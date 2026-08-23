# check-tests.sh — tests (Docker only; needs full stack).
# _check_tests always runs with coverage; _apply_coverage_floor enforces the branch tier's
# line floor plus the flat auth floor, both read from the Cobertura report.
#
# Backend pytest (the `all.sh` backend phase) covers the Django-rendered pages, templates,
# and django-components — it is the only unit/integration suite. The site is server-rendered
# and carries no JavaScript test layer, so there is no frontend coverage source and the
# coverage floor applies to the backend alone.
#
# THE NUMBERS ARE NOT DECIDED HERE. The project's coverage standard owns them:
# COVERAGE_THRESHOLD is set by the caller from the branch tier (75 always, 80 from
# `testing` upward); AUTH_FLOOR does not tier. Change the standard first, then these.
# Sourced by the pre-PR gate runner, never executed directly.
# Uses: SCRIPTS, BRANCH_TIER, COVERAGE_THRESHOLD, PROJECT_ROOT,
#       CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT, BACKEND_COV

# The app whose coverage carries the auth floor. Mirrors the AUTH_APP the backend
# coverage script measures — keep the two in step.
: "${AUTH_APP:=users}"
AUTH_FLOOR=90

_check_tests() {
  local output="" exit_code=0

  # Coverage on every tier. 75 is the always-floor, so a feature branch that measured
  # nothing would be reporting a floor it never checked — which is the defect this gate
  # exists to catch, one level up.
  output=$(bash "$SCRIPTS/tests/all.sh" --coverage 2>&1) || exit_code=$?

  CHECK_OUTPUT["tests"]="$output"

  if [[ $exit_code -eq 0 ]]; then
    CHECK_PASS["tests"]="true"
    local p; p=$(printf '%s' "$output" | grep -oE '[0-9]+ passed' | tail -1)
    CHECK_SUMMARY["tests"]="${p:+${p} · }All tests passed"
  elif [[ $exit_code -eq 5 ]]; then
    # pytest exit code 5 = no tests collected; pass with a warning below the promotion tier
    if [[ "$BRANCH_TIER" == "promotion" ]]; then
      CHECK_PASS["tests"]="false"
      CHECK_SUMMARY["tests"]="No tests collected — required before promoting"
    else
      CHECK_PASS["tests"]="true"
      CHECK_SUMMARY["tests"]="No tests collected yet — add tests before promoting"
    fi
  else
    CHECK_PASS["tests"]="false"
    local f; f=$(printf '%s' "$output" | grep -oE '[0-9]+ failed' | head -1)
    CHECK_SUMMARY["tests"]="${f:-Tests failed}"
  fi
}

_apply_coverage_floor() {
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

  # The auth floor is measured separately because the aggregate can clear its floor while
  # the auth app sits under its own. Skipped only while apps/$AUTH_APP does not exist; once
  # it does, a report measuring none of it fails closed rather than reporting 0 and passing.
  local auth_cov=""
  if [[ -d "$PROJECT_ROOT/code/src/django/apps/$AUTH_APP" && -f "$xml" ]]; then
    auth_cov=$(python3 - "$xml" "$AUTH_APP" <<'PY' 2>/dev/null || echo "-1"
import sys
import xml.etree.ElementTree as ET

xml_path, auth_app = sys.argv[1], sys.argv[2]
needle = f"apps/{auth_app}/"
try:
    root = ET.parse(xml_path).getroot()
except (OSError, ET.ParseError):
    print(-1)
    raise SystemExit(0)

covered = total = 0
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

print(-1 if total == 0 else int(covered / total * 100))
PY
    )
    if [[ "$auth_cov" -lt 0 ]]; then
      failed_layers+=("auth unmeasurable")
    elif [[ "$auth_cov" -lt "$AUTH_FLOOR" ]]; then
      failed_layers+=("auth ${auth_cov}%")
    fi
  fi

  if [[ ${#failed_layers[@]} -gt 0 ]]; then
    CHECK_PASS["tests"]="false"
    local ls; ls=$(IFS=', '; echo "${failed_layers[*]}")
    CHECK_SUMMARY["tests"]+=" [${BRANCH_TIER} tier requires ${COVERAGE_THRESHOLD}% line"
    CHECK_SUMMARY["tests"]+=", ${AUTH_FLOOR}% auth: ${ls} below floor]"
  else
    CHECK_SUMMARY["tests"]+=" [coverage: backend=${backend_cov}%${auth_cov:+ · auth=${auth_cov}%}]"
  fi
}
