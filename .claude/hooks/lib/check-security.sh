# check-security.sh — security audit: local + Docker.
# Python: ruff --select S (flake8-bandit rules)   JS/TS: pnpm audit --audit-level low
# Reads auditConfig.ignoreGhsas/ignoreCves from pnpm-workspace.yaml (pnpm 11's home for
# these settings; falls back to package.json pnpm.auditConfig for older configs) to build
# pnpm audit --ignore flags. Malformed (whitespace) entries are skipped.
# Source: .claude/hooks/pre-pr-check.sh
# Uses: PROJECT_ROOT, DEV_COMPOSE, _dual_result, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_security() {
  local local_exit=0 docker_exit=0
  local local_py="" local_js="" docker_py="" docker_js=""

  # ── Build pnpm --ignore flags from auditConfig (pnpm-workspace.yaml; pkg.json fallback) ──
  local IGNORE_FLAGS=()
  local ignore_json
  ignore_json=$(python3 -c "
import json
ids = []
# pnpm 11: auditConfig lives in pnpm-workspace.yaml
try:
    import yaml
    ws = yaml.safe_load(open('$PROJECT_ROOT/pnpm-workspace.yaml')) or {}
    ac = ws.get('auditConfig', {}) or {}
    ids += (ac.get('ignoreGhsas', []) or []) + (ac.get('ignoreCves', []) or [])
except Exception:
    pass
# legacy fallback: package.json pnpm.auditConfig (pre-pnpm-11)
try:
    pkg = json.load(open('$PROJECT_ROOT/package.json'))
    ac = pkg.get('pnpm', {}).get('auditConfig', {})
    ids += (ac.get('ignoreCves', []) or []) + (ac.get('ignoreGhsas', []) or [])
except Exception:
    pass
seen = set(); out = []
for i in ids:
    i = str(i).strip()
    if i and ' ' not in i and i not in seen:
        seen.add(i); out.append(i)
print(' '.join(out))
" 2>/dev/null || true)
  for cve in $ignore_json; do
    IGNORE_FLAGS+=("--ignore" "$cve")
  done

  # ── Local Python (ruff flake8-bandit rules) ────────────────────────────────
  local_py=$(cd "$PROJECT_ROOT" && \
    uv run ruff check --select S code/src/django/ 2>&1) || local_exit=1

  # ── Local JS/TS (pnpm audit) ───────────────────────────────────────────────
  local_js=$(cd "$PROJECT_ROOT" && \
    pnpm audit --audit-level low "${IGNORE_FLAGS[@]}" 2>&1) || local_exit=1
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
