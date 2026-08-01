#!/usr/bin/env bash
#
# pre-pr-check.sh — Claude Code PreToolUse hook: quality gate for gh pr create/new.
#
# 8 checks. The Python half of format/lint/typecheck runs locally AND in Docker (a
# host/container drift check); any mismatch is a hard block (exit 2). The JS/TS half
# The JS legs (eslint, prettier, pnpm audit) run in the host Node toolchain; the django
# image carries no Node, so they are host-only. The
# Django-rendered marketing pages/templates/components are covered by the Python gates
# (ruff / basedpyright) + backend pytest ([7/8]).
#
#   [1/8] cloc       — local only   (wc -l file-size enforcement, ≥800 = error)
#   [2/8] lockfiles  — local+Docker (uv sync --frozen + pnpm install --frozen-lockfile)
#   [3/8] format     — Python local+Docker (ruff format) · Prettier repo-wide (host)
#   [4/8] lint       — Python local+Docker (ruff check)  · eslint (host)
#   [5/8] stubs      — local only   (grep-based; source files are host-mounted)
#   [6/8] typecheck  — Python local+Docker (basedpyright) (no JS type-check — no TypeScript)
#   [7/8] tests      — Docker only  (backend pytest covers Django marketing/templates; 80% floor on staging/main)
#   [8/8] security   — local+Docker (bandit + pnpm audit)
#
# Exit codes:  0 = all checks passed   2 = one or more checks failed / mismatched
#
# Pinned versions (update when CLAUDE.md stack table changes):
#   uv 0.11.7   pnpm 10.33.2
#
set -uo pipefail

# ── 1  Fast-path guard ────────────────────────────────────────────────────────

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))' \
  2>/dev/null || true)

printf '%s' "$COMMAND" | grep -qE 'gh pr (create|new)\b' || exit 0

# Capture full output to a persistent log for post-mortem debugging.
HOOK_LOG="/tmp/pre-pr-hook-$(date +%s).log"
exec > >(tee "$HOOK_LOG") 2>&1

# ── 2  Paths and context ──────────────────────────────────────────────────────

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"
SCRIPTS="$PROJECT_ROOT/code/src/scripts"
DEV_COMPOSE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
TEST_COMPOSE="$PROJECT_ROOT/code/src/docker/docker-compose.test.yml"
HISTORY_DIR="$HOME/.claude/pr-check-history"

# ── Load environment variables for docker compose interpolation ───────────────
# docker-compose.dev.yml uses :? (required) syntax for secrets.
# Source .env.dev so that docker compose can parse the file without error when
# this hook runs in a shell that has not already loaded the project environment.
ENV_DEV="$PROJECT_ROOT/code/src/docker/.env.dev"
ENV_TEST="$PROJECT_ROOT/code/src/docker/.env.test"
if [[ -f "$ENV_DEV" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$ENV_DEV"
  set +a
fi
if [[ -f "$ENV_TEST" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$ENV_TEST"
  set +a
fi

# Auto-detect worktree so Docker checks target the right container set.
# shellcheck source=../../code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPTS/_lib/worktree-detect.sh"
if [[ -n "${OVERRIDE_DEV_FILE:-}" ]]; then
  _dc() { docker compose -f "$DEV_COMPOSE" -f "$OVERRIDE_DEV_FILE" "$@"; }
else
  _dc() { docker compose -f "$DEV_COMPOSE" "$@"; }
fi
if [[ -n "${OVERRIDE_TEST_FILE:-}" ]]; then
  _tc() { docker compose -f "$TEST_COMPOSE" -f "$OVERRIDE_TEST_FILE" "$@"; }
else
  _tc() { docker compose -f "$TEST_COMPOSE" "$@"; }
fi

BRANCH=$(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
COMMIT=$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")
BRANCH_SAFE="${BRANCH//\//_}"
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
HISTORY_FILE="$HISTORY_DIR/${BRANCH_SAFE}.json"
TMPDIR_CHECKS=$(mktemp -d)
trap 'rm -rf "$TMPDIR_CHECKS"' EXIT

mkdir -p "$HISTORY_DIR"

# ── 3  Branch type and tier ───────────────────────────────────────────────────

case "$BRANCH" in
  us[0-9]*/*|pm/*|fix/*|chore/*) BRANCH_TYPE="feature" ;;
  testing)                         BRANCH_TYPE="testing" ;;
  dev)                             BRANCH_TYPE="dev" ;;
  staging)                         BRANCH_TYPE="staging" ;;
  main)                            BRANCH_TYPE="main" ;;
  *)                               BRANCH_TYPE="feature" ;;
esac

if [[ "$BRANCH_TYPE" == "staging" || "$BRANCH_TYPE" == "main" ]]; then
  BRANCH_TIER="staging_main"
  COVERAGE_THRESHOLD=80
else
  BRANCH_TIER="feature"
  COVERAGE_THRESHOLD=0
fi

ATTEMPT=$(python3 -c "
import json
try:
    d = json.load(open('$HISTORY_FILE'))
    print(len(d.get('attempts', [])) + 1)
except Exception:
    print(1)
" 2>/dev/null || echo "1")

TIER_SFX=$([[ "$BRANCH_TIER" == "staging_main" ]] && echo " [80% coverage floor]" || echo "")

printf '\n'
printf '╔══════════════════════════════════════════════════════════════════╗\n'
printf '║  PR Gate — Attempt %-3s — %-39s ║\n' "$ATTEMPT" "${BRANCH}${TIER_SFX}"
printf '╚══════════════════════════════════════════════════════════════════╝\n'
printf '  Commit: %s  |  Started: %s\n\n' "$COMMIT" "$TIMESTAMP"

# ── 4  Ensure Docker daemon and containers are running ────────────────────────

if ! docker info > /dev/null 2>&1; then
  printf '  Docker daemon not running — attempting start...\n'
  sudo systemctl start docker 2>/dev/null || true
  for _i in $(seq 1 15); do docker info > /dev/null 2>&1 && break || sleep 1; done
  if ! docker info > /dev/null 2>&1; then
    printf '\n## PR Blocked — Docker daemon failed to start\n'
    printf 'Fix: sudo systemctl start docker\n'
    printf '(Passwordless sudo for this command must be in /etc/sudoers.)\n'
    exit 2
  fi
  printf '  Docker daemon started.\n\n'
fi

dev_running() {
  _dc ps --status running 2>/dev/null \
    | grep -qE '\b(backend|frontend)\b'
}
test_running() {
  _tc ps --status running 2>/dev/null \
    | grep -qE '\bbackend-test\b'
}

if ! dev_running; then
  printf '  Dev containers not running — starting dev stack...\n'
  bash "$SCRIPTS/development/server.sh" up
  for _i in $(seq 1 18); do
    sleep 5
    dev_running && { printf '  Dev stack ready.\n\n'; break; } || true
  done
  if ! dev_running; then
    printf '  ERROR: Dev stack failed to start after 90 s.\n'
    exit 2
  fi
fi

if ! test_running; then
  printf '  Test stack not running — building and starting...\n'
  _tc up -d --build
  for _i in $(seq 1 18); do
    sleep 5
    test_running && { printf '  Test stack ready.\n\n'; break; } || true
  done
  if ! test_running; then
    printf '  ERROR: Test stack failed to start after 90 s.\n'
    exit 2
  fi
fi

# ── 5  Version info (informational) ──────────────────────────────────────────

VERSION_WARNINGS=()

LOCAL_UV=$(uv --version 2>/dev/null | awk '{print $2}' || echo "not-found")
DOCKER_UV=$(_dc exec -T django \
  uv --version 2>/dev/null | awk '{print $2}' || echo "not-found")
LOCAL_PNPM=$(pnpm --version 2>/dev/null | tr -d '[:space:]' || echo "not-found")
DOCKER_PNPM="n/a"  # no Node toolchain in the django image — pnpm is host-only

[[ "$LOCAL_UV" == "not-found" ]] && \
  VERSION_WARNINGS+=("uv not installed locally")
[[ "$LOCAL_UV" != "not-found" && "$LOCAL_UV" != "$DOCKER_UV" && "$DOCKER_UV" != "not-found" ]] && \
  VERSION_WARNINGS+=("uv drift: local=${LOCAL_UV} docker=${DOCKER_UV}")
[[ "$LOCAL_PNPM" == "not-found" ]] && \
  VERSION_WARNINGS+=("pnpm not installed locally")

# ── 6  Check infrastructure ───────────────────────────────────────────────────

declare -A CHECK_PASS=()
declare -A CHECK_SUMMARY=()
declare -A CHECK_OUTPUT=()

BACKEND_COV=0
FRONTEND_COV=0

# Shared result setter for dual-environment checks.
# Sets CHECK_PASS and CHECK_SUMMARY (mismatch cases); caller sets summary for both-fail.
_dual_result() {
  local name="$1" local_exit="$2" docker_exit="$3" \
        local_out="$4" docker_out="$5"
  CHECK_OUTPUT["$name"]=$(printf \
    '── Local ────────────────────────────────────────────────────────────\n%s\n\n── Docker ───────────────────────────────────────────────────────────\n%s\n' \
    "$local_out" "$docker_out")
  if   [[ $local_exit -eq 0 && $docker_exit -eq 0 ]]; then
    CHECK_PASS["$name"]="true"
  elif [[ $local_exit -eq 0 && $docker_exit -ne 0 ]]; then
    CHECK_PASS["$name"]="false"
    CHECK_SUMMARY["$name"]="MISMATCH: passed locally, failed in Docker"
  elif [[ $local_exit -ne 0 && $docker_exit -eq 0 ]]; then
    CHECK_PASS["$name"]="false"
    CHECK_SUMMARY["$name"]="MISMATCH: failed locally, passed in Docker"
  else
    CHECK_PASS["$name"]="false"
    # CHECK_SUMMARY set by caller for "both fail" case
  fi
}

# Source check modules (each defines one _check_<name> function)
# shellcheck source=lib/check-cloc.sh
source "$HOOK_DIR/lib/check-cloc.sh"
# shellcheck source=lib/check-lockfiles.sh
source "$HOOK_DIR/lib/check-lockfiles.sh"
# shellcheck source=lib/check-format.sh
source "$HOOK_DIR/lib/check-format.sh"
# shellcheck source=lib/check-lint.sh
source "$HOOK_DIR/lib/check-lint.sh"
# shellcheck source=lib/check-stubs.sh
source "$HOOK_DIR/lib/check-stubs.sh"
# shellcheck source=lib/check-typecheck.sh
source "$HOOK_DIR/lib/check-typecheck.sh"
# shellcheck source=lib/check-tests.sh
source "$HOOK_DIR/lib/check-tests.sh"
# shellcheck source=lib/check-security.sh
source "$HOOK_DIR/lib/check-security.sh"

ALL_CHECKS=(cloc lockfiles format lint stubs typecheck tests security)

printf '  [1/8] Line count (cloc)\n'
_check_cloc

printf '  [2/8] Lockfile alignment (local + Docker)\n'
_check_lockfiles

printf '  [3/8] Format (local + Docker)\n'
_check_format

printf '  [4/8] Lint (local + Docker)\n'
_check_lint

printf '  [5/8] Stub audit\n'
_check_stubs

printf '  [6/8] Type-check (local + Docker)\n'
_check_typecheck

printf '  [7/8] Tests%s\n' \
  "$([[ "$BRANCH_TIER" == "staging_main" ]] && echo ' + coverage (80% floor)' || echo '')"
_check_tests
_apply_coverage_floor

printf '  [8/8] Security (local + Docker)\n'
_check_security

# ── 7  Tally ──────────────────────────────────────────────────────────────────

FAILED_CHECKS=()
OVERALL_PASS=true
for _c in "${ALL_CHECKS[@]}"; do
  [[ "${CHECK_PASS[$_c]:-false}" == "false" ]] && FAILED_CHECKS+=("$_c") && OVERALL_PASS=false || true
done

# ── 8  Write history ──────────────────────────────────────────────────────────

if [[ -f "$HISTORY_FILE" ]]; then
  cat "$HISTORY_FILE" > "$TMPDIR_CHECKS/existing.json"
else
  printf '{"branch":"%s","attempts":[]}' "$BRANCH" > "$TMPDIR_CHECKS/existing.json"
fi

printf '%s\n' "${FAILED_CHECKS[@]+"${FAILED_CHECKS[@]}"}" \
  | python3 -c "import sys,json; print(json.dumps([l.rstrip() for l in sys.stdin if l.strip()]))" \
  > "$TMPDIR_CHECKS/failed.json"

printf '%s\n' "${VERSION_WARNINGS[@]+"${VERSION_WARNINGS[@]}"}" \
  | python3 -c "import sys,json; print(json.dumps([l.rstrip() for l in sys.stdin if l.strip()]))" \
  > "$TMPDIR_CHECKS/warnings.json"

python3 -c "
import json, sys
args = sys.argv[1:]
result = {}
for i in range(0, len(args), 3):
    result[args[i]] = {'passed': args[i+1] == 'true', 'summary': args[i+2]}
print(json.dumps(result))
" \
  cloc       "${CHECK_PASS[cloc]:-false}"       "${CHECK_SUMMARY[cloc]:-}" \
  lockfiles  "${CHECK_PASS[lockfiles]:-false}"  "${CHECK_SUMMARY[lockfiles]:-}" \
  format     "${CHECK_PASS[format]:-false}"     "${CHECK_SUMMARY[format]:-}" \
  lint       "${CHECK_PASS[lint]:-false}"       "${CHECK_SUMMARY[lint]:-}" \
  stubs      "${CHECK_PASS[stubs]:-false}"      "${CHECK_SUMMARY[stubs]:-}" \
  typecheck  "${CHECK_PASS[typecheck]:-false}"  "${CHECK_SUMMARY[typecheck]:-}" \
  tests      "${CHECK_PASS[tests]:-false}"      "${CHECK_SUMMARY[tests]:-}" \
  security   "${CHECK_PASS[security]:-false}"   "${CHECK_SUMMARY[security]:-}" \
  > "$TMPDIR_CHECKS/summaries.json"

LAST_FAIL_COMMIT=$(python3 -c "
import json
try:
    d = json.load(open('$TMPDIR_CHECKS/existing.json'))
    for a in reversed(d.get('attempts', [])):
        if a.get('status') == 'failed':
            print(a.get('commit', ''))
            break
except Exception:
    pass
" 2>/dev/null || echo "")

if [[ "$OVERALL_PASS" == "true" && -n "$LAST_FAIL_COMMIT" && "$LAST_FAIL_COMMIT" != "$COMMIT" ]]; then
  git -C "$PROJECT_ROOT" log \
    "${LAST_FAIL_COMMIT}..${COMMIT}" \
    --oneline --no-merges 2>/dev/null | head -20 \
    | python3 -c "import sys,json; print(json.dumps([l.rstrip() for l in sys.stdin if l.strip()]))" \
    > "$TMPDIR_CHECKS/resolution.json"
else
  printf '[]' > "$TMPDIR_CHECKS/resolution.json"
fi

STATUS=$([[ "$OVERALL_PASS" == "true" ]] && echo "passed" || echo "failed")

python3 - \
  "$HISTORY_FILE" "$STATUS" "$TIMESTAMP" "$COMMIT" "$BRANCH" \
  "$LOCAL_UV" "$DOCKER_UV" "$LOCAL_PNPM" "$DOCKER_PNPM" \
  "$BACKEND_COV" "$FRONTEND_COV" "$COVERAGE_THRESHOLD" \
  "$TMPDIR_CHECKS/failed.json" \
  "$TMPDIR_CHECKS/resolution.json" \
  "$TMPDIR_CHECKS/warnings.json" \
  "$TMPDIR_CHECKS/summaries.json" \
  "$TMPDIR_CHECKS/existing.json" \
  <<'PYEOF'
import sys, json

history_file   = sys.argv[1]
status         = sys.argv[2]
timestamp      = sys.argv[3]
commit         = sys.argv[4]
branch         = sys.argv[5]
local_uv       = sys.argv[6]
docker_uv      = sys.argv[7]
local_pnpm     = sys.argv[8]
docker_pnpm    = sys.argv[9]
backend_cov    = int(sys.argv[10])
frontend_cov   = int(sys.argv[11])
cov_threshold  = int(sys.argv[12])
try:
    failed_checks = json.load(open(sys.argv[13]))
except Exception:
    failed_checks = []
try:
    resolution = json.load(open(sys.argv[14]))
except Exception:
    resolution = []
try:
    warnings = json.load(open(sys.argv[15]))
except Exception:
    warnings = []
try:
    check_summaries = json.load(open(sys.argv[16]))
except Exception:
    check_summaries = {}

try:
    data = json.load(open(sys.argv[17]))
    if "attempts" not in data:
        data["attempts"] = []
except Exception:
    data = {"branch": branch, "attempts": []}

data["attempts"].append({
    "timestamp":        timestamp,
    "commit":           commit,
    "status":           status,
    "failed_checks":    failed_checks,
    "check_summaries":  check_summaries,
    "version_info": {
        "uv":   {"local": local_uv,   "docker": docker_uv},
        "pnpm": {"local": local_pnpm, "docker": docker_pnpm},
        "warnings": warnings,
    },
    "coverage": {
        "backend_pct":  backend_cov,
        "frontend_pct": frontend_cov,
        "threshold":    cov_threshold,
        "required":     cov_threshold > 0,
    },
    "resolution_commits": resolution,
})
data["attempts"] = data["attempts"][-10:]
data["branch"] = branch

with open(history_file, "w") as f:
    json.dump(data, f, indent=2)
PYEOF

# ── 9  Write human-readable failure report ───────────────────────────────────

PR_FAIL_FILE="$HISTORY_DIR/${BRANCH_SAFE}-failure.md"

if [[ "$OVERALL_PASS" != "true" ]]; then
  python3 - "$PR_FAIL_FILE" "$BRANCH" "$COMMIT" "$TIMESTAMP" "$ATTEMPT" \
    "$TMPDIR_CHECKS/failed.json" "$TMPDIR_CHECKS/summaries.json" <<'FAILPYEOF'
import sys, json

fail_file   = sys.argv[1]
branch      = sys.argv[2]
commit      = sys.argv[3]
timestamp   = sys.argv[4]
attempt_num = sys.argv[5]
failed      = json.load(open(sys.argv[6]))
summaries   = json.load(open(sys.argv[7]))

CHECK_DISPLAY = {
    "cloc":      "Line Count",
    "lockfiles": "Lockfile Alignment",
    "format":    "Format",
    "lint":      "Lint",
    "stubs":     "Stub Audit",
    "typecheck": "Type-check",
    "tests":     "Tests + Coverage",
    "security":  "Security",
}
CHECK_ACTIONS = {
    "cloc":      "Split file(s) exceeding 800 lines into focused modules [CLAUDE.md]",
    "lockfiles": "Run `bash code/src/scripts/development/install-backend.sh --sync` and `pnpm install`, then rebuild Docker images",
    "format":    "Run `bash code/src/scripts/syntax/format.sh --fix`",
    "lint":      "Run `bash code/src/scripts/syntax/lint.sh --fix` then fix remaining",
    "stubs":     "Remove hard-coded stubs — `bash code/src/scripts/audits/stubs.sh`",
    "typecheck": "Fix type errors — `bash code/src/scripts/syntax/check.sh`",
    "tests":     "Run `bash code/src/scripts/tests/all.sh` to see failing tests",
    "security":  "Address vulnerabilities — bandit (Python) or `pnpm audit fix` (JS)",
}

ts_display = timestamp[:16].replace("T", " ")

lines = [
    "# PR Gate Failure Report",
    "",
    f"**Branch:** `{branch}` | **Commit:** `{commit}` | "
    f"**Attempt:** {attempt_num} | **When:** {ts_display} UTC",
    "",
    "## Failed Checks",
    "",
]

for k in failed:
    c      = summaries.get(k, {})
    summ   = c.get("summary", "")
    action = CHECK_ACTIONS.get(k, "")
    lines.append(f"### {CHECK_DISPLAY.get(k, k)}")
    if summ:
        lines.append(f"**Details:** {summ}")
    lines.append(f"**Action:** {action}")
    lines.append("")

lines += [
    "## Resolution",
    "",
    "_Not yet resolved._",
    "",
]

with open(fail_file, "w") as f:
    f.write("\n".join(lines))
FAILPYEOF

elif [[ -f "$PR_FAIL_FILE" ]]; then
  # Checks now passing — update failure report with resolution commits
  python3 - "$PR_FAIL_FILE" "$TMPDIR_CHECKS/resolution.json" "$COMMIT" "$TIMESTAMP" <<'RESPYEOF'
import sys, json

fail_file  = sys.argv[1]
resolution = json.load(open(sys.argv[2]))
commit     = sys.argv[3]
timestamp  = sys.argv[4]

ts_display = timestamp[:16].replace("T", " ")

try:
    content = open(fail_file).read()
except Exception:
    sys.exit(0)

resolution_lines = [
    "## Resolution",
    "",
    f"**Resolved at:** {ts_display} UTC | **Commit:** `{commit}`",
    "",
]

if resolution:
    resolution_lines += [
        "**Commits made to fix failures:**",
        "",
        "```text",
    ] + resolution + [
        "```",
        "",
    ]
else:
    resolution_lines += [
        "_No additional commits were identified between the failed and passing attempts._",
        "",
    ]

new_content = content.replace(
    "## Resolution\n\n_Not yet resolved._\n\n",
    "\n".join(resolution_lines),
)

with open(fail_file, "w") as f:
    f.write(new_content)
RESPYEOF
fi

# ── 10  Terminal results ──────────────────────────────────────────────────────

_icon() { [[ "${CHECK_PASS[$1]:-false}" == "true" ]] && printf '✓' || printf '✗'; }

printf '\nCHECK RESULTS\n'
printf '────────────────────────────────────────────────────────────────────\n'
for _c in "${ALL_CHECKS[@]}"; do
  printf '  %s  %-12s  %s\n' "$(_icon "$_c")" "$_c" "${CHECK_SUMMARY[$_c]:-}"
done
printf '\n'

if [[ "$OVERALL_PASS" == "true" ]]; then
  printf '✓ All checks passed — PR creation proceeding.\n\n'
  if [[ ${#VERSION_WARNINGS[@]} -gt 0 ]]; then
    printf 'Version warnings (non-blocking):\n'
    for _w in "${VERSION_WARNINGS[@]}"; do printf '  - %s\n' "$_w"; done
    printf '\n'
  fi
  exit 0
fi

printf '✗ PR Gate BLOCKED — %d check(s) failed: %s\n\n' \
  "${#FAILED_CHECKS[@]}" "$(IFS=', '; echo "${FAILED_CHECKS[*]}")"

for _c in "${FAILED_CHECKS[@]}"; do
  printf '%s DETAILS\n' "$(printf '%s' "$_c" | tr '[:lower:]' '[:upper:]')"
  printf '────────────────────────────────────────────────────────────────────\n'
  printf '%s\n' "${CHECK_OUTPUT[$_c]:-}" | head -60
  printf '\n'
done

printf 'ACTION REQUIRED\n'
printf '────────────────────────────────────────────────────────────────────\n'
for _c in "${FAILED_CHECKS[@]}"; do
  case "$_c" in
    cloc)      printf '  cloc      : Split file(s) exceeding 800 lines into focused modules [CLAUDE.md]\n' ;;
    lockfiles) printf '  lockfiles : Run `bash code/src/scripts/development/install-backend.sh --sync` and `pnpm install`, then rebuild Docker images\n' ;;
    format)    printf '  format    : Run `bash code/src/scripts/syntax/format.sh --fix` to auto-format\n' ;;
    lint)      printf '  lint      : Run `bash code/src/scripts/syntax/lint.sh --fix` then fix remaining\n' ;;
    stubs)     printf '  stubs     : Remove hard-coded stubs — `bash code/src/scripts/audits/stubs.sh`\n' ;;
    typecheck) printf '  typecheck : Fix type errors — `bash code/src/scripts/syntax/check.sh`\n' ;;
    tests)     printf '  tests     : Run `bash code/src/scripts/tests/all.sh` to see failing tests\n' ;;
    security)  printf '  security  : Address vulnerabilities — bandit (Python) or `pnpm audit fix` (JS)\n' ;;
  esac
done
printf '\n  Every attempt is recorded and will appear in the PR comment when all checks pass.\n\n'

if [[ ${#VERSION_WARNINGS[@]} -gt 0 ]]; then
  printf 'Version warnings (non-blocking):\n'
  for _w in "${VERSION_WARNINGS[@]}"; do printf '  - %s\n' "$_w"; done
  printf '\n'
fi

exit 2
