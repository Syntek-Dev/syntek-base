#!/usr/bin/env bash
#
# backend.sh — Run the Django/pytest test suite inside the test container.
#
# Usage: backend.sh [--output DIR] [pytest args]
#
#   --output DIR   Write JUnit XML report to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/backend/
#
# Requires the test stack to be running:
#   docker compose -f code/src/docker/docker-compose.test.yml up -d
#
# Exit codes:  0 = all tests passed   1 = test failures   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/backend"

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

if ! docker compose -f "$COMPOSE_FILE" ps backend-test --status running | grep -q "running"; then
  printf 'backend.sh error: backend-test container is not running.\n' >&2
  printf 'Start the test stack first:\n' >&2
  printf '  docker compose -f code/src/docker/docker-compose.test.yml up -d\n' >&2
  exit 2
fi

docker compose -f "$COMPOSE_FILE" exec backend-test \
  pytest \
    --junit-xml="$CONTAINER_OUTPUT/results.xml" \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}"
