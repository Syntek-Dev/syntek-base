@./CONTEXT.md

# CLAUDE.md — code/docs/testing/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The testing sub-documents behind `code/docs/TESTING.md` — the test taxonomy, backend
testing, template/HTMX testing, Django Ninja API endpoint testing, advanced
techniques, and coverage thresholds. Everything runs on pytest; there is no
client-side runner.

## How to work here

- **Routing:** documentation, not code — `doc-writer` or `test-writer`
  (Opus for substantive guidance; Opus for typo/header touches).
- **Concrete steps:** edit the relevant sub-doc → keep `code/docs/TESTING.md` a thin
  index → every run instruction must invoke a `code/src/scripts/tests/*.sh` runner,
  never raw `pytest`. Keep the coverage floors in `COVERAGE.md`
  authoritative and consistent with `code/CONTEXT.md`.
- **Definition of done:** taxonomy and examples match the shipped suites; coverage
  floors agree across docs; each file ≤ 300 code lines; British English.

## Guardrails

- **300-line instructional limit** — these are `**/docs/*.md`; split and demote the
  parent to an index if a file exceeds it.
- **Coverage floors are a single source of truth** — 75% line and branch, 90% for
  `apps/users`. There is no separate frontend floor. Do not restate a different
  number here; if the floor changes, update `code/CONTEXT.md` in the same pass —
  and, on a mobile project, `code/src/mobile/jest.config.js` too. **One standard,
  enforced once per runtime:** `coverage.py` and Jest share no accumulator, so the
  same numbers live in two places and must move together.
- Never document invoking test runners directly — always via the shell scripts.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/TESTING.md`.
