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
#   In syntek-base      uv.lock is committed (16/08/2026), so all three lockfiles exist and
#                       every leg re-resolves for real. It is copier-EXCLUDED, because it
#                       pins the root project under the template's own name and must never
#                       travel — but it is present and authoritative here.
#   In a generated project  identical behaviour, against that project's own uv.lock.
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
# With --package, whether ANY ecosystem's lockfile held the name. Each leg looks in its own
# lock and skips — saying so — when the name is not there, because a name is a Python OR a
# JavaScript OR a Rust package, and the default runs all three: one leg dying on a name it
# never had used to abort the rest after an earlier leg had already written its lock.
PACKAGE_FOUND=false

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
                      solves the problem, which is the one to prefer. JavaScript: a
                      direct dependency moves to latest; a transitive one re-resolves
                      within its consumers' ranges. Reports versions before and after
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

# Name the files that ACTUALLY moved. `pnpm update --latest` frequently rewrites only
# pnpm-lock.yaml — a declared range like ^1.2.0 already admits 1.9.0, so the manifest needs no
# edit — and the old wording claimed both every time. Reporting an action that did not happen is
# the same defect as reporting a check that did not run (code/docs/GATE-REPORTING.md).
_report_pnpm_writes() {
  local label="$1" moved=()
  if ! git -C "$PROJECT_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    log "  $label — could not check which files changed (not a git work tree)."
    return 0
  fi
  mapfile -t moved < <(git -C "$PROJECT_ROOT" diff --name-only -- \
    package.json 'code/src/*/package.json' pnpm-lock.yaml 2>/dev/null)
  if [[ ${#moved[@]} -eq 0 ]]; then
    log "  $label — already current; no file changed."
  else
    log "  $label in $(printf '%s, ' "${moved[@]}" | sed 's/, $//')."
  fi
}

# Every version pnpm-lock.yaml resolves NAME to, one per line. Read from the `packages:`
# section, where each resolved version has exactly one key (`name@version`, quoted when
# scoped); `snapshots:` repeats them with peer suffixes and is not read.
_locked_versions() {
  awk -v name="$1" '
    /^packages:/ { in_p = 1; next }
    /^snapshots:/ { exit }
    in_p && /^  [^ ]/ {
      key = $0; sub(/^  /, "", key); sub(/:$/, "", key); gsub(/\047/, "", key)
      at = index(substr(key, 2), "@") + 1
      if (substr(key, 1, at - 1) == name) print substr(key, at + 1)
    }' "$PROJECT_ROOT/pnpm-lock.yaml" | sort -u
}

# True when NAME is declared by any workspace importer (root or code/src/*) — i.e. a
# direct dependency whose manifest range is ours to move. Dependency names sit at six
# spaces under `importers:`; their `specifier:`/`version:` fields sit at eight.
_is_direct() {
  awk -v name="$1" '
    /^importers:/ { in_i = 1; next }
    in_i && /^[^ ]/ { exit }
    in_i && /^      [^ ]/ {
      key = $0; sub(/^      /, "", key); sub(/:$/, "", key); gsub(/\047/, "", key)
      if (key == name) { found = 1; exit }
    }
    END { exit found ? 0 : 1 }' "$PROJECT_ROOT/pnpm-lock.yaml"
}

# Move ONE JavaScript package, choosing the form that can actually move it.
#
# A direct dependency takes `--latest`: its range is ours, so moving to the registry's latest
# (across a major, if there is one) is the deliberate act --apply exists for. A TRANSITIVE one
# must not: `pnpm update --latest <name>` rewrites manifest ranges only, so for a package no
# manifest declares it re-resolves nothing — measured 14/10/2026 on pnpm 11.25.0, where it left
# handlebars, moment and @grpc/grpc-js on versions their consumers' ranges had already
# outgrown, and this script then reported "already current". The transitive form re-resolves
# within the ranges the consumers declare, which is the narrowest fix and the one the 15/08
# @grpc/grpc-js precedent in pnpm-workspace.yaml used. `-r` because a direct dependency can
# live in the mobile workspace member rather than the root.
#
# Reported by what the lockfile RESOLVES before and after, never by whether a file changed:
# a diff can move for unrelated reasons, and an unchanged one is not proof that anything was
# re-resolved (code/docs/GATE-REPORTING.md).
_apply_pnpm_package() {
  local name="$1" before after kind
  before="$(_locked_versions "$name")"
  if [[ -z "$before" ]]; then
    log "  $name is not in pnpm-lock.yaml — not a JavaScript dependency here; skipped."
    return 0
  fi
  PACKAGE_FOUND=true
  if _is_direct "$name"; then
    kind="direct"
    pnpm update -r --latest "$name"
  else
    kind="transitive"
    pnpm update -r "$name"
  fi
  after="$(_locked_versions "$name")"
  if [[ "$before" == "$after" ]]; then
    log "  $name ($kind) — unchanged at $(tr '\n' ' ' <<<"$after")"
    log "    The cause is one of: it is already the newest its declared ranges admit; an"
    log "    override in pnpm-workspace.yaml holds it; or the newer release is younger than"
    log "    pnpm 11's default 24-hour minimumReleaseAge — a security fix that cannot wait"
    log "    takes a minimumReleaseAgeExclude entry. Moving past a consumer's range takes a"
    log "    bounded override there — never a looser range."
  else
    log "  $name ($kind): $(tr '\n' ' ' <<<"$before")-> $(tr '\n' ' ' <<<"$after")"
    _report_pnpm_writes "  written"
  fi
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
        # uv.lock stores PEP 503-normalised names: lower case, runs of -_. as one hyphen.
        norm="$(printf '%s' "$PACKAGE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[-_.]+/-/g')"
        if ! grep -qx "name = \"$norm\"" uv.lock; then
          log "  $PACKAGE is not in uv.lock — not a Python dependency here; skipped."
        else
          PACKAGE_FOUND=true
          uv lock --upgrade-package "$PACKAGE"
          log "  uv.lock re-resolved for $PACKAGE only."
        fi
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
      _apply_pnpm_package "$PACKAGE"
    else
      pnpm update --latest
      _report_pnpm_writes "packages updated"
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
      if [[ ! -f "$RUST_DIR/Cargo.lock" ]] || ! grep -qx "name = \"$PACKAGE\"" "$RUST_DIR/Cargo.lock"; then
        log "  $PACKAGE is not in Cargo.lock — not a Rust dependency here; skipped."
      else
        PACKAGE_FOUND=true
        (cd "$RUST_DIR" && cargo update --package "$PACKAGE")
        log "  Cargo.lock re-resolved for $PACKAGE only."
      fi
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
  if [[ -n "$PACKAGE" ]] && ! $PACKAGE_FOUND; then
    die "$PACKAGE is in none of the lockfiles this run could read — nothing moved."
  fi
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
