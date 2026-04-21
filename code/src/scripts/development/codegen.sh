#!/usr/bin/env bash
#
# codegen.sh — Regenerate GraphQL TypeScript types and hooks from the live schema.
#
# Usage: codegen.sh [--help]
#
# Requires the dev stack to be running (backend + frontend containers).
# Fetches the schema from the backend container and writes generated types to:
#   code/src/frontend/src/graphql/generated/
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'codegen.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
codegen.sh — Regenerate GraphQL TypeScript types and hooks from the live schema

Usage:
  codegen.sh [--help]

Requires the dev stack to be running. Start it first with:
  bash code/src/scripts/development/server.sh up

Schema source: http://backend:8000/graphql/ (internal Docker network)
Output:        code/src/frontend/src/graphql/generated/

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

# ── Args ──────────────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage; exit 0 ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

# ── Preflight ─────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"

container_running() {
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qi "$1"
}

container_running backend \
  || die "backend container is not running. Start with: bash code/src/scripts/development/server.sh up"

container_running frontend \
  || die "frontend container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Run codegen ───────────────────────────────────────────────────────────────
bold "▸ codegen.sh"
log ""
log "  Schema: http://backend:8000/graphql/"
log "  Output: code/src/frontend/src/graphql/generated/"
log ""

docker compose -f "$COMPOSE_FILE" exec \
  -e GRAPHQL_SCHEMA_URL=http://backend:8000/graphql/ \
  frontend \
  pnpm codegen

log ""
bold "✓ Types regenerated."
