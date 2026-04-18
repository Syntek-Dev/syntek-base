# code/src/docker/backend — Backend Dockerfiles & Entrypoints

One `Dockerfile.<env>` and one `entrypoint.<env>.sh` per environment.
Build context for all Dockerfiles is the **project root** — COPY paths are relative to it.

## Dockerfiles

| File                 | Base image         | Source       | Server                           |
| -------------------- | ------------------ | ------------ | -------------------------------- |
| `Dockerfile.dev`     | `python:3.14-slim` | volume mount | Gunicorn + Uvicorn, `--reload`   |
| `Dockerfile.test`    | `python:3.14-slim` | baked in     | Gunicorn + Uvicorn               |
| `Dockerfile.staging` | `python:3.14-slim` | baked in     | Gunicorn + Uvicorn (multi-stage) |
| `Dockerfile.prod`    | `python:3.14-slim` | baked in     | Gunicorn + Uvicorn (multi-stage) |

**Dev** installs dependencies only; the backend source at `code/src/backend/` is mounted
as a volume at runtime so Gunicorn's `--reload` picks up file changes immediately.

**Staging / Prod** use a two-stage build:

- Stage 1 (`builder`): installs Python deps via `uv sync --no-dev`
- Stage 2 (`runtime`): copies the venv and source; runs as non-root user `django` (UID 1001)

## Entrypoints

| File                    | What it does                                                                        |
| ----------------------- | ----------------------------------------------------------------------------------- |
| `entrypoint.dev.sh`     | `migrate` → Gunicorn + Uvicorn, 1 worker, `--reload`                                |
| `entrypoint.test.sh`    | `migrate` → Gunicorn + Uvicorn, 1 worker (server stays up; run `pytest` via `exec`) |
| `entrypoint.staging.sh` | `migrate` → `collectstatic` → Gunicorn + Uvicorn, 2 workers                         |
| `entrypoint.prod.sh`    | `migrate` → `collectstatic` → Gunicorn + Uvicorn, 4 workers                         |

All entrypoints `cd /workspace/code/src/backend` before any Django command.

## Tunable env vars (staging / prod)

| Variable                | Default | Description                        |
| ----------------------- | ------- | ---------------------------------- |
| `GUNICORN_WORKERS`      | 2 / 4   | Number of Uvicorn worker processes |
| `GUNICORN_TIMEOUT`      | 30      | Worker timeout in seconds          |
| `GUNICORN_MAX_REQUESTS` | 1000    | Requests per worker before recycle |

## Running tests (test environment)

```bash
# Bring the test stack up
docker compose -f code/src/docker/docker-compose.test.yml up -d

# Run the full backend test suite
docker compose -f code/src/docker/docker-compose.test.yml exec backend-test pytest

# Run frontend tests
docker compose -f code/src/docker/docker-compose.test.yml exec frontend-test pnpm run test
```

## Health check

Staging and prod Dockerfiles include a `HEALTHCHECK` against `GET /health/`.
Wire this endpoint up in `code/src/backend/config/urls.py` before deploying.

## Cross-references

- `code/src/docker/CONTEXT.md` — environment overview and image table
- `code/src/backend/CONTEXT.md` — Django app structure and settings modules
