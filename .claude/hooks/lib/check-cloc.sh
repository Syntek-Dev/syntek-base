# check-cloc.sh — line-count enforcement via cloc.sh (local only).
# Source: .claude/hooks/pre-pr-check.sh
# Uses: PROJECT_ROOT, SCRIPTS, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_cloc() {
  local output="" exit_code=0
  output=$(bash "$SCRIPTS/audits/cloc.sh" 2>&1) || exit_code=$?
  CHECK_OUTPUT["cloc"]="$output"
  if [[ $exit_code -eq 0 ]]; then
    CHECK_PASS["cloc"]="true"
    local w; w=$(printf '%s' "$output" | grep -oE '[0-9]+ file[s]? approaching' | head -1)
    CHECK_SUMMARY["cloc"]="${w:+${w} — }All files within 800-line limit"
  else
    CHECK_PASS["cloc"]="false"
    local e; e=$(printf '%s' "$output" \
      | grep -oE '[0-9]+ file[s]? exceed' | head -1)
    CHECK_SUMMARY["cloc"]="${e:-File(s) exceed 800-line hard limit}"
  fi
}
