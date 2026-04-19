#!/usr/bin/env bash
#
# reset.sh — Drop and recreate the development database, then run all migrations.
#            ⚠  DESTRUCTIVE — irreversibly destroys all dev data.
#
# Usage: reset.sh [--seed] [--yes] [--help]
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

DB_NAME="${POSTGRES_DB:-project_name_dev}"
DB_USER="${POSTGRES_USER:-postgres}"

# ── Defaults ──────────────────────────────────────────────────────────────────
SEED=false
YES=false

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'reset.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
warn() { printf '\033[33m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
reset.sh — Drop and recreate the development database

⚠  DESTRUCTIVE — irreversibly destroys all data in the development database.

Usage:
  reset.sh             Drop DB, recreate, run all migrations
  reset.sh --seed      Also load initial fixtures after migrating
  reset.sh --yes       Skip confirmation prompt (for scripted use)

Environment:
  POSTGRES_DB    Database name (default: project_name_dev)
  POSTGRES_USER  Database user (default: postgres)

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --seed)     SEED=true; shift ;;
    --yes)      YES=true; shift ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# Check containers
docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "backend" \
  || die "backend container is not running. Start with: bash code/src/scripts/development/server.sh up"
docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "db" \
  || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Confirmation ──────────────────────────────────────────────────────────────
bold "▸ reset.sh"
log ""
warn "  ⚠  This will PERMANENTLY DELETE all data in '$DB_NAME'."
log "  Services: backend + db"
log ""

if ! $YES; then
  printf '  Type "yes" to continue: '
  read -r REPLY
  [[ "$REPLY" == "yes" ]] || { log "  Aborted."; exit 0; }
  log ""
fi

# ── Reset ─────────────────────────────────────────────────────────────────────
bold "  Dropping database '$DB_NAME'…"
docker compose -f "$COMPOSE_FILE" exec -T db \
  psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" postgres
docker compose -f "$COMPOSE_FILE" exec -T db \
  psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" postgres
log ""

bold "  Running migrations…"
docker compose -f "$COMPOSE_FILE" exec -T backend python manage.py migrate
log ""

if $SEED; then
  bold "  Loading fixtures…"
  docker compose -f "$COMPOSE_FILE" exec -T backend python manage.py loaddata initial_data \
    2>/dev/null \
    || { log "  ⚠  No fixtures found (initial_data). Skipping seed."; }
  log ""
fi

bold "✓ Database reset complete."
$SEED && log "  Seed data loaded." || true
