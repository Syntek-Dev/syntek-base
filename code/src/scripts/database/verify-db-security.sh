#!/usr/bin/env bash
#
# verify-db-security.sh — Verify database security configuration.
#
# Checks:
#   1. Django system check (confirms no configuration errors)
#   2. PostgreSQL log_statement setting (must be 'none' in dev)
#
# Usage:
#   bash code/src/scripts/database/verify-db-security.sh
#
# Exit codes:  0 = all checks passed   1 = check failed   2 = script error
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

die()  { printf 'verify-db-security.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
pass() { printf '\033[32m✓ %s\033[0m\n' "$*"; }
fail() { printf '\033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) sed -n '3,13p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)         die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

# `ps --services` prints service names only, so `grep -qx` matches exactly.
container_running() {
  cd "$PROJECT_ROOT"
  "${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "django"
}

db_running() {
  cd "$PROJECT_ROOT"
  "${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "db"
}

cd "$PROJECT_ROOT"

container_running || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"
db_running        || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"

bold "▸ verify-db-security.sh"
log ""

# ── Check 1: Django system check ──────────────────────────────────────────────
bold "1. Django system check"
if "${DC[@]}" exec -T -w /workspace/code/src/django django python manage.py check; then
  pass "Django system check passed."
else
  fail "Django system check failed."
fi
log ""

# ── Check 2: PostgreSQL log_statement ─────────────────────────────────────────
bold "2. PostgreSQL log_statement"
PG_USER="${POSTGRES_USER:-$(grep -E '^POSTGRES_USER=' "$ENV_FILE" | cut -d= -f2- || true)}"
PG_USER="${PG_USER:-{{PROJECT_SLUG}}}"
PG_DB="${POSTGRES_DB:-$(grep -E '^POSTGRES_DB=' "$ENV_FILE" | cut -d= -f2- || true)}"
PG_DB="${PG_DB:-{{PROJECT_SLUG}}_dev}"
LOG_STMT=$("${DC[@]}" exec -T db \
  psql -U "$PG_USER" -d "$PG_DB" -tAc "SHOW log_statement;")

if [[ "$LOG_STMT" == "none" ]]; then
  pass "log_statement = none"
else
  fail "log_statement = '$LOG_STMT' (expected 'none'). Check postgresql.dev.conf is mounted."
fi
log ""

bold "✓ All security checks passed."
