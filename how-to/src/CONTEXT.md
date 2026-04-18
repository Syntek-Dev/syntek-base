# how-to/src — Contributing & Code-Quality Guide

## Directory Tree

```text
how-to/src/
└── CONTEXT.md               ← this file (contributing guide, testing, code quality, git hooks)
```

---

## Contributing & Code-Quality Guide

This directory contains all three deployable layers of the Syntek Studio website.

| Directory   | Contents                                           |
| ----------- | -------------------------------------------------- |
| `backend/`  | Django 6.0.4 + Strawberry GraphQL API              |
| `frontend/` | Next.js 16.2.4 App Router site                     |
| `docker/`   | Dockerfiles and Compose files for all environments |

Read the relevant sub-layer CONTEXT.md before touching any code:

- `backend/CONTEXT.md` — Django apps, GraphQL schema, service layer rules
- `frontend/CONTEXT.md` — Next.js pages, components, Apollo Client, code generation
- `docker/CONTEXT.md` — images, environments, Nginx proxy

---

## Contributing

**All development runs inside Docker.** Never execute `python`, `pytest`, `pnpm`, `next`, or
`npm` directly on your host machine.

```bash
# Backend commands
docker compose exec backend python manage.py <command>
docker compose exec backend pytest

# Frontend commands
docker compose exec frontend pnpm <command>
```

### Branching

Branches must follow the format `us###/short-description` where `###` is the zero-padded
user story number. Full branch and promotion rules: `project-management/docs/GIT-GUIDE.md`.

### Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <description>

[optional body]
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `perf`, `style`

**Scopes:** `backend`, `frontend`, `graphql`, `db`, `ci`, `docs`, `infra`

---

## Licensing

This codebase is proprietary. All rights reserved by Syntek Studio. You must have explicit
written permission from Syntek Studio before using, copying, or distributing any part of this
source code. Do not include third-party dependencies whose licences are incompatible with
commercial proprietary use (e.g. GPL/AGPL) without prior written approval.

---

## Testing

### Philosophy

Write a failing test first, then write the minimum implementation to make it pass (TDD). No
stubs to get coverage green — tests must cover real behaviour.

### Backend (pytest + pytest-django)

Tests live alongside the code they test, inside each Django app:

```text
apps/
└── users/
    ├── models.py
    ├── services.py
    └── tests/
        ├── test_models.py
        └── test_services.py
```

Run tests inside the container:

```bash
docker compose exec backend pytest               # full suite
docker compose exec backend pytest apps/users/   # single app
docker compose exec backend pytest -k "test_login"  # filter by name
```

Pytest is configured in `pyproject.toml` (`[tool.pytest.ini_options]`). It stops on first
failure (`-x`) and uses `config.settings.local` as the Django settings module.

**Coverage floors:**

| Module type          | Minimum |
| -------------------- | ------- |
| All modules          | 75%     |
| Auth-related modules | 90%     |

### Frontend (Vitest + React Testing Library)

Tests live co-located with the component or module they test:

```text
src/
└── components/
    └── Button/
        ├── Button.tsx
        └── Button.test.tsx
```

Run tests inside the container:

```bash
docker compose exec frontend pnpm test          # watch mode
docker compose exec frontend pnpm test --run    # single pass (CI)
```

**Coverage floor:** 70% minimum across all frontend modules.

### What to test

| Layer             | Test target                                     |
| ----------------- | ----------------------------------------------- |
| Django services   | Business logic, edge cases, error paths         |
| GraphQL resolvers | Permission checks, correct return shape         |
| React components  | Render output, user interactions, accessibility |
| Utility functions | Pure logic — full branch coverage expected      |

Do not test implementation details (internal state, private methods). Test observable behaviour.

---

## Code Quality

Pre-commit hooks are managed by [Lefthook](https://github.com/evilmartians/lefthook) and run
automatically on `git commit`. They **must pass before a commit is accepted**.

Install hooks after cloning (requires Node and pnpm on the host, or run inside the container):

```bash
pnpm install   # also runs `lefthook install` via the prepare script
```

### Backend — Python

| Tool          | Purpose                           | Run manually           |
| ------------- | --------------------------------- | ---------------------- |
| Ruff (lint)   | Style, imports, security, bugs    | `uv run ruff check .`  |
| Ruff (format) | Auto-formatter (Black-compatible) | `uv run ruff format .` |
| basedpyright  | Static type checking              | `uv run basedpyright`  |

Configuration lives in `pyproject.toml` (`[tool.ruff]`, `[tool.basedpyright]`).

Key rules:

- Line length: **100 characters**
- Import order: `future` → `stdlib` → `django` → `third-party` → `first-party` → `local`
- `except (A, B):` syntax, never `except A, B:`
- All type annotations required — basedpyright runs in `standard` mode

### Frontend — TypeScript / CSS

| Tool       | Purpose                              | Run manually                                     |
| ---------- | ------------------------------------ | ------------------------------------------------ |
| ESLint     | TypeScript and JavaScript linting    | `pnpm lint:js`                                   |
| Prettier   | Formatting (TS, CSS, JSON, MD, YAML) | `pnpm format:check`                              |
| TypeScript | Type checking                        | `docker compose exec frontend pnpm tsc --noEmit` |

Configuration files:

- ESLint: `eslint.config.mjs` (repo root)
- Prettier: `.prettierrc` (repo root) — `printWidth: 100`, `singleQuote: false`, `semi: true`
- TypeScript: `code/src/frontend/tsconfig.json`

The `code/src/frontend/src/graphql/generated/` directory is excluded from all linting — never
edit generated files by hand.

### Markdown

```bash
pnpm lint:md   # markdownlint-cli2 across all .md files
```

Configuration: `.markdownlint-cli2.jsonc` (repo root). Every fenced code block must declare
its language — a bare ` ``` ` is a lint error (MD040).

---

## Before You Commit

```bash
# Backend
uv run ruff check .
uv run ruff format --check .
uv run basedpyright

# Frontend
pnpm lint:js
pnpm format:check

# Markdown
pnpm lint:md
```

All checks must be clean. The pre-commit hook runs these automatically, but running them
manually first gives faster feedback.

## Before You Push

Run the full test suite:

```bash
docker compose exec backend pytest
docker compose exec frontend pnpm test --run
```

Both must pass with no failures before pushing to any branch.
