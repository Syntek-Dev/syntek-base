#!/usr/bin/env bash
#
# all.sh — Run test suites in sequence with optional suite and coverage flags.
#
# Usage: all.sh [OPTIONS]
#
# Core suite (always run):
#   backend   — pytest unit + integration   (backend.sh / backend-coverage.sh)
#
# Optional suites (opt-in flags):
#   --api     Bruno API integration tests   (api.sh)
#   --all     Shorthand for every optional suite (currently --api)
#
# Coverage flag (applies to backend only):
#   --coverage  backend-coverage.sh instead of the plain variant
#
# Examples:
#   bash all.sh                          # backend
#   bash all.sh --coverage               # backend with coverage thresholds
#   bash all.sh --api                    # + API integration tests
#   bash all.sh --all                    # all optional suites
#   bash all.sh --all --coverage         # everything, coverage on backend
#
# Mutation testing (not included — run standalone when needed):
#   bash code/src/scripts/tests/mutmut.sh run    # Python mutation testing
#
# Execution order: backend → api
# Stops on first failure.
#
# Exit codes:  0 = all suites passed   1 = first failure   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

die()  { printf 'all.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
sep()  { printf '\n%s\n\n' "──────────────────────────────────────────────────────"; }

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat <<'EOF'
all.sh — Run test suites in sequence with optional suite and coverage flags

Usage: all.sh [OPTIONS]

Core suite (always run):
  backend   — pytest unit + integration   (backend.sh / backend-coverage.sh)

Optional suites (opt-in flags):
  --api     Bruno API integration tests   (api.sh)
  --all     Shorthand for every optional suite (currently --api)

Coverage flag (applies to backend only):
  --coverage  backend-coverage.sh instead of the plain variant

Examples:
  bash all.sh                        # backend
  bash all.sh --coverage             # backend with coverage thresholds
  bash all.sh --api                  # + API integration tests
  bash all.sh --all                  # all optional suites
  bash all.sh --all --coverage       # everything, coverage on backend

Mutation testing (not included — run standalone when needed):
  bash code/src/scripts/tests/mutmut.sh run    # Python mutation testing

Execution order: backend → api
Stops on first failure (set -e).

Exit codes:  0 = all suites passed   1 = first failure   2 = script error
EOF
  exit 0
fi

COVERAGE=false
RUN_API=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --coverage) COVERAGE=true;  shift ;;
    --api)      RUN_API=true;   shift ;;
    --all)      RUN_API=true;   shift ;;
    *) die "unknown option: $1 (use --help for usage)" ;;
  esac
done

bold "▸ all.sh"
log ""
log "  Core:       backend$(${COVERAGE} && printf ' (coverage)' || true)"
${RUN_API}  && log "  + api"   || true
log ""

sep
if [[ "$COVERAGE" == "true" ]]; then
  log "[all] backend (coverage)…"
  "$SCRIPT_DIR/backend-coverage.sh"
else
  log "[all] backend…"
  "$SCRIPT_DIR/backend.sh"
fi

if [[ "$RUN_API" == "true" ]]; then
  sep
  log "[all] api (Bruno)…"
  "$SCRIPT_DIR/api.sh"
fi

# Mobile surface — delegated, not reimplemented. The existence guard is what keeps "all"
# honest without templated file contents: a web-only project has no code/src/mobile/, so
# nothing here changes for it. Runs on the host (Metro and Jest are not containerised).
MOBILE_SCRIPTS="$SCRIPT_DIR/../mobile"
if [[ -d "$MOBILE_SCRIPTS" && -d "$SCRIPT_DIR/../../mobile" ]]; then
  sep
  log "[all] mobile (jest-expo)…"
  if [[ "$COVERAGE" == "true" ]]; then
    "$MOBILE_SCRIPTS/test.sh" --coverage
  else
    "$MOBILE_SCRIPTS/test.sh"
  fi
fi

sep
bold "✓ all.sh — all suites passed."
