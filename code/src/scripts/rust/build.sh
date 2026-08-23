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
# Exit codes:  0 = built   1 = this workspace's own code failed to compile
#              2 = script error, INCLUDING a workspace that could not be built at all —
#                  no compile result exists for the code in code/src/rust/
#
# WHY A FAILED COMPILE IS SOMETIMES 1 AND SOMETIMES 2
# cargo exits 101 for a type error in our crates AND for a run that never reached them —
# a dependency's build script panicking over an absent system library, a missing linker,
# an unreachable registry. Here, unlike in lint.sh, a compilation failure is a LEGITIMATE
# FINDING: `cargo check` IS the type gate, so rustc diagnosing our code is precisely the
# result this script was asked for. What is not a finding is a run that never read our
# code — filing that as 1 reports a missing system library as broken code, and it is the
# same lie as a false green, pointing the other way. Rule: code/docs/GATE-REPORTING.md.
# So the discrimination is NOT "did it compile" but the span question lint.sh asks — was
# anything in THIS workspace diagnosed? — and the classifier answering it is shared with
# lint.sh in _common.sh rather than copied here, because one rule gets one home.
# syntax/check.sh reads the 2 and files the Rust leg as COULD NOT RUN, quoting the reason
# out of this script's `build.sh error:` line. That reason must therefore name a cause a
# reader can act on — "rust build failed" tells nobody which library to install.
#
# maturin's own exit is deliberately left alone: it runs only after `cargo build` has
# already compiled this workspace, so it is a packaging step, not the compile leg above.
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

# Called only after a cargo compile leg failed. Turns cargo's single 101 into this
# script's two answers, per the header.
_compile_verdict() {
  if _workspace_was_diagnosed; then
    log ""
    bold "✗ Rust compilation failed — rustc diagnosed this workspace's own code above."
    exit 1
  fi
  die "$(_no_build_reason)"
}

bold "▸ build.sh (rust — $MODE)"
log ""

case "$MODE" in
  check)
    _cargo check --workspace --all-targets || _compile_verdict
    ;;
  release)
    need_tool maturin "Install it with: uv tool install maturin"
    _cargo build --workspace --release || _compile_verdict
    maturin develop --release --manifest-path crates/nativecore/Cargo.toml
    ;;
  debug)
    need_tool maturin "Install it with: uv tool install maturin"
    _cargo build --workspace || _compile_verdict
    maturin develop --manifest-path crates/nativecore/Cargo.toml
    ;;
esac

log ""
bold "✓ Rust build complete."
