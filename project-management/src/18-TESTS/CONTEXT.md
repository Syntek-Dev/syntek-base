# project-management/src/18-TESTS

Per-story test records — the **automated** record of what each test checks and whether it passed,
and the **manual** journey walk-through a tester or Claude Chrome follows step by step. Both are
written once the story's code ships. This folder is a base-repo **template-only scaffold**: it
ships the two `US000-…` copy sources and nothing else; real records are added by copying a
template to `US###-…` per story.

## Directory Tree

```text
project-management/src/18-TESTS/
├── CONTEXT.md                 ← this file
├── CLAUDE.md                  ← operating rules for this folder
├── US000-TEST-STATUS.md       ← template: per-story automated-test record (half generated)
└── US000-MANUAL-TESTING.md    ← template: per-story manual journey walk-through
```

To record a story, copy each template to its `US###-…` name — e.g. `US000-TEST-STATUS.md` →
`US###-TEST-STATUS.md`. The folder stays flat: every real file is `US###-TEST-STATUS.md` or
`US###-MANUAL-TESTING.md` at the root.

## Record-tier position

This is a **record** folder. A feature flows
`15-DECISIONS → 16-SPRINT-PLANS → 17-STORY-PLANS → code → 18-22 records`: the story plan
(17) is the master a developer codes from, and the 18–22 folders (tests, reviews, findings, bugs,
refactoring) capture what happened after the code shipped. These two files are the test half of
that record.

## What the records capture

- **`US###-TEST-STATUS.md`** — the automated outcome, in two halves. A **generated** block holds
  the suite rollup, coverage measured against the floors, and a per-test table naming what each
  test checks and whether it passed, one row per case; a **hand-written** remainder holds how to
  reproduce the run, the outstanding gaps and flaky tests, and the status line. The generated
  block is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
  artefacts — JUnit XML, Bruno JSON, axe JSON and `coverage.xml` — and is never authored by hand.
- **`US###-MANUAL-TESTING.md`** — the executed walk-through. Preconditions and seed data, then one
  section per journey **area**, its rows in the order a person moves through the product and each
  marked `Pass` or `Fail`; then permission and access, accessibility and responsive behaviour as
  journeys of their own; then the failures, and a tester sign-off. Rows name controls by what a
  person sees, so the same file serves a human tester and a browser agent.

## What sits beside them

Three record folders resemble each other and answer different questions. `../11-QA/` asks whether
the **specified scenarios** were met; `../05-USER-FLOW/IMPLEMENTATION/` asks whether the **flow
exists** as designed; these two ask whether **executing the tests passed**. The manual guide cites
`11-QA`'s scenario IDs and reuses `05-USER-FLOW`'s step numbers rather than restating either.

## When to write them

Both are written by `project-management/workflows/22-implementation-documentation/` — the
documentation closeout that runs after the code phases and before the PR — and are only verified
by `23-pr-and-review/`. Append the update date on every change.

## Cross-references

- `../02-STORIES/` — the user stories these records test
- `../17-STORY-PLANS/` — the per-story implementation plan the tests close the loop on
- `../11-QA/` — the QA plan (PLANNING) and review (IMPLEMENTATION) these records sit beside
- `../05-USER-FLOW/` — the consolidated journeys whose step numbers the manual rows reuse
- `code/docs/TESTING.md` · `code/docs/ACCESSIBILITY.md` — coverage floors and WCAG rules
- `code/src/scripts/tests/` — the runners, and the `test-record.sh` generator

**Last Updated**: <%DATE%>
