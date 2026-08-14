---
workflow: 07-component-designs
phase: design
skills: [frontend, stack-htmx-templates, prototype]
model: fable
---

# Component Designs — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                |
| --------- | ------------------------------------------------------ |
| All steps | **Internal — Live Artefacts** → src/07-COMPONENTS/     |
| All steps | **Internal — Guides** → code/docs/RESPONSIVE-DESIGN.md |

**The visual direction is already settled — read it before Step 1.** `code/docs/VISUAL-DESIGN.md`
Section 3 names this project's direction and its setting on each of the six axes (alignment, rhythm,
contrast, ornament, density, motion). Design within it. **Do not re-open it as free text here**,
and do not design a component whose composition contradicts an axis — Section 4.2's ban list reads off
that table, so a component designed against it fails review later. If the component work genuinely
disproves an axis setting, change it in Section 3 — that is the canonical home — and say so. If any axis
still reads `TBD`, stop: `how-to/workflows/01-first-time-setup/` Step 9 has not been run.

---

## Steps

### Step 1 — Grill, then Identify Required Components

> **Model:** opus · **MCP:** code-review-graph (reference only)

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> about the required components, their states and
variants, and reuse of existing shared components before identifying the component set.

If a design question stays open after grilling, spike it with a throwaway prototype
(`.claude/skills/prototype/SKILL.md`) to answer that one question before committing to the
real build.

Review the user flows and user stories for the in-scope area.
List every UI component needed. For each one, check whether it already exists in:

- `code/src/django/components/`
- The Figma component library

Reuse existing components before designing new ones.

### Step 2 — Design New Components in Figma

> **Model:** opus · **MCP:** figma (reference only)

For each new component, design all required variants and states:

- Default
- Hover
- Focus
- Disabled
- Error
- Success
- Empty / loading (where applicable)

Use brand tokens (colour, typography, spacing) — never raw hex values or hard-coded sizes.

#### 2a — Set child constraints (flexible layout)

Every component frame uses `layoutMode: 'NONE'`. Responsive behaviour comes entirely from
**Figma child constraints** — set them explicitly on every child element before signing off:

| Element role                            | Horizontal | Vertical |
| --------------------------------------- | ---------- | -------- |
| Background fill rectangle               | STRETCH    | STRETCH  |
| Left-pinned content (logo, card start)  | MIN        | CENTER   |
| Right-pinned content (CTA, hamburger)   | MAX        | CENTER   |
| Centred content (hero text, quotes)     | CENTER     | MIN      |
| Full-width text or divider              | STRETCH    | MIN      |
| Proportionally scaled image placeholder | SCALE      | STRETCH  |
| Fixed-position badge (e.g. status dot)  | MAX        | MAX      |

Verify by temporarily resizing the component frame to the smallest (320 px) and largest
(10240 px) widths — backgrounds must fill, and pinned elements must stay correctly positioned.

#### 2b — In-place rebuild via Figma MCP

When rebuilding an existing component programmatically via `mcp__figma__use_figma`:

1. Clear the component's children first (do not create a new COMPONENT node — preserve the key).
2. Rebuild child elements with correct `constraints` on each node.
3. Re-publish the library — existing instances in wireframe files auto-update; no re-placing needed.

**Figma MCP page-switch rule**: if the target page is not already current, split into two script
runs — Run 1: `await figma.setCurrentPageAsync(targetPage)` only. Run 2: build all content on
`figma.currentPage`. Never switch page and mutate content in the same run (children will not
persist).

### Step 3 — Annotate Components

For each component, document in Figma or an accompanying note:

- Props / variants exposed to consumers
- Accessibility requirements (ARIA role, keyboard interaction, focus management)
- Responsive behaviour
- Any motion or transition behaviour

### Step 4 — Accessibility Review

Review every interactive component against WCAG 2.2 AA:

- Colour contrast meets minimum ratios (4.5:1 text, 3:1 UI components)
- Focus indicator is visible and meets 3:1 contrast
- Touch targets are at least 24 × 24 px (WCAG 2.5.8)

Reference `code/docs/ACCESSIBILITY.md` for the full checklist.

### Step 5 — Set Up Code Connect Mappings

Where a Figma component maps to an existing or new codebase component, register the
mapping using the Figma MCP:

```text
mcp__figma__get_code_connect_suggestions
mcp__figma__send_code_connect_mappings
```

### Step 6 — Sign Off

Component designs must be agreed before frontend implementation begins.
Record sign-off via PR review or a comment in the Figma file.

### Step 7 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

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
