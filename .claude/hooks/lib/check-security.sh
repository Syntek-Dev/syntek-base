# check-security.sh — security audit: local + Docker.
# Python: ruff --select S (flake8-bandit rules)   JS/TS: pnpm audit --audit-level low
# Passes NO ignore flags: pnpm reads `audit.ignore` from pnpm-workspace.yaml itself, and
# there is no CLI flag to pass (see the block below for the false green that cost).
# Sourced by the pre-PR gate runner, never executed directly.
# Uses: PROJECT_ROOT, DEV_COMPOSE, _dual_result, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_security() {
  local local_exit=0 docker_exit=0
  local local_py="" local_js="" docker_py="" docker_js=""

  # ── Ignored advisories are CONFIG, never flags ─────────────────────────────
  # This block used to build `--ignore <GHSA>` arguments. `pnpm audit` has no
  # such flag: given one, pnpm prints "No new vulnerabilities were ignored" and
  # EXITS 0 without auditing anything. Because pnpm-workspace.yaml has always
  # carried ignore entries, the flags were always present, so this leg reported
  # a pass on every run it has ever made — a false green, not a weak check.
  # Measured: the flagged invocation exits 0 while the plain one reports 36
  # advisories (19 high, 17 moderate).
  #
  # pnpm reads the ignore list from pnpm-workspace.yaml itself (`audit.ignore`),
  # which is why the repository's own security audit — which passes no flags —
  # has been reporting correctly all along. Pass nothing and let the config do
  # its job; that is pnpm's own documented behaviour.
  # ── Local Python (ruff flake8-bandit rules) ────────────────────────────────
  # `uv run` resolves the project before running anything, which a TEMPLATE
  # cannot satisfy: pyproject.toml's `name` is an unrendered token and uv.lock is
  # absent by design. The rules themselves are perfectly runnable — only the
  # launcher is not — so template mode calls ruff directly, exactly as the
  # format gate already does. The check still RUNS; it is not skipped.
  if [[ "${TEMPLATE_MODE:-false}" == "true" ]]; then
    local_py=$(cd "$PROJECT_ROOT" && \
      ruff check --select S code/src/django/ 2>&1) || local_exit=1
  else
    local_py=$(cd "$PROJECT_ROOT" && \
      uv run ruff check --select S code/src/django/ 2>&1) || local_exit=1
  fi

  # ── Local JS/TS (pnpm audit) ───────────────────────────────────────────────
  local_js=$(cd "$PROJECT_ROOT" && \
    pnpm audit --audit-level low 2>&1) || local_exit=1
  printf '%s' "$local_js" \
    | grep -qE '[0-9]+ (low|moderate|high|critical) severity' && local_exit=1 || true

  # ── Docker Python (ruff flake8-bandit rules) ──────────────────────────────
  docker_py=$(_dc exec -T django \
    uv run ruff check --select S code/src/django/ 2>&1) || docker_exit=1

  # pnpm audit is host-only — the django image carries no Node toolchain, so the
  # local result is folded into the Docker leg rather than re-run in the container.
  docker_js="$local_js"

  local combined_local combined_docker
  combined_local=$(printf 'Python (ruff S):\n%s\n\nJS/TS (pnpm audit):\n%s' \
    "$local_py" "$local_js")
  combined_docker=$(printf 'Python (ruff S):\n%s\n\nJS/TS (pnpm audit):\n%s' \
    "$docker_py" "$docker_js")

  _dual_result "security" "$local_exit" "$docker_exit" "$combined_local" "$combined_docker"

  if [[ "${CHECK_PASS[security]}" == "true" ]]; then
    CHECK_SUMMARY["security"]="No security issues (local ✓ Docker ✓)"
  elif [[ -z "${CHECK_SUMMARY[security]:-}" ]]; then
    local top
    top=$(printf '%s\n%s\n%s\n%s' "$local_py" "$local_js" "$docker_py" "$docker_js" \
      | grep -E '(Found [0-9]+ error|severity vulnerability)' | head -3 | tr '\n' '; ')
    CHECK_SUMMARY["security"]="${top:-Security issues found}"
  fi
}
