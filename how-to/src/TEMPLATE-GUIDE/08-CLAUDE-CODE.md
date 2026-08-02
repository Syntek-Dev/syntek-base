# The Claude Code Setup

**Last Updated**: 02/08/2026

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

The point is that context is **scoped**. An agent doing frontend work never loads the GDPR
registers. This is why the 300-line instructional cap exists.

## Agents — two tiers

**Orchestrators (8)** are the entry points. They carry all tools, pick the matching workflow, and
delegate:

| Agent      | Triggered by                                 |
| ---------- | -------------------------------------------- |
| `feature`  | A new full-stack capability                  |
| `bugfix`   | A bug, regression, or broken behaviour       |
| `review`   | A quality pass before a PR                   |
| `security` | An OWASP audit or hardening pass             |
| `refactor` | Restructuring without behaviour change       |
| `story`    | Writing a user story or planning a sprint    |
| `pr`       | Raising a PR and moving it through promotion |
| `release`  | Version bump, changelog, deploy              |

**Specialists (29) and document writers (13)** are delegated to for scoped work — `backend`,
`frontend`, `database`, `gdpr`, `test-writer`, `qa-tester`, `seo`, `authentication`,
`privacy-policy-writer`, `incident-response-plan-writer`, and so on. Each is tool-scoped with a
distinct remit.

Two rules that shape the output:

- **No agent reviews its own work.** Review and QA are separate spawns.
- **Every orchestrator has a documentation phase as a hard gate before its commit phase.**

Full roster: `.claude/agents/CONTEXT.md`.

## Models

Two tiers only. `sonnet` and `haiku` are never used.

| Alias   | For                                                                                         |
| ------- | ------------------------------------------------------------------------------------------- |
| `fable` | Planning, specification, design — architecture, schema, user flows, stories, sprints, plans |
| `opus`  | Everything else — code, tests, migrations, review, PR, release, docs, mechanical touches    |

Sessions run on Opus. Sub-agents and workflows route by tier through their `model:` frontmatter.

> **Plan requirement.** The Fable tier means this is designed for **Claude Max 20× or above, or
> the Anthropic API**. On a smaller plan, retarget the Fable agents (`story`, `sprint`, `planner`,
> `user-story`) to `opus` in their frontmatter — everything still works, you just lose the tier
> separation.
>
> **On another provider?** Only the model routing is Claude-specific. Swap the aliases in
> `.claude/CLAUDE.md` §4, each agent's `model:` frontmatter, and the `model:` lines in `docs/` and
> `workflows/` routing frontmatter. The documentation system and gates are provider-agnostic.

## Skills — loaded on demand

| Skill                                       | Loaded when                                                  |
| ------------------------------------------- | ------------------------------------------------------------ |
| `stack-django`                              | Backend code — models, services, Ninja endpoints, pytest     |
| `stack-htmx-templates`                      | Frontend — templates, components, HTMX, Alpine, token CSS    |
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

Plus `cloudinary-*` for media work.

## Grilling — the one to understand first

Substantial work does not begin with the work. It begins with an interview:

- one question at a time, never a wall of them
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
| `grilling`         | The **engine**. Not invoked directly — design agents load it as their opening move.             | n/a                                                       |
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
| **Research** | The agent alone — facts looked up from code, docs or APIs                   |
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

Six read-only Python scripts in `.claude/plugins/` that agents call to gather context —
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

It is all files. `.claude/settings.json` controls permissions, model and hooks; deleting an agent
or skill directory removes it. If grilling is not for you, the rule lives in `.claude/CLAUDE.md`
§10 — edit it. Nothing here is load-bearing for the application.

---

## Next

- Add your own agent, skill or workflow → `11-EXTENDING.md`
- Put it to work → `09-FIRST-STORY.md`
