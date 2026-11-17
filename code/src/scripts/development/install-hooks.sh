#!/usr/bin/env bash
#
# install-hooks.sh — Arm the lefthook git hooks for this checkout, on purpose.
#
# The arming step root install.sh runs last in Phase 1, extracted so it can run (and be
# probed) without docker, sudo or secrets. It arms the EFFECTIVE pre-commit hook — the path
# `git rev-parse --path-format=absolute --git-path hooks/pre-commit` names from the checkout
# root — so a linked worktree and a relative or absolute core.hooksPath arm the hook git will
# actually run, never an unused default. It reports what it wrote and what it replaced (a
# hand-written hook, or the raw one `code-review-graph install` writes or appends), rather
# than overwriting in silence.
#
# Usage:
#   install-hooks.sh            Arm the hooks (pnpm exec lefthook install)
#   install-hooks.sh --notice   Print a one-line reminder if the hooks are unarmed; exit 0
#   install-hooks.sh --help     Show this help
#
# Exit codes:  0 = success   1 = requirement missing   2 = install failed
#   0 — armed, or skipped (no git repository; core.hooksPath=/dev/null opt-out)
#   1 — git, pnpm or the project's lefthook binary (node_modules) not found
#   2 — the hook path cannot be resolved, a pre-commit.old cannot be moved aside,
#       `lefthook install` failed, or it did not arm the effective hook
#
# These follow root install.sh's exit-code contract DELIBERATELY, not this folder's
# `1 = command failed, 2 = script error` (install-backend.sh, install-frontend.sh): this
# script exists to be a step of install.sh, which propagates its code unchanged. An
# unknown option is therefore also a 2 here (outside --notice, which never fails).
#
# "Armed" is one predicate, shared by both modes and by tests/hook-arming.sh: the effective
# path is a readable, executable regular file carrying lefthook's generated marker, the line
# `call_lefthook run "pre-commit"`, and NOT carrying code-review-graph's appended block
# (`>>> code-review-graph pre-commit hook >>>`) — that block's `|| true` tail becomes the
# hook's exit status, so the checks stop blocking commits. A marker without the executable bit
# is unarmed too.
#
# The lefthook binary is the project's own — $PROJECT_ROOT/node_modules/.bin/lefthook, run
# through `pnpm exec` — never one found on PATH. Without it the step exits 1 having executed
# no lefthook at all.
#
# A `pre-commit.old` already beside a hook lefthook does not manage is moved to
# `pre-commit.old.<YYYYmmddHHMMSS>` in the same directory first, because lefthook would
# otherwise fail on it or, under --force, overwrite it.
#
# --notice is the package.json `postinstall`: it reads only, writes only to stdout, and
# ALWAYS exits 0 with stderr empty — even on an unknown option, an unreachable checkout root
# or any git error. It prints one line naming `bash install.sh` when the hooks are unarmed in a
# git checkout (under core.hooksPath=/dev/null, the `git config --unset-all core.hooksPath`
# that re-enables them), and nothing when they are armed, when CI is set, when there is no
# repository, or when git is not on PATH. ANY non-empty CI silences it — `CI=false` included,
# since the variable's presence, not its value, is the convention this follows. It never runs
# lefthook, never writes a file, makes no network call and reads no credential.
#
# Writes only under the effective hook directory, plus lefthook's own
# .git/info/lefthook.checksum, which every `lefthook install` writes.
#
set -euo pipefail

# --notice is decided before anything that can fail: the postinstall must never be what
# fails an install, so from here on in that mode stderr is discarded and every exit is 0.
NOTICE=false
for arg in "$@"; do [[ "$arg" == "--notice" ]] && NOTICE=true; done
if $NOTICE; then
  exec 2>/dev/null
  set +e
  trap 'exit 0' EXIT
fi

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
                              hooks are unarmed. Silent when armed, when CI is set (any
                              non-empty value, CI=false included), with no git repository,
                              or with git absent. Always exits 0, whatever else is passed

Skips (exit 0) with no git repository, and arms nothing when core.hooksPath=/dev/null —
that setting is a deliberate opt-out. A custom core.hooksPath is armed with --force. Only
the project's own lefthook (node_modules) is ever run. An existing pre-commit.old beside a
hook lefthook does not manage is moved to pre-commit.old.<timestamp> first.

Exit codes:  0 = armed or skipped   1 = requirement missing   2 = install failed
             (root install.sh's contract, which runs this as its Phase 1 Step 9)
EOF
}

if ! $NOTICE; then
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h) usage; exit 0 ;;
      *)         die "Unknown option '$1'. Use --help for usage." ;;
    esac
  done
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 2
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)" || die "cannot resolve the checkout root"
cd "$PROJECT_ROOT" || die "cannot enter the checkout root $PROJECT_ROOT"

# The effective pre-commit hook, resolved from the checkout root. Fails when git cannot
# resolve it (core.hooksPath under a regular file, or /dev/null).
effective_hook() { git rev-parse --path-format=absolute --git-path hooks/pre-commit 2>/dev/null; }
has_marker() { grep -qF "$MARKER" "$1" 2>/dev/null; }
has_graph()  { grep -qF "$GRAPH_MARKER" "$1" 2>/dev/null; }
is_armed()   { [[ -f "$1" && -r "$1" && -x "$1" ]] && has_marker "$1" && ! has_graph "$1"; }
in_repo()    { git rev-parse --git-dir >/dev/null 2>&1; }

# ── --notice — the postinstall. Reads only; every path out is exit 0 ─────────────
if $NOTICE; then
  [[ -n "${CI:-}" ]] && exit 0
  command -v git >/dev/null 2>&1 || exit 0
  in_repo || exit 0
  if [[ "$(git config --get core.hooksPath 2>/dev/null)" == "/dev/null" ]]; then
    printf '  \033[33m⚠\033[0m  Git hooks are disabled by core.hooksPath=/dev/null — to arm them: git config --unset-all core.hooksPath && bash install.sh\n'
    exit 0
  fi
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
hook_dir="${hook%/*}"

command -v pnpm >/dev/null 2>&1 || { err "pnpm not found — it is required to run lefthook"; exit 1; }
# The project's binary or nothing: checked BEFORE any lefthook runs, so `pnpm exec` can never
# fall back to a lefthook on PATH (constraint 7.4).
lh_bin="$PROJECT_ROOT/node_modules/.bin/lefthook"
if [[ ! -f "$lh_bin" || ! -x "$lh_bin" ]]; then
  err "lefthook not found in node_modules — $lh_bin is missing; a lefthook on PATH is never used (run: bash code/src/scripts/development/install-frontend.sh --local)"
  exit 1
fi
if ! lh_version="$(pnpm exec lefthook version 2>/dev/null)" || [[ -z "$lh_version" ]]; then
  err "lefthook in node_modules does not run — $lh_bin (run: bash code/src/scripts/development/install-frontend.sh --local)"
  exit 1
fi

# The third-claimant report: classify what is there before anything changes it. A hook
# carrying lefthook's marker is rewritten in place by lefthook; anything else is renamed to
# pre-commit.old by lefthook, so only that case needs an existing .old moved aside.
state="absent"
if [[ -e "$hook" || -L "$hook" ]]; then
  if has_marker "$hook" && has_graph "$hook"; then state="graph-appended"
  elif is_armed "$hook";                   then state="armed"
  elif has_marker "$hook";                 then state="lefthook-unarmed"
  elif has_graph "$hook";                  then state="graph-raw"
  else                                          state="foreign"
  fi
fi

moved_old=""
if [[ "$state" == "graph-raw" || "$state" == "foreign" ]] && [[ -e "$hook_dir/pre-commit.old" || -L "$hook_dir/pre-commit.old" ]]; then
  stamp="$(date +%Y%m%d%H%M%S)"; moved_old="$hook_dir/pre-commit.old.$stamp"; n=1
  while [[ -e "$moved_old" || -L "$moved_old" ]]; do moved_old="$hook_dir/pre-commit.old.$stamp-$n"; n=$((n + 1)); done
  if ! mv -n -- "$hook_dir/pre-commit.old" "$moved_old" || [[ -e "$hook_dir/pre-commit.old" ]]; then
    die "cannot move the existing $hook_dir/pre-commit.old aside — nothing armed"
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

[[ -n "$moved_old" ]] && warn "Moved the existing pre-commit.old aside to ${moved_old##*/} (same directory), so nothing was overwritten"
case "$state" in
  absent)           ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  armed)            ok "Git hooks already armed — refreshed $hook (lefthook $lh_version)" ;;
  graph-appended)   warn "Removed the code-review-graph block appended to lefthook's hook at $hook — it made the hook's checks non-blocking"
                    ok "Git hooks re-armed → $hook (lefthook $lh_version)" ;;
  lefthook-unarmed) warn "Restored lefthook's non-executable hook at $hook in place"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  graph-raw)        warn "Replaced the raw code-review-graph hook at $hook (reclaimed; kept as pre-commit.old)"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  foreign)          warn "Replaced a hook lefthook does not manage at $hook (kept as pre-commit.old)"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
esac
