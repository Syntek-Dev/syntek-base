# project-management/src/19-FINDINGS

Findings records — one per user story, written **at story completion** to capture where the
delivered work diverged from the project's standards, and to steer the story that follows.
Base-repo scaffold: the folder ships **template-only**; real records are added by copying
`FINDING-US000-TEMPLATE.md` per story.

## Directory Tree

```text
project-management/src/19-FINDINGS/
├── CONTEXT.md                  ← this file (orientation)
├── CLAUDE.md                   ← operating rules
└── FINDING-US000-TEMPLATE.md   ← copy this to record a story's findings
```

## Naming

```text
FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md   ← primary: findings from closing one story
FINDING-<DESCRIPTOR>-DD-MM-YYYY.md         ← fallback: a genuinely cross-cutting sweep
```

The **story-anchored form leads** — a findings record is written as a story closes, so it
carries its `US###`. A standalone audit not owned by one story (a periodic schema sweep, a
dependency review) uses the story-less fallback and leaves the story fields as
`N/A — cross-cutting`. Descriptor in `SCREAMING-KEBAB-CASE`; date is the completion date,
`DD-MM-YYYY`; story numbers zero-padded to three digits (`US###`).

## Where this sits — the record tier

The `src/` folders run in three tiers: **14-DECISIONS → 15-SPRINT-PLANS → 16-STORY-PLANS →
code → 17–21 records**. This folder is a **record** (17-TESTS, 18-REVIEWS, **19-FINDINGS**,
20-BUGS, 21-REFACTORING) — written _after_ code exists, closing the loop on the story plan
(15) the developer coded from.

It is deliberately distinct from its siblings:

| Folder           | Answers                                                  |
| ---------------- | -------------------------------------------------------- |
| `18-REVIEWS`     | Is this PR fit to merge?                                 |
| `19-FINDINGS`    | What did shipping this story reveal about the standards? |
| `20-BUGS`        | What is broken, and how was it fixed?                    |
| `21-REFACTORING` | What was restructured, without behaviour change?         |

A review gates a merge and closes with the PR. A finding **outlives** the story: it is the
input that shapes the next story's plan.

## What the record captures

Per finding: what was found, where, why it matters, the smallest fix, and whether it is
**cheap to change later or expensive to retrofit**. Schema shape, a missing scope column,
and absent constraints are expensive; a missing index or an unwritten docstring is cheap.
Each finding carries a disposition — carried into the next story, deferred with a named
target, raised as a bug, or accepted with a reason.

Findings are recorded, **not fixed in place**. The record states the smallest fix; the fix
itself lands in a later story, a bug report, or a refactor.

## When to write it

At story completion, during
`project-management/workflows/21-implementation-documentation/` — after the code and its
documentation land, before the PR is raised. One record per story; if a story surfaces
nothing, record that explicitly rather than skipping the file.

## Cross-references

- `FINDING-US000-TEMPLATE.md` — the per-story findings template
- `../02-STORIES/` — the stories findings are anchored to
- `../16-STORY-PLANS/` — the code master a finding closes the loop on, and the next plan it feeds
- `../18-REVIEWS/` — the merge-gating review from the same PR
- `../20-BUGS/` — where a finding that is a defect is escalated
- `../21-REFACTORING/` — where a finding that is structural debt is actioned
- `../14-DECISIONS/` — where a finding that settles a hard-to-reverse trade-off graduates
- `code/docs/DATABASE.md` — the data-layer rules findings are assessed against
- `project-management/workflows/21-implementation-documentation/` — where these are written

**Last Updated**: <%DATE%>
