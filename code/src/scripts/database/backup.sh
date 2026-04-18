#!/usr/bin/env bash
#
# backup.sh — Create a pg_dump backup of the development database.
#
# Usage: backup.sh [--output-dir DIR] [--format custom|plain] [--help]
#
# Default output: code/src/scripts/database/reports/backup-YYYY-MM-DDTHH-MM-SSZ.<ext>
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/database/reports"

DB_NAME="${POSTGRES_DB:-syntek_website_dev}"
DB_USER="${POSTGRES_USER:-postgres}"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_DIR="$REPORTS_DIR"
FORMAT="custom"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'backup.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
backup.sh — Create a pg_dump backup of the development database

Usage:
  backup.sh                        Backup to default output directory
  backup.sh --output-dir /tmp      Write backup to a custom directory
  backup.sh --format plain         Use plain-SQL format instead of custom

Options:
  --output-dir DIR    Directory to write the backup file (default: database/reports/)
  --format FORMAT     pg_dump format: custom (default) | plain
                        custom → .dump  (requires pg_restore to restore)
                        plain  → .sql   (can be piped directly to psql)

Environment:
  POSTGRES_DB    Database name (default: syntek_website_dev)
  POSTGRES_USER  Database user (default: postgres)

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir)  require_arg "$@"; OUTPUT_DIR="$2"; shift 2 ;;
    --format)      require_arg "$@"; FORMAT="$2"; shift 2 ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

case "$FORMAT" in
  custom|plain) ;;
  *) die "Invalid --format '$FORMAT'. Choose: custom plain" ;;
esac

cd "$PROJECT_ROOT"

docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "db" \
  || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H-%M-%SZ')
EXT="$([[ "$FORMAT" == "custom" ]] && echo "dump" || echo "sql")"
OUTPUT_FILE="$OUTPUT_DIR/backup-${TIMESTAMP}.${EXT}"

# ── Backup ────────────────────────────────────────────────────────────────────
bold "▸ backup.sh — $DB_NAME → $OUTPUT_FILE"
log "  format: $FORMAT"
log ""

if [[ "$FORMAT" == "custom" ]]; then
  docker compose -f "$COMPOSE_FILE" exec -T db \
    pg_dump -U "$DB_USER" -F c "$DB_NAME" > "$OUTPUT_FILE"
else
  docker compose -f "$COMPOSE_FILE" exec -T db \
    pg_dump -U "$DB_USER" -F p "$DB_NAME" > "$OUTPUT_FILE"
fi

SIZE=$(du -sh "$OUTPUT_FILE" | cut -f1)
log ""
bold "✓ Backup complete."
log "  File:   $OUTPUT_FILE"
log "  Size:   $SIZE"
log ""
log "  Restore with:"
if [[ "$FORMAT" == "custom" ]]; then
  log "    bash code/src/scripts/database/restore.sh $OUTPUT_FILE"
else
  log "    bash code/src/scripts/database/restore.sh --format plain $OUTPUT_FILE"
fi
