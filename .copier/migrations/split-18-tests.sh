#!/usr/bin/env bash
#
# split-18-tests.sh — move per-story test records left at the 18-TESTS/ root into the
#                     sub-folder each now belongs in.
#
# WHAT CHANGED (30/09/2026). project-management/src/18-TESTS/ held both per-story test
# records side by side at its root. It now splits by record type:
#
#   18-TESTS/US###-MANUAL-TESTING.md  ->  18-TESTS/MANUAL/US###-MANUAL-TESTING.md
#   18-TESTS/US###-TEST-STATUS.md     ->  18-TESTS/AUTOMATED/US###-TEST-STATUS.md
#
# Filenames are unchanged; only the folder moved.
#
# WHY. The two records stopped being written at the same moment by the same workflow. The
# manual testing guide is now authored from the specs at 17-story-plans, before any code
# exists, and walked at 22; the automated record is still written at 22, after the suites run.
# Two records with two authors and two rule sets each got a folder of their own. The argument
# is the UPDATED 30/09/2026 comment in project-management/src/18-TESTS/CLAUDE.md.
#
# WHY A MIGRATION IS NEEDED. Copier moves the two US000 templates it owns and deletes the old
# ones — but a developer's US### records were never template files, so `copier update` leaves
# them at the root. That is the v2.0.0 silent orphan again, with one difference that makes it
# worse: the 18-TESTS/ root keeps its CONTEXT.md, and `audits/template-orphans.sh` keys on a
# missing CONTEXT.md, so it cannot see a record stranded there. The first sign would be
# `tests/test-record.sh` refusing a root-level record, or a manual guide nobody can find.
#
# WHAT IT DOES. For each root-level US###-MANUAL-TESTING.md and US###-TEST-STATUS.md, moves the
# file into its sub-folder — only where the template has already rendered that sub-folder (its
# CONTEXT.md present), so a hand run against a tree that has not taken the split does nothing
# rather than guess. It never overwrites: a name already present in the sub-folder is reported
# for a human and left where it is. The US000 templates are never moved; a leftover root copy of
# one is reported, because the template now ships from the sub-folder. Anything else at the root
# is not a test record and is left alone.
#
# Idempotent: a second run finds nothing at the root and exits 0. A no-op, too, on a project
# with no records — which is why it can run ungated on every update while its version key is
# pending (copier.yml `_migrations`).
#
# Working directory is the project being updated.
#
# COLLISIONS NEVER FAIL THE UPDATE, for the reason v2.0.0-renumber-src.sh records in its own
# header: a non-zero exit aborts every migration declared after this one and leaves the project
# half-upgraded, which is worse than a collision this prints instructions for. Nor does a move
# that fails — a permission, a cross-device link: `set -e` would otherwise turn one failed `mv`
# into that same abort, so the move is guarded and a failure is reported like a collision, the
# record left where it was.
#
# Exit codes:  0 = always
#
set -euo pipefail

TESTS="project-management/src/18-TESTS"

[[ -d "$TESTS" ]] || exit 0

MOVED=0
COLLIDED=0
declare -a COLLISIONS=()
declare -a FAILED=()
declare -a LEFTOVER_TEMPLATES=()
declare -a NOT_SPLIT=()

printf '\n▸ 18-TESTS split — moving per-story test records into MANUAL/ and AUTOMATED/\n'

while IFS= read -r f; do
  name="${f##*/}"

  case "$name" in
    US000-MANUAL-TESTING.md | US000-TEST-STATUS.md)
      LEFTOVER_TEMPLATES+=("$TESTS/$name")
      continue
      ;;
  esac

  if [[ "$name" =~ ^US[0-9]{3,}-MANUAL-TESTING\.md$ ]]; then
    sub="MANUAL"
  elif [[ "$name" =~ ^US[0-9]{3,}-TEST-STATUS\.md$ ]]; then
    sub="AUTOMATED"
  else
    continue
  fi

  # The sub-folder is the template's to create. Without its CONTEXT.md the split has not
  # reached this tree, so there is nowhere correct to move to yet.
  if [[ ! -f "$TESTS/$sub/CONTEXT.md" ]]; then
    NOT_SPLIT+=("$TESTS/$name")
    continue
  fi

  dest="$TESTS/$sub/$name"
  if [[ -e "$dest" ]]; then
    # Never overwrite. A record present on both sides needs a human to reconcile.
    COLLISIONS+=("$TESTS/$name -> $dest")
    COLLIDED=$((COLLIDED + 1))
    continue
  fi

  if ! mv "$f" "$dest" 2>/dev/null; then
    FAILED+=("$TESTS/$name -> $dest")
    continue
  fi
  printf '  moved  18-TESTS/%s -> 18-TESTS/%s/%s\n' "$name" "$sub" "$name"
  MOVED=$((MOVED + 1))
done < <(find "$TESTS" -mindepth 1 -maxdepth 1 -type f -name 'US*.md' 2>/dev/null | sort)

if [[ $MOVED -eq 0 && $COLLIDED -eq 0 && ${#FAILED[@]} -eq 0 && ${#LEFTOVER_TEMPLATES[@]} -eq 0 && ${#NOT_SPLIT[@]} -eq 0 ]]; then
  printf '  nothing at the root — no records needed moving\n\n'
  exit 0
fi

[[ $MOVED -eq 0 ]] || printf '\n  %d record(s) moved into the 18-TESTS split.\n' "$MOVED"

if [[ $COLLIDED -gt 0 ]]; then
  printf '\n  %d record(s) could NOT be moved — a file of the same name already exists:\n\n' "$COLLIDED"
  for c in "${COLLISIONS[@]}"; do printf '    %s\n' "$c"; done
  printf '\n  Nothing was overwritten and the update was NOT interrupted. Merge each pair by\n'
  printf '  hand, delete the root copy, then re-run this script.\n'
fi

if [[ ${#FAILED[@]} -gt 0 ]]; then
  printf '\n  %d record(s) could NOT be moved — the move itself failed:\n\n' "${#FAILED[@]}"
  for m in "${FAILED[@]}"; do printf '    %s\n' "$m"; done
  printf '\n  Each is still at the root and the update was NOT interrupted. Check the file'"'"'s\n'
  printf '  permissions and the sub-folder'"'"'s, move it by hand, then re-run this script.\n'
fi

if [[ ${#NOT_SPLIT[@]} -gt 0 ]]; then
  printf '\n  %d record(s) left in place — this tree has no MANUAL/ or AUTOMATED/ yet:\n\n' "${#NOT_SPLIT[@]}"
  for n in "${NOT_SPLIT[@]}"; do printf '    %s\n' "$n"; done
  printf '\n  Update to a template that carries the split, then re-run this script.\n'
fi

if [[ ${#LEFTOVER_TEMPLATES[@]} -gt 0 ]]; then
  printf '\n  Template copies still at the root (the template now ships them from the sub-folders):\n\n'
  for t in "${LEFTOVER_TEMPLATES[@]}"; do printf '    %s\n' "$t"; done
  printf '\n  Not moved. Carry any local edit across to the sub-folder copy, then delete these.\n'
fi

[[ $MOVED -eq 0 ]] || printf '\n  Review with `git status`, then commit.\n'
printf '\n'
exit 0
