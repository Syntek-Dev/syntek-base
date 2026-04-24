# Project: project-name

**Last Updated**: 19/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB) **Timezone**: Europe/London

---

> **Dev:** Always use `docker compose exec backend` for Django, `docker compose exec frontend` for
> Next.js, and `docker compose exec mobile` for Expo. Never run `python`, `pytest`, `pnpm`, or
> `next` directly outside the container.

---

## Layer Routing

Read only the layer relevant to your task:

| Task type                                  | Read first                      |
| ------------------------------------------ | ------------------------------- |
| Writing, reviewing, or testing code        | `code/CONTEXT.md`               |
| Stories, sprints, PRs, releases, GDPR, SEO | `project-management/CONTEXT.md` |
| Setup, daily dev, CLI usage, debugging     | `how-to/CONTEXT.md`             |

Always-applicable guides: `project-management/docs/GIT-GUIDE.md` · `project-management/docs/VERSIONING-GUIDE.md`

---

## Critical Global Rules

**Coding:**

- Max 750 lines per file (800 with grace). Split into modules beyond that.
- Short, focused functions — one purpose each. Favour readability over cleverness.
- `except (A, B):` not `except A, B:`. Log at ERROR/WARNING before swallowing.
- `transaction.atomic()` on every service method doing ≥ 2 writes.
- No inline imports inside functions except where unavoidable (document the reason).

**Security (non-negotiable):**

- Every GraphQL mutation needs explicit permission check (OWASP A01).
- User-supplied IDs always verified against caller's ownership — no IDOR.
- Django `DEBUG=False` in all non-local environments.
- CORS `ALLOWED_ORIGINS` must be an explicit allowlist — never `*` in production.
- All secrets via environment variables — never hardcoded.

**Testing:**

- Green = real implementation passing. No stubs to get green.
- Backend coverage floor: 75% all modules; 90% for auth-related code.
- Frontend coverage floor: 70% minimum.

**Scripts:**

- Never run `pnpm`, `npm`, `npx`, `uv`, `pip`, or any package-manager command directly.
- Always use the project shell scripts in `code/src/scripts/**/*.sh` instead.
- If no script exists for the task, ask the user to create one before proceeding.

**Documentation (Markdown):**

- Every fenced code block must declare its language — ` ```bash `, ` ```python `,
  ` ```typescript `, ` ```text `, etc. A bare ` ``` ` is a lint error (MD040).

**Before every commit:** lint and type-check both layers.
**Before every push:** run full test suite.

Full detail → `code/CONTEXT.md`

---

## MCP Servers

| Server              | Scope              | Always available                       |
| ------------------- | ------------------ | -------------------------------------- |
| `code-review-graph` | Repo — `.mcp.json` | Yes — auto-loaded for all contributors |
| `context7`          | Machine-global     | Only if installed locally              |
| `claude-in-chrome`  | Machine-global     | Only if installed locally              |
| `mcp-mermaid`       | Machine-global     | Only if installed locally              |
| `figma`             | Machine-global     | Only if installed locally              |

**Documentation lookups** (`context7`): Always prefer over web search for any library, framework,
or SDK. Use `mcp__context7__resolve-library-id` → `mcp__context7__query-docs`.

**Code graph** (`code-review-graph`): Use before Grep/Glob/Read. Faster, cheaper on tokens,
structural context.

**Browser automation** (`claude-in-chrome`): For inspecting rendered output and visual verification.
Load tool schema with ToolSearch before calling any `mcp__claude-in-chrome__*` tool.

**Design context** (`figma`): Use for reading Figma design files, generating FigJam diagrams, and
managing Code Connect mappings. Load tool schema with ToolSearch before calling any
`mcp__figma__*` tool. Prioritise when the user shares a figma.com URL.

---

## Model Selection

Always use the **latest model in the family** — never hardcode version strings. In agent calls:
`model: "haiku"` / `model: "sonnet"` / `model: "opus"`.

| Family     | Use for                                                                                   |
| ---------- | ----------------------------------------------------------------------------------------- |
| **Haiku**  | Fast lookups, single-file reads, CONTEXT.md updates, formatting, simple renames           |
| **Sonnet** | Standard coding, tests, reviews, documentation, stories, sprints, CI runs _(default)_     |
| **Opus**   | Complex architecture, security audits, GDPR analysis, cross-layer refactors, novel design |

When in doubt, use **Sonnet**. Escalate to **Opus** only when the problem genuinely requires deeper
reasoning.

---

## GAPS.md Rule

If Claude encounters a workflow folder (any path matching `*/workflows/[0-9][0-9]-*/`) that is
missing `STEPS.md` or `CHECKLIST.md`, it must:

1. Append an entry to `/GAPS.md` at the project root with the missing file path and a suggested
   description
2. Proceed using `CONTEXT.md` alone as best-effort guidance
3. Never generate and silently commit missing files without explicit user instruction

Check `/GAPS.md` at the start of any workflow to see if it has been recently updated.

---

## Routing Rule

Read a workflow's `CONTEXT.md` for decision-making without executing it. Only enter `STEPS.md`
when the workflow is explicitly triggered by the user or another agent.

| Task Type                                              | Domain                | Read First                      |
| ------------------------------------------------------ | --------------------- | ------------------------------- |
| Writing code, TDD, security, API design, DB migrations | `code/`               | `code/CONTEXT.md`               |
| Project setup, daily dev, debugging                    | `how-to/`             | `how-to/CONTEXT.md`             |
| Stories, sprints, PRs, releases, GDPR compliance       | `project-management/` | `project-management/CONTEXT.md` |

---

## Naming Conventions

### Files

| Pattern                          | Example                     | Used for                           |
| -------------------------------- | --------------------------- | ---------------------------------- |
| `SCREAMING-SNAKE-CASE.md`        | `CONTEXT.md`, `OVERVIEW.md` | All documentation files            |
| `US###.md`                       | `US015.md`                  | User stories (3-digit zero-padded) |
| `SPRINT-##.md`                   | `SPRINT-06.md`              | Sprint plans (2-digit)             |
| `US###-TEST-STATUS.md`           | `US015-TEST-STATUS.md`      | Test tracking per story            |
| `US###-MANUAL-TESTING.md`        | `US015-MANUAL-TESTING.md`   | Manual test guide per story        |
| `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` | `BUG-AUTH-18-04-2026.md`    | Bug reports                        |

### Directories

| Pattern                 | Example                 | Used for                 |
| ----------------------- | ----------------------- | ------------------------ |
| `SCREAMING-SNAKE-CASE/` | `STORIES/`, `PLANS/`    | Documentation/PM folders |
| `kebab-case/`           | `backend/`, `frontend/` | Source code directories  |

### Branches

Format: `us###/short-description` — full rules in `project-management/docs/GIT-GUIDE.md`.

---

## Skill Targets

- **Stack Skill (Backend):** `stack-django`
- **Stack Skill (Frontend):** `stack-react`
- **Global Skill:** `global-workflow`

---

## Stack Overview

| Component           | Technology                                                          |
| ------------------- | ------------------------------------------------------------------- |
| **Type**            | Full-Stack Monorepo (Backend + Web + Mobile)                        |
| **Backend Lang**    | Python 3.14                                                         |
| **Backend Frame**   | Django 6.0.4                                                        |
| **GraphQL**         | Strawberry GraphQL 0.314.3                                          |
| **Database**        | PostgreSQL 18                                                       |
| **Backend Server**  | Gunicorn + Uvicorn / Nginx                                          |
| **Cache / Queue**   | Valkey (latest stable at release)                                   |
| **Frontend Frame**  | Next.js 16.2.4 (App Router)                                         |
| **Mobile Frame**    | Expo SDK (latest) + Expo Router + React Native 0.85.x               |
| **Mobile Styling**  | NativeWind 4.2.3 + react-native-css-interop 0.2.3 (Tailwind CSS v3) |
| **Frontend Lang**   | TypeScript 6.0.3                                                    |
| **UI Library**      | React 19.2 / React Native                                           |
| **Shared UI**       | `code/src/shared/` (cross-platform components)                      |
| **Styling**         | Tailwind CSS 4.2                                                    |
| **GraphQL Client**  | Apollo Client                                                       |
| **Code Generation** | GraphQL Code Generator                                              |
| **Node Runtime**    | Node.js 24.15.0                                                     |
| **Package Manager** | pnpm 10.33.0 (JS) / uv 0.11.7 (Python)                              |
| **Backend Tests**   | pytest, pytest-django                                               |
| **Frontend Tests**  | Vitest, React Testing Library                                       |
| **Mobile Tests**    | Jest + React Native Testing Library (unit/TDD), Detox (E2E/BDD)     |
| **Container**       | Docker Compose                                                      |

---

## Key Locations

| Path                                       | Purpose                                          |
| ------------------------------------------ | ------------------------------------------------ |
| `code/src/backend/`                        | Django project root                              |
| `code/src/backend/apps/`                   | Django apps (users, core, content, etc.)         |
| `code/src/backend/apps/core/schema.py`     | Root Strawberry GraphQL schema                   |
| `code/src/backend/config/settings/`        | Environment-specific Django settings             |
| `code/src/frontend/`                       | Next.js project root                             |
| `code/src/frontend/src/app/`               | Next.js App Router pages                         |
| `code/src/frontend/src/components/`        | Page-specific React components                   |
| `code/src/frontend/src/graphql/`           | Web GraphQL queries, mutations, fragments        |
| `code/src/frontend/src/graphql/generated/` | Auto-generated TypeScript types and hooks        |
| `code/src/mobile/`                         | Expo React Native app root                       |
| `code/src/mobile/app/`                     | Expo Router screens                              |
| `code/src/mobile/src/graphql/`             | Mobile GraphQL queries, mutations, fragments     |
| `code/src/mobile/src/graphql/generated/`   | Auto-generated TypeScript types and hooks        |
| `code/src/shared/`                         | Cross-platform components, hooks, and utilities  |
| `project-management/src/`                  | Stories, sprints, GDPR docs, security audits, QA |

---

## Environment

| Setting                | Value                                |
| ---------------------- | ------------------------------------ |
| **Frontend URL (Dev)** | http://localhost:3000                |
| **Backend URL (Dev)**  | http://localhost:8000                |
| **GraphQL Endpoint**   | http://localhost:8000/graphql/       |
| **GraphQL Playground** | http://localhost:8000/graphql/ (dev) |
| **Django Admin**       | http://localhost:8000/admin/         |
| **Database (Dev)**     | project_name_dev                     |
| **Locale**             | en_GB                                |
| **Timezone**           | Europe/London                        |
| **Currency**           | GBP (£)                              |

---

## SEO & Accessibility

SEO applies to all Next.js pages in `code/src/frontend/src/app/`. Full checklist:
`project-management/docs/SEO-CHECKLIST.md`. Use `/syntek-dev-suite:seo` to implement.

WCAG 2.2 AA compliance required on all interactive frontend components.
Full guide: `code/docs/ACCESSIBILITY.md`.

---

## Versioning

Single-track semver for this project. Full rules: `project-management/docs/VERSIONING-GUIDE.md`.
Use `/syntek-dev-suite:version` to manage all version bumps.
