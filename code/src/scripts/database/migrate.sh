#!/usr/bin/env bash
#
# migrate.sh — Django migration management via the django container.
#
# Usage:
#   migrate.sh run          [--database DB] [--app APP]
#   migrate.sh make         [--app APP] [--name NAME] [--empty]
#   migrate.sh show         [--database DB] [--app APP]
#   migrate.sh check        [--database DB]
#   migrate.sh fake         [--database DB] --migration MIGRATION [--app APP]
#   migrate.sh fake-initial [--database DB]
#   migrate.sh --help
#
# Use --database DB only when the project defines more than one DATABASES entry.
# Omit --database to target the default database (the baseline has one).
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

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'migrate.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
migrate.sh — Django migration management via the django container

Usage:
  migrate.sh run                   Apply all pending migrations
  migrate.sh make                  Create migrations for all apps
  migrate.sh show                  Show migration status for all apps
  migrate.sh check                 Exit non-zero if any migrations are pending
  migrate.sh fake                  Mark migrations as applied without running SQL
  migrate.sh fake-initial          Fake initial migrations for pre-existing tables

Options (run, show, check, fake, fake-initial):
  --database DB      Target a non-default DATABASES alias.
                     Omit to use the default database (the baseline has one).

Options (run, make, show, fake):
  --app APP          Restrict to a single Django app

Options (make):
  --name NAME        Custom migration name
  --empty            Create an empty migration (for data migrations)

Options (fake):
  --migration NAME   Migration name to fake (e.g. 0003_add_slug)
                     Omit to fake the latest migration for the app.

Examples (<app> is a package under code/src/django/apps/):
  migrate.sh run
  migrate.sh run --app <app>
  migrate.sh make --app <app> --name add_slug_field
  migrate.sh make --empty --app <app> --name backfill_slugs
  migrate.sh show --app <app>
  migrate.sh check
  migrate.sh fake --app <app> --migration 0002_add_slug
  migrate.sh fake-initial

  # Only if the project has added a second database entry to DATABASES:
  migrate.sh run --database <alias>
  migrate.sh check --database <alias>

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# `ps --services` prints service names only, so `grep -qx` is an exact match — a
# substring grep over the full `ps` table also matches image names and other services.
container_running() {
  cd "$PROJECT_ROOT"
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} ps --services --status running 2>/dev/null \
    | grep -qx "django"
}

manage() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} exec -T -w /workspace/code/src/django django python manage.py "$@"
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
DATABASE=""
MIGRATION_NAME=""
MAKE_NAME=""
EMPTY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app)        require_arg "$@"; APP="$2"; shift 2 ;;
    --database)   require_arg "$@"; DATABASE="$2"; shift 2 ;;
    --name)       require_arg "$@"; MAKE_NAME="$2"; shift 2 ;;
    --migration)  require_arg "$@"; MIGRATION_NAME="$2"; shift 2 ;;
    --empty)      EMPTY=true; shift ;;
    --help|-h)    usage; exit 0 ;;
    *)            die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"
container_running || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  run)
    bold "▸ migrate.sh run${DATABASE:+ — db:$DATABASE}${APP:+ — $APP}"
    log ""
    declare -a run_args=(migrate)
    [[ -n "$APP" ]]      && run_args+=("$APP")
    [[ -n "$DATABASE" ]] && run_args+=(--database "$DATABASE")
    manage "${run_args[@]}"
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
    bold "▸ migrate.sh show${DATABASE:+ — db:$DATABASE}${APP:+ — $APP}"
    log ""
    declare -a show_args=(showmigrations)
    [[ -n "$APP" ]]      && show_args+=("$APP")
    [[ -n "$DATABASE" ]] && show_args+=(--database "$DATABASE")
    manage "${show_args[@]}"
    ;;

  check)
    bold "▸ migrate.sh check${DATABASE:+ — db:$DATABASE}"
    log ""
    declare -a check_args=(migrate --check)
    [[ -n "$DATABASE" ]] && check_args+=(--database "$DATABASE")
    manage "${check_args[@]}"
    log ""
    bold "✓ No pending migrations."
    ;;

  fake)
    [[ -z "$APP" ]] && die "fake requires --app APP"
    bold "▸ migrate.sh fake${DATABASE:+ — db:$DATABASE} — $APP${MIGRATION_NAME:+ $MIGRATION_NAME}"
    log ""
    declare -a fake_args=(migrate --fake "$APP")
    [[ -n "$MIGRATION_NAME" ]] && fake_args+=("$MIGRATION_NAME")
    [[ -n "$DATABASE" ]]       && fake_args+=(--database "$DATABASE")
    manage "${fake_args[@]}"
    log ""
    bold "✓ Migration(s) marked as applied."
    ;;

  fake-initial)
    bold "▸ migrate.sh fake-initial${DATABASE:+ — db:$DATABASE}"
    log ""
    declare -a fi_args=(migrate --fake-initial)
    [[ -n "$DATABASE" ]] && fi_args+=(--database "$DATABASE")
    manage "${fi_args[@]}"
    log ""
    bold "✓ Initial migrations faked."
    ;;
esac
