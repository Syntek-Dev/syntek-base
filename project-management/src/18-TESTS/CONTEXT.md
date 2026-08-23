# project-management/src/18-TESTS

Per-story test records — the automated **test status** and the human **manual-testing**
guide for each user story, written once its code ships. This folder is a base-repo
**template-only scaffold**: it ships the two `US000-…` copy sources and nothing else;
real records are added by copying a template to `US###-…` per story.

## Directory Tree

```text
project-management/src/18-TESTS/
├── CONTEXT.md                 ← this file
├── CLAUDE.md                  ← operating rules for this folder
├── US000-TEST-STATUS.md       ← template: per-story automated-test status record
└── US000-MANUAL-TESTING.md    ← template: per-story manual test walk-through
```

To record a story, copy each template to its `US###-…` name — e.g.
`US000-TEST-STATUS.md` → `US###-TEST-STATUS.md`. The folder stays flat: every real file
is `US###-TEST-STATUS.md` or `US###-MANUAL-TESTING.md` at the root.

## Record-tier position

This is a **record** folder. A feature flows
`15-DECISIONS → 16-SPRINT-PLANS → 17-STORY-PLANS → code → 18-22 records`: the story plan
(17) is the master a developer codes from, and the 18–22 folders (tests, reviews, findings, bugs,
refactoring) capture what happened after the code shipped. These two files are the test
half of that record.

## What the records capture

- **`US###-TEST-STATUS.md`** — the automated outcome: which suites ran (Unit, Integration,
  API/contract, E2E, Accessibility), their pass/fail counts, and coverage measured against
  the floors (**one floor**: 75% line and branch, 90% for auth-critical modules, raised to
  80% by the pre-PR gate on `staging`/`main` — template, django-component, and HTMX-partial
  tests are pytest tests and count towards the same number), plus outstanding gaps and flaky
  tests. Coverage numbers are transcribed from the runners under `code/src/scripts/tests/**`,
  never authored by hand.
- **`US###-MANUAL-TESTING.md`** — the by-hand walk-through: preconditions and seed data,
  scenarios grouped Happy path / Error states / Edge cases / Permission & security /
  Accessibility, a device/breakpoint matrix, and a tester sign-off block.

## When to write them

Write and update the pair during implementation and PR review — the code workflows
(backend/API/frontend) and `project-management/workflows/23-pr-and-review/`. Keep both in
step with the story and its suites; append the update date on every change.

## Cross-references

- `../02-STORIES/` — the user stories these records test
- `../17-STORY-PLANS/` — the per-story implementation plan the tests close the loop on
- `../11-QA/` — the QA plan (PLANNING) and review (IMPLEMENTATION) these records feed
- `code/docs/TESTING.md` · `code/docs/ACCESSIBILITY.md` — coverage floors and WCAG rules
- `project-management/workflows/23-pr-and-review/` — where the records are finalised

**Last Updated**: <%DATE%>
