#!/usr/bin/env bash
#
# package.sh — Build the distributable desktop binary.
#
# Usage:
#   package.sh          Optimised release binary
#   package.sh --help
#
# Produces a single native executable under code/src/rust/target/release/. Installer and
# store packaging (AppImage, .deb, .msi, .dmg) are per-platform decisions made in the
# deploy repository, not here — this script stops at the binary deliberately.
#
# ATTRIBUTION CHECK: fails if the AboutSlint disclosure has been removed from the UI.
# That disclosure is what the Royalty-free Slint licence requires in exchange for free
# commercial use, so shipping without it is a licence breach, not a style regression.
#
# Exit codes:  0 = built   1 = build failed or attribution missing   2 = script error
#
SCRIPT_NAME="package.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help | -h)
      sed -n '3,15p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

bold "▸ package.sh (desktop)"
log ""

# Match the widget INSTANTIATION (`AboutSlint {`), not the bare word, and strip //
# comments first. Two near-misses this guards against, both of which leave the string
# present while the widget is gone:
#   - the comment above it explaining the obligation
#   - the `import { ..., AboutSlint } from "std-widgets.slint"` line (closing brace)
if ! sed 's|//.*||' "$DESKTOP_DIR"/ui/*.slint | grep -Eq 'AboutSlint[[:space:]]*\{'; then
  printf '%s error: %s\n' "$SCRIPT_NAME" \
    "AboutSlint not found in $DESKTOP_DIR/ui — Slint's Royalty-free licence requires the use of Slint to be disclosed. Restore it, or buy a Commercial licence. See code/docs/DESKTOP.md." >&2
  exit 1
fi
log "✓ Slint attribution present."
log ""

cargo build -p desktop --release

log ""
bold "✓ Desktop binary built: code/src/rust/target/release/"
