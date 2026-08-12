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

## The Public API — what a breaking change breaks

Semantic Versioning's first rule is an obligation, not a formality:

> Software using Semantic Versioning MUST declare a public API. This API could be declared in the
> code itself or exist strictly in documentation. However it is done, it SHOULD be precise and
> comprehensive.

Until that declaration exists, **MAJOR is undecidable** — "breaking change" has no referent, and
two reasonable people bump differently on the same diff. Declare it once, in writing, and every
later increment argument becomes a question of fact rather than of taste.

### <%PROJECT_NAME%>'s declaration

> **TBD — settle this before cutting `1.0.0`.** Replace this block with the real declaration.
> The table below is the usual answer for a product built on this stack, not an assumption about
> this one.

| Surface                                                                                | In or out | Why                                                                       |
| -------------------------------------------------------------------------------------- | --------- | ------------------------------------------------------------------------- |
| The Django Ninja `/api/` contract — routes, request and response schemas, status codes | **in**    | External callers depend on it and cannot see a change coming              |
| The database schema _as reached through that API_                                      | **in**    | A dropped or retyped field breaks a consumer as surely as a deleted route |
| Public page URLs that are linked or indexed                                            | **in**    | A moved URL breaks inbound links and search placement                     |
| The `/mcp/` tool surface, where wired                                                  | **in**    | An agent calling a renamed tool fails at runtime                          |
| Templates, components, CSS tokens, internal service signatures                         | **out**   | Internal — changing them cannot break a consumer                          |
| Management commands and the dev scripts                                                | **out**   | Operator tooling, versioned by the repository rather than depended upon   |

Two rules follow, and both are decidable **only** because that table exists:

- An **in-scope** surface changing incompatibly → **MAJOR**, whatever else the change touches.
- An **out-of-scope** surface changing → **MINOR or PATCH**, however large the diff.

Sub-packages declare their own. `code/src/mobile/` has no API callers, so its public surface is
the store release itself — which is part of why its track is independent.

---

## Version Increment Rules

| Type  | When                                                          | Example         |
| ----- | ------------------------------------------------------------- | --------------- |
| MAJOR | An incompatible change to a surface **declared public above** | `1.0.0 → 2.0.0` |
| MINOR | New pages, new features, backwards-compatible                 | `1.0.0 → 1.1.0` |
| PATCH | Bug fixes, copy changes, documentation updates                | `1.0.0 → 1.0.1` |

The same rules apply at both the root project level and sub-package level. How a commit _signals_
a breaking change — the `!` shorthand and the `BREAKING CHANGE:` footer — belongs to the commit
format: `project-management/docs/GIT-GUIDE.md`.

---

## Initial Development and `1.0.0`

| Rule                                                                                                                | What it means here                                                                                                                                                                                               |
| ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`0.y.z` is initial development.** Anything MAY change at any time; the public API SHOULD NOT be considered stable | A generated project starts at `0.1.0`. While the leading zero stands, an incompatible change is a MINOR bump — state that expectation to consumers rather than implying a stability that is not claimed          |
| **`1.0.0` defines the public API.** Every increment after it is decided against that API                            | Cut `1.0.0` when the first external consumer exists, or when the API is already being treated as stable in practice — whichever comes first. Shipping to production is not the trigger; **being depended on** is |

---

## Pre-release and Build Metadata

Both append to the normal version, and both have a strict grammar. Identifiers comprise only ASCII
alphanumerics and hyphens (`[0-9A-Za-z-]`), must not be empty, and numeric identifiers must not
carry leading zeroes.

| Form               | Separator                      | Example                                            | Effect on precedence                         |
| ------------------ | ------------------------------ | -------------------------------------------------- | -------------------------------------------- |
| **Pre-release**    | `-` after PATCH                | `1.0.0-alpha.1`                                    | **Lower** than the associated normal version |
| **Build metadata** | `+` after PATCH or pre-release | `1.0.0+20260812` · `1.0.0-alpha.1+exp.sha.5114f85` | **Ignored entirely**                         |

```text
1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-rc.1 < 1.0.0
```

A pre-release says the version is unstable and might not satisfy the compatibility its normal
version implies. Build metadata says **nothing at all** about compatibility — two versions
differing only in build metadata are the same version for every ordering decision, so never use it
to tell two releases apart.

---

## Precedence

How two versions order, which matters the moment anything resolves a range.

1. Compare MAJOR, then MINOR, then PATCH, **numerically**.
2. When those are equal, a version **with** a pre-release ranks **below** one without.
3. Compare pre-release identifiers left to right until one differs:
   - numeric identifiers compare numerically;
   - non-numeric identifiers compare in ASCII sort order;
   - **a numeric identifier always ranks below a non-numeric one**;
   - where all preceding identifiers are equal, the **larger set** of identifiers ranks higher.
4. **Build metadata is ignored.**

---

## Deprecation

Removal is a breaking change; the **surprise** is the avoidable part.

1. **Deprecate in a MINOR release** — update the documentation, and where the surface is code,
   warn on use. The behaviour still works.
2. **Leave it deprecated for at least one full minor release**, so a consumer upgrading one minor
   at a time reaches a version that both warns and works.
3. **Remove in the next MAJOR**, recorded in `CHANGELOG.md` under `Removed`.

Deprecating and removing in the same release is not a deprecation — it is a removal with a note.

---

## Recovering from a Wrong Release

A release that turns out to be incompatible is **not** fixed by retagging or rewriting history:
the old version is already resolved, cached, and depended upon somewhere.

| Situation                                        | Fix                                                                                                                               |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| Shipped an incompatible change as MINOR or PATCH | Release a **new MINOR that restores compatibility** as soon as it is found, then ship the incompatible change properly as a MAJOR |
| Shipped the wrong number, nothing else wrong     | Release the next correct version. Do not reuse or move the wrong one                                                              |
| Shipped a broken build under a correct number    | Release a PATCH. The broken version stays in the history                                                                          |

**Never delete or move a published tag.** The version that went out is a fact about the world.

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

**Only the root files above move on a root bump. Never a versioning document anywhere else in
the tree.** A sub-package's `CHANGELOG.md`, `VERSION-HISTORY.md` and `RELEASES.md` move only when
that sub-package itself changes, on its own track, in its own commit. Sweeping them along with a
root bump is the easy mistake: nothing fails, and the sub-package's history silently becomes a
mirror of the root's, which is precisely the information the two-tier scheme exists to keep apart.

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

### Your version history is yours

`VERSION`, `VERSION-HISTORY.md`, `CHANGELOG.md` and `RELEASES.md` at the root are **seeded once
at generation and never touched again by the template**. They arrive at `0.1.0` with a single
entry describing the scaffold, and everything after that is your project's own record.

The mechanism: the template ships them from a `.copier/` staging directory and moves them into
place with a post-generation task. Those tasks run on `copier copy` and never on `copier update`,
so a template update cannot overwrite your release history with the template's — the same
arrangement `README.md` uses, and for the same reason.

A corollary worth knowing: because updates never touch these four files, template improvements to
them never reach you either. That is the intended trade. They are yours from the moment the
project exists.
