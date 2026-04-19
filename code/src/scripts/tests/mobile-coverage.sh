#!/usr/bin/env bash
#
# mobile-coverage.sh — Run Jest with coverage reporting (one-shot).
#
# Usage: mobile-coverage.sh [--output DIR] [jest args]
#
#   --output DIR   Write coverage reports to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/mobile-coverage/
#
# Enforces the 70% line and branch coverage floor configured in jest.config.js.
#
# Exit codes:  0 = passed + coverage met   1 = failures or below threshold   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/mobile-coverage"

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
  printf 'mobile-coverage.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
CONTAINER_OUTPUT="/workspace/${OUTPUT_DIR#"$PROJECT_ROOT/"}"

docker compose -f "$COMPOSE_FILE" run --rm \
  mobile-test \
  pnpm test:coverage \
    "--coverageDirectory=$CONTAINER_OUTPUT" \
    --passWithNoTests \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}"
