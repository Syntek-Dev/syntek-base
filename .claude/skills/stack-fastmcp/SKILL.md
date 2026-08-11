---
name: stack-fastmcp
description: >-
  FastMCP tool-surface idioms for <%PROJECT_NAME%> — the MCP server mounted at `/mcp/`
  beside Django Ninja's `/api/`: the Starlette composition in `config/asgi.py`, tools written
  over the service layer, `TokenVerifier` auth with identity taken from the token and never
  from a tool argument, and in-memory `Client` tests. Load this when writing or reviewing
  anything under `apps/**/mcp_tools.py` or `config/mcp.py`, when exposing domain operations to
  an LLM agent, or when a backend/security/test agent needs the canonical MCP idioms.
---

# Stack: FastMCP (<%PROJECT_NAME%>)

Reference material for the **MCP tool surface** — the second adapter over the service layer.
The `backend`, `security`, and `test-writer` agents cite this file so they need not restate
it. It states **how MCP code is shaped here**; `code/docs/MCP-SERVER.md` and its sub-docs own
the _why_, and `code/workflows/05-mcp-server/` is the procedure.

**Status: nothing is mounted at baseline** and `fastmcp` is not a declared dependency — it
sits in the "deliberately NOT declared" register in the root `pyproject.toml`. These are the
conventions a project follows when it builds one.

**Locale:** British English (en_GB) · <%TIMEZONE%> · <%CURRENCY%>.

---

## When to use this skill

Any task touching `config/mcp.py`, `config/asgi.py`'s MCP composition, or
`apps/**/mcp_tools.py` — writing a tool, reviewing one, auditing the surface, or testing it.

**Not** for Django Ninja endpoints (`.claude/skills/stack-django/`) and not for pages
(`.claude/skills/stack-htmx-templates/`). If the caller is an HTTP client rather than an LLM
agent, you are in the wrong skill.

---

## The shape

```text
apps/orders/
├── api.py          ← Ninja Router  → /api/     ┐ two adapters,
├── mcp_tools.py    ← FastMCP tools → /mcp/     ┘ neither calls the other
└── services.py     ← all the logic, called by both
```

`config/mcp.py` is the single assembly point (mirroring `config/api.py`); each app exports
`register(mcp)` rather than decorating a shared import, so an app can be removed without
touching anything else.

---

## The five rules

1. **Identity comes from the verified token, never from a tool argument.** No `user_id`, no
   `account_slug`, no `on_behalf_of`. The caller is a language model that will pass whatever
   value serves its goal — such a parameter _is_ the IDOR, already shipped.
2. **Tools hold no logic.** Authorise, delegate to `services.py`, map the result. Identical to
   the contract `api.py` already has.
3. **Every state-changing tool calls the same named policy as its Ninja twin** — imported, not
   re-implemented. The `.claude/CLAUDE.md` §6 non-negotiable is about the operation, not the
   transport.
4. **The docstring is the contract.** It is the prompt the model reads when choosing to call
   the tool: state what it does, when to use it, what is irreversible, and the exact allowed
   values. A vague docstring is a bug that manifests as wrong actions.
5. **`/mcp/` is outside Django's middleware.** No session, no `login_required`, no CSRF, no
   API rate-limit middleware, no Sentry Django integration. Arrange auth, limits and
   observability inside FastMCP deliberately.

---

## What a tool must never allow

The three error classes reach `/mcp/` from the service layer unchanged — a tool is a peer
adapter over the same services `api.py` calls, so it **inherits the JSON API's row** on the
per-surface table in `code/docs/NEGATIVE-SPACE.md` rather than holding one of its own. Read
that guide before writing a guard or a constraint; it owns what an invariant is, the single
enforcement point, and the taxonomy.

- **A programmer error stays a programmer error at the boundary.** `InvariantViolation` carries
  its register key and surfaces as a tool error; mapping it to an ordinary result is how a
  broken invariant becomes a model's next reasoning step.
- **The guard is in the service, not the tool.** Rule 2 already puts the logic there, and the
  register names one enforcement point — a second copy in `mcp_tools.py` is the second call
  site that register forbids.
- `how-to/src/INVARIANTS.md` — this project's register, where a new guard's row goes.

**This surface has no clause of its own yet.** `MCP-SERVER.md` carries no error-taxonomy
section, so the API row above is the whole of it — write the tool's expression against that
guide and the gap register, not against a section that does not exist.

---

## Idioms

- **Tools are task-shaped, not endpoint-shaped** — `cancel_order_by_reference(...)`, never
  `patch_order(id, payload)`. If the description has to explain the data model, the tool is
  too low level; if two tools are always called together, they are one tool.
- **Keep the surface small.** Every extra tool degrades selection accuracy for all the others.
- **Verb-phrase names in domain vocabulary**, every parameter typed — FastMCP derives the tool
  schema from the annotations.
- **Return plain JSON-serialisable shapes**, never a model instance, ciphertext, HMAC token,
  internal ID, or unmasked PII. Cap every collection return.
- **Do not use `FastMCP.from_openapi()`** over this project's own Ninja API. It yields
  CRUD-shaped tools, re-enters the app over HTTP, turns endpoint summaries into the model's
  instructions, and exposes everything by default. Reconsider only for a third-party API you
  cannot refactor, or a throwaway `/prototype` spike.
- **`stateless_http=True`** on `mcp.http_app()` for any multi-worker deployment, i.e. every
  real one — the default holds session state in one worker's memory.
- **Hoist the FastMCP lifespan** to the outer Starlette app, and initialise Django
  (`get_asgi_application()`) _before_ importing anything that touches a model.
- **Close stale DB connections** either side of ORM access — tool calls are outside the
  request cycle, so `request_finished` never fires. Wrap once in `register()`, and preserve
  `__doc__` through any decorator.

---

## Commands

**Never** run `python`, `manage.py`, `pytest`, `pip`, `uv`, or `docker` directly. Tests,
linting and type-checking all go through the project scripts — `code/src/scripts/tests/*.sh`
and `code/src/scripts/syntax/*.sh` — exactly as for the rest of the backend.

---

## Testing

`fastmcp.Client(mcp)` connects in-process: no network, no running server, real registry and
real dispatch. Cover, at minimum, per tool: **no token → rejected**, **another user's
reference → not found**, and each mutation's policy-denial path. Assert the tool list and
schemas too — an agent client holds the schema the way an HTTP client holds the OpenAPI
document, so a renamed parameter is a breaking change. Auth code (the verifier,
`current_user()`) sits under the **90% coverage floor**.

---

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/19-api-code/` — the PM build phase this surface is entered through
- `project-management/workflows/10-security-checks/` — threat-modelling an agent-facing surface before it ships
- `code/workflows/05-mcp-server/` — adding or changing a tool
- `code/workflows/02-tdd-cycle/` — Red → Green → Refactor for tools
- `code/workflows/08-security-hardening/` — the audit `/mcp/` must pass before public exposure
- `how-to/workflows/03-daily-development/` — running the stack while developing tools

## Cross-references

- `code/docs/MCP-SERVER.md` — the guide, and its `mcp-server/` sub-docs
- `.claude/skills/stack-django/SKILL.md` — the service layer and Ninja adapter this sits beside
- `code/docs/api-design/AUTH-STRATEGY.md` — the API-key scheme the `TokenVerifier` reuses
