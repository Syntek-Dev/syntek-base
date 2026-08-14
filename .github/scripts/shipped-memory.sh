#!/usr/bin/env bash
#
# shipped-memory.sh — Verify a generated project receives an EMPTY project-memory store.
#
#                     `.claude/MEMORY.md` is the one shipped file an agent writes to
#                     unprompted, and `.claude/CLAUDE.md` §2.1 has every session read it
#                     second — before the work, ahead of any docs. That combination makes
#                     it the worst possible carrier for syntek-base's own memory: entries
#                     about this repo's .gitignore overrides, which account may bypass
#                     branch protection, or what an internal epic found are meaningless
#                     in a generated project, and are read there as authoritative.
#
#                     It shipped that way. Eleven entries of the template's own
#                     development reached every generated project, and nothing failed —
#                     no consumer of this file exists that CAN fail, which is precisely
#                     the gap these checks fill.
#
#                     Five checks:
#                       1. copier.yml excludes /.claude/MEMORY.md.
#                       2. _tasks seeds it from .copier/MEMORY.md on `copy`.
#                       3. The seed exists.
#                       4. The seed carries all three section headings.
#                       5. The seed carries no entries.
#
#                     1 and 2 are a pair and neither is sufficient. Exclusion alone
#                     leaves a generated project with NO memory file at all, breaking the
#                     §2.1 read order — a quieter failure than the one being fixed. A
#                     seed alone is ignored the moment the exclusion is dropped, which is
#                     the exact regression that produced this script.
#
#                     Numbers are stable identifiers — other documents cite them.
#                     Append, never renumber.
#
#                     What it CANNOT check: an entry that is genuinely generic and
#                     belongs in the seed, versus one about syntek-base. Check 5 bans
#                     both, because "no entries" is decidable and "no syntek-base
#                     entries" is not. Doctrine every project needs belongs in a
#                     `docs/` guide that owns it, never in a memory store.
#
# SELF-TEST. --self-test mutates a copy of each input — adds an entry to the seed,
#            removes a heading, drops the _exclude row, drops the _tasks move — and
#            asserts each check catches its own. A guard nobody has seen fail is a
#            guard nobody knows works.
#
# Requirements: git, grep, awk. No network.
#
# Usage: shipped-memory.sh [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = a generated project receives an empty memory store
#              1 = it does not, or the self-test no longer separates
#              2 = script error (bad arguments, or a self-test that could not run)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

SEED="$PROJECT_ROOT/.copier/MEMORY.md"
COPIER="$PROJECT_ROOT/copier.yml"

# The path as copier.yml writes it, and as _tasks lands it.
MEMORY_PATH="/.claude/MEMORY.md"
SEED_REL=".copier/MEMORY.md"
LIVE_REL=".claude/MEMORY.md"

# Every heading the seed must carry, so it arrives as a canvas rather than a blank file.
SECTIONS=("## Feedback" "## Project Patterns" "## Project State")

QUIET=false
SELF_TEST=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'shipped-memory.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
shipped-memory.sh — Verify a generated project receives an empty project-memory store

Usage: shipped-memory.sh [--quiet] [--self-test] [--help]

  --quiet      Suppress progress output; print findings only
  --self-test  Prove the checks still fire: mutate a copy of each input and assert
               each one is caught
  --help       Show this message

Exit codes: 0 = seed is empty and wired  1 = drift found, or the self-test no longer
separates  2 = script error
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
# Both inputs are read through globals so --self-test can repoint them at mutated
# copies and re-run the whole set, rather than re-implementing the checks against a
# fixture that would drift from them.
run_checks() {
  FINDINGS=()

  # ── 1. copier.yml excludes the live file ────────────────────────────────────
  #
  # Same block parse shipped-readme.sh uses: the _exclude list ends at the next
  # top-level key, and `_tasks:` matches that pattern too.
  local excluded
  excluded=$(awk '/^_exclude:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f && /^[[:space:]]*-/' "$COPIER" \
    | sed 's/^[[:space:]]*-[[:space:]]*//' | sed 's/^"//;s/"$//' || true)
  grep -qxF "$MEMORY_PATH" <<< "$excluded" \
    || finding "copier.yml _exclude does not list $MEMORY_PATH — the template's own memory ships"

  # ── 2. _tasks seeds it ──────────────────────────────────────────────────────
  #
  # Without this an excluded MEMORY.md simply never arrives, and §2.1's read-second
  # instruction points at nothing.
  local tasks
  tasks=$(awk '/^_tasks:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f' "$COPIER" || true)
  grep -qF "mv $SEED_REL $LIVE_REL" <<< "$tasks" \
    || finding "copier.yml _tasks does not move $SEED_REL into $LIVE_REL — a generated project gets no memory file"

  # ── 3. The seed exists ──────────────────────────────────────────────────────
  if [[ ! -f "$SEED" ]]; then
    finding "missing $SEED_REL — nothing to seed a generated project with"
    return 0   # 4 and 5 have nothing to read
  fi

  # ── 4. The seed carries every section heading ───────────────────────────────
  local s
  for s in "${SECTIONS[@]}"; do
    grep -qxF "$s" "$SEED" || finding "$SEED_REL omits the '$s' heading — it must arrive as a canvas, not a blank file"
  done

  # ── 5. The seed carries no entries ──────────────────────────────────────────
  #
  # An entry is an H3 under a section, which is the shape the preamble asks for and
  # every real entry has used. Reported with the offending titles: "the seed is not
  # empty" sends a reader looking, and the titles say what to delete.
  local entries
  entries=$(grep -E '^### ' "$SEED" || true)
  if [[ -n "$entries" ]]; then
    while read -r e; do
      [[ -z "$e" ]] && continue
      finding "$SEED_REL carries an entry: ${e#\#\#\# } — a generated project must start empty"
    done <<< "$entries"
  fi
}

# ── Self-test ─────────────────────────────────────────────────────────────────
#
# The known-negative is the real pair of inputs; each known-positive is one of them
# with a single targeted mutation. Every probe asserts exactly one finding, so a check
# that fires for the wrong reason fails the proof as loudly as one that never fires.
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
  local tmpdir real_seed real_copier

  bold "▸ shipped-memory.sh --self-test"
  log  ""
  command -v mktemp >/dev/null 2>&1 || die "mktemp unavailable — refusing to report a proof that never ran"

  real_seed="$SEED"; real_copier="$COPIER"
  tmpdir=$(mktemp -d) || die "could not create a temporary directory"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmpdir'; SEED='$real_seed'; COPIER='$real_copier'" RETURN

  # ── The known-negative: the real inputs must trip nothing ───────────────────
  run_checks
  if [[ ${#FINDINGS[@]} -ne 0 ]]; then
    printf '\033[31m  ✗ the real inputs already fail — a mutation proof on a broken baseline means nothing\033[0m\n' >&2
    printf '    %s\n' "${FINDINGS[@]}" >&2
    exit 2
  fi
  log "  ✓ the real inputs pass — the baseline is clean"

  # ── 1. Drop the _exclude row ────────────────────────────────────────────────
  grep -vxF "  - $MEMORY_PATH" "$real_copier" > "$tmpdir/no-exclude.yml"
  COPIER="$tmpdir/no-exclude.yml"; probe "check 1 fires when the _exclude row is dropped" "_exclude does not list"
  COPIER="$real_copier"

  # ── 2. Drop the _tasks move ─────────────────────────────────────────────────
  grep -vF "mv $SEED_REL $LIVE_REL" "$real_copier" > "$tmpdir/no-task.yml"
  COPIER="$tmpdir/no-task.yml"; probe "check 2 fires when the _tasks move is dropped" "_tasks does not move"
  COPIER="$real_copier"

  # ── 3. Remove the seed ──────────────────────────────────────────────────────
  SEED="$tmpdir/absent.md"; probe "check 3 fires when the seed is missing" "missing $SEED_REL"
  SEED="$real_seed"

  # ── 4. Remove a heading ─────────────────────────────────────────────────────
  grep -vxF "${SECTIONS[0]}" "$real_seed" > "$tmpdir/no-heading.md"
  SEED="$tmpdir/no-heading.md"; probe "check 4 fires when a section heading is removed" "omits the '${SECTIONS[0]}' heading"
  SEED="$real_seed"

  # ── 5. Add an entry ─────────────────────────────────────────────────────────
  #
  # Shaped like a real one, because that is what a future session would append.
  { cat "$real_seed"; printf '\n### Sam prefers tabs — 01/01/2030\n\nHe does not.\n'; } > "$tmpdir/an-entry.md"
  SEED="$tmpdir/an-entry.md"; probe "check 5 fires when an entry is added" "carries an entry: Sam prefers tabs"
  SEED="$real_seed"

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

bold "▸ shipped-memory.sh"
log  "  checking the project-memory store a generated project receives…"
log  ""

run_checks

if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ A generated project receives an empty, correctly-seeded memory store."
  exit 0
fi

bold "✗ ${#FINDINGS[@]} finding(s):"
printf '  · %s\n' "${FINDINGS[@]}"
log ""
log "  .copier/MEMORY.md is the memory store a generated project receives — it must carry"
log "  the headings and the writing rules and NO entries. syntek-base's own memory lives"
log "  in .claude/MEMORY.md, which copier.yml excludes."
exit 1
