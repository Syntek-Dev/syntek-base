#!/usr/bin/env bash
#
# restore.sh — Restore the development database from a pg_dump backup file.
#              ⚠  DESTRUCTIVE — replaces the current database content.
#
# Usage: restore.sh <backup-file> [--format custom|plain] [--yes] [--force-posture POSTURE] [--help]
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#              4 = refused by the posture guard (_lib/posture-guard.sh)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"
# shellcheck source=code/src/scripts/_lib/posture-guard.sh
source "$SCRIPT_DIR/../_lib/posture-guard.sh"
# The compose array is built only after the posture guard has validated and pinned the Docker
# target (below), so not even the container preflight can reach a different daemon.
ORIG_ARGS=("$@")

if [[ -f "$ENV_FILE" ]]; then
  DB_NAME="${POSTGRES_DB:-$(grep -E '^POSTGRES_DB='   "$ENV_FILE" | cut -d= -f2- || true)}"
  DB_USER="${POSTGRES_USER:-$(grep -E '^POSTGRES_USER=' "$ENV_FILE" | cut -d= -f2- || true)}"
fi
DB_NAME="${DB_NAME:-<%PROJECT_SLUG%>_dev}"
DB_USER="${DB_USER:-<%PROJECT_SLUG%>}"

# ── Defaults ──────────────────────────────────────────────────────────────────
BACKUP_FILE=""
FORMAT="custom"
YES=false
FORCE_POSTURE=""

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
  --yes            Skip confirmation prompt (ignored above development)
  --force-posture POSTURE
                   Run above development, naming the posture the project is at now
                   (staging or production). Without it the posture guard refuses.

Environment:
  POSTGRES_DB    Database name (default: <%PROJECT_SLUG%>_dev)
  POSTGRES_USER  Database user (default: <%PROJECT_SLUG%>)

Exit codes:  0 = success   1 = command failed   2 = script error
             4 = refused by the posture guard (posture-guard: refused —)
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --format)   require_arg "$@"; FORMAT="$2"; shift 2 ;;
    --yes)      YES=true; shift ;;
    --force-posture) require_arg "$@"; FORCE_POSTURE="$2"; shift 2 ;;
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

# ── Posture guard ─────────────────────────────────────────────────────────────
# Above the container preflight, so a refusal is what the operator sees even with the stack
# down. A refusal ends the run at 4; a permit pins every Docker call below to the one target
# the guard validated.
COMPOSE_NAME="$(posture_compose_name "$COMPOSE_FILE" "$OVERRIDE_DEV_FILE")"
posture_guard "$PROJECT_ROOT" refuse "$FORCE_POSTURE" "$COMPOSE_NAME" \
  bash code/src/scripts/database/restore.sh "${ORIG_ARGS[@]}" || exit "$?"
posture_docker_bind || exit "$?"
DOCKER=("${posture_docker[@]}")
DC=("${DOCKER[@]}" compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

# --yes is a convenience, not an authorisation: above development the prompt always runs.
if $YES && posture_above_development; then
  warn "  --yes is ignored at '$posture_resolved' — confirm at the prompt."
  YES=false
fi

"${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "db" \
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
  REPLY=""
  read -r REPLY || true
  if [[ "$REPLY" != "yes" ]]; then
    # Nothing read (no terminal, nothing piped): above development that is a refusal at 4,
    # never an abort at 0 that a scripted caller would read as success.
    [[ -n "$REPLY" ]] || posture_unconfirmed || exit "$?"
    log "  Aborted."; exit 0
  fi
  log ""
fi

# ── Restore ───────────────────────────────────────────────────────────────────
bold "  Dropping and recreating '$DB_NAME'…"
"${DC[@]}" exec -T db \
  psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS \"$DB_NAME\";" postgres
"${DC[@]}" exec -T db \
  psql -U "$DB_USER" -c "CREATE DATABASE \"$DB_NAME\";" postgres
log ""

bold "  Restoring from backup…"
if [[ "$FORMAT" == "custom" ]]; then
  "${DC[@]}" exec -T db \
    pg_restore -U "$DB_USER" -d "$DB_NAME" --no-owner --role "$DB_USER" < "$BACKUP_FILE"
else
  "${DC[@]}" exec -T db \
    psql -U "$DB_USER" -d "$DB_NAME" < "$BACKUP_FILE"
fi

log ""
bold "✓ Restore complete."
log "  Database '$DB_NAME' restored from $(basename "$BACKUP_FILE")."
