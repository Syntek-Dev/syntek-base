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
│   ├── PERFORMANCE.md               (sub-docs: performance/)
│   ├── RENDERING.md                 (sub-docs: rendering/)
│   ├── RESPONSIVE-DESIGN.md         (sub-docs: responsive/)
│   ├── RLS-GUIDE.md                 (sub-docs: rls/)
│   ├── SECURITY.md                  (sub-docs: security/)
│   ├── TESTING.md                   (sub-docs: testing/)
│   ├── URL-STRATEGY.md
│   └── VISUAL-DESIGN.md             ← visual language: anti-generic layout + {{ORG_NAME}} signature
├── src/                             ← all deployable source code
│   ├── CONTEXT.md
│   ├── django/                      ← the Django project (backend + server-rendered frontend)
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
│   │   ├── syntax/                  ← code quality (lint, type-check, format)
│   │   └── tests/                   ← test suite runners (pytest, Bruno)
│   └── tests/                       ← API integration tests (Bruno collection)
│       └── CONTEXT.md
└── workflows/                       ← step-by-step coding workflows
    ├── CONTEXT.md
    ├── 01-new-feature/              ← full-stack feature development
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 02-tdd-cycle/                ← Red → Green → Refactor
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 03-security-hardening/       ← OWASP security audit and hardening
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 04-api-design/               ← Django Ninja API design
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 05-gdpr-enforcement/         ← GDPR code implementation (encryption, consent, deletion)
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 06-review/                   ← code quality review (OWASP, principles, coverage)
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 07-debug/                    ← code-logic debugging and regression test writing
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 08-refactor/                 ← systematic refactoring without behaviour change
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 09-database-migration/       ← Django model and migration workflow
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    └── 10-debugging-with-logs/      ← debug using local logs, Glitchtip, Loki, Grafana
        ├── CHECKLIST.md
        ├── CONTEXT.md
        └── STEPS.md
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

| Guide                           | When to read                                                     |
| ------------------------------- | ---------------------------------------------------------------- |
| `docs/CODING-PRINCIPLES.md`     | Before writing any code                                          |
| `docs/TESTING.md`               | Before writing tests                                             |
| `docs/SECURITY.md`              | Before writing auth, permissions, or any endpoint                |
| `docs/API-DESIGN.md`            | Before adding Django Ninja endpoints or Schema models            |
| `docs/ACCESSIBILITY.md`         | Before building any frontend component                           |
| `docs/RESPONSIVE-DESIGN.md`     | Before building any frontend component or layout                 |
| `docs/ARCHITECTURE-PATTERNS.md` | Before designing a new Django app or page route                  |
| `docs/DATABASE.md`              | **Before any model, migration, or query** — the pre-flight rules |
| `docs/DATA-STRUCTURES.md`       | Before adding a model or schema change                           |
| `docs/LOGGING.md`               | Before adding logging, error tracking, or metrics                |
| `docs/RENDERING.md`             | Before choosing server vs HTMX vs Alpine for an interaction      |
| `docs/PERFORMANCE.md`           | Before optimising a query or page                                |
| `docs/ENCRYPTION-GUIDE.md`      | Before adding any PII field or storage                           |
| `docs/RLS-GUIDE.md`             | Before adding multi-tenant or row-scoped queries                 |
| `docs/URL-STRATEGY.md`          | Before adding routes, redirects, or slug patterns                |

## Global constraints

These apply to every file in `code/src/`:

- **File length:** 750 lines maximum (800 with grace) — split into modules beyond that
- **Coverage floors:** 75% line and branch, 90% for auth-related code (one floor — template and
  HTMX tests are pytest tests and count towards it)
- **Never read:** `node_modules/`, `code/src/django/staticfiles/`, `.git/`
- **New directories:** every new directory in `code/src/` must have a `CONTEXT.md` describing its purpose, contents, and when to use it

Full rules: `code/docs/CODING-PRINCIPLES.md` · `code/docs/TESTING.md`
