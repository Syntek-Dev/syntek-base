#!/usr/bin/env bash
#
# v7.0.0-renumber-src.sh — rescue artefacts stranded by the 7.0.0 renumbering.
#
# Template v7.0.0 shifted project-management/src/14-DECISIONS/ and everything after
# it up by one, to open 14 for the new 14-LOGGING artefact folder that the new
# 14-logging-checks gate writes into. Copier moves the scaffolding it owns to the
# new path and deletes the old — but a developer's ADRs, sprint plans, story plans,
# test records, reviews, findings, bugs, refactoring notes and incident register
# were never template files, so `copier update` leaves them behind in a folder
# nothing references any more. No conflict, no error, update reports success.
# This moves them across.
#
# This is the SECOND deliberate exercise of the exception to the frozen-numbering
# rule (project-management/src/CONTEXT.md → "The numbers here are frozen"): a
# release may renumber this tree only if it ships a migration in the same commit.
# v2.0.0 was the first.
#
# Runs automatically as a copier `_migrations` entry when an update crosses
# v7.0.0. Safe to run by hand afterwards; it is idempotent.
#
# Working directory is the project being updated.
#
# Exit codes:  0 = nothing to do, or moved cleanly   1 = collisions left for a human
#
set -euo pipefail

SRC="project-management/src"

# Old name -> new name, for every folder v7.0.0 shifted. Order does not matter:
# each old directory is distinct from every new one, so no move can cascade.
MAP="
14-DECISIONS:15-DECISIONS
15-SPRINT-PLANS:16-SPRINT-PLANS
16-STORY-PLANS:17-STORY-PLANS
17-TESTS:18-TESTS
18-REVIEWS:19-REVIEWS
19-FINDINGS:20-FINDINGS
20-BUGS:21-BUGS
21-REFACTORING:22-REFACTORING
22-INCIDENTS:23-INCIDENTS
"

[[ -d "$SRC" ]] || exit 0

MOVED=0
COLLIDED=0
declare -a COLLISIONS=()

printf '\n▸ v7.0.0 migration — rescuing artefacts from the src/ renumbering\n'

while IFS=: read -r old new; do
  [[ -n "$old" ]] || continue
  [[ -d "$SRC/$old" ]] || continue

  # A directory the template still owns carries a CONTEXT.md. If this one has one,
  # the rename never happened here — leave it alone rather than guess.
  if [[ -f "$SRC/$old/CONTEXT.md" ]]; then
    continue
  fi

  mkdir -p "$SRC/$new"

  # Move everything left behind, at any depth, preserving the sub-path so a file
  # in PLANNING/ lands in PLANNING/ rather than at the folder root.
  while IFS= read -r f; do
    rel="${f#"$SRC/$old"/}"
    dest="$SRC/$new/$rel"

    if [[ -e "$dest" ]]; then
      # Never overwrite. A name present on both sides needs a human.
      COLLISIONS+=("$SRC/$old/$rel -> $dest")
      COLLIDED=$((COLLIDED + 1))
      continue
    fi

    mkdir -p "$(dirname "$dest")"
    mv "$f" "$dest"
    printf '  moved  %s -> %s\n' "$old/$rel" "$new/$rel"
    MOVED=$((MOVED + 1))
  done < <(find "$SRC/$old" -type f 2>/dev/null | sort)

  # Drop the husk if nothing is left in it.
  find "$SRC/$old" -type d -empty -delete 2>/dev/null || true
done <<< "$MAP"

if [[ $MOVED -eq 0 && $COLLIDED -eq 0 ]]; then
  printf '  nothing stranded — no artefacts needed moving\n\n'
  exit 0
fi

printf '\n  %d file(s) moved into the v7.0.0 numbering.\n' "$MOVED"

if [[ $COLLIDED -gt 0 ]]; then
  printf '\n  %d file(s) could NOT be moved — a file of the same name already exists:\n\n' "$COLLIDED"
  for c in "${COLLISIONS[@]}"; do printf '    %s\n' "$c"; done
  printf '\n  Nothing was overwritten. Reconcile these by hand, then re-run:\n'
  printf '    bash code/src/scripts/audits/template-orphans.sh\n\n'
  exit 1
fi

printf '  Review with `git status`, then commit.\n\n'
exit 0
