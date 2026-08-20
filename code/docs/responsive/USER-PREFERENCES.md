---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Responsive Design — User Preferences and Dark Mode

**Project:** <%PROJECT_NAME%> **Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:**
<%ORG_NAME%> **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Dark mode, reduced-motion, contrast, and accessibility preference queries

---

## User Preferences Overview

These media queries reflect explicit OS-level or browser-level settings. They are non-negotiable —
always respect them. Ignoring them is an accessibility failure.

> **Token-first.** All six of these preference axes **will be** modelled as `DesignTokenValue`
> variant rows in the `design_tokens` system, and the generator **will emit** the **full preference
> cascade** — `:root`, `[data-theme]`, `@media (prefers-color-scheme)`, and the single-axis and
> compound `@media` blocks below — from those rows. **Never hand-edit the generated or preference
> blocks**; change the value via the `/admin/design-tokens` editor (or the CSS token layer that
> seeds it) and let the generator re-emit. The generator is specified in
> [../design-tokens/CASCADE.md](../design-tokens/CASCADE.md); the token layer in
> [../DESIGN-TOKENS.md](../DESIGN-TOKENS.md).

| Query                          | Values                                    | What it signals                             |
| ------------------------------ | ----------------------------------------- | ------------------------------------------- |
| `prefers-color-scheme`         | `light`, `dark`                           | OS dark/light mode setting                  |
| `prefers-reduced-motion`       | `no-preference`, `reduce`                 | Reduced Motion enabled in OS                |
| `prefers-contrast`             | `no-preference`, `more`, `less`, `forced` | High or low contrast preference             |
| `forced-colors`                | `none`, `active`                          | Windows High Contrast / Forced Colours mode |
| `prefers-reduced-transparency` | `no-preference`, `reduce`                 | Reduce Transparency enabled (macOS/iOS)     |
| `prefers-reduced-data`         | `no-preference`, `reduce`                 | Data Saver / metered connection             |

---

## Dark Mode — `prefers-color-scheme`

Design and implement for both light and dark at the same time. Never add dark mode as an afterthought.

### How this project implements dark mode

All theming belongs in the CSS token layer once it lands (`code/docs/DESIGN-TOKENS.md`). Two
distinct files within it:

| File           | Purpose                                                          |
| -------------- | ---------------------------------------------------------------- |
| `colours.css`  | Primitive colour values — never change between modes             |
| `surfaces.css` | Semantic tokens — the only file that defines dark mode overrides |

Components always reference semantic tokens from `surfaces.css`, never primitive colours from
`colours.css` directly. Dark mode is automatic for any component that follows the rules.

All colour values use the **OKLCH** format: `oklch(L% C H)`. Never use raw hex or RGB in token
definitions or component CSS.

### Two-level dark mode system

**Level 1 — OS preference (global):**

```css
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --surface-page: var(--color-dark-2);
    --surface-raised: var(--color-dark-3);
    /* … all tokens … */
  }
}
```

**Level 2 — Scoped attribute (any element):**

Set `data-theme` on any element in a Django template (or django-component); the generated cascade
resolves every token beneath it. Because the attribute is server-rendered, the correct theme is in
the first byte of HTML — there is no flash of the wrong theme while a script boots.

```html
{# Dark section on an otherwise light page #}
<section data-theme="dark">
  {% component "button" variant="primary" %}Always dark here{% endcomponent %}
</section>

{# Light panel inside a dark page #}
<aside data-theme="light">
  {% component "badge" variant="success" %}Always light here{% endcomponent %}
</aside>
```

### Token block rules

**Every token defined in `[data-theme="dark"]` must also appear in the `@media` dark block with
identical values, and vice versa.** The two dark blocks must always be in sync.

**Every token defined in either dark block must appear in `[data-theme="light"]` with its light
mode value.** Shadow tokens are the most commonly missed — always include them.

### Component CSS rules

- **Never use raw colour values in component CSS.** Every colour must come from a CSS custom property.
- **Never reference `--color-*` primitives directly in component CSS.** Always go through a semantic
  `--surface-*`, `--text-*`, `--border-*`, `--btn-*`, or `--badge-*` token.
- When adding a new token to either dark block, add it to all three: both dark blocks and
  `[data-theme="light"]`.

### JavaScript — reading and reacting to the OS preference

The OS preference is handled entirely by the generated `@media (prefers-color-scheme)` block — no
JavaScript is required for automatic theming. Reach for JavaScript only to persist an **explicit**
user override (a light/dark toggle that sets `data-theme` on `<html>`). Standard `matchMedia()`:

```javascript
const mq = window.matchMedia("(prefers-color-scheme: dark)");

if (mq.matches) {
  applyTheme("dark");
}

mq.addEventListener("change", (e) => {
  applyTheme(e.matches ? "dark" : "light");
});
```

**Alpine.js theme toggle** — persists the choice and reflects it via `data-theme` on the root
element:

```html
<button
  type="button"
  x-data="{ scheme: window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light' }"
  x-init="document.documentElement.dataset.theme = scheme"
  @click="scheme = scheme === 'dark' ? 'light' : 'dark';
          document.documentElement.dataset.theme = scheme"
>
  Toggle theme
</button>
```

---

## Reduced Motion — `prefers-reduced-motion`

Users enable this at the OS level when animations cause discomfort, dizziness, or distraction.

**CSS — global reset baseline:**

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Provide a purposeful alternative rather than just removing the effect:

```css
.slide-in {
  animation: slideIn 0.4s ease-out;
}

@media (prefers-reduced-motion: reduce) {
  .slide-in {
    animation: fadeIn 0.15s ease-out;
  }
}
```

**JavaScript-driven animations** must honour the preference too — the CSS reset only covers CSS
animations and transitions. Gate any JS animation on the same query. In Alpine.js:

```html
<div
  x-data="{ reduceMotion: window.matchMedia('(prefers-reduced-motion: reduce)').matches }"
  x-init="if (!reduceMotion) { /* start the JS animation */ }"
></div>
```

Any scripted motion — an Alpine transition, a scroll behaviour — reads the same
`window.matchMedia("(prefers-reduced-motion: reduce)")` value before it starts.

---

## High Contrast — `prefers-contrast` and `forced-colors`

**`prefers-contrast`:** the token overrides are emitted by the generator for this axis (OKLCH, never
raw hex); component CSS only adds structural reinforcement (thicker borders, larger outline offset):

```css
@media (prefers-contrast: more) {
  :root {
    /* generated from the design_tokens `prefers-contrast: more` variant rows */
    --text-body: oklch(0% 0 0);
    --surface-page: oklch(100% 0 0);
    --border-default: oklch(0% 0 0);
  }
  .btn {
    border: 2px solid currentColor;
    outline-offset: 2px;
  }
}
```

**`forced-colors` (Windows High Contrast mode):**

```css
@media (forced-colors: active) {
  .btn {
    border: 2px solid ButtonText;
    background: ButtonFace;
    color: ButtonText;
  }
  /* Restore structure that was conveyed via background alone */
  .card {
    border: 1px solid CanvasText;
  }
}
```

**Rules:**

- Never use `forced-color-adjust: none` without a strong reason.
- Test in Windows High Contrast mode before every release.
- Borders and outlines are preserved in forced-colours mode; backgrounds and `box-shadow` are not.

---

## Reduced Transparency — `prefers-reduced-transparency`

```css
@media (prefers-reduced-transparency: reduce) {
  .frosted-panel {
    backdrop-filter: none;
    background-color: var(--surface-raised);
  }
}
```

---

## Reduced Data — `prefers-reduced-data`

```css
@media (prefers-reduced-data: reduce) {
  .hero {
    background-image: none;
  }
}
```

---

_Part of the `code/docs/` documentation family. See [`../RESPONSIVE-DESIGN.md`](../RESPONSIVE-DESIGN.md) for the full index._
