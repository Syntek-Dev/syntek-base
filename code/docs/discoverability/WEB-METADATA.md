---
type: guide
skills: [seo, stack-htmx-templates]
model: opus
---

# Web Metadata — the per-page `<head>`

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — `build_seo()`, canonical URLs, Open Graph and Twitter Cards

Every public page's `<head>` is produced by one helper and rendered by one partial. Nothing else
writes a `<meta>` tag.

---

## The pattern

All public-facing pages set metadata through the `build_seo()` helper and render it via the
`_seo_head.html` partial included in the base template `<head>`. **Never hand-write `<meta>` tags
in a page template.**

### Rules

- **`build_seo(opts)`** is the only authorised way to produce the SEO context. It caps
  descriptions at 160 chars, forces `twitter:card` to `summary_large_image`, and always sets a
  valid OG image.
- **Canonical URL**: derive from the `SITE_URL` setting — **never** from the request `Host`
  header. A `Host`-derived canonical lets a proxied copy of the site declare itself the original.
- **Article pages**: pass the article fields (published/modified time, tags) so `build_seo()`
  emits the `og:type=article` block.
- Include `_seo_head.html` once, in the base template `<head>`; pages only supply the context.
- **One `build_seo()` call per page.** Two calls means two sources of truth for one `<head>`.

### Usage

```python
# apps/marketing/views.py
from django.conf import settings
from django.shortcuts import render
from apps.marketing.seo import build_seo

def blog_post(request, slug):
    post = get_published_post(slug)
    seo = build_seo(
        title=f"{post.title} — <%ORG_NAME%>",
        description=post.excerpt,
        canonical=f"{settings.SITE_URL}/blog/{post.slug}",
        image=post.hero_image_url,
        og_type="article",
        published_time=post.published_at,
        modified_time=post.updated_at,
        tags=post.tags,
    )
    return render(request, "marketing/blog_post.html", {"post": post, "seo": seo})
```

```django
{# templates/base.html #}
<head>
  {% include "marketing/_seo_head.html" with seo=seo %}
</head>
```

`SITE_URL` defaults to `https://<%PRIMARY_DOMAIN%>` and is overridden per environment. The
`build_seo()` helper and `_seo_head.html` partial live in `apps/marketing/`.

---

## Locale

`lang="en-GB"` on the `<html>` element and `og:locale="<%LOCALE%>"` in the head. This project is
single-locale — there is no hreflang set to maintain, and adding one is a scope decision, not an
implementation detail.

---

## Titles and descriptions are copy

A meta description is a sentence a person reads in a result list, so it obeys
`how-to/src/BRAND-VOICE.md` like any other user-facing string — no superlatives, no keyword
stuffing, and the register the project settled at first-time setup. A description written for a
crawler rather than a reader reads as machine-authored to both.

---

## Answer engines read the same head

An answer engine parsing a page for citation uses the `<title>`, the description and the
`og:` block as its summary of what the page is. There is no separate metadata layer for them —
the work above is the work, and Google confirms no additional optimisation is needed to appear in
its AI features.

What differs is the **body**: an answer belongs in the opening paragraph, under a heading shaped
like the question. That is content structure rather than metadata, and it is owned by
[`CONTENT-STRUCTURE.md`](CONTENT-STRUCTURE.md).

---

## What is mechanically checkable here

**More than anywhere else in this family** — every rule in _The pattern_ is a property of the
emitted HTML or of the view that produced it. Deterministic, and therefore worth a test rather
than a review: each public route emits exactly one `<title>`, one description and one canonical;
the canonical is absolute and derived from `SITE_URL`, never from the request host; no page
template hand-writes a `<meta name="description">` or an `og:` tag; `_seo_head.html` is included
once, in the base template only; exactly one `build_seo()` call per view.

**Not** deterministic: whether the title says what the page is about, whether the description is
worth clicking, or whether the OG image suits the page. Those are copy, and they answer to
`how-to/src/BRAND-VOICE.md` and to a reader.

The split matters because the checkable half is the half that fails **silently**. A
`Host`-derived canonical renders correctly, looks correct in the browser, and hands a proxied
copy of the site the right to call itself the original.

---

## Cross-references

- [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md) — the index and the seam statement
- [`STRUCTURED-DATA.md`](STRUCTURED-DATA.md) — the JSON-LD that accompanies this head
- [`../URL-STRATEGY.md`](../URL-STRATEGY.md) — where canonical paths come from
- [`../RENDERING.md`](../RENDERING.md) — why this is server-rendered and never client-injected
- `how-to/src/BRAND-VOICE.md` — the register for titles and descriptions

_Part of the `code/docs/` documentation family._
