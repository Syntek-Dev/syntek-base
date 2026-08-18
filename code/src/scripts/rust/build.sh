#!/usr/bin/env bash
#
# build.sh — Compile the Rust workspace and install the extension into the venv.
#
# Usage:
#   build.sh            Debug build, installed in editable-equivalent form
#   build.sh --release  Optimised build (what the image and CI use)
#   build.sh --check    Type-check only — no artefact, much faster
#   build.sh --help
#
# The extension module is a uv workspace member built by maturin, so after this runs
# `import nativecore` works in the Django containers and in a local shell.
#
# Exit codes:  0 = built   1 = compilation failed   2 = script error
#
SCRIPT_NAME="build.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

MODE=debug
while [[ $# -gt 0 ]]; do
  case "$1" in
    --release) MODE=release; shift ;;
    --check) MODE=check; shift ;;
    --help | -h)
      sed -n '3,10p' "$SCRIPT_SELF" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

bold "▸ build.sh (rust — $MODE)"
log ""

case "$MODE" in
  check)
    cargo check --workspace --all-targets
    ;;
  release)
    need_tool maturin "Install it with: uv tool install maturin"
    cargo build --workspace --release
    maturin develop --release --manifest-path crates/nativecore/Cargo.toml
    ;;
  debug)
    need_tool maturin "Install it with: uv tool install maturin"
    cargo build --workspace
    maturin develop --manifest-path crates/nativecore/Cargo.toml
    ;;
esac

log ""
bold "✓ Rust build complete."
