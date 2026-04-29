# QA Checks — Steps

**Last Updated**: 28/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — List Stories in Scope

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
/syntek-dev-suite:qa-tester [describe the story, its wireframe, and user flow]
```

### Step 4 — Document QA Plans

For each story, save a QA document in `project-management/src/10-QA/`:

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
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
