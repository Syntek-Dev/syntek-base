#!/usr/bin/env bash
#
# install-frontend.sh — Regenerate pnpm-lock.yaml and sync the repo JS tooling
#            (markdownlint, prettier, eslint, lefthook, bruno). There is no client build.
#
# Usage:
#   install-frontend.sh             Update lockfile only (does not touch node_modules)
#   install-frontend.sh --local     Remove Docker-owned node_modules, then install locally
#   install-frontend.sh --check     Verify lockfile is up-to-date without installing
#   install-frontend.sh --help
#
# Workflow:
#   After changing a package.json            →  install-frontend.sh  (updates lockfile)
#   After 'server.sh up --build'             →  install-frontend.sh --local  (re-owns node_modules)
#   After any EACCES pnpm install error      →  install-frontend.sh --local
#
# --local requires sudo to remove Docker-owned (root-owned) node_modules.
# Docker rebuilds them on the next 'server.sh up --build'.
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
die()  { printf 'install-frontend.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  cat <<'EOF'
install-frontend.sh — Regenerate pnpm-lock.yaml and sync the repo JS tooling

Usage:
  install-frontend.sh           Update lockfile only (node_modules untouched)
  install-frontend.sh --local   Remove Docker-owned node_modules, then install locally
  install-frontend.sh --check   Verify lockfile is up-to-date (frozen-lockfile check)
  install-frontend.sh --help    Show this help

Typical workflows:
  After changing a package.json:          install-frontend.sh
  After 'server.sh up --build' (EACCES):  install-frontend.sh --local
EOF
}

CHECK=false
LOCAL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)     LOCAL=true; shift ;;
    --check)     CHECK=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    # Keep --clean as an alias for --local for backwards compatibility
    --clean)     LOCAL=true; shift ;;
    *)           die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

if $CHECK; then
  bold "▸ install-frontend.sh --check"
  log ""
  log "Verifying lockfile is up-to-date..."
  pnpm install --frozen-lockfile --ignore-scripts
  log ""
  bold "✓ Lockfile is up-to-date."
  exit 0
fi

if $LOCAL; then
  bold "▸ install-frontend.sh --local"
  log ""
  log "Removing Docker-owned node_modules (requires sudo)..."
  # node_modules created by Docker are owned by root; safe to delete because
  # Docker rebuilds them on the next 'server.sh up --build'.
  sudo rm -rf \
    "$PROJECT_ROOT/node_modules" \
  log "Removed."
  log ""
  log "Installing packages locally..."
  pnpm install --ignore-scripts
  log ""
  bold "✓ Local install complete. Commit pnpm-lock.yaml if it changed."
  exit 0
fi

bold "▸ install-frontend.sh"
log ""
log "Updating pnpm-lock.yaml (lockfile-only — node_modules untouched)..."
pnpm install --lockfile-only --ignore-scripts
log ""
bold "✓ Lockfile updated. Commit pnpm-lock.yaml if it changed."
bold "  Run 'install-frontend.sh --local' if you also need local node_modules (IDE, type-check)."
