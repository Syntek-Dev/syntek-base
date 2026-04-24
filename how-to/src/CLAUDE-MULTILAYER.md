# Claude Code — Multilayer Guide

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Overview

This project uses a three-layer context system designed for Claude Code. Each layer has its own
`CONTEXT.md` index. Claude reads only the layer relevant to the current task, keeping responses
fast and the active context window small.

---

## The three layers

| Layer                  | Path                  | Purpose                                                      |
| ---------------------- | --------------------- | ------------------------------------------------------------ |
| **Code**               | `code/`               | Source code, tests, coding standards, and quality workflows  |
| **How-To**             | `how-to/`             | Setup, daily development, debugging, and contributing guides |
| **Project Management** | `project-management/` | Stories, sprints, plans, GDPR, releases                      |

---

## Layer routing

Tell Claude which layer to enter before describing a task. The routing table from `.claude/CLAUDE.md`:

| Task type                                  | Read first                      |
| ------------------------------------------ | ------------------------------- |
| Writing, reviewing, or testing code        | `code/CONTEXT.md`               |
| Stories, sprints, PRs, releases, GDPR, SEO | `project-management/CONTEXT.md` |
| Setup, daily dev, CLI usage, debugging     | `how-to/CONTEXT.md`             |

Always-applicable guides (read regardless of layer):

- `project-management/docs/GIT-GUIDE.md`
- `project-management/docs/VERSIONING-GUIDE.md`

### Entering a layer

Type the layer path at the start of your prompt:

```text
enter code/

enter how-to/

enter project-management/
```

Claude reads the layer's `CONTEXT.md` and uses it to route you to the right docs or workflow.

---

## CONTEXT.md system

Every directory in the three-layer structure contains a `CONTEXT.md` explaining:

- What the directory is for
- Its directory tree
- When to read it
- What _not_ to use it for
- Links to relevant docs and workflows

Read `CONTEXT.md` first. Only enter a `STEPS.md` when a workflow is explicitly triggered.

---

## Slash commands

Slash commands are defined in `.claude/commands/` and run inside any Claude Code session.

| Command       | Purpose                                           |
| ------------- | ------------------------------------------------- |
| `/dev`        | Start the full-stack development environment      |
| `/test`       | Run backend and frontend test suites              |
| `/migrate`    | Run Django database migrations                    |
| `/codegen`    | Generate TypeScript types from the GraphQL schema |
| `/schema`     | Generate or export the Strawberry GraphQL schema  |
| `/staging`    | Deploy to the staging environment                 |
| `/production` | Deploy to the production environment              |

---

## Skills (Syntek Dev Suite)

Skills are invoked with `/syntek-dev-suite:<skill>` inside a Claude Code session.

| Skill                           | Purpose                                    |
| ------------------------------- | ------------------------------------------ |
| `/syntek-dev-suite:backend`     | Django API, services, GraphQL resolvers    |
| `/syntek-dev-suite:frontend`    | Next.js pages, components, Apollo Client   |
| `/syntek-dev-suite:database`    | Migrations, schema, query optimisation     |
| `/syntek-dev-suite:test-writer` | TDD/BDD test generation                    |
| `/syntek-dev-suite:security`    | OWASP hardening, permission checks, IDOR   |
| `/syntek-dev-suite:stories`     | User story creation                        |
| `/syntek-dev-suite:sprint`      | Sprint planning with MoSCoW prioritisation |
| `/syntek-dev-suite:version`     | Semantic version bumps and changelog       |
| `/syntek-dev-suite:docs`        | Documentation generation                   |
| `/syntek-dev-suite:review`      | Code quality review                        |

Full skill reference: `how-to/docs/SYNTEK-GUIDE.md`

---

## MCP servers

| Server              | Scope              | When available                   |
| ------------------- | ------------------ | -------------------------------- |
| `code-review-graph` | Repo (`.mcp.json`) | Auto-loaded for all contributors |
| `context7`          | Machine-global     | Only if installed locally        |
| `claude-in-chrome`  | Machine-global     | Only if installed locally        |
| `mcp-mermaid`       | Machine-global     | Only if installed locally        |

### code-review-graph

Use before Grep/Glob/Read for code exploration. It provides structural context on the codebase
without loading every file into the context window.

### context7

Always prefer over web search for library documentation. Workflow:

1. `mcp__context7__resolve-library-id` — find the library ID
2. `mcp__context7__query-docs` — fetch the relevant section

---

## Model selection

| Model      | Use for                                                                     |
| ---------- | --------------------------------------------------------------------------- |
| **Haiku**  | Fast lookups, single-file reads, CONTEXT.md updates, simple renames         |
| **Sonnet** | Standard coding, tests, reviews, documentation, stories, sprints (default)  |
| **Opus**   | Complex architecture, security audits, GDPR analysis, cross-layer refactors |

In agent calls use `model: "haiku"` / `model: "sonnet"` / `model: "opus"` — never hardcode a
version string. When in doubt, use Sonnet.

---

## Global rules enforced by Claude

These rules apply in every session regardless of layer:

- Max 750 lines per file (800 with grace) — split into modules beyond that
- Every GraphQL mutation needs an explicit permission check
- User-supplied IDs verified against caller ownership — no IDOR
- All secrets via environment variables — never hardcoded
- `DEBUG=False` in all non-local environments
- `transaction.atomic()` on every service method doing ≥ 2 writes
- All fenced code blocks must declare their language (MD040)

---

## GAPS.md

If Claude encounters a workflow folder missing `STEPS.md` or `CHECKLIST.md`, it records the
missing file in `GAPS.md` at the project root and proceeds using `CONTEXT.md` alone. Check
`GAPS.md` at the start of any workflow to see recently flagged gaps.
