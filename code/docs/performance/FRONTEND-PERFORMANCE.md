---
type: guide
skills: [backend, stack-django, stack-htmx-templates]
model: opus
---

# Performance — Frontend

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — page-weight budgets, HTMX/Alpine tuning, fragment caching, media, token CSS

---

## Frontend Performance

Every page is server-rendered Django templates with django-components, HTMX, and Alpine.js. There
is no bundler, no hydration step, and no client-side framework — the browser receives HTML and a
few kilobytes of versioned vendor script.

This removes the usual frontend performance problem (bundle size) and replaces it with a different
one: **the server is now on the critical path of every interaction.** A slow view is a slow UI.
Most of what governs perceived speed on this stack therefore lives in
[`DATABASE-PERFORMANCE.md`](DATABASE-PERFORMANCE.md) — the query behind the fragment — not here.

### Page-weight budget

| Asset                     | Budget   | Notes                                           |
| ------------------------- | -------- | ----------------------------------------------- |
| HTML (gzipped)            | < 50 KB  | A page over this is usually an unpaginated list |
| CSS (gzipped, all)        | < 40 KB  | Token layer + component CSS                     |
| JavaScript (gzipped, all) | < 30 KB  | HTMX + Alpine + any per-page script             |
| Total, first load         | < 150 KB | Excluding Cloudinary-delivered media            |

**Rules:**

- **No build step, and no bundler entry.** HTMX and Alpine are small, versioned vendor scripts
  served once and cached for a year. Adding a bundler is a stack change, argued in an ADR.
- **Before adding any JavaScript dependency, check its size** on
  [bundlephobia](https://bundlephobia.com). A 50 KB library for a 20-line function is not
  acceptable (see `CODING-PRINCIPLES.md` — Dependencies). On this stack, the honest first question
  is whether the behaviour belongs on the server at all.
- **Per-page JavaScript is a static file**, never an inline `<script>` — inline scripts break the
  CSP posture described in `code/docs/RENDERING.md`.

### HTMX and Alpine performance

- **Return partials, not whole pages.** An HTMX request renders the smallest template fragment that
  satisfies the swap (`hx-target` a specific element) — never re-render the full page to update one
  region.
- **Debounce chatty triggers.** Search-as-you-type and other input-driven requests use
  `hx-trigger="keyup changed delay:300ms"` so a keystroke does not equal a request.
- **`hx-boost` is banned** (`code/docs/RENDERING.md`) — every server op is an explicit `hx-*`
  attribute on the element that owns it.
- **Always show feedback.** `hx-indicator` and `hx-disabled-elt` on every non-instant request.
  Un-fed-back latency reads as broken, and on this stack latency is unavoidable.
- **Keep Alpine components small and local.** Alpine is for local interactivity (toggles, menus,
  tabs); anything touching data is an HTMX round-trip. Use `x-cloak` to avoid a flash of
  un-initialised content.
- **Serve HTMX and Alpine as versioned, content-hashed static assets** cached for a year; never
  inline them per page.

### Fragment caching

Because the server renders on every interaction, caching is the main lever — and it is applied at
the template level, not in the browser:

- **Cache whole anonymous pages.** Anonymous GET pages go through the versioned Valkey page cache.
  Anything that varies per visitor (consent banner, analytics) is decided client-side so the cached
  HTML is byte-identical for everyone.
- **`{% cache %}` expensive fragments.** A navigation tree, a footer, or a rendered content block
  that is costly and rarely changes should be cached by key and version, not recomputed per
  request.
- **Version the cache key, do not flush.** Bump a version component in the key on write; a global
  flush turns one edit into a thundering herd.

### Rendering strategy

See `code/docs/RENDERING.md` for the decision rule: full template for navigation and content, HTMX
for server operations, Alpine for rapid local interactions. There is no fourth option — an
interaction that appears to need one reopens the stack choice in an ADR.

---

## Media and Asset Optimisation (Cloudinary)

All user-facing images and video are delivered through Cloudinary. Let the CDN do the optimisation
rather than hand-rolling it:

- **Automatic format and quality:** deliver with `f_auto` (serves WebP/AVIF where the browser
  supports it) and `q_auto`. Do not hard-code a format.
- **Responsive sizes:** request width-specific derivations and emit a `srcset`/`sizes` pair (or use
  `dpr_auto`) so a 400px viewport never downloads a 2000px original.
- **Lazy load below the fold:** `<img loading="lazy" />`.
- **Prevent layout shift (CLS):** set explicit `width`/`height` attributes (or CSS `aspect-ratio`).
- **EXIF stripped on upload:** Cloudinary removes metadata on upload — both a privacy and a size
  win. See `SECURITY.md` — File Upload Security.
- **Icons:** use inline SVG served as static assets — not Cloudinary.
- **Delivery URLs are built server-side** in the view or template. There is no client-side
  Cloudinary SDK (`code/docs/cloudinary/CONTEXT.md`).

---

## Token CSS Performance

- Styling is vanilla CSS driven by design tokens (`var(--token)`). Tokens are static CSS custom
  properties — there is no runtime CSS-in-JS, so no style recalculation cost driven from
  JavaScript.
- CSS is served as content-hashed static assets, cached for a year. Component CSS only ever
  consumes `var(--token)`; it adds no per-render styling work.
- Keep the token layer lean — a custom property resolved once at the root is effectively free;
  deeply nested overrides that force style recalculation on every interaction are not.
- Core Web Vitals still govern the result: token CSS keeps the critical CSS small, which protects
  LCP and CLS. Inline only the tokens and above-the-fold rules the first paint needs.

_Part of the `code/docs/` documentation family. See [`../PERFORMANCE.md`](../PERFORMANCE.md) for the full index._
