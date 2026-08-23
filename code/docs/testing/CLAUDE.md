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
- **`COVERAGE.md` is the single source of truth for the floors** — the numbers, the
  promotion tier, and the fact that there is no separate frontend floor all live there and
  nowhere else. Never restate a number in this folder. When a floor moves it moves in
  `COVERAGE.md` first, then in `code/src/mobile/jest.config.js` on a mobile project.
  **One standard, enforced once per runtime:** `coverage.py` and Jest share no accumulator,
  so the same floors live in two places and must move together — the promotion tier is
  Python-side only and is the one thing that does not.
- Never document invoking test runners directly — always via the shell scripts.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/TESTING.md`.
