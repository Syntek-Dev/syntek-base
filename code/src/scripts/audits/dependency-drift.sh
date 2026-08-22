#!/usr/bin/env bash
#
# dependency-drift.sh — Report the dependency changes a template update would impose.
#
# The sibling orphan audit catches the update that silently loses your files. This catches
# the one that silently changes what your project builds against.
#
# A template release routinely moves dependency floors, toolchain pins and action
# versions. `copier update` applies those to your manifests like any other file change:
# no conflict, no error, update reports success — and the next `uv sync` resolves a
# different graph than the one your tests last passed against. The failure surfaces
# later, somewhere else, looking like your bug.
#
# So this compares what the incoming template DECLARES against what this project
# currently RESOLVES, and splits the result in two:
#
#   BLOCKING       the change forces a different version than the one you have — your
#                  lockfile cannot satisfy the new floor, or a pin moves by enough to
#                  break a build on its own.
#   informational  the declaration moved but your resolved versions already satisfy it.
#                  Nothing has to change.
#
# The split is the whole point. Floors move in nearly every release; blocking on all of
# them would make the override routine within a month, and an override nobody reads is
# worse than no warning at all. This fires only when the update can actually change what
# you build.
#
# For the pins with no lockfile to check against, "enough to break a build on its own":
#
#   Rust toolchain channel   a MINOR move — Rust has one major, so its minor is the real
#                            one, and new clippy lints arrive denied
#   uv                       a MINOR move — 0.x, so minor is where breakage lives
#   pnpm · Node · Python     a MAJOR move
#   GitHub Action refs       a MAJOR move, or any move off a branch ref onto a release
#
# Read-only. It changes nothing and is safe to run at any time.
#
# THERE IS NO --path, and that is deliberate: this answers a whole-repository question no
# subdirectory can restrict, so the flag is refused at the parser like doctrine-drift.sh's
# and security.sh's. The two scope arguments below are the scope.
#
# EVERY RUN PRINTS ITS DENOMINATOR — the manifests actually read on each side. Without it
# a scratch tree holding nothing and a scratch tree declaring exactly what you have both
# printed "No dependency drift" at exit 0, which is a result in one case and the absence of
# one in the other. A side that read nothing exits 2: it is a BAD ARGUMENT, not an absent
# surface — the ruling and its two supports are written at the refusal itself, beside the
# code that acts on them (code/docs/GATE-REPORTING.md Section 5).
#
# Usage: dependency-drift.sh --incoming DIR [--project DIR] [--output FORMAT]
#                            [--output-file PATH] [--quiet] [--help]
#
#   --incoming DIR   The updated tree to compare FROM — normally the scratch copy
#                    `template-update.sh` has already run the update against.
#   --project DIR    The tree to compare TO (default: this repository root).
#
# Exit codes:  0 = no blocking drift   1 = blocking drift found
#              2 = script error — bad arguments, a directory holding no manifest among them
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

INCOMING=""
PROJECT="$PROJECT_ROOT"
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false

die() {
  printf 'dependency-drift.sh error: %s\n' "$*" >&2
  exit 2
}

usage() {
  cat <<'USAGE'
dependency-drift.sh — report the dependency changes a template update would impose

Usage:
  dependency-drift.sh --incoming DIR [--project DIR] [options]

Required:
  --incoming DIR      The updated tree to compare from (a scratch copy the update ran against)

Options:
  --project DIR       The tree to compare to (default: this repository root)
  --output FORMAT     Write a report: md | txt
  --output-file PATH  Override the report path
                        (default: code/src/scripts/audits/reports/dependency-drift.<FORMAT>)
  --quiet             Suppress terminal output — requires --output
  --help              Show this help

Both directories must exist AND hold at least one manifest this reads. Read from BOTH sides:
pyproject.toml, package.json, code/src/rust/Cargo.toml, code/src/rust/crates/*/Cargo.toml,
rust-toolchain.toml, .github/workflows/*.yml. Read from the PROJECT side only, being
resolved state rather than a declaration: uv.lock and code/src/rust/Cargo.lock.
A tree holding none of them is a bad argument, not a clean run:
every run prints what it read on each side, so a clean verdict can be traced to a file.

There is no --path. This compares two whole trees, and no subdirectory restricts that.

Exit codes:  0 = no blocking drift   1 = blocking drift found
             2 = script error — bad arguments, a directory holding no manifest among them
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --incoming) INCOMING="${2:-}"; shift 2 ;;
    --project) PROJECT="${2:-}"; shift 2 ;;
    --output) OUTPUT_FORMAT="${2:-}"; shift 2 ;;
    --output-file) OUTPUT_FILE="${2:-}"; shift 2 ;;
    --quiet) QUIET=true; shift ;;
    --help) usage; exit 0 ;;
    *) die "Unknown option: $1. Use --help for usage." ;;
  esac
done

[[ -n "$INCOMING" ]] || die "--incoming is required. Use --help for usage."
[[ -d "$INCOMING" ]] || die "--incoming is not a directory: $INCOMING"
[[ -d "$PROJECT" ]] || die "--project is not a directory: $PROJECT"
if $QUIET && [[ -z "$OUTPUT_FORMAT" ]]; then
  die "--quiet requires --output."
fi
if [[ -n "$OUTPUT_FORMAT" && "$OUTPUT_FORMAT" != "md" && "$OUTPUT_FORMAT" != "txt" ]]; then
  die "Unknown --output format: $OUTPUT_FORMAT (md | txt)"
fi
command -v python3 >/dev/null 2>&1 || die "python3 is required and was not found."

set +e
DRIFT_OUT="$(INCOMING="$INCOMING" PROJECT="$PROJECT" python3 - <<'PY'
import json, os, re, sys
import tomllib
from pathlib import Path

INC = Path(os.environ["INCOMING"])
PRJ = Path(os.environ["PROJECT"])

blocking: list[tuple[str, str]] = []
info: list[tuple[str, str]] = []


def vt(s):
    """Version string -> comparable 3-tuple. Non-numeric refs sort as (-1,)."""
    nums = re.findall(r"\d+", s or "")
    if not nums:
        return (-1, 0, 0)
    t = tuple(int(n) for n in nums[:3])
    return t + (0,) * (3 - len(t))


# WHAT WAS ACTUALLY OPENED, per side. This is the denominator, and it is the whole
# difference between "the two trees declare the same versions" and "neither tree declared
# anything": both reach an empty result set, and without a count both printed
# "No dependency drift — the incoming template declares what you already have." A directory
# holding no manifest could not have produced a finding, which is the zero-population
# scoping fault of code/docs/GATE-REPORTING.md Section 5 — not the absent-surface row that
# earns a clean exit 0. Recorded at the point of reading rather than re-derived afterwards,
# so a manifest that exists but does not parse counts as unread, which it is.
inc_read: list[str] = []
prj_read: list[str] = []


def toml_at(p, store=None, label=None):
    try:
        with open(p, "rb") as fh:
            doc = tomllib.load(fh)
    except Exception:
        return None
    if store is not None:
        store.append(label or p.name)
    return doc


def json_at(p, store=None, label=None):
    try:
        with open(p) as fh:
            doc = json.load(fh)
    except Exception:
        return None
    if store is not None:
        store.append(label or p.name)
    return doc


SPEC = re.compile(r"^\s*([A-Za-z0-9._-]+)\s*(?:\[[^\]]*\])?\s*(?:>=|==|~=)\s*([0-9][0-9A-Za-z.\-]*)")


def py_floors(doc):
    out = {}
    if not doc:
        return out

    def add(lst):
        for d in lst or []:
            if isinstance(d, str):
                m = SPEC.match(d)
                if m:
                    out[m.group(1).lower()] = m.group(2)

    add((doc.get("project") or {}).get("dependencies"))
    for grp in (doc.get("dependency-groups") or {}).values():
        add(grp)
    return out


# ── Python ────────────────────────────────────────────────────────────────────
inc_py = py_floors(toml_at(INC / "pyproject.toml", inc_read))
prj_py = py_floors(toml_at(PRJ / "pyproject.toml", prj_read))
lock = toml_at(PRJ / "uv.lock", prj_read)
locked = {}
if lock:
    for p in lock.get("package", []) or []:
        locked[str(p.get("name", "")).lower()] = p.get("version", "")

for name, floor in sorted(inc_py.items()):
    was = prj_py.get(name)
    if was == floor:
        continue
    have = locked.get(name)
    line = f"{name}  {was or '(undeclared)'} -> >={floor}"
    if have and vt(have) < vt(floor):
        blocking.append(("python", f"{line}   you have {have} locked"))
    elif have:
        info.append(("python", f"{line}   you have {have}, already satisfies it"))
    elif lock is not None:
        info.append(("python", line))
    else:
        info.append(("python", f"{line}   (no uv.lock to check against)"))

# ── JavaScript ────────────────────────────────────────────────────────────────
inc_js = json_at(INC / "package.json", inc_read) or {}
prj_js = json_at(PRJ / "package.json", prj_read) or {}
for key in ("dependencies", "devDependencies"):
    a, b = inc_js.get(key) or {}, prj_js.get(key) or {}
    for name, spec in sorted(a.items()):
        was = b.get(name)
        if was == spec:
            continue
        line = f"{name}  {was or '(absent)'} -> {spec}"
        if was and vt(spec)[0] != vt(was)[0]:
            blocking.append(("javascript", f"{line}   major move"))
        else:
            info.append(("javascript", line))

for label, key in (("pnpm", "packageManager"),):
    a, b = inc_js.get(key), prj_js.get(key)
    if a and b and a != b:
        line = f"{label}  {b} -> {a}"
        (blocking if vt(a)[0] != vt(b)[0] else info).append(("toolchain", line))

# ── Rust ──────────────────────────────────────────────────────────────────────
def cargo_specs(root, store):
    out = {}
    ws = toml_at(root / "code/src/rust/Cargo.toml", store, "rust/Cargo.toml")
    sources = []
    if ws:
        sources.append((ws.get("workspace") or {}).get("dependencies") or {})
    for man in sorted((root / "code/src/rust/crates").glob("*/Cargo.toml")) if (
        root / "code/src/rust/crates"
    ).is_dir() else []:
        doc = toml_at(man, store, f"rust/crates/{man.parent.name}/Cargo.toml")
        if doc:
            sources.append(doc.get("dependencies") or {})
            sources.append(doc.get("build-dependencies") or {})
    for table in sources:
        for name, val in table.items():
            if isinstance(val, str):
                out[name] = val
            elif isinstance(val, dict) and "version" in val:
                out[name] = val["version"]
    return out


# Surface-gated. A project generated without INCLUDE_RUST has no rust tree, and Copier
# never applies one — so every crate the template declares would report as "absent",
# which is noise about a surface this project does not have. Same for the desktop crate
# inside it, and the same reasoning would apply to mobile if it declared its own pins.
RUST_HERE = (PRJ / "code/src/rust").is_dir()
inc_rs = cargo_specs(INC, inc_read) if RUST_HERE else {}
prj_rs = cargo_specs(PRJ, prj_read) if RUST_HERE else {}
rs_lock = toml_at(PRJ / "code/src/rust/Cargo.lock", prj_read, "rust/Cargo.lock")
rs_locked = {}
if rs_lock:
    for p in rs_lock.get("package", []) or []:
        rs_locked[p.get("name", "")] = p.get("version", "")

for name, spec in sorted(inc_rs.items()):
    was = prj_rs.get(name)
    if was == spec:
        continue
    have = rs_locked.get(name)
    line = f"{name}  {was or '(absent)'} -> {spec}"
    if have and vt(have) < vt(spec):
        blocking.append(("rust", f"{line}   you have {have} locked"))
    else:
        info.append(("rust", line + (f"   you have {have}" if have else "")))

inc_tc = toml_at(INC / "code/src/rust/rust-toolchain.toml", inc_read) if RUST_HERE else None
prj_tc = toml_at(PRJ / "code/src/rust/rust-toolchain.toml", prj_read) if RUST_HERE else None
if inc_tc and prj_tc:
    a = ((inc_tc.get("toolchain") or {}).get("channel")) or ""
    b = ((prj_tc.get("toolchain") or {}).get("channel")) or ""
    if a and b and a != b:
        line = f"rust toolchain  {b} -> {a}"
        # Rust has one major, so its MINOR is the significant move.
        (blocking if vt(a)[:2] != vt(b)[:2] else info).append(("toolchain", line))

# ── CI: action refs and tool pins ─────────────────────────────────────────────
USES = re.compile(r"uses:\s*([A-Za-z0-9._/-]+)@([A-Za-z0-9._-]+)")
ENVP = re.compile(r"^\s*(UV_VERSION|NODE_VERSION|PYTHON_VERSION):\s*\"?([0-9][0-9A-Za-z.\-]*)\"?", re.M)


def ci_facts(root, store):
    acts, envs = {}, {}
    wf = root / ".github/workflows"
    if not wf.is_dir():
        return acts, envs
    read = 0
    for f in sorted(wf.glob("*.yml")):
        try:
            text = f.read_text()
        except Exception:
            continue
        read += 1
        for repo, ref in USES.findall(text):
            acts[repo] = ref
        for key, val in ENVP.findall(text):
            envs[key] = val
    if read:
        store.append(f".github/workflows/*.yml ({read})")
    return acts, envs


inc_a, inc_e = ci_facts(INC, inc_read)
prj_a, prj_e = ci_facts(PRJ, prj_read)

for repo, ref in sorted(inc_a.items()):
    was = prj_a.get(repo)
    if was is None or was == ref:
        continue
    line = f"{repo}  {was} -> {ref}"
    moved_off_branch = vt(was) == (-1, 0, 0)
    if moved_off_branch or vt(ref)[0] != vt(was)[0]:
        blocking.append(("ci", f"{line}   {'was a branch ref' if moved_off_branch else 'major move'}"))
    else:
        info.append(("ci", line))

for key, val in sorted(inc_e.items()):
    was = prj_e.get(key)
    if was is None or was == val:
        continue
    line = f"{key}  {was} -> {val}"
    # uv is 0.x — its minor is the significant move. The rest go on major.
    sig = vt(val)[:2] != vt(was)[:2] if key == "UV_VERSION" else vt(val)[0] != vt(was)[0]
    (blocking if sig else info).append(("toolchain", line))

# ── Report ────────────────────────────────────────────────────────────────────
# The two sides are NOT searched for the same set, and one list saying otherwise reports an
# incoming tree against files it was never asked for. The lockfiles are resolved state, so
# only the project side is read for them — `uv.lock` and `code/src/rust/Cargo.lock` are both
# read from PRJ alone. Everything else is read from both.
LOOKED_FOR_BOTH = (
    "pyproject.toml, package.json, code/src/rust/Cargo.toml, "
    "code/src/rust/crates/*/Cargo.toml, code/src/rust/rust-toolchain.toml, "
    ".github/workflows/*.yml"
)
LOOKED_FOR_PROJECT_ONLY = "uv.lock, code/src/rust/Cargo.lock"


def scope_lines():
    """The denominator, printed on every path — including the ones that found nothing."""
    return [
        f"  incoming  {INC}",
        "            read: " + (", ".join(inc_read) if inc_read else "nothing"),
        f"  project   {PRJ}",
        "            read: " + (", ".join(prj_read) if prj_read else "nothing"),
        "",
    ]


# A side that read nothing cannot have produced a finding, so its empty result is not
# agreement — there was nothing to agree with. Both directories exist by here (the caller
# checked), which is exactly why this is a separate refusal: a real directory holding no
# manifest is the case that reached "No dependency drift" at exit 0 and was believed.
#
# RULED, BECAUSE IT LOOKS LIKE AN ABSENT SURFACE AND IS NOT ONE. GATE-REPORTING Section 2's
# absent-surface row buys a clean exit 0 for a population that is LEGITIMATELY empty — and
# this script already honours it, one level down: RUST_HERE gates the whole Cargo leg off, so
# a web-only project hears nothing about crates and hears it at exit 0. That is the row, done
# correctly, inside the run. A whole SIDE holding none of the manifests LOOKED_FOR names is a
# different animal: --incoming's contract is a rendered project tree, and every rendered tree
# carries pyproject.toml — copier.yml neither excludes it nor gates it, and a post-task
# rewrites its [project] name — so a directory without it is not an empty instance of the
# thing the flag names. Section 5 is the row that fits — "it looked in a place that
# could not contain the thing, and reported success ... a scoping fault. Fix the search" —
# and the search is fixed by the caller passing a different directory, which is what a bad
# argument means.
#
# Two supports, both checked rather than assumed. The exit-0 self-guard exists so an audit can
# run unconditionally in CI with no step-level guard (audits/CLAUDE.md); this one cannot —
# it dies without --incoming, .claude/hooks/lib/check-audits.sh excludes it by name in
# _AUDIT_SKIP, and CONTEXT.md's self-guard register does not list it. And the direction of
# failure: the reader is a human about to apply a `copier update`, template-update.sh treats
# anything above 1 as a stop, so 2 fails closed where 0-with-a-note would wave the update
# through on a comparison that compared nothing.
if not inc_read or not prj_read:
    side = "--incoming" if not inc_read else "--project"
    root = INC if not inc_read else PRJ
    print("\n".join(
        [f"Nothing was compared: {side} {root} holds no dependency manifest this reads.", ""]
        + scope_lines()
        + [
            f"  Looked for on both sides: {LOOKED_FOR_BOTH}",
            f"  Project side only:        {LOOKED_FOR_PROJECT_ONLY}",
            "",
            "  An empty result is not agreement here — nothing was read to agree with.",
            f"  Point {side} at a rendered project tree.",
        ]
    ))
    sys.exit(2)

out = scope_lines()
if blocking:
    out.append("── Dependency changes that WILL change what you build ──")
    out.append("")
    for area, line in blocking:
        out.append(f"  [{area}] {line}")
    out.append("")
    out.append("  These do not conflict and will not fail. Your manifests simply change,")
    out.append("  and the next resolve picks versions your suites have never run against.")
    out.append("")
    out.append("  Before you commit the update: re-resolve, then run the suites.")
    out.append("    bash code/src/scripts/dependencies/update.sh --check")
    out.append("    bash code/src/scripts/tests/all.sh")
    out.append("")

if info:
    out.append("── Declarations that moved, but your versions already satisfy ──")
    out.append("")
    for area, line in info:
        out.append(f"  [{area}] {line}")
    out.append("")

if not blocking and not info:
    # Earned, not assumed: the two scope lines above say what was read to earn it.
    out.append("No dependency drift — the incoming template declares what you already have.")

print("\n".join(out))
sys.exit(1 if blocking else 0)
PY
)"
STATUS=$?
set -e

if [[ $STATUS -gt 1 ]]; then
  # The comparison's own refusal — a scope it could not answer over — and the reason is on
  # its stdout, which nothing has printed yet. Print it here, to stderr so --quiet does not
  # swallow it: "see the output above" over an empty terminal is itself a false claim, and
  # a die telling the reader to consult nothing is how a bad argument reads as a crash.
  printf '%s\n' "$DRIFT_OUT" >&2
  die "the comparison could not run over the scope it was given."
fi

$QUIET || printf '%s\n' "$DRIFT_OUT"

if [[ -n "$OUTPUT_FORMAT" ]]; then
  REPORT="${OUTPUT_FILE:-$REPORTS_DIR/dependency-drift.$OUTPUT_FORMAT}"
  mkdir -p "$(dirname "$REPORT")"
  printf '%s\n' "$DRIFT_OUT" >"$REPORT"
  $QUIET || printf 'Report: %s\n' "$REPORT"
fi

exit $STATUS
