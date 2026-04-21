# User Flow Design — Steps

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Identify the Product Area

Review the in-scope user stories and group them by product area (e.g. auth, client portal,
public pages, admin content). Confirm which area this flow document covers.

### Step 2 — List All Entry Points

Identify every point a user can enter the area:

- Direct URL navigation
- Links from other areas of the product
- External links (emails, notifications)

### Step 3 — Map the Journey

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
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
