# code — Coding Standards, Patterns & Testing

## Directory Tree

```text
code/
├── CONTEXT.md                       ← this file
├── docs/                            ← coding reference guides
│   ├── ACCESSIBILITY.md
│   ├── API-DESIGN.md
│   ├── ARCHITECTURE-PATTERNS.md
│   ├── CODING-PRINCIPLES.md
│   ├── CONTEXT.md
│   ├── DATA-STRUCTURES.md
│   ├── ENCRYPTION-GUIDE.md
│   ├── LOGGING.md
│   ├── PERFORMANCE.md
│   ├── RLS-GUIDE.md
│   ├── SECURITY.md
│   └── TESTING.md
├── src/                             ← all deployable source code
│   ├── CONTEXT.md
│   ├── backend/                     ← Django 6.0.4 + Strawberry GraphQL
│   │   └── CONTEXT.md
│   ├── docker/                      ← Dockerfiles and Compose files
│   │   └── CONTEXT.md
│   ├── frontend/                    ← Next.js 16.2.4 App Router
│   │   └── CONTEXT.md
│   ├── mobile/                      ← Expo React Native app
│   │   └── CONTEXT.md
│   ├── shared/                      ← Cross-platform UI components, hooks, and utilities
│   │   └── CONTEXT.md
│   ├── logs/                        ← runtime log files (dev/test; all gitignored)
│   │   ├── CONTEXT.md
│   │   ├── .gitignore
│   │   └── .gitkeep
│   └── scripts/                     ← quality scripts (lint, check, format)
│       ├── check.sh
│       ├── CONTEXT.md
│       ├── format.sh
│       ├── lint.sh
│       └── reports/                 ← generated reports (gitignored)
│           ├── CONTEXT.md
│           ├── .gitignore
│           └── .gitkeep
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
    ├── 04-api-design/               ← Strawberry GraphQL schema design
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

- Writing any code in `code/src/backend/` or `code/src/frontend/`
- Designing a new page, feature, or Django app
- Writing or debugging tests (TDD)
- Implementing security or permissions logic
- Designing a Strawberry GraphQL schema or Apollo query
- Reviewing a PR for code quality

## Contents

- `docs/` — Reference guides for all coding disciplines
- `workflows/` — Step-by-step guides for common coding tasks

## Do not use for

- Sprint planning, story creation, PR lifecycle → `project-management/CONTEXT.md`
- Environment setup, daily dev commands → `how-to/CONTEXT.md`

## Key docs

| Guide                           | When to read                                       |
| ------------------------------- | -------------------------------------------------- |
| `docs/CODING-PRINCIPLES.md`     | Before writing any code                            |
| `docs/TESTING.md`               | Before writing tests                               |
| `docs/SECURITY.md`              | Before writing auth, permissions, or any resolver  |
| `docs/API-DESIGN.md`            | Before adding GraphQL types or mutations           |
| `docs/ACCESSIBILITY.md`         | Before building any frontend component             |
| `docs/ARCHITECTURE-PATTERNS.md` | Before designing a new Django app or Next.js route |
| `docs/DATA-STRUCTURES.md`       | Before adding a model or schema change             |
| `docs/LOGGING.md`               | Before adding logging, error tracking, or metrics  |
| `docs/PERFORMANCE.md`           | Before optimising a query or page                  |
| `docs/RESPONSIVE-DESIGN.md`    | Before building any responsive layout or component |
