# project-management/src/12-SEO/PLANNING

Pre-development SEO plans — **one plan per user story**. Each plan sets the SEO acceptance
criteria for a story's public page(s) before any code is written: metadata, Open Graph and
Twitter Card tags, JSON-LD structured data, canonical URL, robots directives, sitemap
inclusion, image alt text, heading hierarchy, Core Web Vitals targets, internal linking,
and AI discoverability — all measured against `project-management/docs/SEO-CHECKLIST.md`.

## Directory Tree

```text
project-management/src/12-SEO/PLANNING/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules for this folder
├── SEO-PLAN-US000-TEMPLATE.md     ← copy this to start a story's SEO plan
└── SEO-PLAN-US###-<DESCRIPTOR>.md ← one plan per story that ships a public page
```

## How it works

A plan is tied to a story, mirroring its post-implementation counterpart in
`../IMPLEMENTATION/`. Copy `SEO-PLAN-US000-TEMPLATE.md` to `SEO-PLAN-US###-<DESCRIPTOR>.md`
and complete it: the header (story, date, public route, SEO flag), the per-dimension SEO
acceptance-criteria table, the route-specific robots/sitemap handling, and any `SEO-GAP-n`
items where SEO intent is declared but unspecified. Those criteria are then verified —
against the running build — in the matching `../IMPLEMENTATION/SEO-IMPL-US###-*.md` record.

The plan sets, and stays consistent with, the story's own `### SEO Acceptance Criteria`
section: an `[OPEN]` gap here is either resolved in this plan or fed back into
`../../02-STORIES/US###.md` before the page is built.

## The N/A path

A story that ships no public URL — an admin-only screen, a backend migration, an internal
API — records **`SEO: N/A`** with a one-line reason in the header and needs nothing further.
There is no cross-cutting by-scope report folder; SEO is planned per story.

## When to write one

- When a story introduces or modifies a public-facing page
- When running `project-management/workflows/12-seo-checks/`
- When setting a story's per-page SEO acceptance criteria before development begins

## Cross-references

- `SEO-PLAN-US000-TEMPLATE.md` — the per-story SEO plan template
- `../IMPLEMENTATION/` — the post-implementation records that verify these plans
- `../CONTEXT.md` — the 12-SEO folder overview and the per-story SEO lifecycle
- `../../02-STORIES/` — the story whose SEO acceptance criteria this plan sets
- `project-management/docs/SEO-CHECKLIST.md` — the governing SEO & AI discoverability checklist

**Last Updated**: <%DATE%>
