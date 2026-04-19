#!/usr/bin/env bash
#
# frontend-coverage.sh — Run Vitest with coverage reporting (one-shot).
#
# Usage: frontend-coverage.sh [--output DIR] [vitest args]
#
#   --output DIR   Write HTML and LCOV coverage reports to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/frontend-coverage/
#
# Enforces the 70% line and branch coverage floor configured in vitest.config.ts.
#
# Exit codes:  0 = passed + coverage met   1 = failures or below threshold   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/frontend-coverage"

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
  printf 'frontend-coverage.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
CONTAINER_OUTPUT="/workspace/${OUTPUT_DIR#"$PROJECT_ROOT/"}"

docker compose -f "$COMPOSE_FILE" run --rm frontend-test \
  pnpm test:coverage \
    "--coverage.reportsDirectory=$CONTAINER_OUTPUT" \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}"
