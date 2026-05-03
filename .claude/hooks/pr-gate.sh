#!/usr/bin/env bash
#
# pr-gate.sh — Claude Code PreToolUse hook.
#
# Intercepts `gh pr create` and `gh pr new` commands, runs the full 8-check
# suite via modular lib/ scripts, and blocks the PR if any check fails.
#
# Exit codes:  0 = allow PR creation  |  2 = block (report on stdout)

set -uo pipefail

# ── Parse stdin ───────────────────────────────────────────────────────────────
INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))' \
  2>/dev/null || true)

if ! printf '%s' "$COMMAND" | grep -qE 'gh pr (create|new)\b'; then
  exit 0
fi

# ── Paths ─────────────────────────────────────────────────────────────────────
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"
export SCRIPTS="$PROJECT_ROOT/code/src/scripts"
export COMPOSE_DEV="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
export COMPOSE_TEST="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"

HISTORY_DIR="$HOME/.claude/pr-check-history"
SAFE_BRANCH=""  # set after BRANCH is known

# ── Context ───────────────────────────────────────────────────────────────────
BRANCH=$(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
COMMIT=$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
SAFE_BRANCH="${BRANCH//\//-}"
HISTORY_FILE="$HISTORY_DIR/${SAFE_BRANCH}.json"

case "$BRANCH" in
  us[0-9]*/*|pm/*|fix/*|chore/*) BRANCH_TIER="feature" ;;
  testing)                         BRANCH_TIER="testing" ;;
  dev)                             BRANCH_TIER="dev"     ;;
  staging)                         BRANCH_TIER="staging" ;;
  main)                            BRANCH_TIER="main"    ;;
  *)                               BRANCH_TIER="feature" ;;
esac

if [[ "$BRANCH_TIER" == "staging" || "$BRANCH_TIER" == "main" ]]; then
  EXTRA_COVERAGE_FLOOR=80
else
  EXTRA_COVERAGE_FLOOR=0
fi
export BRANCH_TIER EXTRA_COVERAGE_FLOOR

# ── Attempt count (from durable per-branch history) ───────────────────────────
ATTEMPT=$(python3 - <<PYEOF
import json
try:
    with open("$HISTORY_FILE") as f:
        history = json.load(f)
    print(len(history) + 1 if isinstance(history, list) else 1)
except Exception:
    print(1)
PYEOF
)

# ── Docker helpers ────────────────────────────────────────────────────────────
dev_running() {
  docker compose -f "$COMPOSE_DEV" ps --status running 2>/dev/null \
    | grep -qE '\b(backend|frontend)\b'
}
test_running() {
  docker compose -f "$COMPOSE_TEST" ps --status running 2>/dev/null \
    | grep -qE '\bbackend-test\b'
}

ensure_dev_stack() {
  dev_running && return 0
  printf '  Dev containers not running — starting dev stack...\n'
  bash "$SCRIPTS/development/server.sh" up
  local i
  for i in $(seq 1 18); do
    sleep 5
    if dev_running; then printf '  Dev stack ready.\n'; return 0; fi
  done
  printf '  ERROR: Dev stack failed to start after 90 s.\n'
  return 1
}

ensure_test_stack() {
  test_running && return 0
  printf '  Test containers not running — starting test stack...\n'
  docker compose -f "$COMPOSE_TEST" up -d
  local i
  for i in $(seq 1 18); do
    sleep 5
    if test_running; then printf '  Test stack ready.\n'; return 0; fi
  done
  printf '  ERROR: Test stack failed to start after 90 s.\n'
  return 1
}

# ── Check runner ──────────────────────────────────────────────────────────────
declare -A CHECK_PASS=()
declare -A CHECK_SUMMARY=()
declare -A CHECK_OUTPUT=()

run_check() {
  local name="$1"
  local raw exit_code=0
  raw=$(bash "$HOOK_DIR/lib/check-${name}.sh" 2>&1) || exit_code=$?

  # Strip the #SUMMARY: sentinel from the last line
  local last_line summary="" output
  last_line=$(printf '%s' "$raw" | tail -n 1)
  if [[ "$last_line" == '#SUMMARY:'* ]]; then
    summary="${last_line#'#SUMMARY:'}"
    output=$(printf '%s' "$raw" | head -n -1)
  else
    output="$raw"
  fi

  CHECK_OUTPUT["$name"]="$output"
  CHECK_SUMMARY["$name"]="$summary"
  [[ $exit_code -eq 0 ]] && CHECK_PASS["$name"]="true" || CHECK_PASS["$name"]="false"
}

# ── Header ────────────────────────────────────────────────────────────────────
tier_sfx=$([[ "$BRANCH_TIER" == "staging" || "$BRANCH_TIER" == "main" ]] && echo " [80% floor]" || echo "")
printf '\n'
printf '╔══════════════════════════════════════════════════════════════════╗\n'
printf '║  PR Gate — Attempt %-3s — %-39s ║\n' "$ATTEMPT" "${BRANCH}${tier_sfx}"
printf '╚══════════════════════════════════════════════════════════════════╝\n'
printf '  Commit: %s  |  Started: %s\n\n' "$COMMIT" "$TIMESTAMP"

# ── Start stacks ──────────────────────────────────────────────────────────────
printf '  Ensuring Docker stacks...\n'
ensure_dev_stack  || exit 2
ensure_test_stack || exit 2
printf '\n'

# ── Run checks ────────────────────────────────────────────────────────────────
printf '  Running checks (may take several minutes)...\n\n'

printf '  [1/8] Line count audit\n';            run_check "cloc"
printf '  [2/8] Lockfile + Docker alignment\n'; run_check "lockfiles"
printf '  [3/8] Code style (format)\n';         run_check "format"
printf '  [4/8] Lint\n';                        run_check "lint"
printf '  [5/8] Stub audit\n';                  run_check "stubs"
printf '  [6/8] Type checking\n';               run_check "typecheck"

if [[ "$BRANCH_TIER" == "staging" || "$BRANCH_TIER" == "main" ]]; then
  printf '  [7/8] Tests + coverage (%s%% floor enforced)\n' "$EXTRA_COVERAGE_FLOOR"
else
  printf '  [7/8] Tests\n'
fi
run_check "tests"

printf '  [8/8] Security scans\n'; run_check "security"

# ── Tally ─────────────────────────────────────────────────────────────────────
FAILED_CHECKS=()
for check in cloc lockfiles format lint stubs typecheck tests security; do
  [[ "${CHECK_PASS[$check]:-false}" == "false" ]] && FAILED_CHECKS+=("$check")
done

# ── Save state to durable per-branch history ──────────────────────────────────
export _BRANCH="$BRANCH" _ATTEMPT="$ATTEMPT" _TIMESTAMP="$TIMESTAMP" _COMMIT="$COMMIT"
export _BRANCH_TIER="$BRANCH_TIER" _HISTORY_FILE="$HISTORY_FILE"
export _OVERALL_PASS=$([[ ${#FAILED_CHECKS[@]} -eq 0 ]] && echo "true" || echo "false")

for _k in cloc lockfiles format lint stubs typecheck tests security; do
  _vp="CHECK_PASS[$_k]"
  case "$_k" in
    cloc)      export _CLOC_PASS="${!_vp:-false}"  _CLOC_SUMM="${CHECK_SUMMARY[cloc]:-}"      _CLOC_OUT="${CHECK_OUTPUT[cloc]:-}"      ;;
    lockfiles) export _LOCK_PASS="${!_vp:-false}"  _LOCK_SUMM="${CHECK_SUMMARY[lockfiles]:-}" _LOCK_OUT="${CHECK_OUTPUT[lockfiles]:-}" ;;
    format)    export _FMT_PASS="${!_vp:-false}"   _FMT_SUMM="${CHECK_SUMMARY[format]:-}"     _FMT_OUT="${CHECK_OUTPUT[format]:-}"     ;;
    lint)      export _LINT_PASS="${!_vp:-false}"  _LINT_SUMM="${CHECK_SUMMARY[lint]:-}"      _LINT_OUT="${CHECK_OUTPUT[lint]:-}"      ;;
    stubs)     export _STUBS_PASS="${!_vp:-false}" _STUBS_SUMM="${CHECK_SUMMARY[stubs]:-}"    _STUBS_OUT="${CHECK_OUTPUT[stubs]:-}"    ;;
    typecheck) export _TC_PASS="${!_vp:-false}"    _TC_SUMM="${CHECK_SUMMARY[typecheck]:-}"   _TC_OUT="${CHECK_OUTPUT[typecheck]:-}"   ;;
    tests)     export _TESTS_PASS="${!_vp:-false}" _TESTS_SUMM="${CHECK_SUMMARY[tests]:-}"    _TESTS_OUT="${CHECK_OUTPUT[tests]:-}"    ;;
    security)  export _SEC_PASS="${!_vp:-false}"   _SEC_SUMM="${CHECK_SUMMARY[security]:-}"   _SEC_OUT="${CHECK_OUTPUT[security]:-}"   ;;
  esac
done

python3 - <<'PYEOF'
import json, os

def b(s): return s.strip().lower() == "true"
def t(s, n=4000): return s[:n]

state = {
    "attempt":     int(os.environ["_ATTEMPT"]),
    "branch":      os.environ["_BRANCH"],
    "commit":      os.environ["_COMMIT"],
    "timestamp":   os.environ["_TIMESTAMP"],
    "branch_tier": os.environ["_BRANCH_TIER"],
    "passed":      b(os.environ["_OVERALL_PASS"]),
    "checks": {
        "cloc":      {"passed": b(os.environ["_CLOC_PASS"]),  "summary": os.environ["_CLOC_SUMM"],  "output": t(os.environ["_CLOC_OUT"])},
        "lockfiles": {"passed": b(os.environ["_LOCK_PASS"]),  "summary": os.environ["_LOCK_SUMM"],  "output": t(os.environ["_LOCK_OUT"])},
        "format":    {"passed": b(os.environ["_FMT_PASS"]),   "summary": os.environ["_FMT_SUMM"],   "output": t(os.environ["_FMT_OUT"])},
        "lint":      {"passed": b(os.environ["_LINT_PASS"]),  "summary": os.environ["_LINT_SUMM"],  "output": t(os.environ["_LINT_OUT"])},
        "stubs":     {"passed": b(os.environ["_STUBS_PASS"]), "summary": os.environ["_STUBS_SUMM"], "output": t(os.environ["_STUBS_OUT"])},
        "typecheck": {"passed": b(os.environ["_TC_PASS"]),    "summary": os.environ["_TC_SUMM"],    "output": t(os.environ["_TC_OUT"])},
        "tests":     {"passed": b(os.environ["_TESTS_PASS"]), "summary": os.environ["_TESTS_SUMM"], "output": t(os.environ["_TESTS_OUT"])},
        "security":  {"passed": b(os.environ["_SEC_PASS"]),   "summary": os.environ["_SEC_SUMM"],   "output": t(os.environ["_SEC_OUT"])},
    }
}

hf = os.environ["_HISTORY_FILE"]
os.makedirs(os.path.dirname(hf), exist_ok=True)

try:
    with open(hf) as f:
        history = json.load(f)
    if not isinstance(history, list):
        history = []
except Exception:
    history = []

history.append(state)

with open(hf, "w") as f:
    json.dump(history, f, indent=2)
PYEOF

# ── Terminal output ───────────────────────────────────────────────────────────
icon() { [[ "${CHECK_PASS[$1]:-false}" == "true" ]] && printf '✓' || printf '✗'; }

printf '\nCHECK RESULTS\n'
printf '────────────────────────────────────────────────────────────────\n'
for check in cloc lockfiles format lint stubs typecheck tests security; do
  printf '  %s  %-12s  %s\n' "$(icon "$check")" "$check" "${CHECK_SUMMARY[$check]:-}"
done
printf '\n'

if [[ ${#FAILED_CHECKS[@]} -eq 0 ]]; then
  printf '✓ All checks passed — PR creation proceeding.\n\n'
  exit 0
fi

printf '✗ PR Gate BLOCKED — %d check(s) failed: %s\n\n' \
  "${#FAILED_CHECKS[@]}" "$(IFS=', '; echo "${FAILED_CHECKS[*]}")"

for check in "${FAILED_CHECKS[@]}"; do
  upper=$(printf '%s' "$check" | tr '[:lower:]' '[:upper:]')
  printf '%s DETAILS\n' "$upper"
  printf '────────────────────────────────────────────────────────────────\n'
  printf '%s\n' "${CHECK_OUTPUT[$check]:-}" | head -40
  printf '\n'
done

printf 'ACTION REQUIRED\n'
printf '────────────────────────────────────────────────────────────────\n'
printf '  Fix the issues above and retry the PR creation command.\n'
printf '  Every attempt is recorded and will appear in the PR comment\n'
printf '  when all checks pass.\n\n'

exit 2
