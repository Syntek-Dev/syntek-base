#!/usr/bin/env bash
# precommit-clickup.sh — lefthook pre-commit guard for the ClickUp story export.
#
# Enforces the invariant: project-management/export/clickup/US###-CLIENT.md is ALWAYS
# the canonical output of export-clickup-stories.sh. Runs on every commit but exits
# immediately unless a source story or a generated client file is staged.
#
# Behaviour when triggered:
#   1. Regenerate every US###-CLIENT.md from the source stories in 01-STORIES/.
#   2. Re-stage the regenerated files.
# Any hand-edit to a generated file is therefore overwritten by canonical output
# before it can be committed — the source story is the only way to change them.
#
# Exit codes: 0 = nothing to do OR regenerated successfully  1 = generation failed
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
GEN="$ROOT/project-management/src/00-ASSETS/scripts/export-clickup-stories.sh"

# Staged files added/copied/modified this commit.
staged="$(git diff --cached --name-only --diff-filter=ACM || true)"

# Trigger only when a source story or a generated client file is part of the commit.
relevant="$(printf '%s\n' "$staged" | grep -E \
  '^project-management/(src/01-STORIES/US[0-9]+\.md|export/clickup/US[0-9]+-CLIENT\.md)$' || true)"

[[ -z "$relevant" ]] && exit 0

bash "$GEN" >/dev/null

# Re-stage the canonical output (generated files only — never the README).
cd "$ROOT"
git add -- project-management/export/clickup/*-CLIENT.md 2>/dev/null || true

echo "clickup: regenerated client exports from source stories (generated files are read-only — edit 01-STORIES/ to change them)"
