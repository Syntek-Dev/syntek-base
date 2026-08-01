#!/usr/bin/env bash
#
# mutmut.sh — Python mutation testing via mutmut inside the django container.
#
# Usage:
#   mutmut.sh run     [--paths PATHS]
#   mutmut.sh results
#   mutmut.sh show    MUTANT_ID
#   mutmut.sh apply   MUTANT_ID
#   mutmut.sh --help
#
# A mutation score below 80% indicates tests that pass but do not assert on
# output — investigate surviving mutants with: mutmut.sh show MUTANT_ID
#
# Requires the dev stack to be running:
#   bash code/src/scripts/development/server.sh up
#
# Exit codes:  0 = success / all mutants killed   1 = surviving mutants or error   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"
DEFAULT_PATHS="apps/"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'mutmut.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
mutmut.sh — Python mutation testing via mutmut inside the django container

Usage:
  mutmut.sh run               Run mutation tests against apps/ (default)
  mutmut.sh run --paths PATH  Run against a specific path (e.g. apps/<app>/)
  mutmut.sh results           Show a summary of surviving mutants
  mutmut.sh show MUTANT_ID    Show the diff for a specific mutant
  mutmut.sh apply MUTANT_ID   Apply a mutant to the source (for manual inspection)

A mutation score below 80% indicates tests that pass but do not assert on
output — investigate surviving mutants with: mutmut.sh show MUTANT_ID

Requires the dev stack to be running:
  bash code/src/scripts/development/server.sh up

Exit codes:  0 = success / all mutants killed   1 = surviving mutants or error   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# `ps --services` prints service names only, so `grep -qx` matches exactly.
container_running() {
  cd "$PROJECT_ROOT"
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} ps --services --status running 2>/dev/null \
    | grep -qx "django"
}

mutmut_exec() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} \
    exec -T -w /workspace/code/src/django django uv run mutmut "$@"
}

# ── Command ───────────────────────────────────────────────────────────────────
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  run|results|show|apply) ;;
  --help|-h) usage; exit 0 ;;
  "")        die "No command given. Use --help for usage." ;;
  *)         die "Unknown command '$COMMAND'. Use --help for usage." ;;
esac

cd "$PROJECT_ROOT"
container_running || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  run)
    PATHS="$DEFAULT_PATHS"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --paths)   require_arg "$@"; PATHS="$2"; shift 2 ;;
        --help|-h) usage; exit 0 ;;
        *)         die "Unknown option '$1'. Use --help for usage." ;;
      esac
    done
    bold "▸ mutmut.sh run — $PATHS"
    log ""
    mutmut_exec run --paths-to-mutate "$PATHS"
    log ""
    bold "✓ Mutation run complete. Check results with: mutmut.sh results"
    ;;

  results)
    bold "▸ mutmut.sh results"
    log ""
    mutmut_exec results
    ;;

  show)
    MUTANT_ID="${1:-}"
    [[ -z "$MUTANT_ID" ]] && die "show requires a MUTANT_ID. Use: mutmut.sh show MUTANT_ID"
    bold "▸ mutmut.sh show $MUTANT_ID"
    log ""
    mutmut_exec show "$MUTANT_ID"
    ;;

  apply)
    MUTANT_ID="${1:-}"
    [[ -z "$MUTANT_ID" ]] && die "apply requires a MUTANT_ID. Use: mutmut.sh apply MUTANT_ID"
    bold "▸ mutmut.sh apply $MUTANT_ID"
    log ""
    mutmut_exec apply "$MUTANT_ID"
    log ""
    bold "✓ Mutant $MUTANT_ID applied. Revert with git checkout after inspection."
    ;;
esac
