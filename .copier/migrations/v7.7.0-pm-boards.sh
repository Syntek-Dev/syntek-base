#!/usr/bin/env bash
#
# v7.7.0-pm-boards.sh — give an updated project the five PM boards and the blank cut plan, and
#                       carry its status lines onto the 7.7.0 vocabulary.
#
# WHAT CHANGED (31/10/2026). 7.7.0 adds a generated kanban board to each of the five register
# folders (01-FEATURE-MAPS, 02-STORIES, 03-SPRINTS, 16-SPRINT-PLANS, 17-STORY-PLANS), a CI
# job that fails when a committed *-BOARD.md is stale or missing (pm-board.sh --check), and a
# fixed status vocabulary per register, owned by the `completion` skill.
#
# WHY A MIGRATION IS NEEDED. The boards are seeded from .copier/ by a _task gated to `copy`, so
# `copier update` never delivers them — while it DOES deliver the CI job and the lefthook leg
# that expect them. Without this, an updated project's first CI run fails with five "missing"
# boards. And statuses written under the older vocabulary land in the board's Unrecognised
# column with a warning. The blank CUT-PLAN.md is seeded by the same copy-gated _task, so an
# updated project would otherwise never get the register its first cut writes to.
#
# WHAT IT DOES.
#   1. Renames four retired status values, on the status line only, where the new value is
#      exactly the old one re-cased or re-ordered — one correct answer, so a machine does it:
#        stories  `Accepted Customer`  -> `Customer Accepted`
#                 `Rejected Customer`  -> `Customer Rejected`
#        sprints  `In progress`        -> `In Progress`
#        maps     `Blockers clear ...` -> `Blockers Clear` (the old trailing prose kept as a
#                                         `**Status note:**`-style note after ` — `)
#   2. Writes project-management/src/02-STORIES/CUT-PLAN.md from the template's
#      .copier/CUT-PLAN.md (found beside this script, which runs from the template source) —
#      ONLY when the project has none; an existing cut plan is never touched. The seed is
#      unrendered there, so its two tokens are rendered here from .copier-answers.yml: DATE
#      as the project's own DATE answer (today's date, DD/MM/YYYY, when that is absent or not
#      in that shape), DEVELOPER_NAME as answered. No name there leaves a visible `TBD`
#      placeholder and a warning, never a raw token.
#   3. Runs `pm-board.sh --write`, so the five boards exist and `--check` is green.
#   4. Runs `pm-board.sh --warn` and prints what is left — a map reading `Not started`, or any
#      other value outside the vocabulary — for a human, because those have no single answer
#      (`Not started` is `Charting` only once charting has begun).
#
# NEVER FAILS THE UPDATE, for the reason v2.0.0-renumber-src.sh records: a non-zero exit aborts
# every migration declared after this one and leaves the project half-upgraded.
#
# Idempotent: a second run finds no old value to rename, finds the cut plan present and leaves
# it alone, and rewrites identical boards.
# Working directory is the project being updated.
#
# Exit codes:  0 = always
#
set -uo pipefail

SRC="project-management/src"
BOARD="$SRC/00-ASSETS/scripts/pm-board.sh"

printf '\n▸ 7.7.0 PM boards — status vocabulary, the cut plan and the five generated boards\n'

[[ -d "$SRC" ]] || { echo "  no $SRC/ — nothing to do"; exit 0; }

rename() { # rename <glob-dir> <file-regex> <sed-expression>
  local dir="$1" re="$2" expr="$3" f
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    if sed -E -i.bak "$expr" "$f" 2>/dev/null; then
      cmp -s "$f" "$f.bak" || echo "  renamed a retired status in $f"
      rm -f "$f.bak"
    else
      rm -f "$f.bak"
      echo "  ! could not rewrite $f — check its status line by hand"
    fi
  done < <(find "$dir" "$dir/archive" -maxdepth 1 -type f -name '*.md' 2>/dev/null | grep -E "$re" | grep -v TEMPLATE)
}

rename "$SRC/02-STORIES" '/US[0-9]{3}\.md$' \
  's/^(\*\*Status(:\*\*|\*\*:)[[:space:]]*)Accepted Customer\b/\1Customer Accepted/; s/^(\*\*Status(:\*\*|\*\*:)[[:space:]]*)Rejected Customer\b/\1Customer Rejected/'
rename "$SRC/03-SPRINTS" '/SPRINT-[0-9]{2}\.md$' \
  's/^(\*\*Status(:\*\*|\*\*:)[[:space:]]*)In progress\b/\1In Progress/'
rename "$SRC/01-FEATURE-MAPS" '/MAP-[A-Z0-9-]+\.md$' \
  's/^(\*\*Status(:\*\*|\*\*:)[[:space:]]*)Blockers clear\b/\1Blockers Clear/'

answer() { # one scalar answer from .copier-answers.yml, YAML quoting undone; empty if absent
  local v
  v="$(sed -n "s/^$1:[[:space:]]*//p" .copier-answers.yml 2>/dev/null | head -n 1)"
  v="${v%"${v##*[![:space:]]}"}"
  if [[ "$v" == \'*\' && ${#v} -ge 2 ]]; then
    v="${v:1:${#v}-2}"; v="${v//\'\'/\'}"
  elif [[ "$v" == \"*\" && ${#v} -ge 2 ]]; then
    v="${v:1:${#v}-2}"; v="${v//\\\"/\"}"; v="${v//\\\\/\\}"
  fi
  printf '%s' "$v"
}

seed_cut_plan() { # write the blank cut plan only when the project has none
  local dest="$SRC/02-STORIES/CUT-PLAN.md" seed name date content tmp
  seed="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." 2>/dev/null && pwd)/CUT-PLAN.md"
  [[ -e "$dest" || -L "$dest" ]] && { echo "  $dest present — left as it is"; return 0; }
  [[ -d "$SRC/02-STORIES" ]] || { echo "  no $SRC/02-STORIES/ — cut plan not written"; return 0; }
  [[ -f "$seed" ]] || { echo "  ! template seed $seed not found — cut plan not written"; return 0; }

  name="$(answer DEVELOPER_NAME)"
  if [[ -z "$name" ]]; then
    name="TBD"
    echo "  ! DEVELOPER_NAME not found in .copier-answers.yml — set 'Maintained By' in $dest by hand"
  fi
  date="$(answer DATE)"
  [[ "$date" =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]] || date="$(date +%d/%m/%Y)"

  content="$(<"$seed")" || { echo "  ! could not read $seed — cut plan not written"; return 0; }
  content="${content//'<%DATE%>'/"$date"}"
  content="${content//'<%DEVELOPER_NAME%>'/"$name"}"
  local opener='<''%' # split so the token gate never reads a bare opener in this file
  [[ "$content" == *"$opener"* ]] && echo "  ! an unrendered template token is left in $dest — fix it by hand"

  tmp="$dest.tmp.$$"
  if printf '%s\n' "$content" >"$tmp" && mv "$tmp" "$dest"; then
    echo "  wrote $dest (blank cut plan) — commit it with this update"
  else
    rm -f "$tmp"
    echo "  ! could not write $dest — copy it from the template's .copier/CUT-PLAN.md by hand"
  fi
}
seed_cut_plan

if [[ ! -f "$BOARD" ]]; then
  echo "  $BOARD not present — the boards were not written; run it once it is"
  exit 0
fi

bash "$BOARD" --write || echo "  ! pm-board.sh --write failed — run it by hand and commit the boards"
bash "$BOARD" --warn || true
echo "  Commit the five *-BOARD.md files with this update. Any 'not in the … vocabulary'"
echo "  warning above is a status line to correct by hand (vocabulary: .claude/skills/completion/SKILL.md)."
exit 0
