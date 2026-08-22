# project-management/src/20-FINDINGS

Findings records — one per user story, written **at story completion** to capture where the
delivered work diverged from the project's standards, and to steer the story that follows.
Base-repo scaffold: the folder ships **template-only**; real records are added by copying
`FINDING-US000-TEMPLATE.md` per story.

## Directory Tree

```text
project-management/src/20-FINDINGS/
├── CONTEXT.md                  ← this file (orientation)
├── CLAUDE.md                   ← operating rules
└── FINDING-US000-TEMPLATE.md   ← copy this to record a story's findings
```

## Where this sits — the record tier

The `src/` folders run in three tiers: **15-DECISIONS → 16-SPRINT-PLANS → 17-STORY-PLANS →
code → 18–22 records**. This folder is a **record** (18-TESTS, 19-REVIEWS, **20-FINDINGS**,
21-BUGS, 22-REFACTORING) — written _after_ code exists, closing the loop on the story plan
(15) the developer coded from.

It is deliberately distinct from its siblings:

| Folder           | Answers                                                  |
| ---------------- | -------------------------------------------------------- |
| `19-REVIEWS`     | Is this PR fit to merge?                                 |
| `20-FINDINGS`    | What did shipping this story reveal about the standards? |
| `21-BUGS`        | What is broken, and how was it fixed?                    |
| `22-REFACTORING` | What was restructured, without behaviour change?         |

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
`project-management/workflows/22-implementation-documentation/` — after the code and its
documentation land, before the PR is raised. One record per story; if a story surfaces
nothing, record that explicitly rather than skipping the file.

## Cross-references

- `FINDING-US000-TEMPLATE.md` — the per-story findings template
- `../02-STORIES/` — the stories findings are anchored to
- `../17-STORY-PLANS/` — the code master a finding closes the loop on, and the next plan it feeds
- `../19-REVIEWS/` — the merge-gating review from the same PR
- `../21-BUGS/` — where a finding that is a defect is escalated
- `../22-REFACTORING/` — where a finding that is structural debt is actioned
- `../15-DECISIONS/` — where a finding that settles a hard-to-reverse trade-off graduates
- `code/docs/DATABASE.md` — the data-layer rules findings are assessed against
- `project-management/workflows/22-implementation-documentation/` — where these are written

**Last Updated**: <%DATE%>
