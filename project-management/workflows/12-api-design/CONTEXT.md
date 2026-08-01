# Workflow 12 — API Design

## Purpose

Design the Django Ninja API contract for a user story or feature during the design phase, before
sprint planning and implementation begin. This workflow produces a signed-off API document that
the backend and frontend teams use as the single source of truth for the interface.

## When to run

- After `workflows/03-database-schema/` is complete for the relevant models
- Before `workflows/14-sprint-plans/` — the API design informs story point estimates
- Required for every story that introduces or modifies a Django Ninja endpoint or Schema
  model

## Inputs

- Approved user story from `src/01-STORIES/`
- Signed-off database schema from `src/03-DATABASE/`
- Any relevant wireframes from `src/07-WIREFRAMES/`
- Security threat model from `src/09-SECURITY/` (for permission rules)

## Outputs

- `src/12-API-DESIGN/API-US###-<descriptor>.md` — the API design document

## Key decisions covered

1. Ninja Schema models (request/response Pydantic models, enums)
2. Endpoint signatures — router modules, HTTP methods, and paths
3. Webhook definitions (if event-driven behaviour is needed)
4. Permission matrix — which roles can invoke each operation
5. Ownership enforcement — how caller identity is verified (IDOR prevention)
6. Error strategy — exception handlers and named error responses returned to the client
7. Pagination pattern — cursor vs offset, page size limits
8. Breaking-change and deprecation decisions

## Quality gates

- Every state-changing endpoint must have an explicit permission check documented
- User-supplied IDs must have ownership verification noted
- No operation may be left with an open `*` permission
- Design must be reviewed by at least one other team member before sprint planning

## Related workflows

| Workflow                        | Relationship                                                                                                                                        |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `03-database-schema`            | Upstream — schema must be agreed first                                                                                                              |
| `09-security-checks`            | Parallel or prior — feeds permission rules                                                                                                          |
| `14-sprint-plans`               | Downstream — API doc informs estimates                                                                                                              |
| `17-api-code`                   | Implementation phase — uses this doc as contract                                                                                                    |
| `code/workflows/04-api-design/` | Code-layer counterpart — expresses this contract as Ninja routers, Schemas, and endpoints; entered **from** `17-api-code`, never directly from here |
| `20-pr-and-review`              | Review gate — API doc checked against implementation                                                                                                |

**Layer split:** this workflow decides the contract (Fable); `code/workflows/04-api-design/`
decides how that contract is expressed in Django Ninja code (Opus). Design here, build there.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/api-design/NINJA-CONVENTIONS.md` — design must be convention-compliant; Schema model design, router/endpoint patterns, and pagination conventions
- `code/docs/security/AUTH-AND-AUTHZ.md` — permission matrix must be complete before design is signed off; IDOR prevention and OWASP A01 requirements

### Soft references — consult during execution

- `project-management/docs/SECURITY-GUIDE.md` — STRIDE findings from workflow 09 that inform permission rules
- `project-management/src/03-DATABASE/` — approved schema that the API types must reflect
- `project-management/src/09-SECURITY/` — threat model supplies permission rules
- `code/docs/data-structures/DOMAIN-MODELLING.md` — domain modelling that Ninja Schema models must reflect
- `code/docs/performance/DATABASE-PERFORMANCE.md` — pagination limits, N+1 prevention, and caching decisions at design stage
- `code/docs/api-design/REST-CONVENTIONS.md` — the shared REST/HTTP contract the Ninja API follows: URL structure, HTTP methods, status codes, pagination
- `project-management/workflows/14-sprint-plans/` — downstream workflow; API doc informs estimates
- `code/workflows/04-api-design/` — the code-layer counterpart that implements this contract; it
  names this workflow as its upstream, and is entered from `17-api-code/`
