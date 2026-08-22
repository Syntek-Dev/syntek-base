@./CONTEXT.md

# CLAUDE.md — workflows/11-refactor/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when to use, refactor concepts — imported above) → this file.

## Purpose (one line)

The procedure for systematic refactoring of functionally-correct code — repaying
technical debt, splitting oversized files, extracting logic from resolvers — with
behaviour held identical throughout.

## How to work here

- **Routing:** execute via `STEPS.md`, typically with the `refactor` skill
  (Opus). Requires a green baseline from `code/workflows/02-tdd-cycle/`. Scope the move with
  the code-review-graph **refactor playbook** (`.claude/skills/refactor-safely.md`; guide
  `code/docs/CODE-REVIEW-GRAPH.md`).
- **Model:** Opus for restructuring decisions and mechanical edits to
  the workflow files.
- **Concrete steps:** confirm all tests green and scope defined → read the hard gate
  (`testing/COVERAGE.md`) → extract logic into services, shaping a named access rule
  as a Policy class and a variant algorithm as a Strategy class → split any file over
  750 lines → run the suite via `code/src/scripts/tests/*.sh` after every meaningful
  change → complete `CHECKLIST.md`.
- **Definition of done:** tests unchanged and green, coverage not dropped, behaviour
  identical, every touched file ≤ 750 lines (800 grace).
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Never refactor and change behaviour in the same commit** — fix any bug first via
  workflow `10`, then refactor separately.
- Tests must stay green throughout; coverage must not drop (floors block the PR).
- One function, one purpose; split files over 750 lines (800 grace).
- Never invoke `pytest`, `python`, or `pnpm` directly — only the shell scripts.

## Output & naming

- **Hand-written:** these workflow files; the refactored source stays under
  `code/src/`.
- Refactoring notes saved under `project-management/src/22-REFACTORING/`; workflow
  files `SCREAMING-SNAKE-CASE.md`.
