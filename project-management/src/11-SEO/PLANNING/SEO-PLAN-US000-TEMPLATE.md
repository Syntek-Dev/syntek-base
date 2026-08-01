# SEO Plan — US000 {STORY TITLE}

_Template — copy to `SEO-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]` row and
`{PLACEHOLDER}` with this story's own analysis, and delete this note once populated. This
is the **pre-development** SEO plan for a single story — the per-story SEO acceptance
criteria for its public page(s), set before any code is written; its post-implementation
counterpart is `../IMPLEMENTATION/SEO-IMPL-US000-TEMPLATE.md`._

| Field               | Value                                                  |
| ------------------- | ------------------------------------------------------ |
| **Story**           | US### — {short title}                                  |
| **Date**            | {DD/MM/YYYY}                                           |
| **Sprint**          | SPRINT-## — {sprint name}                              |
| **Public route(s)** | `{/route-path}` (and any variants) — or `SEO: N/A`     |
| **SEO flag**        | Indexable public page / N/A — {one-line reason if N/A} |
| **Status**          | Draft / Reviewed / Signed off                          |

> If **SEO flag = N/A** (the story ships no public URL — e.g. an admin-only screen, a
> backend migration, or an internal API), record the route as `SEO: N/A` with a one-line
> reason in the header and stop. The remaining sections apply only to stories that ship a
> public, indexable page.

---

## 1. SEO acceptance criteria

One row per SEO dimension, measured against `project-management/docs/SEO-CHECKLIST.md`.
Each is a criterion the shipped page must satisfy; the `../IMPLEMENTATION/` record verifies
it against the running build. Replace the `[EXAMPLE]` planned value on every row.

| Dimension                | Requirement                                                   | Target                                    | Planned value                              |
| ------------------------ | ------------------------------------------------------------- | ----------------------------------------- | ------------------------------------------ |
| Title (metadata)         | Unique `<title>`; primary keyword; brand suffix               | ≤ 60 characters                           | [EXAMPLE] `{Page Title} \| {Brand}`        |
| Meta description         | Unique, descriptive, action-oriented                          | ≤ 160 characters                          | [EXAMPLE] `{one-sentence page summary}`    |
| Open Graph               | `og:title`, `og:description`, `og:image`, `og:url`, `og:type` | All present; `og:type` correct            | [EXAMPLE] `og:type = website`              |
| Twitter Card             | `twitter:card` + title / description / image                  | `summary_large_image`                     | [EXAMPLE] `summary_large_image`            |
| JSON-LD structured data  | Correct schema.org type for the page                          | Valid; renders in `<head>`                | [EXAMPLE] `@type: {Article}`               |
| Canonical URL            | Absolute, self-referential `<link rel="canonical">`           | No duplicate-content ambiguity            | [EXAMPLE] `{https://…/route-path}`         |
| Robots directives        | index/follow (or noindex,nofollow for private)                | Public → `index, follow`                  | [EXAMPLE] `index, follow`                  |
| Sitemap inclusion        | Route listed in `sitemap.xml`                                 | Included; regeneration triggered          | [EXAMPLE] `/{route} in sitemap-static.xml` |
| Image alt + optimisation | Descriptive `alt` on every image; modern format               | No missing alt; WebP/AVIF, lazy, `srcset` | [EXAMPLE] `{alt for hero image}`           |
| Heading hierarchy        | Single `<h1>`; logical `<h2>` / `<h3>`                        | One H1; no skipped levels                 | [EXAMPLE] `H1 "{page heading}"`            |
| Core Web Vitals          | Field/lab metrics within thresholds                           | LCP < 2.5 s · CLS < 0.1 · INP < 200 ms    | [EXAMPLE] `LCP target {x.x}s`              |
| Internal linking         | Contextual links to / from related pages                      | ≥ {n} in-content internal links           | [EXAMPLE] `links to /{related-route}`      |
| AI discoverability       | `llms.txt` entry / clean server-rendered content              | Present where relevant / N/A              | [EXAMPLE] `listed in llms.txt`             |

_Keep every dimension row — set a concrete planned value for each. Any dimension that
genuinely does not apply to this page is marked `N/A — {reason}`, not deleted. Where the
story declares SEO intent but leaves the target unspecified, raise it as an `[OPEN]` gap in
§3 rather than guessing._

## 2. Robots & sitemap handling

How crawling and indexing are set for this route specifically.

- **Robots:** {public → `index, follow`; or a private/utility route → `noindex, nofollow`
  with the reason, e.g. a thank-you or preview route that must not surface in search}.
- **Sitemap:** {which sitemap segment the route joins (e.g. `sitemap-static.xml`,
  `sitemap-blog.xml`), and whether inclusion is static or regenerated on publish}.
- **Crawler notes:** {any AI-crawler allowance/disallowance, canonical consolidation, or
  pagination handling this route needs — else "None."}.

## 3. Open gaps

`SEO-GAP-n` items — places where the story declares SEO intent but leaves it unspecified,
or where a target cannot yet be set. Tag each `[OPEN]` or `[RESOLVED]`.

- **SEO-GAP-1** `[OPEN]` — {intent declared but unspecified, e.g. "the story says 'social
  share preview' but no `og:image` asset is specified for this page"}.
- **SEO-GAP-2** `[RESOLVED]` — {gap}; target set in this plan / fed back to `US###.md` on
  {DD/MM/YYYY}.

_Every `[OPEN]` gap must be closed — a concrete target set here, fed back into `US###.md`,
or tracked in `GAPS.md` — before the page ships. If none were found, state "None identified."_

---

## Cross-references

- `../IMPLEMENTATION/SEO-IMPL-US000-TEMPLATE.md` — the post-implementation record that
  verifies this plan against the shipped page
- `../../01-STORIES/US###.md` — the story whose `### SEO Acceptance Criteria` this plan sets
- `project-management/docs/SEO-CHECKLIST.md` — the governing SEO & AI discoverability checklist
- `project-management/workflows/11-seo-checks/` — the workflow that produces this plan
- `code/docs/URL-STRATEGY.md` — slug conventions the route criteria assume. Every public page
  is a Django template rendered server-side, so the crawlable markup is the response itself;
  HTMX swaps and Alpine state must never carry SEO-critical content
