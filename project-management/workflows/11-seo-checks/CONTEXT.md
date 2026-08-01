# Workflow: SEO Checks

**Last Updated**: {{DATE}}

## Directory Tree

```text
project-management/workflows/11-seo-checks/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow whenever a story or sprint introduces or modifies a public-facing page.
Run SEO checks before the story's Definition of Done is marked complete.
Also run at the end of any sprint whose SEO flag is not N/A.

## Prerequisites

- [ ] The public-facing page is deployed to a reachable environment (local, staging, or dev)
- [ ] The story's Frontend tasks are complete
- [ ] The page is server-rendered by its Django view — any dynamic content is in the initial HTML (crawlable)

## Key concepts

- SEO output lives in `project-management/src/11-SEO/` — save any audit reports or Lighthouse exports there
- Every public page must pass all items in the SEO Acceptance Criteria section of its story before the story closes
- The `seo` skill automates the core metadata and structured data checks — always run it as the first step
- Lighthouse is the authoritative tool for Core Web Vitals; results must be recorded, not just observed
- The full SEO checklist is at `project-management/docs/SEO-CHECKLIST.md`
- WCAG 2.2 AA is required on all interactive components — `alt` text and heading hierarchy are both SEO and accessibility obligations

## SEO criteria quick reference

| Area              | Target / Rule                                                                                       |
| ----------------- | --------------------------------------------------------------------------------------------------- |
| Title             | Set in the Django template `<head>` (apps.seo, `build_seo`); max 60 chars; contains primary keyword |
| Meta description  | Set in the Django template `<head>` (apps.seo, `build_seo`); max 160 chars; descriptive and unique  |
| Open Graph        | `og:title`, `og:description`, `og:image` all set                                                    |
| Canonical URL     | `<link rel="canonical">` present; no duplicate content                                              |
| JSON-LD           | Correct schema type for page (Article, BreadcrumbList, Organization, etc.)                          |
| Slug / URL        | Lowercase, hyphenated, human-readable, keyword-bearing                                              |
| Sitemap           | Page included in `sitemap.xml`; Celery task triggered if applicable                                 |
| robots.txt        | Page not blocked                                                                                    |
| Core Web Vitals   | LCP < 2.5 s · CLS < 0.1 · INP < 200 ms                                                              |
| Images            | Descriptive `alt` text on every image; no missing `alt`                                             |
| Heading hierarchy | One `<h1>` per page; `<h2>` / `<h3>` in logical order                                               |

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/SEO-CHECKLIST.md` — the canonical checklist; every item gates story closure

### Soft references — consult during execution

- `project-management/src/11-SEO/` — audit reports and Lighthouse exports
- Story file `### SEO Acceptance Criteria` — per-story SEO criteria
- Sprint file `### SEO Acceptance Criteria` — sprint-level SEO rollup
- `code/docs/performance/FRONTEND-PERFORMANCE.md` — Core Web Vitals targets (LCP < 2.5 s, CLS < 0.1, INP < 200 ms)
- `code/docs/ACCESSIBILITY.md` — `alt` text and heading hierarchy are both SEO and WCAG obligations
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — SSR is required for SEO-critical pages; CSR content is not crawled
- `code/docs/URL-STRATEGY.md` — slug conventions for SEO-correct URLs
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — why every page's content is crawlable without JavaScript
