---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Responsive Design — Breakpoints and Device Reference

**Project:** {{PROJECT_NAME}} **Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:**
{{ORG_NAME}} **Language:** British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Responsive breakpoint tokens, device share, mobile-first viewport reference

---

## Device Split

| Device         | Share |
| -------------- | ----- |
| Mobile         | ~62%  |
| Desktop/Laptop | ~36%  |
| Tablet         | ~2%   |

_Source: StatCounter, early 2026_

Design mobile-first and scale up. Wireframes should always start from a mobile viewport.

---

## Web Breakpoints

```text
┌───────┬───────────┬──────────────────────────────────────────────────┐
│ Token │ Min width │                 Typical devices                  │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ base  │ 320px     │ Smallest phones — iPhone SE 1st gen, Galaxy S5   │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xs    │ 360px     │ Standard Android phones — Galaxy S series, Pixel │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ sm    │ 430px     │ Large phones — iPhone Pro Max, Pixel 7 Pro       │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xmd   │ 600px     │ Small tablets portrait, large phones landscape   │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ md    │ 768px     │ iPad mini / Air portrait, WXGA monitors          │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xlg   │ 1024px    │ Large tablets landscape, small laptops           │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ hd    │ 1280px    │ 720p HD, most common laptop (1280×720, 1366×768) │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ lg    │ 1920px    │ 1080p Full HD                                    │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xl    │ 2560px    │ 1440p QHD                                        │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ 2xl   │ 3840px    │ 4K UHD                                           │
└───────┴───────────┴──────────────────────────────────────────────────┘
```

> **Reference-only tokens.** The `--bp-*` breakpoint tokens (in `shared/src/css/tokens/`) and the
> matching `breakpoint` category in the `design_tokens` DB are **reference rows only**
> (`is_reference_only=True`) — they are documentation, never emitted to a CSS rule. CSS custom
> properties **cannot** sit inside `@media` query conditions, so the pixel values above must be
> baked literally into each `@media` condition. This is the one design-token category that the
> token-first law cannot make runtime-editable. See [../DESIGN-TOKENS.md](../DESIGN-TOKENS.md).

---

## Test Viewports

The public site is server-rendered Django templates, so responsive behaviour is verified in a real
browser with Playwright rather than any native-app harness. Set `page.set_viewport_size(...)` (or a
Playwright device descriptor) to each tier below and assert the layout at that width.

### Portrait — cover each breakpoint tier

```text
┌────────────────┬────────────────┬─────────────────────────────────────────────┐
│ Viewport (W×H) │ Breakpoint hit │            Representative device            │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 320×568        │ base           │ iPhone SE 1st gen                           │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 360×780        │ xs             │ Galaxy S24 / Pixel 7a                       │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 390×844        │ xs–sm          │ iPhone 15 / Pixel 8 — high real-world share │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 430×932        │ sm             │ iPhone 15 Pro Max / Plus                    │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 600×960        │ xmd            │ Galaxy Tab A7 Lite portrait                 │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 768×1024       │ md             │ iPad mini / Air portrait                    │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 1024×1366      │ xlg            │ iPad Pro 12.9" portrait                     │
└────────────────┴────────────────┴─────────────────────────────────────────────┘
```

### Landscape — critical for xmd and above

```text
┌────────────────┬────────────────┬─────────────────────────────┐
│ Viewport (W×H) │ Breakpoint hit │            Notes            │
├────────────────┼────────────────┼─────────────────────────────┤
│ 568×320        │ xs             │ iPhone SE landscape         │
├────────────────┼────────────────┼─────────────────────────────┤
│ 844×390        │ xlg            │ iPhone 15 landscape         │
├────────────────┼────────────────┼─────────────────────────────┤
│ 932×430        │ xlg            │ iPhone 15 Pro Max landscape │
├────────────────┼────────────────┼─────────────────────────────┤
│ 1024×768       │ xlg            │ iPad mini landscape         │
├────────────────┼────────────────┼─────────────────────────────┤
│ 1366×1024      │ lg             │ iPad Pro landscape          │
└────────────────┴────────────────┴─────────────────────────────┘
```

### Why these viewports specifically

- **390×844** is the single most important — sits between `xs` and `sm`, catches off-by-one errors.
- **xmd (600px)** is the most commonly missed tier — only activates on landscape phones and small
  tablets.
- **768px** is where tablet layouts kick in — always test portrait and landscape separately.

### Responsive overflow — minimum viable set

Responsive overflow is asserted in the browser suite by measurement
(`scrollWidth > clientWidth`), never by screenshot — add a row to `OVERFLOW_PAGES` in
`code/src/django/tests/e2e/test_e2e_marketing_overflow.py`. Prioritise these portrait viewports:

- 360×780
- 390×844
- 430×932
- 768×1024

Add **932×430 landscape** if the page has any landscape-specific layouts.

_Part of the `code/docs/` documentation family. See [`../RESPONSIVE-DESIGN.md`](../RESPONSIVE-DESIGN.md) for the full index._
