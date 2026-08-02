@./CONTEXT.md

# CLAUDE.md — code/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-layer map, imported above) → this file → the target sub-layer's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The source root — all deployable code: the Django project (`django/`, backend +
server-rendered frontend) and the `docker/`, `scripts/`, `tests/`, `logs/`, and
gitignored `improvement-architecture/` reports that support it.

## How to work here

- **Routing:** always descend to the right sub-layer first and read its `CONTEXT.md`
  before touching code. Django Python (models, services, Ninja API) → `stack-django`
  skill; Django templates + django-components + HTMX + Alpine + token CSS →
  `stack-htmx-templates` skill. All Opus. Start substantive changes from the matching
  `code/workflows/NN-…/` procedure.
- **Model:** Opus for design, code, tests, reviews and mechanical touches (renames,
  version bumps, running a script).
- **API:** new endpoints use **Django Ninja** — a per-app `api.py` router mounted onto the
  project's **one** `NinjaAPI` (`config/api.py`), served at `/api/` with auto OpenAPI at
  `/api/docs` — with Ninja Schema (Pydantic) request/response models and a named
  permission check on every endpoint. Nothing is wired at baseline; the first endpoint
  creates the instance (`code/docs/api-design/NINJA-CONVENTIONS.md`).
- **Every dev operation goes through the shell scripts under `scripts/`** — dev stack,
  migrations, syntax, tests. **Never invoke `pytest`, `python`, `manage.py`, or
  `docker` directly.**
- **Concrete steps:** read sub-layer `CONTEXT.md` → implement → `scripts/syntax/*.sh`
  → `scripts/tests/*.sh` → update any touched `CONTEXT.md`/`CLAUDE.md` → docs
  hard-gate before commit.
- **Definition of done:** quality gates green; coverage floors met; every new
  directory carries a `CONTEXT.md` + `CLAUDE.md` pair; British English throughout.

## Guardrails

- **Every new directory under `src/` needs a `CONTEXT.md` + `CLAUDE.md` pair** —
  orientation is paired, not optional.
- Source files **≤ 750 lines (800 grace)** — split into modules beyond that.
- Non-negotiables apply everywhere below: explicit permission check on every
  state-changing Django Ninja endpoint; user IDs verified against caller
  ownership (no IDOR); `DEBUG=False` outside local; never `CORS *` in production;
  secrets via environment only; Django's built-in admin lives at a non-obvious prefix
  (`/control/`), **never `/admin/`** (that prefix is the <%PROJECT_NAME%> Admin surface);
  token-first CSS (components consume `var(--token)` only).
- **No client-side build.** There is no bundler and no JavaScript source tree — every
  surface is a Django template. Adding one is an ADR-level stack change, never an
  incidental dependency (`code/docs/RENDERING.md`).
- **Never read** `node_modules/`, `django/static/vendor/`, `.git/`.

## Output & naming

- **Hand-written:** everything under `django/`, `docker/`, `scripts/`, `tests/`.
- **Generated / gitignored:** `logs/` runtime files,
  `improvement-architecture/*.html` review reports, and coverage/audit output under
  `scripts/reports/` and `scripts/tests/reports/`.
- Source directories `kebab-case/` (Django apps `snake_case`); documentation files
  `SCREAMING-SNAKE-CASE.md`.
