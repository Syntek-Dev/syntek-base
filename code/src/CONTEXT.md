# code/src — Source Root

All deployable source code lives here. Every page is server-rendered by Django
(`django/`) — there is no client-side build. The API layer is Django Ninja
(JSON at `/api/`, OpenAPI at `/api/docs`), serving machine clients only.

## Directory Tree

```text
code/src/
├── CONTEXT.md                ← this file (source-root sub-layer map)
├── CLAUDE.md                 ← operating rules for the source root
├── django/                   ← the Django project — at baseline, no application code yet
│   ├── apps/                 ← Django apps (domain modules) — currently empty
│   ├── config/               ← settings/, urls.py, asgi.py, wsgi.py
│   ├── static/               ← static asset source (empty)
│   ├── templates/            ← project template directory (empty)
│   └── CONTEXT.md            ← stack, layout, entry points
├── docker/                   ← Dockerfiles and Compose files for all environments
│   └── CONTEXT.md            ← images, environments, Nginx proxy config
├── scripts/                  ← shell scripts for all development operations
│   ├── _lib/                 ← shared shell helpers (e.g. worktree-detect.sh)
│   ├── audits/               ← codebase health audits (cloc, stub detection)
│   ├── database/             ← database management (migrate, backup, restore, shell)
│   ├── deployment/           ← deployment scripts
│   ├── development/          ← dev stack lifecycle (server, shell, logs)
│   ├── reports/              ← generated audit/coverage reports (gitignored)
│   ├── syntax/               ← code quality (lint, type-check, format)
│   └── tests/                ← test suite runners (pytest, Bruno, playwright-python)
├── tests/                    ← API integration tests (Bruno collection)
│   └── api/
├── logs/                     ← runtime log files (dev/test only; all gitignored)
│   ├── .gitignore
│   └── .gitkeep
└── improvement-architecture/ ← gitignored HTML architecture-review reports (local history)
    ├── .gitignore
    └── .gitkeep
```

## Sub-layers

| Directory                   | Contents                                                                                                                                      | Read first                            |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| `django/`                   | The Django project — at **baseline**: an empty `apps/` package, the environment-split settings, and root URL routing. No application code yet | `django/CONTEXT.md`                   |
| `docker/`                   | Dockerfiles and Compose files for all environments                                                                                            | `docker/CONTEXT.md`                   |
| `scripts/`                  | Shell scripts for **every** development operation — the only sanctioned way to run dev, test, db, and syntax tooling                          | `scripts/CONTEXT.md`                  |
| `tests/`                    | API integration tests (Bruno collection)                                                                                                      | `tests/CONTEXT.md`                    |
| `logs/`                     | Runtime log files (dev/test only; all gitignored)                                                                                             | `logs/CONTEXT.md`                     |
| `improvement-architecture/` | Gitignored HTML architecture-review reports from `/improve-codebase-architecture` (local history)                                             | `improvement-architecture/CONTEXT.md` |

Always read the relevant sub-layer `CONTEXT.md` before touching any code in that directory.

## API layer

None yet. Django Ninja is declared in `pyproject.toml` but unwired — the intended shape is
a single `NinjaAPI` with router modules (`api.py`) per app, Ninja Schema (Pydantic)
request/response models, and a named permission check on every endpoint. Build it when the
first endpoint is needed; see `code/docs/API-DESIGN.md`.

## No client-side frontend

There is no JavaScript SPA, no bundler, and no client-side framework. Every page — public,
portal, and admin alike — is server-rendered from `django/templates/` with django-components,
enhanced by HTMX for server operations and Alpine for local interactivity. Neither the templates
nor the components exist at baseline; the directories are empty.

The only JavaScript in the delivery path is the versioned HTMX and Alpine vendor scripts plus any
per-page static file. Introducing a bundler is a stack change, argued in an ADR — see
`code/docs/RENDERING.md`.

## Cross-references

- `code/CONTEXT.md` — coding standards, testing, security, and API design guides
- `how-to/src/CONTEXT.md` — contributing guide, linting/formatting/typechecking, test commands
