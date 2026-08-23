#!/usr/bin/env bash
#
# backend.sh — Build, run, and tear down the Django/pytest test suite.
#
# Usage: backend.sh [--output DIR] [pytest args]
#
#   --output DIR   Write JUnit XML reports to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/backend/
#
# Runs two phases in sequence:
#   Phase 1 — unit tests        (-m unit)        fast; no DB connections opened
#   Phase 2 — integration tests (-m integration) DB-touching; sequential
#
# Builds the django-test image, starts the test stack, runs both phases, then
# tears everything down (including volumes) on exit — pass or fail.
#
# Exit codes:  0 = all tests passed   1 = test failures   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/backend"

# Every value in .env.test has a working default in docker-compose.test.yml, so the
# committed example is a valid fallback and a fresh clone can run the suite before
# copying it. Passing a missing --env-file just makes compose die with "couldn't find
# env file", which says nothing about what to do next.
[[ -f "$ENV_FILE" ]] || ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test.example"
if [[ ! -f "$ENV_FILE" ]]; then
  printf 'backend.sh error: no .env.test or .env.test.example in code/src/docker/\n' >&2
  exit 2
fi

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

# Help is matched in first position only: every other argument is passed straight
# through to pytest, which has a --help of its own. Without this the script would treat
# `--help` as a pytest arg and build an image before printing anything.
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  sed -n '3,18p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 0
fi

OUTPUT_DIR=""
PASS_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) OUTPUT_DIR="$2"; shift 2 ;;
    *)        PASS_ARGS+=("$1"); shift ;;
  esac
done
[[ -z "$OUTPUT_DIR" ]] && OUTPUT_DIR="$DEFAULT_OUTPUT"

if [[ "$OUTPUT_DIR" != "$PROJECT_ROOT/"* && "$OUTPUT_DIR" != "$PROJECT_ROOT" ]]; then
  printf 'backend.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
CONTAINER_OUTPUT="/workspace/${OUTPUT_DIR#"$PROJECT_ROOT/"}"

DC_TEST=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_TEST_FILE:+-f "$OVERRIDE_TEST_FILE"})

printf '[backend] Building django-test image…\n'
"${DC_TEST[@]}" build django-test

printf '[backend] Starting test stack…\n'
"${DC_TEST[@]}" up -d db cache django-test

_teardown() { "${DC_TEST[@]}" down --volumes 2>/dev/null || true; }
trap _teardown EXIT

# pytest exits 5 when it collects nothing. The template baseline ships no tests, so
# both phases legitimately collect zero until the first app lands — treat 5 as a pass
# and say so. Every other non-zero code is the failure it looks like.
run_phase() {
  local label="$1" marker="$2" junit="$3"
  local rc=0
  "${DC_TEST[@]}" exec django-test \
    pytest -m "$marker" \
      --junit-xml="$junit" \
      "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}" || rc=$?
  if (( rc == 5 )); then
    printf '[backend] %s: no tests collected — nothing matches -m %s yet.\n' "$label" "$marker"
    return 0
  fi
  return "$rc"
}

printf '[backend] Phase 1/2: unit tests…\n'
run_phase "Phase 1/2" unit "$CONTAINER_OUTPUT/results-unit.xml"

printf '[backend] Phase 2/2: integration tests…\n'
run_phase "Phase 2/2" integration "$CONTAINER_OUTPUT/results-integration.xml"
