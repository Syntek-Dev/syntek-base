---
name: pr
description: "Create a pull request, raise a PR, or merge a completed feature branch to testing"
model: opus
---

## Stack

Backend: Django 6.0.6 + Django Ninja + PostgreSQL | Scripts: `code/src/scripts/**/*.sh`
Frontend: Django templates + django-components + HTMX + Alpine + vanilla CSS (design tokens)
Branch naming: us###/short-description | Locale: <%LOCALE%> | Timezone: <%TIMEZONE%>

## Context Loading

Read in this order before spawning any sub-agents:

**Layer context:**

- `project-management/CONTEXT.md` — PM layer overview, PR conventions and branch chain
- `code/CONTEXT.md` — coding layer overview

**Workflows:**

- `project-management/workflows/20-pr-and-review/CONTEXT.md` → `project-management/workflows/20-pr-and-review/STEPS.md`

**Docs:**

- `project-management/docs/GIT-GUIDE.md`
- `project-management/docs/VERSIONING-GUIDE.md`

**References** (check when you need a specific link):

- `project-management/REFERENCES.md`

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/07-review/` — content review — security, patterns, coverage, principles
- `project-management/workflows/19-implementation-documentation/` — must be complete before the PR is raised
- `project-management/workflows/20-pr-and-review/` — the PR lifecycle — branch promotion, approvals, merge gates
- `how-to/workflows/02-worktree-setup/` — when the story runs in a parallel worktree

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
git status   # confirm branch is us###/short-description, no uncommitted changes
```

Branch chain: `us###/short-description` → `testing` → `dev` → `staging` → `main`

## Spawn Protocol

Each phase below is a fresh Agent tool call. No agent reviews its own work.
Steps without a ↳ agent marker are performed by this orchestrating agent directly.
Brief each sub-agent fully in its prompt — it has no memory of previous phases.

## Workflow

### Phase 1 — Final QA

↳ qa-tester [opus]

### Phase 2 — Final Review

↳ review [opus]
Must be a separate agent from Phase 1.

### Phase 3 — Open PR

No sub-agent. Run directly:

```bash
gh pr create --base testing
```

PR body must include: summary, US### reference (e.g. "Closes US042"), and a test plan checklist.

Note: `pre-pr-check.sh` fires automatically on `gh pr create` via the project's PreToolUse hook —
8 quality gates run (format, lint, typecheck, tests at 80% coverage floor, security). Do not duplicate these manually.
Note: `post-pr-comment.sh` posts gate results to GitHub automatically — no action needed.

### Phase 4 — Documentation (mandatory)

**Hard gate — must complete before the PR is marked ready.**

**CONTEXT.md updates** — update every `CONTEXT.md` affected by this PR:

1. Update directory trees to reflect new files or folders
2. Update `**Last Updated**` dates in any modified `CONTEXT.md`
3. Add new constraints, patterns, or decisions to the relevant `CONTEXT.md`
4. Create a `CONTEXT.md` inside every new directory introduced by this PR

**Implementation records** — create a record for every active compliance domain:

- GDPR in scope → `project-management/src/08-GDPR/IMPLEMENTATION/`
- Security changes → `project-management/src/09-SECURITY/ASSESSMENTS/IMPLEMENTATION/`
- QA artefacts → `project-management/src/10-QA/IMPLEMENTATION/`
- SEO changes → `project-management/src/11-SEO/IMPLEMENTATION/`
- API design changes → `project-management/src/12-API-DESIGN/IMPLEMENTATION/`

### Phase 5 — Exit Worktree (conditional)

If running inside a git worktree, call ExitWorktree after the PR is created.
