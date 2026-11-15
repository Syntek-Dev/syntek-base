#!/usr/bin/env bash
#
# seed-dev.sh — Load seed data into the development environment.
#               Creates dev user accounts (superuser + staff) from .env.dev, then runs
#               whatever project seed commands SEED_COMMANDS names — none at baseline.
#               Bound by the posture guard: above development it refuses unless
#               --force-posture names the posture the project is at now.
#
# Usage: seed-dev.sh [--force-posture POSTURE] [--help]
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
# shellcheck source=code/src/scripts/_lib/env-file.sh
source "$SCRIPT_DIR/../_lib/env-file.sh"
# shellcheck source=code/src/scripts/_lib/posture-guard.sh
source "$SCRIPT_DIR/../_lib/posture-guard.sh"
# The compose array is built only after the posture guard has validated and pinned the Docker
# target (below), so not even the container preflight can reach a different daemon.
ORIG_ARGS=("$@")
FORCE_POSTURE=""

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'seed-dev.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

usage() {
  cat <<'EOF'
seed-dev.sh — Load seed data into the development environment

Idempotently seeds the dev user accounts (superuser + staff), then runs each
management command named in SEED_COMMANDS. Safe to run multiple times.

Usage:
  seed-dev.sh            Seed dev users, then any project seed commands
  seed-dev.sh --force-posture POSTURE
                         Run above development, naming the posture the project is at
                         now (staging or production). Without it the guard refuses.
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
                              The file's line wins whenever it exists, even empty;
                              the shell's is used only when the file has none.

Prerequisites:
  The development stack must be running:
    bash code/src/scripts/development/server.sh up

Notes:
  - Users are upserted first (created, or password + flags synced) so dev login
    always matches .env.dev, and later seeds can attribute records to them.
  - Credentials are parsed from .env.dev (never sourced), so quoted values are handled
    correctly; only the keys above are read, and none is ever printed.
  - Missing user credentials are skipped with a warning, not an error.
  - A failed user upsert, or a SEED_COMMANDS entry that fails (an unregistered
    command included), stops the run at exit 1 — a silent skip would hide a typo
    in the seed chain. The failure is named by position or exception class only;
    its stderr is withheld because it can quote a value from .env.dev.

Exit codes:  0 = success   1 = command failed   2 = script error
             4 = refused by the posture guard (posture-guard: refused —)
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
# --force-posture is parsed ahead of the unknown-option die: server.sh up --seed forwards it,
# and a forwarded override must arrive as an override, not as a script error.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force-posture) require_arg "$@"; FORCE_POSTURE="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# ── Posture guard ─────────────────────────────────────────────────────────────
# Before the first Docker call, preflight included. Run from server.sh up --seed this sees the
# parent's validated socket as DOCKER_HOST, with DOCKER_CONTEXT cleared, and validates it again.
COMPOSE_NAME="$(posture_compose_name "$COMPOSE_FILE" "$OVERRIDE_DEV_FILE")"
posture_guard "$PROJECT_ROOT" refuse "$FORCE_POSTURE" "$COMPOSE_NAME" "$ENV_FILE" \
  bash code/src/scripts/database/seed-dev.sh "${ORIG_ARGS[@]}" || exit "$?"
posture_docker_bind || exit "$?"
DOCKER=("${posture_docker[@]}")
DC=("${DOCKER[@]}" compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

# `ps --services` prints service names only, so `grep -qx` matches exactly.
"${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "django" \
  || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"

bold "▸ seed-dev.sh"
log ""

# ── Step 1: Dev users (superuser + staff) ─────────────────────────────────────
# Credentials are PARSED from .env.dev by _lib/env-file.sh, which strips quoted values the
# same way docker compose does — a naive grep|cut keeps surrounding quotes and bakes them
# into the password. It replaced a `set -a; source`, which stripped quotes correctly but
# executed the file: one value carrying a shell metacharacter aborted the source partway
# and left every later credential unset, silently. Values are injected into the container
# via -e (compose --env-file only substitutes YAML vars).
#
# Only the seven keys this script uses are read, one by one — never the whole file exported,
# which would put SECRET_KEY and POSTGRES_PASSWORD into every child's environment. And no
# value is ever printed: an AI may run this script (directly, or through server.sh up --seed),
# so the output names keys only, and a failure's stderr — a database error can quote the
# username or email it rejected — is reduced to the exception's class name.
bold "  Seeding dev users…"

_su_user="$(env_value DJANGO_SUPERUSER_USERNAME "$ENV_FILE")"
_su_email="$(env_value DJANGO_SUPERUSER_EMAIL "$ENV_FILE")"
_su_pass="$(env_value DJANGO_SUPERUSER_PASSWORD "$ENV_FILE")"
_st_user="$(env_value SEED_STAFF_USERNAME "$ENV_FILE")"
_st_email="$(env_value SEED_STAFF_EMAIL "$ENV_FILE")"
_st_pass="$(env_value SEED_STAFF_PASSWORD "$ENV_FILE")"
# The file's SEED_COMMANDS wins over the shell's whenever the file sets the key — an empty
# `SEED_COMMANDS=` included, which means "none" exactly as it did when the file was exported
# whole. Only a file with no SEED_COMMANDS line at all falls back to the shell's.
if env_has SEED_COMMANDS "$ENV_FILE"; then
  SEED_COMMANDS="$(env_value SEED_COMMANDS "$ENV_FILE")"
fi
SEED_COMMANDS="${SEED_COMMANDS:-}"

_seed_err="$(mktemp)"
trap 'rm -f -- "${_seed_err:-}"' EXIT
if ! "${DC[@]}" exec -T \
  -e SU_USER="$_su_user" \
  -e SU_EMAIL="$_su_email" \
  -e SU_PASS="$_su_pass" \
  -e ST_USER="$_st_user" \
  -e ST_EMAIL="$_st_email" \
  -e ST_PASS="$_st_pass" \
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
    print(f'  ✓  {label} {action} (is_staff=True, is_superuser={obj.is_superuser}).')

ensure('Superuser', os.environ.get('SU_USER', ''), os.environ.get('SU_EMAIL', ''), os.environ.get('SU_PASS', ''), True)
ensure('Staff user', os.environ.get('ST_USER', ''), os.environ.get('ST_EMAIL', ''), os.environ.get('ST_PASS', ''), False)
" 2>"$_seed_err"; then
  # The exception's class only (e.g. IntegrityError); its message can quote an account value.
  _exc="$(sed -nE 's/^([A-Za-z_][A-Za-z0-9_.]*(Error|Exception))(:.*)?$/\1/p' "$_seed_err" | tail -n 1)"
  # A failed upsert is a failed run: exit 1, never on to the seed commands nor to the success line.
  printf '  ✗  Dev user seeding failed: %s.\n' "${_exc:-no exception named}" >&2
  printf '     Details are withheld because they can quote an account value from .env.dev.\n' >&2
  exit 1
fi
unset _su_user _su_email _su_pass _st_user _st_email _st_pass _exc
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
    # The entry's position, not its text: the list is a value from .env.dev.
    bold "  ${_n}/${_total}  SEED_COMMANDS entry ${_n}…"
    # Its stderr is captured, never shown: Django's own rejection quotes the entry
    # (`Unknown command: '<entry>'`), and the entry is a value from .env.dev. A failure names
    # the position and stops the run at exit 1 — later entries may depend on this one.
    if ! "${DC[@]}" exec -T -w /workspace/code/src/django django python manage.py "$_cmd" 2>"$_seed_err"; then
      printf '  ✗  SEED_COMMANDS entry %s failed.\n' "$_n" >&2
      printf '     Details are withheld because they can quote a value from .env.dev; run the\n' >&2
      printf '     command yourself in a developer shell to see them.\n' >&2
      exit 1
    fi
    log ""
  done
  unset _total _n _cmd
fi
unset _seed_cmds

bold "✓ Seed complete."
log ""
# Key names, never values: the developer reads the file, the output never quotes it.
log "  Dev accounts: credentials in .env.dev (DJANGO_SUPERUSER_*, SEED_STAFF_*)"
