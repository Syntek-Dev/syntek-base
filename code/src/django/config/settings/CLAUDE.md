@./CONTEXT.md

# CLAUDE.md — config/settings/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(module map + critical settings, imported above) → this file.

## Purpose (one line)

The environment-split Django settings — `base.py` holds every shared value; `dev.py`,
`staging.py`, `production.py`, and `test.py` each import it and override only what
differs, selected at runtime via `DJANGO_SETTINGS_MODULE`.

## How to work here

- **Routing:** settings work → `stack-django` skill (Opus). Shared value → `base.py`;
  a value that differs per environment → that environment's module, never `base.py`.
- **Model:** Opus for security-sensitive settings (auth, CORS, proxies, encryption) and
  for mechanical touches.
- **Concrete steps:** decide shared vs per-environment → add the setting → read secrets
  from `os.environ` (never inline) → run the test settings via
  `code/src/scripts/tests/*.sh`. **Never run `python` or `manage.py` directly.**
- **Definition of done:** `DEBUG=False` in every non-local module; all secrets
  env-sourced; the `CONTEXT.md` settings table updated.

## Guardrails

- **`DEBUG` is deliberately absent from `base.py`** — set it only per environment;
  `DEBUG=False` in `staging.py` and `production.py` (non-negotiable).
- **`AUTH_USER_MODEL` is unset, so Django uses `auth.User`.** If a custom user model is
  wanted it must land **before the first migration** — changing it afterwards needs manual
  FK surgery across every table that references the user.
- **When an API surface is added, `CORS_ALLOWED_ORIGINS` becomes an explicit allowlist** —
  never `["*"]` outside local dev, and `corsheaders` must be registered for it to have any
  effect at all. A setting no middleware reads is worse than no setting.
- **Secrets come from environment variables only** — `SECRET_KEY`, database credentials,
  and any key added later. Never a literal, never a default that works in production.
- **Never hardcode a proxy IP.** If proxy trust is reintroduced, drive it from an env var.
- Adding to `INSTALLED_APPS` or `MIDDLEWARE` is a deliberate act — the baseline is
  `django.contrib.*` plus Django's default middleware, and it stays that way until a
  feature genuinely requires more.

## Output & naming

- **Hand-written:** `base.py`, `dev.py`, `staging.py`, `production.py`, `test.py`.
- Environment modules match `config.settings.<env>` exactly; documentation
  `SCREAMING-SNAKE-CASE.md`.
