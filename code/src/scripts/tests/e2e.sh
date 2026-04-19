#!/usr/bin/env bash
#
# e2e.sh — Run playwright-bdd end-to-end acceptance tests (explicit only).
#
# Usage: e2e.sh [--output DIR] [playwright args]
#
#   --output DIR   Write HTML and JUnit XML reports to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/e2e/
#
# IMPORTANT: E2E tests are never run automatically. They must be triggered
# explicitly — locally via this script or in CI via the test-e2e.yml workflow
# (workflow_dispatch only).
#
# Requires the full test stack to be running (backend + frontend + nginx):
#   docker compose -f code/src/docker/docker-compose.test.yml up -d
#
# Feature files:  code/src/frontend/e2e/features/**/*.feature
# Step defs:      code/src/frontend/e2e/steps/**/*.ts
# Base URL:       http://localhost (nginx port 80 in test compose)
#
# Exit codes:  0 = all scenarios passed   1 = failures   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/e2e"

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
  printf 'e2e.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR/html"
CONTAINER_OUTPUT="/workspace/${OUTPUT_DIR#"$PROJECT_ROOT/"}"

if ! docker compose -f "$COMPOSE_FILE" ps frontend-test --status running | grep -q "running"; then
  printf 'e2e.sh error: test stack is not fully running.\n' >&2
  printf 'Start the full test stack first:\n' >&2
  printf '  docker compose -f code/src/docker/docker-compose.test.yml up -d\n' >&2
  exit 2
fi

docker compose -f "$COMPOSE_FILE" exec \
  -e "PLAYWRIGHT_HTML_REPORT=$CONTAINER_OUTPUT/html" \
  -e "PLAYWRIGHT_JUNIT_OUTPUT_NAME=$CONTAINER_OUTPUT/results.xml" \
  frontend-test \
  pnpm test:e2e \
    --reporter=html \
    --reporter=junit \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}"
