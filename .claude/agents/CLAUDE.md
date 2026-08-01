@./CONTEXT.md

# CLAUDE.md — .claude/agents/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(agent registry, imported above) → this file.

## Purpose (one line)

The agent definitions — invoked via the Agent tool with `subagent_type` — in two tiers:
**8 orchestrators** (`bugfix`, `feature`, `pr`, `refactor`, `release`, `review`, `security`,
`story`) that route a whole workflow end-to-end, and the **specialists + document writers**
(internalised from the `{{ORG_SLUG}}-dev-suite` and `{{ORG_SLUG}}-doc-writer` plugins) that orchestrators
delegate scoped work to. Full roster + tiers: this folder's `CONTEXT.md`.

## How to work here

- **Routing:** these files are prompt definitions, not application code — edit them as
  documentation. A change here reshapes how an agent orchestrates; treat it with the
  weight of a workflow change, not a cosmetic one.
- **Grill first:** agents open any substantial task with a grilling pass — not a static
  question list — loading `.claude/skills/grill-with-docs` and interviewing {{DEVELOPER_NAME}} one question
  at a time before producing the artefact; only trivial/mechanical work skips it
  (`.claude/CLAUDE.md` §10).
- **Model — runtime vs editing (two axes):** an agent's own `model:` frontmatter sets
  which model it _runs_ on, per the §4 tiers — planning agents (`story`, `sprint`,
  `planner`, `user-story`) run on **Fable**; implementation and delivery agents on
  **Opus**. When _editing_ a definition here, use **Opus** — for substantive prompt
  changes (responsibilities, routing, guardrails) and mechanical touches (a rename, a
  fixed cross-reference) alike; `sonnet` and `haiku` are never used.
- **Concrete steps:** read the target agent file whole → keep each agent's remit
  distinct and non-overlapping (the `CONTEXT.md` table is the contract) → point the
  agent at its governing procedures and `**/docs/` guides rather than restating rules →
  keep the file within the 300-line instructional limit.
- **Every agent carries a "Governing procedures" section** — heading exactly
  `## Governing procedures (route here — do not restate at length)`, placed immediately
  after `## Context loading`. It names the procedures across **all three workflow
  layers**: `project-management/workflows/` (specify and gate), `code/workflows/`
  (build and verify), and `how-to/workflows/` (operational — setup, daily dev,
  debugging, worktrees), each with a one-line "when". An agent with no genuine
  counterpart (the standalone legal and policy writers) says so explicitly rather than
  leaving the absence ambiguous. Pairing map: `REFERENCES.md` → Cross-layer workflow
  pairing.
- **Definition of done:** the agent's purpose still matches its `CONTEXT.md` row; no
  two agents claim the same remit; British English; cross-references resolve; the
  `CONTEXT.md` table updated if an agent is added, removed, or renamed.

## Guardrails

- **Agents are hard-blocked from self-editing** — any change here requires explicit
  user instruction; an agent must never rewrite its own or a sibling's definition.
- Agent prompts must reference `code/src/scripts/**/*.sh` for dev operations — never
  raw `pnpm`, `next`, `pytest`, `python`, or `docker`.
- Preserve the non-negotiables an agent carries downstream — permission check on every
  mutation, no IDOR, docs hard-gate before commit — do not dilute them in a reword.
- Keep each definition a thin router to the real workflow, not a duplicate of it.
- **Session continuity is a driving-session duty, not a sub-agent one.** When context nears full,
  the top-level session / orchestrator hands off — invoke the `handoff` skill → write `handoffs/`
  → stop — rather than letting auto-compaction fire; delegated specialists just return to their
  orchestrator. Never silently compact. See `.claude/CLAUDE.md` §2.6.

## Output & naming

- **Hand-written:** each `*.md` agent definition. Nothing here is generated.
- **Naming:** kebab-case filename = frontmatter `name` = `subagent_type` (`backend.md` →
  `name: backend`). Orchestrator names are bare (`security`, not `security-workflow`).
- **Frontmatter:** `name`, `description` (capability + when-to-use), `model`, and — for
  specialists and document writers — a scoped `tools:` line. Orchestrators omit `tools:`
  (they carry all tools to spawn sub-agents). `model` is `fable` or `opus`, never
  `sonnet` or `haiku` (§4).
- Add or rename an agent only with a matching `CONTEXT.md` registry row.
