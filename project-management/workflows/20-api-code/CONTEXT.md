# Workflow: API Code (Django Ninja)

**Last Updated**: <%DATE%>

The API turns approved services into a contract for machine clients. It is a separate phase
from the backend because a permission check and an ownership check live here, at the boundary,
not in the logic beneath it.

## Directory Tree

```text
project-management/workflows/20-api-code/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when writing the Django Ninja API layer — routers, endpoints, and
request/response Schemas that expose backend services to machine clients over
JSON (`/api/*`). Backend models and services must exist before this workflow begins.

## Key concepts

- Every mutating endpoint must have an explicit permission check (OWASP A01)
- User-supplied IDs must always be verified against the caller's ownership — no IDOR
- Ninja routers and Schemas live in each app's `api.py`; the single `NinjaAPI` is defined once in `config/api.py` and mounted at `/api/`
- Consumers read the Ninja JSON directly — the API is Python-typed end to end, so there is no codegen step

## Cross-references

### Governing documents

- `code/docs/api-design/NINJA-CONVENTIONS.md` — router and Schema design, endpoint patterns, pagination conventions
- `code/docs/security/AUTH-AND-AUTHZ.md` — every mutating endpoint requires an explicit permission check (CLAUDE.md Section 6); IDOR prevention and OWASP A01
- `code/docs/testing/COVERAGE.md` — coverage floor thresholds (75% all modules / 90% auth-related) block PR

### Related reading

#### code/ layer

| Path                                               | When to read                                                                          |
| -------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `code/CONTEXT.md`                                  | Django conventions, settings, Ninja API endpoint location                             |
| `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` | Service/endpoint separation — endpoints must not contain business logic               |
| `code/docs/testing/API-TESTING.md`                 | Django Ninja (TestClient) test conventions and coverage floors for API tests          |
| `code/docs/performance/DATABASE-PERFORMANCE.md`    | N+1 prevention in endpoints, pagination limits, and caching patterns                  |
| `code/docs/api-design/AUTH-AND-ERRORS.md`          | Error patterns for endpoint responses (the shared `{code, message, field?}` contract) |

#### code/workflows/ — companion workflows to run alongside this one

| Workflow                                | Purpose                                                            |
| --------------------------------------- | ------------------------------------------------------------------ |
| `code/workflows/04-api-design/`         | Ninja router and Schema design steps — follow before writing code  |
| `code/workflows/02-tdd-cycle/`          | Red-green-refactor steps for read and write endpoint tests         |
| `code/workflows/08-security-hardening/` | Security checklist to run after mutating endpoints are implemented |

#### Source locations

- `code/src/django/config/api.py` — the single `NinjaAPI` (mount new app routers here). **Created by the first endpoint story (Step 2); absent at baseline** (`how-to/src/PROJECT-PATHS.md`). `config/urls.py` will serve it at `/api/` from that point
- `code/src/django/apps/<name>/api.py` — the per-app Ninja `router` (endpoints + Schemas) for the feature

#### project-management/ — what precedes this, and what follows

- `project-management/workflows/19-backend-code/` — backend models and services must exist first
- `project-management/src/13-API-DESIGN/` — the signed-off API design doc being implemented
- `project-management/workflows/21-frontend-code/` — follow this after the API is tested
