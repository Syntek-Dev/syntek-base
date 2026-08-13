---
workflow: 15-sprint-plans
phase: design
skills: [sprint, global-workflow]
model: fable
---

# Sprint Plans — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                               |
| --------- | ------------------------------------------------------------------------------------- |
| All steps | **Internal — Guides** → project-management/docs/PLANNING-GUIDE.md                     |
| All steps | **External — Agile & Project Management** → MoSCoW prioritisation, Definition of Done |
| Artefacts | **Internal — Live Artefacts** → src/15-SPRINT-PLANS/                                  |

---

## Steps

### Step 0 — Grill first

> **Model:** fable

Load `.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%>
(`.claude/CLAUDE.md` §10).

Ask about:

- Whether the sprint has genuinely filled, or is being planned early to keep momentum
- The MoSCoW split — and specifically whether anything marked Must could survive being Should
- Build order versus sprint number: does anything here need pulling ahead of its number
- Which stories carry cross-sprint dependencies, and whether every blocker is actually cleared
- Whether any story is oversized and would be better split — along a user-value seam, never a
  layer boundary

_Done when every question is answered and <%DEVELOPER_NAME%> has confirmed the scope._

### Step 1 — Confirm Prerequisites

Verify the following are complete and committed before writing the sprint plan:

- `project-management/src/09-GDPR/` — GDPR review for all in-scope stories
- `project-management/src/10-SECURITY/` — security threat model and assessment
- `project-management/src/11-QA/` — QA documents for all in-scope stories
- `project-management/src/12-SEO` - SEO documents for all in-scope stories
- `project-management/src/13-API-DESIGN` - API Design documents for all in-scope stories

### Step 2 — Select Stories

> **Model:** opus

Open `project-management/src/02-STORIES/` and list candidate stories for the sprint.
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
- **API** — Django Ninja routers, endpoints, and request/response Schemas (mounted on the project's single `NinjaAPI`, served under `/api/`)
- **Frontend** — Django views + templates with django-components (HTMX + Alpine) on every surface, includich editors
- **Tests** — Unit, integration, and E2E tests (written alongside each phase)

### Step 4 — Run Sprint Agent

```text
sprint [list the stories, their priorities, and any constraints from GDPR/security/QA reviews]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `sprint` · **Model:** fable · **MCP:** none

### Step 5 — Write the Sprint Plan Document

Create `project-management/src/15-SPRINT-PLANS/SPRINT-PLAN-##.md` with the following sections:

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
Workflows: 18-backend-code

### Phase 2 — API
Stories: US###, US###
Workflows: 19-api-code

### Phase 3 — Frontend
Stories: US###, US###
Workflows: 20-frontend-code

### Phase 4 — PR & Review
Workflows: 22-pr-and-review

## Definition of Done
- [ ] All Must stories implemented, tested, and reviewed
- [ ] No open HIGH/CRITICAL security findings
- [ ] GDPR requirements implemented and verified
- [ ] QA scenarios passing (automated and manual)
- [ ] PR merged and version bumped
```

### Step 6 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
