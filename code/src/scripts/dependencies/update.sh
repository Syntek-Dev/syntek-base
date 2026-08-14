#!/usr/bin/env bash
#
# update.sh — Report or apply dependency updates across all three ecosystems.
#
# The single sanctioned entry point for moving a dependency. Python (uv), JavaScript
# (pnpm) and Rust (cargo) each have their own tool and their own idea of what "update"
# means; this puts one command and one exit-code contract over them so a sweep is a
# decision rather than three half-remembered incantations.
#
# It ships, so it runs on both sides of the template boundary and the two are genuinely
# different:
#
#   In syntek-base      there is no uv.lock — absent by design, because it would pin the
#                       root project under the literal project-slug token. Nothing can be
#                       re-resolved here, so the Python leg reports declared floors
#                       against PyPI and stops. Rust and JavaScript do have lockfiles and
#                       behave normally.
#   In a generated project  every lockfile exists and --apply re-resolves for real.
#
# A FLOOR IS NOT A PIN. Raising `redis>=5.0.0` to `redis>=6.0` does not install redis 6 —
# it forbids redis 5. What you actually get is decided by the lockfile, and the two
# disagree far more often than anyone expects: this repository once had CI resolving ruff
# to latest while a developer's host ran 0.14.11, and the two disagreed about what
# "formatted" meant. Raise a floor deliberately, and re-resolve in the same change.
#
# A floor is also bounded by what your other dependencies permit, not by what the registry
# calls latest. `celery[redis]` excludes `redis>=6.5`, so redis 6.4 is the newest this
# project can resolve — raising the floor past it does not fail, it silently drags celery
# backwards to satisfy it. --check reports the registry's latest; it cannot tell you what
# your graph will tolerate. Only a resolve does that, which is why --apply re-resolves
# rather than editing a number.
#
# Usage: update.sh [--check | --apply] [--package NAME] [--ecosystem NAME]
#                  [--output FORMAT] [--output-file PATH] [--quiet] [--help]
#
# Exit codes:  0 = up to date / applied cleanly   1 = updates available (--check)
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/reports"
RUST_DIR="$PROJECT_ROOT/code/src/rust"

MODE="check"
ECOSYSTEMS=()
PACKAGE=""
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
FOUND_UPDATES=false

die() {
  printf 'update.sh error: %s\n' "$*" >&2
  exit 2
}
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }
log() { $QUIET || printf '%s\n' "$*"; }

usage() {
  cat <<'USAGE'
update.sh — report or apply dependency updates (Python, JavaScript, Rust)

Usage:
  update.sh                      Report what is out of date (default)
  update.sh --apply              Re-resolve and write the lockfiles
  update.sh --ecosystem rust     Restrict to one ecosystem (repeatable)

Options:
  --check             Report only, change nothing (default)
  --apply             Apply updates — rewrites lockfiles, and package.json for pnpm
  --package NAME      Restrict --apply to one package — the narrowest upgrade that
                      solves the problem, which is the one to prefer
  --ecosystem NAME    python | javascript | rust (repeat for several; default: all)
  --output FORMAT     Write a report: md | txt
  --output-file PATH  Override the report path
                        (default: code/src/scripts/reports/dependency-update.<FORMAT>)
  --quiet             Suppress terminal output — requires --output
  --help              Show this help

Notes:
  • A floor is not a pin. Raising a floor forbids old versions; it does not install new
    ones. --apply is what changes the resolved graph.
  • After --apply, run the suites before committing:  code/src/scripts/tests/all.sh
  • To see what a TEMPLATE update would impose on this project, that is a different
    question — use code/src/scripts/audits/dependency-drift.sh

Exit codes:  0 = up to date / applied   1 = updates available (--check)   2 = script error
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --apply) MODE="apply"; shift ;;
    --package) PACKAGE="${2:-}"; shift 2 ;;
    --ecosystem) ECOSYSTEMS+=("${2:-}"); shift 2 ;;
    --output) OUTPUT_FORMAT="${2:-}"; shift 2 ;;
    --output-file) OUTPUT_FILE="${2:-}"; shift 2 ;;
    --quiet) QUIET=true; shift ;;
    --help) usage; exit 0 ;;
    *) die "Unknown option: $1. Use --help for usage." ;;
  esac
done

if [[ ${#ECOSYSTEMS[@]} -eq 0 ]]; then
  ECOSYSTEMS=(python javascript rust)
fi
for e in "${ECOSYSTEMS[@]}"; do
  case "$e" in
    python | javascript | rust) ;;
    *) die "Unknown --ecosystem: $e (python | javascript | rust)" ;;
  esac
done
if $QUIET && [[ -z "$OUTPUT_FORMAT" ]]; then
  die "--quiet requires --output."
fi
if [[ -n "$OUTPUT_FORMAT" && "$OUTPUT_FORMAT" != "md" && "$OUTPUT_FORMAT" != "txt" ]]; then
  die "Unknown --output format: $OUTPUT_FORMAT (md | txt)"
fi

wants() {
  local want="$1"
  for e in "${ECOSYSTEMS[@]}"; do [[ "$e" == "$want" ]] && return 0; done
  return 1
}

cd "$PROJECT_ROOT"

# ── Python ────────────────────────────────────────────────────────────────────
if wants python; then
  bold "── Python (uv) ──"
  if ! command -v uv >/dev/null 2>&1 && ! command -v uvx >/dev/null 2>&1; then
    log "  uv not found on PATH — skipped. Install it: install.sh"
  elif [[ ! -f pyproject.toml ]]; then
    log "  no pyproject.toml — skipped."
  elif [[ -f uv.lock ]]; then
    if [[ "$MODE" == "apply" ]]; then
      if [[ -n "$PACKAGE" ]]; then
        uv lock --upgrade-package "$PACKAGE"
        log "  uv.lock re-resolved for $PACKAGE only."
      else
        uv lock --upgrade
        log "  uv.lock re-resolved."
      fi
    else
      if uv lock --check >/dev/null 2>&1; then
        log "  uv.lock is in step with pyproject.toml."
      else
        log "  uv.lock is OUT OF STEP with pyproject.toml — run with --apply."
        FOUND_UPDATES=true
      fi
    fi
  else
    # syntek-base itself. Nothing to resolve, so report floors against PyPI instead —
    # the only useful thing that can be said without a lockfile.
    log "  No uv.lock — this is the base template, so nothing can be re-resolved."
    log "  Declared floors against PyPI latest:"
    PYOUT="$(python3 - <<'PY'
import json, re, sys, tomllib, urllib.request

SPEC = re.compile(r"^\s*([A-Za-z0-9._-]+)\s*(?:\[[^\]]*\])?\s*>=\s*([0-9][0-9A-Za-z.\-]*)")
doc = tomllib.load(open("pyproject.toml", "rb"))
specs = list((doc.get("project") or {}).get("dependencies") or [])
for grp in (doc.get("dependency-groups") or {}).values():
    specs += [s for s in grp if isinstance(s, str)]

def vt(s):
    n = re.findall(r"\d+", s or "")
    t = tuple(int(x) for x in n[:3])
    return t + (0,) * (3 - len(t))

behind = 0
for s in specs:
    m = SPEC.match(s)
    if not m:
        continue
    name, floor = m.group(1), m.group(2)
    try:
        with urllib.request.urlopen(f"https://pypi.org/pypi/{name}/json", timeout=15) as r:
            latest = json.load(r)["info"]["version"]
    except Exception:
        print(f"    {name:24} floor {floor:12} (lookup failed)")
        continue
    if vt(latest) > vt(floor):
        behind += 1
        mark = "  <-- MAJOR" if vt(latest)[0] > vt(floor)[0] else ""
        print(f"    {name:24} floor {floor:12} latest {latest}{mark}")
sys.exit(1 if behind else 0)
PY
)" && PYSTATUS=0 || PYSTATUS=$?
    [[ -n "$PYOUT" ]] && log "$PYOUT"
    if [[ ${PYSTATUS:-0} -eq 1 ]]; then
      FOUND_UPDATES=true
      log "  Raising a floor here is deliberate — it states the minimum this template"
      log "  supports. It is bounded by what the graph tolerates, not by PyPI."
    else
      log "    every floor is at or above PyPI latest."
    fi
  fi
fi

# ── JavaScript ────────────────────────────────────────────────────────────────
if wants javascript; then
  bold "── JavaScript (pnpm) ──"
  if ! command -v pnpm >/dev/null 2>&1; then
    log "  pnpm not found on PATH — skipped. Install it: install.sh"
  elif [[ ! -f package.json ]]; then
    log "  no package.json — skipped."
  elif [[ "$MODE" == "apply" ]]; then
    if [[ -n "$PACKAGE" ]]; then
      pnpm update --latest "$PACKAGE"
      log "  $PACKAGE updated in package.json and pnpm-lock.yaml."
    else
      pnpm update --latest
      log "  package.json and pnpm-lock.yaml updated."
    fi
  else
    if OUT="$(pnpm outdated 2>&1)"; then
      log "  every package is current."
    else
      log "$OUT"
      FOUND_UPDATES=true
    fi
  fi
fi

# ── Rust ──────────────────────────────────────────────────────────────────────
if wants rust; then
  bold "── Rust (cargo) ──"
  if [[ ! -d "$RUST_DIR" ]]; then
    log "  no code/src/rust/ — this project was generated without the Rust surface."
  elif ! command -v cargo >/dev/null 2>&1; then
    log "  cargo not found on PATH — skipped. Install rustup: install.sh"
  elif [[ "$MODE" == "apply" ]]; then
    if [[ -n "$PACKAGE" ]]; then
      (cd "$RUST_DIR" && cargo update --package "$PACKAGE")
      log "  Cargo.lock re-resolved for $PACKAGE only."
    else
      (cd "$RUST_DIR" && cargo update)
      log "  Cargo.lock re-resolved."
    fi
  else
    OUT="$(cd "$RUST_DIR" && cargo update --dry-run 2>&1)"
    log "$OUT"
    if printf '%s' "$OUT" | grep -qE "^\s+Updating "; then
      FOUND_UPDATES=true
    fi
  fi
fi

# ── Close ─────────────────────────────────────────────────────────────────────
if [[ "$MODE" == "apply" ]]; then
  bold "✓ Applied. Re-run the suites before committing:"
  log "    bash code/src/scripts/tests/all.sh"
  exit 0
fi

if $FOUND_UPDATES; then
  bold "Updates are available. Apply with --apply, then run the suites."
  STATUS=1
else
  bold "✓ Everything is current."
  STATUS=0
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  REPORT="${OUTPUT_FILE:-$REPORTS_DIR/dependency-update.$OUTPUT_FORMAT}"
  mkdir -p "$(dirname "$REPORT")"
  {
    printf '# Dependency update report\n\n'
    printf 'Mode: %s · Ecosystems: %s\n' "$MODE" "${ECOSYSTEMS[*]}"
  } >"$REPORT"
  $QUIET || printf 'Report: %s\n' "$REPORT"
fi

exit $STATUS
