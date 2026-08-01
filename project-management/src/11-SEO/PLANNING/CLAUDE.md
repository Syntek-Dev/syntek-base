@./CONTEXT.md

# CLAUDE.md — src/11-SEO/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(per-story plan structure, the N/A path, when to write one — imported above) → this file.

## Purpose (one line)

Pre-development SEO plans — one per user story — setting the per-dimension SEO acceptance
criteria for a story's public page(s) before any code is written.

## How to work here

- **Routing:** plans are produced by `project-management/workflows/11-seo-checks/` using
  the `seo` agent, against a story in `../../01-STORIES/` and its wireframe, governed by
  `project-management/docs/SEO-CHECKLIST.md`. Read a story's plan before implementing it.
- **Model:** Fable — setting per-dimension acceptance criteria (metadata targets, schema
  type, robots/sitemap strategy, Core Web Vitals budgets) is substantive SEO judgement;
  Opus only for a date-header bump or a rename.
- **Concrete steps:** copy `SEO-PLAN-US000-TEMPLATE.md` → `SEO-PLAN-US###-<DESCRIPTOR>.md`
  → record the public route and SEO flag → set a concrete planned value on every dimension
  row → state the route's robots/sitemap handling → raise unspecified intent as an `[OPEN]`
  `SEO-GAP-n` → cross-link the `US###` and the paired `../IMPLEMENTATION/` record.
- **Definition of done:** every dimension has a target or a justified `N/A`; each `[OPEN]`
  gap is closed or fed back into `US###.md`; the route's robots/sitemap handling is stated;
  British English; DD/MM/YYYY dates.

## Guardrails

- **A story with no public URL records `SEO: N/A`** with a one-line reason in the header
  and needs nothing further — do not invent criteria for a page that does not exist.
- These are **pre-development** plans — the criteria are _specified_ here and _verified_
  against the build in `../IMPLEMENTATION/`; keep them consistent with
  `project-management/docs/SEO-CHECKLIST.md` and the story's `### SEO Acceptance Criteria`.
- **Documentation only — no code, secrets, or `.env` content.** Lighthouse `.json` exports
  and measured results belong in the `../IMPLEMENTATION/` record, not here.
- One plan per story; do not batch multiple stories into one file. There is no cross-cutting
  by-scope report folder — SEO is planned per story.

## Output & naming

- **Hand-written:** `SEO-PLAN-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Generated:** none.
- Filename descriptor SCREAMING-KEBAB-CASE; story `US###`; dates DD/MM/YYYY.
