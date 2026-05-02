# API Code (GraphQL) — Checklist

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] `code/docs/API-DESIGN.md` read — type design and pagination conventions applied
- [ ] `code/docs/ARCHITECTURE-PATTERNS.md` read — resolvers contain no business logic
- [ ] `code/docs/SECURITY.md` read — permission and IDOR requirements understood
- [ ] `code/workflows/04-api-design/` followed — types and resolver signatures agreed before coding
- [ ] Strawberry types defined for all input and output shapes
- [ ] Queries return only data the caller is authorised to see
- [ ] All queries apply pagination or result limits — no unbounded queries
- [ ] Every mutation has an explicit permission check (OWASP A01)
- [ ] Every user-supplied ID verified against caller ownership before use (no IDOR)
- [ ] `code/workflows/03-security-hardening/` run — all security checks passed
- [ ] `code/workflows/02-tdd-cycle/` followed — tests written before implementation (no stubs)
- [ ] Tests cover: authenticated success, unauthenticated rejection, ownership boundaries, invalid input
- [ ] All tests pass against a real implementation
- [ ] Coverage floors met (≥ 75% all modules; ≥ 90% auth-related)
- [ ] Frontend TypeScript types regenerated after schema changes
- [ ] `ruff check` passes — no lint errors
- [ ] `mypy` passes — no type errors

---

## Definition of Done

- [ ] All GraphQL operations for the feature are tested and passing
- [ ] No security findings (permission checks and IDOR prevention confirmed)
- [ ] Code committed and pushed
- [ ] Ready for `16-frontend-code/` to consume the API
