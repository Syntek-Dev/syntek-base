# Brand Guides — Steps

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Generate Initial Brand Concepts with Claude Design

Use [Claude Design by Anthropic Labs](https://www.anthropic.com/news/claude-design-anthropic-labs) to generate the initial brand direction. Prompt it with the product vision and target audience from the prerequisites.

Generate:

- Logo concepts and visual identity directions
- Colour palette options (primary, secondary, neutral, semantic roles)
- Typography pairings and scale suggestions
- Overall visual tone (minimal, bold, warm, technical, accessible, etc.)

Review and curate the outputs. Document every agreed decision immediately as a `BRAND-<TOPIC>.md` file in `project-management/src/05-BRAND-GUIDE/`:

| File                  | Content                                            |
| --------------------- | -------------------------------------------------- |
| `BRAND-LOGO.md`       | Logo concepts, usage rules, clear space guidelines |
| `BRAND-COLOURS.md`    | Full palette with hex values and semantic roles    |
| `BRAND-TYPOGRAPHY.md` | Typefaces, scale, weights, line heights            |
| `BRAND-TONE.md`       | Personality traits and tone of voice rules         |
| `BRAND-SPACING.md`    | Base unit, spacing scale, container max-widths     |

These documents are the source of truth. Figma and the token system are built from them — not the other way around.

### Step 2 — Define the Colour Palette

From the Claude Design output, finalise every colour with its role:

| Role              | Description                              |
| ----------------- | ---------------------------------------- |
| Primary           | Main brand colour, CTAs, key UI elements |
| Secondary         | Supporting accent colour                 |
| Neutral           | Backgrounds, borders, text               |
| Semantic: success | Confirmation states                      |
| Semantic: warning | Caution states                           |
| Semantic: error   | Validation and error states              |
| Semantic: info    | Informational states                     |

Provide hex values, names, and contrast ratios against intended backgrounds
(WCAG 2.2 AA: 4.5:1 for normal text, 3:1 for large text and UI components).

### Step 3 — Define Typography

Finalise:

- Typeface(s) and fallback stack
- Type scale (h1–h6, body, caption, label)
- Font weights per level
- Line heights and letter spacing
- Responsive behaviour (does the scale shift at breakpoints?)

### Step 4 — Define Spacing and Layout

Finalise:

- Base spacing unit (e.g. 4 px or 8 px grid)
- Spacing scale tokens (xs, sm, md, lg, xl, 2xl, etc.)
- Layout breakpoints (build-time only — not DB-driven tokens; see `project-management/docs/RESPONSIVE-DESIGN.md` for the full breakpoint table)
- Container max-widths

### Step 5 — Build the Figma Brand Guide

Open the Figma team templates:
[Figma Drafts — Syntek Studio](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629)

Using the brand guide template, port the agreed decisions from `project-management/src/05-BRAND-GUIDE/` into Figma:

- Set up Figma variables for all colour, typography, and spacing tokens so component designs can consume them
- Build the logo page: usage rules, minimum sizes, clear space, do/don't examples
- Build the colour page: swatches, semantic role labels, contrast ratio annotations
- Build the typography page: scale samples, weight and spacing rules
- Build the spacing and layout page: grid system, breakpoint annotations

The Figma brand guide is the shared design reference for all component and wireframe work that follows.

### Step 6 — Update the Design Token System

Feed decisions into the DB-driven token system:

- Update or create token records via Django admin
- Confirm that CSS variables are generated correctly
- Confirm that Tailwind v4 picks up the updated variables
- If existing tokens are changing, document the migration plan

### Step 7 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
