@./CONTEXT.md

# CLAUDE.md — code/src/django/tests/unit/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is tested here, imported above) → this file.

## Purpose (one line)

Unit tests for the root `conftest.py` — the project-wide pytest hooks no single app owns.

## How to work here

- **Routing:** `test-writer` (Opus); a defect in a hook is `bugfix`.
- **Model:** Opus.
- **Concrete steps:** load the root conftest under a private module name
  (`importlib.util.spec_from_file_location`), never `import conftest` — pytest has already
  registered it, and a second import under the same name would alias that registration → drive
  the hook with stand-in sessions → point any written path at `tmp_path` → run
  `code/src/scripts/tests/backend.sh`.
- **Definition of done:** each test fails when the behaviour it names is broken — seen red
  before the fix, not assumed.

## Guardrails

- **Never write to the real `reports/story-map.json` from a test** — monkeypatch
  `STORY_MAP_PATH` to `tmp_path`, or the test corrupts the record of the run it is part of.
- Keep the module-level `pytest.mark.story` marker; a test here is recorded like any other.
- Never invoke `pytest` directly — always the shell scripts.

## Output & naming

- **Hand-written:** everything here.
- Modules `test_<hook-or-area>.py`.
