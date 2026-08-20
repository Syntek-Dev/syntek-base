---
type: guide
skills: [security, stack-django, stack-htmx-templates]
model: opus
---

# Security — Authentication and Authorisation

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Authentication, authorisation, MFA, RBAC, session and IDOR controls

---

## Authentication

> Requirements follow [NIST SP 800-63B](https://pages.nist.gov/800-63-3/sp800-63b.html) and the
> OWASP Authentication Cheat Sheet.

- Use the framework's built-in authentication system. Do not roll your own.
- Passwords must be hashed using a memory-hard algorithm (argon2id preferred, then scrypt, then
  bcrypt). See `security/CRYPTO-AND-DATA.md` for approved algorithms.
- Never store plaintext or reversibly encrypted passwords.
- Enforce strong password requirements: minimum 12 characters, reject common passwords.
- Allow all characters including Unicode and whitespace. Do not silently truncate passwords.
- Implement MFA for admin and privileged user accounts.
- Session tokens must be regenerated on privilege change (login, role change, password reset).
- Implement account lockout or exponential back-off after repeated failed login attempts.
- Upgrade work factors over time when a user authenticates with older settings.

## Authorisation

- Implement RBAC or policy-based authorisation using the framework's built-in tools.
- Apply **least privilege**: every user, role, and API key has only the permissions it needs.
- Authorisation checks must happen on the server — never trust client-side role claims.
- Every Django Ninja endpoint must explicitly declare who can access it (its `auth=` and an
  explicit permission check). A missing check is a bug.
- **IDOR prevention**: always scope queries to the authenticated user's resources.

```python
# WRONG — trusts a user-supplied id
order = Order.objects.get(id=order_id)

# CORRECT — scoped to the authenticated caller
order = Order.objects.get(id=order_id, user=request.auth)
```

_Portable reference: the same pattern applies in any framework — never fetch by a
client-supplied id alone; always constrain the query by the owning user or tenant._

### PII access is its own permission class

Reading personal data, exporting it, and erasing it are three different acts with three
different blast radii, so they are three permissions rather than one `is_staff` check. Every one
of them is permission-gated **and** audit-logged (`code/docs/security/AUDIT-TRAIL.md`). Adapt
the names per model; the shape is what matters:

| Permission          | Scope       | Export | Delete | Typical role  |
| ------------------- | ----------- | ------ | ------ | ------------- |
| `pii.access`        | own PII     | no     | no     | all users     |
| `pii.access.others` | others' PII | no     | no     | support       |
| `pii.export`        | all PII     | yes    | no     | admin, DPO    |
| `pii.delete`        | all PII     | yes    | yes    | admin, DPO    |
| `pii.audit`         | access logs | logs   | no     | security, DPO |

The storage design behind these — which column is hashed for lookup and which is encrypted at
rest — is `code/docs/ENCRYPTION-GUIDE.md`'s; this table is only who may reach it.

### Admin RBAC role management

None of this is built — `code/src/django/apps/` holds `core/` and `health/` only. The
role-management endpoints (create, update, delete, assign) **will be** gated by one canonical
**area-RBAC predicate** — an `_actor_has_permission` in the identity app's admin-member service —
resolving to superuser **or** an active area admin. It **will be** the first statement of every
`AdminRoleService` method (OWASP A01), never re-implemented per call site. Ninja endpoints add
only an authentication check, then translate typed service errors into the response Schema's
error entries (no exception class names leak).

**Privilege-escalation surface — a role can grant module access.** Because a role's
`AdminRolePermission` rows **will feed** the ABAC fallback in `can_access_module`, a role **will
be** an access-granting object. The superadmin-only gate (`gdpr`, `integrations`, `billing`) runs
**before** any role lookup, so a non-superuser can never reach those modules even if a crafted
role lists them — the role's entries for those modules stay inert. Effective access is a
direct `ModulePermission` override first, role fallback second; a direct override always wins.

**No IDOR on the role endpoints.** Roles are platform-global reference data with no per-user
ownership, so the IDOR scoping pattern above does not apply; instead every user-supplied id
(role id, member id) is existence-checked, and the assign endpoint resolves both ids before
writing. `is_system` roles cannot be renamed or deleted via the API.

---

## Anti-Enumeration

Account and resource enumeration allows an attacker to confirm whether users, tenants, or records
exist without authentication. These rules are mandatory for all backend modules.

### Rule: identical responses for "not found" and "forbidden"

All endpoints must return identical error shapes when:

- A record does not exist
- A record exists but the caller lacks permission to access it

The response must always be the same generic `"Access denied."` / `"FORBIDDEN"` regardless of
whether the underlying issue is absence or authorisation.

### Rule: no exception class names in API responses

`type(exc).__name__` must never be used as an API-facing error code. Use a fixed opaque string
(e.g. `"FORBIDDEN"`, `"INVALID_INPUT"`) and log the real exception class server-side.

### Rule: identical response shapes across all authentication outcomes

Login, registration, password reset, MFA, and social auth endpoints must return the same response
shape — same fields, same types — regardless of whether the operation succeeded or failed.

### Rule: social / OIDC callback failures are always generic

Any failure in a social or OIDC callback that could reveal account existence must collapse to a
single `provider_callback_failed` / `oidc_callback_failed` error code.

### Rule: no internal identifiers in FORBIDDEN messages

Permission codes, role names, and other internal taxonomy strings must not appear in API error
messages. The message body must always be a generic string (`"Access denied."`).

---

## Django Security Settings (staging and production)

```python
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
X_FRAME_OPTIONS = "DENY"
SECURE_CONTENT_TYPE_NOSNIFF = True
```

**Django Ninja auth — declare it once, per router, then never leave it off:**

```python
from ninja import Router
from ninja.security import django_auth  # session-cookie auth for the /admin/ area

router = Router(auth=django_auth)  # default: every operation requires an authenticated session


@router.get("/health", auth=None)  # opt a single endpoint out explicitly — never implicitly
def health(request): ...
```

Authentication is the router/operation `auth=`; **authorisation is a separate, explicit check
inside every state-changing handler** (see `INPUT-AND-API.md`). Throttling is applied via Ninja's
throttling classes (`AuthRateThrottle` / `AnonRateThrottle`) or a throttling middleware, keyed on
the trusted client IP.

_Portable reference: on Django REST Framework the equivalent is a project-wide
`DEFAULT_PERMISSION_CLASSES = ["rest_framework.permissions.IsAuthenticated"]` plus
`DEFAULT_THROTTLE_CLASSES`; FastAPI uses dependency-injected auth. This stack uses Django Ninja._

**SECRET_KEY:** never hardcode. Load from environment:

```python
import os

SECRET_KEY = os.environ["DJANGO_SECRET_KEY"]  # raises KeyError if not set — intentional
```

---

## admin_db — strict usage restriction

`admin_db = "admin_db"` (the BYPASSRLS database role alias) bypasses PostgreSQL Row Level Security.

**Authorised call sites (hard limit).** This is a policy, not an inventory: none of the modules
below exists at baseline, and the table is the closed list any implementation is held to.

| Location                                                                      | Reason                                                                                                                                                                                     |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `apps.<%IDENTITY_APP%>.backends` — authentication backend                     | Login must succeed without a current RLS session variable                                                                                                                                  |
| `apps.<%IDENTITY_APP%>.services.password_reset` — reset token lookup          | Reset links arrive without a session                                                                                                                                                       |
| `apps.<%AUDIT_APP%>.services.AuditDecryptionService.resolve` — PII resolution | Superuser incident investigation must resolve another user's encrypted email/username; the default connection's row-security policy restricts the user table to the calling user's own row |
| `apps.<%AUDIT_APP%>.services.gdpr.gdpr_erase` — erasure anonymisation         | Article 17 erasure nulls the identifying columns on every audit row for a subject, across scopes the caller cannot see (`code/docs/security/AUDIT-TRAIL.md`)                               |
| `apps.<%AUDIT_APP%>.tasks` — retention purge                                  | The retention sweep deletes expired rows across every scope, so it cannot run under a caller's row-security session variable (`code/docs/security/AUDIT-TRAIL.md`)                         |

Adding a new `admin_db` call site requires a documented security justification and code review
sign-off from a <%ORG_NAME%> core maintainer. Any grep for `using=admin_db` outside the table above
should trigger a review comment. **This table is the only authoritative list**; no other guide
restates it.

Pre-commit hook pattern to enforce this. The negative lookahead names the same two apps as the
table, and both are rendered from this project's copier answers rather than written literally:

```yaml
- repo: local
  hooks:
    - id: no-admin-db
      name: Unauthorised admin_db usage
      language: pygrep
      entry: 'using\s*=\s*["\']?admin_db["\']?'
      args: ["--negate"]
      files: '^code/src/django/(?!apps/<%IDENTITY_APP%>/(backends|services/password_reset)|apps/<%AUDIT_APP%>/(services|tasks)).*\.py$'
      pass_filenames: true
```

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
