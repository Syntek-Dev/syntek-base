@./CONTEXT.md

# CLAUDE.md — docker/nginx/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(files, routing, upstream resolution — imported above) → this file.

## Purpose (one line)

The dev and test reverse-proxy configs — both `server_name _` catch-alls in front of the
single `django` upstream.

## How to work here

- **Routing:** proxy work → `cicd` skill (Opus). Edit `dev.conf` and `test.conf` together;
  they differ only in the upstream service name.
- **Model:** Opus.
- **Concrete steps:** add the `location` → bring the stack up → verify with
  `docker compose exec nginx nginx -t` before relying on it → check the route end to end.
- **Definition of done:** `nginx -t` passes in both stacks; the route resolves; dev/test
  parity held; `CONTEXT.md` routing table updated.

## Guardrails

- **Add a `location` only when the route needs different proxy behaviour** — buffering,
  timeouts, body size, or access control. Ordinary routes ride the `/` catch-all; a
  per-route block that just repeats the catch-all is noise that will drift.
- **Never enumerate application page slugs here.** Business routes belong in Django's
  URLconf, not the proxy — that coupling is what made the previous config impossible to
  reuse across projects.
- **Keep `dev.conf` and `test.conf` in step.** A route added to one belongs in the other.
- **Long-lived streaming routes need `proxy_buffering off`** plus raised
  `proxy_read_timeout`/`proxy_send_timeout`, and a `limit_conn` cap — an uncapped
  per-connection stream is a trivial resource-exhaustion vector.
- **Internal-only endpoints are restricted at the proxy** (`allow 127.0.0.1; deny all`)
  when the endpoint itself is unauthenticated — the network boundary is then the control,
  so it must also be mirrored in the server Nginx, which lives in the deploy repo.
- Django's built-in admin is `/control/`, never `/admin/`.

## Output & naming

- **Hand-written:** `dev.conf`, `test.conf`.
- Config files are named for the environment they serve; documentation
  `SCREAMING-SNAKE-CASE.md`.
