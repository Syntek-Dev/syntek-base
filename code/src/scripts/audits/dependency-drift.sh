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
# Usage: dependency-drift.sh --incoming DIR [--project DIR] [--output FORMAT]
#                            [--output-file PATH] [--quiet] [--help]
#
#   --incoming DIR   The updated tree to compare FROM — normally the scratch copy
#                    `template-update.sh` has already run the update against.
#   --project DIR    The tree to compare TO (default: this repository root).
#
# Exit codes:  0 = no blocking drift   1 = blocking drift found   2 = script error
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

Exit codes:  0 = no blocking drift   1 = blocking drift found   2 = script error
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


def toml_at(p):
    try:
        with open(p, "rb") as fh:
            return tomllib.load(fh)
    except Exception:
        return None


def json_at(p):
    try:
        with open(p) as fh:
            return json.load(fh)
    except Exception:
        return None


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
inc_py = py_floors(toml_at(INC / "pyproject.toml"))
prj_py = py_floors(toml_at(PRJ / "pyproject.toml"))
lock = toml_at(PRJ / "uv.lock")
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
inc_js = json_at(INC / "package.json") or {}
prj_js = json_at(PRJ / "package.json") or {}
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
def cargo_specs(root):
    out = {}
    ws = toml_at(root / "code/src/rust/Cargo.toml")
    sources = []
    if ws:
        sources.append((ws.get("workspace") or {}).get("dependencies") or {})
    for man in sorted((root / "code/src/rust/crates").glob("*/Cargo.toml")) if (
        root / "code/src/rust/crates"
    ).is_dir() else []:
        doc = toml_at(man)
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
inc_rs = cargo_specs(INC) if RUST_HERE else {}
prj_rs = cargo_specs(PRJ) if RUST_HERE else {}
rs_lock = toml_at(PRJ / "code/src/rust/Cargo.lock")
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

inc_tc = toml_at(INC / "code/src/rust/rust-toolchain.toml") if RUST_HERE else None
prj_tc = toml_at(PRJ / "code/src/rust/rust-toolchain.toml") if RUST_HERE else None
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


def ci_facts(root):
    acts, envs = {}, {}
    wf = root / ".github/workflows"
    if not wf.is_dir():
        return acts, envs
    for f in sorted(wf.glob("*.yml")):
        try:
            text = f.read_text()
        except Exception:
            continue
        for repo, ref in USES.findall(text):
            acts[repo] = ref
        for key, val in ENVP.findall(text):
            envs[key] = val
    return acts, envs


inc_a, inc_e = ci_facts(INC)
prj_a, prj_e = ci_facts(PRJ)

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
out = []
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
    out.append("No dependency drift — the incoming template declares what you already have.")

print("\n".join(out))
sys.exit(1 if blocking else 0)
PY
)"
STATUS=$?
set -e

if [[ $STATUS -gt 1 ]]; then
  die "the comparison failed — see the output above."
fi

$QUIET || printf '%s\n' "$DRIFT_OUT"

if [[ -n "$OUTPUT_FORMAT" ]]; then
  REPORT="${OUTPUT_FILE:-$REPORTS_DIR/dependency-drift.$OUTPUT_FORMAT}"
  mkdir -p "$(dirname "$REPORT")"
  printf '%s\n' "$DRIFT_OUT" >"$REPORT"
  $QUIET || printf 'Report: %s\n' "$REPORT"
fi

exit $STATUS
