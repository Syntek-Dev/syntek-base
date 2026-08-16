# check-lint.sh — lint check.
# Python (backend): ruff check — run local AND in Docker (host/container drift check).
# JS: ESLint over the repo. The site is server-rendered, so the only JavaScript is the
#   progressive-enhancement scripts under code/src/django/static/js/. ESLint runs in the
#   host Node toolchain, so this leg is host-only and folded identically into both legs
#   (no container to drift against). Django templates carry no ESLint — they are covered
#   by the Python gate (ruff) and the backend pytest gate.
# Sourced by the pre-PR gate runner, never executed directly.
# Uses: PROJECT_ROOT, DEV_COMPOSE, _dual_result, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_lint() {
  local local_exit=0 docker_exit=0
  local local_py="" docker_py="" js_out="" js_exit=0

  # ── Python — local + Docker (drift check) ──────────────────────────────────
  local_py=$(ruff check "$PROJECT_ROOT/code/src/django/" 2>&1) \
    || local_exit=1
  docker_py=$(_dc exec -T django \
    ruff check code/src/django/ 2>&1) || docker_exit=1

  # ── JS — repo-wide, host-only (folded into both legs) ──────────────────────
  js_out=$(cd "$PROJECT_ROOT" && pnpm exec eslint . 2>&1) || js_exit=1
  [[ $js_exit -ne 0 ]] && { local_exit=1; docker_exit=1; }

  local combined_local combined_docker
  combined_local=$(printf 'Python (ruff check):\n%s\n\nJS (eslint):\n%s' \
    "$local_py" "$js_out")
  combined_docker=$(printf 'Python (ruff check):\n%s\n\nJS (eslint):\n%s' \
    "$docker_py" "$js_out")

  _dual_result "lint" "$local_exit" "$docker_exit" "$combined_local" "$combined_docker"

  if [[ "${CHECK_PASS[lint]}" == "true" ]]; then
    CHECK_SUMMARY["lint"]="No lint issues (Python local ✓ Docker ✓ · JS ✓)"
  elif [[ -z "${CHECK_SUMMARY[lint]:-}" ]]; then
    local e; e=$(printf '%s\n%s' "$local_py" "$js_out" \
      | grep -oE '[0-9]+ error' | head -1)
    CHECK_SUMMARY["lint"]="${e:-Lint issues found}"
  fi
}
