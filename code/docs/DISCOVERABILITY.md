---
type: guide
skills: [seo, stack-htmx-templates]
model: opus
---

# Discoverability — Being Found

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — how this stack implements being found: page metadata, structured data,
and the root files crawlers and agents fetch

How <%PROJECT_NAME%> is found by the people looking for it — by search engines, by answer
engines, and (where a project ships one) by app-store search. This is the **build side**: the
mechanisms, the helpers, and the rules a developer follows when writing the code.

---

## What this owns, and what it does not

> This guide owns **how this stack implements discoverability**;
> [`project-management/docs/SEO-CHECKLIST.md`](../../project-management/docs/SEO-CHECKLIST.md)
> owns **what must be true on a given page** before its story closes. When the two disagree, the
> checklist is the requirement and this guide is the method — fix the method here, never relax
> the requirement there.

That split is the `project-management/` ↔ `code/docs/` reading of
[`architecture/BUILD-OPERATE-SEAM.md`](architecture/BUILD-OPERATE-SEAM.md): the specifying layer
states the obligation, the build layer states the technique. A rule that appears in both has been
written in the wrong place once.

| Question                                                     | Answered by                                                      |
| ------------------------------------------------------------ | ---------------------------------------------------------------- |
| Does this page have a canonical URL, a description, an H1?   | `project-management/docs/SEO-CHECKLIST.md` (per page, per story) |
| How does a canonical URL get built on this stack?            | This guide → `discoverability/WEB-METADATA.md`                   |
| Which pages need `Article` rather than `Organization` schema | The story's SEO plan in `project-management/src/12-SEO/`         |
| How is a schema emitted without an XSS hole                  | This guide → `discoverability/STRUCTURED-DATA.md`                |
| Is the sitemap correct for this release?                     | `project-management/workflows/12-seo-checks/`                    |
| What serves `robots.txt`, and what must it say?              | This guide → `discoverability/ROOT-SURFACE.md`                   |
| Where does the answer go in the body, and how is it headed?  | This guide → `discoverability/CONTENT-STRUCTURE.md`              |
| How long may an App Store subtitle or keyword set be?        | This guide → `discoverability/APP-STORE.md` (mobile-only)        |

---

## The three surfaces

**Search engines** crawl and rank pages. **Answer engines** read and cite them. **App stores**
index listing metadata. The first two do not merely share mechanics on this stack — Google states
that appearing in AI Overviews and AI Mode needs **no additional optimisation** beyond ordinary
indexation, so they are one job with one set of rules. `discoverability/CONTENT-STRUCTURE.md` Section 1
carries the citation and the three myths it disposes of.

The third does not. Store search matches **listing metadata inside a length budget**, not a
crawled page, and none of the head, schema or body rules reach it. It is owned by
[`discoverability/APP-STORE.md`](discoverability/APP-STORE.md) — **mobile-only**, a copier-gated
sub-document on the same mechanism that gates
[`visual-design/MOBILE.md`](visual-design/MOBILE.md), so the row below dangles on a web-only
project by design.

---

## Sub-documents

| Document                                                                       | Covers                                                                                                                                                   |
| ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`discoverability/WEB-METADATA.md`](discoverability/WEB-METADATA.md)           | The per-page `<head>`: the `build_seo()` helper, canonical URLs, Open Graph and Twitter Cards                                                            |
| [`discoverability/STRUCTURED-DATA.md`](discoverability/STRUCTURED-DATA.md)     | JSON-LD builders, the XSS-safe serialiser, and the render-server-side rule                                                                               |
| [`discoverability/ROOT-SURFACE.md`](discoverability/ROOT-SURFACE.md)           | Every file served at the site root or under `/.well-known/` — `robots.txt`, sitemaps, `llms.txt`, feeds — and who owns each                              |
| [`discoverability/CONTENT-STRUCTURE.md`](discoverability/CONTENT-STRUCTURE.md) | The page **body**: answer-first openings, question-shaped headings, self-contained answer blocks — and why there is no separate answer-engine discipline |
| [`discoverability/APP-STORE.md`](discoverability/APP-STORE.md)                 | **Mobile-only.** The App Store and Play listing: the text fields, their limits, and why Apple's keyword budget is counted in bytes                       |

> **These guides are prescriptive, not descriptive.** `apps/marketing/seo.py`,
> `apps/marketing/jsonld.py` and `apps/core/views/seo.py` are the shape a project builds, not
> files that already exist — `code/src/django/apps/` ships empty. Read a path here as "where this
> goes", never as "where this is".

---

## The rules that hold across all three

- **Server-rendered or it does not exist.** A crawler that has to execute JavaScript to see your
  content may not bother, and an answer engine reading raw HTML certainly will not.
  [`RENDERING.md`](RENDERING.md) decides where an interaction runs; discoverability is the reason
  critical content is never on the client side of that line.
- **One authorised producer per output.** Metadata comes from `build_seo()`, structured data from
  the JSON-LD builders, root files from their named views. Hand-writing any of them in a template
  is how a page quietly ships without a canonical tag.
- **Private prefixes are never indexed.** `/admin/` (the <%PROJECT_NAME%> Admin) and `/portal/`
  (the Client Portal) are excluded from every sitemap and disallowed in `robots.txt`
  ([`URL-STRATEGY.md`](URL-STRATEGY.md)).
- **Canonical URLs come from configuration, never from the request.** Deriving a canonical from
  the `Host` header lets an attacker's proxied copy of the site declare itself canonical.

---

## How much of this a machine can check

**Every sub-document ends with a `What is mechanically checkable here` section, and the answer
differs sharply between them** — which is why it is stated five times rather than once. The
gradient runs from `STRUCTURED-DATA.md`, where nearly everything is a test, through
`WEB-METADATA.md` and `ROOT-SURFACE.md`, where the shape of the output is checkable but the words
are not, to `CONTENT-STRUCTURE.md` and `APP-STORE.md`, where almost nothing is.

Two consequences, and the second is the one that bites:

- **No audit in `code/src/scripts/audits/` covers this family**, and none is planned. The rules
  above are properties of **rendered pages**, and `code/src/django/apps/` ships empty — a script
  written today would report success having examined nothing, which is worse than no script,
  because a green result is believed.
- **A clean pipeline says nothing about whether this guide was honoured.** The gate that exists,
  `project-management/workflows/12-seo-checks/`, runs **before any code**, so it reviews a plan
  rather than a page. Discoverability is a **review concern**, and the review is a person's.

## What lives elsewhere

Named here so nobody documents them twice:

| Concern                                              | Owner                                                                                                                |
| ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Core Web Vitals, page weight, caching                | [`performance/FRONTEND-PERFORMANCE.md`](performance/FRONTEND-PERFORMANCE.md)                                         |
| Whether an interaction is server, HTMX, Alpine       | [`RENDERING.md`](RENDERING.md)                                                                                       |
| Slug and route naming                                | [`URL-STRATEGY.md`](URL-STRATEGY.md)                                                                                 |
| Image alt text as an accessibility requirement       | [`ACCESSIBILITY.md`](ACCESSIBILITY.md)                                                                               |
| Health, metrics and status endpoints                 | [`logging/HEALTH-CONTRACT.md`](logging/HEALTH-CONTRACT.md)                                                           |
| Outbound-mail DNS (SPF, DKIM, DMARC)                 | `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 12                                                     |
| The words on the page — tone, register, banned tells | `how-to/src/BRAND-VOICE.md` (the **shape** of the body is this guide's — see `discoverability/CONTENT-STRUCTURE.md`) |
| Backlinks, PR, citation monitoring, keyword research | **Nothing here.** Growth activities; no guide in this repository consumes them                                       |

---

## Cross-references

- [`../../project-management/docs/SEO-CHECKLIST.md`](../../project-management/docs/SEO-CHECKLIST.md)
  — the per-page requirements this guide implements
- [`architecture/BUILD-OPERATE-SEAM.md`](architecture/BUILD-OPERATE-SEAM.md) — the ownership-sentence
  rule this guide's seam statement follows
- [`architecture/FRONTEND-PATTERNS.md`](architecture/FRONTEND-PATTERNS.md) — frontend state and
  routing, where this doctrine used to live
- `project-management/workflows/12-seo-checks/` — the gate that verifies a page against the checklist

_Part of the `code/docs/` documentation family._
