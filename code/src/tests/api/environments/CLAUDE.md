@./CONTEXT.md

# CLAUDE.md — api/environments/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(env file list + rules, imported above) → this file.

## Purpose (one line)

Bruno environment configuration for the API collection — `host`, `docker`, `local`,
`staging`, and `production` files (`.bru` + `.json`) that set `api_url` and shared
thresholds, plus `variables.json` declaring the shared runtime variables.

## How to work here

- **Routing:** test-harness config → `stack-django` skill (Opus) when tied to API contracts.
  These files are selected by `code/src/scripts/tests/api.sh --env <name>` — **never invoke the
  Bruno CLI, `pnpm`, or `docker` directly.**
- **Model:** Opus for a routine `api_url` or threshold edit and when changing the variable
  contract that requests depend on.
- **Concrete steps:** edit the target env file → keep `.bru` and `.json` variants in step →
  update `variables.json` if you add a shared variable → confirm dependent requests still
  resolve `{{api_url}}` and `{{auth_token}}` → run a folder against that env.
- **Definition of done:** `host.*` still points at the test nginx and `docker.*` at
  `http://django-test:8000`; no credentials committed; both file formats consistent.

## Guardrails

- **Credentials are never stored here.** `variables.json` declares runtime variables with
  empty values; real ones are injected per-run with the `BRUNO_VAR_` prefix (CI secrets,
  or the shell). Secrets via environment only.
- **`.bru` and `.json` are two views of one environment — change both.** The desktop app
  and the CLI read different formats; a drifted pair sends two runners to two URLs, and
  nothing warns you.
- `host.*` is `api.sh`'s default (Bruno on the host, through the published nginx port);
  `docker.*` is the CI default (inside the network, hostname `django-test`). Do not
  repoint either at the other's target.
- **Environment URLs come from tokens, not hand-typed hostnames** — `host` from
  `{{PROJECT_SLUG}}`, `staging`/`production` from `{{PRIMARY_DOMAIN}}`, so `setup.sh`
  resolves them at instantiation. A literal hostname here survives instantiation and
  silently points a new project at the template's domain.
- Never point a mutation run at `production` by accident.

## Output & naming

- **Hand-written:** the per-environment `.bru`/`.json` files and `variables.json`.
- Environment files are named by environment (`local`, `docker`, `staging`, `production`).
