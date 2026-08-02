# code/src/docker — Docker Configuration

Compose files, Dockerfiles, and entrypoints for all four environments. There is **one
application container, `django`**, which server-renders the site. No Node, no React, no
separate frontend container.

> **All compose commands run from the project root:**
> `docker compose -f code/src/docker/docker-compose.<env>.yml <command>`
>
> **Never run `python` or `pytest` directly — always `docker compose exec`.**

## Environments

| Environment | Compose file                 | Access                | Spun up by              |
| ----------- | ---------------------------- | --------------------- | ----------------------- |
| `dev`       | `docker-compose.dev.yml`     | `http://localhost:81` | Developer locally       |
| `test`      | `docker-compose.test.yml`    | `http://localhost:83` | CI / developer          |
| `staging`   | `docker-compose.staging.yml` | Server (tunnel)       | GitHub Actions → server |
| `prod`      | `docker-compose.prod.yml`    | Server (tunnel)       | GitHub Actions → server |

> Dev and test bind different host ports (`81` / `83`) so both can run at once. The
> container side is always `80`; host `80` is left free for other local tooling.

## Services

| Service  | Image                    | dev | test | staging | prod |
| -------- | ------------------------ | --- | ---- | ------- | ---- |
| `django` | `python:3.14-slim`       | ✅  | ✅   | ✅      | ✅   |
| `db`     | `postgres:18-alpine`     | ✅  | ✅   | ❌      | ❌   |
| `cache`  | `valkey/valkey:8-alpine` | ✅  | ✅   | ❌      | ❌   |
| `nginx`  | `nginx:alpine`           | ✅  | ✅   | ❌      | ❌   |

> **Staging and production:** Postgres, Valkey, and Nginx run on the server, not in
> Compose — only the `django` container is deployed. **Pin `valkey/valkey:8-alpine` to a
> digest before the first production release.**

## Application server (`django`)

- **dev** — Uvicorn directly (`--reload`), so `.py` and template edits hot-reload.
- **test** — Gunicorn + one Uvicorn worker; the container stays up for `exec pytest`.
- **staging / prod** — Gunicorn + Uvicorn workers, count tuned by `GUNICORN_WORKERS`,
  `GUNICORN_TIMEOUT`, `GUNICORN_MAX_REQUESTS`.

## Path routing (Nginx — dev / test)

Every route resolves to the django upstream. `/static/` is served from disk by Nginx.

| Path        | Upstream                           |
| ----------- | ---------------------------------- |
| `/static/`  | Nginx, from the staticfiles volume |
| `/media/`   | `django`                           |
| `/control/` | `django` — Django's built-in admin |
| `/`         | `django` — catch-all               |

> Django's built-in admin is at `/control/`, **never `/admin/`**. See
> `code/docs/URL-STRATEGY.md`.

## Directory layout

```text
docker/
├── django/                  # the application container
│   ├── Dockerfile.dev        # Uvicorn --reload; source mounted as a volume
│   ├── Dockerfile.test       # source baked in; run pytest via exec
│   ├── Dockerfile.staging    # multi-stage; Gunicorn + Uvicorn; non-root
│   ├── Dockerfile.prod       # multi-stage; Gunicorn + Uvicorn; non-root
│   └── entrypoint.<env>.sh   # migrate → server (collectstatic in test/staging/prod)
├── nginx/
│   ├── dev.conf              # proxy → django:8000
│   └── test.conf             # proxy → django-test:8000
├── postgres/
│   └── postgresql.dev.conf   # local tuning
├── docker-compose.<env>.yml
├── docker-compose.usXXX.dev.yml.example    # worktree isolation template
├── docker-compose.usXXX.test.yml.example   # worktree isolation template
└── .env.<env>.example        # environment templates — copy, never commit the real file
```

## Health check

The stacks probe `/control/` — the only route the baseline serves. It answers `302` to the
admin login, which proves the process is up and the URLconf loaded. **Repoint the
healthchecks at a dedicated liveness route once one exists.**

## Network subnet scheme

Explicit bridge subnets, so Docker never auto-assigns from the 192.168.x.x pool (which
collides with common VPN and home-router ranges).

| Stack          | Subnet                                           |
| -------------- | ------------------------------------------------ |
| Main dev       | `10.0.1.0/24`                                    |
| Main test      | `10.0.0.0/24`                                    |
| Per-story dev  | `10.NNN.1.0/24` — story 7 dev → `10.7.1.0/24`    |
| Per-story test | `10.NNN.0.0/24` — story 59 test → `10.59.0.0/24` |

Third octet `0` = test, `1` = dev. Second octet = story number (`0` = main stacks). Story
numbers above 254 overflow — rename to a sub-range before that point.

## Worktree stacks

A per-story stack runs **concurrently** with the main dev stack, so every host-facing port
the base file binds must be re-scoped in the override — otherwise the second stack collides
with the first. Copy `docker-compose.usXXX.dev.yml.example`, replace `NNN` throughout, and
add the matching `/etc/hosts` entry (`127.0.0.NNN`). Keep worktree IPs at `127.0.0.2`+;
`127.0.0.1` is the main stack. The Nginx configs are `server_name _` catch-alls, so a
worktree stack reuses them unchanged.

## Cross-references

- `code/src/django/CONTEXT.md` — the Django project and its settings
- `how-to/workflows/01-first-time-setup/` — first run of the dev stack
- `how-to/workflows/03-daily-development/` — daily Compose commands
