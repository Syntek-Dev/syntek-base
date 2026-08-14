# STORY-PLAN-US000 — &lt;Story Title&gt; (Template)

| Field  | Value                                                                                                                                                                 |
| ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Date   | DD/MM/YYYY                                                                                                                                                            |
| Branch | `us000/short-kebab-description`                                                                                                                                       |
| Sprint | SPRINT-## · Wave # · —                                                                                                                                                |
| Author | <%ORG_NAME%>                                                                                                                                                          |
| Status | `Open` (default) · `Pending` · `In Progress` · `In Review` · `Accepted` · `Accepted Customer` · `Rejected` · `Rejected Customer` · `Blocked` · `Completed` · `Closed` |

<!--
═══════════════════════════════════════════════════════════════════════════════
  HOW TO USE THIS TEMPLATE  (delete this comment block in the real plan)
═══════════════════════════════════════════════════════════════════════════════
  • Copy to STORY-PLAN-US###-<SCREAMING-KEBAB-DESCRIPTOR>.md, replace every <...> and
    [PLACEHOLDER], and add the row to 16-STORY-PLANS/CONTEXT.md "Plans Index".
  • This is a SUPERSET. Keep the ★-marked core sections always. Keep the
    ◇-marked sections only when the story touches that concern; delete the
    rest so the plan stays honest. Never delete a section to dodge a gate —
    delete it only when it genuinely does not apply, and say why in one line.
  • British English (en_GB) throughout: behaviour, serialise, anonymise,
    optimisation, licence, sub-processor. Dates DD/MM/YYYY in prose; filenames
    use DD-MM-YYYY.
  • Status: pick ONE value from the canonical ClickUp board vocabulary in the
    header table — `Open` · `Pending` · `In Progress` · `In Review` · `Accepted`
    · `Accepted Customer` · `Rejected` · `Rejected Customer` · `Blocked`
    · `Completed` · `Closed`. New plans start `Open`. This is the same set used
    for the story's `**Status:**` and pushed to ClickUp by the `clickup-sync`
    workflow — defined in `project-management/docs/PLANNING-GUIDE.md`
    (it replaced the old To Do→Open / Ready→Pending / Done→Completed vocabulary).
  • Plan files are NOT subject to the 300-line instructional limit or the
    750/800-line source limit — write the full plan a human and Claude both read.
  • Backtick every path, filename, command, identifier, and token name.
  • Every command in this plan MUST be a project script from
    code/src/scripts/**/*.sh. Raw python / pytest / manage.py / pnpm / docker / uv
    are forbidden EXCEPT the two narrow exceptions documented in
    Section "Quality Gates, Scripts & Local↔Docker Alignment".
  • Legend used in tables below:
      ★ always include   ◇ include if the concern applies   ⬡ retrospective only
      ✓ applies   ✓ always   — not applicable
═══════════════════════════════════════════════════════════════════════════════
-->

<!-- ◇ Header addenda — keep any that apply, directly under the table, before the rule. -->
<!-- Implements **ADR-###** (&lt;decision title&gt;). -->
<!-- > Authored retrospectively (DD/MM/YYYY) to fill a plan gap for an already-shipped story. -->
<!-- > Source authority: where this plan conflicts with `project-management/src/02-STORIES/US###.md`
       or `…/15-SPRINT-PLANS/##-SPRINT-PLAN-##.md`, the Section "…" of that doc wins. GDPR authority:
       `…/09-GDPR/…`. This plan records the engineering route, not the requirement. -->

---

## Table of Contents

<!-- ◇ Keep for large plans (page builds, GDPR, multi-phase). Drop for small single-layer plans. -->

1. [Problem Statement](#problem-statement)
2. [Reference Documents (code/docs gate map)](#reference-documents-codedocs-gate-map)
3. [Architecture Decision](#architecture-decision)
4. [Approach](#approach)
5. [Key Decisions](#key-decisions)
6. [Dependencies](#dependencies)
7. [GDPR](#gdpr)
8. [Security](#security)
9. [Logging & Observability](#logging--observability)
10. [Performance, Rendering, Responsive & Accessibility](#performance-rendering-responsive--accessibility)
11. [Implementation Workflows & Standards](#implementation-workflows--standards)
12. [Execution & Verification via Claude Dynamic Workflows](#execution--verification-via-claude-dynamic-workflows)
13. [Quality Gates, Scripts & Local↔Docker Alignment](#quality-gates-scripts--localdocker-alignment)
14. [Testing](#testing)
15. [Documentation Write-Ups (Implementation Records)](#documentation-write-ups-implementation-records)
16. [CONTEXT.md & Index Updates](#contextmd--index-updates)
17. [Status Propagation & ClickUp Sync](#status-propagation--clickup-sync)
18. [Deferred Items](#deferred-items)
19. [Risks](#risks)
20. [Docker & Nginx Infrastructure](#docker--nginx-infrastructure)
21. [As-Built Summary](#as-built-summary)
22. [Sprint Verification Checklist](#sprint-verification-checklist)
23. [Definition of Done](#definition-of-done)

---

## Problem Statement

<!-- ★ Always. -->

**Why this story exists.** [What user/business need or defect drives it. Link the story:
`project-management/src/02-STORIES/US###.md`.]

**Current state / gap.** [What exists today and precisely what is missing or broken.]

**What this story delivers.** [The concrete outcome — one paragraph or a short bullet list. State
what is explicitly OUT of scope and which future US### owns it; mirror into Section "Deferred Items".]

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                    |
| ----------------------------- | --------- | -------------------------------------------------------- |
| Database / models / migration | ✓ / —     | [new models, fields, indexes, RLS]                       |
| Service layer                 | ✓ / —     | [business logic, transactions]                           |
| Django Ninja API              | ✓ / —     | [endpoints, request/response schemas, permission checks] |
| Frontend (templates)          | ✓ / —     | [templates, django-components, HTMX partials]            |
| Infrastructure / DevOps       | ✓ / —     | [Docker, Nginx, CI, Nix, email, storage]                 |
| GDPR / PII                    | ✓ / —     | [personal data touched? → Section GDPR mandatory]        |

---

## Reference Documents (code/docs gate map)

<!-- ★ Always. List ONLY the docs this story is actually gated by, but check every row first.
     Each entry-point doc fans out to a `<topic>/` sub-directory of focused sub-docs — cite the
     specific sub-doc when the work is narrow (e.g. `code/docs/security/AUTH-AND-AUTHZ.md`). -->

| Concern (when it gates)                                                                                           | Authoritative doc(s)                                                                                                                                                                              | Applies? |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| **URL / route / slug / admin path** (any new path)                                                                | `code/docs/URL-STRATEGY.md` — Marketing `/`, Admin `/admin/` (UUIDs), Portal `/portal/` (slugs); Django admin lives at a non-obvious path, **never** `/admin/`                                    | ✓ / —    |
| **Coding principles** (any code)                                                                                  | `code/docs/CODING-PRINCIPLES.md` + `BACKEND-CODING-PRINCIPLES.md` / `FRONTEND-CODING-PRINCIPLES.md`; `coding-principles/{DESIGN-PRINCIPLES,PRACTICAL-RULES,STYLE-AND-PROCESS}.md`                 | ✓ / —    |
| **Architecture** (structural decisions)                                                                           | `code/docs/ARCHITECTURE-PATTERNS.md`; `architecture/{CORE-AND-SCALING,SERVICE-AND-MIDDLEWARE,FRONTEND-PATTERNS}.md`; `architecture/AUTH-CONTRACT.md` for AdminMember/ModulePermission writes      | ✓ / —    |
| **Data structures / schema** (new model/field/index)                                                              | `code/docs/DATA-STRUCTURES.md`; `data-structures/{DOMAIN-MODELLING,SCHEMA-DESIGN,FUNDAMENTALS,ANTI-PATTERNS,REFACTORING}.md`                                                                      | ✓ / —    |
| **API design** (any schema/endpoint)                                                                              | `code/docs/API-DESIGN.md`; `api-design/{NINJA-CONVENTIONS,REST-CONVENTIONS,AUTH-AND-ERRORS,AUTH-STRATEGY,CLIENT-PATTERNS,WEBHOOKS,EVENT-TRACKING,API-DOCS}.md`                                    | ✓ / —    |
| **Security** (every feature — A01 permission checks, IDOR)                                                        | `code/docs/SECURITY.md`; `security/{AUTH-AND-AUTHZ,INPUT-AND-API,CRYPTO-AND-DATA,SECRETS-AND-TRANSPORT,MONITORING-AND-INCIDENT,OWASP-AND-CHECKLIST,SUPPLY-CHAIN}.md`                              | ✓        |
| **Encryption** (any PII / encrypted field)                                                                        | `code/docs/ENCRYPTION-GUIDE.md`; `encryption/{FIELD-ENCRYPTION,LOOKUP-TOKENS}.md`                                                                                                                 | ✓ / —    |
| **RLS** (multi-tenant / row-scoped data)                                                                          | `code/docs/RLS-GUIDE.md`; `rls/{FUNDAMENTALS,MIDDLEWARE-AND-NINJA,POLICY-TEMPLATES,TESTING-AND-AUDIT}.md`                                                                                         | ✓ / —    |
| **Rendering** (interaction boundary)                                                                              | `code/docs/RENDERING.md`; `rendering/{TEMPLATES-AND-INTERACTIVITY,PITFALLS-AND-EXAMPLES}.md`                                                                                                      | ✓ / —    |
| **Responsive** (layout / breakpoints / CSS)                                                                       | `code/docs/RESPONSIVE-DESIGN.md`; `responsive/{BREAKPOINTS,MEDIA-QUERIES,CONTAINER-QUERIES,USER-PREFERENCES}.md`                                                                                  | ✓ / —    |
| **Accessibility** (any interactive UI — WCAG 2.2 AA)                                                              | `code/docs/ACCESSIBILITY.md`; `accessibility/{HTML-AND-ARIA,INTERACTION,TESTING-AND-COMPONENTS}.md`                                                                                               | ✓ / —    |
| **Design tokens** (any visual value)                                                                              | `code/docs/DESIGN-TOKENS.md` — all colour/spacing/radius/type/shadow/motion from the DB-canonical token layer (`code/src/django/apps/design_tokens/`, consumed as `var(--token)`), never literals | ✓ / —    |
| **Performance** (queries, caching, bundles)                                                                       | `code/docs/PERFORMANCE.md`; `performance/{DATABASE-PERFORMANCE,FRONTEND-PERFORMANCE,API-AND-MONITORING}.md`                                                                                       | ✓ / —    |
| **Scale / readiness / server contract** (new route/upload/SSE surface, user-owned table, or a shifted load curve) | `code/docs/architecture/CORE-AND-SCALING.md`; `how-to/src/SCALE-ARCHITECTURE/`, `how-to/src/SERVER-ARCHITECTURE/` (anti-forecast — consulted, never a per-story provisioning gate)                | ✓ / —    |
| **Logging / observability** (any logging)                                                                         | `code/docs/LOGGING.md`; `logging/{DJANGO-LOGGING,FRONTEND-LOGGING,OBSERVABILITY,CLOUDINARY}.md`                                                                                                   | ✓ / —    |
| **Testing** (any code change)                                                                                     | `code/docs/TESTING.md`; `testing/{TAXONOMY,BACKEND-TESTING,FRONTEND-TESTING,API-TESTING,ADVANCED-TESTING,COVERAGE}.md`                                                                            | ✓        |
| **Cloudinary** (media upload/delivery)                                                                            | `code/docs/cloudinary/CONTEXT.md` → `{PYTHON_SDK,CROSS_SDK_INFO}.md` (server-side Python SDK — there is no JavaScript SDK in this stack)                                                          | ✓ / —    |

> Cross-layer compliance guides also gate this plan: `project-management/docs/SECURITY-GUIDE.md`
> (STRIDE), `project-management/docs/GDPR-GUIDE.md`, `project-management/docs/SEO-CHECKLIST.md`,
> `project-management/docs/QA-GUIDE.md`, `project-management/docs/VERSIONING-GUIDE.md`,
> `project-management/docs/GIT-GUIDE.md`.

---

## Architecture Decision

<!-- ◇ Keep when the story makes or depends on a non-trivial architectural choice.
     If it materially changes a cross-cutting pattern, raise an ADR in
     `project-management/src/14-DECISIONS/ADR-###-*.md` and link it in the header. -->

[Narrative of the core technical decision and the constraint it must respect (e.g. the immutable
core decisions in `code/docs/architecture/CORE-AND-SCALING.md`, the auth contract in
`architecture/AUTH-CONTRACT.md`, or the `/admin/` ownership rule in `URL-STRATEGY.md`). State what
is fixed by prior decisions vs what this story is free to choose.]

---

## Approach

<!-- ★ Always. Subdivide with ### per layer (engineering archetype) OR per phase (multi-step
     archetype). Keep only the layers in scope (see Problem Statement scope table). -->

### Database — `code/src/django/apps/<app>/models.py`

<!-- ◇ Keep if DB in scope. -->

- [Models / fields / indexes / constraints. Naming + indexing per `data-structures/SCHEMA-DESIGN.md`.]
- [PII columns? → `EncryptedField` per `encryption/FIELD-ENCRYPTION.md`; unique encrypted lookups →
  HMAC lookup tokens per `encryption/LOOKUP-TOKENS.md`.]
- [Row-scoped? → RLS policy per `rls/POLICY-TEMPLATES.md`, updated in the same migration.]
- Migration via `bash code/src/scripts/database/migrate.sh make` → review the generated file →
  `bash code/src/scripts/database/migrate.sh run`. Follows **code workflow `03-database-migration`**.
- Register/update the model in Django admin (mounted at the non-obvious control path, **not**
  `/admin/`).

### Service Layer — `code/src/django/apps/<app>/services/`

<!-- ◇ Keep if business logic in scope. -->

- [Service functions/classes. Business logic lives here, never in endpoints — see
  `architecture/SERVICE-AND-MIDDLEWARE.md`.]
- Wrap any operation with **≥2 writes** in `transaction.atomic()`.
- [New error types — `code/src/django/apps/<app>/errors.py`:]

  | Class         | `code`           | Raised when |
  | ------------- | ---------------- | ----------- |
  | `<ErrorName>` | `<machine_code>` | [condition] |

### Django Ninja API — `code/src/django/apps/<app>/api.py` (router + `Schema`s)

<!-- ◇ Keep if API in scope. Follows code workflow 04-api-design + PM workflow 13-api-design. -->

- [Read/write endpoints (router operations) and request/response `Schema` classes, mounted on the
  single `NinjaAPI` (`config/api.py`, mounted at `/api/`). Conventions: `api-design/NINJA-CONVENTIONS.md`.]
- **Every mutating endpoint (write operation) has an explicit permission check** (OWASP A01) via a
  named permission class — see `architecture/AUTH-CONTRACT.md` and `security/AUTH-AND-AUTHZ.md`. No implicit allow.
- **User-supplied IDs validated against the caller's ownership** — no IDOR.
- M2M reads through soft-delete use the `Prefetch` rule; honour the type-completeness and
  constraint-guard rules from workflow `04-api-design`.
- Request/response bodies are Python-typed with django-ninja `Schema` classes on the router — there
  is **no codegen step**; external consumers read this JSON directly.

### Frontend — `code/src/django/templates/` and `code/src/django/components/`

<!-- ◇ Keep if frontend in scope. -->

- [Public page(s) — scaffold with `bash code/src/scripts/development/new-django-view.sh <route_path>`
  (a Django view + template + `urls.py` entry in `apps.marketing`; never hand-create route dirs).
  Path follows `URL-STRATEGY.md`.]
- [Server-rendered template vs HTMX vs Alpine split per `rendering/TEMPLATES-AND-INTERACTIVITY.md`.]
- Reuse the django-components library (`code/src/django/components/`) **before** building new
  components; the admin area is built from the same templates and components as every other
  surface. All visual values from the DB-canonical token layer
  (`code/src/django/apps/design_tokens/`, consumed as `var(--token)`) — never literals.
- WCAG 2.2 AA per `accessibility/*`; mobile-first per `responsive/*`.
- [Per-page `<head>` — title, description, Open Graph, JSON-LD, canonical — rendered server-side via
  the `build_seo` helper, per `project-management/docs/SEO-CHECKLIST.md` for any public marketing page.]

### Phase plan (multi-step stories)

<!-- ◇ Use instead of / alongside the per-layer headings when work is sequenced. -->

- **Phase A — [backend foundation]:** [scope, exit criteria]
- **Phase B — [templates / HTMX interactions]:** [scope, exit criteria]
- **Phase C — [integration]:** [scope, exit criteria]

### Pre-existing bug fixes

<!-- ◇ Keep only if fixing pre-existing bugs en route. Mark resolved with ✅. Prefer a separate
     bugfix (code workflow 10-debug) + a `20-BUGS/BUG-<DESC>-DD-MM-YYYY.md` report if non-trivial. -->

- [ ] [Bug] — [fix] — ✅ Resolved / pending

---

## Key Decisions

<!-- ★ Always. Use the 4-column form (richer, preferred). -->

| Decision   | Chosen          | Rejected / Alternative | Reason                      |
| ---------- | --------------- | ---------------------- | --------------------------- |
| [decision] | [chosen option] | [what was rejected]    | [rationale + doc reference] |

---

## Dependencies

<!-- ★ Always. 4-column story matrix + the three prose lines below. -->

| Story / Artefact | Model / Feature | Required for           | Current state                                                                 |
| ---------------- | --------------- | ---------------------- | ----------------------------------------------------------------------------- |
| US###            | [what it gives] | [why this story needs] | `Open` / `Pending` / `In Progress` / `Blocked` / `Completed` (ClickUp status) |

**Blocked by:** [stories/artefacts that must land first — or "none".]
**Blocks:** [stories that depend on this — or "none".]
**Can be done now:** [the slice startable immediately inside this worktree, independent of blockers.]

> Where the project keeps a cross-cutting programme plan (`16-STORY-PLANS/PLAN-<DESCRIPTOR>.md`,
> e.g. a parallel-worktree execution DAG), cross-reference it here so the serialisation gates
> are respected. The base template ships none — delete this line if the project has no such plan.

---

## GDPR

<!-- ◇ MANDATORY if any personal data is touched; delete only if the story handles zero PII.
     Drives PM workflow 09-gdpr-compliance and code workflow 06-gdpr-enforcement. -->

- **Personal data touched:** [fields → add/confirm in `project-management/src/09-GDPR/DATA-INVENTORY.md`].
- **Lawful basis (per processing activity):**

  | Processing activity | Lawful basis (UK GDPR Art. 6) | Special category? | Article |
  | ------------------- | ----------------------------- | ----------------- | ------- |
  | [activity]          | [consent / contract / …]      | [no / Art. 9 …]   | [Art.]  |

- **Retention:** [period + trigger — align with `09-GDPR/RETENTION-DELETION.md`].
- **Rights mechanics:** access (SAR), erasure (delete vs anonymise where audit needs the row),
  restriction, portability — per `project-management/docs/gdpr/DATA-RIGHTS.md`.
- **At rest:** field-level AES-256-GCM via `EncryptedField`; **no PII in logs or error payloads.**
- **DPIA:** [required? if yes → `09-GDPR/DPIA-<DESCRIPTOR>.md`].

---

## Security

<!-- ◇ Keep for any non-trivial security surface (auth, input, uploads, secrets, crypto).
     Drives PM workflow 10-security-checks and code workflow 08-security-hardening. -->

| Check                            | Requirement                                                                         |
| -------------------------------- | ----------------------------------------------------------------------------------- |
| AuthN / AuthZ                    | [scheme per `api-design/AUTH-STRATEGY.md`; NIST SP 800-63B]                         |
| Endpoint permission checks (A01) | Every endpoint gated by an explicit Policy check                                    |
| IDOR                             | All user-supplied IDs verified against caller ownership                             |
| Input validation                 | [per `security/INPUT-AND-API.md`]                                                   |
| File uploads                     | [type/size/scan hardening — if applicable]                                          |
| Secrets                          | Env vars only; never hardcoded; `DEBUG=False` off-local; CORS allowlist (never `*`) |
| Rate limiting                    | [public endpoints — per existing rate-limit infra, if applicable]                   |
| Dependencies                     | New/upgraded deps triaged per `security/SUPPLY-CHAIN.md`                            |

> STRIDE threat model + OWASP Top 10 (2025) mapping per `project-management/docs/SECURITY-GUIDE.md`.
> Findings/assessments are written to `project-management/src/10-SECURITY/**` (see Section Documentation
> Write-Ups). Critical/High must be fixed before PR; document accepted lower-severity risks.

---

## Logging & Observability

<!-- ◇ Keep if the story emits logs/metrics or wires observability. -->

- Backend: structured logger per `logging/DJANGO-LOGGING.md` (never `print`). Logger child:
  `[logger name]`. There is no JavaScript server — all server logging is Django logging.
- Browser: the small project logger + GlitchTip via the Sentry browser SDK, per
  `logging/FRONTEND-LOGGING.md` (never a raw `console.*` in shipped Alpine or page scripts).
- Metrics / error tracking: [GlitchTip / Loki / Prometheus / Grafana — per `logging/OBSERVABILITY.md`].
- **No PII** in any log line, span, or error payload.

---

## Performance, Rendering, Responsive & Accessibility

<!-- ◇ Keep the rows that apply. -->

- **Performance:** [N+1 prevention via `select_related`/`prefetch_related` + `nplusone` in dev;
  caching / response targets per `performance/*`.]
- **Scale readiness** (◇ when the story adds a route/upload/SSE surface or a user-owned table):
  statelessness, keyset pagination, `tenant_id` coverage, async-safe I/O, cache-stampede posture
  (the cache-stampede posture); a new edge/server need → `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`.
  Anti-forecast — reconcile the snapshot, don't provision.
- **Rendering:** [Template / HTMX / Alpine boundary per `rendering/TEMPLATES-AND-INTERACTIVITY.md`; data-fetch strategy.]
- **Responsive:** [breakpoints + mobile-first per `responsive/*`; 13-breakpoint wireframe check.]
- **Accessibility:** [WCAG 2.2 AA; keyboard/focus per `accessibility/INTERACTION.md`; verified by
  the manual WCAG 2.2 AA checklist.]
- **SEO** (public pages): metadata, JSON-LD, sitemap, robots — `project-management/docs/SEO-CHECKLIST.md`.

---

## Implementation Workflows & Standards

<!-- ★ Always. The three sub-tables below are the spine of the plan. -->

> Standard implementation path for this story, followed inside its worktree. Layer scope is driven
> by the story's scope table; always-on rows apply regardless. PM workflows 02–16 (design/planning)
> must be complete before any code; 16–21 (implementation/delivery) run inside the worktree.

### PM workflow chain (in order)

| Phase                           | Workflow                                                            | Applies  |
| ------------------------------- | ------------------------------------------------------------------- | -------- |
| Story written + AC agreed       | `project-management/workflows/02-story-creation/`                   | ✓ always |
| Sprint slotted                  | `…/03-sprint-planning/`                                             | ✓        |
| DB schema signed off            | `…/04-database-schema/`                                             | ✓ / —    |
| User flow mapped                | `…/05-user-flow-design/`                                            | ✓ / —    |
| Brand / components / wireframes | `…/06-brand-guides/`, `…/07-component-designs/`, `…/08-wireframes/` | ✓ / —    |
| GDPR review                     | `…/09-gdpr-compliance/`                                             | ✓ / —    |
| Security review                 | `…/10-security-checks/`                                             | ✓ / —    |
| QA plan                         | `…/11-qa-checks/`                                                   | ✓        |
| SEO check (public pages)        | `…/12-seo-checks/`                                                  | ✓ / —    |
| API contract designed           | `…/13-api-design/`                                                  | ✓ / —    |
| Detailed sprint plan            | `…/15-sprint-plans/`                                                | ✓        |
| Backend code                    | `…/18-backend-code/`                                                | ✓ / —    |
| API code                        | `…/19-api-code/`                                                    | ✓ / —    |
| Frontend code                   | `…/20-frontend-code/`                                               | ✓ / —    |
| PR & review                     | `…/22-pr-and-review/`                                               | ✓ always |
| Release                         | `…/23-release/`                                                     | ✓ / —    |

### Code workflows invoked

| Workflow                                 | When                                                                        |
| ---------------------------------------- | --------------------------------------------------------------------------- |
| `code/workflows/01-new-feature/`         | The build spine for a full-stack capability                                 |
| `code/workflows/02-tdd-cycle/`           | ✓ always — Red → Green → Refactor for every unit of behaviour               |
| `code/workflows/04-api-design/`          | Any Django Ninja endpoint / schema work                                     |
| `code/workflows/03-database-migration/`  | Any schema change / migration                                               |
| `code/workflows/06-gdpr-enforcement/`    | Any PII / consent / erasure code                                            |
| `code/workflows/08-security-hardening/`  | Security-sensitive surface; pre-PR security pass                            |
| `code/workflows/07-review/`              | ✓ always — code-content quality/security/coverage gate before PR            |
| `code/workflows/11-refactor/`            | Behaviour-preserving cleanup / debt / files &gt;750 lines (separate commit) |
| `code/workflows/10-debug/`               | A reproducible logic bug (failing regression test first)                    |
| `code/workflows/09-debugging-with-logs/` | Observability-driven debugging; hands off to `10-debug` for the fix         |

### Standards gates

| Doc                                                   | When it gates                                                                                               |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `code/docs/CODING-PRINCIPLES.md` (+ backend/frontend) | All code                                                                                                    |
| `code/docs/TESTING.md`                                | All code — one floor: **75% line and branch / 90% auth**; pre-PR gate on `staging`/`main` raises to **80%** |
| `code/docs/SECURITY.md`                               | All code — A01 permission checks, IDOR, secrets                                                             |
| `code/docs/API-DESIGN.md`                             | Any API surface                                                                                             |
| `code/docs/DATA-STRUCTURES.md`                        | Any model/schema                                                                                            |
| `code/docs/ENCRYPTION-GUIDE.md`                       | Any PII                                                                                                     |
| `code/docs/RLS-GUIDE.md`                              | Any row-scoped data                                                                                         |
| `code/docs/ACCESSIBILITY.md` + `RESPONSIVE-DESIGN.md` | Any interactive UI                                                                                          |
| `code/docs/DESIGN-TOKENS.md`                          | Any visual value                                                                                            |
| `code/docs/URL-STRATEGY.md`                           | Any route/slug/endpoint/admin path                                                                          |
| `code/docs/RENDERING.md` + `PERFORMANCE.md`           | Any template / HTMX rendering / perf-sensitive path                                                         |
| `code/docs/LOGGING.md`                                | Any logging/observability                                                                                   |
| `project-management/docs/SEO-CHECKLIST.md`            | Any public marketing page                                                                                   |

---

## Execution & Verification via Claude Dynamic Workflows

<!-- ★ Always. This section tells the implementer to drive the build with Claude dynamic workflows
     (the Workflow tool / subagents), with adversarial verification and review at each gate. Every
     command referenced here is a project script — see the next section for the local↔docker rules. -->

Every Opus session runs with **ultracode** on (dynamic workflows enabled). Drive this story with
dynamic workflows rather than ad-hoc single passes: fan out, verify adversarially, then synthesise.
Map the work to these orchestration stages — run each as a Claude dynamic workflow / subagent set,
and treat verification + review as first-class, not afterthoughts.

### Stage 0 — Plan verification (before any code)

- Spawn 2–3 independent reviewers (or a small `parallel()` workflow) to **adversarially critique this
  plan**: missing layers, unhandled GDPR/security, wrong doc references, dependency-order errors,
  unscoped deferrals. Resolve findings before coding. Dispatch the built-in `Plan` subagent for architectural depth.

### Stage 1 — Build (TDD inner loop)

- Follow `code/workflows/01-new-feature/` with `02-tdd-cycle/` as the inner loop: **Red → Green →
  Refactor**, one unit of behaviour at a time. Baseline before writing: `syntax/check.sh`.
- Use subagents per layer (backend / API / frontend) where they can proceed independently; serialise
  where one truly blocks another (mirror _Dependencies_).

### Stage 2 — Continuous verification gates (run after every meaningful change)

Run these as a quality-gate workflow (a `pipeline()`/`parallel()` over the checks with a fix loop —
re-run after each `--fix` until clean). Each maps 1:1 to the pre-PR hook (`.claude/hooks/pre-pr-check.sh`):

| Gate            | Command (project script)                                       | Pre-PR gate # |
| --------------- | -------------------------------------------------------------- | ------------- |
| Format          | `bash code/src/scripts/syntax/format.sh --fix`                 | [3/8]         |
| Lint            | `bash code/src/scripts/syntax/lint.sh --fix`                   | [4/8]         |
| Typecheck       | `bash code/src/scripts/syntax/check.sh`                        | [6/8]         |
| Stub audit      | `bash code/src/scripts/audits/stubs.sh` (`--strict` for TODOs) | [5/8]         |
| cloc line-count | `bash code/src/scripts/audits/cloc.sh` (≥750 warn / ≥800 fail) | [1/8]         |
| Dependency/CVE  | `bash code/src/scripts/audits/security.sh`                     | [8/8]         |
| Lockfiles fresh | `install-backend.sh --check` · `install-frontend.sh --check`   | [2/8]         |
| Tests           | `bash code/src/scripts/tests/all.sh` (`--coverage` for floors) | [7/8]         |

> The pre-PR hook re-runs all 8 gates **both locally and inside Docker** and **hard-blocks on any
> local↔Docker mismatch**. Running them yourself throughout (not just at PR time) keeps the two
> environments aligned and avoids a late block.

### Stage 3 — Review (before raising the PR)

- Run `code/workflows/07-review/`: a quality/security/coverage review of the _code content_. Drive it
  with the `review` and `security` skills (which dispatch `code-reviewer` / `qa-tester`),
  and the `review-changes` graph playbook (`.claude/skills/review-changes.md`) for structural context.
- For findings, **adversarially verify** each before acting: spawn independent skeptics to confirm a
  finding is real (majority vote) — avoids churning on false positives.
- Refactor cleanups go through `code/workflows/11-refactor/` in a **separate commit** (behaviour
  unchanged, coverage not reduced; re-run `syntax/lint.sh` + `syntax/check.sh` + `audits/cloc.sh`).

### Stage 4 — Behavioural verification

- Confirm the change actually works in the running app: `bash code/src/scripts/development/server.sh up`,
  then exercise the path in a browser; for UI, run `bash code/src/scripts/tests/e2e-py.sh`
  (pytest-playwright) and walk the manual accessibility checklist.

### Stage 5 — PR & release

- `code/workflows/07-review/` clean → PM `22-pr-and-review/` (branch promotion + write back the
  implementation records in _Documentation Write-Ups_) → PM `23-release/` when cutting a version
  (`version` per `project-management/docs/VERSIONING-GUIDE.md`).

---

## Quality Gates, Scripts & Local↔Docker Alignment

<!-- ★ Always. The canonical command list + the two narrow raw-command exceptions. -->

**Governing rule.** All developer operations use the wrapper scripts in `code/src/scripts/**/*.sh`.
Never run raw `python`, `manage.py`, `pytest`, `pnpm`, or `docker` for normal work. The wrappers execute
tools **inside the Docker containers** (the canonical environment), which is what keeps local and
Docker behaviour aligned — everyone runs the same tool versions against the same image.

### Canonical commands

| Need                          | Command                                                                                                                  | Runs   |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------ |
| Start / stop dev stack        | `bash code/src/scripts/development/server.sh up [--build] [--watch]` / `down`                                            | Docker |
| Open a service shell          | `bash code/src/scripts/development/shell.sh [--service django\|db\|cache\|nginx]`                                        | Docker |
| Tail logs                     | `bash code/src/scripts/development/logs.sh --follow [--service ...]`                                                     | Docker |
| New Django app                | `bash code/src/scripts/development/new-django-app.sh <app_name>`                                                         | Docker |
| New public marketing page     | `bash code/src/scripts/development/new-django-view.sh <route_path>`                                                      | Local  |
| Make / run migrations         | `bash code/src/scripts/database/migrate.sh make` → review → `... run` (`check`, `show`, `--database`, `--app`, `--name`) | Docker |
| Seed dev data                 | `bash code/src/scripts/database/seed-dev.sh`                                                                             | Docker |
| Reset / backup / restore DB   | `database/{reset,backup,restore,shell,manageusers,verify-db-security}.sh`                                                | Docker |
| Format                        | `bash code/src/scripts/syntax/format.sh [--fix]` (ruff format + Prettier for CSS/MD/JSON/YAML)                           | Both   |
| Lint                          | `bash code/src/scripts/syntax/lint.sh [--fix] [--unsafe-fix]` (ruff + markdownlint; `--file-type css` for CSS)           | Both   |
| Typecheck                     | `bash code/src/scripts/syntax/check.sh` (basedpyright — Python only; there is no TypeScript)                             | Docker |
| cloc audit                    | `bash code/src/scripts/audits/cloc.sh [--path ...]`                                                                      | Local  |
| Stub audit                    | `bash code/src/scripts/audits/stubs.sh [--strict]`                                                                       | Local  |
| Dependency / CVE audit        | `bash code/src/scripts/audits/security.sh [--js-only\|--py-only] [--docker]`                                             | Both   |
| Backend tests (+coverage)     | `bash code/src/scripts/tests/backend.sh` · `tests/backend-coverage.sh` (≥75%)                                            | Docker |
| API / contract tests          | `bash code/src/scripts/tests/api.sh` (Bruno — `/api/*` JSON)                                                             | Docker |
| Browser e2e (a11y + overflow) | `bash code/src/scripts/tests/e2e-py.sh` (dev stack up)                                                                   | Local  |
| Mutation testing              | `bash code/src/scripts/tests/mutmut.sh` (local only)                                                                     | Docker |
| Everything                    | `bash code/src/scripts/tests/all.sh [--api] [--coverage]`                                                                | Both   |
| Lockfiles (regen / verify)    | `development/install-backend.sh [--sync\|--check]` · `install-frontend.sh [--local\|--check]`                            | Local  |
| Worktree `/etc/hosts`         | `bash code/src/scripts/development/hosts-story-add.sh us###` / `hosts-story-remove.sh`                                   | Local  |

> **Secret scanning** has no wrapper script — it runs in CI (`.github/workflows/audit-secrets.yml`).
> `audits/security.sh` covers dependency CVEs only. There is **no schema-export / codegen
> step** — the API is Python-typed django-ninja (one `NinjaAPI`, served under `/api/`)
> and consumed as JSON by external clients, so no typed-client generation is required.

### Exception 1 — raw `pnpm exec`

Reach for raw pnpm **only** when probing host tooling directly (`pnpm exec prettier --check ...`,
`pnpm install --frozen-lockfile`, `pnpm audit`). `pnpm-workspace.yaml` declares **no workspace
packages** — the root `package.json` carries repo tooling only (markdownlint, Prettier, lefthook,
Bruno), and nothing it installs reaches the browser. The site is server-rendered Django, tested
via `tests/backend.sh`.

- Root, repo-wide non-source lint/format (not containerised): `pnpm lint:md`,
  `pnpm format:check`, `pnpm format`.

### Exception 2 — raw `uv run ...` (Python)

Reach for raw uv **only** for host-vs-container drift detection or a one-off tool with no wrapper, and
**always** `uv sync --frozen` (or `install-backend.sh --sync`) first so the
host `.venv` matches `uv.lock` (Python pinned **3.14**). Examples mirroring the gate:
`uv run ruff check code/src/django/`, `uv run ruff format --check code/src/django/`,
`uv run ruff check --select S code/src/django/` (bandit), `uv run basedpyright code/src/django/`,
`uv run pytest [--cov]`, `uv export --no-hashes --format=requirements-txt`, `uv pip list --format=freeze`.

> **Alignment rule of thumb:** wrappers = source of truth (container execution); raw `pnpm --filter`
> / `pnpm exec` and `uv run` are reserved for drift detection and wrapper-less actions. If this story
> introduces a new raw command, mirror it on both host and container exactly as the pre-PR gate does,
> or add a wrapper script instead. Keep host tool versions matched to the images.

---

## Testing

<!-- ◇ Keep for any code change (almost always). Tier markers: unit / integration / api / e2e. -->

**Coverage floor:** **75%** line and branch (auth-critical paths **90%**) — one floor, since template
and HTMX tests are pytest tests; the pre-PR gate raises it to **80%** on `staging`/`main`. Assert on outcomes, not internals; Faker/factory-boy
fixtures; parametrise; no stubs / `NotImplementedError` in green code.

### Unit & integration (backend) — `bash code/src/scripts/tests/backend.sh`

| Test ID | Description | Assertion          |
| ------- | ----------- | ------------------ |
| [id]    | [behaviour] | [expected outcome] |

- [Template and component behaviour is covered by backend pytest (`tests/backend.sh`).]

### API / contract — `tests/api.sh` (Bruno)

- [Bruno `.bru` flows for new `/api/*` endpoints; JSON response-shape assertions.]

### API permission tests — per `code/docs/testing/API-TESTING.md`

- [Permission-check tests: unauthorised caller is rejected; IDOR attempt is rejected.]

### Browser e2e — `bash code/src/scripts/tests/e2e-py.sh` (pytest-playwright)

- [Journey and viewport-overflow checks against the running dev stack. One browser driver, in
  Python — `code/src/django/tests/e2e/`; there is no JavaScript test runner.]

### Accessibility

- Markup-level rules (landmarks, heading order, labels, accessible names) asserted in pytest;
  automated axe scans in the e2e suite (`test_e2e_a11y.py`); contrast, focus order, and
  screen-reader passes walked manually — WCAG 2.2 AA.

### Manual testing

- [Steps a human follows — captured in `project-management/src/17-TESTS/US###-MANUAL-TESTING.md`.]

---

## Documentation Write-Ups (Implementation Records)

<!-- ★ Always. The documentation hard gate: these records MUST be complete before any commit.
     This table is the authoritative "which write-up goes in which folder, produced by which
     workflow" map. Mark each row Always / Conditional / Not required for THIS story, with a reason. -->

| Record                                     | Filename pattern                                                    | Destination folder                                                                               | Produced by (workflow)                                                   | This story                 |
| ------------------------------------------ | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ | -------------------------- |
| **This plan**                              | `STORY-PLAN-US###-<DESC>.md`                                        | `project-management/src/16-STORY-PLANS/`                                                         | planning                                                                 | Always                     |
| ADR (if a cross-cutting decision)          | `ADR-###-<title>.md`                                                | `…/src/14-DECISIONS/`                                                                            | planning                                                                 | Conditional                |
| User story                                 | `US###.md`                                                          | `…/src/02-STORIES/`                                                                              | PM `02-story-creation`                                                   | Always                     |
| Sprint plan                                | `##-SPRINT-PLAN-##.md`                                              | `…/src/15-SPRINT-PLANS/`                                                                         | PM `15-sprint-plans`                                                     | Always                     |
| Schema / ERD / migration notes             | `SCHEMA-*.md`, `ERD-*.md`, `MIGRATION-NOTES-*.md`                   | `…/src/04-DATABASE/`                                                                             | PM `04-database-schema`                                                  | Conditional                |
| GDPR gap report (planning)                 | `GDPR-PLAN-US###-*.md`                                              | `…/src/09-GDPR/PLANNING/`                                                                        | PM `09-gdpr-compliance`                                                  | Conditional                |
| GDPR implementation record                 | `GDPR-IMPL-US###-*.md`                                              | `…/src/09-GDPR/IMPLEMENTATION/`                                                                  | PM `22-pr-and-review` (write-back)                                       | Conditional                |
| Security audit / assessment / threat model | `AUDIT-…`, `ASSESSMENT-…`, threat-model, `VULN-…` (`-DD-MM-YYYY`)   | `…/src/10-SECURITY/{AUDITS,ASSESSMENTS,THREAT-MODEL,VULNERABILITIES}/{PLANNING,IMPLEMENTATION}/` | PM `10-security-checks` + `17` write-back / code `08-security-hardening` | Conditional                |
| QA plan (pre-dev)                          | `QA-PLAN-US###-<DESC>.md`                                           | `…/src/11-QA/PLANNING/`                                                                          | PM `11-qa-checks`                                                        | Always                     |
| QA implementation review                   | `QA-IMPL-US###-<DESC>.md`                                           | `…/src/11-QA/IMPLEMENTATION/`                                                                    | PM `22-pr-and-review`                                                    | Always                     |
| SEO implementation record                  | `SEO-IMPL-US###-<DESC>-DD-MM-YYYY.md`                               | `…/src/12-SEO/IMPLEMENTATION/`                                                                   | PM `20-frontend-code` → `12-seo-checks`                                  | Conditional (public pages) |
| API design doc                             | `API-PLAN-US###-<DESC>.md`                                          | `…/src/13-API-DESIGN/PLANNING/`                                                                  | PM `13-api-design`                                                       | Conditional                |
| API implementation record                  | `API-IMPL-US###-<DESC>-DD-MM-YYYY.md`                               | `…/src/13-API-DESIGN/IMPLEMENTATION/`                                                            | PM `19-api-code` (write-back)                                            | Conditional                |
| Test status / manual testing               | `US###-TEST-STATUS.md`, `US###-MANUAL-TESTING.md`                   | `…/src/17-TESTS/`                                                                                | PM `14/15/16` code workflows                                             | Always                     |
| Code review record                         | `REVIEW-US###-<DESC>.md`                                            | `…/src/18-REVIEWS/`                                                                              | PM `22-pr-and-review` / code `07-review`                                 | Always                     |
| Bug report (if a bug surfaced)             | `BUG-<DESC>-DD-MM-YYYY.md`                                          | `…/src/20-BUGS/`                                                                                 | code `10-debug` / `09-debugging-with-logs`                               | Conditional                |
| Refactoring record                         | `REFACTOR-<DESC>.md` / `REFACTORING-US###-*.md`                     | `…/src/21-REFACTORING/`                                                                          | code `11-refactor`                                                       | Conditional                |
| Release (version bump)                     | root `VERSION`, `CHANGELOG.md`, `RELEASES.md`, `VERSION-HISTORY.md` | repo root                                                                                        | PM `23-release`                                                          | Conditional                |

> **Folder gotchas (from the workflow↔folder map):** design/compliance folders `09-GDPR`–
> `13-API-DESIGN` each split into `PLANNING/` (pre-dev plan/spec, per story) + `IMPLEMENTATION/`
> (delivery write-back, per story) — `10-SECURITY` nests that split under its four categories. There
> is **no `STORIES/` subfolder** any more. `IMPLEMENTATION/` records live under the design-phase
> numbers (08–12) but are written **during delivery** (workflows 14–18). `src/` numbers align with
> workflow numbers only up to **12**; from `src/14-DECISIONS` on they diverge — do not assume
> `src/15-SPRINT-PLANS`=WF14 (WF14 is `18-backend-code`).

---

## CONTEXT.md & Index Updates

<!-- ★ Always — part of the documentation hard gate. -->

| File                                                 | Change required                                                                                                                                                     |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `project-management/src/16-STORY-PLANS/CONTEXT.md`   | Add this plan's row to the Plans Index (file link, story, Status); bump **Last Updated**                                                                            |
| `<any new directory>/CONTEXT.md` + `CLAUDE.md`       | Every new directory in any layer needs both — `CLAUDE.md` opens with `@./CONTEXT.md`, then a `Read order:` line and the four H2 sections (never a bare import stub) |
| `code/src/django/apps/<app>/CONTEXT.md` (if new app) | Document the new app                                                                                                                                                |
| Relevant `CONTEXT.md` **Last Updated** dates         | Refresh wherever content changed                                                                                                                                    |
| `GAPS.md` / `DEFERRED.md` (repo root)                | Record any gap/blocker / deferred item with its target US###                                                                                                        |

---

## Status Propagation & ClickUp Sync

<!-- ★ Always. Status appears in several artefacts and is mirrored onto the ClickUp board. Whenever
     this story's status changes (e.g. Open → In Progress → In Review → Completed), set the SAME
     canonical ClickUp value (Section header vocabulary) in EVERY artefact below, then regenerate the
     ClickUp export. The story file is the single source of truth the export reads. -->

On every status transition, update the same ClickUp status value everywhere it appears, in this order:

| #   | Artefact                       | Where the status lives                                                   | Notes                                                        |
| --- | ------------------------------ | ------------------------------------------------------------------------ | ------------------------------------------------------------ |
| 1   | **Story (source of truth)**    | `project-management/src/02-STORIES/US###.md` → `**Status:**` header      | Edit here **first** — the only file the ClickUp export reads |
| 2   | **This plan**                  | `…/src/16-STORY-PLANS/STORY-PLAN-US###-*.md` → `Status` (metadata table) | Keep in lockstep with the story                              |
| 3   | **Plans Index**                | `…/src/16-STORY-PLANS/CONTEXT.md` → Plans Index `Status` column          | Also bump the index **Last Updated**                         |
| 4   | **Sprint record**              | `…/src/03-SPRINTS/SPRINT-##.md` → story status table                     | If the story is listed in a sprint                           |
| 5   | **Sprint plan**                | `…/src/15-SPRINT-PLANS/##-SPRINT-PLAN-##.md` → story table / DoD         | If covered by a detailed sprint plan                         |
| 6   | **ClickUp export (generated)** | `…/export/clickup/US###-CLIENT.md`                                       | **Do not hand-edit** — read-only (0444); regenerate (below)  |

Then regenerate the ClickUp-ready export from the (updated) source story:

```bash
# Single story (preferred while iterating):
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US###
# Or regenerate every story:
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh
```

This rewrites `project-management/export/clickup/US###-CLIENT.md` with only the client-facing fields
(title, `Status`, MoSCoW, Story Points, Client Summary, User Story — internal fields stripped). The
`precommit-clickup.sh` lefthook also regenerates and re-stages these on commit whenever a source story
or a generated client file is staged, so the export can never drift from the source story.

> **Push to ClickUp** is performed by `project-management/src/00-ASSETS/scripts/sync-clickup.sh`
> (idempotent upsert via `export/clickup-task-map.json`), run automatically by the `clickup-sync`
> GitHub workflow on push/PR. You normally only run the **export** script and let CI sync; to preview
> the push locally use `bash project-management/src/00-ASSETS/scripts/sync-clickup.sh US### --dry-run`
> (it writes to ClickUp only when `CLICKUP_SYNC_APPLY=1` + `CLICKUP_API_TOKEN` +
> `CLICKUP_BACKLOG_LIST_ID` are set — CI-only).

---

## Deferred Items

<!-- ★ Always (state "None" if truly none). Each deferral names a target future story; mirror to
     repo-root DEFERRED.md. -->

- **&lt;Item&gt;** — [reason] — target: US### / future.

---

## Risks

<!-- ★ Always. 4-column form preferred. -->

| Risk   | Likelihood   | Impact       | Mitigation   |
| ------ | ------------ | ------------ | ------------ |
| [risk] | Low/Med/High | Low/Med/High | [mitigation] |

---

## Docker & Nginx Infrastructure

<!-- ★ Always (worktree isolation). N = the story number; use the canonical `127.0.0.N` IP scheme. -->

Four per-story worktree-isolation files (create alongside the worktree):

| File                                            | Purpose                                                              |
| ----------------------------------------------- | -------------------------------------------------------------------- |
| `code/src/docker/docker-compose.us###.dev.yml`  | Dev stack override — IP `127.0.0.N`, ports `3080`/`3082`/`3180`      |
| `code/src/docker/docker-compose.us###.test.yml` | Test stack override — IP `127.0.0.N`, port `3081`                    |
| `code/src/docker/nginx/dev-us###.conf`          | Nginx dev reverse proxy for `dev-us###.<%PROJECT_SLUG%>.localhost`   |
| `code/src/docker/nginx/test-us###.conf`         | Nginx test reverse proxy for `test-us###.<%PROJECT_SLUG%>.localhost` |

`/etc/hosts` (one-time per story — use `bash code/src/scripts/development/hosts-story-add.sh us###`):

```text
127.0.0.N dev-us###.<%PROJECT_SLUG%>.localhost test-us###.<%PROJECT_SLUG%>.localhost
```

> The worktree-aware scripts auto-detect the `us###/...` branch (`_lib/worktree-detect.sh`) and layer
> in these override files. Cross-reference the project's parallel-worktree programme plan
> (`16-STORY-PLANS/PLAN-<DESCRIPTOR>.md`) where one exists.

---

## As-Built Summary

<!-- ⬡ Retrospective only — fill in AFTER the story ships (or when authoring a plan retrospectively).
     Delete for a forward-looking plan. -->

- **Models / migrations:** [what shipped]
- **Services:** [what shipped]
- **Ninja API:** [endpoints / schemas shipped]
- **Frontend:** [templates / components / HTMX partials shipped]
- **Tests / coverage:** [final numbers vs floors]
- **Deviations from plan:** [what changed and why]

---

## Sprint Verification Checklist

<!-- ◇ Keep for larger stories. Run before declaring done. -->

```bash
# Quality gates (mirror the 8 pre-PR gates)
bash code/src/scripts/syntax/format.sh --fix
bash code/src/scripts/syntax/lint.sh --fix
bash code/src/scripts/syntax/check.sh
bash code/src/scripts/audits/stubs.sh
bash code/src/scripts/audits/cloc.sh
bash code/src/scripts/audits/security.sh
bash code/src/scripts/development/install-backend.sh --check
bash code/src/scripts/development/install-frontend.sh --check
bash code/src/scripts/tests/all.sh --coverage

# Status propagation → regenerate the ClickUp export from the updated source story
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US###
```

- [ ] All 8 quality gates pass locally **and** in Docker (no mismatch)
- [ ] Coverage floors met (75% line/branch · 90% auth — 80% if targeting `staging`/`main`)
- [ ] Accessibility verified for any UI — pytest markup assertions + the manual checklist
- [ ] Every state-changing endpoint permission-checked; no IDOR
- [ ] No PII in logs/errors; secrets via env only; `DEBUG=False` off-local
- [ ] All implementation records written to correct folders (Section Documentation Write-Ups)
- [ ] `CONTEXT.md` / index / `GAPS.md` / `DEFERRED.md` updated
- [ ] Status propagated to story + plan + index + sprint/sprint-plan; ClickUp export regenerated (see _Status Propagation & ClickUp Sync_)

---

## Definition of Done

<!-- ★ Always. -->

- [ ] Acceptance criteria in `US###.md` met and demonstrated
- [ ] Code workflows `02-tdd-cycle` + `07-review` complete; security pass where applicable
- [ ] Behaviour verified in the running app (dev stack up; UI walked in a browser)
- [ ] All quality gates green locally and in Docker; coverage floors met
- [ ] Documentation hard gate satisfied — all records + `CONTEXT.md` updates complete **before** commit
- [ ] PR raised and promoted via PM `22-pr-and-review/`; review record in `18-REVIEWS/`
- [ ] Status set to the final ClickUp value across story + plan + Plans Index + sprint/sprint-plan; ClickUp export regenerated (`export-clickup-stories.sh`) and synced; `GAPS.md`/`DEFERRED.md` reconciled
- [ ] (If releasing) version bumped + changelog per PM `23-release/` and `VERSIONING-GUIDE.md`
