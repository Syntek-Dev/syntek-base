# project-management/src/18-TESTS/MANUAL

Per-story **manual testing guides** — the journeys a tester or Claude Chrome walks step by step,
and whether each step passed. A guide is written **before** the code it tests, from the story's
specifications, alongside its story plan. That is what makes it worth having: it states what the
build should do before there is a build for it to agree with, so when it is walked after the code
ships it is an independent oracle rather than a description of whatever was built.

## Directory Tree

```text
project-management/src/18-TESTS/MANUAL/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules: authoring, row IDs, Flow and QA columns, build captures, the walk, amendments
├── US000-MANUAL-TESTING.md   ← template: copied to US###-MANUAL-TESTING.md at 17-story-plans
└── US###-MANUAL-TESTING.md   ← one guide per story
```

## What a guide holds

A header naming the story, its plan, the surface under test and the spec artefacts the guide was
authored from; the preconditions, seed data and any open question; _Recorded during the build_,
the captures a spec requires the build to take — a baseline, an inventory — which the rows are
later compared with; one section per **journey area**, its rows in the order a person moves
through the product; then permission and access, accessibility and responsive behaviour as
journeys of their own; the failures; and a tester sign-off.

Each row carries seven cells:

| Column               | Holds                                                                                        |
| -------------------- | -------------------------------------------------------------------------------------------- |
| **ID**               | `{AREA}-{NN}` — the row's own permanent identifier                                           |
| **Action**           | What a person does, naming each control by what they see                                     |
| **Expected outcome** | What the specs say should happen                                                             |
| **Flow**             | The consolidated user-flow step the row exercises, cited — or `—`                            |
| **QA**               | The QA-plan scenario the row exercises, cited — or `—`                                       |
| **Result**           | `Pass` or `Fail` once walked; blank until then                                               |
| **Notes**            | A failure's reason, the trail of a row changed after authoring, or the question a row awaits |

Because a row names what a person sees rather than how the page is built, the same file serves
a human tester and a browser agent.

## One file across the lifecycle

The same file is authored at `17-story-plans`, gains its `Flow` column at
`18-consolidate-design-work`, has its captures filled during the build, is read at the Red phase,
walked and marked at `22-implementation-documentation`, and verified at `23-pr-and-review`. The
stage table is `../CLAUDE.md` → _The record lifecycle_.

## Cross-references

- `US000-MANUAL-TESTING.md` — the template every guide is copied from
- `../AUTOMATED/` — the paired automated record; a manual `Fail` beside a green suite is a missing test
- `../CLAUDE.md` — the record lifecycle and the three-record boundary
- `../../17-STORY-PLANS/` — the plan each guide is authored beside
- `../../11-QA/PLANNING/` — where the `QA` column's scenario IDs are defined
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers are defined
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA rules for the accessibility journey

**Last Updated**: <%DATE%>
