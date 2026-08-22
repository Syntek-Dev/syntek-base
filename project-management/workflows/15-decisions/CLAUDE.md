@./CONTEXT.md

# CLAUDE.md — workflows/15-decisions/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, inputs, key decisions, quality gates — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The decide-tier ADR workflow — capture a significant architectural or design decision
as an immutable `ADR-###-<TITLE>.md` in `src/15-DECISIONS/`, using
`ADR-000-TEMPLATE.md`, before sprint and story planning lock it into an execution
schedule.

## How to work here

- **Routing:** run `STEPS.md` in order; the hard gates —
  `src/15-DECISIONS/CLAUDE.md` (immutability, monotonic indices) and
  `ADR-000-TEMPLATE.md` (the five-section scaffold) — must be read before Step 1.
  Inputs: the driving story or spec (`04-database-schema`, `10-security-checks`,
  `13-api-design`, or any 02–14 workflow) that surfaced the trade-off.
- **Model:** Fable for the reasoned trade-off record itself; Opus for a mechanical
  status flip (`Proposed` → `Accepted`, or the supersession cross-link) or a typo fix.
- **Skills:** load `.claude/skills/codebase-design/SKILL.md` to reason through the
  options with the deep-module vocabulary (module, interface, seam, depth, leverage,
  locality; the deletion test); load `.claude/skills/research/SKILL.md` when a
  contested decision or stack choice needs a primary-source-cited note to ground it.
- **Concrete steps:** read the two hard gates → confirm the decision is ADR-worthy →
  take the next free `ADR-###` index → copy the template → fill Context, Options
  considered, Decision, and Consequences → set Status → cross-link any superseded ADR
  both ways → cross-link the driving `US###`/spec → satisfy `CHECKLIST.md`.
- **Definition of done:** all five sections complete (Status, Context, Options considered,
  Decision, Consequences); the index unique and monotonic; the record links its driving
  `US###` or spec; the filename follows `ADR-###-<TITLE>.md`. The ADR is then the single
  source of truth for the decision, and `workflows/16-sprint-plans/` and
  `workflows/17-story-plans/` cite it as a constraint on the plans they produce.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Accepted ADRs are immutable** — never rewrite the decision in place. A change of
  course is a **new** ADR that marks the old one `Superseded`, with both records
  cross-referencing each other.
- **Indices are unique and monotonic** — never reuse a retired number; gaps are
  acceptable, collisions are not.
- **Not every decision needs an ADR** — reserve it for choices that are hard to
  reverse or that a later decision would need to explicitly supersede; a call the
  implementer should just own does not belong here.
- Documentation workflow — no code, secrets, or `.env` content here; the ADR states
  the decision, `code/` enforces it. Instructional `.md` files ≤ 300 code lines (the
  ADR artefact itself is exempt — see `src/15-DECISIONS/CLAUDE.md`).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the record
  `ADR-###-<TITLE>.md` (3-digit zero-padded index, `SCREAMING-SNAKE-CASE` title) under
  `src/15-DECISIONS/`, cross-linked to its driving `US###`.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
