#!/usr/bin/env bash
# self-test-ledger.sh — Sourced, never run: the crash guard and the optional probe ledger the six
#                       self-tested detectors share.
#
# TEMPLATE-ONLY: .github/scripts/ is copier _exclude'd.
#
# Two duties, both inert unless a detector runs --self-test:
#
#   THE CRASH GUARD. st_arm traps ERR (with errtrace, so functions inherit it) and EXIT. A command
#   that would stop the script under `set -e`, an unbound variable, or any exit before st_finish
#   exits 2 — a script error — never 1, which is reserved for a probe that ran and failed, and
#   never 0. A failure inside a command substitution or subshell is left to its caller, as
#   `set -e` leaves it. template-integrity.sh's pre-push leg and CI both read exit 2 as a script
#   error, so a self-test that crashes can never read as a red probe or as a pass.
#
#   THE LEDGER. With SELF_TEST_LEDGER=<file> set, each probe appends one line,
#   `pass<TAB><label><TAB><line>` or `fail<TAB><label><TAB><line>`, and a self-test that reaches
#   its end appends `end<TAB><failed count>`. <line> is the line inside self_test() whose call
#   recorded it (0 outside self_test()). No hook reads it (21/11/2026: the planned-red allowance
#   that did was removed). It is a reviewer's record: run at a red probe's commit and at its fix,
#   two ledgers show the probe's label unchanged and its result gone fail to pass
#   (code/workflows/02-tdd-cycle/STEPS.md). No ledger file is written when the variable is unset.
#
# Usage, in a detector:
#   . "$SCRIPT_DIR/self-test-ledger.sh"
#   $SELF_TEST && st_arm [cleanup-function]   # before the self-test runs
#   st_record pass|fail "<label>"             # once per probe
#   self_test; st_finish "$ST_FAILS"          # exits 0 or 1, having written the end line
#
# Exit codes it imposes: 0 every probe passed  1 a probe failed  2 the self-test did not finish

ST_LEDGER="${SELF_TEST_LEDGER:-}"
ST_ENDED=false
ST_ON_EXIT=""

st_record() { # pass|fail LABEL
  local label="${2//[$'\t\n']/ }" i line=0
  # The probe's own line: the line inside self_test() whose call led here, however deep.
  for ((i = 1; i < ${#FUNCNAME[@]}; i++)); do
    if [[ "${FUNCNAME[$i]}" == self_test ]]; then line="${BASH_LINENO[$((i - 1))]}"; break; fi
  done
  if [[ -n "$ST_LEDGER" ]]; then printf '%s\t%s\t%s\n' "$1" "$label" "$line" >> "$ST_LEDGER"; fi
  return 0
}

st_finish() { # FAILED-COUNT — write the end line and exit 0 (none failed) or 1
  if [[ -n "$ST_LEDGER" ]]; then printf 'end\t%s\n' "$1" >> "$ST_LEDGER"; fi
  ST_ENDED=true
  if [[ "$1" -eq 0 ]]; then exit 0; fi
  exit 1
}

# shellcheck disable=SC2329  # invoked by the ERR trap st_arm sets
st__err() {
  [[ "${BASH_SUBSHELL:-0}" -eq 0 ]] || return 0
  printf 'self-test error: [%s] failed (line %s) — a script error, never a red probe\n' \
    "$BASH_COMMAND" "${BASH_LINENO[0]:-?}" >&2
  exit 2
}

# shellcheck disable=SC2329  # invoked by the EXIT trap st_arm sets
st__exit() {
  local rc=$?
  trap - ERR
  if [[ -n "$ST_ON_EXIT" ]]; then "$ST_ON_EXIT" || true; fi
  if ! $ST_ENDED; then
    printf 'self-test stopped before its end (exit %s) — a script error, never a red probe\n' "$rc" >&2
    exit 2
  fi
  exit "$rc"
}

st_arm() { # [CLEANUP-FUNCTION] — run on exit, ahead of the guard
  ST_ON_EXIT="${1:-}"
  set -o errtrace
  trap st__err ERR
  trap st__exit EXIT
}
