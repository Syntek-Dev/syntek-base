#!/usr/bin/env bash
#
# backend-coverage.sh — Build, run coverage, and tear down the Django/pytest suite.
#
# Usage: backend-coverage.sh [--output DIR] [pytest args]
#
#   --output DIR   Write HTML and XML coverage reports to DIR (must be within project root).
#                  Default: code/src/scripts/tests/reports/backend-coverage/
#
# Runs two phases in sequence:
#   Phase 1 — unit tests        (-m unit)        coverage collected, no report emitted
#   Phase 2 — integration tests (-m integration) coverage appended, reports emitted
#
# Coverage is accumulated across both phases before the final threshold check
# (--cov-fail-under=75). Enforces the 75% line and branch coverage floor.
#
# A final auth-coverage gate then derives apps/<AUTH_APP> line coverage from the emitted
# Cobertura coverage.xml and enforces a ≥90% floor (auth code holds a higher bar).
# AUTH_APP defaults to `users` and is skipped while that app does not exist.
#
# Both floors are inert only while code/src/django/apps/ has no modules — the template
# baseline. They arm themselves as soon as the first one lands; never relax them by hand.
#
# Exit codes:  0 = passed + coverage met   1 = failures or below threshold   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test"
DEFAULT_OUTPUT="$SCRIPT_DIR/reports/backend-coverage"
APPS_DIR="$PROJECT_ROOT/code/src/django/apps"
# The app whose coverage carries the 90% auth floor. Override if the project names it
# something other than `users`.
AUTH_APP="${AUTH_APP:-users}"

# Every value in .env.test has a working default in docker-compose.test.yml, so the
# committed example is a valid fallback and a fresh clone can run the suite before
# copying it.
[[ -f "$ENV_FILE" ]] || ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.test.example"
if [[ ! -f "$ENV_FILE" ]]; then
  printf 'backend-coverage.sh error: no .env.test or .env.test.example in code/src/docker/\n' >&2
  exit 2
fi

# Coverage floors are enforced against code, not against emptiness. The template
# baseline has an empty `apps/` package: `--cov=apps` measures nothing, so a 75% floor
# would fail a tree that has nothing to cover, and the auth gate would fail closed on a
# users app that does not exist yet. Detect that state explicitly and say so — the
# floors switch on by themselves the moment the first module lands. Never relax them
# any other way.
HAS_APP_CODE=false
if [[ -d "$APPS_DIR" ]] && \
   find "$APPS_DIR" -name '*.py' ! -name '__init__.py' -print -quit 2>/dev/null | read -r _; then
  HAS_APP_CODE=true
fi
COV_FLOOR=75
$HAS_APP_CODE || COV_FLOOR=0

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

# Help is matched in first position only — everything else passes through to pytest.
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  sed -n '3,26p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
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
  printf 'backend-coverage.sh error: --output must be within project root: %s\n' "$PROJECT_ROOT" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
CONTAINER_OUTPUT="/workspace/${OUTPUT_DIR#"$PROJECT_ROOT/"}"

DC_TEST=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_TEST_FILE:+-f "$OVERRIDE_TEST_FILE"})

printf '[backend-coverage] Building django-test image…\n'
"${DC_TEST[@]}" build django-test

printf '[backend-coverage] Starting test stack…\n'
"${DC_TEST[@]}" up -d db cache django-test

_teardown() { "${DC_TEST[@]}" down --volumes 2>/dev/null || true; }
trap _teardown EXIT

if ! $HAS_APP_CODE; then
  printf '[backend-coverage] NOTE: code/src/django/apps/ contains no modules yet — the 75%%\n'
  printf '[backend-coverage]       coverage floor and the auth gate are inert until it does.\n'
fi

# pytest exits 5 when it collects nothing; the baseline ships no tests. Treat 5 as a
# pass and say so — every other non-zero code is a real failure.
run_phase() {
  local label="$1" marker="$2"; shift 2
  local rc=0
  "${DC_TEST[@]}" exec django-test pytest -m "$marker" "$@" \
    "${PASS_ARGS[@]+"${PASS_ARGS[@]}"}" || rc=$?
  if (( rc == 5 )); then
    printf '[backend-coverage] %s: no tests collected — nothing matches -m %s yet.\n' "$label" "$marker"
    return 0
  fi
  return "$rc"
}

printf '[backend-coverage] Phase 1/2: unit tests (collecting coverage)…\n'
run_phase "Phase 1/2" unit \
  --cov=apps \
  --cov-branch \
  --cov-report= \
  --cov-fail-under=0 \
  --junit-xml="$CONTAINER_OUTPUT/results-unit.xml"

# NOTE: CI raises this to 80% on main/staging branches.
# If your branch targets main/staging, aim for ≥80% before pushing.
printf '[backend-coverage] Phase 2/2: integration tests (coverage accumulated + reported)…\n'
run_phase "Phase 2/2" integration \
  --cov=apps \
  --cov-branch \
  --cov-append \
  --cov-fail-under="$COV_FLOOR" \
  --cov-report="html:$CONTAINER_OUTPUT/html" \
  --cov-report="xml:$CONTAINER_OUTPUT/coverage.xml" \
  --cov-report=term-missing \
  --junit-xml="$CONTAINER_OUTPUT/results-integration.xml"

# The auth gate needs an auth app to gate. Absent (baseline) → skip loudly. Present but
# unmeasured → fail closed, below, because that is a real regression.
if [[ ! -d "$APPS_DIR/$AUTH_APP" ]]; then
  printf '[backend-coverage] Auth coverage check: skipped — apps/%s/ does not exist yet.\n' "$AUTH_APP"
  printf '[auth-gate] The 90%% floor applies from the moment that app is created.\n'
  exit 0
fi

printf '[backend-coverage] Auth coverage check: apps/%s/ line coverage must meet ≥90%%…\n' "$AUTH_APP"
# A standalone `coverage report` exec cannot resolve the `.coverage` data file against
# `[tool.coverage.run] source = ["apps"]` from the container WORKDIR (/workspace) — the `apps`
# package actually lives at code/src/django/apps, so coverage maps nothing and fails closed with
# "No data" regardless of the real number (GAP-BACKEND-COVERAGE-AUTH-GATE). Instead we derive the
# apps/users aggregate LINE coverage directly from the Cobertura coverage.xml Phase 2 just wrote:
# paths there are recorded as code/src/django/apps/users/…, and the pyproject `omit` (migrations,
# tests, __init__) is already honoured in the XML. Fails closed if the XML is missing/unparseable
# or if no apps/users lines are present.
"${DC_TEST[@]}" exec -T django-test \
  python - "$CONTAINER_OUTPUT/coverage.xml" "$AUTH_APP" <<'PY'
import sys
import xml.etree.ElementTree as ET

AUTH_FLOOR = 90.0
xml_path, auth_app = sys.argv[1], sys.argv[2]
needle = f"apps/{auth_app}/"

try:
    root = ET.parse(xml_path).getroot()
except (OSError, ET.ParseError) as exc:
    sys.stderr.write(f"[auth-gate] cannot read coverage.xml: {exc}\n")
    sys.exit(1)

covered = 0
total = 0
for cls in root.iter("class"):
    if needle not in cls.get("filename", ""):
        continue
    lines_el = cls.find("lines")
    if lines_el is None:
        continue
    for line in lines_el.findall("line"):
        total += 1
        if int(line.get("hits", "0")) > 0:
            covered += 1

# The caller only runs this when apps/<auth_app>/ exists on disk, so zero measured
# lines means coverage stopped seeing an app that is there — a regression, not a
# baseline. Fail closed.
if total == 0:
    sys.stderr.write(f"[auth-gate] no {needle} lines found in coverage.xml (failing closed)\n")
    sys.exit(1)

pct = covered / total * 100
print(f"[auth-gate] {needle} line coverage: {pct:.2f}% ({covered}/{total} lines)")
if pct < AUTH_FLOOR:
    sys.stderr.write(f"[auth-gate] FAIL: {pct:.2f}% is below the {AUTH_FLOOR:.0f}% auth floor\n")
    sys.exit(1)
print(f"[auth-gate] PASS: {pct:.2f}% meets the {AUTH_FLOOR:.0f}% auth floor")
PY
