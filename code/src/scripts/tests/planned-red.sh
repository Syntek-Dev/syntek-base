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
# of its check, under `PLANNED_RED=<detector>` and a `Planned-Red: <detector>` trailer.
#
# The fixture is SYNTHETIC: a `git init` in a `mktemp -d` directory holding a copier.yml marker,
# a COPY of template-integrity.sh (never a symlink) and five stand-in detectors, each exiting
# with a code the probe chooses for its plain run and for its --self-test. Real `git commit`s
# run through a hooks directory inside the fixture that calls the script exactly as the two
# lefthook legs do, so the environment a hook inherits is exercised, not assumed. Git runs with
# no global or system configuration. Nothing in the fixture is a path back into this checkout.
#
# What it asserts:
#   accepted   a planned red is committed when the named self-test exits 1 and the trailer
#              names it; the hook output records the red.
#   rejected   the same commit is refused when the named self-test passes, when it is a script
#              error, when the trailer is missing or names another script, when the trailer is
#              present without the opt-in, when the opt-in names no detector or an unstaged one.
#   enforced   every other self-test, and every plain check including the named script's, still
#              fails the commit; a red self-test without the opt-in still fails it.
#   ordinary   a commit staging no detector runs no self-test and passes.
#   wired      lefthook.yml calls the script from both legs.
#
# Usage: planned-red.sh [--keep] [--help]
#   --keep   Leave the fixture directory in place and print its path.
#
# Requires: bash, git. No network, no Docker.
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
    --help|-h) sed -n '6,37p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'planned-red.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done
command -v git >/dev/null 2>&1 || { echo "planned-red.sh: git not found" >&2; exit 2; }

FX="$(mktemp -d)"
cleanup() { if $KEEP; then echo "fixture kept: $FX"; else rm -rf "$FX"; fi; }
trap cleanup EXIT
FAILS=0
PASSES=0
OUT="$FX/.fixture/out"

pass() { PASSES=$((PASSES + 1)); printf '  \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILS=$((FAILS + 1)); printf '  \033[31m✗\033[0m %s\n' "$1"; }
check() { local label="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$label"; else fail "$label"; fi; }
fgit() {
  GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 git -C "$FX" -c user.name=probe \
    -c user.email=probe@example.invalid -c core.hooksPath="$FX/.fixture/hooks" "$@"
}

DETECTORS=(check-template-tokens.sh shipped-readme.sh shipped-memory.sh shipped-registers.sh
           shipped-boards.sh)

build_fixture() {
  local d
  mkdir -p "$FX/.github/scripts" "$FX/.fixture/hooks" "$FX/.fixture/exit"
  printf '_exclude: []\n' > "$FX/copier.yml"
  printf '.fixture/\n' > "$FX/.gitignore"
  cp "$HOOK" "$FX/.github/scripts/template-integrity.sh"
  for d in "${DETECTORS[@]}"; do
    # A stand-in: exits with .fixture/exit/<name>.<plain|self>, 0 when absent, and logs the call.
    cat > "$FX/.github/scripts/$d" <<'EOF'
#!/usr/bin/env bash
mode=plain; [[ "${1:-}" == --self-test ]] && mode=self
root="$(cd "$(dirname "$0")/../.." && pwd)"
echo "$(basename "$0") $mode" >> "$root/.fixture/calls"
f="$root/.fixture/exit/$(basename "$0").$mode"
exit "$(cat "$f" 2>/dev/null || echo 0)"
EOF
  done
  # The two hooks, shaped exactly as lefthook.yml's legs run them.
  printf '#!/usr/bin/env bash\n[ -f copier.yml ] || exit 0\nexec bash .github/scripts/template-integrity.sh --pre-commit\n' \
    > "$FX/.fixture/hooks/pre-commit"
  printf '#!/usr/bin/env bash\n[ -f copier.yml ] || exit 0\nexec bash .github/scripts/template-integrity.sh --commit-msg "$1"\n' \
    > "$FX/.fixture/hooks/commit-msg"
  chmod +x "$FX/.fixture/hooks/"*
  git init -q "$FX"
  fgit add -A
  fgit commit -q --no-verify -m fixture
}

# reset — back to the fixture commit, every stand-in green, no calls logged.
reset() {
  fgit reset -q --hard HEAD
  fgit reset -q --hard "$(fgit rev-list --max-parents=0 HEAD)"
  rm -f "$FX/.fixture/exit/"* "$FX/.fixture/calls" "$OUT"
}
set_exit() { echo "$3" > "$FX/.fixture/exit/$1.$2"; }       # set_exit NAME plain|self CODE
touch_detector() { echo "# probe" >> "$FX/.github/scripts/$1"; fgit add ".github/scripts/$1"; }
touch_other() { echo "x" >> "$FX/README.md"; fgit add README.md; }

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

RED_MSG=$'test: a red probe\n\nPlanned-Red: shipped-boards.sh'

probe_accepted() {
  echo "accepted"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1
  check "a planned red is committed when its self-test exits 1 and the trailer names it" \
    attempt shipped-boards.sh "$RED_MSG"
  check "the hook output records the planned red" said "planned red — shipped-boards.sh --self-test exited 1"
  check "the commit carries the Planned-Red trailer" \
    bash -c 'git -C "$1" log -1 --format=%B | grep -qx "Planned-Red: shipped-boards.sh"' _ "$FX"
}

probe_rejected() {
  echo "rejected"
  reset; touch_detector shipped-boards.sh
  check "a planned red is refused when its self-test passes" refused shipped-boards.sh "$RED_MSG"
  check "  and the refusal says the self-test passed" said "self-test passed"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 2
  check "a planned red is refused when its self-test is a script error (exit 2)" refused shipped-boards.sh "$RED_MSG"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1
  check "a planned red with no trailer is refused" refused shipped-boards.sh "test: a red probe"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1
  check "a planned red whose trailer names another script is refused" \
    refused shipped-boards.sh $'test: a red probe\n\nPlanned-Red: shipped-memory.sh'
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1
  check "a planned red with two trailers is refused" \
    refused shipped-boards.sh "$RED_MSG"$'\nPlanned-Red: shipped-boards.sh'
  reset; touch_detector shipped-boards.sh
  check "a Planned-Red trailer without the opt-in is refused" refused "" "$RED_MSG"
  reset; touch_detector shipped-boards.sh
  check "a Planned-Red trailer in the body, not the trailer block, is not a trailer" \
    attempt "" $'test: green\n\nPlanned-Red: shipped-boards.sh\n\nthis paragraph ends the message.'
  reset; touch_other
  check "an opt-in naming no self-tested detector is refused" \
    refused shipped-ai.sh $'test: x\n\nPlanned-Red: shipped-ai.sh'
  reset; touch_detector shipped-memory.sh; set_exit shipped-boards.sh self 1
  check "an opt-in naming a detector that is not staged is refused" refused shipped-boards.sh "$RED_MSG"
}

probe_enforced() {
  echo "enforced"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1; set_exit shipped-memory.sh self 1
  check "another self-test that fails still refuses the planned red" refused shipped-boards.sh "$RED_MSG"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1; set_exit shipped-readme.sh plain 1
  check "another plain check that fails still refuses it" refused shipped-boards.sh "$RED_MSG"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1; set_exit shipped-boards.sh plain 1
  check "the named script's own plain check that fails still refuses it" refused shipped-boards.sh "$RED_MSG"
  reset; touch_detector shipped-boards.sh; set_exit shipped-boards.sh self 1
  check "a red self-test without the opt-in refuses the commit" refused "" "test: unplanned red"
}

probe_ordinary() {
  echo "ordinary"
  reset; touch_other
  check "a commit staging no detector passes" attempt "" "docs: ordinary"
  check "  and runs no self-test" bash -c '! grep -q " self$" "$1/.fixture/calls"' _ "$FX"
  check "  but runs every plain check" bash -c '[[ $(grep -c " plain$" "$1/.fixture/calls") -eq 5 ]]' _ "$FX"
  reset; touch_detector shipped-readme.sh
  check "a green detector commit passes with every self-test run" attempt "" "test: green"
}

probe_wired() {
  echo "wired"
  check "lefthook.yml's pre-commit leg calls template-integrity.sh --pre-commit" \
    grep -qF 'bash .github/scripts/template-integrity.sh --pre-commit' "$LEFTHOOK"
  check "lefthook.yml's commit-msg leg calls template-integrity.sh --commit-msg {1}" \
    grep -qF 'bash .github/scripts/template-integrity.sh --commit-msg {1}' "$LEFTHOOK"
}

echo "planned-red.sh — fixture at $FX"
if [[ ! -f "$HOOK" ]]; then
  fail "there is no .github/scripts/template-integrity.sh to prove"
  probe_wired
elif ! build_fixture >/dev/null 2>&1; then
  fail "the fixture could not be built"
else
  probe_accepted
  probe_rejected
  probe_enforced
  probe_ordinary
  probe_wired
fi
echo ""
if [[ $FAILS -eq 0 ]]; then
  printf '\033[1m✓ planned-red.sh: %d probes passed\033[0m\n' "$PASSES"
  exit 0
fi
printf '\033[1m✗ planned-red.sh: %d of %d probes failed\033[0m\n' "$FAILS" "$((FAILS + PASSES))"
exit 1
