@./CONTEXT.md

# CLAUDE.md — apps/core/tests/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the phase split and what drives it, imported above) → this file → `../CLAUDE.md` for the
rules the code under test is held to.

## Purpose (one line)

The tests covering `apps.core`, split by whether they need a database.

## How to work here

- **Routing:** `test-writer` (Opus). Read `../CONTEXT.md` first — a test asserting
  something the app does not claim to do is worse than no test.
- **Model:** Opus.
- **Concrete steps:** pick the cheapest layer that can catch the defect
  (`code/docs/testing/TAXONOMY.md`) → put it in `unit/` if it needs no database, here if
  it does → run `code/src/scripts/tests/backend-coverage.sh`.
- **Definition of done:** the test fails when the behaviour it names is broken — verified
  by breaking it, not assumed; coverage floors still met.

## Guardrails

- **Never run `pytest` directly** — `code/src/scripts/tests/*.sh` only.
- **A file in `unit/` must not touch the database.** It is marked `unit` by path and runs
  in phase 1, where no `django_db` fixture is applied; a stray query fails confusingly.
- **`assert` is correct here and banned everywhere else** (ruff `S101` exempts the test
  tree) — `code/docs/NEGATIVE-SPACE.md`.
- Cover the branch that is hard to reach, not the line that is easy to reach.

## Output & naming

- **Hand-written:** every file here.
- Test files `test_*.py`; classes `Test*`; functions `test_*`.
