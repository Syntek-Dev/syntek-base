---
type: guide
skills: [backend, stack-django]
model: opus
---

# API Design — Webhooks

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — secure outbound + inbound webhooks: HMAC signing, replay protection, idempotency, framework receivers

---

## Status and Placement

**Nothing here need be built yet.** This is the design contract to follow when a webhook is added.
Typical webhooks a project of this shape grows into:

| Webhook                                           | Direction |
| ------------------------------------------------- | --------- |
| Payment/accounting confirmation (e.g. QuickBooks) | Inbound   |
| Email events — open/click/bounce (e.g. Mailgun)   | Inbound   |
| Integration gateway                               | Both      |

**Placement rule (non-negotiable).** Webhooks are inbound HTTP `POST` receivers. They belong on
**plain Django views** (the existing repo pattern) or a **separately deployed FastAPI gateway** —
**never** on the Django Ninja JSON API. Django Ninja is the first-party JSON API; a third party
cannot participate in its session/CSRF or first-party token auth, and the receiver needs the **raw**
request body for HMAC verification, which the Ninja/JSON transport would parse into a `Schema`. A
plain Django view exposes `request.body` untouched. This follows the framework-responsibility model
(one bounded context = one framework for its primary client surface).

### Threat model

A webhook endpoint is a public, unauthenticated entry point until proven otherwise. Design against:

| Threat              | Vector                                         | Primary control                               |
| ------------------- | ---------------------------------------------- | --------------------------------------------- |
| Forgery             | Attacker POSTs a fake event                    | HMAC signature over the raw body              |
| Replay              | Attacker re-sends a captured valid request     | Signed-timestamp window + idempotency dedupe  |
| Tampering           | Body altered in transit                        | Signature covers `timestamp + "." + raw_body` |
| DoS / amplification | Huge body, or trusting payload to do DB work   | Body-size cap, verify-then-enqueue            |
| Secret leakage      | Secret logged or committed                     | Encrypted at rest, never logged               |
| SSRF (outbound)     | Attacker-controlled delivery URL hits internal | Allowlist scheme/host on outbound endpoints   |

---

## Outbound Webhooks (we emit)

### Payload design

- **Past-tense event name** that names what happened: `invoice.paid`, `subscription.cancelled`.
- **ISO-8601 UTC timestamp** for when the event occurred (`occurred_at`), distinct from delivery time.
- **Data complete enough to process without a callback.** Include the changed resource so a consumer
  rarely needs to call back to fetch it — but see the high-value re-fetch rule under inbound.
- Stable `id` per event (used by the consumer for idempotency) and an explicit schema `version`.

### Signing

Sign every delivery. Compute `HMAC-SHA256` over the exact string `timestamp + "." + raw_body`, where
`raw_body` is the serialised bytes actually sent. Send it as:

```text
X-Webhook-Signature: t=1718000000,v1=<hex digest>
```

The `t` value binds the signature to a moment so the consumer can enforce a replay window. HMAC
algorithm choice and the constant-time comparison rule are owned by
[`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) — Cryptography and Encryption
Standards (Approved algorithms; Rules). Do not restate them; use HMAC-SHA256.

### Secret management and rotation

- **One secret per endpoint**, generated with a CSPRNG, **encrypted at rest** (never in plaintext
  config). Secrets are never logged — see [`../security/MONITORING-AND-INCIDENT.md`](../security/MONITORING-AND-INCIDENT.md)
  — What must never be logged.
- **Dual-secret rotation.** During a rollover window keep the old and new secret both active and
  sign each delivery with **both** (emit two `v1=` values, or deliver twice). The consumer accepts a
  match against either. Retire the old secret only after the window closes.

### Delivery

- **HTTPS only.** Reject non-`https` delivery URLs. Validate the scheme and host on save and before
  each send to prevent SSRF into internal ranges.
- **Retry with exponential back-off:** up to 5 attempts spread over 24 hours on connection failure or
  a non-2xx response.
- **Disable after N consecutive failures** (e.g. 15) and alert; require manual or verified
  re-enablement.
- **Log every attempt** (endpoint, event id, status, latency, attempt number) — but never the secret
  or signature material.

---

## Inbound Webhooks (we receive)

The receiver is the security-critical half. Apply these controls in order.

1. **Cap the body size before reading.** Enforce a maximum (e.g. 256 KB) and return `413` if
   exceeded — read no further. This blocks memory-exhaustion DoS.
2. **Verify the signature first, over the RAW body, before parsing.** Re-serialising JSON reorders
   keys and changes whitespace, which breaks the HMAC. Verify the bytes exactly as received, then
   parse. Use a **constant-time** compare (`hmac.compare_digest`) — never `==`. The constant-time
   rule and primitive are owned by [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md)
   — Rules, and the API-security framing by [`../security/INPUT-AND-API.md`](../security/INPUT-AND-API.md)
   — API Security.
3. **Replay protection.** Reject if the signed timestamp is outside a tolerance window (±300 s) —
   this caps the replay opportunity. **And** dedupe by the provider event id / idempotency key,
   persisted: if you have already processed that id, return `200` and do nothing. Tolerance alone is
   not enough; an attacker can replay within the window.
4. **IP allowlist where the provider publishes ranges** (e.g. Mailgun, QuickBooks). This is defence
   in depth, not the sole control — IPs change and can be spoofed upstream of TLS termination. The
   signature remains the authentication.
5. **Verify-then-enqueue.** Once verified, return `200` quickly and process **asynchronously**
   (Celery). Never block the response on business logic, and never leak a business-logic error back
   to the provider (it will retry on any non-2xx, amplifying load). A verified-but-unprocessable
   event is logged and `200`-acked, not failed.
6. **Never trust the payload over your own data.** For high-value events (e.g. `payment.confirmed`)
   re-fetch the resource from the provider's API using a stored credential and confirm state before
   acting. The webhook is a notification, not a source of truth.
7. **The receiver is `csrf_exempt`.** The HMAC signature is the authentication; there is no browser
   session and no CSRF token. Authorisation framing: [`../security/AUTH-AND-AUTHZ.md`](../security/AUTH-AND-AUTHZ.md)
   — Authentication.

### Shared verification helper

One framework-agnostic helper does the cryptographic work; every receiver calls it.

```python
import hashlib
import hmac
import time


def verify_webhook(raw_body: bytes, header: str, secret: str, tolerance: int = 300) -> bool:
    """Verify an inbound webhook signature header of the form 't=<unix>,v1=<hex>'."""
    parts = dict(p.split("=", 1) for p in header.split(",") if "=" in p)
    timestamp, received = parts.get("t"), parts.get("v1")
    if not timestamp or not received:
        return False
    if abs(time.time() - int(timestamp)) > tolerance:  # stale or future-dated → replay
        return False
    signed = f"{timestamp}.".encode() + raw_body
    expected = hmac.new(secret.encode(), signed, hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, received)  # constant-time
```

Wrap `int(timestamp)` defensively at the call site; a non-numeric `t` must fail closed.

---

## Framework Receivers

All three wire the same `verify_webhook` helper. The Django Ninja JSON API is intentionally absent —
it parses the body and is the first-party surface, not a third-party receiver.

### Plain Django view — the repo pattern

This is the default and matches existing endpoints such as
`code/src/django/apps/media/views/admin_upload.py`.

```python
@csrf_exempt
@require_POST
def quickbooks_webhook(request):
    if len(request.body) > 256 * 1024:
        return HttpResponse(status=413)
    sig = request.headers.get("X-Webhook-Signature", "")
    if not verify_webhook(request.body, sig, settings.QUICKBOOKS_WEBHOOK_SECRET):
        return HttpResponse(status=401)
    process_quickbooks_event.delay(request.body.decode())  # Celery; return fast
    return HttpResponse(status=200)
```

### DRF `APIView` — portable reference

DRF is **not installed**; this is a portability note for a future public REST product, not our setup.
Set `permission_classes = [AllowAny]` and verify manually — DRF's auth classes do not understand HMAC
signatures, and never let DRF parse the body before you have verified the raw bytes.

### FastAPI async endpoint — portable reference

FastAPI is **not installed**; relevant only if an integration gateway ships as a separately deployed
service. `raw = await request.body()`, verify, then hand off via `BackgroundTasks` or a queue.

---

## Webhook Receiver Security Checklist

- [ ] Endpoint is a plain Django view (or FastAPI gateway), **not** the Ninja JSON API.
- [ ] Body size capped before reading; oversized → `413`.
- [ ] Signature verified over the **raw** body, **before** JSON parsing.
- [ ] Comparison is constant-time (`hmac.compare_digest`), never `==`.
- [ ] Signed timestamp checked against a ±300 s window.
- [ ] Event id / idempotency key persisted and deduped.
- [ ] IP allowlist applied where the provider publishes ranges (defence in depth).
- [ ] Verified, then `200` returned fast; processing is async (Celery).
- [ ] High-value events re-fetched from the provider API before acting.
- [ ] View is `csrf_exempt`; the signature is the authentication.
- [ ] Secret encrypted at rest, dual-secret rotation supported, never logged.

---

## Cross-References

- [`./AUTH-AND-ERRORS.md`](./AUTH-AND-ERRORS.md) — API key / Bearer transport, `401` vs `403`, rate-limit defaults.
- [`./REST-CONVENTIONS.md`](./REST-CONVENTIONS.md) — response envelope, status codes, idempotency.
- [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) — HMAC algorithm and constant-time compare.
- [`../security/INPUT-AND-API.md`](../security/INPUT-AND-API.md) — API Security; webhook signature verification.
- [`../security/MONITORING-AND-INCIDENT.md`](../security/MONITORING-AND-INCIDENT.md) — what to log and what must never be logged.
- [`../security/AUTH-AND-AUTHZ.md`](../security/AUTH-AND-AUTHZ.md) — authentication and least-privilege scoping.
- [`../architecture/AUTH-CONTRACT.md`](../architecture/AUTH-CONTRACT.md) — actor-level mutation auth gates and audit-log contract.
- `project-management/docs/GDPR-GUIDE.md` — UK GDPR workflow (first-party event tracking carries a higher privacy cost than webhooks; see EVENT-TRACKING design).

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
