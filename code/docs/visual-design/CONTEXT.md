# code/docs/visual-design

Sub-documents for the visual-design guide. The **cross-surface core** — the mandate, the project's
named direction and its six axes, and the ban list (Section 4.1 universal, Section 4.2 direction deviations) —
stays in the parent guide. These files hold only each surface's own expression of it: the signature
made concrete, the component vocabulary, and — where the surface has one — the pre-ship checklist
(`WEB.md`).

## Directory Tree

```text
code/docs/visual-design/
├── CLAUDE.md  ← operating rules
├── CONTEXT.md ← this file
├── WEB.md     ← Django templates + django-components + HTMX + Alpine + token CSS (`apps.marketing`)
├── MOBILE.md  ← **Mobile-only.** React Native — platform conformance and adaptivity, the two dimensions nothing else owns
└── DESKTOP.md ← **Desktop-only.** Slint — the stock-Fluent tell and the deliberate style choice
```

`MOBILE.md` and `DESKTOP.md` are `_exclude`-gated on their surface answers in `copier.yml`, matching
every other mobile, rust and desktop document in `code/docs/`. The rows above stay listed
unconditionally and flagged — a dangling index row is the established pattern here, because the
alternative is templated file contents.

**Each file holds only its surface's expression.** The mandate, the direction and its axes, the ban
list and the motion numbers are all in the parent guide, stated once.

## Cross-references

- `code/docs/VISUAL-DESIGN.md` — the index these sub-documents belong to
