#!/usr/bin/env bash
#
# pnpm-update.sh — Run pnpm self-update and pin the new version in all project files.
#
# Usage:
#   pnpm-update.sh             Self-update pnpm, then pin the resulting version
#   pnpm-update.sh --pin X.Y.Z Pin a specific version without running self-update
#   pnpm-update.sh --help
#
# Files updated:
#   package.json                            packageManager field and engines.pnpm
#   code/src/docker/**/Dockerfile.*         npm install -g pnpm@<version> lines
#   .claude/CLAUDE.md                       Stack overview table
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
die()  { printf 'pnpm-update.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  cat <<'EOF'
pnpm-update.sh — Self-update pnpm and pin the new version in all project files

Usage:
  pnpm-update.sh               Run pnpm self-update, then pin the resulting version
  pnpm-update.sh --pin X.Y.Z   Pin a specific version without running self-update
  pnpm-update.sh --help        Show this help

Files updated:
  package.json                      packageManager field + engines.pnpm
  code/src/docker/**/Dockerfile.*   npm install -g pnpm@<version> lines
  .claude/CLAUDE.md                 Stack overview table

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

PIN_VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pin)
      [[ $# -gt 1 ]] || die "--pin requires a version argument (e.g. --pin 11.2.0)"
      PIN_VERSION="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# ── Step 1: self-update or use pinned version ─────────────────────────────────
if [[ -n "$PIN_VERSION" ]]; then
  bold "▸ pnpm-update.sh --pin ${PIN_VERSION}"
  log ""
  NEW_VERSION="$PIN_VERSION"
  log "Skipping pnpm self-update — pinning to ${NEW_VERSION}."
else
  bold "▸ pnpm-update.sh"
  log ""
  log "Running pnpm self-update..."
  pnpm self-update
  NEW_VERSION="$(pnpm --version)"
fi

log ""
log "Pinning pnpm@${NEW_VERSION} across the project..."
log ""

CHANGED=0

# ── Step 2: package.json ──────────────────────────────────────────────────────
PACKAGE_JSON="$PROJECT_ROOT/package.json"

# packageManager field — matches any pinned version string
if grep -q '"packageManager"' "$PACKAGE_JSON"; then
  sed -i "s|\"packageManager\": \"pnpm@[^\"]*\"|\"packageManager\": \"pnpm@${NEW_VERSION}\"|" "$PACKAGE_JSON"
else
  die "No \"packageManager\" field found in package.json. Add it manually first."
fi

# engines.pnpm — matches any version constraint string
sed -i "s|\"pnpm\": \"[^\"]*\"|\"pnpm\": \">=${NEW_VERSION}\"|" "$PACKAGE_JSON"

log "  Updated: package.json"
CHANGED=$((CHANGED + 1))

# ── Step 3: Dockerfiles ───────────────────────────────────────────────────────
DOCKER_DIR="$PROJECT_ROOT/code/src/docker"

while IFS= read -r -d '' dockerfile; do
  if grep -q "npm install -g pnpm@" "$dockerfile"; then
    sed -i "s|npm install -g pnpm@[^[:space:]]*|npm install -g pnpm@${NEW_VERSION}|g" "$dockerfile"
    log "  Updated: ${dockerfile#"$PROJECT_ROOT/"}"
    CHANGED=$((CHANGED + 1))
  fi
done < <(find "$DOCKER_DIR" -name "Dockerfile*" -print0)

# ── Step 4: CLAUDE.md ─────────────────────────────────────────────────────────
CLAUDE_MD="$PROJECT_ROOT/.claude/CLAUDE.md"

if [[ -f "$CLAUDE_MD" ]] && grep -q "pnpm [0-9]" "$CLAUDE_MD"; then
  sed -i "s|pnpm [0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]* (JS)|pnpm ${NEW_VERSION} (JS)|g" "$CLAUDE_MD"
  log "  Updated: .claude/CLAUDE.md"
  CHANGED=$((CHANGED + 1))
fi

# ── Done ──────────────────────────────────────────────────────────────────────
log ""
bold "✓ pnpm pinned to ${NEW_VERSION} in ${CHANGED} file(s)."
log ""
log "  Next steps:"
log "    1. Review the diff:      git diff"
log "    2. Rebuild images:       bash code/src/scripts/development/server.sh up --build"
log "    3. Commit:               git add package.json .claude/CLAUDE.md code/src/docker"
log "                             git commit -m 'chore(deps): bump pnpm to ${NEW_VERSION}'"
