@./CONTEXT.md

# CLAUDE.md — src/11-SEO/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the per-story PLANNING/IMPLEMENTATION split, SEO dimensions — imported above) → this
file → the target sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The SEO artefact store, per story — a `PLANNING/` pre-development SEO plan and an
`IMPLEMENTATION/` post-implementation SEO record that gate a public page from design to a
verified, indexable feature.

## How to work here

- **Routing:** never write here free-hand — `PLANNING/` plans come from
  `workflows/11-seo-checks/` (after wireframe sign-off); `IMPLEMENTATION/` records come
  from `workflows/20-pr-and-review/`. Both governed by `docs/SEO-CHECKLIST.md`; run the
  heavier analysis through the `seo` agent.
- **Model:** Fable for the SEO reasoning (acceptance criteria, gap analysis, verification
  judgement); Opus for mechanical touches — dropping a Lighthouse `.json`, filing,
  renaming, date-stamping.
- **Concrete steps:** pick the phase → copy that folder's `US000-TEMPLATE.md` to
  `SEO-<PLAN|IMPL>-US###-<DESCRIPTOR>.md` → complete every SEO dimension for the story's
  route(s) → cross-link the `US###` and the paired plan/record → satisfy the workflow
  `CHECKLIST.md`.
- **Definition of done:** artefact in the correct phase folder, named to convention,
  linked to its `US###`; every SEO dimension addressed or marked N/A with a reason;
  British English; DD/MM/YYYY dates.

## Guardrails

- **Documentation only** — no code, secrets, or `.env` content. SEO obligations are
  _specified_ here and _enforced_ in `code/` (metadata, sitemap, JSON-LD, robots); keep
  them consistent with `docs/SEO-CHECKLIST.md` and `code/docs/RENDERING.md`.
- **PLANNING/ precedes IMPLEMENTATION/** — pre-development targets go in the plan,
  verified outcomes in the record; the record answers the plan, never backfills it.
- **Per story** — one plan and one record per story with a public route, tied to a
  `US###`; there is no cross-cutting report folder. Every new directory needs a
  `CONTEXT.md`; instructional files stay ≤ 300 code lines.

## Output & naming

- **Hand-written:** the per-story SEO plans and records under the two sub-folders.
- **Generated (tool output, never hand-edit):** Lighthouse `.json` exports that may
  accompany an `IMPLEMENTATION/` record — regenerate from the audit rather than editing.
- `PLANNING/SEO-PLAN-US###-<DESCRIPTOR>.md`; `IMPLEMENTATION/SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`;
  descriptors SCREAMING-KEBAB-CASE; dates DD/MM/YYYY.
