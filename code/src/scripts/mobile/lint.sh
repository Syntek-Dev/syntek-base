#!/usr/bin/env bash
#
# lint.sh — ESLint the mobile surface.
#
# Usage:
#   lint.sh          Report issues
#   lint.sh --fix    Apply safe automatic fixes
#   lint.sh --help
#
# The mobile app carries its own eslint and typescript-eslint, so the repository root's
# `lint:js` deliberately does NOT cover this tree. That is why this script exists and why
# CI invokes it as a separate step.
#
# Exit codes:  0 = clean   1 = lint issues   2 = script error
#
SCRIPT_NAME="lint.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

FIX=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --fix) FIX=true; shift ;;
    --help | -h)
      sed -n '3,8p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

[[ -d node_modules ]] || die "Dependencies missing. Run: bash code/src/scripts/mobile/install.sh"

bold "▸ lint.sh (mobile)"
log ""

if $FIX; then
  pnpm exec eslint . --fix
else
  pnpm exec eslint .
fi

log ""
bold "✓ Mobile lint clean."
