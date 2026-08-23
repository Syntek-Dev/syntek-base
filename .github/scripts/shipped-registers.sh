#!/usr/bin/env bash
#
# shipped-registers.sh — Verify a generated project receives EMPTY standing registers.
#
#                       `GAPS.md` and `DEFERRED.md` are the two files an agent appends to
#                       unprompted as a project runs, and `.claude/CLAUDE.md` Section 9 has
#                       every session treat them as the project's own state. That makes them
#                       the same carrier problem `shipped-memory.sh` was written for: an
#                       entry about syntek-base's branch protection, or an internal epic's
#                       blocker, reads in a generated project as that project's live gap.
#
#                       Until 22/08/2026 they took the weaker treatment — they shipped, and
#                       were kept empty by hand. The discipline was prose-only and it had
#                       already failed inside a published tag: `git show v6.0.0:GAPS.md` is
#                       47 lines carrying this repository's own unreconciled-`main` entry,
#                       which a real `copier copy` handed to a generated project as its own
#                       active gap and a real `copier update` delivered as a merge conflict.
#
#                       Nine checks, three per register plus the wiring:
#                         1. copier.yml excludes /GAPS.md.
#                         2. copier.yml excludes /DEFERRED.md.
#                         3. _tasks seeds GAPS.md from .copier/GAPS.md on `copy`.
#                         4. _tasks seeds DEFERRED.md from .copier/DEFERRED.md on `copy`.
#                         5. Both seeds exist.
#                         6. The GAPS seed carries its `## Format` heading.
#                         7. The DEFERRED seed carries its add-a-row rule.
#                         8. The GAPS seed carries no entry.
#                         9. The DEFERRED seed carries no row.
#
#                       Exclusion and seed are a PAIR and neither is sufficient, which is
#                       the lesson `shipped-memory.sh` records: exclusion alone leaves a
#                       generated project with no register at all, while 88 shipped files, a
#                       shipped PreToolUse hook and a lefthook block message all route
#                       readers to them; a seed alone is ignored the moment the exclusion is
#                       dropped.
#
#                       Numbers are stable identifiers — other documents cite them.
#                       Append, never renumber.
#
#                       Why emptiness is GATED and not trusted: a seed cut from a polluted
#                       root is a one-way door. It ships that content to every project
#                       generated thereafter, and no `copier update` can take it back,
#                       because the exclusion that protects a project's own entries protects
#                       the inherited ones just as well.
#
#                       What it CANNOT check: an entry that is genuinely generic against one
#                       about syntek-base. Checks 8 and 9 ban both, because "no entries" is
#                       decidable and "no syntek-base entries" is not.
#
# SELF-TEST. --self-test mutates a copy of each input — adds an entry to each seed, removes
#            a heading, drops an _exclude row, drops a _tasks move — and asserts each check
#            catches its own. A guard nobody has seen fail is a guard nobody knows works.
#
# Requirements: git, grep, awk. No network.
#
# Usage: shipped-registers.sh [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = a generated project receives empty, correctly-seeded registers
#              1 = it does not, or the self-test no longer separates
#              2 = script error (bad arguments, or a self-test that could not run)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

GAPS_SEED="$PROJECT_ROOT/.copier/GAPS.md"
DEFERRED_SEED="$PROJECT_ROOT/.copier/DEFERRED.md"
COPIER="$PROJECT_ROOT/copier.yml"

# The paths as copier.yml writes them, and as _tasks lands them.
GAPS_PATH="/GAPS.md"
DEFERRED_PATH="/DEFERRED.md"
GAPS_SEED_REL=".copier/GAPS.md"
DEFERRED_SEED_REL=".copier/DEFERRED.md"
GAPS_LIVE_REL="GAPS.md"
DEFERRED_LIVE_REL="DEFERRED.md"

# One heading per register that proves the seed arrived as a canvas rather than a blank
# file. GAPS.md's `## Format` block is what an appending session copies; DEFERRED.md has no
# headings at all, so its add-a-row rule stands in for one.
GAPS_HEADING="## Format"
DEFERRED_RULE="**Add a row when:**"

QUIET=false
SELF_TEST=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'shipped-registers.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
shipped-registers.sh — Verify a generated project receives empty standing registers

Usage: shipped-registers.sh [--quiet] [--self-test] [--help]

  --quiet      Suppress progress output; print findings only
  --self-test  Prove the checks still fire: mutate a copy of each input and assert
               each one is caught
  --help       Show this message

Exit codes: 0 = both seeds are empty and wired  1 = drift found, or the self-test no
longer separates  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT"
[[ -f "$COPIER" ]] || die "missing $COPIER"

FINDINGS=()
finding() { FINDINGS+=("$1"); }

# ── The checks, as one re-pointable unit ──────────────────────────────────────
#
# Every input is read through a global so --self-test can repoint it at a mutated copy and
# re-run the whole set, rather than re-implementing the checks against a fixture that would
# then drift from them.
run_checks() {
  FINDINGS=()

  # ── 1 and 2. copier.yml excludes both live files ────────────────────────────
  #
  # The same block parse shipped-memory.sh and the shipped-README check use: the _exclude
  # list ends at the next top-level key, and `_tasks:` matches that pattern too. Note the
  # parse is exact-line, so an _exclude entry carrying a TRAILING COMMENT is invisible to
  # it — keep the commentary above the entry, never beside it.
  local excluded
  excluded=$(awk '/^_exclude:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f && /^[[:space:]]*-/' "$COPIER" \
    | sed 's/^[[:space:]]*-[[:space:]]*//' | sed 's/^"//;s/"$//' || true)
  grep -qxF "$GAPS_PATH" <<< "$excluded" \
    || finding "copier.yml _exclude does not list $GAPS_PATH — syntek-base's own gaps ship"
  grep -qxF "$DEFERRED_PATH" <<< "$excluded" \
    || finding "copier.yml _exclude does not list $DEFERRED_PATH — syntek-base's own deferrals ship"

  # ── 3 and 4. _tasks seeds both ──────────────────────────────────────────────
  #
  # Without these an excluded register simply never arrives, and every rule routing a
  # reader to it points at nothing — a quieter failure than the one being fixed.
  local tasks
  tasks=$(awk '/^_tasks:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f' "$COPIER" || true)
  grep -qF "mv $GAPS_SEED_REL $GAPS_LIVE_REL" <<< "$tasks" \
    || finding "copier.yml _tasks does not move $GAPS_SEED_REL into $GAPS_LIVE_REL — a generated project gets no gaps register"
  grep -qF "mv $DEFERRED_SEED_REL $DEFERRED_LIVE_REL" <<< "$tasks" \
    || finding "copier.yml _tasks does not move $DEFERRED_SEED_REL into $DEFERRED_LIVE_REL — a generated project gets no deferred register"

  # ── 5. Both seeds exist ─────────────────────────────────────────────────────
  local gaps_readable=true deferred_readable=true
  if [[ ! -f "$GAPS_SEED" ]]; then
    finding "missing $GAPS_SEED_REL — nothing to seed a generated project's gaps register with"
    gaps_readable=false
  fi
  if [[ ! -f "$DEFERRED_SEED" ]]; then
    finding "missing $DEFERRED_SEED_REL — nothing to seed a generated project's deferred register with"
    deferred_readable=false
  fi

  # ── 6 and 8. The GAPS seed: its canvas, and its emptiness ───────────────────
  if $gaps_readable; then
    grep -qxF "$GAPS_HEADING" "$GAPS_SEED" \
      || finding "$GAPS_SEED_REL omits the '$GAPS_HEADING' heading — it must arrive as a canvas, not a blank file"

    # An entry is a dated H2, which is the shape the Format block asks for and every real
    # entry has used. The Format block's own exemplar is that same shape inside a fenced
    # code block, so the fence must be tracked rather than the line matched: a grep would
    # report the seed's instructions as its contents.
    local gaps_entries
    gaps_entries=$(awk '/^```/{f=!f; next} !f && /^## [0-9]{2}\/[0-9]{2}\/[0-9]{4}/' "$GAPS_SEED" || true)
    if [[ -n "$gaps_entries" ]]; then
      while read -r e; do
        [[ -z "$e" ]] && continue
        finding "$GAPS_SEED_REL carries an entry: ${e#\#\# } — a generated project must start empty"
      done <<< "$gaps_entries"
    fi
  fi

  # ── 7 and 9. The DEFERRED seed: its rule, and its emptiness ─────────────────
  if $deferred_readable; then
    grep -qF "$DEFERRED_RULE" "$DEFERRED_SEED" \
      || finding "$DEFERRED_SEED_REL omits its '$DEFERRED_RULE' rule — it must arrive carrying the rule for writing to it"

    # A row is a table row whose first cell names a story. The preamble's own prose names
    # the `DEFERRED (US###)` marker without ever opening a table, so matching the row shape
    # rather than the token keeps the instructions out of the finding.
    local deferred_rows
    deferred_rows=$(grep -E '^\|[[:space:]]*(\[)?US[0-9]' "$DEFERRED_SEED" || true)
    if [[ -n "$deferred_rows" ]]; then
      while read -r r; do
        [[ -z "$r" ]] && continue
        finding "$DEFERRED_SEED_REL carries a row: $(printf '%s' "$r" | cut -c1-60) — a generated project must start empty"
      done <<< "$deferred_rows"
    fi
  fi
}

# ── Self-test ─────────────────────────────────────────────────────────────────
#
# The known-negative is the real set of inputs; each known-positive is one of them with a
# single targeted mutation. Every probe asserts exactly one finding, so a check that fires
# for the wrong reason fails the proof as loudly as one that never fires.
ST_FAILS=0
ST_PROBES=0

probe() { # $1 = label, $2 = a substring the single expected finding must contain
  ST_PROBES=$((ST_PROBES + 1))
  run_checks
  if [[ ${#FINDINGS[@]} -eq 1 ]] && [[ "${FINDINGS[0]}" == *"$2"* ]]; then
    log "  ✓ $1"
  else
    ST_FAILS=$((ST_FAILS + 1))
    printf '\033[31m  ✗ %s produced %d finding(s): %s\033[0m\n' \
      "$1" "${#FINDINGS[@]}" "$(printf '%s; ' "${FINDINGS[@]:-(none)}")"
  fi
}

self_test() {
  local tmpdir real_gaps real_deferred real_copier

  bold "▸ shipped-registers.sh --self-test"
  log  ""
  command -v mktemp >/dev/null 2>&1 || die "mktemp unavailable — refusing to report a proof that never ran"

  real_gaps="$GAPS_SEED"; real_deferred="$DEFERRED_SEED"; real_copier="$COPIER"
  tmpdir=$(mktemp -d) || die "could not create a temporary directory"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmpdir'; GAPS_SEED='$real_gaps'; DEFERRED_SEED='$real_deferred'; COPIER='$real_copier'" RETURN

  # ── The known-negative: the real inputs must trip nothing ───────────────────
  run_checks
  if [[ ${#FINDINGS[@]} -ne 0 ]]; then
    printf '\033[31m  ✗ the real inputs already fail — a mutation proof on a broken baseline means nothing\033[0m\n' >&2
    printf '    %s\n' "${FINDINGS[@]}" >&2
    exit 2
  fi
  log "  ✓ the real inputs pass — the baseline is clean"

  # ── 1. Drop the GAPS _exclude row ───────────────────────────────────────────
  grep -vxF "  - $GAPS_PATH" "$real_copier" > "$tmpdir/no-gaps-exclude.yml"
  COPIER="$tmpdir/no-gaps-exclude.yml"; probe "check 1 fires when the GAPS _exclude row is dropped" "_exclude does not list $GAPS_PATH"
  COPIER="$real_copier"

  # ── 2. Drop the DEFERRED _exclude row ───────────────────────────────────────
  grep -vxF "  - $DEFERRED_PATH" "$real_copier" > "$tmpdir/no-def-exclude.yml"
  COPIER="$tmpdir/no-def-exclude.yml"; probe "check 2 fires when the DEFERRED _exclude row is dropped" "_exclude does not list $DEFERRED_PATH"
  COPIER="$real_copier"

  # ── 3. Drop the GAPS _tasks move ────────────────────────────────────────────
  grep -vF "mv $GAPS_SEED_REL $GAPS_LIVE_REL" "$real_copier" > "$tmpdir/no-gaps-task.yml"
  COPIER="$tmpdir/no-gaps-task.yml"; probe "check 3 fires when the GAPS _tasks move is dropped" "_tasks does not move $GAPS_SEED_REL"
  COPIER="$real_copier"

  # ── 4. Drop the DEFERRED _tasks move ────────────────────────────────────────
  grep -vF "mv $DEFERRED_SEED_REL $DEFERRED_LIVE_REL" "$real_copier" > "$tmpdir/no-def-task.yml"
  COPIER="$tmpdir/no-def-task.yml"; probe "check 4 fires when the DEFERRED _tasks move is dropped" "_tasks does not move $DEFERRED_SEED_REL"
  COPIER="$real_copier"

  # ── 5. Remove a seed ────────────────────────────────────────────────────────
  GAPS_SEED="$tmpdir/absent.md"; probe "check 5 fires when a seed is missing" "missing $GAPS_SEED_REL"
  GAPS_SEED="$real_gaps"

  # ── 6. Remove the GAPS canvas heading ───────────────────────────────────────
  grep -vxF "$GAPS_HEADING" "$real_gaps" > "$tmpdir/no-heading.md"
  GAPS_SEED="$tmpdir/no-heading.md"; probe "check 6 fires when the GAPS Format heading is removed" "omits the '$GAPS_HEADING' heading"
  GAPS_SEED="$real_gaps"

  # ── 7. Remove the DEFERRED rule ─────────────────────────────────────────────
  grep -vF "$DEFERRED_RULE" "$real_deferred" > "$tmpdir/no-rule.md"
  DEFERRED_SEED="$tmpdir/no-rule.md"; probe "check 7 fires when the DEFERRED add-a-row rule is removed" "omits its '$DEFERRED_RULE' rule"
  DEFERRED_SEED="$real_deferred"

  # ── 8. Add a GAPS entry ─────────────────────────────────────────────────────
  #
  # Shaped like the one v6.0.0 actually shipped, because that is the failure being gated.
  { cat "$real_gaps"; printf '\n## 01/01/2030 — `main` has not been reconciled\n\n**Type:** Active gap\n'; } > "$tmpdir/an-entry.md"
  GAPS_SEED="$tmpdir/an-entry.md"; probe "check 8 fires when a GAPS entry is added" "carries an entry: 01/01/2030"
  GAPS_SEED="$real_gaps"

  # ── 9. Add a DEFERRED row ───────────────────────────────────────────────────
  { cat "$real_deferred"; printf '\n| US042 | Rate limiting | US099 |\n'; } > "$tmpdir/a-row.md"
  DEFERRED_SEED="$tmpdir/a-row.md"; probe "check 9 fires when a DEFERRED row is added" "carries a row:"
  DEFERRED_SEED="$real_deferred"

  # Leave the globals holding the real inputs so nothing downstream inherits a
  # deliberately broken one.
  run_checks

  log ""
  if [[ "$ST_FAILS" -eq 0 ]]; then
    bold "✓ Self-test passed — $ST_PROBES probes: every check fires on its own mutation."
    log ""
    return 0
  fi
  log "  the detector no longer separates a clean seed from a polluted one —"
  log "  fix the check, never the expectation."
  log ""
  return 1
}

if $SELF_TEST; then
  self_test
  exit $?
fi

bold "▸ shipped-registers.sh"
log  "  checking the standing registers a generated project receives…"
log  ""

run_checks

if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ A generated project receives empty, correctly-seeded standing registers."
  exit 0
fi

bold "✗ ${#FINDINGS[@]} finding(s):"
printf '  · %s\n' "${FINDINGS[@]}"
log ""
log "  .copier/GAPS.md and .copier/DEFERRED.md are the registers a generated project"
log "  receives — each must carry its writing rules and NO entries. syntek-base's own"
log "  registers are the root GAPS.md and DEFERRED.md, which copier.yml excludes."
exit 1
