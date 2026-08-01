@./CONTEXT.md

# CLAUDE.md — src/16-TESTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(template list, naming, record-tier position — imported above) → this file.

## Purpose (one line)

The per-story test record — one `US###-TEST-STATUS.md` automated-coverage tracker and one
`US###-MANUAL-TESTING.md` manual walk-through per user story, copied from the `US000-…`
templates and kept in step as tests are written and coverage changes.

## How to work here

- **Routing:** these are implementation records, written during the **code / PR phase** —
  updated as part of the code workflows (backend / API / frontend) and finalised in
  `project-management/workflows/20-pr-and-review/`, and revisited by the debug and refactor
  workflows. The automated figures come from the suites run via
  `code/src/scripts/tests/**/*.sh` — never invoke `pytest`
  directly.
- **Model:** **Opus** for the whole job — authoring a manual guide, transcribing coverage,
  flipping a pass/fail status, or creating the paired file for a new `US###`. These are
  mechanical implementation touches, not planning artefacts.
- **Concrete steps:** identify the `US###` → copy `US000-TEST-STATUS.md` and
  `US000-MANUAL-TESTING.md` to `US###-…` (create both if absent) → replace every
  `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows → record real suite results, coverage, and
  the manual walk-through → link the story (`../01-STORIES/US###.md`) and its plan
  (`../15-STORY-PLANS/STORY-PLAN-US###-*.md`) → append the update date.
- **Definition of done:** both files present and current, named to convention, coverage
  matching the last suite run, story and story-plan cross-linked, British English, dates
  DD/MM/YYYY.

## Guardrails

- **Documentation only** — a record of test outcomes, never test code. The tests live under
  `code/src/django/**/tests/` and `code/src/tests/` (Bruno);
  this folder points at them, it does not hold them.
- **No secrets, tokens, real credentials, or personal data** in a manual guide — use
  fixtures and seeded test users via the project seeding scripts, never live values.
- **Flat folder** — every file is `US###-TEST-STATUS.md` or `US###-MANUAL-TESTING.md` at
  the root (plus the two `US000-…` templates); no sub-folders or other document types.
- **Keep the pair honest** — a `TEST-STATUS` claiming green must reflect the real floors
  (one floor: 75% line and branch, 90% auth-critical, raised to 80% by the pre-PR gate on
  `staging`/`main`); do not record a pass the suites do not support.

## Output & naming

- **Hand-written:** both `.md` files per story — the status tracker and the manual guide —
  copied from the `US000-…` templates.
- **Generated:** none; coverage numbers are transcribed from the test-runner output under
  `code/src/scripts/tests/**`, not authored.
- Files strictly `US###-TEST-STATUS.md` and `US###-MANUAL-TESTING.md` — `US` + zero-padded
  three-digit story number; dates DD/MM/YYYY.
