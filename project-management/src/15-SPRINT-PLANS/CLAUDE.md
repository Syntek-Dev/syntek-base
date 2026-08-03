@./CONTEXT.md

# CLAUDE.md — src/15-SPRINT-PLANS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(naming, execution-order table, contents schema — imported above) → this file.

## Purpose (one line)

Sprint-level plans — one `{exec-order}-SPRINT-PLAN-{sprint-number}.md` per sprint, written
after the GDPR, security, QA, SEO, and API-design checks are complete; it fixes the goal,
story set, MoSCoW priority, and phased backend → API → frontend → PR sequence, then **feeds
each story to its story plan** in `../16-STORY-PLANS/` (the code master) — per-story
implementation depth lives there, never duplicated here.

## How to work here

- **Routing:** start from `project-management/workflows/15-sprint-plans/`
  (`STEPS.md` + `CHECKLIST.md`); it governs when and how a plan is written. Sizing,
  MoSCoW, and phase-breakdown conventions come from
  `project-management/docs/PLANNING-GUIDE.md`. Use `sprint`
  for the heavier drafting.
- **Model:** Fable to draft a plan (story selection, phasing, Definition of Done);
  Opus for mechanical touches — renaming, re-prefixing execution order, or
  fixing a header.
- **Concrete steps:** copy `00-SPRINT-PLAN-00-TEMPLATE.md` → pull stories from
  `../02-STORIES/` and the matching record in `../03-SPRINTS/SPRINT-##.md` →
  prioritise with MoSCoW → break into phases → link each story to its story plan in
  `../16-STORY-PLANS/` → fold in **sprint-wide** constraint summaries from the
  `09-GDPR`, `10-SECURITY`, `11-QA`, `12-SEO`, `13-API-DESIGN` reviews (field-level
  detail stays in the story plan) → set the Definition of Done → satisfy the workflow
  `CHECKLIST.md`.
- **Definition of done:** file named `<exec-order>-SPRINT-PLAN-<sprint-number>.md`,
  both segments 2-digit zero-padded; stories cross-linked to `US###`; matching
  `SPRINT-##.md` exists; pre-sprint checks reflected; British English, DD/MM/YYYY.

## Guardrails

- **Documentation only** — no code, secrets, or `.env` content. GDPR/security/IDOR
  requirements are _specified_ in the plan and _enforced_ in `code/`; keep them
  consistent with `code/docs/SECURITY.md`.
- **`<exec-order>` ≠ `<sprint-number>`.** The prefix is recommended build sequence, the
  suffix the sprint it plans — they diverge deliberately when a sprint must be built out
  of number order (e.g. an infrastructure or observability sprint pulled early). Do not
  "correct" a deliberate mismatch to match.
- **No per-story implementation depth here.** Models, resolvers, components, and
  field-level GDPR/security belong in the story plan (`../16-STORY-PLANS/`); the sprint
  plan carries only sprint-wide summaries and the story-plans index.
- **Every plan needs a matching `../03-SPRINTS/SPRINT-##.md`** record — the two are
  paired; do not create an orphan plan.
- No new file without going through the workflow; this is a flat leaf folder — do not
  add sub-directories.

## Output & naming

- **Hand-written:** every `##-SPRINT-PLAN-##.md` and the `00-…-TEMPLATE.md`.
- **Generated:** none here — the client-facing `SPRINT-PLANS.pdf` is regenerated one
  level up in `project-management/export/`, never hand-edited.
- Files `<exec-order>-SPRINT-PLAN-<sprint-number>.md` (both 2-digit zero-padded);
  stories referenced as `US###`, sprints as `SPRINT-##`; dates DD/MM/YYYY.
