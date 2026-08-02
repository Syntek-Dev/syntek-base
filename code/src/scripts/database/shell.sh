#!/usr/bin/env bash
#
# shell.sh — Open a database shell via Docker (Django dbshell or direct psql).
#
# Usage: shell.sh [--psql] [--help]
#
# Default: Django dbshell (python manage.py dbshell) in the django container.
# --psql:  Direct psql session in the db container.
#
# Exit codes:  0 = exited normally   1 = container error   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"
DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

# Load env file so POSTGRES_USER / POSTGRES_DB are available in this shell
# (--env-file only injects vars into the compose process, not the host shell)
if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$ENV_FILE"
  set +a
fi

DB_NAME="${POSTGRES_DB:-<%PROJECT_SLUG%>_dev}"
DB_USER="${POSTGRES_USER:-<%PROJECT_SLUG%>}"

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
psql connects as POSTGRES_USER to POSTGRES_DB (env vars, defaults: <%PROJECT_SLUG%> / <%PROJECT_SLUG%>_dev).

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
  "${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "db" \
    || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"
  bold "▸ shell.sh — psql ($DB_USER @ $DB_NAME)"
  log "  Type \\q or press Ctrl+D to exit."
  log ""
  exec "${DC[@]}" exec db \
    psql -U "$DB_USER" -d "$DB_NAME"
else
  "${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "django" \
    || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"
  bold "▸ shell.sh — Django dbshell"
  log "  Type \\q or press Ctrl+D to exit."
  log ""
  exec "${DC[@]}" exec -w /workspace/code/src/django django python manage.py dbshell
fi
