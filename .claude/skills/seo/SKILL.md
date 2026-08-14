---
name: seo
description: >-
  Wire technical SEO and AI discoverability into <%PROJECT_NAME%>'s public pages — the per-page
  head through `build_seo()`, JSON-LD structured data, canonical URLs, and the robots, sitemap
  and llms.txt views. Load when a public page or feature needs its discoverability wiring, or
  the marketing pages need an SEO pass. Not building the page or its components (`frontend`),
  not the service data a JSON-LD builder reads (`backend`), not writing the page copy, and not
  the per-page requirements list itself (`project-management/docs/SEO-CHECKLIST.md`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-htmx-templates
---

# Wire Discoverability (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable wiring task whose output is head metadata,
structured data and crawler configuration).

**All of it is server-rendered by Django. There is no client-side metadata layer.** The
per-page head is built by `apps.marketing.seo.build_seo()` and rendered through the
`_seo_head.html` partial; JSON-LD comes from the `seo.py` builders; robots, sitemap and
llms.txt are the Django views in `apps/core/views/seo.py`.

---

## The brief arrives settled

A fork cannot ask, so three values must be in the brief:

1. **The production domain** — canonical URLs and `og:url` are built from it, and a literal
   localhost shipped to production is the failure this exists to prevent. Check the environment
   and existing config first; only ask when it is genuinely absent.
2. **The schema type per page** — `Organization` is the default; `Article`, `Service`,
   `FAQPage`, `BreadcrumbList` and `LocalBusiness` are the ones worth probing for.
3. **The default Open Graph image** — the fallback social-share asset.

**Locale is fixed and never raised:** `lang="en-GB"`, `og:locale="<%LOCALE%>"`. Where the three
above are open, that is a `grilling` pass run inline first.

## What to wire

- **Metadata** — title, description, canonical and robots directives through **one
  `build_seo()` call per page**; the view passes the returned dict to the template and
  `_seo_head.html` renders the tags.
- **Open Graph and Twitter Cards** — emitted by `_seo_head.html` from the same dict, with image
  dimensions and alt text.
- **JSON-LD structured data** — server-rendered `<script type="application/ld+json">` from the
  `seo.py` builders, with dynamic fields sourced from the domain services (SSR), never the JSON
  API.
- **robots.txt, sitemap, llms.txt** — the `apps/core/views/seo.py` views. Allow the AI crawlers
  (GPTBot, ClaudeBot, PerplexityBot, Google-Extended). **Disallow `/admin/` and `/portal/`** —
  the admin and the client portal are private and must never be indexed.
- **The body's shape** — BLUF structure, question-format headings, FAQ and comparison blocks,
  and "last updated" timestamps. The method is
  `code/docs/discoverability/CONTENT-STRUCTURE.md`.

> **`llms.txt` is not a discoverability lever, and this skill does not own that fact.** Google
> states that AI Overviews and AI Mode need no additional machine-readable file and **no
> optimisation beyond ordinary indexation**. `llms.txt` is still shipped — for **agent
> consumption** (IDE agents, MCP clients), per `code/docs/discoverability/ROOT-SURFACE.md` § 1.
> Everything else above is ordinary SEO and survives unchanged. The doctrine lives in the
> guide; this routes to it. **That the opposite claim sat undetected in a prompt for months is
> the argument for routing** — prompt-only knowledge is reachable only by whoever routes there,
> so nobody reviews it.

## Guardrails

- **Critical content is server-rendered** and never gated behind client JavaScript
  (`code/docs/RENDERING.md`).
- **`/admin/` and `/portal/` are excluded** from the sitemap and disallowed in robots.
- Canonical and `og:url` use the production domain **from configuration** — never a literal.
- Verification tokens and API keys are environment variables, never hardcoded.
- Titles, meta descriptions and OG text are copy: they follow `how-to/src/BRAND-VOICE.md` —
  British English, no superlatives, the stated cadence.

## Definition of done

Every `SEO-CHECKLIST.md` item for the touched pages done or explicitly deferred with a reason;
metadata, canonical, OG/Twitter and the applicable JSON-LD present and server-rendered through
`build_seo()` + `_seo_head.html`; the robots, sitemap and llms.txt views current, with the
private prefixes excluded and the AI crawlers allowed; British English throughout.

## Handoff

Report in this shape, then name what is owed:

```text
## SEO: [page / feature]
Metadata:   title · description · canonical · OG · Twitter  (build_seo → _seo_head.html)
Structured: [Organization | Article | FAQ | Breadcrumb | …]
Crawler:    apps/core/views/seo.py — robots · sitemap · llms.txt  (admin/portal excluded)
Body:       BLUF · question headings · last-updated
Files:      [changed paths]
Env:        [new variables — names only]
```

Owed next: `frontend` for template-level rendering of structured data or SEO-adjacent UI,
`backend` for service data a JSON-LD builder needs, `test-writer` to cover the metadata output,
`qa-tester` to validate the tags and JSON-LD, `cicd` if sitemap regeneration should be
scheduled rather than request-time, and `doc-writer` to record the configuration.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/12-seo-checks/` — the verification procedure
- `project-management/workflows/20-frontend-code/` — the phase this wiring lands in

## Cross-references

- `project-management/docs/SEO-CHECKLIST.md` — **what must be true per page**; the audit baseline
- `code/docs/DISCOVERABILITY.md` — **how this stack does it**; the method side of that seam
- `code/docs/discoverability/CONTENT-STRUCTURE.md` — the body's shape, and § 1's myth disposals
- `code/docs/discoverability/ROOT-SURFACE.md` — every root and `.well-known` file, and who owns it
- `code/docs/RENDERING.md` — why critical content is never JS-gated
- `code/docs/URL-STRATEGY.md` — canonical URL and slug rules across the three prefixes
- `code/src/django/apps/marketing/CONTEXT.md` — where `build_seo` and the head partial sit
