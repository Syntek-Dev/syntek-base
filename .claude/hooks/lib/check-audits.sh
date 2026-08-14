# check-audits.sh — the template's own gate: every audit, plus the shipped-file checks.
#
# TEMPLATE MODE ONLY. In a generated project the eight application checks are the
# gate and this one does not run; in syntek-base itself the application checks
# have no subject (see pre-pr-check.sh § 2b) and THIS is the substantive gate —
# the template's product is its structure, its routing and its documentation, and
# that is exactly what these scripts read.
#
# Scope, and why it is defined by a directory rather than a list: a list drifts
# the moment an audit is added, and the failure is silent — a new gate that the
# PR check never runs looks identical to a gate that passes. Two are excluded
# because a dedicated check already owns them, and running them twice would
# report one defect as two:
#
#   cloc.sh      → gate [1/8] cloc
#   security.sh  → gate [8/8] security
#
# Every audit is expected to self-skip when its surface is absent (mobile, rust,
# desktop, CSS). One that fails for want of a surface is a bug in that audit, and
# surfacing it here is correct rather than something to filter out.
#
# Source: .claude/hooks/pre-pr-check.sh
# Uses: PROJECT_ROOT, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_audits() {
  local failed=() passed=0 out="" name rc
  local audit_dir="$PROJECT_ROOT/code/src/scripts/audits"

  for script in "$audit_dir"/*.sh; do
    [[ -f "$script" ]] || continue
    name=$(basename "$script")
    case "$name" in
      cloc.sh | security.sh) continue ;;
    esac
    local script_out
    script_out=$(bash "$script" 2>&1)
    rc=$?
    if [[ $rc -eq 0 ]]; then
      passed=$((passed + 1))
    else
      failed+=("$name")
      out+=$(printf '\n── %s (exit %s) ───────────────────────────────\n%s\n' \
        "$name" "$rc" "$(printf '%s' "$script_out" | tail -25)")
    fi
  done

  # The shipped-file integrity checks are CI-enforced and template-only: they
  # prove that what a generated project receives still matches this repository.
  # Nothing in the eight application checks looks at them.
  for script in "$PROJECT_ROOT"/.github/scripts/shipped-*.sh; do
    [[ -f "$script" ]] || continue
    name=$(basename "$script")
    local script_out
    script_out=$(bash "$script" 2>&1)
    rc=$?
    if [[ $rc -eq 0 ]]; then
      passed=$((passed + 1))
    else
      failed+=("$name")
      out+=$(printf '\n── %s (exit %s) ───────────────────────────────\n%s\n' \
        "$name" "$rc" "$(printf '%s' "$script_out" | tail -25)")
    fi
  done

  CHECK_OUTPUT["audits"]="${out:-all audits clean}"

  if [[ ${#failed[@]} -eq 0 ]]; then
    CHECK_PASS["audits"]="true"
    CHECK_SUMMARY["audits"]="${passed} audit(s) clean"
  else
    CHECK_PASS["audits"]="false"
    CHECK_SUMMARY["audits"]="${#failed[@]} failed: $(
      IFS=', '
      echo "${failed[*]}"
    )"
  fi
}
