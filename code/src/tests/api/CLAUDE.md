@./CONTEXT.md

# CLAUDE.md — tests/api/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(collection layout + run commands, imported above) → this file → the target
sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The Bruno API test collection for the <%PROJECT_NAME%> Django Ninja API — one `kebab-case/`
folder of `.bru` requests per domain, all targeting `{{api_url}}/api/` against a live
backend. **Empty at baseline: the project serves no API yet.**

## How to work here

- **Routing:** contract/integration test work → `stack-django` skill (Opus); start from
  `code/workflows/04-api-design/`. Run via `code/src/scripts/tests/api.sh` (optionally
  `--folder <name>` or `--env <name>`) — **never call the Bruno CLI, `pnpm`, or `docker`
  directly.**
- **Model:** Opus for assertions and contract coverage, and for renames or running the
  script.
- **Concrete steps:** build and verify the endpoint first → create the domain folder with
  its `CONTEXT.md` + `CLAUDE.md` pair → copy `../template-test.bru` in and rename → verify
  names/fields against the live OpenAPI schema → assign the correct `seq` so ordering holds
  → run the folder, then the full suite.
- **Definition of done:** request passes on the docker stack; schema-verified; auth handled
  via `{{auth_token}}`; no credentials committed.

## Guardrails

- **A request without an endpoint is a failing request.** Add `.bru` files only for
  endpoints that exist — the collection was emptied precisely because it outlived the API
  it described, and `api.sh` is green only while it stays honest.
- **Auth ordering matters** once authenticated requests exist: `auth_token` is populated by
  the login request (`seq 1`) and bearer-auth requests depend on `auth/` sorting
  alphabetically first. Authenticated suites also need a `seed_api_test_user` management
  command — `api.sh` skips seeding with a warning while none is registered.
- The **CLI ignores `bruno.json`'s `ignore` list** — a `.bru` inside `api/` runs. Tag
  environment-dependent or destructive requests (`wip`, `manual`) and exclude them via
  `--exclude-tags`.
- **Never commit real credentials**; select the intended environment before every run.

## Output & naming

- **Hand-written:** `.bru` files, `bruno.json`, per-environment files under `environments/`.
- **Generated (gitignored):** JSON run reports under `scripts/**/reports/`.
- Request files `snake_case.bru`; domain folders `kebab-case/`.
