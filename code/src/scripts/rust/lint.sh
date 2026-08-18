#!/usr/bin/env bash
#
# lint.sh — Clippy and rustfmt over the Rust workspace.
#
# Usage:
#   lint.sh              Report issues (warnings are errors)
#   lint.sh --fix        Apply rustfmt and clippy's machine-applicable fixes
#   lint.sh --fmt-only   rustfmt alone — no clippy
#   lint.sh --help
#
# Clippy runs with -D warnings so CI and a local run agree. The per-crate lint table in
# each Cargo.toml is what denies unwrap/expect/panic/indexing on the FFI boundary; this
# script is the thing that enforces it.
#
# WHY --fmt-only EXISTS, AND WHY IT IS NOT THE DEFAULT SHAPE
# This script is the Rust surface's OWNER for both formatting and linting, because
# `cargo fmt --check` failing the lint gate is what keeps CI and a local run agreeing.
# syntax/format.sh delegates here for --file-type rust, and a format command must format
# and nothing else: `--fix` also runs `clippy --fix`, which rewrites logic rather than
# layout. So the aggregator asks for the narrow half by name instead of accepting a
# source rewrite it never advertised. Nothing else passes this flag.
#
# Exit codes:  0 = clean   1 = lint or format issues   2 = script error
#
SCRIPT_NAME="lint.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

FIX=false
FMT_ONLY=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --fix) FIX=true; shift ;;
    --fmt-only) FMT_ONLY=true; shift ;;
    --help | -h)
      sed -n '3,13p' "$SCRIPT_SELF" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

if $FMT_ONLY; then
  bold "▸ lint.sh (rust — rustfmt only)"
  log ""

  if $FIX; then
    cargo fmt --all
  else
    cargo fmt --all --check
  fi

  log ""
  bold "✓ Rust formatting clean."
  exit 0
fi

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
