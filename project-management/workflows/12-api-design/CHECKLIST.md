---
workflow: 12-api-design
phase: design
---

# Checklist — API Design

Use this checklist to verify the API design document is complete before sprint planning.

## Prerequisites

- [ ] User story is approved and acceptance criteria are finalised
- [ ] Database schema is signed off for all models touched by this story
- [ ] Security threat model is complete (permission rules sourced from it)

## Types

- [ ] All object types needed by the client are defined
- [ ] All input types are defined (one per mutation)
- [ ] Enums replace any magic-string fields
- [ ] Custom scalars are named and justified

## Queries

- [ ] Every read operation from the acceptance criteria has a query signature
- [ ] Pagination strategy is documented for any list query
- [ ] Nullable return types are explained

## Mutations

- [ ] Every write operation from the acceptance criteria has a mutation signature
- [ ] Each mutation uses a dedicated input type and payload type
- [ ] Mutations with ≥ 2 writes are flagged for `transaction.atomic()`
- [ ] Success and error return shapes are documented

## Subscriptions

- [ ] All real-time operations are defined (or explicitly noted as not needed)
- [ ] Trigger conditions are documented for each subscription

## Permissions

- [ ] Permission matrix is complete — every operation has at least one allowed role
- [ ] Every operation accepting a user-supplied ID has ownership verification noted
- [ ] No operation has open (`*`) access without explicit written justification
- [ ] Anonymous operations are explicitly listed and justified

## Errors

- [ ] Named error types cover all failure paths in the threat model
- [ ] Error table is complete with trigger conditions

## Breaking changes

- [ ] Deprecated fields are marked with `@deprecated` and a removal version noted
- [ ] No existing client query is broken without a migration path documented

## Sign-off

- [ ] Peer review completed by at least one other team member
- [ ] All acceptance criteria from the user story are covered by at least one operation
- [ ] Document saved to `src/12-API-DESIGN/API-US###-<descriptor>.md`
- [ ] User story updated with a reference to this API design document
