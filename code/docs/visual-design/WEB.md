---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Visual Design — the Web Surface

**Last Updated:** <%DATE%>
**Version:** 0.1.0
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)

The **web** expression of the doctrine in [`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) — Django
templates + django-components + HTMX + Alpine + token CSS, served by `apps.marketing`.

**Read the index first.** The mandate (Section 1), the project's **direction and its six axes** (Section 3), and
the ban list (Section 4.1 universal, Section 4.2 direction deviations) all live there and govern this file. This
guide holds only what is specific to the web surface: the signature made concrete in CSS and
components, the component vocabulary, and the pre-ship checklist.

> **Written in the default `editorial` direction.** Every clause below is the default direction
> expressed in this stack, **not house law**. A project whose Section 3 axes differ must restate the
> colour, typography and layout clauses against its own settings — see the index, _Adopting this
> guide_.

**Tiers.** Every clause specific to this surface carries an inline marker naming what a script can
decide about it. A clause that only restates a rule owned elsewhere carries none — the
inline-gradient tell and the pill taxonomy rule are the index's (Section 4.1), the `var(--token)`-only law
is `../DESIGN-TOKENS.md`'s — because a second copy of a tier drifts from the doctrine it partitions.
Tier scheme: [`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) Section 6.

---

## The signature, in CSS and components

Values are DB-canonical tokens — consume `var(--token)` only, never a literal (see
`../DESIGN-TOKENS.md`); the brand guide holds the exact values, this guide holds the
**composition**. Fill the specific hues, typefaces, and variants below from the project's own brand
guide.

### Colour

- **One anchor colour, one accent.** **[judgement]** `--color-primary` (the brand anchor hue) carries the logo,
  primary buttons, hero/footer, and `--surface-inverse`. `--color-accent` is for large text, icons,
  and UI accents only — **never** body copy (use `--color-accent-accessible` for links). Anchor +
  white is the core pairing; do not introduce off-palette hues.
- **Drive light/dark from semantic surfaces** — **[gate: fail]** `--surface-page/-raised/-sunken/-overlay/-inverse`
  and `--text-primary/-secondary/-muted`, never raw `--color-neutral-*`. A `var(--color-neutral-…)`
  reference in component or page CSS is an unambiguous match; the token layer, where the semantic
  surfaces are composed from the neutrals, is out of scope (same scoping as `css-gradients.sh`).
- **Gradients are sanctioned `--gradient-*` tokens, never composed inline.** A raw
  `linear-gradient(135deg, …)` in component or page CSS is the generic AI-look tell — even when its
  stops are tokens. Consume `var(--gradient-*)` or a per-sector `var(--sector-tone-*)`; add a new
  brand gradient as a token in the token layer (`code/src/django/static/css/tokens/gradients.css`) plus a
  `design_tokens` migration, never as an inline literal. A functional gradient (loading shimmer,
  image or scrim mask) may stay inline **only** with a `gradient-allow` annotation. Enforced by
  `code/src/scripts/audits/css-gradients.sh`. No blue→purple, violet, indigo, or rainbow gradient —
  ever.

### Typography

- **Three typefaces by role, self-hosted (zero Google Fonts):** **[gate: fail]** `--font-heading` (all h1–h6),
  `--font-primary` (body), `--font-secondary` (buttons, nav, labels). Never set body in the heading
  face **[judgement]**; never hard-code a `font-family`. A `fonts.googleapis.com` / `fonts.gstatic.com`
  reference in a template or stylesheet, and a literal `font-family` in component or page CSS, are
  both unambiguous matches.
- **Fluid, editorial headings:** **[gate: warn]** `clamp()` scale, `--line-height-tight`, h1 **800 extrabold** with
  tight tracking; body at `--line-height-relaxed`. Body measure capped (~60ch). _(Contrast axis:
  `loud`. A `quiet` direction sets a lighter weight and wider tracking here.)_

### Layout — the house patterns (this is where the AI-look is won or lost)

- **Alternating section bands.** **[gate: warn]** Stack `{% component "section" background="…" %}` alternating
  `page` / `sunken` (and `primary-light` / `inverse` for accents) down the page — a deliberate
  vertical rhythm, never one flat background. _(Rhythm axis: `banded`.)_
- **Left-oriented editorial headings — not centred.** **[gate: warn]** Section headers and grids align to the
  start (`text-align: start`, `justify-content: flex-start`), with a capped body beneath. The
  house alternative to the generic centred hero. _(Alignment axis: `start`.)_
- **Full-bleed background, capped content.** The `section` component's background stretches to the
  viewport edge; the `container` locks content to `--section-inner-max-width`, centred with
  breakpoint-scaled `padding-inline`. No bare `<section>` in page content **[gate: fail]**.
  _(Direction-independent — this is a containment rule, not a composition choice.)_
- **The 3px accent border.** **[judgement]** Hero gets `border-block-start: 3px solid var(--color-accent)`; the
  matching CTA section gets the mirror on the bottom. A signature rule, not decoration.
- **Per-sector gradient tones.** **[judgement]** Each audience sector the project serves has a fixed
  `--sector-tone-{slug}` gradient with built-in AA-safe text, reduced-motion, and forced-colors
  fallbacks. Pass the sector-tone prop; never hand-pick a gradient.
- **Pick a real hero variant** **[judgement]** defined for the project (e.g. a solid-anchor hero, a split hero, or
  an editorial hero with eyebrow label + accent underline) — chosen by the wireframe. Do not build a
  fourth, generic hero that matches no variant the project defined.

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

This is the **taxonomy rule**, and it is direction-independent — it lives in the index at Section 4.1, not
in Section 4.2. A direction may change how a pill _looks_; it never licenses a pill that labels nothing.

### Elevation

- **Soft, purposeful elevation.** **[gate: warn]** Resting cards `--shadow-sm`, hover steps to `--shadow-md` (never
  jump to `lg`); modals `xl`. Every focusable element carries `--shadow-focus` — the focus ring is
  mandatory. Shadows convey depth, never ornament.

### Motion — the web expression

**The numbers are `../VISUAL-DESIGN.md` Section 5** — durations, the easing hierarchy, the frequency rule,
entry scales, stagger, and the reduced-motion contract. This section states only how they are
expressed in CSS.

- **Compose from the `--motion-*` tokens**, never a literal duration or timing function: **[gate: fail]**
  `--motion-hover/-press/-enter/-exit/-modal`. Their values come from Section 5 through the `motion` token
  category; a raw `transition: 200ms ease` in component CSS is a token-first violation. The literal
  timing function is the web-specific half — Section 5 states the duration rule for every surface.
- **CSS transitions and `@keyframes` only** — **[gate: fail]** animate `transform` and `opacity`, nothing else.
- Button hover is a small `translateY(-3px)` plus the shadow step; active is `scale(0.97)`. **[gate: warn]**
- **`prefers-reduced-motion: reduce` selects the token's `reduce` axis**, **[gate: fail]** which is a second set of
  values — not a blanket `animation: none`. Keep opacity and colour transitions; drop the transform.
  See `../design-tokens/CASCADE.md` for how the axis resolves.

### Icons & logo

- **Font Awesome only, `currentColor` by default** — via the `{% icon %}` tag; only status icons
  take a semantic colour. Never mix icon libraries or hard-code a hex on an `<i>`. **[gate: fail]**
- **Never re-draw or re-type the wordmark**; **[judgement]** never set the brand name in all-caps; the brand tagline
  is first-class copy but kept verbatim. (Fill the wordmark, tagline, and voice rules from the
  project brand guide.)

---

## Compose from the component vocabulary

Duplicating a shared component is a defect. **[judgement]** Build from the project's django-components catalogue
(e.g. `code/src/django/components/`) — hero variants, feature cards, sector/service grids, CTA
banners, process timelines, pricing matrices, testimonial cards/rows, content cards, badges,
breadcrumbs, cards, `section`, and `container` — and the shared UI primitives in the shared
component library. Reach for an existing component before authoring markup; a new component type is
added to the catalogue first, then used.

---

## Pre-ship checklist — web

Rows restate clauses owned above, in the index, or in a neighbouring guide (`../ACCESSIBILITY.md`,
`../RESPONSIVE-DESIGN.md`, `../FRONTEND-CODING-PRINCIPLES.md`); they carry no tier markers, because
the tier belongs to the clause and a second copy of it drifts (index Section 6).

- [ ] Built against the screen's wireframe + component design artefacts — not improvised.
- [ ] Index Section 3 names a direction and every axis carries a setting — not `TBD`.
- [ ] Composition matches the direction's axes; `section`/`container` nesting intact. _(Under the
      default `editorial`: alternating section bands, left-oriented headings.)_
- [ ] Real hero variant chosen; 3px accent border on hero/CTA where the pattern applies.
- [ ] Sector pages pass the sector-tone prop; card text clears AA on the gradient.
- [ ] Every value resolves to a token (`bash code/src/scripts/audits/css-tokens.sh` clean).
- [ ] No inline gradient — brand gradients are `--gradient-*` / `--sector-tone-*` tokens
      (`bash code/src/scripts/audits/css-gradients.sh` clean).
- [ ] No em dash in copy (`bash code/src/scripts/audits/copy-emdash.sh` clean); no spaced-en-dash substitute.
- [ ] No machine cadence in copy (`bash code/src/scripts/audits/copy-slop.sh` clean); its warnings
      answered, and the `[judgement]` clauses read by a human (`how-to/src/BRAND-VOICE.md` Section 4).
- [ ] Pills/eyebrows used only for real taxonomy, not stamped on every heading.
- [ ] Responsive across the breakpoint scale, mobile-first (`../RESPONSIVE-DESIGN.md`); verified at
      the test viewports, no horizontal scroll.
- [ ] Footer carries the full legal set (Terms, Privacy, Accessibility, Cookies, DPA) via the shared footer.
- [ ] Elevation scaled + focus ring present; motion composed from `--motion-*` tokens, no literal
      duration or timing function.
- [ ] Any action a user performs 100+ times a day has **no** animation (index Section 5, frequency first).
- [ ] `reduce` axis keeps opacity and colour and drops transform — not a blanket `animation: none`.
- [ ] None of the index Section 4.1 or Section 4.2 banned patterns present.
- [ ] Copy is real and on-voice; WCAG 2.2 AA met; British English throughout.

---

## Cross-references

- [`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) — the index: mandate, direction and axes, ban list
- `../DESIGN-TOKENS.md` — the token catalogue and the `var(--token)`-only law
- `../FRONTEND-CODING-PRINCIPLES.md` — templates, HTMX, Alpine, CSS discipline
- `../ACCESSIBILITY.md` — WCAG 2.2 AA, non-negotiable on every direction
- `../RESPONSIVE-DESIGN.md` — the breakpoint scale
- `how-to/src/BRAND-VOICE.md` — the copy half of the same doctrine
