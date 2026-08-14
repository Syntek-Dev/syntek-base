---
type: guide
skills: [security, stack-django, stack-fastmcp]
model: opus
---

# MCP Server — Auth & Threat Model

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — token verification, the identity rule, and MCP-specific threats

---

The `/mcp/` mount sits outside Django's middleware ([`MOUNTING.md`](MOUNTING.md) → _The
middleware cliff_). Nothing authenticates a request unless FastMCP does. This document is
where that gets arranged, and it **extends** [`../SECURITY.md`](../SECURITY.md) — it never
relaxes anything there.

## The rule everything else hangs from

> **Identity comes from the verified token. Never from a tool argument.**

A tool parameter is chosen by a language model that is optimising for its current goal, and
that may be steered by content it has read. `get_orders(user_id: int)` is not an
authorisation bug waiting to happen — it _is_ the bug, already shipped. The caller can pass
any integer, and any correct-looking value will be honoured.

```python
# WRONG — the model supplies the identity
@mcp.tool
def get_orders(user_id: int) -> list[dict]:
    return [_to_dict(o) for o in Order.objects.filter(user_id=user_id)]


# CORRECT — the token supplies the identity; the argument only narrows
@mcp.tool
def get_orders(status: str | None = None) -> list[dict]:
    user = current_user()
    return [_to_dict(o) for o in list_orders_for_user(user, status=status)]
```

The same applies to any argument that _is_ an identity in disguise: `account_slug`,
`organisation_id`, `on_behalf_of`, `tenant`. A user-supplied reference to a **record**
(`reference="ORD-1234"`) is fine — provided ownership is verified against the token's user
before use, which is the standing no-IDOR rule (`.claude/CLAUDE.md` §6).

## The verifier

The default is the project's existing opaque API key
([`../api-design/AUTH-STRATEGY.md`](../api-design/AUTH-STRATEGY.md) → _API key + secret
lifecycle_), validated by a custom `TokenVerifier` that resolves it to a Django user.
Reusing that scheme is deliberate: one credential model, one revocation path, one audit trail.

```python
# apps/core/mcp_auth.py
from fastmcp.server.auth import AccessToken, TokenVerifier
from fastmcp.server.dependencies import get_access_token

from apps.core.services import resolve_api_key  # hashed lookup, constant-time compare


class ProjectKeyVerifier(TokenVerifier):
    async def verify_token(self, token: str) -> AccessToken | None:
        record = await resolve_api_key(token)  # None on unknown/revoked/expired
        if record is None:
            return None  # → 401, no detail leaked
        return AccessToken(
            token=token,
            client_id=str(record.user_id),
            scopes=list(record.scopes),
            claims={"user_id": record.user_id},
        )


def current_user():
    """The authenticated Django user for this tool call. Raises if absent."""
    token = get_access_token()
    if token is None:
        raise PermissionError("Authentication required.")
    return get_user_by_id(token.claims["user_id"])
```

`current_user()` **raises** rather than returning `None`. A tool that silently proceeds
unauthenticated is worse than one that fails: the model will report success.

### The escalation path

| Verifier                                   | Use when                                                  | Trigger to move on                            |
| ------------------------------------------ | --------------------------------------------------------- | --------------------------------------------- |
| `StaticTokenVerifier`                      | **Local development only** — fixed tokens, fixed claims   | Anything leaves your machine                  |
| `ProjectKeyVerifier` (above) — **default** | First-party agents; a key the user creates and can revoke | A third party must authenticate its own users |
| `OAuthProxy` + `JWTVerifier`               | Third-party agent clients via an existing OAuth provider  | —                                             |

`StaticTokenVerifier` must be impossible to enable outside local: gate it on the settings
module, not on `DEBUG`, exactly as `API_DOCS_ENABLED` is gated
([`../api-design/NINJA-CONVENTIONS.md`](../api-design/NINJA-CONVENTIONS.md)).

## Authorisation, per tool

Authentication says who is calling. **Authorisation is still per tool**, and scopes are not a
substitute for the domain permission check:

- Every state-changing tool calls the **same named policy** its Ninja twin calls. One
  definition, two adapters — never a re-implementation, which is how the two drift.
- Every user-supplied reference is resolved **through** the caller's own queryset, so a
  reference to someone else's record returns not-found rather than forbidden (no enumeration —
  see [`../security/AUTH-AND-AUTHZ.md`](../security/AUTH-AND-AUTHZ.md)).
- Scope checks (`token.scopes`) gate _categories_ of tool. They are a coarse outer ring, not
  the permission check.

## MCP-specific threats

These are on top of OWASP, not instead of it.

| Threat                                                                                         | Control                                                                                                                                             |
| ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Indirect prompt injection** — data the agent reads instructs it to call a destructive tool   | Never let a tool's _output_ widen a later tool's authority. Destructive tools take an explicit reference the user can recognise, and are logged     |
| **Confused deputy** — the agent is steered into acting for the wrong principal                 | Identity from the token only; no `on_behalf_of` parameter exists to abuse                                                                           |
| **Over-broad surface** — an agent reaches an operation nobody meant to expose                  | Curated hand-written tools, never `from_openapi()` ([`TOOL-DESIGN.md`](TOOL-DESIGN.md)); registration is explicit per app                           |
| **Data exfiltration through tool results** — PII leaves in a response the model then transmits | Return the minimum field set; never raw ciphertext, HMAC tokens, internal IDs, or unmasked PII ([`../ENCRYPTION-GUIDE.md`](../ENCRYPTION-GUIDE.md)) |
| **Unbounded cost / runaway loops** — an agent retries a tool thousands of times                | Per-key rate limiting inside FastMCP (the API middlewares do not cover `/mcp/`); cap every collection return                                        |
| **Token theft** — the key is long-lived and pasted into a client config                        | Hashed at rest, shown once, per-key scope, instant revocation, and an audit event on create/revoke/use-failure                                      |
| **Missing transport security** — streamable HTTP over plaintext                                | HTTPS enforced at the edge; `/mcp/` is never exposed on a plaintext listener                                                                        |

## What to log

Per [`../logging/`](../logging/) and `../security/MONITORING-AND-INCIDENT.md`: log every tool
invocation with the tool name, the resolved user id, the outcome, and the duration. Log every
authentication failure. **Never** log the token, the tool arguments verbatim (they may carry
PII), or the full result payload.

Tool calls are agent-initiated and unattended — the log is frequently the only record that an
action was taken at all, so treat it as an audit trail, not as debug output.

## Checklist

- [ ] A `TokenVerifier` is configured; there is no unauthenticated path to any tool.
- [ ] `StaticTokenVerifier` is impossible outside the local settings module.
- [ ] No tool takes a user, account, tenant, or `on_behalf_of` parameter.
- [ ] Every mutation calls the same named policy as its Ninja twin.
- [ ] Every reference is resolved through the caller's own queryset.
- [ ] Per-key rate limiting exists on `/mcp/`; every collection return is capped.
- [ ] API keys hashed at rest, shown once, revocable, audited.
- [ ] Tool results carry no ciphertext, HMAC token, internal ID, or unmasked PII.
- [ ] Invocation and auth-failure logging in place; no tokens or arguments logged.
- [ ] `/mcp/` reviewed under `code/workflows/08-security-hardening/` before it ships.

_Part of the `code/docs/` documentation family. See [`../MCP-SERVER.md`](../MCP-SERVER.md) for the full index._
