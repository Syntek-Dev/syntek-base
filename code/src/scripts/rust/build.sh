#!/usr/bin/env bash
#
# build.sh — Compile the Rust workspace and install the extension into the venv.
#
# Usage:
#   build.sh            Debug build, installed in editable-equivalent form
#   build.sh --release  Optimised build (what the image and CI use)
#   build.sh --check    Type-check only — no artefact, much faster
#   build.sh --self-test  Prove the maturin floor check against stand-in tools
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
# WHY maturin's VERSION IS CHECKED, AND NOT ONLY ITS PRESENCE
# PyO3 0.30 dropped the `extension-module` feature, so nothing in Cargo stops the module
# linking libpython any more: from maturin 1.9.4, maturin itself does. The floor lives in
# crates/nativecore/pyproject.toml [build-system] requires and is READ from there, never
# restated here. That table binds only a PEP 517 build; `maturin develop` below runs the
# host's maturin, so an older one would install an extension that links libpython. Refused
# with exit 2 before anything compiles. (`cargo build` alone links libpython regardless:
# only the maturin artefact is the abi3-portable one.)
#
SCRIPT_NAME="build.sh"

# ── --self-test ───────────────────────────────────────────────────────────────
# Runs THIS script in debug mode once per fixtures/rust-build/<case>.<exit>.txt, with the
# stand-in cargo and maturin from fixtures/rust-build/stubs/ first on PATH. Each case file
# is the `maturin --version` line the stub prints; <exit> is the exit expected. A case
# expecting 0 must reach `maturin develop`; one expecting 2 must not, and must name the
# floor it was refused against. Dispatched BEFORE _common.sh is sourced, so it needs no
# real toolchain. Exit 0 pass, 1 fail, 2 fixtures missing.
if [[ "${1:-}" == "--self-test" ]]; then
  set -uo pipefail
  self="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
  fx="$(cd "$(dirname "${BASH_SOURCE[0]}")/../audits/fixtures" 2>/dev/null && pwd)/rust-build"
  [[ -d "$fx/stubs" ]] || { printf 'build.sh error: self-test fixtures missing: audits/fixtures/rust-build\n' >&2; exit 2; }
  floor="$(sed -n 's/.*"maturin>=\([0-9][0-9.]*\)[,"].*/\1/p' \
    "$(dirname "$self")/../../rust/crates/nativecore/pyproject.toml" 2>/dev/null | head -1)"
  printf '\033[1m%s\033[0m\n' "▸ build.sh --self-test (maturin floor: ${floor:-unreadable})"
  failed=0 n=0
  for f in "$fx"/*.txt; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f" .txt)"; want="${base##*.}"; n=$((n + 1))
    log_file="$(mktemp)"; err_file="$(mktemp)"
    rc=0
    PATH="$fx/stubs:$PATH" MATURIN_STUB_VERSION="$f" MATURIN_STUB_LOG="$log_file" \
      bash "$self" >/dev/null 2>"$err_file" || rc=$?
    ran=no; grep -q '^develop$' "$log_file" && ran=yes
    if [[ "$rc" != "$want" ]]; then
      failed=1; printf '  ✗ %s: exited %s, expected %s\n' "$base" "$rc" "$want"
    elif [[ "$want" == 0 && "$ran" != yes ]]; then
      failed=1; printf '  ✗ %s: exited 0 without running maturin develop\n' "$base"
    elif [[ "$want" != 0 && "$ran" == yes ]]; then
      failed=1; printf '  ✗ %s: ran maturin develop before refusing\n' "$base"
    elif [[ "$want" != 0 ]] && ! grep -qF "${floor:-<no floor>}" "$err_file"; then
      failed=1; printf '  ✗ %s: refused without naming the %s floor\n' "$base" "${floor:-unreadable}"
    else
      printf '  ✓ %s\n' "$base"
    fi
    rm -f "$log_file" "$err_file"
  done
  [[ $n -gt 0 ]] || { printf 'build.sh error: no cases in audits/fixtures/rust-build\n' >&2; exit 2; }
  if [[ $failed -eq 0 ]]; then
    printf '\033[1m%s\033[0m\n' "✓ Self-test passed — $n case(s); a maturin below the floor is refused before it installs."
    exit 0
  fi
  printf '\033[1m%s\033[0m\n' "✗ Self-test FAILED — fix build.sh, never the fixtures."
  exit 1
fi

source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

MODE=debug
while [[ $# -gt 0 ]]; do
  case "$1" in
    --release) MODE=release; shift ;;
    --check) MODE=check; shift ;;
    --help | -h)
      sed -n '3,11p' "$SCRIPT_SELF" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

# The floor, read from the PEP 517 table, and the host maturin's version, compared
# numerically field by field (1.10.0 is past 1.9.4). Unreadable either way is exit 2.
_maturin_floor() {
  sed -n 's/.*"maturin>=\([0-9][0-9.]*\)[,"].*/\1/p' "$RUST_DIR/crates/nativecore/pyproject.toml" | head -1
}

_version_at_least() {
  local have="$1" want="$2" h1 h2 h3 w1 w2 w3
  IFS=. read -r h1 h2 h3 <<<"$have"
  IFS=. read -r w1 w2 w3 <<<"$want"
  h1=${h1:-0} h2=${h2:-0} h3=${h3:-0} w1=${w1:-0} w2=${w2:-0} w3=${w3:-0}
  ((h1 != w1)) && { ((h1 > w1)); return; }
  ((h2 != w2)) && { ((h2 > w2)); return; }
  ((h3 >= w3))
}

need_maturin() {
  local floor have line
  floor="$(_maturin_floor)"
  [[ -n "$floor" ]] \
    || die "could not read maturin's floor from crates/nativecore/pyproject.toml [build-system] requires."
  need_tool maturin "Install maturin $floor or newer: uv tool install 'maturin>=$floor,<2.0'"
  line="$(maturin --version 2>&1 | head -1)" || true
  have="$(printf '%s\n' "$line" | sed -n 's/^maturin \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p')"
  [[ -n "$have" ]] \
    || die "could not read a version from 'maturin --version' ('$line'); maturin $floor or newer is required. Reinstall with: uv tool install 'maturin>=$floor,<2.0'"
  _version_at_least "$have" "$floor" \
    || die "maturin $have is older than the $floor floor in crates/nativecore/pyproject.toml; below it the installed extension links libpython. Upgrade with: uv tool install 'maturin>=$floor,<2.0'"
}

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
    need_maturin
    _cargo build --workspace --release || _compile_verdict
    maturin develop --release --manifest-path crates/nativecore/Cargo.toml
    ;;
  debug)
    need_maturin
    _cargo build --workspace || _compile_verdict
    maturin develop --manifest-path crates/nativecore/Cargo.toml
    ;;
esac

log ""
bold "✓ Rust build complete."
