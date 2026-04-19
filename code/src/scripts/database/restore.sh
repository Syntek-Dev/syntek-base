#!/usr/bin/env bash
#
# restore.sh — Restore the development database from a pg_dump backup file.
#              ⚠  DESTRUCTIVE — replaces the current database content.
#
# Usage: restore.sh <backup-file> [--format custom|plain] [--yes] [--help]
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
BACKUP_FILE=""
FORMAT="custom"
YES=false

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'restore.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
warn() { printf '\033[33m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
restore.sh — Restore the development database from a pg_dump backup

⚠  DESTRUCTIVE — drops and recreates the database before restoring.

Usage:
  restore.sh <backup-file>                   Restore a custom-format backup
  restore.sh <backup-file> --format plain    Restore a plain-SQL backup
  restore.sh <backup-file> --yes             Skip confirmation prompt

Arguments:
  <backup-file>    Path to the backup file produced by backup.sh

Options:
  --format FORMAT  Format of the backup file: custom (default) | plain
  --yes            Skip confirmation prompt

Environment:
  POSTGRES_DB    Database name (default: project_name_dev)
  POSTGRES_USER  Database user (default: postgres)

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --format)   require_arg "$@"; FORMAT="$2"; shift 2 ;;
    --yes)      YES=true; shift ;;
    --help|-h)  usage; exit 0 ;;
    -*)         die "Unknown option '$1'. Use --help for usage." ;;
    *)          [[ -z "$BACKUP_FILE" ]] && BACKUP_FILE="$1" || die "Unexpected argument '$1'"; shift ;;
  esac
done

[[ -z "$BACKUP_FILE" ]] && die "No backup file specified. Usage: restore.sh <backup-file>"
[[ -f "$BACKUP_FILE" ]] || die "Backup file not found: $BACKUP_FILE"

case "$FORMAT" in
  custom|plain) ;;
  *) die "Invalid --format '$FORMAT'. Choose: custom plain" ;;
esac

cd "$PROJECT_ROOT"

docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "db" \
  || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Confirmation ──────────────────────────────────────────────────────────────
bold "▸ restore.sh"
log ""
warn "  ⚠  This will PERMANENTLY REPLACE all data in '$DB_NAME'."
log "  Backup: $BACKUP_FILE"
log "  Format: $FORMAT"
log ""

if ! $YES; then
  printf '  Type "yes" to continue: '
  read -r REPLY
  [[ "$REPLY" == "yes" ]] || { log "  Aborted."; exit 0; }
  log ""
fi

# ── Restore ───────────────────────────────────────────────────────────────────
bold "  Dropping and recreating '$DB_NAME'…"
docker compose -f "$COMPOSE_FILE" exec -T db \
  psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" postgres
docker compose -f "$COMPOSE_FILE" exec -T db \
  psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" postgres
log ""

bold "  Restoring from backup…"
if [[ "$FORMAT" == "custom" ]]; then
  docker compose -f "$COMPOSE_FILE" exec -T db \
    pg_restore -U "$DB_USER" -d "$DB_NAME" --no-owner --role "$DB_USER" < "$BACKUP_FILE"
else
  docker compose -f "$COMPOSE_FILE" exec -T db \
    psql -U "$DB_USER" -d "$DB_NAME" < "$BACKUP_FILE"
fi

log ""
bold "✓ Restore complete."
log "  Database '$DB_NAME' restored from $(basename "$BACKUP_FILE")."
