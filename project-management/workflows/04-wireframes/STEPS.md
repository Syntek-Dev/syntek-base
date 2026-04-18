# Wireframes — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Define the Page or Feature Scope

From the user story, identify:

- Which pages or components are involved
- The primary user journey (happy path)
- Edge cases: empty states, loading states, error states

### Step 2 — Sketch the Layout

Produce a wireframe for each distinct view. Include:

- Page/component hierarchy
- Navigation and routing (where does each action lead?)
- Form fields, labels, and validation messages
- Interactive states: default, hover, focus, disabled, error, success, empty

Tools: Figma, Excalidraw, or a plain Markdown ASCII layout — any format is acceptable
as long as the document is readable and committed.

### Step 3 — Document the Wireframe

Save the wireframe document to `project-management/src/WIREFRAMES/`.

Name the file: `WF-US###-<DESCRIPTOR>.md` (or `.png` / `.fig` if a visual format).

Include in the document:

- Link to the corresponding user story (`US###.md`)
- Annotated layout or screenshot
- List of components required and whether they are new or reused
- Accessibility notes (focus order, ARIA roles, colour contrast)

### Step 4 — Review

Review the wireframe for:

- Coverage of all acceptance criteria from the user story
- Logical user flow — no dead ends or ambiguous navigation
- All interactive states defined
- WCAG 2.2 AA compliance at the layout level

### Step 5 — Sign Off

Wireframes must be agreed before frontend implementation starts.
Record sign-off in the document or via PR review.

### Step 6 — Proceed to Implementation

Once approved, follow `code/workflows/01-new-feature/` to build the feature.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
