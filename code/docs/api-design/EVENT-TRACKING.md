---
type: guide
agent: backend
skills: [stack-django]
model: opus
---

# API Design — First-Party Event Tracking

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — engagement/CTR event ingestion complementing Plausible: when to build it, the ingestion API shape, privacy

---

## Status

**Forward-looking.** No first-party event store is built yet. Aggregate analytics today are served
entirely by Plausible (cookieless, GDPR-light). This doc defines the contract for the day we need
per-entity attribution that Plausible cannot give us. Do not build any of this until the decision
gate in _When to build your own_ is met.

---

## Event tracking is not webhooks

These are two different mechanisms and they live in different docs. Do not conflate them.

| Concern             | Mechanism                                                     | Owned by                         |
| ------------------- | ------------------------------------------------------------- | -------------------------------- |
| Inbound third-party | A third party POSTs **signed** events to us (verify + ingest) | [`./WEBHOOKS.md`](./WEBHOOKS.md) |
| First-party events  | **We** observe a click on **our own** pages (emit → ingest)   | this doc                         |

The dividing line is who originates the event and whether a shared secret signs it.

- **Email / newsletter CTR** (open, click, bounce) arrives from Mailgun as an inbound webhook. That
  is a verify-and-ingest receiver → [`./WEBHOOKS.md`](./WEBHOOKS.md), not this doc.
- **On-site CTR** for blog posts, testimonials, case studies, and portfolios is observed by our own
  client code on our own pages. That is event tracking → this doc.

---

## Plausible vs an own store

Plausible already supports custom click events and goals, not just pageviews. Reach for an own-built
store only where Plausible structurally cannot answer the question.

| Capability                          | Plausible (current)              | Own event store (forward-looking)         |
| ----------------------------------- | -------------------------------- | ----------------------------------------- |
| Cookieless / no consent banner      | Yes — privacy-friendly by design | No — behavioural data, see _Privacy_      |
| Aggregate pageviews                 | Yes                              | Possible but redundant                    |
| Custom click events / goals         | Yes                              | Yes                                       |
| Per-record (per-entity) attribution | No — aggregates only             | Yes — joined to our own DB rows           |
| Funnels to enquiries / conversions  | Limited                          | Yes — full first-party joins              |
| GDPR cost                           | Low (Plausible absorbs it)       | Higher — lawful basis, retention, IP rule |

**Rule:** use Plausible custom events and goals for aggregate CTR and conversion goals. Stand up an
own store **only** where per-entity attribution joined to our own data is required.

---

## When to build your own (decision gate)

Build a first-party store only when **all** of the following hold:

- You need attribution to a **specific** record — this blog post, this testimonial, this portfolio
  item — not an aggregate count.
- You need to join engagement to **first-party data** (the enquiry, the lead, the client record).
- You need **funnels / conversions** that follow a visitor from on-site click through to an enquiry.

If aggregate counts are sufficient, configure a Plausible custom event or goal and **stop** — do not
build a store. Per-entity need is the only trigger; "it might be nice to have raw events" is not.

---

## Where it runs

Placement follows the framework responsibility model in
[`./AUTH-STRATEGY.md`](./AUTH-STRATEGY.md) — one bounded context, one framework for its primary
client surface; add a second framework only for a different consumer or a different
runtime/deployment boundary.

| Expected volume          | Run it as                                           | Why                                                |
| ------------------------ | --------------------------------------------------- | -------------------------------------------------- |
| Low (occasional clicks)  | A plain Django view, or a Django Ninja endpoint     | No new infrastructure; reuses the in-process spine |
| High, async, write-heavy | A **separately deployed FastAPI ingestion service** | Keeps the Django ORM/admin off the hot write path  |

High-volume ingestion is the canonical FastAPI separate-service case: deployed on its own, async,
write-optimised, **no Django ORM or admin on the hot path**, talking back to the Django core over an
internal authenticated API. It is never mounted inside the Django process. See
[`./AUTH-STRATEGY.md`](./AUTH-STRATEGY.md) for the framework model and service-to-service auth.

---

## Ingestion API shape

### Event schema

Keep the event thin and free of identity the client could forge or leak.

| Field         | Notes                                                               |
| ------------- | ------------------------------------------------------------------- |
| `event_type`  | e.g. `click`, `view` — closed enum, validated server-side           |
| `entity_type` | `blog_post`, `testimonial`, `case_study`, `portfolio` — closed enum |
| `entity_id`   | The first-party record ID the event attributes to                   |
| `occurred_at` | ISO 8601 UTC; clamp to server time to bound clock skew              |
| `visitor_id`  | **Anonymised** rotating session/visitor id — never a user or PII id |
| `context`     | Minimal: referrer path, page slug. No free-text, no query strings   |

### Client emission

- The client uses `navigator.sendBeacon` so events flush reliably on page unload without blocking
  navigation; **batch** click events into one beacon where possible.
- Honour cookie consent the same way the analytics script does — see _Privacy and GDPR_.

### Endpoint rules

This endpoint is **public-write**: anyone can POST to it. Therefore it must not trust any
client-supplied identity, and it must defend itself.

- **Never** trust client-supplied identity — derive nothing security-sensitive from the body.
- **Origin checks** — accept only requests from our own origins (CORS allowlist, never `*`).
- **Rate limiting** — Valkey-backed per-IP limits; reuse the public rate-limit defaults in
  [`./AUTH-AND-ERRORS.md`](./AUTH-AND-ERRORS.md) — Rate Limiting. Return `429` with `Retry-After`.
- **Idempotency** — accept a client event id and de-duplicate, so beacon retries do not double-count.
- **Abuse controls** — validate every enum, reject oversized batches, cap payload size.
- **Envelope** — reuse the response envelope, status codes, and error format from
  [`./REST-CONVENTIONS.md`](./REST-CONVENTIONS.md) — Request and Response Shapes / REST Error
  Response Format.

---

## Privacy and GDPR (critical)

Behavioural event data is a materially different privacy proposition from Plausible's cookieless
aggregates. It triggers its **own** lawful-basis decision — separate from, and not covered by, the
existing Plausible work.

- **Lawful basis.** On-site behavioural tracking engages PECR (storage/access of information on the
  device) and UK GDPR Art. 6. Decide the basis — typically **consent** — before any event is stored.
  Follow `project-management/docs/GDPR-GUIDE.md`.
- **IP minimisation.** Never store a raw IP. Hash or truncate it for abuse control only. Use the
  approved primitive and constant-time rules in
  [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) — Cryptography and Encryption
  Standards.
- **No PII in events.** No names, no emails, no user ids. `visitor_id` is an anonymised rotating
  token, not an account identifier. See
  [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) — Data Classification.
- **Defined retention.** Set and enforce a retention window; expire raw events on schedule and keep
  only the aggregates you have a basis to retain.
- **Honour consent.** Gate emission on the same cookie-consent state as the analytics script — no
  consent, no beacon.
- **Never log secrets.** Tokens, keys, and raw identifiers must never reach logs — see
  [`../security/MONITORING-AND-INCIDENT.md`](../security/MONITORING-AND-INCIDENT.md) — What must
  never be logged.

---

## Cross-references

| Topic                                     | Document                                                                           |
| ----------------------------------------- | ---------------------------------------------------------------------------------- |
| Inbound webhooks (Mailgun, QuickBooks)    | [`./WEBHOOKS.md`](./WEBHOOKS.md)                                                   |
| Framework model + service-to-service auth | [`./AUTH-STRATEGY.md`](./AUTH-STRATEGY.md)                                         |
| Public rate-limit defaults                | [`./AUTH-AND-ERRORS.md`](./AUTH-AND-ERRORS.md) — Rate Limiting                     |
| Response envelope + error format          | [`./REST-CONVENTIONS.md`](./REST-CONVENTIONS.md)                                   |
| IP hashing, constant-time, classification | [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md)                 |
| Origin / CORS, public-write defences      | [`../security/INPUT-AND-API.md`](../security/INPUT-AND-API.md) — API Security      |
| What must never be logged                 | [`../security/MONITORING-AND-INCIDENT.md`](../security/MONITORING-AND-INCIDENT.md) |
| UK GDPR workflow                          | `project-management/docs/GDPR-GUIDE.md`                                            |

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
