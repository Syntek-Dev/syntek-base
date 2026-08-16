#!/usr/bin/env bash
#
# v5.0.0-git-guide-split.sh — report citations aimed at a section that has moved.
#
# WHAT CHANGED IN THE TEMPLATE. Recording the required-check set took
# project-management/docs/GIT-GUIDE.md from 269 to 292 code lines and tripped the 270-line
# ratchet, so v5.0.0 split it: the guide is now a thin index, and its content lives in four
# sub-documents under project-management/docs/git/ — BRANCHES-AND-WORKTREES.md, COMMITS.md,
# PR-AND-REQUIRED-CHECKS.md and MIGRATION-GATES.md. Every H2 and H3 kept its wording
# character for character, because those headings are what citations name.
#
# WHY AN UPDATE CANNOT REPAIR EVERY CITATION. Copier replaces both files wholesale — they
# are template-owned, so the 31 citations INSIDE the template were repointed and travel
# down with the update. What it cannot reach is a citation YOUR project wrote: a link
# carrying an anchor onto that filename, or prose naming one of its sections. Neither
# breaks loudly. The path still resolves, because the index is still there; the anchor now
# points at a file whose headings have moved one level down, so the reader lands on a table
# of contents instead of on the text they were sent to read. `doc-references.sh` asks
# whether a cited path resolves and has no opinion on whether the section inside it still
# exists, so nothing in the project will report this.
#
# WHY THIS ADVISES RATHER THAN ACTS. Every other correct destination depends on which
# section was meant, and only the author of the sentence knows that. A script guessing
# between four sub-documents would rewrite a proportion of them wrongly, and a wrong
# citation that reads as deliberate is worse than one a person was asked to check.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v5.0.0. Safe to
# run by hand afterwards: it only reads.
#
# Working directory is the project being updated.
#
# Exit codes:  0 = always, findings or not. A migration that fails an update leaves the
#              project half-upgraded, which is worse than a citation this prints a list of.
#
set -euo pipefail

GUIDE="project-management/docs/GIT-GUIDE.md"

[[ -d project-management/docs ]] || exit 0

# Section-level only. A bare path citation still resolves and still lands somewhere useful,
# so flagging it would bury the ones that no longer do. Two shapes qualify: an anchor after
# the filename, and the word Section within a short distance of it.
HITS=$(grep -rIn --exclude-dir=.git \
  -e 'GIT-GUIDE\.md#' \
  -e 'GIT-GUIDE\.md[^#]\{0,40\}[Ss]ection' \
  -e '[Ss]ection[^#]\{0,40\}GIT-GUIDE\.md' \
  . 2>/dev/null | grep -v "^\./${GUIDE}:" || true)

[[ -n "$HITS" ]] || exit 0

COUNT=$(printf '%s\n' "$HITS" | wc -l | tr -d ' ')

printf '\n▸ v5.0.0 migration — %s is now an index over four sub-documents\n\n' "$GUIDE"
printf '  %s citation(s) in your own files name a SECTION of that guide. The path still\n' "$COUNT"
printf '  resolves, so nothing is broken and no check will report this — but the section\n'
printf '  named now lives one level down, and the reader lands on the index instead.\n\n'

printf '%s\n' "$HITS" | sed 's/^/      /'

printf '\n  Where each subject went:\n\n'
printf '      Worktree naming, the branch chain, the two prefixes\n'
printf '          -> project-management/docs/git/BRANCHES-AND-WORKTREES.md\n'
printf '      The pre-commit and pre-push gates, the message format\n'
printf '          -> project-management/docs/git/COMMITS.md\n'
printf '      Promotion order, required checks vs path filters, toolchain pins\n'
printf '          -> project-management/docs/git/PR-AND-REQUIRED-CHECKS.md\n'
printf '      The review gates and staging verification a migration earns\n'
printf '          -> project-management/docs/git/MIGRATION-GATES.md\n\n'
printf '  Every heading kept its exact wording, so an anchor that worked before works\n'
printf '  against the new file once the filename is repointed.\n\n'

exit 0
