# Project: <%PROJECT_NAME%>

**Last Updated**: <%DATE%> | **Version**: 0.1.0 | **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) | **Timezone**: <%TIMEZONE%>

@../CONTEXT.md
@../REFERENCES.md
@./CONTEXT.md

---

## 1. Identity

**Developer:** <%DEVELOPER_NAME%> — Full Stack Software Developer at <%ORG_NAME%>. Senior developer — be concise, focus on architecture and trade-offs.

- **Chat output must be scannable, not an essay.** This is a hard standard, not a preference — it applies to every reply, including this file's own author.
  - **Lists over paragraphs.** Default to a bulleted or numbered list, or a small table. A wall of prose is the failure mode; reach for a paragraph only when the point genuinely does not decompose.
  - **Short sentences.** One idea each. **Sacrifice grammar for concision** — fragments are fine, and preferred over a correct sentence twice the length.
  - **Never a long essay.** No preamble, no restating the question, no summary of what you are about to say, no closing recap. Lead with the answer.
  - **Bold the load-bearing words** so the reply survives skim-reading. Code, paths and commands in backticks.
  - Applies to **chat replies**, not to the repository's own documentation — `docs/`, `CONTEXT.md`, `CLAUDE.md` and the PM artefacts keep their existing register.
  - The grilling question format (Section 10, `.claude/skills/grilling/SKILL.md`) is this rule applied to interviews.
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
   (Section 2.5) — it names the skills and model for that work.

Every folder `CLAUDE.md` repeats this chain in its own `Read order:` line.

### 2.2 How work flows

A task enters through the **skill** whose description matches it; that skill routes to the
matching `**/workflows/NN-…/` procedure and dispatches a subagent for any step needing a fresh
context (Section 2.3). The governing `docs/` guide and the workflow `STEPS.md`/`CHECKLIST.md` carry
routing frontmatter (Section 2.5) naming the skills and model for that work.

**Four things precede all of it, once per project** (`how-to/workflows/01-first-time-setup/`
Steps 7–10), in order, because each depends on the one before: the **project brief** in the root
`CONTEXT.md` — what this builds, for whom, replacing what — then **`how-to/src/BRAND-VOICE.md`**,
which settles how the project speaks to that named reader (every skill that writes a user-facing
string loads it), then **`code/docs/VISUAL-DESIGN.md` Section 3**, which names the **visual direction**
and pins its six axes — the same doctrine in composition rather than copy, and what makes Section 4.2's
ban list decidable at all — then **`/scale-planning`**, which settles the size the system is
designed for and therefore what it does _not_ need. All four are cheap before the first feature
and expensive after the tenth. If the brief is still the raw generation-time answer, or
`BRAND-VOICE.md` Section 3 or `VISUAL-DESIGN.md` Section 3 still carry `TBD` placeholders, say so before
planning anything.

**PM planning runs a per-story loop, not a phase batch.** A human thinks each story through
end-to-end so implementation is mechanical: one story runs `02`→`14` before the next starts;
when the open sprint reaches `<%SPRINT_CAPACITY_SP%>` SP (grace `<%SPRINT_GRACE_SP%>`), `15`
and `16` run for that sprint; once every story is planned, `17-consolidate-design-work` unifies
the per-story design and schema work before any code. Never batch a gate across the backlog.
Full cadence: `project-management/workflows/CONTEXT.md` and
`project-management/docs/PLANNING-GUIDE.md`.

### 2.3 Skills — one category, two shapes

There is **one** category, the **skill**, and within it one split:

- **Reference skill** — states conventions (`stack-django`, `codebase-design`). Runs inline in
  the current context and never forks.
- **Task skill** — an executable procedure (`feature`, `backend`, `release`). Forks unless its
  input is the conversation itself; its own frontmatter says which.

Skills fire on **description match**, so most work needs no explicit routing — name one only to
force a choice. Where independence is required — **no skill reviews its own work** — the running
skill dispatches `general-purpose` through the Agent tool, **naming the skill to load in the
prompt**. Built-in targets are `Explore`, `Plan` and `general-purpose`; the first two skip
`CLAUDE.md`, so use them only where the work writes nothing. Models are `fable`/`opus` by task
(Section 4) — design skills (`story`, `sprint`, `planner`, `scale-planning`) run on Fable. A skill
never self-edits.

### 2.4 The roster

**`.claude/skills/CONTEXT.md` is the roster and the only when-to-load table** — every skill, what
it is for, and the optional-surface flags. Read it there; nothing summarises it here.

**Graph playbooks** — `code-review-graph install` generates four task cards under `.claude/skills/`
(`explore-codebase`, `debug-issue`, `review-changes`, `refactor-safely`): **auto-generated,
referenced by path, never hand-edited** (they regenerate on `install`). Canonical guide:
`code/docs/CODE-REVIEW-GRAPH.md`, cited by the `bugfix`, `review`, `refactor` and
`code-reviewer` skills and workflows `07`/`09`/`10`/`11`.

### 2.5 Routing frontmatter

Every `**/docs/*.md` and `**/workflows/**/*.md` file carries YAML frontmatter naming the skills
and model for that work — **read it first and obey it**:

- **Docs guides:** `type: guide` · `skills: [..]` · `model:`
- **Workflow `STEPS.md`/`CHECKLIST.md`:** `workflow:` · `phase:` · `skills: [..]` · `model:`

### 2.6 Session continuity — hand off, never silently compact

When the context window nears full, **do not rely on auto-compaction** — it is disabled
(`settings.json` → `autoCompactEnabled: false`) and intercepted (the `PreCompact` hook,
`.claude/hooks/pre-compact-handoff.sh`). Instead the **driving session invokes the `handoff`
skill** → writes `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` → **stops** and prints the path,
so <%DEVELOPER_NAME%> can `/clear` and resume in a fresh context window. A hook cannot invoke a skill or stop the
session — that is the model's job (this rule). This is a **top-level session** duty; a dispatched
subagent returns its result to the session that spawned it rather than handing off.

**Two thresholds, measured not guessed.** The model cannot read its own context usage, so the
`UserPromptSubmit` hook `.claude/hooks/context-threshold-handoff.sh` measures it and this rule
reacts: at **50%** advise — finish the step in flight, start no new scoped work, name the
stopping point and offer `/handoff`; at **75%** insist — write the handoff and stop the turn.
See `.claude/skills/handoff/SKILL.md`.

---

## 3. Tooling — MCP Servers & Project Plugins

| Server              | When to use                                                                                  | How you get it                                                              |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `code-review-graph` | Before Grep/Glob/Read — structural context, impact analysis. Faster and token-cheaper.       | Configured in `.mcp.json`                                                   |
| `context7`          | Any library, framework, or SDK docs. `resolve-library-id` → `query-docs`.                    | Configured in `.mcp.json`                                                   |
| `mcp-mermaid`       | Architecture and flow diagrams.                                                              | Configured in `.mcp.json`                                                   |
| `claude-in-chrome`  | Rendered UI inspection, visual verification, browser automation. Load schema via ToolSearch. | **Install the Claude Chrome extension and pair it** — no config supplies it |

**Graph ⇄ layer system — work in tandem.** The code-review-graph and the layered
`CONTEXT.md`/`CLAUDE.md` docs are two synchronised views of the codebase: machine-derived
structure and human-curated orientation. **Explore with both** — read the target `CONTEXT.md`
for orientation, then run the code-review-graph explore playbook for structure. **Update both
together** — whenever you revise the docs, refresh the graph (`code-review-graph update`, or the
`build_or_update_graph_tool` MCP tool) so neither drifts. Guide: `code/docs/CODE-REVIEW-GRAPH.md`.

**Project helper scripts** — `.claude/plugins/*.py` (6 read-only inspection helpers: `project`,
`env`, `db`, `git`, `log`, `pm`) that skills call to gather context. They do **not** run dev
operations — those go through `code/src/scripts/**/*.sh`. Registry: `.claude/plugins/CONTEXT.md`.

**Disabled marketplace plugins** — `<%ORG_SLUG%>-dev-suite` and `<%ORG_SLUG%>-doc-writer` are disabled for
this project (`settings.json` → `enabledPlugins`); their contents are internalised as the skills
under `.claude/skills/`. Never invoke the old `<%ORG_SLUG%>-dev-suite` / `<%ORG_SLUG%>-doc-writer`
plugin commands — use the internal skills instead.

---

## 4. Claude Models

Every session runs on **Opus** with **ultracode** on (`effortLevel: xhigh`, dynamic workflows) — baked into `.claude/settings.json` (`model: opus`, `effortLevel: xhigh`, `ultracode: true`, `enableWorkflows: true`). Opus is the default main-loop model. Use the latest in each family — never hardcode version strings.

Sub-agents, workflows, and docs-guides route by **tier** through their `model:` frontmatter (Section 2.5): **Fable** sets the foundation, **Opus** builds on it and handles every mechanical touch. **Never use `sonnet` or `haiku`.**

| Alias        | Use for                                                                                                                                                                                     |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `fable`      | **Planning · spec · design.** Architecture, schema & data design, user flows, GDPR/security/QA specs, API design, stories, sprints, plans — the reasoning tier the implementation builds on |
| `opus`       | **Everything else.** Backend/frontend code, tests, migrations, review, PR, release, docs — and all mechanical touches (renames, version bumps, running scripts, doc-index lookups)          |
| ~~`sonnet`~~ | **Never used.**                                                                                                                                                                             |
| ~~`haiku`~~  | **Never used.**                                                                                                                                                                             |

---

## 5. Naming Conventions

### Writing conventions

- **Never use the section sign (U+00A7).** Write `Section 3.2`, or just `3.2` where the context
  already says it is a section. Its doubled form, for a range, is banned too — write
  `Sections 4 to 7`.
- It is the scholarly and legal shorthand for "section", absorbed from RFCs, specs, statutes and
  standards documents. The usage is correct and denser than this project wants: these files are
  read under time pressure by people who are not lawyers.
- **The rule is deliberately written without the character**, so that zero occurrences is an
  invariant anything can check — `grep -rIP '\xc2\xa7' .` returning nothing is the pass condition.
- **Prefer plain ASCII punctuation** in anything an agent writes. The em dash is the deliberate
  exception — it is house style throughout the prose here, and `audits/copy-emdash.sh` bans it
  only in **public marketing copy**, never in documentation.
- If that codepoint ever shows up as mojibake, mid-word, or somewhere "section" makes no sense,
  that is a UTF-8/Latin-1 encoding fault rather than a writing-style one — fix it as corruption.

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
- Data invariants are enforced **in the database** — foreign keys with explicit delete behaviour, `NOT NULL`, `UNIQUE`, and `CHECK` on every bounded or enum-like column. Application-level validation is not a substitute (`code/docs/DATABASE.md`). Every invariant is enforced in **exactly one named place**, recorded in `how-to/src/INVARIANTS.md`; a breach is a **programmer error** that surfaces as a 500 and a tracker event, never a friendly 4xx (`code/docs/NEGATIVE-SPACE.md`).
- A scope column, the row-security policy that reads it, its supporting index, and the middleware that sets its session variable ship **together** — never write a scope session variable that no policy reads.
- Migrations never hold a long `ACCESS EXCLUSIVE` lock on a large table — add-nullable → backfill → constrain; build indexes concurrently on populated tables; no manual DDL against a deployed database.
- `DEBUG=False` in all non-local environments.
- `CORS_ALLOWED_ORIGINS` explicit allowlist — never `*` in production.
- All secrets via environment variables — never hardcoded.
- Django admin must **never** be mounted at `/admin/` — it mounts at the non-obvious `/control/` path.
- Never commit `.env` files — use `.env.*.example` templates only.
- Implementation docs and `CONTEXT.md`/`CLAUDE.md` updates must be complete before any commit — hard gate, not optional — and the code-review-graph refreshed alongside them, **staged first, then refreshed**, because the incremental pass never sees an unstaged new file (`code-review-graph update`, or the `build_or_update_graph_tool` MCP tool) so the layered docs and the graph stay in lockstep (`code/docs/CODE-REVIEW-GRAPH.md`).
- **Token-first.** Design values are DB-canonical (`apps/design_tokens`). New values enter via the `/admin/design-tokens` editor or a migration — never as a raw literal in component/page CSS. Component CSS only ever consumes `var(--token)`, and the var name must resolve in the token layer (`code/src/django/static/css/tokens/*.css` + `surfaces.css`) — enforced by `code/src/scripts/audits/css-tokens.sh`. See `code/docs/DESIGN-TOKENS.md`.
- New Django app → `bash code/src/scripts/development/new-django-app.sh <app_name>` — never run `manage.py startapp` or `django-admin startapp` directly.
- New public marketing page → `bash code/src/scripts/development/new-django-view.sh <route_path>` — creates a Django view + template + URL entry. Never hand-create page routes outside this script.
- All documentation (`CONTEXT.md`, `docs/*.md`, `.claude/skills/**/*.md`, `REFERENCES.md`) must reference scripts from `code/src/scripts/` for developer operations — never raw `pnpm`, `npm`, `npx`, `pip`, `uv`, `docker`, or `python manage.py` commands.
- **Doctrine derived from an outside source is credited where it is written**, not retrospectively — the `README.md` Section _Influences and attribution_ table gains the row in the **same change** as the rule it credits. Attribution written once decays; written alongside, it stays true.
- **Use, adapt and redistribute are three different permissions.** A **share-alike** source (CC-BY-SA) may be **read** as a checklist of concerns; its text and its rule wording may **never** be derived into anything this template redistributes, because every generated project would inherit the obligation. Check the licence column in `README.md` Section _Influences_ **before** deriving, not after. Permissive sources (MIT, Apache-2.0, unlicensed) are derived freely and credited.

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
- **Domain objects over dictionaries:** a set of keys known at design time and carrying domain meaning is a **named type**, on every surface — dictionaries are for keys that are genuinely data. Parse at the boundary and pass objects inward; a closed set that behaviour branches on is an enum. **Mandatory for all new and modified code**, with one documented escape hatch: `DICT-OK: <reason> — confined to <boundary>`, greppable and required. Standard: `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md` · exceptions: `TYPES-EXCEPTIONS.md` · **gate: `code/src/scripts/audits/dict-discipline.sh`**
- **Discoverability:** all public pages in `apps.marketing`. Two halves, and neither restates the other — **what must be true per page**: `project-management/docs/SEO-CHECKLIST.md` · **how this stack does it**: `code/docs/DISCOVERABILITY.md`
- **Accessibility:** WCAG 2.2 AA on all interactive components — guide: `code/docs/ACCESSIBILITY.md`
- **Versioning:** single-track semver — rules: `project-management/docs/VERSIONING-GUIDE.md` · bump via the `version` skill (or the `release` skill)
- **Instructional file length:** `.md` files that instruct Claude Code must not exceed **300 code
  lines** (`cloc --include-lang=Markdown`) — **gate: `code/src/scripts/audits/docs-length.sh`**,
  never `cloc.sh`, which excludes Markdown by design. Applies to `**/docs/**/*.md` ·
  `**/workflows/**/*.md` · `.claude/**/*.md` · every `CONTEXT.md` and `CLAUDE.md`. Does **NOT**
  apply to root-level `*.md` (README.md, CHANGELOG.md, GAPS.md, RELEASES.md, etc.) or
  `**/src/*.md` (operator guides for humans, e.g. NIXOS-SETUP.md) — though a `CONTEXT.md` or
  `CLAUDE.md` inside an exempt tree is still bound. Oversized files are split; the entry point
  becomes a thin index that cross-references sub-documents.
- **The warn tier has teeth — the ratchet.** From **270** code lines (90%) a file may not get
  **longer** without a dated reason: `docs-length.sh --since <ref>` fails on growth at or above
  the tier, and on a file **born** there. Lefthook measures from `HEAD`, CI from the merge-base.
  Answer by splitting, or with a whole-line
  `<!-- docs-length-allow: <reason> (expires DD/MM/YYYY) -->` — both halves mandatory, an undated
  allowance being an amnesty for exactly the files that earned scrutiny. It defers the ratchet
  only, never the 300 limit. **Nothing is exempt for growing by design**: a register that
  outgrows the cap becomes an index, like anything else.

<!-- docs-length-allow: this file gains a bullet whenever a rule is added, and at 277/300 it needs a split decision — but it is the auto-loaded root config whose @ imports every session depends on, so splitting it is its own node rather than a side-effect of the one that added the ratchet (expires 01/11/2026) -->

- **Directory `CONTEXT.md` + `CLAUDE.md` pairing:** `CONTEXT.md` is **orientation** — what is
  here and **why** it is here (the directory tree, what-is-here). `CLAUDE.md` is **operating
  rules** — how to work here: it opens with `@./CONTEXT.md` (plus `@./REFERENCES.md` where one
  exists in that directory), then a `Read order:` line, then four H2s — **Purpose (one line)** ·
  **How to work here** · **Guardrails** · **Output & naming** — scaled to the folder. Every
  directory with one carries the other, bar the root and the generated-output `reports/` folders.
  The decision test, the headings banned from a `CONTEXT.md`, and the route-don't-restate rule:
  `code/docs/DOCUMENTATION-PAIRING.md` — gate: `code/src/scripts/audits/docs-pairing.sh`.
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
component, test suite, QA plan, refactor, or fix), the running skill **opens with a grilling
pass** (the `grilling` skill): interrogate first, look facts up rather than asking, and take no
action until <%DEVELOPER_NAME%> confirms. Only trivial or mechanical work skips it.

**`.claude/skills/grilling/SKILL.md` owns the shape and nothing else restates it** — the round
structure (ask the whole settled frontier in one numbered round, wait, recompute, ask the next),
the question format (brief titled options plus an explicit recommendation), and the ban on the
`AskUserQuestion` tool all live there. A skill or workflow opening a grilling pass names
**what** must be settled and routes for **how**; a restatement drifts the moment the skill
changes. This **supersedes every static 'Clarify Before Planning' / 'Required Information' /
'Clarifying questions' checklist project-wide**. <%DEVELOPER_NAME%> can also invoke it directly
with `/grill-me` (stateless) or `/grill-with-docs` (records decisions).

---

## Skill Targets

**Routed, never restated.** `.claude/skills/CONTEXT.md` is the one place a skill's name, remit
and when-to-load trigger are written down — including the stack skills and the optional-surface
ones. Read it there (Section 2.4).
