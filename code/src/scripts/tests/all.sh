#!/usr/bin/env bash
#
# all.sh — Run backend, frontend, and mobile test suites in sequence.
#
# Usage: all.sh [--coverage]
#
#   --coverage   Run coverage variants for all three suites.
#                Default: plain test runs.
#
# Stops on first failure. Does not run E2E tests — use e2e.sh explicitly.
# Backend requires the test stack to be running; frontend and mobile are one-shot.
#
# Each sub-script writes its own report to its default output directory:
#   reports/backend/         or  reports/backend-coverage/
#   reports/frontend/        or  reports/frontend-coverage/
#   reports/mobile/          or  reports/mobile-coverage/
#
# Exit codes:  0 = all suites passed   1 = first failure   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

COVERAGE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --coverage) COVERAGE=true; shift ;;
    *) printf 'all.sh: unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

if [[ "$COVERAGE" == "true" ]]; then
  printf '[all] Running backend coverage...\n'
  "$SCRIPT_DIR/backend-coverage.sh"

  printf '[all] Running frontend coverage...\n'
  "$SCRIPT_DIR/frontend-coverage.sh"

  printf '[all] Running mobile coverage...\n'
  "$SCRIPT_DIR/mobile-coverage.sh"
else
  printf '[all] Running backend tests...\n'
  "$SCRIPT_DIR/backend.sh"

  printf '[all] Running frontend tests...\n'
  "$SCRIPT_DIR/frontend.sh"

  printf '[all] Running mobile tests...\n'
  "$SCRIPT_DIR/mobile.sh"
fi

printf '[all] All tests passed.\n'
