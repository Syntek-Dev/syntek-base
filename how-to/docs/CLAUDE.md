@./CONTEXT.md

# CLAUDE.md — how-to/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(guide index, imported above) → this file → `tooling-guide/CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The operational reference guides — `DEVELOPMENT.md` (setup, env, Compose commands),
`CLI-TOOLING.md` (command reference), `GIT-WORKTREES.md` (parallel stacks),
`CELERY-FIRST-RUN.md` (Celery worker/beat first-run review), `FEATURE-DEPLOY.md` (feature
deploy-coordination checklist), `TOOLING-GUIDE.md` (internal agents & skills index over
`tooling-guide/`), `AI-DICTIONARY.md` (AI-coding glossary over `ai-dictionary/`), and
`SKILL-AUTHORING.md` (how to write skills).

## How to work here

- **Routing:** guide authoring → `global-workflow` skill. These are humans' reference
  docs, not workflows — for a procedure, edit `how-to/workflows/NN-…/` instead and
  link here.
- **Model:** Opus to write or restructure a guide and renames and link/header
  fixes.
- **Concrete steps:** edit the target `*.md` → keep every command a
  `code/src/scripts/**/*.sh` reference → keep the file ≤ 300 code lines (`cloc`), and
  if it would exceed that, split into a sub-doc folder and leave a thin index (the
  `TOOLING-GUIDE.md` → `tooling-guide/` pattern) → update `CONTEXT.md` if a guide is
  added or removed.
- **Definition of done:** commands match the scripts they name; cross-references
  resolve; British English; docs hard-gate satisfied.
- **Routing frontmatter:** every guide here carries `type`/`agent`/`skills`/`model` frontmatter — read it first and route to the named agent, skills, and model (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Script-first:** no raw `pnpm`/`npm`/`uv`/`docker`/`python manage.py` in any guide
  — always the `code/src/scripts/**/*.sh` equivalent.
- **≤ 300 code lines** per instructional file; oversize → split with a thin index.
- Keep guidance current with the actual scripts and Compose files — stale commands
  are worse than none.

## Output & naming

- **Hand-written:** all eight guides and the `tooling-guide/` + `ai-dictionary/` sub-documents; nothing generated here.
- Documentation files `SCREAMING-SNAKE-CASE.md`; the sub-doc folder is `kebab-case/`.
