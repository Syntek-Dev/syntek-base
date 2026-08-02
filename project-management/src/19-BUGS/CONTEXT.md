# project-management/src/19-BUGS

Bug reports, per user story. The base repo ships this folder **template-only** as a
scaffold: one `BUG-US000-TEMPLATE.md` a project copies per defect. Real reports are added
by copying it; nothing else lives here until a bug is filed.

## Directory Tree

```text
project-management/src/19-BUGS/
├── CONTEXT.md              ← this file (orientation)
├── CLAUDE.md               ← operating rules
└── BUG-US000-TEMPLATE.md   ← copy this to file a bug report
```

## Naming

```text
BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md      ← primary: a defect owned by one story
BUG-<DESCRIPTOR>-DD-MM-YYYY.md            ← fallback: a genuinely cross-cutting defect
```

The **story-anchored form leads** — most defects surface while closing a single story, so
the report carries its `US###`. A genuinely cross-cutting defect (an audit finding, a
shared-infrastructure fault not owned by one story) uses the story-less fallback and leaves
the story fields as `N/A — cross-cutting`. Descriptor in `SCREAMING-KEBAB-CASE`; date is the
discovery date, `DD-MM-YYYY`; story numbers zero-padded to three digits (`US###`).

## Where this sits — the record tier

The `src/` folders run in three tiers: **13-DECISIONS → 14-SPRINT-PLANS → 15-STORY-PLANS →
code → 16–20 records**. This folder is a **record** (16-TESTS, 17-REVIEWS, 18-FINDINGS, **19-BUGS**,
20-REFACTORING) — written _after_ code exists, to close the loop on the story plan (15) the
developer coded from. The fix itself ships in `code/`; this folder records the defect, not
the patch.

## What the record captures

One defect per file: metadata (affected story + severity + date found + status + found-during),
a one-line summary, the environment, numbered reproduction steps, Expected vs Actual, a
root-cause analysis, the fix (files touched + approach), a **regression test** written
test-first (TDD), impact & related stories, and verification via the project test scripts.

## When to write it

File a report when a defect is isolated — during `code/workflows/10-debug/`, or in
`project-management/workflows/10-qa-checks/` / `20-pr-and-review/` review, or from a
production incident. Copy the template, complete every section, link the story, and flip the
status to `Fixed` (then `Verified`) as the fix lands.

## Cross-references

- `BUG-US000-TEMPLATE.md` — the per-defect report template
- `../01-STORIES/` — the stories bugs are anchored to
- `../15-STORY-PLANS/` — the code master a fix closes the loop on
- `../17-REVIEWS/` · `../16-TESTS/` — the review and test records from the same PR
- `code/workflows/10-debug/` · `code/workflows/09-debugging-with-logs/` — the debug procedures

**Last Updated**: <%DATE%>
