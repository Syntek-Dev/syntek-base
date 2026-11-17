#!/usr/bin/env bash
#
# install-hooks.sh — Arm the lefthook git hooks for this checkout, on purpose.
#
# The arming step root install.sh runs last in Phase 1, extracted so it can run (and be
# probed) without docker, sudo or secrets. It arms the EFFECTIVE pre-commit hook — the path
# `git rev-parse --path-format=absolute --git-path hooks/pre-commit` names from the checkout
# root — so a linked worktree and a relative or absolute core.hooksPath arm the hook git will
# actually run, never an unused default. It reports what it wrote and what it replaced (a
# hand-written hook, or the raw one `code-review-graph install` appends), rather than
# overwriting in silence.
#
# "Armed" is one predicate, shared by both modes and by tests/hook-arming.sh: the effective
# path is a readable, executable regular file carrying lefthook's generated marker, the line
# `call_lefthook run "pre-commit"`. A marker without the executable bit is unarmed.
#
# --notice is the package.json `postinstall`: it reads only, writes only to stdout, and
# ALWAYS exits 0. It prints one line naming `bash install.sh` when the hooks are unarmed in a
# git checkout, and nothing when they are armed, when CI is set, when there is no repository,
# or when git is not on PATH. It never runs lefthook, never writes a file, makes no network
# call and reads no credential.
#
# Usage:
#   install-hooks.sh            Arm the hooks (pnpm exec lefthook install)
#   install-hooks.sh --notice   Print a one-line reminder if the hooks are unarmed; exit 0
#   install-hooks.sh --help     Show this help
#
# Exit codes:  0 = success   1 = requirement missing   2 = install failed
#   0 — armed, or skipped (no git repository; core.hooksPath=/dev/null opt-out)
#   1 — git, pnpm or the lefthook binary not found
#   2 — the hook path cannot be resolved, `lefthook install` failed, or it did not arm the
#       effective hook
#
# These follow root install.sh's exit-code contract DELIBERATELY, not this folder's
# `1 = command failed, 2 = script error` (install-backend.sh, install-frontend.sh): this
# script exists to be a step of install.sh, which propagates its code unchanged. An
# unknown option is therefore also a 2 here.
#
# Writes only under the effective hook directory, plus lefthook's own
# .git/info/lefthook.checksum, which every `lefthook install` writes.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
MARKER='call_lefthook run "pre-commit"'
GRAPH_MARKER='>>> code-review-graph pre-commit hook >>>'

# ── Helpers — install.sh's shape (glyph + colour), defined here because it exports none ──
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '  %s\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m  %s\n' "$*"; }
warn() { printf '  \033[33m⚠\033[0m  %s\n' "$*" >&2; }
err()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; }
die()  { err "$*"; exit 2; }

usage() {
  cat <<'EOF'
install-hooks.sh — Arm the lefthook git hooks for this checkout

Usage:
  install-hooks.sh            Arm the effective pre-commit hook (pnpm exec lefthook install)
  install-hooks.sh --notice   Read-only: print a reminder naming `bash install.sh` if the
                              hooks are unarmed. Silent when armed, when CI is set, with no
                              git repository, or with git absent. Always exits 0
  install-hooks.sh --help     Show this help

Skips (exit 0) with no git repository, and arms nothing when core.hooksPath=/dev/null —
that setting is a deliberate opt-out. A custom core.hooksPath is armed with --force.

Exit codes:  0 = armed or skipped   1 = requirement missing   2 = install failed
             (root install.sh's contract, which runs this as its Phase 1 Step 9)
EOF
}

NOTICE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --notice)  NOTICE=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *)         die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT" || die "cannot enter the checkout root $PROJECT_ROOT"

# The effective pre-commit hook, resolved from the checkout root. Fails when git cannot
# resolve it (core.hooksPath under a regular file, or /dev/null).
effective_hook() { git rev-parse --path-format=absolute --git-path hooks/pre-commit 2>/dev/null; }
is_armed() { [[ -f "$1" && -r "$1" && -x "$1" ]] && grep -qF "$MARKER" "$1" 2>/dev/null; }
in_repo() { git rev-parse --git-dir >/dev/null 2>&1; }

# ── --notice — the postinstall. Reads only; every path out is exit 0 ─────────────
if $NOTICE; then
  [[ -n "${CI:-}" ]] && exit 0
  command -v git >/dev/null 2>&1 || exit 0
  in_repo || exit 0
  hook="$(effective_hook)" || hook=""
  if [[ -n "$hook" ]] && is_armed "$hook"; then exit 0; fi
  printf '  \033[33m⚠\033[0m  Git hooks are not armed in this checkout — run: bash install.sh\n'
  exit 0
fi

# ── Arming ────────────────────────────────────────────────────────────────────
command -v git >/dev/null 2>&1 || { err "git not found — it is required to arm the hooks"; exit 1; }

# The guard is git's own answer, never `[ -d .git ]`: a `git worktree add` checkout has .git
# as a FILE, and this project creates such checkouts for parallel story work.
if ! in_repo; then
  warn "Skipped git hook installation — $PROJECT_ROOT is not inside a git repository"
  exit 0
fi

hooks_path="$(git config --get core.hooksPath 2>/dev/null || true)"
if [[ "$hooks_path" == "/dev/null" ]]; then
  warn "Git hooks are disabled by core.hooksPath=/dev/null — nothing armed. To arm them:"
  warn "  git config --unset-all core.hooksPath && bash install.sh"
  exit 0
fi

hook="$(effective_hook)" ||
  die "cannot resolve the effective pre-commit hook path${hooks_path:+ (core.hooksPath=$hooks_path)}"

command -v pnpm >/dev/null 2>&1 || { err "pnpm not found — it is required to run lefthook"; exit 1; }
# `pnpm exec` resolves node_modules/.bin first, so the project's locked lefthook is the one
# that runs even when another lefthook is earlier on PATH.
if ! lh_version="$(pnpm exec lefthook version 2>/dev/null)" || [[ -z "$lh_version" ]]; then
  err "lefthook not found — not installed in node_modules or on PATH (run: bash code/src/scripts/development/install-frontend.sh --local)"
  exit 1
fi

# The third-claimant report: say what is about to be replaced, before it is.
previous=""
if [[ -e "$hook" || -L "$hook" ]]; then
  if is_armed "$hook"; then
    previous="lefthook"
  elif grep -qF "$GRAPH_MARKER" "$hook" 2>/dev/null; then
    previous="the raw hook code-review-graph install appended"
  elif grep -qF "$MARKER" "$hook" 2>/dev/null; then
    previous="a lefthook hook that is not executable"
  else
    previous="a hook lefthook does not manage"
  fi
fi

# lefthook 2.2 refuses a custom core.hooksPath unless forced; force only when one is set.
args=(install)
[[ -n "$hooks_path" ]] && args+=(--force)

if ! output="$(pnpm exec lefthook "${args[@]}" 2>&1)"; then
  [[ -n "$output" ]] && printf '%s\n' "$output" | sed 's/^/    /' >&2
  err "lefthook install failed — the pre-commit hook at $hook is not armed"
  exit 2
fi

# Verify the hook git will actually run, not the one lefthook says it wrote.
if ! is_armed "$hook"; then
  [[ -n "$output" ]] && printf '%s\n' "$output" | sed 's/^/    /' >&2
  err "lefthook install did not arm the effective pre-commit hook at $hook"
  exit 2
fi

case "$previous" in
  "")       ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  lefthook) ok "Git hooks already armed — refreshed $hook (lefthook $lh_version)" ;;
  *)        warn "Replaced $previous at $hook (lefthook keeps a non-lefthook hook as pre-commit.old)"
            ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
esac
