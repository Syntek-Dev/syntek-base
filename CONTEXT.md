# project-name — Project Overview

This is the source repository for `project-name`, built as a full-stack monorepo:
Django + Strawberry GraphQL backend, Next.js + Tailwind CSS frontend.

## Directory Tree

```text
project-name/
├── .claude/
│   ├── CLAUDE.md                    ← global rules, routing, model selection
│   ├── settings.local.json          ← local Claude Code permission settings
│   ├── commands/                    ← slash commands
│   │   ├── codegen.md
│   │   ├── dev.md
│   │   ├── migrate.md
│   │   ├── production.md
│   │   ├── schema.md
│   │   ├── staging.md
│   │   └── test.md
│   └── plugins/                     ← MCP tool plugins
│       ├── chrome-tool.py
│       ├── db-tool.py
│       ├── ddev-tool.py
│       ├── docker-tool.py
│       ├── env-tool.py
│       ├── git-tool.py
│       ├── log-tool.py
│       ├── pm-tool.py
│       ├── project-tool.py
│       └── quality-tool.py
├── .github/
│   └── workflows/                   ← CI: syntax, tests, and audit checks
│       ├── audit-cloc.yml
│       ├── audit-stubs.yml
│       ├── syntax-js-ts.yml
│       ├── syntax-markdown.yml
│       ├── syntax-python.yml
│       ├── test-backend.yml
│       ├── test-e2e.yml
│       ├── test-frontend.yml
│       └── test-mobile.yml
├── code/                            ← source code, coding standards, tests
│   ├── CONTEXT.md
│   ├── docs/                        ← coding reference guides
│   ├── src/
│   │   ├── backend/                 ← Django 6.0.4 + Strawberry GraphQL
│   │   ├── docker/                  ← Dockerfiles and Compose files
│   │   ├── frontend/                ← Next.js 16.2.4 App Router
│   │   ├── logs/                    ← runtime log files (dev/test; gitignored)
│   │   ├── mobile/                  ← Expo SDK + React Native
│   │   ├── scripts/                 ← development, test, database, and quality scripts
│   │   └── shared/                  ← cross-platform components and utilities
│   └── workflows/                   ← step-by-step coding workflows (01–10)
├── how-to/                          ← setup, daily dev, debugging guides
│   ├── CONTEXT.md
│   ├── docs/                        ← operational reference guides
│   ├── src/                         ← contributing and code-quality guide
│   └── workflows/                   ← step-by-step operational workflows (01–03)
├── project-management/              ← stories, sprints, PM, GDPR, security
│   ├── CONTEXT.md
│   ├── docs/                        ← PM reference guides (git, versioning, SEO, GDPR)
│   ├── src/                         ← live PM artefacts (00-ASSETS … 16-REFACTORING)
│   └── workflows/                   ← step-by-step PM workflows (01–18)
├── CHANGELOG.md
├── CONTEXT.md                       ← this file
├── CONTRIBUTING.md
├── DESIGN.md                        ← design entry point for Claude Design (standards + workflows)
├── GAPS.md                          ← missing workflow files flagged by Claude
├── install.sh                       ← interactive project setup script
├── LICENSE
├── README.md
├── RELEASES.md
├── VERSION
├── VERSION-HISTORY.md
├── eslint.config.mjs                ← ESLint config (JS/TS/React)
├── lefthook.yml                     ← pre-commit hook runner config
├── package.json                     ← root workspace package (pnpm)
├── pnpm-lock.yaml
├── pnpm-workspace.yaml              ← pnpm monorepo workspace definition
├── pyproject.toml                   ← Python tooling config (ruff, basedpyright, uv)
├── uv.lock
├── .dockerignore
├── .editorconfig
├── .gitignore
├── .markdownlint-cli2.jsonc         ← Markdown lint config (MD040 etc.)
├── .mcp.json                        ← MCP server config (code-review-graph)
├── .npmrc
├── .nvmrc                           ← Node.js version pin
├── .prettierignore
├── .prettierrc                      ← Prettier formatting config
└── .python-version                  ← Python version pin (3.14)
```

## Layer Map

| Layer                 | Purpose                                                              |
| --------------------- | -------------------------------------------------------------------- |
| `code/`               | Source code and coding standards                                     |
| `how-to/`             | Setup guides, daily development, debugging                           |
| `project-management/` | User stories, sprints, plans, GDPR, security audits                  |
| `.claude/`            | Claude Code context, routing, git and version guides                 |
| `DESIGN.md`           | Design entry point — standards, guides, and workflows for UI/UX work |
| `code/src/backend/`   | Django project                                                       |
| `code/src/frontend/`  | Next.js project                                                      |

## Starting Points

- **First time here?** → `how-to/CONTEXT.md`
- **Writing or reviewing code?** → `code/CONTEXT.md`
- **Planning or PM work?** → `project-management/CONTEXT.md`
- **Routing and global rules?** → `.claude/CLAUDE.md`
- **UI/UX design or component work?** → `DESIGN.md`

## Repository State

Current version: see `VERSION` and `CHANGELOG.md`.
Backend, frontend, and mobile source code live in `code/src/` and are initialised via `/syntek-dev-suite:setup`.
