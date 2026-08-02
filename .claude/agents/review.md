---
name: review
description: "Review code quality mid-development, run a QA pass, or check for issues before raising a PR"
model: opus
---

## Stack

Backend: Django + Django Ninja + PostgreSQL | Scripts: `code/src/scripts/**/*.sh`
Frontend: Django templates + django-components + HTMX + Alpine + vanilla CSS (design tokens)
Branch naming: us###/short-description | Locale: <%LOCALE%> | Timezone: <%TIMEZONE%>

## Context Loading

Read in this order before spawning any sub-agents:

**Layer context:**

- `code/CONTEXT.md` — coding layer overview, stack conventions
- `project-management/CONTEXT.md` — PR gates, QA standards, review artefact locations

**Workflows:**

- `code/workflows/07-review/CONTEXT.md`

**Docs:**

- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **review playbook**
  (`.claude/skills/review-changes.md`): `detect_changes` → `get_affected_flows` →
  `query_graph` tests_for → `get_impact_radius`, before delegating to `review`
- `.claude/skills/codebase-design/SKILL.md` — the deep-module vocabulary for review comments
  (module/interface/seam/depth/leverage; the deletion test; the interface is the test surface)
- `.claude/skills/improve-codebase-architecture/SKILL.md` — optional architectural-depth pass:
  `/improve-codebase-architecture` surfaces deepening opportunities (shallow→deep) as an HTML report
  before a structural PR

**References** (check when you need a specific link):

- `code/REFERENCES.md`
- `project-management/REFERENCES.md`

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/07-review/` — the code-quality review procedure (content of the change)
- `project-management/workflows/20-pr-and-review/` — the PR merge process (verification and gates)
- `code/workflows/08-security-hardening/` — where a security finding raised in review is fixed

## Non-Negotiables (pass to every sub-agent you spawn)

- Every state-changing Django Ninja endpoint needs explicit permission check (OWASP A01)
- User-supplied IDs verified against caller's ownership — no IDOR
- `DEBUG=False` in all non-local environments
- `CORS_ALLOWED_ORIGINS` explicit allowlist — never `*` in production
- All secrets via env vars — never hardcoded
- Django admin never at `/admin/` (that prefix belongs to the <%PROJECT_NAME%> Admin — Django views + templates + HTMX)
- Never commit `.env` files — use `.env.*.example` templates only

## Pre-flight

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/format.sh
```

## Spawn Protocol

Each phase below is a fresh Agent tool call. No agent reviews its own work.
Steps without a ↳ agent marker are performed by this orchestrating agent directly.
Brief each sub-agent fully in its prompt — it has no memory of previous phases.

## Workflow

### Phase 1 — Code Review

↳ review [opus]
Must not be the agent that wrote the code being reviewed.

### Phase 2 — QA Pass

↳ qa-tester [opus]
Must be a separate agent from Phase 1 reviewer.

### Phase 3 — Security (conditional)

Run if any of the following are in scope: auth, permissions, PII handling, or a new state-changing Django Ninja endpoint.
↳ security [opus]
Always a separate agent. Always opus model.
