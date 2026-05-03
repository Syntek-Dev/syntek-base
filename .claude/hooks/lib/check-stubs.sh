#!/usr/bin/env bash
#
# check-stubs.sh — Detect hard-coded stubs via stubs.sh.
# Exit 0 = pass | Exit 1 = fail

set -uo pipefail

output=$(bash "$SCRIPTS/audits/stubs.sh" 2>&1)
exit_code=$?

printf '%s\n' "$output"

if [[ $exit_code -eq 0 ]]; then
  printf '#SUMMARY:No hard stubs found\n'
else
  h=$(printf '%s\n' "$output" | grep -oE '[0-9]+ occurrence' | head -1 || true)
  printf '#SUMMARY:%s\n' "${h:-Hard stubs found}"
  exit 1
fi
