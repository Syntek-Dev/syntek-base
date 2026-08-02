---
workflow: 07-wireframes
phase: design
agent: frontend
skills: [stack-htmx-templates]
model: fable
---

# Wireframes — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
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

**The medium is fixed: a self-contained HTML screen.** Copy
`project-management/src/07-WIREFRAMES/SCREENS/WF-000-TEMPLATE.html` and compose from the `wf-*`
classes in `SHARED/wireframe.css`. No CDN, no framework, no external fonts — it must open over
`file://`. Figma and Excalidraw are **not** alternatives here: a second medium would put the
design tier behind a hosted dependency and make it undiffable.

**Mobile-only.** A screen on the mobile surface is wireframed the same way, in the same folder,
through this same gate — composed at a phone viewport (390 × 844 reference). Do not let intent
rest on **hover, scrollbars, or browser chrome**: none exists natively, so a wireframe depending
on them is a web design in a phone-shaped frame.

### Step 3 — Document the Wireframe

> **Model:** opus

Save the screen to `project-management/src/07-WIREFRAMES/SCREENS/`.

Name the file `WF-###-<Screen-Name>.html`, or `WF-###-MOBILE-<Screen-Name>.html` for a mobile
screen — which shares the number of its web counterpart where one exists. Full convention:
`project-management/src/07-WIREFRAMES/CONTEXT.md`.

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
