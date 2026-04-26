#!/usr/bin/env bash
#
# api.sh — Run Bruno API integration tests against the test stack.
#
# Usage: api.sh [--output DIR] [--env ENV] [bru args]
#
#   --output DIR   Write results.json to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/api/
#   --env ENV      Bruno environment to use. Default: docker
#
# Credentials:
#   Set BRUNO_VAR_test_password in your shell before running:
#     BRUNO_VAR_test_password=secret ./code/src/scripts/tests/api.sh
#
# Requires the test stack to be running (backend-test at minimum):
#   docker compose -f code/src/docker/docker-compose.test.yml up -d db cache backend-test
#
# Bruno is run via the frontend-test image, which already has @usebruno/cli
# installed as part of the root pnpm install.
#
# Exit codes:  0 = all tests passed   1 = test failures   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
COLLECTION="$PROJECT_ROOT/code/src/tests/api"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/api"

OUTPUT_DIR=""
BRUNO_ENV="docker"
PASS_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) OUTPUT_DIR="$2"; shift 2 ;;
    --env)    BRUNO_ENV="$2"; shift 2 ;;
    *)        PASS_ARGS+=("$1"); shift ;;
  esac
done
[[ -z "$OUTPUT_DIR" ]] && OUTPUT_DIR="$DEFAULT_OUTPUT"

if [[ "$OUTPUT_DIR" != "$PROJECT_ROOT/"* && "$OUTPUT_DIR" != "$PROJECT_ROOT" ]]; then
  printf 'api.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"

if ! docker compose -f "$COMPOSE_FILE" ps backend-test --status running | grep -q "running"; then
  printf 'api.sh error: backend-test container is not running.\n' >&2
  printf 'Start the test stack first:\n' >&2
  printf '  docker compose -f code/src/docker/docker-compose.test.yml up -d db cache backend-test\n' >&2
  exit 2
fi

docker compose -f "$COMPOSE_FILE" run --rm \
  -e "BRUNO_VAR_test_password=${BRUNO_VAR_test_password:-}" \
  -v "$COLLECTION:/workspace/code/src/tests/api:ro" \
  -v "$OUTPUT_DIR:/output:rw" \
  frontend-test \
  bru run /workspace/code/src/tests/api \
    --env "$BRUNO_ENV" \
    --reporter-json /output/results.json \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}"
