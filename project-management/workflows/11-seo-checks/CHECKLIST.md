# SEO Checks — Checklist

**Last Updated**: 01/05/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Automated checks

- [ ] `/syntek-dev-suite:seo` skill run and output reviewed
- [ ] No errors or warnings remain from the skill output

## Metadata

- [ ] `<title>` is set via the Next.js metadata API — max 60 chars — contains the primary keyword
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
- [ ] Any fixes committed via `/syntek-dev-suite:git`

---

## Definition of Done

- [ ] All checklist items above are ticked
- [ ] Story SEO Acceptance Criteria complete
- [ ] Lighthouse report saved to `project-management/src/11-SEO/`
