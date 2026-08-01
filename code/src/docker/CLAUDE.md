@./CONTEXT.md

# CLAUDE.md — code/src/docker/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(environments, services, routing, subnet scheme — imported above) → this file → the
target sub-folder's (`django/`, `nginx/`, `postgres/`) `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The Docker layer — Compose files, per-environment Dockerfiles and entrypoints, and the
Nginx and Postgres config, across `dev`, `test`, `staging`, and `prod`. One application
container, `django`, server-renders everything.

## How to work here

- **Routing:** infra work → `cicd` agent (Opus). Descend to the right sub-folder and read
  its `CONTEXT.md` before editing an image or the proxy. All compose commands run **from
  the project root**: `docker compose -f code/src/docker/docker-compose.<env>.yml <cmd>`.
- **Model:** Opus for Dockerfile/compose/proxy changes and for image-tag bumps.
- **Concrete steps:** edit the env-specific file → keep dev/test/staging/prod parity →
  bring the stack up and exercise it via `docker compose exec`. **Never run `python` or
  `pytest` directly.**
- **Definition of done:** all four environments still build; ports and subnets do not
  collide; healthchecks pass; `CONTEXT.md` updated.

## Guardrails

- **A service earns its place.** This stack is deliberately four containers. Do not add
  one speculatively — add it with the feature that needs it, and delete it with that
  feature. A compose file describing infrastructure nothing uses is worse than no file.
- **`DEBUG=False` outside local**; secrets flow via `.env.<env>` files (never committed)
  and env vars — never baked into an image, never a working default in production.
- **Django's built-in admin is at `/control/`, never `/admin/`** — see
  `code/docs/URL-STRATEGY.md`.
- **Nginx configs are `server_name _` catch-alls.** Add a specific `location` only for a
  route that needs different proxy behaviour (buffering, timeouts, body size); everything
  else rides the catch-all.
- **Re-scope every published port** in a worktree override to `127.0.0.NNN`, matching the
  `/etc/hosts` entry — otherwise the per-story stack collides with the main one.
- Pin `valkey/valkey:8-alpine` to a digest before the first production release.
- Every new directory under `src/` gets a `CONTEXT.md` + `CLAUDE.md` pair.

## Output & naming

- **Hand-written:** `docker-compose.<env>.yml`, `Dockerfile.<env>`, `entrypoint.<env>.sh`,
  the Nginx `.conf` files, `postgresql.dev.conf`, and the `.env.<env>.example` templates.
- **Templates (copy, never edit in place):** `*.usXXX.*.example` for worktree stacks.
- **Never committed:** `.env.dev`, `.env.test`, `.env.staging`, `.env.prod`.
- Compose files and Dockerfiles carry the environment suffix; documentation
  `SCREAMING-SNAKE-CASE.md`; worktree files carry the `usNNN` story tag.
