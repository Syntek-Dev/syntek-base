@./CONTEXT.md

# CLAUDE.md — workflows/04-api-design/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when to use, schema layout — imported above) → this file.

## Purpose (one line)

The procedure for adding or modifying the Django Ninja JSON API surface — Router
modules, Schema request/response models, and endpoints — with endpoints kept thin
over services.

## How to work here

- **Routing:** execute via `STEPS.md` through the `stack-django` skill (Opus). Routers
  in `apps/<app>/api.py`, Schema models in `apps/<app>/schemas.py`, aggregated on the
  root `NinjaAPI` mounted at `/api/`; business logic delegated to
  `apps/<app>/services.py`.
- **Model:** Opus for Schema/endpoint design and mechanical edits
  to the workflow files.
- **Research:** when a stack choice or ADR/PLAN behind the API needs grounding
  beyond one library's API docs, load `.claude/skills/research/SKILL.md` for a
  primary-source-cited note (ADR groundwork).
- **Concrete steps:** confirm the data model is agreed and containers are up → read
  the two hard-gate docs (`api-design/NINJA-CONVENTIONS.md`,
  `security/AUTH-AND-AUTHZ.md`) → define Schema models and endpoints, permission-checking
  every state-changing endpoint → regenerate and commit the OpenAPI schema → add API
  tests → complete `CHECKLIST.md`.
- **Definition of done:** conventions pass and the auto OpenAPI at `/api/docs` reflects
  the endpoints, every state-changing endpoint permission-checked with no IDOR, response
  Schema models expose every writable input field.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Every state-changing endpoint carries an explicit permission check** and verifies
  IDs against caller ownership — authz is the requirement, not an afterthought.
- Endpoints stay thin — logic lives in services.
- **The site does not consume this API.** Pages use HTMX against Django views; a browser
  `fetch` to a Ninja endpoint means rendering HTML client-side, which the stack rejects
  (`code/docs/api-design/CLIENT-PATTERNS.md`).
- Never invoke `python` or `pytest` directly — only the shell scripts.

## Output & naming

- **Hand-written:** these workflow files; routers/schemas/endpoints under
  `code/src/django/apps/`.
- **Generated (never hand-edit):** the auto OpenAPI schema at `/api/docs`.
- Workflow files `SCREAMING-SNAKE-CASE.md`.
