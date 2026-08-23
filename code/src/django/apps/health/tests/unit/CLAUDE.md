@./CONTEXT.md

# CLAUDE.md — apps/health/tests/unit/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(why the path is functional, imported above) → this file → `../CLAUDE.md`.

## Purpose (one line)

Phase-1 tests for `apps.health` — no database, no container, no network.

## How to work here

- **Routing:** `test-writer` (Opus).
- **Model:** Opus.
- **Concrete steps:** assert against values you constructed, not against a live
  dependency → substitute collaborators with `monkeypatch` → run
  `code/src/scripts/tests/backend-coverage.sh`.
- **Definition of done:** the test passes with no database available, and fails when the
  behaviour it names is broken.

## Guardrails

- **No database access, ever.** Phase 1 applies no `django_db` fixture, so a query here
  fails for a reason that has nothing to do with the assertion.
- **No `pytest.mark.django_db` in this directory** — a test needing one belongs in the
  parent, where it is marked `integration` by path.
- **Never run `pytest` directly** — `code/src/scripts/tests/*.sh` only.

## Output & naming

- **Hand-written:** every file here.
- Test files `test_*.py`; classes `Test*`; functions `test_*`.
