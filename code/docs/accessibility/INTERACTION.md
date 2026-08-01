---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Accessibility — Keyboard Navigation and Focus Management

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Keyboard navigation, focus management, ARIA interaction patterns

---

## Keyboard Navigation

Every interactive element must be operable with a keyboard alone.

### Rules

- All interactive elements must be reachable with `Tab` and `Shift+Tab`.
- All interactive elements must be activatable with `Enter` or `Space`.
- Custom components must implement expected keyboard patterns from the
  [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/patterns/).
- Tab order must follow a logical reading order. Do not use `tabindex` values greater than 0 —
  they create unpredictable tab order. Use `tabindex="0"` to make a non-interactive element
  focusable, and `tabindex="-1"` to make an element programmatically focusable but not in the
  tab order.
- `Escape` must close modal dialogs, popovers, and dropdown menus, returning focus to the
  triggering element.

### Common keyboard patterns

| Component   | Keys                                                                   |
| ----------- | ---------------------------------------------------------------------- |
| Button      | `Enter`, `Space` to activate                                           |
| Link        | `Enter` to follow                                                      |
| Checkbox    | `Space` to toggle                                                      |
| Radio group | `Arrow keys` to move between options                                   |
| Tab panel   | `Arrow keys` to switch tabs, `Tab` to enter panel content              |
| Menu        | `Arrow keys` to navigate, `Enter` to select, `Escape` to close         |
| Dialog      | `Tab` cycles within dialog, `Escape` closes                            |
| Combobox    | `Arrow keys` to navigate options, `Enter` to select, `Escape` to close |

### Skip link

Every page must include a skip link as the first focusable element:

```html
<body>
  <a href="#main-content" class="sr-only">Skip to main content</a>
  <nav><!-- navigation --></nav>
  <main id="main-content">
    <!-- page content -->
  </main>
</body>
```

---

## Focus Management

When content changes dynamically, focus must be managed deliberately.

### Rules

- When a modal dialog opens, move focus to the first focusable element inside the dialog.
- When a modal closes, return focus to the element that triggered it.
- When content is removed from the page (e.g., deleting an item from a list), move focus to a
  logical place. Do not let focus fall to `<body>`.
- After an HTMX swap that replaces the main content region, move focus to the new content's
  heading or first control.
- Focus indicators must be visible. Never use `outline: none` without providing a custom focus
  style.

### Moving focus after an HTMX swap

```html
<div
  id="panel"
  tabindex="-1"
  hx-get="/reports/summary/"
  hx-trigger="click from:#load-summary"
  hx-target="#panel"
  hx-swap="innerHTML"
>
  <!-- swapped content -->
</div>

<script>
  document.body.addEventListener("htmx:afterSettle", (e) => {
    if (e.detail.target.id === "panel") e.detail.target.focus();
  });
</script>
```

### Focus trapping in dialogs

Prefer the native `<dialog>` element — `showModal()` traps focus, makes the background inert, and
closes on `Escape` automatically, with no JavaScript of your own. For non-`<dialog>` overlays,
Alpine's Focus plugin (`x-trap`) traps and restores focus declaratively.

Hand-rolling a focus trap is the wrong answer on this stack: it is a well-known source of
accessibility bugs, and both supported options above already solve it.

```django
{# Native dialog — the browser handles the trap, the inert background, and Escape #}
<div x-data="{ open: false }">
  <button type="button" @click="$refs.dialog.showModal()">Edit details</button>

  <dialog x-ref="dialog" aria-labelledby="edit-title">
    <h2 id="edit-title">Edit details</h2>
    {% include "_edit_form.html" %}
    <button type="button" @click="$refs.dialog.close()">Cancel</button>
  </dialog>
</div>
```

```django
{# Non-dialog overlay — Alpine's Focus plugin traps and restores #}
<div x-data="{ open: false }" x-trap.noscroll="open" role="dialog" aria-modal="true">
  …
</div>
```

Where the dialog's contents come from the server, load them with `hx-get` into the dialog **before**
calling `showModal()`, so focus lands on populated markup rather than an empty shell.

---

## Forms and Inputs

Forms are one of the most common accessibility failure points. The same rules apply to a full-page
form post and to a form submitted through HTMX.

### Rules

- Every `<input>`, `<select>`, and `<textarea>` must have a `<label>` with a matching `for`/`id`
  attribute, or be wrapped in a `<label>` element.
- Placeholder text is not a label. Placeholders disappear when typing.
- Error messages must be programmatically associated with the field using `aria-describedby`.
- Error messages must not rely solely on colour. Include an icon or text prefix ("Error:").
- Required fields must be indicated with `aria-required="true"` or the HTML `required` attribute.
- Group related fields with `<fieldset>` and `<legend>`.
- Autocomplete attributes must be used on fields that collect personal information (WCAG 1.3.5).
- Validation errors returned by a django-ninja endpoint must be surfaced against the field they
  belong to, not only in a summary banner.

### Accessible form example

```html
<form novalidate>
  <div>
    <label for="email">Email address <span aria-hidden="true">*</span></label>
    <input
      type="email"
      id="email"
      name="email"
      autocomplete="email"
      required
      aria-required="true"
      aria-describedby="email-error"
      aria-invalid="true"
    />
    <p id="email-error" role="alert">Error: Please enter a valid email address.</p>
  </div>

  <fieldset>
    <legend>Preferred contact method</legend>
    <label><input type="radio" name="contact" value="email" /> Email</label>
    <label><input type="radio" name="contact" value="phone" /> Phone</label>
  </fieldset>

  <button type="submit">Submit</button>
</form>
```

### Inline validation

- Validate on blur (when the user leaves a field), not on every keystroke.
- When validation errors are corrected, update or remove the error message. Screen readers will
  announce the change if the error container uses `aria-live="polite"`.

---

## Motion and Animation

- Provide a way to pause, stop, or hide any content that moves for more than 5 seconds
  (WCAG 2.2.2).
- Respect the user's `prefers-reduced-motion` setting.

```css
.fade-in {
  animation: fadeIn 0.3s ease-in;
}

@media (prefers-reduced-motion: reduce) {
  .fade-in {
    animation: none;
  }
}
```

- No content should flash more than three times per second (WCAG 2.3.1 — seizure risk).

For full implementation patterns — CSS resets and JS/Alpine reduced-motion checks — see
[`../responsive/USER-PREFERENCES.md`](../responsive/USER-PREFERENCES.md).

_Part of the `code/docs/` documentation family. See [`../ACCESSIBILITY.md`](../ACCESSIBILITY.md) for the full index._
