# <%PROJECT_NAME%> — Project Overview

## What this project is

> <%PROJECT_DESCRIPTION%>

**Read that first, every session.** It is the only statement of what is being built and for
whom; every gate downstream — the feature map, the stories, the schema, the sizing envelope —
is judged against it. If it has drifted from what the project has become, correcting it is a
task in its own right, not a side-effect of some other change.

## How it is built

This is the source repository for `<%PROJECT_SLUG%>`, built as a **Django-only monolith**:
Django 6 + Django Ninja + PostgreSQL on the server, Django templates + django-components +
HTMX + Alpine + token-driven vanilla CSS on the client. There is no separate frontend or
mobile application — one deployable serves the API and the rendered pages.

## Directory Tree

```text
<%PROJECT_SLUG%>/
├── .claude/                         ← Claude Code configuration — the authoritative rules
│   ├── CLAUDE.md                    ← global rules, routing, model selection, non-negotiables
│   ├── CONTEXT.md
│   ├── MEMORY.md                    ← project memory (feedback, patterns, project state)
│   ├── settings.json                ← project-level permissions, model, hooks
│   ├── agents/                      ← 8 orchestrators + specialists + doc-writers (roster: agents/CONTEXT.md)
│   ├── hooks/                       ← pre-PR quality gates
│   ├── plugins/                     ← read-only inspection helpers agents call for context
│   └── skills/                      ← internalised stack, workflow, and document skills
├── .agents/                         ← vendored third-party skills (Cloudinary)
├── .github/
│   └── workflows/                   ← CI: syntax, tests, audits, Claude gate, ClickUp sync
├── code/                            ← source code, coding standards, coding workflows
│   ├── CONTEXT.md                   ← code layer entry point
│   ├── CLAUDE.md
│   ├── REFERENCES.md
│   ├── docs/                        ← coding reference guides (architecture, security, testing)
│   ├── src/
│   │   ├── django/                  ← the Django project — backend and server-rendered frontend
│   │   ├── rust/                    ← RUST-ONLY — the Cargo workspace (PyO3, binaries, CLI)
│   │   │                              ← incl. crates/desktop/ — DESKTOP-ONLY Slint app
│   │   ├── docker/                  ← Dockerfiles and Compose files (dev/test/staging/prod)
│   │   ├── logs/                    ← runtime log files (dev/test; gitignored)
│   │   ├── scripts/                 ← shell scripts — ALL dev operations run through here
│   │   └── tests/                   ← API integration tests (Bruno collection)
│   └── workflows/                   ← step-by-step coding workflows (02–14)
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
│   └── workflows/                   ← step-by-step operational workflows (01–04)
├── project-management/              ← stories, sprints, design, GDPR, security, releases
│   ├── CONTEXT.md                   ← PM layer entry point
│   ├── CLAUDE.md
│   ├── REFERENCES.md
│   ├── docs/                        ← PM reference guides (git, versioning, SEO, GDPR, QA)
│   ├── export/                      ← ClickUp sync artefacts and task map
│   ├── src/                         ← live PM artefacts (00-ASSETS … 21-REFACTORING)
│   └── workflows/                   ← step-by-step PM workflows (01–22)
├── handoffs/                        ← session handoff documents (auto-compaction replacement)
├── learning/                        ← /teach sandbox — throwaway learning workspace
├── research/                        ← /research notes — primary-source-cited
├── .zed/                            ← Zed editor settings
├── CONTEXT.md                       ← this file
├── REFERENCES.md                    ← curated index of internal docs and external resources
├── README.md
├── DESIGN.md                        ← design entry point (standards, constraints, Figma)
├── GAPS.md                          ← active gaps, blockers, sprint dependencies
├── DEFERRED.md                      ← deferred-work register
├── CHANGELOG.md
├── RELEASES.md
├── VERSION
├── VERSION-HISTORY.md
├── copier.yml                       ← template contract — questions, delimiters, post-tasks
├── install.sh                       ← install the toolchain and dependencies
├── skills-lock.json                 ← installed Claude Code skills (versions and hashes)
├── lefthook.yml                     ← pre-commit hook runner config
├── package.json                     ← root workspace package (pnpm)
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
├── pyproject.toml                   ← Python tooling config and the django package manifest
├── eslint.config.mjs
├── .dockerignore
├── .editorconfig
├── .gitignore
├── .markdownlint-cli2.jsonc         ← Markdown lint config
├── .mcp.json                        ← MCP server config (code-review-graph, context7, figma)
├── .npmrc
├── .nvmrc                           ← Node.js version pin
├── .prettierignore
├── .prettierrc
└── .python-version                  ← Python version pin
```

Note: `uv.lock` is **absent by design** in the base template — it would pin the root project
under the literal `<%PROJECT_SLUG%>` name. Copier generates it and removes the ignore rule at
generation time, because a generated project must commit it (every Dockerfile builds with
`uv sync --frozen`).

## Layer Map

| Layer                           | Purpose                                                              |
| ------------------------------- | -------------------------------------------------------------------- |
| `code/`                         | Source code, coding standards, and the coding workflows              |
| `how-to/`                       | Setup, daily development, debugging, scaling, template instantiation |
| `project-management/`           | User stories, sprints, design artefacts, GDPR, security, releases    |
| `.claude/`                      | Global rules, agent and skill routing, model selection, hooks        |
| `DESIGN.md`                     | Design entry point — standards, constraints, and UI/UX workflows     |
| `code/src/django/`              | The single deployable — API and server-rendered pages                |
| `code/src/rust/`                | **Rust-only.** Native primitives compiled into that deployable       |
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

## Conventions

- **`CONTEXT.md` is orientation** — the directory tree and what-is-here. **`CLAUDE.md` is
  operating rules.** Every directory carrying a `CONTEXT.md` also carries a `CLAUDE.md`.
- **The root is the one exception to that pairing.** A root `/CLAUDE.md` is gitignored,
  because `code-review-graph install` generates one there and this project is Claude Code
  only. `.claude/CLAUDE.md` is the root's operating-rules counterpart to this file.
- **All developer operations run through the project shell scripts** under
  `code/src/scripts/` — never raw `python`, `pytest`, `pnpm`, `uv`, or `docker` commands.
- **Language is British English (en_GB)** across all documentation and copy.

## Repository State

Current version: **2.10.0** — see `VERSION`, `CHANGELOG.md`, and `RELEASES.md`.

Versioning is two-tier: the root project tracks the monorepo on single-track semver, and each
deployable sub-package carries its own independent semver — `code/src/django/` (manifest: root
`pyproject.toml`) always, plus `code/src/mobile/` (manifest: its own `package.json`, with the
same number mirrored in `app.json`) in a project that opted into the mobile surface. Sub-package
versions never move as a side-effect of a root bump. Rules:
`project-management/docs/VERSIONING-GUIDE.md`.

The template ships with no application code beyond the Django project skeleton — feature work
starts from a user story in `project-management/src/02-STORIES/`.
