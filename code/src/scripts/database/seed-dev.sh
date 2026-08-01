#!/usr/bin/env bash
#
# seed-dev.sh — Load seed data for dev and staging environments.
#               Creates dev user accounts (superuser + staff) from .env.dev, then runs
#               whatever project seed commands SEED_COMMANDS names — none at baseline.
#
# Usage: seed-dev.sh [--help]
#
# Exit codes:  0 = success   1 = command failed   2 = script error
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

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'seed-dev.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
seed-dev.sh — Load seed data for dev and staging environments

Idempotently seeds the dev user accounts (superuser + staff), then runs each
management command named in SEED_COMMANDS. Safe to run multiple times.

Usage:
  seed-dev.sh            Seed dev users, then any project seed commands
  seed-dev.sh --help     Show this help

Environment (read from .env.dev):
  DJANGO_SUPERUSER_USERNAME   Superuser username
  DJANGO_SUPERUSER_EMAIL      Superuser email
  DJANGO_SUPERUSER_PASSWORD   Superuser password
  SEED_STAFF_USERNAME         Staff user username
  SEED_STAFF_EMAIL            Staff user email
  SEED_STAFF_PASSWORD         Staff user password
  SEED_COMMANDS               Space-separated manage.py commands to run after the
                              users, in dependency order. Empty at baseline.
                              e.g. SEED_COMMANDS="seed_tags seed_articles"

Prerequisites:
  The development stack must be running:
    bash code/src/scripts/development/server.sh up

Notes:
  - Users are upserted first (created, or password + flags synced) so dev login
    always matches .env.dev, and later seeds can attribute records to them.
  - Credentials are sourced from .env.dev, so quoted values are handled correctly.
  - Missing user credentials are skipped with a warning, not an error.
  - A SEED_COMMANDS entry that is not a registered management command is a hard
    failure — a silent skip would hide a typo in the seed chain.

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage; exit 0 ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# `ps --services` prints service names only, so `grep -qx` matches exactly.
"${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "django" \
  || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"

bold "▸ seed-dev.sh"
log ""

# ── Step 1: Dev users (superuser + staff) ─────────────────────────────────────
# Credentials are sourced from .env.dev (set -a) so quoted values are stripped
# the same way docker compose and shell.sh interpret them — a naive grep|cut
# keeps surrounding quotes and bakes them into the password. Values are injected
# into the container via -e (compose --env-file only substitutes YAML vars).
bold "  Seeding dev users…"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$ENV_FILE"
  set +a
fi

"${DC[@]}" exec -T \
  -e SU_USER="${DJANGO_SUPERUSER_USERNAME:-}" \
  -e SU_EMAIL="${DJANGO_SUPERUSER_EMAIL:-}" \
  -e SU_PASS="${DJANGO_SUPERUSER_PASSWORD:-}" \
  -e ST_USER="${SEED_STAFF_USERNAME:-}" \
  -e ST_EMAIL="${SEED_STAFF_EMAIL:-}" \
  -e ST_PASS="${SEED_STAFF_PASSWORD:-}" \
  -w /workspace/code/src/django django \
  python manage.py shell --verbosity 0 -c "
import os
from django.contrib.auth import get_user_model
User = get_user_model()

def ensure(label, username, email, password, superuser):
    if not (username and email and password):
        print(f'  ⚠  {label}: credentials not set in .env.dev — skipping.')
        return
    # Idempotent upsert keyed on username (USERNAME_FIELD): create if absent,
    # otherwise sync password + flags so dev login always matches .env.dev.
    obj, created = User.objects.get_or_create(username=username, defaults={'email': email})
    obj.email = email
    obj.is_active = True
    obj.is_staff = True
    if superuser:
        obj.is_superuser = True
    obj.set_password(password)
    obj.save()
    action = 'created' if created else 'updated'
    print(f'  ✓  {label} {username} {action} (is_staff=True, is_superuser={obj.is_superuser}).')

ensure('Superuser', os.environ.get('SU_USER', ''), os.environ.get('SU_EMAIL', ''), os.environ.get('SU_PASS', ''), True)
ensure('Staff user', os.environ.get('ST_USER', ''), os.environ.get('ST_EMAIL', ''), os.environ.get('ST_PASS', ''), False)
" \
  || log "  ⚠  Dev user seeding failed (see error above)."
log ""

# ── Step 2: Project seed commands ─────────────────────────────────────────────
# The baseline Django project has no apps, so it registers no seed commands. A
# project adds its own `manage.py seed_*` commands and lists them here, in
# dependency order, rather than editing this script.
read -r -a _seed_cmds <<< "${SEED_COMMANDS:-}"

if [[ ${#_seed_cmds[@]} -eq 0 ]]; then
  bold "  Project seed commands: none"
  log "  Set SEED_COMMANDS in .env.dev once the project has seed commands to run,"
  log "  e.g. SEED_COMMANDS=\"seed_tags seed_articles\"."
  log ""
else
  _total=${#_seed_cmds[@]}
  _n=0
  for _cmd in "${_seed_cmds[@]}"; do
    _n=$((_n + 1))
    bold "  ${_n}/${_total}  ${_cmd}…"
    "${DC[@]}" exec -T -w /workspace/code/src/django django python manage.py "$_cmd"
    log ""
  done
  unset _total _n _cmd
fi
unset _seed_cmds

bold "✓ Seed complete."
log ""
log "  Dev accounts (passwords in .env.dev):"
log "    Superuser  ${DJANGO_SUPERUSER_USERNAME:-—} / ${DJANGO_SUPERUSER_EMAIL:-not set}"
log "    Staff      ${SEED_STAFF_USERNAME:-—} / ${SEED_STAFF_EMAIL:-not set}"
