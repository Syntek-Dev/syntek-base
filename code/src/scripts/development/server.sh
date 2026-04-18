#!/usr/bin/env bash
#
# server.sh — Manage the development Docker Compose stack.
#
# Usage:
#   server.sh up       [--build] [--watch] [--service SERVICE]
#   server.sh down     [--volumes]
#   server.sh restart  [--service SERVICE]
#   server.sh build    [--service SERVICE]
#   server.sh status
#   server.sh --help
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'server.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
server.sh — Manage the development Docker Compose stack

Usage:
  server.sh up       Start all services (or a single service)
  server.sh down     Stop and remove containers
  server.sh restart  Restart all services (or a single service)
  server.sh build    Build or rebuild service images
  server.sh status   Show container status and port bindings

Options (up):
  --build            Rebuild images before starting
  --watch            Enable file-watch mode (docker compose up --watch)
  --service SERVICE  Target a single service

Options (down):
  --volumes          Also remove named volumes (wipes database data)

Options (restart, build):
  --service SERVICE  Target a single service

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Command ───────────────────────────────────────────────────────────────────
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  up|down|restart|build|status) ;;
  --help|-h) usage; exit 0 ;;
  "")        die "No command given. Use --help for usage." ;;
  *)         die "Unknown command '$COMMAND'. Use --help for usage." ;;
esac

# ── Per-command flag parsing ──────────────────────────────────────────────────
BUILD=false
WATCH=false
VOLUMES=false
SERVICE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build)            BUILD=true; shift ;;
    --watch)            WATCH=true; shift ;;
    --volumes)          VOLUMES=true; shift ;;
    --service)          require_arg "$@"; SERVICE="$2"; shift 2 ;;
    --help|-h)          usage; exit 0 ;;
    *)                  die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  up)
    bold "▸ server.sh up"
    declare -a args=(docker compose -f "$COMPOSE_FILE" up -d)
    $BUILD  && args+=(--build)
    $WATCH  && args+=(--watch)
    [[ -n "$SERVICE" ]] && args+=("$SERVICE")
    log ""
    "${args[@]}"
    log ""
    bold "✓ Stack is up."
    log "  Site:     http://dev.syntekstudio.com"
    log "  GraphQL:  http://dev.syntekstudio.com/graphql/"
    log "  Admin:    http://dev.syntekstudio.com/admin/"
    log "  Mail:     http://dev.syntekstudio.com:1080"
    ;;

  down)
    bold "▸ server.sh down"
    declare -a args=(docker compose -f "$COMPOSE_FILE" down)
    $VOLUMES && args+=(--volumes)
    log ""
    "${args[@]}"
    log ""
    $VOLUMES \
      && bold "✓ Stack stopped and volumes removed." \
      || bold "✓ Stack stopped."
    ;;

  restart)
    bold "▸ server.sh restart"
    log ""
    if [[ -n "$SERVICE" ]]; then
      docker compose -f "$COMPOSE_FILE" restart "$SERVICE"
    else
      docker compose -f "$COMPOSE_FILE" restart
    fi
    log ""
    bold "✓ Restarted${SERVICE:+ $SERVICE}."
    ;;

  build)
    bold "▸ server.sh build"
    log ""
    if [[ -n "$SERVICE" ]]; then
      docker compose -f "$COMPOSE_FILE" build "$SERVICE"
    else
      docker compose -f "$COMPOSE_FILE" build
    fi
    log ""
    bold "✓ Build complete."
    ;;

  status)
    bold "▸ server.sh status"
    log ""
    docker compose -f "$COMPOSE_FILE" ps
    log ""
    docker compose -f "$COMPOSE_FILE" images 2>/dev/null || true
    ;;
esac
