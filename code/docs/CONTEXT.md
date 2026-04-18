# code/docs — Coding Reference Guides

These guides define the standards for all code in this project. Read the relevant guide before
starting any task in the `code/` layer.

## Directory Tree

```text
code/docs/
├── ACCESSIBILITY.md         ← WCAG 2.2 AA, semantic HTML, ARIA patterns
├── API-DESIGN.md            ← Strawberry GraphQL conventions, REST patterns
├── ARCHITECTURE-PATTERNS.md ← service layer, Django app structure, Next.js routing
├── CODING-PRINCIPLES.md     ← Rob Pike + Linus Torvalds rules, file-length limits
├── CONTEXT.md               ← this file
├── DATA-STRUCTURES.md       ← domain modelling, PostgreSQL schema design, indexing
├── ENCRYPTION-GUIDE.md      ← field-level encryption patterns (PII storage)
├── LOGGING.md               ← logging, Glitchtip, Loki, Prometheus, Grafana, Cloudinary
├── PERFORMANCE.md           ← N+1 prevention, caching, Next.js optimisation
├── RLS-GUIDE.md             ← row-level security patterns (multi-tenant scope)
├── SECURITY.md              ← OWASP A01–A10, GraphQL security, CORS, IDOR prevention
└── TESTING.md               ← TDD phases, coverage floors, pytest + Vitest setup
```

| Guide                      | Scope                                                            |
| -------------------------- | ---------------------------------------------------------------- |
| `CODING-PRINCIPLES.md`     | Rob Pike + Linus Torvalds rules, file length limits              |
| `TESTING.md`               | TDD phases, coverage floors, pytest + Vitest setup               |
| `SECURITY.md`              | OWASP A01–A10, GraphQL security, CORS, IDOR prevention           |
| `ACCESSIBILITY.md`         | WCAG 2.2 AA, semantic HTML, ARIA patterns                        |
| `API-DESIGN.md`            | Strawberry GraphQL conventions, REST patterns                    |
| `ARCHITECTURE-PATTERNS.md` | Service layer, Django app structure, Next.js routing             |
| `DATA-STRUCTURES.md`       | Domain modelling, PostgreSQL schema design, indexing             |
| `PERFORMANCE.md`           | N+1 prevention, caching, Next.js optimisation                    |
| `LOGGING.md`               | Logging config, Glitchtip, Loki, Prometheus, Grafana, Cloudinary |
| `ENCRYPTION-GUIDE.md`      | Field-level encryption patterns (if PII storage is needed)       |
| `RLS-GUIDE.md`             | Row-level security patterns (if multi-tenant scope added)        |
