#!/usr/bin/env bash
# template-integrity.sh — The template-integrity pre-commit leg and its planned-red allowance.
#
# TEMPLATE-ONLY: .github/scripts/ is copier _exclude'd, so a generated project never holds this
# file. lefthook.yml ships, and its two legs that call this script are self-gating on copier.yml
# (itself _exclude'd), so downstream they exit 0 before reaching it.
#
# --pre-commit is the cheap half of .github/workflows/audit-template.yml, pulled forward to the
# commit: the five detectors' plain checks, preceded by their --self-tests whenever a
# .github/scripts/*.sh is staged. Every result must be a pass — bar the probes named in advance.
# When the allowance itself is staged — this script, self-test-ledger.sh, lefthook.yml, or its
# proof code/src/scripts/tests/planned-red.sh — that proof runs first (about a minute), because
# no detector's self-test exercises the allowance and a weakened one would otherwise pass.
#
# THE PLANNED-RED ALLOWANCE. A probe is committed red ahead of the check it proves (code
# workflow 02-tdd-cycle). When the probe lives in a detector's own --self-test, the self-test leg
# would refuse that commit, so the red could never be recorded. The allowance names the probes:
#
#   PLANNED_RED=<detector>::<probe label>[::<probe label>…]
#
#   <detector> is ONE of the five self-tested detectors by its basename in .github/scripts/, and
#   it must be staged — the probes being committed live in it. Each <probe label> is a probe's
#   name exactly as the detector records it in its self-test ledger (.github/scripts/
#   self-test-ledger.sh), and at least one is required.
#
#   The named detector's --self-test runs with a ledger and must exit 1, finish (its end line
#   written — a self-test that stops early is a crash, and the detectors' crash guard exits 2),
#   and fail EXACTLY the named probes, each NEW: absent from the ledger of HEAD's version of the
#   detector, run in a `git archive HEAD` copy. And a planned red may only ADD probes:
#     a. every probe label in HEAD's ledger appears in the staged ledger as a pass — none renamed,
#        removed or turned red;
#     b. the staged detector's diff against HEAD changes and deletes no line, and every line it
#        adds sits inside its self_test() region (from `self_test() {` to the first `}` alone on
#        a line), so no check a plain run executes can change in a planned-red commit;
#     c. the end line's failure count equals the fail lines recorded, so a failure counted
#        without being recorded is refused.
#   Every other self-test, and every plain check including the named detector's own, still runs
#   and must pass.
#
#   On acceptance --pre-commit writes a one-shot token under `git rev-parse --git-path`, holding
#   the opt-in and the staged tree (`git write-tree`). --commit-msg requires exactly one
#   `Planned-Red: <the opt-in, verbatim>` trailer, requires the token for the current staged tree,
#   and consumes it whatever it decides. So a trailer on a path that never ran this pre-commit leg
#   — a merge, a bare commit-msg run — has no token and is refused, a merge commit is refused the
#   trailer outright, and a trailer without the opt-in is refused too: the history records each
#   planned red the hook saw and no other. An amend sees nothing staged against the commit it
#   amends and is refused; to change a planned-red commit, `git reset --soft HEAD^` and commit it
#   again with the opt-in.
#
#   THE PROOF ITSELF. Staging the proof runs it, so a red probe committed ahead of its fix in the
#   proof would be refused like any other. PLANNED_RED=planned-red.sh::<probe label>… names the
#   proof's new red probes instead, judged from its own ledger (PROOF_LEDGER) by the same rules,
#   with (b) read over the whole file: the proof's diff adds lines and changes or deletes none.
#   The allowance's own files (this script, self-test-ledger.sh, lefthook.yml) may not be staged
#   with it.
#
# There is no other bypass, and the allowance is not one: it changes which probes one self-test
# may fail, never whether it runs.
#
# Usage: template-integrity.sh --pre-commit | --commit-msg FILE | --help
#
# Requires: bash, git, tar.
# Exit codes: 0 = pass  1 = refused (a check failed, or the allowance was misused)
#             2 = script error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DETECTORS=(check-template-tokens.sh shipped-readme.sh shipped-memory.sh shipped-registers.sh
           shipped-boards.sh)
PLANNED="${PLANNED_RED:-}"
TOKEN_NAME="planned-red-token"
PROOF="code/src/scripts/tests/planned-red.sh"
PROOF_NAME="planned-red.sh"
PL_DET=""
PL_LABELS=()
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

is_detector() {
  local d
  for d in "${DETECTORS[@]}"; do [[ "$1" == "$d" ]] && return 0; done
  return 1
}

# PLANNED_RED=<detector>::<label>[::<label>…] → PL_DET and PL_LABELS.
parse_planned() {
  local rest
  PL_DET="${PLANNED%%::*}"
  PL_LABELS=()
  [[ "$PLANNED" == *::* ]] || return 0
  rest="${PLANNED#*::}::"
  while [[ -n "$rest" ]]; do
    PL_LABELS+=("${rest%%::*}")
    rest="${rest#*::}"
  done
}

# HEAD's tree, once per run: a `git archive HEAD` copy with its own index and one commit (the
# proof's real fixture archives HEAD), no hooks and no configuration. Path in HEAD_TREE.
HEAD_TREE=""
# git, and anything run, in another tree: none of the hook's own repository environment
# (GIT_INDEX_FILE, which `git commit` exports to its hooks, and GIT_CONFIG_PARAMETERS, which carries
# a caller's `-c` options — a hooks path among them — into every child git) and no configuration.
in_tree() { # DIR CMD… — CMD in DIR, cut off from this repository
  local d="$1"; shift
  (cd "$d" && env -u GIT_INDEX_FILE -u GIT_DIR -u GIT_WORK_TREE -u GIT_PREFIX -u GIT_OBJECT_DIRECTORY \
    -u GIT_CONFIG_PARAMETERS -u GIT_CONFIG_COUNT \
    GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 "$@")
}
head_tree() {
  [[ -z "$HEAD_TREE" ]] || return 0
  local t; scratch t
  git archive HEAD | tar -x -C "$t" || return 1
  in_tree "$t" git init -q && in_tree "$t" git add -A \
    && in_tree "$t" git -c user.name=head -c user.email=head@example.invalid commit -q -m head || return 1
  HEAD_TREE="$t"
}

target_path() { # NAME — the judged script's path from the root
  if [[ "$1" == "$PROOF_NAME" ]]; then printf '%s' "$PROOF"; else printf '.github/scripts/%s' "$1"; fi
}

# run_probes NAME LEDGER DIR — the named script's probes, run in DIR with a ledger; prints nothing,
# returns the script's exit code. A detector runs --self-test under SELF_TEST_LEDGER; the proof runs
# under PROOF_LEDGER, with SELF_TEST_LEDGER cleared so its fixtures' detectors never write to it.
run_probes() {
  local n="$1" l="$2" dir="$3" rc=0
  local run=(env); [[ "$dir" == . ]] || run=(in_tree "$dir" env)
  if [[ "$n" == "$PROOF_NAME" ]]; then
    "${run[@]}" -u SELF_TEST_LEDGER PROOF_LEDGER="$l" PLANNED_RED='' bash "$PROOF" || rc=$?
  else
    "${run[@]}" -u PROOF_LEDGER SELF_TEST_LEDGER="$l" PLANNED_RED='' bash ".github/scripts/$n" --self-test || rc=$?
  fi
  return "$rc"
}

# head_ledger NAME OUT — HEAD's version of the named script run with a ledger, into OUT. Returns 3
# when HEAD holds no such script, 1 when HEAD's run leaves no finished ledger (then nothing can be
# shown new against it).
head_ledger() {
  local n="$1" out="$2" rc=0
  : > "$out"
  git rev-parse --verify -q HEAD >/dev/null || return 3
  git cat-file -e "HEAD:$(target_path "$n")" 2>/dev/null || return 3
  head_tree || return 1
  run_probes "$n" "$out" "$HEAD_TREE" >/dev/null 2>&1 || rc=$?
  [[ $rc -le 1 && -s "$out" ]] && [[ "$(tail -n 1 "$out" | cut -f1)" == end ]] || return 1
}

labels_of() { awk -F'\t' '$1 == "pass" || $1 == "fail" { print $2 }' "$1"; }

# diff_shape NAME — how the staged script differs from HEAD: `changed` when a line is changed or
# deleted, `outside` when a line is added outside the detector's self_test() region (from its
# `self_test() {` line to the first `}` alone on a line after it, in the staged copy), `noregion`
# when a detector has no such region, nothing when every change is an added line inside it. The
# proof has no region: any added line is inside.
diff_shape() {
  local n="$1" path lo=1 hi=999999999 bounds
  path="$(target_path "$n")"
  if [[ "$n" != "$PROOF_NAME" ]]; then
    bounds="$(git show ":$path" | awk '!s && /^self_test\(\) \{/ { s = NR; next } s && !e && /^}$/ { e = NR } END { print s + 0, e + 0 }')"
    lo="${bounds% *}"; hi="${bounds#* }"
    if [[ "$lo" -eq 0 || "$hi" -eq 0 ]]; then echo noregion; return 0; fi
    lo=$((lo + 1)); hi=$((hi - 1))
  fi
  git diff --cached -U0 HEAD -- "$path" | awk -v lo="$lo" -v hi="$hi" '
    /^@@/ { h = 1; match($0, /\+[0-9]+/); n = substr($0, RSTART + 1, RLENGTH - 1) + 0; next }
    !h || /^\\/ { next }
    /^-/ { print "changed"; exit }
    /^\+/ { if (n < lo || n > hi) { print "outside"; exit } n++ }'
}

# judge_planned NAME — the named script's probes, judged against the opt-in.
judge_planned() {
  local d="$1" dir ledger rc=0 fails want l n_fail n_end what="self-test"
  scratch dir; ledger="$dir/ledger"
  [[ "$d" != "$PROOF_NAME" ]] || what="proof"
  if [[ "$d" == "$PROOF_NAME" ]]; then
    run_probes "$d" "$ledger" . || rc=$?
  else
    SELF_TEST_LEDGER="$ledger" bash ".github/scripts/$d" --self-test || rc=$?
  fi
  case "$rc" in
    1) ;;
    0) refuse "PLANNED_RED=$PLANNED but $d's $what passed — nothing is red, so nothing is planned" ;;
    *) refuse "PLANNED_RED=$PLANNED but $d's $what exited $rc — a script error is not a planned red" ;;
  esac
  [[ -f "$ledger" && "$(tail -n 1 "$ledger" | cut -f1)" == end ]] \
    || refuse "$d's $what exited 1 but recorded no finished ledger — it stopped early, and a crash is not a planned red"
  fails="$(awk -F'\t' '$1 == "fail" { print $2 }' "$ledger" | LC_ALL=C sort -u)"
  want="$(printf '%s\n' "${PL_LABELS[@]}" | LC_ALL=C sort -u)"
  [[ "$fails" == "$want" ]] || refuse "PLANNED_RED names [$(paste -sd'|' <<< "$want")] but $d's red probes are [$(paste -sd'|' <<< "$fails")] — exactly the named probes may fail, and every other must pass"
  rc=0; head_ledger "$d" "$dir/head-ledger" || rc=$?
  if [[ $rc -ne 0 ]]; then
    [[ $rc -eq 3 && "$d" != "$PROOF_NAME" ]] \
      || refuse "HEAD's $d records no finished ledger, so the named probes cannot be shown to be new"
  fi
  labels_of "$dir/head-ledger" > "$dir/head-labels"
  for l in "${PL_LABELS[@]}"; do
    if grep -qxF -- "$l" "$dir/head-labels"; then
      refuse "the probe '$l' already exists at HEAD — only a probe new in this commit may be planned red; an old probe gone red is a broken detector"
    fi
  done
  # A planned red may only ADD probes: every probe HEAD's version runs runs again and passes, the
  # end line's failure count is the fail lines recorded, and the diff against HEAD adds lines and
  # changes or deletes none — for a detector, every added line inside its self_test() region, so
  # no check a plain run executes can change in a planned-red commit.
  n_fail="$(awk -F'\t' '$1 == "fail"' "$ledger" | wc -l | tr -d ' ')"
  n_end="$(tail -n 1 "$ledger" | cut -f2)"
  [[ "$n_end" == "$n_fail" ]] \
    || refuse "$d's ledger ends with $n_end failure(s) but records $n_fail fail line(s) — a failure counted without being recorded is not a planned red"
  while IFS= read -r l; do
    [[ -n "$l" ]] || continue
    awk -F'\t' -v l="$l" '$1 == "pass" && $2 == l { found = 1 } END { exit !found }' "$ledger" \
      || refuse "the probe '$l' runs at HEAD but is not a pass in the staged $d — a planned red may only add probes, never rename, remove or break one"
  done < "$dir/head-labels"
  case "$(diff_shape "$d")" in
    changed) if [[ "$d" == "$PROOF_NAME" ]]; then
               refuse "the staged $d changes or deletes lines against HEAD — a planned red of the proof adds probes and changes nothing else"
             fi
             refuse "the staged $d changes or deletes a line against HEAD — a planned red only adds probes, inside self_test()" ;;
    outside) refuse "the staged $d adds a line outside self_test() — a planned red only adds probes there, so no check can change with it" ;;
    noregion) refuse "the staged $d has no self_test() { … } region to hold a planned red's probes" ;;
  esac
  printf '\033[33m▸ planned red — %s: %s (new, and the only red probes), as PLANNED_RED declares\033[0m\n' \
    "$d" "$(paste -sd'|' <<< "$want" | sed 's/|/, /g')"
}

head_has_trailer() {
  git rev-parse --verify -q HEAD >/dev/null \
    && git log -1 --format=%B HEAD | git interpret-trailers --parse | grep -qi '^Planned-Red:'
}

pre_commit() {
  cd "$PROJECT_ROOT"
  [[ -f copier.yml ]] || exit 0
  local staged d rc token
  token="$(git rev-parse --git-path "$TOKEN_NAME")" || die "could not resolve the git directory"
  rm -f "$token"
  staged="$(git diff --cached --name-only)" || die "could not read the staged set"
  if [[ -n "$PLANNED" ]]; then
    parse_planned
    [[ "$PL_DET" == "$PROOF_NAME" ]] || is_detector "$PL_DET" \
      || refuse "PLANNED_RED=$PLANNED names no self-tested detector (one of: ${DETECTORS[*]}), nor the proof $PROOF_NAME"
    [[ ${#PL_LABELS[@]} -gt 0 ]] \
      || refuse "PLANNED_RED=$PLANNED names no probe — write it <detector>::<probe label>[::<probe label>…]"
    for d in "${PL_LABELS[@]}"; do [[ -n "$d" ]] || refuse "PLANNED_RED=$PLANNED names an empty probe label"; done
    if ! grep -qxF "$(target_path "$PL_DET")" <<< "$staged"; then
      head_has_trailer \
        && refuse "PLANNED_RED=$PLANNED but $PL_DET is not staged — an amend sees nothing staged against the commit it amends; to change a planned-red commit, git reset --soft HEAD^ and commit it again with the opt-in"
      refuse "PLANNED_RED=$PLANNED but $PL_DET is not staged — a planned red commits a probe in that detector"
    fi
    if [[ "$PL_DET" == "$PROOF_NAME" ]] \
       && grep -qxE '\.github/scripts/(template-integrity|self-test-ledger)\.sh|lefthook\.yml' <<< "$staged"; then
      refuse "PLANNED_RED=$PLANNED but the allowance itself is staged — the proof is never red in the commit that changes what it proves"
    fi
  fi
  if grep -qxE '\.github/scripts/(template-integrity|self-test-ledger)\.sh|lefthook\.yml|code/src/scripts/tests/planned-red\.sh' <<< "$staged"; then
    [[ -f "$PROOF" ]] || refuse "the allowance is staged but its proof $PROOF is missing"
    if [[ -n "$PLANNED" && "$PL_DET" == "$PROOF_NAME" ]]; then
      judge_planned "$PROOF_NAME"
    else
      rc=0
      env -u PROOF_LEDGER -u SELF_TEST_LEDGER bash "$PROOF" || rc=$?
      [[ $rc -eq 0 ]] || refuse "the planned-red allowance is staged and its proof $PROOF exited $rc"
    fi
  fi
  if grep -q '^\.github/scripts/.*\.sh$' <<< "$staged"; then
    for d in "${DETECTORS[@]}"; do
      if [[ -n "$PLANNED" && "$d" == "$PL_DET" ]]; then
        judge_planned "$d"
        continue
      fi
      rc=0
      bash ".github/scripts/$d" --self-test || rc=$?
      [[ $rc -eq 0 ]] || refuse "$d --self-test exited $rc"
    done
  fi
  for d in "${DETECTORS[@]}"; do
    rc=0
    bash ".github/scripts/$d" || rc=$?
    [[ $rc -eq 0 ]] || refuse "$d exited $rc"
  done
  if [[ -n "$PLANNED" ]]; then
    printf '%s\n%s\n' "$PLANNED" "$(git write-tree)" > "$token" || die "could not write the planned-red token"
  fi
}

commit_msg() {
  local file="$1" trailers n token tok_planned="" tok_tree="" have_token=false
  cd "$PROJECT_ROOT"
  [[ -f copier.yml ]] || exit 0
  [[ -f "$file" ]] || die "no commit message file at $file"
  token="$(git rev-parse --git-path "$TOKEN_NAME")" || die "could not resolve the git directory"
  if [[ -f "$token" ]]; then
    have_token=true
    tok_planned="$(sed -n 1p "$token")"; tok_tree="$(sed -n 2p "$token")"
  fi
  rm -f "$token"   # one-shot: consumed whatever this leg decides
  trailers="$(git interpret-trailers --parse < "$file" | grep -i '^Planned-Red:' || true)"
  n=0; [[ -z "$trailers" ]] || n="$(grep -c . <<< "$trailers")"
  if git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1; then
    [[ $n -eq 0 && -z "$PLANNED" ]] \
      || refuse "a merge commit never carries a planned red — the pre-commit leg does not run for a merge"
    return 0
  fi
  if [[ -z "$PLANNED" ]]; then
    [[ $n -eq 0 ]] || refuse "the message carries a Planned-Red trailer, but PLANNED_RED is not set — the hook saw no planned red (to change a planned-red commit, git reset --soft HEAD^ and commit it again with the opt-in)"
    return 0
  fi
  [[ $n -eq 1 ]] || refuse "PLANNED_RED=$PLANNED needs exactly one 'Planned-Red: $PLANNED' trailer; the message carries $n"
  [[ "$(sed 's/^[^:]*:[[:space:]]*//; s/[[:space:]]*$//' <<< "$trailers")" == "$PLANNED" ]] \
    || refuse "the Planned-Red trailer names '${trailers#*:}', not $PLANNED"
  $have_token || refuse "no planned-red token — the pre-commit leg accepted no planned red for this commit (a merge, a hook that did not run, or a token already spent)"
  [[ "$tok_planned" == "$PLANNED" ]] || refuse "the planned-red token was written for PLANNED_RED=$tok_planned, not $PLANNED"
  [[ "$tok_tree" == "$(git write-tree)" ]] \
    || refuse "the planned-red token was written for another staged tree — the index changed after the pre-commit leg judged it"
}

case "${1:-}" in
  --pre-commit) pre_commit ;;
  --commit-msg) [[ -n "${2:-}" ]] || die "--commit-msg needs the message file"; commit_msg "$2" ;;
  --help|-h) sed -n '2,64p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' ;;
  *) die "usage: template-integrity.sh --pre-commit | --commit-msg FILE | --help" ;;
esac
