#!/usr/bin/env bash
#
# health.sh — Probe the dev stack's liveness and readiness endpoints.
#
# Usage: health.sh [--url URL] [--watch [SECONDS]] [--quiet] [--help]
#
# Reads what `apps.health` publishes and reports it in the terms an operator needs: which
# probe answered, which word readiness returned, and what that word means for the service.
# It never restarts anything — diagnosis only. The recovery steps are
# `how-to/docs/HEALTH-PROBES.md`.
#
# --watch exists because the readiness verdict is memoised for HEALTH_CACHE_TTL_SECONDS
# (default 15): a single probe taken just after an alert can still be reporting the state
# from before the fault, so watching across one TTL is the only honest reading.
#
# Exit codes:  0 = operational   1 = degraded or down   2 = script error
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

# ── Defaults ──────────────────────────────────────────────────────────────────
BASE_URL="${HEALTH_BASE_URL:-http://dev.<%PROJECT_SLUG%>.localhost:81}"
WATCH=false
WATCH_SECONDS=20
QUIET=false

# In syntek-base itself that default is still an unrendered Copier token, naming a host that
# cannot resolve however healthy the stack is. Fall back to the port nginx publishes on
# loopback. A generated project renders a real hostname and never reaches this branch.
if [[ "$BASE_URL" == *PROJECT_SLUG* ]]; then
  BASE_URL="http://localhost:81"
fi

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'health.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }
log()  { $QUIET || printf '%s\n' "$*"; }
warn() { $QUIET || printf '\033[33m%s\033[0m\n' "$*"; }
bad()  { $QUIET || printf '\033[31m%s\033[0m\n' "$*"; }
good() { $QUIET || printf '\033[32m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
health.sh — Probe the dev stack's liveness and readiness endpoints

Usage:
  health.sh                    Probe both endpoints once
  health.sh --watch            Probe every 2s for 20s (one cache TTL, with margin)
  health.sh --watch 60         Probe every 2s for 60s
  health.sh --url URL          Probe a different origin
  health.sh --quiet            Print nothing; use the exit code

Options:
  --url URL          Origin to probe (default: the dev stack; HEALTH_BASE_URL overrides)
  --watch [SECONDS]  Poll repeatedly (default 20s) — the readiness verdict is memoised,
                     so a single probe can predate the fault you are chasing
  --quiet            Suppress output entirely; decide on the exit code alone
  --help             Show this help

What readiness reports:
  operational  every dependency answered                            exit 0
  degraded     Valkey failed; the site is still serving correctly   exit 1
  down         PostgreSQL failed; requests cannot be served         exit 1

Recovery steps and failure modes: how-to/docs/HEALTH-PROBES.md

Exit codes:  0 = operational   1 = degraded or down   2 = script error
EOF
}

# ── Arguments ─────────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --url)    [[ $# -gt 1 ]] || die "--url requires a value"; BASE_URL="$2"; shift 2 ;;
    --watch)  WATCH=true
              # The seconds argument is optional, so only consume $2 when it is a number.
              if [[ "${2:-}" =~ ^[0-9]+$ ]]; then WATCH_SECONDS="$2"; shift 2; else shift; fi ;;
    --quiet)  QUIET=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *)        die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

command -v curl > /dev/null 2>&1 || die "curl is not installed"

# ── One probe pass ────────────────────────────────────────────────────────────
# Returns 0 operational, 1 degraded/down. Prints one line per endpoint.
probe_once() {
  local live_code ready_code ready_body status

  live_code="$(curl -s -m 5 -o /dev/null -w '%{http_code}' "${BASE_URL}/health/" 2>/dev/null || echo "000")"
  ready_body="$(curl -s -m 5 "${BASE_URL}/health/ready/" 2>/dev/null || echo "")"
  ready_code="$(curl -s -m 5 -o /dev/null -w '%{http_code}' "${BASE_URL}/health/ready/" 2>/dev/null || echo "000")"

  if [[ "$live_code" != "200" ]]; then
    bad "  ✗ liveness   ${live_code}  — the process is not answering"
    log "    Not a dependency fault: /health/ touches nothing. Check the container and its"
    log "    startup log:  bash code/src/scripts/development/logs.sh --service django"
    return 1
  fi
  good "  ✓ liveness   200  — process up"

  # Read the word out of the JSON without a parser: the body is one key by contract.
  status="$(printf '%s' "$ready_body" | sed -n 's/.*"status"[[:space:]]*:[[:space:]]*"\([a-z]*\)".*/\1/p')"

  case "$status" in
    operational) good "  ✓ readiness  ${ready_code}  — operational"; return 0 ;;
    degraded)    warn "  ⚠ readiness  ${ready_code}  — degraded: Valkey is not answering."
                 log  "    The site is serving correctly; this is not an outage."
                 return 1 ;;
    down)        bad  "  ✗ readiness  ${ready_code}  — down: PostgreSQL is not answering."
                 return 1 ;;
    *)           bad  "  ✗ readiness  ${ready_code}  — unrecognised body: ${ready_body:-<empty>}"
                 log  "    Expected one of operational, degraded, down."
                 return 1 ;;
  esac
}

# ── Run ───────────────────────────────────────────────────────────────────────
bold "▸ health.sh — ${BASE_URL}"
log ""

if ! $WATCH; then
  probe_once; RC=$?
  log ""
  exit $RC
fi

log "  Watching for ${WATCH_SECONDS}s — a readiness verdict can lag a fault by one cache TTL."
log ""
DEADLINE=$((SECONDS + WATCH_SECONDS))
RC=0
while (( SECONDS < DEADLINE )); do
  probe_once || RC=1
  log ""
  sleep 2
done
exit $RC
