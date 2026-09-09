# project-management/src/11-QA/PLANNING

Pre-development QA plans — **one plan per user story**. Each plan derives a complete set
of test scenarios from the story's wireframe and user flow before any code is written:
acceptance-criteria gaps, happy-path / error-state / edge-case / permission scenarios,
accessibility and responsive expectations, and any GDPR or security constraints.

## Directory Tree

```text
project-management/src/11-QA/PLANNING/
├── CONTEXT.md                    ← this file
├── CLAUDE.md                     ← operating rules for this folder
├── QA-PLAN-US000-TEMPLATE.md     ← copy this to start a story's QA plan
└── QA-PLAN-US###-<DESCRIPTOR>.md ← one plan per story
```

## How it works

A plan is tied to a story, mirroring its post-implementation counterpart in
`../IMPLEMENTATION/`. Copy `QA-PLAN-US000-TEMPLATE.md` to
`QA-PLAN-US###-<DESCRIPTOR>.md` and complete it: the acceptance-criteria gaps found while
planning tests, the four Given/When/Then scenario tables (happy path `HP-nn`, error states
`ES-nn`, edge cases `EC-nn`, permission and access `PA-nn`), the WCAG 2.2 AA and responsive
expectations, and the GDPR/security constraints the story introduces. Those scenarios are
then verified — against the running build — in the matching
`../IMPLEMENTATION/QA-IMPL-US###-*.md` review.

Any acceptance-criteria gap found here feeds back into `../../02-STORIES/US###.md` before
the sprint plan locks scope: an `[OPEN]` gap must be resolved (re-tagged `[RESOLVED]` with
its date) in the story first.

## When to write one

- After wireframe sign-off and security checks, before development on the story begins
- When running `project-management/workflows/11-qa-checks/`
- When deriving a story's test scope and acceptance criteria from its wireframe

## The three-record boundary, and where these IDs travel

**This folder is the specifying half of one question: were the story's scenarios met?** The answer
is recorded next door in `../IMPLEMENTATION/`. Two other records look alike and ask different
questions — `../../05-USER-FLOW/IMPLEMENTATION/` asks whether the **flow exists** as it was
designed, and `../../18-TESTS/` asks whether **executing the tests** passed. Each owns its own
rules; read them there.

**The `HP-nn` / `ES-nn` / `EC-nn` / `PA-nn` IDs are defined here and cited downstream.** Besides
`../IMPLEMENTATION/`, the manual walk-through `../../18-TESTS/US###-MANUAL-TESTING.md` cites them
in its `QA` column — one scenario per walked row — and never redefines them. Renumbering a
scenario after the plan is written therefore invalidates citations in two files, not one, and
neither of them raises an error.

## Cross-references

- `QA-PLAN-US000-TEMPLATE.md` — the per-story QA plan template
- `../IMPLEMENTATION/` — the post-implementation reviews that verify these plans
- `../CONTEXT.md` — the 11-QA folder overview and the per-story QA lifecycle
- `../../02-STORIES/` · `../../08-WIREFRAMES/` — the story and wireframe a plan is written against
- `project-management/docs/QA-GUIDE.md` — the governing QA guide

**Last Updated**: <%DATE%>
