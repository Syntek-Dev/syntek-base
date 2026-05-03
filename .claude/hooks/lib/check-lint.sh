#!/usr/bin/env bash
#
# check-lint.sh — Runs the project lint script and captures pass/fail.
# Exit 0 = pass | Exit 1 = fail

set -uo pipefail

output=$(bash "$SCRIPTS/syntax/lint.sh" 2>&1)
exit_code=$?

printf '%s\n' "$output"

if [[ $exit_code -eq 0 ]]; then
  printf '#SUMMARY:No lint issues found\n'
else
  err=$(printf '%s\n' "$output" | grep -oE '[0-9]+ error' | head -1 || true)
  printf '#SUMMARY:%s\n' "${err:-Lint issues found}"
  exit 1
fi
