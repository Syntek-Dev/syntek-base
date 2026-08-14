---
workflow: 06-brand-guides
phase: design
skills: [frontend, stack-htmx-templates]
model: fable
---

# Brand Guides — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                |
| --------- | ------------------------------------------------------ |
| All steps | **Internal — Live Artefacts** → src/06-BRAND-GUIDE/    |
| All steps | **Internal — Guides** → code/docs/RESPONSIVE-DESIGN.md |

---

## Steps

### Step 0 — Grill first

> **Model:** fable

Load `.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%>
(`.claude/CLAUDE.md` Section 10).

Ask about:

- Which token domains this story actually touches — colour, type, spacing, logo, voice — and
  which it explicitly does not
- Whether any proposed value is genuinely new, or a near-neighbour of something already decided
- The contrast pairings any new colour must satisfy, before it is chosen rather than after
- Whether this is a project-level brand decision or a one-story need (the latter is the common
  case, and belongs in `USER-STORY-IDEAS/` as an ask, not a decision)

_Done when every question is answered and <%DEVELOPER_NAME%> has confirmed the scope._

### Step 1 — Define Brand Principles

> **Model:** opus

Document the brand personality, and reconcile it against the two prerequisite documents that
already settled voice and direction at first-time setup:

- Core values and personality traits
- **Tone of voice** — already settled in `how-to/src/BRAND-VOICE.md` Section 3. Refine it here if the
  brand work produces a fuller answer, and write the refinement back; the two must not contradict.
- **Visual direction** — already settled in `code/docs/VISUAL-DESIGN.md` Section 3: a named direction
  plus a setting on each of the six axes (alignment, rhythm, contrast, ornament, density, motion).
  **Do not re-open it as free text here.** Read the committed direction, design within it, and if
  the brand work genuinely disproves an axis setting, change it in Section 3 — that is the canonical
  home — and say so, because Section 4.2's ban list and every wireframe already read off it.

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
