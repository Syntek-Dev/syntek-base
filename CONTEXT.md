# <%PROJECT_NAME%> — Project Overview

The entry point every session starts from: what this project is, how it is laid out, and where
each kind of work belongs. Read it before the layer you are heading into, because the layer
files assume the map below.

## What this project is

> <%PROJECT_DESCRIPTION%>

**Read that first, every session.** It is the only statement of what is being built and for
whom; every gate downstream — the feature map, the stories, the schema, the sizing envelope —
is judged against it. If it has drifted from what the project has become, correcting it is a
task in its own right, not a side-effect of some other change.

## How it is built

This is the source repository for `<%PROJECT_SLUG%>`, built as a **Django-only monolith**:
Django 6 + Django Ninja + PostgreSQL on the server, Django templates + django-components +
HTMX + Alpine + token-driven vanilla CSS on the client. **There is no separate frontend
application** — one deployable serves the API and the rendered pages.

Optional surfaces are added at generation and are absent unless the project asked for them: a
React Native **mobile** app under `code/src/mobile/`, a **Rust** workspace under
`code/src/rust/`, and a Slint **desktop** app inside it. Each is a separate deployable that
consumes this API; none of them changes the rule above for the web.

## Directory Tree

```text
<%PROJECT_SLUG%>/
├── .claude/                         ← Claude Code configuration — the authoritative rules
│   ├── CLAUDE.md                    ← global rules, routing, model selection, non-negotiables
│   ├── CONTEXT.md
│   ├── MEMORY.md                    ← project memory (feedback, patterns, project state)
│   ├── settings.json                ← project-level permissions, model, hooks
│   ├── hooks/                       ← pre-PR quality gates
│   ├── plugins/                     ← read-only inspection helpers a skill calls for context
│   └── skills/                      ← internalised stack, workflow, and document skills
├── .agents/                         ← vendored third-party skills (Cloudinary)
├── .github/                         ← CI workflows and the template-integrity scripts
│   └── workflows/                   ← CI: syntax, tests, audits, Claude gate, ClickUp sync
├── code/                            ← source code, coding standards, coding workflows
│   ├── CONTEXT.md                   ← code layer entry point
│   ├── CLAUDE.md
│   ├── REFERENCES.md
│   ├── docs/                        ← coding reference guides (architecture, security, testing)
│   ├── src/
│   │   ├── django/                  ← the Django project — backend and server-rendered frontend
│   │   ├── mobile/                  ← MOBILE-ONLY — the Expo / React Native app
│   │   ├── rust/                    ← RUST-ONLY — the Cargo workspace (PyO3, binaries, CLI)
│   │   │                              ← incl. crates/desktop/ — DESKTOP-ONLY Slint app
│   │   ├── docker/                  ← Dockerfiles and Compose files (dev/test/staging/prod)
│   │   ├── improvement-architecture/ ← /improve-codebase-architecture reports
│   │   ├── logs/                    ← runtime log files (dev/test; gitignored)
│   │   ├── scripts/                 ← shell scripts — ALL dev operations run through here
│   │   └── tests/                   ← API integration tests (Bruno collection)
│   └── workflows/                   ← step-by-step coding workflows (01–13)
├── how-to/                          ← setup, daily development, debugging, scaling
│   ├── CONTEXT.md                   ← how-to layer entry point
│   ├── CLAUDE.md
│   ├── REFERENCES.md
│   ├── docs/                        ← operational reference guides (CLI, tooling, worktrees)
│   ├── src/
│   │   ├── TEMPLATE-TOKENS.md       ← the token contract copier.yml implements
│   │   ├── TEMPLATE-GUIDE/          ← full guides for using this repo as a template
│   │   ├── NIXOS-SETUP.md           ← host provisioning guide
│   │   ├── SCALE-ARCHITECTURE/      ← sizing envelope snapshot (regenerated per project)
│   │   └── SERVER-ARCHITECTURE/     ← server/edge contract for the deploy repo
│   └── workflows/                   ← step-by-step operational workflows (01–09)
├── project-management/              ← stories, sprints, design, GDPR, security, releases
│   ├── CONTEXT.md                   ← PM layer entry point
│   ├── CLAUDE.md
│   ├── REFERENCES.md
│   ├── docs/                        ← PM reference guides (git, versioning, SEO, GDPR, QA)
│   ├── export/                      ← ClickUp sync artefacts and task map
│   ├── src/                         ← live PM artefacts (00-ASSETS … 22-INCIDENTS)
│   └── workflows/                   ← step-by-step PM workflows (01–23)
├── handoffs/                        ← session handoff documents (auto-compaction replacement)
├── questionnaires/                  ← /to-questionnaire — outbound discovery questionnaires
├── learning/                        ← /teach sandbox — throwaway learning workspace
├── research/                        ← /research notes — primary-source-cited
├── .copier/                         ← seed-once staging: the README, version state, blank
│                                      project memory and scale-planning map a generated
│                                      project starts from; moved into place and removed
│                                      at generation
├── .zed/                            ← Zed editor settings
├── CONTEXT.md                       ← this file
├── REFERENCES.md                    ← curated index of internal docs and external resources
├── README.md                        ← the public front door — what this template is and how to use it
├── DESIGN.md                        ← design entry point (standards, constraints, Figma)
├── GAPS.md                          ← active gaps, blockers, sprint dependencies
├── DEFERRED.md                      ← deferred-work register
├── CHANGELOG.md                     ← what changed in each release, newest first
├── THIRD-PARTY-NOTICES.md           ← licence notices for third-party work shipped here
├── LICENSE                          ← syntek-base's own licence — not rendered into a project
├── SECURITY.md                      ← how to report a vulnerability in syntek-base itself
├── CONTRIBUTING.md                  ← how to contribute to syntek-base itself
├── RELEASES.md                      ← the release notes behind each version
├── VERSION                          ← the single source of truth for the current version
├── VERSION-HISTORY.md               ← every version and the date it shipped
├── .copier-answers.yml              ← your generation answers — `copier update` needs it
├── copier.yml                       ← template contract — questions, delimiters, post-tasks
├── install.sh                       ← install the toolchain and dependencies
├── skills-lock.json                 ← installed Claude Code skills (versions and hashes)
├── lefthook.yml                     ← pre-commit hook runner config
├── package.json                     ← root workspace package (pnpm)
├── pnpm-lock.yaml                   ← the resolved JS tooling graph — committed, never hand-edited
├── uv.lock                          ← the resolved Python graph — committed, copier-excluded (see below)
├── pnpm-workspace.yaml              ← the pnpm workspace globs and audit ignore list
├── pyproject.toml                   ← Python tooling config and the django package manifest
├── eslint.config.mjs                ← ESLint config for the repo tooling (no client-side build)
├── .dockerignore                    ← what never enters a Docker build context
├── .editorconfig                    ← baseline editor settings shared across contributors
├── .gitattributes                   ← LF everywhere; the binary list — a CRLF checkout breaks the scripts
├── .gitignore                       ← what git never tracks
├── .markdownlint-cli2.jsonc         ← Markdown lint config
├── .mcp.json                        ← project MCP servers (code-review-graph, context7, mermaid)
├── .npmrc                           ← pnpm registry and install behaviour
├── .nvmrc                           ← Node.js version pin
├── .opengrep-version                ← Opengrep engine pin (audits/static-analysis.sh + its CI job)
├── .prettierignore                  ← what Prettier never formats
├── .prettierrc                      ← Prettier formatting rules
└── .python-version                  ← Python version pin
```

Note: `uv.lock` **is committed here** (16/08/2026), so the Django image builds in this
repository and its Python gates and suites run against a real dependency set. It pins
`syntek-base` itself, so `copier.yml` lists it in `_exclude` and it never travels: a generated
project would otherwise inherit a lock naming the template, fail `uv sync --frozen`, and hit a
conflict in a lockfile on every `copier update`. Your project's own lock is written by the
`uv lock` post-task at generation and committed with the initial commit.

## Layer Map

| Layer                           | Purpose                                                              |
| ------------------------------- | -------------------------------------------------------------------- |
| `code/`                         | Source code, coding standards, and the coding workflows              |
| `how-to/`                       | Setup, daily development, debugging, scaling, template instantiation |
| `project-management/`           | User stories, sprints, design artefacts, GDPR, security, releases    |
| `.claude/`                      | Global rules, skill routing, model selection, hooks                  |
| `DESIGN.md`                     | Design entry point — standards, constraints, and UI/UX workflows     |
| `code/src/django/`              | The web deployable — API and server-rendered pages                   |
| `code/src/mobile/`              | **Mobile-only.** The Expo / React Native app, consuming that API     |
| `code/src/rust/`                | **Rust-only.** Native primitives compiled into the web deployable    |
| `code/src/rust/crates/desktop/` | **Desktop-only.** The native Slint application                       |

The PM layer **specifies and gates**; the code layer **builds and verifies**. The canonical
cross-layer workflow pairing lives in `REFERENCES.md` — neither layer's `CONTEXT.md` restates it.

## Starting Points

- **Generating a project from this template?** → `how-to/src/TEMPLATE-GUIDE/`
- **First time developing here?** → `how-to/CONTEXT.md`
- **Writing or reviewing code?** → `code/CONTEXT.md`
- **Planning or PM work?** → `project-management/CONTEXT.md`
- **Routing, model selection, and global rules?** → `.claude/CLAUDE.md`
- **UI/UX design or component work?** → `DESIGN.md`
- **Looking for a specific guide?** → `REFERENCES.md`

## How this repository documents itself

Every directory that orients Claude carries two files: a `CONTEXT.md` saying **what is here and
why it is here**, and a `CLAUDE.md` saying **how to work here**. Two directories are exempt from
the pairing — this root, whose `/CLAUDE.md` is gitignored because `code-review-graph install`
generates one there (`.claude/CLAUDE.md` is its operating-rules counterpart), and the
generated-output `reports/` folders under `code/src/scripts/**`.

The split is what keeps a rule in exactly one place, so changing it changes it everywhere. The
decision test, the headings that never belong in an orientation file, and the enforcement live in
`code/docs/DOCUMENTATION-PAIRING.md`.

## Repository State

Current version: **3.2.2** — see `VERSION`, `CHANGELOG.md`, and `RELEASES.md`.

Versioning is two-tier: the root project tracks the monorepo on single-track semver, and each
deployable sub-package carries its own independent semver — `code/src/django/` (manifest: root
`pyproject.toml`) always, plus `code/src/mobile/` (manifest: its own `package.json`, with the
same number mirrored in `app.json`) in a project that opted into the mobile surface. Sub-package
versions never move as a side-effect of a root bump. Rules:
`project-management/docs/VERSIONING-GUIDE.md`.

The template ships with no application code beyond the Django project skeleton — feature work
starts from a user story in `project-management/src/02-STORIES/`.
