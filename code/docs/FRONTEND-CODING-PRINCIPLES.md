---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Frontend Coding Principles — Django Templates + HTMX + Alpine + Vanilla CSS

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Frontend code review, naming conventions, error handling patterns
**MCP Servers:** code-review-graph (structural analysis, design pattern detection)

Read alongside **[CODING-PRINCIPLES.md](CODING-PRINCIPLES.md)**. The frontend is one surface:
Django templates + **django-components** + **HTMX** + **Alpine** + vanilla CSS (design tokens) +
inline SVG icons, server-rendered throughout. There is **no client-side framework, no bundler, and
no TypeScript** — public pages, the portal, and the admin area are all built the same way.

Interaction placement (server vs HTMX vs Alpine) is in **[RENDERING.md](RENDERING.md)** and the
`stack-htmx-templates` skill; the visual language in **[VISUAL-DESIGN.md](VISUAL-DESIGN.md)**;
server/Python principles in
**[BACKEND-CODING-PRINCIPLES.md](BACKEND-CODING-PRINCIPLES.md)**.

---

## Table of Contents

- [Templates & django-components](#templates--django-components)
- [HTMX & Alpine](#htmx--alpine)
- [Ground in the Live Code](#ground-in-the-live-code)
- [CSS — Coding Principles](#css--coding-principles)
- [Token-First CSS Consumption](#token-first-css-consumption)
- [Component & Code Placement](#component--code-placement)
- [Per-page JavaScript](#per-page-javascript)
- [Logging & Naming](#logging--naming)
- [What is not built yet](#what-is-not-built-yet)
- [Code Review Checklist (Frontend)](#code-review-checklist-frontend)

---

## Templates & django-components

Shared UI is a **django-component**, never inline markup. One folder per component:
`code/src/django/components/<snake>/<snake>.py` + `<snake>.html`; render with `{% component "<snake>" %}`.

- **Reuse before you build.** Check the `code/src/django/components/` catalogue first — duplicating
  a shared component is a defect.
- **Views stay thin.** A view composes data from the domain services and renders a template; business
  logic lives in the service layer, never the view or the template. Public pages pull published
  content from services directly (SSR).
- **Templates hold no logic.** Presentation only — no queries, no branching beyond display. Every
  view/template and component opens with a one-line, pronoun-free comment on **why** it exists —
  never what the markup renders, and never a story, ticket, doc path, or date
  ([`coding-principles/STYLE-AND-PROCESS.md`](coding-principles/STYLE-AND-PROCESS.md)).
- **CSP-clean.** No inline `<script>` or `<style>`. Alpine reads HTML attributes; HTMX is configured
  via `<meta>`; per-page JS is a static file. Content must be usable with JavaScript disabled — every
  link is a real `<a>`, Alpine only enhances.
- **django-components is the only component system, and `django-cotton` must not be reintroduced.**
  The two conflict: cotton installs a global template-compilation monkeypatch that django-components
  also patches, so the second one loaded wins and components silently stop rendering. It was tried
  and dropped for that reason. A second component library is a stack change, not a template choice.

---

## HTMX & Alpine

Place every interaction by class (full doctrine: [RENDERING.md](RENDERING.md)):

- **First load / navigation / content → server-rendered HTML** — the default.
- **Meaningful server op (save, submit, load, publish) → HTMX** fragment swap, **always** with a
  visible indicator (`htmx-indicator` / `hx-disabled-elt`). Un-fed-back latency reads as broken — a
  review gate.
- **Rapid / local interaction (live-filter, drag-reorder, menus, toggles) → Alpine** (`x-data`), no
  round-trip; sync to the server on commit, not per-keystroke.
- **`hx-boost` is banned.** Every server op is an explicit `hx-*` element.
- **Both sides of an HTMX exchange are typed.** The view builds a **view-model**, not a context
  dictionary assembled inline; `hx-vals` sends named fields parsed server-side into a request
  type; swap-target ids, event names and `HX-*` values are shared constants, never inline
  literals. An Alpine component past one property or any method is registered with
  `Alpine.data('name', …)` in a static file rather than inlined into `x-data`. Full rules:
  [`data-structures/TYPES-BROWSER.md`](data-structures/TYPES-BROWSER.md).

---

## Ground in the Live Code

The **live codebase is the source of truth for how things are built** — the shipped components,
CSS, tokens, and page structure. Planning artefacts (wireframes in `08-WIREFRAMES`, component
designs in `07-COMPONENTS`) capture _intent_, but a project's code **drifts from its planning once
written**. Implement from the code that exists, not from the plan in the abstract:

- **Read the shipped code first.** Reuse and extend the real components, tokens, and conventions
  before authoring anything new — an established pattern beats a fresh one that only matches the
  diagram.
- **Reconcile intent against reality.** Where the code has moved on from the artefact, follow the
  code and surface the drift; never re-apply a stale design or reintroduce a superseded pattern.
- **Verify against the running app, not the mock** — the actual rendered page and the component
  catalogue, not just the wireframe.

The visual counterpart — the <%ORG_NAME%> signature and the anti-generic mandate — is
[VISUAL-DESIGN.md](VISUAL-DESIGN.md).

---

## CSS — Coding Principles

Applies to every `.css` file in `code/src/django/static/css/` (page and layer CSS) and to the CSS
co-located with each django-component in `code/src/django/components/<snake>/`. Tokens live in
`code/src/django/static/css/tokens/`.

- **Token-first.** Never define a colour, spacing, radius, typography, shadow, or motion value in a
  component or page CSS file — consume `var(--token)` only (see below + [DESIGN-TOKENS.md](DESIGN-TOKENS.md)).
- **WET / Rule of Three.** Duplicate freely once, tolerate twice, extract on the third occurrence.
  Three files sharing a rule is the extraction threshold, not two.
- **DRY.** A multi-property block appearing identically in 4+ files is extracted to a shared utility
  (`sections/utility.css`), a section layer (`sections/*.css`), or `base/reset.css`.
- **KISS.** Prefer one obvious utility class over deeply nested selectors or cascade tricks. If a rule
  needs more than a sentence to explain, simplify it.
- **Component encapsulation.** A component's CSS styles only that component. Page CSS never
  re-declares a component's internals — override only via a BEM modifier (`.card--featured`) or a
  scoped parent.
- **Logical properties.** Always `margin-block-end`, `padding-inline`, `border-block-start` — never
  physical (`margin-bottom`, `padding-left`) in new or refactored code.
- **Focus ring.** Never `outline: none; box-shadow: var(--shadow-focus)` in a component — the global
  `:focus-visible` in `base/reset.css` handles every focus ring.
- **Order.** `@import` at the top (external reset → tokens → utilities → components); all `@media` /
  `@container` / `@supports` at the **bottom** of the file, after the base declarations.

---

## Token-First CSS Consumption

Design values are **DB-canonical** — owned by the `design_tokens` system, not component CSS. Full
spec: **[DESIGN-TOKENS.md](DESIGN-TOKENS.md)**. Consumption rules:

- **Never write a raw visual literal** (colour, length, shadow, duration, radius, font). Add the token
  first — via the `/admin/design-tokens` editor or a migration — then reference it.
- **Only ever consume `var(--token)`.** Component CSS reads tokens; it never defines visual values.
- **Gradients are tokens too.** Never compose a `linear-/radial-/conic-gradient(…)` inline in
  component or page CSS — a generic inline gradient is the AI-look tell (`VISUAL-DESIGN.md`). Consume
  `var(--gradient-*)` / `var(--sector-tone-*)`; add a new brand gradient via
  `shared/src/css/tokens/gradients.css` + a `design_tokens` migration. A functional gradient (loading
  shimmer, scrim mask) may stay inline **only** with a `gradient-allow` annotation. Enforced by
  `code/src/scripts/audits/css-gradients.sh`.
- **The var must resolve** in the token layer (`shared/src/css/tokens/*.css` + `surfaces.css`, served
  live at `/assets/tokens.css`). A phantom `var(--x)` is silently dropped by Lightning CSS —
  **enforced in CI** by `code/src/scripts/audits/css-tokens.sh`. Run it before a PR:

```bash
bash code/src/scripts/audits/css-tokens.sh
```

---

## Component & Code Placement

Before writing new code, decide where it belongs:

| Artefact                      | Location                                                                       |
| ----------------------------- | ------------------------------------------------------------------------------ |
| Server component (shared UI)  | `code/src/django/components/<snake>/` — `.py` + `.html`, `{% component %}`     |
| Public page (view + template) | `code/src/django/apps/marketing/` — thin view + Django template (SSR)          |
| Design token value            | DB-canonical (`apps/design_tokens`); the CSS seed is `static/css/tokens/*.css` |
| Reusable component + its CSS  | `code/src/django/components/<snake>/` — `.py` + `.html` + `.css`, co-located   |
| Per-page JavaScript           | a static file under `code/src/django/static/js/` — never an inline `<script>`  |

`apps/design_tokens` is the single source of token values; `code/src/django/components/` is the
authority for component styling and BEM. Never duplicate or conflict with an established component
pattern. When in doubt, extend the existing component before adding a new one.

**The legal footer is data, not markup.** The shared `site_footer` renders the full legal set —
Terms, Privacy, Accessibility, Cookies, DPA — from `navigation.py::FOOTER_LEGAL_LINKS`, never
hand-dropped per page. The reason is that the set changes: a new jurisdiction, a cookie banner, a
processor agreement. Hand-written links mean the page that was built last month keeps the old
set, and nothing reports it, because a missing legal link renders perfectly.

---

## Per-page JavaScript

Beyond HTMX and Alpine, hand-written JavaScript is the exception and stays small enough to read in
one sitting. There is no bundler and no module graph — a page script is a plain static `.js` file
loaded with `<script defer src="{% static %}">`.

- **Server first.** Before writing a line of JavaScript, establish that the behaviour cannot be an
  HTMX round-trip or an Alpine attribute. Almost always it can.
- **Data enters via `{% json_script %}`**, never by interpolating values into a script body —
  interpolation is both an XSS vector and a CSP violation.
- **No new dependency without an ADR.** A package here is a stack change: it implies a bundler, a
  lockfile in the delivery path, and a supply-chain surface the template deliberately does not have.
- **Progressive enhancement is mandatory.** The page must render and its links must work with
  JavaScript disabled — a script may improve an interaction, never enable it.

---

## Logging & Naming

**Logging.** Never `console.log/warn/error()` in committed code — route browser JS through the
project logger so output reaches GlitchTip, and server code through Django logging
([LOGGING.md](LOGGING.md)). Remove temporary debug logs before committing.

**Naming.** `snake_case` for Python, template files, and component folders; `kebab-case` for CSS
classes and file names; in browser JavaScript, `camelCase` (vars/functions) and
`SCREAMING_SNAKE_CASE` (constants). Global conventions:
[CODING-PRINCIPLES.md](coding-principles/PRACTICAL-RULES.md#naming-conventions).

---

## What is not built yet

The web peer of [`MOBILE-CODING-PRINCIPLES.md`](MOBILE-CODING-PRINCIPLES.md) Section 5, and it exists
for the same reason: an absence nobody wrote down is indistinguishable from an oversight, and
gets rebuilt slightly differently by whoever notices it next.

Shipped at baseline: `templates/500.html`, `apps/core/templatetags/core.py`
(`{% request_id %}`), and `static/js/observability.js`. Each is proved by a gate that runs —
ruff, ESLint, Prettier — rather than by review.

| Not built                                     | Why it waits                                                                                                    |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `templates/marketing/base.html`               | Needs the visual direction (`VISUAL-DESIGN.md` Section 3) and the brand voice, both settled at first-time setup |
| The `#error-region` div                       | Lives in that base template; until then `observability.js` creates it at runtime                                |
| The HTMX error partial                        | Needs the base template to inherit from, and the voice to be written in                                         |
| The `<script>` tag loading `observability.js` | Same — there is no base template to put it in, so nothing loads the handler                                     |
| The `css/tokens/` layer                       | Design values are DB-canonical; the stylesheet arrives with `apps.design_tokens`                                |

**The consequence to hold in mind:** `audits/negative-space.sh` (`htmx-handler-absent`) is a
**no-op until the first template uses `hx-`**, because it keys on that. So the handler is
shipped and unproven in this repository, and the first page to use HTMX is what turns the clause
on. That is correct for the clause and worth knowing before assuming a green run means anything
here.

`code/src/scripts/development/new-django-view.sh` already **requires**
`templates/marketing/base.html` and refuses to run without it, so the first row above is the one
that unblocks the rest.

---

## Code Review Checklist (Frontend)

In addition to the [global checklist in CODING-PRINCIPLES.md](coding-principles/STYLE-AND-PROCESS.md#code-review-checklist):

- [ ] Built from the shipped code — real components/tokens/conventions reused, wireframe/design
      reconciled against what is actually there (not improvised from the plan)
- [ ] Shared UI is a `{% component %}`, not inline markup; views thin; templates logic-free
- [ ] Interactions placed by class — server default, HTMX (with a visible indicator) for server ops,
      Alpine for local; `hx-boost` absent; usable with JS disabled
- [ ] Nothing fails silently — a 5xx swaps a real error region rather than nothing, and an
      unresolved template variable is visible in dev ([rendering/PITFALLS-AND-EXAMPLES.md](rendering/PITFALLS-AND-EXAMPLES.md))
- [ ] CSP-clean — no inline `<script>` / `<style>`
- [ ] No raw visual literal — every value is `var(--token)`; `css-tokens.sh` clean
- [ ] No inline gradient — brand gradients are `--gradient-*` / `--sector-tone-*` tokens;
      `css-gradients.sh` clean (functional shimmer/mask exempt via `gradient-allow`)
- [ ] No em dash in user-facing copy — reworded, never a spaced-en-dash substitute; `copy-emdash.sh` clean
- [ ] No banned sentence pattern or vocabulary in user-facing copy; `copy-slop.sh` clean and its
      warnings answered (`how-to/src/BRAND-VOICE.md` Section 4)
- [ ] Pills/eyebrows only for real taxonomy (blog topics, case studies, testimonials), not on every heading
- [ ] Responsive mobile-first across the breakpoint scale (`RESPONSIVE-DESIGN.md`); no horizontal scroll
- [ ] Footer carries the full legal set (Terms, Privacy, Accessibility, Cookies, DPA) via the shared footer
- [ ] Not the generic "AI-look" — <%ORG_NAME%> signature met (`VISUAL-DESIGN.md`)
- [ ] CSS: `@import` at top, queries at the bottom; logical properties; BEM; no per-component focus
      ring; no declaration block repeated in 4+ files
- [ ] Any hand-written JS is a static file, data via `{% json_script %}`, no new dependency
- [ ] Typed both ways — view-model out, request type in; no context dict assembled inline in the
      view; `Alpine.data` for anything past a single boolean; swap targets, event names and
      `HX-*` values are shared constants ([data-structures/TYPES-BROWSER.md](data-structures/TYPES-BROWSER.md))
- [ ] No `console.log/warn/error()` in committed code
- [ ] British English throughout
