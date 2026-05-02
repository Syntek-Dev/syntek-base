# project-management — PM Workflow, Stories & Compliance

## Directory Tree

```text
project-management/
├── CONTEXT.md               ← this file
├── docs/                    ← PM reference guides
│   ├── CONTEXT.md
│   ├── GDPR-GUIDE.md            ← lawful basis, retention, data rights
│   ├── GIT-GUIDE.md             ← branch strategy, commit format, PR flow, PR gates
│   ├── QA-GUIDE.md              ← QA planning at design stage — test scenario format
│   ├── RESPONSIVE-DESIGN.md     ← breakpoints, media vs container queries, viewport testing
│   ├── SECURITY-GUIDE.md        ← STRIDE threat modelling, severity levels, document format
│   ├── SEO-CHECKLIST.md         ← SEO and AI discoverability for all frontend pages
│   ├── SPRINT-PLANNING-GUIDE.md ← sprint plan format, MoSCoW prioritisation, phases
│   └── VERSIONING-GUIDE.md      ← root-only semver, files to update on every bump
├── src/                        ← live PM artefacts (stories, sprints, bugs, …)
│   ├── 00-ASSETS/              ← ERD diagrams, user-flow diagrams, logos
│   │   └── CONTEXT.md
│   ├── 00-DECISIONS/           ← ADR-###-*.md (architectural decision records)
│   │   └── CONTEXT.md
│   ├── 00-PLANS/               ← PLAN-<FEATURE>.md, PLAN-US###-*.md
│   │   └── CONTEXT.md
│   ├── 01-STORIES/             ← US###.md
│   │   └── CONTEXT.md
│   ├── 02-SPRINTS/             ← SPRINT-##.md
│   │   └── CONTEXT.md
│   ├── 03-DATABASE/            ← SCHEMA-*.md, ERD-*.md, MIGRATION-NOTES-*.md
│   │   └── CONTEXT.md
│   ├── 04-USER-FLOW/           ← USER-FLOW-<AREA>.md
│   │   └── CONTEXT.md
│   ├── 05-BRAND-GUIDE/         ← brand identity, colour palette, typography
│   │   └── CONTEXT.md
│   ├── 06-COMPONENTS/          ← component design specs
│   │   └── CONTEXT.md
│   ├── 07-WIREFRAMES/          ← WF-<US###>-*.md, WF-<SCREEN>-*.md
│   │   └── CONTEXT.md
│   ├── 08-GDPR/                ← data inventory, consent, retention, breach docs
│   │   └── CONTEXT.md
│   ├── 09-SECURITY/            ← AUDIT-*.md, threat models, assessments
│   │   └── CONTEXT.md
│   ├── 10-QA/                  ← QA-US###-<DESCRIPTION>.md
│   │   └── CONTEXT.md
│   ├── 11-SEO/                 ← SEO planning documents
│   │   ├── CONTEXT.md
│   │   └── PLANNING/
│   │       └── CONTEXT.md
│   ├── 12-API-DESIGN/          ← API-US###-*.md, API-<FEATURE>-*.md
│   │   └── CONTEXT.md
│   ├── 13-SPRINT-PLANS/        ← SPRINT-PLAN-##.md
│   │   └── CONTEXT.md
│   ├── 14-TESTS/               ← US###-TEST-STATUS.md, US###-MANUAL-TESTING.md
│   │   └── CONTEXT.md
│   ├── 15-REVIEWS/             ← REVIEW-US###-*.md, REVIEW-<TOPIC>.md
│   │   └── CONTEXT.md
│   ├── 16-BUGS/                ← BUG-<DESCRIPTOR>-DD-MM-YYYY.md
│   │   └── CONTEXT.md
│   └── 17-REFACTORING/         ← REFACTORING-US###-*.md, REFACTORING-<TOPIC>.md
│       └── CONTEXT.md
└── workflows/                  ← step-by-step PM workflows
    ├── CONTEXT.md
    ├── 01-story-creation/      ← write a well-formed user story
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 02-sprint-planning/     ← organise stories into a balanced sprint
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 03-database-schema/     ← design and sign off a database schema
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 04-user-flow-design/    ← map user journeys before wireframing
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 05-brand-guides/        ← define and document the visual brand identity
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 06-component-designs/   ← design reusable UI components
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 07-wireframes/          ← create and sign off wireframes
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 08-gdpr-compliance/     ← review a feature for GDPR compliance
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 09-security-checks/     ← threat-model planned features before sprint planning
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 10-qa-checks/           ← define QA scenarios for each story before development
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 11-seo-checks/          ← verify SEO requirements before a story is closed
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 12-api-design/          ← design the GraphQL contract before sprint planning
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 13-sprint-plans/        ← write the sprint plan (MoSCoW, phases, definition of done)
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 14-backend-code/        ← implement Django models, services, business logic
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 15-api-code/            ← implement the Strawberry GraphQL API layer
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 16-frontend-code/       ← implement Next.js pages and React components
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 17-app-code/            ← implement Expo React Native screens and components
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 18-pr-and-review/       ← create, review, and merge a feature PR
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    └── 19-release/             ← cut a release (version bump, changelog, deploy)
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

| Guide                           | When to read                                            |
| ------------------------------- | ------------------------------------------------------- |
| `docs/GIT-GUIDE.md`             | Branch strategy, commit format, PR gates                |
| `docs/VERSIONING-GUIDE.md`      | Before any version bump or release                      |
| `docs/SEO-CHECKLIST.md`         | Before publishing a new page                            |
| `docs/GDPR-GUIDE.md`            | Before adding any feature that handles personal data    |
| `docs/RESPONSIVE-DESIGN.md`     | Before wireframing, designing, or testing any UI screen |
| `docs/QA-GUIDE.md`              | Before writing QA scenarios for a story                 |
| `docs/SECURITY-GUIDE.md`        | Before threat-modelling a planned feature               |
| `docs/SPRINT-PLANNING-GUIDE.md` | Before planning or writing a sprint plan                |

## src/ structure

Numbered to mirror the `workflows/` steps. `00-` folders are pre-workflow reference material.

| Path                   | Contains                                     |
| ---------------------- | -------------------------------------------- |
| `src/00-ASSETS/`       | ERD diagrams, user-flow diagrams, logos      |
| `src/00-DECISIONS/`    | Architectural decision records (ADR-###)     |
| `src/00-PLANS/`        | Architectural and feature plans              |
| `src/01-STORIES/`      | User stories (US###.md)                      |
| `src/02-SPRINTS/`      | Sprint plans and logs                        |
| `src/03-DATABASE/`     | Schema designs, ERDs, migration notes        |
| `src/04-USER-FLOW/`    | User journey maps per product area           |
| `src/05-BRAND-GUIDE/`  | Brand identity, colour palette, typography   |
| `src/06-COMPONENTS/`   | Component design specs                       |
| `src/07-WIREFRAMES/`   | Wireframes per user story or screen          |
| `src/08-GDPR/`         | GDPR data inventory, consent, retention docs |
| `src/09-SECURITY/`     | Security audits, threat models, assessments  |
| `src/10-QA/`           | QA test files per user story                 |
| `src/11-SEO/`          | SEO planning documents                       |
| `src/12-API-DESIGN/`   | GraphQL API design documents                 |
| `src/13-SPRINT-PLANS/` | Sprint plan documents                        |
| `src/14-TESTS/`        | Test status and manual testing guides        |
| `src/15-REVIEWS/`      | Code review notes                            |
| `src/16-BUGS/`         | Bug reports and related user stories         |
| `src/17-REFACTORING/`  | Refactoring plans and notes                  |
