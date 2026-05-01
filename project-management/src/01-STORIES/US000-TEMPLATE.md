# US000 — [Story Title]

**Epic:** [Epic Name — e.g. Authentication & Access Control / Core Features / Public Pages]
**Status:** Ready

<!-- FLAGS
     DB        — shortlist of models created / modified, or N/A
     User Flow — Yes or N/A
     Backend   — Yes or N/A
     API       — shortlist of mutations / queries introduced, or N/A
     Frontend  — Web / Mobile / Web + Mobile / N/A
     GDPR      — Yes (complete GDPR section below) or N/A
     Security  — shortlist of concerns (e.g. rate-limit, audit-log, XSS-escape, IDOR), or N/A
     Testing   — shortlist of test types required (e.g. unit, integration, E2E, manual), or N/A -->

| Flag      | Value                                          |
| --------- | ---------------------------------------------- |
| DB        | `ModelA`, `ModelB`                             |
| User Flow | Yes                                            |
| Backend   | Yes                                            |
| API       | `createModelA`, `updateModelA`, `deleteModelA` |
| Frontend  | Web + Mobile                                   |
| GDPR      | Yes                                            |
| Security  | rate-limit, audit-log, XSS-escape              |
| Testing   | unit, integration, E2E                         |

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
Then [makemigrations --check] reports no unapplied changes
And [pytest] passes after the migration is applied
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

- [ ] `[mutationName]` — authenticated caller with required permission receives the expected payload
- [ ] `[mutationName]` — unauthenticated caller receives HTTP 401
- [ ] `[mutationName]` — caller without required permission receives HTTP 403
- [ ] `[mutationName]` — invalid input returns a validation error with a descriptive message
- [ ] `[queryName]` — returns only records the caller is authorised to view
- [ ] All mutations write to `audit_auditlog` before the transaction commits

### Frontend Acceptance Criteria

<!-- Remove this section when Frontend flag is N/A.
     Scope subsections to Web / Mobile / both as indicated by the Frontend flag. -->

```gherkin
Scenario: [Web — component renders in the correct state]
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

Scenario: [Mobile — screen renders correctly]
Given [precondition]
When the user navigates to [screen]
Then they see [expected UI state]

Scenario: [Mobile — action triggers correct mutation]
Given [precondition]
When the user taps [control]
Then [expected mutation fires and UI updates]
```

### GDPR Acceptance Criteria

<!-- Remove this section when GDPR flag is N/A. -->

- [ ] `[field_name]` is stored as `EncryptedField` (Fernet AES-256-GCM) — never persisted in plaintext
- [ ] HMAC-SHA3-256 companion field `[hmac_token]` is written on every create and update for erasure lookup
- [ ] `[app].gdpr_erase([identifier])` nulls `[field list]`, retains the row for audit purposes
- [ ] `[app].gdpr_erase()` is wired into the US041 erasure orchestrator
- [ ] Celery Beat task `[task_name]` purges / anonymises rows older than [retention period]
- [ ] Consent gate: `[mutationName]` rejects any call where `consent_given = False` with a clear error
- [ ] No PII field is exposed in the public GraphQL schema or any public endpoint
- [ ] PII fields are documented in the Privacy Policy (US039) and Sub-Processor Register

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

### Testing Acceptance Criteria

<!-- Remove this section when Testing flag is N/A. -->

- [ ] Backend coverage is at or above 75 % for all modules (at or above 90 % for auth-related paths) after this story
- [ ] Frontend coverage is at or above 70 % after this story
- [ ] Unit tests cover the success path, validation error, and permission error for `[service_function]`
- [ ] Unit tests cover constraint enforcement and signal idempotence for `[ModelName]`
- [ ] Integration tests cover the success path, 401, and 403 for all mutations introduced by this story
- [ ] E2E tests cover the primary user flow, the permission-denied path, and at least one form validation error
- [ ] Manual checks cover any UI behaviour not reachable by automation (e.g. [drag-and-drop, colour picker])

---

## Tasks

All tasks below map directly to an acceptance criterion above. Mark each complete before raising a PR.

### DB Tasks

<!-- Remove this section when DB flag is N/A. -->

- [ ] Create Django model `[ModelName]` in `code/src/backend/apps/[app]/models.py`
- [ ] Add fields: [field list with types and constraints]
- [ ] Add unique constraint on `([field_a, field_b])`
- [ ] Add index on `[field_c]` for `[query pattern]`
- [ ] Add check constraint: `[invariant description]`
- [ ] Write and apply migration — run `makemigrations --check` then `pytest` after applying
- [ ] Seed initial data if required (via data migration or fixture)

### User Flow Tasks

<!-- Remove this section when User Flow flag is N/A. -->

- [ ] Create wireframe for `[UI area]` covering the primary path, error states, and permission-denied state
- [ ] Review wireframe with stakeholders before implementation begins
- [ ] Link wireframe reference in the Frontend Tasks section below

### Backend Tasks

<!-- Remove this section when Backend flag is N/A. -->

- [ ] Implement service method `[name]` in `code/src/backend/apps/[app]/services.py` wrapped in `transaction.atomic()`
- [ ] Verify caller ownership of user-supplied `[id field]` before querying (IDOR prevention)
- [ ] Implement `post_save` signal for `[Model]` using `get_or_create` (idempotent)
- [ ] Create Celery task `[task_name]` with schedule `[cron expression]`
- [ ] Add `audit_auditlog` entry on `[event]` — fields: `actor_id`, `target_id`, `action`, `ip`, `timestamp`

### API Tasks

<!-- Remove this section when API flag is N/A. -->

- [ ] Add Strawberry query `[queryName]` with permission check in `code/src/backend/apps/[app]/schema.py`
- [ ] Add Strawberry mutation `[mutationName]` with permission check and service layer call
- [ ] Apply permission decorator: `@permission_required("[module]", level="[view|edit|full]")`
- [ ] Run `graphql-codegen` to regenerate frontend TypeScript types after schema changes

### Frontend Tasks

<!-- Remove this section when Frontend flag is N/A.
     Scope tasks to Web / Mobile / both as indicated by the Frontend flag. -->

<!-- Web -->

- [ ] Create Next.js page `code/src/frontend/src/app/[path]/page.tsx`
- [ ] Build `[ComponentName]` in `code/src/frontend/src/components/[Name]/[Name].tsx`
- [ ] Wire Apollo hook `use[MutationName]Mutation` / `use[QueryName]Query`
- [ ] Implement form validation (required fields, character limits, live counters)
- [ ] Implement permission-based control visibility (hidden / disabled with tooltip)
- [ ] Handle loading, empty, and error states

<!-- Mobile -->

- [ ] Create Expo screen `code/src/mobile/app/[path].tsx`
- [ ] Build `[ComponentName]` in `code/src/mobile/src/components/[Name]/[Name].tsx`
- [ ] Wire Apollo hook `use[MutationName]Mutation` / `use[QueryName]Query`
- [ ] Handle loading and error states with appropriate mobile UI patterns

<!-- Both -->

- [ ] Write user guide / help article for `[workflow]`

### GDPR Tasks

<!-- Remove this section when GDPR flag is N/A. -->

- [ ] Add `EncryptedField` (Fernet AES-256-GCM) to `[field_name]` in `[app]/models.py`
- [ ] Add HMAC-SHA3-256 companion field `[hmac_token]` for erasure lookup without decryption
- [ ] Implement `[app].gdpr_erase([identifier])` — nulls `[field list]`, retains row
- [ ] Wire `[app].gdpr_erase()` into the US041 erasure orchestrator
- [ ] Create Celery Beat task `[task_name]` for retention purge after `[period]`
- [ ] Enforce consent gate in `[mutationName]`: reject if `consent_given = False`
- [ ] Document PII fields in Privacy Policy (US039) and Sub-Processor Register

### Security Tasks

<!-- Remove this section when Security flag is N/A. -->

- [ ] Implement rate limit on `[endpoint]` — max N attempts per IP per M minutes
- [ ] Return HTTP 429 with `Retry-After` header on rate limit breach; enforce exponential backoff after lockout
- [ ] HTML-escape `[field]` server-side before rendering in any admin or public view
- [ ] Add `audit_auditlog` entry on `[success event]` within the same `transaction.atomic()` block as the write
- [ ] Add `audit_auditlog` entry on `[failure event]` including IP and reason
- [ ] Verify `[mutation]` rejects calls where the session user does not own the target resource

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

- [ ] `[mutationName]` — success path returns expected payload
- [ ] `[mutationName]` — unauthenticated caller receives 401
- [ ] `[mutationName]` — caller without permission receives 403
- [ ] `[mutationName]` — invalid input returns validation error with descriptive message

<!-- E2E tests -->

- [ ] Primary user flow — happy path completes and displays success state
- [ ] Permission-denied path — user without access sees access-denied screen or is redirected
- [ ] Form validation — required field error is displayed without submission

<!-- Frontend unit tests (Vitest + React Testing Library / Jest + RNTL) -->

- [ ] `[ComponentName]` — renders in loading state
- [ ] `[ComponentName]` — renders in empty state
- [ ] `[ComponentName]` — renders in error state
- [ ] `[ComponentName]` — permission-gated controls are hidden / disabled for insufficient permission

<!-- Manual checks -->

- [ ] [UI behaviour not reachable by automation — e.g. drag-and-drop reorder, colour picker render]
- [ ] Cross-browser: Chrome, Firefox, Safari (latest stable) — Web only
- [ ] Device: iOS and Android on a physical device or simulator — Mobile only
- [ ] Accessibility: keyboard navigation and screen reader on `[component]` — WCAG 2.2 AA

---

## Verification Checks

Run all of the following before raising a PR. All must pass.

- [ ] `makemigrations --check` — no unapplied model changes detected
- [ ] `pytest` — all backend tests pass; coverage at or above floor for this module
- [ ] `vitest` — all frontend tests pass; coverage at or above 70 %
- [ ] Lint and type-check pass in both layers
- [ ] `graphql-codegen` re-run after any schema change; generated files committed
- [ ] No secrets, debug flags, or hardcoded IDs introduced
- [ ] GDPR section reviewed and all GDPR tasks checked off (if GDPR: Yes)
- [ ] Security acceptance criteria signed off (if Security: not N/A)

---

## Definition of Done

- [ ] All acceptance criteria met and verified by a reviewer
- [ ] All tasks checked off
- [ ] All verification checks passed
- [ ] Code reviewed and approved (minimum 1 reviewer)
- [ ] No outstanding TODO or FIXME comments introduced by this story
- [ ] Merged to `main` (or the active release branch)
- [ ] Story status updated to **Done** in the project board
- [ ] Any GDPR or security gaps identified during review are documented in the sprint note
