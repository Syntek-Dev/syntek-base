@./CONTEXT.md

# CLAUDE.md — learning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree + purpose, imported above) → this file → the `teach` skill (`.claude/skills/teach/SKILL.md`).

## Purpose (one line)

The committed practice sandbox for the `teach` skill — learn a new skill here without changing
the product.

## How to work here

- **Routing:** all work here runs through the `teach` skill (`.claude/skills/teach/SKILL.md`);
  it owns the lesson loop (mission → level → resources → recall + build → review). Model: Opus.
- **Concrete steps:** `/teach <topic>` creates `learning/<topic>/` with `MISSION.md`,
  `RESOURCES.md`, `PROGRESS.md`, and `LESSONS/` → practise inside that folder only → record each
  lesson and its next-review date in `PROGRESS.md`.
- **Definition of done (per session):** a fresh session can resume from the topic's files alone,
  and nothing outside `learning/` changed.

## Guardrails

- **The codebase is read-only from here.** Read `code/src/`, `project-management/src/`, and any
  doc freely as reference; write only inside `learning/<topic>/`. No migrations, no
  commits-as-shipping, no ship gates run from a lesson.
- **Practice copies only.** A practice `US###` or `PLAN` stays under `LESSONS/` — never in
  `project-management/src/`. A coding example stays here — never wired into `code/src/`.
- **British English (en_GB)**; runnable examples mirror the real scripts
  (`code/src/scripts/development|tests/*.sh`) so the skill transfers.

## Output & naming

- **Hand-written:** everything here is {{DEVELOPER_NAME}}'s throwaway practice, created via `/teach`.
- Topic folders `kebab-case/`; the fixed files are `MISSION.md`, `RESOURCES.md`, `PROGRESS.md`,
  and the `LESSONS/` folder.
