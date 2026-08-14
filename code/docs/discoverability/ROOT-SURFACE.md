---
type: guide
skills: [seo, stack-htmx-templates]
model: opus
---

# The Root Surface — root files and `/.well-known/`

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the crawler views, the static discovery files, and the register of who
owns each

Everything a client fetches from the site root without following a link: `robots.txt`, the
sitemaps, `llms.txt`, any syndication feed, and the `/.well-known/` files. Three different things
serve them, and the register below is the only place that says which.

---

## 1. The crawler views — served by Django

`robots.txt`, the sitemap set, `llms.txt` and any feed are **Django views**, not static files,
because each depends on live state — published pages, current routes, the environment's domain.

They live in `apps/core/views/seo.py`.

### robots.txt

- **Disallow `/admin/` and `/portal/`.** The <%PROJECT_NAME%> Admin and the Client Portal are
  private and must never be indexed ([`../URL-STRATEGY.md`](../URL-STRATEGY.md)).
- **Allow AI crawlers explicitly** — GPTBot, ClaudeBot, PerplexityBot, Google-Extended. Silence
  is not consent to some of them and is read as permission by others; say what you mean.
- **Distinguish training crawlers from retrieval crawlers.** They are different decisions:
  retrieval bots fetch a page to answer a question and may cite it; training bots collect corpus.
  A project may reasonably allow one and refuse the other.
- `Disallow` is **not** a security control. It is a request, honoured voluntarily, and a public
  list of the paths you consider sensitive. Anything that must not be reached is blocked at the
  edge (`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`), never here.

### Sitemaps

- Generated from published state — a page that is not live is not in the sitemap.
- `/admin/` and `/portal/` excluded, same as robots.
- Segment by content type only once the volume justifies it. A single `sitemap.xml` is correct
  until it is not; premature segmentation is four files to keep correct instead of one.

### llms.txt

The [llms.txt specification](https://llmstxt.org/) — a Markdown map of the site for agents that
read rather than crawl. Keep it a curated index of what matters, not a dump of every route.

**It is not an answer-engine ranking or citation signal, and this guide previously said it was.**
Google states that no new "AI text files" are needed to appear in AI Overviews or AI Mode
([AI features and your website](https://developers.google.com/search/docs/appearance/ai-features)),
and its search advocates have said no AI system fetches the file for search. Shipping it will not
get a page cited.

**Where it does earn its place is agent consumption** — IDE agents, MCP clients and
documentation-fetching tools that are handed a URL and want an index rather than a crawl. This
repository is itself an example: the vendored `cloudinary-docs` skill retrieves Cloudinary's
`llms.txt` to find the right page. Judge the file against that use, which is real and testable,
rather than against citations it does not produce.

Related: [`../MCP-SERVER.md`](../MCP-SERVER.md) — the other agent-facing surface this project
serves, and the one whose audience actually reads this file.

### Feeds — RSS and Atom

A feed is a crawler view like the sitemaps: generated from published state, excluding `/admin/`
and `/portal/`, served by Django rather than written by hand. Django ships
`django.contrib.syndication` for exactly this; do not hand-assemble XML.

Ship one **only where recurring published content exists** — a blog, a changelog, release notes.
A feed over a static marketing site advertises staleness. Where one exists, link it from the
`<head>` with `<link rel="alternate" type="application/rss+xml">` so it is discoverable without
guessing the path.

---

## 2. Static discovery files — served without a view

RFC-defined discovery files (`security.txt` per RFC 9116, `change-password` per RFC 8615) are
served as static files. No application logic, no database queries, no view.

Place them under a collected static directory and let **Whitenoise** serve them (via
`collectstatic`), or serve them at the **edge**:

```text
code/src/django/static/.well-known/
└── security.txt    # RFC 9116 responsible-disclosure contact
```

`static/.well-known/security.txt` is delivered at `/.well-known/security.txt` with
`Content-Type: text/plain; charset=utf-8`.

### Legacy redirect

Add HTTP 301 redirects for legacy path variations in the Django URLconf (or at the edge), not in
application logic:

```python
# config/urls.py
from django.views.generic import RedirectView

path(".well-known/", RedirectView.as_view(url="/.well-known/security.txt", permanent=True))
```

---

## 3. The register — every root file and who owns it

**Not everything at the root is discoverability.** Several of these files sit here only because
they are fetched from the root; their rules belong to another guide entirely. The `Owner` column
is the point of this table.

> The files marked **edge** are provisioned by the server, not this repository:
> `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` owns "what the server provides", this
> guide keeps owning "why the file exists and what it must say".

| Path                                             | Purpose                          | Owner                                   | Applies when                |
| ------------------------------------------------ | -------------------------------- | --------------------------------------- | --------------------------- |
| `/robots.txt`                                    | Crawler access rules             | **This guide** Section 1                | Always                      |
| `/sitemap.xml` (+ segments)                      | Indexable URL set                | **This guide** Section 1                | Always                      |
| `/llms.txt` · `/llms-full.txt`                   | Agent-readable site map          | **This guide** Section 1                | Always                      |
| `/feed.xml` · `/rss.xml` · `/atom.xml`           | Syndication feed                 | **This guide** Section 1                | Only with recurring content |
| `/.well-known/security.txt`                      | Disclosure contact (RFC 9116)    | [`../SECURITY.md`](../SECURITY.md)      | Always                      |
| `/favicon.ico` · `.svg` · `apple-touch-icon.png` | Site icons                       | Frontend / brand assets                 | Always                      |
| `/manifest.webmanifest` · `/sw.js`               | PWA install + offline            | Frontend                                | Only if a PWA is shipped    |
| `/browserconfig.xml`                             | Windows tile                     | Frontend                                | Rarely — legacy Edge        |
| `/ai.txt`                                        | AI **training** consent          | **This guide** Section 1                | If training use is refused  |
| `/.well-known/gpc`                               | Global Privacy Control signal    | `project-management/docs/GDPR-GUIDE.md` | If tracking exists          |
| `/.well-known/change-password`                   | Password-manager deep link       | Auth surface                            | If accounts exist           |
| `/.well-known/acme-challenge/`                   | TLS certificate validation       | **edge**                                | Always (automatic)          |
| `/.well-known/pki-validation/`                   | Commercial CA validation         | **edge**                                | Only with a commercial CA   |
| `/.well-known/mta-sts.txt`                       | Inbound-mail TLS policy          | **edge** (with TLS-RPT DNS)             | Only if inbound mail exists |
| `/.well-known/brand-indicators-…` (BIMI)         | Verified logo in email clients   | **edge** (needs DMARC + VMC)            | Only with enforced DMARC    |
| `/.well-known/assetlinks.json`                   | Android App Links                | **Mobile surface**                      | Mobile-only                 |
| `/.well-known/apple-app-site-association`        | iOS Universal Links              | **Mobile surface**                      | Mobile-only                 |
| `/.well-known/apple-developer-merchantid-…`      | Apple Pay domain verification    | Payments surface                        | Only with Apple Pay         |
| `/humans.txt` · `/ads.txt` · `/sellers.json`     | Credits · ad-seller declarations | **Not adopted**                         | Only with programmatic ads  |

**The two app-linking files are a cross-surface case.** `assetlinks.json` and
`apple-app-site-association` are served by the _web_ surface and exist only because a _mobile_
app does. A web-only project must not ship them — an empty or wrong association file breaks deep
linking more visibly than its absence.

**Ops endpoints are not on this table.** `/health`, `/readyz`, `/metrics`, `/status` and
`/version` are fetched from the root but are a monitoring contract, not a discovery surface:
[`../logging/HEALTH-CONTRACT.md`](../logging/HEALTH-CONTRACT.md) owns them, and `/metrics` must be
firewalled rather than merely disallowed.

---

## What is mechanically checkable here

Deterministic, and therefore worth a gate rather than a review: every public route resolves;
`robots.txt` names the private prefixes; the sitemap contains no `/admin/` or `/portal/` URL;
every file the register marks "Always" returns 200. **Not** deterministic: whether the `llms.txt`
index picks the right pages, or whether the crawler policy is the one the business wants.

---

## Cross-references

- [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md) — the index and the seam statement
- [`../SECURITY.md`](../SECURITY.md) — `security.txt`, and why `Disallow` is not a control
- [`../logging/HEALTH-CONTRACT.md`](../logging/HEALTH-CONTRACT.md) — the ops endpoints this excludes
- [`../URL-STRATEGY.md`](../URL-STRATEGY.md) — the private prefixes
- `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — the edge-provisioned rows
- [llms.txt specification](https://llmstxt.org/) · [RFC 9116](https://www.rfc-editor.org/rfc/rfc9116)

_Part of the `code/docs/` documentation family._
