---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Accessibility — Components, Announcements, and Testing

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — accessible django-component patterns, dynamic-update announcements, testing

---

## django-component Patterns

Shared UI is a django-component rendered on the server (`code/src/django/components/<snake>/`).
Because the component emits final markup, its accessibility is fixed at render time — there is no
client-side layer that can add a missing label later. The component is the last chance to get it
right.

### Accessible component signatures

A component that renders an interactive element **takes its accessible name as a required
argument** rather than hoping the caller remembers to pass one:

```python
# components/icon_button/icon_button.py
from django_components import Component, register


@register("icon_button")
class IconButton(Component):
    template_file = "icon_button.html"

    def get_context_data(self, *, icon: str, label: str, pressed: bool | None = None):
        # `label` is positional-by-keyword and has no default — an icon-only control
        # cannot be rendered without an accessible name.
        return {"icon": icon, "label": label, "pressed": pressed}
```

```django
{# icon_button.html #}
<button
  type="button"
  aria-label="{{ label }}"
  {% if pressed is not None %}aria-pressed="{{ pressed|yesno:"true,false" }}"{% endif %}
>
  {% include "icons/"|add:icon|add:".svg" with aria_hidden="true" %}
</button>
```

**Rules:**

- Decorative SVG carries `aria-hidden="true"`; the name lives on the control, not the icon.
- A busy control sets `aria-busy="true"` and keeps its accessible name — never swap the label for
  a spinner.
- Forward `aria-describedby` so a caller can attach help or error text.

### Announcing dynamic updates

An HTMX swap replaces markup without a page load, so screen readers announce nothing by default.
Put a persistent live region in the base template — outside every swap target, so it is never
itself replaced — and swap a message into it:

```django
{# base.html — persistent, never an hx-target of anything else #}
<div id="status" role="status" aria-live="polite" aria-atomic="true" class="sr-only"></div>
```

```python
def save_item(request, pk):
    ...
    response = render(request, "_item.html", {"item": item})
    response["HX-Trigger"] = json.dumps({"announce": "Changes saved"})
    return response
```

Use `aria-live="polite"` for routine updates and reserve `aria-live="assertive"` (or
`role="alert"`) for errors such as a failed save.

**Replacing the live region defeats it.** A region swapped in the same response as its message is
new to the accessibility tree and may never be announced. Keep the region static; change only its
contents. Focus management for the swapped region itself is in
[`INTERACTION.md`](INTERACTION.md).

### Visually hidden utility

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

/* Show on focus (for skip links) */
.sr-only:focus,
.sr-only:focus-within {
  position: static;
  width: auto;
  height: auto;
  padding: inherit;
  margin: inherit;
  overflow: visible;
  clip: auto;
  white-space: normal;
}
```

Define `.sr-only` once in the global token-driven CSS — every template and component shares the
one utility.

---

## Touch Targets

Interactive controls must be comfortably operable by touch and by users with limited dexterity.

- WCAG 2.2 SC 2.5.8 (Target Size, Minimum) requires a **24×24 CSS pixel** minimum, with spacing
  exceptions.
- As general good practice, size primary interactive targets to at least **44×44 CSS pixels** —
  the comfortable touch-target size — using token-driven padding rather than fixed literals.
- Do not place small tappable controls immediately adjacent to one another without spacing.

---

## Testing Accessibility

### Automated testing

Automated tools catch roughly 30–50% of accessibility issues. They are necessary, not sufficient —
the manual checklist below is where the rest is caught. Two automated layers:

- **pytest assertions on rendered markup** — landmarks, heading order, form labelling, `alt` text,
  accessible names, `aria-*` wiring. Cheapest and fastest, and they run on every push. Patterns in
  [`../testing/FRONTEND-TESTING.md`](../testing/FRONTEND-TESTING.md); run via
  `bash code/src/scripts/tests/backend.sh`.
- **axe-core WCAG 2.2 AA scan in a real browser** —
  `code/src/django/tests/e2e/test_e2e_a11y.py`, run via
  `bash code/src/scripts/tests/e2e-py.sh`. Critical and serious violations fail; moderate and minor
  warn. It scans four projects (desktop/mobile x light/dark) because dark-mode contrast
  regressions are invisible to a light-only scan.

> **The gate covers only what `a11y_config.PAGES` lists.** A page missing from that tuple is a page
> nobody scans — add each public route as it ships.

- **Lighthouse** — a useful third opinion in Chrome DevTools, per page, before shipping it.

What neither layer reaches — real focus order, screen-reader announcement, zoom and reflow — is
the manual checklist below. Treat it as mandatory rather than as a fallback.

### Manual testing

**Keyboard testing (every PR):**

1. Unplug or disable the mouse/trackpad.
2. Navigate the entire feature using only `Tab`, `Shift+Tab`, `Enter`, `Space`, `Escape`, and arrow
   keys.
3. Verify that every interactive element is reachable and operable.
4. Verify that focus order is logical and focus is visible at all times.

**Screen reader testing (every major feature):**

- **macOS:** VoiceOver (built-in, Cmd+F5 to toggle)
- **Windows:** NVDA (free) or JAWS
- **Mobile browsers:** VoiceOver (iOS Safari) and TalkBack (Android Chrome) for the responsive site

**Zoom and reflow testing:**

1. Set browser zoom to 200% — verify no content is lost or overlapping.
2. Set browser zoom to 400% at 1280px viewport width — verify content reflows to a single column.

---

## Accessibility Checklist

Before submitting any user-facing change for review:

- [ ] All interactive elements are operable with keyboard alone
- [ ] Tab order follows a logical reading sequence
- [ ] All form fields have programmatically associated labels
- [ ] Error messages are associated with their fields via `aria-describedby`
- [ ] Colour is not the only means of conveying information
- [ ] Text contrast meets 4.5:1 (normal) or 3:1 (large) minimums
- [ ] Images have appropriate `alt` text (informative or empty for decorative)
- [ ] Icon-only buttons have accessible labels (Font Awesome icons are `aria-hidden`)
- [ ] Focus is managed correctly when content changes dynamically (HTMX swaps, dialogs)
- [ ] Modals trap focus and return focus on close
- [ ] `prefers-reduced-motion` is respected for animations
- [ ] Interactive targets are at least 44×44 CSS pixels (24×24 minimum under WCAG 2.5.8)
- [ ] The page has a skip link to main content
- [ ] Heading levels are in logical order with one `<h1>` per page
- [ ] `lang` attribute is set on `<html>`
- [ ] Markup-level assertions (landmarks, headings, labels, accessible names) pass in pytest
- [ ] The route is listed in `a11y_config.PAGES` and the axe scan is clean (`e2e-py.sh`)
- [ ] Keyboard-only navigation has been manually verified

_Part of the `code/docs/` documentation family. See [`../ACCESSIBILITY.md`](../ACCESSIBILITY.md) for the full index._
