#!/usr/bin/env bash
#
# server.sh — Start the Expo dev server (Metro) for the mobile surface.
#
# Usage:
#   server.sh                Start Metro, print the QR code for Expo Go
#   server.sh --clear        Start with the Metro cache cleared
#   server.sh --tunnel       Start via an Expo tunnel (device not on the same LAN)
#   server.sh --port N       Override the port (default: this worktree's Metro port)
#   server.sh --help
#
# THIS IS THE ONE DEV OPERATION THAT IS NOT CONTAINERISED.
# Expo Go runs on a physical device, and a device cannot reach a 127.0.0.N loopback
# alias — Metro must be reachable on the LAN, which containerising fights rather than
# helps. "The stack" is therefore Docker plus this one host process, and Node and pnpm
# are explicit host prerequisites.
#
# The Django API still runs in Docker, started by its own dev-stack script. Once the API
# exists, a device will not reach it on 127.0.0.N either — it needs the host's LAN
# address.
#
# Exit codes:  0 = success   1 = Metro failed to start   2 = script error
#
SCRIPT_NAME="server.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

EXPO_ARGS=()
PORT="$METRO_PORT"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clear) EXPO_ARGS+=(--clear); shift ;;
    --tunnel) EXPO_ARGS+=(--tunnel); shift ;;
    --port)
      [[ $# -ge 2 ]] || die "--port needs a value."
      PORT="$2"
      shift 2
      ;;
    --help | -h)
      sed -n '3,11p' "$SCRIPT_SELF" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

[[ -d node_modules ]] || die "Dependencies missing. Run: bash code/src/scripts/mobile/install.sh"

bold "▸ server.sh (mobile)"
log ""
log "  Metro port : $PORT${WORKTREE_US_NUM:+  (worktree us$WORKTREE_US_NUM)}"
log "  Dev loop   : Expo Go — scan the QR code below"
log ""

# exec so Ctrl+C reaches Metro directly rather than this wrapper.
exec pnpm exec expo start --port "$PORT" "${EXPO_ARGS[@]}"
