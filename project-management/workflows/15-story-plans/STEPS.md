---
workflow: 15-story-plans
phase: design
agent: planner
skills: [global-workflow]
model: fable
---

# Story Plans — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step             | Section                                                                           |
| ---------------- | --------------------------------------------------------------------------------- |
| All steps        | **Internal — Live Artefacts** → src/15-STORY-PLANS/                               |
| All steps        | src/15-STORY-PLANS/CLAUDE.md — copy-the-template rules, dependency DAG honesty    |
| Template         | src/15-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md — the canonical superset scaffold |
| Gathering inputs | **Internal — Live Artefacts** → src/14-SPRINT-PLANS/, src/13-DECISIONS/           |

---

## Prerequisites

- [ ] Story slotted into a sprint (`src/14-SPRINT-PLANS/##-SPRINT-PLAN-##.md`)
- [ ] Every 01–12 spec relevant to this story exists and is signed off (GDPR, security,
      QA, SEO, API design as applicable)
- [ ] Any ADR this story rests on is `Accepted` in `src/13-DECISIONS/`

---

## Steps

### Step 1 — Grill, then Gather Inputs

> **Model:** fable

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> one question at a time — scope, which layers are in scope (database /
service / API / frontend / infra / GDPR), phasing, and any open architectural question —
each with a recommended answer, no action until confirmed.

Gather:

- The sprint plan (`src/14-SPRINT-PLANS/`) — goal, priority, and phase assignment for this
  story
- Every ADR (`src/13-DECISIONS/`) the story rests on
- Every relevant 01–12 spec: story, schema, user flow, wireframes, GDPR, security, QA, SEO,
  API design
- The GDPR, security, and QA constraints each spec carries — these are **carried into** the
  plan, not re-derived

### Step 2 — Copy the Template

Copy `src/15-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` to
`src/15-STORY-PLANS/STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`. Never start from scratch.
Keep the ★-marked core sections always; keep ◇-marked sections only where the story
touches that concern, and say in one line why a dropped section does not apply.

### Step 3 — Fix the Technical Approach

Complete the Problem Statement, the Reference Documents gate map, Architecture Decision
(raise a new ADR in `src/13-DECISIONS/` — via `workflows/13-decisions/` — if the story
makes a cross-cutting choice), and Approach — per layer (database / service / API /
frontend) or per phase for a multi-step story.

### Step 4 — Break the Story into Phased Implementation Tasks

Map the approach onto the code workflow chain, noting explicit phase dependencies:

| Phase    | PM workflow        | Produces                                                                            |
| -------- | ------------------ | ----------------------------------------------------------------------------------- |
| Backend  | `16-backend-code`  | Models, services, migration (TDD via `code/workflows/02-tdd-cycle/`)                |
| API      | `17-api-code`      | Django Ninja routers, endpoints, request/response schemas, permission checks        |
| Frontend | `18-frontend-code` | Templates, django-components, HTMX partials — component-library reuse checked first |

State which phase must land before the next can start, and which slice is startable now
regardless of blockers (mirrors the plan's `Can be done now` line).

### Step 5 — Fill the Key Decisions and Dependencies Tables

- Key decisions: chosen vs rejected, with rationale and a doc reference
- Dependencies: the 4-column story matrix, plus `Blocked by` / `Blocks` / `Can be done
now` — keep this honest, the parallel-worktree DAG depends on it

### Step 6 — Carry In GDPR, Security, and QA Constraints

Copy the obligations from the 01–12 specs into the plan's GDPR, Security, and Testing
sections — do not re-derive them:

- GDPR — personal data touched, lawful basis, retention, rights mechanics, from
  `src/08-GDPR/`
- Security — AuthN/AuthZ, mutation permission checks (A01), IDOR, input validation, from
  `src/09-SECURITY/`
- QA — test scenarios and edge cases, from `src/10-QA/`

Every mutation the plan introduces must carry an explicit permission check and ownership
verification in the plan's Security table — no exceptions.

### Step 7 — Define the Test Strategy

Complete the plan's Testing section per layer: unit & integration (services), template /
component / HTMX-partial rendering, API permission-check tests, markup-level accessibility,
browser e2e (a11y scan + responsive overflow), and manual testing — one coverage floor per
`code/docs/TESTING.md` (75% line and branch, 90% auth). The browser suite is excluded from
coverage; it exercises a running stack over HTTP and instruments nothing.

### Step 8 — Run the Planner Agent

```text
planner [story, sprint plan, ADRs, and every 01–12 spec gathered in Step 1]
```

> **↳ New agent:** `planner` · **Model:** fable · **MCP:** none

### Step 9 — Adversarial Plan Review

> **Model:** opus

Spawn 2–3 independent reviewers to critique the draft before it is treated as codeable:
missing layers, unhandled GDPR/security, wrong doc references, dependency-order errors,
unscoped deferrals. Resolve every finding.

### Step 10 — Save, Index, and Cross-Reference

1. Save to `src/15-STORY-PLANS/STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`
2. Add the row to `src/15-STORY-PLANS/CONTEXT.md` → Plans Index (file link, story, Status)
3. Reference the plan in the driving user story (`src/01-STORIES/US###.md`)
4. Proceed to `workflows/16-backend-code/` to begin implementation

### Step 11 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` + `CLAUDE.md` inside it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
