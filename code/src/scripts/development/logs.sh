#!/usr/bin/env bash
#
# logs.sh — View and tail logs from development Docker Compose services.
#
# Usage: logs.sh [--service SERVICE] [--follow] [--tail N] [--since DURATION] [--help]
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

# ── Defaults ──────────────────────────────────────────────────────────────────
SERVICE=""
FOLLOW=false
TAIL="100"
SINCE=""

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'logs.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
logs.sh — View and tail logs from development Docker Compose services

Usage:
  logs.sh                          Show last 100 lines from all services
  logs.sh --follow                 Follow all service logs (Ctrl+C to stop)
  logs.sh --service backend        Tail only the backend service
  logs.sh --service backend --follow --tail 50

Options:
  --service SERVICE    Service to show logs for (default: all)
                         backend | frontend | db | cache
  --follow             Follow log output
  --tail N             Number of lines to show from the end (default: 100)
  --since DURATION     Show logs since a duration or timestamp
                         Examples: 30m, 1h, 2024-01-01T00:00:00

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --service)  require_arg "$@"; SERVICE="$2"; shift 2 ;;
    --follow)   FOLLOW=true; shift ;;
    --tail)     require_arg "$@"; TAIL="$2"; shift 2 ;;
    --since)    require_arg "$@"; SINCE="$2"; shift 2 ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# ── Build docker compose logs command ────────────────────────────────────────
declare -a args=(docker compose -f "$COMPOSE_FILE" logs)
args+=(--tail "$TAIL")
$FOLLOW       && args+=(-f)
[[ -n "$SINCE" ]] && args+=(--since "$SINCE")
[[ -n "$SERVICE" ]] && args+=("$SERVICE")

bold "▸ logs.sh${SERVICE:+ — $SERVICE}${FOLLOW:+ (following)}"
log ""
"${args[@]}"
