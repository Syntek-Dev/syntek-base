#!/usr/bin/env bash
#
# open-coverage.sh — Open HTML coverage reports in the default browser.
#
# Usage: open-coverage.sh [--backend]
#
#   --backend    Open backend coverage HTML only.
#   (no flags)   Open backend coverage HTML.
#
# Reports must exist first — run backend-coverage.sh.
#
# Exit codes:  0 = opened at least one report   1 = no reports found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BACKEND_HTML="$SCRIPT_DIR/reports/backend-coverage/html/index.html"

OPEN_BACKEND=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --backend)  OPEN_BACKEND=true; shift ;;
    --help|-h)  sed -n '3,12p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'open-coverage.sh: unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

if [[ "$OPEN_BACKEND" == "false" ]]; then
  OPEN_BACKEND=true
fi

if command -v xdg-open &>/dev/null; then
  OPENER="xdg-open"
elif command -v open &>/dev/null; then
  OPENER="open"
else
  printf 'open-coverage.sh error: no browser opener found (xdg-open or open).\n' >&2
  exit 2
fi

OPENED=0

if [[ "$OPEN_BACKEND" == "true" ]]; then
  if [[ -f "$BACKEND_HTML" ]]; then
    printf '[coverage] Opening backend coverage report...\n'
    "$OPENER" "$BACKEND_HTML"
    OPENED=$((OPENED + 1))
  else
    printf '[coverage] Backend HTML report not found: %s\n' "$BACKEND_HTML" >&2
    printf '           Run ./code/src/scripts/tests/backend-coverage.sh first.\n' >&2
  fi
fi

if [[ "$OPENED" -eq 0 ]]; then
  exit 1
fi
