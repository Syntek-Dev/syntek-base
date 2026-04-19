#!/usr/bin/env bash
#
# frontend.sh — Run the Vitest + React Testing Library suite (one-shot).
#
# Usage: frontend.sh [--output DIR] [vitest args]
#
#   --output DIR   Write JUnit XML report to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/frontend/
#
# Starts a fresh frontend-test container, runs the full suite, then exits.
# Does not require the test stack to be running — manages its own lifecycle.
#
# Exit codes:  0 = all tests passed   1 = test failures   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/frontend"

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
  printf 'frontend.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
CONTAINER_OUTPUT="/workspace/${OUTPUT_DIR#"$PROJECT_ROOT/"}"

docker compose -f "$COMPOSE_FILE" run --rm frontend-test \
  pnpm test \
    --reporter=verbose \
    --reporter=junit \
    "--outputFile.junit=$CONTAINER_OUTPUT/results.xml" \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}"
