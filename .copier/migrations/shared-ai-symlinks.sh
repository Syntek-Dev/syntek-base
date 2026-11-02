#!/usr/bin/env bash
# Copier formerly dereferenced the three vendored skill aliases when generating.
# Its renderer cannot replace those materialised directories with symlinks. Before
# updating, convert only copies identical to the canonical .agents/skills trees.
# Validate every candidate first; a locally changed copy stops the update intact.
# Working directory: the project being updated. Safe to repeat after conversion.
set -euo pipefail

skills=(cloudinary-docs cloudinary-react cloudinary-transformations)
candidates=()

for skill in "${skills[@]}"; do
  legacy=".claude/skills/$skill"
  canonical=".agents/skills/$skill"
  [[ -L "$legacy" || ! -d "$legacy" ]] && continue

  if [[ -L "$canonical" || ! -d "$canonical" || "$legacy" -ef "$canonical" ]] \
    || ! diff -qr "$legacy" "$canonical" >/dev/null; then
    printf 'Cannot convert %s: no independent identical copy was verified at %s.\n' \
      "$legacy" "$canonical" >&2
    printf 'Compare both directories, preserve your changes in the canonical directory,\n' >&2
    printf 'and make both copies identical before rerunning copier update. No skill was changed.\n' >&2
    exit 1
  fi
  candidates+=("$skill")
done

for skill in "${candidates[@]}"; do
  # The canonical tree retains every file; only its verified duplicate is removed.
  rm -r -- ".claude/skills/$skill"
  ln -s "../../.agents/skills/$skill" ".claude/skills/$skill"
  printf 'Converted duplicate %s into its canonical skill alias.\n' "$skill"
done
