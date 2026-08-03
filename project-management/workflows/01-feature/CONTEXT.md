# Workflow 01 — Feature

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/01-feature/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## Purpose

Turn a feature idea into a **resolved decision map** before a single story is written. Wayfinder
charts the feature's decision frontier — every open question, in dependency order — and then each
node is settled one at a time. The output is `MAP-<FEATURE>.md` in `src/01-FEATURE/`.

This is the foundation the whole planning loop stands on. Stories written against a resolved map
describe _what to build_; stories written without one spend `02`–`14` rediscovering the same
questions, story by story, and answering them inconsistently.

## When to use this

- A new feature, epic, or body of work larger than a single story
- Before `02-story-creation` — the map is what the stories are cut from
- When an existing feature is being materially reshaped

## When NOT to use this

- A single, well-understood story — go straight to `02-story-creation`
- A bug fix or a refactor — those have their own routes
- A spike answering one question — use `/prototype`
- A one-surface design decision with no frontier — use `/grill-with-docs` directly

## Prerequisites

- [ ] The feature idea exists as a paragraph or a conversation — not yet as stories
- [ ] `.claude/skills/wayfinder/SKILL.md` read (CHART and RESOLVE modes)
- [ ] The layered context is loadable (see _Reading order_ below)

## Key concepts

- **Runs once per feature, not per story.** Everything from `02` to `14` is a per-story loop;
  this sits outside it and upstream of it.
- **Two modes, several sessions.** **CHART** maps the frontier in one session. **RESOLVE** settles
  one node per later session, graduates the outcome to its real home, and redraws the frontier.
  Charting deliberately does _not_ settle anything beyond research nodes.
- **The map is an index, not a vault.** Each resolved node links to the ADR, plan, or story it
  became. Detail lives there; the map stays low-resolution and readable at a glance.
- **A resolved node is a question later gates do not have to re-ask.** This is the whole payoff:
  the grilling pass in `04-database-schema` reads the map instead of re-litigating the data model,
  and every story inherits the same answers.
- **Not every node resolves before stories start.** A map with its blocking nodes settled and its
  fog honestly marked is enough. The bar is "no story will be written on an unanswered blocker",
  not "nothing is unknown".

## Reading order — what wayfinder loads, in order

The map is only as good as the ground truth behind it. Load in this order, each layer narrowing
the next:

1. **`CONTEXT.md` then `CLAUDE.md`** from the root down to the areas in play — orientation, then
   operating rules.
2. **The relevant docs guides** — `code/docs/DATABASE.md`, `code/docs/SECURITY.md`,
   `code/docs/ARCHITECTURE-PATTERNS.md` and the like, for the constraints a decision must
   respect.
3. **The whole of `project-management/src/`** — every story, spec, decision, plan, and record.
4. **The codebase itself**, via the `code-review-graph` explore playbook.

**`src/` is the living state of the project, not an archive.** Because every story closes with
`IMPLEMENTATION/` records that state what shipped _and where it diverged from the plan_, reading
`src/` tells you what was actually built, not merely what was once intended. A new feature mapped
against that is mapped against reality. A map drawn from the codebase alone loses the reasoning;
a map drawn from the plans alone loses the drift.

## Cross-references

### Hard gates — read before executing Step 1

- `.claude/skills/wayfinder/SKILL.md` — CHART and RESOLVE, the map artefact, node types, and
  the graduation table
- `project-management/docs/PLANNING-GUIDE.md` — the cadence this map feeds

### Soft references — consult during execution

- `.claude/skills/grill-with-docs/SKILL.md` — the per-node engine for grilling-type nodes
- `.claude/skills/research/SKILL.md` — for research nodes needing primary sources
- `.claude/skills/prototype/SKILL.md` — for tracer nodes needing a spike
- `project-management/src/14-DECISIONS/` — where hard-to-reverse outcomes graduate
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore playbook for mapping the surface
- `project-management/workflows/02-story-creation/` — the next workflow; stories cut from the map
