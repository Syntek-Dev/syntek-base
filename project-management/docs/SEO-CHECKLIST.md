---
type: guide
agent: seo
skills: [stack-htmx-templates]
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
- Tick items off as they are implemented; implement any section with the `seo` agent

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

- [ ] `llms.txt` — Markdown file at site root for LLM agents
- [ ] `llms-full.txt` — full content version for AI agents
- [ ] Allow AI crawlers in `robots.txt` (GPTBot, ClaudeBot, PerplexityBot, Google-Extended)
- [ ] Clear, direct answers in first paragraph of content (BLUF — Bottom Line Up Front)
- [ ] Plain language, well-structured prose (easy for AI to parse and chunk)

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
- [ ] Backlink profile building (earned links, digital PR)
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
- [ ] RSS / Atom feeds (content discovery for aggregators and AI)

### AI Crawler Management

- [ ] Monitor server logs for AI bot traffic (GPTBot, ClaudeBot, PerplexityBot, etc.)
- [ ] Distinguish training bots vs. retrieval bots in `robots.txt`
- [ ] AI-specific sitemap references in `llms.txt`

---

## Intermediate — `.well-known/` Files

### Security & Trust

- [ ] `/.well-known/security.txt` (RFC 9116) — vulnerability disclosure contact: email, PGP key, scope, policy URL, expiry date; good practice for any site handling user data
- [ ] `/security.txt` — legacy location for `security.txt`; redirect to `/.well-known/security.txt`
- [ ] `/.well-known/dnt-policy.txt` — EFF Do Not Track policy file; declares how the site honours DNT signals

### Privacy & Legal

- [ ] `/.well-known/gpc` — Global Privacy Control JSON endpoint; declares whether the site honours the GPC signal (legal teeth in California under CCPA; relevant for UK under ICO guidance)
- [ ] `/.well-known/change-password` — redirect to the password change page; used by password managers (1Password, Apple Passwords, Chrome) to deep-link users to the correct page

### Platform Integrations

- [ ] `/.well-known/apple-app-site-association` (no file extension, JSON content) — enables iOS Universal Links and Handoff; required if an iOS app should open from web links
- [ ] `/.well-known/assetlinks.json` — Android Digital Asset Links for App Links and Smart Lock; required if an Android app should open from web links
- [ ] `/.well-known/apple-developer-merchantid-domain-association` — required to enable Apple Pay on the web; Apple verifies domain ownership before allowing payment sheet

### Certificate Validation

- [ ] `/.well-known/acme-challenge/` — Let's Encrypt / ACME CA validation path; handled automatically by certbot, Caddy, Traefik — ensure it is not blocked by `robots.txt` or Nginx config
- [ ] `/.well-known/pki-validation/` — used by commercial CAs (DigiCert, Sectigo) for domain validation

### Email Branding

- [ ] `/.well-known/brand-indicators-for-message-identification` (BIMI) — declares your verified logo for email clients that support BIMI; pairs with DMARC enforcement and a Verified Mark Certificate (VMC)

---

## Intermediate — Email Infrastructure (DNS + HTTP)

These are DNS records and one HTTP file. They do not affect page indexing directly but are required for email deliverability, which affects brand trust and referral traffic from email campaigns.

### DNS Records

- [ ] **SPF** — `TXT` record at the root domain; lists permitted mail server IPs/hostnames; prevents spoofing
- [ ] **DKIM** — `TXT` record at `[selector]._domainkey.[domain]`; cryptographic signature on outbound mail; required for DMARC alignment
- [ ] **DMARC** — `TXT` record at `_dmarc.[domain]`; policy for SPF/DKIM failures (none → quarantine → reject); enables aggregate and forensic reporting
- [ ] **TLS-RPT** — `TXT` record at `_smtp._tls.[domain]`; requests TLS failure reports from receiving mail servers
- [ ] **MTA-STS** — `TXT` record at `_mta-sts.[domain]` plus the HTTP file below; enforces TLS for inbound mail

### HTTP File

- [ ] `/.well-known/mta-sts.txt` — MTA-STS policy file; declares `mode: enforce` (or `testing`/`none`), MX hostnames, and `max_age`; required alongside the MTA-STS DNS record

### Reporting

- [ ] DMARC `rua` tag set to an aggregate reporting inbox (e.g. a dedicated mailbox or reporting service like Postmark, Valimail)
- [ ] DMARC `ruf` tag set for forensic (per-message) failure reports if required

---

## Intermediate — Legal & Compliance Routes

- [ ] `/privacy` or `/privacy-policy` — Privacy Notice (UK GDPR Art. 13/14); covers lawful basis, data categories, retention, third parties, data subject rights, DPO contact
- [ ] `/terms` or `/terms-and-conditions` — Terms of Service governing use of the site
- [ ] `/cookies` or `/cookie-policy` — Cookie usage notice (required separately under PECR in the UK if non-essential cookies are used); must list cookie names, purposes, and durations
- [ ] `/accessibility` or `/accessibility-statement` — WCAG conformance declaration; increasingly required for charity, public sector, and government clients
- [ ] `/dpa` or `/data-processing-agreement` — DPA template for B2B clients processing data via the platform
- [ ] `/sub-processors` or `/subprocessors` — list of third-party processors; expected by enterprise clients and required for transparent GDPR compliance under Art. 28
- [ ] `/.well-known/gpc` — Global Privacy Control endpoint (see `.well-known/` Files section above)

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

### Generative Engine Optimisation (GEO)

- [ ] Optimise content for AI citation (be the source AI quotes)
- [ ] Original research, proprietary data, unique case studies (citation magnets)
- [ ] Entity-based content strategy (build brand entity recognition)
- [ ] Third-party authority signals (earned media, press mentions, Wikipedia presence)
- [ ] Content chunking strategy (structure content so RAG systems can extract cleanly)
- [ ] Fan-out query coverage (cover sub-queries that AI decomposes complex questions into)
- [ ] Platform-specific optimisation (ChatGPT, Perplexity, Google AI Overviews, Gemini, Claude)

### AI Monitoring & Measurement

- [ ] Track AI referral traffic in analytics (ChatGPT, Perplexity, etc. as referrers)
- [ ] Monitor brand mentions in AI-generated answers
- [ ] AI citation frequency tracking
- [ ] Share of voice in AI search results
- [ ] Prompt-level monitoring (what prompts surface your brand)

### Technical AI Readiness

- [ ] Ensure content is not trapped in PDFs, images, or iframes
- [ ] Multimodal optimisation (alt text, captions, transcripts for video/audio)
- [ ] API documentation with `llms.txt` for developer-facing products
- [ ] Machine-readable data formats alongside human-readable content

---

## Advanced — Developer & Operations Routes

- [ ] `/health/` or `/healthz` — health check endpoint for load balancers, Kubernetes liveness probes, and uptime monitors; return HTTP 200 with minimal payload; must NOT be publicly documented or linked
- [ ] `/readyz` — readiness check (Kubernetes idiom); separate from liveness if startup time differs
- [ ] `/ping` — simple liveness check; return `pong` or HTTP 200
- [ ] `/metrics` — Prometheus metrics endpoint; **must be firewalled** and never publicly accessible; blocks by IP or internal network only
- [ ] `/status` — public status page route (Statuspage, Instatus, Cachet, or self-hosted)
- [ ] `/version` or `/.well-known/version` — exposes deployed version/commit info; useful for debugging but treat as a minor information-disclosure risk; gate behind internal network or omit from production
- [ ] `/debug`, `/wp-admin`, `/phpmyadmin` — **must never be accessible**; block explicitly at the reverse proxy; `robots.txt` Disallow is a deterrent only, not security

---

## Root Files Quick Reference

| File / Path                                                  | Purpose                                     |
| ------------------------------------------------------------ | ------------------------------------------- |
| `/robots.txt`                                                | Crawler access rules                        |
| `/sitemap.xml`, `/sitemap_index.xml`                         | XML sitemaps (submit to GSC + Bing)         |
| `/sitemap-static.xml`, `/sitemap-blog.xml`, etc.             | Segmented sitemaps by content type          |
| `/sitemap.txt`, `/sitemap.xml.gz`                            | Plain-text and compressed sitemap variants  |
| `/llms.txt`, `/llms-full.txt`                                | AI agent content guide (Markdown)           |
| `/ai.txt`                                                    | AI training consent / opt-out declaration   |
| `/favicon.ico`, `/favicon.svg`                               | Site icons (legacy + modern)                |
| `/favicon-32x32.png`, `/favicon-16x16.png`                   | Raster favicon variants                     |
| `/apple-touch-icon.png`                                      | iOS home-screen icon (180 × 180 px)         |
| `/manifest.webmanifest`, `/sw.js`                            | PWA manifest and service worker             |
| `/browserconfig.xml`                                         | Windows tile configuration                  |
| `/ads.txt`, `/app-ads.txt`, `/sellers.json`                  | Authorised ad sellers (IAB)                 |
| `/humans.txt`                                                | Site credits                                |
| `/[indexnow-key].txt`                                        | IndexNow API key verification               |
| `/.well-known/security.txt`                                  | Vulnerability disclosure contact (RFC 9116) |
| `/.well-known/gpc`                                           | Global Privacy Control policy endpoint      |
| `/.well-known/change-password`                               | Password manager deep-link redirect         |
| `/.well-known/apple-app-site-association`                    | iOS Universal Links / Handoff               |
| `/.well-known/assetlinks.json`                               | Android App Links                           |
| `/.well-known/apple-developer-merchantid-domain-association` | Apple Pay domain verification               |
| `/.well-known/acme-challenge/`                               | Let's Encrypt / ACME certificate validation |
| `/.well-known/mta-sts.txt`                                   | MTA-STS mail TLS policy                     |
| `/.well-known/brand-indicators-for-message-identification`   | BIMI logo declaration for email             |
| `/cookies`, `/dpa`, `/sub-processors`                        | Legal / compliance pages                    |
| `/health/`, `/healthz`, `/metrics`, `/status`                | Ops endpoints (firewalled where noted)      |

---

## Related Resources

- [`code/docs/architecture/FRONTEND-PATTERNS.md`](../../code/docs/architecture/FRONTEND-PATTERNS.md)
  — the `build_seo()` helper and the JSON-LD rendering pattern
- [Google Search Console](https://search.google.com/search-console) — Submit sitemaps and monitor
  indexing
- [Bing Webmaster Tools](https://www.bing.com/webmasters) — IndexNow and Bing indexing
- [Schema.org](https://schema.org) — Structured data vocabulary reference
- [llms.txt specification](https://llmstxt.org) — AI agent content guide format
