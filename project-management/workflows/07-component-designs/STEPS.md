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
- The consolidated set in `project-management/src/07-COMPONENTS/CONSOLIDATED-IDEAS/`

Reuse existing components before designing new ones.

### Step 2 — Design New Components

> **Model:** opus

For each new component, design all required variants and states:

- Default
- Hover
- Focus
- Disabled
- Error
- Success
- Empty / loading (where applicable)

Use brand tokens (colour, typography, spacing) — never raw hex values or hard-coded sizes.

#### 2a — Hold the design across the breakpoint set

Responsive behaviour is part of the design, not a later pass. Design mobile-first at 360 px
portrait, then check the component at both ends of the range — **320 px** and **10240 px**.
Backgrounds must fill, pinned elements must stay pinned, and nothing may distort or detach.
The breakpoint set and the desktop threshold are in this folder's `CONTEXT.md`; the mechanics
are `code/docs/responsive/BREAKPOINTS.md` and `code/docs/responsive/CONTAINER-QUERIES.md`.

### Step 3 — Annotate Components

For each component, record in its `COMP-IDEA-US###-<DESCRIPTOR>.md`
(`project-management/src/07-COMPONENTS/USER-STORY-IDEAS/`):

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

### Step 5 — Map Each Design to the Component Library

Every component record names its counterpart in `code/src/django/components/` — the existing
django-component it reuses, or the name a new one will take. A design with no named counterpart
is a design nobody can implement without guessing.

### Step 6 — Sign Off

Component designs must be agreed before frontend implementation begins.
Record sign-off via PR review or in the component record itself.

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
