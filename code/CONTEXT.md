# code — Coding Standards, Patterns & Testing

## Directory Tree

```text
code/
├── CONTEXT.md                       ← this file
├── REFERENCES.md                    ← internal and external reference index for the code layer
├── docs/                            ← coding reference guides
│   ├── ACCESSIBILITY.md             (sub-docs: accessibility/)
│   ├── API-DESIGN.md                (sub-docs: api-design/)
│   ├── ARCHITECTURE-PATTERNS.md     (sub-docs: architecture/)
│   ├── BACKEND-CODING-PRINCIPLES.md ← Django/Python/Celery specifics
│   ├── CODING-PRINCIPLES.md         (sub-docs: coding-principles/)
│   ├── CONTEXT.md
│   ├── DATA-STRUCTURES.md           (sub-docs: data-structures/)
│   ├── DESIGN-TOKENS.md             ← CSS design token catalogue and usage rules
│   ├── ENCRYPTION-GUIDE.md          (sub-docs: encryption/)
│   ├── FRONTEND-CODING-PRINCIPLES.md ← Django templates + HTMX + Alpine + CSS
│   ├── LOGGING.md                   (sub-docs: logging/)
│   ├── MCP-SERVER.md                (sub-docs: mcp-server/) ← FastMCP tools at /mcp/
│   ├── PERFORMANCE.md               (sub-docs: performance/)
│   ├── RENDERING.md                 (sub-docs: rendering/)
│   ├── RESPONSIVE-DESIGN.md         (sub-docs: responsive/)
│   ├── RLS-GUIDE.md                 (sub-docs: rls/)
│   ├── SECURITY.md                  (sub-docs: security/)
│   ├── TESTING.md                   (sub-docs: testing/)
│   ├── URL-STRATEGY.md
│   └── VISUAL-DESIGN.md             ← visual language: anti-generic layout + <%ORG_NAME%> signature
├── src/                             ← all deployable source code
│   ├── CONTEXT.md
│   ├── django/                      ← the Django project (backend + server-rendered frontend)
│   │   └── CONTEXT.md
│   ├── mobile/                      ← MOBILE-ONLY — the Expo React Native app
│   │   └── CONTEXT.md
│   ├── docker/                      ← Dockerfiles and Compose files
│   │   └── CONTEXT.md
│   ├── logs/                        ← runtime log files (dev/test; all gitignored)
│   │   ├── CONTEXT.md
│   │   ├── .gitignore
│   │   └── .gitkeep
│   ├── scripts/                     ← shell scripts for all development operations
│   │   ├── CONTEXT.md
│   │   ├── audits/                  ← codebase health audits (cloc, stub detection)
│   │   ├── database/                ← database management (migrate, backup, restore, shell)
│   │   ├── deployment/              ← deployment scripts (planned)
│   │   ├── development/             ← dev stack lifecycle (server, shell, logs, scaffolding)
│   │   ├── mobile/                  ← MOBILE-ONLY — Metro, lint, typecheck, test, bundle
│   │   ├── syntax/                  ← code quality (lint, type-check, format)
│   │   └── tests/                   ← test suite runners (pytest, Bruno)
│   └── tests/                       ← API integration tests (Bruno collection)
│       └── CONTEXT.md
└── workflows/                       ← step-by-step coding workflows (three families)
    ├── CONTEXT.md
    │   ── Build (01–06) ──
    ├── 01-new-feature/              ← full-stack feature development
    ├── 02-tdd-cycle/                ← Red → Green → Refactor
    ├── 03-database-migration/       ← Django model and migration workflow
    ├── 04-api-design/               ← Django Ninja API design (/api/)
    ├── 05-mcp-server/               ← FastMCP tool surface (/mcp/)
    ├── 06-gdpr-enforcement/         ← GDPR code implementation
    │   ── Verify (07–08) ──
    ├── 07-review/                   ← code quality review (principles, coverage)
    ├── 08-security-hardening/       ← OWASP security audit and hardening
    │   ── Diagnose & improve (09–11) ──
    ├── 09-debugging-with-logs/      ← find the cause: logs, Glitchtip, Loki, Grafana
    ├── 10-debug/                    ← fix it: isolate, regression test, patch
    └── 11-refactor/                 ← improve it: no behaviour change

Each workflow folder holds CONTEXT.md · STEPS.md · CHECKLIST.md · CLAUDE.md.
```

## When to read this

- Writing any code in `code/src/django/`
- Designing a new page, feature, or Django app
- Writing or debugging tests (TDD)
- Implementing security or permissions logic
- Designing a Django Ninja API endpoint
- Reviewing a PR for code quality

## Contents

- `docs/` — Reference guides for all coding disciplines
- `workflows/` — Step-by-step guides for common coding tasks

## Do not use for

- Sprint planning, story creation, PR lifecycle → `project-management/CONTEXT.md`
- Environment setup, daily dev commands → `how-to/CONTEXT.md`

## Key docs

| Guide                           | When to read                                                           |
| ------------------------------- | ---------------------------------------------------------------------- |
| `docs/CODING-PRINCIPLES.md`     | Before writing any code                                                |
| `docs/TESTING.md`               | Before writing tests                                                   |
| `docs/SECURITY.md`              | Before writing auth, permissions, or any endpoint                      |
| `docs/API-DESIGN.md`            | Before adding Django Ninja endpoints or Schema models                  |
| `docs/MCP-SERVER.md`            | Before exposing anything to an LLM agent (the FastMCP `/mcp/` surface) |
| `docs/ACCESSIBILITY.md`         | Before building any frontend component                                 |
| `docs/RESPONSIVE-DESIGN.md`     | Before building any frontend component or layout                       |
| `docs/ARCHITECTURE-PATTERNS.md` | Before designing a new Django app or page route                        |
| `docs/DATABASE.md`              | **Before any model, migration, or query** — the pre-flight rules       |
| `docs/DATA-STRUCTURES.md`       | Before adding a model or schema change                                 |
| `docs/LOGGING.md`               | Before adding logging, error tracking, or metrics                      |
| `docs/RENDERING.md`             | Before choosing server vs HTMX vs Alpine for an interaction            |
| `docs/PERFORMANCE.md`           | Before optimising a query or page                                      |
| `docs/ENCRYPTION-GUIDE.md`      | Before adding any PII field or storage                                 |
| `docs/RLS-GUIDE.md`             | Before adding multi-tenant or row-scoped queries                       |
| `docs/URL-STRATEGY.md`          | Before adding routes, redirects, or slug patterns                      |

## Surfaces — where source may live

`code/` owns **all deployable source**, and `code/src/` is the only place it lives. A project has
one surface always, and a second only if it opted in:

| Surface    | Path          | Standards                                                     |
| ---------- | ------------- | ------------------------------------------------------------- |
| **Web**    | `src/django/` | The `docs/` guides below — the default reading of every rule  |
| **Mobile** | `src/mobile/` | The same `docs/` tree, plus the React Native technique guides |

The mobile app is placed **inside `code/src/`, beside the Django project**, rather than as a
fifth root layer. That keeps this layer's definition intact — the other three root layers
(`how-to/`, `project-management/`, `.claude/`) hold documentation and process, never source —
and, more importantly, keeps **one `docs/` tree for both surfaces** so web and mobile standards
cannot drift into separate doctrines. A parallel `mobile/docs/` was rejected for exactly that
reason. Definitions and the full rationale: `code/src/CONTEXT.md` → _Surfaces_.

## Global constraints

These apply to every file in `code/src/`:

- **File length:** 750 lines maximum (800 with grace) — split into modules beyond that
- **Coverage floors:** 75% line and branch, 90% for auth-related code (one floor — template and
  HTMX tests are pytest tests and count towards it)
- **Never read:** `node_modules/`, `code/src/django/staticfiles/`, `.git/`
- **New directories:** every new directory in `code/src/` must have a `CONTEXT.md` describing its purpose, contents, and when to use it

Full rules: `code/docs/CODING-PRINCIPLES.md` · `code/docs/TESTING.md`
