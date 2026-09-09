# US000 — Manual Testing Guide

_Template — copy to `US###-MANUAL-TESTING.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. The executed manual walk-through for a single user story (US###): the journey a tester or Claude Chrome follows step by step, and whether each step passed._

**Last Updated**: {DD/MM/YYYY} · **Story**: US### · **Status**: {status: Passed / Failed / In progress / Blocked}

- **Story:** `../02-STORIES/US###.md` — {short title}
- **Story plan:** `../17-STORY-PLANS/{XX}-STORY-PLAN-US###-{DESCRIPTOR}.md` — the code master this guide exercises
- **Branch:** `us###/{short-description}`
- **Surface:** {Browser / CLI / Gate / API — pick one; it decides the row vocabulary below}

> **What this file is, and is not.** This records **executing** the manual tests and their outcome.
> Whether the story met its specified scenarios is `../11-QA/IMPLEMENTATION/`; whether the flow
> exists as designed is `../05-USER-FLOW/IMPLEMENTATION/`. Three records, three questions.
>
> **How to run it** — the browser tool contract, the marking rule and the re-run rule are in this
> folder's `CLAUDE.md`. Nothing here restates them.

---

## Preconditions and environment

- **Stack:** dev stack running — `bash code/src/scripts/development/server.sh up`
- **Base URL:** {the live URL `server.sh up` printed — never quoted from memory}
- **Seed data:** {the fixture or seeded users needed, via a `code/src/scripts/**/*.sh` entry point;
  never live credentials or real personal data}
- **Accounts / roles:** {which seeded roles are needed — note the permission boundary the story introduces}
- **Out of scope:** {any journey area this story does not touch, so a reader knows the omission is deliberate}

---

## Journeys

One `##` section per **area**, named for its consolidated flow
(`../05-USER-FLOW/CONSOLIDATED-IDEAS/USER-FLOW-CONSOLIDATED-{AREA}.md`). Rows run in the order a
person actually moves through the product, not grouped by test category.

**Row IDs are `{AREA}-{NN}`, where `{NN}` is the step number from that consolidated flow** — so a
row, a flow step and a diagram node all carry the same number. A step this story adds that the
flow does not yet have takes the next free number and is flagged in Notes.

**`QA`** cites the scenario this row exercises from `../11-QA/PLANNING/QA-PLAN-US###-{DESCRIPTOR}.md`
(`HP-nn`, `ES-nn`, `EC-nn`, `PA-nn`), or `—` where the row exercises none. An untraced row is not a
defect — it is a scenario the plan did not foresee, and it belongs in that plan's implementation
record under _New edge cases discovered_.

Mark `Result` **Pass** or **Fail**. A `Fail` **must** carry its reason in `Notes`; a `Pass` leaves
`Notes` empty unless there is something a later tester needs.

### {AREA — e.g. Sign-up}

| ID                    | Action                              | Expected outcome                                            | QA      | Result | Notes |
| --------------------- | ----------------------------------- | ----------------------------------------------------------- | ------- | ------ | ----- |
| _[EXAMPLE] SIGNUP-01_ | _Open the base URL_                 | _The home page loads and the **Sign up** button is visible_ | _—_     | _Pass_ | _{}_  |
| _[EXAMPLE] SIGNUP-02_ | _Click **Sign up**_                 | _The sign-up form opens with focus on the first field_      | _HP-01_ | _Pass_ | _{}_  |
| _[EXAMPLE] SIGNUP-03_ | _Submit with the email field empty_ | _An inline error is shown and focus moves to that field_    | _ES-01_ | _Pass_ | _{}_  |
| _[EXAMPLE] SIGNUP-04_ | _Submit a valid form_               | _The account is created and the dashboard loads_            | _HP-02_ | _Pass_ | _{}_  |

**Actions name what a person sees, never a selector** — "Click the **Book now** button in the
hero", not `[data-testid="book-now"]`. A control that cannot be found by its visible or accessible
name is itself a WCAG 2.2 AA finding; record it as a `Fail` on the accessibility journey rather
than working around it with a selector.

### {AREA — the next journey this story touches}

| ID                | Action | Expected outcome | QA  | Result | Notes |
| ----------------- | ------ | ---------------- | --- | ------ | ----- |
| _[EXAMPLE] {}-01_ | _{}_   | _{}_             | _—_ | _Pass_ | _{}_  |

---

## Permission and access

The same table, for what happens when a caller reaches a screen or action they should not have —
OWASP A01: ownership verified, no IDOR, and nothing leaked into the rendered page or its source.

| ID                  | Action                                                   | Expected outcome                                                 | QA      | Result | Notes |
| ------------------- | -------------------------------------------------------- | ---------------------------------------------------------------- | ------- | ------ | ----- |
| _[EXAMPLE] PERM-01_ | _Request a protected action while signed out_            | _Denied or redirected; no record data rendered_                  | _PA-01_ | _Pass_ | _{}_  |
| _[EXAMPLE] PERM-02_ | _Signed in as user A, request user B's record by its ID_ | _Denied; the response does not confirm the record exists_        | _PA-02_ | _Pass_ | _{}_  |
| _[EXAMPLE] PERM-03_ | _View the page source_                                   | _No database column names, admin URLs, or visitor personal data_ | _—_     | _Pass_ | _{}_  |

---

## Accessibility (WCAG 2.2 AA)

Executed against the rendered build — rules in `code/docs/ACCESSIBILITY.md`. These are steps with
outcomes, not a separate checklist: the automated axe gate covers only the routes listed in
`code/src/django/tests/e2e/a11y_config.py`, and contrast, focus order and screen-reader
announcement stay a manual pass whatever that tuple holds.

| ID                  | Action                                                  | Expected outcome                                                | QA  | Result | Notes |
| ------------------- | ------------------------------------------------------- | --------------------------------------------------------------- | --- | ------ | ----- |
| _[EXAMPLE] A11Y-01_ | _Tab from the top of the page to the last control_      | _Order follows the visual order; focus always visible; no trap_ | _—_ | _Pass_ | _{}_  |
| _[EXAMPLE] A11Y-02_ | _Inspect the heading structure_                         | _Exactly one `<h1>`; no level skipped_                          | _—_ | _Pass_ | _{}_  |
| _[EXAMPLE] A11Y-03_ | _Operate the story's primary control by keyboard alone_ | _Reachable, operable, and its state is announced_               | _—_ | _Pass_ | _{}_  |

## Responsive behaviour

| ID                 | Action             | Expected outcome                                      | QA  | Result | Notes |
| ------------------ | ------------------ | ----------------------------------------------------- | --- | ------ | ----- |
| _[EXAMPLE] RWD-01_ | _Resize to 360px_  | _Single column; no horizontal scroll_                 | _—_ | _Pass_ | _{}_  |
| _[EXAMPLE] RWD-02_ | _Resize to 600px_  | _The grid reflows at the critical breakpoint_         | _—_ | _Pass_ | _{}_  |
| _[EXAMPLE] RWD-03_ | _Resize to 768px_  | _Layout switches as the story's responsive spec says_ | _—_ | _Pass_ | _{}_  |
| _[EXAMPLE] RWD-04_ | _Resize to 1280px_ | _Full layout; line length stays comfortably readable_ | _—_ | _Pass_ | _{}_  |

Breakpoints above are the project defaults — adjust to the story's own responsive spec.

---

## Failures

Every `Fail` above, once, with what it blocks. `None.` if the walk was clean. A failure is
**recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a finding.

| ID                    | What happened                                                | Blocks the story? | Routed to       |
| --------------------- | ------------------------------------------------------------ | ----------------- | --------------- |
| _[EXAMPLE] SIGNUP-03_ | _{the error rendered but focus stayed on the submit button}_ | _No_              | _`../21-BUGS/`_ |

---

## Tester sign-off

| Field        | Value                                                      |
| ------------ | ---------------------------------------------------------- |
| **Tester**   | {name, or `Claude Chrome` — and the human who reviewed it} |
| **Date**     | {DD/MM/YYYY}                                               |
| **Browsers** | {those actually used — a browser not opened is not a pass} |
| **Outcome**  | Passed / Passed with notes / Failed / Blocked              |
| **Blockers** | {none — or the failing row IDs}                            |

- [ ] Every row carries a `Pass` or a `Fail` — an empty `Result` is an unrun step, never a pass
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and each `{AREA}-{NN}` matches its flow step
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against `US###-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../02-STORIES/US###.md` — the story under test
- `../17-STORY-PLANS/{XX}-STORY-PLAN-US###-{DESCRIPTOR}.md` — the implementation plan this guide exercises
- `US###-TEST-STATUS.md` — the paired automated-test record
- `../11-QA/PLANNING/QA-PLAN-US###-{DESCRIPTOR}.md` — where the `QA` column's scenario IDs are defined
- `../11-QA/IMPLEMENTATION/QA-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — whether the specified scenarios were met
- `../05-USER-FLOW/IMPLEMENTATION/USER-FLOW-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — the flow as built, whose step numbers these IDs reuse
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA rules for the accessibility journey

<!-- UPDATED 09/09/2026. Rewritten from a QA-taxonomy checklist into an executed journey
     walk-through. It was grouped Happy path / Error states / Edge cases / Permission & security /
     Accessibility — the same four scenario classes, under the same HP/ES/EC/PA IDs, that
     "../11-QA/PLANNING/" defines and "../11-QA/IMPLEMENTATION/" verifies, so the taxonomy was
     written three times and this file owned none of it. It now groups by journey area and reuses
     the consolidated flow's step numbers, keeping the scenario ID as a trace column instead.
     Reason: 11-QA answers "were the specified scenarios met", 05-USER-FLOW answers "does the flow
     exist as designed", and this answers "did executing it pass" — three questions, one owner
     each. The rows are also addressed to a browser agent as well as a human, which is why an
     action names a visible control and never a selector. Owner of the run contract: this folder's
     CLAUDE.md. Settled by the grilling pass of 09/09/2026. -->
