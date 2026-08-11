---
name: bugfix
description: "Fix a bug, debug a regression, or resolve a broken behaviour"
model: opus
---

## Stack

Backend: Django 6.0.6 + Django Ninja + PostgreSQL | Scripts: `code/src/scripts/**/*.sh`
Frontend: Django templates + django-components + HTMX + Alpine + vanilla CSS (design tokens)
Branch naming: us###/short-description | Locale: <%LOCALE%> | Timezone: <%TIMEZONE%>

## Context Loading

Read in this order before spawning any sub-agents:

**Layer context:**

- `code/CONTEXT.md` — coding layer overview

**Workflows:**

- `code/workflows/10-debug/CONTEXT.md` → `code/workflows/10-debug/STEPS.md`
- `code/workflows/09-debugging-with-logs/CONTEXT.md` — log-based debugging patterns
- `code/workflows/02-tdd-cycle/CONTEXT.md` — regression test cycle

**Docs:**

- `code/docs/CODING-PRINCIPLES.md` — global principles
- `code/docs/BACKEND-CODING-PRINCIPLES.md` — Django/Python/Celery specifics (read when bug is in backend)
- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — Django templates/HTMX/Alpine/CSS specifics (read when bug is in frontend)
- `code/docs/TESTING.md`
- `code/docs/LOGGING.md`
- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **debug playbook**
  (`.claude/skills/debug-issue.md`): trace the fault structurally before wide manual searches

**Skills:**

- `.claude/skills/grill-with-docs/SKILL.md` — open the bug with a grilling interview before delegating to `debugger`
- `.claude/skills/handoff/SKILL.md` — compact the session into a committed `handoffs/` doc when a session must end before the work does

**References** (check when you need a specific link):

- `code/REFERENCES.md`

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `how-to/workflows/08-debugging/` — **first** — confirm the environment is healthy (containers, logs, build)
- `code/workflows/10-debug/` — then isolate the fault, pin it with a regression test, apply the minimal fix
- `code/workflows/09-debugging-with-logs/` — staging/prod faults via Glitchtip, Loki, and Grafana
- `project-management/workflows/21-implementation-documentation/` — routes the finding to `project-management/src/20-BUGS/`

## Non-Negotiables (pass to every sub-agent you spawn)

- Every state-changing Django Ninja endpoint needs an explicit permission check (OWASP A01)
- User-supplied IDs verified against caller's ownership — no IDOR
- `DEBUG=False` in all non-local environments
- `CORS_ALLOWED_ORIGINS` explicit allowlist — never `*` in production
- All secrets via env vars — never hardcoded
- Django admin never at `/admin/` (that prefix belongs to the <%PROJECT_NAME%> Admin — Django views + templates + HTMX)
- Never commit `.env` files — use `.env.*.example` templates only

## Pre-flight

```bash
git status   # confirm current branch and state
```

## Spawn Protocol

Each phase below is a fresh Agent tool call. No agent reviews its own work.
Steps without a ↳ agent marker are performed by this orchestrating agent directly.
Brief each sub-agent fully in its prompt — it has no memory of previous phases.

## Workflow

### Phase 1 — Reproduce & Isolate

**Grill first (before delegating).** This orchestrator opens with a grilling pass — load
`.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%> (the exact
expected-vs-actual behaviour, the precise reproduction steps, and the intended scope of the
fix). An obvious one-line fix skips it. The confirmed answers become the `debugger`
brief below. Design-work default (`.claude/CLAUDE.md` §10).

↳ debugger [opus]
Provide: bug description, reproduction steps, expected vs actual behaviour.
Must identify root cause before fix begins.

### Phase 2 — Regression Test

↳ test-writer [opus]
Write a failing test that reproduces the bug. Test must be RED before the fix is applied.
This agent must not be the Phase 3 fix implementer.

### Phase 3 — Minimal Fix

↳ backend or frontend [opus] — choose based on fault location.
Fix must be minimal — do not refactor surrounding code in the same commit.

### Phase 4 — Verify Green

No sub-agent. Run directly:

```bash
bash code/src/scripts/tests/backend.sh   # one runner covers every layer
```

The regression test written in Phase 2 must now pass.

### Phase 5 — QA

↳ qa-tester [opus]
Must be a separate agent from Phase 3. Check for regressions in surrounding features.

### Phase 6 — Documentation

No sub-agent. **Hard gate — must complete before Phase 7.**

1. Update any `CONTEXT.md` affected by new files, directories, or constraints introduced by this fix
2. Write bug report artefact if it does not exist: `project-management/src/20-BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md`
3. Update `/GAPS.md` if the fix exposed a broader architectural or security gap
4. Update `/DEFERRED.md` for anything explicitly deferred to a future story

### Phase 7 — Commit

↳ git [opus]
Commit message: `fix(<scope>): <short description>`
