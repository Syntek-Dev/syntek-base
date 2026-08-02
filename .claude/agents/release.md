---
name: release
description: "Cut a release, bump the version number, or deploy to production"
model: opus
---

## Stack

Backend: Django 6.0.6 + Django Ninja + PostgreSQL | Scripts: `code/src/scripts/**/*.sh`
Frontend: Django templates + django-components + HTMX + Alpine + vanilla CSS (design tokens)
Branch naming: us###/short-description | Locale: <%LOCALE%> | Timezone: <%TIMEZONE%>

## Context Loading

Read in this order before spawning any sub-agents:

**Layer context:**

- `project-management/CONTEXT.md` — PM layer overview, release conventions and version state

**Workflows:**

- `project-management/workflows/21-release/CONTEXT.md` → `project-management/workflows/21-release/STEPS.md`

**Docs:**

- `project-management/docs/VERSIONING-GUIDE.md`
- `project-management/docs/GIT-GUIDE.md`

**References** (check when you need a specific link):

- `project-management/REFERENCES.md`

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/21-release/` — the release procedure — version bump, changelog, deploy
- `project-management/workflows/20-pr-and-review/` — the promotion chain that must be green first

## Non-Negotiables (pass to every sub-agent you spawn)

- Every state-changing Django Ninja endpoint needs explicit permission check (OWASP A01)
- User-supplied IDs verified against caller's ownership — no IDOR
- `DEBUG=False` in all non-local environments
- `CORS_ALLOWED_ORIGINS` explicit allowlist — never `*` in production
- All secrets via env vars — never hardcoded
- Django admin never at `/admin/` (that prefix belongs to the <%PROJECT_NAME%> Admin — Django views + templates + HTMX)
- Never commit `.env` files — use `.env.*.example` templates only

## Pre-flight

Run before any phase:

```bash
python3 .claude/plugins/env-tool.py find        # verify env files exist
python3 .claude/plugins/git-tool.py status      # confirm on staging or main, no uncommitted changes
```

Prerequisite: staging branch must be green. All sprint stories for this release must be marked complete.

## Spawn Protocol

Each phase below is a fresh Agent tool call. No agent reviews its own work.
Steps without a ↳ agent marker are performed by this orchestrating agent directly.
Brief each sub-agent fully in its prompt — it has no memory of previous phases.

## Workflow

### Phase 1 — Version Bump

↳ version bump [patch|minor|major] [opus]
Determine bump type from request: patch (bugfixes), minor (new features), major (breaking changes).
Updates: `VERSION`, `VERSION-HISTORY.md`, `RELEASES.md`, `CHANGELOG.md`,
`code/src/django/pyproject.toml`, `package.json`

### Phase 2 — Full Test Suite

No sub-agent. Run directly:

```bash
bash code/src/scripts/tests/backend.sh
bash code/src/scripts/tests/api.sh
```

Both must pass. If either fails, stop and report — do not deploy.

### Phase 3 — Commit Version Files

↳ git [opus]
Commit message: `chore(release): bump version to X.Y.Z`

### Phase 4 — Deploy

No sub-agent. Run directly:

```bash
bash code/src/scripts/deployment/production.sh
```
