---
workflow: 19-api-code
phase: build
agent: backend
skills: [stack-django]
model: opus
---

# API Code (Django Ninja) — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (api-design/NINJA-CONVENTIONS.md, security/AUTH-AND-AUTHZ.md, testing/API-TESTING.md) · **External — Framework & Language Docs → Backend** (Django Ninja) · **External — Testing** for supporting references.

## Execution Checklist

- [ ] `code/docs/api-design/NINJA-CONVENTIONS.md` read — router and Schema design and pagination conventions applied
- [ ] `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` read — endpoints contain no business logic
- [ ] `code/docs/security/AUTH-AND-AUTHZ.md` read — permission and IDOR requirements understood
- [ ] `code/workflows/04-api-design/` followed — Schemas and endpoint signatures agreed before coding
- [ ] Ninja Schemas defined for all request and response shapes
- [ ] Read endpoints return only data the caller is authorised to see
- [ ] All read endpoints apply pagination or result limits — no unbounded queries
- [ ] Every mutating endpoint has an explicit permission check (OWASP A01)
- [ ] Every user-supplied ID verified against caller ownership before use (no IDOR)
- [ ] `code/workflows/08-security-hardening/` run — all security checks passed
- [ ] `code/workflows/02-tdd-cycle/` followed — tests written before implementation (no stubs)
- [ ] Tests cover: authenticated success, unauthenticated rejection, ownership boundaries, invalid input
- [ ] All tests pass against a real implementation
- [ ] Coverage floors met (≥ 75% all modules; ≥ 90% auth-related)
- [ ] `_to_*` mapper functions defined once in the app's `api.py` — imported (not copied) across read and write endpoints, not duplicated per endpoint
- [ ] Every M2M prefetch on a soft-deleting model uses `Prefetch()` with `deleted_at__isnull=True` — not bare `prefetch_related()`
- [ ] Every soft-delete constraint guard checks **all** M2M consumer models, not only the primary one
- [ ] Ninja response Schema exposes all fields that request Schemas accept as writable — no write-only fields
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

- [ ] All Ninja endpoints for the feature are tested and passing
- [ ] No security findings (permission checks and IDOR prevention confirmed)
- [ ] Code committed and pushed
- [ ] Ready for `20-frontend-code/` to consume the API
