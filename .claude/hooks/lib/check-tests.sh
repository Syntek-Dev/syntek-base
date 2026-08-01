# check-tests.sh — tests (Docker only; needs full stack).
# _apply_coverage_floor enforces 80% on staging/main via report files.
#
# Backend pytest (the `all.sh` backend phase) covers the Django-rendered pages, templates,
# and django-components — it is the only unit/integration suite. The site is server-rendered
# and carries no JavaScript test layer, so there is no frontend coverage source and the
# coverage floor applies to the backend alone.
# Source: .claude/hooks/pre-pr-check.sh
# Uses: SCRIPTS, BRANCH_TIER, COVERAGE_THRESHOLD, PROJECT_ROOT,
#       CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT, BACKEND_COV

_check_tests() {
  local output="" exit_code=0

  if [[ "$BRANCH_TIER" == "staging_main" ]]; then
    output=$(bash "$SCRIPTS/tests/all.sh" --coverage 2>&1) || exit_code=$?
  else
    output=$(bash "$SCRIPTS/tests/all.sh" 2>&1) || exit_code=$?
  fi

  CHECK_OUTPUT["tests"]="$output"

  if [[ $exit_code -eq 0 ]]; then
    CHECK_PASS["tests"]="true"
    local p; p=$(printf '%s' "$output" | grep -oE '[0-9]+ passed' | tail -1)
    CHECK_SUMMARY["tests"]="${p:+${p} · }All tests passed"
  elif [[ $exit_code -eq 5 ]]; then
    # pytest exit code 5 = no tests collected; pass with warning on non-staging/main branches
    if [[ "$BRANCH_TIER" == "staging_main" ]]; then
      CHECK_PASS["tests"]="false"
      CHECK_SUMMARY["tests"]="No tests collected — required before merging to staging/main"
    else
      CHECK_PASS["tests"]="true"
      CHECK_SUMMARY["tests"]="No tests collected yet — add tests before merging to staging/main"
    fi
  else
    CHECK_PASS["tests"]="false"
    local f; f=$(printf '%s' "$output" | grep -oE '[0-9]+ failed' | head -1)
    CHECK_SUMMARY["tests"]="${f:-Tests failed}"
  fi
}

_apply_coverage_floor() {
  [[ "$BRANCH_TIER" != "staging_main" ]] && return 0
  [[ "${CHECK_PASS[tests]:-false}" != "true" ]] && return 0

  local backend_cov=0 failed_layers=()

  local xml="$PROJECT_ROOT/code/src/scripts/tests/reports/backend-coverage/coverage.xml"
  if [[ -f "$xml" ]]; then
    backend_cov=$(python3 -c "
import xml.etree.ElementTree as ET
try:
    root = ET.parse('$xml').getroot()
    print(int(float(root.get('line-rate', 0)) * 100))
except Exception:
    print(0)
" 2>/dev/null || echo "0")
  else
    backend_cov=$(printf '%s' "${CHECK_OUTPUT[tests]}" \
      | grep -oP 'TOTAL\s+\d+\s+\d+\s+\K\d+(?=%)' | tail -1 || echo "0")
  fi

  BACKEND_COV=$backend_cov

  [[ "$backend_cov"  -lt "$COVERAGE_THRESHOLD" ]] && failed_layers+=("backend ${backend_cov}%")

  if [[ ${#failed_layers[@]} -gt 0 ]]; then
    CHECK_PASS["tests"]="false"
    local ls; ls=$(IFS=', '; echo "${failed_layers[*]}")
    CHECK_SUMMARY["tests"]+=" [staging/main requires ${COVERAGE_THRESHOLD}%: ${ls} below floor]"
  else
    CHECK_SUMMARY["tests"]+=" [coverage: backend=${backend_cov}%]"
  fi
}
