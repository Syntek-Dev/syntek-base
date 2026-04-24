# code/src/docker — Docker Configuration

Docker Compose files, Dockerfiles, and entrypoint scripts for all four environments.

> **All compose commands are run from the project root:**
> `docker compose -f code/src/docker/docker-compose.<env>.yml <command>`
>
> **Never run `python`, `pytest`, `pnpm`, or `next` directly — always use `docker compose exec`.**

## Environments

| Environment | Compose file                 | URL / access                     | Who spins it up         |
| ----------- | ---------------------------- | -------------------------------- | ----------------------- |
| `dev`       | `docker-compose.dev.yml`     | `dev.projectname.com` (port 80)  | Developer locally       |
| `test`      | `docker-compose.test.yml`    | `test.projectname.com` (port 80) | CI / developer          |
| `staging`   | `docker-compose.staging.yml` | CF Tunnel subdomain              | GitHub Actions → server |
| `prod`      | `docker-compose.prod.yml`    | CF Tunnel root domain            | GitHub Actions → server |

## Images

| Service    | Image             | Version          | Environments             |
| ---------- | ----------------- | ---------------- | ------------------------ |
| `backend`  | `python`          | `3.14-slim`      | all                      |
| `frontend` | `node`            | `24.15.0-alpine` | dev, test (builder)      |
| `frontend` | `nginx`           | `alpine`         | dev, test, staging, prod |
| `db`       | `postgres`        | `18-alpine`      | dev, test                |
| `cache`    | `valkey/valkey`   | `8-alpine`       | dev, test                |
| `maildev`  | `maildev/maildev` | `latest`         | dev, test                |
| `nginx`    | `nginx`           | `alpine`         | dev, test                |

> **Staging and production:** Postgres and Valkey run on the server — not in Docker.
> Only `backend` and `frontend` containers are deployed.

> **Pin `valkey/valkey:8-alpine` to an exact digest before the first production release.**

## Backend server

The backend runs **Gunicorn with Uvicorn workers** (ASGI) in all non-dev environments:

```bash
gunicorn config.asgi:application -k uvicorn.workers.UvicornWorker
```

In dev, **Uvicorn** runs directly with `--reload` for hot-reloading.

Tunable env vars (staging / prod): `GUNICORN_WORKERS`, `GUNICORN_TIMEOUT`, `GUNICORN_MAX_REQUESTS`.

## Frontend

In `dev` and `test`, Next.js runs its dev server (port 3000) behind the Nginx proxy.

In `staging` and `prod`, Next.js is built to a **static export** (`output: 'export'` in `next.config.ts`).
The output is served by Nginx inside the container — no Node.js runtime at run time.

`NEXT_PUBLIC_GRAPHQL_URL` is baked in at image build time via `ARG` in `Dockerfile.staging/prod`.

## GHCR image names

```text
ghcr.io/Syntek-Dev/project-name/backend:<tag>
ghcr.io/Syntek-Dev/project-name/frontend:<tag>
```

Tags: `staging`, `prod`, or a specific git SHA / semver string.
Set `IMAGE_TAG` in the server environment to control which image is pulled.

## Path routing (Nginx — dev / test)

| Path prefix                | Upstream           |
| -------------------------- | ------------------ |
| `/graphql/`                | backend (ASGI)     |
| `/admin/`                  | backend (Django)   |
| `/static/`                 | backend            |
| `/health/`                 | backend            |
| `/_next/webpack-hmr` (dev) | frontend (HMR WS)  |
| `/`                        | frontend (Next.js) |

> **Media files are served by Cloudinary in all environments.**
> No `/media/` route exists in any nginx config. Django's `DEFAULT_FILE_STORAGE` uses
> Cloudinary storage in every environment — no local media volume is required.

## Directory layout

```text
docker/
├── backend/
│   ├── Dockerfile.dev         # Uvicorn hot-reload; source mounted as volume
│   ├── Dockerfile.test        # Source baked in; runs pytest on start
│   ├── Dockerfile.staging     # Multi-stage; Gunicorn + Uvicorn; non-root user
│   ├── Dockerfile.prod        # Multi-stage; Gunicorn + Uvicorn; non-root user
│   ├── entrypoint.dev.sh      # migrate → uvicorn --reload
│   ├── entrypoint.test.sh     # migrate → pytest (exits with test result code)
│   ├── entrypoint.staging.sh  # migrate → collectstatic → gunicorn (2 workers)
│   └── entrypoint.prod.sh     # migrate → collectstatic → gunicorn (4 workers)
├── frontend/
│   ├── Dockerfile.dev         # Deps installed; source mounted; next dev
│   ├── Dockerfile.test        # Source baked in; runs vitest on start
│   ├── Dockerfile.staging     # Multi-stage node builder → nginx static server
│   └── Dockerfile.prod        # Multi-stage node builder → nginx static server
├── nginx/
│   ├── dev.conf               # Proxy → backend:8000 + frontend:3000, HMR WS
│   ├── test.conf              # Proxy → backend-test:8000 + frontend-test:3000
│   └── frontend-static.conf   # Serves Next.js static export (staging / prod container)
├── docker-compose.dev.yml
├── docker-compose.test.yml
├── docker-compose.staging.yml
└── docker-compose.prod.yml
```

## Observability

| Tool       | dev | test | staging | prod | Notes                                        |
| ---------- | --- | ---- | ------- | ---- | -------------------------------------------- |
| File logs  | ✅  | ✅   | ❌      | ❌   | Written to `code/src/logs/` (gitignored)     |
| Glitchtip  | ❌  | ❌   | ✅      | ✅   | Exception tracking via Sentry SDK            |
| Loki       | ❌  | ❌   | ✅      | ✅   | Promtail on server captures Docker stdout    |
| Prometheus | ❌  | ❌   | ✅      | ✅   | Scraped from `/metrics/` (django-prometheus) |
| Grafana    | ❌  | ❌   | ✅      | ✅   | Dashboards over Loki + Prometheus            |

Staging and prod containers log structured JSON to stdout — no log volumes, no file handlers.
Promtail is configured on the server (outside Docker) and ships logs to Loki automatically.

Full configuration guide: `code/docs/LOGGING.md`

## Health check

The backend exposes `GET /health/` — required by the `HEALTHCHECK` in staging/prod Dockerfiles
and by the server's Nginx upstream health checks. Wire this up in `config/urls.py`.

## Cross-references

- `code/src/backend/CONTEXT.md` — Django app structure and settings
- `code/src/frontend/CONTEXT.md` — Next.js project structure
- `how-to/workflows/01-first-time-setup/` — spinning up the dev stack for the first time
- `how-to/workflows/02-daily-development/` — daily Docker Compose commands
