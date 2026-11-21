#!/usr/bin/env bash
# template-integrity.sh — The template-integrity hook legs: plain checks at commit, every
#                         self-test at push.
#
# TEMPLATE-ONLY: .github/scripts/ is copier _exclude'd, so a generated project never holds this
# file. lefthook.yml ships, and its two legs that call this script are self-gating on copier.yml
# (itself _exclude'd), so downstream they exit 0 before reaching it.
#
# --pre-commit is the cheap half of .github/workflows/audit-template.yml, pulled forward to the
# commit: the five detectors' PLAIN checks, and nothing else. No self-test runs at commit, so a
# probe committed red ahead of its fix (code workflow 02-tdd-cycle) is an ordinary commit — durable
# in history, and replayable. A staged .github/scripts/*.sh with unstaged changes beside it is
# refused, because the plain checks run from the working tree, which under a plain hook need not
# be what is committed (lefthook hides unstaged changes during pre-commit; a plain hook does not).
#
# --pre-push [REMOTE [URL]] reads git's pre-push lines on stdin (`<local ref> <local sha>
# <remote ref> <remote sha>`) and judges the commit each pushed ref points at — never the working
# tree: for each distinct tip (a deletion has none, and is skipped), every self-test in SELF_TESTS
# runs, in parallel, each in its own copy of that commit's tree. The push is refused when any
# exits non-zero; exit 2, a self-test that crashed or stopped early (self-test-ledger.sh's guard),
# is named as a script error and never read as a pass. A listed script the commit does not hold
# is named "absent at <sha> — skipped" (not run, never counted as a pass or a red) only when the
# commit is genuinely older than it: no commit in its history touched the script, and the commit
# is an ancestor of one that introduced it on the first-parent history of HEAD, main or
# origin/main. Any other lack — a deletion, an orphan tip, a squash or graft of a deleting tree,
# a tip forked before the script with commits of its own — is named "deleted at <sha>" and
# refuses the push: a red, never a skip, counted red but not run (21/11/2026). git here sees no
# replace objects, and a shallow repository, which has lost the history the decision reads, is
# refused outright (round 8). One it holds that exits 127 is a failure like any other. A push
# with no commit to judge (a deletion only, or no ref lines on stdin) says so and exits 0. CI runs
# the same nine self-tests on every push to any branch, unfiltered, in audit-template.yml
# (pm-boards.sh in [1/4] from 21/11/2026, beside pm-board.sh --check, the archive freeze).
# template-hooks.sh proves exactly this of the workflow's text: each listed step is present in a
# job named as a required [n/4] context, with no unquoted `if:` or `continue-on-error` on the step
# or its job, and the --check job has a `fetch-depth: 0` checkout. It does not detect a quoted
# key, a `shell:` or `defaults:` override, `needs:` on a skipped job, or a second, shallow
# checkout — a workflow diff is review's (21/11/2026, round 8). CI is the record; a hook is a
# convenience a developer can skip (`--no-verify`, core.hooksPath), never a gate. CI is a gate only
# where a ruleset requires it, and only main is protected: dev, staging and testing are not, so a
# red tip can reach them; and main's ruleset lets its bypass actor (the admin role, bypass mode
# "always") merge or push past the required checks AND force-push or delete main, so a red tip can
# reach main through that bypass too (21/11/2026). Nor does main yet require a branch to be up to
# date before it merges — strict required checks, with merges restricted to merge and rebase (a
# squash would fold an archive move into one commit and lock --check red), are pending the
# maintainer's ruleset change — so a merged result is not re-judged against the latest main.
# Two self-tests run in CI alone, needing toolchains or a generated project:
# check-template-parsers.sh's and shipped-artefacts.sh's.
#
# --self-tests [COMMIT] is the same judgement for one commit (default HEAD) — the reviewer's
# replay. A red probe's own commit exits 1 and its fix exits 0; the two review rules this
# replays are code/workflows/02-tdd-cycle/STEPS.md's. A commit genuinely older than a listed
# script reads that script absent and skipped, so the replay judges what the commit held; any
# other commit lacking one reads it red.
#
# THE COPY. `git archive <commit>` extracted into a `mktemp -d`, then checked: re-added under a
# fresh repository with every content attribute unset, its tree must be the commit's tree, byte
# for byte and mode for mode — so a local attribute (export-ignore, export-subst), a filter or a
# line-ending setting that changed the copy is refused, never judged. The copy is then committed
# (shipped-ai.py renders from it over git) with no hooks and no configuration, and every self-test
# runs with this repository's git environment stripped.
#
# GIT, READ HERE. Every git command this script runs in this repository runs with no system or
# global configuration, no caller `-c` options (GIT_CONFIG_PARAMETERS / GIT_CONFIG_COUNT), no
# external diff or pager, no replace objects (GIT_NO_REPLACE_OBJECTS), and the output-shaping
# keys pinned (colour, quoting, relative paths, renames, line endings, the attributes file): a
# repository's own .git/config cannot be switched off, and the copy's tree check is what stands
# against it.
#
# Usage: template-integrity.sh --pre-commit | --pre-push [REMOTE [URL]] | --self-tests [COMMIT]
#        | --help
#
# Requires: bash, git, tar; the self-tests' own needs (shipped-ai.sh: uvx with Copier cached).
# Exit codes: 0 = pass  1 = refused (a check or a self-test failed)  2 = script error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DETECTORS=(check-template-tokens.sh shipped-readme.sh shipped-memory.sh shipped-registers.sh
           shipped-boards.sh)
# Every self-test the push leg runs, from the root of the commit judged. Each also runs in CI.
SELF_TESTS=(
  ".github/scripts/check-template-tokens.sh --self-test"
  ".github/scripts/shipped-readme.sh --self-test"
  ".github/scripts/shipped-memory.sh --self-test"
  ".github/scripts/shipped-registers.sh --self-test"
  ".github/scripts/shipped-boards.sh --self-test"
  ".github/scripts/register-index-routes.sh --self-test"
  ".github/scripts/shipped-ai.sh --self-test"
  "code/src/scripts/tests/pm-boards.sh"
  "code/src/scripts/tests/template-hooks.sh"
)
ZERO_SHA_RE='^0+$'
SCRATCH=()

die() { printf 'template-integrity: %s\n' "$*" >&2; exit 2; }
refuse() { printf '\033[31m✗ template-integrity:\033[0m %s\n' "$*" >&2; exit 1; }
# shellcheck disable=SC2329  # invoked by the EXIT trap below
cleanup() { local d; for d in "${SCRATCH[@]}"; do rm -rf "$d"; done; }
trap cleanup EXIT
scratch() { # VAR — a fresh directory, removed on exit, its path in VAR
  local d; d="$(mktemp -d)" || die "could not create a temporary directory"
  SCRATCH+=("$d"); printf -v "$1" '%s' "$d"
}

# git in this repository, its output pinned (see GIT, READ HERE). GIT_INDEX_FILE and GIT_DIR are
# kept: a pre-commit hook must read the index git is committing.
g() {
  env -u GIT_CONFIG_PARAMETERS -u GIT_CONFIG_COUNT -u GIT_EXTERNAL_DIFF -u GIT_DIFF_OPTS \
    -u GIT_PAGER -u GIT_ATTR_SOURCE GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null \
    GIT_NO_REPLACE_OBJECTS=1 git --no-pager -c color.ui=false -c core.quotePath=true -c diff.relative=false \
      -c diff.noprefix=false -c diff.renames=false -c core.autocrlf=false -c core.eol=lf \
      -c core.attributesFile=/dev/null "$@"
}
# git, and anything run, in another tree: none of this repository's environment and no
# configuration.
in_tree() { # DIR CMD… — CMD in DIR, cut off from this repository
  local d="$1"; shift
  (cd "$d" && env -u GIT_INDEX_FILE -u GIT_DIR -u GIT_WORK_TREE -u GIT_PREFIX -u GIT_OBJECT_DIRECTORY \
    -u GIT_ALTERNATE_OBJECT_DIRECTORIES -u GIT_CONFIG_PARAMETERS -u GIT_CONFIG_COUNT \
    -u GIT_EXTERNAL_DIFF -u GIT_ATTR_SOURCE GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 "$@")
}

pre_commit() {
  cd "$PROJECT_ROOT"
  [[ -f copier.yml ]] || exit 0
  local d rc
  while IFS= read -r -d '' d; do
    [[ "$d" == .github/scripts/*.sh ]] || continue
    g diff --quiet --no-ext-diff --no-textconv -- "$d" \
      || refuse "$d is staged with unstaged changes beside it — the plain checks run from the working tree, so stage the whole file (or stash the rest)"
  done < <(g diff --cached --name-only --no-renames -z || die "could not read the staged set")
  for d in "${DETECTORS[@]}"; do
    rc=0
    bash ".github/scripts/$d" || rc=$?
    [[ $rc -eq 0 ]] || refuse "$d exited $rc"
  done
}

# copy_of SHA DIR — SHA's tree extracted into DIR, checked to be that tree, and committed.
copy_of() {
  local sha="$1" dir="$2" want got
  want="$(g rev-parse --verify -q "$sha^{tree}")" || die "no tree for $sha"
  g archive --format=tar "$sha" | tar -x -C "$dir" || die "could not extract $sha"
  in_tree "$dir" git init -q || die "could not initialise the copy of $sha"
  printf '* -text -eol -filter -ident -working-tree-encoding -export-ignore -export-subst\n' \
    > "$dir/.git/info/attributes"
  in_tree "$dir" git add -A -f || die "could not stage the copy of $sha"
  got="$(in_tree "$dir" git write-tree)" || die "could not read the copy of $sha"
  [[ "$got" == "$want" ]] \
    || refuse "the copy of ${sha:0:12} is not the tree that commit holds — a local attribute, filter or line-ending setting changed it (git archive), so it cannot be judged"
  rm -f "$dir/.git/info/attributes"
  in_tree "$dir" git -c user.name=template-integrity -c user.email=template-integrity@example.invalid \
    -c core.hooksPath=/dev/null commit -q --no-verify -m "copy of $sha" || die "could not commit the copy of $sha"
}

# never_held SHA PATH — SHA is genuinely older than PATH: no commit in its history touched PATH,
# and SHA is an ancestor of a commit that introduced PATH (holds it where its first parent does
# not) on the first-parent history of HEAD, main or origin/main. Anything else — an orphan, a
# squash or a graft of a deleting tree, a tip forked before the script with commits of its own —
# reads as deleted (round 8, 21/11/2026).
never_held() {
  local sha="$1" path="$2" ref c
  [[ -z "$(g rev-list -1 --full-history "$sha" -- "$path")" ]] || return 1
  for ref in HEAD refs/heads/main refs/remotes/origin/main; do
    g rev-parse -q --verify "$ref^{commit}" >/dev/null || continue
    while IFS= read -r c; do
      g cat-file -e "$c:$path" 2>/dev/null || continue
      ! g cat-file -e "$c^1:$path" 2>/dev/null || continue
      g merge-base --is-ancestor "$sha" "$c" && return 0
    done < <(g rev-list --first-parent "$ref" -- "$path")
  done
  return 1
}

# self_tests SHA — every self-test against SHA, each in its own copy, in parallel; refuses on any red.
self_tests() {
  local sha="$1" base i path dirs=() pids=() rc bad=() run=() absent=() deleted=() t0=$SECONDS
  # A shallow repository has lost the history that tells a deleted script from one never held, so
  # it judges nothing (round 8).
  [[ "$(g rev-parse --is-shallow-repository)" == false ]] \
    || refuse "this repository is shallow — the history that tells a deleted self-test from one never held is missing, so ${sha:0:12} cannot be judged (git fetch --unshallow, then push again)"
  scratch base
  mkdir "$base/copy"
  copy_of "$sha" "$base/copy"
  # A listed script the commit does not hold is skipped and named — never run and never counted
  # as a pass — only when the commit is genuinely older than it (never_held). Any other absence is
  # a deletion: a red, never a skip (round 7; the rewritten histories round 8), counted red but not
  # run. One it holds that exits 127 or crashes is a failure.
  for i in "${!SELF_TESTS[@]}"; do
    path="${SELF_TESTS[$i]%% *}"
    if [[ -f "$base/copy/$path" ]]; then
      run+=("$i")
    elif never_held "$sha" "$path"; then
      absent+=("$i")
    else
      deleted+=("$i")
    fi
  done
  for i in "${run[@]}"; do
    cp -a "$base/copy" "$base/$i" || die "could not copy the tree of $sha"
    dirs[i]="$base/$i"
  done
  printf '▸ %s: %d self-tests, each in a copy of the commit…\n' "${sha:0:12}" "${#run[@]}"
  for i in "${absent[@]}"; do
    printf '  \033[33m–\033[0m %s — absent at %s — skipped (not run, not a pass)\n' "${SELF_TESTS[$i]}" "${sha:0:12}"
  done
  for i in "${deleted[@]}"; do
    printf '  \033[31m✗\033[0m %s — deleted at %s (its history held it) — a red, never a skip\n' "${SELF_TESTS[$i]}" "${sha:0:12}"
    bad+=("$i")
  done
  for i in "${run[@]}"; do
    # shellcheck disable=SC2086  # each entry is a script and its flags, split on purpose
    in_tree "${dirs[$i]}" bash ${SELF_TESTS[$i]} > "$base/$i.out" 2>&1 &
    pids[i]="$!"
  done
  for i in "${run[@]}"; do
    rc=0; wait "${pids[$i]}" || rc=$?
    if [[ $rc -eq 0 ]]; then
      printf '  \033[32m✓\033[0m %s\n' "${SELF_TESTS[$i]}"
    else
      bad+=("$i")
      if [[ $rc -eq 2 ]]; then
        printf '  \033[31m✗\033[0m %s — exit 2, a script error (it crashed or stopped early), never a pass\n' "${SELF_TESTS[$i]}"
      else
        printf '  \033[31m✗\033[0m %s — exit %d\n' "${SELF_TESTS[$i]}" "$rc"
      fi
    fi
  done
  for i in "${bad[@]}"; do
    [[ -f "$base/$i.out" ]] || continue   # a deleted script ran nothing
    printf '\n── %s (last 20 lines) ──\n' "${SELF_TESTS[$i]}" >&2
    tail -n 20 "$base/$i.out" >&2
  done
  printf '  (%ds — %d run, %d red, %d absent and skipped)\n' "$((SECONDS - t0))" "${#run[@]}" "${#bad[@]}" "${#absent[@]}"
  [[ ${#bad[@]} -eq 0 ]] || refuse "${sha:0:12} has ${#bad[@]} red self-test(s) — fix them before this commit is pushed"
}

pre_push() {
  cd "$PROJECT_ROOT"
  [[ -f copier.yml ]] || exit 0
  local lref lsha rref rsha seen=" " sha
  local -a tips=()
  while read -r lref lsha rref rsha; do
    [[ -n "${lsha:-}" ]] || continue
    [[ ! "$lsha" =~ $ZERO_SHA_RE ]] || continue   # a deletion pushes no commit
    sha="$(g rev-parse --verify -q "$lsha^{commit}")" || die "the pushed $lref names no commit ($lsha)"
    [[ "$seen" == *" $sha "* ]] && continue
    seen+="$sha "; tips+=("$sha")
    : "$rref" "$rsha"
  done
  if [[ ${#tips[@]} -eq 0 ]]; then
    printf 'template-integrity: no pushed commit to judge (a deletion only, or no ref lines on stdin)\n'
    return 0
  fi
  for sha in "${tips[@]}"; do self_tests "$sha"; done
}

case "${1:-}" in
  --pre-commit) pre_commit ;;
  --pre-push) pre_push ;;
  --self-tests)
    cd "$PROJECT_ROOT"
    sha="$(g rev-parse --verify -q "${2:-HEAD}^{commit}")" || die "no commit ${2:-HEAD}"
    self_tests "$sha" ;;
  --help|-h) sed -n '2,73p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' ;;
  *) die "usage: template-integrity.sh --pre-commit | --pre-push [REMOTE [URL]] | --self-tests [COMMIT]" ;;
esac
