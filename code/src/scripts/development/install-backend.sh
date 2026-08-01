#!/usr/bin/env bash
#
# install-backend.sh — Regenerate uv.lock and sync Python backend dependencies.
#
# Usage:
#   install-backend.sh            Update uv.lock only (does not touch .venv)
#   install-backend.sh --sync     Update uv.lock and install into .venv
#   install-backend.sh --check    Verify uv.lock is up-to-date without installing
#   install-backend.sh --help
#
# Workflow:
#   After changing pyproject.toml            →  install-backend.sh  (updates lockfile)
#   After adding a new package               →  install-backend.sh --sync  (lockfile + .venv)
#   In CI / pre-commit verification          →  install-backend.sh --check
#
# The Docker backend image is rebuilt on the next 'server.sh up --build', which
# runs 'uv sync --frozen' inside the container using the committed uv.lock.
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
die()  { printf 'install-backend.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  cat <<'EOF'
install-backend.sh — Regenerate uv.lock and sync Python backend dependencies

Usage:
  install-backend.sh           Update uv.lock only (.venv untouched)
  install-backend.sh --sync    Update uv.lock and install/update .venv (all groups)
  install-backend.sh --check   Verify uv.lock is up-to-date without installing
  install-backend.sh --help    Show this help

Typical workflows:
  After changing pyproject.toml:            install-backend.sh
  After adding a package (need IDE types):  install-backend.sh --sync
  In CI or pre-commit verification:         install-backend.sh --check
EOF
}

SYNC=false
CHECK=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --sync)      SYNC=true;  shift ;;
    --check)     CHECK=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

if $CHECK; then
  bold "▸ install-backend.sh --check"
  log ""
  log "Verifying uv.lock is up-to-date..."
  uv lock --check
  log ""
  bold "✓ uv.lock is up-to-date."
  exit 0
fi

if $SYNC; then
  bold "▸ install-backend.sh --sync"
  log ""
  log "Updating uv.lock and installing into .venv (all dependency groups)..."
  uv sync --all-groups
  log ""
  bold "✓ .venv updated. Commit uv.lock if it changed."
  bold "  Run 'server.sh up --build' to rebuild the Docker image with the new packages."
  exit 0
fi

bold "▸ install-backend.sh"
log ""
log "Updating uv.lock (lockfile-only — .venv untouched)..."
uv lock
log ""
bold "✓ uv.lock updated. Commit uv.lock if it changed."
bold "  Run 'install-backend.sh --sync' if you also need local .venv (IDE, type-check)."
bold "  Run 'server.sh up --build' to rebuild the Docker image with the new packages."
