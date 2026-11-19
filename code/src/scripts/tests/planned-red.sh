#!/usr/bin/env bash
# SC2016: the `bash -c '…' _ args` predicates expand their positional parameters in the child, by
# design. SC2329: predicates are invoked indirectly, through check(), which shellcheck cannot see.
# shellcheck disable=SC2016,SC2329
#
# planned-red.sh — Probes for the planned-red allowance in the template-integrity hook.
#
# Proves .github/scripts/template-integrity.sh (TEMPLATE-ONLY: .github/scripts/ is copier
# _exclude'd, and so is this script), the procedure lefthook.yml's template-integrity pre-commit
# leg and planned-red-trailer commit-msg leg call. A planned red is a probe committed red, ahead
# of its check, under `PLANNED_RED=<detector>::<probe label>[::<probe label>…]` and a matching
# `Planned-Red:` trailer.
#
# Two fixtures, neither holding a path back into this checkout, git running with no global or
# system configuration in both, and every commit a real `git commit` through a hooks directory
# inside the fixture that calls the script exactly as the two lefthook legs do:
#
#   SYNTHETIC  a `git init` in a `mktemp -d` directory holding a copier.yml marker, a COPY of
#              template-integrity.sh and five stand-in detectors. A stand-in's probes are lines
#              in its own file (`#PROBE<TAB>pass|fail<TAB><label>`), so HEAD's version and the
#              staged one carry different probes exactly as a real detector does; it writes the
#              self-test ledger from them, and a probe can force any exit code or drop the
#              ledger's end line to stand for a crash.
#   REAL       `git archive HEAD` of this checkout, with this working tree's .github/scripts/
#              copied over it (the versions under test), committed in its own `git init`. The
#              real detectors run there: a crash inside a self-test, a gutted check and a real
#              new red probe.
#
# What it asserts:
#   accepted   a planned red is committed when exactly the named probes fail, each is new
#              against HEAD, the trailer repeats the opt-in, and the hook output names them.
#   rejected   a bare detector name with no probe; a named probe that passes; a red probe the
#              opt-in does not name; a named probe that already exists at HEAD; a self-test that
#              stops before its end (a crash) or writes no ledger, or exits 2; a missing,
#              mismatched or doubled trailer; a trailer without the opt-in; an opt-in naming no
#              detector or an unstaged one.
#   token      the commit-msg leg needs the one-shot token the pre-commit leg writes on accepting
#              a planned red, bound to the staged tree, and consumes it; a merge commit never
#              carries the trailer; an amend is refused with the reset route named, and that
#              route works.
#   enforced   every other self-test, and every plain check including the named script's, still
#              fails the commit; a red self-test without the opt-in still fails it.
#   ordinary   a commit staging no detector runs no self-test and passes.
#   real       each real detector writes a complete ledger; an unbound variable and a failing
#              command inside a real self-test exit 2; a gutted real check is refused; a real new
#              red probe is accepted end to end.
#   wired      lefthook.yml calls the script from both legs.
#
# Usage: planned-red.sh [--keep] [--help]
#   --keep   Leave the fixture directories in place and print their paths.
#
# Requires: bash, git, python3 (the real detectors). No network, no Docker.
# Exit codes: 0 = every probe passed  1 = a probe failed  2 = script error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
HOOK="$PROJECT_ROOT/.github/scripts/template-integrity.sh"
LEFTHOOK="$PROJECT_ROOT/lefthook.yml"

KEEP=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep) KEEP=true; shift ;;
    --help|-h) sed -n '6,54p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'planned-red.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done
command -v git >/dev/null 2>&1 || { echo "planned-red.sh: git not found" >&2; exit 2; }

FX="$(mktemp -d)"
RX="$(mktemp -d)"
cleanup() { if $KEEP; then echo "fixtures kept: $FX $RX"; else rm -rf "$FX" "$RX"; fi; }
trap cleanup EXIT
FAILS=0
PASSES=0
OUT="$FX/.fixture/out"

pass() { PASSES=$((PASSES + 1)); printf '  \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILS=$((FAILS + 1)); printf '  \033[31m✗\033[0m %s\n' "$1"; }
check() { local label="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$label"; else fail "$label"; fi; }
# git in a fixture: no global or system config, a fixed identity, the fixture's own hooks.
xgit() {
  local root="$1"; shift
  GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 git -C "$root" -c user.name=probe \
    -c user.email=probe@example.invalid -c core.hooksPath="$root/.fixture/hooks" "$@"
}
fgit() { xgit "$FX" "$@"; }

DETECTORS=(check-template-tokens.sh shipped-readme.sh shipped-memory.sh shipped-registers.sh
           shipped-boards.sh)

# The two hooks, shaped exactly as lefthook.yml's legs run them, in fixture $1.
write_hooks() {
  mkdir -p "$1/.fixture/hooks"
  printf '#!/usr/bin/env bash\n[ -f copier.yml ] || exit 0\nexec bash .github/scripts/template-integrity.sh --pre-commit\n' \
    > "$1/.fixture/hooks/pre-commit"
  printf '#!/usr/bin/env bash\n[ -f copier.yml ] || exit 0\nexec bash .github/scripts/template-integrity.sh --commit-msg "$1"\n' \
    > "$1/.fixture/hooks/commit-msg"
  chmod +x "$1/.fixture/hooks/"*
}

build_fixture() {
  local d
  mkdir -p "$FX/.github/scripts" "$FX/.fixture/exit"
  printf '_exclude: []\n' > "$FX/copier.yml"
  printf '.fixture/\n' > "$FX/.gitignore"
  cp "$HOOK" "$FX/.github/scripts/template-integrity.sh"
  for d in "${DETECTORS[@]}"; do
    # A stand-in. Its probes are its own `#PROBE` lines; under --self-test it writes each to the
    # ledger, then the end line (unless .fixture/noend), and exits 1 if any failed. An exit code
    # in .fixture/exit/<name>.<plain|self> overrides; .fixture/noledger writes no ledger at all.
    # It runs from HEAD's tree too (the novelty check), where .fixture is absent.
    cat > "$FX/.github/scripts/$d" <<'EOF'
#!/usr/bin/env bash
mode=plain; [[ "${1:-}" == --self-test ]] && mode=self
root="$(cd "$(dirname "$0")/../.." && pwd)"
name="$(basename "$0")"
echo "$name $mode" 2>/dev/null >> "$root/.fixture/calls"
code=0
if [[ $mode == self ]]; then
  fails=0
  while IFS=$'\t' read -r tag res label; do
    [[ "$tag" == "#PROBE" ]] || continue
    [[ $res == fail ]] && fails=$((fails + 1))
    [[ -n "${SELF_TEST_LEDGER:-}" && ! -f "$root/.fixture/noledger" ]] \
      && printf '%s\t%s\n' "$res" "$label" >> "$SELF_TEST_LEDGER"
  done < "$0"
  [[ -n "${SELF_TEST_LEDGER:-}" && ! -f "$root/.fixture/noledger" && ! -f "$root/.fixture/noend" ]] \
    && printf 'end\t%s\n' "$fails" >> "$SELF_TEST_LEDGER"
  [[ $fails -gt 0 ]] && code=1
fi
f="$root/.fixture/exit/$name.$mode"
[[ -f "$f" ]] && code="$(cat "$f")"
exit "$code"
EOF
    printf '#PROBE\tpass\told probe\n' >> "$FX/.github/scripts/$d"
  done
  write_hooks "$FX"
  git init -q -b master "$FX"
  fgit add -A
  fgit commit -q --no-verify -m fixture
}

# reset — back to the fixture commit on master, every stand-in green, no calls logged.
reset() {
  fgit merge --abort >/dev/null 2>&1 || true
  fgit rebase --abort >/dev/null 2>&1 || true
  fgit checkout -q -f master 2>/dev/null || true
  fgit reset -q --hard "$(fgit rev-list --max-parents=0 HEAD)"
  fgit branch -D side >/dev/null 2>&1 || true
  fgit clean -qfd -e .fixture
  rm -f "$FX/.fixture/exit/"* "$FX/.fixture/calls" "$FX/.fixture/noend" "$FX/.fixture/noledger" "$OUT"
  rm -f "$(fgit rev-parse --git-path planned-red-token)"
}
set_exit() { echo "$3" > "$FX/.fixture/exit/$1.$2"; }       # set_exit NAME plain|self CODE
# add_probe NAME pass|fail LABEL — a new probe in the stand-in, staged.
add_probe() { printf '#PROBE\t%s\t%s\n' "$2" "$3" >> "$FX/.github/scripts/$1"; fgit add ".github/scripts/$1"; }
# flip_old NAME — the stand-in's committed probe turns red (a weakened detector), staged.
flip_old() { sed -i 's/^#PROBE\tpass\told probe$/#PROBE\tfail\told probe/' "$FX/.github/scripts/$1"; fgit add ".github/scripts/$1"; }
touch_other() { echo "x" >> "$FX/README.md"; fgit add README.md; }
token_path() { printf '%s/%s' "$FX" "$(fgit rev-parse --git-path planned-red-token)"; }

# attempt [PLANNED_RED] MESSAGE — commit; 0 when git made the commit. Output kept in $OUT.
attempt() {
  local planned="$1" msg="$2" before rc=0
  before="$(fgit rev-parse HEAD)"
  if [[ -n "$planned" ]]; then
    PLANNED_RED="$planned" fgit commit -q -m "$msg" > "$OUT" 2>&1 || rc=$?
  else
    env -u PLANNED_RED GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 git -C "$FX" -c user.name=probe \
      -c user.email=probe@example.invalid -c core.hooksPath="$FX/.fixture/hooks" \
      commit -q -m "$msg" > "$OUT" 2>&1 || rc=$?
  fi
  [[ $rc -eq 0 && "$(fgit rev-parse HEAD)" != "$before" ]]
}
refused() { ! attempt "$@"; }
said() { grep -qF -- "$1" "$OUT"; }
direct_refused() { ! hook_direct "$@"; }
# hook_direct PLANNED_RED MESSAGE — the commit-msg leg alone, as a path that skips pre-commit.
hook_direct() {
  printf '%s\n' "$2" > "$FX/.fixture/msg"
  (cd "$FX" && PLANNED_RED="$1" bash .github/scripts/template-integrity.sh --commit-msg .fixture/msg) > "$OUT" 2>&1
}

SPEC='shipped-boards.sh::new probe'
RED_MSG=$'test: a red probe\n\nPlanned-Red: shipped-boards.sh::new probe'

probe_accepted() {
  echo "accepted"
  reset; add_probe shipped-boards.sh fail "new probe"
  check "a planned red is committed when exactly its named new probe fails and the trailer repeats it" \
    attempt "$SPEC" "$RED_MSG"
  check "  the hook output names the planned probe" said "planned red — shipped-boards.sh: new probe"
  check "  the commit carries the Planned-Red trailer" \
    bash -c 'git -C "$1" log -1 --format=%B | grep -qxF "Planned-Red: shipped-boards.sh::new probe"' _ "$FX"
  check "  and the token is consumed" bash -c '[[ ! -e "$1" ]]' _ "$(token_path)"
  reset; add_probe shipped-boards.sh fail "new probe"; add_probe shipped-boards.sh fail "second probe"
  check "two new red probes are committed when the opt-in names both" \
    attempt "$SPEC::second probe" $'test: two red probes\n\nPlanned-Red: shipped-boards.sh::new probe::second probe'
}

probe_rejected() {
  echo "rejected"
  reset; add_probe shipped-boards.sh fail "new probe"
  check "an opt-in naming the detector but no probe is refused" \
    refused shipped-boards.sh $'test: x\n\nPlanned-Red: shipped-boards.sh'
  check "  and the refusal asks for the probe label" said "names no probe"
  reset; add_probe shipped-boards.sh pass "new probe"
  check "a planned red is refused when its named probe passes" refused "$SPEC" "$RED_MSG"
  check "  and the refusal says the self-test passed" said "self-test passed"
  reset; add_probe shipped-boards.sh fail "new probe"; add_probe shipped-boards.sh fail "unnamed probe"
  check "a red probe the opt-in does not name refuses the planned red" refused "$SPEC" "$RED_MSG"
  check "  and the refusal says exactly the named probes may fail" said "exactly the named probes may fail"
  reset; add_probe shipped-boards.sh fail "new probe"; flip_old shipped-boards.sh
  check "an existing probe turned red beside the planned one is refused — a weakened detector" \
    refused "$SPEC" "$RED_MSG"
  check "  and the refusal names the old probe among the red" said "[new probe|old probe]"
  reset; flip_old shipped-boards.sh
  check "naming a probe that already exists at HEAD is refused — only a new probe is planned" \
    refused 'shipped-boards.sh::old probe' $'test: x\n\nPlanned-Red: shipped-boards.sh::old probe'
  check "  and the refusal says it already exists at HEAD" said "already exists at HEAD"
  reset; add_probe shipped-boards.sh fail "new probe"; touch "$FX/.fixture/noend"
  check "a self-test that stops before its end (a crash) is refused, though it exits 1" \
    refused "$SPEC" "$RED_MSG"
  check "  and the refusal says it stopped early" said "stopped early"
  reset; add_probe shipped-boards.sh fail "new probe"; touch "$FX/.fixture/noledger"
  check "a self-test that writes no ledger is refused, though it exits 1" refused "$SPEC" "$RED_MSG"
  check "  and the refusal says it recorded no finished ledger" said "no finished ledger"
  reset; add_probe shipped-boards.sh fail "new probe"; set_exit shipped-boards.sh self 2
  check "a planned red is refused when its self-test is a script error (exit 2)" refused "$SPEC" "$RED_MSG"
  reset; add_probe shipped-boards.sh fail "new probe"
  check "a planned red with no trailer is refused" refused "$SPEC" "test: a red probe"
  reset; add_probe shipped-boards.sh fail "new probe"
  check "a trailer naming the detector alone, not the probe, is refused" \
    refused "$SPEC" $'test: a red probe\n\nPlanned-Red: shipped-boards.sh'
  reset; add_probe shipped-boards.sh fail "new probe"
  check "a planned red with two trailers is refused" \
    refused "$SPEC" "$RED_MSG"$'\nPlanned-Red: shipped-boards.sh::new probe'
  reset; add_probe shipped-boards.sh pass "new probe"
  check "a Planned-Red trailer without the opt-in is refused" refused "" "$RED_MSG"
  reset; add_probe shipped-boards.sh pass "new probe"
  check "a Planned-Red line in the body, not the trailer block, is not a trailer" \
    attempt "" $'test: green\n\nPlanned-Red: shipped-boards.sh::new probe\n\nthis paragraph ends the message.'
  reset; touch_other
  check "an opt-in naming no self-tested detector is refused" \
    refused 'shipped-ai.sh::x' $'test: x\n\nPlanned-Red: shipped-ai.sh::x'
  reset; add_probe shipped-memory.sh pass "new probe"
  check "an opt-in naming a detector that is not staged is refused" refused "$SPEC" "$RED_MSG"
}

probe_token() {
  echo "token"
  reset
  check "the commit-msg leg alone, with no token, refuses the opt-in and its trailer" direct_refused "$SPEC" "$RED_MSG"
  check "  and the refusal names the missing token" said "no planned-red token"
  reset; add_probe shipped-boards.sh fail "new probe"
  (cd "$FX" && PLANNED_RED="$SPEC" bash .github/scripts/template-integrity.sh --pre-commit) >/dev/null 2>&1 || true
  touch_other
  check "a token written for another staged tree is refused" direct_refused "$SPEC" "$RED_MSG"
  check "  and the refusal names the changed tree" said "another staged tree"
  check "  and the refused token is consumed" bash -c '[[ ! -e "$1" ]]' _ "$(token_path)"
  reset; add_probe shipped-boards.sh fail "new probe"; attempt "$SPEC" "$RED_MSG" || true
  check "a token is one-shot — a second message on it is refused" direct_refused "$SPEC" "$RED_MSG"
  check "  and the refusal names the spent token" said "no planned-red token"
  reset
  fgit checkout -q -b side; touch_other; fgit commit -q --no-verify -m side; fgit checkout -q master
  echo "y" >> "$FX/OTHER.md"; fgit add OTHER.md; fgit commit -q --no-verify -m master-side
  local before; before="$(fgit rev-parse HEAD)"
  PLANNED_RED="$SPEC" fgit merge -q --no-ff side -m "$RED_MSG" > "$OUT" 2>&1 || true
  check "a merge commit carrying the trailer is refused (git merge runs no pre-commit)" \
    bash -c '[[ "$(git -C "$1" rev-parse HEAD)" == "$2" ]]' _ "$FX" "$before"
  check "  and the refusal says a merge never carries a planned red" said "merge commit never carries a planned red"
  reset
  echo "z" >> "$FX/OTHER.md"; fgit add OTHER.md; fgit commit -q --no-verify -m ordinary
  before="$(fgit rev-parse HEAD)"
  printf '%s\n' "$RED_MSG" > "$FX/.fixture/reword-msg"
  printf '#!/bin/sh\ncat "%s" > "$1"\n' "$FX/.fixture/reword-msg" > "$FX/.fixture/editor"
  chmod +x "$FX/.fixture/editor"
  PLANNED_RED="$SPEC" GIT_EDITOR="$FX/.fixture/editor" \
    fgit -c sequence.editor="sed -i s/^pick/reword/" rebase -q -i HEAD~1 > "$OUT" 2>&1 || true
  check "a sequencer reword adding the trailer to a commit with no red probe is refused" \
    bash -c '! git -C "$1" log -1 --format=%B | grep -q "^Planned-Red:"' _ "$FX"
  reset; add_probe shipped-boards.sh fail "new probe"; attempt "$SPEC" "$RED_MSG" || true
  check "amending a planned-red commit is refused" \
    bash -c 'PLANNED_RED="$2" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 git -C "$1" -c user.name=probe -c user.email=probe@example.invalid -c core.hooksPath="$1/.fixture/hooks" commit -q --amend -m "$3" > "$4" 2>&1; [[ $? -ne 0 ]]' \
    _ "$FX" "$SPEC" "$RED_MSG" "$OUT"
  check "  and the refusal names the reset route" said "git reset --soft HEAD^"
  fgit reset -q --soft HEAD^ 2>/dev/null || true
  check "the reset route recommits the planned red" attempt "$SPEC" "$RED_MSG"
}

probe_enforced() {
  echo "enforced"
  reset; add_probe shipped-boards.sh fail "new probe"; set_exit shipped-memory.sh self 1
  check "another self-test that fails still refuses the planned red" refused "$SPEC" "$RED_MSG"
  reset; add_probe shipped-boards.sh fail "new probe"; set_exit shipped-readme.sh plain 1
  check "another plain check that fails still refuses it" refused "$SPEC" "$RED_MSG"
  reset; add_probe shipped-boards.sh fail "new probe"; set_exit shipped-boards.sh plain 1
  check "the named script's own plain check that fails still refuses it" refused "$SPEC" "$RED_MSG"
  reset; add_probe shipped-boards.sh fail "new probe"
  check "a red self-test without the opt-in refuses the commit" refused "" "test: unplanned red"
}

probe_ordinary() {
  echo "ordinary"
  reset; touch_other
  check "a commit staging no detector passes" attempt "" "docs: ordinary"
  check "  and runs no self-test" bash -c '! grep -q " self$" "$1/.fixture/calls"' _ "$FX"
  check "  but runs every plain check" bash -c '[[ $(grep -c " plain$" "$1/.fixture/calls") -eq 5 ]]' _ "$FX"
  reset; add_probe shipped-readme.sh pass "new probe"
  check "a green detector commit passes with every self-test run" attempt "" "test: green"
}

# ── The real fixture ─────────────────────────────────────────────────────────────────────────
rgit() { xgit "$RX" "$@"; }
build_real() {
  git -C "$PROJECT_ROOT" archive HEAD | tar -x -C "$RX"
  rm -rf "$RX/.github/scripts"; mkdir -p "$RX/.github/scripts"
  cp "$PROJECT_ROOT"/.github/scripts/*.sh "$PROJECT_ROOT"/.github/scripts/*.py "$RX/.github/scripts/"
  write_hooks "$RX"
  printf '.fixture/\n' >> "$RX/.gitignore"
  git init -q -b master "$RX"
  rgit add -A
  rgit commit -q --no-verify -m real-fixture
}
rreset() { rgit reset -q --hard HEAD; rgit clean -qfd -e .fixture; }
# rself NAME — the real detector's self-test with a ledger; prints the exit code.
rself() {
  local rc=0
  (cd "$RX" && SELF_TEST_LEDGER="$RX/.fixture/ledger" bash ".github/scripts/$1" --self-test) >/dev/null 2>&1 || rc=$?
  echo "$rc"
}
# insert_in_self_test NAME LINE — put LINE as the first statement of the real self_test().
insert_in_self_test() {
  awk -v l="$2" '{print} /^self_test\(\) \{/ && !done {print l; done=1}' "$RX/.github/scripts/$1" \
    > "$RX/.fixture/tmp" && cat "$RX/.fixture/tmp" > "$RX/.github/scripts/$1"
}
rattempt() {
  local planned="$1" msg="$2" before rc=0
  before="$(rgit rev-parse HEAD)"
  PLANNED_RED="$planned" rgit commit -q -m "$msg" > "$OUT" 2>&1 || rc=$?
  [[ $rc -eq 0 && "$(rgit rev-parse HEAD)" != "$before" ]]
}

rrefused() { ! rattempt "$@"; }

probe_real() {
  echo "real"
  local d rc
  if ! build_real >/dev/null 2>&1; then fail "the real fixture could not be built"; return; fi
  for d in "${DETECTORS[@]}"; do
    rm -f "$RX/.fixture/ledger"
    rc="$(rself "$d")"
    check "real $d --self-test passes and writes a complete ledger" \
      bash -c '[[ $2 -eq 0 ]] && grep -qP "^pass\t" "$1" && tail -1 "$1" | grep -qxP "end\t0"' _ "$RX/.fixture/ledger" "$rc"
  done
  rreset; insert_in_self_test shipped-boards.sh '  : "$PLANNED_RED_PROBE_UNSET_VAR"'
  check "an unbound variable inside a real self-test exits 2, never a red" \
    bash -c '[[ $1 -eq 2 ]]' _ "$(rself shipped-boards.sh)"
  rreset; insert_in_self_test shipped-memory.sh '  grep -q planned-red-nomatch /dev/null'
  check "a failing command inside a real self-test exits 2, never a red" \
    bash -c '[[ $1 -eq 2 ]]' _ "$(rself shipped-memory.sh)"
  rreset
  sed -i 's/^finding() { FINDINGS+=("$1"); }$/finding() { :; }/' "$RX/.github/scripts/shipped-boards.sh"
  rgit add .github/scripts/shipped-boards.sh
  check "a gutted real check (finding() stubbed) is refused under any planned probe" \
    rrefused 'shipped-boards.sh::check 1 fires when a board is re-included' \
    $'test: x\n\nPlanned-Red: shipped-boards.sh::check 1 fires when a board is re-included'
  check "  and the refusal says other probes went red" said "exactly the named probes may fail"
  rreset
  awk '{print} /^  ARTEFACTS="\$real_art"$/ {print "  probe \"a planned real probe\" \"a finding no check writes\""}' \
    "$RX/.github/scripts/shipped-boards.sh" > "$RX/.fixture/tmp" && cat "$RX/.fixture/tmp" > "$RX/.github/scripts/shipped-boards.sh"
  rgit add .github/scripts/shipped-boards.sh
  check "a real new red probe is accepted end to end" \
    rattempt 'shipped-boards.sh::a planned real probe' $'test: a real red probe\n\nPlanned-Red: shipped-boards.sh::a planned real probe'
}

probe_wired() {
  echo "wired"
  check "lefthook.yml's pre-commit leg calls template-integrity.sh --pre-commit" \
    grep -qF 'bash .github/scripts/template-integrity.sh --pre-commit' "$LEFTHOOK"
  check "lefthook.yml's commit-msg leg calls template-integrity.sh --commit-msg {1}" \
    grep -qF 'bash .github/scripts/template-integrity.sh --commit-msg {1}' "$LEFTHOOK"
}

echo "planned-red.sh — fixtures at $FX and $RX"
if [[ ! -f "$HOOK" ]]; then
  fail "there is no .github/scripts/template-integrity.sh to prove"
  probe_wired
elif ! build_fixture >/dev/null 2>&1; then
  fail "the fixture could not be built"
else
  probe_accepted
  probe_rejected
  probe_token
  probe_enforced
  probe_ordinary
  probe_real
  probe_wired
fi
echo ""
if [[ $FAILS -eq 0 ]]; then
  printf '\033[1m✓ planned-red.sh: %d probes passed\033[0m\n' "$PASSES"
  exit 0
fi
printf '\033[1m✗ planned-red.sh: %d of %d probes failed\033[0m\n' "$FAILS" "$((FAILS + PASSES))"
exit 1
