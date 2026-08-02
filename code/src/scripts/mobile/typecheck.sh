#!/usr/bin/env bash
#
# typecheck.sh — TypeScript type-check the mobile surface (tsc --noEmit).
#
# Usage:
#   typecheck.sh          Type-check once
#   typecheck.sh --watch  Re-check on change
#   typecheck.sh --help
#
# TypeScript exists on the mobile surface only. The web surface has none, so there is no
# root typecheck job and basedpyright covers the Python side separately.
#
# The token-first law's "name resolves" clause is free here: an unresolved token import
# does not compile, so this script enforces half of it. The no-raw-literals clause is
# checked by audits/mobile-tokens.sh.
#
# Exit codes:  0 = clean   1 = type errors   2 = script error
#
SCRIPT_NAME="typecheck.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

TSC_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --watch) TSC_ARGS+=(--watch); shift ;;
    --help | -h)
      sed -n '3,8p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

[[ -d node_modules ]] || die "Dependencies missing. Run: bash code/src/scripts/mobile/install.sh"

bold "▸ typecheck.sh (mobile)"
log ""

pnpm exec tsc --noEmit "${TSC_ARGS[@]}"

log ""
bold "✓ Mobile types clean."
