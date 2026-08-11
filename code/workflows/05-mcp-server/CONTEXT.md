# Workflow: MCP Tool Surface (FastMCP)

The MCP surface is a second adapter over the same service layer, not a layer above the API. It
has its own workflow because its threat model differs: the caller is an LLM acting for a user,
so identity comes from the token and never from a tool argument.

## Directory Tree

```text
code/workflows/05-mcp-server/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding or changing the **FastMCP tool surface at `/mcp/`** — the first
mount, a new tool, or a change to an existing tool's signature, docstring, or policy.

Use it only when **an LLM agent must carry out this project's domain operations on a user's
behalf**. It is not the route for "exposing the API to AI": a Django Ninja endpoint is already
callable by anything that speaks HTTP, and a tool surface that mirrors it one-for-one is a
second contract for no new capability. If the caller is an HTTP client, use `04-api-design`.

## Key concepts

- **Two peer adapters, one seam.** `apps/<app>/mcp_tools.py` and `apps/<app>/api.py` both
  delegate to `apps/<app>/services.py`. Neither calls the other; neither holds logic.
- **`config/mcp.py`** is the single assembly point, mirroring `config/api.py`. Each app exports
  `register(mcp)`.
- **`config/asgi.py` becomes a Starlette router** — FastMCP at `/mcp/`, Django at `/`, the
  FastMCP lifespan hoisted to the outer app.
- **The mount is outside Django's middleware.** No session, no `login_required`, no CSRF, no
  API rate limiting, no Sentry Django integration. This is the workflow's defining constraint.
- **Identity comes from the verified token, never a tool argument.** A `user_id` parameter is
  an IDOR by construction — the caller is a language model.
- **The docstring is the contract**, because it is the prompt the model reads when deciding
  whether to call the tool.
- **Tests connect in-process** via `fastmcp.Client(mcp)` — no network, no running server.

## Cross-references

### Governing documents

- `code/docs/mcp-server/TOOL-DESIGN.md` — tool shape, granularity, docstring contract
- `code/docs/mcp-server/AUTH-AND-THREATS.md` — `TokenVerifier`, the identity rule, threat model
- `code/docs/security/AUTH-AND-AUTHZ.md` — the permission and IDOR rules this surface inherits

### Related reading

- `code/docs/mcp-server/MOUNTING.md` — the ASGI composition and session mode (first mount only)
- `code/docs/mcp-server/TESTING-AND-OPS.md` — in-memory client tests, the ORM connection rule
- `code/docs/api-design/AUTH-STRATEGY.md` — the API-key scheme the `TokenVerifier` reuses
- `code/docs/URL-STRATEGY.md` — why `/mcp/` is a sibling of `/api/`, never nested inside it
- `code/workflows/02-tdd-cycle/` — the Red → Green → Refactor cycle tools are built through
- `code/workflows/08-security-hardening/` — the audit `/mcp/` must pass before public exposure
- `project-management/workflows/19-api-code/` — **this workflow is entered from there**
- `project-management/workflows/21-implementation-documentation/` — writes the implementation
  record and refreshes the graph; do not write it here
