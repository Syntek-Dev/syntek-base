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

# The pinned version, read rather than restated — CI installs exactly this one, so a
# local run that disagrees is answering a different advisory set from the gate.
#
# Built from $RUST_DIR, which _common.sh resolved to an absolute path BEFORE it cd'd there.
# Recomputing it from $BASH_SOURCE here instead is what broke this gate: after that cd, a
# relative invocation (`bash code/src/scripts/rust/audit.sh`, the form every guide documents)
# no longer resolves, and the whole supply-chain audit died on `cd` before running a check.
CARGO_DENY_PIN_FILE="$RUST_DIR/.cargo-deny-version"
CARGO_DENY_VERSION=""
[[ -f "$CARGO_DENY_PIN_FILE" ]] && CARGO_DENY_VERSION="$(tr -d '[:space:]' < "$CARGO_DENY_PIN_FILE")"

need_tool cargo-deny "Install it with: cargo install --locked --version ${CARGO_DENY_VERSION:-<see code/src/rust/.cargo-deny-version>} cargo-deny"

bold "▸ audit.sh (rust supply chain)"
log ""

$UPDATE && cargo deny fetch

cargo deny check advisories licenses bans sources

log ""
bold "✓ Rust supply chain clean."
