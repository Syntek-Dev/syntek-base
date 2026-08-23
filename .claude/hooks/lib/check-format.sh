# check-format.sh — format check.
# Python (backend): ruff format --check — run local AND in Docker (host/container drift check).
# Prettier: repo-wide (Markdown, CSS, JSON, YAML, JS), scoped by .prettierignore. It runs in
#   the host Node toolchain, so this leg is host-only and is folded identically into both
#   legs (no container to drift against).
# Sourced by the pre-PR gate runner, never executed directly.
# Uses: PROJECT_ROOT, DEV_COMPOSE, _dual_result, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_format() {
  local local_exit=0 docker_exit=0
  local local_py="" docker_py="" js_out="" js_exit=0

  # ── Python — local + Docker (drift check) ──────────────────────────────────
  local_py=$(ruff format --check "$PROJECT_ROOT/code/src/django/" 2>&1) \
    || local_exit=1
  docker_py=$(_dc exec -T django \
    ruff format --check code/src/django/ 2>&1) || docker_exit=1

  # ── Prettier — repo-wide, host-only (folded into both legs) ────────────────
  js_out=$(cd "$PROJECT_ROOT" && pnpm exec prettier --check . 2>&1) || js_exit=1
  [[ $js_exit -ne 0 ]] && { local_exit=1; docker_exit=1; }

  local combined_local combined_docker
  combined_local=$(printf 'Python (ruff format --check):\n%s\n\nPrettier (--check):\n%s' \
    "$local_py" "$js_out")
  combined_docker=$(printf 'Python (ruff format --check):\n%s\n\nPrettier (--check):\n%s' \
    "$docker_py" "$js_out")

  _dual_result "format" "$local_exit" "$docker_exit" "$combined_local" "$combined_docker"

  if [[ "${CHECK_PASS[format]}" == "true" ]]; then
    CHECK_SUMMARY["format"]="All files correctly formatted (Python local ✓ Docker ✓ · Prettier ✓)"
  elif [[ -z "${CHECK_SUMMARY[format]:-}" ]]; then
    # `grep -c` prints 0 AND exits 1 when nothing matches, so the old
    # `|| echo "?"` fallback appended to the count instead of replacing it and
    # the summary read "0\n? file(s) need formatting". Swallow the exit with
    # `|| true` and count Prettier's real marker — it reports `[warn] <path>`,
    # which none of the previous patterns matched, so a Prettier-only failure
    # always counted zero.
    local count
    count=$(printf '%s\n%s' "$local_py" "$js_out" \
      | grep -cE '(would reformat|needs formatting|Unformatted|^\[warn\] )' 2>/dev/null || true)
    CHECK_SUMMARY["format"]="${count:-some} file(s) need formatting — run format.sh --fix"
  fi
}
