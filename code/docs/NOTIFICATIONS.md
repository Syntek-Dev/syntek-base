---
type: guide
skills: [notifications, stack-django]
model: opus
---

# Notifications

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus (the template foundation, the send boundary, PII per channel)

**Status: declared, not wired.** No notification ships at baseline and no SMS or push provider
is a declared dependency. Django's `django.core.mail` is present because Django ships it; the
first story that sends anything adds the channel it needs through the dependency procedure,
not the whole set. What exists today is this contract.

A **notification** is a message the system sends to a person on a channel they are not
currently looking at — an email, an SMS, a push, or an in-app item they will find later. That
last clause is what makes it different from a page: **the recipient is not present to give
context, and the message is stored by someone else's system**, which is why the PII rules below
are stricter than for anything rendered in a session.

## The send boundary

**Send from the service layer, never from an endpoint, view, or template.** An endpoint
enqueues; a background task sends. A slow provider must never hold a request open, and a
provider outage must never turn into a 500 on a form submission.

- A service method with two or more writes wraps them in `transaction.atomic()`.
- The enqueue itself obeys the boundary rules in `TASK-AUTHORING.md` — above all, never enqueue
  inside an uncommitted transaction.
- Every state-changing endpoint that triggers or configures a notification carries its named
  Policy check, and any recipient or user ID it accepts is verified against the caller's
  ownership. A "resend my receipt" endpoint that trusts the ID in the body is an IDOR that
  posts personal data to an attacker's inbox.

## The shared template foundation

Every email extends **one** branded base layout. Individual notifications define body content
only, and never re-declare the header, the footer, or the styles.

```text
code/src/django/apps/<app>/templates/emails/
├── layouts/base.html     # the master layout — brand header and footer
├── components/           # button, card, alert partials
└── notifications/        # welcome.html, password_reset.html … body only
```

The reason is the same one behind `DESIGN-TOKENS.md`: a header copied into twelve templates is
twelve places a rebrand has to reach, and the twelfth is always missed. SMS bodies live beside
these as plain-text templates, each prefixed with a `[<%ORG_NAME%>]` signature so a message
arriving out of context is still attributable.

**Brand configuration comes from settings and environment** — the brand name, the logo URL, the
sender address and from-name — never as literals scattered through templates. Provider
credentials are environment variables in every case (`.env.*.example` carries the names only).

## PII, per channel

Personal data in a notification leaves the system's control the moment it is handed to a
provider, and lands somewhere it will sit unencrypted for years. Treat every field as hazardous
by default.

| Where             | Rule                                                                                                                                              |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Subject lines** | An internal reference, never an identity — `Your order confirmation #{reference}`, never a name or address                                        |
| **Bodies**        | Mask where a value must appear: `jo****@example.com`, the last four digits of a phone, city plus postcode prefix, first name plus surname initial |
| **SMS and OTP**   | Minimal. An OTP message carries the code, its expiry, and a never-share line — no identity, no card number, no account email                      |
| **Logs**          | The internal user ID only. Never an email, a phone number, or the rendered body, in logs or in the error tracker                                  |
| **At rest**       | Recipient PII follows the field-encryption pipeline (`ENCRYPTION-GUIDE.md`)                                                                       |

The subject-line rule is the one most often broken, because a subject reads like metadata
rather than content. It is not: it is the part of the message that appears on a lock screen.

## In-app notifications

An in-app notification is a **frontend** concern — a django-component (toast, inbox, badge)
rendered server-side and updated over HTMX. Reuse the shared catalogue before building a new
one, consume `var(--token)` only, and meet WCAG 2.2 AA on every interactive element
(`FRONTEND-CODING-PRINCIPLES.md`, `ACCESSIBILITY.md`).

## What this guide does not decide

- **Whether a message may lawfully be sent at all** — consent, the lawful basis, unsubscribe
  obligations and retention are `project-management/docs/GDPR-GUIDE.md`'s, and PECR governs
  anything that is marketing rather than transactional.
- **The words** — the register, cadence and ban list are `how-to/src/BRAND-VOICE.md`'s.
- **The delivery guarantee** — at-least-once versus at-most-once is a task-layer configuration
  choice, decided in `TASK-AUTHORING.md`, not per notification.

## Cross-references

- [`TASK-AUTHORING.md`](TASK-AUTHORING.md) — the enqueue boundary, idempotency, retries
- [`ENCRYPTION-GUIDE.md`](ENCRYPTION-GUIDE.md) — how recipient PII is stored
- [`LOGGING.md`](LOGGING.md) — what a send event may record
- [`DESIGN-TOKENS.md`](DESIGN-TOKENS.md) — the token rule the in-app components consume
- [`API-DESIGN.md`](API-DESIGN.md) — the endpoint and Policy pattern a trigger endpoint follows
