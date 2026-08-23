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
# Exit codes:  0 = clean   1 = lint or format issues
#              2 = script error, INCLUDING a workspace that would not build — no lint
#                  result exists, so there is nothing to report about the code
#
# WHY A WORKSPACE THAT WILL NOT BUILD IS 2 AND NEVER 1
# `cargo clippy` exits 101 for a lint it denied AND for a workspace that never compiled —
# a build script panicking over an absent system library, a missing linker, an unreachable
# registry. Those are not the same result: the first is a finding ABOUT THE CODE, the
# second is no finding at all, because clippy never read the code. Filing it as 1 reports
# "could not look" as "looked, and found something" — the same lie as a false green, just
# pointing the other way. Rule: code/docs/GATE-REPORTING.md.
# They are told apart by the one question the exit code cannot answer — did anything in
# THIS workspace get diagnosed? — and every rustc and clippy diagnostic answers it by
# rendering a `--> path:line:col` span, which a run that died in a dependency's build
# script never emits, and a run that died inside a dependency emits only into the registry.
# syntax/lint.sh reads the 2 and files the Rust leg as COULD NOT RUN, quoting the reason
# out of this script's `lint.sh error:` line. That reason must therefore name a cause a
# reader can act on — "rust lint failed" tells nobody which library to install.
# The span question and the reason are asked by build.sh too, so both live in _common.sh;
# what differs is only the verdict each draws, and that stays here.
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

# rustfmt exits 1 for "this needs reformatting", which is a finding, and 101 when it is not
# installed for the pinned toolchain, which is no formatting verdict at all.
_fmt() {
  local rc=0
  _cargo fmt "$@" || rc=$?
  case $rc in
    0) return 0 ;;
    1)
      log ""
      bold "✗ Rust formatting issues found."
      $FIX || log "  Run lint.sh --fix, or syntax/format.sh --file-type rust --fix."
      exit 1
      ;;
    *)
      die "cargo fmt could not run (exit $rc), so nothing was checked: rustfmt is missing from the toolchain pinned in code/src/rust/rust-toolchain.toml, or a file could not be parsed. Add it with: rustup component add rustfmt"
      ;;
  esac
}

# Called only after a clippy invocation failed. Turns cargo's single 101 into this script's
# two answers, per the header.
_clippy_verdict() {
  if _workspace_was_diagnosed; then
    log ""
    bold "✗ Rust lint issues found."
    exit 1
  fi
  die "$(_no_build_reason)"
}

if $FMT_ONLY; then
  bold "▸ lint.sh (rust — rustfmt only)"
  log ""

  if $FIX; then
    _before=$(_snapshot)
    _fmt --all
    log ""
    _report_writes "rustfmt applied" "$_before"
  else
    # `_fmt` exits before this line unless `--check` came back clean, so the state IS the
    # result here.
    _fmt --all --check
    log ""
    bold "✓ Rust formatting clean."
  fi
  exit 0
fi

bold "▸ lint.sh (rust)"
log ""

if $FIX; then
  _before=$(_snapshot)
  _fmt --all
  _clippy_rc=0
  _cargo clippy --workspace --all-targets --fix --allow-dirty --allow-staged -- -D warnings \
    || _clippy_rc=$?
  log ""
  # Named separately from rustfmt because `clippy --fix` rewrites LOGIC, not layout, and the
  # reader needs to know which files to re-read rather than merely re-format. Reported BEFORE
  # the verdict below, because a run that then fails has still rewritten the tree.
  _report_writes "rustfmt + clippy --fix applied" "$_before"
  if [[ $_clippy_rc -ne 0 ]]; then
    _clippy_verdict
  fi
else
  _fmt --all --check
  _cargo clippy --workspace --all-targets -- -D warnings || _clippy_verdict
  log ""
  bold "✓ Rust lint clean."
fi
