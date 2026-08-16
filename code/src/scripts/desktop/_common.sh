#!/usr/bin/env bash
#
# _common.sh — Shared setup for the desktop scripts. Source it, never call it.
#
# Provides:
#   PROJECT_ROOT   repository root
#   RUST_DIR       code/src/rust  (the desktop crate is a member of this workspace)
#   DESKTOP_DIR    code/src/rust/crates/desktop
#   bold/log/die   the house output helpers (die uses $SCRIPT_NAME)
#   need_tool      hard-fail with an install hint when a toolchain binary is missing
#
# WHY THESE RUN ON THE HOST
# A desktop application needs a display server. There is no way to run it usefully inside
# the app container, so like the mobile and rust groups these run on the host — against
# the toolchain pinned by code/src/rust/rust-toolchain.toml.
#
# CONTRACT: SCRIPT_NAME must be set before sourcing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
RUST_DIR="$PROJECT_ROOT/code/src/rust"
DESKTOP_DIR="$RUST_DIR/crates/desktop"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log() { printf '%s\n' "$*"; }
die() { printf '%s error: %s\n' "${SCRIPT_NAME:-desktop}" "$*" >&2; exit 2; }

need_tool() {
  command -v "$1" >/dev/null 2>&1 || die "'$1' not found. $2"
}

[[ -d "$DESKTOP_DIR" ]] || die "code/src/rust/crates/desktop/ not found — this project was generated without the desktop surface."

need_tool cargo "Install rustup: https://rustup.rs — the toolchain is pinned by code/src/rust/rust-toolchain.toml."

# Run from the workspace root so rustup reads rust-toolchain.toml and cargo resolves the
# workspace. The crate is selected with -p rather than by changing directory.
cd "$RUST_DIR"
