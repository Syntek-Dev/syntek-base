---
type: guide
skills: [test-writer, stack-django, stack-fastmcp]
model: opus
---

# MCP Server — Testing & Operations

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — in-memory client tests, the ORM connection rule, observability, rollout

---

## Testing: connect a client in-process

FastMCP's `Client` speaks to a server object directly, with no network and no running process.
That is the whole test strategy — it exercises the real tool registry, the real schemas, and
the real dispatch path, at unit-test speed.

```python
# apps/orders/tests/test_mcp_tools.py
import pytest
from fastmcp import Client

from config.mcp import mcp


@pytest.mark.django_db
async def test_find_orders_returns_only_the_callers_orders(user, other_user, order_factory):
    order_factory(user=user, reference="ORD-1")
    order_factory(user=other_user, reference="ORD-2")

    async with Client(mcp) as client:
        result = await client.call_tool("find_orders", {})

    references = [o["reference"] for o in result.data]
    assert references == ["ORD-1"]
```

Tests run through the project scripts as usual — `code/src/scripts/tests/backend.sh` — and
count towards the same coverage floors as everything else (75% line and branch; **90% for
auth-related code**, which includes the verifier and `current_user()`). See
[`../testing/COVERAGE.md`](../testing/COVERAGE.md).

### What must be covered

| Test                                                     | Why                                                                        |
| -------------------------------------------------------- | -------------------------------------------------------------------------- |
| Every tool with **no token** → rejected                  | The middleware cliff means this is not covered by anything else            |
| Every tool with **another user's reference** → not found | The IDOR case; the highest-value test on this surface                      |
| Every mutation's policy denial path                      | Proves the check is the same one `api.py` enforces                         |
| Tool list and schemas (`client.list_tools()`)            | A renamed or retyped parameter is a breaking change for every agent client |
| `config/asgi.py` — both mounts resolve                   | Route order and lifespan wiring are silent when wrong                      |
| A collection tool's cap                                  | Proves the unbounded-return guard exists                                   |

Assert the **tool list and schemas** deliberately: an agent client holds the tool schema the
way an HTTP client holds the OpenAPI document. Renaming a parameter breaks every configured
client, so treat the schema snapshot as a contract, exactly as the committed
`openapi.json` is treated ([`../api-design/NINJA-CONVENTIONS.md`](../api-design/NINJA-CONVENTIONS.md)).

## The ORM connection rule

Tool calls arrive outside Django's request/response cycle, so nothing closes stale database
connections for you — Django's `request_finished` signal never fires. On a long-lived
connection this surfaces as `InterfaceError: connection already closed` after an idle period,
intermittently, in production only.

Close them explicitly at the boundary. Do it once, in a decorator applied by `register()`,
rather than in every tool:

```python
from asgiref.sync import sync_to_async
from django.db import close_old_connections


def with_db(fn):
    """Wrap a tool so stale connections are reaped either side of ORM access."""

    async def wrapper(*args, **kwargs):
        await sync_to_async(close_old_connections)()
        try:
            return await sync_to_async(fn)(*args, **kwargs)
        finally:
            await sync_to_async(close_old_connections)()

    wrapper.__name__ = fn.__name__
    wrapper.__doc__ = fn.__doc__          # the docstring IS the contract — preserve it
    return wrapper
```

Two traps in that snippet, both worth the comment they carry:

- **Synchronous ORM calls need `sync_to_async`.** A bare ORM call inside an async tool raises
  `SynchronousOnlyOperation`. Prefer writing tools synchronously and wrapping once.
- **`__doc__` must survive the decorator.** FastMCP reads it to build the tool description, so
  a decorator that drops it silently blanks the model's only instructions.

## Observability

Sentry's Django integration does not see `/mcp/` — it hooks Django's request cycle, which this
mount bypasses. Add the ASGI or Starlette integration alongside it, and capture explicitly in
the tool boundary. Otherwise a failing tool is invisible: the agent receives an error, decides
to try something else, and nobody is paged.

Log per [`AUTH-AND-THREATS.md`](AUTH-AND-THREATS.md) → _What to log_: tool name, resolved user,
outcome, duration — never the token, the raw arguments, or the full result. Route it through
the project's existing structured logging ([`../LOGGING.md`](../LOGGING.md)) so MCP activity
lands in the same place as everything else.

Worth a dashboard from day one: **calls per key**, **failure rate per tool**, and **p95
duration per tool**. Agents retry, so a slow tool becomes a load problem faster than a slow
page does.

## Rolling it out

1. **Wire it behind an off switch.** A settings flag decides whether the MCP mount is added at
   all, defaulting off outside local — the same posture as `API_DOCS_ENABLED`. Mounting is a
   deploy-time decision, not a code-change decision.
2. **Ship read-only tools first.** Let real agent traffic show you which task shapes are
   actually requested before anything can mutate state.
3. **Watch the failure rate per tool.** A tool the model calls and then abandons has a
   docstring problem, not a code problem.
4. **Add mutations one at a time**, each with its policy, its audit log, and its test for the
   other-user's-reference case.
5. **Security review before public exposure** — `code/workflows/08-security-hardening/`, using
   the checklist in [`AUTH-AND-THREATS.md`](AUTH-AND-THREATS.md).

## Dependency and version notes

`fastmcp` is **not** declared at baseline; it lives in the "deliberately NOT declared" register
in the root `pyproject.toml` with its trigger. Add it with the feature that needs it, pin it in
`uv.lock` through the normal lockfile flow, and treat the MCP protocol version the way any
wire protocol is treated — a client and server that disagree fail at connection time, so the
pin is load-bearing. FastMCP moves quickly; check its release notes on every upgrade rather
than assuming a minor is safe.

_Part of the `code/docs/` documentation family. See [`../MCP-SERVER.md`](../MCP-SERVER.md) for the full index._
