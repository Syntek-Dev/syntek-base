@./CONTEXT.md

# CLAUDE.md — code/src/tests/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree + purpose, imported above) → this file → the target `api/` `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The API integration and contract test root — the Bruno collection under `api/` that runs
against a **live** Django Ninja backend, plus `template-test.bru`, the annotated request template
kept deliberately outside `api/` so the CLI never executes it. At baseline the collection holds
configuration, environments, and one folder — `api/health/`, the liveness and readiness contract,
which is root-mounted rather than under `/api/` and therefore runnable before any endpoint exists.

## How to work here

- **Routing:** API test work → `stack-django` skill (Opus) when verifying backend
  contracts; start from `code/workflows/04-api-design/`. Run the suite via
  `code/src/scripts/tests/api.sh` — **never invoke the Bruno CLI, `pnpm`, or `docker`
  directly.**
- **Model:** Opus for authoring assertions and contract coverage and renames
  or running the script.
- **Concrete steps:** copy `template-test.bru` into the right `api/<folder>/` and rename →
  verify every endpoint against the live OpenAPI schema at
  `http://dev.<%PROJECT_SLUG%>.localhost:81/api/docs`
  → select the correct environment (`local`/`docker`/`staging`/`production`) → run
  `code/src/scripts/tests/api.sh`.
- **Definition of done:** requests pass against the docker test stack; schema-verified;
  environment-parameterised; no real credentials committed.

## Guardrails

- **These require a running backend** — they are integration/contract tests, not unit
  tests. Do not treat a green run without a live API as meaningful.
- **Never commit real credentials** — use Bruno secret variables or inject from CI.
- Keep `template-test.bru` **outside** `api/`; the CLI runs the collection recursively and
  would execute (and fail) any placeholder left inside it.
- Always select the intended environment before running — never point a state-changing suite at
  `production` by accident.

## Output & naming

- **Hand-written:** `.bru` request files and `template-test.bru`.
- **Generated (gitignored):** JSON run reports under `scripts/**/reports/`.
- Request files `snake_case.bru`; collection folders `kebab-case/`.
