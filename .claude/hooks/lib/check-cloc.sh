#!/usr/bin/env bash
#
# check-cloc.sh — Enforce 800-line file limit.
# Outputs full cloc audit, then a #SUMMARY: sentinel on the last line.
# Exit 0 = pass | Exit 1 = fail

set -uo pipefail

output=$(bash "$SCRIPTS/audits/cloc.sh" 2>&1)
exit_code=$?

printf '%s\n' "$output"

if [[ $exit_code -eq 0 ]]; then
  warn=$(printf '%s\n' "$output" | grep -oE '[0-9]+ file' | head -1 || true)
  if [[ -n "$warn" ]]; then
    printf '#SUMMARY:%ss approaching limit · All files within 800-line limit\n' "$warn"
  else
    printf '#SUMMARY:All files within 800-line limit\n'
  fi
else
  err=$(printf '%s\n' "$output" | grep -oE '[0-9]+ file' | head -1 || true)
  printf '#SUMMARY:%s\n' "${err:-File(s) exceed 800-line limit}"
  exit 1
fi
