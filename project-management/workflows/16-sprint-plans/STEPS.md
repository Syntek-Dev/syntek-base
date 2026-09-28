---
workflow: 16-sprint-plans
phase: design
skills: [sprint, global-workflow]
model: opus
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
| Artefacts | **Internal — Live Artefacts** → src/16-SPRINT-PLANS/                                  |

---

## Steps

### Step 0 — Grill first

> **Model:** opus

Load `.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%>
(`.claude/CLAUDE.md` Section 10).

**Recorded answers** (`.claude/skills/grilling/SKILL.md` → _A decision already recorded is a fact_):
the right-hand column below, beside the question each usually settles.

| Question                                                                             | Usually settled in                                                                                                                       |
| ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Has the sprint genuinely filled, or is it being planned early to keep momentum       | The record's `**Capacity:**` field (`src/03-SPRINTS/SPRINT-##.md`), against the trigger in `project-management/docs/planning/CADENCE.md` |
| The MoSCoW split — could anything marked Must survive being Should                   | Each member's `## MoSCoW Priority` (`src/02-STORIES/US###.md`)                                                                           |
| Build order versus sprint number — does anything need pulling ahead of its number    | The `<exec-order>` prefixes in `src/16-SPRINT-PLANS/`, and any number reserved in a member story                                         |
| Which stories carry cross-sprint dependencies, and is every blocker actually cleared | Each member's `## Dependencies`, checked against the tree                                                                                |
| Is any story oversized, better split along a user-value seam, never a layer boundary | Each member's `## Story Points`, and its slice row's `Nodes` and `Acceptance` (`src/01-FEATURE-MAPS/`)                                   |
| Is every prerequisite in Step 1 met                                                  | The gate artefacts themselves — measured, never asked                                                                                    |

_Done when every question is answered — from an artefact or by <%DEVELOPER_NAME%> — and
<%DEVELOPER_NAME%> has confirmed the scope._

### Step 1 — Confirm Prerequisites

Verify the following are complete and committed before writing the sprint plan:

- `project-management/src/09-GDPR/` — GDPR review, for stories whose `GDPR` flag is not `N/A`
- `project-management/src/10-SECURITY/` — security threat model and assessment
- `project-management/src/11-QA/` — QA documents, for stories whose `QA` flag is not `N/A`
- `project-management/src/12-SEO/` — SEO documents, for stories whose `SEO` flag is not `N/A`
- `project-management/src/13-API-DESIGN/` — API design, for stories whose `API` flag is not `N/A`
- `project-management/src/14-LOGGING/` — logging plans, for stories whose `Logging` flag is not `N/A`

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
- **Frontend** — Django views + templates with django-components (HTMX + Alpine) on every surface, including rich editors
- **Tests** — Unit, integration, and E2E tests (written alongside each phase)

### Step 4 — Run Sprint Agent

```text
sprint [list the stories, their priorities, and any constraints from GDPR/security/QA reviews]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `sprint` · **Model:** opus · **MCP:** none

### Step 5 — Write the Sprint Plan Document

Create `project-management/src/16-SPRINT-PLANS/<exec-order>-SPRINT-PLAN-<sprint-number>.md`,
both segments 2-digit zero-padded (rule: `project-management/src/16-SPRINT-PLANS/CLAUDE.md`),
with the following sections:

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
Workflows: 19-backend-code

### Phase 2 — API
Stories: US###, US###
Workflows: 20-api-code

### Phase 3 — Frontend
Stories: US###, US###
Workflows: 21-frontend-code

### Phase 4 — PR & Review
Workflows: 23-pr-and-review

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
