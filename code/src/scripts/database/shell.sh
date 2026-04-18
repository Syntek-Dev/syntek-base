#!/usr/bin/env bash
#
# shell.sh — Open a database shell via Docker (Django dbshell or direct psql).
#
# Usage: shell.sh [--psql] [--help]
#
# Default: Django dbshell (python manage.py dbshell) in the backend container.
# --psql:  Direct psql session in the db container.
#
# Exit codes:  0 = exited normally   1 = container error   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

DB_NAME="${POSTGRES_DB:-syntek_website_dev}"
DB_USER="${POSTGRES_USER:-postgres}"

# ── Defaults ──────────────────────────────────────────────────────────────────
USE_PSQL=false

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'shell.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
shell.sh — Open a database shell via Docker

Usage:
  shell.sh           Django dbshell (python manage.py dbshell) — default
  shell.sh --psql    Direct psql session in the db container

Options:
  --psql     Open psql directly in the db container instead of Django dbshell

Django dbshell connects using the DATABASE_URL / DATABASES setting from Django config.
psql connects as POSTGRES_USER to POSTGRES_DB (env vars, defaults: postgres / syntek_website_dev).

Exit codes:  0 = exited normally   1 = container error   2 = script error
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --psql)     USE_PSQL=true; shift ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

if $USE_PSQL; then
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "db" \
    || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"
  bold "▸ shell.sh — psql ($DB_USER @ $DB_NAME)"
  log "  Type \\q or press Ctrl+D to exit."
  log ""
  exec docker compose -f "$COMPOSE_FILE" exec db \
    psql -U "$DB_USER" -d "$DB_NAME"
else
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "backend" \
    || die "backend container is not running. Start with: bash code/src/scripts/development/server.sh up"
  bold "▸ shell.sh — Django dbshell"
  log "  Type \\q or press Ctrl+D to exit."
  log ""
  exec docker compose -f "$COMPOSE_FILE" exec backend python manage.py dbshell
fi
