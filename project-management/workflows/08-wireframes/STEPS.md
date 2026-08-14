---
workflow: 08-wireframes
phase: design
skills: [frontend, stack-htmx-templates]
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
| All steps | **Internal — Live Artefacts** → src/08-WIREFRAMES/                                        |
| All steps | **Internal — Guides** → code/docs/RESPONSIVE-DESIGN.md (breakpoints and orientation data) |

**The visual direction is already settled — read it before Step 0.** `code/docs/VISUAL-DESIGN.md`
Section 3 names this project's direction and its setting on each of the six axes (alignment, rhythm,
contrast, ornament, density, motion). Lay out within it. **Do not re-open it as free text here** —
a wireframe is where an axis is most easily contradicted by accident, and Section 4.2's ban list reads
off that table. If the layout work genuinely disproves an axis setting, change it in Section 3 — that is
the canonical home — and say so. If any axis still reads `TBD`, stop:
`how-to/workflows/01-first-time-setup/` Step 9 has not been run.

---

## Steps

### Step 0 — Grill first

> **Model:** fable

Load `.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%>
(`.claude/CLAUDE.md` Section 10).

Ask about:

- Which screens this story genuinely introduces, and which it only touches
- Whether each screen realises a step in the story's user-flow fragment, or invents a new one
- Which components it expects to reuse — and whether any gap is a real component need or a
  layout problem in disguise
- Whether a mobile counterpart is in scope, and if so what cannot carry over (hover, scrollbars,
  browser chrome have no native equivalent)

_Done when every question is answered and <%DEVELOPER_NAME%> has confirmed the scope._

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
`project-management/src/08-WIREFRAMES/USER-STORY-IDEAS/WF-IDEA-US000-TEMPLATE.html` and compose from the `wf-*`
classes in `SHARED/wireframe.css`. No CDN, no framework, no external fonts — it must open over
`file://`. Figma and Excalidraw are **not** alternatives here: a second medium would put the
design tier behind a hosted dependency and make it undiffable.

**Mobile-only.** A screen on the mobile surface is wireframed the same way, in the same folder,
through this same gate — composed at a phone viewport (390 × 844 reference). Do not let intent
rest on **hover, scrollbars, or browser chrome**: none exists natively, so a wireframe depending
on them is a web design in a phone-shaped frame.

### Step 3 — Document the Wireframe

> **Model:** opus

Save the screen to `project-management/src/08-WIREFRAMES/USER-STORY-IDEAS/` — **stage 1** — as
`WF-IDEA-US###-<Screen-Name>.html`, or `WF-IDEA-US###-MOBILE-<Screen-Name>.html` for a mobile
screen, which shares the number of its web counterpart where one exists.

**Do not use the bare `WF-###-` form here.** That is stage 2, written by
`17-consolidate-design-work` into `CONSOLIDATED-IDEAS/`: a consolidated screen drops the `IDEA`
marker and the story number because it belongs to the product rather than to one story. Full
convention: `project-management/src/08-WIREFRAMES/CONTEXT.md`.

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
implementation — a feature is not codeable until workflows 02–16 are complete
(`project-management/workflows/CLAUDE.md`). Continue in order:

`09-gdpr-compliance` → `10-security-checks` → `11-qa-checks` → `12-seo-checks` (public pages)
→ `13-api-design` (if the story touches the Ninja API) → `14-decisions` → `15-sprint-plans`
→ `16-story-plans`.

The story plan produced by `16-story-plans/` is the master a developer codes from. Frontend
implementation then runs through `20-frontend-code/`, which drives
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
