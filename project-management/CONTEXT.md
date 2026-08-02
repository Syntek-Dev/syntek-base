# project-management — PM Workflow, Stories & Compliance

## Directory Tree

```text
project-management/
├── CONTEXT.md               ← this file
├── REFERENCES.md            ← internal and external reference index for this layer
├── docs/                    ← PM reference guides
│   ├── CONTEXT.md
│   ├── gdpr/                    ← GDPR sub-documents (COMPLIANCE.md, DATA-RIGHTS.md)
│   ├── GDPR-GUIDE.md            ← GDPR obligations, data flows, and legal bases (index)
│   ├── GIT-GUIDE.md             ← branch strategy, commit format, PR flow, PR gates
│   ├── QA-GUIDE.md              ← QA planning and test documentation standards
│   ├── RESPONSIVE-DESIGN.md     ← breakpoints, mobile-first, responsive patterns
│   ├── SECURITY-GUIDE.md        ← security standards and threat modelling guide
│   ├── SEO-CHECKLIST.md         ← SEO and AI discoverability for all frontend pages
│   ├── SPRINT-PLANNING-GUIDE.md ← MoSCoW prioritisation and sprint format conventions
│   └── VERSIONING-GUIDE.md      ← root-only semver, files to update on every bump
├── export/                  ← PDF exports and zip archives for client delivery
├── src/                     ← live PM artefacts, in three tiers (see below)
│   ├── 00-ASSETS/               ← logos, brand assets, export scripts (pre-workflow ref)
│   │
│   │   ── Specify (01–12) ──
│   ├── 01-STORIES/              ← US###.md (user stories)
│   ├── 02-SPRINTS/              ← SPRINT-##.md (backlog → sprint organisation)
│   ├── 03-DATABASE/             ← SCHEMA-*.md, ERD-*.md, migration notes
│   ├── 04-USER-FLOW/            ← USER-FLOW-TEMPLATE.md + DIAGRAMS/
│   ├── 05-BRAND-GUIDE/          ← guide-build/ (Python → LaTeX → PDF brand guide)
│   ├── 06-COMPONENTS/           ← component-build/ (Python → LaTeX → PDF component sheet)
│   ├── 07-WIREFRAMES/           ← SCREENS/ (WF-###-*.html) + SHARED/wireframe.css
│   ├── 08-GDPR/                 ← 6 register skeletons + PLANNING/ + IMPLEMENTATION/
│   ├── 09-SECURITY/             ← THREAT-MODEL/ ASSESSMENTS/ AUDITS/ VULNERABILITIES/
│   ├── 10-QA/                   ← PLANNING/ + IMPLEMENTATION/
│   ├── 11-SEO/                  ← PLANNING/ + IMPLEMENTATION/
│   ├── 12-API-DESIGN/           ← PLANNING/ + IMPLEMENTATION/
│   │
│   │   ── Decide & plan (13–15) ──
│   ├── 13-DECISIONS/            ← ADR-###-<TITLE>.md
│   ├── 14-SPRINT-PLANS/         ← detailed sprint execution plans
│   ├── 15-STORY-PLANS/          ← per-story implementation plan (code master reference)
│   │
│   │   ── Implement & record (16–20) ──
│   ├── 16-TESTS/                ← US###-TEST-STATUS.md, US###-MANUAL-TESTING.md
│   ├── 17-REVIEWS/              ← REVIEW-US###-*.md
│   ├── 18-FINDINGS/             ← FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│   ├── 19-BUGS/                 ← BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│   └── 20-REFACTORING/          ← REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── workflows/               ← step-by-step PM workflows (01–21)
    ├── 01-story-creation/ … 12-api-design/     ← specify a feature
    ├── 13-decisions/ 14-sprint-plans/ 15-story-plans/  ← decide & plan
    ├── 16-backend-code/ 17-api-code/ 18-frontend-code/  ← implement
    ├── 19-implementation-documentation/         ← docs + implementation records
    ├── 20-pr-and-review/                        ← PR, review, merge
    └── 21-release/                              ← version bump, changelog, deploy
```

Every `src/` and `workflows/` sub-folder carries a `CONTEXT.md` + `CLAUDE.md`; each
workflow folder also has `STEPS.md` + `CHECKLIST.md`.

## When to read this

- Creating or updating a user story, sprint, decision (ADR), or plan
- Running a design/compliance spec (DB, user flow, GDPR, security, QA, SEO, API)
- Managing a PR through review and merge, or cutting a release

## Contents

- `docs/` — reference guides for PM, GDPR, SEO, security, QA, versioning, responsive design
- `export/` — PDF exports and zip archives of PM artefacts for client delivery
- `src/` — all live PM artefacts, in three tiers (specify → decide & plan → record)
- `workflows/` — step-by-step guides for PM tasks

## Do not use for

- Writing code → `code/CONTEXT.md`
- Environment setup, CLI usage → `how-to/CONTEXT.md`

## src/ structure — the three tiers

`00-ASSETS` is pre-workflow reference. The rest runs in three tiers; **08–15 tie their
artefacts to a user story** via per-story `PLANNING/` + `IMPLEMENTATION/` templates.

| Tier                      | Paths                                                                                               |
| ------------------------- | --------------------------------------------------------------------------------------------------- |
| **Specify** (01–12)       | stories, sprints, DB, user flow, brand, components, wireframes, GDPR, security, QA, SEO, API design |
| **Decide & plan** (13–15) | `13-DECISIONS/` (ADRs) → `14-SPRINT-PLANS/` → `15-STORY-PLANS/` (the code master)                   |
| **Record** (16–20)        | `16-TESTS/`, `17-REVIEWS/`, `18-FINDINGS/`, `19-BUGS/`, `20-REFACTORING/` — per story               |

The **story plan (15)** is what a developer codes from; it references its sprint plan
(14), the decisions (13), and every 01–12 spec. Sprint plans (14) feed the story plans.

## Workflow gates

- A feature is not ready to code until the specify → decide → plan tiers are complete
- A PR is not ready to merge until `workflows/20-pr-and-review/` is signed off
- A release is not ready until `workflows/21-release/` is followed
- Every new directory in any layer must have a `CONTEXT.md` (and a `CLAUDE.md`)

## Key docs

| Guide                       | When to read                                         |
| --------------------------- | ---------------------------------------------------- |
| `docs/GIT-GUIDE.md`         | Branch strategy, commit format, PR gates             |
| `docs/VERSIONING-GUIDE.md`  | Before any version bump or release                   |
| `docs/SEO-CHECKLIST.md`     | Before publishing a new page                         |
| `docs/GDPR-GUIDE.md`        | Before adding any feature that handles personal data |
| `docs/RESPONSIVE-DESIGN.md` | Before brand work, wireframing, or component design  |

**Last Updated**: <%DATE%>
