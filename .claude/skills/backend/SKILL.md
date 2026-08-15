---
name: backend
description: >-
  Build the server side of a <%PROJECT_NAME%> feature — Django models and migrations, the
  service layer holding the business logic, and the two adapters over it: Django Ninja
  endpoints at `/api/` and FastMCP tools at `/mcp/`. Load when a story needs server-side data
  modelling, query and index work, RLS session context, or an API/tool surface implemented.
  Not the UI that consumes it (`frontend`), not designing the schema it builds to
  (`database`), not authoring its tests (`test-writer`), and not root-causing a fault in code
  already shipped (`bugfix`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-django stack-fastmcp
---

# Build the Server Side (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is server-side code).
You own the server half of a feature and hand back; you route to the governing guide rather
than restating it.

**Locale:** British English in comments, docstrings and messages.

---

## The brief arrives settled

A fork has no conversation behind it and **cannot open a grilling pass**, so the design must
already be made. The brief must carry:

- **The approved schema** — `project-management/workflows/04-database-schema/` signed off.
  Never design one here.
- **The API contract**, where endpoints or MCP tools are in scope — the operations, their
  inputs and outputs, the named Policy guarding each state-changing one, and the error shapes.
- **The scope** — which app, which models, and whether `/api/`, `/mcp/`, or both are in play.

**If the schema or the contract is missing, return and say so.** Inventing either turns a
design decision into a commit nobody reviewed. Where the caller wants that design settled
first, the pass is `grilling` — run inline, before this skill is dispatched.

## Remit

- **Data modelling** — `apps/<app>/models/`, relationships with explicit `on_delete`,
  indexes, and constraints in `Meta.constraints`.
- **Migrations** — generated and applied through the scripts, reviewed before they run.
- **Service layer** — the business logic; multi-write methods wrapped in
  `transaction.atomic()`.
- **Django Ninja** — Router modules (`api.py`), `Schema` request/response models, and
  endpoints whose state-changing operations each carry a named Policy check.
- **MCP tools** — `apps/**/mcp_tools.py` over the same service layer, assembled in
  `config/mcp.py`. A **peer adapter to `api.py`, never a layer above it**: identity comes from
  the verified token and never from a tool argument, and every mutation calls the same named
  Policy its Ninja twin calls. The `/mcp/` mount sits **outside Django's middleware**, so
  nothing from the request cycle is present — read `code/docs/MCP-SERVER.md` and load
  `stack-fastmcp` before writing one.
- **Query performance** — kill N+1s with `select_related` / `prefetch_related`; add indexes
  for the query shapes that actually run.
- **RLS and PII** — the session-context middleware and the field-encryption pipeline below.

## Before you write code

1. **Reuse first, create second.** Use `code-review-graph` (or Grep/Glob) to find the existing
   models, managers, query scopes, services, validators and Policy classes. Copy-pasted query
   logic, duplicated validation, or a permission check repeated across endpoints are all
   defects — extract a shared manager, service method or Policy instead.
2. **Read the target directory's `CONTEXT.md`** before working in it.
3. **Check the data-layer pre-flight rules** (`code/docs/DATABASE.md`) — scope columns,
   database-level constraints, lock-safe migration shape, and the deferred-infrastructure
   register with its trigger conditions.

## Row-level security

The backend sets RLS session context before queries run: an **RLS context middleware**,
registered after `AuthenticationMiddleware`, issues `SET LOCAL` for the scope session variables
inside the request transaction. **A scoped table reached without that context set is a security
finding.**

Set only the scope variables a policy actually reads, each derived from a field that exists — a
variable written and consumed by nothing reads as isolation while enforcing none. A scope
column, its policy, its supporting index, and the middleware that sets it **ship together**.
Policy conventions: `code/docs/RLS-GUIDE.md`.

## PII on the endpoint

Filter PII fields by permission in the response `Schema`; guard every PII endpoint with a
permission check **plus** an audit-log write; hash for lookup and encrypt for storage through
the Fernet pipeline; never expose a sequential ID — the admin surfaces UUIDs. Patterns:
`code/docs/ENCRYPTION-GUIDE.md`, `code/docs/security/AUTH-AND-AUTHZ.md`.

## Comments and docstrings

Carry the **why** only — the code states the what, and a comment restating a name or the line
below it is deleted rather than reworded. No story, ticket, doc path, person or date in code,
and no `TODO`/`FIXME` (deferred work goes to `DEFERRED.md` / `GAPS.md`).

**The one exception is published interface text.** A Django Ninja endpoint docstring and
`summary` render on the OpenAPI page, and a FastMCP tool docstring **is the prompt the model
reads** — both state the full what (`code/docs/api-design/API-DOCS.md`,
`code/docs/mcp-server/TOOL-DESIGN.md`). Full standard:
`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 4.

## Scripts — never a raw command

```bash
bash code/src/scripts/database/migrate.sh make   # generate migrations
bash code/src/scripts/database/migrate.sh run    # apply migrations
bash code/src/scripts/tests/backend.sh           # run the backend suite
```

Never `python`, `pytest`, `manage.py` or `docker` directly. New Django app →
`bash code/src/scripts/development/new-django-app.sh <app_name>`. Read-only environment
detection, when the stack's state is in doubt: `.claude/plugins/{project,db,env}-tool.py`.

## Definition of done

Migrations reviewed before they were applied and applied cleanly; every state-changing
endpoint and every MCP mutation carries its named Policy check; no user-supplied ID reaches a
query without an ownership check; scoped tables have their policy, index and middleware in
place; the backend suite green; British English throughout.

## Handoff

Report the **file paths** touched or created, what was **reused versus newly shared**, the
**migration order** where several were created, and any **environment variable** added with
its matching `.env.*.example` entry. Then name what is owed next — `test-writer` for coverage,
`frontend` for the UI that consumes this, `database` for schema or index work beyond the
approved design, `code-reviewer` and `qa-tester` before it ships, and `gdpr-mechanics` where a
data-subject right is in play. **Suggest, do not chain**, unless the caller said to.

**Rust-only:** where a hot path or a constant-time comparison belongs in native code, that is
`stack-rust` — it exists only in a project that compiles Rust.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/18-backend-code/` — the build phase that drives this work
- `project-management/workflows/19-api-code/` — the build phase for the Django Ninja layer
- `project-management/workflows/04-database-schema/` — the approved schema, a prerequisite
- `code/workflows/03-database-migration/` — writing and applying the migration
- `code/workflows/04-api-design/` — expressing the contract as routers and Schemas
- `code/workflows/05-mcp-server/` — the FastMCP tool surface at `/mcp/`
- `code/workflows/08-security-hardening/` — permission and RLS hardening
- `code/workflows/02-tdd-cycle/` — implementing against pre-written failing tests
- `project-management/workflows/21-implementation-documentation/` — the closeout before commit
- `how-to/workflows/08-debugging/` — when the stack itself is unhealthy, not the code

## Cross-references

- `code/docs/DATABASE.md` — the data-layer pre-flight rules, read before any model or query
- `code/docs/data-structures/TYPES-PYTHON.md` — records as frozen dataclasses or Ninja schemas,
  `StrEnum` for a closed set, and exhaustive `match` closing on `InvariantViolation`; the rule it
  expresses is `data-structures/TYPES-OVER-DICTIONARIES.md`, whose parse-at-the-boundary clause
  decides where a payload stops being a dictionary — a service method never receives one
- `code/docs/ARCHITECTURE-PATTERNS.md` — the service-layer boundary and module structure
- `code/docs/API-DESIGN.md` — endpoint, Schema and error conventions
- `code/docs/MCP-SERVER.md` — the `/mcp/` surface, its auth model, and what it does not inherit
- `code/docs/security/INPUT-AND-API.md` — boundary validation, throttling, upload hardening
- `code/docs/architecture/CORE-AND-SCALING.md` — the phase-gate and keyset readiness rules
- `code/docs/PERFORMANCE.md` — query optimisation, caching, response-time targets
- `code/docs/BACKEND-CODING-PRINCIPLES.md` — the Django/Python/Celery specifics this builds to
- `code/docs/URL-STRATEGY.md` — the route, slug and endpoint naming a new surface takes
- `code/docs/PROCESS-MODEL.md` — worker class, event loop, and the ORM's sync boundary
- `code/docs/TASK-AUTHORING.md` — the enqueue boundary, idempotency and retries for background work
- `code/docs/MANAGEMENT-COMMANDS.md` — arguments as untrusted input, blast radius, exit codes
- `code/docs/OBJECT-STORAGE.md` — the S3-API adapter contract and presigned-URL rules
