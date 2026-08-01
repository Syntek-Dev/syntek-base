# how-to/src — Contributing & Code-Quality Guide

**Last Updated**: {{DATE}} | **Maintained By**: {{ORG_NAME}}

## Directory Tree

```text
how-to/src/
├── CONTEXT.md               ← this file (contributing guide, testing, code quality, git hooks)
├── TEMPLATE-TOKENS.md       ← base-template manifest: the {{…}}, what to fill, what stays fixed
├── NIXOS-SETUP.md           ← pointer stub → deploy repo runbooks + SERVER-ARCHITECTURE/
├── SCALE-ARCHITECTURE/      ← how the app scales: load profiles, readiness audit, sizing envelope (scale-planner snapshot)
└── SERVER-ARCHITECTURE/     ← what the server/edge must provide + assigned compute with buffer; feeds the NixOS deploy repo
```

---

## Contributing & Code-Quality Guide

This file documents the contributing standards, testing requirements, and code-quality rules that
apply across the entire `{{PROJECT_NAME}}` codebase.

---

## Contributing

**All development runs inside Docker.** Never execute `python`, `pytest`, `pnpm`, or `npm`
directly on your host machine.

```bash
# Backend — run tests
bash code/src/scripts/tests/backend.sh

# Frontend — run tests
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

**Scopes:** `backend`, `frontend`, `api`, `db`, `ci`, `docs`, `infra`

---

## Dev User Accounts

The development database ships with two pre-seeded accounts created by `reset.sh --seed`.
Credentials are stored in `code/src/docker/.env.dev` (gitignored).

| Account    | Django flag               | Purpose                                                 |
| ---------- | ------------------------- | ------------------------------------------------------- |
| Superuser  | `is_superuser + is_staff` | Full admin access; all module permissions               |
| Staff user | `is_staff` only           | Verify ABAC permission boundaries in dev/manual testing |

To seed accounts after a fresh reset:

```bash
bash code/src/scripts/database/reset.sh --seed
```

Accounts are idempotent — already-existing accounts are skipped, not duplicated.

To create a one-off account with custom credentials:

```bash
bash code/src/scripts/database/manageusers.sh create-superuser
bash code/src/scripts/database/manageusers.sh create-staff --email you@example.com --username you
```

---

## Licensing

This codebase is proprietary. All rights reserved by {{ORG_NAME}}. You must have explicit
written permission from {{ORG_NAME}} before using, copying, or distributing any part of this
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
bash code/src/scripts/tests/backend.sh                        # full suite
bash code/src/scripts/tests/backend.sh apps/users/            # single app
bash code/src/scripts/tests/backend.sh -k "test_login"        # filter by name
```

Pytest is configured in `pyproject.toml` (`[tool.pytest.ini_options]`). It stops on first
failure (`-x`) and uses `config.settings.local` as the Django settings module.

**Coverage floors:**

| Module type          | Minimum |
| -------------------- | ------- |
| All modules          | 75%     |
| Auth-related modules | 90%     |

### Templates, components, and HTMX partials

These are pytest tests too — there is no client-side runner. They live beside the app they
cover, in `code/src/django/apps/<app>/tests/`, and count towards the single coverage floor
above. Patterns: `code/docs/testing/FRONTEND-TESTING.md`.

```bash
bash code/src/scripts/tests/backend.sh code/src/django/apps/marketing/
```

### What to test

| Layer                      | Test target                                           |
| -------------------------- | ----------------------------------------------------- |
| Django services            | Business logic, edge cases, error paths               |
| Django Ninja API endpoints | Permission checks, correct return shape               |
| Django views / templates   | Status, template used, rendered content, query counts |
| django-components          | Rendered markup and its accessible surface            |
| HTMX partials              | Fragment returned, no page chrome, response headers   |
| Utility functions          | Pure logic — full branch coverage expected            |

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

### Frontend — CSS and Markdown

| Tool            | Purpose                                | Run manually                                                |
| --------------- | -------------------------------------- | ----------------------------------------------------------- |
| Prettier        | Formatting (CSS, JSON, MD, YAML)       | `bash code/src/scripts/syntax/format.sh --file-type css`    |
| markdownlint    | Markdown linting (MD040 fences)        | `bash code/src/scripts/syntax/lint.sh --file-type markdown` |
| `css-tokens`    | Every `var(--token)` resolves          | `bash code/src/scripts/audits/css-tokens.sh`                |
| `css-gradients` | No inline gradients outside the tokens | `bash code/src/scripts/audits/css-gradients.sh`             |

There is no TypeScript and no client bundle, so there is nothing for a JS type-checker to
check. Configuration files:

- Prettier: `.prettierrc` (repo root) — `printWidth: 100`, `singleQuote: false`, `semi: true`
- Markdown: `.markdownlint-cli2.jsonc`

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
bash code/src/scripts/tests/backend.sh
```

Both must pass with no failures before pushing to any branch.
