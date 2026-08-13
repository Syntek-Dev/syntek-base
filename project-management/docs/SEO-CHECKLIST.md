---
type: guide
skills: [seo, stack-htmx-templates]
model: opus
---

# SEO & AI Discoverability Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**MCP Servers:** context7 (SEO, OpenGraph, structured data docs)

---

## Overview

This checklist covers all levels of SEO and AI discoverability implementation, from essential root
files through to advanced Generative Engine Optimisation (GEO). Use it to audit existing projects or
guide new implementations.

**How to use this checklist:**

- Work through each tier in order — Beginner first, then Intermediate, then Advanced
- Tick items off as they are implemented; implement any section with the `seo` skill

> **What this owns.** This checklist owns **what must be true on a given page** before its story
> closes; [`code/docs/DISCOVERABILITY.md`](../../code/docs/DISCOVERABILITY.md) owns **how this
> stack implements it**. When the two disagree, this file is the requirement and that guide is
> the method. Do not add implementation detail here, and do not relax a requirement there.

**Sections and rows marked _(not a gate item)_ are not checked by `workflows/12-seo-checks/`.**
They are real work, but they are ongoing programmes or off-site activities — nobody can tick them
for a single page in a single story. Leaving them unmarked made the gate look like it verified
things it never could. Anything without the marker **is** a gate item.

> **Every tick here is a person's judgement, not a script's.** `12-seo-checks` runs inside the
> per-story loop, **before any code exists**, so it reviews the plan for a page rather than the
> page — and no audit in `code/src/scripts/audits/` covers this ground either. A green pipeline
> is not evidence that a single row below is satisfied. Which rules a machine _could_ check, if
> there were a built page to check them against, is recorded per artefact in
> [`code/docs/DISCOVERABILITY.md`](../../code/docs/DISCOVERABILITY.md) → _How much of this a
> machine can check_.

**On answer engines (GEO/AEO).** Google states there are no additional requirements or special
optimisations for AI Overviews and AI Mode beyond ordinary indexation
([primary source](https://developers.google.com/search/docs/appearance/ai-features)). This
checklist previously carried three techniques that follow from the opposite belief; they have
been removed. The reasoning is
[`code/docs/discoverability/CONTENT-STRUCTURE.md`](../../code/docs/discoverability/CONTENT-STRUCTURE.md)
§ 1.

---

## Beginner — Search Engine SEO

### Root Files & Config

- [ ] `robots.txt` — crawler access rules
- [ ] `sitemap.xml` — XML sitemap submitted to Google Search Console and Bing Webmaster Tools
- [ ] `favicon.ico` / `site.webmanifest` — site icon and PWA config
- [ ] `sitemap_index.xml` — master sitemap index pointing to segmented sub-sitemaps (use when site exceeds 50,000 URLs or segmentation is needed by content type)
- [ ] `/sitemap-static.xml` — static/evergreen pages (home, about, contact, legal)
- [ ] `/sitemap-blog.xml` — blog post URLs driven by publish state
- [ ] `/sitemap-sectors.xml` (or `/sitemap-pages.xml`) — sector landing pages, services, pricing, portfolio, testimonials
- [ ] `/sitemap-images.xml` — Cloudinary image URLs for blog and portfolio content
- [ ] `/sitemap-news.xml` — blog posts published within 48 hours (Google News schema; only if the site qualifies as a news publisher)
- [ ] `sitemap.txt` — plain-text sitemap (one URL per line); simpler alternative for small sites
- [ ] `sitemap.xml.gz` — gzip-compressed sitemap served alongside plain XML for bandwidth efficiency
- [ ] `ads.txt` — IAB Authorised Digital Sellers declaration (required for programmatic advertising)
- [ ] `app-ads.txt` — same concept for mobile app inventory

### HTML Head — Essential Meta

- [ ] Meta title (`<title>` tag)
- [ ] Meta description
- [ ] Meta robots (`noindex`, `nofollow`, `noarchive`, etc.)
- [ ] Canonical tags (`<link rel="canonical">`)
- [ ] Viewport meta tag (mobile responsiveness)
- [ ] Charset declaration (UTF-8)
- [ ] Favicon / icon links

### On-Page Basics

- [ ] Heading hierarchy (H1–H6, one H1 per page)
- [ ] Image alt text on all images
- [ ] Descriptive, keyword-aware URLs (short, readable slugs)
- [ ] Internal linking between related pages
- [ ] Mobile-friendly / responsive design
- [ ] HTTPS (SSL/TLS certificate)
- [ ] Page load speed (compress images, minify CSS/JS)
- [ ] Custom 404 error page

### Content Basics

- [ ] Unique, helpful content per page
- [ ] Keyword research and natural keyword usage
- [ ] Content freshness (regular updates)

### Accounts & Tools

- [ ] Google Search Console (verify site, submit sitemap)
- [ ] Bing Webmaster Tools (verify site, submit sitemap)
- [ ] Google Business Profile (for local businesses)

---

## Beginner — AI Discoverability

- [ ] `llms.txt` — Markdown index at site root **for agent consumption** (IDE agents, MCP
      clients, documentation fetchers). **Not a citation or ranking signal** — see
      [`ROOT-SURFACE.md`](../../code/docs/discoverability/ROOT-SURFACE.md) § 1
- [ ] `llms-full.txt` — full content version, same audience and same caveat
- [ ] Allow AI crawlers in `robots.txt` (GPTBot, ClaudeBot, PerplexityBot, Google-Extended)
- [ ] Clear, direct answers in first paragraph of content (BLUF — Bottom Line Up Front)
- [ ] Plain language, well-structured prose

> Body structure is a method question:
> [`CONTENT-STRUCTURE.md`](../../code/docs/discoverability/CONTENT-STRUCTURE.md) owns how.

---

## Beginner — AI Consent & Crawler Consent

- [ ] `/ai.txt` — Spawning's proposed opt-out/opt-in file for AI training data usage; distinct purpose from `llms.txt` (training consent vs discoverability)
- [ ] `robots.txt` — explicit `Allow` or `Disallow` rules for AI training crawlers (GPTBot, CCBot, CommonCrawl) separate from retrieval crawlers (ClaudeBot, PerplexityBot)
- [ ] Distinguish training bots (CCBot, GPTBot data collection) from retrieval bots (ClaudeBot, PerplexityBot, Google-Extended) in `robots.txt` directives

---

## Beginner — PWA, Icons & Platform Files

- [ ] `/manifest.webmanifest` (or `/manifest.json`) — Web App Manifest defining PWA installability, name, icons, theme colour, background colour, display mode
- [ ] `/sw.js` (or `/service-worker.js`) — service worker for PWA offline support and push notifications; path matters as service workers control their scope and below
- [ ] `/favicon.ico` — classic browser favicon (still required for legacy browser support)
- [ ] `/favicon.svg` — vector favicon (preferred for modern browsers; scales cleanly)
- [ ] `/favicon-32x32.png` and `/favicon-16x16.png` — raster favicon variants
- [ ] `/apple-touch-icon.png` — home-screen icon for iOS devices (180 × 180 px recommended)
- [ ] `/apple-touch-icon-precomposed.png` — pre-iOS 7 variant (optional)
- [ ] `/browserconfig.xml` — Microsoft tile configuration for pinned sites in Windows / older Edge

---

## Intermediate — Search Engine SEO

### Structured Data & Rich Results

- [ ] Schema.org / JSON-LD markup (`LocalBusiness`, `Organization`, `Product`, `FAQ`, `Event`, etc.)
- [ ] Breadcrumb structured data
- [ ] Review / rating structured data
- [ ] Sitelinks search box markup

### HTML Head — Social & Sharing

- [ ] Open Graph tags (`og:title`, `og:description`, `og:image`, `og:url`, `og:type`)
- [ ] Twitter Card tags (`twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`)

### HTML Head — International & Language

- [ ] Hreflang tags (multilingual / regional targeting)
- [ ] `Content-Language` meta tag

### Indexing & Crawl Efficiency

- [ ] IndexNow protocol (push-based instant indexing for Bing, Yandex, Seznam, DuckDuckGo)
- [ ] XML sitemap segmentation (separate sitemaps for posts, pages, images, videos)
- [ ] Sitemap index file (for large sites)
- [ ] Crawl budget management (avoid crawl traps, parameter handling)
- [ ] Pagination handling (`rel="next"` / `rel="prev"` or load-more patterns)

### Technical Performance

- [ ] Core Web Vitals (LCP, INP, CLS) — measured and within thresholds
- [ ] Image optimisation (WebP/AVIF format, lazy loading, responsive `srcset`)
- [ ] Minified and deferred CSS/JS
- [ ] Content Delivery Network (CDN)
- [ ] Server response time / TTFB optimisation
- [ ] Gzip / Brotli compression

### Content & Authority

- [ ] Internal linking strategy (topical clusters, pillar pages)
- [ ] Backlink profile building (earned links, digital PR) — _(not a gate item)_
- [ ] Content audits (update stale content, consolidate thin pages)
- [ ] Duplicate content management (canonicals, redirects)
- [ ] 301 redirect chains (find and fix)

### Local SEO

- [ ] Google Business Profile optimisation
- [ ] Local schema markup (`LocalBusiness`, address, opening hours)
- [ ] NAP consistency (Name, Address, Phone across directories)
- [ ] Local citations and directory listings

---

## Intermediate — AI Discoverability

### Content Structure for AI

_Method:_ [`CONTENT-STRUCTURE.md`](../../code/docs/discoverability/CONTENT-STRUCTURE.md).
These serve readers and search engines equally — they are not answer-engine-specific.

- [ ] Question-format H2/H3 headings (mirror natural language queries)
- [ ] Concise, citable statistics and data points in content
- [ ] FAQ sections with direct answers
- [ ] Comparison tables and structured lists
- [ ] "Last updated" timestamps on content
- [ ] Author bylines with credentials / expertise signals

### Technical for AI

- [ ] Server-side rendering (SSR) — avoid content hidden behind JavaScript
- [ ] No critical content behind logins, paywalls, or interactive elements
- [ ] Clean HTML (minimal JavaScript-rendered content for key pages)
- [ ] RSS / Atom feed where recurring content exists — a Django view; register row in
      [`ROOT-SURFACE.md`](../../code/docs/discoverability/ROOT-SURFACE.md) § 3

### AI Crawler Management

- [ ] Monitor server logs for AI bot traffic (GPTBot, ClaudeBot, PerplexityBot, etc.)
- [ ] Distinguish training bots vs. retrieval bots in `robots.txt`
- [ ] AI-specific sitemap references in `llms.txt`

---

## Intermediate — `.well-known/` Files

**Not enumerated here.** The full root and `/.well-known/` surface — every file, its purpose, its
owner, and when it applies — is the register at
[`code/docs/discoverability/ROOT-SURFACE.md`](../../code/docs/discoverability/ROOT-SURFACE.md)
§ 3. Several of those rows are owned by the edge or by another surface entirely, which is exactly
why one register with an ownership column beats a tick-list here.

The two checks that are genuinely per-site, and belong on this list:

- [ ] `/.well-known/acme-challenge/` is **not** blocked by `robots.txt` or the proxy config —
      blocking it silently breaks certificate renewal
- [ ] App-linking files (`assetlinks.json`, `apple-app-site-association`) are present **only if a
      mobile app exists** — a wrong or stale association file breaks deep linking more visibly
      than its absence

---

## Intermediate — Email Infrastructure

**Not owned here.** Outbound-mail DNS (SPF, DKIM, DMARC) is a server contract, not a page
requirement: `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` § 12 owns what the deploy
repository must publish, and `NIXOS-HANDOFF.md` carries the secret list. MTA-STS, TLS-RPT and BIMI
are edge-provisioned rows in the register at
[`code/docs/discoverability/ROOT-SURFACE.md`](../../code/docs/discoverability/ROOT-SURFACE.md) § 3.

Mail deliverability affects brand trust and email referral traffic, so it belongs on a launch
plan — but ticking it here would mean two documents owning one DNS record.

---

## Intermediate — Legal & Compliance Routes

**Which documents are required is not an SEO decision** — `GDPR-GUIDE.md` and the
`legal-documents` skill own whether this project needs a privacy notice, a cookie notice under
PECR, a DPA, or a sub-processor list, and what each must say.

What belongs on this checklist is how they behave as pages:

- [ ] Every legal page that exists is **indexable** — no `noindex`, reachable from the footer on
      every page. These are trust signals to search engines and citation anchors to answer engines
- [ ] Each has a stable canonical URL that does not change when the document is revised
- [ ] The accessibility statement, where one exists, states the actual conformance level — a
      claim of WCAG 2.2 AA that the site does not meet is worse than no statement

---

## Advanced — Search Engine SEO

### Technical Architecture

- [ ] JavaScript rendering audit (ensure Googlebot can render JS content)
- [ ] Dynamic rendering for JS-heavy sites
- [ ] Log file analysis (crawl patterns, bot behaviour, crawl waste)
- [ ] Orphan page detection and resolution
- [ ] Redirect mapping and migration planning
- [ ] Edge SEO (Cloudflare Workers, CDN-level optimisations)
- [ ] HTTP/2 or HTTP/3 server configuration
- [ ] Preconnect, prefetch, preload resource hints

### Advanced Structured Data

- [ ] Product schema with `shippingDetails`, `returnPolicy` (e-commerce)
- [ ] Organisation-level schema as fallback
- [ ] `VideoObject` / `HowTo` / `Recipe` schema
- [ ] Event schema with dates and locations
- [ ] Speakable schema (voice search optimisation)
- [ ] `SameAs` links (connect social profiles to Knowledge Graph)

### Advanced Indexing

- [ ] Google Indexing API (for job postings, livestreams, etc.)
- [ ] IndexNow automation (CI/CD integration, post-deploy hooks)
- [ ] Programmatic sitemap generation from database / CMS
- [ ] Noindex / nofollow strategy for faceted navigation and filters

### Security & Trust

- [ ] HTTPS everywhere (HSTS headers, no mixed content)
- [ ] `security.txt` (`/.well-known/security.txt`)
- [ ] Content Security Policy (CSP) headers
- [ ] Permissions-Policy headers

### App & Cross-Platform

- [ ] `/.well-known/assetlinks.json` (Android app linking)
- [ ] `/.well-known/apple-app-site-association` (iOS deep linking)
- [ ] AMP pages (where still relevant)

### Performance Monitoring

- [ ] Real User Monitoring (RUM) for Core Web Vitals
- [ ] Synthetic testing (Lighthouse CI, WebPageTest)
- [ ] Crawl anomaly alerting

### Other Root Files

- [ ] `humans.txt` (credits / team info)
- [ ] `ads.txt` / `sellers.json` (if running programmatic ads)
- [ ] `/.well-known/change-password` (password change redirect)

---

## Advanced — AI Discoverability (GEO)

### Generative Engine Optimisation (GEO) — _(not gate items)_

**Three rows were removed here, not merely unticked**, because they instruct work Google's own
documentation says is unnecessary: _content chunking for RAG extraction_, _fan-out query
coverage_, and _platform-specific optimisation per engine_. The last also named five products as
the requirement, which `code/docs/architecture/PROVIDER-NEUTRALITY.md` forbids independently.
Everything that survives is ordinary content quality:

- [ ] Original research, proprietary data, unique case studies (citation magnets)
- [ ] Entity clarity — the organisation is named consistently and described the same way
      everywhere, and `Organization` schema carries its `sameAs` profile links
- [ ] Third-party authority signals (earned media, press mentions)

### AI Monitoring & Measurement — _(not gate items)_

Ongoing measurement, and none of it is page-scoped. This project ships no analytics stack, so
each row assumes tooling a deployment must choose first.

- [ ] Track AI referral traffic in analytics (ChatGPT, Perplexity, etc. as referrers)
- [ ] Monitor brand mentions in AI-generated answers
- [ ] AI citation frequency tracking
- [ ] Share of voice in AI search results

### Technical AI Readiness

- [ ] Ensure content is not trapped in PDFs, images, or iframes
- [ ] Multimodal optimisation (alt text, captions, transcripts for video/audio)
- [ ] API documentation indexed by `llms.txt` for developer-facing products — the one use with
      demonstrated uptake (IDE agents, MCP clients)
- [ ] Machine-readable data formats alongside human-readable content

---

## Advanced — Developer & Operations Routes

**Not owned here.** `/health`, `/readyz`, `/ping`, `/metrics`, `/status` and `/version` are a
monitoring contract rather than a discovery surface:
[`code/docs/logging/HEALTH-CONTRACT.md`](../../code/docs/logging/HEALTH-CONTRACT.md) owns the
endpoints the application exposes, and `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` § 8
owns what the server provisions.

The one SEO-adjacent point, kept because it is a real trap: **a `robots.txt` `Disallow` is not
protection.** Paths that must never be reachable — `/debug`, `/wp-admin`, `/phpmyadmin`,
`/metrics` — are blocked at the reverse proxy. Listing them in `robots.txt` publishes a map of
what you consider sensitive.

---

## Root Files Quick Reference

**Moved.** The enumeration of every root and `/.well-known/` file — with an owner and an
applies-when column, which a bare list could not carry — is
[`code/docs/discoverability/ROOT-SURFACE.md`](../../code/docs/discoverability/ROOT-SURFACE.md)
§ 3. Keeping a second copy here is how the two drifted in the first place.

---

## Related Resources

- [`code/docs/DISCOVERABILITY.md`](../../code/docs/DISCOVERABILITY.md) — **how this stack
  implements everything on this checklist**: the `<head>` pipeline, the JSON-LD builders, and the
  root surface
- [Google Search Console](https://search.google.com/search-console) — Submit sitemaps and monitor
  indexing
- [Bing Webmaster Tools](https://www.bing.com/webmasters) — IndexNow and Bing indexing
- [Schema.org](https://schema.org) — Structured data vocabulary reference
- [llms.txt specification](https://llmstxt.org) — AI agent content guide format
