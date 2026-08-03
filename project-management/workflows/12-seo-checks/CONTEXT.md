# Workflow 12 — SEO Checks

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/12-seo-checks/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## Purpose

Set a story's **SEO acceptance criteria before its page is built** — the per-dimension targets
that `20-frontend-code` implements against and `21-implementation-documentation` verifies. The
output is `SEO-PLAN-US###-<DESCRIPTOR>.md` in `src/12-SEO/PLANNING/`.

## This workflow plans — it does not verify

The split matters, and it used to be wrong here. This gate sits in the **specify tier**, inside
the per-story loop — it runs _before any code exists_, so there is no page to audit and no
Lighthouse score to record. Requiring a deployed page at planning time made this workflow
impossible to run in its own slot.

| Concern                                                           | Owner                             |
| ----------------------------------------------------------------- | --------------------------------- |
| Per-dimension SEO targets, before the page exists                 | **here** (`12-seo-checks`)        |
| Building the page to those targets                                | `20-frontend-code`                |
| Auditing the built page, Lighthouse, the `IMPLEMENTATION/` record | `21-implementation-documentation` |

## When to use this

- During a story's pass through the specify tier, when it introduces or changes a public page
- Before `14-decisions` closes the story's loop

## When NOT to use this

- To verify a built page — that is `21-implementation-documentation`
- For a story with no public URL — record `SEO: N/A` with a reason and move on

## Prerequisites

- [ ] The story exists in `src/02-STORIES/` with acceptance criteria
- [ ] The story's wireframes exist (`src/08-WIREFRAMES/USER-STORY-IDEAS/`) — page structure drives
      heading hierarchy and Core Web Vitals targets
- [ ] `project-management/docs/SEO-CHECKLIST.md` read

## Key concepts

- **Targets, not measurements.** Every dimension gets a concrete planned value — the intended
  title, the schema type, the robots handling — not a box to tick later.
- **A story with no public URL records `SEO: N/A`** with a one-line reason and needs nothing
  further. Do not invent criteria for a page that will not exist.
- **`SEO-GAP-n` for declared-but-unspecified intent.** Where a story says "this should rank" with
  no stated target, raise a gap and resolve it — into this plan or back into `US###.md` — before
  the story clears `14-decisions`.
- **SSR is assumed.** Every page is server-rendered, so content is crawlable without JavaScript
  (`code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md`). A target that depends on client-side
  rendering is a target that will not be met.

## SEO criteria quick reference

| Area              | Target / Rule                                                              |
| ----------------- | -------------------------------------------------------------------------- |
| Title             | Set via `apps.seo` `build_seo`; max 60 chars; contains the primary keyword |
| Meta description  | Set via `build_seo`; max 160 chars; descriptive and unique                 |
| Open Graph        | `og:title`, `og:description`, `og:image` all planned                       |
| Canonical URL     | `<link rel="canonical">` planned; no duplicate content                     |
| JSON-LD           | Schema type chosen for the page (Article, BreadcrumbList, Organization, …) |
| Slug / URL        | Lowercase, hyphenated, human-readable, keyword-bearing                     |
| Sitemap           | Inclusion decided; Celery regeneration noted if applicable                 |
| robots.txt        | Indexing decision stated explicitly                                        |
| Core Web Vitals   | Budgets set: LCP < 2.5 s · CLS < 0.1 · INP < 200 ms                        |
| Images            | Alt-text intent stated per image role                                      |
| Heading hierarchy | One `<h1>`; `<h2>`/`<h3>` order planned from the wireframe                 |

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/SEO-CHECKLIST.md` — the canonical checklist these targets are set from

### Soft references — consult during execution

- `project-management/src/12-SEO/PLANNING/` — where the plan lands
- `project-management/src/08-WIREFRAMES/USER-STORY-IDEAS/` — the page structure being planned for
- Story file `### SEO Acceptance Criteria` — kept consistent with this plan
- `code/docs/performance/FRONTEND-PERFORMANCE.md` — the Core Web Vitals budgets
- `code/docs/URL-STRATEGY.md` — slug conventions
- `code/docs/ACCESSIBILITY.md` — alt text and heading order are SEO **and** WCAG obligations
- `project-management/workflows/21-implementation-documentation/` — verifies these targets on the
  built page and writes the `IMPLEMENTATION/` record
