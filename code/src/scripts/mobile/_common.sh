#!/usr/bin/env bash
#
# _common.sh — Shared setup for the mobile scripts. Source it, never call it.
#
# Provides:
#   PROJECT_ROOT   repository root
#   MOBILE_DIR     code/src/mobile
#   METRO_PORT     Metro's port for this worktree (see below)
#   bold/log/die   the house output helpers (die uses $SCRIPT_NAME)
#
# METRO PORT AND WORKTREES
# Metro joins each story's existing reserved port block rather than inventing a second
# isolation scheme: base 8081 on main, 8081 + story number in a us### worktree. Parallel
# worktrees therefore never collide on Metro any more than they do on nginx.
#
# CONTRACT: SCRIPT_NAME must be set before sourcing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
MOBILE_DIR="$PROJECT_ROOT/code/src/mobile"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log() { printf '%s\n' "$*"; }
die() { printf '%s error: %s\n' "${SCRIPT_NAME:-mobile}" "$*" >&2; exit 2; }

# shellcheck source=../_lib/worktree-detect.sh
source "$PROJECT_ROOT/code/src/scripts/_lib/worktree-detect.sh"

if [[ -n "$WORKTREE_US_NUM" ]]; then
  # 10# forces base-10: a story number like 008 is not octal.
  METRO_PORT=$((8081 + 10#$WORKTREE_US_NUM))
else
  METRO_PORT=8081
fi

[[ -d "$MOBILE_DIR" ]] || die "code/src/mobile/ not found — this project was generated without the mobile surface."

# Every mobile operation runs from the app directory so pnpm resolves the workspace
# member rather than the repository root.
cd "$MOBILE_DIR"
