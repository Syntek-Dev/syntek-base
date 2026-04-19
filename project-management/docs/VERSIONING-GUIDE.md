# Versioning Guide — project-name

**Last Updated**: 18/04/2026 **Version**: 0.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Strategy Overview

project-name uses a **single-track semver** strategy — the project as a whole is versioned.

---

## Version Increment Rules

| Type  | When                                              | Example         |
| ----- | ------------------------------------------------- | --------------- |
| MAJOR | Breaking changes to the public API or data schema | `1.0.0 → 2.0.0` |
| MINOR | New pages, new features, backwards-compatible     | `1.0.0 → 1.1.0` |
| PATCH | Bug fixes, copy changes, documentation updates    | `1.0.0 → 1.0.1` |

---

## Files to Update on Every Bump

All of the following must be updated. Missing any one leaves the project inconsistent.

| File                              | What to update                                                               |
| --------------------------------- | ---------------------------------------------------------------------------- |
| `VERSION`                         | Replace the plain semver string                                              |
| `VERSION-HISTORY.md`              | Add one summary row (date, version, one-line description)                    |
| `RELEASES.md`                     | Add a full release notes section for the new version                         |
| `CHANGELOG.md`                    | Add a detailed entry grouped by Added / Changed / Fixed / Removed / Security |
| `code/src/backend/pyproject.toml` | Update the `version` field in `[project]`                                    |
| `code/src/frontend/package.json`  | Update the `version` field                                                   |

---

## Tooling

Use `/syntek-dev-suite:version` to manage all version bumps.

```text
/syntek-dev-suite:version bump patch
/syntek-dev-suite:version bump minor
/syntek-dev-suite:version bump major
```

### Status check

```text
/syntek-dev-suite:version status
```

---

## Baseline

Project starts at `0.1.0`. Do not back-fill version history. Current branch is the starting point.
