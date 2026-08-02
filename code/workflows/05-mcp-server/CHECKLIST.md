---
workflow: 05-mcp-server
phase: build
agent: backend
skills: [stack-django, stack-fastmcp]
model: opus
---

# MCP Tool Surface — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (MCP-SERVER.md, SECURITY.md, API-DESIGN.md) · **External — Framework & Language Docs → Backend** (FastMCP, Starlette) · **External — Testing** for supporting references.

## Gate

- [ ] An **LLM agent** is genuinely the caller — an HTTP client would not do (else use `04-api-design`) · _fable_

## Mount (first mount only)

- [ ] `fastmcp` added to `pyproject.toml`, lockfile refreshed, register comment removed · _opus_
- [ ] `config/asgi.py` composes both apps; FastMCP lifespan hoisted to the outer Starlette app · _opus_
- [ ] `get_asgi_application()` runs before any import that touches a model · _opus_
- [ ] Django's mount is last (it is a catch-all); `/mcp` redirects to `/mcp/` · _opus_
- [ ] `stateless_http=True`, or a recorded reason it is not · _opus_
- [ ] The mount is gated on an explicit setting, defaulting off outside local · _opus_

## Authentication and authorisation

- [ ] A `TokenVerifier` is configured — there is no unauthenticated path to any tool · _opus_
- [ ] `current_user()` raises when no token is present; it never returns `None` · _opus_
- [ ] `StaticTokenVerifier` is impossible outside the local settings module · _opus_
- [ ] **No tool takes a user, account, tenant, or `on_behalf_of` parameter** · _opus_
- [ ] Every state-changing tool calls the same named Policy as its Ninja twin — imported, not re-implemented · _opus_
- [ ] Every user-supplied reference resolves through the caller's own queryset (no IDOR, no enumeration) · _opus_
- [ ] Per-key rate limiting exists on `/mcp/` — the API middlewares do not cover it · _opus_

## Tools

- [ ] Tools live in `apps/<app>/mcp_tools.py`, registered via `register(mcp)` in `config/mcp.py` · _opus_
- [ ] No business logic in any tool — it authorises, delegates to `services.py`, and maps · _opus_
- [ ] Docstrings state purpose, when to use, what is irreversible, and exact allowed values · _opus_
- [ ] Verb-phrase names in domain vocabulary; every parameter typed · _opus_
- [ ] Task-shaped, not endpoint-shaped; the tool set is as small as it can be · _fable_
- [ ] Returns are JSON-serialisable — no model instances, ciphertext, HMAC tokens, internal IDs, or unmasked PII · _opus_
- [ ] Every collection return is capped · _opus_
- [ ] `FastMCP.from_openapi()` was **not** used over this project's own API · _opus_
- [ ] Stale DB connections closed either side of ORM access; `__doc__` survives any decorator · _opus_

## Tests

- [ ] Per tool: no token → rejected · _opus_
- [ ] Per tool: another user's reference → not found · _opus_
- [ ] Per mutation: the policy-denial path · _opus_
- [ ] Tool list and schemas asserted (a renamed parameter is a breaking change) · _opus_
- [ ] First mount: a test asserts both ASGI mounts resolve · _opus_
- [ ] Coverage floors met — 75% line and branch, **90% on the verifier and `current_user()`** · _opus_
- [ ] All runs went through `code/src/scripts/tests/*.sh`, never raw `pytest` · _opus_

## Operations

- [ ] Sentry sees `/mcp/` (ASGI/Starlette integration, plus capture at the tool boundary) · _opus_
- [ ] Tool name, resolved user, outcome and duration logged; token, raw arguments and full results never logged · _opus_
- [ ] `/mcp/` added to the server/edge contract in `how-to/src/SERVER-ARCHITECTURE/` with proxy buffering **off** · _opus_
- [ ] `code/workflows/08-security-hardening/` run against the surface before public exposure · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `config/CONTEXT.md` route table and `code/docs/URL-STRATEGY.md` updated if the prefix set changed
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` and a `CLAUDE.md` inside it
- [ ] The code-review-graph refreshed alongside the docs (`code-review-graph update`)
