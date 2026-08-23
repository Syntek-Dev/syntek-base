# check-typecheck.sh — type-check.
# Python (backend): basedpyright — run local (if on PATH) AND in Docker (host/container drift).
# There is no JavaScript type-check leg here: the WEB surface is server-rendered and has no
#   TypeScript, and its Alpine scripts are linted rather than type-checked. The optional
#   MOBILE surface does carry TypeScript, checked by code/src/scripts/mobile/typecheck.sh and
#   reachable as syntax/check.sh --file-type typescript — not from this gate.
# Sourced by the pre-PR gate runner, never executed directly.
# Uses: PROJECT_ROOT, DEV_COMPOSE, _dual_result, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_typecheck() {
  local local_exit=0 docker_exit=0
  local local_py="" docker_py=""

  # ── Python — local (if available) + Docker ─────────────────────────────────
  if command -v basedpyright &>/dev/null; then
    local_py=$(basedpyright "$PROJECT_ROOT/code/src/django/" 2>&1) \
      || local_exit=1
  else
    # NO RESULT, not a clean result. This used to leave local_exit at its initialiser, so
    # _dual_result read "0 && 0" as a pass and the gate printed
    # "No type errors (Python local ✓ Docker ✓)" over a host leg that never ran — and, worse,
    # printed "MISMATCH: passed locally, failed in Docker" when Docker went red, asserting a
    # host result that was never produced. Rule: code/docs/GATE-REPORTING.md.
    local_py="(basedpyright not on host PATH — this leg COULD NOT RUN)"
    local_exit="$LEG_UNMEASURED"
  fi
  docker_py=$(_dc exec -T django \
    basedpyright code/src/django/ 2>&1) || docker_exit=1

  local combined_local combined_docker
  combined_local=$(printf 'Python (basedpyright):\n%s' "$local_py")
  combined_docker=$(printf 'Python (basedpyright):\n%s' "$docker_py")

  _dual_result "typecheck" "$local_exit" "$docker_exit" "$combined_local" "$combined_docker"

  if [[ "${CHECK_PASS[typecheck]}" == "true" ]]; then
    CHECK_SUMMARY["typecheck"]="No type errors (Python local ✓ Docker ✓)"
  elif [[ -z "${CHECK_SUMMARY[typecheck]:-}" ]]; then
    local e; e=$(printf '%s' "$local_py" | grep -oE '[0-9]+ error' | head -1)
    CHECK_SUMMARY["typecheck"]="${e:-Type errors found}"
  fi
}
