#!/usr/bin/env bash
#
# install.sh — Bootstrap the syntek-website development environment.
#
# Installs all Python and JavaScript dependencies, copies missing .env.*
# files from their examples, and marks every project script executable.
#
# Usage: bash install.sh
#
# Requirements: uv >= 0.11, pnpm >= 10.33
#
# Exit codes:  0 = success   1 = requirement missing   2 = install failed
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# ── Helpers ───────────────────────────────────────────────────────────────────
bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
log()   { printf '  %s\n' "$*"; }
ok()    { printf '  \033[32m✓\033[0m  %s\n' "$*"; }
err()   { printf '\033[31merror:\033[0m %s\n' "$*" >&2; }
die()   { err "$*"; exit 1; }

# ── Preflight checks ──────────────────────────────────────────────────────────
bold "▸ install.sh — syntek-website"
log ""

command -v uv   >/dev/null 2>&1 || die "uv is not installed. See https://docs.astral.sh/uv/getting-started/installation/"
command -v pnpm >/dev/null 2>&1 || die "pnpm is not installed. See https://pnpm.io/installation"

UV_VERSION=$(uv --version 2>&1 | awk '{print $2}')
PNPM_VERSION=$(pnpm --version 2>&1)
log "uv   $UV_VERSION"
log "pnpm $PNPM_VERSION"
log ""

cd "$PROJECT_ROOT"

# ── Python dependencies ───────────────────────────────────────────────────────
bold "── Python (uv sync) ──────────────────────────────────────────────────────"
log ""
uv sync --all-groups || { err "uv sync failed"; exit 2; }
log ""
ok "Python dependencies installed (.venv)"
log ""

# ── JavaScript dependencies ───────────────────────────────────────────────────
bold "── JavaScript (pnpm install) ─────────────────────────────────────────────"
log ""
pnpm install || { err "pnpm install failed"; exit 2; }
log ""
ok "JavaScript dependencies installed (node_modules)"
log ""

# ── Environment files ────────────────────────────────────────────────────────
bold "── Environment files ────────────────────────────────────────────────────"
log ""

ENV_DIR="$PROJECT_ROOT/code/src/docker"
COPIED=()
SKIPPED=()

for example in "$ENV_DIR"/.env.*.example; do
  target="${example%.example}"
  if [[ ! -f "$target" ]]; then
    cp "$example" "$target"
    COPIED+=("$(basename "$target")")
  else
    SKIPPED+=("$(basename "$target")")
  fi
done

for f in "${COPIED[@]+"${COPIED[@]}"}";  do ok "created  code/src/docker/$f"; done
for f in "${SKIPPED[@]+"${SKIPPED[@]}"}"; do log "skipped  code/src/docker/$f (already exists)"; done
log ""

if [[ ${#COPIED[@]} -gt 0 ]]; then
  printf '  \033[33m⚠  All secrets in the following files must be populated before\033[0m\n'
  printf '  \033[33m   starting any environment:\033[0m\n'
  log ""
  for f in "${COPIED[@]}"; do
    log "     code/src/docker/$f"
  done
  log ""
fi

# ── Script permissions ────────────────────────────────────────────────────────
bold "── Script permissions (chmod +x) ────────────────────────────────────────"
log ""

# Make this script executable
chmod +x "$PROJECT_ROOT/install.sh"

# Make every project script executable
find "$PROJECT_ROOT/code/src/scripts" -name "*.sh" -exec chmod +x {} \;

SCRIPT_COUNT=$(find "$PROJECT_ROOT/code/src/scripts" -name "*.sh" | wc -l | tr -d ' ')
ok "$SCRIPT_COUNT scripts marked executable"
log ""

# ── Done ──────────────────────────────────────────────────────────────────────
bold "✓ Ready. Next: populate code/src/docker/.env.* secrets, then run ./code/src/scripts/development/server.sh up"
log ""
