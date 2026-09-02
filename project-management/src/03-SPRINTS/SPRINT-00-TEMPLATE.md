# SPRINT-00

**Last Updated**: DD/MM/YYYY **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** [One sentence describing the primary outcome this sprint delivers.]

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** [used] / [total] SP

<!-- FLAGS — the UNION of the member stories' flags, one row per gate.
     Computed from the Story Summary below, not authored independently. The one permitted
     narrowing is a story split across sprints (Part A / Part B): this sprint carries only the
     half it delivers. Any other divergence from the union is a mistake in one of the two.
     Row meanings and the per-gate routing: src/02-STORIES/US000-TEMPLATE.md. -->

| Flag       | Value                                                  |
| ---------- | ------------------------------------------------------ |
| DB         | `ModelA`, `ModelB`                                     |
| User Flow  | Yes                                                    |
| Brand      | `--color-accent`                                       |
| Components | `Button`, `Card`                                       |
| Wireframes | /dashboard                                             |
| GDPR       | Yes                                                    |
| Security   | rate-limit, audit-log                                  |
| QA         | unit, integration, E2E — happy-path, permission-denied |
| SEO        | /blog, /about                                          |
| API        | `POST /model-a`, `PATCH /model-a`                      |
| Logging    | login-success, permission-denied                       |
| Backend    | Yes                                                    |
| Frontend   | Both                                                   |

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
- [ ] All migrations apply cleanly against a clean database — `bash code/src/scripts/database/migrate.sh check` reports nothing pending
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

- [ ] All endpoints listed in the Story Summary are available on the project's single `NinjaAPI` (served under `/api/`)
- [ ] All endpoints require authentication; unauthenticated callers receive HTTP 401
- [ ] All endpoints enforce the required permission level; callers without permission receive HTTP 403
- [ ] All write endpoints write to `audit_auditlog` before the transaction commits
- [ ] Request/response `Schema` classes are defined and typed — Ninja serves JSON directly to its consumers (no codegen step)

### Frontend Acceptance Criteria

<!-- Remove this section when Frontend flag is N/A.
     Scope subsections to Public / Admin / both as indicated by the Frontend flag. -->

<!-- Pages and components -->

- [ ] All new Django pages and django-components render correctly in Chrome, Firefox, and Safari (latest stable)
- [ ] All forms validate required fields and display inline error messages without submitting
- [ ] Permission-gated controls are hidden or disabled (with tooltip) for users without sufficient permission
- [ ] Loading, empty, and error states are handled in all new pages and components

<!-- HTMX interactions -->

- [ ] Every HTMX swap targets an id the response actually returns; no partial carries page chrome
- [ ] Every non-instant HTMX request shows feedback (`hx-indicator` / `hx-disabled-elt`)
- [ ] Validation failure returns `200` with the re-rendered form; `4xx`/`5xx` surface a global error toast

### GDPR Acceptance Criteria

<!-- Remove this section when GDPR flag is N/A. -->

- [ ] All PII fields introduced this sprint are stored as `EncryptedField` (Fernet AES-256-GCM) — no PII in plaintext
- [ ] HMAC-SHA3-256 companion fields are present for all encrypted fields requiring erasure lookup
- [ ] `gdpr_erase()` coverage is extended or confirmed for all new PII models introduced this sprint
- [ ] All consent gates are enforced at the endpoint layer (not only in the UI)
- [ ] New PII fields and their lawful bases are documented in the Privacy Policy and Sub-Processor Register
- [ ] No PII is exposed in any public endpoint or server-rendered page introduced this sprint

### Security Acceptance Criteria

<!-- Remove this section when Security flag is N/A. -->

- [ ] All rate limits specified in the Story Summary security criteria are implemented and return HTTP 429 on breach
- [ ] All `audit_auditlog` entries specified in the Story Summary security criteria are implemented
- [ ] All user-supplied input rendered in admin or public views is HTML-escaped server-side
- [ ] No new endpoint bypasses the ABAC permission system
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint

### Logging Acceptance Criteria

<!-- Remove this section when the Logging flag is N/A.
     Every story in this sprint whose own Logging flag is not N/A must meet these criteria. -->

- [ ] All new service methods, Ninja endpoints, and Django views use the named logger (`logging.getLogger("apps.X")`) — no bare `print()` on any server path, and no stray `console.log()` in committed JavaScript
- [ ] All `[enc]`-marked fields from the sprint's schema designs (`04-DATABASE/DB-<FEATURE>-DD-MM-YYYY.md`) are absent from every log line produced by stories in this sprint
- [ ] Permission-denied and unexpected-error paths across all stories log at the correct level (`WARNING` / `ERROR`) with safe fields only (IDs, action names — no PII values, no tokens)
- [ ] No `console.*` in any JavaScript committed this sprint — browser logging routes through the project logger
- [ ] No raw PII (email, name, phone, address) appears in `code/src/logs/django.log` after exercising all new flows in dev

### SEO Acceptance Criteria

<!-- Remove this section when SEO flag is N/A. -->

- [ ] The `seo` skill run against all public pages introduced in this sprint; output reviewed and all issues resolved
- [ ] `<title>` set via the Django template `<head>`, through the `build_seo()` helper (`code/docs/discoverability/WEB-METADATA.md`) — max 60 chars — contains primary keyword
- [ ] `<meta name="description">` set — max 160 chars — unique to this page
- [ ] `<link rel="canonical">` present and correct
- [ ] `og:title`, `og:description`, `og:image` (min 1200 × 630 px) all set
- [ ] JSON-LD block present in `<head>` — correct schema type for the page — validated with no errors in Google Rich Results Test
- [ ] Page URL appears in `sitemap.xml` — or is explicitly excluded with `noindex` decision documented
- [ ] `robots.txt` does not block the page path — or `noindex` decision is explicitly documented
- [ ] Image `alt` text present on all images — non-empty, descriptive, not keyword-stuffed
- [ ] Exactly one `<h1>` per page — `<h2>` / `<h3>` used in logical order — no skipped levels
- [ ] LCP < 2.5 s · CLS < 0.1 · INP < 200 ms — recorded in Lighthouse audit
- [ ] Lighthouse report exported alongside the story's SEO record — `project-management/src/12-SEO/IMPLEMENTATION/LIGHTHOUSE-[US###]-[ROUTE]-[DD-MM-YYYY].json`

### QA Acceptance Criteria — Automated

<!-- Remove this section when the QA flag is N/A. -->

- [ ] Coverage is at or above 75 % line and branch for all modules introduced or modified this sprint (at or above 90 % for auth-related paths) — one floor, since template, django-component, and HTMX-partial tests are pytest tests
- [ ] Unit, integration, and E2E tests cover all stories as indicated in the Test Scope table in the QA Tasks section below
- [ ] Every story's `US###-TEST-STATUS.md` is written and its coverage transcribed, not asserted

### QA Acceptance Criteria — Manual

<!-- Remove this section when the QA flag names no manual type. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] Every story's `US###-MANUAL-TESTING.md` carries a tester sign-off block

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### DB Tasks

<!-- Remove this section when DB flag is N/A. -->

| Story | Task                                                                                    | Done |
| ----- | --------------------------------------------------------------------------------------- | ---- |
| US### | Create Django model `[ModelName]` with fields, constraints, and index                   | [ ]  |
| US### | Write and apply migration via `database/migrate.sh make` → review → `run`, then `check` | [ ]  |
| US### | Seed initial data if required                                                           | [ ]  |

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
| US### | Implement service method `[name]` in `<app>/services.py` — `transaction.atomic()` | [ ]  |
| US### | Implement `post_save` signal for `[Model]` — idempotent via `get_or_create`       | [ ]  |
| US### | Create Celery task `[task_name]` with schedule `[cron]`                           | [ ]  |
| US### | Add `audit_auditlog` entry on `[event]`                                           | [ ]  |

### API Tasks

<!-- Remove this section when API flag is N/A. -->

| Story | Task                                                               | Done |
| ----- | ------------------------------------------------------------------ | ---- |
| US### | Add Django Ninja read endpoint `[endpoint]` with permission check  | [ ]  |
| US### | Add Django Ninja write endpoint `[endpoint]` with permission check | [ ]  |
| US### | Define request/response `Schema` classes (Ninja — no codegen step) | [ ]  |

### Frontend Tasks

<!-- Remove this section when Frontend flag is N/A.
     Scope tasks to Public / Admin / both as indicated by the Frontend flag. -->

| Story | Surface | Task                                                                                     | Done |
| ----- | ------- | ---------------------------------------------------------------------------------------- | ---- |
| US### | Page    | Scaffold the Django view + template (`new-django-view.sh`) — server-rendered             | [ ]  |
| US### | Page    | Build `[ComponentName]` as a django-component with validation and permission-gated UI    | [ ]  |
| US### | HTMX    | Add the `_[name].html` partial and the view's `HX-Request` branch                        | [ ]  |
| US### | HTMX    | Wire the save: indicator, `200` re-render on validation failure, `HX-Trigger` on success | [ ]  |

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
| US### | Verify `[endpoint]` rejects calls where session user does not own target resource | [ ]  |

### Logging Tasks

<!-- Remove this section when the Logging flag is N/A.
     Reference: code/docs/LOGGING.md · the per-story plans in src/14-LOGGING/PLANNING/ -->

| Story | Layer   | Task                                                                                          | Done |
| ----- | ------- | --------------------------------------------------------------------------------------------- | ---- |
| US### | Backend | Use `logging.getLogger("apps.[app-name]")` for all log calls in service and Ninja endpoint    | [ ]  |
| US### | Backend | `DEBUG` log on service method entry — `[entity]_id`, `action` only; no PII                    | [ ]  |
| US### | Backend | `INFO` log on success — `[entity]_id`, `duration_ms`; no encrypted field values               | [ ]  |
| US### | Backend | `WARNING` log on permission denied — `actor_id`, `action`; no tokens or PII                   | [ ]  |
| US### | Browser | Keep committed JavaScript free of `console.log()`; route logging through the project logger   | [ ]  |
| US### | Pages   | Server-rendered pages log key user-facing events via the Django logger — IDs only, not values | [ ]  |
| US### | Both    | Confirm no `[enc]` field values appear in `django.log` after exercising the flow              | [ ]  |

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
| US### | Run the `seo` skill to confirm all SEO checks pass                               | [ ]  |

### QA Tasks — Automated

<!-- Remove this section when the QA flag is N/A. -->

**Test scope per story:**

| Story | Unit | Integration | E2E | Manual |
| ----- | ---- | ----------- | --- | ------ |
| US### | Yes  | Yes         | Yes | Yes    |
| US### | Yes  | Yes         | No  | No     |

### QA Tasks — Manual

<!-- Remove this section when the QA flag names no manual type. -->

- [ ] [UI behaviour not reachable by automation — e.g. drag-and-drop, colour picker, file upload]
- [ ] Cross-browser: Chrome, Firefox, Safari (latest stable)
- [ ] Responsive: verify layout at mobile, tablet, and desktop breakpoints (mobile-first) — Web (public pages)
- [ ] Accessibility: keyboard navigation and screen reader on `[component]` — WCAG 2.2 AA

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

- [ ] `bash code/src/scripts/database/migrate.sh check` — no unapplied model changes detected
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — all suites pass; coverage at or above the floor for all modules touched
- [ ] Template, django-component, and HTMX-partial tests pass (same pytest run)
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off (if GDPR: Yes)
- [ ] Every story's logging plan satisfied and its exclusion check run (if Logging: not N/A)
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
