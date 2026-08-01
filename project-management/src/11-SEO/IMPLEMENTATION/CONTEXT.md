# project-management/src/11-SEO/IMPLEMENTATION

Post-implementation SEO verification records — **one per user story**. Each record
confirms, with evidence, that a story's SEO acceptance criteria were met on the shipped
public page(s), and closes the gaps from its pre-development plan in `../PLANNING/`.

## Directory Tree

```text
project-management/src/11-SEO/IMPLEMENTATION/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
├── SEO-IMPL-US000-TEMPLATE.md        ← copy this to record a story's verification
└── SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md  ← one record per story with a public route
```

## File naming

```text
SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
```

Example: `SEO-IMPL-US000-HOME-PAGE-01-01-2026.md`. Prefix `SEO-IMPL-`, three-digit
zero-padded story number, `SCREAMING-KEBAB-CASE` descriptor, then the date DD-MM-YYYY.

## When to create a file here

Write a record during `project-management/workflows/20-pr-and-review/`, after a story's
code ships and before the story closes. Copy `SEO-IMPL-US000-TEMPLATE.md`, open the
story's plan in `../PLANNING/SEO-PLAN-US###-*.md`, and verify each planned SEO dimension
against the running build.

## What belongs in each record

- Header table: story (US###), date, public route(s), Lighthouse SEO score, and outcome
  (Pass / Pass with follow-ups / Blocked), with a link to the pre-development plan
- Per-dimension verification — metadata, Open Graph / Twitter Card, JSON-LD, canonical,
  robots, sitemap, image alt, heading hierarchy, internal linking, `llms.txt` — each
  marked Pass / Fail / Deviation with the rendered tag or measured value as evidence
- Core Web Vitals measured (LCP < 2.5 s, CLS < 0.1, INP < 200 ms) versus targets
- Each plan gap closed **with evidence**, and any justified deviation plus follow-ups

## The N/A path

A story that ships no public URL records `SEO: N/A` in the header with a one-line reason
(e.g. a backend-only migration) and needs nothing further — no dimension tables required.

## Cross-references

- `SEO-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../PLANNING/` — the pre-development plans these records verify
- `../CONTEXT.md` — the SEO folder overview and the per-story PLANNING/IMPLEMENTATION split
- `project-management/workflows/20-pr-and-review/` — where these records are written
- `project-management/docs/SEO-CHECKLIST.md` — the governing SEO standard

**Last Updated**: {{DATE}}
