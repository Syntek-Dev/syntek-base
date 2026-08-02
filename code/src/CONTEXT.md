# code/src — Source Root

All deployable source code lives here. The **web surface** is server-rendered by Django
(`django/`) — every page is a template and there is no client-side build behind it. The
API layer is Django Ninja (JSON at `/api/`, OpenAPI at `/api/docs`), serving machine
clients only. A project may also carry a second, **optional** surface — the React Native
mobile app at `mobile/` — which is a separate deployable, not a build step for the pages.

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
├── mobile/                   ← MOBILE-ONLY — the Expo React Native app (absent unless opted in)
│   ├── app/                  ← expo-router routes (routes only — tests live in __tests__/)
│   ├── __tests__/            ← jest-expo + React Native Testing Library
│   └── CONTEXT.md            ← the mobile surface: layout, scripts, versioning
├── docker/                   ← Dockerfiles and Compose files for all environments
│   └── CONTEXT.md            ← images, environments, Nginx proxy config
├── scripts/                  ← shell scripts for all development operations
│   ├── _lib/                 ← shared shell helpers (e.g. worktree-detect.sh)
│   ├── audits/               ← codebase health audits (cloc, stub detection)
│   ├── database/             ← database management (migrate, backup, restore, shell)
│   ├── deployment/           ← deployment scripts
│   ├── development/          ← dev stack lifecycle (server, shell, logs)
│   ├── mobile/               ← MOBILE-ONLY — Metro, lint, typecheck, test, bundle (host)
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
| `mobile/`                   | **Mobile-only.** The Expo React Native app — one route at baseline. Absent unless the project opted in                                        | `mobile/CONTEXT.md`                   |
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

**The agent-facing counterpart** — a FastMCP tool server at `/mcp/`, for LLM clients that must
carry out this project's domain operations — is likewise designed and not built. `fastmcp` is
not even a declared dependency; it sits in the "deliberately NOT declared" register in the root
`pyproject.toml` with its trigger condition. When it is built, it is a **peer adapter over the
same service layer**, not a layer above the API: `apps/<name>/mcp_tools.py` beside
`apps/<name>/api.py`, both delegating to `apps/<name>/services.py`, neither calling the other.
That second adapter is what makes the service layer a real seam rather than a hypothetical one.
See `code/docs/MCP-SERVER.md`.

## Surfaces

**Surface** is load-bearing vocabulary here: a _surface_ is one delivery target with its own
runtime, toolchain and release cycle. This repository has at most two, and every doctrine
statement about builds, bundlers, TypeScript or rendering is scoped to one of them.

| Surface    | Lives in  | Runtime                                       | Present                      |
| ---------- | --------- | --------------------------------------------- | ---------------------------- |
| **Web**    | `django/` | Django ASGI — server-rendered pages + `/api/` | Always                       |
| **Mobile** | `mobile/` | React Native (Expo) on a device               | Only if the project opted in |

The two are **peers, not layers**. The mobile app consumes the same Django Ninja API a
third-party client would; it never renders a Django page and Django never bundles it. That is
why narrowing a rule to "the web surface" narrows its _scope_ without weakening its _force_.

## No client-side build on the web surface

There is no JavaScript SPA, no bundler, and no client-side framework. Every page — public,
portal, and admin alike — is server-rendered from `django/templates/` with django-components,
enhanced by HTMX for server operations and Alpine for local interactivity. Neither the templates
nor the components exist at baseline; the directories are empty.

The only JavaScript in the delivery path is the versioned HTMX and Alpine vendor scripts plus any
per-page static file. Introducing a bundler is a stack change, argued in an ADR — see
`code/docs/RENDERING.md`. A mobile surface is **not** that change: it ships no JavaScript to the
browser and adds no step between editing a template and seeing it.

## Where the mobile surface sits, and why

`mobile/` is a sibling of `django/` rather than a fifth root layer or a `code/src/apps/mobile/`
nesting. Three reasons, in order of weight:

- **"All deployable source lives in `code/src/`" stays true.** A top-level `mobile/` layer would
  falsify that and this file's opening line, fragment the coding standards into two parallel
  trees, and roughly double the governance surface under `.claude/`.
- **"Apps" already means Django apps** — `django/apps/`, `new-django-app.sh`, `apps.marketing`,
  and six app-name template tokens. Adopting Expo's `apps/` monorepo convention would make the
  word ambiguous in every document, bought for a second client that may never exist.
- **One `CONTEXT.md`/`CLAUDE.md` pair slots into the existing chain**, and mobile standards live
  beside web standards in `code/docs/` so the two cannot drift into separate doctrines.

The cost, accepted knowingly: the workspace glob in `pnpm-workspace.yaml` is implicit, so any
future directory here carrying a `package.json` joins the pnpm workspace without anyone declaring
it. `code/src/` also now holds two languages' source trees, so route by sub-layer before working.

## Cross-references

- `code/CONTEXT.md` — coding standards, testing, security, and API design guides
- `how-to/src/CONTEXT.md` — contributing guide, linting/formatting/typechecking, test commands
