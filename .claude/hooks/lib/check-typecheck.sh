#!/usr/bin/env bash
#
# check-typecheck.sh — Type-check via check.sh (basedpyright + tsc --noEmit).
# Exit 0 = pass | Exit 1 = fail

set -uo pipefail

output=$(bash "$SCRIPTS/syntax/check.sh" 2>&1)
exit_code=$?

printf '%s\n' "$output"

if [[ $exit_code -eq 0 ]]; then
  printf '#SUMMARY:No type errors found\n'
else
  py_err=$(printf '%s\n' "$output" | grep -oE '[0-9]+ error' | head -1 || true)
  printf '#SUMMARY:%s\n' "${py_err:-Type errors found}"
  exit 1
fi
