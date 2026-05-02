# Workflow: API Code (GraphQL)

> **Agent hints — Model:** Sonnet · **MCP:** `code-review-graph`, `docfork` + `context7` (Strawberry GraphQL)

## Directory Tree

```text
project-management/workflows/15-api-code/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when writing the Strawberry GraphQL API layer — types, queries, and
mutations that expose backend services to the frontend. Backend models and services must
exist before this workflow begins.

## Prerequisites

- [ ] Backend models and services are implemented and tested
- [ ] User story is understood — which data must be exposed and to whom
- [ ] No breaking schema changes are in-flight on the same app

## Key concepts

- Every mutation must have an explicit permission check (OWASP A01)
- User-supplied IDs must always be verified against the caller's ownership — no IDOR
- Strawberry types live in each app; the root schema is `code/src/backend/apps/core/schema.py`
- GraphQL code generation regenerates frontend TypeScript types after every schema change

## Cross-references

### code/ layer — read before writing any API code

| Path                                 | When to read                                                            |
| ------------------------------------ | ----------------------------------------------------------------------- |
| `code/CONTEXT.md`                    | Django conventions, settings, GraphQL endpoint location                 |
| `code/docs/API-DESIGN.md`            | GraphQL type design, resolver patterns, pagination conventions          |
| `code/docs/ARCHITECTURE-PATTERNS.md` | Service/resolver separation — resolvers must not contain business logic |
| `code/docs/SECURITY.md`              | Permission check patterns, IDOR prevention, OWASP A01 requirements      |

### code/workflows/ — companion workflows to run alongside this one

| Workflow                                | Purpose                                                             |
| --------------------------------------- | ------------------------------------------------------------------- |
| `code/workflows/04-api-design/`         | GraphQL type and resolver design steps — follow before writing code |
| `code/workflows/02-tdd-cycle/`          | Red-green-refactor steps for query and mutation tests               |
| `code/workflows/03-security-hardening/` | Security checklist to run after mutations are implemented           |

### Source locations

- `code/src/backend/apps/core/schema.py` — root Strawberry schema (register new types here)
- `code/src/frontend/src/graphql/generated/` — TypeScript types regenerated after schema changes

### project-management/ — prerequisites and next step

- `project-management/workflows/14-backend-code/` — backend models and services must exist first
- `project-management/workflows/16-frontend-code/` — follow this after the API is tested
