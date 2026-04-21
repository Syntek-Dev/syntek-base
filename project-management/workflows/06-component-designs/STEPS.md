# Component Designs — Steps

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Identify Required Components

Review the user flows and user stories for the in-scope area.
List every UI component needed. For each one, check whether it already exists in:

- `code/src/frontend/src/components/`
- The Figma component library

Reuse existing components before designing new ones.

### Step 2 — Design New Components in Figma

Open the Figma team templates:
[Figma Drafts — Syntek Studio](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629)

Use the component design template. For each new component, design all required variants and states:

- Default
- Hover
- Focus
- Disabled
- Error
- Success
- Empty / loading (where applicable)

Use brand tokens (Figma variables from the brand guide file) — never raw hex values or hard-coded sizes.

### Step 3 — Annotate Components

For each component, document in Figma or an accompanying note:

- Props / variants exposed to consumers
- Accessibility requirements (ARIA role, keyboard interaction, focus management)
- Responsive behaviour — annotate which breakpoint tiers require layout changes (refer to `project-management/docs/RESPONSIVE-DESIGN.md` for the full viewport tier table)
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
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
