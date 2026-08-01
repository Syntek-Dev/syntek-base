# check-typecheck.sh — type-check.
# Python (backend): basedpyright — run local (if on PATH) AND in Docker (host/container drift).
# There is no JavaScript type-check leg: the site is server-rendered and the project carries
#   no TypeScript. The Django templates are covered by the Python gate (basedpyright) and
#   backend pytest.
# Source: .claude/hooks/pre-pr-check.sh
# Uses: PROJECT_ROOT, DEV_COMPOSE, _dual_result, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_typecheck() {
  local local_exit=0 docker_exit=0
  local local_py="" docker_py=""

  # ── Python — local (if available) + Docker ─────────────────────────────────
  if command -v basedpyright &>/dev/null; then
    local_py=$(basedpyright "$PROJECT_ROOT/code/src/django/" 2>&1) \
      || local_exit=1
  else
    local_py="(basedpyright not on host PATH — skipped; Docker check is authoritative)"
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
