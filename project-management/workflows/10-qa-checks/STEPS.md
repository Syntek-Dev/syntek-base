---
workflow: 10-qa-checks
phase: verify
agent: qa-tester
skills: [stack-django, stack-htmx-templates]
model: fable
---

# QA Checks — Steps

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                  |
| --------- | ------------------------------------------------------------------------ |
| All steps | **Internal — Guides** → project-management/docs/QA-GUIDE.md              |
| All steps | **External — Agile & Project Management** → Definition of Done           |
| Artefacts | **Internal — Live Artefacts** → src/10-QA/PLANNING/ (save QA plans here) |

---

## Steps

### Step 1 — Grill, then List Stories in Scope

> **Model:** opus

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview {{DEVELOPER_NAME}} one question at a time — the test scope, the highest-risk areas, and the
scenarios to cover (happy path, error states, edge cases, accessibility) before writing
the QA plan.

Open `project-management/src/01-STORIES/` and identify every user story covered by the completed
wireframes. This is the scope for the QA review.

### Step 2 — Review Each Wireframe for Testability

For each wireframe in `project-management/src/07-WIREFRAMES/`, identify:

- **Happy path** — the expected successful user journey
- **Error states** — validation failures, empty states, server errors
- **Edge cases** — boundary inputs, concurrent actions, permission changes mid-flow
- **Accessibility** — keyboard navigation, screen reader labels, focus management
- **Responsive behaviour** — how the layout changes at each breakpoint

### Step 3 — Run QA Agent

```text
qa-tester [describe the story, its wireframe, and user flow]
```

> **↳ New agent:** `qa-tester` · **Model:** fable · **MCP:** none

### Step 4 — Document QA Plans

For each story, save a QA document in `project-management/src/10-QA/PLANNING/`:

```text
QA-US###-<DESCRIPTION>.md
```

Each document should include:

- Test scenarios (happy path, error states, edge cases)
- Acceptance criteria gaps (anything missing from the user story)
- Notes for the developer on testability requirements

### Step 5 — Feed Back to Stories

If QA identifies missing acceptance criteria, update the relevant
`US###.md` in `project-management/src/01-STORIES/` before sprint planning.

### Step 6 — Commit

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
