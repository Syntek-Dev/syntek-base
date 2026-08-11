# Workflow: Code Review

Reviewing the content of a change and running the merge process are separate jobs with separate
failure modes. Splitting them keeps a green pipeline from being mistaken for a reviewed change.

## Directory Tree

```text
code/workflows/07-review/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when performing a code quality review before raising a PR. This
covers the _content_ of the code — security, patterns, coverage, and coding principles.
For the PR merge process (branch promotion, approvals, gates) use
`project-management/workflows/22-pr-and-review/`.

## Key concepts

What this review is judged against, and where each standard is decided:

- **OWASP A01–A10** is the security baseline; **NIST SP 800-63B** governs authentication,
  password policy and MFA (`code/docs/security/OWASP-AND-CHECKLIST.md`)
- **Named Policy classes** are how a Django Ninja endpoint expresses its permission check, and
  ownership verification is what separates a permission check from an IDOR
  (`code/docs/security/AUTH-AND-AUTHZ.md`)
- **One coverage floor** covers every layer — template and HTMX tests are pytest tests and count
  towards it (`code/docs/testing/COVERAGE.md`)
- **The django-components library is the first place to look** before a new component is written;
  a duplicate is a review finding, not a style preference

Three recurring bites this review exists to catch, each with a non-obvious failure mode:

- A bare `prefetch_related()` on a **soft-deleting M2M** silently returns deleted records in API
  responses; `Prefetch(..., deleted_at__isnull=True)` is what filters them
  (`code/docs/api-design/NINJA-CONVENTIONS.md` — "Soft-Delete Filtering in M2M Prefetches")
- A constraint guard before a destructive operation that checks only the primary M2M consumer
  leaves the others unguarded
- A response Schema narrower than its request Schema makes a field writable and unreadable, which
  no test asserting a round-trip will notice

## Cross-references

### Governing documents

- `code/docs/security/AUTH-AND-AUTHZ.md` — permission and IDOR requirements
- `code/docs/security/OWASP-AND-CHECKLIST.md` — OWASP A01–A10 and NIST SP 800-63B pre-release checklist
- `code/docs/testing/COVERAGE.md` — coverage floors and test philosophy

### Related reading

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
