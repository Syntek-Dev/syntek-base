@./CONTEXT.md

# CLAUDE.md — workflows/15-sprint-plans/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The detailed sprint-planning workflow — after GDPR, security, and QA checks are
complete, select and sequence the stories entering a sprint into a `SPRINT-PLAN-##.md`
in `src/15-SPRINT-PLANS/`, assigning each to the backend → API → frontend phase chain.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `sprint`
  skill (Fable). The hard gate `docs/PLANNING-GUIDE.md` (MoSCoW + phase
  breakdown) must be read before Step 1. Prerequisites: GDPR
  (`workflows/09-gdpr-compliance`), security (`09`), and QA (`10`) all complete, and
  every in-scope story with full acceptance criteria.
- **Model:** Fable for the plan; Opus for mechanical touches (version-header
  bumps, status flips).
- **Concrete steps:** read `docs/PLANNING-GUIDE.md` → select stories, prioritise
  MoSCoW, record goal, phase breakdown, acceptance criteria, QA scenarios, and
  definition of done per story → write `SPRINT-PLAN-##.md` into `src/15-SPRINT-PLANS/`
  → satisfy `CHECKLIST.md`.
- **Definition of done:** the plan is the single source of truth for what is in scope
  and how it is sequenced; it unlocks story planning and the development phases (`workflows/16`→`22`).
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **A feature is not codeable until workflows 02–16 are complete** — this plan and the
  story plan that follows it close the design phase and open implementation.
- Pre-development artefacts (SEO, API design) required per `CHECKLIST.md` must exist
  before a story enters the plan.
- Development phases run in strict order: backend → API → frontend → PR & review.
- Documentation workflow — no code here. Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the plan `SPRINT-PLAN-##.md`
  (2-digit zero-padded) under `src/15-SPRINT-PLANS/`, cross-linked to its `SPRINT-##`
  and constituent `US###`.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
