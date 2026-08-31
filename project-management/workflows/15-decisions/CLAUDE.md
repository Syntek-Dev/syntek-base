@./CONTEXT.md

# CLAUDE.md — workflows/15-decisions/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, inputs, key decisions, quality gates — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The decide-tier **coherence gate** — confirm every ADR this story raised holds true and
none clashes with another, and author the records steps `04`–`14` left unwritten, before
sprint and story planning lock the decisions into an execution schedule.

## How to work here

- **Routing:** run `STEPS.md` in order; the hard gates —
  `src/15-DECISIONS/CLAUDE.md` (immutability, naming, the driving-`US###` rule) and
  `ADR-US000-TEMPLATE.md` (the five-section scaffold) — must be read before Step 1.
  Inputs: the driving `US###` and **every ADR already written for it** by steps `04`–`14`
  (`04-database-schema`, `10-security-checks`, `13-api-design`, and the rest).
- **Model:** Fable for the reasoned trade-off record itself; Opus for a mechanical
  status flip (`Proposed` → `Accepted`, or the supersession cross-link) or a typo fix.
- **Skills:** load `.claude/skills/codebase-design/SKILL.md` to reason through the
  options with the deep-module vocabulary (module, interface, seam, depth, leverage,
  locality; the deletion test); load `.claude/skills/research/SKILL.md` when a
  contested decision or stack choice needs a primary-source-cited note to ground it.
- **Concrete steps:** read the two hard gates → gather the story's existing ADRs → check
  each still holds against what later steps decided → check no two clash → write the
  records the loop surfaced but nobody authored → resolve any clash by a **new**
  superseding ADR, never an edit → set Status → satisfy `CHECKLIST.md`.
- **Definition of done:** every hard-to-reverse decision this story made is recorded; every
  record's five sections are complete; **no two of the story's ADRs contradict each other**,
  and any that did is superseded with both links written; each filename follows
  `ADR-US###-<DECISION>-DD-MM-YYYY.md`. `workflows/16-sprint-plans/` and
  `workflows/17-story-plans/` then cite the set as a constraint on the plans they produce.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Accepted ADRs are immutable** — never rewrite the decision in place. A change of
  course is a **new** ADR that marks the old one `Superseded`, with both records
  cross-referencing each other.
- **A clash is resolved forward, never by editing.** Two of a story's ADRs disagreeing is
  the finding this gate exists to make; the fix is a new record superseding the loser, so
  the disagreement stays legible.
- **This gate authors nothing without a driving `US###`.** A wayfinder map reaches an ADR
  only through the slice that becomes a story.
- **Not every decision needs an ADR** — reserve it for choices that are hard to
  reverse or that a later decision would need to explicitly supersede; a call the
  implementer should just own does not belong here.
- Documentation workflow — no code, secrets, or `.env` content here; the ADR states
  the decision, `code/` enforces it. Instructional `.md` files ≤ 300 code lines (the
  ADR artefact itself is exempt — see `src/15-DECISIONS/CLAUDE.md`).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the record
  `ADR-US###-<DECISION>-DD-MM-YYYY.md` (driving story, decision in
  `SCREAMING-SNAKE-CASE`, date) under `src/15-DECISIONS/`, flat and cross-linked to its
  driving `US###`.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
