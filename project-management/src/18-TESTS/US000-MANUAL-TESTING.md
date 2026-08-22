# US000 — Manual Testing Guide

_Template — copy to `US###-MANUAL-TESTING.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. The human-run manual test walk-through for a single user story (US###): the scenarios a tester follows by hand and signs off before the story merges._

**Last Updated**: {DD/MM/YYYY} · **Story**: US### · **Status**: {status: In progress / Passed / Blocked}

- **Story:** `../02-STORIES/US###.md` — {short title}
- **Story plan:** `../17-STORY-PLANS/STORY-PLAN-US###-{DESCRIPTOR}.md` — the code master this guide exercises
- **Branch:** `us###/{short-description}`

---

## Preconditions & environment

- **Stack:** dev stack running — `bash code/src/scripts/development/server.sh up`
- **URL:** {the route(s) under test, e.g. `http://localhost:8000/{path}`}
- **Seed data:** {the fixture or seeded users needed — run via the project seeding command,
  e.g. `bash code/src/scripts/database/{seed-script}.sh`; never live credentials or real PII}
- **Accounts / roles:** {which seeded roles are needed — e.g. an anonymous visitor and one
  authorised user; note the permission boundary the story introduces}
- **Tools:** {browser(s) + any extension, e.g. axe DevTools, for the accessibility pass}

Mark each scenario **✅ / ❌** in the `Result` column; put any observation, ticket, or deviation
in `Notes`.

---

## Happy path

The expected successful journeys, end to end.

| ID                | Steps                     | Expected result                              | Result | Notes |
| ----------------- | ------------------------- | -------------------------------------------- | ------ | ----- |
| _[EXAMPLE] HP-01_ | _{navigate to the route}_ | _{page loads (HTTP 200); {element} visible}_ | _✅_   | _{}_  |

## Error states

Every visible validation failure, empty state, server error, and timeout.

| ID                | Steps                            | Expected result                                  | Result | Notes |
| ----------------- | -------------------------------- | ------------------------------------------------ | ------ | ----- |
| _[EXAMPLE] ES-01_ | _{submit with an invalid field}_ | _{inline error shown; focus moves to the field}_ | _✅_   | _{}_  |

## Edge cases

Boundary inputs and unusual-but-valid conditions.

| ID                | Steps                              | Expected result                        | Result | Notes |
| ----------------- | ---------------------------------- | -------------------------------------- | ------ | ----- |
| _[EXAMPLE] EC-01_ | _{value one char over max length}_ | _{rejected with a validation message}_ | _✅_   | _{}_  |

## Permission & security

What happens when a caller reaches a screen or action they should not have (OWASP A01 —
verify ownership, no IDOR; no secrets or personal data leaked in the page/source).

| ID                | Steps                                            | Expected result                                            | Result | Notes |
| ----------------- | ------------------------------------------------ | ---------------------------------------------------------- | ------ | ----- |
| _[EXAMPLE] PA-01_ | _{anonymous caller requests a protected action}_ | _{denied / redirected; no data leak}_                      | _✅_   | _{}_  |
| _[EXAMPLE] PA-02_ | _{view page source}_                             | _{no DB column names, admin URLs, or visitor PII in HTML}_ | _✅_   | _{}_  |

## Accessibility (WCAG 2.2 AA)

Verify against the rendered build — see `code/docs/ACCESSIBILITY.md`.

| ID                | Steps                                    | Expected result                                         | Result | Notes |
| ----------------- | ---------------------------------------- | ------------------------------------------------------- | ------ | ----- |
| _[EXAMPLE] AX-01_ | _{run axe DevTools on the route}_        | _{zero violations}_                                     | _✅_   | _{}_  |
| _[EXAMPLE] AX-02_ | _{tab through all interactive elements}_ | _{logical order; visible focus ring; no keyboard trap}_ | _✅_   | _{}_  |
| _[EXAMPLE] AX-03_ | _{inspect heading structure}_            | _{one `<h1>`; no skipped levels}_                       | _✅_   | _{}_  |

---

## Device & breakpoint matrix

Confirm the layout at each breakpoint and on each target browser. Breakpoints below are the
project defaults — adjust to the story's responsive spec.

| Viewport           | What to check                                 | Result | Notes |
| ------------------ | --------------------------------------------- | ------ | ----- |
| _360px (mobile)_   | _{single-column; no horizontal scroll}_       | _✅_   | _{}_  |
| _600px (xmd)_      | _{grid reflows at the critical breakpoint}_   | _✅_   | _{}_  |
| _768px (tablet)_   | _{layout switches as designed}_               | _✅_   | _{}_  |
| _1280px (desktop)_ | _{full layout; content comfortably readable}_ | _✅_   | _{}_  |

| Browser   | Version  | Result | Notes |
| --------- | -------- | ------ | ----- |
| _Chrome_  | _Latest_ | _✅_   | _{}_  |
| _Firefox_ | _Latest_ | _✅_   | _{}_  |
| _Safari_  | _Latest_ | _✅_   | _{}_  |

---

## Tester sign-off

| Field        | Value                                       |
| ------------ | ------------------------------------------- |
| **Tester**   | {name / agent}                              |
| **Date**     | {DD/MM/YYYY}                                |
| **Outcome**  | Passed / Passed with notes / Blocked        |
| **Blockers** | {none — or the failing scenario IDs + refs} |

- [ ] Every scenario above marked ✅, or a ❌ carries a note and an owning story/ticket
- [ ] Device & breakpoint matrix complete across the target browsers
- [ ] No secrets, real credentials, or personal data used or exposed during testing
- [ ] Result mirrored in `US###-TEST-STATUS.md` and the QA review before merge

---

## Cross-references

- `../02-STORIES/US###.md` — the story under test
- `../17-STORY-PLANS/STORY-PLAN-US###-{DESCRIPTOR}.md` — the implementation plan this guide exercises
- `US###-TEST-STATUS.md` — the paired automated-test status record
- `../11-QA/IMPLEMENTATION/QA-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — the QA review that signs the story off
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA rules for the accessibility pass
