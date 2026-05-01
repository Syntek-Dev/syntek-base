# Sprint Planning — Steps

**Last Updated**: 01/05/2026 **Version**: 1.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Confirm the next sprint number

Check `project-management/src/02-SPRINTS/` for the highest existing `SPRINT-##.md` and increment by one.
Confirm the previous sprint's Definition of Done is complete before proceeding.

### Step 2 — Review the backlog

Read open stories in `project-management/src/01-STORIES/` and identify candidates.

For each candidate, confirm:

- Status is `Ready`
- All upstream dependencies (listed in the story's Dependencies section) are either complete or also in this sprint
- Story Points are estimated

### Step 3 — Copy the template

Copy `project-management/src/02-SPRINTS/SPRINT-00-TEMPLATE.md` to a new file:

```text
project-management/src/02-SPRINTS/SPRINT-##.md
```

Replace `SPRINT-00` in the heading with the confirmed sprint number.

### Step 4 — Fill in the Story Summary table

Add each selected story to the Story Summary table with its ID, Title, MoSCoW classification, and SP.
Total the SP column and verify it is at or below team capacity.

Must Have stories must fill capacity first. Should Have and Could Have stories are stretch targets only.
Stories split across sprints must note `(Part A)` or `(Part B)` in the Title column.

### Step 5 — Set the flags

Roll up the flags from every story in the Story Summary table.

| Flag      | Rule                                                                                    |
| --------- | --------------------------------------------------------------------------------------- |
| DB        | List every model created or modified across all sprint stories; N/A if no model changes |
| User Flow | Set Yes if any story introduces a new user journey; N/A otherwise                       |
| Backend   | Set Yes if any story involves service layer, signals, or Celery tasks; N/A otherwise    |
| API       | List every GraphQL mutation and query introduced across all sprint stories; N/A if none |
| Frontend  | Set Web, Mobile, or Web + Mobile based on the stories' Frontend flags; N/A if none      |
| GDPR      | Set Yes if any story in the sprint processes personal data; N/A otherwise               |
| Security  | List every security concern from all sprint stories; N/A if none                        |
| Testing   | List every test type required across all sprint stories; N/A if none                    |

Once all flags are set, remove every section whose flag is N/A.

### Step 6 — Write the sprint goal and dependencies

- **Goal:** one sentence describing the primary outcome of the sprint
- **Dependencies:** list which stories require prior sprints and what this sprint unblocks

### Step 7 — Generate or write the sprint content

Use the skill to generate initial content for the sprint's sections, or write manually:

```text
/syntek-dev-suite:sprint [describe the sprint goal and list the selected stories]
```

Paste the generated content into the correct sections. The skill output must fit the template
structure — do not paste free-form content outside the defined sections.

### Step 8 — Complete each Acceptance Criteria subsection

Work through every section whose flag is not N/A:

- **Acceptance Criteria (Overview)** — 1–2 sentences summarising what the sprint must deliver
- **DB** — checklist items for all models and migrations across the sprint
- **User Flow** — checklist items for all user journeys and wireframe approvals
- **Backend** — checklist items for service layer standards, signals, and Celery tasks
- **API** — checklist items for all mutations and queries introduced
- **Frontend** — checklist items scoped to Web / Mobile / both per the Frontend flag
- **GDPR** — checklist items for PII encryption, erasure, retention, and consent gates
- **Security** — checklist items for rate limits, audit logs, escaping, and permission gates
- **Testing** — coverage floors and test scope summary

### Step 9 — Complete each Tasks subsection

Mirror the Acceptance Criteria subsections with sprint-level task tables.
Each task row must include the Story column (e.g. `US###`) so it traces back to a story.

For Frontend Tasks, scope each row's Platform column to `Web`, `Mobile`, or `Both`.

### Step 10 — Verify Verification Checks and Definition of Done

Both sections must be present and untouched — do not remove or modify them.

### Step 11 — Review and balance

Check the completed sprint file against `CHECKLIST.md`.

Confirm:

- Total SP is at or below capacity
- Dependencies are accurately recorded
- All GDPR and Security criteria are addressed for every story that carries those flags

### Step 12 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
