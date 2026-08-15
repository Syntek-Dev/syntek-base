# Project: <%PROJECT_NAME%>

**Last Updated**: <%DATE%> | **Version**: 0.1.0 | **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) | **Timezone**: <%TIMEZONE%>

@../CONTEXT.md
@../REFERENCES.md
@./CONTEXT.md

---

## 1. Identity

**Developer:** <%DEVELOPER_NAME%> — Full Stack Software Developer at <%ORG_NAME%>. Senior
developer — be concise, focus on architecture and trade-offs.

**Chat output must be scannable, not an essay** — a hard standard, applying to every reply
including this file's own author. **Chat only**: `docs/`, the pairs and the PM artefacts keep
their own register.

- **Lead with the answer.** No preamble, no restating the question, no closing recap.
- **Structure by default** — a list or a small table over prose; a paragraph only where the point
  does not decompose. A forced list reads as badly as a wall, and a one-column table worse still.
- **Cut filler, not grammar.** Hedges and throat-clearing go; the words carrying the sense stay.
  A fragment the reader has to decode costs more than the eight words it saved.
- **Bold the load-bearing words**; code, paths and commands in backticks.
- The grilling question format (Section 10, `.claude/skills/grilling/SKILL.md`) is this rule
  applied to interviews.

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

A task enters through the **skill** whose description matches it, which routes to the matching
`**/workflows/NN-…/` procedure and dispatches a subagent where a step needs fresh context (2.3).

**Four things run once per project, before anything else** — the brief, the brand voice, the
visual direction, the sizing envelope, in that order because each depends on the last
(`how-to/workflows/01-first-time-setup/` Steps 7 to 10). Say so if any is still `TBD`. **PM
planning is a per-story loop, never a phase batch** (`project-management/workflows/CONTEXT.md`).

### 2.3 Skills — one category, two shapes

There is **one** category, the **skill**, split into **reference** (states conventions, runs
inline, never forks) and **task** (an executable procedure, forks unless its input is the
conversation). Definitions and the roster live in `.claude/skills/CONTEXT.md`; how to author or
edit one is `.claude/skills/CLAUDE.md` → `how-to/docs/SKILL-AUTHORING.md`.

Skills fire on **description match**, so most work needs no explicit routing — name one only to
force a choice. Where independence is required — **no skill reviews its own work** — the running
skill dispatches `general-purpose` through the Agent tool, **naming the skill to load in the
prompt**. Built-in targets are `Explore`, `Plan` and `general-purpose`; the first two skip
`CLAUDE.md`, so use them only where the work writes nothing. A skill never self-edits.

### 2.4 The roster

**`.claude/skills/CONTEXT.md` is the roster and the only when-to-load table** — every skill, what
it is for, and the optional-surface flags. Read it there; nothing summarises it here. The four
auto-generated graph cards are covered by the same file and `code/docs/CODE-REVIEW-GRAPH.md`.

### 2.5 Routing frontmatter

Every `**/docs/*.md` and `**/workflows/**/*.md` file carries YAML frontmatter naming the skills
and model for that work — **read it first and obey it**:

- **Docs guides:** `type: guide` · `skills: [..]` · `model:`
- **Workflow `STEPS.md`/`CHECKLIST.md`:** `workflow:` · `phase:` · `skills: [..]` · `model:`

### 2.6 Session continuity — handoff, never silently compact

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

### 2.7 Dynamic workflows — the internal procedure comes first

Ultracode is on, so substantial work is orchestrated with the **Workflow tool**. Orchestration is
not procedure: a dynamic workflow supplies the fan-out, the adversarial verification and the
synthesis — the **steps, gates and order** come from the internal `**/workflows/NN-…/` folder that
matches the task. Read the three indexes (`code/`, `how-to/` and `project-management/`, each
`workflows/CONTEXT.md`, interlocked by the pairing table in the root `REFERENCES.md`) **before**
authoring a script, and name the workflow each phase executes in the script's `meta`. A phase
invented where an internal workflow already covers it is a second, unreviewed copy of a gate.

Improvise **only** the phases no internal workflow covers, and say in the script that you did. Where
such a phase will recur it becomes a numbered folder through the `scaffold` skill, registered per
that layer's `workflows/CLAUDE.md` — a Workflow script is never the procedure of record, because
nothing reads it on the next task and no gate applies to it.

---

## 3. Tooling — MCP Servers & Project Plugins

### 3.1 The servers

| Server              | When to use                                                                                  | How you get it                                                              |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `code-review-graph` | Before Grep/Glob/Read — structural context, impact analysis. Faster and token-cheaper.       | Configured in `.mcp.json`                                                   |
| `context7`          | Library/framework/SDK/CLI docs — **second**, after the internal `**/docs/`. Order in 3.2.    | Configured in `.mcp.json`                                                   |
| `mcp-mermaid`       | Architecture and flow diagrams.                                                              | Configured in `.mcp.json`                                                   |
| `claude-in-chrome`  | Rendered UI inspection, visual verification, browser automation. Load schema via ToolSearch. | **Install the Claude Chrome extension and pair it** — no config supplies it |

### 3.2 How to look something up

**The internal docs first. `context7` second. Web search last** — stop at the first tier that
answers it. An internal guide is a **decision**; an external doc is a menu of possibilities, and
reading the menu first produces answers this project has already rejected.

| Order | Source                                                                                                | Answers                                                                                     |
| ----- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 1     | **Internal** — the `**/docs/` guides, the layered `CONTEXT.md`/`CLAUDE.md` chain, and `REFERENCES.md` | What **this project has decided**: the convention, the constraint, the enforcement point    |
| 2     | **`context7` MCP** — `resolve-library-id` → `query-docs`                                              | What a **library, framework, SDK or CLI does**, at the version pinned in `REFERENCES.md`    |
| 3     | **Web search / `WebFetch`**                                                                           | What owns no library documentation — a vendor changelog, a standard's own page, an advisory |

- **Escalate on silence, not convenience.** Move outward when the docs are silent, name the library
  without naming the call, or describe a version we have left. "Faster to search" is not silence.
- **What comes back is a candidate, not a rule.** An external answer contradicting a guide loses;
  correcting a genuinely stale guide is its own change, through the Section 6 gate.
- **Synthesis is not a search.** Several primary sources weighed against one another is `/research`
  (`.claude/skills/research/SKILL.md`), not a search result pasted into an ADR.
- **This chain answers doctrine, not project facts** — those run `code-review-graph` →
  Read/Grep/Glob → `.claude/plugins/*.py`, owned by `.claude/skills/grilling/SKILL.md`.

### 3.3 Graph and layer docs — work in tandem

The code-review-graph and the layered `CONTEXT.md`/`CLAUDE.md` docs are two synchronised views of
the codebase: machine-derived structure and human-curated orientation. **Explore with both**, and
**update both together** — the refresh rule is in Section 6. Guide:
`code/docs/CODE-REVIEW-GRAPH.md`.

### 3.4 Helper scripts and disabled plugins

`.claude/plugins/*.py` — 6 read-only inspection helpers a skill calls to gather context; they
never run dev operations. Registry: `.claude/plugins/CONTEXT.md`. The `<%ORG_SLUG%>-dev-suite` and
`<%ORG_SLUG%>-doc-writer` marketplace plugins are **disabled** and internalised as the skills under
`.claude/skills/` — never invoke their old commands.

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

## 5. Naming & Writing Conventions

- **Writing conventions** — the U+00A7 ban, plain-ASCII punctuation and the em-dash exception,
  Markdown style: `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2.
- **Naming** — each folder's `CLAUDE.md` carries its own patterns under **Output & naming**, which
  is authoritative for that tree. PM artefact patterns: `project-management/CLAUDE.md`. Branches:
  `project-management/docs/GIT-GUIDE.md`. Directories are `SCREAMING-SNAKE-CASE/` for docs and PM,
  `kebab-case/` for source.

---

## 6. Non-Negotiable Rules

These apply in every task, regardless of layer:

- Every state-changing Django Ninja endpoint needs an explicit permission check (OWASP A01), and every user-supplied ID is verified against the caller's ownership — no IDOR.
- Data invariants are enforced **in the database**, each in exactly one named place; a breach is a programmer error surfacing as a 500, never a friendly 4xx (`code/docs/DATABASE.md` · `code/docs/NEGATIVE-SPACE.md` · register: `how-to/src/INVARIANTS.md`).
- A scope column, the row-security policy that reads it, its supporting index, and the middleware that sets its session variable ship **together** — never write a scope session variable that no policy reads.
- Migrations never hold a long `ACCESS EXCLUSIVE` lock on a large table — add-nullable → backfill → constrain; build indexes concurrently; no manual DDL against a deployed database.
- `DEBUG=False` outside local · `CORS_ALLOWED_ORIGINS` an explicit allowlist, never `*` · all secrets via environment variables · never commit `.env` (use `.env.*.example`).
- Django's built-in admin **never** mounts at `/admin/` — it lives at the non-obvious `/control/` (`code/docs/URL-STRATEGY.md`).
- **All dev operations run through `code/src/scripts/**/*.sh`** — never a raw `python`, `pytest`, `pnpm`, `uv`, `pip`, `npx` or `docker` invocation, whether you are running it or writing it into a doc. New Django app → `development/new-django-app.sh`; new public page → `development/new-django-view.sh`.
- Implementation docs and `CONTEXT.md`/`CLAUDE.md` updates are complete before any commit — hard gate — and the code-review-graph refreshed alongside them, **staged first, then refreshed**, because the incremental pass never sees an unstaged new file (`code/docs/CODE-REVIEW-GRAPH.md`).
- **Token-first.** Design values are DB-canonical; component CSS only ever consumes `var(--token)`, and the name must resolve in the token layer — never a raw literal (`code/docs/DESIGN-TOKENS.md`, gate: `audits/css-tokens.sh`).
- **Doctrine derived from an outside source is credited where it is written**, not retrospectively — the `README.md` Section _Influences and attribution_ table gains the row in the **same change** as the rule it credits. Attribution written once decays; written alongside, it stays true.
- **Use, adapt and redistribute are three different permissions.** A **share-alike** source (CC-BY-SA) may be **read** as a checklist of concerns; its text and its rule wording may **never** be derived into anything this template redistributes, because every generated project would inherit the obligation. Check the licence column in `README.md` Section _Influences_ **before** deriving, not after. Permissive sources (MIT, Apache-2.0, unlicensed) are derived freely and credited.

---

## 7. Environment

Locale <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>. Database `<%PROJECT_SLUG%>_dev`. The dev stack
serves on **`http://dev.<%PROJECT_SLUG%>.localhost:81`** — host port 81, because a local router
often holds 80, and `:8000` is the Django container's internal port, never published. A worktree
stack answers on its own `dev-us<NNN>.` host. **Never quote a URL from memory:
`server.sh up` prints the live one, and `code/docs/URL-STRATEGY.md` owns every route and prefix.**

---

## 8. Standards

- **Database:** read `code/docs/DATABASE.md` before any model, migration, or query — scope columns, database-level constraints, lock-safe migrations, search, and the deferred-infrastructure register with its trigger conditions
- **Domain objects over dictionaries:** a set of keys known at design time and carrying domain meaning is a **named type**, on every surface — dictionaries are for keys that are genuinely data. **Mandatory for all new and modified code**, with one greppable escape hatch: `DICT-OK: <reason> — confined to <boundary>`. Standard: `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md` · exceptions: `TYPES-EXCEPTIONS.md` · **gate: `audits/dict-discipline.sh`**
- **Discoverability:** all public pages in `apps.marketing`. Two halves, and neither restates the other — **what must be true per page**: `project-management/docs/SEO-CHECKLIST.md` · **how this stack does it**: `code/docs/DISCOVERABILITY.md`
- **Accessibility:** WCAG 2.2 AA on all interactive components — guide: `code/docs/ACCESSIBILITY.md`
- **Versioning:** single-track semver — rules: `project-management/docs/VERSIONING-GUIDE.md` · bump via the `version` skill (or the `release` skill)
- **Instructional file length:** `.md` files that instruct Claude Code must not exceed **300 code lines**, and from **270** may not grow without a dated allowance. Scope, exemptions, the ratchet and the allowance format: `code/docs/DOCUMENTATION-LENGTH.md` — **gate: `audits/docs-length.sh`**, never `cloc.sh`
- **Directory `CONTEXT.md` + `CLAUDE.md` pairing:** `CONTEXT.md` is **orientation** — what is here and why. `CLAUDE.md` is **operating rules** — how to work here. Every directory with one carries the other, bar the root and the generated `reports/` folders. The decision test, the four H2s, the banned headings and route-don't-restate: `code/docs/DOCUMENTATION-PAIRING.md` — gate: `audits/docs-pairing.sh`
- **Source code file length:** all source files (`.py`, `.html`, `.css`, `.js`, etc.) must not exceed **750 lines** (800 with grace) — split into modules beyond that. Defined in `code/CONTEXT.md`

---

## 9. Project Memory & the Registers

Three files hold state between sessions, and each owns its own rules — read them there:

| File                | Holds                                                       |
| ------------------- | ----------------------------------------------------------- |
| `.claude/MEMORY.md` | Feedback, patterns, project-state facts. Read every session |
| `GAPS.md`           | Active gaps, blockers, sprint dependencies                  |
| `DEFERRED.md`       | Work a shipped story explicitly handed to a future one      |

Never cross them: memory is not a gap, and a gap is not a memory. Ephemeral task state stays in
the conversation.

**Promotion — this file owns it.** When a `GAPS.md` entry is resolved, mark it `✅ CLOSED <date>`,
promote any permanent decision to the doc below, then remove the closed entry on the next tidy
pass:

| Entry type                      | Target doc                           |
| ------------------------------- | ------------------------------------ |
| Architecture decision / pattern | `code/docs/ARCHITECTURE-PATTERNS.md` |
| Security implementation pattern | `code/docs/SECURITY.md`              |
| Design system / token spec      | `code/docs/DESIGN-TOKENS.md`         |

---

## 10. Grilling — the clarification default

**For trivial or mechanical work** (a rename, a version bump, a syntax fix) make reasonable calls
on minor details and proceed — <%DEVELOPER_NAME%> will redirect if wrong.

**Every substantial task in any layer opens with a grilling pass** — design, code, tests, QA,
refactor, review, debug, migration, docs, not only planning. Before producing the artefact, the
running skill interrogates, looks facts up rather than asking, and takes no action until
<%DEVELOPER_NAME%> confirms.

**Above one sitting, chart before you grill.** Work spanning several stories — an epic, a
cross-cutting migration — cannot be settled in one pass. `/wayfinder` maps the decision frontier
and dispatches batches of nodes back to grilling to settle them
(`.claude/skills/wayfinder/SKILL.md`; procedure: `project-management/workflows/01-feature/`). A
single design surface goes straight to `/grill-with-docs`.

**`.claude/skills/grilling/SKILL.md` owns the shape and nothing else restates it** — the round
structure, the question format, and the ban on the `AskUserQuestion` tool all live there. A skill
or workflow opening a pass names **what** must be settled and routes for **how**. This
**supersedes every static 'Clarify Before Planning' / 'Required Information' / 'Clarifying
questions' checklist project-wide**. <%DEVELOPER_NAME%> can invoke it directly with `/grill-me`
(stateless) or `/grill-with-docs` (records decisions).
