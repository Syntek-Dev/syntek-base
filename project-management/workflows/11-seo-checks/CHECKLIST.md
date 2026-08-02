---
workflow: 11-seo-checks
phase: verify
agent: seo
skills: [stack-htmx-templates]
model: opus
---

# SEO Checks — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (SEO-CHECKLIST.md) · **External — SEO & Discoverability** (Lighthouse, Core Web Vitals) · **Internal — Live Artefacts** (src/11-SEO/) for supporting references.

## Automated checks

- [ ] `seo` skill run and output reviewed
- [ ] No errors or warnings remain from the skill output

## Metadata

- [ ] `<title>` is set in the Django template `<head>` (apps.seo, `build_seo` helper) — max 60 chars — contains the primary keyword
- [ ] `<meta name="description">` is set — max 160 chars — unique to this page
- [ ] `<link rel="canonical">` is present and points to the correct URL
- [ ] `og:title` is set and matches or complements the page title
- [ ] `og:description` is set and matches or complements the meta description
- [ ] `og:image` is set — image is at least 1200 × 630 px

## Structured data

- [ ] JSON-LD block is present in `<head>` as `<script type="application/ld+json">`
- [ ] Schema type is correct for the page content (e.g. `Article`, `BreadcrumbList`, `Organization`)
- [ ] JSON-LD validated with no errors in Google Rich Results Test or Schema.org validator

## Discoverability

- [ ] Page URL appears in `sitemap.xml`
- [ ] `robots.txt` does not block the page path
- [ ] Page slug is lowercase, hyphenated, human-readable, and keyword-bearing

## Core Web Vitals (Lighthouse)

- [ ] LCP < 2.5 s — recorded in Lighthouse audit
- [ ] CLS < 0.1 — recorded in Lighthouse audit
- [ ] INP < 200 ms — recorded in Lighthouse audit
- [ ] Lighthouse report exported and saved to `project-management/src/11-SEO/LIGHTHOUSE-[US###]-[ROUTE]-[DD-MM-YYYY].json`

## Images

- [ ] Every `<img>` has a non-empty `alt` attribute (or `alt=""` for decorative images)
- [ ] `alt` text is descriptive and contextually useful — not keyword-stuffed

## Heading hierarchy

- [ ] Exactly one `<h1>` on the page
- [ ] `<h2>` and `<h3>` used in logical order — no skipped levels

## Story sign-off

- [ ] All items in the story's `### SEO Acceptance Criteria` section are ticked
- [ ] Any fixes committed via `git`
- [ ] SEO implementation record written to `project-management/src/11-SEO/IMPLEMENTATION/SEO-IMPL-US###-<descriptor>-DD-MM-YYYY.md`

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] All checklist items above are ticked
- [ ] Story SEO Acceptance Criteria complete
- [ ] Lighthouse report saved to `project-management/src/11-SEO/`
