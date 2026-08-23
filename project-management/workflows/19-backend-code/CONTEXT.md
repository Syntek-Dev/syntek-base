# Workflow: Backend Code

**Last Updated**: <%DATE%>

The service layer is built first because everything above it — the API, the MCP tools, the
pages — is an adapter over it. Building an adapter first is how business logic ends up in a
view.

## Directory Tree

```text
project-management/workflows/19-backend-code/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when implementing Django models, services, and business logic for a
feature. The database schema must be approved before this workflow begins.

## Key concepts

- Tests are written before implementation (TDD)
- Service methods that perform ≥ 2 writes must use `transaction.atomic()`
- Backend coverage floor: 75% all modules; 90% for auth-related code
- All commands run via the project shell scripts in `code/src/scripts/` — never directly

## Cross-references

### Governing documents

- `code/docs/coding-principles/PRACTICAL-RULES.md` — transaction rules (2+ writes → `atomic()`), DRY, Decision Structuring (Policy/Strategy)
- `code/docs/security/AUTH-AND-AUTHZ.md` — permission and IDOR checks required before any service method; OWASP A01
- `code/docs/testing/COVERAGE.md` — coverage floors (75% all modules / 90% auth-related) block PR
- `code/docs/encryption/FIELD-ENCRYPTION.md` — PII fields must be encrypted before the first commit; AES-256-GCM

### Related reading

#### code/ layer

| Path                                               | When to read                                                                                           |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `code/CONTEXT.md`                                  | Django conventions, settings structure, project layout                                                 |
| `code/docs/coding-principles/STYLE-AND-PROCESS.md` | Error handling, naming, import rules                                                                   |
| `code/docs/data-structures/SCHEMA-DESIGN.md`       | Model naming, field conventions, indexing strategy                                                     |
| `code/docs/logging/DJANGO-LOGGING.md`              | When and how to log at ERROR / WARNING level                                                           |
| `code/docs/rls/MIDDLEWARE-AND-NINJA.md`            | Row-level security patterns for multi-tenant data                                                      |
| `code/docs/testing/BACKEND-TESTING.md`             | TDD rules, pytest setup, and fixture conventions                                                       |
| `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` | Service layer, Policy/Strategy class patterns, module structure                                        |
| `code/docs/performance/DATABASE-PERFORMANCE.md`    | N+1 prevention in the service layer                                                                    |
| `code/docs/data-structures/DOMAIN-MODELLING.md`    | Domain object design conventions                                                                       |
| `code/docs/cloudinary/PYTHON_SDK.md`               | If a service wraps Cloudinary uploads or the admin API — invoke `/cloudinary-docs` before implementing |

#### code/workflows/ — companion workflows to run alongside this one

| Workflow                                | Purpose                                                  |
| --------------------------------------- | -------------------------------------------------------- |
| `code/workflows/02-tdd-cycle/`          | Red-green-refactor steps for every new service method    |
| `code/workflows/03-database-migration/` | Apply and verify the approved migration in the container |
| `code/workflows/01-implement-story/`    | Full-stack feature checklist that wraps this workflow    |

#### project-management/ — what precedes this, and what follows

- `project-management/workflows/04-database-schema/` — schema must be approved before this workflow
- `project-management/workflows/20-api-code/` — follow this after backend logic is tested
- `project-management/src/02-STORIES/` — the story acceptance criteria driving the implementation
