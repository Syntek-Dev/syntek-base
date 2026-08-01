@./CONTEXT.md

# CLAUDE.md — django/config/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(routes and entry points — imported above) → this file → `settings/`'s
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The Django project configuration package — root URL conf (`urls.py`), the ASGI/WSGI entry
points, and the environment-split `settings/`.

## How to work here

- **Routing:** config work → `stack-django` skill (Opus). Route changes touch `urls.py`;
  per-environment values belong in `settings/` (descend and read its `CONTEXT.md` first).
- **Model:** Opus for URL, ASGI, and settings changes, and for mechanical touches.
- **Concrete steps:** edit `urls.py` / `asgi.py` → mount each app's routes via
  `include()` rather than importing views here → test via `code/src/scripts/tests/*.sh`;
  lint/type-check via `code/src/scripts/syntax/*.sh`. **Never run `python`, `manage.py`,
  `pytest`, or `docker` directly.**
- **Definition of done:** routes resolve; `DEBUG` still absent from `base.py`;
  `CONTEXT.md` route table updated.

## Guardrails

- **Django admin is never mounted at `/admin/`** — that prefix is reserved for the
  project's own admin surface. Django admin mounts at `DJANGO_ADMIN_PATH` (`control/`).
  See `code/docs/URL-STRATEGY.md`.
- **`urls.py` imports from `config` only.** Give each app its own `urls.py` and
  `include()` it, so removing an app never breaks the root URL conf — the coupling that
  made the previous tree impossible to strip cleanly.
- **Route order is load-bearing** once a catch-all exists: specific routes first, any
  slug catch-all last.
- Files **≤ 750 lines (800 grace)**.

## Output & naming

- **Hand-written:** `urls.py`, `asgi.py`, `wsgi.py`, `settings/*.py`.
- Module names are fixed by Django (`urls`, `asgi`, `wsgi`); documentation
  `SCREAMING-SNAKE-CASE.md`; routes follow `code/docs/URL-STRATEGY.md`.
