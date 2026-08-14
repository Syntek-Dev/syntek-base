---
name: notifications
description: >-
  Build <%PROJECT_NAME%>'s notification delivery — transactional email through Django's mail
  layer, SMS and push through configured providers, and in-app items in the templated frontend,
  all on one branded template foundation with PII kept out of subjects, bodies and logs. Load
  when a story needs to send something, or the shared template layer needs building. Not the
  preference or inbox UI beyond the delivery component (`frontend`), not consent, unsubscribe
  legality or retention (`gdpr-mechanics`), and not the provider credentials in a pipeline
  (`cicd`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-django stack-htmx-templates
---

# Build Notification Delivery (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is the delivery layer
and its templates).

**Locale:** British English in every user-facing string; dates DD/MM/YYYY, 24-hour,
<%CURRENCY%>, and <%TIMEZONE%> for anything scheduled.

---

## The brief arrives settled

A fork cannot ask, so the brief must carry:

- **The channels** — email only, or also SMS, push, in-app.
- **The notification types** — welcome, password reset, security alert, receipt, digest.
- **The sender identity** — the from-address and from-name, as environment variable names, not
  literals.
- **Whether per-type opt-out is required**, which is a GDPR and PECR question the brief answers
  rather than this skill.

**The provider is read from the environment, never chosen here.** Inspect it
(`.claude/plugins/env-tool.py find`); do not hardcode a backend or invent mail infrastructure.
Where the channel set or the opt-out model is still open, that is a `grilling` pass run inline
first.

## What to build

1. **Send from the service layer.** An endpoint enqueues, a background task sends. Never send
   from an endpoint, a view, or a template — a slow provider must not hold a request open. Two
   or more writes go in `transaction.atomic()`, and the enqueue obeys
   `code/docs/TASK-AUTHORING.md`'s boundary rule: never inside an uncommitted transaction.
2. **Extend the shared template foundation.** One branded base layout; each notification
   defines **body content only** and never re-declares the header, footer or styles. The
   directory shape and the SMS signature prefix are in `code/docs/NOTIFICATIONS.md`.
3. **Reuse the component catalogue for in-app items.** A toast, inbox or badge is a
   django-component, server-rendered and updated over HTMX — check `code/src/django/components/`
   before building a new one. Token-first CSS, WCAG 2.2 AA on every interactive element.
4. **Take brand configuration from settings and environment** — name, logo URL, colours — not
   as literals across templates.
5. **Verify:** `bash code/src/scripts/tests/backend.sh`. Assert the right template renders, the
   send is **enqueued rather than performed inline**, and no PII appears in the subject or the
   logged payload.

## Guardrails

- **PII is stricter here than anywhere in a session**, because the message lands in a system
  this project does not control and sits there for years. Subject lines carry an internal
  reference and never an identity; bodies mask; SMS and OTP carry the minimum; logs record the
  internal user ID only. The full table is `code/docs/NOTIFICATIONS.md` Section _PII, per channel_ —
  **route to it, do not restate it.**
- **Every endpoint that triggers or configures a notification** carries its named Policy check,
  and any recipient ID it accepts is verified against the caller. A resend endpoint that trusts
  the ID in the body posts personal data to whoever asked.
- **Secrets via environment variables only** — provider tokens, API keys, sender addresses.
  `.env.*.example` carries the names, never the values.
- **Token-first for in-app UI** — components consume `var(--token)` only.
- **You wire the templating; you do not write the copy.** Substantive wording follows
  `how-to/src/BRAND-VOICE.md`'s microcopy register — plain, calm, no hype.

## Definition of done

Sends dispatched asynchronously from the service layer; every email extending the one base
layout; SMS bodies prefixed and minimal; no PII in any subject, SMS, OTP or log line; every
trigger endpoint permission-checked with no IDOR; brand values from configuration; in-app
components reused where they exist and WCAG 2.2 AA met; the backend suite green.

## Handoff

Report the channels wired, the notification types added, the templates created, and every new
environment variable by name. Then name what is owed: `frontend` for the preference and inbox
UI, `gdpr-mechanics` to confirm consent, unsubscribe and retention hold, `qa-tester` to verify
rendering across clients and the edge cases, `cicd` for the provider credentials in the
deployment pipelines, and `doc-writer` to record the types and their triggers.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/01-new-feature/` — building a new notification surface
- `code/workflows/10-debug/` — a send that is broken rather than missing
- `project-management/workflows/09-gdpr-compliance/` — the consent and PII rules for content

## Cross-references

- `code/docs/NOTIFICATIONS.md` — the owning guide: send boundary, template foundation, PII
- `code/docs/TASK-AUTHORING.md` — the enqueue boundary, idempotency, retries
- `code/docs/ENCRYPTION-GUIDE.md` — how recipient PII is stored at rest
- `code/docs/LOGGING.md` — what a send event may record
- `how-to/src/BRAND-VOICE.md` — the microcopy register the wording follows
- `code/docs/API-DESIGN.md` — the endpoint and Policy pattern a trigger follows
