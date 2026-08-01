---
name: feature
description: "Implement a new full-stack feature, add a new capability, or build something new end-to-end"
model: opus
---

## Stack

Backend: Django 6.0.6 + Django Ninja + PostgreSQL | Scripts: `code/src/scripts/**/*.sh`
Frontend: Django templates + django-components + HTMX + Alpine + vanilla CSS (design tokens)
Branch naming: us###/short-description | Locale: {{LOCALE}} | Timezone: {{TIMEZONE}}

## Context Loading

Read in this order before spawning any sub-agents:

**Layer context:**

- `code/CONTEXT.md` — coding layer overview, stack conventions
- `project-management/CONTEXT.md` — PM layer overview, story and sprint state

**Workflows:**

- `code/workflows/01-new-feature/CONTEXT.md` → `code/workflows/01-new-feature/STEPS.md`
- `code/workflows/02-tdd-cycle/CONTEXT.md` — TDD red/green/refactor cycle
- `code/workflows/09-database-migration/CONTEXT.md` — migration conventions
- `project-management/workflows/16-backend-code/CONTEXT.md`
- `project-management/workflows/17-api-code/CONTEXT.md`
- `project-management/workflows/18-frontend-code/CONTEXT.md`

**Docs:**

- `code/docs/CODING-PRINCIPLES.md` — global principles
- `code/docs/BACKEND-CODING-PRINCIPLES.md` — Django/Python/Celery specifics (read when touching backend)
- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — Django templates/HTMX/Alpine/CSS specifics (read when touching frontend)
- `code/docs/ARCHITECTURE-PATTERNS.md`
- `code/docs/API-DESIGN.md`
- `code/docs/DATA-STRUCTURES.md`
- `code/docs/SECURITY.md`
- `code/docs/TESTING.md`

**References** (check when you need a specific link):

- `code/REFERENCES.md`
- `project-management/REFERENCES.md`

**Session skills** (load when the work outgrows one session):

- `.claude/skills/wayfinder/SKILL.md` — chart a large, ambiguous epic into a decision map resolved across sessions (before decomposing a big feature/epic)
- `.claude/skills/handoff/SKILL.md` — compact the session into a committed `handoffs/` doc when a session must end before the work does

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/15-story-plans/` — the master plan you build from — a story is not codeable without it
- `project-management/workflows/16-backend-code/` — backend phase — drives `code/workflows/02-tdd-cycle/` and `09-database-migration/`
- `project-management/workflows/17-api-code/` — API phase — drives `code/workflows/04-api-design/`
- `project-management/workflows/18-frontend-code/` — frontend phase — drives `code/workflows/01-new-feature/`
- `code/workflows/01-new-feature/` — the full-stack build procedure itself
- `code/workflows/02-tdd-cycle/` — Red → Green → Refactor within every phase
- `project-management/workflows/19-implementation-documentation/` — records, findings, docs, graph refresh — hard gate before commit
- `project-management/workflows/20-pr-and-review/` — PR, review, merge

## Non-Negotiables (pass to every sub-agent you spawn)

- Every state-changing Django Ninja endpoint needs an explicit permission check (OWASP A01)
- User-supplied IDs verified against caller's ownership — no IDOR
- `DEBUG=False` in all non-local environments
- `CORS_ALLOWED_ORIGINS` explicit allowlist — never `*` in production
- All secrets via env vars — never hardcoded
- Django admin never at `/admin/` (that prefix belongs to the {{PROJECT_NAME}} Admin — Django views + templates + HTMX)
- Never commit `.env` files — use `.env.*.example` templates only

## Pre-flight

```bash
git status                                           # confirm branch is us###/short-description
bash code/src/scripts/development/server.sh status   # confirm dev stack is running
```

## Spawn Protocol

Each phase below is a fresh Agent tool call. No agent reviews its own work.
Steps without a ↳ agent marker are performed by this orchestrating agent directly.
Brief each sub-agent fully in its prompt — it has no memory of previous phases.

## Workflow

### Phase 1 — Plan

↳ planner [opus]
The planning phase **opens with a grilling pass** — `planner` loads `.claude/skills/grill-with-docs` and interviews {{DEVELOPER_NAME}} one question at a time (each with its recommended answer, facts looked up not asked) before producing the plan, inverting the proceed-by-default posture (`.claude/CLAUDE.md` §10).
Must complete before any implementation phase starts.
Save to: `project-management/src/15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md`

### Phase 2 — Failing Tests (TDD Red Phase)

↳ test-writer [opus]
All tests must be RED before Phase 3 starts.
This agent must not be the Phases 3–7 implementer.

### Phase 3 — Models & Migration

↳ backend [opus]
After agent completes, run directly:

```bash
bash code/src/scripts/database/migrate.sh make
bash code/src/scripts/database/migrate.sh run
```

### Phase 4 — Service Layer

↳ backend [opus]
Every method with ≥2 writes uses `transaction.atomic()`.

### Phase 5 — Django Ninja Endpoints & Schemas

↳ backend [opus]
Every state-changing endpoint uses a named Policy class. Permission check on every state-changing endpoint (OWASP A01).

### Phase 6 — Codegen

No sub-agent. Run directly:

```bash
bash code/src/scripts/tests/backend.sh
```

### Phase 7 — Frontend

↳ frontend [opus]
Check the existing django-components catalogue before creating new components.
All interactive elements must meet WCAG 2.2 AA.

### Phase 8 — Tests Green

No sub-agent. Run directly:

```bash
bash code/src/scripts/tests/backend.sh
bash code/src/scripts/tests/all.sh --api
```

Both must pass before proceeding to Phase 9.

### Phase 9 — Review & QA (two separate spawns)

↳ review [opus] — must not be any agent from Phases 2–7
↳ qa-tester [opus] — must be a separate agent from the reviewer

### Phase 10 — Documentation

No sub-agent. **Hard gate — must complete before Phase 11.**

1. Update every `CONTEXT.md` affected by new files, directories, or constraints from this feature (directory trees, Last Updated dates, new patterns/decisions)
2. Create a `CONTEXT.md` inside every new directory introduced by this feature
3. Verify implementation records from Phase 9 are written (see `code/workflows/01-new-feature/STEPS.md` Step 10)
4. Verify `/GAPS.md` and `/DEFERRED.md` are current

### Phase 11 — Commit

↳ git [opus]
