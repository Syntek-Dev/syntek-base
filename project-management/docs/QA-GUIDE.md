# QA Guide — project-name

> **Agent hints — Model:** Sonnet

**Last Updated**: 28/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Table of Contents

- [Overview](#overview)
- [When to Run QA Checks](#when-to-run-qa-checks)
- [What QA Covers at Design Stage](#what-qa-covers-at-design-stage)
- [Test Scenario Categories](#test-scenario-categories)
- [QA Document Format](#qa-document-format)
- [Feeding Back to User Stories](#feeding-back-to-user-stories)
- [Quick Checklist](#quick-checklist)

---

## Overview

QA planning happens at **design stage** — before code is written. Test scenarios are derived
from wireframes and user flows, not from a completed implementation. This ensures:

- Acceptance criteria are complete before development starts
- Developers know what constitutes "done" before they begin
- Edge cases and error states are designed for, not discovered in code review

This guide supports the `workflows/10-qa-checks` workflow.

---

## When to Run QA Checks

QA checks run once per sprint cycle, after security checks and before sprint plans are written:

```text
09-security-checks  →  10-qa-checks  →  11-sprint-plans  →  12-backend-code
```

QA checks are also the point where missing acceptance criteria in `src/01-STORIES/` are
identified and fed back before sprint planning locks the scope.

---

## What QA Covers at Design Stage

QA at this stage is not test execution — it is **test planning**. The goal is to derive a
complete set of test scenarios from the wireframes so developers can write tests alongside their
implementation.

For each wireframe, the QA review covers:

| Area                     | What to look for                                                                      |
| ------------------------ | ------------------------------------------------------------------------------------- |
| **Happy path**           | The expected successful user journey, end to end                                      |
| **Error states**         | Validation failures, server errors, empty states, timeout handling                    |
| **Edge cases**           | Boundary inputs (max length, zero, negative), concurrent actions, rapid re-submission |
| **Permission checks**    | What happens when an unauthorised user reaches a protected screen or action           |
| **Accessibility**        | Keyboard navigation, focus management, screen reader labels, error announcements      |
| **Responsive behaviour** | Layout at mobile (360px) and desktop (1280px) minimum; critical at `xmd` (600px)      |
| **Data integrity**       | What is displayed when data is partially missing or in an unexpected state            |

---

## Test Scenario Categories

Each QA document groups scenarios into four categories:

### 1. Functional — happy path

The expected successful flow. One or two scenarios per core user action.

```text
GIVEN a logged-in user with the 'editor' role
WHEN they submit a valid blog post form
THEN the post is saved as a draft and they are redirected to the post list
AND the post appears in the list with status 'Draft'
```

### 2. Functional — error states

Every visible error state and empty state in the wireframe.

```text
GIVEN a user submitting the contact form
WHEN the email field is blank
THEN an inline validation message appears: "Email address is required"
AND the form is not submitted
AND focus moves to the email field
```

### 3. Edge cases

Boundary conditions and unusual but valid inputs.

```text
GIVEN a user entering a title
WHEN the title is exactly 255 characters
THEN the input is accepted
WHEN the title is 256 characters
THEN the input is rejected with an inline validation message
```

### 4. Permission and access

What happens when someone reaches a screen or action they should not have access to.

```text
GIVEN an anonymous visitor
WHEN they navigate directly to /admin/
THEN they are redirected to the login page
AND the redirect URL preserves /admin/ as the `next` parameter
```

---

## QA Document Format

One file per user story in `project-management/src/10-QA/`:

```text
QA-US###-<DESCRIPTION>.md  (e.g. QA-US015-HOMEPAGE.md)
```

```markdown
# QA — US### <Story Title>

**Date**: DD/MM/YYYY **Sprint**: ## **Wireframe**: WF-US###-<NAME>.md

## Acceptance Criteria Gaps

List any acceptance criteria missing from the user story that this review identified.
These must be added to `US###.md` before the sprint plan is written.

- AC-GAP-1: <missing criterion>

## Test Scenarios

### Happy Path

| ID    | Given          | When     | Then              |
| ----- | -------------- | -------- | ----------------- |
| HP-01 | <precondition> | <action> | <expected result> |

### Error States

| ID    | Given          | When     | Then              |
| ----- | -------------- | -------- | ----------------- |
| ES-01 | <precondition> | <action> | <expected result> |

### Edge Cases

| ID    | Given          | When     | Then              |
| ----- | -------------- | -------- | ----------------- |
| EC-01 | <precondition> | <action> | <expected result> |

### Permission and Access

| ID    | Given          | When     | Then              |
| ----- | -------------- | -------- | ----------------- |
| PA-01 | <precondition> | <action> | <expected result> |

## Accessibility Notes

- <specific focus or keyboard behaviour to verify>
- <screen reader label to check>

## Responsive Notes

- <behaviour at 360px to verify>
- <behaviour at 600px (xmd) to verify>
- <behaviour at 1280px to verify>

## Developer Notes

<Anything the developer must know about testability requirements — e.g. "the success toast must
have aria-live='polite' for screen reader announcement">
```

---

## Feeding Back to User Stories

Any `AC-GAP` identified during QA review must be added to the story's acceptance criteria in
`project-management/src/01-STORIES/US###.md` before the sprint plan is written.

**Do not proceed to sprint planning if stories have unresolved acceptance criteria gaps.**

The workflow for feeding back:

1. Note the gap in the QA document under `## Acceptance Criteria Gaps`
2. Open `US###.md` and add the missing criterion under `## Acceptance Criteria`
3. Cross-reference: add a note in the story — `Updated after QA review (DD/MM/YYYY)`
4. Mark the gap as resolved in the QA document

---

## Quick Checklist

Before closing the QA checks workflow:

- [ ] All in-scope user stories identified
- [ ] Every wireframe reviewed for happy path, error states, edge cases, and permissions
- [ ] Accessibility and responsive behaviour noted for each screen
- [ ] `QA-US###-<DESCRIPTION>.md` created for every in-scope story in `src/10-QA/`
- [ ] All acceptance criteria gaps identified and fed back into `US###.md`
- [ ] No stories with unresolved `AC-GAP` entries remain
- [ ] Developer notes on testability requirements added where needed
- [ ] Ready to proceed to `workflows/11-sprint-plans`
