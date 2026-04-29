# Sprint Plans — Steps

**Last Updated**: 28/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Confirm Prerequisites

Verify the following are complete and committed before writing the sprint plan:

- `project-management/src/08-GDPR/` — GDPR review for all in-scope stories
- `project-management/src/09-SECURITY/` — security threat model and assessment
- `project-management/src/10-QA/` — QA documents for all in-scope stories

### Step 2 — Select Stories

Open `project-management/src/01-STORIES/` and list candidate stories for the sprint.
Apply MoSCoW prioritisation:

| Priority   | Meaning                                        |
| ---------- | ---------------------------------------------- |
| **Must**   | Sprint fails without this                      |
| **Should** | High value, include if capacity allows         |
| **Could**  | Nice to have, drop first if time is short      |
| **Won't**  | Out of scope for this sprint, backlog for next |

### Step 3 — Map Stories to Development Phases

For each story in the sprint, identify which development phases it touches:

- **Backend** — Django models, services, business logic
- **API** — Strawberry GraphQL types, queries, mutations
- **Frontend** — Next.js pages, React components, Apollo integration
- **Tests** — Unit, integration, and E2E tests (written alongside each phase)

### Step 4 — Run Sprint Agent

```text
/syntek-dev-suite:sprint [list the stories, their priorities, and any constraints from GDPR/security/QA reviews]
```

### Step 5 — Write the Sprint Plan Document

Create `project-management/src/11-SPRINT-PLANS/SPRINT-PLAN-##.md` with the following sections:

```text
# Sprint Plan ## — <Goal Summary>

## Sprint Goal
<one-sentence goal>

## Stories

### Must
- US### — <title> (backend / API / frontend)

### Should
- US### — <title> (backend / API / frontend)

### Could
- US### — <title> (backend / API / frontend)

## Phase Breakdown

### Phase 1 — Backend
Stories: US###, US###
Workflows: 12-backend-code

### Phase 2 — API
Stories: US###, US###
Workflows: 13-api-code

### Phase 3 — Frontend
Stories: US###, US###
Workflows: 14-frontend-code

### Phase 4 — PR & Review
Workflows: 15-pr-and-review

## Definition of Done
- [ ] All Must stories implemented, tested, and reviewed
- [ ] No open HIGH/CRITICAL security findings
- [ ] GDPR requirements implemented and verified
- [ ] QA scenarios passing (automated and manual)
- [ ] PR merged and version bumped
```

### Step 6 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
