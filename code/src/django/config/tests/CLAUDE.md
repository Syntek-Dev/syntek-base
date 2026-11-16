@./CONTEXT.md

# CLAUDE.md — config/tests/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is tested here and why in a fresh interpreter, imported above) → this file →
`../settings/CLAUDE.md` for the rules the settings under test are held to.

## Purpose (one line)

The tests covering computed values in the `config` settings package.

## How to work here

- **Routing:** `test-writer` (Opus). Read `../settings/CONTEXT.md` first — a test asserting a
  setting the module does not compute is worse than no test.
- **Model:** Opus.
- **Concrete steps:** add a case only for a value `settings/` derives (parses, appends,
  validates) → import the module in a fresh interpreter, never in the test process → run
  `code/src/scripts/tests/backend.sh`.
- **Definition of done:** each test fails when the behaviour it names is broken — verified
  by breaking it, not assumed; the overlay guard `audits/worktree-overlay.sh` still exits `0`.

## Guardrails

- **Never import `config.settings.dev` in the test process.** It mutates the `TEMPLATES` list
  shared with `config.settings.test` and changes every template test that runs after it.
- **Keep the explicit `unit` marker.** The module is not under `unit/`, so without it
  `conftest.py` would mark it `integration` and attach a database it never uses.
- **Expected origins are literals, never re-derived from `dev.py`** — a test that reads its
  answer from the code under test cannot fail.
- **A refusal is asserted as `ImproperlyConfigured`, never as a dropped entry.** The trusted
  list must never widen silently, and an entry quietly ignored hides the typo that caused it.
- **Never run `pytest` directly** — `code/src/scripts/tests/*.sh` only.

## Output & naming

- **Hand-written:** every file here.
- Test files `test_*.py`; classes `Test*`; functions `test_*`.
