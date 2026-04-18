#!/usr/bin/env bash
#
# shell.sh — Open an interactive shell in a development Docker Compose service.
#
# Usage: shell.sh [--service SERVICE] [--help]
#
# Default service: backend  (bash)
# Services: backend (bash) · frontend (sh) · db (bash) · cache (sh) · nginx (sh) · maildev (sh)
#
# Exit codes:  0 = exited normally   1 = container error   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

# ── Defaults ──────────────────────────────────────────────────────────────────
SERVICE="backend"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'shell.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
shell.sh — Open an interactive shell in a development Docker Compose service

Usage:
  shell.sh                     Open bash in the backend container (default)
  shell.sh --service frontend  Open sh in the frontend container
  shell.sh --service db        Open bash in the PostgreSQL container
  shell.sh --service cache     Open sh in the Valkey container

Options:
  --service SERVICE    Service to shell into:
                         backend (default) | frontend | db | cache | nginx | maildev

Exit codes:  0 = exited normally   1 = container error   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --service)  require_arg "$@"; SERVICE="$2"; shift 2 ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

# Map service to shell binary (alpine uses ash/sh, debian-based has bash)
case "$SERVICE" in
  backend|db)                   SHELL_BIN="bash" ;;
  frontend|cache|nginx|maildev) SHELL_BIN="sh" ;;
  *)                            die "Unknown service '$SERVICE'. Choose: backend frontend db cache nginx maildev" ;;
esac

cd "$PROJECT_ROOT"

bold "▸ shell.sh — $SERVICE ($SHELL_BIN)"
log "  Type 'exit' or press Ctrl+D to leave the container."
log ""

exec docker compose -f "$COMPOSE_FILE" exec "$SERVICE" "$SHELL_BIN"
