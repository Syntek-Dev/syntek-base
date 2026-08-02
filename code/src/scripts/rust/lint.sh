#!/usr/bin/env bash
#
# lint.sh — Clippy and rustfmt over the Rust workspace.
#
# Usage:
#   lint.sh        Report issues (warnings are errors)
#   lint.sh --fix  Apply rustfmt and clippy's machine-applicable fixes
#   lint.sh --help
#
# Clippy runs with -D warnings so CI and a local run agree. The per-crate lint table in
# each Cargo.toml is what denies unwrap/expect/panic/indexing on the FFI boundary; this
# script is the thing that enforces it.
#
# Exit codes:  0 = clean   1 = lint or format issues   2 = script error
#
SCRIPT_NAME="lint.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

FIX=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --fix) FIX=true; shift ;;
    --help | -h)
      sed -n '3,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

bold "▸ lint.sh (rust)"
log ""

if $FIX; then
  cargo fmt --all
  cargo clippy --workspace --all-targets --fix --allow-dirty --allow-staged -- -D warnings
else
  cargo fmt --all --check
  cargo clippy --workspace --all-targets -- -D warnings
fi

log ""
bold "✓ Rust lint clean."
