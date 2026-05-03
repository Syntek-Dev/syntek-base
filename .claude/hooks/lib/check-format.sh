#!/usr/bin/env bash
#
# check-format.sh — Dry-run code style check (ruff + Prettier) via format.sh.
# Exit 0 = pass | Exit 1 = fail

set -uo pipefail

output=$(bash "$SCRIPTS/syntax/format.sh" 2>&1)
exit_code=$?

printf '%s\n' "$output"

if [[ $exit_code -eq 0 ]]; then
  printf '#SUMMARY:No style issues\n'
else
  printf '#SUMMARY:Style issues found — run format.sh --fix to correct\n'
  exit 1
fi
