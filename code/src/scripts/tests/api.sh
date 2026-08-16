#!/usr/bin/env bash
#
# api.sh — Run Bruno API integration tests against the test stack.
#
# Usage: api.sh [--output DIR] [--env ENV] [--folder FOLDER] [bru args]
#
#   --output DIR     Write results.json to DIR (must be within project root).
#                    Default: code/src/scripts/tests/reports/api/
#   --env ENV        Bruno environment to use. Default: host
#   --folder FOLDER  Subfolder of the collection to run. Default: entire collection.
#
# Credentials:
#   Set BRUNO_VAR_test_password in your shell before running:
#     BRUNO_VAR_test_password=secret bash code/src/scripts/tests/api.sh
#
# Brings up the test stack (db, cache, django-test, nginx), seeds the Bruno fixture
# users when the project provides that management command, then runs Bruno on the HOST
# via the root pnpm workspace (@usebruno/cli) against the test stack's nginx.
# Host-based — Bruno runs on the host, not in a container.
#
# Exits 0 without starting anything when the collection holds no requests.
#
# The default `host` env targets http://test.<%PROJECT_SLUG%>.localhost:83 (the test
# nginx, published on 127.0.0.1:83). The .localhost hostname resolves to 127.0.0.1;
# add it to /etc/hosts if your resolver does not handle *.localhost. Override the
# target with API_BASE_URL, or pass `--env docker` to run inside the compose network.
#
# Exit codes:  0 = all tests passed   1 = test failures   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test"
COLLECTION="$PROJECT_ROOT/code/src/tests/api"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/api"

# Every value in .env.test has a working default in docker-compose.test.yml, so the
# committed example is a valid fallback.
[[ -f "$ENV_FILE" ]] || ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test.example"
if [[ ! -f "$ENV_FILE" ]]; then
  printf 'api.sh error: no .env.test or .env.test.example in code/src/docker/\n' >&2
  exit 2
fi

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

# Help is matched in first position only — everything else passes through to `bru run`.
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  sed -n '3,31p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 0
fi

OUTPUT_DIR=""
BRUNO_ENV="host"
FOLDER=""
PASS_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) OUTPUT_DIR="$2"; shift 2 ;;
    --env)    BRUNO_ENV="$2"; shift 2 ;;
    --folder) FOLDER="$2"; shift 2 ;;
    *)        PASS_ARGS+=("$1"); shift ;;
  esac
done

[[ -z "$OUTPUT_DIR" ]] && OUTPUT_DIR="$DEFAULT_OUTPUT"

if [[ "$OUTPUT_DIR" != "$PROJECT_ROOT/"* && "$OUTPUT_DIR" != "$PROJECT_ROOT" ]]; then
  printf 'api.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"

API_BASE_URL="${API_BASE_URL:-http://test.<%PROJECT_SLUG%>.localhost:83}"
# The path used to prove the stack is answering before Bruno starts. At baseline
# `/control/` is the only route the URLconf registers; point this at a real liveness
# route (e.g. /health/) once the project has one.
API_HEALTH_PATH="${API_HEALTH_PATH:-/control/}"

# Nothing to run is not a pass or a failure — it is the baseline. Bruno's own exit code
# for an empty run is unhelpful, so decide here, before building an image for nothing.
# `environments/` holds .bru config files, not requests.
if ! find "$COLLECTION" -name '*.bru' -not -path "$COLLECTION/environments/*" \
     -print -quit 2>/dev/null | read -r _; then
  printf '[api] No requests in %s — the collection is empty.\n' "$COLLECTION"
  printf '[api] Nothing to run; add .bru requests as API endpoints ship.\n'
  exit 0
fi

DC_TEST=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_TEST_FILE:+-f "$OVERRIDE_TEST_FILE"})

printf '[api] Building the django-test image…\n'
"${DC_TEST[@]}" build django-test

printf '[api] Starting the test stack (db, cache, django-test, nginx)…\n'
"${DC_TEST[@]}" up -d db cache django-test nginx
"${DC_TEST[@]}" up --wait --no-recreate django-test

_teardown() { "${DC_TEST[@]}" down --volumes 2>/dev/null || true; }
trap _teardown EXIT

# Default matches TEST_API_USER_PASSWORD in docker-compose.test.yml; override in shell if needed.
BRUNO_VAR_test_password="${BRUNO_VAR_test_password:-Test@Api2026!}"
# Default matches LIMITED_API_USER_PASSWORD in docker-compose.test.yml; override in shell if needed.
BRUNO_VAR_limited_password="${BRUNO_VAR_limited_password:-Limited@Api2026!}"

# Seed the three Bruno API fixture users (test_api_user, limited_api_user, target_api_user).
# Without this the authenticated requests fail with "Email or password incorrect" and cascade
# into "Authentication required" across the suite. The seeded passwords are pinned to the exact
# values Bruno sends so adminLogin succeeds regardless of any shell override above.
#
# The command ships with the app that owns the fixture users, so it does not exist until
# that app does. Probe for it rather than assuming — an unauthenticated collection is
# perfectly runnable without it.
if "${DC_TEST[@]}" exec -T django-test \
     python /workspace/code/src/django/manage.py help seed_api_test_user > /dev/null 2>&1; then
  printf '[api] Seeding Bruno API test users…\n'
  "${DC_TEST[@]}" exec -T \
    -e "TEST_API_USER_PASSWORD=${BRUNO_VAR_test_password}" \
    -e "LIMITED_API_USER_PASSWORD=${BRUNO_VAR_limited_password}" \
    django-test python /workspace/code/src/django/manage.py seed_api_test_user
else
  printf '[api] seed_api_test_user is not a registered management command — skipping fixture users.\n'
  printf '[api] Authenticated requests will fail until the app that provides it exists.\n'
fi

# The host runner reaches the API through the test nginx — fail early if it is not up.
printf '[api] Checking the test stack is reachable at %s%s…\n' "$API_BASE_URL" "$API_HEALTH_PATH"
if ! curl -sf -o /dev/null "${API_BASE_URL}${API_HEALTH_PATH}"; then
  printf 'api.sh error: test stack not reachable at %s%s (is the .localhost host in /etc/hosts?)\n' \
    "$API_BASE_URL" "$API_HEALTH_PATH" >&2
  exit 2
fi

# Bruno runs on the HOST via the root pnpm workspace (@usebruno/cli). `-r` (recursive) is
# required so a folder run descends into nested folders. The CLI honours NEITHER bruno.json's
# `ignore` list NOR `meta { skip }` — the only exclusion lever is `--exclude-tags`. Two tags
# are excluded:
#   manual — requests that can't pass in a normal run (rate-limit needs >60 rapid requests).
#   wip    — requests blocked on test-data/service infrastructure not present in the test stack
#            (seeded SEO records, a seeded client + Cloudinary mock, a seeded blog post, and the
#            not-yet-implemented user(id) endpoint).
# The request template lives outside the collection root so recursion never picks it up.
( cd "$COLLECTION" && \
  BRUNO_VAR_test_password="${BRUNO_VAR_test_password}" \
  BRUNO_VAR_limited_password="${BRUNO_VAR_limited_password}" \
  pnpm exec bru run -r ${FOLDER:+"$FOLDER"} \
    --env "$BRUNO_ENV" \
    --exclude-tags manual,wip \
    --reporter-json "$OUTPUT_DIR/results.json" \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}" )
