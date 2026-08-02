#!/usr/bin/env bash
#
# run.sh — Build and launch the desktop application.
#
# Usage:
#   run.sh             Debug build, launched
#   run.sh --release   Optimised build, launched
#   run.sh --help
#
# Needs a display server. Over SSH, forward one or set DISPLAY/WAYLAND_DISPLAY first —
# the app will exit with a Slint platform error otherwise, which is expected, not a bug.
#
# Exit codes:  0 = clean exit   1 = build or runtime failure   2 = script error
#
SCRIPT_NAME="run.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --release) ARGS+=(--release); shift ;;
    --help | -h)
      sed -n '3,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
  log "warning: neither DISPLAY nor WAYLAND_DISPLAY is set — the window cannot open."
  log ""
fi

bold "▸ run.sh (desktop)"
log ""

cargo run -p desktop "${ARGS[@]}"
