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
- **Sub-packages** — each deployable unit (currently just the `django` project
  bundle) has its own independent semver. Sub-package versions move only when that
  package's code changes — they are never bumped as a side-effect of a root project
  version bump.

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

| Path               | Package manifest             | Version files                                       |
| ------------------ | ---------------------------- | --------------------------------------------------- |
| `code/src/django/` | `pyproject.toml` (repo root) | `CHANGELOG.md`, `VERSION-HISTORY.md`, `RELEASES.md` |

### Files to update on every sub-package bump

| File                              | What to update                                                               |
| --------------------------------- | ---------------------------------------------------------------------------- |
| `package.json` / `pyproject.toml` | Update the `version` field                                                   |
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
