# Sprint Planning Guide — project-name

> **Agent hints — Model:** Sonnet

**Last Updated**: 28/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Table of Contents

- [Overview](#overview)
- [When to Write a Sprint Plan](#when-to-write-a-sprint-plan)
- [MoSCoW Prioritisation](#moscow-prioritisation)
- [Development Phases](#development-phases)
- [Sprint Plan Document Format](#sprint-plan-document-format)
- [Relationship to Other Documents](#relationship-to-other-documents)
- [Quick Checklist](#quick-checklist)

---

## Overview

A sprint plan is the **single source of truth** for what is in scope, why, and in what order it
will be built. It is written once per sprint, after GDPR, security, and QA checks are complete,
so that developers begin with a full picture of the requirements, constraints, and test criteria.

Sprint plans live in `project-management/src/12-SPRINT-PLANS/`. This guide supports the
`workflows/12-sprint-plans` workflow.

---

## When to Write a Sprint Plan

Sprint plans are written at the end of the pre-sprint checks phase:

```text
08-gdpr-compliance
09-security-checks   ←  all three must be complete and signed off
10-qa-checks
          ↓
12-sprint-plans  ←  sprint plan written here
          ↓
13-backend-code  ←  development begins
```

**Prerequisites** — all of the following must be done before writing the sprint plan:

- GDPR review complete for all in-scope stories (`src/08-GDPR/`)
- Security threat model and assessment complete (`src/09-SECURITY/`)
- QA documents exist for all in-scope stories, no unresolved `AC-GAP` entries (`src/10-QA/`)
- All in-scope `US###.md` files have complete acceptance criteria

---

## MoSCoW Prioritisation

Stories are grouped into four priority tiers. The sprint plan must contain at least the **Must**
tier. **Should** and **Could** tiers are stretch goals — they are dropped first if capacity
becomes constrained.

| Priority   | Definition                                                | Rule                                                       |
| ---------- | --------------------------------------------------------- | ---------------------------------------------------------- |
| **Must**   | Sprint fails without this — core functionality or blocker | Capacity must be reserved to deliver all Must stories      |
| **Should** | High value; included if capacity allows                   | Included in sprint plan; dropped if Must stories overrun   |
| **Could**  | Nice to have; low priority                                | Only started once all Must and Should stories are complete |
| **Won't**  | Out of scope for this sprint; explicitly deferred         | Recorded in the plan to prevent scope creep                |

**Avoid sprint plans where everything is Must.** If every story is marked Must, re-evaluate
scope or split the sprint.

---

## Development Phases

Each sprint follows the same four-phase delivery sequence. Stories are mapped to phases based on
which layers they touch:

| Phase | Workflow           | What is built                                           |
| ----- | ------------------ | ------------------------------------------------------- |
| **1** | `13-backend-code`  | Django models, services, business logic, migrations     |
| **2** | `14-api-code`      | Strawberry GraphQL types, queries, mutations, resolvers |
| **3** | `15-frontend-code` | Next.js pages, React components, Apollo integration     |
| **4** | `17-pr-and-review` | PR, code review, QA sign-off, merge to `testing`        |

Tests are written **alongside** each phase — not after. Backend tests in Phase 1; API tests in
Phase 2; frontend tests in Phase 3.

A story may touch only some phases (e.g. a purely backend change skips Phase 3). The sprint plan
records which phases each story requires.

---

## Sprint Plan Document Format

One file per sprint in `project-management/src/12-SPRINT-PLANS/`:

```text
SPRINT-PLAN-##.md  (e.g. SPRINT-PLAN-01.md)
```

```markdown
# Sprint Plan ## — <Sprint Goal Summary>

**Date**: DD/MM/YYYY **Sprint**: ## **Planned by**: <name>

---

## Sprint Goal

<One sentence: what this sprint delivers and why it matters>

---

## Stories

### Must

| Story | Title   | Phases touched           | QA doc             |
| ----- | ------- | ------------------------ | ------------------ |
| US### | <title> | Backend / API / Frontend | QA-US###-<NAME>.md |

### Should

| Story | Title   | Phases touched | QA doc             |
| ----- | ------- | -------------- | ------------------ |
| US### | <title> | Backend / API  | QA-US###-<NAME>.md |

### Could

| Story | Title   | Phases touched | QA doc             |
| ----- | ------- | -------------- | ------------------ |
| US### | <title> | Frontend only  | QA-US###-<NAME>.md |

### Won't (this sprint)

- US### — <title> — deferred because: <reason>

---

## GDPR Constraints

<Any requirements from `src/08-GDPR/` that developers must implement>

- <e.g. New `email` field must use `EncryptedField`; `gdpr_erase` handler must be updated>

## Security Constraints

<Developer constraints from `src/09-SECURITY/` that must be met for all stories in this sprint>

- <e.g. Login endpoint: max 5 attempts per IP per minute; 429 beyond limit>
- <e.g. All `user_id` parameters verified against `request.user` — no IDOR>

---

## Phase Breakdown

### Phase 1 — Backend (`workflows/13-backend-code`)

**Stories**: US###, US###

Key deliverables:

- <model or service to implement>
- <migration to write>

### Phase 2 — API (`workflows/14-api-code`)

**Stories**: US###, US###

Key deliverables:

- <GraphQL type or query to implement>
- <mutation and permission check>

### Phase 3 — Frontend (`workflows/15-frontend-code`)

**Stories**: US###, US###

Key deliverables:

- <page or component to implement>
- <Apollo hook to wire up>

### Phase 4 — PR & Review (`workflows/17-pr-and-review`)

All stories. PR opened to `testing`; CI must pass; QA sign-off required before merge.

---

## Definition of Done

- [ ] All Must stories implemented, tested, and reviewed
- [ ] No open `CRITICAL` or `HIGH` security findings
- [ ] GDPR constraints implemented and verified per `src/08-GDPR/`
- [ ] All QA scenarios from `src/10-QA/` passing (automated and manual)
- [ ] PR merged to `testing`; CI passing
- [ ] Version bumped if this sprint produces a release
```

---

## Relationship to Other Documents

| Document                      | How it relates to the sprint plan                                             |
| ----------------------------- | ----------------------------------------------------------------------------- |
| `src/01-STORIES/US###.md`     | Source of stories; acceptance criteria must be complete before planning       |
| `src/08-GDPR/`                | GDPR constraints section of the sprint plan comes from here                   |
| `src/09-SECURITY/`            | Security constraints section of the sprint plan comes from here               |
| `src/10-QA/QA-US###-*.md`     | QA doc column in story tables; test scenarios used in Phase 4 sign-off        |
| `src/02-SPRINTS/SPRINT-##.md` | High-level sprint log (velocity, retrospective notes); separate from the plan |
| `docs/VERSIONING-GUIDE.md`    | Consulted when the sprint includes a release                                  |

---

## Quick Checklist

Before finalising a sprint plan:

- [ ] All prerequisites confirmed complete (GDPR, security, QA)
- [ ] Stories selected and assigned to Must / Should / Could / Won't
- [ ] Each story mapped to its development phases
- [ ] GDPR constraints section populated from `src/08-GDPR/`
- [ ] Security constraints section populated from `src/09-SECURITY/`
- [ ] QA doc linked for every Must and Should story
- [ ] Phase breakdown lists key deliverables per phase
- [ ] Definition of Done is specific and testable
- [ ] `SPRINT-PLAN-##.md` committed and pushed
- [ ] All developers have read the plan before development begins
