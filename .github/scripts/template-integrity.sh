#!/usr/bin/env bash
# template-integrity.sh — The template-integrity pre-commit leg and its planned-red allowance.
#
# TEMPLATE-ONLY: .github/scripts/ is copier _exclude'd, so a generated project never holds this
# file. lefthook.yml ships, and its two legs that call this script are self-gating on copier.yml
# (itself _exclude'd), so downstream they exit 0 before reaching it.
#
# --pre-commit is the cheap half of .github/workflows/audit-template.yml, pulled forward to the
# commit: the five detectors' plain checks, preceded by their --self-tests whenever a
# .github/scripts/*.sh is staged. Every result must be a pass — bar one, named in advance.
#
# THE PLANNED-RED ALLOWANCE. A probe is committed red ahead of the check it proves (code
# workflow 02-tdd-cycle). When the probe lives in a detector's own --self-test, the self-test leg
# would refuse that commit, so the red could never be recorded. The allowance is narrow:
#
#   PLANNED_RED=<basename>   the ONE detector whose --self-test is expected red, by its basename
#                            exactly as it sits in .github/scripts/ (e.g. shipped-boards.sh). It
#                            must be one of the five self-tested detectors, and it must be
#                            staged — the probe being committed lives in it.
#
#   For that detector the --self-test must exit 1 (a probe failed). A pass is refused — nothing
#   is red, so nothing is planned — and so is any other code, 2 above all: a script error is not
#   a red probe. Every other self-test, and every plain check including the named detector's
#   own, still runs and must pass.
#
#   The commit message must carry exactly one `Planned-Red: <basename>` trailer naming the same
#   detector, checked by --commit-msg; a Planned-Red trailer without the opt-in is refused too,
#   so the history never claims a planned red the hook did not see.
#
# There is no other bypass, and the allowance is not one: it changes which exit code one
# self-test must return, never whether it runs.
#
# Usage: template-integrity.sh --pre-commit | --commit-msg FILE | --help
#
# Requires: bash, git.
# Exit codes: 0 = pass  1 = refused (a check failed, or the allowance was misused)
#             2 = script error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DETECTORS=(check-template-tokens.sh shipped-readme.sh shipped-memory.sh shipped-registers.sh
           shipped-boards.sh)
PLANNED="${PLANNED_RED:-}"

die() { printf 'template-integrity: %s\n' "$*" >&2; exit 2; }
refuse() { printf '\033[31m✗ template-integrity:\033[0m %s\n' "$*" >&2; exit 1; }

is_detector() {
  local d
  for d in "${DETECTORS[@]}"; do [[ "$1" == "$d" ]] && return 0; done
  return 1
}

pre_commit() {
  cd "$PROJECT_ROOT"
  [[ -f copier.yml ]] || exit 0
  local staged d rc
  staged="$(git diff --cached --name-only)" || die "could not read the staged set"
  if [[ -n "$PLANNED" ]]; then
    is_detector "$PLANNED" \
      || refuse "PLANNED_RED=$PLANNED names no self-tested detector (one of: ${DETECTORS[*]})"
    grep -qxF ".github/scripts/$PLANNED" <<< "$staged" \
      || refuse "PLANNED_RED=$PLANNED is not staged — a planned red commits a probe in that detector"
  fi
  if grep -q '^\.github/scripts/.*\.sh$' <<< "$staged"; then
    for d in "${DETECTORS[@]}"; do
      rc=0
      bash ".github/scripts/$d" --self-test || rc=$?
      if [[ "$d" == "$PLANNED" ]]; then
        case "$rc" in
          1) printf '\033[33m▸ planned red — %s --self-test exited 1, as PLANNED_RED declares\033[0m\n' "$d" ;;
          0) refuse "PLANNED_RED=$d but its self-test passed — nothing is red, so nothing is planned" ;;
          *) refuse "PLANNED_RED=$d but its self-test exited $rc — a script error is not a planned red" ;;
        esac
      elif [[ $rc -ne 0 ]]; then
        refuse "$d --self-test exited $rc"
      fi
    done
  fi
  for d in "${DETECTORS[@]}"; do
    rc=0
    bash ".github/scripts/$d" || rc=$?
    [[ $rc -eq 0 ]] || refuse "$d exited $rc"
  done
}

commit_msg() {
  local file="$1" trailers n
  cd "$PROJECT_ROOT"
  [[ -f copier.yml ]] || exit 0
  [[ -f "$file" ]] || die "no commit message file at $file"
  trailers="$(git interpret-trailers --parse < "$file" | grep -i '^Planned-Red:' || true)"
  n=0; [[ -z "$trailers" ]] || n="$(grep -c . <<< "$trailers")"
  if [[ -z "$PLANNED" ]]; then
    [[ $n -eq 0 ]] || refuse "the message carries a Planned-Red trailer, but PLANNED_RED is not set — the hook saw no planned red"
    return 0
  fi
  [[ $n -eq 1 ]] || refuse "PLANNED_RED=$PLANNED needs exactly one 'Planned-Red: $PLANNED' trailer; the message carries $n"
  [[ "$(sed 's/^[^:]*:[[:space:]]*//; s/[[:space:]]*$//' <<< "$trailers")" == "$PLANNED" ]] \
    || refuse "the Planned-Red trailer names '${trailers#*:}', not $PLANNED"
}

case "${1:-}" in
  --pre-commit) pre_commit ;;
  --commit-msg) [[ -n "${2:-}" ]] || die "--commit-msg needs the message file"; commit_msg "$2" ;;
  --help|-h) sed -n '2,37p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' ;;
  *) die "usage: template-integrity.sh --pre-commit | --commit-msg FILE | --help" ;;
esac
