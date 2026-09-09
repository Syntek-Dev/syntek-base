#!/usr/bin/env bash
#
# test-record.sh — Write the generated block of a story's automated test record.
#
#                  Reads what the suites already produced and rewrites the region between
#                  <!-- BEGIN GENERATED: test-record --> and <!-- END GENERATED --> in
#                  project-management/src/18-TESTS/US###-TEST-STATUS.md. Nothing outside those
#                  markers is touched.
#
# WHY THIS IS NOT A FLAG ON A RUNNER. The suites carry an exit-code contract three CI workflows
# depend on — 0 pass, 1 failure, 2 script error, never masked. A doc-writing flag on all.sh would
# either couple the record to a green run, which is exactly when it is least needed, or blur that
# contract. Kept separate, this reads whatever is on disk: after a partial run, after a red run,
# or twice without re-running anything.
#
# WHY A STORY MARKER AND NOT A PATH OR A DIFF. A JUnit <testcase> carries classname and name and
# nothing that names a story. The attribution cannot be inferred either: a path breaks the moment
# a story spans two apps, and a branch diff misses every test a later fix touches. So a test
# declares its own story — @pytest.mark.story("US###") for pytest, read at collection into
# reports/story-map.json by code/src/django/conftest.py, and meta tags for Bruno, read from the
# .bru source so one whole-collection run still feeds every story's record.
#
# THE SHORT-TABLE TRAP. Selection is by marker, so a test written for this story WITHOUT one is
# absent rather than failing. That is a deliberate trade — a hard gate would block every shared
# helper and every test predating the convention — and it means a short table is ambiguous
# between "few tests" and "few markers". Run audits/story-markers.sh before trusting one.
#
# THIS SCRIPT WRITES OUTSIDE code/. It is the only script under scripts/tests/ that does; every
# sibling writes only into the gitignored reports/. Said plainly because a reader assumes
# otherwise.
#
# Usage: test-record.sh US### [OPTIONS]
#
#   --reports DIR      Read report artefacts from DIR   (default: scripts/tests/reports)
#   --record PATH      Write to PATH instead of the conventional US###-TEST-STATUS.md
#   --dry-run          Print the generated block to stdout; write nothing
#   --quiet            Suppress progress output
#   --help             This message
#
# Reads, each optional — an absent artefact is reported as absent, never as a clean zero:
#   <reports>/story-map.json                        story attribution + docstrings (pytest)
#   <reports>/backend-coverage/results-*.xml        unit + integration JUnit  (or backend/)
#   <reports>/e2e/results.xml                       browser + accessibility JUnit
#   <reports>/api/results.json                      Bruno API results
#   <reports>/a11y/*.json                           axe violation counts
#   <reports>/backend-coverage/coverage.xml         line + branch coverage
#
# Exit codes:  0 = block written, or printed under --dry-run
#              1 = record missing, markers missing, or no report artefacts to read
#              2 = script error (bad argument, python3 absent)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

STORY=""
REPORTS_DIR="$SCRIPT_DIR/reports"
RECORD_PATH=""
DRY_RUN=false
QUIET=false

die() { printf 'test-record.sh error: %s\n' "$*" >&2; exit 2; }
fail() { printf 'test-record.sh: %s\n' "$*" >&2; exit 1; }
log() { $QUIET || printf '[test-record] %s\n' "$*"; }

usage() { sed -n '3,40p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage; exit 0 ;;
    --reports) [[ $# -ge 2 ]] || die "--reports needs a directory"; REPORTS_DIR="$2"; shift 2 ;;
    --record)  [[ $# -ge 2 ]] || die "--record needs a path";      RECORD_PATH="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --quiet)   QUIET=true; shift ;;
    -*)        die "unknown option: $1" ;;
    *)         [[ -z "$STORY" ]] || die "only one story may be given (got '$STORY' and '$1')"
               STORY="$1"; shift ;;
  esac
done

[[ -n "$STORY" ]] || die "a story is required, e.g. test-record.sh US008"
[[ "$STORY" =~ ^US[0-9]{3}$ ]] || die "story must be US followed by three digits, got '$STORY'"
command -v python3 >/dev/null 2>&1 || die "python3 is required and was not found."

[[ -n "$RECORD_PATH" ]] || \
  RECORD_PATH="$PROJECT_ROOT/project-management/src/18-TESTS/${STORY}-TEST-STATUS.md"

if [[ ! -d "$REPORTS_DIR" ]]; then
  fail "no report artefacts at $REPORTS_DIR — run a suite first (see tests/CONTEXT.md). Nothing was written."
fi

if ! $DRY_RUN && [[ ! -f "$RECORD_PATH" ]]; then
  fail "$RECORD_PATH does not exist — copy US000-TEST-STATUS.md to it first. Nothing was written."
fi

log "story $STORY · reports $REPORTS_DIR"

STORY="$STORY" REPORTS_DIR="$REPORTS_DIR" RECORD_PATH="$RECORD_PATH" \
DRY_RUN="$DRY_RUN" PROJECT_ROOT="$PROJECT_ROOT" QUIET="$QUIET" python3 - <<'PY'
"""Build the generated block and splice it into the record.

Every table here is derived from an artefact a suite wrote. Where an artefact is absent the
suite is omitted from the rollup and named in the notes underneath, because a missing row and a
zero are different claims (code/docs/GATE-REPORTING.md).
"""

from __future__ import annotations

import glob
import json
import os
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

STORY = os.environ["STORY"]
REPORTS = Path(os.environ["REPORTS_DIR"])
RECORD = Path(os.environ["RECORD_PATH"])
DRY_RUN = os.environ["DRY_RUN"] == "true"
QUIET = os.environ["QUIET"] == "true"
ROOT = Path(os.environ["PROJECT_ROOT"])

BEGIN = "<!-- BEGIN GENERATED: test-record -->"
END = "<!-- END GENERATED -->"


def note(message: str) -> None:
    if not QUIET:
        print(f"[test-record] {message}")


def humanise(name: str) -> str:
    """Turn a test's own name into the behaviour it checks.

    The names in this project already read as prose — test_is_never_cached,
    test_rejects_a_write_method — so the transform is mechanical: drop the prefix, restore the
    spaces, and hold a parametrised id apart as the case it covers.
    """
    base, open_bracket, params = name.partition("[")
    text = re.sub(r"^test_", "", base).replace("_", " ").strip()
    text = (text[:1].upper() + text[1:]) if text else base
    if open_bracket:
        text += " — " + params.rstrip("]").replace("-", " / ")
    return text


# ---------------------------------------------------------------- story attribution (pytest)

story_map: dict[tuple[str, str], dict] = {}
story_map_path = REPORTS / "story-map.json"
if story_map_path.is_file():
    for entry in json.loads(story_map_path.read_text(encoding="utf-8")):
        if STORY in entry.get("stories", []):
            story_map[(entry["classname"], entry["name"])] = entry
else:
    note("no story-map.json — pytest suites cannot be attributed to a story; run a backend suite first")


# ---------------------------------------------------------------- JUnit XML suites

def read_junit(path: Path) -> list[dict]:
    cases = []
    try:
        tree = ET.parse(path)
    except (ET.ParseError, OSError):
        note(f"could not read {path} — skipped")
        return cases
    for case in tree.iter("testcase"):
        classname = case.get("classname", "")
        name = case.get("name", "")
        if (classname, name) not in story_map:
            continue
        failure = case.find("failure")
        error = case.find("error")
        skipped = case.find("skipped")
        broken = failure if failure is not None else error
        cases.append(
            {
                "classname": classname,
                "name": name,
                "docstring": story_map[(classname, name)].get("docstring", ""),
                "result": "Skipped" if skipped is not None else ("Fail" if broken is not None else "Pass"),
                "notes": ((broken.get("message") or "").strip().splitlines() or [""])[0] if broken is not None else "",
            }
        )
    return cases


def first_existing(*candidates: str) -> Path | None:
    for candidate in candidates:
        path = REPORTS / candidate
        if path.is_file():
            return path
    return None


SUITES = [
    ("Unit", first_existing("backend-coverage/results-unit.xml", "backend/results-unit.xml")),
    ("Integration", first_existing("backend-coverage/results-integration.xml", "backend/results-integration.xml")),
    ("E2E and accessibility", first_existing("e2e/results.xml")),
]

collected: list[tuple[str, Path, list[dict]]] = []
absent: list[str] = []
for label, path in SUITES:
    if path is None:
        absent.append(label)
        continue
    collected.append((label, path, read_junit(path)))


# ---------------------------------------------------------------- Bruno

def read_bruno() -> tuple[Path | None, list[dict]]:
    path = REPORTS / "api" / "results.json"
    if not path.is_file():
        return None, []
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError):
        note(f"could not read {path} — skipped")
        return path, []

    tagged: set[str] = set()
    for bru in glob.glob(str(ROOT / "code" / "src" / "tests" / "api" / "**" / "*.bru"), recursive=True):
        source = Path(bru).read_text(encoding="utf-8", errors="replace")
        meta = re.search(r"meta\s*\{(.*?)\}", source, re.DOTALL)
        if meta and re.search(rf"\b{re.escape(STORY)}\b", meta.group(1)):
            tagged.add(str(Path(bru).relative_to(ROOT / "code" / "src" / "tests" / "api")))

    if not tagged:
        return path, []

    rows: list[dict] = []
    iterations = payload if isinstance(payload, list) else [payload]
    for iteration in iterations:
        for result in iteration.get("results", []):
            filename = (result.get("test") or {}).get("filename", "")
            if filename not in tagged:
                continue
            for assertion in (result.get("assertionResults") or []) + (result.get("testResults") or []):
                status = str(assertion.get("status", "")).lower()
                rows.append(
                    {
                        "classname": filename,
                        "name": assertion.get("description") or assertion.get("lhsExpr") or "assertion",
                        "docstring": "",
                        "result": "Pass" if status == "pass" else "Fail",
                        "notes": (assertion.get("error") or "") if status != "pass" else "",
                    }
                )
    return path, rows


bruno_path, bruno_rows = read_bruno()
if bruno_path is None:
    absent.append("API (Bruno)")


# ---------------------------------------------------------------- axe violation counts

a11y_files = sorted(glob.glob(str(REPORTS / "a11y" / "*.json")))
a11y_counts: dict[str, int] = {}
for a11y_file in a11y_files:
    try:
        payload = json.loads(Path(a11y_file).read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError):
        continue
    violations = payload.get("violations")
    a11y_counts[Path(a11y_file).stem] = len(violations) if isinstance(violations, list) else 0


# ---------------------------------------------------------------- coverage

def read_coverage() -> tuple[Path | None, float | None, float | None, list[tuple[str, str, str, str, str]]]:
    path = REPORTS / "backend-coverage" / "coverage.xml"
    if not path.is_file():
        return None, None, None, []
    try:
        tree = ET.parse(path)
    except (ET.ParseError, OSError):
        note(f"could not read {path} — coverage omitted")
        return path, None, None, []
    root = tree.getroot()

    def pct(value: str | None) -> float | None:
        try:
            return round(float(value) * 100, 1) if value is not None else None
        except ValueError:
            return None

    modules: list[tuple[str, str, str, str, str]] = []
    for cls in root.iter("class"):
        lines = list(cls.iter("line"))
        if not lines:
            continue
        missed = sum(1 for line in lines if line.get("hits") == "0")
        modules.append(
            (
                cls.get("filename", ""),
                str(len(lines)),
                str(missed),
                f"{pct(cls.get('branch-rate'))}%" if pct(cls.get("branch-rate")) is not None else "—",
                f"{pct(cls.get('line-rate'))}%" if pct(cls.get("line-rate")) is not None else "—",
            )
        )
    modules.sort(key=lambda row: row[0])
    return path, pct(root.get("line-rate")), pct(root.get("branch-rate")), modules


coverage_path, line_rate, branch_rate, coverage_modules = read_coverage()


def line_floor() -> int:
    """Read the line floor from pyproject rather than carrying a second copy of it.

    code/docs/testing/COVERAGE.md owns the floors and pyproject implements the machine-readable
    one. A literal here would be a third statement of the same number, and the one nobody
    remembers to move.
    """
    pyproject = ROOT / "pyproject.toml"
    try:
        match = re.search(r"^fail_under\s*=\s*(\d+)", pyproject.read_text(encoding="utf-8"), re.M)
    except OSError:
        return 75
    return int(match.group(1)) if match else 75


FLOOR = line_floor()


# ---------------------------------------------------------------- render

def escape(text: str) -> str:
    return text.replace("|", "\\|").replace("\n", " ").strip()


out: list[str] = [BEGIN, ""]

out += ["### 1.1 Suite summary", ""]
out += ["| Suite | Report artefact | Tests | Result | Coverage |",
        "| ----- | --------------- | ----- | ------ | -------- |"]

total = passed = failed = 0
rollup = [(label, path, rows) for label, path, rows in collected if rows]
for label, path, rows in rollup:
    p = sum(1 for row in rows if row["result"] == "Pass")
    f = sum(1 for row in rows if row["result"] == "Fail")
    total += len(rows)
    passed += p
    failed += f
    cover = f"{line_rate}%" if label in {"Unit", "Integration"} and line_rate is not None else "—"
    out.append(f"| {label} | `{path.relative_to(REPORTS)}` | {len(rows)} | {p} Pass / {f} Fail | {cover} |")

if bruno_rows and bruno_path is not None:
    p = sum(1 for row in bruno_rows if row["result"] == "Pass")
    f = sum(1 for row in bruno_rows if row["result"] == "Fail")
    total += len(bruno_rows)
    passed += p
    failed += f
    out.append(f"| API (Bruno) | `{bruno_path.relative_to(REPORTS)}` | {len(bruno_rows)} | {p} Pass / {f} Fail | — |")

if a11y_counts:
    violations = sum(a11y_counts.values())
    out.append(f"| Accessibility (axe) | `a11y/*.json` | {len(a11y_counts)} pages | {violations} violations | — |")

out.append(f"| **Totals** | | **{total}** | **{passed} Pass / {failed} Fail** | "
           f"**{line_rate}%** |" if line_rate is not None else
           f"| **Totals** | | **{total}** | **{passed} Pass / {failed} Fail** | **—** |")
out.append("")

if absent:
    out += [f"_Not run, or produced no artefact: {', '.join(absent)}. An absent suite is not a"
            f" zero — say why in Section 3._", ""]
if not story_map and not bruno_rows:
    out += [f"_No test declares `{STORY}`. Either none has been written yet, or the marker is"
            f" missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._", ""]

out += ["### 1.2 Coverage vs floors", ""]
if line_rate is None:
    out += ["_No `coverage.xml` — run `backend-coverage.sh` rather than `backend.sh` to produce one._", ""]
else:
    out += ["| Scope | Floor | This story | Met? |",
            "| ----- | ----- | ---------- | ---- |",
            f"| All modules — line + branch | {FLOOR}% | {line_rate}% line / {branch_rate}% branch | "
            f"{'Yes' if line_rate >= FLOOR else 'No'} |",
            "| Auth-critical modules | 90% | _{state the modules in scope and their figures}_ | _{}_ |",
            "",
            "_The line floor above is read from `pyproject.toml`; the 90% auth floor is not"
            " machine-readable and is stated by `code/docs/testing/COVERAGE.md`, which owns both."
            " The auth-critical row is not derivable either — which modules sit in the"
            " authentication, session and permission path is a judgement. Name them and read their"
            " figures from the per-module table below._",
            ""]
    if coverage_modules:
        out += ["| Module | Statements | Missed | Branch | Cover |",
                "| ------ | ---------- | ------ | ------ | ----- |"]
        out += [f"| `{escape(m[0])}` | {m[1]} | {m[2]} | {m[3]} | {m[4]} |" for m in coverage_modules]
        out.append("")

out += ["### 1.3 Tests by module", ""]

grouped: dict[str, dict[str, list[dict]]] = {}
for _, _, rows in collected:
    for row in rows:
        parts = row["classname"].rsplit(".", 1)
        module, cls = (parts[0], parts[1]) if len(parts) == 2 and parts[1][:1].isupper() else (row["classname"], "")
        grouped.setdefault(module, {}).setdefault(cls, []).append(row)

if not grouped and not bruno_rows:
    out += [f"_No attributed tests to list for {STORY}._", ""]

for module in sorted(grouped):
    out += [f"#### `{module}`", ""]
    for cls in sorted(grouped[module]):
        if cls:
            out += [f"##### `{cls}`", ""]
        out += ["| What it checks | Why | Test | Result | Notes |",
                "| -------------- | --- | ---- | ------ | ----- |"]
        for row in sorted(grouped[module][cls], key=lambda r: r["name"]):
            out.append(
                f"| {escape(humanise(row['name']))} | {escape(row['docstring'])} | "
                f"`{escape(row['name'])}` | {row['result']} | {escape(row['notes'])} |"
            )
        out.append("")

if bruno_rows:
    out += ["#### API requests (Bruno)", ""]
    by_file: dict[str, list[dict]] = {}
    for row in bruno_rows:
        by_file.setdefault(row["classname"], []).append(row)
    for filename in sorted(by_file):
        out += [f"##### `{filename}`", "",
                "| What it checks | Why | Test | Result | Notes |",
                "| -------------- | --- | ---- | ------ | ----- |"]
        for row in by_file[filename]:
            out.append(f"| {escape(row['name'])} |  | `{escape(filename)}` | {row['result']} | {escape(row['notes'])} |")
        out.append("")

if a11y_counts:
    out += ["#### Accessibility scans (axe)", "",
            "| Page and project | Why | Test | Result | Notes |",
            "| ---------------- | --- | ---- | ------ | ----- |"]
    for slug in sorted(a11y_counts):
        count = a11y_counts[slug]
        out.append(f"| `{escape(slug)}` | Critical and serious violations fail the gate | "
                   f"`test_a11y_scan` | {'Pass' if count == 0 else 'Fail'} | "
                   f"{'' if count == 0 else f'{count} violations'} |")
    out.append("")

out.append(END)


def align_tables(lines: list[str]) -> list[str]:
    """Pad every table cell to its column width, the way Prettier writes a Markdown table.

    project-management/src/** is both linted and formatted, so a record whose generated block
    carried compact tables would fail markdownlint MD060 the moment anyone ran the gate — and it
    would fail again after every regeneration, which is the kind of recurring noise that gets a
    gate switched off. Cheaper to emit what the formatter would have written.
    """
    result: list[str] = []
    run: list[list[str]] = []
    run_at = 0

    def flush() -> None:
        if not run:
            return
        widths = [max(len(row[i]) for row in run) for i in range(len(run[0]))]
        for index, row in enumerate(run):
            if index == 1:
                cells = ["-" * max(width, 3) for width in widths]
            else:
                cells = [cell.ljust(width) for cell, width in zip(row, widths)]
            result.append("| " + " | ".join(cells) + " |")
        run.clear()

    for line in lines:
        stripped = line.strip()
        is_row = stripped.startswith("|") and stripped.endswith("|") and len(stripped) > 1
        if is_row:
            cells = [cell.strip() for cell in stripped[1:-1].split("|")]
            if run and len(cells) != len(run[0]):
                flush()
            if not run:
                run_at = len(result)
            run.append(cells)
        else:
            flush()
            result.append(line)
    flush()
    del run_at
    return result


block = "\n".join(align_tables(out))

if DRY_RUN:
    print(block)
    sys.exit(0)

body = RECORD.read_text(encoding="utf-8")
if BEGIN not in body or END not in body:
    print(
        f"test-record.sh: {RECORD} carries no generated block — expected the markers\n"
        f"  {BEGIN}\n  {END}\n"
        "Copy US000-TEST-STATUS.md again rather than pasting them by hand; the surrounding\n"
        "sections changed with them. Nothing was written.",
        file=sys.stderr,
    )
    sys.exit(1)

start = body.index(BEGIN)
finish = body.index(END) + len(END)
RECORD.write_text(body[:start] + block + body[finish:], encoding="utf-8")
try:
    shown = RECORD.relative_to(ROOT)
except ValueError:
    # --record can point anywhere, including outside the repository. Reporting the write is not
    # worth failing it, which is what an unguarded relative_to did here.
    shown = RECORD
note(f"wrote {total} test rows into {shown}")
PY
