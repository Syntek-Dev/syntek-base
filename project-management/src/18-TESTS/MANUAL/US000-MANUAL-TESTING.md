# US000 — Manual Testing Guide

_Template — copy to `US###-MANUAL-TESTING.md` at `17-story-plans` Step 7.2, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. The manual testing guide for a single user story (US###): the journey a tester or Claude Chrome follows step by step, and — once walked — whether each step passed._

**Last Updated**: {DD/MM/YYYY} · **Story**: US### · **Status**: {Authored — not yet walked / In progress / Passed / Failed / Blocked}

- **Story:** `../../02-STORIES/US###.md` — {short title}
- **Story plan:** `../../17-STORY-PLANS/{XX}-STORY-PLAN-US###-{DESCRIPTOR}.md` — the code master this guide was authored beside
- **Branch:** `us###/{short-description}`
- **Surface:** {Browser / CLI / Gate / API — pick one; it decides the row vocabulary below}
- **Authored from:** {every spec artefact read at authoring — story, QA plan, user flow, wireframes, security and GDPR plans, ADRs, the story plan. Never code.}

> **Authored before code, walked after it.** Which workflow writes which part of this file, and
> when, is `../CLAUDE.md` → _The record lifecycle_. Every rule for filling it — authoring, open
> questions, row IDs, the two citation columns, the build captures, marking, amendments and the
> browser contract — is this folder's `CLAUDE.md`. Neither is restated here.
>
> **What this file is, and is not.** This records **executing** the manual tests and their outcome.
> Whether the story met its specified scenarios is `../../11-QA/IMPLEMENTATION/`; whether the flow
> exists as designed is `../../05-USER-FLOW/IMPLEMENTATION/`. Three records, three questions.

---

## Preconditions and environment

- **Stack:** dev stack running — `bash code/src/scripts/development/server.sh up`
- **Base URL:** {the live URL `server.sh up` printed — never quoted from memory}
- **Seed data:** {the fixture or seeded users needed, via a `code/src/scripts/**/*.sh` entry point;
  never live credentials or real personal data}
- **Accounts / roles:** {which seeded roles are needed — note the permission boundary the story introduces}
- **Out of scope:** {any journey area this story does not touch, and any QA-plan scenario a person cannot walk, each with its reason — so a reader knows the omission is deliberate}
- **Open questions:** {`None.` — or each point the records could not decide, numbered and awaiting the developer's answer; every row it holds carries `Awaiting answer` in `Notes`}

---

## Recorded during the build

Captures a spec requires this file to hold that are not steps — a baseline, an inventory, a
figure the rows are compared with. Authored at `17` with every value blank, and filled at the
moment each slot names. `None required.` if no spec asks for one.

| Capture                                                                                 | Required by                       | Taken                   | Value |
| --------------------------------------------------------------------------------------- | --------------------------------- | ----------------------- | ----- |
| _[EXAMPLE] The citation-gate findings by identity, with `HEAD` and the git-index state_ | _the story's Verification Checks_ | _Before the first edit_ |       |
| _[EXAMPLE] The same gate's findings, same form, same index state_                       | _the story's QA Tasks — Manual_   | _At the walk_           |       |

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### {AREA — e.g. Sign-up}

| ID                    | Action                              | Expected outcome                                            | Flow           | QA      | Result | Notes |
| --------------------- | ----------------------------------- | ----------------------------------------------------------- | -------------- | ------- | ------ | ----- |
| _[EXAMPLE] SIGNUP-01_ | _Open the base URL_                 | _The home page loads and the **Sign up** button is visible_ | _—_            | _—_     |        |       |
| _[EXAMPLE] SIGNUP-02_ | _Click **Sign up**_                 | _The sign-up form opens with focus on the first field_      | _SIGN-UP 1_    | _HP-01_ |        |       |
| _[EXAMPLE] SIGNUP-03_ | _Submit with the email field empty_ | _An inline error is shown and focus moves to that field_    | _SIGN-UP 2_    | _ES-01_ |        |       |
| _[EXAMPLE] SIGNUP-04_ | _Submit a valid form_               | _The account is created and the dashboard loads_            | _SIGN-UP 2, 3_ | _HP-02_ |        |       |

### {AREA — the next journey this story touches}

| ID                | Action | Expected outcome | Flow | QA  | Result | Notes |
| ----------------- | ------ | ---------------- | ---- | --- | ------ | ----- |
| _[EXAMPLE] {}-01_ | _{}_   | _{}_             | _—_  | _—_ |        |       |

---

## Permission and access

The same table, for what happens when a caller reaches a screen or action they should not have —
OWASP A01: ownership verified, no IDOR, and nothing leaked into the rendered page or its source.

| ID                  | Action                                                   | Expected outcome                                                 | Flow | QA      | Result | Notes |
| ------------------- | -------------------------------------------------------- | ---------------------------------------------------------------- | ---- | ------- | ------ | ----- |
| _[EXAMPLE] PERM-01_ | _Request a protected action while signed out_            | _Denied or redirected; no record data rendered_                  | _—_  | _PA-01_ |        |       |
| _[EXAMPLE] PERM-02_ | _Signed in as user A, request user B's record by its ID_ | _Denied; the response does not confirm the record exists_        | _—_  | _PA-02_ |        |       |
| _[EXAMPLE] PERM-03_ | _View the page source_                                   | _No database column names, admin URLs, or visitor personal data_ | _—_  | _—_     |        |       |

---

## Accessibility (WCAG 2.2 AA)

Executed against the rendered build — rules in `code/docs/ACCESSIBILITY.md`. These are steps with
outcomes, not a separate checklist: the automated axe gate covers only the routes listed in
`code/src/django/tests/e2e/a11y_config.py`, and contrast, focus order and screen-reader
announcement stay a manual pass whatever that tuple holds.

| ID                  | Action                                                  | Expected outcome                                                | Flow | QA  | Result | Notes |
| ------------------- | ------------------------------------------------------- | --------------------------------------------------------------- | ---- | --- | ------ | ----- |
| _[EXAMPLE] A11Y-01_ | _Tab from the top of the page to the last control_      | _Order follows the visual order; focus always visible; no trap_ | _—_  | _—_ |        |       |
| _[EXAMPLE] A11Y-02_ | _Inspect the heading structure_                         | _Exactly one `<h1>`; no level skipped_                          | _—_  | _—_ |        |       |
| _[EXAMPLE] A11Y-03_ | _Operate the story's primary control by keyboard alone_ | _Reachable, operable, and its state is announced_               | _—_  | _—_ |        |       |

## Responsive behaviour

| ID                 | Action             | Expected outcome                                      | Flow | QA  | Result | Notes |
| ------------------ | ------------------ | ----------------------------------------------------- | ---- | --- | ------ | ----- |
| _[EXAMPLE] RWD-01_ | _Resize to 360px_  | _Single column; no horizontal scroll_                 | _—_  | _—_ |        |       |
| _[EXAMPLE] RWD-02_ | _Resize to 600px_  | _The grid reflows at the critical breakpoint_         | _—_  | _—_ |        |       |
| _[EXAMPLE] RWD-03_ | _Resize to 768px_  | _Layout switches as the story's responsive spec says_ | _—_  | _—_ |        |       |
| _[EXAMPLE] RWD-04_ | _Resize to 1280px_ | _Full layout; line length stays comfortably readable_ | _—_  | _—_ |        |       |

Breakpoints above are the project defaults — adjust to the story's own responsive spec.

---

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID                    | What happened                                                | Blocks the story? | Routed to          |
| --------------------- | ------------------------------------------------------------ | ----------------- | ------------------ |
| _[EXAMPLE] SIGNUP-03_ | _{the error rendered but focus stayed on the submit button}_ | _No_              | _`../../21-BUGS/`_ |

---

## Tester sign-off

Filled at the walk.

| Field        | Value                                                      |
| ------------ | ---------------------------------------------------------- |
| **Tester**   | {name, or `Claude Chrome` — and the human who reviewed it} |
| **Date**     | {DD/MM/YYYY}                                               |
| **Browsers** | {those actually used — a browser not opened is not a pass} |
| **Outcome**  | Passed / Passed with notes / Failed / Blocked              |
| **Blockers** | {none — or the failing row IDs}                            |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against `../AUTOMATED/US###-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US###.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/{XX}-STORY-PLAN-US###-{DESCRIPTOR}.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US###-TEST-STATUS.md` — the paired automated-test record
- `../../11-QA/PLANNING/QA-PLAN-US###-{DESCRIPTOR}.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — whether the specified scenarios were met
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/USER-FLOW-CONSOLIDATED-{AREA}.md` — where the `Flow` column's step numbers are defined
- `../../05-USER-FLOW/IMPLEMENTATION/USER-FLOW-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — the flow as built
- `../../20-FINDINGS/FINDING-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — where each amendment made at the walk is recorded
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

<!-- UPDATED 30/09/2026. Moved into MANUAL/ when "../" split by record type, and turned from a
     walk-through written after the code into a guide written before it: 17-story-plans authors
     it from the specs, and 22-implementation-documentation walks it. So every Result cell ships
     blank, the header gained "Authored from" and an "Authored — not yet walked" status, and
     Failures and the sign-off are marked as filled at the walk. Rows now carry their own
     permanent {AREA}-{NN} IDs and a new Flow column that cites the consolidated user-flow step,
     reversing the 09/09/2026 rule above that {NN} reused that step number — the consolidated
     flow does not exist yet when the guide is authored. The sign-off gained the amendment
     check, and every relative path gained a level for the new depth. The review of the same
     change added the "Open questions" line and the "Recorded during the build" section — the one
     part of this file the build writes — and cut the opening note to routes. The reasoning, and
     every rule this template follows, are in this folder's CLAUDE.md; settled by the grilling
     pass of 30/09/2026. -->
