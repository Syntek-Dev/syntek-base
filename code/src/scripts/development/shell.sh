#!/usr/bin/env bash
#
# shell.sh — Open an interactive shell in a development Docker Compose service.
#
# Usage: shell.sh [--service SERVICE] [--help]
#
# Default service: django  (bash)
# Services: django (bash) · db (bash) · cache (sh) · nginx (sh)
#
# Exit codes:  0 = exited normally   1 = container error   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

# ── Defaults ──────────────────────────────────────────────────────────────────
SERVICE="django"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'shell.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
shell.sh — Open an interactive shell in a development Docker Compose service

Usage:
  shell.sh                     Open bash in the django container (default)
  shell.sh --service db        Open bash in the PostgreSQL container
  shell.sh --service cache     Open sh in the Valkey container

Options:
  --service SERVICE    Service to shell into:
                         django (default) | db | cache | nginx

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
  django|db)    SHELL_BIN="bash" ;;
  cache|nginx)  SHELL_BIN="sh" ;;
  *)            die "Unknown service '$SERVICE'. Choose: django db cache nginx" ;;
esac

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

cd "$PROJECT_ROOT"

bold "▸ shell.sh — $SERVICE ($SHELL_BIN)"
log "  Type 'exit' or press Ctrl+D to leave the container."
log ""

exec "${DC[@]}" exec "$SERVICE" "$SHELL_BIN"
