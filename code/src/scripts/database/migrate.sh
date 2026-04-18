#!/usr/bin/env bash
#
# migrate.sh — Django migration management via the backend container.
#
# Usage:
#   migrate.sh run   [--app APP]
#   migrate.sh make  [--app APP] [--name NAME] [--empty]
#   migrate.sh show  [--app APP]
#   migrate.sh check
#   migrate.sh fake  --migration MIGRATION [--app APP]
#   migrate.sh fake-initial
#   migrate.sh --help
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'migrate.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
migrate.sh — Django migration management via the backend container

Usage:
  migrate.sh run                   Apply all pending migrations
  migrate.sh make                  Create migrations for all apps
  migrate.sh show                  Show migration status for all apps
  migrate.sh check                 Exit non-zero if any migrations are pending
  migrate.sh fake                  Mark migrations as applied without running SQL
  migrate.sh fake-initial          Fake initial migrations for pre-existing tables

Options (run, make, show, fake):
  --app APP          Restrict to a single Django app

Options (make):
  --name NAME        Custom migration name
  --empty            Create an empty migration (for data migrations)

Options (fake):
  --migration NAME   Migration name to fake (e.g. 0003_add_slug)
                     Omit to fake the latest migration for the app.

Examples:
  migrate.sh run
  migrate.sh run --app users
  migrate.sh make --app content --name add_slug_field
  migrate.sh make --empty --app users --name populate_usernames
  migrate.sh show --app core
  migrate.sh check
  migrate.sh fake --app users --migration 0002_alter_user
  migrate.sh fake-initial

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

container_running() {
  cd "$PROJECT_ROOT"
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null \
    | grep -q "[[:space:]]backend[[:space:]]" || \
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null \
    | grep -qi "backend"
}

manage() {
  docker compose -f "$COMPOSE_FILE" exec -T backend python manage.py "$@"
}

# ── Command ───────────────────────────────────────────────────────────────────
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  run|make|show|check|fake|fake-initial) ;;
  --help|-h) usage; exit 0 ;;
  "")        die "No command given. Use --help for usage." ;;
  *)         die "Unknown command '$COMMAND'. Use --help for usage." ;;
esac

# ── Per-command flag parsing ──────────────────────────────────────────────────
APP=""
MIGRATION_NAME=""
MAKE_NAME=""
EMPTY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app)        require_arg "$@"; APP="$2"; shift 2 ;;
    --name)       require_arg "$@"; MAKE_NAME="$2"; shift 2 ;;
    --migration)  require_arg "$@"; MIGRATION_NAME="$2"; shift 2 ;;
    --empty)      EMPTY=true; shift ;;
    --help|-h)    usage; exit 0 ;;
    *)            die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"
container_running || die "backend container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  run)
    bold "▸ migrate.sh run${APP:+ — $APP}"
    log ""
    if [[ -n "$APP" ]]; then
      manage migrate "$APP"
    else
      manage migrate
    fi
    log ""
    bold "✓ Migrations applied."
    ;;

  make)
    bold "▸ migrate.sh make${APP:+ — $APP}"
    log ""
    declare -a make_args=(makemigrations)
    [[ -n "$APP" ]]       && make_args+=("$APP")
    [[ -n "$MAKE_NAME" ]] && make_args+=(--name "$MAKE_NAME")
    $EMPTY                && make_args+=(--empty)
    manage "${make_args[@]}"
    log ""
    bold "✓ Migration files created."
    ;;

  show)
    bold "▸ migrate.sh show${APP:+ — $APP}"
    log ""
    if [[ -n "$APP" ]]; then
      manage showmigrations "$APP"
    else
      manage showmigrations
    fi
    ;;

  check)
    bold "▸ migrate.sh check"
    log ""
    manage migrate --check
    log ""
    bold "✓ No pending migrations."
    ;;

  fake)
    [[ -z "$APP" ]] && die "fake requires --app APP"
    bold "▸ migrate.sh fake — $APP${MIGRATION_NAME:+ $MIGRATION_NAME}"
    log ""
    declare -a fake_args=(migrate --fake "$APP")
    [[ -n "$MIGRATION_NAME" ]] && fake_args+=("$MIGRATION_NAME")
    manage "${fake_args[@]}"
    log ""
    bold "✓ Migration(s) marked as applied."
    ;;

  fake-initial)
    bold "▸ migrate.sh fake-initial"
    log ""
    manage migrate --fake-initial
    log ""
    bold "✓ Initial migrations faked."
    ;;
esac
