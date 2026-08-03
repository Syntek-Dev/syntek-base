# QA Plan — US000 {STORY TITLE}

_Template — copy to `QA-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]` row and
`{PLACEHOLDER}` with this story's own analysis, and delete this note once populated. This
is the **pre-development** QA plan for a single story, derived from its wireframe and user
flow before any code is written; its post-implementation counterpart is
`../IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md`._

| Field         | Value                         |
| ------------- | ----------------------------- |
| **Story**     | US### — {short title}         |
| **Date**      | {DD/MM/YYYY}                  |
| **Sprint**    | SPRINT-## — {sprint name}     |
| **Wireframe** | {WF-###-<SCREEN>.html / N/A}  |
| **Status**    | Draft / Reviewed / Signed off |

---

## 1. Acceptance criteria gaps

Gaps, ambiguities, or missing acceptance criteria this QA pass found in the story. Each
becomes a feedback item into `../../02-STORIES/US###.md` **before** the sprint plan locks
scope. Tag every item `[OPEN]` or `[RESOLVED]`.

- **AC-GAP-1** `[OPEN]` — {ambiguity or missing criterion, e.g. "the story does not state
  what happens when {field} is submitted empty"}.
- **AC-GAP-2** `[RESOLVED]` — {gap}; added to `US###.md` on {DD/MM/YYYY}.

_Every `[OPEN]` gap must be resolved in `US###.md` (re-tagged `[RESOLVED]` with the date it
was added) before sprint planning proceeds. If none were found, state "None identified."_

## 2. Test scenarios

Given / When / Then scenarios derived from the wireframe and user flow, grouped into four
categories. These become the story's test suite; developers write tests against them.

### Happy path (HP-nn)

The expected successful journeys, end to end.

| ID    | Given                            | When              | Then                         |
| ----- | -------------------------------- | ----------------- | ---------------------------- |
| HP-01 | [EXAMPLE] {a valid precondition} | {the core action} | {the expected success state} |

_One or two scenarios per core user action._

### Error states (ES-nn)

Every visible validation failure, empty state, server error, and timeout.

| ID    | Given                                    | When               | Then                                                    |
| ----- | ---------------------------------------- | ------------------ | ------------------------------------------------------- |
| ES-01 | [EXAMPLE] {a form with an invalid field} | {the user submits} | {an inline error is shown and focus moves to the field} |

_Cover each error and empty state visible in the wireframe._

### Edge cases (EC-nn)

Boundary inputs and unusual-but-valid conditions.

| ID    | Given                                 | When                              | Then                                              |
| ----- | ------------------------------------- | --------------------------------- | ------------------------------------------------- |
| EC-01 | [EXAMPLE] {a field at its max length} | {the value is one character over} | {the input is rejected with a validation message} |

_Boundary values (max length, zero, negative), concurrent actions, rapid re-submission._

### Permission and access (PA-nn)

What happens when someone reaches a screen or action they should not have access to
(OWASP A01 — enforce, never assume; verify ownership, no IDOR).

| ID    | Given                                           | When                                        | Then                                                        |
| ----- | ----------------------------------------------- | ------------------------------------------- | ----------------------------------------------------------- |
| PA-01 | [EXAMPLE] {an unauthorised or anonymous caller} | {they request a protected screen or action} | {access is denied / they are redirected, and no data leaks} |

_Include one scenario per protected action and per role boundary the story introduces._

## 3. Accessibility notes (WCAG 2.2 AA)

Accessibility expectations to verify against the built screen — see
`code/docs/ACCESSIBILITY.md`.

- **axe-core:** zero violations on the rendered page / component.
- **Focus management:** logical tab order; visible focus ring; a focus trap in any modal
  or dialog, returning focus to the trigger on close.
- **Equal-weight actions:** confirm and cancel are equally reachable and labelled; no
  action relies on colour alone.
- **Announcements:** error and success states announced (`role="alert"` /
  `aria-live`); required fields marked `aria-required`.
- **Keyboard:** every interactive control operable by keyboard; no keyboard trap.

_Add the specific labels, focus behaviours, and announcements this story must satisfy._

## 4. Responsive behaviour

- {Behaviour to verify at 360 px (mobile)}.
- {Behaviour to verify at 600 px (`xmd`) — the critical breakpoint}.
- {Behaviour to verify at 1280 px (desktop)}.

## 5. GDPR & security constraints

Where this story touches personal data or a protected action, the QA expectations for it.
Cross-check the story's GDPR plan and security artefacts; QA _specifies_ what `code/`
enforces.

- **[EXAMPLE] Consent** — {consent control unticked by default; label states purpose,
  lawful basis, and retention}; cross-ref `../../09-GDPR/PLANNING/GDPR-PLAN-US###-*.md`.
- **[EXAMPLE] Permission** — {mutation requires an explicit permission check; caller's
  ownership of any supplied ID verified — no IDOR}.

_If the story handles no personal data and adds no protected action, state "None — no PII,
no new protected action" and omit the rows._

---

## Cross-references

- `../IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that
  verifies this plan against the running build
- `../../02-STORIES/US###.md` — the story whose acceptance criteria this plan tests and
  feeds back into
- `../../08-WIREFRAMES/` — the wireframe the scenarios are derived from
- `../../09-GDPR/PLANNING/` · `../../10-SECURITY/` — the GDPR and security constraints
  this plan cross-checks
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produces this plan
