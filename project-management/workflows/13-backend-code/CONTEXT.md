# Workflow: Backend Code

> **Agent hints — Model:** Sonnet · **MCP:** `code-review-graph`, `docfork` + `context7` (Django, Python)

## Directory Tree

```text
project-management/workflows/13-backend-code/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when implementing Django models, services, and business logic for a
feature. The database schema must be approved before this workflow begins.

## Prerequisites

- [ ] Database schema is approved (`project-management/src/03-DATABASE/`)
- [ ] Migrations are applied and the app is in a clean state
- [ ] User story and acceptance criteria are understood

## Key concepts

- Tests are written before implementation (TDD)
- Service methods that perform ≥ 2 writes must use `transaction.atomic()`
- Backend coverage floor: 75% all modules; 90% for auth-related code
- All commands run via `docker compose exec backend` — never directly

## Cross-references

### code/ layer — read before writing any backend code

| Path                             | When to read                                           |
| -------------------------------- | ------------------------------------------------------ |
| `code/CONTEXT.md`                | Django conventions, settings structure, project layout |
| `code/docs/CODING-PRINCIPLES.md` | Function design, error handling, transaction rules     |
| `code/docs/DATA-STRUCTURES.md`   | Model naming, field conventions, indexing strategy     |
| `code/docs/SECURITY.md`          | Auth, permission checks, IDOR prevention, OWASP rules  |
| `code/docs/LOGGING.md`           | When and how to log at ERROR / WARNING level           |
| `code/docs/ENCRYPTION-GUIDE.md`  | PII field encryption (Fernet) requirements             |
| `code/docs/RLS-GUIDE.md`         | Row-level security patterns for multi-tenant data      |

### code/workflows/ — companion workflows to run alongside this one

| Workflow                                | Purpose                                                  |
| --------------------------------------- | -------------------------------------------------------- |
| `code/workflows/02-tdd-cycle/`          | Red-green-refactor steps for every new service method    |
| `code/workflows/09-database-migration/` | Apply and verify the approved migration in the container |
| `code/workflows/01-new-feature/`        | Full-stack feature checklist that wraps this workflow    |

### project-management/ — prerequisites and next step

- `project-management/workflows/03-database-schema/` — schema must be approved before this workflow
- `project-management/workflows/14-api-code/` — follow this after backend logic is tested
