@./CONTEXT.md

# CLAUDE.md — code/src/django/tests/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what belongs here and what does not, imported above) → this file → `e2e/CLAUDE.md`.

## Purpose (one line)

The home for test suites that belong to no single app — currently just the browser-level
`e2e/` suite.

## How to work here

- **Routing:** `test-writer` (Opus). Descend to `e2e/` and read its `CLAUDE.md` before
  adding a browser test.
- **Model:** Opus.
- **Concrete steps:** decide the layer first (`code/docs/testing/TAXONOMY.md`) → if the
  test belongs to one app, write it in `apps/<app>/tests/` instead → only cross-cutting,
  browser-bound checks land here.
- **Definition of done:** the test lives at the cheapest layer that can actually catch
  the defect, and runs through a `code/src/scripts/tests/*.sh` runner.

## Guardrails

- **Default to `apps/<app>/tests/`.** A test placed here that could have lived beside its
  app loses its locality: it survives the app's deletion and drifts.
- **A new sub-package here needs a reason and a `CONTEXT.md` + `CLAUDE.md` pair** — this
  directory is not a dumping ground for tests nobody wanted to place.
- Never invoke `pytest` or `playwright` directly — always the shell scripts.

## Output & naming

- **Hand-written:** everything here.
- Packages `snake_case`; modules `test_<area>.py` (`test_e2e_<area>.py` under `e2e/`).
