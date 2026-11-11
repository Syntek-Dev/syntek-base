---
type: guide
skills: [backend, stack-django]
model: opus
---

# Retries and Backoff

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — classifying a failure, backoff, bounds, and the end of retrying

Part of the reliability family — [`../RELIABILITY.md`](../RELIABILITY.md) is its index, and
states why nothing here applies to an operation that is not idempotent
([`IDEMPOTENCY.md`](IDEMPOTENCY.md)).

## Classify the failure first

**Classify the failure where it happens.** A timeout, a 5xx from a remote, or lock contention is
retryable. A validation failure, a 4xx, or a row that will never exist is permanent. Retrying a
permanent failure repeats the work, holds the caller, and fails anyway.

**The class decides retryability**, rather than it being judged again per call site. The classes
are the error taxonomy's ([`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) → _The error taxonomy_),
and each surface states how it carries them — the _Per-surface expression_ table below.

## Backoff is exponential and jittered

Unjittered backoff synchronises: every caller that failed in one incident retries at the same
instant and hits the recovering dependency with the wave that knocked it over. Same rule the
cache TTLs already carry ([`../BACKEND-CODING-PRINCIPLES.md`](../BACKEND-CODING-PRINCIPLES.md) →
_Caching_).

## Every retry is bounded

**By attempt count and by total age.** An operation must not be able to retry for ever.

## State what happens after the last attempt

The row is marked failed, an alert fires, or the message is parked for inspection. Silent
exhaustion is the failure mode a customer discovers for you.

## What a failure record carries

A failure that reaches the error tracker carries the operation's name and its arguments'
**identifiers** — never their contents and never personal data. That the failure is seen at all
is monitoring's rule, not this one's ([`../performance/API-AND-MONITORING.md`](../performance/API-AND-MONITORING.md)
→ _Background Jobs and Queues (Celery)_, and [`../LOGGING.md`](../LOGGING.md)).

## Per-surface expression

| Surface          | How the surface carries the class, and where it is stated                                                                                     |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Background tasks | By what happens next — permanent, retryable, or empty — [`../TASK-AUTHORING.md`](../TASK-AUTHORING.md) → _The error taxonomy on this surface_ |
| The CLI          | By exit code — [`../MANAGEMENT-COMMANDS.md`](../MANAGEMENT-COMMANDS.md)                                                                       |

## Cross-references

- [`IDEMPOTENCY.md`](IDEMPOTENCY.md): the contract every retried operation must already meet
- [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md): the taxonomy that decides retryability
- [`../architecture/SERVICE-AND-MIDDLEWARE.md`](../architecture/SERVICE-AND-MIDDLEWARE.md): job
  classification and circuit breakers

_Part of the `code/docs/` documentation family._
