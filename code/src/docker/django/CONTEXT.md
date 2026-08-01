# code/src/docker/django — Application Container

The Dockerfiles and entrypoints for the single application container. Python only — the
site is server-rendered by Django, so the image carries no Node toolchain.

## Files

| File                    | Environment | Notes                                                      |
| ----------------------- | ----------- | ---------------------------------------------------------- |
| `Dockerfile.dev`        | dev         | Deps only; source mounted as a volume at runtime           |
| `Dockerfile.test`       | test        | Source baked in; test dependency group installed           |
| `Dockerfile.staging`    | staging     | Multi-stage; non-root user                                 |
| `Dockerfile.prod`       | prod        | Multi-stage; non-root user                                 |
| `entrypoint.dev.sh`     | dev         | migrate → Uvicorn `--reload`                               |
| `entrypoint.test.sh`    | test        | migrate → collectstatic → Gunicorn (1 worker), or run `$@` |
| `entrypoint.staging.sh` | staging     | migrate → collectstatic → Gunicorn + Uvicorn workers       |
| `entrypoint.prod.sh`    | prod        | migrate → collectstatic → Gunicorn + Uvicorn workers       |

## Base image and dependencies

`python:3.14-slim`, with dependencies installed by `uv` from the root `pyproject.toml` and
`uv.lock`. The build context is the **project root** (`context: ../../..`), so both files
are reachable; paths inside the Dockerfiles are therefore repo-root-relative.

`uv.lock` is **not shipped by the base template** — `setup.sh` generates it at instantiation
(see `how-to/src/TEMPLATE-TOKENS.md`). Every build here `COPY`s it, so a build attempted before
`setup.sh` has run fails on that `COPY`. Run `setup.sh` first, or `uv lock` by hand.

## Server per environment

- **dev** — Uvicorn directly with `--reload`, watching `.py` and `.html`. Uvicorn's
  watchfiles reloader handles inode-replacing editors, which Gunicorn's `--reload` with the
  Uvicorn worker does not do reliably.
- **test** — Gunicorn with a single Uvicorn worker. The container stays up so tests run via
  `docker compose exec django-test pytest …`; passing a command instead runs it and exits.
- **staging / prod** — Gunicorn with Uvicorn workers; count and limits tuned by
  `GUNICORN_WORKERS`, `GUNICORN_TIMEOUT`, `GUNICORN_MAX_REQUESTS`.

Every entrypoint runs migrations first, then honours a passed command if there is one —
the hook that lets a future worker or one-off task container reuse the same image.

## Static files

`collectstatic` runs in test, staging, and production. It is deliberately skipped in dev,
where Django serves static from the finders so edits appear without a rebuild.

## Cross-references

- `code/src/docker/CONTEXT.md` — the environments these images run in
- `code/src/django/CONTEXT.md` — the Django project itself
