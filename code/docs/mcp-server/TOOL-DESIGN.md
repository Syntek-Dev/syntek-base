---
type: guide
skills: [backend, stack-django, stack-fastmcp]
model: opus
---

# MCP Server — Tool Design

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — writing tools over the service layer: naming, contracts, granularity

---

A tool's caller is a language model choosing between options under uncertainty. That single
fact drives every rule here, and it is why a tool is **not** an endpoint with a different
decorator.

## Where tools live

One module per Django app, beside its Ninja router:

```text
apps/orders/
├── api.py          ← Ninja Router  → /api/
├── mcp_tools.py    ← FastMCP tools → /mcp/
├── services.py     ← the logic both call
└── schemas.py      ← shared Pydantic shapes
```

`config/mcp.py` is the single assembly point, mirroring `config/api.py`:

```python
# config/mcp.py — the one FastMCP server
from fastmcp import FastMCP

from apps.orders.mcp_tools import register as register_orders

mcp = FastMCP(name="<%PROJECT_NAME%>", auth=build_verifier())
register_orders(mcp)
```

Each app exports `register(mcp)` rather than decorating a shared import, so an app can be
removed without editing anything but `config/mcp.py` — the same coupling rule `config/urls.py`
follows.

## The shape of a tool

```python
# apps/orders/mcp_tools.py
from fastmcp import FastMCP

from apps.core.mcp_auth import current_user
from apps.orders.policies import CanCancelOrder
from apps.orders.services import cancel_order, list_orders_for_user


def register(mcp: FastMCP) -> None:
    @mcp.tool
    def find_orders(status: str | None = None, limit: int = 20) -> list[dict]:
        """Find the signed-in customer's orders, newest first.

        Use this before cancelling or amending an order, to obtain its reference.
        Returns at most `limit` orders. `status` filters to one of: pending, shipped,
        cancelled. Omit `status` to see all.
        """
        user = current_user()
        return [_to_dict(o) for o in list_orders_for_user(user, status=status)[:limit]]

    @mcp.tool
    def cancel_order_by_reference(reference: str, reason: str) -> dict:
        """Cancel one of the signed-in customer's orders.

        This cannot be undone and may incur a fee if the order has shipped. Confirm the
        reference with `find_orders` first. `reason` is recorded and shown to staff.
        """
        user = current_user()
        order = CanCancelOrder(user).get_or_raise(reference)   # ownership + permission
        return _to_dict(cancel_order(order, reason=reason))
```

Four things to copy exactly:

1. **No `user_id` parameter.** Identity comes from `current_user()`, which reads the verified
   token. This is the rule from [`AUTH-AND-THREATS.md`](AUTH-AND-THREATS.md) and it is absolute.
2. **A named policy object before any mutation**, resolving the caller's own record from a
   user-supplied reference. Same policy the Ninja endpoint uses — imported, not re-implemented.
3. **No logic in the tool.** It authorises, delegates, maps. Identical to `api.py`.
4. **Plain `dict`/`list` returns.** Return a JSON-serialisable shape, not a model instance.

## The docstring _is_ the contract

For a Ninja endpoint, the OpenAPI description is documentation. For a tool it is the **prompt**
— the only thing the model reads when deciding whether to call it. A vague docstring is a bug
that manifests as the agent doing the wrong thing.

| Write                                                        | Not                            |
| ------------------------------------------------------------ | ------------------------------ |
| What the tool does, in one line, in the user's vocabulary    | The implementation             |
| **When to use it**, and what to call first                   | Nothing (the model will guess) |
| What is irreversible, chargeable, or visible to other people | Nothing                        |
| The exact accepted values for constrained parameters         | "a valid status"               |

Name tools as **verb phrases in the domain's language** — `cancel_order_by_reference`, not
`orders_delete` or `post_order_cancel`. Type every parameter; FastMCP derives the tool schema
from the annotations, so `str | None = None` and a literal set of values do real work.

## Granularity: tasks, not endpoints

The instinct to expose one tool per endpoint produces a surface that is simultaneously too
large to choose from and too small to accomplish anything. Aim instead at **the unit of work a
user would describe**.

| Prefer                                         | Over                                                        |
| ---------------------------------------------- | ----------------------------------------------------------- |
| `find_orders` returning what is needed next    | `list_orders` + `get_order` + `get_order_lines`             |
| `cancel_order_by_reference(reference, reason)` | `patch_order(id, {"status": "cancelled"})`                  |
| One tool that reads and returns a full picture | Three tools the model must chain, each a chance to go wrong |

Two working heuristics: if a tool's description has to explain the data model, it is too low
level; if two tools are _always_ called together, they are one tool. Keep the surface small —
every additional tool degrades selection accuracy for all the others. Ship the three that
matter, not the thirty that exist.

## Why not generate from the Ninja OpenAPI

`FastMCP.from_openapi()` will build a server from `/api/openapi.json` in a few lines, and it is
**not** the default here. Rejected for four reasons:

- **It produces CRUD-shaped tools**, which is exactly the granularity failure above — the
  resource-oriented URL design that makes a good REST API makes a poor tool surface.
- **It re-enters the application over HTTP**, so every call pays a second trip through the
  network stack, Django's middleware and the Ninja auth layer, with a second set of failure
  modes and a second identity to keep aligned.
- **Docstrings become endpoint summaries** written for a developer reading OpenAPI, not
  instructions for a model choosing an action.
- **It exposes the whole API by default.** Every endpoint becomes agent-reachable, and the
  blast radius of adding an endpoint silently includes the MCP surface.

**Trigger to reconsider:** you are bridging a _third-party_ API you do not own and cannot
refactor, or you need a throwaway spike to test whether an agent workflow is viable at all
(`/prototype`). Neither describes this project's own API.

## Resources and prompts

FastMCP also serves **resources** (read-only, addressable content) and **prompts** (reusable
templates). Use a resource when the agent needs a document rather than an action — a policy
page, a schedule, a rendered report. The same rules apply: no identity in the URI, ownership
checked on read.

## Checklist

- [ ] Tool lives in `apps/<name>/mcp_tools.py`, registered via `register(mcp)`.
- [ ] No identity parameter; `current_user()` from the token.
- [ ] Named policy check before every mutation, imported from the same module `api.py` uses.
- [ ] No business logic — delegates to `services.py`.
- [ ] Docstring states purpose, when to use, what is irreversible, and exact allowed values.
- [ ] Verb-phrase name in domain vocabulary; every parameter typed.
- [ ] Task-shaped, not endpoint-shaped; the surface is as small as it can be.
- [ ] Returns a JSON-serialisable shape, never a model instance or ciphertext.

_Part of the `code/docs/` documentation family. See [`../MCP-SERVER.md`](../MCP-SERVER.md) for the full index._
