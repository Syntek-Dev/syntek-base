# User Story Creation — Steps

**Last Updated**: 01/05/2026 **Version**: 1.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Confirm the next story number

Check `project-management/src/01-STORIES/` for the highest existing `US###.md` and increment by one.
Reserve that number before continuing — do not start writing until the number is confirmed.

### Step 2 — Copy the template

Copy `project-management/src/01-STORIES/US000-TEMPLATE.md` to a new file:

```text
project-management/src/01-STORIES/US###.md
```

Replace `US000` in the heading with the confirmed story number and add the story title.

### Step 3 — Set the flags

Fill in every row of the flags table before writing any section content.

| Flag      | Rule                                                                           |
| --------- | ------------------------------------------------------------------------------ |
| DB        | List each model being created or modified; set N/A if no model changes         |
| User Flow | Set Yes if a UI journey exists; N/A if purely backend or infrastructure        |
| Backend   | Set Yes if service layer, signals, or Celery tasks are involved; N/A otherwise |
| API       | List each GraphQL mutation and query introduced; N/A if no schema changes      |
| Frontend  | Set Web, Mobile, or Web + Mobile; N/A if no UI work                            |
| GDPR      | Set Yes if any personal data is created, read, or modified; N/A otherwise      |
| Security  | List each concern (e.g. rate-limit, audit-log, XSS-escape); N/A if none        |
| Testing   | List test types required (e.g. unit, integration, E2E, manual); N/A if none    |

Once all flags are set, remove every section whose flag is N/A.

### Step 4 — Write the User Story, MoSCoW, Story Points, and Dependencies

- User Story: "As a [role], I want [capability], so that [benefit]."
- MoSCoW: Must Have / Should Have / Could Have / Won't Have
- Story Points: estimate using the rough guide in the template comment
- Dependencies: list upstream stories or external services this story requires

### Step 5 — Generate or write the story content

Use the skill to generate initial content, or write manually:

```text
/syntek-dev-suite:stories [describe the feature, user role, and any constraints]
```

Paste the generated content into the correct sections. The skill output must fit the template
structure — do not paste free-form content outside the defined sections.

### Step 6 — Complete each Acceptance Criteria subsection

Work through every section whose flag is not N/A:

- **Acceptance Criteria (Overview)** — 1–2 Gherkin scenarios covering the primary happy path and the key failure case
- **DB** — model structure scenarios and constraint enforcement scenarios
- **User Flow** — navigation, redirect, permission-denied, and error-state scenarios
- **Backend** — checklist items for service method behaviour, signals, and Celery tasks
- **API** — checklist items for each mutation and query (success, 401, 403, validation error)
- **Frontend** — Gherkin scenarios for component states; scope to Web / Mobile / both per flag
- **GDPR** — checklist items for encryption, erasure, retention, and consent gate
- **Security** — checklist items prefixed with `[UF##/ST##]` reference
- **Testing** — checklist items for coverage floors and required test types

### Step 7 — Complete each Tasks subsection

Mirror the Acceptance Criteria subsections with concrete, actionable tasks.
Every task must map to at least one acceptance criterion — no tasks without a corresponding criterion.

For Frontend Tasks, scope each task to `Web`, `Mobile`, or `Both` as a comment prefix.

### Step 8 — Verify Verification Checks and Definition of Done

Both sections must be present and untouched — do not remove or modify them.

### Step 9 — Review

Read the completed story against the checklist in `CHECKLIST.md` before saving.

### Step 10 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
