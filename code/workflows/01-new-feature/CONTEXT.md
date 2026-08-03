# Workflow: Add a New Full-Stack Feature

## Directory Tree

```text
code/workflows/01-new-feature/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding any new capability to the website that requires both backend
(Django) and frontend (Django templates + django-components + HTMX + Alpine) work.

## Prerequisites

- [ ] A user story exists in `project-management/src/02-STORIES/` covering this feature
- [ ] Branch created from `dev`: `us###/feature-name`
- [ ] No blocking items in `/GAPS.md`
- [ ] `.env.dev` is populated and containers are running

## Key concepts

- Business logic lives in Django **services**, not endpoints — keep endpoints thin
- Django Ninja Schema models go in `apps/<app>/schemas.py`, endpoints in `apps/<app>/api.py`
- Pages reach the server through HTMX against Django views; the Ninja JSON API serves machine clients only
- Commit the OpenAPI schema after any Ninja Schema change so CI can diff it for breaking changes

- Frontend components must use the django-components library (`code/src/django/components/`) first —
  check the shared library catalogue before creating any new component. Only build new
  components if nothing in the shared library fits.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/security/AUTH-AND-AUTHZ.md` — every state-changing Django Ninja endpoint must verify permissions (CLAUDE.md §6)
- `code/docs/testing/COVERAGE.md` — coverage floors (75% line and branch / 90% auth) block PR — one floor, not one per layer
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA is non-negotiable on all interactive components (CLAUDE.md §8)
- `code/docs/encryption/FIELD-ENCRYPTION.md` — any PII field must be encrypted before committing

### Soft references — consult during execution

- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **explore playbook**
  (`.claude/skills/explore-codebase.md`): map the affected area structurally before building
- `code/docs/CODING-PRINCIPLES.md` — coding rules (thin index)
- `code/docs/TESTING.md` — test requirements (thin index)
- `code/docs/SECURITY.md` — security rules (thin index)
- `code/docs/API-DESIGN.md` — API design conventions (thin index)
- `code/docs/ARCHITECTURE-PATTERNS.md` — architecture patterns
- `code/docs/RENDERING.md` — rendering strategy: server templates, HTMX partials, Alpine (thin index)
- `code/docs/RESPONSIVE-DESIGN.md` — responsive design (thin index)
- `code/docs/DATA-STRUCTURES.md` — data structures (thin index)
- `code/docs/RLS-GUIDE.md` — row-level security (thin index)
- `code/docs/logging/DJANGO-LOGGING.md` — new features must log security events
- `code/docs/performance/DATABASE-PERFORMANCE.md` — N+1 prevention in new endpoints and services
- `code/docs/cloudinary/CONTEXT.md` — if this feature involves media upload, delivery, or transformation; see the individual SDK docs and invoke the Cloudinary skills at the relevant step
- `code/docs/architecture/CORE-AND-SCALING.md` — readiness invariants (statelessness, keyset, `tenant_id`, async-safe I/O) a new capability must not break; a new route/upload/SSE surface → flag `scale-planner` for the `how-to/src/SERVER-ARCHITECTURE/` edge requirement (soft, non-blocking — anti-forecast)
- `project-management/workflows/21-implementation-documentation/` — **the next workflow after
  this one.** It owns the implementation records, the findings record, the `CONTEXT.md`/`CLAUDE.md`
  closeout, and the code-review-graph refresh — all a hard gate before commit. Never duplicate
  its record formats here.
- `project-management/workflows/22-pr-and-review/` — follows 19; raises and merges the PR, and
  only **verifies** the records 19 wrote
- `project-management/workflows/20-frontend-code/` · `18-backend-code/` · `19-api-code/` — the
  PM-layer build phases that drive this workflow; a story reaches here through them, not directly
