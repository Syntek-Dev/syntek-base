@./CONTEXT.md

# CLAUDE.md — src/14-DECISIONS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(ADR register + naming, imported above) → this file.

## Purpose (one line)

The Architecture Decision Record store — one immutable `ADR-###-<TITLE>.md` per
significant technical or design decision, capturing status, context, options
considered, decision, and consequences.

## How to work here

- **Routing:** an ADR is authored, not scaffolded — write it directly here. Reach for
  it during architectural work via `planner`; a decision that changes a
  build or deploy path is drafted alongside the relevant `code/workflows/` procedure.
  Ground a contested decision or stack choice with a primary-source-cited note via
  `.claude/skills/research/SKILL.md` (ADR groundwork).
- **Model:** Fable — an ADR is a reasoned trade-off document (context, options,
  consequences); Opus for a mechanical status flip (e.g. `accepted` →
  `superseded`) or a typo fix.
- **Concrete steps:** take the next free 3-digit index → create
  `ADR-###-<TITLE>.md` → fill the five sections (**Status**, **Context**, **Options
  considered**, **Decision**, **Consequences**) → cross-link any `US###` that drove or
  consumes the decision → set Status to `accepted` when signed off.
- **Definition of done:** decision recorded under a unique zero-padded index, named to
  convention, five sections complete, superseded ADRs cross-referenced both ways,
  British English throughout.

## Guardrails

- **Accepted ADRs are immutable** — never rewrite the decision in place. To change
  course, raise a new ADR and mark the old one `superseded`, cross-referencing the
  replacement ADR; note the supersession on both records.
- **Indices are unique and monotonic** — never reuse a retired number; gaps are
  acceptable, collisions are not.
- **This is a documentation folder** — no source, secrets, or `.env` content; an ADR
  states a security or architecture _decision_, it is enforced in `code/`.
- Instructional `.md` limit does not apply to these root-level `src/` artefacts, but
  keep each ADR focused on a single decision.

## Output & naming

- **Hand-written:** every `ADR-###-<TITLE>.md` in this folder.
- **Generated:** none — nothing here is machine-produced.
- Naming: `ADR-###-<TITLE>.md` — 3-digit zero-padded index, `TITLE` in
  `SCREAMING-SNAKE-CASE`; referenced stories as `US###`.
