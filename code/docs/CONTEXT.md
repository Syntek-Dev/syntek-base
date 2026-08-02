# code/docs — Coding Reference Guides

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Quick index reference, file navigation, directory tree lookups
**MCP Servers:** code-review-graph (codebase structure context)

These guides define the standards for all code in this project. Read the relevant guide before
starting any task in the `code/` layer.

## Directory Tree

```text
code/docs/
├── ACCESSIBILITY.md                  ← WCAG 2.2 AA, semantic HTML, ARIA patterns
│   └── accessibility/                ← html-and-aria/ interaction/ testing-and-components/ mobile/
├── API-DESIGN.md                     ← Django Ninja JSON API + REST conventions
│   └── api-design/                   ← rest-conventions/ ninja-conventions/ auth-and-errors/ auth-strategy/ webhooks/ event-tracking/ api-docs/ client-patterns/
├── ARCHITECTURE-PATTERNS.md          ← service layer, Django app structure, template/HTMX routing
│   └── architecture/                 ← service-and-middleware/ frontend-patterns/ core-and-scaling/ auth-contract/
├── BACKEND-CODING-PRINCIPLES.md      ← Django/Python/Celery specifics (read with CODING-PRINCIPLES)
├── CODING-PRINCIPLES.md              ← global rules: Rob Pike, Linus, SOLID, CUPID, DDD, YAGNI
│   └── coding-principles/            ← design-principles/ practical-rules/ style-and-process/
├── CODE-REVIEW-GRAPH.md              ← code-review-graph MCP playbooks (explore/debug/review/refactor)
├── CONTEXT.md                        ← this file
├── FRONTEND-CODING-PRINCIPLES.md     ← Django templates + HTMX + Alpine + CSS (read with CODING-PRINCIPLES)
├── DATABASE.md              ← pre-flight data-layer rules: scope, constraints, locks, search, deferrals
├── DATA-STRUCTURES.md       ← domain modelling, PostgreSQL schema design, indexing
├── DESIGN-TOKENS.md         ← CSS design-token catalogue and var(--token)-only usage rules
│   └── design-tokens/                ← model/ cascade/ editor/ mobile/
├── ENCRYPTION-GUIDE.md      ← field-level encryption patterns (PII storage)
│   └── encryption/                   ← field-encryption/ lookup-tokens/
├── LOGGING.md               ← logging, Glitchtip, Loki, Prometheus, Grafana, Cloudinary
│   └── logging/                      ← django-logging/ frontend-logging/ observability/ health-contract/ cloudinary/
├── MCP-SERVER.md            ← the FastMCP tool surface at /mcp/ (available but unwired)
│   └── mcp-server/                   ← mounting/ tool-design/ auth-and-threats/ testing-and-ops/
├── PERFORMANCE.md           ← N+1 prevention, caching, page-weight and template tuning
│   └── performance/                  ← database-performance/ frontend-performance/ api-and-monitoring/
├── RENDERING.md             ← interaction model: server templates, HTMX, Alpine
│   └── rendering/                    ← templates-and-interactivity/ pitfalls-and-examples/
├── RESPONSIVE-DESIGN.md     ← mobile-first CSS, media queries, breakpoints, CSS custom properties
│   └── responsive/                   ← breakpoints/ media-queries/ user-preferences/ container-queries/
├── RLS-GUIDE.md             ← row-level security patterns (multi-tenant scope)
│   └── rls/                          ← fundamentals/ middleware-and-ninja/ policy-templates/ testing-and-audit/
├── SECURITY.md              ← OWASP A01–A10, Django Ninja API security, CORS, IDOR prevention
│   └── security/                     ← crypto-and-data/ supply-chain/ monitoring-and-incident/ owasp-and-checklist/
├── TESTING.md               ← TDD phases, coverage floors, pytest setup
├── URL-STRATEGY.md          ← route naming, slug patterns, Django URL conventions
├── VISUAL-DESIGN.md         ← visual language: anti-generic layout + <%ORG_NAME%> signature
└── cloudinary/              ← Cloudinary SDK reference docs (Python)
    └── CONTEXT.md
```

| Guide                           | Scope                                                                                                                                                  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `CODING-PRINCIPLES.md`          | Global principles: Rob Pike, Linus, SOLID, CUPID, DDD, YAGNI                                                                                           |
| `BACKEND-CODING-PRINCIPLES.md`  | Django/Python/Celery: class vs fn, error handling, caching                                                                                             |
| `FRONTEND-CODING-PRINCIPLES.md` | Django templates + HTMX + Alpine + CSS specifics                                                                                                       |
| `TESTING.md`                    | TDD phases, coverage floors, pytest setup                                                                                                              |
| `SECURITY.md`                   | OWASP A01–A10, Django Ninja API security, CORS, IDOR prevention                                                                                        |
| `ACCESSIBILITY.md`              | WCAG 2.2 AA, semantic HTML, ARIA patterns                                                                                                              |
| `API-DESIGN.md`                 | Django Ninja JSON API and REST conventions                                                                                                             |
| `MCP-SERVER.md`                 | The FastMCP tool surface at `/mcp/` — mounting, tool design, auth, testing (available but unwired)                                                     |
| `ARCHITECTURE-PATTERNS.md`      | Service layer, Django app structure, template/HTMX routing                                                                                             |
| `CODE-REVIEW-GRAPH.md`          | code-review-graph MCP playbooks: explore, debug, review, refactor                                                                                      |
| `DATABASE.md`                   | **Read first for data-layer work** — scope columns, database-level constraints, lock-safe migrations, search, deferred infrastructure and its triggers |
| `DATA-STRUCTURES.md`            | Domain modelling, PostgreSQL schema design, indexing                                                                                                   |
| `PERFORMANCE.md`                | N+1 prevention, caching, page-weight and template tuning                                                                                               |
| `RENDERING.md`                  | Server templates, HTMX, and Alpine — where an interaction runs                                                                                         |
| `RESPONSIVE-DESIGN.md`          | Mobile-first CSS, media queries, breakpoints, CSS custom properties                                                                                    |
| `LOGGING.md`                    | Logging config, Glitchtip, Loki, Prometheus, Grafana, Cloudinary                                                                                       |
| `ENCRYPTION-GUIDE.md`           | Field-level encryption patterns (if PII storage is needed)                                                                                             |
| `RLS-GUIDE.md`                  | Row-level security patterns (if multi-tenant scope added)                                                                                              |
| `URL-STRATEGY.md`               | Route naming, slug patterns, Django URL conventions                                                                                                    |
| `DESIGN-TOKENS.md`              | CSS design-token catalogue and `var(--token)`-only usage rules                                                                                         |
| `VISUAL-DESIGN.md`              | Visual language — anti-generic layout, <%ORG_NAME%> signature                                                                                          |
| `cloudinary/CONTEXT.md`         | Cloudinary SDK docs index — Python SDK                                                                                                                 |
