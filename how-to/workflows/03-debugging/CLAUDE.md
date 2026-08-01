@./CONTEXT.md

# CLAUDE.md — how-to/workflows/03-debugging/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file.

## Purpose (one line)

The reactive operational-debugging workflow — triage a failing test, broken build,
runtime error, or unexpected Django Ninja/frontend result starting from container logs.

## How to work here

- **Routing:** environment/operational failure → `global-workflow` skill via
  `STEPS.md`; `CHECKLIST.md` to confirm resolution. Once the environment is proven
  healthy, hand off to `code/workflows/07-debug/` (code-logic) or
  `code/workflows/10-debugging-with-logs/` (staging/prod observability).
- **Model:** Opus for diagnosis and procedure edits and command/link fixes.
- **Concrete steps:** container logs first → Django shell for backend data → the
  Django Ninja `/api/docs` OpenAPI UI for isolated endpoint calls → browser DevTools
  Network tab for HTMX requests and their fragments — all via `code/src/scripts/**/*.sh`
  (logs, shell). Amend by editing
  `STEPS.md` + `CHECKLIST.md` together.
- **Definition of done:** root cause isolated to environment vs code; `CHECKLIST.md`
  passes; British English.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Scope boundary:** this workflow diagnoses the _environment_. Code-logic bugs and
  regression tests belong to `code/workflows/07-debug/`; do not fix product code here.
- **Script-first:** logs and shells via `code/src/scripts/**/*.sh` — never a raw
  `docker logs` / `python manage.py shell` in the steps.
- No hard gate — start from logs; debugging is reactive.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; nothing generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`.
