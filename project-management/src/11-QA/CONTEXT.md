# project-management/src/11-QA

QA artefacts, per user story. The base repo ships this as a **per-story scaffold**: a
pre-development `PLANNING/` QA plan and a post-implementation `IMPLEMENTATION/` QA review,
tied to a story at both ends, mirroring the 09-GDPR split.

## Directory Tree

```text
project-management/src/11-QA/
├── CONTEXT.md · CLAUDE.md
├── PLANNING/                     ← pre-development QA plan, one per story
│   ├── CONTEXT.md · CLAUDE.md
│   └── QA-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/               ← post-implementation QA review, one per story
    ├── CONTEXT.md · CLAUDE.md
    └── QA-IMPL-US000-TEMPLATE.md
```

Each folder ships one `US000-TEMPLATE.md`; a project copies it per story. QA is **per
story** — there is no cross-cutting by-scope report folder (that role is served by the
per-story plans, as in 09-GDPR).

## When to use this

| Folder            | When                                                | Workflow                      |
| ----------------- | --------------------------------------------------- | ----------------------------- |
| `PLANNING/`       | After wireframe sign-off, before development begins | `workflows/11-qa-checks/`     |
| `IMPLEMENTATION/` | After code is written, during PR review             | `workflows/23-pr-and-review/` |

## PLANNING ↔ IMPLEMENTATION — per story

- `PLANNING/QA-PLAN-US###-<DESCRIPTOR>.md` — the pre-development QA plan: acceptance-
  criteria gaps, test scenarios (happy path, error states, edge cases, permission and
  access), and accessibility / GDPR constraints, derived from the wireframe and user flow.
- `IMPLEMENTATION/QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` — the post-implementation
  review verifying each planned scenario against the running build, recording deviations
  and new edge cases, and carrying the sign-off before merge.

## Relationship to 18-TESTS/

QA artefacts here precede or accompany development. Once a story is merged, automated
test status and manual guides live in `project-management/src/18-TESTS/` — do not
duplicate them here.

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `project-management/workflows/11-qa-checks/` — produces the `PLANNING/` plan
- `project-management/workflows/23-pr-and-review/` — produces the `IMPLEMENTATION/` review
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/src/08-WIREFRAMES/` · `src/10-SECURITY/` — the design and security
  artefacts a QA plan is written against
- `project-management/src/18-TESTS/` — post-development test status and manual guides

**Last Updated**: <%DATE%>
