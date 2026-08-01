---
name: story
description: "Write a user story, create a US### story file, or plan a sprint"
model: fable
---

## Stack

Backend: Django 6.0.6 + Django Ninja + PostgreSQL | Scripts: `code/src/scripts/**/*.sh`
Frontend: Django templates + django-components + HTMX + Alpine + vanilla CSS (design tokens)
Branch naming: us###/short-description | Locale: {{LOCALE}} | Timezone: {{TIMEZONE}}

## Context Loading

Read in this order before spawning any sub-agents:

**Layer context:**

- `project-management/CONTEXT.md` — PM layer overview, current sprint state and story numbering

**Workflows:**

- `project-management/workflows/01-story-creation/CONTEXT.md` → `project-management/workflows/01-story-creation/STEPS.md`
- `project-management/workflows/02-sprint-planning/CONTEXT.md` → `project-management/workflows/02-sprint-planning/STEPS.md` (only if sprint planning was requested)

**Docs:**

- `project-management/docs/SPRINT-PLANNING-GUIDE.md`

**References** (check when you need a specific link):

- `project-management/REFERENCES.md`

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/01-story-creation/` — write the `US###` story
- `project-management/workflows/02-sprint-planning/` — the high-level sprint record
- `project-management/workflows/14-sprint-plans/` — the detailed sprint plan
- `project-management/workflows/15-story-plans/` — the per-story implementation plan

## Non-Negotiables (pass to every sub-agent you spawn)

- Every state-changing Django Ninja endpoint needs an explicit permission check (OWASP A01)
- User-supplied IDs verified against caller's ownership — no IDOR
- `DEBUG=False` in all non-local environments
- `CORS_ALLOWED_ORIGINS` explicit allowlist — never `*` in production
- All secrets via env vars — never hardcoded
- Django admin never at `/admin/` (that prefix belongs to the {{PROJECT_NAME}} Admin — Django views + templates + HTMX)
- Never commit `.env` files — use `.env.*.example` templates only

## Spawn Protocol

Each phase below is a fresh Agent tool call. No agent reviews its own work.
Steps without a ↳ agent marker are performed by this orchestrating agent directly.
Brief each sub-agent fully in its prompt — it has no memory of previous phases.

## Workflow

For a large, ambiguous epic — bigger than one session can hold — open with `.claude/skills/wayfinder/SKILL.md` to chart its decision frontier into a shared map, resolved one decision at a time across sessions, before decomposing it into the stories/sprints below.

### Phase 1 — Story Creation

↳ user-story [opus]
Story design **opens with a grilling pass** — `user-story` loads `.claude/skills/grill-with-docs` and interviews {{DEVELOPER_NAME}} one question at a time (each with its recommended answer) before writing the story, inverting the proceed-by-default posture (`.claude/CLAUDE.md` §10).
Save output to: `project-management/src/01-STORIES/US###.md`
Use the next available US### number. Story must include: title, role, goal, acceptance criteria, and definition of done.

### Phase 2 — Sprint Planning (conditional)

Only run if the request explicitly asks for sprint planning or "plan a sprint".
↳ sprint [opus]
Save output to: `project-management/src/02-SPRINTS/SPRINT-##.md`

### Phase 3 — Commit

↳ git [opus]
Commit message: `docs(pm): add US### <short title>` or `docs(pm): SPRINT-## planning`
