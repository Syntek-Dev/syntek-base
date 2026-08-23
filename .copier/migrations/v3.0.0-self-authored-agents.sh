#!/usr/bin/env bash
#
# v3.0.0-self-authored-agents.sh — report agent definitions the template never owned.
#
# Template v3.0.0 deletes `.claude/agents/` in full: its 54 agent definitions, plus the
# directory's own CONTEXT.md and CLAUDE.md, were rewritten as skills under
# `.claude/skills/` — not one for one, since several folded together. Copier removes the
# files it generated, so for a project that never wrote its own agent this migration
# finds nothing and says so.
#
# A project that authored ITS OWN agent is the case this exists for. That file was never
# a template file, so Copier has no knowledge of it and leaves it exactly where it was —
# in a directory nothing routes to any more. No conflict, no error, update reports
# success. It is the same silent-orphan failure a renumbering causes, running in
# reverse: there the scaffolding moved and your files stayed, here the scaffolding was
# deleted and your files stayed.
#
# ADVISORY ONLY. It never moves, rewrites or deletes an agent definition, and it always
# exits 0 so it cannot fail an update. Relocating an agent is a rewrite, not a rename —
# a skill needs `name` and `description` frontmatter and must pass the skill-conformance
# audit — so a machine that moved the file would produce a skill that fails its own gate
# and call it a migration. That judgement stays with a human.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v3.0.0.
# Safe to run by hand afterwards; it is idempotent and read-only bar one empty-directory
# tidy-up.
#
# Working directory is the project being updated.
#
# Exit codes:  0 = always (advisory)
#
set -euo pipefail

AGENTS=".claude/agents"

[[ -d "$AGENTS" ]] || exit 0

declare -a AUTHORED=()
declare -a STALE=()

while IFS= read -r f; do
  case "$(basename "$f")" in
    # Template scaffolding for the directory itself. It is gone from v3.0.0, so a copy
    # left here is stale rather than something to convert.
    CONTEXT.md | CLAUDE.md) STALE+=("$f") ;;
    *) AUTHORED+=("$f") ;;
  esac
done < <(find "$AGENTS" -type f 2>/dev/null | sort)

if [[ ${#AUTHORED[@]} -eq 0 && ${#STALE[@]} -eq 0 ]]; then
  # Copier deleted every file it owned and nothing was left behind. Drop the husk.
  find "$AGENTS" -type d -empty -delete 2>/dev/null || true
  exit 0
fi

printf '\n▸ v3.0.0 migration — agent definitions the template does not own\n\n'

if [[ ${#AUTHORED[@]} -gt 0 ]]; then
  printf '  %d agent definition(s) remain in %s.\n' "${#AUTHORED[@]}" "$AGENTS"
  printf '  The template no longer reads this directory — nothing routes to these files.\n\n'

  for f in "${AUTHORED[@]}"; do
    name="$(basename "$f" .md)"
    printf '    %-44s -> .claude/skills/%s/SKILL.md\n' "$f" "$name"
  done

  cat <<'ADVICE'

  To keep one, relocate it as a skill. This is a rewrite, not a move:

    1. Create .claude/skills/<name>/SKILL.md and move the body across.
    2. Give it `name` and `description` frontmatter. The description is what fires
       the skill on a match, so it carries the routing the `agent:` field used to.
    3. Drop `tools:` — it never restricted anything, and skills have no equivalent.
    4. Prove it:  bash code/src/scripts/audits/skill-conformance.sh

  Writing one:  how-to/docs/SKILL-AUTHORING.md
  The roster:   .claude/skills/CONTEXT.md

  To drop one instead, delete the file. Nothing references it.
ADVICE
fi

if [[ ${#STALE[@]} -gt 0 ]]; then
  printf '\n  %d stale template file(s) also remain, safe to delete:\n\n' "${#STALE[@]}"
  for f in "${STALE[@]}"; do printf '    %s\n' "$f"; done
fi

printf '\n  Nothing was changed. %s is left exactly as it was.\n\n' "$AGENTS"

exit 0
