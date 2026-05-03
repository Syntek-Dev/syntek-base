#!/usr/bin/env bash
#
# check-tests.sh — Run full test suite; enforce 80% coverage floor on staging/main.
# Exit 0 = pass | Exit 1 = fail
#
# Requires: SCRIPTS, PROJECT_ROOT, BRANCH_TIER, EXTRA_COVERAGE_FLOOR exported.

set -uo pipefail

tier="${BRANCH_TIER:-feature}"
floor="${EXTRA_COVERAGE_FLOOR:-0}"
exit_code=0

if [[ "$tier" == "staging" || "$tier" == "main" ]]; then
  printf '  Running tests with coverage (%s%% floor enforced for %s)...\n' "$floor" "$tier"
  output=$(bash "$SCRIPTS/tests/all.sh" --coverage 2>&1) || exit_code=$?
else
  printf '  Running tests...\n'
  output=$(bash "$SCRIPTS/tests/all.sh" 2>&1) || exit_code=$?
fi

printf '%s\n' "$output"

if [[ $exit_code -ne 0 ]]; then
  f=$(printf '%s\n' "$output" | grep -oE '[0-9]+ failed' | head -1 || true)
  printf '#SUMMARY:%s\n' "${f:-Tests failed}"
  exit 1
fi

# Coverage floor for staging/main
if [[ "$tier" == "staging" || "$tier" == "main" ]]; then
  failed_layers=()

  backend_cov=0
  backend_xml="$PROJECT_ROOT/code/src/scripts/tests/reports/backend-coverage/coverage.xml"
  if [[ -f "$backend_xml" ]]; then
    backend_cov=$(python3 -c "
import xml.etree.ElementTree as ET
try:
    root = ET.parse('$backend_xml').getroot()
    rate = float(root.get('line-rate', 0))
    print(int(rate * 100))
except Exception:
    print(0)
" 2>/dev/null || echo "0")
  else
    backend_cov=$(printf '%s\n' "$output" \
      | grep -oP 'TOTAL\s+\d+\s+\d+\s+\K\d+(?=%)' | tail -1 || echo "0")
  fi

  frontend_cov=0
  frontend_summary="$PROJECT_ROOT/code/src/scripts/tests/reports/frontend-coverage/coverage-summary.json"
  if [[ -f "$frontend_summary" ]]; then
    frontend_cov=$(python3 -c "
import json
try:
    d = json.load(open('$frontend_summary'))
    pct = d.get('total', {}).get('lines', {}).get('pct', 0)
    print(int(float(pct)))
except Exception:
    print(0)
" 2>/dev/null || echo "0")
  fi

  printf '  Coverage — backend: %s%% frontend: %s%% (threshold: %s%%)\n' \
    "$backend_cov" "$frontend_cov" "$floor"

  for layer_name in backend frontend; do
    [[ "$layer_name" == "backend" ]] && val="$backend_cov" || val="$frontend_cov"
    val="${val%%.*}"
    if [[ "$val" -lt "$floor" ]]; then
      delta=$(( floor - val ))
      failed_layers+=("${layer_name} ${val}% (need +${delta}%)")
    fi
  done

  if [[ ${#failed_layers[@]} -gt 0 ]]; then
    ls_str=$(IFS=', '; echo "${failed_layers[*]}")
    p=$(printf '%s\n' "$output" | grep -oE '[0-9]+ passed' | tail -1 || true)
    printf '#SUMMARY:%sTests passed [%s requires %s%%: %s]\n' \
      "${p:+${p} · }" "$tier" "$floor" "$ls_str"
    exit 1
  fi
fi

p=$(printf '%s\n' "$output" | grep -oE '[0-9]+ passed' | tail -1 || true)
printf '#SUMMARY:%s\n' "${p:+${p} · }All tests passed"
