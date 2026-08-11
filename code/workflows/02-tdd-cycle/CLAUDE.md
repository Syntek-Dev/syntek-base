@./CONTEXT.md

# CLAUDE.md — workflows/02-tdd-cycle/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(Red → Green → Refactor, coverage floors — imported above) → this file.

## Purpose (one line)

The test-driven-development procedure — write failing tests at the contract level,
implement the minimum to pass, then refactor with the suite green throughout.

## How to work here

- **Routing:** execute via `STEPS.md`; service and endpoint tests through the
  `stack-django` skill, template/component/HTMX-partial tests through
  `stack-htmx-templates` — both pytest, both Opus. The
  `test-writer` agent may generate stubs, but green must mean a real implementation.
- **Model:** Opus for authoring tests and implementation and mechanical
  edits to the workflow files.
- **Concrete steps:** confirm `code/src/scripts/syntax/check.sh` passes → **Red**:
  write contract-level tests with realistic data, factories, and parametrisation,
  watch them fail → **Green**: minimal implementation, add tests only for genuine
  edge cases found while building → **Refactor**: improve without changing the public
  contract. Run suites via `code/src/scripts/tests/*.sh`.
- **Definition of done:** tests green, coverage floors met (75% line and branch / auth 90%),
  no stubs left behind.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Never add a test solely to raise a coverage number** — tests assert observable
  outcomes (return values, DB state, API responses), not internals.
- Refactor changes zero tests unless the public contract itself changes.
- No stubs at green: a passing suite must exercise real behaviour.
- Never invoke `pytest` or `python` directly — only the shell
  scripts.

## Output & naming

- **Hand-written:** these workflow files; the tests and implementation they drive
  live beside the code under `code/src/`.
- Workflow files `SCREAMING-SNAKE-CASE.md`.
