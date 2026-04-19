# Git Guide — project-name

**Last Updated**: 18/04/2026 **Version**: 0.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Branch Strategy

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

| Branch          | Purpose                                                                   |
| --------------- | ------------------------------------------------------------------------- |
| `us###/feature` | Feature work scoped to a single user story (e.g. `us001/homepage-layout`) |
| `testing`       | Dev team QA — CI + manual testing before merging to dev                   |
| `dev`           | Integration branch — all in-progress features merged here                 |
| `staging`       | Pre-production — acceptance tests run here                                |
| `main`          | Production-ready code — client-accepted releases only                     |

Branch names use the user story number prefix: `us###/<short-description>`.

---

## Before Every Commit

Run these commands before every commit — no exceptions.

### Step 1 — Backend lint

```bash
docker compose exec backend ruff check --fix .
docker compose exec backend ruff check .
```

### Step 2 — Frontend lint and type-check

```bash
docker compose exec frontend npm run lint
docker compose exec frontend npm run type-check
```

### Step 3 — Commit

Only commit once all linters exit cleanly.

---

## Before Every Push

Run the full test suite before pushing any branch:

```bash
# Backend
docker compose exec backend pytest

# Frontend
docker compose exec frontend npm test
```

Only push when all tests pass.

---

## Commit Message Format

```text
<type>(<scope>): <Description> - <Summarise>

<Body>

Files Changed:
- path/to/file

Still to do:
- task

Version: <old> → <new>
```

### Type values

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
| `style`    | Formatting only (no logic change)                   |

### Scope values

| Scope      | Meaning                              |
| ---------- | ------------------------------------ |
| `backend`  | Django backend changes               |
| `frontend` | Next.js frontend changes             |
| `graphql`  | Strawberry schema or Apollo client   |
| `db`       | Django migrations or schema changes  |
| `ci`       | CI workflow files                    |
| `docs`     | Documentation files                  |
| `infra`    | Docker Compose or environment config |

---

## PR Flow

All feature branches must travel the full promotion order. Never skip a stage.

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

| Merge step                  | Gate                                                       |
| --------------------------- | ---------------------------------------------------------- |
| `us###/feature` → `testing` | Tests pass locally; PR opened to `testing` only            |
| `testing` → `dev`           | CI passes on `testing`; QA sign-off                        |
| `dev` → `staging`           | CI passes on `dev`; lead sign-off; no regressions          |
| `staging` → `main`          | Staging sign-off; version bump and changelog entry present |

### Rules

- Feature branches always target `testing` — never `dev`, `staging`, or `main` directly
- A branch rejection at any stage goes back to the original `us###/feature` branch for fixes
