@./CONTEXT.md

# CLAUDE.md — workflows/11-seo-checks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, SEO criteria quick reference — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The SEO verification workflow — run whenever a story or sprint introduces or modifies
a public-facing page, checking metadata, structured data, and Core Web Vitals before
the story's Definition of Done is marked complete.

## How to work here

- **Routing:** run `STEPS.md` in order; **first step is always the
  `seo` agent** (Opus) for metadata and structured-data checks. The
  hard gate `docs/SEO-CHECKLIST.md` gates story closure. Prerequisite: the page is
  deployed to a reachable environment and server-rendered by its Django view (any
  dynamic content present in the initial HTML, since every page is server-rendered).
- **Model:** Opus for audits and remediation and mechanical touches
  (recording a Lighthouse export, status flips).
- **Concrete steps:** run `seo` → verify title/description/OG/
  canonical/JSON-LD/slug/sitemap/robots against the quick reference → run Lighthouse
  for Core Web Vitals (LCP < 2.5 s · CLS < 0.1 · INP < 200 ms) and **record** results
  into `src/11-SEO/` → satisfy `CHECKLIST.md` and the story's `### SEO Acceptance
Criteria`.
- **Definition of done:** every SEO-checklist item passes; Lighthouse results recorded
  (not just observed); `alt` text and heading hierarchy verified for WCAG + SEO.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Lighthouse is authoritative for Core Web Vitals — results must be recorded**,
  never merely observed.
- **SSR is required for SEO-critical pages** — CSR content is not crawled
  (`code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md`).
- Every public page passes all SEO Acceptance Criteria before the story closes; `alt`
  text and heading hierarchy are both SEO **and** WCAG 2.2 AA obligations.
- Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; audit reports and Lighthouse exports
  saved under `src/11-SEO/` (`PLANNING/`, `IMPLEMENTATION/`), linked to their `US###`.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
