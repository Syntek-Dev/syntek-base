@./CONTEXT.md

# CLAUDE.md — how-to/workflows/01-first-time-setup/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file.

## Purpose (one line)

The workflow for standing the project up on a fresh machine or onboarding a teammate
— clone, copy environment files, and start the Dockerised backend (8000) and
frontend (3000).

## How to work here

- **Routing:** setup task → `global-workflow` skill. Execute `STEPS.md` in order
  (setup is sequential, no hard gate) and verify against `CHECKLIST.md`; lean on
  `how-to/docs/DEVELOPMENT.md` and `CLI-TOOLING.md` for command detail.
- **Model:** Opus to revise the procedure and command/link fixes.
- **Concrete steps:** to amend, edit `STEPS.md` and `CHECKLIST.md` together → every
  command a `code/src/scripts/**/*.sh` reference → keep prerequisites and the
  concept notes accurate against the current Compose stack.
- **Definition of done:** a newcomer following `STEPS.md` reaches a running dev stack;
  `CHECKLIST.md` passes; British English.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Environment files are never committed** — copy from `.env.*.example`; the real
  `.env.dev` stays gitignored.
- The project runs **entirely inside Docker** — no host Python/Node steps.
- **Script-first:** no raw `docker`/`pnpm`/`uv` commands in the steps.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; nothing generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`.
