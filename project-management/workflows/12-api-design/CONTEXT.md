---
workflow: 12-api-design
phase: design
trigger: After database schema is signed off; before sprint planning
output: API-US###-<descriptor>.md in src/12-API-DESIGN/
---

# Workflow 12 — API Design

## Purpose

Design the GraphQL API contract for a user story or feature during the design phase, before
sprint planning and implementation begin. This workflow produces a signed-off API document that
backend, frontend, and mobile teams use as the single source of truth for the interface.

## When to run

- After `workflows/03-database-schema/` is complete for the relevant models
- Before `workflows/13-sprint-plans/` — the API design informs story point estimates
- Required for every story that introduces or modifies a GraphQL type, query, mutation, or
  subscription

## Inputs

- Approved user story from `src/01-STORIES/`
- Signed-off database schema from `src/03-DATABASE/`
- Any relevant wireframes from `src/07-WIREFRAMES/`
- Security threat model from `src/09-SECURITY/` (for permission rules)

## Outputs

- `src/12-API-DESIGN/API-US###-<descriptor>.md` — the API design document

## Key decisions covered

1. GraphQL type definitions (object types, input types, enums, scalars)
2. Query and mutation signatures
3. Subscription definitions (if real-time behaviour is needed)
4. Permission matrix — which roles can invoke each operation
5. Ownership enforcement — how caller identity is verified (IDOR prevention)
6. Error strategy — named error types returned to the client
7. Pagination pattern — relay-style cursor vs offset, page size limits
8. Breaking-change and deprecation decisions

## Quality gates

- Every mutation must have an explicit permission check documented
- User-supplied IDs must have ownership verification noted
- No operation may be left with an open `*` permission
- Design must be reviewed by at least one other team member before sprint planning

## Related workflows

| Workflow             | Relationship                                         |
| -------------------- | ---------------------------------------------------- |
| `03-database-schema` | Upstream — schema must be agreed first               |
| `09-security-checks` | Parallel or prior — feeds permission rules           |
| `13-sprint-plans`    | Downstream — API doc informs estimates               |
| `15-api-code`        | Implementation phase — uses this doc as contract     |
| `18-pr-and-review`   | Review gate — API doc checked against implementation |
