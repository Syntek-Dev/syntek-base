# The Claude Code Setup

**Last Updated**: 13/08/2026

What ships in `.claude/`, how it routes work, and what to expect from it. This is the part of the
template with the least equivalent elsewhere, so it is worth understanding before you fight it.

---

## Read order

Every session starts the same way, and every folder's `CLAUDE.md` repeats the chain:

```text
1. .claude/CLAUDE.md      ← global rules; @-imports CONTEXT.md and REFERENCES.md
2. .claude/MEMORY.md      ← project memory — never skipped
3. <target>/CONTEXT.md    ← orientation for the directory being worked in
4. <target>/CLAUDE.md     ← operating rules for that directory
5. routing frontmatter    ← on the specific docs/ or workflows/ file being opened
```

The point is that context is **scoped**. A session doing frontend work never loads the GDPR
registers. This is why the 300-line instructional cap exists.

## Skills — one category, two shapes

Everything in `.claude/skills/` is a **skill**: a folder with a `SKILL.md` and optional
sub-documents. There is no tier above it and no roster to memorise. Within the one category
there is a single split, and it is about **where the work runs**:

| Kind                | What it is                                                                | Where it runs                                                    |
| ------------------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **Reference skill** | States conventions — `stack-django`, `codebase-design`, `global-workflow` | Inline, in the current context. Never forks                      |
| **Task skill**      | An executable procedure — `feature`, `bugfix`, `story`, `release`         | Forks into a fresh context, unless its input is the conversation |

Skills fire on **description match**, so most work needs no explicit routing — name one only to
force a choice. The ones you will hit first are the task skills that sequence others: `feature`
(a new capability), `bugfix` (something is broken), `review` (a quality pass before a PR),
`security` (an OWASP audit), `refactor` (restructuring without behaviour change), `story` and
`sprint` (planning), `pr` (raise and promote), `release` (bump, changelog, deploy). Each pulls in
the scoped skills it needs — `backend`, `frontend`, `database`, `test-writer`, `qa-tester`,
`code-reviewer`, `gdpr-mechanics`, and so on.

**If you answered yes to the mobile question**, you also get `stack-react-native`, mirroring
`stack-django` for the backend and `stack-htmx-templates` for the web frontend. Answer no and it
does not exist. Either way the registry lists it, flagged mobile-only: that keeps
`.claude/CLAUDE.md` free of conditional contents, which is the rule the whole opt-in rests on.
`frontend` stays Django-templates-only in both cases.

Two rules that shape the output:

- **No skill reviews its own work.** Each phase dispatches separately.
- **Every task skill that ships code has a documentation phase as a hard gate before its commit
  phase.**

**How a fork happens.** A skill that needs a clean context dispatches `general-purpose` through
the Agent tool and **names the skill to load in the prompt**. The built-in targets are `Explore`,
`Plan` and `general-purpose`; the first two skip `CLAUDE.md`, so they are only valid where the
work writes nothing.

## Models

Two tiers only. `sonnet` and `haiku` are never used.

| Alias   | For                                                                                         |
| ------- | ------------------------------------------------------------------------------------------- |
| `fable` | Planning, specification, design — architecture, schema, user flows, stories, sprints, plans |
| `opus`  | Everything else — code, tests, migrations, review, PR, release, docs, mechanical touches    |

Sessions run on Opus. Skills and workflows route by tier through their `model:` frontmatter.

> **Plan requirement.** The Fable tier means this is designed for **Claude Max 20× or above, or
> the Anthropic API**. On a smaller plan, retarget the design skills (`planner`,
> `scale-planning`, `sprint`, `story`) to `opus` in their frontmatter — everything still works,
> you just lose the tier separation.
>
> **On another provider?** Only the model routing is Claude-specific. Swap the aliases in
> `.claude/CLAUDE.md` §4, each skill's `model:` frontmatter, and the `model:` lines in `docs/` and
> `workflows/` routing frontmatter. The documentation system and gates are provider-agnostic.

## The skills you will meet first

| Skill                                       | Loaded when                                                  |
| ------------------------------------------- | ------------------------------------------------------------ |
| `stack-django`                              | Backend code — models, services, Ninja endpoints, pytest     |
| `stack-htmx-templates`                      | Frontend — templates, components, HTMX, Alpine, token CSS    |
| `stack-fastmcp`                             | The MCP tool surface at `/mcp/` — tools, token auth, tests   |
| `runbook`                                   | Writing operator guides a human executes under pressure      |
| `global-workflow`                           | Branches, commits, PRs, version bumps, docs, comments        |
| `grilling` · `grill-me` · `grill-with-docs` | Design interrogation (see below)                             |
| `codebase-design`                           | Architecture and refactor — the deep-module vocabulary       |
| `domain-modelling`                          | Recording a new concept or decision                          |
| `improve-codebase-architecture`             | `/improve-codebase-architecture` — deepening review          |
| `scale-planning`                            | `/scale-planning` — size the deployment, prove it scales     |
| `teach`                                     | `/teach <topic>` — a sandbox that writes only to `learning/` |
| `wayfinder`                                 | Charting an epic too big for one session                     |
| `handoff`                                   | `/handoff` — the auto-compaction replacement                 |
| `prototype`                                 | `/prototype` — a throwaway spike answering one question      |
| `research`                                  | `/research` — a primary-source-cited note                    |
| `legal-documents`                           | Privacy policy, T&C, DPA, GDPR notice                        |
| `msp-scp-documents`                         | Security and compliance policies                             |

Plus `cloudinary-*` for media work. That is a selection, not the roster —
`.claude/skills/CONTEXT.md` lists every skill with its trigger, and quotes no total, because it
moves on every change and differs between two correct projects once the optional surfaces are in
play.

## Grilling — the one to understand first

Substantial work does not begin with the work. It begins with an interview:

- asked in rounds — the whole settled frontier at once, never trickled out one at a time
- each carries a **recommended answer** with its rationale
- facts are looked up, not asked — "does a `Customer` model exist?" is never a question
- nothing is built until you confirm

This applies across design, code, tests, QA, refactors, migrations and docs. It supersedes every
static "clarifying questions" checklist in the repo. Only trivial or mechanical work skips it.

**Expect it to feel slow at first.** It exists because the expensive failure in agentic coding is
not bad code — it is confidently building the wrong thing.

### Three entry points

| Command            | What it is                                                                                      | Records anything?                                         |
| ------------------ | ----------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| `grilling`         | The **engine**. Not invoked directly — design skills load it as their opening move.             | n/a                                                       |
| `/grill-me`        | **Stateless.** Interview only. The sharpened design lives in the conversation and nowhere else. | No                                                        |
| `/grill-with-docs` | **Stateful.** Same interview, but each decision is written to its real home as it resolves.     | ADRs, plan Open Questions, glossary terms, story criteria |

Use `/grill-me` to think out loud, pressure-test an idea, or rehearse an argument you are not
committing to. Use `/grill-with-docs` for anything that should still be true next month — it is
the one that stops a decision being re-litigated in review six weeks later.

## Grilling vs wayfinder — which one

Both interrogate. They operate at different scales, and picking the wrong one is the most common
way to have a bad afternoon with this template.

**Grilling sharpens one design surface in one sitting.** One schema, one API contract, one story,
one refactor. It ends when that surface is settled.

**Wayfinder charts a whole epic's decision _frontier_** — work too big to hold in one head — into
a markdown map, then settles the nodes one at a time across many sessions. It is the cartographer;
grilling is the per-node engine it dispatches to.

| Reach for…           | When                                                                                                      |
| -------------------- | --------------------------------------------------------------------------------------------------------- |
| `/grill-me`          | One surface, and you want to think rather than commit                                                     |
| `/grill-with-docs`   | One surface, and the answer must survive the session                                                      |
| `/wayfinder chart`   | The work spans several stories, you cannot list the decisions yet, and one sitting will not get you there |
| `/wayfinder resolve` | A map exists and you are settling its next unblocked node                                                 |

The tell: **can you name the decisions?** If you can list them, grill them. If the honest answer is
"I do not yet know what I need to decide", that fog is what wayfinder is for — its map has an
explicit **Fog of war** section for exactly the things not yet sharp enough to be a question.

### How wayfinder works

Two modes, deliberately never in the same session:

- **CHART** (once) — pin the destination and what is consciously out of scope, explore breadth-first
  to surface every knowable open decision, wire the blocking edges so the unblocked ones are
  visible, write `MAP-<EPIC>.md` into the plans folder, fire the research nodes, and **stop**.
  Charting settles nothing; that is the discipline.
- **RESOLVE** (each later session) — load the map, take the next unblocked node, settle it by its
  type, **graduate** the outcome into its real artefact, then redraw the frontier.

Nodes are typed, and the type determines who does the work:

| Node type    | Settled by                                                                  |
| ------------ | --------------------------------------------------------------------------- |
| **Research** | Claude alone — facts looked up from code, docs or APIs                      |
| **Tracer**   | A rough spike that raises fidelity on a foggy area before it can be decided |
| **Grilling** | You, through one `/grill-with-docs` pass                                    |
| **Task**     | Manual unblocking — provision infra, run a migration, seed data             |

The map is a **low-resolution index, never a storage vault.** A resolved decision graduates to
where it belongs — an ADR, a story plus plan, a `GAPS.md` blocker, a `DEFERRED.md` row, or a
glossary term in the nearest `CONTEXT.md` — and the map keeps only a link. The epic is done when
Frontier and Fog of war are both empty.

**Do not grill an entire epic in one sitting.** That is the anti-pattern wayfinder exists to
prevent: you will either run out of context or make twenty decisions at a fidelity that suited
none of them.

## Session continuity

Auto-compaction is **disabled** (`settings.json` → `autoCompactEnabled: false`) and intercepted by
a `PreCompact` hook. Instead, when context fills, the session invokes the `handoff` skill, writes
`handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`, and stops so you can `/clear` and resume from a
committed document.

Silent compaction loses decisions; a written handoff does not.

## Hooks

| Hook                     | Fires                                                                                                                        |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `pre-pr-check.sh`        | Before `gh pr create` — 8 gates: format, lint, typecheck, tests, security, stubs, cloc, lockfiles. Blocks the PR on failure. |
| `post-pr-comment.sh`     | Posts gate results as a PR comment                                                                                           |
| `pre-compact-handoff.sh` | Intercepts compaction                                                                                                        |

## Helper plugins

Six read-only Python scripts in `.claude/plugins/` that Claude calls to gather context —
`project`, `env`, `db`, `git`, `log`, `pm`. They inspect; they never run dev operations. Those go
through `code/src/scripts/`.

## MCP servers

| Server              | Use                                                        |
| ------------------- | ---------------------------------------------------------- |
| `code-review-graph` | Structural context and impact analysis — cheaper than Grep |
| `context7`          | Current library and framework documentation                |
| `mcp-mermaid`       | Architecture and flow diagrams                             |
| `figma`             | Design reads and writes, Code Connect                      |
| `claude-in-chrome`  | Rendered UI inspection and browser automation              |

Only `code-review-graph` is repo-scoped (`.mcp.json`); the rest are machine-global and available
only if you have installed them.

**The graph and the layered docs are two views of the same codebase** — machine-derived structure
and human-curated orientation. Explore with both, and refresh the graph whenever you revise the
docs so they do not drift.

---

## Turning parts off

It is all files. `.claude/settings.json` controls permissions, model and hooks; deleting a skill
directory removes it. If grilling is not for you, the rule lives in `.claude/CLAUDE.md`
§10 — edit it. Nothing here is load-bearing for the application.

---

## Next

- Add your own skill or workflow → `12-EXTENDING.md`
- Put it to work → `10-FIRST-FEATURE.md`
