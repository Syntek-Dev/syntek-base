# Workflow: Code Review

## Directory Tree

```text
code/workflows/07-review/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when performing a code quality review before raising a PR. This
covers the _content_ of the code — security, patterns, coverage, and coding principles.
For the PR merge process (branch promotion, approvals, gates) use
`project-management/workflows/22-pr-and-review/`.

## Prerequisites

- [ ] TDD cycle complete — tests are green
- [ ] Linters are clean (`ruff`, ESLint, markdownlint)
- [ ] No known outstanding bugs on this scope

## Key concepts

- OWASP A01–A10 are the security baseline — all must be addressed before a PR is raised
- NIST SP 800-63B governs authentication, password policy, and MFA requirements
- Every state-changing Django Ninja endpoint must verify authentication and permissions explicitly via named Policy classes
- User-supplied IDs must be validated against caller ownership (no IDOR)
- Coverage floor: 75% line and branch (90% auth) — one floor, not one per layer
- No hardcoded secrets, no bare `except:`, no inline imports without documentation

- Frontend PRs must not introduce components that duplicate existing the django-components library ones —
  verify the shared library was checked before each new component was built.

- M2M prefetches on soft-deleting models must use `Prefetch()` with `deleted_at__isnull=True` —
  a bare `prefetch_related()` silently returns deleted records in API responses.
  See `code/docs/api-design/NINJA-CONVENTIONS.md` — "Soft-Delete Filtering in M2M Prefetches".
- Every constraint guard before a destructive operation must check **all** M2M consumer models,
  not just the primary one.
- Django Ninja response Schema models must expose every field that request Schema inputs accept as writable.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/security/AUTH-AND-AUTHZ.md` — permission and IDOR requirements
- `code/docs/security/OWASP-AND-CHECKLIST.md` — OWASP A01–A10 and NIST SP 800-63B pre-release checklist
- `code/docs/testing/COVERAGE.md` — coverage floors and test philosophy

### Soft references — consult during execution

- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **review playbook**
  (`.claude/skills/review-changes.md`): `detect_changes` → `get_affected_flows` →
  `query_graph` tests_for → `get_impact_radius`, run before broad Grep/Glob
- `code/docs/coding-principles/STYLE-AND-PROCESS.md` — code review checklist, error handling, naming, security
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` — service layer and module structure
- `code/docs/architecture/CORE-AND-SCALING.md` — consult the scale-readiness invariants (in-process state, unbounded queries, `tenant_id`, sync-in-async) during the review pass
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — server/HTMX/Alpine interaction boundary rule
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA compliance requirements (thin index)
- `code/docs/responsive/BREAKPOINTS.md` — mobile-first CSS and breakpoint conventions
- `code/docs/performance/DATABASE-PERFORMANCE.md` — N+1 prevention and caching
- `code/docs/performance/FRONTEND-PERFORMANCE.md` — page weight, HTMX tuning, fragment caching
- `code/docs/logging/DJANGO-LOGGING.md` — logging standards and security event requirements
- `code/docs/api-design/NINJA-CONVENTIONS.md` — for API-layer review
- `code/docs/testing/API-TESTING.md` — verifying Django Ninja test coverage
- `code/docs/cloudinary/CONTEXT.md` — when reviewing Cloudinary upload, delivery, or transformation code; invoke `/cloudinary-docs` for Python SDK patterns or `/cloudinary-transformations` for URL syntax
- `project-management/workflows/21-implementation-documentation/` — runs after this review and
  before the PR; it writes the records and refreshes the graph
- `project-management/workflows/22-pr-and-review/` — the subsequent PR merge workflow. **Split of
  duties:** this workflow owns the _content_ review (security, patterns, coverage, principles);
  workflow 21 owns the _process_ (branch promotion, approvals, merge gates) and verifies the
  records. Neither restates the other's checklist.
- `code/workflows/08-security-hardening/` — where any security finding this review raises is fixed
