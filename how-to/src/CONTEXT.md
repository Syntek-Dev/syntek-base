# how-to/src — Contributing & Code-Quality Guide

## Directory Tree

```text
how-to/src/
├── CONTEXT.md                   ← this file
├── BRANCH-GUIDE.md              ← branch naming and promotion flow
├── CLAUDE-MULTILAYER.md         ← using Claude Code with the three-layer structure
├── CODE-REVIEW.md               ← reviewer checklist and feedback standards
├── COMMIT-GUIDE.md              ← Conventional Commits format and rules
├── CUSTOMISING-TEMPLATE.md      ← adapting syntek-base as your own project
├── ENV-SETUP.md                 ← environment variable reference
├── GETTING-STARTED.md           ← first steps — clone, configure, run
├── ISSUE-REPORTING.md           ← bug reports and feature requests
└── PR-GUIDE.md                  ← opening, reviewing, and merging pull requests
```

---

## Contributing & Code-Quality Guide

This directory contains contributor-facing guides for the project. Use these alongside the
step-by-step workflows in `how-to/workflows/` and the operational reference in `how-to/docs/`.

---

## Contributing

**All development runs inside Docker.** Use the project scripts — never execute `python`,
`pytest`, `pnpm`, `next`, or `npm` directly on the host machine.

```bash
# Start the dev stack
./code/src/scripts/development/server.sh up

# Run all tests
./code/src/scripts/tests/all.sh

# Lint, format, and type-check
./code/src/scripts/syntax/lint.sh
./code/src/scripts/syntax/check.sh
```

### Branching

Branches follow the format `us###/short-description`. See [BRANCH-GUIDE.md](BRANCH-GUIDE.md)
for the full naming rules and promotion flow.

### Commit messages

Follow Conventional Commits. See [COMMIT-GUIDE.md](COMMIT-GUIDE.md) for the full format,
type and scope reference, and examples.

---

## Licensing

This project is released under the [MIT Licence](../../LICENSE). You are free to use, copy,
modify, merge, publish, distribute, sublicense, and sell copies of the software without
restriction. Third-party dependencies bundled in this template carry MIT, Apache 2.0, or ISC
licences. GPL/AGPL dependencies require written approval before inclusion.

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
