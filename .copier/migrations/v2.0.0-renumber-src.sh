#!/usr/bin/env bash
#
# v2.0.0-renumber-src.sh — rescue artefacts stranded by the 2.0.0 renumbering.
#
# Template v2.0.0 shifted every project-management/src/NN-…/ folder up by one to
# open 01 for the feature-discovery gate. Copier moves the scaffolding it owns to
# the new path and deletes the old — but a developer's stories, ADRs and sprint
# records were never template files, so `copier update` leaves them behind in a
# folder nothing references any more. No conflict, no error, update reports
# success. This moves them across.
#
# Runs automatically as a copier `_migrations` entry when an update crosses
# v2.0.0. Safe to run by hand afterwards; it is idempotent.
#
# Working directory is the project being updated.
#
# COLLISIONS NEVER FAIL THE UPDATE (23/08/2026). This exited 1 on a collision until a real
# v2.3.1 -> v7.4.0 update hit one, and the cost was measured rather than argued: Copier had
# left two of its OWN files at the old path, the move found them already present at the new
# one, and the non-zero exit aborted every migration declared after this — including
# v4.0.0-manifest-name.sh, so the project was left claiming the template's package name with
# a lockfile already resolved under it, half-upgraded and reporting failure at the one point
# where nothing can be retried. A half-upgraded project is worse than a collision this prints
# instructions for; that is the rule v4.0.0-manifest-name.sh already states in its own header.
# Nothing is overwritten either way, and `audits/template-orphans.sh` is the backstop that
# reports whatever is left behind at the old path.
#
# Exit codes:  0 = always
#
set -euo pipefail

SRC="project-management/src"

# Old name -> new name, for every folder v2.0.0 shifted. Order does not matter:
# each old directory is distinct from every new one, so no move can cascade.
MAP="
01-STORIES:02-STORIES
02-SPRINTS:03-SPRINTS
03-DATABASE:04-DATABASE
04-USER-FLOW:05-USER-FLOW
05-BRAND-GUIDE:06-BRAND-GUIDE
06-COMPONENTS:07-COMPONENTS
07-WIREFRAMES:08-WIREFRAMES
08-GDPR:09-GDPR
09-SECURITY:10-SECURITY
10-QA:11-QA
11-SEO:12-SEO
12-API-DESIGN:13-API-DESIGN
13-DECISIONS:15-DECISIONS
14-SPRINT-PLANS:16-SPRINT-PLANS
15-STORY-PLANS:17-STORY-PLANS
16-TESTS:18-TESTS
17-REVIEWS:19-REVIEWS
18-FINDINGS:20-FINDINGS
19-BUGS:21-BUGS
20-REFACTORING:22-REFACTORING
"

[[ -d "$SRC" ]] || exit 0

MOVED=0
COLLIDED=0
declare -a COLLISIONS=()

printf '\n▸ v2.0.0 migration — rescuing artefacts from the src/ renumbering\n'

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

printf '\n  %d file(s) moved into the v2.0.0 numbering.\n' "$MOVED"

if [[ $COLLIDED -gt 0 ]]; then
  printf '\n  %d file(s) could NOT be moved — a file of the same name already exists:\n\n' "$COLLIDED"
  for c in "${COLLISIONS[@]}"; do printf '    %s\n' "$c"; done
  printf '\n  Nothing was overwritten and the update was NOT interrupted. Reconcile these\n'
  printf '  by hand, then re-run:\n'
  printf '    bash code/src/scripts/audits/template-orphans.sh\n\n'
  exit 0
fi

printf '  Review with `git status`, then commit.\n\n'
exit 0
