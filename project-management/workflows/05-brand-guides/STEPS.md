---
workflow: 05-brand-guides
phase: design
agent: frontend
skills: [stack-htmx-templates]
model: fable
---

# Brand Guides — Steps

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                |
| --------- | ------------------------------------------------------ |
| All steps | **Internal — Live Artefacts** → src/05-BRAND-GUIDE/    |
| All steps | **Internal — Guides** → code/docs/RESPONSIVE-DESIGN.md |

---

## Steps

### Step 1 — Define Brand Principles

> **Model:** opus

Document the brand personality, tone of voice, and visual direction:

- Core values and personality traits
- Tone of voice (formal/informal, technical/accessible)
- Visual direction (clean, bold, minimal, etc.)

### Step 2 — Define the Colour Palette

Specify all colours with their roles:

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
(must meet WCAG 2.2 AA: 4.5:1 for normal text, 3:1 for large text and UI components).

### Step 3 — Define Typography

Specify:

- Typeface(s) and fallback stack
- Type scale (heading levels h1–h6, body, caption, label)
- Font weights per level
- Line heights and letter spacing
- Responsive behaviour (does the scale shift at breakpoints?)

### Step 4 — Define Spacing and Layout

Specify:

- Base spacing unit (e.g. 4 px or 8 px grid)
- Spacing scale tokens (xs, sm, md, lg, xl, 2xl, etc.)
- Layout breakpoints (build-time only — not DB-driven tokens)
- Container max-widths

### Step 5 — Update the Design Token System

> **Model:** opus

Feed decisions into the DB-driven token system:

- Update or create token records via the design-token admin area
- Confirm that CSS variables are generated correctly
- Confirm that the updated CSS variables are consumed correctly by the frontend
- If existing tokens are changing, document the migration plan

### Step 6 — Commit

> **Model:** opus

```text
git
```

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
