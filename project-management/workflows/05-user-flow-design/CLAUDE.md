@./CONTEXT.md

# CLAUDE.md — workflows/05-user-flow-design/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file.

## Purpose (one line)

Map how users move through a product area — screens, decision nodes, and transitions —
after story creation and before brand guides or wireframes.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`. Pre-code design phase — no hard
  safety gates apply. Feeds `workflows/07-component-designs/` and `08-wireframes/`.
- **Model:** Fable — journey mapping is design judgement.
- **Spike an open question:** when one design question blocks the flow, load
  `.claude/skills/prototype/SKILL.md` — a throwaway spike to answer that one question
  before committing to a real build; discard it after.
- **Concrete steps:** confirm in-scope `US###` stories and their acceptance criteria →
  identify the product area (auth, client portal, public, admin) → map every screen,
  decision, and transition with **both success and failure paths** → annotate GDPR
  data touchpoints → save one `USER-FLOW-<AREA>.md` per area to
  `project-management/src/05-USER-FLOW/`.
- **Definition of done:** every decision node resolves both outcomes; the flow is the
  agreed source of truth for wireframe scope and GDPR data-touch mapping; checklist
  satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Every decision node must define both a success and a failure outcome** — no dead
  ends.
- Flows document behaviour and structure, **not visual design** — that is brand,
  component, and wireframe work.
- Data touchpoints must map to lawful basis and retention (`docs/GDPR-GUIDE.md`); routes
  must follow `code/docs/URL-STRATEGY.md`; account for mobile and desktop paths
  (`code/docs/RESPONSIVE-DESIGN.md`). STRIDE modelling of the flow happens in
  workflow 09.
- Documentation only — no code.

## Output & naming

- **Hand-written:** `USER-FLOW-<AREA>.md` in `src/05-USER-FLOW/`; `STEPS.md`/
  `CHECKLIST.md` updates.
- One file per product area, `SCREAMING-SNAKE-CASE`; stories referenced as `US###`;
  dates DD/MM/YYYY.
