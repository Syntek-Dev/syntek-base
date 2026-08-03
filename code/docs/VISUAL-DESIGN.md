---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Visual Design Language

**Last Updated:** <%DATE%>
**Version:** 0.1.0
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)
**Status:** Template. Codifies the visual-design discipline for the public site (`apps.marketing`)
and the shared component library.

> **Scope note (template).** §1 (the mandate) and §4 (the AI-look ban) are the generic, portable
> core — they travel to any project unchanged. §2 (artefact locations), §3 (the brand signature),
> and §5 (the component catalogue) carry `<%ORG_NAME%>`-level placeholders and generic token roles:
> fill them with the project's real brand system, component vocabulary, and design-artefact
> locations. See [Adopting this guide](#adopting-this-guide).

---

## 1. The mandate (portable)

Every page must be **unmistakably <%ORG_NAME%>**. The default failure mode of machine-authored UI is
the "AI-look": a symmetrical centred hero, one flat background, a single row of three equal cards,
rounded-everything with a soft drop shadow, and no vertical rhythm. It is competent, generic, and
forgettable — and it is a **review gate defect**, peer to the WCAG and HTMX-indicator gates.

The mandate, in one line: **never ship generic, centred, single-band UI — implement the design that
was already decided, in the <%ORG_NAME%> signature.** You are not inventing a layout; you are
building one.

---

## 2. Implement the design — do not invent it

A page's design is decided **upstream**, at _design-time_ — the PM/design agents run the grilling
interview and produce the artefacts (via Figma MCP / Claude Design; that flow is rooted in the
repo's `DESIGN.md`). Your job is _code-time_: build that intent against the live codebase. Before
writing any template or CSS, load the design artefacts for the screen:

| Load                            | For                                                                     |
| ------------------------------- | ----------------------------------------------------------------------- |
| the screen's **wireframe**      | the screen's layout, sections, and content order                        |
| the **component/pattern** specs | each component's states, variants, and composition patterns             |
| the **brand guide**             | the foundations — colour, type, motion, elevation, spacing, icons, logo |

In this repo the artefacts live under `project-management/src/` — wireframes in `08-WIREFRAMES/`,
components in `07-COMPONENTS/`, the brand guide in `06-BRAND-GUIDE/`; adjust to the host project's
own artefact locations.

- **The artefacts are intent; the live code is the built truth.** A project's code drifts from its
  planning once written — the shipped components, CSS, tokens, and page structure are the reality
  you extend. Reconcile the wireframe/design against what is actually there: reuse the real
  components and match established conventions; where the code has moved on from the artefact, follow
  the code (and surface the drift), do **not** re-apply a stale design. (Discipline:
  `FRONTEND-CODING-PRINCIPLES.md`.)
- The brand guide's **canonical foundations** (its rendered source of truth) win over any derived
  `.md` spec on conflict.
- **No artefact _and_ no established code pattern?** Then neither the design phase nor the code
  decides it — flag it (route back through the design-artefact workflows, or open a grilling pass);
  do not improvise a generic layout.

---

## 3. The <%ORG_NAME%> signature

The concrete moves that make a page read as <%ORG_NAME%>. Values are DB-canonical tokens — consume
`var(--token)` only, never a literal (see `DESIGN-TOKENS.md`); the brand guide holds the exact
values, this guide holds the **composition**. Fill the specific hues, typefaces, and variants below
from the project's own brand guide.

### Colour

- **One anchor colour, one accent.** `--color-primary` (the brand anchor hue) carries the logo,
  primary buttons, hero/footer, and `--surface-inverse`. `--color-accent` is for large text, icons,
  and UI accents only — **never** body copy (use `--color-accent-accessible` for links). Anchor +
  white is the core pairing; do not introduce off-palette hues.
- **Drive light/dark from semantic surfaces** — `--surface-page/-raised/-sunken/-overlay/-inverse`
  and `--text-primary/-secondary/-muted`, never raw `--color-neutral-*`.
- **Gradients are sanctioned `--gradient-*` tokens, never composed inline.** A raw
  `linear-gradient(135deg, …)` in component or page CSS is the generic AI-look tell — even when its
  stops are tokens. Consume `var(--gradient-*)` or a per-sector `var(--sector-tone-*)`; add a new
  brand gradient as a token in the token layer (`code/src/django/static/css/tokens/gradients.css`) plus a
  `design_tokens` migration, never as an inline literal. A functional gradient (loading shimmer,
  image or scrim mask) may stay inline **only** with a `gradient-allow` annotation. Enforced by
  `code/src/scripts/audits/css-gradients.sh`. No blue→purple, violet, indigo, or rainbow gradient —
  ever.

### Typography

- **Three typefaces by role, self-hosted (zero Google Fonts):** `--font-heading` (all h1–h6),
  `--font-primary` (body), `--font-secondary` (buttons, nav, labels). Never set body in the heading
  face; never hard-code a `font-family`.
- **Fluid, editorial headings:** `clamp()` scale, `--line-height-tight`, h1 **800 extrabold** with
  tight tracking; body at `--line-height-relaxed`. Body measure capped (~60ch).

### Layout — the house patterns (this is where the AI-look is won or lost)

- **Alternating section bands.** Stack `{% component "section" background="…" %}` alternating
  `page` / `sunken` (and `primary-light` / `inverse` for accents) down the page — a deliberate
  vertical rhythm, never one flat background.
- **Left-oriented editorial headings — not centred.** Section headers and grids align to the
  start (`text-align: start`, `justify-content: flex-start`), with a capped body beneath. The
  house alternative to the generic centred hero.
- **Full-bleed background, capped content.** The `section` component's background stretches to the
  viewport edge; the `container` locks content to `--section-inner-max-width`, centred with
  breakpoint-scaled `padding-inline`. No bare `<section>` in page content.
- **The 3px accent border.** Hero gets `border-block-start: 3px solid var(--color-accent)`; the
  matching CTA section gets the mirror on the bottom. A signature rule, not decoration.
- **Per-sector gradient tones.** Each audience sector the project serves has a fixed
  `--sector-tone-{slug}` gradient with built-in AA-safe text, reduced-motion, and forced-colors
  fallbacks. Pass the sector-tone prop; never hand-pick a gradient.
- **Pick a real hero variant** defined for the project (e.g. a solid-anchor hero, a split hero, or
  an editorial hero with eyebrow label + accent underline) — chosen by the wireframe. Do not build a
  fourth, centred, generic hero.

### Eyebrows & pills — a labelling device, used sparingly

The pill/badge above a heading **classifies content; it is not decoration**. Use an eyebrow pill only
where it tells the reader what a thing _is_ as they scan — a blog post's topic, a case-study or
portfolio category, a testimonial's sector, a pricing-tier tag. There it earns its place: it labels
quickly and neatly.

- **Default to no pill.** Add one only when it carries real taxonomy the reader benefits from.
- **Never stamp a pill above every section heading, on every page.** A pill on a plain marketing
  section is noise and reads as templated AI filler — a review-gate defect, like the AI-look layout.
- The hero eyebrow (the editorial hero's label) is a deliberate, single, per-page accent — not the
  same thing as scattering topic pills down a page that has no taxonomy to show.

### Elevation & motion

- **Soft, purposeful elevation.** Resting cards `--shadow-sm`, hover steps to `--shadow-md` (never
  jump to `lg`); modals `xl`. Every focusable element carries `--shadow-focus` — the focus ring is
  mandatory. Shadows convey depth, never ornament.
- **Restrained, token-paired motion.** Compose from `--motion-hover/-press/-enter/-exit/-modal`;
  button hover is a small `translateY(-3px)` + shadow, active `scale(0.97)`. Spring easing is for
  success only. **Everything sits behind `prefers-reduced-motion`** (non-negotiable).

### Icons & logo

- **Font Awesome only, `currentColor` by default** — via the `{% icon %}` tag; only status icons
  take a semantic colour. Never mix icon libraries or hard-code a hex on an `<i>`.
- **Never re-draw or re-type the wordmark**; never set the brand name in all-caps; the brand tagline
  is first-class copy but kept verbatim. (Fill the wordmark, tagline, and voice rules from the
  project brand guide.)

---

## 4. The AI-look — banned patterns

If a page does any of these, it is off-brand — fix it before hand-off:

- **Centred everything.** Centred hero headline + subtitle + two pill buttons, centred section
  headings, centred body. <%ORG_NAME%> is left-oriented and editorial.
- **One flat background** for the whole page — no alternating bands, no rhythm.
- **The three-equal-card grid as the _only_ device**, repeated down the page. Vary the vocabulary
  (split hero, timeline, sector grid, feature rows, CTA banner).
- **Inline or generic gradients.** A raw `linear-gradient(…)` composed in component CSS, a
  purple/violet/indigo or blue→purple ramp, a rainbow mesh, or any colour outside the palette. Brand
  gradients are delivered as `--gradient-*` / `--sector-tone-*` tokens only, in-palette.
- **Em dashes in body copy.** An em dash (—) in user-facing prose is a machine-authored tell. Reword
  with a comma, colon, full stop, or parentheses; **never** substitute a spaced en dash. (Numeric/day
  ranges like `Mon–Fri` keep their en dash.) See the project brand-voice guide; enforced by
  `code/src/scripts/audits/copy-emdash.sh`.
- **A pill/eyebrow above every heading.** Pills label taxonomy (blog topics, case studies,
  testimonials); a pill on a plain section is filler — see § 3 _Eyebrows & pills_.
- **Emoji in headings or UI chrome.** Icons are Font Awesome.
- **Rounded-everything + a soft drop shadow on every element.** Radius and elevation are scaled and
  purposeful, not a default coat.
- **Undifferentiated buttons** — no primary/secondary hierarchy; ghost buttons everywhere.
- **Filler copy** ("Lorem ipsum", "Empower your business", "Seamless solutions"). Copy is real and
  follows the brand-voice guide — substantiate or cut.

---

## 5. Compose from the component vocabulary

Duplicating a shared component is a defect. Build from the project's django-components catalogue
(e.g. `code/src/django/components/`) — hero variants, feature cards, sector/service grids, CTA
banners, process timelines, pricing matrices, testimonial cards/rows, content cards, badges,
breadcrumbs, cards, `section`, and `container` — and the shared UI primitives in the shared
component library. Reach for an existing component before authoring markup; a new component type is
added to the catalogue first, then used.

---

## 6. Pre-ship checklist

- [ ] Built against the screen's wireframe + component design artefacts — not improvised.
- [ ] Alternating section bands; left-oriented editorial headings; `section`/`container` nesting.
- [ ] Real hero variant chosen; 3px accent border on hero/CTA where the pattern applies.
- [ ] Sector pages pass the sector-tone prop; card text clears AA on the gradient.
- [ ] Every value resolves to a token (`bash code/src/scripts/audits/css-tokens.sh` clean).
- [ ] No inline gradient — brand gradients are `--gradient-*` / `--sector-tone-*` tokens
      (`bash code/src/scripts/audits/css-gradients.sh` clean).
- [ ] No em dash in copy (`bash code/src/scripts/audits/copy-emdash.sh` clean); no spaced-en-dash substitute.
- [ ] Pills/eyebrows used only for real taxonomy, not stamped on every heading.
- [ ] Responsive across the breakpoint scale, mobile-first (`RESPONSIVE-DESIGN.md`); verified at the
      test viewports, no horizontal scroll.
- [ ] Footer carries the full legal set (Terms, Privacy, Accessibility, Cookies, DPA) via the shared footer.
- [ ] Elevation scaled + focus ring present; motion token-paired and behind `prefers-reduced-motion`.
- [ ] None of the §4 banned patterns present.
- [ ] Copy is real and on-voice; WCAG 2.2 AA met; British English throughout.

---

## Adopting this guide

This guide ships as a template. §1 (the mandate) and §4 (the AI-look ban) are the portable core —
adopt them unchanged. Fill the placeholders in §2 (the artefact locations), §3 (the brand signature
— anchor and accent hues, the three font roles, hero variants, sector tones), and §5 (the component
catalogue) with the host project's own brand system, component vocabulary, and design-artefact
paths. The _shape_ of the guide is the portable part; the _content_ is per-project.
