# project-management — PM Workflow, Stories & Compliance

This layer decides what gets built and holds the gates; the code layer builds it. Keeping the
two apart is what lets a story be argued with before it is expensive — and what stops a
design decision being made, unrecorded, at the keyboard.

## Directory Tree

```text
project-management/
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── REFERENCES.md            ← internal and external reference index for this layer
├── docs/                    ← PM reference guides
│   ├── CONTEXT.md
│   ├── gdpr/                    ← GDPR sub-documents (COMPLIANCE.md, DATA-RIGHTS.md)
│   ├── GDPR-GUIDE.md            ← GDPR obligations, data flows, and legal bases (index)
│   ├── git/                     ← git sub-documents (BRANCHES-AND-WORKTREES.md, COMMITS.md,
│   │                              PR-AND-REQUIRED-CHECKS.md, MIGRATION-GATES.md)
│   ├── GIT-GUIDE.md             ← branch, commit, PR and migration gates (index)
│   ├── QA-GUIDE.md              ← QA planning and test documentation standards
│   ├── RESPONSIVE-DESIGN.md     ← breakpoints, mobile-first, responsive patterns
│   ├── SECURITY-GUIDE.md        ← security standards and threat modelling guide
│   ├── SEO-CHECKLIST.md         ← SEO and AI discoverability for all frontend pages
│   ├── planning/                ← planning sub-documents (CADENCE.md, STORIES.md, SPRINTS.md)
│   ├── PLANNING-GUIDE.md        ← MoSCoW prioritisation and sprint format conventions
│   └── VERSIONING-GUIDE.md      ← root-only semver, files to update on every bump
├── export/                  ← ClickUp sync artefacts + PDF/zip exports for client delivery
├── src/                     ← live PM artefacts, in three tiers (see below)
│   ├── 00-ASSETS/               ← logos, brand assets, export scripts (pre-workflow ref)
│   │
│   │   ── Discover (01) ──
│   ├── 01-FEATURE-MAPS/         ← MAP-<FEATURE>.md (wayfinder decision maps)
│   │
│   │   ── Specify (02–14) ──
│   ├── 02-STORIES/              ← US###.md (user stories)
│   ├── 03-SPRINTS/              ← SPRINT-##.md (backlog → sprint organisation)
│   │   (04–08: USER-STORY-IDEAS/ → CONSOLIDATED-IDEAS/ → IMPLEMENTATION/ + a cumulative asset)
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
│   ├── 14-LOGGING/              ← PLANNING/ + IMPLEMENTATION/
│   │
│   │   ── Decide & plan (15–17) ──
│   ├── 15-DECISIONS/            ← ADR-###-<TITLE>.md
│   ├── 16-SPRINT-PLANS/         ← detailed sprint execution plans
│   ├── 17-STORY-PLANS/          ← per-story implementation plan (code master reference)
│   │
│   │   ── Implement & record (18–22, per story) ──
│   ├── 18-TESTS/                ← US###-TEST-STATUS.md, US###-MANUAL-TESTING.md
│   ├── 19-REVIEWS/              ← REVIEW-US###-*.md
│   ├── 20-FINDINGS/             ← FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│   ├── 21-BUGS/                 ← BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│   ├── 22-REFACTORING/          ← REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│   │
│   │   ── Record, not per story (23) ──
│   └── 23-INCIDENTS/            ← INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md + INCIDENT-INDEX.md (PII-free)
└── workflows/               ← step-by-step PM workflows (01–24)
    ├── 01-feature-map/                          ← discover: chart the feature
    ├── 02-story-creation/ … 14-logging-checks/ ← specify a feature
    ├── 15-decisions/ 16-sprint-plans/ 17-story-plans/  ← decide & plan
    ├── 18-consolidate-design-work/              ← consolidate the per-story design work
    ├── 19-backend-code/ 20-api-code/ 21-frontend-code/  ← implement
    ├── 22-implementation-documentation/         ← docs + implementation records
    ├── 23-pr-and-review/                        ← PR, review, merge
    └── 24-release/                              ← version bump, changelog, deploy
```

Every `src/` and `workflows/` sub-folder carries a `CONTEXT.md` + `CLAUDE.md`; each
workflow folder also has `STEPS.md` + `CHECKLIST.md`.

## When to read this

- Creating or updating a user story, sprint, decision (ADR), or plan
- Running a design/compliance spec (DB, user flow, GDPR, security, QA, SEO, API)
- Managing a PR through review and merge, or cutting a release

## Contents

- `docs/` — reference guides for PM, GDPR, SEO, security, QA, versioning, responsive design
- `export/` — ClickUp sync artefacts (`clickup/`, `clickup-task-map.json`), plus PDF and zip
  exports of PM artefacts for client delivery
- `src/` — all live PM artefacts, in three tiers (specify → decide & plan → record)
- `workflows/` — step-by-step guides for PM tasks

## Do not use for

- Writing code → `code/CONTEXT.md`
- Environment setup, CLI usage → `how-to/CONTEXT.md`

## src/ structure — the three tiers

`00-ASSETS` is pre-workflow reference. The rest runs in three tiers; **09–13 tie their
artefacts to a user story** via per-story `PLANNING/` + `IMPLEMENTATION/` templates
(`10-SECURITY` nests the pair under each of its four category folders).

| Tier                      | Paths                                                                                               |
| ------------------------- | --------------------------------------------------------------------------------------------------- |
| **Specify** (02–14)       | stories, sprints, DB, user flow, brand, components, wireframes, GDPR, security, QA, SEO, API design |
| **Decide & plan** (15–17) | `15-DECISIONS/` (ADRs) → `16-SPRINT-PLANS/` → `17-STORY-PLANS/` (the code master)                   |
| **Record** (18–22)        | `18-TESTS/`, `19-REVIEWS/`, `20-FINDINGS/`, `21-BUGS/`, `22-REFACTORING/` — per story               |
| **Record** (23)           | `23-INCIDENTS/` — the PII-free incident register; **not** per story, and has no workflow            |

The **story plan (17)** is what a developer codes from; it references its sprint plan
(16), the decisions (15), and every 02–14 spec. Sprint plans (16) feed the story plans.

## Workflow gates

- A feature is not ready to code until the specify → decide → plan tiers are complete
- A PR is not ready to merge until `workflows/23-pr-and-review/` is signed off
- A release is not ready until `workflows/24-release/` is followed
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
