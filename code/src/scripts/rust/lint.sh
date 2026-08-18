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

# Report the ACTION, never only a state. Both blocks below can REWRITE source under --fix —
# `cargo fmt --all` always, `clippy --fix` sometimes rewriting logic rather than layout — and a
# success line reading "clean" is true either way while telling the reader nothing about what
# just happened to their tree. Rule: code/docs/GATE-REPORTING.md.
# CONTENT digests, not `git status`: a file that was ALREADY dirty before the run stays dirty
# after it, so a porcelain comparison reports "nothing changed" over a real rewrite. target/ is
# excluded — it is generated, gitignored, and thousands of files.
_snapshot() {
  find "$RUST_DIR" -type f \( -name '*.rs' -o -name '*.toml' \) -not -path '*/target/*' -print0 2>/dev/null \
    | sort -z | xargs -0 md5sum 2>/dev/null || true
}
_report_writes() {
  local label="$1" before="$2" after changed
  after=$(_snapshot)
  if [[ "$before" == "$after" ]]; then
    bold "✓ $label — no file was changed."
  else
    # `|| true` is load-bearing under `set -o pipefail`: diff exits 1 precisely WHEN there are
    # differences, which is the only branch that reaches this line.
    changed=$( { diff <(printf '%s\n' "$before") <(printf '%s\n' "$after") 2>/dev/null || true; } \
      | awk '/^>/ {print $NF}' | sed "s|^$RUST_DIR/||" | sort -u | paste -sd', ')
    bold "✓ $label — rewrote: ${changed:-(files under code/src/rust/)}"
  fi
}

if $FMT_ONLY; then
  bold "▸ lint.sh (rust — rustfmt only)"
  log ""

  if $FIX; then
    _before=$(_snapshot)
    cargo fmt --all
    log ""
    _report_writes "rustfmt applied" "$_before"
  else
    # `--check` exits non-zero when anything needs formatting and `set -e` stops the script,
    # so reaching this line genuinely means clean. The state IS the result here.
    cargo fmt --all --check
    log ""
    bold "✓ Rust formatting clean."
  fi
  exit 0
fi

bold "▸ lint.sh (rust)"
log ""

if $FIX; then
  _before=$(_snapshot)
  cargo fmt --all
  cargo clippy --workspace --all-targets --fix --allow-dirty --allow-staged -- -D warnings
  log ""
  # Named separately from rustfmt because `clippy --fix` rewrites LOGIC, not layout, and the
  # reader needs to know which files to re-read rather than merely re-format.
  _report_writes "rustfmt + clippy --fix applied" "$_before"
else
  cargo fmt --all --check
  cargo clippy --workspace --all-targets -- -D warnings
  log ""
  bold "✓ Rust lint clean."
fi
