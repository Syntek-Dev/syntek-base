#!/usr/bin/env bash
#
# test.sh — Run the mobile test suite (jest-expo + React Native Testing Library).
#
# Usage:
#   test.sh                Run the suite
#   test.sh --coverage     Run with coverage and enforce the floors
#   test.sh --watch        Re-run on change
#   test.sh --path PATH    Restrict to a file or directory
#   test.sh --help
#
# COVERAGE: the same numbers as the backend — 75% lines and branches, 90% on
# auth-adjacent code — enforced ONCE PER RUNTIME. coverage.py and Jest share no
# accumulator, so a single combined percentage across both surfaces was never
# achievable. Thresholds live in code/src/mobile/jest.config.js.
#
# Exit codes:  0 = pass   1 = failures or coverage below floor   2 = script error
#
SCRIPT_NAME="test.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

JEST_ARGS=()
COVERAGE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --coverage) COVERAGE=true; shift ;;
    --watch) JEST_ARGS+=(--watch); shift ;;
    --path)
      [[ $# -ge 2 ]] || die "--path needs a value."
      JEST_ARGS+=("$2")
      shift 2
      ;;
    --help | -h)
      sed -n '3,10p' "$SCRIPT_SELF" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

[[ -d node_modules ]] || die "Dependencies missing. Run: bash code/src/scripts/mobile/install.sh"

bold "▸ test.sh (mobile)"
log ""

if $COVERAGE; then
  pnpm exec jest --coverage --passWithNoTests "${JEST_ARGS[@]}"
else
  pnpm exec jest --passWithNoTests "${JEST_ARGS[@]}"
fi

log ""
bold "✓ Mobile tests passed."
