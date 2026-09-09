#!/usr/bin/env bash
#
# story-markers.sh — List tests that declare no user story, and therefore appear in no record.
#
#                    A test declares the story it belongs to with @pytest.mark.story("US###"),
#                    inheritable from its class or module via pytestmark; a Bruno request
#                    declares the same value in its meta block as tags: [US###]. That marker is
#                    what code/src/scripts/tests/test-record.sh selects on when it writes a
#                    story's automated test record into project-management/src/18-TESTS/.
#
# THIS WARNS AND EXITS 0, ALWAYS. It is not a gate and must not become one without a decision:
# failing on an unmarked test would block every shared helper and all the tests that predate the
# convention, which is a cure worse than the disease for a marker whose only job is a record.
#
# WHICH MAKES THE FAILURE MODE QUIET, AND THAT IS THE POINT OF THIS SCRIPT. Selection by marker
# means an unmarked test is ABSENT from the record rather than failing it — so a short table is
# ambiguous between "this story has few tests" and "this story's tests carry no marker", and the
# two look identical to a reader. Run this before trusting a short table. A record that omits
# half a story's tests while reporting the other half green is worse than no record
# (code/docs/GATE-REPORTING.md — could-not-look is never reported as looked-and-clean).
#
# Usage: story-markers.sh [--output FORMAT] [--output-file PATH] [--path PATH] [--quiet] [--help]
#
#   --output FORMAT    text (default) or json
#   --output-file PATH Write the report to PATH instead of the reports directory
#   --path PATH        Narrow the scan to a repo-relative path
#   --quiet            Suppress progress output
#
# Scope scanned:  every test_*.py under code/src/django/ and every *.bru under
#                 code/src/tests/api/. conftest.py and the Bruno template outside api/ are
#                 excluded — neither is a test.
#
# Exit codes:  0 = always, whether or not anything is unmarked   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$SCRIPT_DIR/reports"

OUTPUT_FORMAT="text"
OUTPUT_FILE=""
TARGET_PATH=""
QUIET=false

die() { printf 'story-markers.sh error: %s\n' "$*" >&2; exit 2; }
log() { $QUIET || printf '%s\n' "$*"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) sed -n '3,32p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    --output) [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --path) [[ $# -ge 2 ]] || die "--path needs a path"; TARGET_PATH="$2"; shift 2 ;;
    --quiet) QUIET=true; shift ;;
    *) die "unknown option: $1" ;;
  esac
done

case "$OUTPUT_FORMAT" in text|json) ;; *) die "unknown output format: $OUTPUT_FORMAT" ;; esac
command -v python3 >/dev/null 2>&1 || die "python3 is required and was not found."

[[ -n "$OUTPUT_FILE" ]] || OUTPUT_FILE="$REPORTS_DIR/story-markers-report.$OUTPUT_FORMAT"
mkdir -p "$(dirname "$OUTPUT_FILE")"

REPORT="$(
  PROJECT_ROOT="$PROJECT_ROOT" TARGET_PATH="$TARGET_PATH" OUTPUT_FORMAT="$OUTPUT_FORMAT" python3 - <<'PY'
"""Find tests carrying no story marker.

Parsed with ast rather than grepped, because the marker is inheritable: a function is covered by
a decorator on itself, by one on its class, or by a module-level pytestmark. A regex sees the
first and misses the other two, which would report a correctly marked file as unmarked and train
a reader to ignore the output.
"""

from __future__ import annotations

import ast
import json
import os
import re
from pathlib import Path

ROOT = Path(os.environ["PROJECT_ROOT"])
TARGET = os.environ["TARGET_PATH"]
FORMAT = os.environ["OUTPUT_FORMAT"]

STORY_RE = re.compile(r"^US\d{3}$")


def in_scope(path: Path) -> bool:
    return not TARGET or str(path.relative_to(ROOT)).startswith(TARGET)


def marker_stories(decorators: list[ast.expr]) -> list[str]:
    """Return the US### values of any pytest.mark.story decorator in this list."""
    found: list[str] = []
    for node in decorators:
        call = node if isinstance(node, ast.Call) else None
        target = call.func if call else node
        if isinstance(target, ast.Attribute) and target.attr == "story":
            for arg in (call.args if call else []):
                if isinstance(arg, ast.Constant) and isinstance(arg.value, str):
                    found.append(arg.value)
    return found


def module_stories(tree: ast.Module) -> list[str]:
    """Stories set for the whole module by a pytestmark assignment."""
    found: list[str] = []
    for node in tree.body:
        if not isinstance(node, ast.Assign):
            continue
        if not any(isinstance(t, ast.Name) and t.id == "pytestmark" for t in node.targets):
            continue
        value = node.value
        elements = value.elts if isinstance(value, (ast.List, ast.Tuple)) else [value]
        found.extend(marker_stories(list(elements)))
    return found


unmarked: list[dict[str, str]] = []
marked = 0
scanned_files = 0
bad_values: list[dict[str, str]] = []

for py in sorted((ROOT / "code" / "src" / "django").rglob("test_*.py")):
    if not in_scope(py):
        continue
    scanned_files += 1
    try:
        tree = ast.parse(py.read_text(encoding="utf-8"))
    except (SyntaxError, OSError):
        continue

    rel = str(py.relative_to(ROOT))
    at_module = module_stories(tree)

    def visit(body: list[ast.stmt], inherited: list[str], prefix: str) -> None:
        global marked
        for node in body:
            if isinstance(node, ast.ClassDef):
                visit(node.body, inherited + marker_stories(node.decorator_list), f"{prefix}{node.name}::")
            elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)) and node.name.startswith("test"):
                stories = inherited + marker_stories(node.decorator_list)
                for value in stories:
                    if not STORY_RE.match(value):
                        bad_values.append({"where": f"{rel}::{prefix}{node.name}", "value": value})
                if stories:
                    marked += 1
                else:
                    unmarked.append({"kind": "pytest", "where": f"{rel}::{prefix}{node.name}"})

    visit(tree.body, at_module, "")

bru_dir = ROOT / "code" / "src" / "tests" / "api"
scanned_bru = 0
for bru in sorted(bru_dir.rglob("*.bru")) if bru_dir.is_dir() else []:
    if not in_scope(bru):
        continue
    scanned_bru += 1
    source = bru.read_text(encoding="utf-8", errors="replace")
    meta = re.search(r"meta\s*\{(.*?)\}", source, re.DOTALL)
    tags = re.search(r"tags\s*:\s*\[(.*?)\]", meta.group(1), re.DOTALL) if meta else None
    values = re.findall(r"US\d{3}", tags.group(1)) if tags else []
    if values:
        marked += 1
    else:
        unmarked.append({"kind": "bruno", "where": str(bru.relative_to(ROOT))})

payload = {
    "scanned": {"python_files": scanned_files, "bru_files": scanned_bru},
    "marked": marked,
    "unmarked": unmarked,
    "malformed": bad_values,
}

if FORMAT == "json":
    print(json.dumps(payload, indent=2))
    raise SystemExit(0)

lines: list[str] = []
if scanned_files == 0 and scanned_bru == 0:
    scope = f" under {TARGET}" if TARGET else ""
    lines.append(f"No tests found{scope} — nothing of this kind here, rather than nothing wrong.")
else:
    lines.append(f"Scanned {scanned_files} test module(s) and {scanned_bru} Bruno request(s).")
    lines.append(f"{marked} carry a story marker; {len(unmarked)} do not.")
    if unmarked:
        lines.append("")
        lines.append("Unmarked — absent from every per-story test record:")
        lines.extend(f"  {row['where']}" for row in unmarked)
        lines.append("")
        lines.append("Add @pytest.mark.story(\"US###\") to the test, its class, or its module;")
        lines.append("for a Bruno request add tags: [US###] to its meta block.")
    if bad_values:
        lines.append("")
        lines.append("Malformed story values — expected US followed by three digits:")
        lines.extend(f"  {row['where']} -> {row['value']}" for row in bad_values)

print("\n".join(lines))
PY
)"

printf '%s\n' "$REPORT" > "$OUTPUT_FILE"
log "$REPORT"
log ""
log "story-markers: report written to ${OUTPUT_FILE#"$PROJECT_ROOT"/}"
log "story-markers: warning only — this never fails a build."
exit 0
