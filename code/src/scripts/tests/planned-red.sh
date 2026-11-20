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
#   proof      staging the hook, the ledger library, lefthook.yml or this script runs this script,
#              and its failure refuses the commit; nothing else runs it. The proof's own planned
#              red: accepted when its new probes alone are red; refused beside a staged allowance,
#              an old probe red, renamed or deleted, a changed line, or an uncounted failure.
#   real       each real detector writes a complete ledger; an unbound variable and a failing
#              command inside a real self-test exit 2; a gutted real check is refused; a real new
#              red probe is accepted end to end.
#   wired      lefthook.yml calls the script from both legs, and audit-template.yml runs this one.
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
    --help|-h) sed -n '6,57p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
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

# The proof's own ledger, for the allowance's planned red of the proof: with PROOF_LEDGER set, each
# probe appends `pass|fail<TAB><label>` and the run ends with `end<TAB><failed count>`. The
# detectors' SELF_TEST_LEDGER is cleared, so no fixture's detector ever writes into a caller's.
LEDGER="${PROOF_LEDGER:-}"
unset PROOF_LEDGER SELF_TEST_LEDGER
record() { if [[ -n "$LEDGER" ]]; then printf '%s\t%s\n' "$1" "${2//[$'\t\n']/ }" >> "$LEDGER"; fi; }
pass() { PASSES=$((PASSES + 1)); record pass "$1"; printf '  \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILS=$((FAILS + 1)); record fail "$1"; printf '  \033[31m✗\033[0m %s\n' "$1"; }
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
    # A stand-in. Its probes are its own `#PROBE` lines, inside a `self_test() {` … `}` region at
    # its end (never executed: the script exits above it); under --self-test it writes each to the
    # ledger with its line number, then the end line (unless .fixture/noend; one failure more than
    # it recorded under .fixture/endbump), and exits 1 if any failed. An exit code in
    # .fixture/exit/<name>.<plain|self> overrides; .fixture/noledger writes no ledger at all.
    # It runs from HEAD's tree too (the novelty check), where .fixture is absent.
    cat > "$FX/.github/scripts/$d" <<'EOF'
#!/usr/bin/env bash
mode=plain; [[ "${1:-}" == --self-test ]] && mode=self
root="$(cd "$(dirname "$0")/../.." && pwd)"
name="$(basename "$0")"
echo "$name $mode" 2>/dev/null >> "$root/.fixture/calls"
code=0
if [[ $mode == self ]]; then
  fails=0; n=0
  while IFS=$'\t' read -r tag res label; do
    n=$((n + 1))
    [[ "$tag" == "#PROBE" ]] || continue
    [[ $res == fail ]] && fails=$((fails + 1))
    [[ -n "${SELF_TEST_LEDGER:-}" && ! -f "$root/.fixture/noledger" ]] \
      && printf '%s\t%s\t%s\n' "$res" "$label" "$n" >> "$SELF_TEST_LEDGER"
  done < "$0"
  [[ -f "$root/.fixture/endbump" ]] && fails=$((fails + 1))
  [[ -f "$root/.fixture/endbump.$name" ]] && fails=$((fails + 1))
  [[ -n "${SELF_TEST_LEDGER:-}" && ! -f "$root/.fixture/noledger" && ! -f "$root/.fixture/noend" ]] \
    && printf 'end\t%s\n' "$fails" >> "$SELF_TEST_LEDGER"
  [[ $fails -gt 0 ]] && code=1
fi
f="$root/.fixture/exit/$name.$mode"
[[ -f "$f" ]] && code="$(cat "$f")"
exit "$code"
self_test() {
EOF
    printf '#PROBE\tpass\told probe\n}\n' >> "$FX/.github/scripts/$d"
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
  rm -f "$FX/.fixture/exit/"* "$FX/.fixture/calls" "$FX/.fixture/noend" "$FX/.fixture/noledger" \
    "$FX/.fixture/endbump" "$OUT"
  rm -f "$(fgit rev-parse --git-path planned-red-token)"
}
set_exit() { echo "$3" > "$FX/.fixture/exit/$1.$2"; }       # set_exit NAME plain|self CODE
# add_probe NAME pass|fail LABEL — a new probe in the stand-in, the last line of its self_test()
# region (inserted above the closing brace, so the diff only adds a line inside it), staged.
add_probe() { insert_before_last "$FX/.github/scripts/$1" "$(printf '#PROBE\t%s\t%s' "$2" "$3")"; fgit add ".github/scripts/$1"; }
insert_before_last() { # FILE LINE — LINE above FILE's last line
  local f="$1" t; t="$(mktemp)"
  { head -n -1 "$f"; printf '%s\n' "$2"; tail -n 1 "$f"; } > "$t" && cat "$t" > "$f" && rm -f "$t"
}
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

# The allowance's own proof runs when the allowance changes: a stand-in planned-red.sh in the
# synthetic fixture, exiting with .fixture/exit/planned-red.sh.self (0 when absent).
probe_proof() {
  echo "proof"
  reset
  mkdir -p "$FX/code/src/scripts/tests"
  printf '#!/usr/bin/env bash
root="$(cd "$(dirname "$0")/../../../.." && pwd)"
echo "planned-red.sh self" >> "$root/.fixture/calls"
exit "$(cat "$root/.fixture/exit/planned-red.sh.self" 2>/dev/null || echo 0)"
' \
    > "$FX/code/src/scripts/tests/planned-red.sh"
  fgit add code/src/scripts/tests/planned-red.sh; fgit commit -q --no-verify -m stand-in
  local f
  for f in .github/scripts/template-integrity.sh .github/scripts/self-test-ledger.sh lefthook.yml \
           code/src/scripts/tests/planned-red.sh; do
    rm -f "$FX/.fixture/calls"; mkdir -p "$FX/$(dirname "$f")"; echo "# probe" >> "$FX/$f"; fgit add "$f"
    set_exit planned-red.sh self 1
    check "staging $f runs planned-red.sh, and its failure refuses the commit" refused "" "ci: x"
    check "  and planned-red.sh was called" bash -c 'grep -qx "planned-red.sh self" "$1/.fixture/calls"' _ "$FX"
    rm -f "$FX/.fixture/exit/planned-red.sh.self"
    check "  and it passes once planned-red.sh passes" attempt "" "ci: x"
  done
  rm -f "$FX/.fixture/calls"; touch_other
  attempt "" "docs: x" >/dev/null 2>&1 || true
  check "a commit staging none of them does not run planned-red.sh" \
    bash -c '! grep -q "planned-red.sh" "$1/.fixture/calls"' _ "$FX"
}

# ── Round 4: a planned red may only add probes ────────────────────────────────────────────────
# relabel NAME — every old stand-in probe renamed (and left green); staged.
relabel() { sed -i 's/^#PROBE\tpass\told probe$/#PROBE\tpass\told probe (rev)/' "$FX/.github/scripts/$1"; fgit add ".github/scripts/$1"; }

probe_only_adds() {
  echo "only adds"
  reset; sed -i 's/^#PROBE\tpass\told probe$/#PROBE\tfail\told probe (rev)/' "$FX/.github/scripts/shipped-boards.sh"
  fgit add .github/scripts/shipped-boards.sh
  check "an old probe renamed and red is refused, though its new label is absent at HEAD" \
    refused 'shipped-boards.sh::old probe (rev)' $'test: x\n\nPlanned-Red: shipped-boards.sh::old probe (rev)'
  check "  and the refusal says a planned red may only add probes — an old probe renamed and red" said "may only add probes"
  reset; relabel shipped-boards.sh; add_probe shipped-boards.sh fail "new probe"
  check "an old probe renamed while green beside a new red probe is refused" refused "$SPEC" "$RED_MSG"
  reset; sed -i '/^#PROBE\tpass\told probe$/d' "$FX/.github/scripts/shipped-boards.sh"; add_probe shipped-boards.sh fail "new probe"
  check "an old probe deleted beside a new red probe is refused" refused "$SPEC" "$RED_MSG"
  check "  and the refusal says a planned red may only add probes — an old probe deleted beside a new red probe" said "may only add probes"
  reset; add_probe shipped-boards.sh fail "new probe"; touch "$FX/.fixture/endbump.shipped-boards.sh"
  check "a self-test counting a failure it never recorded is refused" refused "$SPEC" "$RED_MSG"
  check "  and the refusal names the uncounted failure — a self-test counting a failure it never recorded" said "a failure counted without being recorded"
  rm -f "$FX/.fixture/endbump.shipped-boards.sh"
  reset; add_probe shipped-boards.sh fail "new probe"; sed -i 's/^code=0$/code=0 /' "$FX/.github/scripts/shipped-boards.sh"
  fgit add .github/scripts/shipped-boards.sh
  check "a detector whose diff changes a line beside the new probe is refused" refused "$SPEC" "$RED_MSG"
  check "  and the refusal says a line was changed or deleted — a detector whose diff changes a line beside the new probe" said "changes or deletes a line"
  reset; add_probe shipped-boards.sh fail "new probe"; echo "# appended" >> "$FX/.github/scripts/shipped-boards.sh"
  fgit add .github/scripts/shipped-boards.sh
  check "a detector gaining a line outside its self_test() region is refused" refused "$SPEC" "$RED_MSG"
  check "  and the refusal says the line is outside self_test() — a detector gaining a line outside its self_test() region" said "outside self_test()"
  reset; add_probe shipped-boards.sh fail "new probe"
  check "a new red probe inside the region alone is still accepted" attempt "$SPEC" "$RED_MSG"
}

rroot() { rgit reset -q --hard "$(rgit rev-list --max-parents=0 HEAD)"; rgit clean -qfd -e .fixture; }
# rred NAME — the real detector's red labels in the working tree, joined `<NAME>::<l>::<l>…`.
rred() {
  rm -f "$RX/.fixture/ledger"; rself "$1" >/dev/null
  printf '%s' "$1"; awk -F'\t' '$1 == "fail" { printf "::%s", $2 }' "$RX/.fixture/ledger"
}
rmsg() { printf 'test: x\n\nPlanned-Red: %s' "$1"; }

probe_real_only_adds() {
  echo "real only adds"
  local b="$RX/.github/scripts/shipped-boards.sh" m="$RX/.github/scripts/shipped-memory.sh" spec
  rroot
  sed -i 's/^finding() { FINDINGS+=("$1"); }$/finding() { :; }/; s/st_record pass "\$1"$/st_record pass "$1 (rev)"/; s/st_record fail "\$1"$/st_record fail "$1 (rev)"/' "$b"
  rgit add .github/scripts/shipped-boards.sh; spec="$(rred shipped-boards.sh)"
  check "a gutted real check with every probe relabelled is refused, though each red label is new" \
    rrefused "$spec" "$(rmsg "$spec")"
  check "  and the refusal says a planned red may only add probes — a gutted real check with every probe relabelled" said "may only add probes"
  rroot
  awk '/^self_test\(\) \{/ { print; print "  ST_FAILS=1; st_record fail \"the only probe\"; return 0"; skip = 1; next }
       skip && /^}$/ { skip = 0 } !skip { print }' "$b" > "$RX/.fixture/tmp" && cat "$RX/.fixture/tmp" > "$b"
  sed -i 's/^finding() { FINDINGS+=("$1"); }$/finding() { :; }/' "$b"
  rgit add .github/scripts/shipped-boards.sh
  check "a real self-test emptied of every old probe but one new red one is refused" \
    rrefused 'shipped-boards.sh::the only probe' "$(rmsg 'shipped-boards.sh::the only probe')"
  check "  and the refusal says a planned red may only add probes — a real self-test emptied of every old probe but one new red one" said "may only add probes"
  rroot
  sed -i 's/^    || finding "copier.yml _exclude does not list/    || true "copier.yml _exclude does not list/; s/probe "check 1 fires when the _exclude row is dropped"/probe "check 1 fires when the exclude row is dropped"/' "$m"
  rgit add .github/scripts/shipped-memory.sh; spec="$(rred shipped-memory.sh)"
  check "a real probe renamed beside its neutered check is refused" rrefused "$spec" "$(rmsg "$spec")"
  check "  and the refusal says a planned red may only add probes — a real probe renamed beside its neutered check" said "may only add probes"
  rroot
  sed -i 's/^  FINDINGS=()$/  FINDINGS=( )/' "$b"
  awk '{print} /^  ARTEFACTS="\$real_art"$/ {print "  probe \"a planned real probe\" \"a finding no check writes\""}' \
    "$b" > "$RX/.fixture/tmp" && cat "$RX/.fixture/tmp" > "$b"
  rgit add .github/scripts/shipped-boards.sh
  check "a real check-logic line modified beside a new red probe is refused" \
    rrefused 'shipped-boards.sh::a planned real probe' "$(rmsg 'shipped-boards.sh::a planned real probe')"
  check "  and the refusal says a line was changed or deleted — a real check-logic line modified beside a new red probe" said "changes or deletes a line"
  rroot
  awk '{print} /^  ARTEFACTS="\$real_art"$/ {print "  probe \"a planned real probe\" \"a finding no check writes\""; print "  ST_FAILS=$((ST_FAILS + 1))"}' \
    "$b" > "$RX/.fixture/tmp" && cat "$RX/.fixture/tmp" > "$b"
  rgit add .github/scripts/shipped-boards.sh
  check "a real self-test bumping its failure count without recording a probe is refused" \
    rrefused 'shipped-boards.sh::a planned real probe' "$(rmsg 'shipped-boards.sh::a planned real probe')"
  check "  and the refusal names the uncounted failure — a real self-test bumping its failure count without recording a probe" said "a failure counted without being recorded"
  rroot
}

# The proof's own planned red: a stand-in planned-red.sh in the synthetic fixture whose probes are
# its `#PROBE` lines, written to PROOF_LEDGER, exiting 1 when any is red.
proof_standin() {
  mkdir -p "$FX/code/src/scripts/tests"
  cat > "$FX/code/src/scripts/tests/planned-red.sh" <<'EOF'
#!/usr/bin/env bash
root="$(cd "$(dirname "$0")/../../../.." && pwd)"
echo "planned-red.sh self" 2>/dev/null >> "$root/.fixture/calls"
fails=0; n=0
while IFS=$'\t' read -r tag res label; do
  n=$((n + 1))
  [[ "$tag" == "#PROBE" ]] || continue
  [[ $res == fail ]] && fails=$((fails + 1))
  [[ -n "${PROOF_LEDGER:-}" ]] && printf '%s\t%s\t%s\n' "$res" "$label" "$n" >> "$PROOF_LEDGER"
done < "$0"
[[ -f "$root/.fixture/endbump" ]] && fails=$((fails + 1))
[[ -n "${PROOF_LEDGER:-}" ]] && printf 'end\t%s\n' "$fails" >> "$PROOF_LEDGER"
code=0; [[ $fails -gt 0 ]] && code=1
exit "$code"
#PROBE	pass	old proof probe
#PROBE	pass	second old proof probe
EOF
  fgit add code/src/scripts/tests/planned-red.sh; fgit commit -q --no-verify -m proof-stand-in
}
PROOF_SPEC='planned-red.sh::new proof probe'
PROOF_MSG=$'test: a red proof probe\n\nPlanned-Red: planned-red.sh::new proof probe'
proof_add() { printf '#PROBE\t%s\t%s\n' "$1" "$2" >> "$FX/code/src/scripts/tests/planned-red.sh"; fgit add code/src/scripts/tests/planned-red.sh; }

probe_proof_planned() {
  echo "proof planned red"
  local p="$FX/code/src/scripts/tests/planned-red.sh"
  reset; proof_standin; proof_add fail "new proof probe"
  check "a red probe new in the proof is committed as the proof's planned red" attempt "$PROOF_SPEC" "$PROOF_MSG"
  check "  and the hook output names it" said "planned red — planned-red.sh: new proof probe"
  reset; proof_standin; proof_add fail "new proof probe"; echo "# x" >> "$FX/.github/scripts/template-integrity.sh"
  fgit add .github/scripts/template-integrity.sh
  check "the proof's planned red is refused when the allowance itself is staged with it" \
    refused "$PROOF_SPEC" "$PROOF_MSG"
  check "  and the refusal says the allowance is staged" said "the allowance itself is staged"
  reset; proof_standin; proof_add fail "new proof probe"
  sed -i 's/^#PROBE\tpass\told proof probe$/#PROBE\tfail\told proof probe/' "$p"; fgit add "$p"
  check "an old proof probe gone red beside the new one is refused" refused "$PROOF_SPEC" "$PROOF_MSG"
  reset; proof_standin
  sed -i 's/^#PROBE\tpass\told proof probe$/#PROBE\tfail\trenamed proof probe/' "$p"; fgit add "$p"
  check "an old proof probe renamed and red is refused, though its new label is absent at HEAD" \
    refused 'planned-red.sh::renamed proof probe' $'test: x\n\nPlanned-Red: planned-red.sh::renamed proof probe'
  check "  and the refusal says a planned red may only add probes" said "may only add probes"
  reset; proof_standin
  sed -i '/^#PROBE\tpass\tsecond old proof probe$/d' "$p"; proof_add fail "new proof probe"
  check "an old proof probe deleted beside a new red one is refused" refused "$PROOF_SPEC" "$PROOF_MSG"
  reset; proof_standin; proof_add fail "new proof probe"; sed -i 's/^code=0; /code=0;  /' "$p"; fgit add "$p"
  check "a proof whose diff changes a line beside the new probe is refused" refused "$PROOF_SPEC" "$PROOF_MSG"
  check "  and the refusal says the proof only gains lines" said "adds probes and changes nothing else"
  reset; proof_standin; proof_add fail "new proof probe"; touch "$FX/.fixture/endbump"
  check "a proof counting a failure it never recorded is refused" refused "$PROOF_SPEC" "$PROOF_MSG"
  check "  and the refusal names the uncounted failure" said "a failure counted without being recorded"
  reset; proof_standin; proof_add pass "new proof probe"
  check "a green proof commit still passes without the opt-in" attempt "" "test: green proof"
}

probe_wired() {
  echo "wired"
  check "audit-template.yml runs planned-red.sh" \
    grep -qE '^[[:space:]]+run: bash code/src/scripts/tests/planned-red\.sh$' "$PROJECT_ROOT/.github/workflows/audit-template.yml"
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
  probe_proof
  probe_proof_planned
  probe_only_adds
  probe_real
  probe_real_only_adds
  probe_wired
fi
echo ""
record end "$FAILS"
if [[ $FAILS -eq 0 ]]; then
  printf '\033[1m✓ planned-red.sh: %d probes passed\033[0m\n' "$PASSES"
  exit 0
fi
printf '\033[1m✗ planned-red.sh: %d of %d probes failed\033[0m\n' "$FAILS" "$((FAILS + PASSES))"
exit 1
