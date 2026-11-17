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
#   install-hooks.sh            Arm the hooks (node_modules/.bin/lefthook install, run directly)
#   install-hooks.sh --notice   Print a one-line reminder if the hooks are unarmed; exit 0
#   install-hooks.sh --help     Show this help
#
# Exit codes:  0 = success   1 = requirement missing   2 = install failed
#   0 — armed, or skipped (no git repository; a project nested in another repository;
#       core.hooksPath=/dev/null opt-out)
#   1 — git or the project's lefthook binary (node_modules) not found, or it does not run
#   2 — the repository is broken, bare or its core.worktree points elsewhere; core.hooksPath
#       is empty or unresolvable; the hooks directory lies outside the git common directory;
#       a hook cannot be moved aside; `lefthook install` failed or did not arm the hook (a
#       symlinked hook moved aside is put back first, or the command that restores it printed)
#
# These follow root install.sh's exit-code contract DELIBERATELY, not this folder's
# `1 = command failed, 2 = script error` (install-backend.sh, install-frontend.sh): this
# script exists to be a step of install.sh, which propagates its code unchanged. An
# unknown option is therefore also a 2 here (outside --notice, which never fails).
#
# "Armed" is one predicate, shared by both modes and by tests/hook-arming.sh: `pre-commit` in
# the hooks DIRECTORY `git rev-parse --path-format=absolute --git-path hooks` names (never the
# hook file resolved directly, which follows a symlink to its target) is a readable,
# executable regular file — not a symlink — in lefthook 2.2.2's GENERATED LAYOUT: line 1 is
# `#!/bin/sh`; `call_lefthook()` is defined and `LEFTHOOK` used on non-comment lines; and its
# last non-blank line is exactly `call_lefthook run "pre-commit" "$@"`, with nothing after it.
# Any appended tail — code-review-graph's block (`>>> code-review-graph pre-commit hook >>>`)
# or an arbitrary `|| true` — becomes the hook's exit status, so the checks stop blocking
# commits: unarmed. A hook without the executable bit is unarmed too. A symlinked hook is
# foreign: the link itself is moved aside, its target and the target's directory are never
# touched. lefthook overwrites in place any hook carrying the string LEFTHOOK, so lefthook's
# hook with a tail, and a foreign hook mentioning LEFTHOOK, are copied to pre-commit.old first.
#
# Which repository: the one whose root is this project's root, found from there with the GIT_*
# repository-location variables cleared — GIT_DIR, GIT_WORK_TREE, GIT_COMMON_DIR,
# GIT_INDEX_FILE, GIT_OBJECT_DIRECTORY and GIT_NAMESPACE. A project nested inside an unrelated
# repository (no .git of its own) skips, exit 0. A .git at the root that git cannot read — or
# that git climbs past to an outer repository — exits 2 with git's own error, as does a
# repository git itself reports as bare (`rev-parse --is-bare-repository`) or whose work tree
# (`rev-parse --show-toplevel`) is elsewhere — git's effective answers, never one config scope.
#
# Where: the hooks directory's REAL path must lie inside the repository's git common directory
# (`git rev-parse --git-common-dir`), checked for both what git resolves and what core.hooksPath
# names. Anything else is refused, exit 2, nothing written: a global, system, GIT_CONFIG,
# GIT_CONFIG_COUNT/PARAMETERS or included value, a symlinked .git/hooks, a local path outside
# the repository, and a working-tree path such as a tracked .githooks/ — so arming can never
# rewrite a machine-wide hook or a committed file. The remedy names where the setting came from.
# A redirected path inside the common directory is armed with --force.
#
# The lefthook binary is the project's own — $PROJECT_ROOT/node_modules/.bin/lefthook — and
# the binary checked is the binary executed: it is run DIRECTLY, never through `pnpm exec` and
# never found on PATH. `pnpm exec` first runs pnpm's verify-deps-before-run, which over a stale
# node_modules (a manifest or lockfile changed since the install) silently runs a full install,
# lifecycle scripts included, and rewrites the lockfile. Run directly, a stale node_modules is
# used as it is: the installed lefthook arms the hook and nothing is installed. The hook and
# lefthook.checksum it writes are byte-identical to what `pnpm exec lefthook install` writes in
# the same checkout (measured 17/11/2026, lefthook 2.2.2, both orders; the hook embeds the
# absolute path of the platform binary, so two checkouts differ). Without the binary the step
# exits 1 having executed no lefthook at all.
#
# A `pre-commit.old` already beside a hook lefthook does not manage is moved to
# `pre-commit.old.<YYYYmmddHHMMSS>` in the same directory first, because lefthook would
# otherwise fail on it or, under --force, overwrite it. A symlinked hook moved aside to
# pre-commit.old is moved back if `lefthook install` then fails or does not arm the hook; if it
# cannot be, the exact `mv` that restores it is printed.
#
# --notice is the package.json `postinstall`: it reads only, writes only to stdout, and
# ALWAYS exits 0 with stderr empty — even on an unknown option, an unreachable checkout root
# or any git error. It prints one line naming `bash install.sh` when the hooks are unarmed in a
# git checkout (under core.hooksPath=/dev/null, the `git config --<scope> --unset-all
# core.hooksPath` that re-enables them, in the scope the value came from — or, for a value from
# the environment, a GIT_CONFIG file or a file a scope includes, which no `git config --<scope>
# --unset-all` removes, that source in words), and nothing when they are armed, when CI is set,
# when there is no repository, or when git is not on PATH. ANY non-empty CI silences it —
# `CI=false` included, since the variable's presence, not its value, is the convention this
# follows. It never runs lefthook, never writes a file, makes no network call and reads no
# credential.
#
# Writes only under the effective hook directory, plus lefthook's own
# .git/info/lefthook.checksum, which every `lefthook install` writes. Never node_modules or the
# lockfile: no package manager is run.
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
  install-hooks.sh            Arm the effective pre-commit hook (the project's lefthook install)
  install-hooks.sh --notice   Read-only: print a reminder naming `bash install.sh` if the
                              hooks are unarmed. Silent when armed, when CI is set (any
                              non-empty value, CI=false included), with no git repository,
                              or with git absent. Always exits 0, whatever else is passed

Skips (exit 0) with no git repository or when nested inside another repository, and arms
nothing when core.hooksPath=/dev/null — that setting is a deliberate opt-out. The hooks
directory must lie inside this repository's git directory (its git common directory, .git);
one outside it — shared, machine-wide or in the working tree — is refused, and a redirected
one inside it is armed with --force. Only the project's own lefthook (node_modules) is ever
run, directly — never through pnpm, so a stale node_modules is never re-installed. A symlinked
hook is replaced as a link, and put back if lefthook then fails.
An existing pre-commit.old beside a hook lefthook does not manage is moved to
pre-commit.old.<timestamp> first.

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

# A caller's GIT_DIR or GIT_WORK_TREE would point every git call below at another repository,
# so the project's own checkout is always found from its root and nothing else.
unset GIT_DIR GIT_WORK_TREE GIT_COMMON_DIR GIT_INDEX_FILE GIT_OBJECT_DIRECTORY GIT_NAMESPACE

has_graph()    { grep -qF "$GRAPH_MARKER" "$1" 2>/dev/null; }
# lefthook 2.2.2's own ownership test (isLefthookFile): the case-sensitive string LEFTHOOK.
# A hook carrying it is overwritten in place with no pre-commit.old; one without it is renamed.
has_lefthook() { grep -qF 'LEFTHOOK' "$1" 2>/dev/null; }
# Lefthook's own hook is recognised by lefthook 2.2.2's GENERATED LAYOUT, never by substrings:
# line 1 is `#!/bin/sh`; `call_lefthook()` is defined and `LEFTHOOK` used on non-comment lines;
# and the last non-blank line is exactly `call_lefthook run "pre-commit" "$@"`. lefthook_body
# is the same without the last-line rule — lefthook's hook, possibly with a tail appended.
LAST_LINE='call_lefthook run "pre-commit" "$@"'
lefthook_body() {
  local code
  [[ "$(head -n 1 "$1" 2>/dev/null)" == '#!/bin/sh' ]] || return 1
  code="$(grep -vE '^[[:space:]]*#' "$1" 2>/dev/null)" || return 1
  grep -qF 'LEFTHOOK' <<< "$code" && grep -qE '^[[:space:]]*call_lefthook\(\)' <<< "$code" &&
    grep -qxF "$LAST_LINE" <<< "$code"
}
lefthook_layout() {
  lefthook_body "$1" && [[ "$(grep -v '^[[:space:]]*$' "$1" 2>/dev/null | tail -n 1)" == "$LAST_LINE" ]]
}
# A symlinked hook is foreign whatever it points at: git runs the target, which nothing here owns.
# Any tail after lefthook's last line — code-review-graph's block or an arbitrary `|| true` —
# becomes the hook's exit status, so the checks stop blocking commits: unarmed.
is_armed() {
  [[ -f "$1" && ! -L "$1" && -r "$1" && -x "$1" ]] && lefthook_layout "$1" && ! has_graph "$1"
}

# The real path of a directory or file that may not exist yet: the nearest existing ancestor
# with symlinks resolved, plus the components below it.
real_path() {
  local p="$1" rest="" base
  while [[ ! -e "$p" && "$p" == */* ]]; do rest="/${p##*/}$rest"; p="${p%/*}"; [[ -n "$p" ]] || p="/"; done
  if [[ -d "$p" ]]; then base="$(cd "$p" 2>/dev/null && pwd -P)" || return 1
  else base="$(cd "${p%/*}" 2>/dev/null && pwd -P)/${p##*/}" || return 1
  fi
  printf '%s%s\n' "${base%/}" "${rest:-}"
}

# repo_state → absent | nested | broken | bare | worktree-elsewhere | ok. Git cannot tell "no
# repository" from "a repository it cannot read" (a corrupt HEAD reads as not-a-repository, and
# inside another repository git climbs straight past it), so a .git entry at the project root is
# checked here, and git must have resolved THAT .git. The guard is git's own answer, never a
# directory test on .git: a `git worktree add` checkout has .git as a FILE.
repo_state="absent"; git_msg=""; repo_top=""
detect_repo() {
  local gd own="$PROJECT_ROOT/.git" want
  if [[ -e "$own" || -L "$own" ]]; then
    if ! git_msg="$(git rev-parse --git-dir 2>&1 >/dev/null)"; then repo_state="broken"; return; fi
    gd="$(git rev-parse --path-format=absolute --git-dir 2>/dev/null)" || gd=""
    if [[ -f "$own" ]]; then
      # A gitfile's value, with the trailing CR and whitespace git itself tolerates removed.
      want="$(sed -n 's/^gitdir: *//p' "$own" 2>/dev/null | head -1 | tr -d '\r' | sed 's/[[:space:]]*$//')"
      [[ "$want" == /* ]] || want="$PROJECT_ROOT/$want"
    else want="$own"
    fi
    if [[ -z "$gd" || ! "$gd" -ef "$want" ]]; then
      git_msg="$(git --git-dir="$own" rev-parse --git-dir 2>&1 >/dev/null)" || true
      git_msg="${git_msg:-fatal: invalid repository}"$'\n'"(this script's diagnosis: git resolved ${gd:-no git directory}, not $want, which $own names)"
      repo_state="broken"; return
    fi
    # git's EFFECTIVE answers, never a config value read across every scope: a core.bare or
    # core.worktree that only an unrelated scope sets does not change this repository.
    if [[ "$(git rev-parse --is-bare-repository 2>/dev/null)" == "true" ]]; then repo_state="bare"; return; fi
    repo_top="$(git rev-parse --show-toplevel 2>/dev/null)" || repo_top=""
    if [[ -n "$repo_top" && "$repo_top" -ef "$PROJECT_ROOT" ]]; then repo_state="ok"
    elif [[ -n "$repo_top" ]]; then repo_state="worktree-elsewhere"
    else
      git_msg="fatal: no work tree (this script's diagnosis: git rev-parse --show-toplevel failed for $PROJECT_ROOT)"
      repo_state="broken"
    fi
    return
  fi
  if git_msg="$(git rev-parse --git-dir 2>&1 >/dev/null)"; then
    repo_top="$(git rev-parse --show-toplevel 2>/dev/null)" || repo_top=""
    repo_state="nested"
  else
    repo_state="absent"
  fi
}

# A value from the command scope — GIT_CONFIG_COUNT / GIT_CONFIG_KEY_<n> / GIT_CONFIG_VALUE_<n>,
# GIT_CONFIG_PARAMETERS, or a GIT_CONFIG file — has no `git config --<scope>` that removes it, so
# its source is named in words. Origin is git's --show-origin field (`file:<path>` for a file).
command_scope_fix() {   # key origin
  if [[ "$2" == file:* ]]; then
    printf 'it comes from the GIT_CONFIG file %s — unset GIT_CONFIG or remove %s from that file' "${2#file:}" "$1"
  else
    printf 'it comes from the environment (GIT_CONFIG_COUNT / GIT_CONFIG_KEY_<n> or GIT_CONFIG_PARAMETERS) — unset those variables'
  fi
}

# A value git reports under a scope but that lives in a file that scope's config INCLUDES
# (include.path / includeIf): `git config --<scope> --unset-all` exits 5 and leaves it in force,
# so the included file is named in words. The value is the scope's own when its origin is the
# origin `--no-includes` reports for that scope; otherwise this prints and returns 0.
included_fix() {   # key scope origin
  local own=""
  [[ "$3" == file:* ]] || return 1
  own="$(git config --"$2" --no-includes --show-origin --get "$1" 2>/dev/null)" || own=""
  [[ "${own%%$'\t'*}" == "$3" ]] && return 1
  printf 'it comes from %s, included from your %s config — remove %s from that file' "${3#file:}" "$2" "$1"
}

# `git config --<scope> --unset-all <key>`, in the scope the effective value came from; for an
# included value or the command scope, the words above — never a command that would exit 5 or
# leave the value in force.
unset_in_scope() {
  local key="$1" line="" sc="" origin=""
  if line="$(git config --show-scope --show-origin --get "$key" 2>/dev/null)"; then
    sc="${line%%$'\t'*}"; origin="${line#*$'\t'}"; origin="${origin%%$'\t'*}"
  fi
  case "$sc" in
    local|worktree|global|system)
      included_fix "$key" "$sc" "$origin" || printf 'git config --%s --unset-all %s' "$sc" "$key" ;;
    command) command_scope_fix "$key" "$origin" ;;
    *) printf 'git config --local --unset-all %s' "$key" ;;
  esac
}

# The fix followed by the install: chained with && when it is a command, as a sentence when not.
fix_then_install() {   # key
  local f; f="$(unset_in_scope "$1")"
  if [[ "$f" == "git config "* ]]; then printf '%s && bash install.sh' "$f"
  else printf '%s, then run: bash install.sh' "$f"
  fi
}

# core.hooksPath: whether it is set, its value, scope and origin. Read through `git config`,
# which also sees GIT_CONFIG — a file `git rev-parse` ignores — so both are checked below.
# --show-scope is git 2.26+; older git asks the local and worktree scopes by name.
hp_set=false; hp_val=""; hp_scope=""; hp_origin=""
read_hooks_path() {
  local line rest
  if line="$(git config --show-scope --show-origin --get core.hooksPath 2>/dev/null)"; then
    hp_set=true; hp_scope="${line%%$'\t'*}"; rest="${line#*$'\t'}"
    hp_origin="${rest%%$'\t'*}"; hp_val="${rest#*$'\t'}"
  elif hp_val="$(git config --get core.hooksPath 2>/dev/null)"; then
    hp_set=true
    if git config --local --get core.hooksPath >/dev/null 2>&1; then hp_scope="local"
    elif git config --worktree --get core.hooksPath >/dev/null 2>&1; then hp_scope="worktree"
    else hp_scope="global or system"
    fi
  fi
}

# The hooks DIRECTORY, then /pre-commit appended. Resolving the hook FILE with
# --path-format=absolute follows a symlinked pre-commit to its target, which would make a link
# "the hook" and its target's directory "the hooks dir". A directory that cannot exist (an
# ancestor is a regular file) is unresolvable; one that is itself a file is left to lefthook,
# whose failure names the install.
hook_dir=""; hook=""; cfg_dir=""
resolve_hook() {
  local a v
  hook_dir="$(git rev-parse --path-format=absolute --git-path hooks 2>/dev/null)" || return 1
  [[ -n "$hook_dir" ]] || return 1
  if [[ ! -e "$hook_dir" ]]; then
    a="${hook_dir%/*}"
    while [[ -n "$a" && ! -e "$a" ]]; do a="${a%/*}"; done
    [[ -z "$a" || -d "$a" ]] || return 1
  fi
  hook="$hook_dir/pre-commit"
  cfg_dir=""
  if $hp_set; then   # what the config itself names, relative to the work tree root
    v="$(git config --type=path --get core.hooksPath 2>/dev/null)" || v="$hp_val"
    if [[ "$v" == /* ]]; then cfg_dir="$v"; else cfg_dir="$PROJECT_ROOT/$v"; fi
  fi
}

# The location rule: the hooks directory's REAL path must lie
# inside this repository's git common directory. That one rule refuses a global, system,
# GIT_CONFIG, GIT_CONFIG_COUNT/PARAMETERS or included value, a symlinked .git/hooks, and a
# local path outside the repository — and a working-tree path such as a tracked .githooks/, so
# arming can never rewrite a committed file. out_dir names the offending real path.
common_dir=""; out_dir=""; out_is_common=false
hooks_outside() {
  local c r p
  c="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || return 1
  common_dir="$(real_path "$c")" || common_dir="$c"
  out_is_common=false
  for p in "$hook_dir" "$cfg_dir"; do
    [[ -n "$p" ]] || continue
    r="$(real_path "$p")" || r="$p"
    case "$r" in
      "$common_dir"/*) ;;
      "$common_dir") out_dir="$r"; out_is_common=true; return 0 ;;   # the git dir itself
      *) out_dir="$r"; return 0 ;;
    esac
  done
  return 1
}

# The default hooks directory as written, symlinks NOT resolved — what a symlinked .git/hooks
# looks like before --path-format=absolute follows it.
lexical_hooks() {
  local c
  c="$(git rev-parse --git-common-dir 2>/dev/null)" || return 1
  [[ "$c" == /* ]] || c="$PROJECT_ROOT/$c"
  printf '%s/hooks\n' "${c%/}"
}

# The remedy, chosen by where the effective core.hooksPath came from (its scope and origin)
# and by nothing else in the environment. Claims a core.hooksPath source only when one is set.
# Never the literal relative `.git/hooks`: from a linked worktree that names the worktree's own
# .git FILE. Local and worktree values may be multi-valued, hence --unset-all.
remedy() {
  local lex
  if ! $hp_set; then
    lex="$(lexical_hooks)" || lex=""
    if [[ -n "$lex" && -L "$lex" ]]; then
      printf '%s is a symlink to %s — replace the symlink with a real directory: rm %s && mkdir %s' "$lex" "$out_dir" "$lex" "$lex"
    else
      printf 'the hooks directory %s resolves to %s — replace any symlink on that path with a real directory' "$hook_dir" "$out_dir"
    fi
    return
  fi
  # An included file (include.path / includeIf), in any file scope: named in words, once.
  case "$hp_scope" in
    local|worktree|global|system) included_fix core.hooksPath "$hp_scope" "$hp_origin" && return ;;
  esac
  case "$hp_scope" in
    global) printf 'remove the global setting: git config --global --unset-all core.hooksPath' ;;
    system) printf 'remove the system setting: git config --system --unset-all core.hooksPath' ;;
    command) command_scope_fix core.hooksPath "$hp_origin" ;;
    local|worktree)
      printf 'point it at a directory inside the repository: git config --%s --unset-all core.hooksPath && git config --%s core.hooksPath %s/hooks (or just the --unset-all)' \
        "$hp_scope" "$hp_scope" "$common_dir" ;;
    *) printf 'remove it where it is set, or: git config --local --unset-all core.hooksPath && git config --local core.hooksPath %s/hooks' "$common_dir" ;;
  esac
}

# Where the refused setting came from, for the refusal line — only when one is set.
hp_source() { $hp_set && printf ' (core.hooksPath from %s config)' "${hp_scope:-unknown}"; return 0; }

# ── --notice — the postinstall. Reads only; every path out is exit 0 ─────────────
say() { printf '  \033[33m⚠\033[0m  %s\n' "$*"; }   # stdout: the notice's only channel
if $NOTICE; then
  [[ -n "${CI:-}" ]] && exit 0
  command -v git >/dev/null 2>&1 || exit 0
  detect_repo
  case "$repo_state" in
    absent|nested) exit 0 ;;
    broken) say "This checkout's git repository cannot be read, so its hooks cannot be checked — run: bash install.sh to see git's error"
            exit 0 ;;
    bare) say "This checkout's repository has core.bare=true, so no hook can be armed — fix it: $(fix_then_install core.bare)"
          exit 0 ;;
    worktree-elsewhere) say "This checkout's core.worktree points elsewhere (${repo_top:-unknown}), so no hook can be armed — fix it: $(fix_then_install core.worktree)"
          exit 0 ;;
  esac
  read_hooks_path
  if $hp_set; then
    if [[ "$hp_val" == "/dev/null" ]]; then
      say "Git hooks are disabled by core.hooksPath=/dev/null — to arm them: $(fix_then_install core.hooksPath)"
      exit 0
    elif [[ -z "$hp_val" ]]; then
      say "core.hooksPath is set but empty, so no hook can run — fix it: $(fix_then_install core.hooksPath)"
      exit 0
    fi
  fi
  if ! resolve_hook; then
    if $hp_set; then
      say "Git hooks cannot be resolved from core.hooksPath=$hp_val — fix it (or $(unset_in_scope core.hooksPath)), then run: bash install.sh"
    else
      say "Git hooks cannot be resolved in this checkout — run: bash install.sh"
    fi
    exit 0
  fi
  if hooks_outside; then
    if $out_is_common; then
      say "Git hooks are not armed: the hooks directory$(hp_source) is the git directory $common_dir itself; it must be a subdirectory of it — $(remedy), then run: bash install.sh"
    else
      say "Git hooks are not armed: the hooks directory $out_dir$(hp_source) is outside this repository's git directory $common_dir — $(remedy), then run: bash install.sh"
    fi
    exit 0
  fi
  is_armed "$hook" && exit 0
  say "Git hooks are not armed in this checkout — run: bash install.sh"
  exit 0
fi

# ── Arming ────────────────────────────────────────────────────────────────────
command -v git >/dev/null 2>&1 || { err "git not found — it is required to arm the hooks"; exit 1; }

detect_repo
case "$repo_state" in
  absent)
    warn "Skipped git hook installation — $PROJECT_ROOT is not inside a git repository"
    exit 0 ;;
  nested)
    warn "Skipped git hook installation — $PROJECT_ROOT is not the root of the git repository it sits in (${repo_top:-unknown}); a nested project arms nothing"
    exit 0 ;;
  broken)
    [[ -n "$git_msg" ]] && printf '%s\n' "$git_msg" | sed 's/^/    /' >&2
    err "the git repository at $PROJECT_ROOT is broken or cannot be read — git said: $(printf '%s' "$git_msg" | grep -m1 -E 'fatal|error' || printf '%s' "$git_msg" | head -1)"
    exit 2 ;;
  bare)
    err "core.bare=true in the repository at $PROJECT_ROOT — a bare repository has no work tree to arm; nothing armed (fix: $(unset_in_scope core.bare))"
    exit 2 ;;
  worktree-elsewhere)
    err "core.worktree points the work tree at ${repo_top:-another directory}, not $PROJECT_ROOT — nothing armed (fix: $(unset_in_scope core.worktree))"
    exit 2 ;;
esac

read_hooks_path
if $hp_set; then
  if [[ "$hp_val" == "/dev/null" ]]; then
    warn "Git hooks are disabled by core.hooksPath=/dev/null — nothing armed. To arm them:"
    warn "  $(fix_then_install core.hooksPath)"
    exit 0
  fi
  [[ -n "$hp_val" ]] ||
    die "core.hooksPath is set but empty ($hp_scope config) — no hook can run. Fix it: $(unset_in_scope core.hooksPath)"
fi

if ! resolve_hook; then
  if $hp_set; then die "cannot resolve the hooks directory from core.hooksPath=$hp_val — nothing armed"; fi
  die "cannot resolve the hooks directory — nothing armed"
fi

if hooks_outside; then
  if $out_is_common; then
    err "the hooks directory$(hp_source) is the git directory $common_dir itself — it must be a subdirectory of $common_dir; nothing armed"
  else
    err "the hooks directory $out_dir$(hp_source) is outside this repository's git directory $common_dir — refusing to arm a hooks directory beyond this repository; nothing armed"
  fi
  err "  $(remedy)"
  exit 2
fi

# The project's binary or nothing, checked BEFORE any lefthook runs and then executed itself —
# never resolved through PATH, and never through `pnpm exec`, whose dependency check can run an
# install over a stale node_modules (header).
lh_bin="$PROJECT_ROOT/node_modules/.bin/lefthook"
if [[ ! -f "$lh_bin" || ! -x "$lh_bin" ]]; then
  err "lefthook not found in node_modules — $lh_bin is missing; a lefthook on PATH is never used (run: bash code/src/scripts/development/install-frontend.sh --local)"
  exit 1
fi
if ! lh_version="$("$lh_bin" version 2>/dev/null)" || [[ -z "$lh_version" ]]; then
  err "lefthook in node_modules does not run — $lh_bin (run: bash code/src/scripts/development/install-frontend.sh --local)"
  exit 1
fi

# The third-claimant report: classify what is there before anything changes it. lefthook
# itself overwrites IN PLACE any hook carrying the string LEFTHOOK (its isLefthookFile) and
# renames any other to pre-commit.old. So: lefthook's own generated hook, merely
# non-executable, is rewritten with nothing to keep; lefthook's hook with a tail appended, and a
# foreign hook that merely mentions LEFTHOOK (even only in a comment), are COPIED to
# pre-commit.old first, because lefthook would keep nothing; anything else lefthook renames. A
# symlink is moved aside HERE, as a link, so lefthook never writes through it into its target.
state="absent"
if [[ -L "$hook" ]]; then                                  state="symlink"
elif [[ -e "$hook" ]]; then
  if lefthook_body "$hook" && has_graph "$hook";  then state="graph-appended"
  elif is_armed "$hook";                          then state="armed"
  elif lefthook_layout "$hook";                   then state="lefthook-unarmed"
  elif lefthook_body "$hook";                     then state="tail-appended"
  elif has_lefthook "$hook";                      then state="claims-lefthook"
  elif has_graph "$hook";                         then state="graph-raw"
  else                                                 state="foreign"
  fi
fi

# An existing pre-commit.old in the hooks dir — never beside a symlink's target — is moved to
# a timestamped name first, and reported at once, so the report survives a later failure.
case "$state" in
  symlink|graph-appended|tail-appended|claims-lefthook|graph-raw|foreign)
    if [[ -e "$hook_dir/pre-commit.old" || -L "$hook_dir/pre-commit.old" ]]; then
      stamp="$(date +%Y%m%d%H%M%S)"; moved_old="$hook_dir/pre-commit.old.$stamp"; n=1
      while [[ -e "$moved_old" || -L "$moved_old" ]]; do moved_old="$hook_dir/pre-commit.old.$stamp-$n"; n=$((n + 1)); done
      if ! mv -n -- "$hook_dir/pre-commit.old" "$moved_old" || [[ -e "$hook_dir/pre-commit.old" || -L "$hook_dir/pre-commit.old" ]]; then
        die "cannot move the existing $hook_dir/pre-commit.old aside — nothing armed"
      fi
      warn "Moved the existing pre-commit.old aside to ${moved_old##*/} (same directory), so nothing is overwritten"
    fi ;;
esac

link_moved=false
if [[ "$state" == "symlink" ]]; then
  if ! mv -n -- "$hook" "$hook_dir/pre-commit.old" || [[ -e "$hook" || -L "$hook" ]]; then
    die "cannot move the symlinked hook $hook aside — nothing armed"
  fi
  link_moved=true
fi

# On a failure after the symlinked hook was moved aside, put the link back — mv -n, so nothing
# lefthook wrote is overwritten — or, where it cannot go back, print the command that restores it.
restore_link() {
  $link_moved || return 0
  local old="$hook_dir/pre-commit.old"
  if [[ -L "$old" && ! -e "$hook" && ! -L "$hook" ]] && mv -n -- "$old" "$hook" && [[ -L "$hook" && ! -L "$old" ]]; then
    warn "Restored your symlinked hook at $hook — nothing armed"
  else
    warn "Your symlinked hook was moved to $old and could not be put back. Restore it with:"
    warn "  mv -f -- $(printf '%q' "$old") $(printf '%q' "$hook")"
  fi
}

if [[ "$state" == "graph-appended" || "$state" == "tail-appended" || "$state" == "claims-lefthook" ]]; then
  # lefthook would overwrite it in place, keeping nothing: keep a copy first.
  cp -p -- "$hook" "$hook_dir/pre-commit.old" || die "cannot copy the existing hook $hook aside — nothing armed"
fi

# lefthook 2.2 refuses a custom core.hooksPath unless forced; force only when one is set (and
# by now it lies inside the git common directory).
args=(install)
$hp_set && args+=(--force)

if ! output="$("$lh_bin" "${args[@]}" 2>&1)"; then
  [[ -n "$output" ]] && printf '%s\n' "$output" | sed 's/^/    /' >&2
  err "lefthook install failed — the pre-commit hook at $hook is not armed"
  restore_link
  exit 2
fi

# Verify the hook git will actually run, not the one lefthook says it wrote.
if ! is_armed "$hook"; then
  [[ -n "$output" ]] && printf '%s\n' "$output" | sed 's/^/    /' >&2
  err "lefthook install did not arm the effective pre-commit hook at $hook"
  restore_link
  exit 2
fi

case "$state" in
  absent)           ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  armed)            ok "Git hooks already armed — refreshed $hook (lefthook $lh_version)" ;;
  graph-appended)   warn "Removed the code-review-graph block appended to lefthook's hook at $hook — it made the hook's checks non-blocking; the hook as it was is kept as pre-commit.old"
                    ok "Git hooks re-armed → $hook (lefthook $lh_version)" ;;
  tail-appended)    warn "Removed a tail appended after lefthook's last line at $hook — it made the hook's checks non-blocking; the hook as it was is kept as pre-commit.old"
                    ok "Git hooks re-armed → $hook (lefthook $lh_version)" ;;
  lefthook-unarmed) warn "Restored lefthook's non-executable hook at $hook in place"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  claims-lefthook)  warn "Replaced a hook lefthook does not manage at $hook — it mentions LEFTHOOK, which lefthook takes as its own and overwrites in place; a copy was kept as pre-commit.old"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  symlink)          warn "Replaced a symlinked hook at $hook — the link itself, kept as pre-commit.old; its target was not touched"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  graph-raw)        warn "Replaced the raw code-review-graph hook at $hook (reclaimed; kept as pre-commit.old)"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
  foreign)          warn "Replaced a hook lefthook does not manage at $hook (kept as pre-commit.old)"
                    ok "Git hooks armed → $hook (lefthook $lh_version)" ;;
esac
