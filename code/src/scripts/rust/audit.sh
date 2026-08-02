#!/usr/bin/env bash
#
# audit.sh — Supply-chain gate for the Rust dependency tree.
#
# Usage:
#   audit.sh           Advisories, licences, bans and sources (cargo-deny)
#   audit.sh --update  Refresh the advisory database first
#   audit.sh --help
#
# WHY THIS IS NOT OPTIONAL
# crates.io has no review process, and a PyO3 extension shares its address space with
# Django — there is no sandbox between a malicious crate and your database credentials.
# A Rust dependency is strictly more dangerous than a pure-Python one, so this runs in CI
# on every change to the workspace. Policy lives in code/src/rust/deny.toml.
#
# Exit codes:  0 = clean   1 = advisory/licence/ban violation   2 = script error
#
SCRIPT_NAME="audit.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

UPDATE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --update) UPDATE=true; shift ;;
    --help | -h)
      sed -n '3,14p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

need_tool cargo-deny "Install it with: cargo install --locked cargo-deny"

bold "▸ audit.sh (rust supply chain)"
log ""

$UPDATE && cargo deny fetch

cargo deny check advisories licenses bans sources

log ""
bold "✓ Rust supply chain clean."
