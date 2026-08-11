# project-management/src/18-REVIEWS

Code-review records — one per user story, capturing findings, dimension checks, and the
merge verdict for a story's branch/PR. Base-repo scaffold: the folder ships **template-only**;
real records are added by copying the template per story.

## Directory Tree

```text
project-management/src/18-REVIEWS/
├── CONTEXT.md                 ← this file
├── CLAUDE.md                  ← operating rules for this folder
└── REVIEW-US000-TEMPLATE.md   ← the per-story review template — copy for each review
```

Real records (`REVIEW-US###-<DESCRIPTOR>.md`) are **not** shipped in the base repo; each is
created by copying `REVIEW-US000-TEMPLATE.md` when a story's PR is reviewed.

## Where it sits (record tier)

```text
14-DECISIONS → 15-SPRINT-PLANS → 16-STORY-PLANS → code → 17–21 records
                                                          (17-TESTS · 18-REVIEWS · 19-FINDINGS · 20-BUGS · 21-REFACTORING)
```

A review (18) is a **record-tier** artefact: it is written **after** the code ships, closing
the loop on the `16-STORY-PLANS` plan the story was coded from and reading against the
`17-TESTS` status.

## What the record captures

- Metadata — story `US###`, branch/PR, reviewer, date, and the verdict
  (Approve / Approve-with-nits / Changes-requested)
- Scope and the files reviewed
- A findings table (`R-0NN` · severity Critical/High/Medium/Low/Info · `file:line` · issue ·
  resolution/status)
- Dimension checklists — Security (OWASP A01, IDOR, secrets/DEBUG), GDPR/PII, test coverage
  vs floors, quality/DRY/file-length, performance (N+1), accessibility (WCAG 2.2 AA)
- Required actions before merge, and the status transition (e.g. In Review → Accepted)

## When to write it

During `project-management/workflows/22-pr-and-review/` (and the code-review workflow
`code/workflows/07-review/`), once a story's code is ready for review and before it merges.
Copy the template, complete every section against the branch, and drive every finding to a
resolution. A `Changes-requested` verdict blocks the merge until re-review.

## Cross-references

- `REVIEW-US000-TEMPLATE.md` — the per-story review template
- `../02-STORIES/` — the stories under review
- `../16-STORY-PLANS/` — the implementation plans reviews close the loop on
- `../17-TESTS/` — the test status/manual guides a review reads against
- `../11-QA/IMPLEMENTATION/` — the paired QA review from the same PR
- `project-management/workflows/22-pr-and-review/` — where these reviews are written
- `code/docs/SECURITY.md` — the OWASP / IDOR obligations the security checklist rests on

**Last Updated**: <%DATE%>
