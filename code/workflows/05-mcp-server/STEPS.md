---
workflow: 05-mcp-server
phase: build
skills: [backend, stack-django, stack-fastmcp]
model: opus
---

# MCP Tool Surface — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                                          |
| ---- | -------------------------------------------------------------------------------- |
| 1    | **Guides in code/docs/** → MCP-SERVER.md (tool design), API-DESIGN.md            |
| 2    | **External — Framework & Language Docs → Backend** → FastMCP, Starlette          |
| 3    | **Guides in code/docs/** → MCP-SERVER.md (auth and threats), SECURITY.md         |
| 4    | **Guides in code/docs/** → MCP-SERVER.md (tool design), ARCHITECTURE-PATTERNS.md |
| 5    | **External — Testing** → pytest, pytest-django                                   |
| 6    | **Guides in code/docs/** → LOGGING.md, MCP-SERVER.md (testing and ops)           |

Steps 2 and 3 are **first-mount only** — skip them when adding a tool to an existing surface.

---

## Steps

### Step 1 — Grill, then Design the Tool Surface

> **↳ New dispatch:** `general-purpose` · **Skill:** `planner` · **Model:** fable · **MCP:** code-review-graph

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and interview
<%DEVELOPER_NAME%>. Settle, in this order:

1. **Is an agent the right caller at all?** If an HTTP client would do, stop — use
   `04-api-design`. This question is the workflow's own gate; do not skip it.
2. **What task does the agent perform**, described the way a user would describe it? Tools are
   task-shaped, not endpoint-shaped.
3. **The smallest tool set that accomplishes it.** Every extra tool degrades the model's
   selection accuracy for all the others.
4. **Per tool:** the exact parameters (none of which may be an identity), the named Policy
   guarding any mutation, what is irreversible, and the return shape.
5. **Who the clients are** — that decides the verifier (project API key by default; OAuth proxy
   only for third-party clients).

Record hard-to-reverse calls as an ADR in `project-management/src/15-DECISIONS/`. Save the design
alongside the story's API design in `project-management/src/13-API-DESIGN/PLANNING/`.

### Step 2 — Mount the Server (first mount only)

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **Also load:** `stack-fastmcp`

Add `fastmcp` to `pyproject.toml` and refresh the lockfile through the normal flow. Create
`config/mcp.py` with the single `FastMCP` instance — built with `mask_error_details=True` and
carrying the `on_call_tool` error middleware — then convert `config/asgi.py` into the Starlette
router per `code/docs/mcp-server/MOUNTING.md`.

Five things that are silent when wrong: the FastMCP **lifespan must be hoisted** to the outer
app; `get_asgi_application()` must run **before** any import that touches a model; the Django
mount is a **catch-all and must be last**; `/mcp` needs a redirect to `/mcp/`; and the router
carries `RequestIDASGIMiddleware`, or a tool call and a page are two records joined by a
timestamp. Set `stateless_http=True` unless you record a reason not to.

Gate the mount on an explicit setting, defaulting off outside local — mounting is a
deploy-time decision, like `API_DOCS_ENABLED`.

### Step 3 — Wire Authentication (first mount only)

> **↳ New dispatch:** `general-purpose` · **Skill:** `security` · **Model:** opus · **Also load:** `stack-fastmcp`

Implement the `TokenVerifier` over the project's existing API-key scheme, resolving a token to
a Django user (`code/docs/mcp-server/AUTH-AND-THREATS.md`). `current_user()` **raises** when no
token is present — never returns `None`, because a tool that proceeds unauthenticated will
report success to the agent.

`StaticTokenVerifier` is local-only and must be gated on the settings module, never on `DEBUG`.
Add per-key rate limiting here: the API rate-limit middlewares do not cover `/mcp/`.

### Step 4 — Write the Tools

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **Also load:** `stack-django`, `stack-fastmcp`

Create or extend `apps/<app>/mcp_tools.py`, exporting `register(mcp)`, and register it in
`config/mcp.py`. Each tool: resolve the user from the token, check the **same named Policy its
Ninja twin checks** (imported, not re-implemented), resolve any user-supplied reference through
the caller's own queryset, delegate to `services.py`, and return a plain JSON-serialisable
shape.

Write the docstring as the contract it is — purpose, when to use it, what is irreversible, the
exact allowed values for every constrained parameter, and the failures the model can recover
from. Cap every collection return.

**No `try/except` in a tool.** The three error classes are classified once, in the `on_call_tool`
middleware; a tool that catches its own service's errors re-decides the taxonomy per tool, which
is the second call site the register forbids. There are no status codes here — FastMCP returns
an error as a result the model reads and acts on
(`code/docs/mcp-server/TOOL-DESIGN.md` → _The error taxonomy on this surface_).

Do **not** reach for `FastMCP.from_openapi()` over this project's own API; the reasoning is in
`code/docs/mcp-server/TOOL-DESIGN.md`.

### Step 5 — Test Through an In-Process Client

> **↳ New dispatch:** `general-purpose` · **Skill:** `test-writer` · **Model:** opus · **Also load:** `stack-fastmcp`

`fastmcp.Client(mcp)` connects with no network and no running server. Three seams are
mandatory per tool, because no Django middleware covers them: **no token → rejected**,
**another user's reference → not found**, and the mutation's **policy-denial path**. Also
assert the tool list and schemas — an agent client holds them the way an HTTP client holds the
OpenAPI document, so a renamed parameter is a breaking change.

On the first mount, add a test that both ASGI mounts resolve. Auth code sits under the **90%**
coverage floor. Run through `code/src/scripts/tests/*.sh`.

### Step 6 — Instrument, then Harden

> **↳ New dispatch:** `general-purpose` · **Skill:** `logging`, then `security` · **Model:** opus

Sentry's Django integration does not see `/mcp/` — add the ASGI/Starlette integration and
capture in the `on_call_tool` middleware, which is the one place that already knows the error's
class, or a failing tool is invisible. Log tool name, resolved user, outcome and duration; never
the token, the raw arguments, or the full result. Tool calls are unattended, so the log is the
audit trail.

Verify the three configuration clauses with `bash code/src/scripts/audits/negative-space.sh` —
they turn on the moment the first `mcp_tools.py` exists.

Then run `code/workflows/08-security-hardening/` against the surface using the checklist in
`code/docs/mcp-server/AUTH-AND-THREATS.md`. Add `/mcp/` to the server/edge contract in
`how-to/src/SERVER-ARCHITECTURE/` with proxy buffering **off** — a buffering proxy turns every
tool call into a timeout.

### Step 7 — Close Out

> **↳ Model:** opus

Update `code/docs/mcp-server/`, `config/CONTEXT.md`'s route table, and `code/docs/URL-STRATEGY.md`
if the prefix set changed; refresh the code-review-graph. The implementation record itself is
written by `project-management/workflows/22-implementation-documentation/` — not here.

**Rollout:** ship read-only tools first, watch the per-tool failure rate (a tool the model calls
then abandons has a docstring problem, not a code problem), then add mutations one at a time.
