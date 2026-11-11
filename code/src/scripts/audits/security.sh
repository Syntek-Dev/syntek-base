#!/usr/bin/env bash
#
# security.sh — Dependency security audit: pnpm audit (JS/TS) + pip-audit / uv audit (Python).
#
#   Mirrors the CI "[8/8] Security" gate so a clean local run predicts a clean CI run.
#   The gate runs, per ecosystem:
#     JS/TS:  pnpm audit --audit-level low      (honours audit.ignore in
#                                                 pnpm-workspace.yaml — read natively by pnpm 11)
#     Python: uv run pip-audit                  (CVE scan of the locked backend deps)
#
#   Runs on the host by default (like the other audits/ scripts). Pass --docker to run the
#   same audits inside the running dev containers instead (django service).
#
#   NB: pip-audit and uv audit are NOT the same tool. pip-audit is the mature standalone
#   scanner the CI gate uses; uv audit is uv's built-in (experimental) equivalent. The default
#   here is pip-audit for CI parity — use --py-tool uv to run uv audit instead.
#
# Usage: security.sh [--docker] [--local] [--js-only] [--py-only]
#                    [--py-tool pip-audit|uv] [--audit-level LEVEL] [--quiet] [--help]
#
# Exit codes:  0 = no vulnerabilities   1 = vulnerabilities found
#              2 = a tool did not run to a result (network, missing lock), or a script error
#
#   A non-zero exit from pnpm audit or pip-audit is not a finding by itself — both exit 1 on a
#   503 from the advisory service as readily as on an advisory. Each leg's output is matched
#   against the line that tool prints for a real result; anything else is NOT RUN, and NOT RUN
#   is exit 2, never 1 and never 0 (code/docs/GATE-REPORTING.md). A finding outranks it.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"
# A fresh clone has only the example; compose needs a file to interpolate from, and the
# pre-PR gate promises to run before anything is copied (tests/backend.sh does the same).
[[ -f "$ENV_FILE" ]] || ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev.example"
BACKEND_DIR="$PROJECT_ROOT/code/src/django"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

# ── Defaults ──────────────────────────────────────────────────────────────────
MODE="local"           # local | docker
RUN_JS=true
RUN_PY=true
PY_TOOL="pip-audit"    # pip-audit (CI parity) | uv
AUDIT_LEVEL="low"      # pnpm audit threshold: info|low|moderate|high|critical
QUIET=false
JS_EXIT=0
PY_EXIT=0

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }
die()  { printf 'security.sh error: %s\n' "$*" >&2; exit 2; }
require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

usage() {
  cat <<'EOF'
security.sh — Dependency security audit (pnpm audit + pip-audit / uv audit)

Mirrors the CI "[8/8] Security" gate so a clean local run predicts a clean CI run.

Usage:
  security.sh                      Audit JS/TS + Python on the host (pip-audit)
  security.sh --docker             Run the same audits inside the dev containers
  security.sh --js-only            Only pnpm audit (JS/TS workspace)
  security.sh --py-only            Only the Python CVE scan (backend)
  security.sh --py-tool uv         Use `uv audit` instead of pip-audit (experimental)
  security.sh --audit-level high   Raise the pnpm audit threshold

Options:
  --local                Run on the host (default)
  --docker               Run inside the running dev container (django)
  --js-only              Audit only JS/TS dependencies (pnpm audit)
  --py-only              Audit only Python dependencies
  --py-tool TOOL         Python auditor: pip-audit (default, CI parity) | uv
  --audit-level LEVEL    pnpm audit threshold: info|low|moderate|high|critical (default low)
  --quiet                Suppress per-tool output; print only the summary line
  --help                 Show this help

Notes:
  • pnpm audit reads audit.ignore from pnpm-workspace.yaml natively, so
    accepted/suppressed advisories do not fail the run (matches the CI gate).
  • --docker requires the dev stack to be running:
        bash code/src/scripts/development/server.sh up
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)        MODE="local"; shift ;;
    --docker)       MODE="docker"; shift ;;
    --js-only)      RUN_PY=false; shift ;;
    --py-only)      RUN_JS=false; shift ;;
    --py-tool)      require_arg "$@"; PY_TOOL="$2"; shift 2 ;;
    --audit-level)  require_arg "$@"; AUDIT_LEVEL="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --help|-h)      usage; exit 0 ;;
    *)              die "Unknown option: $1. Use --help for usage." ;;
  esac
done

case "$AUDIT_LEVEL" in
  info|low|moderate|high|critical) ;;
  *) die "Invalid --audit-level '$AUDIT_LEVEL'. Choose: info low moderate high critical" ;;
esac
case "$PY_TOOL" in
  pip-audit|uv) ;;
  *) die "Invalid --py-tool '$PY_TOOL'. Choose: pip-audit uv" ;;
esac
$RUN_JS || $RUN_PY || die "--js-only and --py-only are mutually exclusive"

# Compose invocation (adds the worktree dev override when on a us###/ branch).
DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

require_containers() {
  "${DC[@]}" ps --status running 2>/dev/null | grep -q "django" \
    || die "No dev containers running. Start with: bash code/src/scripts/development/server.sh up"
}

# run_capture FILE CMD... — run CMD, streaming its output unless --quiet and keeping a copy in
# FILE, because the verdict is read out of that output. Returns CMD's exit code, never tee's.
run_capture() {
  local file="$1" rc=0
  shift
  set +e
  if $QUIET; then
    "$@" >"$file" 2>&1; rc=$?
  else
    "$@" 2>&1 | tee "$file"; rc=${PIPESTATUS[0]}
  fi
  set -e
  return "$rc"
}

# leg_result RC FILE PATTERN — prints 0 (clean), 1 (finding) or 2 (NOT RUN). PATTERN is the
# line the tool prints when it found something; a failure without it never examined anything.
leg_result() {
  if [[ "$1" -eq 0 ]]; then echo 0
  elif grep -qE "$3" "$2"; then echo 1
  else echo 2
  fi
}

# leg_label RESULT — the summary wording for each result
leg_label() {
  case "$1" in
    0) echo "clean ✓" ;;
    1) echo "VULNERABLE ✗" ;;
    *) echo "NOT RUN ? — the tool failed before reaching a result; nothing was examined" ;;
  esac
}

# ── JS/TS — pnpm audit ────────────────────────────────────────────────────────
# Each audit_* sets its leg's result (0 | 1 | 2) in JS_EXIT / PY_EXIT — see leg_result.
audit_js() {
  local out rc=0
  bold "▶ JS/TS — pnpm audit --audit-level $AUDIT_LEVEL (mode: $MODE)"
  out="$(mktemp)"
  # pnpm is host-only — the django image carries no Node toolchain.
  run_capture "$out" bash -c "cd '$PROJECT_ROOT' && pnpm audit --audit-level $AUDIT_LEVEL" || rc=$?
  JS_EXIT="$(leg_result "$rc" "$out" '[0-9]+ vulnerabilit(y|ies) found')"
  rm -f "$out"
}

# ── Python — pip-audit (default) or uv audit ──────────────────────────────────
audit_py() {
  local out rc=0 found
  out="$(mktemp)"
  if [[ "$PY_TOOL" == "uv" ]]; then
    bold "▶ Python — uv audit (mode: $MODE)"
    # uv audit is experimental and no finding transcript of it is captured here, so its
    # finding shape is matched loosely: any line naming a vulnerability.
    found='[Vv]ulnerabilit'
    local cmd='uv audit --preview-features audit-command'
    if [[ "$MODE" == "docker" ]]; then
      run_capture "$out" "${DC[@]}" exec -T django sh -c "cd /workspace/code/src/django && $cmd" || rc=$?
    else
      run_capture "$out" bash -c "cd '$BACKEND_DIR' && $cmd" || rc=$?
    fi
  else
    found='Found [0-9]+ known vulnerabilit'

    bold "▶ Python — pip-audit (mode: $MODE)"
    # Export the locked deps to a requirements file, then scan it — matches the CI gate.
    #
    # --frozen is load-bearing, not tidiness. Without it `uv export` UPDATES uv.lock as a
    # side effect, so an audit that only reads would silently create the lockfile on a tree
    # that has none — and every `[ -f uv.lock ]` guard in the repository reads that file to
    # decide whether a gate runs. A read-only-looking script must never be able to arm five
    # CI gates by accident; with --frozen it fails loudly instead.
    #
    # --all-groups because uv exports its default groups only (`dev`), so until 14/10/2026 the
    # `test` group — pytest, playwright, mutmut and the rest — was never scanned at all. None
    # of it ships (the images sync --no-dev), but all of it runs on a developer's host.
    #
    # `uv run --frozen` for the same reason as the export: a bare `uv run` re-locks a uv.lock
    # its manifest has moved past, and syncs the environment, before pip-audit starts. That made
    # dependencies/audit.sh's lockfile leg report clean over a lock this audit had just written.
    local cmd='uv export --frozen --all-groups --format requirements-txt --no-hashes > "$req" && uv run --frozen pip-audit --requirement "$req"; rc=$?; rm -f "$req"; exit $rc'
    if [[ "$MODE" == "docker" ]]; then
      run_capture "$out" "${DC[@]}" exec -T django sh -c \
        "cd /workspace/code/src/django && req=\$(mktemp) && $cmd" || rc=$?
    else
      run_capture "$out" bash -c "cd '$BACKEND_DIR' && req=\$(mktemp) && $cmd" || rc=$?
    fi
  fi
  PY_EXIT="$(leg_result "$rc" "$out" "$found")"
  rm -f "$out"
}

# ── Run ───────────────────────────────────────────────────────────────────────
[[ "$MODE" == "docker" ]] && require_containers

if $RUN_JS; then audit_js; log ""; fi
if $RUN_PY; then audit_py; log ""; fi

# ── Summary ───────────────────────────────────────────────────────────────────
js_status="skipped"; py_status="skipped"
$RUN_JS && js_status="$(leg_label "$JS_EXIT")"
$RUN_PY && py_status="$(leg_label "$PY_EXIT")"

bold "── Security audit summary (${MODE}) ──"
$RUN_JS && log "  JS/TS  (pnpm audit):           $js_status"
$RUN_PY && log "  Python (${PY_TOOL}):$(printf '%*s' $((18 - ${#PY_TOOL})) '')$py_status"

if [[ $JS_EXIT -eq 1 || $PY_EXIT -eq 1 ]]; then
  bold "✗ Vulnerabilities found."
  exit 1
fi
if [[ $JS_EXIT -ne 0 || $PY_EXIT -ne 0 ]]; then
  bold "? Unmeasured — an audit marked NOT RUN never examined its dependencies. Fix the cause above and re-run."
  exit 2
fi
bold "✓ No vulnerabilities."
exit 0
