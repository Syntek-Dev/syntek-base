#!/usr/bin/env bash
#
# _common.sh — Shared setup for the Rust scripts. Source it, never call it.
#
# Provides:
#   PROJECT_ROOT   repository root
#   RUST_DIR       code/src/rust
#   bold/log/die   the house output helpers (die uses $SCRIPT_NAME)
#   need_tool      hard-fail with an install hint when a toolchain binary is missing
#
# WHY THESE RUN ON THE HOST
# Like the mobile scripts, and unlike everything else, these run on the host rather than
# in Docker. The toolchain is pinned by code/src/rust/rust-toolchain.toml, so a host run
# and the image's build stage compile with the same compiler; putting cargo in a
# container would add a rebuild to every edit for no isolation gain, because the artefact
# is a native module the local interpreter has to load anyway.
#
# CONTRACT: SCRIPT_NAME must be set before sourcing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
# The absolute path of the script that sourced this file. Computed HERE, before the cd
# at the foot of this file: every caller's --help reads its own header with sed, and a
# relative $0 (`bash code/src/scripts/mobile/lint.sh`, which is how every doc in this
# repository invokes these) stops resolving the moment the working directory moves.
SCRIPT_SELF="$SCRIPT_DIR/$(basename "${BASH_SOURCE[1]}")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
RUST_DIR="$PROJECT_ROOT/code/src/rust"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log() { printf '%s\n' "$*"; }
die() { printf '%s error: %s\n' "${SCRIPT_NAME:-rust}" "$*" >&2; exit 2; }

# Hard-fail with the install command rather than letting cargo emit a bare "not found".
need_tool() {
  command -v "$1" >/dev/null 2>&1 || die "'$1' not found. $2"
}

[[ -d "$RUST_DIR" ]] || die "code/src/rust/ not found — this project was generated without the Rust surface."

need_tool cargo "Install rustup: https://rustup.rs — the toolchain is pinned by code/src/rust/rust-toolchain.toml."

# Every Rust operation runs from the workspace root so rustup reads rust-toolchain.toml
# and cargo resolves the workspace rather than a single crate.
cd "$RUST_DIR"
