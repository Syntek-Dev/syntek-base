#!/usr/bin/env bash
#
# server.sh — Manage the test Docker Compose stack.
#
# Usage:
#   server.sh up       [--build] [--service SERVICE]
#   server.sh down     [--volumes] [--force-posture POSTURE]
#   server.sh restart  [--service SERVICE]
#   server.sh build    [--service SERVICE]
#   server.sh status
#   server.sh --help
#
# NOTE: The test backend image bakes source code in at build time (no volume
# mount). After adding or changing code, run "server.sh up --build" or
# "server.sh build" followed by "server.sh up" to pick up the changes before
# running backend.sh or backend-coverage.sh.
#
# The posture guard (_lib/posture-guard.sh) binds `down --volumes` only. --force-posture is
# accepted everywhere and inert on every other path.
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#              4 = refused by the posture guard (_lib/posture-guard.sh)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test"
ORIG_ARGS=("$@")

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'server.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
warn() { printf '\033[33m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
server.sh — Manage the test Docker Compose stack

Usage:
  server.sh up       Start all services (or a single service)
  server.sh down     Stop and remove containers
  server.sh restart  Restart all services (or a single service)
  server.sh build    Build or rebuild service images
  server.sh status   Show container status and image list

Options (up):
  --build            Rebuild images before starting
  --service SERVICE  Target a single service

Options (down):
  --volumes          Also remove named volumes (wipes test database data)

Options (all commands):
  --force-posture POSTURE
                     Name the posture the project is at now (staging or production) to
                     run `down --volumes` above development. Inert everywhere else.

Options (restart, build):
  --service SERVICE  Target a single service

NOTE: The django-test image bakes source code in at build time.
      Run "up --build" after any code changes.

Exit codes:  0 = success   1 = command failed   2 = script error
             4 = refused by the posture guard (posture-guard: refused —)
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Command ───────────────────────────────────────────────────────────────────
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  up|down|restart|build|status) ;;
  --help|-h) usage; exit 0 ;;
  "")        die "No command given. Use --help for usage." ;;
  *)         die "Unknown command '$COMMAND'. Use --help for usage." ;;
esac

# ── Per-command flag parsing ──────────────────────────────────────────────────
BUILD=false
VOLUMES=false
SERVICE=""
FORCE_POSTURE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build)    BUILD=true; shift ;;
    --volumes)  VOLUMES=true; shift ;;
    --service)  require_arg "$@"; SERVICE="$2"; shift 2 ;;
    --force-posture) require_arg "$@"; FORCE_POSTURE="$2"; shift 2 ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# Auto-detect worktree: if branch is us###/*, apply matching compose override. Sourced ahead
# of the env-file check because the posture guard needs the override's declared name.
# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"
# shellcheck source=code/src/scripts/_lib/posture-guard.sh
source "$SCRIPT_DIR/../_lib/posture-guard.sh"
COMPOSE_NAME="$(posture_compose_name "$COMPOSE_FILE" "$OVERRIDE_TEST_FILE")"
DOCKER=(docker)

# ── Posture guard: down --volumes ─────────────────────────────────────────────
# Above the env-file check, so an operator with no .env.test still sees the posture refusal.
# A permit pins the compose array below to the target the guard validated.
if [[ "$COMMAND" == down ]] && $VOLUMES; then
  posture_guard "$PROJECT_ROOT" refuse "$FORCE_POSTURE" "$COMPOSE_NAME" "$ENV_FILE" \
    bash code/src/scripts/tests/server.sh "${ORIG_ARGS[@]}" || exit "$?"
  posture_docker_bind || exit "$?"
  DOCKER=("${posture_docker[@]}")
fi

[[ -f "$ENV_FILE" ]] || die "Env file not found: $ENV_FILE"

# Base docker compose command — all subcommands use this array. DOCKER is the plain CLI on
# every unguarded path and the validated binding on `down --volumes`.
DC=("${DOCKER[@]}" compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_TEST_FILE:+-f "$OVERRIDE_TEST_FILE"})

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  up)
    bold "▸ server.sh up"
    if $BUILD; then
      warn "  Rebuilding images before starting…"
      log ""
      if [[ -n "$SERVICE" ]]; then
        "${DC[@]}" build "$SERVICE"
      else
        "${DC[@]}" build
      fi
      log ""
    fi
    declare -a args=("${DC[@]}" up -d)
    [[ -n "$SERVICE" ]] && args+=("$SERVICE")
    log ""
    "${args[@]}"
    log ""
    bold "✓ Test stack is up."
    if [[ -n "$OVERRIDE_TEST_FILE" ]]; then
      _n=$((10#$WORKTREE_US_NUM))
      log "  Site:      http://test-us${WORKTREE_US_NUM}.<%PROJECT_SLUG%>.localhost:${_n}081"
      log "  API:       http://test-us${WORKTREE_US_NUM}.<%PROJECT_SLUG%>.localhost:${_n}081/api/"
    else
      log "  Site:      http://test.<%PROJECT_SLUG%>.localhost:83"
      log "  API:       http://test.<%PROJECT_SLUG%>.localhost:83/api/"
    fi
    log ""
    log "  Run tests: bash code/src/scripts/tests/backend.sh"
    log "  Coverage:  bash code/src/scripts/tests/backend-coverage.sh"
    ;;

  down)
    bold "▸ server.sh down"
    declare -a args=("${DC[@]}" down)
    $VOLUMES && args+=(--volumes)
    log ""
    "${args[@]}"
    log ""
    $VOLUMES \
      && bold "✓ Test stack stopped and volumes removed." \
      || bold "✓ Test stack stopped."
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
    log "  Start the stack: bash code/src/scripts/tests/server.sh up"
    ;;

  status)
    bold "▸ server.sh status"
    log ""
    "${DC[@]}" ps
    log ""
    "${DC[@]}" images 2>/dev/null || true
    ;;
esac
