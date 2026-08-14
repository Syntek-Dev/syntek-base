@./CONTEXT.md

# CLAUDE.md — how-to/workflows/03-daily-development/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file.

## Purpose (one line)

The start-of-session workflow — pull latest, cut a `us###/short-description` branch,
bring the containers up, and set the working context for the day's user story.

## How to work here

- **Routing:** session start → `global-workflow` skill. `STEPS.md` in order,
  `CHECKLIST.md` to verify; command detail in `how-to/docs/DEVELOPMENT.md`,
  `CLI-TOOLING.md`, and `TOOLING-GUIDE.md`.
- **Session handoff:** session must end before the work does →
  `.claude/skills/handoff/SKILL.md` compacts it into a committed `handoffs/` doc.
- **Learn before you build:** an unfamiliar technique or convention → practise it first in the
  `learning/` sandbox via `.claude/skills/teach/SKILL.md` (writes nothing to the codebase).
- **Model:** Opus to revise the procedure and command/link fixes.
- **Concrete steps:** to amend, edit `STEPS.md` + `CHECKLIST.md` together → every
  command a `code/src/scripts/**/*.sh` reference → keep the branch-naming step aligned
  with `project-management/docs/GIT-GUIDE.md`.
- **Definition of done:** following `STEPS.md` yields a correctly named branch on a
  running stack; `CHECKLIST.md` passes; British English.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Hard gate:** `project-management/docs/GIT-GUIDE.md` — the `us###/…` branch name
  must be correct **before** the first commit; do not defer it.
- Always branch from up-to-date `dev`; containers must be running before any work.
- **Script-first:** no raw `docker`/`pnpm`/`uv`/`git`-hook bypass in the steps.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; nothing generated.
- Branches `us###/short-description`; documentation files `SCREAMING-SNAKE-CASE.md`.
