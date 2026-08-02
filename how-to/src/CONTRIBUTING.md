# Contributing & Code Quality — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

The contributing standards, testing requirements, and code-quality rules that apply across this
codebase.

> Changing the **syntek-base template** this project was generated from is a different thing —
> see that repository's own `CONTRIBUTING.md`.

---

## Contributing

**All development runs inside Docker.** Never execute `python`, `pytest`, `pnpm` or `npm` directly
on your host machine — every operation has a script in `code/src/scripts/`.

```bash
bash code/src/scripts/tests/backend.sh     # the full test suite
bash code/src/scripts/development/server.sh up
```

There is one test suite. Services, Django Ninja endpoints, views, templates, django-components and
HTMX partials all run under pytest — there is no separate client-side runner, because there is no
client bundle.

### Branching

| Prefix               | For                                        | Example                 |
| -------------------- | ------------------------------------------ | ----------------------- |
| `us###/<short-desc>` | work scoped to a user story                | `us015/homepage-layout` |
| `pm/<short-desc>`    | project management, process, documentation | `pm/wireframes-figma`   |

Full branch and promotion rules: `project-management/docs/GIT-GUIDE.md`.

### Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <description>

[optional body]
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `perf`, `style`
**Scopes:** `backend`, `frontend`, `api`, `db`, `ci`, `docs`, `infra`

---

## Dev user accounts

The development database ships with two pre-seeded accounts created by `reset.sh --seed`.
Credentials live in `code/src/docker/.env.dev` (gitignored).

| Account    | Django flag               | Purpose                                                 |
| ---------- | ------------------------- | ------------------------------------------------------- |
| Superuser  | `is_superuser + is_staff` | Full admin access; all module permissions               |
| Staff user | `is_staff` only           | Verify ABAC permission boundaries in dev/manual testing |

```bash
bash code/src/scripts/database/reset.sh --seed
```

Seeding is idempotent — existing accounts are skipped, not duplicated.

One-off accounts with custom credentials:

```bash
bash code/src/scripts/database/manageusers.sh create-superuser
bash code/src/scripts/database/manageusers.sh create-staff --email you@example.com --username you
```

---

## Licensing

This project is licensed **<%LICENCE%>**, held by <%ORG_NAME%>. The `LICENSE` file at the
repository root is authoritative; this section is a summary.

Do not add a third-party dependency whose licence is incompatible with that choice. Where
<%LICENCE%> is proprietary or otherwise commercial, that rules out GPL/AGPL without prior written
approval — MIT, Apache 2.0 and ISC are safe.

> The syntek-base template this project was generated from is MIT licensed and imposes no
> obligation on this codebase. The licence above is this project's own, and unrelated.

---

## Testing

### Philosophy

Write a failing test first, then the minimum implementation that makes it pass. **No stubs written
to make coverage green** — the stub audit catches them and they fail CI.

### Where tests live

Beside the code they cover, inside each Django app:

```text
apps/
└── <%IDENTITY_APP%>/
    ├── models.py
    ├── services.py
    └── tests/
        ├── test_models.py
        └── test_services.py
```

### Running them

```bash
bash code/src/scripts/tests/backend.sh                     # full suite
bash code/src/scripts/tests/backend.sh apps/<%IDENTITY_APP%>/   # one app
bash code/src/scripts/tests/backend.sh -k "test_login"     # filter by name
bash code/src/scripts/tests/all.sh --coverage              # enforce the floor
bash code/src/scripts/tests/api.sh                         # Bruno HTTP-layer tests
```

pytest is configured in `pyproject.toml` (`[tool.pytest.ini_options]`): it stops on first failure
(`-x`) and uses `config.settings.local` as the settings module.

### Coverage floors

| Module type          | Minimum |
| -------------------- | ------- |
| All modules          | 75 %    |
| Auth-related modules | 90 %    |

### What to test

| Layer                      | Test target                                           |
| -------------------------- | ----------------------------------------------------- |
| Django services            | Business logic, edge cases, error paths               |
| Django Ninja API endpoints | Permission checks, correct return shape               |
| Django views / templates   | Status, template used, rendered content, query counts |
| django-components          | Rendered markup and its accessible surface            |
| HTMX partials              | Fragment returned, no page chrome, response headers   |
| Utility functions          | Pure logic — full branch coverage expected            |

Test observable behaviour, not implementation details. Patterns for the template layer:
`code/docs/testing/FRONTEND-TESTING.md`.

---

## Code quality

Pre-commit hooks are managed by [Lefthook](https://github.com/evilmartians/lefthook) and run
automatically on `git commit`. They **must pass before a commit is accepted** — do not use
`--no-verify`.

Hooks are installed by `bash install.sh`.

### Python

| Tool          | Purpose                          |
| ------------- | -------------------------------- |
| Ruff (lint)   | Style, imports, security, bugs   |
| Ruff (format) | Auto-formatter, Black-compatible |
| basedpyright  | Static type checking             |

Configuration lives in `pyproject.toml` (`[tool.ruff]`, `[tool.basedpyright]`). Key rules:

- Line length **100 characters**
- Import order: `future` → `stdlib` → `django` → `third-party` → `first-party` → `local`
- `except (A, B):`, never `except A, B:`
- All type annotations required — basedpyright runs in `standard` mode

### CSS and Markdown

| Tool            | Enforces                                         |
| --------------- | ------------------------------------------------ |
| Prettier        | Formatting for CSS, JSON, Markdown, YAML         |
| markdownlint    | Markdown, including fenced-language (MD040)      |
| `css-tokens`    | Every `var(--token)` resolves in the token layer |
| `css-gradients` | No inline gradients outside the tokens           |

There is no TypeScript and no client bundle, so there is nothing for a JS type-checker to check.
Configuration: `.prettierrc` (`printWidth: 100`) and `.markdownlint-cli2.jsonc`, both at the root.

---

## Before you commit

```bash
bash code/src/scripts/syntax/format.sh     # dry run; --fix to apply
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh      # basedpyright
```

All three support `--file-type`, `--path`, `--output` and `--quiet`.

The pre-commit hook runs these anyway, but running them first gives faster feedback than a
rejected commit.

## Before you push

```bash
bash code/src/scripts/tests/backend.sh
bash code/src/scripts/audits/css-tokens.sh
bash code/src/scripts/audits/stubs.sh
```

The suite must pass with no failures before pushing to any branch.

## Before you raise a PR

The `pre-pr-check.sh` hook fires on `gh pr create` and runs eight gates — format, lint, typecheck,
tests, security, stubs, cloc, lockfiles — blocking the PR rather than letting CI find it later.

The **documentation hard gate** must also be satisfied: directory trees updated, new directories
carrying both `CONTEXT.md` and `CLAUDE.md`, implementation records written, `GAPS.md` and
`DEFERRED.md` current, and the code-review-graph refreshed. See
`project-management/workflows/19-implementation-documentation/`.
