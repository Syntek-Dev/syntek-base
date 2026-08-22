# Workflow 13 — API Design

The API is a contract other clients hold, so it is decided rather than discovered. Designing it
before implementation is what stops the schema being whatever the first endpoint happened to
return.

## Directory Tree

```text
project-management/workflows/13-api-design/
├── CHECKLIST.md   ← verification checklist before marking complete
├── CLAUDE.md      ← operating rules
├── CONTEXT.md     ← this file (when to use, key concepts, governing documents)
└── STEPS.md       ← ordered steps to execute
```

## Purpose

Design the Django Ninja API contract for a user story or feature during the design phase, before
sprint planning and implementation begin. This workflow produces a signed-off API document that
the backend and frontend teams use as the single source of truth for the interface.

## When to run

**Entry condition: the story's `API` flag is not `N/A`.** The flag is set at
`02-story-creation` from the feature map's slice row, and it means the story introduces a
Ninja endpoint. A story whose `API` flag reads `N/A` skips this gate, and every downstream
checklist reads the flag rather than demanding this gate's artefact unconditionally
(`project-management/docs/planning/CADENCE.md`).

- After `workflows/04-database-schema/` is complete for the relevant models
- Before `workflows/16-sprint-plans/` — the API design informs story point estimates
- Required for every story that introduces or modifies a Django Ninja endpoint or Schema
  model

## Inputs

- Approved user story from `src/02-STORIES/`
- Signed-off database schema from `src/04-DATABASE/`
- Any relevant wireframes from `src/08-WIREFRAMES/`
- Security threat model from `src/10-SECURITY/` (for permission rules)

## Outputs

- `src/13-API-DESIGN/API-US###-<descriptor>.md` — the API design document

## Key decisions covered

1. Ninja Schema models (request/response Pydantic models, enums)
2. Endpoint signatures — router modules, HTTP methods, and paths
3. Webhook definitions (if event-driven behaviour is needed)
4. Permission matrix — which roles can invoke each operation
5. Ownership enforcement — how caller identity is verified (IDOR prevention)
6. Error strategy — exception handlers and named error responses returned to the client
7. Pagination pattern — cursor vs offset, page size limits
8. Breaking-change and deprecation decisions

## Related workflows

| Workflow                        | Relationship                                                                                                                                        |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `04-database-schema`            | Upstream — schema must be agreed first                                                                                                              |
| `10-security-checks`            | Parallel or prior — feeds permission rules                                                                                                          |
| `16-sprint-plans`               | Downstream — API doc informs estimates                                                                                                              |
| `20-api-code`                   | Implementation phase — uses this doc as contract                                                                                                    |
| `code/workflows/04-api-design/` | Code-layer counterpart — expresses this contract as Ninja routers, Schemas, and endpoints; entered **from** `20-api-code`, never directly from here |
| `23-pr-and-review`              | Review gate — API doc checked against implementation                                                                                                |

**Layer split:** this workflow decides the contract (Fable); `code/workflows/04-api-design/`
decides how that contract is expressed in Django Ninja code (Opus). Design here, build there.

## Cross-references

### Governing documents

- `code/docs/api-design/NINJA-CONVENTIONS.md` — design must be convention-compliant; Schema model design, router/endpoint patterns, and pagination conventions
- `code/docs/security/AUTH-AND-AUTHZ.md` — permission matrix must be complete before design is signed off; IDOR prevention and OWASP A01 requirements

### Related reading

- `project-management/docs/SECURITY-GUIDE.md` — STRIDE findings from workflow 09 that inform permission rules
- `project-management/src/04-DATABASE/` — approved schema that the API types must reflect
- `project-management/src/10-SECURITY/` — threat model supplies permission rules
- `code/docs/data-structures/DOMAIN-MODELLING.md` — domain modelling that Ninja Schema models must reflect
- `code/docs/performance/DATABASE-PERFORMANCE.md` — pagination limits, N+1 prevention, and caching decisions at design stage
- `code/docs/api-design/REST-CONVENTIONS.md` — the shared REST/HTTP contract the Ninja API follows: URL structure, HTTP methods, status codes, pagination
- `project-management/workflows/16-sprint-plans/` — downstream workflow; API doc informs estimates
- `code/workflows/04-api-design/` — the code-layer counterpart that implements this contract; it
  names this workflow as its upstream, and is entered from `20-api-code/`
