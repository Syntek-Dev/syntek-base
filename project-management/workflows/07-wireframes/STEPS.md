---
workflow: 07-wireframes
phase: design
agent: frontend
skills: [stack-htmx-templates]
model: fable
---

# Wireframes — Steps

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                                   |
| --------- | ----------------------------------------------------------------------------------------- |
| All steps | **Internal — Live Artefacts** → src/07-WIREFRAMES/                                        |
| All steps | **Internal — Guides** → code/docs/RESPONSIVE-DESIGN.md (breakpoints and orientation data) |

---

## Steps

### Step 1 — Define the Page or Feature Scope

> **Model:** opus

From the user story, identify:

- Which pages or components are involved
- The primary user journey (happy path)
- Edge cases: empty states, loading states, error states

### Step 2 — Sketch the Layout

> **Model:** opus · **MCP:** figma (reference only)

Produce a wireframe for each distinct view. Include:

- Page/component hierarchy
- Navigation and routing (where does each action lead?)
- Form fields, labels, and validation messages
- Interactive states: default, hover, focus, disabled, error, success, empty

Tools: Figma, Excalidraw, or a plain Markdown ASCII layout — any format is acceptable
as long as the document is readable and committed.

### Step 3 — Document the Wireframe

> **Model:** opus

Save the wireframe document to `project-management/src/07-WIREFRAMES/`.

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

### Step 6 — Proceed to the Next Gate

**Not to code.** Signed-off wireframes unlock the remaining design and compliance gates, not
implementation — a feature is not codeable until workflows 01–15 are complete
(`project-management/workflows/CLAUDE.md`). Continue in order:

`08-gdpr-compliance` → `09-security-checks` → `10-qa-checks` → `11-seo-checks` (public pages)
→ `12-api-design` (if the story touches the Ninja API) → `13-decisions` → `14-sprint-plans`
→ `15-story-plans`.

The story plan produced by `15-story-plans/` is the master a developer codes from. Frontend
implementation then runs through `18-frontend-code/`, which drives
`code/workflows/01-new-feature/` and `code/workflows/02-tdd-cycle/`.

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
