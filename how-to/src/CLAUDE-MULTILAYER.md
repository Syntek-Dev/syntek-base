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

Six MCP servers are configured for this project across two scopes. The repo-scoped server is
defined in `.mcp.json` and loaded automatically. The four user-scoped servers must be installed
once on each developer's machine and are stored in `~/.claude.json`. One server is built-in.

| Server              | Scope                   | When available                    |
| ------------------- | ----------------------- | --------------------------------- |
| `code-review-graph` | Repo — `.mcp.json`      | Auto-loaded for all contributors  |
| `claude-in-chrome`  | Built-in                | Always — no installation required |
| `docfork`           | User — `~/.claude.json` | Only if installed locally         |
| `context7`          | User — `~/.claude.json` | Only if installed locally         |
| `figma`             | User — `~/.claude.json` | Only if installed locally         |
| `mcp-mermaid`       | User — `~/.claude.json` | Only if installed locally         |

---

### code-review-graph (repo-scoped — auto-loaded)

No action required. The server is defined in `.mcp.json` at the project root and Claude Code
loads it automatically for every contributor.

**What it does:** Parses the codebase with Tree-sitter, builds a persistent structural knowledge
graph, and provides impact analysis, flow tracing, and smart review context — all without loading
every file into the context window.

**When to use:** Always prefer this over `Grep`/`Glob`/`Read` for code exploration. It is faster
and cheaper on tokens. Use `Grep` only when you need raw text matching on something the graph does
not index.

The server is defined in `.mcp.json` as:

```json
{
  "mcpServers": {
    "code-review-graph": {
      "command": "uvx",
      "args": ["code-review-graph", "serve"]
    }
  }
}
```

No additional steps are needed. If the graph is stale after large refactors, trigger a rebuild
with the `mcp__code-review-graph__build_or_update_graph_tool` tool inside a Claude Code session.

---

### claude-in-chrome (built-in — no installation)

`claude-in-chrome` is built into Claude Code. No installation is required and no entry in
`~/.claude.json` is needed.

**What it does:** Provides browser automation tools for inspecting rendered output, visual
verification, console log reading, and screenshot capture inside Claude Code sessions.

**When to use:** Use to verify UI changes in the browser, check rendered pages, or debug
JavaScript before reporting work as complete.

**Important:** Tool schemas are deferred — you must load them with `ToolSearch` before calling
any `mcp__claude-in-chrome__*` tool. At the start of any browser session, load and call
`tabs_context_mcp` first:

```text
ToolSearch: select:mcp__claude-in-chrome__tabs_context_mcp
```

Never trigger JavaScript `alert()`, `confirm()`, or `prompt()` dialogs — they block all
subsequent browser events.

---

### docfork (user-scoped — install once per machine)

**What it does:** Searches indexed documentation for 10,000+ libraries and frameworks using
hybrid BM25 + semantic search. Returns versioned, official content from authoritative sources —
not SEO-optimised blog posts or community content.

**When to use:** Always prefer `docfork` over web search for any library, framework, or SDK
documentation. Use `search_docs` first for broad discovery, then `fetch_doc` to retrieve the full
page.

**Workflow:**

1. `mcp__docfork__search_docs` — search by library name and natural-language query
2. `mcp__docfork__fetch_doc` — retrieve the full documentation page from a result URL

**Install:**

```bash
claude mcp add --scope user docfork -- npx -y @docfork/mcp
```

Verify the server was added:

```bash
claude mcp list
```

---

### context7 (user-scoped — install once per machine)

**What it does:** Fetches current, version-specific documentation for libraries and frameworks.
Use as a complement to `docfork` when its results are sparse or a second source is needed.

**When to use:** Use for library API syntax, configuration references, version migration guides,
and SDK method signatures — even for well-known libraries whose training data may be outdated.
Do not use for refactoring, business logic, or general programming concepts.

**Workflow:**

1. `mcp__context7__resolve-library-id` — resolve the library name to its context7 ID
2. `mcp__context7__query-docs` — fetch the relevant documentation section using that ID

**Install:**

```bash
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp
```

Verify the server was added:

```bash
claude mcp list
```

---

### figma (user-scoped — install once per machine)

**What it does:** The official Figma MCP server. Reads design files, captures screenshots,
generates FigJam diagrams, and manages Code Connect mappings between Figma components and
codebase components.

**When to use:** Use whenever a `figma.com` URL is shared, a user asks about a Figma design, or
wireframe sign-off is required before frontend work begins. Prioritise over all other tools when
a figma.com URL is present.

**URL parsing:**

- `figma.com/design/:fileKey/:name?node-id=:nodeId` → extract `fileKey` and `nodeId`; convert
  `-` to `:` in the `nodeId`
- `figma.com/board/:fileKey/:name` → FigJam file; use `get_figjam` instead of `get_design_context`

**Workflow:**

1. `mcp__figma__get_design_context` — primary tool; returns code, screenshot, and design hints
2. `mcp__figma__get_screenshot` — capture a visual of a specific node
3. `mcp__figma__generate_diagram` — create a diagram in FigJam

**Install:**

You need a Figma personal access token. Generate one at
**Figma → Settings → Security → Personal access tokens**.

```bash
claude mcp add --scope user figma -- npx -y figma-developer-mcp --figma-api-key=YOUR_FIGMA_API_KEY
```

Replace `YOUR_FIGMA_API_KEY` with your token. The key is stored in `~/.claude.json` — never
commit it to version control.

Verify the connection inside a Claude Code session by calling `mcp__figma__whoami`.

---

### mcp-mermaid (user-scoped — install once per machine)

**What it does:** Renders Mermaid diagrams inside Claude Code sessions. Used for database ERDs
in `project-management/src/03-DATABASE/`, user flow charts in `04-USER-FLOW/`, and architecture
diagrams.

**When to use:** Use whenever a Mermaid diagram needs to be generated or validated. Schema design
is formalised before any migration is written — use the
`project-management/workflows/03-database-schema/` workflow and render the ERD with this server
before sign-off.

**Workflow:**

```text
mcp__mcp-mermaid__generate_mermaid_diagram
```

**Install:**

```bash
npx -y @anthropic-ai/mcp-install mcp-mermaid
```

This registers the server in your user-level Claude Code config automatically.

Full installation guide: [github.com/hustcc/mcp-mermaid](https://github.com/hustcc/mcp-mermaid)

Verify the server was added:

```bash
claude mcp list
```

---

### Verifying all servers after installation

After installing all four user-scoped servers, run:

```bash
claude mcp list
```

You should see all six servers listed — `code-review-graph` (project), `claude-in-chrome`
(built-in), `docfork`, `context7`, `figma`, and `mcp-mermaid` (all user-scoped).

To remove a server if you need to reconfigure it:

```bash
claude mcp remove --scope user <server-name>
```

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
