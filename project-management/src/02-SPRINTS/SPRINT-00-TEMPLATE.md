# SPRINT-00

**Last Updated**: DD/MM/YYYY **Version**: 1.0.0 **Maintained By**: [Team / Studio Name]
**Language**: British English (en_GB)

---

**Goal:** [One sentence describing the primary outcome this sprint delivers.]

**Timeline:** TBD · **Capacity:** [used] / [total] SP

<!-- FLAGS
     DB        — shortlist of models created / modified across this sprint, or N/A
     User Flow — Yes (new user journeys introduced) or N/A
     Backend   — Yes or N/A
     API       — shortlist of mutations / queries introduced, or N/A
     Frontend  — Web / Mobile / Web + Mobile / N/A
     GDPR      — Yes (PII introduced or processed) or N/A
     Security  — shortlist of concerns across this sprint, or N/A
     SEO       — shortlist of affected pages / routes (e.g. /blog, /about), or N/A
     Testing   — shortlist of test types required (e.g. unit, integration, E2E, manual), or N/A -->

| Flag      | Value                          |
| --------- | ------------------------------ |
| DB        | `ModelA`, `ModelB`             |
| User Flow | Yes                            |
| Backend   | Yes                            |
| API       | `createModelA`, `updateModelA` |
| Frontend  | Web + Mobile                   |
| GDPR      | Yes                            |
| Security  | rate-limit, audit-log          |
| SEO       | /blog, /about                  |
| Testing   | unit, integration, E2E         |

---

## Story Summary

| ID    | Title         | MoSCoW      | SP  |
| ----- | ------------- | ----------- | --- |
| US### | [Story title] | Must Have   | N   |
| US### | [Story title] | Should Have | N   |
| US### | [Story title] | Could Have  | N   |

**Total:** [N] SP

<!-- Capacity guidance:
     - Keep total SP at or below team capacity.
     - Must Have stories fill capacity first; Should Have / Could Have are stretch targets.
     - Stories split across sprints (Part A / Part B) must note the split in the Title column. -->

## Dependencies

- US### requires US### (Sprint ##) — [reason].
- US### has no upstream dependencies.
- This sprint unblocks: US### ([brief description]), US### ([brief description]).

---

## Acceptance Criteria

[One or two sentences describing what the sprint must deliver as a whole for it to be considered successful.]

### DB Acceptance Criteria

<!-- Remove this section when DB flag is N/A. -->

- [ ] All models listed in the Story Summary are created or modified with the correct fields, constraints, and indexes
- [ ] All migrations apply cleanly against a clean database with no `makemigrations --check` errors
- [ ] `[ModelName]` — unique constraint on `[field]` is enforced at the database layer
- [ ] `[ModelName]` — check constraint `[invariant]` is enforced at the database layer
- [ ] No migration ordering conflicts exist between stories in this sprint

### User Flow Acceptance Criteria

<!-- Remove this section when User Flow flag is N/A. -->

- [ ] All wireframes for new user journeys are reviewed and approved before implementation begins
- [ ] `[Journey description]` — authenticated user can complete the flow end to end
- [ ] `[Journey description]` — unauthenticated user is redirected to login with destination saved
- [ ] `[Journey description]` — user without permission sees an access-denied screen
- [ ] All error states display a clear, user-facing message and leave system state consistent

### Backend Acceptance Criteria

<!-- Remove this section when Backend flag is N/A. -->

- [ ] All service methods introduced this sprint are wrapped in `transaction.atomic()` where they touch two or more tables
- [ ] All user-supplied IDs are verified against the caller's session before any query executes (IDOR prevention)
- [ ] All `post_save` signals introduced this sprint are idempotent (safe to run twice without side effects)
- [ ] All Celery tasks introduced this sprint execute on schedule and log success or failure with error details
- [ ] All audit log entries are written within the same `transaction.atomic()` block as the write they record

### API Acceptance Criteria

<!-- Remove this section when API flag is N/A. -->

- [ ] All mutations and queries listed in the Story Summary are available at the GraphQL endpoint
- [ ] All mutations require authentication; unauthenticated callers receive HTTP 401
- [ ] All mutations enforce the required permission level; callers without permission receive HTTP 403
- [ ] All mutations write to `audit_auditlog` before the transaction commits
- [ ] `graphql-codegen` has been re-run; generated TypeScript types are committed and up to date

### Frontend Acceptance Criteria

<!-- Remove this section when Frontend flag is N/A.
     Scope subsections to Web / Mobile / both as indicated by the Frontend flag. -->

<!-- Web -->

- [ ] All new Next.js pages and components render correctly in Chrome, Firefox, and Safari (latest stable)
- [ ] All forms validate required fields and display inline error messages without submitting
- [ ] Permission-gated controls are hidden or disabled (with tooltip) for users without sufficient permission
- [ ] Loading, empty, and error states are handled in all new pages and components

<!-- Mobile -->

- [ ] All new Expo screens render correctly on iOS and Android (physical device or simulator)
- [ ] All mobile forms validate required fields and display appropriate error feedback
- [ ] Loading and error states are handled with appropriate mobile UI patterns

### GDPR Acceptance Criteria

<!-- Remove this section when GDPR flag is N/A. -->

- [ ] All PII fields introduced this sprint are stored as `EncryptedField` (Fernet AES-256-GCM) — no PII in plaintext
- [ ] HMAC-SHA3-256 companion fields are present for all encrypted fields requiring erasure lookup
- [ ] `gdpr_erase()` coverage is extended or confirmed for all new PII models introduced this sprint
- [ ] All consent gates are enforced at the mutation layer (not only in the UI)
- [ ] New PII fields and their lawful bases are documented in the Privacy Policy and Sub-Processor Register
- [ ] No PII is exposed in any public GraphQL query or public endpoint introduced this sprint

### Security Acceptance Criteria

<!-- Remove this section when Security flag is N/A. -->

- [ ] All rate limits specified in the Story Summary security criteria are implemented and return HTTP 429 on breach
- [ ] All `audit_auditlog` entries specified in the Story Summary security criteria are implemented
- [ ] All user-supplied input rendered in admin or public views is HTML-escaped server-side
- [ ] No new endpoint bypasses the ABAC permission system
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint

### SEO Acceptance Criteria

<!-- Remove this section when SEO flag is N/A. -->

- [ ] All new public-facing pages have a `<title>` and `<meta name="description">` set via the
      Next.js metadata API
- [ ] `og:title`, `og:description`, and `og:image` are set for all new public pages
- [ ] Canonical URLs are set correctly across all new public pages — no duplicate content risk
- [ ] JSON-LD structured data is included where applicable (e.g. `Article`, `BreadcrumbList`,
      `Organization`)
- [ ] All new page slugs / URLs are human-readable, lowercase, hyphenated, and contain the target
      keyword
- [ ] All new public pages are included in `sitemap.xml` (Celery regeneration task triggered or
      static entry added)
- [ ] `robots.txt` does not block any new public page introduced this sprint
- [ ] All new public pages meet Core Web Vitals targets: LCP < 2.5 s, CLS < 0.1, INP < 200 ms
- [ ] All images on new pages have descriptive `alt` text; no image served without `alt`
- [ ] Heading hierarchy is correct on all new pages: one `<h1>` per page; `<h2>` / `<h3>` in
      logical order

### Testing Acceptance Criteria

<!-- Remove this section when Testing flag is N/A. -->

- [ ] Backend coverage is at or above 75 % for all modules introduced or modified this sprint (at or above 90 % for auth-related paths)
- [ ] Frontend coverage is at or above 70 % for all components introduced or modified this sprint
- [ ] Unit, integration, and E2E tests cover all stories as indicated in the Test Scope table in the Testing Tasks section below
- [ ] All manual checks listed in the Testing Tasks section below are complete and signed off

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### DB Tasks

<!-- Remove this section when DB flag is N/A. -->

| Story | Task                                                                   | Done |
| ----- | ---------------------------------------------------------------------- | ---- |
| US### | Create Django model `[ModelName]` with fields, constraints, and index  | [ ]  |
| US### | Write and apply migration — run `makemigrations --check` then `pytest` | [ ]  |
| US### | Seed initial data if required                                          | [ ]  |

### User Flow Tasks

<!-- Remove this section when User Flow flag is N/A. -->

| Story | Task                                                                    | Done |
| ----- | ----------------------------------------------------------------------- | ---- |
| US### | Create wireframe for `[UI area]` covering primary path and error states | [ ]  |
| US### | Wireframe reviewed and approved before implementation begins            | [ ]  |

### Backend Tasks

<!-- Remove this section when Backend flag is N/A. -->

| Story | Task                                                                              | Done |
| ----- | --------------------------------------------------------------------------------- | ---- |
| US### | Implement service method `[name]` in `[app]/services.py` — `transaction.atomic()` | [ ]  |
| US### | Implement `post_save` signal for `[Model]` — idempotent via `get_or_create`       | [ ]  |
| US### | Create Celery task `[task_name]` with schedule `[cron]`                           | [ ]  |
| US### | Add `audit_auditlog` entry on `[event]`                                           | [ ]  |

### API Tasks

<!-- Remove this section when API flag is N/A. -->

| Story | Task                                                           | Done |
| ----- | -------------------------------------------------------------- | ---- |
| US### | Add Strawberry query `[queryName]` with permission check       | [ ]  |
| US### | Add Strawberry mutation `[mutationName]` with permission check | [ ]  |
| US### | Run `graphql-codegen`; commit generated TypeScript types       | [ ]  |

### Frontend Tasks

<!-- Remove this section when Frontend flag is N/A.
     Scope tasks to Web / Mobile / both as indicated by the Frontend flag. -->

| Story | Platform | Task                                                            | Done |
| ----- | -------- | --------------------------------------------------------------- | ---- |
| US### | Web      | Create Next.js page `[path]` with Apollo data fetching          | [ ]  |
| US### | Web      | Build `[ComponentName]` with validation and permission-gated UI | [ ]  |
| US### | Mobile   | Create Expo screen `[path]`                                     | [ ]  |
| US### | Mobile   | Build `[ComponentName]` with validation and error states        | [ ]  |

### GDPR Tasks

<!-- Remove this section when GDPR flag is N/A. -->

| Story | Task                                                                 | Done |
| ----- | -------------------------------------------------------------------- | ---- |
| US### | Add `EncryptedField` to `[field_name]`                               | [ ]  |
| US### | Add HMAC-SHA3-256 companion `[hmac_token]`                           | [ ]  |
| US### | Implement / extend `[app].gdpr_erase()` to cover new PII models      | [ ]  |
| US### | Wire `[app].gdpr_erase()` into US041 erasure orchestrator            | [ ]  |
| US### | Create Celery Beat retention task `[task_name]`                      | [ ]  |
| US### | Document new PII fields in Privacy Policy and Sub-Processor Register | [ ]  |

### Security Tasks

<!-- Remove this section when Security flag is N/A. -->

| Story | Task                                                                              | Done |
| ----- | --------------------------------------------------------------------------------- | ---- |
| US### | Implement rate limit on `[endpoint]` — max N / IP / M min; HTTP 429 on breach     | [ ]  |
| US### | HTML-escape `[field]` server-side before rendering in any view                    | [ ]  |
| US### | Add `audit_auditlog` entry on `[event]` within the same `transaction.atomic()`    | [ ]  |
| US### | Verify `[mutation]` rejects calls where session user does not own target resource | [ ]  |

### SEO Tasks

<!-- Remove this section when SEO flag is N/A. -->

| Story | Task                                                                             | Done |
| ----- | -------------------------------------------------------------------------------- | ---- |
| US### | Set `<title>` and `<meta name="description">` for `[page / route]`               | [ ]  |
| US### | Set `og:title`, `og:description`, `og:image` for `[page / route]`                | [ ]  |
| US### | Set canonical URL for `[page / route]`                                           | [ ]  |
| US### | Add JSON-LD structured data (`[schema type]`) to `[page / route]`                | [ ]  |
| US### | Add `[page / route]` to `sitemap.xml`; trigger Celery regeneration if applicable | [ ]  |
| US### | Run Lighthouse to verify Core Web Vitals targets; record results                 | [ ]  |
| US### | Run `/syntek-dev-suite:seo` to confirm all SEO checks pass                       | [ ]  |

### Testing Tasks

<!-- Remove this section when Testing flag is N/A. -->

**Test scope per story:**

| Story | Unit | Integration | E2E | Manual |
| ----- | ---- | ----------- | --- | ------ |
| US### | Yes  | Yes         | Yes | Yes    |
| US### | Yes  | Yes         | No  | No     |

**Manual checks this sprint:**

- [ ] [UI behaviour not reachable by automation — e.g. drag-and-drop, colour picker, file upload]
- [ ] Cross-browser: Chrome, Firefox, Safari (latest stable) — Web
- [ ] Device: iOS and Android (physical device or simulator) — Mobile
- [ ] Accessibility: keyboard navigation and screen reader on `[component]` — WCAG 2.2 AA

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

- [ ] `makemigrations --check` — no unapplied model changes detected
- [ ] `pytest` — all backend tests pass; coverage at or above floor for all modules touched
- [ ] `vitest` — all frontend tests pass; coverage at or above 70 % for all components touched
- [ ] Lint and type-check pass in both layers
- [ ] `graphql-codegen` re-run after any schema change; generated files committed
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off (if GDPR: Yes)
- [ ] All security acceptance criteria signed off (if Security: not N/A)
- [ ] SEO acceptance criteria signed off and Lighthouse results recorded (if SEO: not N/A)

---

## Definition of Done

- [ ] All stories in the Story Summary are individually marked **Done** (their own DoD complete)
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All code merged to `main` (or the active release branch)
- [ ] Sprint closed in the project board
- [ ] GDPR gaps identified during the sprint are documented in this file under the GDPR section
- [ ] Retrospective notes captured (optional — link or inline)
