---
workflow: 18-backend-code
phase: build
agent: backend
skills: [stack-django]
model: opus
---

# Backend Code — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (coding-principles/PRACTICAL-RULES.md, data-structures/SCHEMA-DESIGN.md, security/AUTH-AND-AUTHZ.md, testing/BACKEND-TESTING.md, testing/COVERAGE.md, encryption/FIELD-ENCRYPTION.md) · **External — Testing** · **External — Code Quality** for supporting references.

## Execution Checklist

- [ ] `code/docs/data-structures/SCHEMA-DESIGN.md` read — model naming and indexing conventions applied
- [ ] `code/docs/coding-principles/PRACTICAL-RULES.md` read — transaction rules and error handling applied
- [ ] `code/docs/security/AUTH-AND-AUTHZ.md` read — permission and ownership checks applied
- [ ] Approved schema document reviewed before any code written
- [ ] `code/workflows/03-database-migration/` followed — migrations generated and applied cleanly
- [ ] `code/workflows/02-tdd-cycle/` followed — tests written before implementation (no stubs)
- [ ] Models match the approved schema exactly
- [ ] PII fields encrypted per `code/docs/encryption/FIELD-ENCRYPTION.md` where applicable
- [ ] RLS applied per `code/docs/rls/MIDDLEWARE-AND-NINJA.md` where applicable
- [ ] Service methods with ≥ 2 writes wrapped in `transaction.atomic()`
- [ ] No inline imports unless unavoidable (documented where used)
- [ ] Exceptions logged at ERROR or WARNING per `code/docs/logging/DJANGO-LOGGING.md` before being swallowed
- [ ] New models registered in Django admin
- [ ] All tests pass against a real implementation
- [ ] Coverage: ≥ 75% all modules; ≥ 90% auth-related code
- [ ] `ruff check` passes — no lint errors
- [ ] `mypy` passes — no type errors

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] All acceptance criteria from the user story are covered by passing tests
- [ ] Code committed and pushed
- [ ] Ready for `19-api-code/` to expose the service layer
