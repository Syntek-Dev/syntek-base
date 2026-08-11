# code/docs — Coding Reference Guides

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

These guides are where the standards for `code/src/` are decided, so that no rule has to be
re-derived at the point of use. Each top-level guide is a thin index; the detail lives in the
`kebab-case/` sub-folder beside it, because an instructional file stops being readable long
before it stops being writable.

## Directory Tree

```text
code/docs/
├── ACCESSIBILITY.md                  ← WCAG 2.2 AA, semantic HTML, ARIA patterns
│   └── accessibility/                ← html-and-aria/ interaction/ testing-and-components/ mobile/
├── API-DESIGN.md                     ← Django Ninja JSON API + REST conventions
│   └── api-design/                   ← rest-conventions/ ninja-conventions/ auth-and-errors/ auth-strategy/ webhooks/ event-tracking/ api-docs/ client-patterns/
├── ARCHITECTURE-PATTERNS.md          ← service layer, Django app structure, template/HTMX routing
│   └── architecture/                 ← service-and-middleware/ frontend-patterns/ core-and-scaling/ auth-contract/ provider-neutrality/ build-operate-seam/
├── BACKEND-CODING-PRINCIPLES.md      ← Django/Python/Celery specifics (read with CODING-PRINCIPLES)
├── CODING-PRINCIPLES.md              ← global rules: Rob Pike, Linus, SOLID, CUPID, DDD, YAGNI
│   └── coding-principles/            ← design-principles/ practical-rules/ style-and-process/
├── CODE-REVIEW-GRAPH.md              ← code-review-graph MCP playbooks (explore/debug/review/refactor)
├── CLAUDE.md                         ← operating rules
├── CONTEXT.md                        ← this file
├── FRONTEND-CODING-PRINCIPLES.md     ← Django templates + HTMX + Alpine + CSS (read with CODING-PRINCIPLES)
├── DATABASE.md              ← pre-flight data-layer rules: scope, constraints, locks, search, deferrals
├── DATA-STRUCTURES.md       ← domain modelling, PostgreSQL schema design, indexing
│   └── data-structures/              ← fundamentals/ domain-modelling/ schema-design/ schema-migrations/ anti-patterns/ refactoring/
├── DESKTOP.md               ← DESKTOP-ONLY — the native Slint app and its licence obligation
│   └── desktop/                      ← licensing/ ui-and-state/
├── DESIGN-TOKENS.md         ← CSS design-token catalogue and var(--token)-only usage rules
│   └── design-tokens/                ← model/ cascade/ editor/ mobile/
├── DISCOVERABILITY.md       ← being found: page metadata, structured data, root surface, body
│   └── discoverability/              ← WEB-METADATA · STRUCTURED-DATA · ROOT-SURFACE · CONTENT-STRUCTURE
├── DOCUMENTATION-PAIRING.md ← the CONTEXT.md/CLAUDE.md split: the decision test, banned headings
├── ENCRYPTION-GUIDE.md      ← field-level encryption patterns (PII storage)
│   └── encryption/                   ← field-encryption/ lookup-tokens/ rust-crypto/ (rust-only)
├── LOGGING.md               ← logging, error tracking, log aggregation, metrics, traces, Cloudinary
│   └── logging/                      ← django-logging/ frontend-logging/ observability/ health-contract/ cloudinary/
├── OBJECT-STORAGE.md        ← private-document S3 storage: adapter, presigned URLs, validation (declared, not wired)
├── PROCESS-MODEL.md         ← worker class, event loop, the ORM sync boundary, where a task worker sits
├── TASK-AUTHORING.md        ← background tasks: enqueue boundary, delivery guarantee, idempotency, retries (declared, not wired)
├── MCP-SERVER.md            ← the FastMCP tool surface at /mcp/ (available but unwired)
│   └── mcp-server/                   ← mounting/ tool-design/ auth-and-threats/ testing-and-ops/
├── NEGATIVE-SPACE.md        ← what the code must never allow: invariant classes, one enforcement point, the error taxonomy, the guard clause
├── PERFORMANCE.md           ← N+1 prevention, caching, page-weight and template tuning
│   └── performance/                  ← database-performance/ frontend-performance/ api-and-monitoring/
├── RENDERING.md             ← interaction model: server templates, HTMX, Alpine
│   └── rendering/                    ← templates-and-interactivity/ pitfalls-and-examples/
├── RESPONSIVE-DESIGN.md     ← mobile-first CSS, media queries, breakpoints, CSS custom properties
│   └── responsive/                   ← breakpoints/ media-queries/ user-preferences/ container-queries/
├── RLS-GUIDE.md             ← row-level security patterns (multi-tenant scope)
│   └── rls/                          ← fundamentals/ middleware-and-ninja/ policy-templates/ testing-and-audit/
├── RUST.md                  ← RUST-ONLY — the Cargo workspace, PyO3 boundary, cargo-deny gate
│   └── rust/                         ← pyo3-boundary/ memory-hygiene/ supply-chain/
├── SECURITY.md              ← OWASP A01–A10, Django Ninja API security, CORS, IDOR prevention
│   └── security/                     ← auth-and-authz/ crypto-and-data/ input-and-api/ secrets-and-transport/ supply-chain/ monitoring-and-incident/ owasp-and-checklist/
├── TESTING.md               ← TDD phases, coverage floors, pytest setup
│   └── testing/                      ← taxonomy/ backend-testing/ frontend-testing/ api-testing/ advanced-testing/ coverage/
├── URL-STRATEGY.md          ← route naming, slug patterns, Django URL conventions
├── VISUAL-DESIGN.md         ← visual language: the direction slot + axes, anti-generic layout, signature
│   └── visual-design/                ← WEB.md · MOBILE.md (mobile-only) · DESKTOP.md (desktop-only)
└── cloudinary/              ← Cloudinary SDK reference docs (Python)
    └── CONTEXT.md
```

| Guide                           | Scope                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CODING-PRINCIPLES.md`          | Global principles: Rob Pike, Linus, SOLID, CUPID, DDD, YAGNI                                                                                                                                                                                                                                                                                                   |
| `BACKEND-CODING-PRINCIPLES.md`  | Django/Python/Celery: class vs fn, error handling, caching                                                                                                                                                                                                                                                                                                     |
| `FRONTEND-CODING-PRINCIPLES.md` | Django templates + HTMX + Alpine + CSS specifics                                                                                                                                                                                                                                                                                                               |
| `TESTING.md`                    | TDD phases, coverage floors, pytest setup                                                                                                                                                                                                                                                                                                                      |
| `SECURITY.md`                   | OWASP A01–A10, Django Ninja API security, CORS, IDOR prevention                                                                                                                                                                                                                                                                                                |
| `ACCESSIBILITY.md`              | WCAG 2.2 AA, semantic HTML, ARIA patterns                                                                                                                                                                                                                                                                                                                      |
| `API-DESIGN.md`                 | Django Ninja JSON API and REST conventions                                                                                                                                                                                                                                                                                                                     |
| `MCP-SERVER.md`                 | The FastMCP tool surface at `/mcp/` — mounting, tool design, auth, testing (available but unwired)                                                                                                                                                                                                                                                             |
| `NEGATIVE-SPACE.md`             | What the code must never allow — what counts as an invariant, the invariant classes and their one enforcement point each, the programmer/user/environment error taxonomy, and the guard clause (`raise`, never `assert` — ruff `S101`)                                                                                                                         |
| `TASK-AUTHORING.md`             | Background-task authoring: the enqueue boundary and its committed-but-unpublished window, the delivery guarantee as a configured choice, idempotency, retries and backoff, limits, queue routing, testing without a broker (declared, not wired)                                                                                                               |
| `PROCESS-MODEL.md`              | Worker class, event loop, the ORM's sync boundary, and where a task worker sits relative to the web process family                                                                                                                                                                                                                                             |
| `OBJECT-STORAGE.md`             | Private-document storage over the S3 API: the adapter contract, presigned URLs, upload validation (declared, not wired)                                                                                                                                                                                                                                        |
| `ARCHITECTURE-PATTERNS.md`      | Service layer, Django app structure, template/HTMX routing                                                                                                                                                                                                                                                                                                     |
| `CODE-REVIEW-GRAPH.md`          | code-review-graph MCP playbooks: explore, debug, review, refactor                                                                                                                                                                                                                                                                                              |
| `DATABASE.md`                   | **Read first for data-layer work** — scope columns, database-level constraints, lock-safe migrations, search, deferred infrastructure and its triggers                                                                                                                                                                                                         |
| `DATA-STRUCTURES.md`            | Domain modelling, PostgreSQL schema design, indexing                                                                                                                                                                                                                                                                                                           |
| `PERFORMANCE.md`                | N+1 prevention, caching, page-weight and template tuning                                                                                                                                                                                                                                                                                                       |
| `RENDERING.md`                  | Server templates, HTMX, and Alpine — where an interaction runs                                                                                                                                                                                                                                                                                                 |
| `RESPONSIVE-DESIGN.md`          | Mobile-first CSS, media queries, breakpoints, CSS custom properties                                                                                                                                                                                                                                                                                            |
| `LOGGING.md`                    | Logging config, error tracking, log aggregation, metrics and dashboards, distributed tracing, Cloudinary                                                                                                                                                                                                                                                       |
| `ENCRYPTION-GUIDE.md`           | Field-level encryption patterns (if PII storage is needed)                                                                                                                                                                                                                                                                                                     |
| `RLS-GUIDE.md`                  | Row-level security patterns (if multi-tenant scope added)                                                                                                                                                                                                                                                                                                      |
| `URL-STRATEGY.md`               | Route naming, slug patterns, Django URL conventions                                                                                                                                                                                                                                                                                                            |
| `DISCOVERABILITY.md`            | **How this stack implements being found** — the `build_seo()` head pipeline, JSON-LD structured data, the root/`.well-known` surface with its ownership register, and the body's shape. The method side of `project-management/docs/SEO-CHECKLIST.md`. § 1 of `discoverability/CONTENT-STRUCTURE.md` records why there is no separate answer-engine discipline |
| `DOCUMENTATION-PAIRING.md`      | The `CONTEXT.md` / `CLAUDE.md` split — the decision test, the headings banned from an orientation file, route-don't-restate                                                                                                                                                                                                                                    |
| `DESIGN-TOKENS.md`              | CSS design-token catalogue and `var(--token)`-only usage rules                                                                                                                                                                                                                                                                                                 |
| `RUST.md`                       | **Rust-only.** The Cargo workspace — the gate question, the PyO3 boundary, secret memory hygiene, the cargo-deny supply-chain gate                                                                                                                                                                                                                             |
| `DESKTOP.md`                    | **Desktop-only.** The native Slint app — read `desktop/LICENSING.md` before shipping or selling                                                                                                                                                                                                                                                                |
| `VISUAL-DESIGN.md`              | Visual language — §3 names the **direction** and its six axes (settled at first-time setup); §4.1 universal tells, §4.2 direction deviations; §5 the motion numbers                                                                                                                                                                                            |
| `cloudinary/CONTEXT.md`         | Cloudinary SDK docs index — Python SDK                                                                                                                                                                                                                                                                                                                         |
