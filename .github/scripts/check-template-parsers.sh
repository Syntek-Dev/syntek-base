#!/usr/bin/env bash
#
# check-template-parsers.sh — prove every toolchain can still parse its own manifest
# in the TEMPLATE, before a project is generated.
#
# THE DEFECT CLASS. The sibling token check beside this one checks token SHAPE — is it
# well-formed, is it registered, is a delimiter spelled out. This script checks token
# POSITION, which is the other half and cannot be done by reading text:
#
#   A token is inert in a comment, a description or a string literal. It is fatal in any
#   position a real parser validates — a package name, a crate name, a shell word — because
#   `<`, `%` and `>` are not legal there. Such a file cannot be parsed in this repository at
#   all, so every gate that depends on parsing it fails HERE while looking perfectly correct
#   in a generated project. The gate then proves nothing until after generation, which is the
#   one place nobody looks.
#
# WHY A PROBE AND NOT A LIST OF POSITIONS. The obvious plan is to teach the sibling check
# "the handful of positions that qualify". That plan does not survive contact with the
# evidence: pnpm parses `<%PROJECT_SLUG%>` in package.json's `name` without complaint — it
# still does, in both the root and mobile manifests — while uv rejects the identical token
# in a pyproject.toml `name` and refuses to load the project. Same syntactic position,
# opposite verdict — so "is this an identifier position?" is not statically decidable, and
# any hand-maintained register of positions is just the rule again, one level up, still
# carried by whoever remembers to read it.
#
# THE UV HALF IS A FACT ABOUT UV, NOT A REPORT ON THIS TREE. syntek-base's own `name` has
# been the house constant `syntek-base` since `7cd385d`, precisely because the token there
# was fatal — so the live manifest no longer demonstrates the claim the probe is built on.
# What keeps it honest is `--self-test` below, which builds a throwaway manifest carrying
# the token in that exact position and asserts uv still rejects it. Read the claim in the
# present tense about uv; read the repository as the case already fixed.
#
# So this script does not look at positions at all. It runs each toolchain's OWN parser and
# requires success — which catches every position where the delimiters are ILLEGAL, without
# anyone maintaining a list of which those are.
#
# WHAT IT CANNOT REACH, STATED HERE BECAUSE THIS HEADER USED TO CLAIM THE OPPOSITE. A shell
# word is the one position where the delimiters are legal and ACTIVE: `<` and `>` are
# redirects, so the command parses cleanly and then does something else. A probe whose test
# is parse-SUCCESS can never fire there. Measured 18/08/2026 — a compose file carrying the
# token inside a CMD-SHELL healthcheck passes `docker compose config` at exit 0. That is the
# `70fc963` case and the `test-api.yml:86` case, and neither would
# have been caught here. The remedy for that row is doctrine, not a gate: a shell word never
# carries a token — see the position table in how-to/src/TEMPLATE-TOKENS.md.
#
# WHAT EACH PROBE COSTS. All are metadata-only — no build, no network beyond a dependency
# resolve, nothing written to the tree.
#
#   uv lock --dry-run          the Python manifest and its whole dependency graph
#   cargo metadata --no-deps   the Rust workspace and every member Cargo.toml
#   pnpm ls -r --depth -1      the JS workspace and every member package.json
#   docker compose config      each compose file, interpolated — NOT the shell-word case
#
# The compose probe passes each file its matching `.env.<env>.example`. Without one, compose
# fails on unset required variables rather than on anything to do with tokens, and a gate that
# fails for the wrong reason is worse than no gate. The side-effect is worth having: this also
# proves every example env file is complete enough to render its own compose file.
#
# ABSENT SURFACES ARE NOT FAILURES, AND NOT SILENCE EITHER. Rust and mobile are optional and
# absent from most generated projects, so a missing manifest SKIPS — loudly, by name. A
# manifest that is present with no toolchain to read it is the dangerous case and FAILS: that
# is a gate that cannot run, and the house rule is that it must say so rather than pass.
#
# Requirements: git. Each probe requires its own toolchain only when its manifest exists.
#
# Usage:  bash .github/scripts/check-template-parsers.sh [--self-test] [--help]
# Exit:   0 = every present surface parses   1 = a surface failed, or a probe could not run
#         2 = script error
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

SELF_TEST=false
usage() {
  cat <<'EOF'
check-template-parsers.sh — prove every toolchain can parse its own manifest in the template

Usage: check-template-parsers.sh [--self-test] [--help]

  --self-test  Prove the probe still fires: build a synthetic manifest carrying a token in
               a validated position and assert the parser rejects it
  --help       Show this message

Exit codes: 0 = clean  1 = a surface failed to parse, or a probe could not run  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           printf 'check-template-parsers.sh error: unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
done

STATUS=0
pass() { printf '  \033[32m✓\033[0m %-28s %s\n' "$1" "$2"; }
skip() { printf '  \033[2m–\033[0m %-28s %s\n' "$1" "$2"; }
fail() { printf '  \033[31m✗\033[0m %-28s %s\n' "$1" "$2"; STATUS=1; }

# $1 label · $2 manifest that must exist · $3 tool · $4… the probe
probe() {
  local label="$1" manifest="$2" tool="$3"; shift 3
  if [[ ! -e "$manifest" ]]; then
    skip "$label" "no $manifest — surface not in this project"
    return 0
  fi
  if ! command -v "$tool" >/dev/null 2>&1; then
    fail "$label" "$manifest exists but '$tool' is not installed — cannot verify"
    return 0
  fi
  local out
  if out=$("$@" 2>&1); then
    pass "$label" "parses"
  else
    fail "$label" "$tool could not parse it:"
    printf '%s\n' "$out" | sed -n '1,6p' | sed 's/^/      /'
  fi
}

run_probes() {
  printf '\033[1m▸ Template parser probes\033[0m\n\n'

  probe "Python — uv" pyproject.toml uv \
    uv lock --dry-run

  probe "Rust — cargo" code/src/rust/Cargo.toml cargo \
    cargo metadata --no-deps --format-version 1 --manifest-path code/src/rust/Cargo.toml

  probe "JS — pnpm workspace" package.json pnpm \
    pnpm ls -r --depth -1

  # Compose files are enumerated rather than globbed into one probe, so a failure names the
  # environment that broke instead of "one of four".
  local f e
  for e in dev test staging prod; do
    f="code/src/docker/docker-compose.$e.yml"
    if [[ ! -f "$f" ]]; then
      skip "Docker — $e" "no $f"
      continue
    fi
    if [[ ! -f "code/src/docker/.env.$e.example" ]]; then
      fail "Docker — $e" "$f has no .env.$e.example; compose cannot be interpolated"
      continue
    fi
    probe "Docker — $e" "$f" docker \
      docker compose --env-file "code/src/docker/.env.$e.example" -f "$f" config
  done
}

# ── Self-test ─────────────────────────────────────────────────────────────────
#
# A gate nobody has watched fail is not known to work. Rather than mutate a real manifest,
# build a synthetic one carrying a token in the exact position that motivated this script,
# and assert uv rejects it.
self_test() {
  local tmpdir rc out
  printf '\033[1m▸ check-template-parsers.sh --self-test\033[0m\n\n'
  command -v uv >/dev/null 2>&1 || { echo "uv unavailable — refusing to report a proof that never ran" >&2; exit 2; }
  command -v mktemp >/dev/null 2>&1 || { echo "mktemp unavailable" >&2; exit 2; }

  tmpdir=$(mktemp -d) || { echo "could not create a temporary directory" >&2; exit 2; }
  # shellcheck disable=SC2064
  trap "rm -rf '$tmpdir'" RETURN

  # Negative first: a legal name must parse, or the positive proves nothing.
  cat > "$tmpdir/pyproject.toml" <<'TOML'
[project]
name = "legal-name"
version = "0.1.0"
requires-python = ">=3.14"
dependencies = []
[tool.uv]
package = false
TOML
  if out=$(cd "$tmpdir" && uv lock --dry-run 2>&1); then
    printf '  ✓ a legal package name parses — the baseline is clean\n'
  else
    printf '\033[31m  ✗ a legal package name failed to parse — the baseline is broken\033[0m\n' >&2
    printf '%s\n' "$out" | sed 's/^/      /' >&2
    exit 2
  fi

  # The positive: the same manifest with the name tokenised, which is the defect this
  # script exists for. Built from parts so the literal never appears in a rendered file.
  local tok
  tok="<%""PROJECT_SLUG""%>"
  sed -i "s/legal-name/$tok/" "$tmpdir/pyproject.toml"
  rm -f "$tmpdir/uv.lock"
  rc=0
  out=$(cd "$tmpdir" && uv lock --dry-run 2>&1) || rc=$?
  if [[ $rc -ne 0 ]] && printf '%s' "$out" | grep -qi 'not a valid package'; then
    printf '  ✓ a tokenised package name is rejected — the probe fires\n\n'
    printf '\033[1m✓ Self-test passed — the probe separates a legal manifest from a tokenised one.\033[0m\n\n'
    return 0
  fi

  printf '\033[31m  ✗ a tokenised package name was NOT rejected — the probe no longer fires\033[0m\n' >&2
  printf '%s\n' "$out" | sed -n '1,6p' | sed 's/^/      /' >&2
  printf '\n  fix the probe, never the expectation.\n\n' >&2
  return 1
}

if $SELF_TEST; then
  self_test
  exit $?
fi

run_probes
printf '\n'
if [[ $STATUS -eq 0 ]]; then
  printf '\033[1m\033[32m✓\033[0m Every present surface parses in the template.\033[0m\n\n'
else
  printf '\033[31mA surface does not parse in the template.\033[0m Its gates cannot run here, and\n'
  printf 'will look correct only after generation. Move the token out of the validated position\n'
  printf '— house constant here, branded by a copier _task — as pyproject.toml does.\n'
  printf 'Rule: how-to/src/TEMPLATE-TOKENS.md, "Position matters as much as shape".\n\n'
fi
exit $STATUS
