@./CONTEXT.md

# CLAUDE.md — docker/django/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(files, base image, server per environment — imported above) → this file.

## Purpose (one line)

The four Dockerfiles and four entrypoints for the single Python application container.

## How to work here

- **Routing:** image work → `cicd` skill (Opus). A change to one environment's Dockerfile
  usually belongs in the other three — check all four before finishing.
- **Model:** Opus.
- **Concrete steps:** edit the Dockerfile or entrypoint → rebuild
  (`docker compose -f code/src/docker/docker-compose.<env>.yml build`) → bring the stack up
  → confirm the entrypoint's migrate and server steps both run.
- **Definition of done:** all four images build; the entrypoints are executable; dev
  hot-reload still works; staging and prod still run as a non-root user.

## Guardrails

- **Build context is the project root** (`context: ../../..`) so `pyproject.toml` and
  `uv.lock` are reachable. Every `COPY` path is therefore repo-root-relative — a path
  written relative to this folder silently fails the build.
- **Keep the four environments in parity.** A system package added for dev is almost
  always needed in test, staging, and prod too.
- **No Node in this image.** The site is server-rendered; if a build step ever needs Node
  it belongs in a separate build stage, never in the runtime layer.
- **Staging and prod run as a non-root user** — do not regress that for convenience.
- **Secrets are never baked into an image** — they arrive as environment variables at run
  time. No `ARG`-then-`ENV` secret passing; the value persists in the layer history.
- **Entrypoints run migrations before the server starts.** Keep the `exec "$@"` passthrough
  so a one-off command container can reuse the image.

## Output & naming

- **Hand-written:** `Dockerfile.<env>`, `entrypoint.<env>.sh`.
- Files carry the environment suffix exactly matching the compose file that builds them;
  documentation `SCREAMING-SNAKE-CASE.md`.
