@./CONTEXT.md

# CLAUDE.md — workflows/17-consolidate-design-work/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, the two stages, the five folders in scope — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The design-consolidation gate — once every story is planned, reconcile the per-story
schema, flow, brand, component, and wireframe work accumulated in `USER-STORY-IDEAS/`
into one coherent design under `CONSOLIDATED-IDEAS/`, before any code is written.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `planner` agent (Fable), which
  delegates: `database` for `src/04-DATABASE`, `frontend` for `src/07-COMPONENTS` and
  `src/08-WIREFRAMES`, and takes `src/05-USER-FLOW` and `src/06-BRAND-GUIDE` itself. The
  hard gates — `code/docs/DATABASE.md` and `code/docs/DESIGN-TOKENS.md` — must be read
  before Step 1.
- **Chart it first if it is large.** Consolidating a broad design surface across many stories is
  itself a decision frontier — load `.claude/skills/wayfinder/SKILL.md` and chart it rather than
  attempting one grilling pass over everything. The feature's original map
  (`src/01-FEATURE/MAP-<FEATURE>.md`) is the natural place to resume.
- **Grill first:** Step 1 is a grilling pass (`.claude/skills/grill-with-docs`) — which
  folders are genuinely in play, what counts as a collision, and how aggressively to merge
  — one question at a time, no action until <%DEVELOPER_NAME%> confirms.
- **Model:** Fable throughout — resolving two stories' competing models of the same
  concept is design judgement, not a mechanical merge. Opus only for the mechanical
  tail: re-running a generator, a rename, a cross-link, a status flip.
- **Concrete steps:** inventory every `USER-STORY-IDEAS/` artefact → identify collisions
  and divergences → resolve each to one canonical form, escalating anything
  hard-to-reverse to `14-decisions/` → write `CONSOLIDATED-IDEAS/` → regenerate the brand
  and component deliverables → correct any `STORY-PLAN-US###-*.md` the consolidation
  invalidated → satisfy `CHECKLIST.md`.
- **Definition of done:** every stage-1 artefact is either carried into a consolidated
  artefact or explicitly recorded as superseded; the consolidated set has no unresolved
  duplicate; every affected story plan is corrected; `18-backend-code/` is unblocked.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`agent`/`skills`/`model` frontmatter — read it first (see
  `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Never edit a `USER-STORY-IDEAS/` artefact.** Stage 1 is frozen the moment this
  workflow starts — it is the audit trail of what each story asked for. Consolidation is
  additive: it writes to `CONSOLIDATED-IDEAS/` and cross-links back.
- **Runs once, after every story is planned.** Consolidating with stories still to plan
  means doing it again — and the second pass silently invalidates the first.
- **This workflow unifies; it never adds scope.** A gap discovered here that needs new
  capability is a new user story through `02-story-creation/`, not a quiet addition.
- **Schema first, and schema is the expensive one.** A fragmented schema gets costlier
  with every story that ships on it (`code/docs/DATABASE.md` — constraints in the
  database, scope column with its policy and index, lock-safe migration shape). Visual
  drift is cheap by comparison; do `04-DATABASE` before the design folders.
- **Token-first survives consolidation.** Consolidated design values are DB-canonical
  (`code/docs/DESIGN-TOKENS.md`) — they enter via the `/admin/design-tokens` editor or a
  migration, never as a literal in component CSS.
- **A consolidation that changes a planned shape must correct the plan.** Leaving a
  `STORY-PLAN-US###-*.md` asserting a superseded design is how the whole two-stage model
  fails — the developer codes from the plan, not from here.
- **Generated deliverables are regenerated, never hand-edited** — `brand_guide.py` and
  `components.py` are the source; re-run them.
- Documentation workflow — no code here. Instructional `.md` files ≤ 300 code lines
  (the consolidated artefacts themselves are exempt).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the consolidated artefacts under
  `src/04-DATABASE`, `src/05-USER-FLOW`, `src/06-BRAND-GUIDE`, `src/07-COMPONENTS`, and
  `src/08-WIREFRAMES` → `CONSOLIDATED-IDEAS/`.
- **Produced by following it:** corrections to affected `STORY-PLAN-US###-*.md` files,
  and any new `ADR-###-<TITLE>.md` a hard-to-reverse resolution warrants.
- **Regenerated (never hand-edit):** `brand-guide.tex`/`.pdf` and `components.tex`/`.pdf`.
- Consolidated artefacts `<TYPE>-CONSOLIDATED-<DESCRIPTOR>.md`; descriptors
  `SCREAMING-KEBAB-CASE`; workflow folders `NN-kebab-case/`; dates DD/MM/YYYY.
