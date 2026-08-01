# code/src/docker/nginx — Nginx Configurations

Reverse-proxy config for the dev and test stacks.

> Staging and production have **no Nginx container and no Nginx file in this repo** — the
> deployment server's own Nginx, provisioned by the NixOS deploy repo, does the reverse
> proxy there.

## Files

| File        | Used by                     | Purpose                       |
| ----------- | --------------------------- | ----------------------------- |
| `dev.conf`  | `nginx` service, dev stack  | Reverse proxy → `django`      |
| `test.conf` | `nginx` service, test stack | Reverse proxy → `django-test` |

Both are `server_name _` catch-alls, so a worktree stack reuses them unchanged — there are
no per-story Nginx variants to generate.

## Path routing (dev & test)

| Path        | Upstream                           | Notes                               |
| ----------- | ---------------------------------- | ----------------------------------- |
| `/static/`  | Nginx, from the staticfiles volume | `alias`, not proxied                |
| `/media/`   | `django:8000`                      |                                     |
| `/control/` | `django:8000`                      | Django's built-in admin             |
| `/`         | `django:8000`                      | Catch-all — every application route |

`test.conf` uses `django-test` as the upstream name, matching the service in
`docker-compose.test.yml`.

## Upstream resolution

Both configs use Docker's embedded DNS (`resolver 127.0.0.11`) with the upstream held in a
variable. Nginx therefore resolves the address per request rather than caching it at
start-up, so the `django` container can restart without taking Nginx down with it.

## X-Forwarded-Proto

Both configs forward the real scheme (`$scheme` — `http` locally). Django only trusts that
header where `SECURE_PROXY_SSL_HEADER` is set, which is `staging.py` and `production.py`
only; dev and test do not set it, and do not set `SECURE_SSL_REDIRECT` or the secure-cookie
flags either. The three settings move together — enabling `SECURE_SSL_REDIRECT` locally
without a TLS terminator in front produces an infinite redirect loop.

## Server Nginx (staging / prod)

Owned by the NixOS deploy repo, not this one. The reference shape:

```nginx
location ~ ^/(static|media|control)/ { proxy_pass http://127.0.0.1:8000; }
location / { proxy_pass http://127.0.0.1:8000; }
```

TLS termination and tunnel integration are handled at the server level.

## Cross-references

- `code/src/docker/CONTEXT.md` — full environment overview
- `code/docs/URL-STRATEGY.md` — why the admin is at `/control/`
