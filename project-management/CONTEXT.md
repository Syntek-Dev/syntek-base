# project-management — PM Workflow, Stories & Compliance

## Directory Tree

```text
project-management/
├── CONTEXT.md               ← this file
├── docs/                    ← PM reference guides
│   ├── CONTEXT.md
│   ├── GDPR-GUIDE.md        ← lawful basis, retention, data rights
│   ├── GIT-GUIDE.md         ← branch strategy, commit format, PR flow, PR gates
│   ├── SEO-CHECKLIST.md     ← SEO and AI discoverability for all frontend pages
│   └── VERSIONING-GUIDE.md  ← root-only semver, files to update on every bump
├── src/                     ← live PM artefacts (stories, sprints, bugs, …)
│   ├── BUGS/                ← BUG-<DESCRIPTOR>-DD-MM-YYYY.md
│   │   └── CONTEXT.md
│   ├── DATABASE/            ← SCHEMA-*.md, ERD-*.md, MIGRATION-NOTES-*.md
│   │   └── CONTEXT.md
│   ├── GDPR/                ← data inventory, consent, retention, breach docs
│   │   └── CONTEXT.md
│   ├── PLANS/               ← PLAN-<FEATURE>.md, PLAN-US###-*.md
│   │   └── CONTEXT.md
│   ├── QA/                  ← QA-US###-<DESCRIPTION>.md
│   │   └── CONTEXT.md
│   ├── REFACTORING/         ← REFACTORING-US###-*.md, REFACTORING-<TOPIC>.md
│   │   └── CONTEXT.md
│   ├── REVIEWS/             ← REVIEW-US###-*.md, REVIEW-<TOPIC>.md
│   │   └── CONTEXT.md
│   ├── SECURITY/            ← AUDIT-*.md, threat models, assessments
│   │   └── CONTEXT.md
│   ├── SPRINTS/             ← SPRINT-##.md
│   │   └── CONTEXT.md
│   ├── STORIES/             ← US###.md
│   │   └── CONTEXT.md
│   ├── TESTS/               ← US###-TEST-STATUS.md, US###-MANUAL-TESTING.md
│   │   └── CONTEXT.md
│   └── WIREFRAMES/          ← WF-<US###>-*.md, WF-<SCREEN>-*.md
│       └── CONTEXT.md
└── workflows/               ← step-by-step PM workflows
    ├── CONTEXT.md
    ├── 01-story-creation/   ← write a well-formed user story
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 02-sprint-planning/  ← organise stories into a balanced sprint
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 03-database-schema/  ← design and sign off a database schema
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 04-wireframes/       ← create and sign off wireframes
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 05-pr-and-review/    ← create, review, and merge a feature PR
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 06-gdpr-compliance/  ← review a feature for GDPR compliance
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    └── 07-release/          ← cut a release (version bump, changelog, deploy)
        ├── CHECKLIST.md
        ├── CONTEXT.md
        └── STEPS.md
```

## When to read this

- Creating or updating a user story (US###)
- Sprint planning or retrospective
- Managing a PR through the review and merge lifecycle
- Cutting a release (version bump + changelog)
- GDPR compliance review of a new feature
- SEO implementation on a page
- Using Syntek Dev Suite agents (`/syntek-dev-suite:*`)

## Contents

- `docs/` — Reference guides for PM, GDPR, SEO
- `src/` — All live PM artefacts (stories, sprints, plans, reviews, bugs, QA, tests)
- `workflows/` — Step-by-step guides for PM tasks

## Do not use for

- Writing code → `code/CONTEXT.md`
- Environment setup, CLI usage → `how-to/CONTEXT.md`

## Key docs

| Guide                      | When to read                                         |
| -------------------------- | ---------------------------------------------------- |
| `docs/GIT-GUIDE.md`        | Branch strategy, commit format, PR gates             |
| `docs/VERSIONING-GUIDE.md` | Before any version bump or release                   |
| `docs/SEO-CHECKLIST.md`    | Before publishing a new page                         |
| `docs/GDPR-GUIDE.md`       | Before adding any feature that handles personal data |

## src/ structure

| Path               | Contains                                     |
| ------------------ | -------------------------------------------- |
| `src/STORIES/`     | User stories (US###.md)                      |
| `src/SPRINTS/`     | Sprint plans and logs                        |
| `src/PLANS/`       | Architectural and feature plans              |
| `src/BUGS/`        | Bug reports and related user stories         |
| `src/QA/`          | QA test files per user story                 |
| `src/TESTS/`       | Test status and manual testing guides        |
| `src/REVIEWS/`     | Code review notes                            |
| `src/REFACTORING/` | Refactoring plans and notes                  |
| `src/SECURITY/`    | Security audits, threat models, assessments  |
| `src/GDPR/`        | GDPR data inventory, consent, retention docs |
