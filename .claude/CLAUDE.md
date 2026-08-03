# Project: <%PROJECT_NAME%>

**Last Updated**: <%DATE%> | **Version**: 0.1.0 | **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) | **Timezone**: <%TIMEZONE%>

@../CONTEXT.md
@../REFERENCES.md
@./CONTEXT.md

---

## 1. Identity

**Developer:** <%DEVELOPER_NAME%> — Full Stack Software Developer at <%ORG_NAME%>. Senior developer — be concise, focus on architecture and trade-offs.

- **Chat output must be scannable, not an essay.** When reporting information to <%DEVELOPER_NAME%>, be extremely concise — sacrifice grammar for the sake of concision.
- **Memory functionality** Auto memory is off, if there is anything for this project regarding memory storage, we store it in ../MEMORY.md

> **Always use the project shell scripts under `code/src/scripts/` for all dev operations.
> Never run `python`, `pytest`, `pnpm`, or `docker` commands directly — use the scripts.**

---

## 2. Operating Model

**Read `.claude/CLAUDE.md` then `.claude/MEMORY.md` first — always, before any work, every
session and every task.** They are the two authoritative files; everything else is read on the
way to the work.

### 2.1 Read order

1. **`.claude/CLAUDE.md`** (this file) — its `@` imports auto-load the root `CONTEXT.md`,
   `REFERENCES.md`, and `.claude/CONTEXT.md`.
2. **`.claude/MEMORY.md`** — project memory (feedback, patterns, state). Never skip it.
3. The **target folder's `CONTEXT.md`** (orientation — tree, what-is-here) then its **`CLAUDE.md`**
   (operating rules).
4. The **routing frontmatter** on any `**/docs/*.md` or `**/workflows/**/*.md` file you open
   (§2.5) — it names the agent, skills, and model for that work.

Every folder `CLAUDE.md` repeats this chain in its own `Read order:` line.

### 2.2 How work flows

A task enters through an **orchestrator agent**, which routes to the matching
`**/workflows/NN-…/` procedure and **delegates** scoped work to **specialist** agents; the
specialists load the **stack skills**. The governing `docs/` guide and the workflow
`STEPS.md`/`CHECKLIST.md` carry routing frontmatter (§2.5) naming who does the work.

**Two things precede all of it, once per project** (`how-to/workflows/01-first-time-setup/`
Steps 7–8): the **project brief** in the root `CONTEXT.md` — what this builds, for whom,
replacing what — and **`/scale-planning`**, which settles the size the system is designed for and
therefore what it does _not_ need. Both are cheap before the first feature and expensive after
the tenth. If the brief is still the raw generation-time answer, say so before planning anything.

**PM planning runs a per-story loop, not a phase batch.** A human thinks each story through
end-to-end so implementation is mechanical: one story runs `02`→`14` before the next starts;
when the open sprint reaches `<%SPRINT_CAPACITY_SP%>` SP (grace `<%SPRINT_GRACE_SP%>`), `14`
and `15` run for that sprint; once every story is planned, `17-consolidate-design-work` unifies
the per-story design and schema work before any code. Never batch a gate across the backlog.
Full cadence: `project-management/workflows/CONTEXT.md` and
`project-management/docs/PLANNING-GUIDE.md`.

### 2.3 Agents (two tiers — full roster: `.claude/agents/CONTEXT.md`)

- **Orchestrators (entry points, carry all tools):** `bugfix`, `feature`, `pr`, `refactor`,
  `release`, `review`, `security`, `story`. Pick the one matching the task and let it delegate.
- **Specialists + document writers:** delegated to for scoped work (e.g. `backend`, `frontend`,
  `database`, `gdpr`, `test-writer`, `qa-tester`, `privacy-policy-writer`). Each is tool-scoped
  with a distinct remit; invoke one directly only for a narrow job. The roster in
  `.claude/agents/CONTEXT.md` is the count — no number is repeated here, because it goes stale on
  every roster change and, with the optional surfaces, differs between two correct
  projects. Rows flagged **mobile-only** (`mobile`) are absent on a web-only project, and rows
  flagged **rust-only** (`rust`) or **desktop-only** (`desktop`) are absent unless the project
  opted into those surfaces.

Internalised from the (now-disabled) `<%ORG_SLUG%>-dev-suite` / `<%ORG_SLUG%>-doc-writer` plugins; models are
`fable`/`opus` by tier (§4) — planning agents (`story`, `sprint`, `planner`, `user-story`)
run on Fable; never `sonnet` or `haiku`. Agents never self-edit.

### 2.4 Skills — load on demand (full table: `.claude/skills/CONTEXT.md`)

| Skill                           | Load when                                                                                                                                          |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `stack-django`                  | Backend code — models, services, Django Ninja endpoints, pytest                                                                                    |
| `stack-htmx-templates`          | Public frontend — Django templates, django-components, HTMX, Alpine, token CSS                                                                     |
| `stack-react-native`            | **Mobile-only.** The mobile surface — Expo, TypeScript, expo-router, StyleSheet over tokens                                                        |
| `stack-rust`                    | **Rust-only.** The Rust workspace — PyO3 extensions, the never-panic boundary, secret zeroizing, the cargo-deny gate                               |
| `stack-slint`                   | **Desktop-only.** The native Slint app — the licence disclosure, the generated-code lint boundary, threading, AccessKit                            |
| `stack-fastmcp`                 | The MCP tool surface at `/mcp/` — FastMCP tools over the service layer, token auth, in-memory client tests                                         |
| `global-workflow`               | Branches, commits, PRs, version bumps, docs, code comments                                                                                         |
| `runbook`                       | Authoring operator documentation — `how-to/docs/` and `how-to/src/` guides a human executes                                                        |
| `grill-me` · `grill-with-docs`  | Design work — type `/grill-me` (stateless) or `/grill-with-docs` (records decisions); both wrap the `grilling` engine                              |
| `codebase-design`               | Architecture / refactor / review — the deep-module vocabulary (module, interface, seam, depth, leverage, locality; deletion test; design it twice) |
| `domain-modelling`              | Recording a new concept or decision — add the term to the nearest `CONTEXT.md`, or an ADR, as a design crystallises                                |
| `improve-codebase-architecture` | <%DEVELOPER_NAME%> types `/improve-codebase-architecture` — scan for deepening opportunities, present a visual HTML report, then grill the pick    |
| `scale-planning`                | Sizing the deployment for a target user count and proving it scales — readiness + envelope on the scaling phase-gates; feeds the NixOS deploy repo |
| `teach`                         | <%DEVELOPER_NAME%> types `/teach <topic>` — safe learning sandbox; writes only to `learning/`                                                      |
| `wayfinder`                     | Charting a large epic into a decision map, resolved across sessions                                                                                |
| `handoff`                       | <%DEVELOPER_NAME%> types `/handoff`, or context nears full — the auto-compaction replacement (committed `handoffs/`; §2.6)                         |
| `prototype`                     | <%DEVELOPER_NAME%> types `/prototype` — throwaway spike answering one design question                                                              |
| `research`                      | <%DEVELOPER_NAME%> types `/research` — primary-source-cited note feeding an ADR/PLAN                                                               |
| `legal-documents`               | Privacy Policy, T&C, GDPR notice, DPA, contract, NDA                                                                                               |
| `msp-scp-documents`             | Security/compliance policy (InfoSec, incident, retention, …)                                                                                       |

`cloudinary-*` skills cover Cloudinary upload, delivery, and transformations.

**Graph playbooks** — `code-review-graph install` generates four task cards under `.claude/skills/`
(`explore-codebase`, `debug-issue`, `review-changes`, `refactor-safely`): **auto-generated,
referenced by path, never hand-edited** (they regenerate on `install`). Canonical guide:
`code/docs/CODE-REVIEW-GRAPH.md`, wired into the debug/review/refactor/explore agents and
workflows `07`/`09`/`10`/`11`.

### 2.5 Routing frontmatter

Every `**/docs/*.md` and `**/workflows/**/*.md` file carries YAML frontmatter naming the agent,
skills, and model for that work — **read it first and obey it**:

- **Docs guides:** `type: guide` · `agent:` · `skills: [..]` · `model:`
- **Workflow `STEPS.md`/`CHECKLIST.md`:** `workflow:` · `phase:` · `agent:` · `skills: [..]` · `model:`

### 2.6 Session continuity — hand off, never silently compact

When the context window nears full, **do not rely on auto-compaction** — it is disabled
(`settings.json` → `autoCompactEnabled: false`) and intercepted (the `PreCompact` hook,
`.claude/hooks/pre-compact-handoff.sh`). Instead the **driving session invokes the `handoff`
skill** → writes `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` → **stops** and prints the path,
so <%DEVELOPER_NAME%> can `/clear` and resume in a fresh context window. A hook cannot invoke a skill or stop the
session — that is the model's job (this rule). This is a top-level session / orchestrator duty;
delegated specialists return to their orchestrator rather than hand off.
See `.claude/skills/handoff/SKILL.md`.

---

## 3. Tooling — MCP Servers & Project Plugins

| Server              | When to use                                                                                  |
| ------------------- | -------------------------------------------------------------------------------------------- |
| `code-review-graph` | Before Grep/Glob/Read — structural context, impact analysis. Faster and token-cheaper.       |
| `context7`          | Any library, framework, or SDK docs. `resolve-library-id` → `query-docs`.                    |
| `claude-in-chrome`  | Rendered UI inspection, visual verification, browser automation. Load schema via ToolSearch. |
| `mcp-mermaid`       | Architecture and flow diagrams.                                                              |
| `figma`             | Figma design reads/writes, Code Connect. Load schema via ToolSearch.                         |

**Graph ⇄ layer system — work in tandem.** The code-review-graph and the layered
`CONTEXT.md`/`CLAUDE.md` docs are two synchronised views of the codebase: machine-derived
structure and human-curated orientation. **Explore with both** — read the target `CONTEXT.md`
for orientation, then run the code-review-graph explore playbook for structure. **Update both
together** — whenever you revise the docs, refresh the graph (`code-review-graph update`, or the
`build_or_update_graph_tool` MCP tool) so neither drifts. Guide: `code/docs/CODE-REVIEW-GRAPH.md`.

**Project helper scripts** — `.claude/plugins/*.py` (6 read-only inspection helpers: `project`,
`env`, `db`, `git`, `log`, `pm`) that agents call to gather context. They do **not** run dev
operations — those go through `code/src/scripts/**/*.sh`. Registry: `.claude/plugins/CONTEXT.md`.

**Disabled marketplace plugins** — `<%ORG_SLUG%>-dev-suite` and `<%ORG_SLUG%>-doc-writer` are disabled for
this project (`settings.json` → `enabledPlugins`); their agents and skills are internalised under
`.claude/`. Never invoke the old `<%ORG_SLUG%>-dev-suite` / `<%ORG_SLUG%>-doc-writer` plugin commands — use
the internal agents instead.

---

## 4. Claude Models

Every session runs on **Opus** with **ultracode** on (`effortLevel: xhigh`, dynamic workflows) — baked into `.claude/settings.json` (`model: opus`, `effortLevel: xhigh`, `ultracode: true`, `enableWorkflows: true`). Opus is the default main-loop model. Use the latest in each family — never hardcode version strings.

Sub-agents, workflows, and docs-guides route by **tier** through their `model:` frontmatter (§2.5): **Fable** sets the foundation, **Opus** builds on it and handles every mechanical touch. **Never use `sonnet` or `haiku`.**

| Alias        | Use for                                                                                                                                                                                     |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `fable`      | **Planning · spec · design.** Architecture, schema & data design, user flows, GDPR/security/QA specs, API design, stories, sprints, plans — the reasoning tier the implementation builds on |
| `opus`       | **Everything else.** Backend/frontend code, tests, migrations, review, PR, release, docs — and all mechanical touches (renames, version bumps, running scripts, doc-index lookups)          |
| ~~`sonnet`~~ | **Never used.**                                                                                                                                                                             |
| ~~`haiku`~~  | **Never used.**                                                                                                                                                                             |

---

## 5. Naming Conventions

### Files

| Pattern                          | Example                     | Used for                           |
| -------------------------------- | --------------------------- | ---------------------------------- |
| `SCREAMING-SNAKE-CASE.md`        | `CONTEXT.md`, `OVERVIEW.md` | All documentation files            |
| `US###.md`                       | `US015.md`                  | User stories (3-digit zero-padded) |
| `SPRINT-##.md`                   | `SPRINT-06.md`              | High-level sprint records          |
| `SPRINT-PLAN-##.md`              | `SPRINT-PLAN-03.md`         | Detailed sprint plans              |
| `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` | `BUG-AUTH-18-04-2026.md`    | Bug reports                        |
| `ADR-###-*.md`                   | `ADR-001-auth-strategy.md`  | Architectural decision records     |
| `WF-<NNN>-*.html`                | `WF-001-Homepage.html`      | Wireframes                         |
| `API-US###-*.md`                 | `API-US015-auth.md`         | API design documents               |
| `QA-US###-*.md`                  | `QA-US015-auth.md`          | QA plans                           |

### Directories

| Pattern                 | Example               | Used for                     |
| ----------------------- | --------------------- | ---------------------------- |
| `SCREAMING-SNAKE-CASE/` | `STORIES/`, `PLANS/`  | Documentation and PM folders |
| `kebab-case/`           | `django/`, `scripts/` | Source code directories      |

**Branches:** `us###/short-description` — full rules in `project-management/docs/GIT-GUIDE.md`.

---

## 6. Non-Negotiable Rules

These apply in every task, regardless of layer:

- Every state-changing Django Ninja endpoint needs an explicit permission check (OWASP A01).
- User-supplied IDs always verified against caller's ownership — no IDOR.
- Data invariants are enforced **in the database** — foreign keys with explicit delete behaviour, `NOT NULL`, `UNIQUE`, and `CHECK` on every bounded or enum-like column. Application-level validation is not a substitute (`code/docs/DATABASE.md`).
- A scope column, the row-security policy that reads it, its supporting index, and the middleware that sets its session variable ship **together** — never write a scope session variable that no policy reads.
- Migrations never hold a long `ACCESS EXCLUSIVE` lock on a large table — add-nullable → backfill → constrain; build indexes concurrently on populated tables; no manual DDL against a deployed database.
- `DEBUG=False` in all non-local environments.
- `CORS_ALLOWED_ORIGINS` explicit allowlist — never `*` in production.
- All secrets via environment variables — never hardcoded.
- Django admin must **never** be mounted at `/admin/` — it mounts at the non-obvious `/control/` path.
- Never commit `.env` files — use `.env.*.example` templates only.
- Implementation docs and `CONTEXT.md`/`CLAUDE.md` updates must be complete before any commit — hard gate, not optional — and the code-review-graph refreshed alongside them (`code-review-graph update`, or the `build_or_update_graph_tool` MCP tool) so the layered docs and the graph stay in lockstep (`code/docs/CODE-REVIEW-GRAPH.md`).
- **Token-first.** Design values are DB-canonical (`apps/design_tokens`). New values enter via the `/admin/design-tokens` editor or a migration — never as a raw literal in component/page CSS. Component CSS only ever consumes `var(--token)`, and the var name must resolve in the token layer (`code/src/django/static/css/tokens/*.css` + `surfaces.css`) — enforced by `code/src/scripts/audits/css-tokens.sh`. See `code/docs/DESIGN-TOKENS.md`.
- New Django app → `bash code/src/scripts/development/new-django-app.sh <app_name>` — never run `manage.py startapp` or `django-admin startapp` directly.
- New public marketing page → `bash code/src/scripts/development/new-django-view.sh <route_path>` — creates a Django view + template + URL entry. Never hand-create page routes outside this script.
- All documentation (`CONTEXT.md`, `docs/*.md`, `agents/*.md`, `REFERENCES.md`) must reference scripts from `code/src/scripts/` for developer operations — never raw `pnpm`, `npm`, `npx`, `pip`, `uv`, `docker`, or `python manage.py` commands.

---

## 7. Environment

| Setting        | Value                                              |
| -------------- | -------------------------------------------------- |
| Frontend (Dev) | `http://localhost:8000`                            |
| Backend / API  | `http://localhost:8000` · `/api/`                  |
| Database (Dev) | `<%PROJECT_SLUG%>_dev`                             |
| Django Admin   | non-obvious path — see `code/docs/URL-STRATEGY.md` |
| Locale         | <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>           |

URL conventions — full rules in `code/docs/URL-STRATEGY.md`:
Marketing `/` (slugs) · <%PROJECT_NAME%> Admin `/admin/` (UUIDs) · Client Portal `/portal/` (slugs)

---

## 8. Standards

- **Database:** read `code/docs/DATABASE.md` before any model, migration, or query — scope columns, database-level constraints, lock-safe migrations, search, and the deferred-infrastructure register with its trigger conditions
- **SEO:** all public pages in `apps.marketing` — checklist: `project-management/docs/SEO-CHECKLIST.md`
- **Accessibility:** WCAG 2.2 AA on all interactive components — guide: `code/docs/ACCESSIBILITY.md`
- **Versioning:** single-track semver — rules: `project-management/docs/VERSIONING-GUIDE.md` · bump via the internal `version` agent (or the `release` orchestrator)
- **Instructional file length:** `.md` files that instruct Claude Code must not exceed **300 code
  lines** (`cloc --include-lang=Markdown`). Rule applies to: `**/docs/*.md` ·
  `**/workflows/**/*.md` · `.claude/**/*.md` · all `CONTEXT.md` files. Rule does **NOT** apply
  to root-level `*.md` files (README.md, CHANGELOG.md, GAPS.md, RELEASES.md, etc.) or
  `**/src/*.md` files (operational guides for humans, e.g. NIXOS-SETUP.md). Oversized
  instructional files must be split; the entry point becomes a thin index that cross-references
  sub-documents.
- **Directory CONTEXT.md + CLAUDE.md pairing:** Every directory that contains a `CONTEXT.md`
  must also have a `CLAUDE.md`. `CONTEXT.md` is **orientation** (holds the directory tree and
  what-is-here); `CLAUDE.md` is **operating rules**. Each `CLAUDE.md` **opens with `@./CONTEXT.md`**
  (plus `@./REFERENCES.md` where a `REFERENCES.md` exists in that directory) so the tree still
  auto-loads on navigation, then a `Read order:` line, then four H2 sections — **Purpose (one
  line)** · **How to work here** (routing, model allocation, concrete steps, definition of done)
  · **Guardrails** · **Output & naming** — scaled to the folder (a leaf stays short; a layer/app
  root is fuller). Keep each well within the instructional-file limit. **Never leave a bare
  `@./CONTEXT.md` import stub** — that is the old convention, replaced 03/07/2026.
- **Source code file length:** all source files (`.py`, `.html`, `.css`, `.js`, etc.) must not
  exceed **750 lines** (800 with grace) — split into modules beyond that. Defined in `code/CONTEXT.md`.

---

## 9. Project Memory

`.claude/MEMORY.md` is the authoritative memory store for this project. Read it at the start of
every session. Write here instead of the global auto-memory system.

**When to write:**

- Feedback <%DEVELOPER_NAME%> gives on approach — corrections or confirmations of non-obvious choices
- Patterns and conventions discovered during work
- Project-state facts not derivable from the codebase (stack decisions, business rules)
- Operational quirks or workarounds

**When NOT to write here:** active gaps, blockers, sprint dependencies → those go in `GAPS.md`.
Ephemeral task details and in-progress state stay in the conversation only.

---

## 10. GAPS.md Workflow

`GAPS.md` at the project root tracks active architectural gaps, blockers, and sprint dependencies
only. Do not use it for memory, patterns, or observations — those go in `.claude/MEMORY.md`.

**When to write to GAPS.md:**

- Active gap or blocker discovered during work
- Sprint dependency (story X must ship before Y)
- Infrastructure gap (environment setup required before a feature can run)
- Planned feature deferred from the current story with a named future story as the target

**Read as well as written.** `GAPS.md` and `DEFERRED.md` are the standing register of unfinished
business, and `project-management/workflows/01-feature/` reads both before charting a feature —
to **suggest** candidate features from what has accumulated, and to triage every open entry
against the feature being charted (closes / blocks / unrelated). `01` **claims** an entry on the
feature map; only `21-implementation-documentation` **closes** it, against shipped code.

**Promotion cycle** — when an entry is resolved, mark it `✅ CLOSED <date>`. Promote permanent
decisions to the appropriate doc, then remove the closed entry on the next tidy pass:

| Entry type                      | Target doc                           |
| ------------------------------- | ------------------------------------ |
| Architecture decision / pattern | `code/docs/ARCHITECTURE-PATTERNS.md` |
| Security implementation pattern | `code/docs/SECURITY.md`              |
| Design system / token spec      | `code/docs/DESIGN-TOKENS.md`         |

**Question-asking policy:** For trivial or mechanical work (a rename, a version bump, a syntax
fix), make reasonable calls on minor details and proceed — <%DEVELOPER_NAME%> will redirect if wrong. Any
substantial task in any layer opens with a grilling pass (below), not a fixed question list.

**Grilling — the default across every layer:** Grilling is the project's clarification mechanism
for **all substantial work — design, code, tests, QA, refactor, review, debug, migration, docs —
not only planning and design.** Before producing the artefact (a plan, schema, resolver,
component, test suite, QA plan, refactor, or fix), the responsible agent **opens with a grilling
pass** (the `grilling` skill): interrogate first, one question at a time, each with a recommended
answer, looking facts up rather than asking, no action until <%DEVELOPER_NAME%> confirms. Only trivial or
mechanical work skips it. This **supersedes every static 'Clarify Before Planning' / 'Required
Information' / 'Clarifying questions' checklist project-wide** — agents open with a grilling pass,
not a fixed question list. <%DEVELOPER_NAME%> can also invoke it directly with `/grill-me` (stateless) or
`/grill-with-docs` (records decisions). See `.claude/skills/grilling/SKILL.md`.

---

## Skill Targets

<!-- DO NOT REMOVE — names the skills the specialist agents load from .claude/skills/ -->

The skills the internal agents load on demand (full when-to-load table: `.claude/skills/CONTEXT.md`):

- **Stack Skill (Backend):** `stack-django` — `.claude/skills/stack-django/`
- **Stack Skill (Frontend, web):** `stack-htmx-templates` — `.claude/skills/stack-htmx-templates/`
- **Stack Skill (Mobile) — mobile-only:** `stack-react-native` — `.claude/skills/stack-react-native/` (paired with the `mobile` agent; both absent on a web-only project)
- **Stack Skill (Native) — rust-only:** `stack-rust` — `.claude/skills/stack-rust/` (paired with the `rust` agent; both absent unless the project opted into the Rust surface. Gates **authoring**: a project that merely consumes a prebuilt PyO3 wheel needs neither)
- **Stack Skill (Desktop) — desktop-only:** `stack-slint` — `.claude/skills/stack-slint/` (paired with the `desktop` agent; both absent unless the project opted in. Only offered when the Rust surface is on, because Slint is Rust. Carries the **licence obligation**: the `AboutSlint` disclosure is what makes commercial use free)
- **Stack Skill (Agent-facing):** `stack-fastmcp` — `.claude/skills/stack-fastmcp/` (the `/mcp/` tool surface; loaded by `backend`, `security`, and `test-writer` — no dedicated agent, because MCP tools are backend service-layer work)
- **Global Skill:** `global-workflow` — `.claude/skills/global-workflow/`
- **Operator-Docs Skill:** `runbook` — `.claude/skills/runbook/` (paired with the `operator-docs` agent; the craft for guides a human executes)
- **Design / Grilling Skills:** `grilling` (engine) · `grill-me` (stateless) · `grill-with-docs` (records decisions) — `.claude/skills/{grilling,grill-me,grill-with-docs}/`
- **Architecture / Design Skills:** `codebase-design` (deep-module vocabulary) · `domain-modelling` (keep the model current) · `improve-codebase-architecture` (`/improve-codebase-architecture` — deepening review → HTML report → grill) · `scale-planning` (`/scale-planning` — size for a target user count + prove scalability; feeds the NixOS deploy repo) — `.claude/skills/{codebase-design,domain-modelling,improve-codebase-architecture,scale-planning}/`
- **Learning & Session Skills:** `teach` (learn in the `learning/` sandbox) · `wayfinder` (chart an epic) · `handoff` (session handoff / auto-compaction replacement, §2.6) · `prototype` (throwaway spike) · `research` (primary-source note) — `.claude/skills/{teach,wayfinder,handoff,prototype,research}/`
- **Legal Documents Skill:** `legal-documents` — `.claude/skills/legal-documents/`
- **Security/Compliance Skill:** `msp-scp-documents` — `.claude/skills/msp-scp-documents/`
