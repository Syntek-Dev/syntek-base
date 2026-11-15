#!/usr/bin/env bash
#
# reset.sh — Drop and recreate the development database, then run all migrations.
#            ⚠  DESTRUCTIVE — irreversibly destroys all dev data.
#
# Usage: reset.sh [--seed] [--yes] [--force-posture POSTURE] [--help]
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

# Read DB credentials from env file when not set in the shell environment.
if [[ -f "$ENV_FILE" ]]; then
  DB_NAME="${POSTGRES_DB:-$(grep -E '^POSTGRES_DB=' "$ENV_FILE" | cut -d= -f2- || true)}"
  DB_USER="${POSTGRES_USER:-$(grep -E '^POSTGRES_USER=' "$ENV_FILE" | cut -d= -f2- || true)}"
fi

# The fallback is unconditional, and that is the whole fix: .env.dev carries no
# POSTGRES_DB line at all — docker-compose.dev.yml fixes the name and .env.dev.example
# says so — so the grep above yields an empty string on the path where the env file
# EXISTS. Keeping this inside an `else` made DB_NAME empty in the normal case, and
# `DROP DATABASE IF EXISTS "";` is the error that produced. backup.sh and restore.sh
# already resolve it this way; this script was the odd one out.
DB_NAME="${DB_NAME:-<%PROJECT_SLUG%>_dev}"
DB_USER="${DB_USER:-<%PROJECT_SLUG%>}"

# ── Defaults ──────────────────────────────────────────────────────────────────
SEED=false
YES=false
FORCE_POSTURE=""

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'reset.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
warn() { printf '\033[33m%s\033[0m\n' "$*"; }
require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

usage() {
  cat <<'EOF'
reset.sh — Drop and recreate the development database

⚠  DESTRUCTIVE — irreversibly destroys all data in the development database.

Usage:
  reset.sh             Drop DB, recreate, run all migrations
  reset.sh --seed      Also load fixtures and create dev user accounts
  reset.sh --yes       Skip confirmation prompt (for scripted use; ignored above development)
  reset.sh --force-posture POSTURE
                       Run above development, naming the posture the project is at now
                       (staging or production). Without it the posture guard refuses.

Environment (all read from .env.dev):
  POSTGRES_DB                 Database name (default: <%PROJECT_SLUG%>_dev)
  POSTGRES_USER               Database user (default: <%PROJECT_SLUG%>)
  DJANGO_SUPERUSER_USERNAME   Superuser username  (--seed only)
  DJANGO_SUPERUSER_EMAIL      Superuser email     (--seed only)
  DJANGO_SUPERUSER_PASSWORD   Superuser password  (--seed only)
  SEED_STAFF_USERNAME         Staff user username (--seed only)
  SEED_STAFF_EMAIL            Staff user email    (--seed only)
  SEED_STAFF_PASSWORD         Staff user password (--seed only)

Exit codes:  0 = success   1 = command failed   2 = script error
             4 = refused by the posture guard (posture-guard: refused —)
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --seed)     SEED=true; shift ;;
    --yes)      YES=true; shift ;;
    --force-posture) require_arg "$@"; FORCE_POSTURE="$2"; shift 2 ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# ── Posture guard ─────────────────────────────────────────────────────────────
# Above the container preflight, so a refusal is what the operator sees even with the stack
# down. A refusal ends the run at 4; a permit pins every Docker call below to the one target
# the guard validated.
COMPOSE_NAME="$(posture_compose_name "$COMPOSE_FILE" "$OVERRIDE_DEV_FILE")"
posture_guard "$PROJECT_ROOT" refuse "$FORCE_POSTURE" "$COMPOSE_NAME" \
  bash code/src/scripts/database/reset.sh "${ORIG_ARGS[@]}" || exit "$?"
posture_docker_bind || exit "$?"
DOCKER=("${posture_docker[@]}")
DC=("${DOCKER[@]}" compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

# --yes is a convenience, not an authorisation: above development the prompt always runs.
if $YES && posture_above_development; then
  warn "  --yes is ignored at '$posture_resolved' — confirm at the prompt."
  YES=false
fi

# Check containers. `ps --services` prints service names only, so `grep -qx` matches
# exactly — a substring grep over the full `ps` table also matches image names.
"${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "django" \
  || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"
"${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "db" \
  || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Confirmation ──────────────────────────────────────────────────────────────
bold "▸ reset.sh"
log ""
warn "  ⚠  This will PERMANENTLY DELETE all data in '$DB_NAME'."
log "  Services: django + db"
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

# ── Reset ─────────────────────────────────────────────────────────────────────
bold "  Dropping database '$DB_NAME'…"
"${DC[@]}" exec -T db \
  psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS \"$DB_NAME\";" postgres
"${DC[@]}" exec -T db \
  psql -U "$DB_USER" -c "CREATE DATABASE \"$DB_NAME\";" postgres
log ""

bold "  Running migrations…"
"${DC[@]}" exec -T -w /workspace/code/src/django django python manage.py migrate
log ""

if $SEED; then
  bold "  Loading fixtures…"
  "${DC[@]}" exec -T -w /workspace/code/src/django django python manage.py loaddata initial_data \
    2>/dev/null \
    || { log "  ⚠  No fixtures found (initial_data). Skipping."; }
  log ""

  # Read seed credentials from .env.dev on the host and inject at exec time.
  # docker compose --env-file only substitutes YAML vars — it does not inject
  # arbitrary keys into the container environment, so -e flags are required.
  _su_user="$(grep -E '^DJANGO_SUPERUSER_USERNAME=' "$ENV_FILE" | cut -d= -f2- || true)"
  _su_email="$(grep -E '^DJANGO_SUPERUSER_EMAIL='    "$ENV_FILE" | cut -d= -f2- || true)"
  _su_pass="$(grep -E '^DJANGO_SUPERUSER_PASSWORD='  "$ENV_FILE" | cut -d= -f2- || true)"
  _st_user="$(grep -E '^SEED_STAFF_USERNAME='        "$ENV_FILE" | cut -d= -f2- || true)"
  _st_email="$(grep -E '^SEED_STAFF_EMAIL='          "$ENV_FILE" | cut -d= -f2- || true)"
  _st_pass="$(grep -E '^SEED_STAFF_PASSWORD='        "$ENV_FILE" | cut -d= -f2- || true)"

  bold "  Creating dev users…"
  if [[ -n "$_su_user" && -n "$_su_email" && -n "$_su_pass" ]]; then
    "${DC[@]}" exec -T \
      -e DJANGO_SUPERUSER_USERNAME="$_su_user" \
      -e DJANGO_SUPERUSER_EMAIL="$_su_email" \
      -e DJANGO_SUPERUSER_PASSWORD="$_su_pass" \
      -w /workspace/code/src/django django \
      python manage.py createsuperuser --noinput 2>/dev/null \
      && log "  ✓  Superuser created." \
      || log "  ⚠  Superuser already exists — skipping."
  else
    log "  ⚠  DJANGO_SUPERUSER_* not set in .env.dev — skipping superuser."
  fi

  if [[ -n "$_st_user" && -n "$_st_email" && -n "$_st_pass" ]]; then
    "${DC[@]}" exec -T \
      -e SEED_STAFF_USERNAME="$_st_user" \
      -e SEED_STAFF_EMAIL="$_st_email" \
      -e SEED_STAFF_PASSWORD="$_st_pass" \
      -w /workspace/code/src/django django \
      python manage.py shell --verbosity 0 -c "
import os, sys
from django.contrib.auth import get_user_model
User = get_user_model()
email    = os.environ['SEED_STAFF_EMAIL']
username = os.environ['SEED_STAFF_USERNAME']
password = os.environ['SEED_STAFF_PASSWORD']
if User.objects.filter(email=email).exists():
    print(f'  Staff user {email} already exists — skipping.')
    sys.exit(0)
User.objects.create_user(username=username, email=email, password=password, is_staff=True)
print(f'  Staff user {email} created.')
" 2>/dev/null \
      || log "  ⚠  Staff user creation failed."
  else
    log "  ⚠  SEED_STAFF_* not set in .env.dev — skipping staff user."
  fi

  unset _su_user _su_email _su_pass _st_user _st_email _st_pass
  log ""
fi

bold "✓ Database reset complete."
if $SEED; then
  _su_user="$(grep -E '^DJANGO_SUPERUSER_USERNAME=' "$ENV_FILE" 2>/dev/null | cut -d= -f2-)"
  _su_email="$(grep -E '^DJANGO_SUPERUSER_EMAIL='    "$ENV_FILE" 2>/dev/null | cut -d= -f2-)"
  _st_user="$(grep -E '^SEED_STAFF_USERNAME='        "$ENV_FILE" 2>/dev/null | cut -d= -f2-)"
  _st_email="$(grep -E '^SEED_STAFF_EMAIL='          "$ENV_FILE" 2>/dev/null | cut -d= -f2-)"
  log ""
  log "  Dev accounts (passwords in .env.dev):"
  log "    Superuser  ${_su_user:-superuser} / ${_su_email:-see .env.dev}"
  log "    Staff      ${_st_user:-staffuser} / ${_st_email:-see .env.dev}"
  unset _su_user _su_email _st_user _st_email
fi
