# project-management/src/21-BUGS

Bug reports, per user story. The base repo ships this folder **template-only** as a
scaffold: one `BUG-US000-TEMPLATE.md` a project copies per defect. Real reports are added
by copying it; nothing else lives here until a bug is filed.

## Directory Tree

```text
project-management/src/21-BUGS/
├── CONTEXT.md              ← this file (orientation)
├── CLAUDE.md               ← operating rules
└── BUG-US000-TEMPLATE.md   ← copy this to file a bug report
```

## Where this sits — the record tier

The `src/` folders run in three tiers: **15-DECISIONS → 16-SPRINT-PLANS → 17-STORY-PLANS →
code → 18–22 records**. This folder is a **record** (18-TESTS, 19-REVIEWS, 20-FINDINGS, **21-BUGS**,
22-REFACTORING) — written _after_ code exists, to close the loop on the story plan (17) the
developer coded from. The fix itself ships in `code/`; this folder records the defect, not
the patch.

## What the record captures

One defect per file: metadata (affected story + severity + date found + status + found-during),
a one-line summary, the environment, numbered reproduction steps, Expected vs Actual, a
root-cause analysis, the fix (files touched + approach), a **regression test** written
test-first (TDD), impact & related stories, and verification via the project test scripts.

## When to write it

File a report when a defect is isolated — during `code/workflows/10-debug/`, or in
`project-management/workflows/11-qa-checks/` / `23-pr-and-review/` review, or from a
production incident. Copy the template, complete every section, link the story, and flip the
status to `Fixed` (then `Verified`) as the fix lands.

## Cross-references

- `BUG-US000-TEMPLATE.md` — the per-defect report template
- `../02-STORIES/` — the stories bugs are anchored to
- `../17-STORY-PLANS/` — the code master a fix closes the loop on
- `../19-REVIEWS/` · `../18-TESTS/` — the review and test records from the same PR
- `code/workflows/10-debug/` · `code/workflows/09-debugging-with-logs/` — the debug procedures

**Last Updated**: <%DATE%>
