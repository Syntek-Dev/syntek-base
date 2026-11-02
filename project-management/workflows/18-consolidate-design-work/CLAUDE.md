@./CONTEXT.md

# CLAUDE.md — workflows/18-consolidate-design-work/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, the two stages, the five folders in scope — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The design-consolidation gate — once every story is planned, reconcile the per-story
schema, flow, brand, component, and wireframe work accumulated in `USER-STORY-IDEAS/`
into one coherent design under `CONSOLIDATED-IDEAS/`, before any code is written.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `planner` skill, which
  delegates: `database` for `src/04-DATABASE`, `frontend` for `src/07-COMPONENTS` and
  `src/08-WIREFRAMES`, and takes `src/05-USER-FLOW` and `src/06-BRAND-GUIDE` itself. The
  hard gates — `code/docs/DATABASE.md` and `code/docs/DESIGN-TOKENS.md` — must be read
  before Step 1.
- **Chart it first if it is large.** Consolidating a broad design surface across many stories is
  itself a decision frontier — load `.claude/skills/wayfinder/SKILL.md` and chart it rather than
  attempting one grilling pass over everything. The feature's original map
  (`src/01-FEATURE-MAPS/MAP-<FEATURE>.md`) is the natural place to resume.
- **Measure, then grill:** Step 1 measures which of the five folders are in play — never asks
  — then grills (`.claude/skills/grill-with-docs`) what counts as a collision and how
  aggressively to merge
  (`.claude/skills/grilling/SKILL.md` → _A decision already recorded is a fact_).
- **Model:** Opus throughout — resolving two stories' competing models of the same
  concept is design judgement, not a mechanical merge; only the tail is mechanical:
  re-running a generator, a rename, a cross-link, a status flip.
- **Concrete steps:** inventory every `USER-STORY-IDEAS/` artefact → identify collisions
  and divergences → resolve each to one canonical form, escalating anything
  hard-to-reverse to `15-decisions/` → write `CONSOLIDATED-IDEAS/` → regenerate the brand
  and component deliverables → correct any `<exec-order>-STORY-PLAN-US###-*.md` the
  consolidation invalidated → set every manual testing guide's `Flow` column and correct the rows
  the consolidation invalidated (`STEPS.md` Step 7) → satisfy `CHECKLIST.md`.
- **Definition of done:** every stage-1 artefact is either carried into a consolidated
  artefact or explicitly recorded as superseded; the consolidated set has no unresolved
  duplicate; every affected story plan is corrected; every manual testing guide cites the
  consolidated steps in its `Flow` column, its invalidated rows corrected;
  `19-backend-code/` is unblocked.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`skills`/`model` frontmatter — read it first (see
  `.claude/CLAUDE.md` Section 2.5).

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
- **Token-first survives consolidation.** Consolidated design values are DB-canonical; how a
  value enters the token layer is `code/docs/DESIGN-TOKENS.md`. Never a literal in component
  CSS.
- **A consolidation that changes a planned shape must correct the plan — and the manual testing
  guide.** Leaving a `<exec-order>-STORY-PLAN-US###-*.md` asserting a superseded design is how the
  whole two-stage model fails — the developer codes from the plan, not from here — and a guide
  row asserting one becomes a test of the wrong thing at the Red phase. A guide row is corrected
  in place and never renumbered (`src/18-TESTS/MANUAL/CLAUDE.md`).
- **Generated deliverables are regenerated, never hand-edited** — `brand_guide.py` and
  `components.py` are the source; re-run them.
- Documentation workflow — no code here. Instructional `.md` files ≤ 300 code lines
  (the consolidated artefacts themselves are exempt).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the consolidated artefacts under
  `src/04-DATABASE`, `src/05-USER-FLOW`, `src/06-BRAND-GUIDE`, `src/07-COMPONENTS`, and
  `src/08-WIREFRAMES` → `CONSOLIDATED-IDEAS/`.
- **Produced by following it:** corrections to affected `<exec-order>-STORY-PLAN-US###-*.md`
  files; the `Flow` cells and corrected rows of every `src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md`;
  and any new `ADR-###-<TITLE>.md` a hard-to-reverse resolution warrants.
- **Regenerated (never hand-edit):** `brand-guide.tex`/`.pdf` and `components.tex`/`.pdf`.
- Consolidated artefacts `<TYPE>-CONSOLIDATED-<DESCRIPTOR>.md`; descriptors
  `SCREAMING-KEBAB-CASE`; workflow folders `NN-kebab-case/`; dates DD/MM/YYYY.

<!-- UPDATED 08/09/2026. All three story-plan filename patterns above — in _Concrete steps_, in
     the guardrail on superseded designs, and in _Output & naming_ — gained the `<exec-order>-`
     prefix. Superseded form, quoted without backticks so no dead name is recorded as a fresh
     citation: "STORY-PLAN-US###-*.md". The prefix is the story's 2-digit position in the settled
     build order across the whole backlog, and is RENUMBERED whenever build order changes, so a
     correction made by this workflow can rename the file it corrects. This is the OPPOSITE of
     the sibling rule in `project-management/src/16-SPRINT-PLANS/CLAUDE.md`: a sprint plan
     carries TWO numbers and a mismatch between them is deliberate information that must never be
     "corrected"; a
     story plan carries ONE, so a drifted prefix says nothing and IS a defect. Naming is owned by
     `project-management/src/17-STORY-PLANS/CLAUDE.md`; this file only consumes it. -->

<!-- UPDATED 30/09/2026. This workflow gained a duty over the manual testing guides in
     `project-management/src/18-TESTS/MANUAL/`: set each guide's Flow column against the
     consolidated step numbers, and correct any row the consolidation invalidated, in the same
     Step 7 pass that already corrects story plans. Settled by the grilling pass of 30/09/2026.
     It lands here because the guide is now authored at 17-story-plans, before any consolidated
     flow exists, with Flow set to a dash throughout — and because the Red phase reads the guide
     as well as the plan, so a guide left asserting a superseded design undoes the consolidation
     exactly as a stale plan does. Every rule the pass follows — the citation format, the
     correction note, the permanent row IDs — is owned by
     "../../src/18-TESTS/MANUAL/CLAUDE.md"; this file only runs them. -->
