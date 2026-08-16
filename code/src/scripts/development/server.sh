#!/usr/bin/env bash
#
# server.sh — Manage the development Docker Compose stack.
#
# Usage:
#   server.sh up       [--build] [--watch] [--service SERVICE]
#   server.sh down     [--volumes]
#   server.sh restart  [--service SERVICE]
#   server.sh build    [--service SERVICE]
#   server.sh status
#   server.sh --help
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'server.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
server.sh — Manage the development Docker Compose stack

Usage:
  server.sh up       Start all services (or a single service)
  server.sh stop     Stop services without removing them (or a single service)
  server.sh down     Stop and remove containers
  server.sh restart  Restart all services (or a single service)
  server.sh build    Build or rebuild service images
  server.sh status   Show container status and port bindings

Options (up):
  --build            Rebuild images before starting
  --watch            Enable file-watch mode (docker compose up --watch)
  --seed             Run database/seed-dev.sh after startup (dev users + SEED_COMMANDS)
  --service SERVICE  Target a single service

Options (down):
  --volumes          Also remove named volumes (wipes database data)
  --clean-hosts [N]  Remove /etc/hosts entries for story N (defaults to current us### branch)

Options (stop, restart, build):
  --service SERVICE  Target a single service

`stop` is what `down` is not: it leaves the containers and the network in place, so a single
dependency can be taken away and given back. That is the only way to rehearse a degraded or
down readiness probe through this script — `restart` returns the service faster than any
probe interval, so the outage is never observed (how-to/docs/HEALTH-PROBES.md).

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Command ───────────────────────────────────────────────────────────────────
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  up|stop|down|restart|build|status) ;;
  --help|-h) usage; exit 0 ;;
  "")        die "No command given. Use --help for usage." ;;
  *)         die "Unknown command '$COMMAND'. Use --help for usage." ;;
esac

# ── Per-command flag parsing ──────────────────────────────────────────────────
BUILD=false
WATCH=false
SEED=false
VOLUMES=false
CLEAN_HOSTS=false
CLEAN_HOSTS_NUM=""
SERVICE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build)            BUILD=true; shift ;;
    --watch)            WATCH=true; shift ;;
    --seed)             SEED=true; shift ;;
    --volumes)          VOLUMES=true; shift ;;
    --clean-hosts)      CLEAN_HOSTS=true
                        if [[ "${2:-}" =~ ^[0-9]+$ ]]; then CLEAN_HOSTS_NUM="$2"; shift; fi
                        shift ;;
    --service)          require_arg "$@"; SERVICE="$2"; shift 2 ;;
    --help|-h)          usage; exit 0 ;;
    *)                  die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

[[ -f "$ENV_FILE" ]] || die "Env file not found: $ENV_FILE"

# Auto-detect worktree: if branch is us###/*, apply matching compose override.
# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"
# shellcheck source=code/src/scripts/_lib/env-file.sh
source "$SCRIPT_DIR/../_lib/env-file.sh"

# Base docker compose command with env file — all subcommands use this array.
DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

# ── Internal helpers ──────────────────────────────────────────────────────────

# Re-sync the postgres user password from .env.dev so a changed POSTGRES_PASSWORD
# never leaves the backend unable to connect against a reused volume.
# Runs only when the full stack is started (no --service flag).
_sync_db_password() {
  [[ -n "$SERVICE" ]] && return 0
  # Parsed, not sourced. `set -a; source` handed the file to bash, which aborts on the
  # first value carrying a shell metacharacter — under `set -euo pipefail` that killed
  # `server.sh up` at exit 2 with the stack already running, so this re-sync never ran and
  # the URL banner below never printed. See _lib/env-file.sh.
  local db_user db_password
  db_user="$(env_value POSTGRES_USER "$ENV_FILE")"
  db_password="$(env_value POSTGRES_PASSWORD "$ENV_FILE")"
  [[ -z "$db_user" ]] && db_user="<%PROJECT_SLUG%>"
  [[ -z "$db_password" ]] && return 0
  # Password is piped to psql stdin — never appears in the process list.
  printf 'ALTER USER "%s" WITH PASSWORD '"'"'%s'"'"';\n' \
    "$db_user" "$db_password" \
    | "${DC[@]}" exec -T db psql -U "$db_user" -d postgres > /dev/null 2>&1 \
    || log "  ⚠  Could not sync DB password (DB not ready — safe to ignore on first build)."
}

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  up)
    bold "▸ server.sh up"
    declare -a args=("${DC[@]}" up -d)
    $BUILD  && args+=(--build)
    $WATCH  && args+=(--watch)
    [[ -n "$SERVICE" ]] && args+=("$SERVICE")
    log ""
    "${args[@]}"
    _sync_db_password
    if $SEED; then
      log ""
      bold "  Seeding dev data…"
      bash "$SCRIPT_DIR/../database/seed-dev.sh"
    fi
    log ""
    bold "✓ Stack is up."
    # Only routes the stack actually serves are printed. At baseline the URLconf
    # registers Django's admin at /control/ and nothing else; the marketing, portal,
    # and API prefixes appear here as the apps that serve them are built.
    if [[ -n "$OVERRIDE_DEV_FILE" ]]; then
      # Worktree stacks isolate by host IP (127.0.0.<story>), and the per-story
      # compose override publishes the port behind that address.
      _host="dev-us${WORKTREE_US_NUM}.<%PROJECT_SLUG%>.localhost"
    else
      # Host 81, not 80 — a local router (e.g. DDEV) commonly holds 127.0.0.1:80.
      _host="dev.<%PROJECT_SLUG%>.localhost:81"
    fi
    log "  Site:          http://${_host}/"
    log "  Django Admin:  http://${_host}/control/   (superuser/staff only)"
    unset _host
    ;;

  down)
    bold "▸ server.sh down"
    declare -a args=("${DC[@]}" down)
    $VOLUMES && args+=(--volumes)
    log ""
    "${args[@]}"
    log ""
    $VOLUMES \
      && bold "✓ Stack stopped and volumes removed." \
      || bold "✓ Stack stopped."
    if $CLEAN_HOSTS; then
      _hosts_num="${CLEAN_HOSTS_NUM:-$WORKTREE_US_NUM}"
      if [[ -n "$_hosts_num" ]]; then
        bash "$SCRIPT_DIR/hosts-story-remove.sh" "$_hosts_num"
      else
        log "  ⚠  --clean-hosts ignored — not on a us### branch and no number given."
      fi
      unset _hosts_num
    fi
    ;;

  stop)
    bold "▸ server.sh stop"
    log ""
    if [[ -n "$SERVICE" ]]; then
      "${DC[@]}" stop "$SERVICE"
    else
      "${DC[@]}" stop
    fi
    log ""
    bold "✓ Stopped${SERVICE:+ $SERVICE}."
    log "  Containers and network are intact — bring it back with:"
    log "    bash code/src/scripts/development/server.sh up${SERVICE:+ --service $SERVICE}"
    ;;

  restart)
    bold "▸ server.sh restart"
    log ""
    if [[ -n "$SERVICE" ]]; then
      "${DC[@]}" restart "$SERVICE"
    else
      "${DC[@]}" restart
    fi
    log ""
    bold "✓ Restarted${SERVICE:+ $SERVICE}."
    ;;

  build)
    bold "▸ server.sh build"
    log ""
    if [[ -n "$SERVICE" ]]; then
      "${DC[@]}" build "$SERVICE"
    else
      "${DC[@]}" build
    fi
    log ""
    bold "✓ Build complete."
    ;;

  status)
    bold "▸ server.sh status"
    log ""
    "${DC[@]}" ps
    log ""
    "${DC[@]}" images 2>/dev/null || true
    ;;
esac
