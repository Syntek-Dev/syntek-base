# Commit Guide — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Format

This project follows [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <Description> - <Summary>

<Body — explain why, not what>

Files Changed:
- path/to/changed/file.py

Still to do:
- any remaining tasks

Version: <old> → <new>
```

The subject line must be under 72 characters. Use imperative mood: "Add feature" not
"Added feature". The body explains _why_ the change was made, not _what_ it does.

---

## Types

| Type       | When to use                                         |
| ---------- | --------------------------------------------------- |
| `feat`     | New feature or page                                 |
| `fix`      | Bug fix                                             |
| `refactor` | Code change that is neither a fix nor a new feature |
| `test`     | Adding or updating tests                            |
| `docs`     | Documentation only                                  |
| `chore`    | Tooling, config, dependencies, version bumps        |
| `ci`       | CI/CD workflow changes                              |
| `perf`     | Performance improvement                             |
| `style`    | Formatting only — no logic change                   |

---

## Scopes

| Scope      | Meaning                              |
| ---------- | ------------------------------------ |
| `backend`  | Django backend changes               |
| `frontend` | Next.js frontend changes             |
| `mobile`   | Expo React Native app changes        |
| `graphql`  | Strawberry schema or Apollo client   |
| `db`       | Django migrations or schema changes  |
| `ci`       | CI workflow files                    |
| `docs`     | Documentation files                  |
| `infra`    | Docker Compose or environment config |
| `shared`   | Shared components or utilities       |

---

## Examples

```text
feat(auth): Add JWT refresh token rotation - Implement sliding session

Tokens now rotate on every request rather than only at expiry. This
closes the window for token theft after a session hijack.

Files Changed:
- code/src/backend/apps/users/services/auth.py
- code/src/backend/apps/users/tests/test_auth.py

Still to do:
- Revocation list cleanup job (see US-019)

Version: 0.1.0 → 0.2.0
```

```text
fix(graphql): Correct IDOR check on portfolio query - Verify ownership

The resolver was checking the portfolio ID existed but not that it
belonged to the requesting user. Anyone authenticated could read
any portfolio.

Files Changed:
- code/src/backend/apps/portfolio/resolvers.py
- code/src/backend/apps/portfolio/tests/test_resolvers.py
```

```text
docs(ci): Update GitHub Actions workflow to use test scripts

Replaces raw docker compose commands with the project test scripts
for consistency with the local development experience.

Files Changed:
- .github/workflows/test-backend.yml
```

---

## Rules

- **One logical change per commit.** Do not mix a bug fix and a refactor in the same commit.
- **Never use `--no-verify`** to skip pre-commit hooks. Fix the reported issue instead.
- Reference the story ID in the body where applicable: `Closes US-042`
- Lock files (`uv.lock`, `pnpm-lock.yaml`) should be committed alongside the dependency change
  that produced them — never in a separate chore commit.

---

## Breaking changes

For a breaking change, append a `!` after the type/scope and add a `BREAKING CHANGE:` footer:

```text
feat(graphql)!: Remove deprecated portfolio fields

BREAKING CHANGE: The `legacyTitle` and `legacySlug` fields have been
removed from the Portfolio type. Clients must migrate to `title` and
`slug` before upgrading.
```

---

## Pre-commit hooks

Hooks run automatically on `git commit` via Lefthook. All of the following must pass before the
commit is accepted:

| Hook           | Tool              | Files                                         |
| -------------- | ----------------- | --------------------------------------------- |
| `eslint`       | ESLint            | `.js`, `.ts`, `.tsx`, `.mjs`                  |
| `prettier`     | Prettier          | `.js`, `.ts`, `.json`, `.yaml`, `.css`, `.md` |
| `ruff-lint`    | ruff              | `.py`                                         |
| `ruff-format`  | ruff format       | `.py`                                         |
| `basedpyright` | basedpyright      | `.py`                                         |
| `markdownlint` | markdownlint-cli2 | `.md`                                         |

Run checks manually before committing:

```bash
./code/src/scripts/syntax/lint.sh
./code/src/scripts/syntax/check.sh
./code/src/scripts/syntax/format.sh
```
