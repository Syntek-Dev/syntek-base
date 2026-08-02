---
type: guide
agent: version
skills: [global-workflow]
model: opus
---

# Versioning Guide — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Semantic versioning strategy, version bumping process, changelog and release tracking
**MCP Servers:** code-review-graph (version impact analysis)

---

## Strategy Overview

<%PROJECT_NAME%> uses a **two-tier versioning strategy**:

- **Root project** — single-track semver covering the entire monorepo (documentation,
  infrastructure, PM artefacts, and cross-cutting changes). Tracked by `VERSION`,
  `CHANGELOG.md`, `VERSION-HISTORY.md`, and `RELEASES.md` at the project root.
- **Sub-packages** — each deployable unit has its own independent semver: the `django`
  project bundle always, and the `mobile` application in a project that opted into the
  mobile surface. Sub-package versions move only when that package's code changes — they
  are never bumped as a side-effect of a root project version bump.

For the mobile application the independence is not merely tidy, it is forced: app-store
versions must increase monotonically, so coupling to the root track would produce either
spurious store releases or gaps in the version sequence.

---

## Version Increment Rules

| Type  | When                                              | Example         |
| ----- | ------------------------------------------------- | --------------- |
| MAJOR | Breaking changes to the public API or data schema | `1.0.0 → 2.0.0` |
| MINOR | New pages, new features, backwards-compatible     | `1.0.0 → 1.1.0` |
| PATCH | Bug fixes, copy changes, documentation updates    | `1.0.0 → 1.0.1` |

The same rules apply at both the root project level and sub-package level.

---

## Root Project — Files to Update on Every Bump

All of the following must be updated. Missing any one leaves the project inconsistent.

| File                 | What to update                                                               |
| -------------------- | ---------------------------------------------------------------------------- |
| `VERSION`            | Replace the plain semver string                                              |
| `VERSION-HISTORY.md` | Add one summary row (date, version, one-line description)                    |
| `RELEASES.md`        | Add a full release notes section for the new version                         |
| `CHANGELOG.md`       | Add a detailed entry grouped by Added / Changed / Fixed / Removed / Security |
| `README.md`          | Update the version badge and footer line                                     |
| `CONTEXT.md`         | Update the version reference in the repo state line                          |

Do **not** update sub-package version files as part of a root bump — they are independent.

---

## Sub-Package Versioning

### Current sub-packages

| Path               | Package manifest                | Version files                                       |
| ------------------ | ------------------------------- | --------------------------------------------------- |
| `code/src/django/` | `pyproject.toml` (repo root)    | `CHANGELOG.md`, `VERSION-HISTORY.md`, `RELEASES.md` |
| `code/src/mobile/` | `package.json` **+ `app.json`** | `CHANGELOG.md`, `VERSION-HISTORY.md`, `RELEASES.md` |

`code/src/mobile/` is **mobile-only** — absent from a web-only project. Read its row as "not
present here" in that case.

### Mobile: two files, one number

The mobile application is the one package whose version lives in **two** manifests. Both must
carry the identical string and move in the same edit:

| File                           | Field          | Consumed by                              |
| ------------------------------ | -------------- | ---------------------------------------- |
| `code/src/mobile/package.json` | `version`      | the pnpm workspace and the toolchain     |
| `code/src/mobile/app.json`     | `expo.version` | Expo — the version shipped to the stores |

Bumping only `package.json` is the easy mistake: nothing fails, the tests still pass, and the
build still succeeds — but the store release goes out under the previous version number. Treat a
disagreement between the two as a bug.

### Files to update on every sub-package bump

| File                              | What to update                                                               |
| --------------------------------- | ---------------------------------------------------------------------------- |
| `package.json` / `pyproject.toml` | Update the `version` field — **plus `app.json` for mobile** (above)          |
| `CHANGELOG.md`                    | Add a detailed entry grouped by Added / Changed / Fixed / Removed / Security |
| `VERSION-HISTORY.md`              | Add one summary row (date, version, one-line description)                    |
| `RELEASES.md`                     | Add a full release notes section for the new version                         |

### Rule: every package manifest gets version files

Any time a new `package.json` or `pyproject.toml` is added anywhere in this repository,
the following three files must be created alongside it in the same directory before the
first commit:

```text
CHANGELOG.md
VERSION-HISTORY.md
RELEASES.md
```

Start all three at `0.1.0`. Do not omit them — a package manifest without version files
has no audit trail.

---

## Tooling

Use `version` to manage all version bumps.

```text
version bump patch
version bump minor
version bump major
```

### Status check

```text
version status
```

---

## Baseline

Root project starts at `0.1.0`. Sub-packages start at `0.1.0` independently.
Do not back-fill version history. Current branch is the starting point.
