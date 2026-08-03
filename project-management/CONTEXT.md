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
│   ├── PLANNING-GUIDE.md ← MoSCoW prioritisation and sprint format conventions
│   └── VERSIONING-GUIDE.md      ← root-only semver, files to update on every bump
├── export/                  ← PDF exports and zip archives for client delivery
├── src/                     ← live PM artefacts, in three tiers (see below)
│   ├── 00-ASSETS/               ← logos, brand assets, export scripts (pre-workflow ref)
│   │
│   │   ── Discover (01) ──
│   ├── 01-FEATURE/              ← MAP-<FEATURE>.md (wayfinder decision maps)
│   │
│   │   ── Specify (02–13) ──
│   ├── 02-STORIES/              ← US###.md (user stories)
│   ├── 03-SPRINTS/              ← SPRINT-##.md (backlog → sprint organisation)
│   │   (03–07: USER-STORY-IDEAS/ → CONSOLIDATED-IDEAS/ → IMPLEMENTATION/ + a cumulative asset)
│   ├── 04-DATABASE/             ← 3 stages + ERD-DIAGRAMS/
│   ├── 05-USER-FLOW/            ← 3 stages + DIAGRAMS/
│   ├── 06-BRAND-GUIDE/          ← 3 stages + guide-build/ (Python → LaTeX → PDF)
│   ├── 07-COMPONENTS/           ← 3 stages + component-build/ (Python → LaTeX → PDF)
│   ├── 08-WIREFRAMES/           ← 3 stages + SHARED/wireframe.css
│   ├── 09-GDPR/                 ← 6 register skeletons + PLANNING/ + IMPLEMENTATION/
│   ├── 10-SECURITY/             ← THREAT-MODEL/ ASSESSMENTS/ AUDITS/ VULNERABILITIES/
│   ├── 11-QA/                   ← PLANNING/ + IMPLEMENTATION/
│   ├── 12-SEO/                  ← PLANNING/ + IMPLEMENTATION/
│   ├── 13-API-DESIGN/           ← PLANNING/ + IMPLEMENTATION/
│   │
│   │   ── Decide & plan (14–16) ──
│   ├── 14-DECISIONS/            ← ADR-###-<TITLE>.md
│   ├── 15-SPRINT-PLANS/         ← detailed sprint execution plans
│   ├── 16-STORY-PLANS/          ← per-story implementation plan (code master reference)
│   │
│   │   ── Implement & record (17–21) ──
│   ├── 17-TESTS/                ← US###-TEST-STATUS.md, US###-MANUAL-TESTING.md
│   ├── 18-REVIEWS/              ← REVIEW-US###-*.md
│   ├── 19-FINDINGS/             ← FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│   ├── 20-BUGS/                 ← BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│   └── 21-REFACTORING/          ← REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── workflows/               ← step-by-step PM workflows (01–22)
    ├── 02-story-creation/ … 13-api-design/     ← specify a feature
    ├── 14-decisions/ 15-sprint-plans/ 16-story-plans/  ← decide & plan
    ├── 18-backend-code/ 19-api-code/ 20-frontend-code/  ← implement
    ├── 21-implementation-documentation/         ← docs + implementation records
    ├── 22-pr-and-review/                        ← PR, review, merge
    └── 23-release/                              ← version bump, changelog, deploy
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
| **Specify** (02–13)       | stories, sprints, DB, user flow, brand, components, wireframes, GDPR, security, QA, SEO, API design |
| **Decide & plan** (14–16) | `14-DECISIONS/` (ADRs) → `15-SPRINT-PLANS/` → `16-STORY-PLANS/` (the code master)                   |
| **Record** (17–21)        | `17-TESTS/`, `18-REVIEWS/`, `19-FINDINGS/`, `20-BUGS/`, `21-REFACTORING/` — per story               |

The **story plan (16)** is what a developer codes from; it references its sprint plan
(15), the decisions (14), and every 02–13 spec. Sprint plans (15) feed the story plans.

## Workflow gates

- A feature is not ready to code until the specify → decide → plan tiers are complete
- A PR is not ready to merge until `workflows/22-pr-and-review/` is signed off
- A release is not ready until `workflows/23-release/` is followed
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
