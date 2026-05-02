# Backend Code — Checklist

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] `code/docs/DATA-STRUCTURES.md` read — model naming and indexing conventions applied
- [ ] `code/docs/CODING-PRINCIPLES.md` read — transaction rules and error handling applied
- [ ] `code/docs/SECURITY.md` read — permission and ownership checks applied
- [ ] Approved schema document reviewed before any code written
- [ ] `code/workflows/09-database-migration/` followed — migrations generated and applied cleanly
- [ ] `code/workflows/02-tdd-cycle/` followed — tests written before implementation (no stubs)
- [ ] Models match the approved schema exactly
- [ ] PII fields encrypted per `code/docs/ENCRYPTION-GUIDE.md` where applicable
- [ ] RLS applied per `code/docs/RLS-GUIDE.md` where applicable
- [ ] Service methods with ≥ 2 writes wrapped in `transaction.atomic()`
- [ ] No inline imports unless unavoidable (documented where used)
- [ ] Exceptions logged at ERROR or WARNING per `code/docs/LOGGING.md` before being swallowed
- [ ] New models registered in Django admin
- [ ] All tests pass against a real implementation
- [ ] Coverage: ≥ 75% all modules; ≥ 90% auth-related code
- [ ] `ruff check` passes — no lint errors
- [ ] `mypy` passes — no type errors

---

## Definition of Done

- [ ] All acceptance criteria from the user story are covered by passing tests
- [ ] Code committed and pushed
- [ ] Ready for `15-api-code/` to expose the service layer
