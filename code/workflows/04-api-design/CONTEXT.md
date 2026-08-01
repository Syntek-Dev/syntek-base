# Workflow: Django Ninja API Design

## Directory Tree

```text
code/workflows/04-api-design/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding or modifying the Django Ninja JSON API surface —
new Router modules, Schema request/response models, or endpoints.

## Prerequisites

- [ ] Data model is agreed and documented
- [ ] `code/docs/api-design/NINJA-CONVENTIONS.md` has been read
- [ ] Django backend containers are running

## Key concepts

- Schema request/response models defined in `apps/<app>/schemas.py`
- Endpoints and their Router defined in `apps/<app>/api.py`
- Routers aggregated on the root `NinjaAPI` mounted at `/api/`
- Business logic delegated to `apps/<app>/services.py` — endpoints stay thin
- Django Ninja auto-generates the OpenAPI schema at `/api/docs` — no codegen step needed

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/api-design/NINJA-CONVENTIONS.md` — Router/`api.py` module rule, Schema models, endpoints, error handling, throttling
- `code/docs/security/AUTH-AND-AUTHZ.md` — endpoint permission requirements and IDOR prevention

### Soft references — consult during execution

- `code/docs/api-design/REST-CONVENTIONS.md` — REST URLs, methods, status codes, pagination, versioning
- `code/docs/data-structures/DOMAIN-MODELLING.md` — value objects, enums, aggregates, Schema/type design
- `code/docs/performance/DATABASE-PERFORMANCE.md` — N+1 prevention and query optimisation
- `code/docs/testing/API-TESTING.md` — API tests immediately follow design
- `project-management/workflows/12-api-design/` — PM-layer API design precedes this workflow; the
  signed-off `API-US###-*.md` is the contract this one expresses in code. Contract decided there
  (Fable), code shape decided here (Opus).
- `project-management/workflows/17-api-code/` — **this workflow is entered from there**, not
  directly from `12-api-design/`
- `project-management/workflows/19-implementation-documentation/` — writes the `API-IMPL-US###-*.md`
  record verifying the built API against the contract; do not write it here
