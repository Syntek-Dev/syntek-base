# US000 — [Story Title]

**Epic:** [Epic Name — e.g. Authentication & Access Control / Core Features / Public Pages]
**Status:** Open

<!-- FLAGS
     DB        — shortlist of models created / modified, or N/A
     User Flow — Yes or N/A
     Backend   — Yes or N/A
     API       — shortlist of Ninja endpoints introduced, or N/A
     Frontend  — Public / Admin / Both / N/A  (all server-rendered Django templates)
     GDPR      — Yes (complete GDPR section below) or N/A
     Security  — shortlist of concerns (e.g. rate-limit, audit-log, XSS-escape, IDOR), or N/A
     SEO       — shortlist of affected pages / routes (e.g. /blog, /about), or N/A
     Testing   — shortlist of test types required (e.g. unit, integration, E2E, manual), or N/A -->

| Flag      | Value                                                |
| --------- | ---------------------------------------------------- |
| DB        | `ModelA`, `ModelB`                                   |
| User Flow | Yes                                                  |
| Backend   | Yes                                                  |
| API       | `POST /model-a`, `PATCH /model-a`, `DELETE /model-a` |
| Frontend  | Both                                                 |
| GDPR      | Yes                                                  |
| Security  | rate-limit, audit-log, XSS-escape                    |
| SEO       | /blog, /about                                        |
| Testing   | unit, integration, E2E                               |

---

## Client Summary

<!-- Plain-English description for client review. 1–3 sentences. No technical jargon.
     Describe WHAT the feature does and WHY it matters to the client or end user.
     This section is included in the Client Approval Pack PDF. -->

[Plain-English description of what this feature does and the benefit it provides.]

---

## User Story

As a [role], I want [capability], so that [benefit].

## MoSCoW Priority

**Must Have** <!-- Must Have / Should Have / Could Have / Won't Have -->

## Story Points

<!-- Rough guide: 1–2 = trivial · 3–5 = moderate · 8 = large · 13 = extra-large (split candidate) -->

[N]

## Dependencies

- US### ([Story title] — [reason this story depends on it])
- [External service / middleware / library required]

---

## Acceptance Criteria

[One or two sentences describing what success looks like for this story overall.]

```gherkin
Scenario: [Happy path — primary success case]
Given [precondition]
When [action]
Then [expected outcome]
And [additional assertion]

Scenario: [Alternative path or edge case]
Given [precondition]
When [action]
Then [expected outcome]

Scenario: [Failure / permission-denied / validation-error case]
Given [precondition]
When [action]
Then [expected error or rejection]
And [system state remains consistent]
```

### DB Acceptance Criteria

<!-- Remove this section when DB flag is N/A. -->

```gherkin
Scenario: [Model structure is correct]
Given the [ModelName] model is created
Then it has the following fields:
  - [field_name] ([type], [constraints])
  - [field_name] ([type], [constraints])
And there is a unique constraint on [field or field pair]

Scenario: [Constraint is enforced at the database layer]
Given [precondition]
When [action that would violate the constraint]
Then the database rejects the operation with a constraint violation error

Scenario: [Migration applies cleanly]
Given the migration is run against a clean database
Then `database/migrate.sh check` reports no unapplied changes
And `tests/backend.sh` passes after the migration is applied
```

### User Flow Acceptance Criteria

<!-- Remove this section when User Flow flag is N/A. -->

```gherkin
Scenario: [Authenticated user completes the primary flow]
Given [user role and precondition]
When they navigate to [entry point]
Then they see [expected UI state]
And [expected outcome on success]

Scenario: [Unauthenticated user is redirected]
Given a user who is not authenticated
When they navigate to [protected route]
Then they are redirected to [login page]
And the original destination is saved for post-login redirect

Scenario: [Insufficient permission — access denied]
Given an authenticated user without the required permission
When they navigate to [protected route]
Then they see an access-denied screen
And no [feature] functionality is visible

Scenario: [Error state is handled gracefully]
Given [precondition]
When [action that causes an error]
Then the user sees [error message / toast]
And the system state remains consistent
```

### Backend Acceptance Criteria

<!-- Remove this section when Backend flag is N/A. -->

- [ ] `[service_function]` returns the expected result on the success path
- [ ] `[service_function]` raises `ValidationError` with a clear message on invalid input
- [ ] `[service_function]` raises `PermissionDenied` when the caller lacks the required permission
- [ ] All writes to two or more tables within `[service_function]` are wrapped in `transaction.atomic()`
- [ ] User-supplied IDs are verified against the caller's ownership before any query executes (IDOR prevention)
- [ ] `post_save` signal on `[Model]` fires and is idempotent (safe to run twice without side effects)
- [ ] Celery task `[task_name]` executes on schedule and logs success or failure with error details

### API Acceptance Criteria

<!-- Remove this section when API flag is N/A. -->

- [ ] `[endpoint]` — authenticated caller with required permission receives the expected payload
- [ ] `[endpoint]` — unauthenticated caller receives HTTP 401
- [ ] `[endpoint]` — caller without required permission receives HTTP 403
- [ ] `[endpoint]` — invalid input returns a validation error with a descriptive message
- [ ] `[endpoint]` (read) — returns only records the caller is authorised to view
- [ ] All write endpoints write to `audit_auditlog` before the transaction commits

### Frontend Acceptance Criteria

<!-- Remove this section when Frontend flag is N/A.
     Scope subsections to Public / Admin / both as indicated by the Frontend flag. -->

```gherkin
Scenario: [Component renders in the correct state]
Given [precondition]
When [user action]
Then [expected UI outcome]
And [additional assertion]

Scenario: [Web — form validation prevents invalid submission]
Given the [form name] form
When the user submits without completing [required field]
Then an inline error message appears below the field
And the form cannot be submitted

Scenario: [Web — permission-gated controls are hidden or disabled]
Given a user with insufficient permission
When they view [page or component]
Then [edit / delete / create] controls are [hidden / disabled with tooltip]

Scenario: [HTMX — the partial swaps in on success]
Given [precondition]
When the user submits [form]
Then the [target region] is replaced with [expected fragment]
And no full page reload occurs

Scenario: [HTMX — validation failure re-renders the form]
Given [precondition]
When the user submits [form] with an invalid field
Then the response is HTTP 200 carrying the re-rendered form and its inline errors
And the previously entered values are preserved

Scenario: [Alpine — local UI state only]
Given [component with local state, e.g. a disclosure or menu]
When the user [toggles it]
Then the state changes in the browser with no server round-trip
```

<!-- Interaction tier: server template → HTMX → Alpine. There is no fourth tier, and a page
     never calls the JSON API — Django views return HTML, `apps/<app>/api.py` returns JSON to
     machine clients. See code/docs/RENDERING.md and code/docs/api-design/CLIENT-PATTERNS.md. -->

### GDPR Acceptance Criteria

<!-- Remove this section when GDPR flag is N/A. -->

- [ ] `[field_name]` is stored as `EncryptedField` (Fernet AES-256-GCM) — never persisted in plaintext
- [ ] HMAC-SHA3-256 companion field `[hmac_token]` is written on every create and update for erasure lookup
- [ ] `[app].gdpr_erase([identifier])` nulls `[field list]`, retains the row for audit purposes
- [ ] `[app].gdpr_erase()` is wired into the US### erasure orchestrator
- [ ] Celery Beat task `[task_name]` purges / anonymises rows older than [retention period]
- [ ] Consent gate: `[endpoint]` rejects any call where `consent_given = False` with a clear error
- [ ] No PII field is exposed in any public endpoint or server-rendered page
- [ ] PII fields are documented in the Privacy Policy (US###) and Sub-Processor Register

### Security Acceptance Criteria

<!-- Remove this section when Security flag is N/A.
     Prefix each item with the relevant story + security test reference in brackets. -->

- [ ] [UF##/ST##] Rate limit on `[endpoint]`: maximum N attempts per IP per M minutes; HTTP 429 returned on breach
- [ ] [UF##/ST##] Exponential backoff enforced after the lockout period expires
- [ ] [UF##/ST##] `audit_auditlog` entry written on every `[success event]`: `action = [action_name]`, including actor ID and IP
- [ ] [UF##/ST##] `audit_auditlog` entry written on every `[failure event]`: `action = [action_name]`, including IP and reason
- [ ] [UF##/ST##] User-supplied `[id field]` is verified against the caller's session before the query executes — no IDOR possible
- [ ] [UF##/ST##] `[user-supplied field]` is HTML-escaped server-side before rendering in any admin or public view — raw HTML is never rendered
- [ ] [UF##/ST##] `request.session.flush()` is called on logout — server-side session deleted from Valkey; client-side cookie deletion alone is insufficient

### Logging Acceptance Criteria

<!-- Always applicable when Backend or Frontend ≠ N/A.
     Log IDs — never log values. Never log [enc] fields. -->

- [ ] All server-side log calls use `logging.getLogger("apps.[app-name]")` (Django) — no bare `print()` on any server path, and no stray `console.log()` in committed JavaScript
- [ ] `[key operation]` logs entry at `DEBUG` with safe fields: `[entity]_id`, `action` — no PII, no `[enc]` field values
- [ ] `[key operation]` logs success at `INFO` with: `[entity]_id`, `duration_ms` — no encrypted field values
- [ ] Permission-denied paths log at `WARNING` with: `actor_id`, `target_id`, `action` — no passwords, tokens, or session keys
- [ ] Unexpected exceptions log at `ERROR` with: exception type and operation name — stack traces never contain raw PII
- [ ] No field marked `[enc]` in the story's schema design (`04-DATABASE/DB-<FEATURE>-DD-MM-YYYY.md`) appears in any log output
- [ ] No `console.*` in any committed JavaScript — browser logging routes through the project logger

### SEO Acceptance Criteria

<!-- Remove this section when SEO flag is N/A. -->

- [ ] All new public-facing pages have a `<title>` and `<meta name="description">` set via the Django template `<head>`, through the `build_seo()` helper the first public page brings with it (`code/docs/discoverability/WEB-METADATA.md`)
- [ ] `og:title`, `og:description`, and `og:image` are set for all new public pages
- [ ] Canonical URL is set correctly — no duplicate content risk
- [ ] JSON-LD structured data is included where applicable (e.g. `Article`, `BreadcrumbList`, `Organization`)
- [ ] Page slug / URL is human-readable, lowercase, hyphenated, and contains the target keyword
- [ ] New pages are included in `sitemap.xml` (via Celery regeneration task or static addition)
- [ ] `robots.txt` does not block any new public page
- [ ] Page meets Core Web Vitals targets: LCP < 2.5 s, CLS < 0.1, INP < 200 ms
- [ ] All images on the page have descriptive `alt` text; no image is served without `alt`
- [ ] Heading hierarchy is correct: one `<h1>` per page; `<h2>` / `<h3>` used in logical order

### Testing Acceptance Criteria

<!-- Remove this section when Testing flag is N/A. -->

- [ ] Coverage is at or above 75 % line and branch for all modules (at or above 90 % for auth-related paths) after this story — one floor: template, django-component, and HTMX-partial tests are pytest tests and count towards it
- [ ] Unit tests cover the success path, validation error, and permission error for `[service_function]`
- [ ] Unit tests cover constraint enforcement and signal idempotence for `[ModelName]`
- [ ] Integration tests cover the success path, 401, and 403 for all endpoints introduced by this story
- [ ] E2E tests cover the primary user flow, the permission-denied path, and at least one form validation error
- [ ] Manual checks cover any UI behaviour not reachable by automation (e.g. [drag-and-drop, colour picker])

---

## Tasks

All tasks below map directly to an acceptance criterion above. Mark each complete before raising a PR.

### DB Tasks

<!-- Remove this section when DB flag is N/A. -->

- [ ] Create Django model `[ModelName]` in `code/src/django/apps/<app>/models.py`
- [ ] Add fields: [field list with types and constraints]
- [ ] Add unique constraint on `([field_a, field_b])`
- [ ] Add index on `[field_c]` for `[query pattern]`
- [ ] Add check constraint: `[invariant description]`
- [ ] Write and apply the migration via `bash code/src/scripts/database/migrate.sh make` → review → `... run`, then `bash code/src/scripts/database/migrate.sh check` and `bash code/src/scripts/tests/backend.sh`
- [ ] Seed initial data if required (via data migration or fixture)

### User Flow Tasks

<!-- Remove this section when User Flow flag is N/A. -->

- [ ] Create wireframe for `[UI area]` covering the primary path, error states, and permission-denied state
- [ ] Review wireframe with stakeholders before implementation begins
- [ ] Link wireframe reference in the Frontend Tasks section below

### Backend Tasks

<!-- Remove this section when Backend flag is N/A. -->

- [ ] Implement service method `[name]` in `code/src/django/apps/<app>/services.py` wrapped in `transaction.atomic()`
- [ ] Verify caller ownership of user-supplied `[id field]` before querying (IDOR prevention)
- [ ] Implement `post_save` signal for `[Model]` using `get_or_create` (idempotent)
- [ ] Create Celery task `[task_name]` with schedule `[cron expression]`
- [ ] Add `audit_auditlog` entry on `[event]` — fields: `actor_id`, `target_id`, `action`, `ip`, `timestamp`

### API Tasks

<!-- Remove this section when API flag is N/A. -->

- [ ] Add Django Ninja read endpoint `[endpoint]` with an explicit permission check, on a router mounted onto the project's single `NinjaAPI` (`config/api.py`, served at `/api/`)
- [ ] Add Django Ninja write endpoint `[endpoint]` with an explicit permission check and a service-layer call
- [ ] Apply the permission guard: `@permission_required("[module]", level="[view|edit|full]")`
- [ ] Define the request/response `Schema` classes — Ninja is Python-typed; consumers read the JSON directly (no codegen step)

### Frontend Tasks

<!-- Remove this section when Frontend flag is N/A.
     Scope tasks to Public / Admin / both as indicated by the Frontend flag. -->

<!-- Pages and components -->

- [ ] Scaffold the public page via `bash code/src/scripts/development/new-django-view.sh <route_path>` — a Django view + template + `urls.py` entry in `apps.marketing`
- [ ] Build `[ComponentName]` as a django-component in the root its ownership assigns it — `code/docs/FRONTEND-CODING-PRINCIPLES.md` Section _Component & Code Placement_ (HTMX + Alpine, token-driven CSS)
- [ ] Wire server-side rendering / HTMX interactions — no client-side API fetch anywhere
- [ ] Implement form validation (required fields, character limits, live counters)
- [ ] Implement permission-based control visibility (hidden / disabled with tooltip)
- [ ] Handle loading, empty, and error states

<!-- HTMX interactions -->

- [ ] Return the smallest partial that satisfies the swap; the `hx-target` id exists in the response
- [ ] Every non-instant request carries `hx-indicator` / `hx-disabled-elt`
- [ ] Validation failure returns `200` with the re-rendered form and its errors

<!-- Both -->

- [ ] Write user guide / help article for `[workflow]`

### GDPR Tasks

<!-- Remove this section when GDPR flag is N/A. -->

- [ ] Add `EncryptedField` (Fernet AES-256-GCM) to `[field_name]` in `<app>/models.py`
- [ ] Add HMAC-SHA3-256 companion field `[hmac_token]` for erasure lookup without decryption
- [ ] Implement `[app].gdpr_erase([identifier])` — nulls `[field list]`, retains row
- [ ] Wire `[app].gdpr_erase()` into the US### erasure orchestrator
- [ ] Create Celery Beat task `[task_name]` for retention purge after `[period]`
- [ ] Enforce consent gate in `[endpoint]`: reject if `consent_given = False`
- [ ] Document PII fields in Privacy Policy (US###) and Sub-Processor Register

### Security Tasks

<!-- Remove this section when Security flag is N/A. -->

- [ ] Implement rate limit on `[endpoint]` — max N attempts per IP per M minutes
- [ ] Return HTTP 429 with `Retry-After` header on rate limit breach; enforce exponential backoff after lockout
- [ ] HTML-escape `[field]` server-side before rendering in any admin or public view
- [ ] Add `audit_auditlog` entry on `[success event]` within the same `transaction.atomic()` block as the write
- [ ] Add `audit_auditlog` entry on `[failure event]` including IP and reason
- [ ] Verify `[endpoint]` rejects calls where the session user does not own the target resource

### Logging Tasks

<!-- Always applicable when Backend or Frontend ≠ N/A.
     Reference: code/docs/LOGGING.md -->

- [ ] Backend: use `logging.getLogger("apps.[app-name]")` for all log calls in `<app>/services.py` and `<app>/api.py` (Ninja endpoints)
- [ ] Backend: add `DEBUG` log at entry of `[service_method]` with `[entity]_id` and `action` only
- [ ] Backend: add `INFO` log on success of `[service_method]` with `[entity]_id` and `duration_ms`
- [ ] Backend: add `WARNING` log on permission-denied in `[endpoint]` — include `actor_id`, `action`; never include token or PII
- [ ] Server-rendered pages: log key user-facing events via `logging.getLogger("apps.[app-name]")` with safe fields only (IDs, not values)
- [ ] Browser: route any client logging through the project logger — never a raw `console.log()` in committed code
- [ ] Confirm: no `[enc]` field values, no raw emails / names / tokens appear in any log line for this story
- [ ] Confirm: no `console.log` / `console.error` in any committed JavaScript

### SEO Tasks

<!-- Remove this section when SEO flag is N/A. -->

- [ ] Set `<title>` and `<meta name="description">` via the Django template `<head>` for `[page / route]` — through the `build_seo()` helper (`code/docs/discoverability/WEB-METADATA.md`)
- [ ] Set `og:title`, `og:description`, `og:image` for `[page / route]`
- [ ] Set canonical URL for `[page / route]`
- [ ] Add JSON-LD structured data (`[schema type]`) to `[page / route]`
- [ ] Verify page slug is human-readable, lowercase, and hyphenated
- [ ] Add `[page / route]` to `sitemap.xml` — trigger Celery regeneration task if applicable
- [ ] Confirm `robots.txt` does not block `[page / route]`
- [ ] Run Lighthouse (or equivalent) to verify Core Web Vitals targets are met
- [ ] Add descriptive `alt` text to all images on `[page / route]`
- [ ] Verify heading hierarchy: one `<h1>` per page; `<h2>` / `<h3>` in logical order
- [ ] Run the `seo` skill to confirm all SEO checks pass

### Testing Tasks

<!-- Remove this section when Testing flag is N/A. -->

<!-- Unit tests -->

- [ ] `[ModelName]` — unique constraint raises `IntegrityError` on duplicate
- [ ] `[ModelName]` — check constraint raises `IntegrityError` on violation
- [ ] `[service_function]` — success path returns expected result
- [ ] `[service_function]` — raises `ValidationError` on invalid input
- [ ] `[service_function]` — raises `PermissionDenied` without required permission
- [ ] Signal `[signal_handler]` — idempotent when called twice (no duplicate rows)

<!-- Integration tests -->

- [ ] `[endpoint]` — success path returns expected payload
- [ ] `[endpoint]` — unauthenticated caller receives 401
- [ ] `[endpoint]` — caller without permission receives 403
- [ ] `[endpoint]` — invalid input returns validation error with descriptive message

<!-- E2E tests (pytest-playwright — code/src/django/tests/e2e/, run via tests/e2e-py.sh) -->

- [ ] Primary user flow — happy path completes and displays success state
- [ ] Permission-denied path — user without access sees access-denied screen or is redirected
- [ ] Form validation — required field error is displayed without submission
- [ ] Route added to the a11y / overflow page lists in `code/src/django/tests/e2e/a11y_config.py`

<!-- django-component and HTMX-partial tests (pytest, Django test client) -->

- [ ] `[ComponentName]` — renders with its accessible name and required ARIA attributes
- [ ] `[ComponentName]` — renders its empty and error states
- [ ] `[ComponentName]` — permission-gated controls are absent for insufficient permission
- [ ] `[partial]` — returned on `HX-Request` with no page chrome; full page returned otherwise

<!-- Manual checks -->

- [ ] [UI behaviour not reachable by automation — e.g. drag-and-drop reorder, colour picker render]
- [ ] Cross-browser: Chrome, Firefox, Safari (latest stable)
- [ ] Responsive: verify layout at mobile, tablet, and desktop breakpoints (mobile-first) — Web (public pages)
- [ ] Accessibility: keyboard navigation and screen reader on `[component]` — WCAG 2.2 AA

---

## Verification Checks

Run all of the following before raising a PR — via the project scripts under
`code/src/scripts/**/*.sh`, never a raw `python`, `manage.py`, `pytest`, or `docker` call.
All must pass.

- [ ] `bash code/src/scripts/database/migrate.sh check` — no unapplied model changes detected
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — all suites pass; coverage at or above the floor for this module
- [ ] Template, django-component, and HTMX-partial tests pass (same pytest run)
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass
- [ ] No secrets, debug flags, or hardcoded IDs introduced
- [ ] GDPR section reviewed and all GDPR tasks checked off (if GDPR: Yes)
- [ ] Security acceptance criteria signed off (if Security: not N/A)
- [ ] SEO acceptance criteria signed off and Lighthouse run recorded (if SEO: not N/A)

---

## Definition of Done

- [ ] All acceptance criteria met and verified by a reviewer
- [ ] All tasks checked off
- [ ] All verification checks passed
- [ ] Code reviewed and approved (minimum 1 reviewer)
- [ ] No outstanding TODO or FIXME comments introduced by this story
- [ ] Merged to `main` (or the active release branch)
- [ ] Story status updated to **Completed** in the project board
- [ ] Any GDPR or security gaps identified during review are documented in the sprint note
