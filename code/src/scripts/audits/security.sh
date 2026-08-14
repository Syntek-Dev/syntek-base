#!/usr/bin/env bash
#
# security.sh — Dependency security audit: pnpm audit (JS/TS) + pip-audit / uv audit (Python).
#
#   Mirrors the CI "[8/8] Security" gate (.github/workflows/claude.yml) so a clean local
#   run predicts a clean CI run. The gate runs, per ecosystem:
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
# Exit codes:  0 = no vulnerabilities   1 = vulnerabilities found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"
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

# Run a command, streaming output unless --quiet. Returns the command's exit code.
run() {
  if $QUIET; then "$@" >/dev/null 2>&1; else "$@"; fi
}

# ── JS/TS — pnpm audit ────────────────────────────────────────────────────────
audit_js() {
  bold "▶ JS/TS — pnpm audit --audit-level $AUDIT_LEVEL (mode: $MODE)"
  # pnpm is host-only — the django image carries no Node toolchain.
  run bash -c "cd '$PROJECT_ROOT' && pnpm audit --audit-level $AUDIT_LEVEL" || return 1
}

# ── Python — pip-audit (default) or uv audit ──────────────────────────────────
audit_py() {
  if [[ "$PY_TOOL" == "uv" ]]; then
    bold "▶ Python — uv audit (mode: $MODE)"
    local cmd='uv audit --preview-features audit-command'
    if [[ "$MODE" == "docker" ]]; then
      run "${DC[@]}" exec -T django sh -c "cd /workspace/code/src/django && $cmd" || return 1
    else
      run bash -c "cd '$BACKEND_DIR' && $cmd" || return 1
    fi
  else
    bold "▶ Python — pip-audit (mode: $MODE)"
    # Export the locked deps to a requirements file, then scan it — matches the CI gate.
    local cmd='uv export --format requirements-txt --no-hashes > "$req" && uv run pip-audit --requirement "$req"; rc=$?; rm -f "$req"; exit $rc'
    if [[ "$MODE" == "docker" ]]; then
      run "${DC[@]}" exec -T django sh -c \
        "cd /workspace/code/src/django && req=\$(mktemp) && $cmd" || return 1
    else
      run bash -c "cd '$BACKEND_DIR' && req=\$(mktemp) && $cmd" || return 1
    fi
  fi
}

# ── Run ───────────────────────────────────────────────────────────────────────
[[ "$MODE" == "docker" ]] && require_containers

if $RUN_JS; then audit_js || JS_EXIT=1; log ""; fi
if $RUN_PY; then audit_py || PY_EXIT=1; log ""; fi

# ── Summary ───────────────────────────────────────────────────────────────────
js_status="skipped"; py_status="skipped"
$RUN_JS && { [[ $JS_EXIT -eq 0 ]] && js_status="clean ✓" || js_status="VULNERABLE ✗"; }
$RUN_PY && { [[ $PY_EXIT -eq 0 ]] && py_status="clean ✓" || py_status="VULNERABLE ✗"; }

bold "── Security audit summary (${MODE}) ──"
$RUN_JS && log "  JS/TS  (pnpm audit):           $js_status"
$RUN_PY && log "  Python (${PY_TOOL}):$(printf '%*s' $((18 - ${#PY_TOOL})) '')$py_status"

if [[ $JS_EXIT -ne 0 || $PY_EXIT -ne 0 ]]; then
  bold "✗ Vulnerabilities found."
  exit 1
fi
bold "✓ No vulnerabilities."
exit 0
