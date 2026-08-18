#!/usr/bin/env bash
#
# bundle.sh — Prove the app bundles for both native platforms (the CI depth bound).
#
# Usage:
#   bundle.sh                 Export iOS and Android JS bundles
#   bundle.sh --platform P    Restrict to one platform (ios | android)
#   bundle.sh --help
#
# THIS IS WHERE CI STOPS. A JS bundle export runs on an ordinary Ubuntu runner and
# catches the failures that matter day to day — a bad import, a missing asset, a Metro
# resolution error. Compiling a native binary is deliberately out of scope: it needs a
# paid macOS runner on every pull request, and the template ships no native code.
#
# Output goes to code/src/mobile/.expo-bundle/ (gitignored).
#
# Exit codes:  0 = bundled   1 = bundling failed   2 = script error
#
SCRIPT_NAME="bundle.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

PLATFORMS=(ios android)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)
      [[ $# -ge 2 ]] || die "--platform needs a value."
      case "$2" in
        ios | android) PLATFORMS=("$2") ;;
        *) die "Invalid platform '$2'. Choose: ios android" ;;
      esac
      shift 2
      ;;
    --help | -h)
      sed -n '3,8p' "$SCRIPT_SELF" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

[[ -d node_modules ]] || die "Dependencies missing. Run: bash code/src/scripts/mobile/install.sh"

bold "▸ bundle.sh (mobile)"
log ""
log "  Platforms: ${PLATFORMS[*]}"
log ""

EXPORT_ARGS=(--output-dir .expo-bundle --clear)
for p in "${PLATFORMS[@]}"; do
  EXPORT_ARGS+=(--platform "$p")
done

pnpm exec expo export "${EXPORT_ARGS[@]}"

log ""
bold "✓ Bundle export succeeded."
