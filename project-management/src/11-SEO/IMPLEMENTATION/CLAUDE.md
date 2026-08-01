@./CONTEXT.md

# CLAUDE.md — src/11-SEO/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each record, the N/A path — imported above) → this file.

## Purpose (one line)

Post-implementation SEO records — one per story with a public page, verifying its SEO
acceptance criteria against the shipped build and closing its `../PLANNING/` plan with evidence.

## How to work here

- **Routing:** written during `project-management/workflows/20-pr-and-review/` (or
  `workflows/11-seo-checks/` when auditing a shipped route), using the `seo` agent against
  the story's plan in `../PLANNING/SEO-PLAN-US###-*.md` and `docs/SEO-CHECKLIST.md`.
- **Model:** Fable for the SEO verification judgement (metadata, structured data,
  crawlability, Core Web Vitals against targets); Opus for the mechanical touches —
  dropping a Lighthouse `.json`, filing, renaming, date-stamping.
- **Concrete steps:** copy `SEO-IMPL-US000-TEMPLATE.md` →
  `SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the story's plan → verify every SEO
  dimension against the running build, record the Lighthouse SEO score and Core Web
  Vitals, close each plan gap with evidence, and justify any deviation.
- **Definition of done:** every SEO dimension is Pass / Fail / Deviation with evidence (or
  the whole record is `SEO: N/A` with a reason); Core Web Vitals measured or a follow-up
  raised; the `US###`, plan-doc link, route, and date are present; British English; DD/MM/YYYY.

## Guardrails

- **Close a plan gap only with evidence** — never mark a tag, JSON-LD block, canonical, or
  Core Web Vital done without pointing at the rendered output or the measured value (or a
  `GAPS.md` entry with a target story).
- **Documentation only — no code, secrets, or `.env` content.** This folder _records_ what
  shipped; the fixes live in `code/`. Keep claims consistent with `docs/SEO-CHECKLIST.md`
  and `code/docs/RENDERING.md`.
- **Post-development phase only** — pre-development targets belong in the sibling
  `../PLANNING/` folder; the record verifies the plan, never backfills it.
- One record per story; do not batch multiple stories into a single file, and do not
  pre-create stubs for unstarted stories.

## Output & naming

- **Hand-written:** one `SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per verified story,
  from the template.
- **Generated (tool output, never hand-edit):** a `LIGHTHOUSE-<US###>-<ROUTE>-DD-MM-YYYY.json`
  export may accompany the record — regenerate from the audit rather than editing.
- Filename descriptor `SCREAMING-KEBAB-CASE`; date `DD-MM-YYYY`; story `US###`.
