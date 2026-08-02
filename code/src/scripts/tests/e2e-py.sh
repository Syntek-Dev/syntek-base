#!/usr/bin/env bash
#
# e2e-py.sh — Run the Python (playwright-python) browser e2e suite.
#
# ONE browser driver, in Python. There is no Node test path in this stack: HTMX, Alpine,
# axe, and anything else that needs a real layout are browser-bound, and Django's test
# client executes no JavaScript. Everything else is covered by pytest through that client
# (code/docs/testing/FRONTEND-TESTING.md) — this suite is only for what genuinely needs
# a browser.
#
# The stack must already be running:  bash code/src/scripts/development/server.sh up
#
# The dev stack serves the site through nginx on host port 81 (not 80 — a local router
# commonly holds 127.0.0.1:80), which is the default below. Override for another target:
#   E2E_BASE_URL=http://localhost:8000 bash code/src/scripts/tests/e2e-py.sh
#
# Usage: e2e-py.sh [pytest args]
#
#   e2e-py.sh                                      Run every e2e test
#   e2e-py.sh -k overflow                          Run matching tests only
#   e2e-py.sh --headed                             Watch it drive a real browser
#   e2e-py.sh code/src/django/tests/e2e/test_e2e_a11y.py    Run one module
#
# These tests are marked `e2e` and are excluded from both phases of backend.sh, so they
# never run as part of the ordinary suite.
#
# Exit codes:  0 = all passed   1 = failures   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
E2E_DIR="code/src/django/tests/e2e"

E2E_BASE_URL="${E2E_BASE_URL:-http://dev.<%PROJECT_SLUG%>.localhost:81}"

log() { printf '[e2e-py] %s\n' "$*"; }
die() { printf '[e2e-py] error: %s\n' "$*" >&2; exit 2; }

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  sed -n '3,27p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 0
fi

cd "$PROJECT_ROOT" || die "cannot enter project root"

command -v uv > /dev/null 2>&1 || die "uv is not installed — see how-to/docs/DEVELOPMENT.md"

# pytest-django imports Django settings at startup, and base.py reads SECRET_KEY straight
# from the environment. The e2e tests never touch the ORM, but the plugin still has to
# import settings, so load the same env file compose gives the test stack.
# Never commit these values.
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test"
[[ -f "$ENV_FILE" ]] || ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test.example"
[[ -f "$ENV_FILE" ]] || die "no .env.test or .env.test.example in code/src/docker/"

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

if ! curl -sf -o /dev/null "${E2E_BASE_URL}/control/"; then
  printf '[e2e-py] Stack not reachable at %s\n' "$E2E_BASE_URL" >&2
  printf '[e2e-py] Start it first: bash code/src/scripts/development/server.sh up\n' >&2
  exit 2
fi

# Chromium only — the suite declares no other browser, and installing all three costs
# ~400MB for engines nothing runs.
log 'Installing Playwright Chromium if needed…'
uv run playwright install chromium > /dev/null 2>&1 ||
  log 'WARNING: chromium install failed; continuing in case it is already present'

# Default to the whole suite ONLY when the caller named no target of their own —
# otherwise `e2e-py.sh <path>` would append to the default path and silently run
# everything instead of the one module asked for.
#
# "Named a target" is decided by whether the argument EXISTS on disk, not by whether it
# starts with a dash. Guessing from the dash splits a flag from its value: `-k "home or
# config"` puts -k in one bucket and its value in the other, and pytest then dies with
# "argument -k: expected one argument".
HAS_TARGET=false
for arg in "$@"; do
  if [[ -e "$arg" ]]; then
    HAS_TARGET=true
    break
  fi
done

if [[ "$HAS_TARGET" == false ]]; then
  set -- "$E2E_DIR" "$@"
fi

log "Running the e2e suite against ${E2E_BASE_URL}…"
# -m e2e selects the browser suite. `-x` (stop on first failure) comes from addopts.
E2E_BASE_URL="$E2E_BASE_URL" uv run pytest -m e2e "$@"
