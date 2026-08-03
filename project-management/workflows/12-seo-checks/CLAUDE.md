@./CONTEXT.md

# CLAUDE.md — workflows/12-seo-checks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(plan-not-verify, the criteria quick reference — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The SEO **planning** gate — set a story's per-dimension SEO targets before its page is built,
writing `SEO-PLAN-US###-<DESCRIPTOR>.md` into `src/12-SEO/PLANNING/`.

## How to work here

- **Routing:** run `STEPS.md` in order with the `seo` agent. The hard gate
  `docs/SEO-CHECKLIST.md` must be read before Step 1. Inputs: the story
  (`src/02-STORIES/`) and its wireframes (`src/08-WIREFRAMES/USER-STORY-IDEAS/`).
- **Grill first:** open with a grilling pass — the primary keyword, the schema type, whether the
  page should be indexed at all — one question at a time (`.claude/CLAUDE.md` §10). These are
  judgement calls, and getting them wrong is expensive once the page ships and ranks.
- **Model:** Fable — choosing a schema type, a canonical strategy, and an indexing posture is
  substantive SEO judgement, not mechanical verification. (This gate previously ran on Opus
  because it _was_ verification; it no longer is.)
- **Concrete steps:** confirm the story has a public URL → copy `SEO-PLAN-US000-TEMPLATE.md` →
  set a concrete planned value on every dimension → state the route's robots/sitemap handling →
  raise any `SEO-GAP-n` → keep the story's `### SEO Acceptance Criteria` in step.
- **Definition of done:** every dimension has a target or a justified `N/A`; every `[OPEN]` gap
  is resolved or fed back into `US###.md`; the plan is consistent with the story.

## Guardrails

- **Never audit a built page here.** There is no page yet — this gate runs inside the per-story
  specify loop, before `20-frontend-code`. Lighthouse scores, rendered-tag checks, and the
  `IMPLEMENTATION/` record all belong to `21-implementation-documentation`.
- **A story with no public URL records `SEO: N/A`** with a reason. Inventing criteria for a page
  that will not exist creates a checklist nobody can satisfy.
- **Targets must be concrete.** "Good meta description" is not a target; the intended text, or a
  rule that produces it, is. A vague target cannot be verified later, which is the same as having
  none.
- **Do not plan for client-side rendering.** Every page is server-rendered; SEO-critical content
  must be in the initial HTML (`code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md`).
- **Alt text and heading order are WCAG obligations too** — plan them once, satisfy both
  (`code/docs/ACCESSIBILITY.md`).
- Documentation workflow — no code. Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the plan `SEO-PLAN-US###-<DESCRIPTOR>.md` under
  `src/12-SEO/PLANNING/`, linked to its `US###`.
- **Not produced here:** the `IMPLEMENTATION/` record and any Lighthouse export — those are
  written by `21-implementation-documentation`.
- Documentation `SCREAMING-SNAKE-CASE.md`; descriptors `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY.
