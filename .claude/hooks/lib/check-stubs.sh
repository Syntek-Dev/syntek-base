# check-stubs.sh — stub audit (local only; grep on host-mounted source files).
# Sourced by the pre-PR gate runner, never executed directly.
# Uses: SCRIPTS, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_stubs() {
  local output="" exit_code=0
  output=$(bash "$SCRIPTS/audits/stubs.sh" 2>&1) || exit_code=$?
  CHECK_OUTPUT["stubs"]="$output"
  if [[ $exit_code -eq 0 ]]; then
    CHECK_PASS["stubs"]="true"
    CHECK_SUMMARY["stubs"]="No hard stubs found"
  else
    CHECK_PASS["stubs"]="false"
    local h; h=$(printf '%s' "$output" | grep -oE '[0-9]+ occurrence' | head -1)
    CHECK_SUMMARY["stubs"]="${h:-Hard stubs found}"
  fi
}
