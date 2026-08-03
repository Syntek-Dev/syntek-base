# project-management/src/11-QA/IMPLEMENTATION

Post-implementation QA reviews — **one per user story**. Each review verifies, with
evidence, that a story's pre-development QA plan in `../PLANNING/` was satisfied by the
shipped code, records deviations and newly discovered edge cases, and carries the
sign-off before the PR merges.

## Directory Tree

```text
project-management/src/11-QA/IMPLEMENTATION/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
├── QA-IMPL-US000-TEMPLATE.md         ← copy this to record a story's QA review
└── QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md  ← one review per implemented story
```

## File naming

```text
QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
```

Example: `QA-IMPL-US000-CONTACT-FORM-01-01-2026.md`. Descriptor in SCREAMING-KEBAB-CASE.

## When to create a file here

Write a review during `project-management/workflows/21-implementation-documentation/`, once a story's
code is ready for review and before the story closes. Copy `QA-IMPL-US000-TEMPLATE.md`,
open the story's plan in `../PLANNING/QA-PLAN-US###-*.md`, and verify each planned
scenario against the running build.

## What belongs in each review

- Story reference (US###), date, sprint, reviewer, and a link to the pre-development plan
- Each plan scenario (HP / ES / EC / PA) marked Pass / Fail / Deviation with evidence
- The plan's acceptance-criteria gaps (AC-GAP-n) closed **with evidence** or carried forward
- Deviations from the plan, justified
- New edge cases discovered during implementation
- Accessibility (WCAG 2.2 AA) and GDPR / security observations against the running build
- A sign-off checklist that blocks the merge until complete

## Cross-references

- `QA-IMPL-US000-TEMPLATE.md` — the per-story review template
- `../PLANNING/` — the pre-development QA plans these reviews verify
- `../CONTEXT.md` — the QA folder overview and the per-story PLANNING/IMPLEMENTATION split
- `../../02-STORIES/` — the user stories under review
- `../../17-TESTS/` · `../../18-REVIEWS/` — downstream test status and code-review notes
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/21-implementation-documentation/` — where these reviews are written

**Last Updated**: <%DATE%>
