---
workflow: 04-user-flow-design
phase: design
agent: planner
skills: [global-workflow]
model: fable
---

# User Flow Design — Steps

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                                       |
| --------- | --------------------------------------------------------------------------------------------- |
| All steps | **Internal — Live Artefacts** → src/04-USER-FLOW/                                             |
| All steps | **Internal — Guides** → code/docs/RESPONSIVE-DESIGN.md (device breakpoints for flow diagrams) |

---

## Steps

### Step 1 — Grill, then Identify the Product Area

> **Model:** fable

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview {{DEVELOPER_NAME}} one question at a time — the product area's boundaries, the roles and their
entry points, the decision nodes and their success/failure outcomes, and every
personal-data touchpoint — before mapping. Record hard-to-reverse calls as an ADR.

Review the in-scope user stories and group them by product area (e.g. auth, client portal,
public pages, admin content). Confirm which area this flow document covers.

### Step 2 — List All Entry Points

Identify every point a user can enter the area:

- Direct URL navigation
- Links from other areas of the product
- External links (emails, notifications)

### Step 3 — Map the Journey

> **Model:** opus · **MCP:** mcp-mermaid (reference only)

For each entry point, trace the full sequence of screens, decisions, and transitions.
Include:

- Happy path (successful completion)
- Alternative paths (e.g. unauthenticated user, validation failure)
- Exit points (logout, cancellation, completion redirect)

Tools: Figma FigJam, Mermaid, or a plain Markdown diagram — any committed format is
acceptable.

### Step 4 — Mark Data Touchpoints

Annotate each step where personal data is collected, displayed, or transmitted.
This feeds the GDPR compliance review in `project-management/workflows/08-gdpr-compliance/`.

### Step 5 — Document the Flow

> **Model:** opus

Save the flow document to `project-management/src/04-USER-FLOW/`.

Name the file: `USER-FLOW-<AREA>.md` (e.g. `USER-FLOW-AUTH.md`).

Include in the document:

- Link to each related user story (`US###.md`)
- Flow diagram or step-by-step table
- Decision nodes with success and failure outcomes
- Data touchpoint annotations

### Step 6 — Review

Review the flow for:

- All acceptance criteria from the linked stories are reachable
- No dead ends or missing transitions
- All alternative paths are handled
- Data touchpoints are complete and accurate

### Step 7 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

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
