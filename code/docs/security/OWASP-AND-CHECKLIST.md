---
type: guide
agent: security
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Security — OWASP Top 10, Stack-Specific Security, and Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — OWASP Top 10 mitigations, stack-specific hardening, pre-launch security checklist

---

## OWASP Top 10 2025 Mitigations

The [OWASP Top 10:2025](https://owasp.org/Top10/2025/) introduces two new categories (Software
Supply Chain Failures and Mishandling of Exceptional Conditions), consolidates SSRF into Broken
Access Control, and re-ranks several existing categories.

| #            | Category                                  | Mitigation                                                                                                                                                                                             |
| ------------ | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **A01:2025** | **Broken Access Control**                 | RBAC/policy enforcement on every endpoint; scope all queries to authenticated user; validate SSRF targets against allowlists; block requests to private IP ranges                                      |
| **A02:2025** | **Security Misconfiguration**             | Review default framework settings; disable debug mode in production; remove default credentials; harden IaC templates                                                                                  |
| **A03:2025** | **Software Supply Chain Failures**        | Pin dependency versions with lock files; verify package integrity and provenance; scan for malicious packages; secure CI/CD pipelines (see [`SUPPLY-CHAIN.md`](SUPPLY-CHAIN.md))                       |
| **A04:2025** | **Cryptographic Failures**                | Use approved algorithms only (see [`CRYPTO-AND-DATA.md`](CRYPTO-AND-DATA.md)); TLS everywhere; encrypt PII at rest; use memory-hard password hashing; never use MD5, SHA-1, DES, or ECB                |
| **A05:2025** | **Injection**                             | Parameterised queries always; framework validation on all inputs; escape/encode output based on context (HTML, JavaScript, URL, SQL); disable dangerous interpreter features                           |
| **A06:2025** | **Insecure Design**                       | Threat model new features; apply least privilege; security review before launch; use secure design patterns; separate trust boundaries                                                                 |
| **A07:2025** | **Authentication Failures**               | Framework auth with memory-hard hashing; regenerate sessions on login; enforce MFA for admin; implement credential stuffing protection; do not require periodic password changes (per NIST SP 800-63B) |
| **A08:2025** | **Software and Data Integrity Failures**  | Pin dependency versions; verify package integrity; use signed commits; validate CI/CD pipeline integrity; verify webhook signatures                                                                    |
| **A09:2025** | **Security Logging & Alerting Failures**  | Log all auth events, admin actions, and errors; configure alerting for suspicious patterns; ensure logs are immutable (see [`MONITORING-AND-INCIDENT.md`](MONITORING-AND-INCIDENT.md))                 |
| **A10:2025** | **Mishandling of Exceptional Conditions** | Handle all error paths explicitly; fail closed (deny by default); do not leak sensitive data in error messages; test error handling paths including unexpected inputs and resource exhaustion          |

---

## Stack-Specific Security

### Django Stack

**Security settings that must be enabled in staging and production:**

```python
# settings/production.py
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
X_FRAME_OPTIONS = "DENY"
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_BROWSER_XSS_FILTER = True
```

**Never disable CSRF protection on views (or HTMX fragments) that handle state-changing requests.**
Django Ninja endpoints authenticated by session cookie are CSRF-protected — keep it enabled. HTMX
carries the token via `{% csrf_token %}` in the form or an `hx-headers` attribute on `<body>`; the
answer to a failing swap is never `@csrf_exempt`.

**Django Ninja auth — every router carries an `auth=`, every state-changing endpoint an explicit
permission check:**

```python
from ninja import Router
from ninja.security import django_auth

router = Router(auth=django_auth)  # authenticated by default; opt out per-endpoint only explicitly
```

Throttling is applied via Ninja's throttling classes (`AuthRateThrottle` / `AnonRateThrottle`),
keyed on the trusted client IP. See [`INPUT-AND-API.md`](INPUT-AND-API.md) for the per-endpoint
authorisation rule. _(Portable reference: DRF sets a project-wide `DEFAULT_PERMISSION_CLASSES` +
`DEFAULT_THROTTLE_CLASSES`; FastAPI uses dependency-injected auth. This stack uses Django Ninja.)_

**SECRET_KEY:** never hardcode. Load from environment:

```python
import os
SECRET_KEY = os.environ["DJANGO_SECRET_KEY"]  # raises KeyError if not set — intentional
```

**`admin_db` BYPASSRLS usage — strictly controlled:**

`using="admin_db"` routes queries through the BYPASSRLS PostgreSQL role, bypassing all RLS policies.
Authorised call sites are strictly limited (login, password-reset token lookup, and superuser audit
PII resolution). No other file may use `using="admin_db"`. See
[`AUTH-AND-AUTHZ.md`](AUTH-AND-AUTHZ.md) for the full table.

Enforce with a pre-commit hook:

```yaml
- repo: local
  hooks:
    - id: no-admin-db-outside-auth
      name: Prevent admin_db use outside apps.users
      language: pygrep
      entry: 'using\s*=\s*["\']admin_db["\']'
      files: \.py$
      exclude: ^code/src/django/apps/users/(backends|services/password_reset)\.py$
      types: [python]
```

### Browser-side security (server-rendered stack)

Every page is server-rendered Django templates with HTMX and Alpine. There is no client-side
framework and no build step, which removes a large class of frontend vulnerability outright — no
bundle to poison, no `npm` dependency reaching the browser, no client-side routing to bypass. What
remains is markup discipline.

**Never trust client-side data for security decisions.** All authorisation happens on the server,
in the view or Ninja endpoint. An `x-show`, a `disabled` attribute, or a hidden `<div>` is a
presentation choice, never a control: if a user must not perform an action, the server must refuse
it.

**XSS prevention:** Django templates auto-escape by default — never pipe user input through `|safe`
or `mark_safe`. Two stack-specific traps:

```django
{# WRONG — user input interpolated into an Alpine expression is executed as JavaScript #}
<div x-data="{ name: '{{ user.display_name }}' }">

{# CORRECT — pass data as JSON, escaped by Django, parsed by Alpine #}
{{ profile|json_script:"profile-data" }}
<div x-data="{ profile: JSON.parse(document.getElementById('profile-data').textContent) }">
```

An HTMX response is swapped into the DOM as HTML, so **a partial is an XSS surface exactly like a
full page.** Auto-escaping applies to partials too; never assemble a fragment with string
concatenation or `mark_safe` on the way out.

**Environment variables:** nothing is compiled into a browser bundle, so no build-time variable
prefix can leak a secret. Secrets stay in Django settings/env and reach the browser only if a
template prints them — which is a review-gated defect, not a configuration accident.

**Content Security Policy (CSP) — set by the edge:**

There is no Node server, so there is no application middleware generating a per-request nonce. The
CSP header is set by the edge (Nginx) as part of the deploy contract; `'unsafe-inline'` must never
appear in it. Django templates must therefore avoid inline `<script>`/`<style>` entirely: Alpine
reads HTML attributes, HTMX is configured via `<meta name="htmx-config">`, and per-page JavaScript
is an external static file. The edge-enforced header set is catalogued in
[`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`](../../../how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md).

---

## Security Testing Scenarios

Every application must cover these scenarios with automated tests:

| Scenario                                                                              | Test Type          |
| ------------------------------------------------------------------------------------- | ------------------ |
| Unauthenticated access to protected endpoint returns 401                              | Integration        |
| Unauthorised user cannot access another user's resource (IDOR)                        | Integration        |
| Privilege escalation: lower-role user cannot perform higher-role action               | Integration        |
| SQL injection characters in input are rejected or escaped                             | Unit / Integration |
| XSS: script tags in user-provided text are escaped on output                          | Integration / E2E  |
| CSRF token missing returns 403                                                        | Integration        |
| Rate limiting blocks excessive requests                                               | Integration        |
| Malformed request body is rejected by the Ninja Schema (422) before the handler runs  | Integration        |
| Repeated auth attempts trip the per-IP / per-account throttle (credential stuffing)   | Integration        |
| File upload with disallowed MIME type is rejected                                     | Integration        |
| File upload exceeding size limit is rejected                                          | Integration        |
| Tampered ciphertext fails authentication (GCM tag failure)                            | Unit               |
| Expired or revoked token is rejected                                                  | Integration        |
| Error responses do not leak stack traces, file paths, or internal details             | Integration        |
| Application fails closed on unexpected exceptions (denies access, does not fail open) | Integration        |
| SSRF: requests to private/internal IP ranges are blocked                              | Integration        |

---

## Security Checklist

Before deploying or merging any change to staging or production:

- [ ] No secrets, API keys, or credentials in the diff
- [ ] All new endpoints have authentication and authorisation
- [ ] All user-controlled inputs are validated before use
- [ ] All database queries use parameterised statements or the ORM
- [ ] Django templates never pipe user input through `|safe`/`mark_safe`, and no user input is
      interpolated into an Alpine expression (use `|json_script`)
- [ ] Debug mode is disabled in staging and production
- [ ] HTTP security headers are set
- [ ] Dependencies have been audited (`bash code/src/scripts/audits/deps.sh`)
- [ ] Uploaded files are validated, size-limited, and stored outside the webroot
- [ ] Sensitive data is encrypted at rest where required
- [ ] Rate limiting is applied to authentication endpoints
- [ ] Logging does not include passwords, tokens, or PII
- [ ] New cryptographic usage uses only approved algorithms
- [ ] Password hashing uses argon2id (or scrypt/bcrypt per the approved hierarchy)
- [ ] Error handling fails closed — no sensitive data leaked in error responses (A10:2025)
- [ ] Every Django Ninja endpoint validates input via a Schema (Pydantic); every state-changing
      endpoint has an explicit permission check, and the OpenAPI docs at `/api/docs` are
      disabled or auth-gated in production
- [ ] No secrets baked into container images or passed as build arguments
- [ ] New data fields have been classified and controls applied accordingly
- [ ] Security-relevant events are logged with structured format
- [ ] RLS is enabled and forced on all new user-scoped or tenant-scoped tables
- [ ] RLS session context (`app.current_user_id`) is set via `RLSMiddleware` for HTTP requests and
      via `set_rls_context` for Celery tasks
- [ ] RLS policies have been audited with positive, negative, and missing-context tests

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
