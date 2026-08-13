---
type: guide
skills: [seo, stack-htmx-templates]
model: opus
---

# Structured Data — JSON-LD

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — typed JSON-LD builders, the XSS-safe serialiser, server-side rendering

Structured data is the machine-readable claim a page makes about itself. It is generated from
typed model fields, never hand-written, and never assembled in the browser.

---

## The pattern

All public pages eligible for Google Rich Results render a `<script type="application/ld+json">`
tag built by typed helpers in `apps/marketing/jsonld.py`. **Never hand-write JSON-LD strings in a
template.**

### Rules

- **Builder functions** (`build_organization_schema`, `build_article_schema`,
  `build_service_schema`, `build_howto_schema`) return plain Python dicts — pure functions, no
  side effects.
- **The `json_ld` template filter/util is the only authorised serialiser.** It escapes `<` to
  `<` so `</script>` cannot terminate the surrounding script block.
- **Render in the template**, so the JSON-LD is present in the static HTML the server returns —
  crawlable without JavaScript. Never inject it from an Alpine or other client-side runtime.
- **Optional fields use conditional keys** — omit the whole `<script>` tag rather than emit
  malformed JSON-LD when a required field is missing.
- **Do not store JSON-LD blobs in the database.** Generate from typed model fields at render time.
- **Multiple schemas on one page**: use separate `<script>` tags — one per schema.

```django
{# render a schema dict passed from the view #}
{% if org_schema %}
<script type="application/ld+json">{{ org_schema|json_ld }}</script>
{% endif %}
```

---

## Why the serialiser is a security control, not a convenience

A JSON-LD block is attacker-reachable whenever any of its fields comes from user input — an
article title, a product name, a review body. Serialising with a plain `json.dumps` and marking
it safe lets a stored `</script>` close the block and open an injection point. The escaping rule
above is the mitigation, which is why there is exactly **one** authorised serialiser and why
hand-written JSON-LD is banned rather than discouraged. See [`../SECURITY.md`](../SECURITY.md).

---

## Choosing a schema type

`Organization` is the default and belongs on the site root. Anything beyond it is a per-story
decision recorded in that story's SEO plan (`project-management/src/12-SEO/PLANNING/`), because
whether a page is an `Article`, a `Service`, a `FAQPage` or none of them is a claim about the
content, not a property of the stack.

**Never claim a type the page does not honestly satisfy.** Schema that misdescribes a page is a
manual-action risk with search engines and a credibility risk with answer engines, and it is not
recoverable by fixing the markup later.

---

## What is mechanically checkable here

**Nearly all of it — this is the most deterministic output in the family.** The emitted JSON
parses, required fields are present, and the declared type matches the page. That makes it test
coverage rather than review judgement: cover the builders with unit tests over their dict output,
and assert the rendered `<script>` block parses in a template test.

**Not** deterministic: whether the type chosen is the right one for the page, and whether the
values describe the thing honestly. A `Product` block with valid syntax and invented review counts
passes every check here and is a manipulation.

---

## Cross-references

- [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md) — the index and the seam statement
- [`WEB-METADATA.md`](WEB-METADATA.md) — the `<head>` this accompanies
- [`../SECURITY.md`](../SECURITY.md) — the escaping rule in its security context
- [`../TESTING.md`](../TESTING.md) — where the builder tests live
- [Schema.org](https://schema.org/) — the vocabulary

_Part of the `code/docs/` documentation family._
