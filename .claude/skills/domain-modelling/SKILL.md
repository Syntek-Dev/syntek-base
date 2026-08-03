---
name: domain-modelling
description: >-
  Keep the project's domain model current as design decisions crystallise — the names for good seams
  live in the layered CONTEXT.md files and the ADRs, and this is the discipline for adding a term,
  sharpening a fuzzy one, and recording a load-bearing decision so future reviews don't re-litigate
  it. Load when naming a new module/concept during architecture, refactor, or review, or when the
  `codebase-design` / `improve-codebase-architecture` skills need a name recorded. Cited by the
  doc-writer, planner, and database agents. Deeper guidance: `code/docs/data-structures/DOMAIN-MODELLING.md`.
---

# Domain Modelling

The project's domain vocabulary is **distributed, not a single glossary file**: every directory's
`CONTEXT.md` is the orientation ("what is here") for its area, and the ADRs in
the project's decision register record the decisions behind the names. This skill keeps that
model current as a design or refactor crystallises new concepts — so a name enters the model the
moment it earns its place, not in a later doc sweep.

Deeper guidance on modelling the data itself: **`code/docs/DATA-STRUCTURES.md`** →
**`code/docs/data-structures/DOMAIN-MODELLING.md`** (aggregates, entities, value objects,
ubiquitous language). This skill is the _maintenance discipline_ that sits on top.

## The three moves

Do these **inline, as the decision lands** — never batch them for later.

1. **Name a new concept → add the term to the nearest `CONTEXT.md`.**
   When a deepened module (`codebase-design`) is named after a concept not yet in the docs, add it to
   the `CONTEXT.md` of the directory that owns it. If that directory has no `CONTEXT.md`, create the
   pair lazily — **`CONTEXT.md` (orientation) + `CLAUDE.md` (operating rules)** — per the project's
   pairing rule (`.claude/CLAUDE.md` §8). Use the term consistently everywhere thereafter.

2. **Sharpen a fuzzy term → edit the `CONTEXT.md` where it's defined.**
   If a conversation reveals a term is used two ways, tighten the definition at its source and make
   the callers agree. Ambiguity in the model is a shallow seam waiting to leak.

3. **Settle a load-bearing decision → offer an ADR.**
   When a design choice would otherwise be re-suggested or re-litigated by a future review, record it
   as the project's decision register (naming per `.claude/CLAUDE.md` §5),
   framed as: _"recording this so future architecture reviews don't re-propose it."_ Only for reasons
   a future explorer would actually need — skip the ephemeral ("not worth it right now") and the
   self-evident. A rejected refactor with a real reason is an ADR; a rejected refactor with no
   durable reason is nothing.

## What is _not_ domain modelling

- Ephemeral task state, blockers, sprint dependencies → **`GAPS.md`** (`.claude/CLAUDE.md` §10).
- Feedback, patterns, project-state facts → **`.claude/MEMORY.md`** (§9).
- The domain model is only the **names and their definitions** and the **decisions** behind them.

## Discipline

- **British English (en_GB)**, the project's ubiquitous language — a term entering the model is spelt
  the British way (`modelling`, `behaviour`, `colour`).
- **Docs are a hard gate + lockstep with the graph.** A `CONTEXT.md`/ADR change is a documentation
  change: complete it before the commit and refresh the code-review-graph alongside
  (`code-review-graph update`, or `build_or_update_graph_tool`) so the layered docs and the graph
  don't drift (`code/docs/CODE-REVIEW-GRAPH.md`).
- **Instructional-file limit** — every `CONTEXT.md` stays ≤ 300 code lines (`.claude/CLAUDE.md` §8);
  split rather than overflow.
- **Model:** the `doc-writer` agent (Opus) authors substantive glossary/ADR text; mechanical touches
  (adding a row, a Last-Updated bump) are Opus too.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/04-database-schema/` — naming the concepts the schema encodes
- `project-management/workflows/14-decisions/` — recording a load-bearing decision
- `project-management/workflows/21-implementation-documentation/` — where a new term lands in the touched `CONTEXT.md`

## Cross-references

- `code/docs/data-structures/DOMAIN-MODELLING.md` — modelling the data (entities, value objects, aggregates)
- `code/docs/DATA-STRUCTURES.md` — the governing data-structures guide (entry point)
- `.claude/skills/codebase-design/SKILL.md` — the design work that produces the names this records
- `.claude/skills/improve-codebase-architecture/SKILL.md` — the review whose decisions land here
- `.claude/CLAUDE.md` §5 (naming) · §8 (CONTEXT.md/CLAUDE.md pairing) · §9 (MEMORY) · §10 (GAPS)
