@./CONTEXT.md

# CLAUDE.md — scripts/development/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script inventory, services, nginx routing — imported above) → this file →
`reports/`.

## Purpose (one line)

Lifecycle control for the local dev Docker Compose stack — `server.sh`, `logs.sh`,
`shell.sh`, dependency install/update, and the
`new-django-app.sh` / `new-django-view.sh` scaffolders.

## How to work here

- **Routing:** the day-to-day entry point — `server.sh up [--seed]` starts everything
  behind nginx at `http://dev.{{PROJECT_SLUG}}.localhost`. **New Django app →
  `new-django-app.sh <name>`; new public marketing page → `new-django-view.sh <path>`**
  (Django view + template + urls entry) — never `manage.py startapp` or a
  hand-made route. The site is server-rendered by Django (templates +
  django-components + HTMX + Alpine); there is no client-side build, and
  `install-frontend.sh` / `pnpm-update.sh` maintain repo tooling only — never raw
  `pnpm`.
- **Model:** Opus to change a script or scaffolder and to run the stack,
  tail logs, or open a shell.
- **Concrete steps:** bring the stack up → work → `logs.sh --service <svc> --follow`
  to debug → `shell.sh --service <svc>` for an interactive container shell →
  `server.sh down` when finished.
- **Definition of done:** stack healthy via `server.sh status`; scaffolders leave a
  registered app / route with its `CONTEXT.md` + `CLAUDE.md` pair.

## Guardrails

- **`server.sh down --volumes` wipes the PostgreSQL data** — for a targeted DB reset
  that keeps volumes, use `database/reset.sh` instead.
- **`/admin/` is the {{PROJECT_NAME}} Admin hub** — Django's own admin lives at
  `/control/`; never mount it at `/admin/`.
- **Every new `src/` directory a scaffolder creates needs a `CONTEXT.md`** (and a
  paired `CLAUDE.md` where a `CONTEXT.md` exists).
- Secrets via environment only — never hardcode a credential in a script.

## Output & naming

- **Hand-written:** the `*.sh` scripts here.
- **Generated / gitignored:** `reports/` is reserved for future report output.
- Scripts `kebab-case.sh`; scaffolded Django apps `snake_case` (registered
  `apps.<name>`); marketing pages as a Django view + template + `urls.py` entry.
