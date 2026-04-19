#!/usr/bin/env bash
#
# manageusers.sh — Create or promote Django users via the backend container.
#
# Usage:
#   manageusers.sh create-superuser
#   manageusers.sh create-staff  --email EMAIL --username USERNAME [--password PASSWORD]
#   manageusers.sh promote       --email EMAIL [--superuser]
#   manageusers.sh --help
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'manageusers.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
manageusers.sh — Create or promote Django users via the backend container

Usage:
  manageusers.sh create-superuser               Interactive superuser creation (Django prompt)
  manageusers.sh create-staff                   Create a staff (non-superuser) account
  manageusers.sh promote                        Grant staff or superuser flag to an existing user

Options (create-staff):
  --email EMAIL          User email address (required)
  --username USERNAME    Username (required)
  --password PASSWORD    Password (prompted interactively if omitted)

Options (promote):
  --email EMAIL          Email of the existing user to promote (required)
  --superuser            Grant superuser in addition to staff (optional)

Examples:
  manageusers.sh create-superuser
  manageusers.sh create-staff --email jane@example.com --username jane
  manageusers.sh create-staff --email jane@example.com --username jane --password s3cret
  manageusers.sh promote --email jane@example.com
  manageusers.sh promote --email jane@example.com --superuser

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

container_running() {
  cd "$PROJECT_ROOT"
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "backend"
}

manage() {
  docker compose -f "$COMPOSE_FILE" exec backend python manage.py "$@"
}

# ── Command ───────────────────────────────────────────────────────────────────
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  create-superuser|create-staff|promote) ;;
  --help|-h) usage; exit 0 ;;
  "")        die "No command given. Use --help for usage." ;;
  *)         die "Unknown command '$COMMAND'. Use --help for usage." ;;
esac

# ── Per-command flag parsing ──────────────────────────────────────────────────
EMAIL=""
USERNAME=""
PASSWORD=""
GRANT_SUPERUSER=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --email)       require_arg "$@"; EMAIL="$2"; shift 2 ;;
    --username)    require_arg "$@"; USERNAME="$2"; shift 2 ;;
    --password)    require_arg "$@"; PASSWORD="$2"; shift 2 ;;
    --superuser)   GRANT_SUPERUSER=true; shift ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

container_running || die "backend container is not running. Start with: ./code/src/scripts/development/server.sh up"

cd "$PROJECT_ROOT"

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  create-superuser)
    bold "▸ manageusers.sh create-superuser"
    log ""
    docker compose -f "$COMPOSE_FILE" exec -it backend python manage.py createsuperuser
    log ""
    bold "✓ Superuser created."
    ;;

  create-staff)
    [[ -z "$EMAIL" ]]    && die "create-staff requires --email EMAIL"
    [[ -z "$USERNAME" ]] && die "create-staff requires --username USERNAME"
    bold "▸ manageusers.sh create-staff — $EMAIL"
    log ""
    if [[ -n "$PASSWORD" ]]; then
      manage shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if User.objects.filter(email='$EMAIL').exists():
    raise SystemExit('User with email $EMAIL already exists.')
User.objects.create_user(username='$USERNAME', email='$EMAIL', password='$PASSWORD', is_staff=True)
print('Staff user created.')
"
    else
      manage createsuperuser --no-superuser --email "$EMAIL" --username "$USERNAME" 2>/dev/null \
        || manage shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if User.objects.filter(email='$EMAIL').exists():
    raise SystemExit('User with email $EMAIL already exists.')
u = User.objects.create_user(username='$USERNAME', email='$EMAIL', is_staff=True)
u.set_unusable_password()
u.save()
print('Staff user created (no password set — use the admin to set one).')
"
    fi
    log ""
    bold "✓ Staff user $EMAIL created."
    ;;

  promote)
    [[ -z "$EMAIL" ]] && die "promote requires --email EMAIL"
    bold "▸ manageusers.sh promote — $EMAIL${GRANT_SUPERUSER:+ (superuser)}"
    log ""
    if $GRANT_SUPERUSER; then
      manage shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
u = User.objects.get(email='$EMAIL')
u.is_staff = True
u.is_superuser = True
u.save()
print('Promoted to superuser.')
"
    else
      manage shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
u = User.objects.get(email='$EMAIL')
u.is_staff = True
u.save()
print('Promoted to staff.')
"
    fi
    log ""
    $GRANT_SUPERUSER \
      && bold "✓ $EMAIL promoted to superuser." \
      || bold "✓ $EMAIL promoted to staff."
    ;;
esac
