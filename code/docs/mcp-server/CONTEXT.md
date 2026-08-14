# code/docs/mcp-server

Sub-documents for the FastMCP tool surface at `/mcp/` — the second adapter over the service
layer, beside Django Ninja's `/api/`. Covers how it is mounted into the Django ASGI process,
how tools are written and scoped, how callers are authenticated and authorised, and how the
surface is tested and operated.

**Status: available but unwired.** Nothing is mounted at baseline and `fastmcp` is not a
declared dependency — these guides describe what a project implements when it builds one.

## Directory Tree

```text
code/docs/mcp-server/
├── CLAUDE.md           ← operating rules
├── CONTEXT.md          ← this file
├── MOUNTING.md         ← `config/asgi.py` Starlette composition, `/mcp/` prefix, lifespan, session mode
├── TOOL-DESIGN.md      ← Tools over the service layer — naming, the error taxonomy here, docstring contract, granularity
├── AUTH-AND-THREATS.md ← `TokenVerifier`, the identity-never-an-argument rule, MCP threat model
└── TESTING-AND-OPS.md  ← In-memory `Client` tests, the ORM connection rule, observability, rollout
```

## Cross-references

- `code/docs/MCP-SERVER.md` — the index these sub-documents belong to
