#!/usr/bin/env bash
#
# _common.sh — Shared setup for the Rust scripts. Source it, never call it.
#
# Provides:
#   PROJECT_ROOT   repository root
#   RUST_DIR       code/src/rust
#   bold/log/die   the house output helpers (die uses $SCRIPT_NAME)
#   need_tool      hard-fail with an install hint when a toolchain binary is missing
#   _cargo         run cargo, showing its output AND keeping a copy of it
#   _workspace_was_diagnosed / _no_build_reason
#                  tell a result ABOUT THIS CODE apart from a run that never reached it
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

# ── Did cargo produce a result ABOUT THIS CODE? ────────────────────────────────
# ONE home, because two callers ask the same question. cargo spends a single exit code
# (101) on a genuine diagnostic AND on a workspace that never compiled — a build script
# panicking over an absent system library, a missing linker, an unreachable registry —
# so lint.sh and build.sh both have to tell those apart before choosing a code. What each
# does with the answer differs and stays in the caller: for clippy a workspace that will
# not build is never a lint finding, while for `cargo check` our own code being diagnosed
# IS the finding. The QUESTION is identical, and a second copy of it is the drift
# audits/doctrine-drift.sh exists to catch. Rule: code/docs/GATE-REPORTING.md.
#
# cargo's output has to be READ and not merely streamed. Streaming through tee costs
# cargo's colour and its progress bar, which is why nothing here asks for `--color=always`:
# the ANSI escapes would sit between `error` and the span the classifier recognises.
CARGO_OUT=""

# Show cargo's output and keep it. Returns cargo's own exit code, never tee's. The capture
# file is created on first use, so test.sh and audit.sh — which source this file and never
# call this — pay nothing for it.
_cargo() {
  local rc=0
  if [[ -z "$CARGO_OUT" ]]; then
    CARGO_OUT=$(mktemp)
    trap 'rm -f "$CARGO_OUT"' EXIT
  fi
  set +e
  cargo "$@" 2>&1 | tee "$CARGO_OUT"
  rc=${PIPESTATUS[0]}
  set -e
  return "$rc"
}

# Did anything in THIS workspace get diagnosed? Every rustc and clippy diagnostic renders a
# `--> path:line:col` span; a run that died in a dependency's build script emits none, and a
# run that died inside a dependency emits them only into the registry. The registry filter
# matters: a diagnostic in code we did not write and do not ship is not a finding about this
# codebase. Call only after _cargo — the question is about a run that happened.
_workspace_was_diagnosed() {
  grep -aE '^ *--> ' "$CARGO_OUT" | grep -qvE '(/registry/|/git/checkouts/)'
}

# The cause, in the words of whoever has to fix it. Read out of cargo's own text, here
# beside the invocation, because syntax/lint.sh and syntax/check.sh quote this line verbatim
# into their COULD NOT RUN summaries and that is what keeps cargo's dialect in one place.
# The message must therefore name something a reader can act on — "rust build failed" tells
# nobody which library to install.
_no_build_reason() {
  local lib pkg first
  lib=$(sed -n 's/.*The system library `\([^`]*\)` required by crate.*/\1/p' "$CARGO_OUT" | head -1)
  pkg=$(sed -n 's/.*failed to run custom build command for `\([^`]*\)`.*/\1/p' "$CARGO_OUT" | head -1)
  if [[ -n "$lib" ]]; then
    printf "the Cargo workspace will not build: the system library '%s' is not installed on this host (%s needs it through pkg-config). Install %s, or set PKG_CONFIG_PATH to the directory holding %s.pc" \
      "$lib" "${pkg:-a dependency}" "$lib" "$lib"
  elif [[ -n "$pkg" ]]; then
    printf "the Cargo workspace will not build: the build script for %s failed — its output is above" "$pkg"
  else
    first=$(grep -am1 '^error' "$CARGO_OUT" | sed 's/^error\(\[[^]]*\]\)\{0,1\}: *//')
    printf "the Cargo workspace will not build: %s" \
      "${first:-cargo stopped before reaching any crate in this workspace}"
  fi
}

[[ -d "$RUST_DIR" ]] || die "code/src/rust/ not found — this project was generated without the Rust surface."

need_tool cargo "Install rustup: https://rustup.rs — the toolchain is pinned by code/src/rust/rust-toolchain.toml."

# Every Rust operation runs from the workspace root so rustup reads rust-toolchain.toml
# and cargo resolves the workspace rather than a single crate.
cd "$RUST_DIR"
