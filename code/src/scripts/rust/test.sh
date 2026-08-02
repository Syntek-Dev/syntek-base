#!/usr/bin/env bash
#
# test.sh — Run the Rust test suite.
#
# Usage:
#   test.sh              Run every test in the workspace
#   test.sh --path NAME  Run only tests matching NAME
#   test.sh --help
#
# These are the RUST-side tests. The Python-side tests that exercise the extension
# through its PyO3 boundary are pytest tests and run via scripts/tests/ — both must pass,
# because a crate can be perfectly correct and still expose a broken boundary.
#
# Exit codes:  0 = pass   1 = failures   2 = script error
#
SCRIPT_NAME="test.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

FILTER=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --path) FILTER="${2:-}"; [[ -n "$FILTER" ]] || die "--path needs a value."; shift 2 ;;
    --help | -h)
      sed -n '3,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

bold "▸ test.sh (rust)"
log ""

if [[ -n "$FILTER" ]]; then
  cargo test --workspace "$FILTER"
else
  cargo test --workspace
fi

log ""
bold "✓ Rust tests pass."
