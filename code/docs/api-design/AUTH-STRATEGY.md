---
type: guide
agent: backend
skills: [stack-django]
model: opus
---

# API Design — Authentication Strategy

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — choosing an auth scheme — session vs opaque token+secret vs JWT — across Django Ninja, DRF, FastAPI

---

This doc owns the **decision**: which authentication scheme belongs on which surface, and the
opaque-token-vs-JWT trade-off. It does not restate mechanics:

- **Transport** (`Authorization: Bearer`, `X-API-Key`, `401` vs `403`, rate-limit defaults) →
  [`./AUTH-AND-ERRORS.md`](./AUTH-AND-ERRORS.md).
- **Crypto primitives + browser token storage** →
  [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md).
- **IDOR scoping, anti-enumeration, session regeneration** →
  [`../security/AUTH-AND-AUTHZ.md`](../security/AUTH-AND-AUTHZ.md).
- **Actor-level mutation gates** →
  [`../architecture/AUTH-CONTRACT.md`](../architecture/AUTH-CONTRACT.md).

---

## Principle

Choose the scheme from three forces, **not** from the framework you happen to be using:

1. **Trust boundary** — does the token cross a process boundary into a service that cannot call the
   issuer? If no, opaque wins. If yes, signed (JWT) earns its keep.
2. **Consumer** — a browser (first-party SPA), a machine (service-to-service), or a third party
   (inbound webhook). Each has a different storage and revocation profile.
3. **Revocation need** — must it die instantly (delete a key) or is expiry acceptable?

A framework never dictates the scheme. The scheme follows the boundary; the framework only provides
the wiring.

---

## Framework responsibility model

One bounded context = one API framework for its primary client surface. Add a second framework only
for a **different consumer** or a **different runtime/deployment boundary** — never re-expose the
same resources through two contracts (that is what blurs the lines).

| Framework              | Owns                                                                                                        | Auth scheme                                                                    | Status                   |
| ---------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | ------------------------ |
| **Django Ninja**       | First-party JSON API — same-origin machine callers and any first-party token client                         | Session cookie ; opaque access token (Bearer) + httpOnly refresh cookie option | **Current**              |
| **Plain Django views** | Machine endpoints the JSON API cannot model — webhook receivers, uploads, health, RSS                       | Per-channel: HMAC signature (webhooks), session (admin)                        | **Current**              |
| **DRF**                | A genuine versioned **public REST product** (many resources + OpenAPI + external consumers)                 | API key + secret, or OAuth2                                                    | Not installed — portable |
| **FastAPI**            | A **separately deployed** service with its own bounded context (e.g. async ingestion / integration gateway) | Short-lived JWT from the core; never mounted in Django                         | Not installed — portable |

**Current reality:** the backend is Django 6 + Django Ninja only. No DRF, no FastAPI, no JWT
library is installed. DRF and FastAPI rows are portable reference for the day a distinct consumer or
a separately deployed service appears.

---

## The schemes and when to use each

| Scheme                              | Use when                                                                           | Avoid when                                                               | Revocation                                         | Where in our stack                                                                          |
| ----------------------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------ | -------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **Session cookie**                  | Same-origin Django pages, HTMX requests, and same-origin JSON; CSRF-protected      | Any cross-origin or third-party API surface                              | Delete server session                              | Every page and HTMX request; built-in Django admin at `/control/` (`SESSION_COOKIE_PATH=/`) |
| **Opaque token + httpOnly refresh** | First-party client → single backend; instant revocation needed; no readable claims | More than one backend must validate the same token without a store hit   | Delete the Valkey key — immediate                  | `AdminAuthService` — access `admin_access:<token>`, refresh `admin_refresh:<token>`         |
| **API key + secret**                | Machine / service-to-service; long-lived credential with a fixed scope             | Browser clients; anything a human pastes into a URL                      | Revoke key row; hashed at rest so leak ≠ use       | Not yet built — portable (inbound integrations)                                             |
| **JWT**                             | A **second** backend must verify access **without** calling the issuer             | Single backend (a store lookup is free); when instant revocation is core | Short TTL + `jti` denylist (no instant kill alone) | Not yet built — enters with the first FastAPI service                                       |
| **HMAC-signed request**             | Inbound third-party webhooks (Mailgun, QuickBooks)                                 | First-party clients you already authenticate                             | Rotate the shared signing secret                   | Webhook receivers — see [`./WEBHOOKS.md`](./WEBHOOKS.md)                                    |

---

## Opaque token vs JWT

Opaque tokens win for **user authentication within a single trust domain**: instantly revocable
(delete the Valkey key), no readable claims to leak, no key distribution. The only cost is a store
lookup (stateful) — and that is free when one backend both issues and validates. This is exactly why
the repo uses opaque tokens, and it is the correct call.

JWT wins **only** as a short-lived access token **across multiple backends**: a second service
verifies the signature without a round-trip to the issuer (stateless). That benefit does not exist
with a single backend.

**The standard hybrid** is short-lived **JWT access token + opaque revocable refresh token**. JWT
legitimately enters this codebase the day a second backend (e.g. a FastAPI service) needs to validate
access locally. Until then, opaque is simpler and strictly safer.

---

## API key + secret lifecycle (machine clients)

For service-to-service or third-party machine clients — a long-lived credential, not a session.

- **Shape:** a public **key id** + a secret. Display a non-secret **prefix** (e.g. `sk_live_a1b2…`)
  so a key is identifiable in logs and UIs without exposing it.
- **Generation:** CSPRNG, ≥ 256-bit entropy via `secrets.token_urlsafe(32)`. See approved primitives
  in [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) (Approved algorithms).
- **Hash at rest:** store **only a hash** of the secret, never plaintext. For a high-entropy random
  secret, a fast `SHA-256` is acceptable (no slow KDF needed — there is nothing to brute-force).
  Compare with constant-time `hmac.compare_digest`.
- **Show once:** return the plaintext secret exactly once at creation; it is unrecoverable after.
- **Scope + rate limit per key:** least-privilege scope and an independent rate limit on every key —
  see [`../security/AUTH-AND-AUTHZ.md`](../security/AUTH-AND-AUTHZ.md) (Authorisation).
- **Rotation with overlap:** issue the replacement, run both for a bounded overlap window, then
  revoke the old — zero-downtime rotation.
- **Immediate revocation:** revoking deletes/disables the row; the next request fails closed.
- **Audit:** log create and revoke (never the secret) per
  [`../security/MONITORING-AND-INCIDENT.md`](../security/MONITORING-AND-INCIDENT.md) (Events that must
  be logged / What must never be logged).

**Contrast with the repo's admin tokens:** those are short-lived **session** tokens in Valkey, fine
as plaintext keys in a trusted store bounded by a 15-min (access) / 7-day (refresh) TTL. A
**long-lived API key has no such TTL**, so it **must** be hashed at rest.

---

## JWT hardening (if/when adopted)

Only relevant once a second backend exists. When it does:

- **Explicit algorithm allowlist; reject `alg: none`.** Never trust the token's own header to choose
  the verification algorithm.
- **Prefer EdDSA (Ed25519) / RS256 / PS256 over HS256** for cross-service — asymmetric keys mean a
  verifier never holds the signing secret. See
  [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) (Approved algorithms — Digital
  signatures).
- **Validate `iss`, `aud`, `exp`, `nbf`, `iat`** on every request; **clock skew ≤ 60s**.
- **Short access TTL + refresh rotation;** keep the refresh token opaque and revocable.
- **`jti` denylist** for revocation before expiry (a signed token cannot be un-issued otherwise).
- **Never put secrets or PII in the payload** — JWT claims are base64, not encrypted.
- **Store in an httpOnly cookie, never `localStorage`** — see
  [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) (Browser Storage Policy).

---

## Per-framework wiring

**Django Ninja (current).** A `SessionAuth` class authenticates same-origin callers from
the Django session; an `HttpBearer` class validates an opaque Bearer token against Valkey and sets
`request.auth` to the staff `User`. Endpoints read `request.auth` and authorise via ABAC
`can_access_module`. State-changing endpoints carry an explicit permission gate following
[`../architecture/AUTH-CONTRACT.md`](../architecture/AUTH-CONTRACT.md) and
[`../security/INPUT-AND-API.md`](../security/INPUT-AND-API.md) (Mutation and query authorisation
(CRITICAL)).

**DRF (portable reference).** Set `DEFAULT_AUTHENTICATION_CLASSES` + `DEFAULT_PERMISSION_CLASSES` in
`REST_FRAMEWORK`; override `authentication_classes` / `permission_classes` per view where a surface
differs.

**FastAPI (portable reference).** Declare the scheme with `Depends()` — `HTTPBearer()` for JWT,
`APIKeyHeader(name="X-API-Key")` for keys — and gate routes with `Security(verify, scopes=[...])`.

---

## Decision checklist

- [ ] Identified the **trust boundary**: single backend → opaque; cross-backend → JWT (hybrid).
- [ ] Identified the **consumer**: browser → httpOnly cookie; machine → API key + secret; third party
      → HMAC signature.
- [ ] Confirmed the **revocation** requirement is met (instant kill vs short TTL + denylist).
- [ ] Long-lived API key secrets are **hashed at rest**, generated with ≥ 256-bit CSPRNG, shown once.
- [ ] No new framework added unless a **different consumer or deployment boundary** justifies it.
- [ ] Transport, status codes, crypto primitive, and storage delegated to the docs that own them
      (cross-references above) — not restated here.

---

## Cross-references

- [`./AUTH-AND-ERRORS.md`](./AUTH-AND-ERRORS.md) — Bearer / `X-API-Key` transport, `401` vs `403`,
  rate-limit defaults.
- [`./REST-CONVENTIONS.md`](./REST-CONVENTIONS.md) — response envelope, status codes, error format.
- [`./WEBHOOKS.md`](./WEBHOOKS.md) — HMAC signing, replay protection, and inbound/outbound webhook
  receivers (the HMAC-signed-request scheme).
- [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) — algorithms, signatures,
  constant-time compare, Browser Storage Policy.
- [`../security/AUTH-AND-AUTHZ.md`](../security/AUTH-AND-AUTHZ.md) — least-privilege, IDOR scoping,
  anti-enumeration, session regeneration.
- [`../security/INPUT-AND-API.md`](../security/INPUT-AND-API.md) — webhook signature verification,
  API endpoint authorisation.
- [`../security/MONITORING-AND-INCIDENT.md`](../security/MONITORING-AND-INCIDENT.md) — what to log on
  key create/revoke; what must never be logged.
- [`../architecture/AUTH-CONTRACT.md`](../architecture/AUTH-CONTRACT.md) — actor-level mutation auth
  gates and audit-log contract.

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
