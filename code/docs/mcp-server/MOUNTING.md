---
type: guide
agent: backend
skills: [stack-django, stack-fastmcp]
model: opus
---

# MCP Server — Mounting

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the ASGI composition, `/mcp/` prefix, lifespan, and session mode

---

One process, one deployable, one release. The MCP server is **not** a second surface: it shares
the Django runtime, the toolchain, the settings, the database connection pool, and the release
cycle. What it does not share is Django's request path — see _The middleware cliff_ below.

## The composition

`config/asgi.py` stops being a bare Django ASGI application and becomes a Starlette router
with two mounts. This is the whole integration:

```python
"""ASGI entry point.

Two applications share one process: the MCP tool surface at ``/mcp/`` and Django
everywhere else. Route order is load-bearing — the Django mount is a catch-all.
"""

from __future__ import annotations

import os

from django.core.asgi import get_asgi_application
from starlette.applications import Starlette
from starlette.responses import RedirectResponse
from starlette.routing import Mount, Route

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings.dev")

# Django must be initialised before anything imports a model — so before mcp_tools.
django_application = get_asgi_application()

from config.mcp import mcp  # noqa: E402 — import after django.setup()

mcp_application = mcp.http_app(path="/")


async def _mcp_slash(request):
    """Send /mcp to /mcp/ so clients configured either way connect."""
    return RedirectResponse(url="/mcp/", status_code=307)


application = Starlette(
    routes=[
        Route("/mcp", endpoint=_mcp_slash, methods=["GET", "POST", "DELETE"]),
        Mount("/mcp", app=mcp_application),
        Mount("/", app=django_application),
    ],
    lifespan=mcp_application.lifespan,
)
```

### Four things in there are not optional

- **`lifespan=mcp_application.lifespan`.** FastMCP manages its session state in a lifespan
  context. Omit it and the server starts, accepts a connection, and fails on the first tool
  call with an unhelpful session error. If the project later grows its own lifespan, combine
  them with `fastmcp.utilities.lifespan.combine_lifespans` — never drop one.
- **`get_asgi_application()` before importing tools.** Tools import services, services import
  models, and models need the app registry loaded. Import order is the bug you will otherwise
  spend an afternoon on; the `noqa: E402` is deliberate and should carry that comment.
- **Route order.** `Mount("/")` matches everything. Anything below it is dead.
- **The `/mcp` → `/mcp/` redirect.** Streamable HTTP clients disagree about the trailing
  slash. Without the redirect, half of them get a 404 and report "server not found".

## Why `/mcp/` and not `/api/mcp/`

`/api/` is Django Ninja's mount. Nesting MCP inside it implies containment that does not
exist: different protocol, different auth transport, different failure modes, and — decisively
— a different position relative to Django's middleware. A sibling prefix says that honestly.
Add the row to [`../URL-STRATEGY.md`](../URL-STRATEGY.md) when you wire it.

| Prefix      | Surface                 | Middleware           |
| ----------- | ----------------------- | -------------------- |
| `/`         | Marketing pages         | Full Django          |
| `/admin/`   | <%PROJECT_NAME%> admin  | Full Django          |
| `/portal/`  | Client portal           | Full Django          |
| `/control/` | Django's built-in admin | Full Django          |
| `/api/`     | Django Ninja JSON API   | Full Django          |
| `/mcp/`     | FastMCP tool surface    | **None** — see below |

## The middleware cliff

This is the single most important operational fact about the mount, and the reason
[`AUTH-AND-THREATS.md`](AUTH-AND-THREATS.md) exists as its own document.

A request to `/mcp/` is handled by Starlette and never enters Django's middleware chain.
Everything in that chain is therefore **absent**:

| You lose                         | Consequence                                                                   |
| -------------------------------- | ----------------------------------------------------------------------------- |
| `SessionMiddleware`              | No `request.session`, no cookie auth, no `request.user`                       |
| `AuthenticationMiddleware`       | `login_required` and permission decorators are meaningless here               |
| `CsrfViewMiddleware`             | No CSRF protection — and none is wanted; there is no browser form             |
| The API rate-limit middlewares   | `/mcp/` is not rate limited unless FastMCP does it                            |
| `CommonMiddleware`, locale, GZip | No `APPEND_SLASH`, no locale activation, no compression                       |
| Sentry's Django integration      | Errors need explicit capture — see [`TESTING-AND-OPS.md`](TESTING-AND-OPS.md) |

Nothing here is a defect to patch. It is what mounting a peer ASGI app means, and the
alternative — running FastMCP _through_ Django — is not available for a streaming protocol.
The response is to arrange auth, limits and observability inside FastMCP deliberately.

## Session mode: pick before you scale out

`mcp.http_app()` defaults to **stateful** sessions held in the worker's memory. With more than
one Gunicorn worker, a client's second request can land on a worker that has never heard of its
session.

```python
mcp_application = mcp.http_app(path="/", stateless_http=True)
```

| Mode                  | Use when                                              | Cost                                        |
| --------------------- | ----------------------------------------------------- | ------------------------------------------- |
| Stateful (default)    | One worker; local development                         | Breaks silently the moment you add a worker |
| `stateless_http=True` | **Any multi-worker deployment — i.e. every real one** | No server-side session state between calls  |

Set `stateless_http=True` unless you have a specific reason not to, and record the reason.
Sticky sessions at the edge are not that reason: they push a correctness requirement into the
deploy repo, where nobody reading `asgi.py` will find it.

## Serving it

The stack already runs Gunicorn with Uvicorn workers against `config.asgi:application`, so
**no deployment change is required** — the Starlette router is that application. Two things to
check when the MCP surface first ships:

- **The worker class must be the Uvicorn one.** A WSGI worker cannot serve streamable HTTP.
  This is already the case (`code/src/docker/`), but verify rather than assume.
- **The edge must not buffer `/mcp/`.** Streamable HTTP responses stream; a proxy that buffers
  them turns every tool call into a timeout. Proxy buffering, timeouts and the security headers
  for this prefix are set **in the deploy repo, never here** — see
  [`../../../how-to/src/SERVER-ARCHITECTURE/`](../../../how-to/src/SERVER-ARCHITECTURE/), and
  add `/mcp/` to that contract in the same change that mounts it.

## Definition of done for a mount

- [ ] `config/asgi.py` composes both apps, lifespan hoisted, route order correct.
- [ ] `/mcp` redirects to `/mcp/`.
- [ ] `stateless_http=True`, or a recorded reason it is not.
- [ ] `/mcp/` added to [`../URL-STRATEGY.md`](../URL-STRATEGY.md) and to
      `config/CONTEXT.md`'s route table.
- [ ] The server/edge contract in `how-to/src/SERVER-ARCHITECTURE/` names `/mcp/` with
      buffering off.
- [ ] `config/asgi.py` is covered by a test that asserts both mounts resolve.

_Part of the `code/docs/` documentation family. See [`../MCP-SERVER.md`](../MCP-SERVER.md) for the full index._
