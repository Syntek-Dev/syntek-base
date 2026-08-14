---
type: guide
skills: [backend, stack-django, stack-fastmcp]
model: opus
---

# MCP Server (FastMCP)

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the FastMCP tool surface at `/mcp/`: mounting, tool design, auth, testing

**Status: available but unwired.** `fastmcp` is not a declared dependency and nothing is
mounted at baseline — the same status Django Ninja itself holds (see
[`../src/CONTEXT.md`](../src/CONTEXT.md) → _API layer_). This guide is the design of record
for the day a project needs one; it is written in the present tense because that is what a
project implements when it builds it, not because it exists today.

---

## What this is, and when you need one

The Model Context Protocol (MCP) lets an LLM client — Claude Code, a desktop assistant, an
agent framework — discover and call a server's operations as **tools**. FastMCP is the Python
framework for writing that server.

Build one when **an agent must perform this project's domain operations on a user's behalf**.
Do not build one to "expose the API to AI": a well-described Django Ninja endpoint is already
callable by anything that speaks HTTP, and an MCP server that mirrors it one-for-one is a
second contract to maintain for no new capability.

| You need                                               | Build                   |
| ------------------------------------------------------ | ----------------------- |
| A machine client to read and write resources over HTTP | Django Ninja (`/api/`)  |
| A human to operate the product                         | A Django page (`/`)     |
| An LLM agent to carry out a task, choosing operations  | FastMCP (`/mcp/`)       |
| An LLM agent to read one document you already serve    | Neither — serve the URL |

## The shape in one picture

Ninja and FastMCP are **peer adapters over one service layer**. Neither calls the other, and
neither holds business logic:

```text
                apps/<name>/services.py          ← the one seam; all logic
                    ╱                 ╲
        apps/<name>/api.py       apps/<name>/mcp_tools.py
        Router → /api/           tools → /mcp/
        HTTP + JSON Schema       MCP + tool schema
        machine clients          LLM agents
```

This is the deep-module rule made literal (`.claude/skills/codebase-design`): Ninja alone made
the service layer a _hypothetical_ seam, because one adapter can always be merged back into the
thing it adapts. A second adapter makes it a **real** one. If adding MCP tempts you to move
logic out of `services.py`, the seam was in the wrong place — fix that first.

## Sub-documents

| Document                                                           | Covers                                                                                                                           |
| ------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| [`mcp-server/MOUNTING.md`](mcp-server/MOUNTING.md)                 | The `config/asgi.py` Starlette router, `/mcp/` prefix, the lifespan rule, stateless mode, and what mounting outside Django costs |
| [`mcp-server/TOOL-DESIGN.md`](mcp-server/TOOL-DESIGN.md)           | Writing tools over the service layer — naming, docstrings as contract, return shapes, granularity, why not `from_openapi()`      |
| [`mcp-server/AUTH-AND-THREATS.md`](mcp-server/AUTH-AND-THREATS.md) | `TokenVerifier` over the project API key, the identity-never-an-argument rule, prompt injection, and the MCP threat model        |
| [`mcp-server/TESTING-AND-OPS.md`](mcp-server/TESTING-AND-OPS.md)   | In-memory `Client` tests, coverage floors, logging, the ORM connection rule, deployment and rollout                              |

## The four rules that do not bend

1. **Tools call services. Services hold logic.** A tool validates, authorises, delegates, and
   maps a result — exactly the contract `api.py` already has
   ([`api-design/NINJA-CONVENTIONS.md`](api-design/NINJA-CONVENTIONS.md)).
2. **Identity comes from the token, never from a tool argument.** A tool that accepts
   `user_id` is an IDOR by construction, because the caller is a language model that will
   pass whatever value serves its current goal. See
   [`mcp-server/AUTH-AND-THREATS.md`](mcp-server/AUTH-AND-THREATS.md).
3. **Every state-changing tool carries the same named permission check as its Ninja twin.**
   The non-negotiable in `.claude/CLAUDE.md` §6 is about the _operation_, not the transport.
4. **The mounted app is outside Django's middleware.** No session, no `login_required`, no
   CSRF, no rate-limit middleware. Anything you assumed Django gives you for free must be
   arranged inside FastMCP.

## Cross-references

- [`API-DESIGN.md`](API-DESIGN.md) — the Django Ninja JSON API this surface sits beside
- [`api-design/AUTH-STRATEGY.md`](api-design/AUTH-STRATEGY.md) — the API-key scheme the MCP
  `TokenVerifier` reuses, and the trust-boundary reasoning behind it
- [`SECURITY.md`](SECURITY.md) — OWASP controls; the MCP threat model extends it, never softens it
- [`URL-STRATEGY.md`](URL-STRATEGY.md) — where `/mcp/` sits among the project's prefixes
- [`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) — the
  service layer both adapters depend on
- `code/workflows/05-mcp-server/` — the procedure for adding a tool
- `.claude/skills/stack-fastmcp/SKILL.md` — the idioms loaded on demand

_Part of the `code/docs/` documentation family._
