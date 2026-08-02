---
type: guide
agent: security
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Security — Input Validation, Django Ninja API Security, File Uploads

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Input validation, Django Ninja API security, file upload hardening

---

## Input Validation and Sanitisation

Assume all external input is hostile until proven otherwise. This includes HTTP request bodies,
query strings, URL parameters, uploaded files, webhook payloads, third-party API responses, and
data from databases that originated from user input.

### Rules

1. **Validate before use.** Reject invalid input at the earliest possible boundary.
2. **Use framework validation.** Declare a Django Ninja `Schema` (Pydantic) for every request body,
   query, and path parameter, or use a Django form for an HTMX-posted form. Browser-side
   constraints (`required`, `type="email"`, `pattern`) are a usability affordance and are never the
   validation.
3. **Allowlist, not blocklist.** Specify what is permitted, not what is forbidden.
4. **Sanitise output, not input.** Do not strip HTML on input; escape it on output.
5. **Validate file uploads:** check MIME type via content inspection, enforce maximum file size,
   store uploads outside the webroot, and scan for malware in production.

---

## API Security

- **Authenticate every endpoint** unless explicitly designed to be public.
- **Rate limit all endpoints**, especially authentication endpoints.
- **Return consistent error shapes.** Do not leak internal details in error responses.
- Set appropriate HTTP security headers on all responses:

| Header                      | Value                                 | Purpose                 |
| --------------------------- | ------------------------------------- | ----------------------- |
| `Content-Security-Policy`   | Restrictive policy                    | Prevents XSS            |
| `X-Content-Type-Options`    | `nosniff`                             | Prevents MIME sniffing  |
| `X-Frame-Options`           | `DENY` or `SAMEORIGIN`                | Prevents clickjacking   |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` | Enforces HTTPS          |
| `Referrer-Policy`           | `strict-origin-when-cross-origin`     | Limits referrer leakage |

- **CORS:** explicitly configure allowed origins. Never use wildcard `*` for authenticated APIs.
- **CSRF protection:** enable CSRF tokens for all state-changing requests.
- **Webhook verification:** always verify webhook signatures. Use constant-time comparison.

### Rate-limit integrity — trusted-proxy client IP

Every per-IP rate limit and IP-keyed audit record must derive the client IP from
`apps.core.utils.get_client_ip` — the **only** module permitted to read `X-Forwarded-For` /
`X-Real-IP` (grep-enforced before PR). Trust is single-hop:

- The forwarded headers are honoured **only** when the TCP peer (`REMOTE_ADDR`) is in
  `settings.TRUSTED_PROXIES`. On a direct connection both `X-Forwarded-For` and `X-Real-IP` are
  attacker-controlled, so they are ignored and `REMOTE_ADDR` is the client IP.
- Forwarded entries are validated with stdlib `ipaddress`; private, loopback, reserved, link-local
  and unspecified addresses are rejected (IPv4 and IPv6) so a spoofed leading entry cannot move the
  rate-limit key.
- `TRUSTED_PROXIES` defaults to `[]` (fail-safe) and is env-var driven — never a hardcoded IP
  literal in a settings file.

Never read `request.META["HTTP_X_FORWARDED_FOR"]` or `REMOTE_ADDR` directly for IP keying — always
delegate to `get_client_ip`, or a forged header re-opens the per-IP bypass.

---

## Django Ninja API Security

The JSON API is served by Django Ninja to machine clients — integrations, webhooks, and any future
mobile app. Pages reach the server through HTMX against Django views instead, but the validation
and authorisation rules below apply identically to both surfaces.

### Input validation via a Ninja Schema

Declare a `Schema` (Pydantic) for every request body, query, and path parameter. Ninja validates
and coerces before the handler runs and returns `422` automatically on invalid input — the handler
only ever sees well-typed data. Constrain fields; do not accept free-form dicts.

```python
from ninja import Router, Schema
from pydantic import Field

router = Router()

class CreateRoleIn(Schema):
    name: str = Field(min_length=1, max_length=100)
    description: str = Field(default="", max_length=500)

class RoleOut(Schema):
    id: int
    name: str
```

### Per-endpoint authorisation (CRITICAL)

The router/operation `auth=` is **authentication** (is there a valid session?), not
**authorisation** (may this caller do this?). **Every state-changing Django Ninja endpoint needs
an explicit permission check.**

**Checklist for every state-changing Ninja endpoint:**

- [ ] The caller is authenticated (router/operation `auth=`)
- [ ] The caller has the required permission for this operation
- [ ] Where a resource ID is supplied by the client, the resolved resource is verified to belong
      to the caller's tenant — never trust a user-supplied ID alone (IDOR prevention)
- [ ] The test suite includes a case where a lower-privilege user is rejected

```python
# WRONG — authenticated, but no permission check
@router.post("/roles", response=RoleOut, auth=django_auth)
def create_role(request, payload: CreateRoleIn):
    return role_service.create_role(payload)

# CORRECT — authentication (auth=) plus an explicit permission check
@router.post("/roles", response=RoleOut, auth=django_auth)
def create_role(request, payload: CreateRoleIn):
    if not check_permission(user=request.auth, scope="permissions.roles", required_level="write"):
        raise PermissionDenied("Insufficient permissions to create roles")
    return role_service.create_role(payload)
```

### Response shaping (field-level authorisation)

Return only the fields the caller may see. Build the response `Schema` from a service that has
already applied per-field visibility, rather than serialising the raw model; a field the caller
must not see is never placed on the response object.

### Throttling

Rate-limit every endpoint via Ninja's throttling (`AuthRateThrottle` / `AnonRateThrottle`, or a
throttling middleware), keyed on the trusted client IP (see `get_client_ip` above). Authentication
endpoints get the strictest limits — this is what closes the credential-stuffing / batched-attempt
surface (repeated login attempts must trip the per-IP and per-account limits, not merely fail).

### OpenAPI docs exposure

Ninja auto-generates an OpenAPI schema and interactive docs at `/api/docs`. Disable or auth-gate
the docs and schema in production — an unauthenticated, machine-readable map of every endpoint is
an information-disclosure surface.

_Portable reference: Django REST Framework and FastAPI enforce the same authentication-vs-
authorisation split and per-endpoint checks; this stack standardises on Django Ninja._

---

## File Upload Security

### Validation

- **Content-type validation via magic bytes.** Do not trust the `Content-Type` header.
- **Allowlist permitted types.** Define an explicit list of accepted MIME types per upload field.
- **Enforce maximum file size** at web server, application, and storage layer.
- **Filename sanitisation.** Generate a random filename (UUID) and store the original as metadata.

### Storage

- **Store uploads outside the webroot.** Serve through an application endpoint that checks authorisation.
- **Use signed URLs for private files.** Generate time-limited, signed delivery URLs (Cloudinary
  supports signed and time-limited URLs for restricted assets).
- **Separate storage from application servers.** This stack delegates media storage and delivery to
  Cloudinary; the Django app never serves raw uploads from its own filesystem (S3/MinIO are
  portable references for the same principle).

### Processing

- **Never execute uploaded files.**
- **Strip metadata from images.** EXIF data can contain GPS coordinates and PII.
- **Scan for malware in production.** Use ClamAV or equivalent.

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
