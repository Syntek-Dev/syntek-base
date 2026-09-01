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
# Pinned versions (update when the project's pinned toolchain moves):
#   uv 0.12.5   pnpm 11.25.0
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

# ── 2b  Template mode — this repository is the template, not an application ───
#
# syntek-base IS the template, and it now ADDS a check rather than dropping three.
#
# Until 16/08/2026 this flag dropped lockfiles, typecheck and tests, because the
# django image could not be built here: pyproject.toml's `name` was an unrendered
# token uv refused to parse, and no uv.lock could therefore exist for the
# `uv sync --frozen` in every Dockerfile. `7cd385d` fixed the name; committing
# uv.lock fixed the rest. The image builds, so all eight checks have a subject.
#
# What template mode still means: `audits` runs as a ninth check. A template's
# product is its structure, routing and documentation, and nothing on the
# application side reads those.
#
# Detection is exact rather than heuristic: copier.yml is listed in copier.yml's
# own `_exclude`, so a GENERATED project never carries it. Its presence at the
# root means this is the template itself.
#
# This is NOT softening the gate, and the distinction matters because softening
# a gate to make a PR pass is forbidden outright here. Nothing that
# can run here is skipped. The Docker halves are not failing — they are
# INAPPLICABLE, there is no subject for them to check, and a gate that reports a
# failure where no subject exists trains the reader to ignore it. That is the
# false-signal class this repository audits for elsewhere.
#
# So template mode: judges every dual check on its LOCAL half alone, drops the
# three that have no local half whatsoever (lockfiles, typecheck, tests), and
# ADDS the check that is authoritative for a template and has no counterpart in
# an application — the audit suite that CI runs.
TEMPLATE_MODE=false
[[ -f "$PROJECT_ROOT/copier.yml" ]] && TEMPLATE_MODE=true

# ── Environment files for docker compose interpolation ────────────────────────
# Both compose files use `:?` (required) syntax for secrets, so compose needs the values
# or it fails outright rather than warning.
#
# These were `set -a; source`d here until 16/08/2026, which was the wrong mechanism twice
# over. It aborted on the first line bash cannot parse — in the template that is
# `POSTGRES_USER=<%PROJECT_SLUG%>`, whose `<`, `%` and `>` are shell metacharacters —
# leaving every later value, SECRET_KEY included, unexported. And it printed a raw parse
# error over the gate's own output on every run. `--env-file` on each compose invocation
# is what the rest of the repository already does; it uses compose's own parser, which
# treats a token as an ordinary literal.
#
# The committed `.example` files are valid fallbacks: every value in them has a working
# default, so a fresh clone runs the gate before copying anything.
ENV_DEV="$PROJECT_ROOT/code/src/docker/.env.dev"
ENV_TEST="$PROJECT_ROOT/code/src/docker/.env.test"
[[ -f "$ENV_DEV" ]]  || ENV_DEV="$PROJECT_ROOT/code/src/docker/.env.dev.example"
[[ -f "$ENV_TEST" ]] || ENV_TEST="$PROJECT_ROOT/code/src/docker/.env.test.example"

# Auto-detect worktree so Docker checks target the right container set.
# shellcheck source=../../code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPTS/_lib/worktree-detect.sh"
# --env-file on every call, exactly as server.sh and backend-coverage.sh do it. Without it
# compose cannot interpolate `${SECRET_KEY:?…}` or `${POSTGRES_PASSWORD:?…}`, which are hard
# errors rather than warnings — so EVERY `_dc`/`_tc` invocation failed, silently, because
# each call site sends stderr to /dev/null. That made the container half of every dual check
# fail invisibly, and template mode then relabelled the whole class "n/a" instead of
# reporting it. Sourcing the files into the environment above is not a substitute: the
# values reach this shell, not the `docker compose` interpolator. Fixed 16/08/2026.
if [[ -n "${OVERRIDE_DEV_FILE:-}" ]]; then
  _dc() { docker compose --env-file "$ENV_DEV" -f "$DEV_COMPOSE" -f "$OVERRIDE_DEV_FILE" "$@"; }
else
  _dc() { docker compose --env-file "$ENV_DEV" -f "$DEV_COMPOSE" "$@"; }
fi
if [[ -n "${OVERRIDE_TEST_FILE:-}" ]]; then
  _tc() { docker compose --env-file "$ENV_TEST" -f "$TEST_COMPOSE" -f "$OVERRIDE_TEST_FILE" "$@"; }
else
  _tc() { docker compose --env-file "$ENV_TEST" -f "$TEST_COMPOSE" "$@"; }
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

# The promotion tier is `testing` and above. A PR opened FROM any of those targets a
# promotion branch, so it must clear the higher floor; a feature branch targets `testing`
# and clears the always-floor. CI reaches the same answer from the other side, keying off
# the PR's BASE branch. Both numbers are owned by the project's coverage standard — never
# edit one here without moving it there first.
case "$BRANCH_TYPE" in
  testing|dev|staging|main)
    BRANCH_TIER="promotion"
    COVERAGE_THRESHOLD=80
    ;;
  *)
    BRANCH_TIER="feature"
    COVERAGE_THRESHOLD=75
    ;;
esac

ATTEMPT=$(python3 -c "
import json
try:
    d = json.load(open('$HISTORY_FILE'))
    print(len(d.get('attempts', [])) + 1)
except Exception:
    print(1)
" 2>/dev/null || echo "1")

TIER_SFX=" [${COVERAGE_THRESHOLD}% coverage floor]"

printf '\n'
printf '╔══════════════════════════════════════════════════════════════════╗\n'
printf '║  PR Gate — Attempt %-3s — %-39s ║\n' "$ATTEMPT" "${BRANCH}${TIER_SFX}"
printf '╚══════════════════════════════════════════════════════════════════╝\n'
printf '  Commit: %s  |  Started: %s\n' "$COMMIT" "$TIMESTAMP"

if [[ "$TEMPLATE_MODE" == "true" ]]; then
  printf '\n'
  printf '  TEMPLATE MODE — this repository is syntek-base itself, not an\n'
  printf '  application generated from it. Since 16/08/2026 that ADDS a check\n'
  printf '  rather than dropping three: the django image builds here, so every\n'
  printf '  gate has a subject. See Section 2b.\n\n'
  printf '  Running:  all eight application checks, plus the audit suite, which\n'
  printf '            is what actually governs a template.\n'
  printf '  Note:     a green run here covers this template and the two apps it\n'
  printf '            ships — not a generated project. GAPS.md, SL-1.\n'
fi
printf '\n'

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

# The service names are read off docker-compose.dev.yml and docker-compose.test.yml, and
# they are `django` and `django-test`. They were `backend`/`frontend`/`backend-test` until
# 16/08/2026 — names from a different project's stack, which match nothing here — so both
# probes always returned false. Nobody saw it because template mode short-circuited both
# branches below: the bug was only reachable in a generated project, where the gate would
# start the stack, wait 90 s, fail to see it, and exit 2 on every run.
dev_running() {
  _dc ps --status running 2>/dev/null \
    | grep -qE '\bdjango\b'
}
test_running() {
  _tc ps --status running 2>/dev/null \
    | grep -qE '\bdjango-test\b'
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
# Read from the container on both sides of the template boundary since 16/08/2026: the
# image builds here now, so host/container uv drift is a real reading rather than an
# undefined one. It was pinned to "n/a" in template mode while there was no container.
DOCKER_UV=$(_dc exec -T django \
  uv --version 2>/dev/null | awk '{print $2}' || echo "not-found")
LOCAL_PNPM=$(pnpm --version 2>/dev/null | tr -d '[:space:]' || echo "not-found")
DOCKER_PNPM="n/a"  # no Node toolchain in the django image — pnpm is host-only

[[ "$LOCAL_UV" == "not-found" ]] && \
  VERSION_WARNINGS+=("uv not installed locally")
[[ "$LOCAL_UV" != "not-found" && "$LOCAL_UV" != "$DOCKER_UV" \
   && "$DOCKER_UV" != "not-found" && "$DOCKER_UV" != "n/a" ]] && \
  VERSION_WARNINGS+=("uv drift: local=${LOCAL_UV} docker=${DOCKER_UV}")
[[ "$LOCAL_PNPM" == "not-found" ]] && \
  VERSION_WARNINGS+=("pnpm not installed locally")

# The code-review-graph refresh is incremental: it diffs against a git ref, so an untracked
# source file is never parsed and the refresh still reports success. Warn rather than gate —
# staging is a judgement about what belongs in the commit, not a quality failure. What it
# serves is the commit gate that requires the graph refreshed over staged work.
UNGRAPHED=$(git -C "$PROJECT_ROOT" ls-files --others --exclude-standard 2>/dev/null \
  | grep -cE '\.(sh|bash|py|ts|tsx|js|mjs|cjs|rs)$' || true)
[[ "${UNGRAPHED:-0}" -gt 0 ]] && \
  VERSION_WARNINGS+=("${UNGRAPHED} untracked source file(s) outside the code-review-graph — stage before the pre-commit refresh")

# ── 6  Check infrastructure ───────────────────────────────────────────────────

declare -A CHECK_PASS=()
declare -A CHECK_SUMMARY=()
declare -A CHECK_OUTPUT=()

BACKEND_COV=0
FRONTEND_COV=0

# Shared result setter for dual-environment checks.
# Sets CHECK_PASS and CHECK_SUMMARY (mismatch cases); caller sets summary for both-fail.
# The value a leg passes for "I could not run". Deliberately NOT an exit code: an exit code
# is a RESULT, and the whole point of this value is that there is no result.
# Rule: code/docs/GATE-REPORTING.md.
LEG_UNMEASURED="unmeasured"

_dual_result() {
  local name="$1" local_exit="$2" docker_exit="$3" \
        local_out="$4" docker_out="$5"

  # No template-mode branch here since 16/08/2026. This used to short-circuit to a
  # host-only verdict because the container could not exist; it can now, so drift between
  # the host and the container is a real reading on both sides of the boundary — and
  # suppressing it was suppressing exactly the defect this function exists to name.
  CHECK_OUTPUT["$name"]=$(printf \
    '── Local ────────────────────────────────────────────────────────────\n%s\n\n── Docker ───────────────────────────────────────────────────────────\n%s\n' \
    "$local_out" "$docker_out")
  # A leg that could not run has produced no result, so it can neither pass nor MISMATCH —
  # a mismatch asserts two results and there would be only one. Handled before the integer
  # comparisons below, which would otherwise read the sentinel as a failure.
  if [[ "$local_exit" == "$LEG_UNMEASURED" || "$docker_exit" == "$LEG_UNMEASURED" ]]; then
    local ran_exit ran_side unmeasured_side
    if [[ "$local_exit" == "$LEG_UNMEASURED" ]]; then
      ran_exit="$docker_exit"; ran_side="Docker"; unmeasured_side="local"
    else
      ran_exit="$local_exit"; ran_side="local"; unmeasured_side="Docker"
    fi
    if [[ "$ran_exit" == "$LEG_UNMEASURED" ]]; then
      CHECK_PASS["$name"]="unmeasured"
      CHECK_SUMMARY["$name"]="NOT MEASURED — neither leg could run"
    elif [[ $ran_exit -eq 0 ]]; then
      CHECK_PASS["$name"]="unmeasured"
      CHECK_SUMMARY["$name"]="NOT MEASURED — the $unmeasured_side leg could not run; the $ran_side leg was clean"
    else
      # One real failure and one absent result: report the failure, and never dress it as
      # a mismatch.
      CHECK_PASS["$name"]="false"
      CHECK_SUMMARY["$name"]="FAILED in $ran_side (the $unmeasured_side leg could not run — no mismatch can be asserted)"
    fi
  elif [[ $local_exit -eq 0 && $docker_exit -eq 0 ]]; then
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
# shellcheck source=lib/check-audits.sh
source "$HOOK_DIR/lib/check-audits.sh"

# NINE checks here, EIGHT in a generated project — and the difference is now an addition
# rather than a subtraction (16/08/2026).
#
# Template mode used to run six: lockfiles, typecheck and tests were DROPPED because each
# reads its authoritative half from the django container and that container could not be
# built here. That premise died when uv.lock was committed. All three now run, and the
# first PR gate to include them found two bugs the drop had been hiding — the container
# probes above matched no service, and the compose healthcheck named an unresolvable
# database. A check that is skipped is a check that cannot report a regression.
#
# `audits` remains template-only, and is the one genuine asymmetry left: a template's
# product is its structure, routing and documentation, which no application-side gate reads.
TOTAL=8
ALL_CHECKS=(cloc lockfiles format lint stubs typecheck tests security)
if [[ "$TEMPLATE_MODE" == "true" ]]; then
  TOTAL=9
  ALL_CHECKS+=(audits)
fi

printf '  [1/%s] Line count (cloc)\n' "$TOTAL"
_check_cloc

printf '  [2/%s] Lockfile alignment (local + Docker)\n' "$TOTAL"
_check_lockfiles

printf '  [3/%s] Format (local + Docker)\n' "$TOTAL"
_check_format

printf '  [4/%s] Lint (local + Docker)\n' "$TOTAL"
_check_lint

printf '  [5/%s] Stub audit\n' "$TOTAL"
_check_stubs

printf '  [6/%s] Type-check (local + Docker)\n' "$TOTAL"
_check_typecheck

printf '  [7/%s] Tests + coverage (%s%% floor)\n' "$TOTAL" "$COVERAGE_THRESHOLD"
_check_tests
_apply_coverage_floor

printf '  [8/%s] Security (local + Docker)\n' "$TOTAL"
_check_security

if [[ "$TEMPLATE_MODE" == "true" ]]; then
  printf '  [9/9] Template audits + shipped-file integrity\n'
  _check_audits
fi

# ── 7  Tally ──────────────────────────────────────────────────────────────────

FAILED_CHECKS=()
UNMEASURED_CHECKS=()
OVERALL_PASS=true
for _c in "${ALL_CHECKS[@]}"; do
  case "${CHECK_PASS[$_c]:-false}" in
    # Reported, never silent — but not blocking. A missing host tool is ordinary on a
    # developer's machine, and a gate that blocks the maintainer is a gate that gets
    # switched off (code/docs/GATE-REPORTING.md).
    unmeasured) UNMEASURED_CHECKS+=("$_c") ;;
    false)      FAILED_CHECKS+=("$_c"); OVERALL_PASS=false ;;
  esac
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

# Built from ALL_CHECKS rather than a fixed list, so a check the run did not
# perform is ABSENT from the history instead of recorded as a failure. In
# template mode three checks are legitimately not run, and writing them as
# `passed: false` would put a defect in the record that never happened.
SUMMARY_ARGS=()
for _c in "${ALL_CHECKS[@]}"; do
  SUMMARY_ARGS+=("$_c" "${CHECK_PASS[$_c]:-false}" "${CHECK_SUMMARY[$_c]:-}")
done

python3 -c "
import json, sys
args = sys.argv[1:]
result = {}
for i in range(0, len(args), 3):
    result[args[i]] = {'passed': args[i+1] == 'true', 'summary': args[i+2]}
print(json.dumps(result))
" "${SUMMARY_ARGS[@]}" \
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

_icon() {
  case "${CHECK_PASS[$1]:-false}" in
    true)       printf '✓' ;;
    unmeasured) printf '⚠' ;;
    *)          printf '✗' ;;
  esac
}

printf '\nCHECK RESULTS\n'
printf '────────────────────────────────────────────────────────────────────\n'
for _c in "${ALL_CHECKS[@]}"; do
  printf '  %s  %-12s  %s\n' "$(_icon "$_c")" "$_c" "${CHECK_SUMMARY[$_c]:-}"
done
if [[ ${#UNMEASURED_CHECKS[@]} -gt 0 ]]; then
  printf '  ⚠  NOT MEASURED: %s\n' "${UNMEASURED_CHECKS[*]}"
  printf '     These did not run, which is not a pass. Install what is missing to close them.\n'
fi
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
