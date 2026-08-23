@./CONTEXT.md

# CLAUDE.md — workflows/20-api-code/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, governing documents — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The Django Ninja API implementation workflow — write the routers, endpoints, and
request/response Schemas that expose backend services to machine clients over
JSON (`/api/*`), implementing the signed-off `API-US###` design once backend
models and services exist and are tested.

## How to work here

- **Routing:** this workflow _drives code_ under the `stack-django` skill (Opus),
  alongside `code/workflows/04-api-design/`, `02-tdd-cycle/`, and
  `08-security-hardening/`. Hard gates to read first:
  `api-design/NINJA-CONVENTIONS.md`, `security/AUTH-AND-AUTHZ.md`,
  `testing/COVERAGE.md`.
- **Model:** Opus for routers, endpoints, Schemas, and tests and renames or running
  a script.
- **Concrete steps:** implement the `API-US###` contract → app `router` + Schemas in
  the app's `api.py`, mounted onto the project's single `NinjaAPI` (`config/api.py`,
  served at `/api/`) → endpoints stay thin, logic in services →
  consumers read the Ninja JSON directly (no codegen step) → tests via
  `code/src/scripts/tests/*.sh`.
  **Never run `pytest`, `python`, or `docker` directly.** Satisfy `CHECKLIST.md`; next
  is `workflows/21-frontend-code/`.
- **Definition of done:** every mutating endpoint permission-checked; coverage floor
  met (75% / 90% auth); checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Every mutating endpoint carries an explicit permission check** (OWASP A01,
  CLAUDE.md Section 6); user-supplied IDs verified against caller ownership — no IDOR.
- **Endpoints contain no business logic** — that stays in the service layer.
- Consumers read the Ninja JSON directly — the API is Python-typed end to end, so
  there is no codegen step and no generated types to hand-edit.
- All operations go through `code/src/scripts/**/*.sh`. Source files ≤ 750 lines
  (800 grace).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the API code in
  `code/src/django/apps/<name>/api.py` and its mount onto the single `NinjaAPI`.
- **Generated:** none — the Ninja API is Python-typed; consumers read its JSON at
  runtime, so there is no codegen artefact.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; API docs
  referenced as `API-US###`; dates DD/MM/YYYY.
