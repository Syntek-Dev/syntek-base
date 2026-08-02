@./CONTEXT.md

# CLAUDE.md — how-to/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(workflow index, imported above) → this file → the target workflow's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The step-by-step operational workflows — first-time setup (`01`), daily development
(`02`), debugging (`03`), and worktree setup (`04`) — each a `CONTEXT.md` +
`STEPS.md` + `CHECKLIST.md` triad.

## How to work here

- **Routing:** operational procedure → `global-workflow` skill. Pick the numbered
  workflow that matches the task; read its `CONTEXT.md` (when-to-use, prerequisites,
  hard gates) before executing `STEPS.md`, then verify against `CHECKLIST.md`.
- **Model:** Opus to author or restructure a workflow and renames and link
  fixes.
- **Concrete steps:** to add or change a workflow, edit the triad together → keep
  every command a `code/src/scripts/**/*.sh` reference → honour the hard-gate/soft-
  reference split each `CONTEXT.md` declares → keep each file ≤ 300 code lines →
  update the parent `CONTEXT.md` table.
- **Definition of done:** `STEPS.md` executes cleanly end to end; `CHECKLIST.md`
  covers the acceptance points; cross-references resolve; British English.
- **Routing frontmatter:** every `STEPS.md`/`CHECKLIST.md` here carries `workflow`/`phase`/`agent`/`skills`/`model` frontmatter — read it first and route accordingly (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Script-first:** no raw `pnpm`/`uv`/`docker`/`python manage.py` in any step.
- **Respect the hard gates:** e.g. `project-management/docs/GIT-GUIDE.md` branch
  naming before the first commit (workflows `02`/`04`); do not reorder around them.
- **≤ 300 code lines** per file; every workflow keeps its four-file shape
  (`CONTEXT.md` · `CLAUDE.md` · `STEPS.md` · `CHECKLIST.md`).

## Output & naming

- **Hand-written:** every `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md`; nothing generated.
- Workflow directories carry an `NN-` numeric prefix and `kebab-case` name;
  documentation files `SCREAMING-SNAKE-CASE.md`; stories referenced as `US###`.
