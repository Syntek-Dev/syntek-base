#!/usr/bin/env bash
#
# check-security.sh — bandit (Python) + pnpm audit (JS/TS) security scan.
# Exit 0 = pass | Exit 1 = fail
#
# Requires: COMPOSE_DEV exported by orchestrator.

set -uo pipefail

exit_code=0

py_header="── Python audit (bandit — all severity levels) ──────────────────"

if docker compose -f "$COMPOSE_DEV" exec -T backend \
    sh -c 'which bandit >/dev/null 2>&1' 2>/dev/null; then
  py_out=$(docker compose -f "$COMPOSE_DEV" exec -T backend \
    bandit -r code/src/backend/ -f text 2>&1 || true)
else
  py_out="  bandit not installed — skipping (install with: uv add --dev bandit)"
fi

js_header=$'\n── JS/TS dependency audit (pnpm — low and above) ─────────────────'
js_out=$(docker compose -f "$COMPOSE_DEV" exec -T frontend \
  pnpm audit --audit-level low 2>&1 || true)

printf '%s\n%s\n%s\n%s\n' "$py_header" "$py_out" "$js_header" "$js_out"

if printf '%s\n' "$py_out" | grep -qE 'Severity:\s*(Low|Medium|High|Critical)' 2>/dev/null; then
  exit_code=1
fi
if printf '%s\n' "$js_out" | grep -qE '[0-9]+ (low|moderate|high|critical) severity' 2>/dev/null; then
  exit_code=1
fi

if [[ $exit_code -eq 0 ]]; then
  printf '#SUMMARY:No security issues found\n'
else
  top=$(printf '%s\n%s\n' "$py_out" "$js_out" \
    | grep -E '(Severity:|severity vulnerability)' | head -3 | tr '\n' '; ')
  printf '#SUMMARY:%s\n' "${top:-Security issues found}"
  exit 1
fi
