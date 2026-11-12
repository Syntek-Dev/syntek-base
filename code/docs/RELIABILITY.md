---
type: guide
skills: [backend, stack-django]
model: opus
---

# Reliability — Retries and Idempotency

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — what happens when a call fails, and whether repeating an operation is safe

This family owns the **cross-surface** doctrine for two questions every network-facing surface
has to answer: when a call fails, is it retried and how; and when an operation runs twice, is the
second run safe. The questions are the same on every surface that can fail or repeat — an outbound
HTTP client, a database transaction, a queue consumer, an inbound webhook, an MCP tool, a
management command — so the rules live here once, and each surface's own guide is to state only
how that surface expresses them. The outbound-webhook delivery budget is an override row of the
budget table in [`reliability/BUDGETS.md`](reliability/BUDGETS.md), which
[`api-design/WEBHOOKS.md`](api-design/WEBHOOKS.md) cites rather than restates. One statement is not yet reduced: the _Retry_ column of the job classification in
[`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) still states
retry rules of its own.

**A surface guide routes here for the rule and keeps its own expression.** The background-task
surface, for instance, keeps its delivery guarantee, its broker-eviction requirement, its
arguments re-read at run time and its signature-drift rule in
[`TASK-AUTHORING.md`](TASK-AUTHORING.md), because those are what a queue adds — not what a retry
is.

## The one rule, seen twice

**Retries and idempotency are one rule seen from two sides.** A retry is a second run of an
operation that may already have done its work, so a retried operation re-runs its idempotency
check by definition — and an operation that is not idempotent cannot safely be retried at all, on
any surface. A retry policy written for an operation with no idempotency proof turns one failure into
duplicated effects.

## Sub-documents

| Document                                                   | Covers                                                                                                                                                                                    |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`reliability/IDEMPOTENCY.md`](reliability/IDEMPOTENCY.md) | The run-twice contract, the proof ladder (constraint → conditional transition → idempotency key), the run-twice acceptance test                                                           |
| [`reliability/RETRIES.md`](reliability/RETRIES.md)         | Who decides to retry, classifying a failure, backoff, honouring `Retry-After`, the attempt log, staleness, the stated end, the failure record                                             |
| [`reliability/BUDGETS.md`](reliability/BUDGETS.md)         | How much: the attempt defined, the declarative default, the budget table, overrides, the worst-case formula, the redelivery limit and the persisted schedule, the manual `self.retry` ban |

## Deferred, with triggers

Each deferral records the condition that reopens it — a trigger, not a shrug.

| Deferred                                            | Revisit when                                                                                                                                                                     |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Circuit breakers on calls to external providers** | The first incident in which bounded retries against a live provider degrade service, **or** the story that integrates a second rate-limited external API — whichever comes first |

**Why deferred, and what already stands in for it.** The retry budget bounds one operation, not
the fleet: fifty workers each within budget still present fifty chains to one degraded provider,
and a breaker is what would cut them. Until a trigger fires, the partial mechanism already in the
tree is the outbound-webhook rule that disables an endpoint after N consecutive failed deliveries
([`api-design/WEBHOOKS.md`](api-design/WEBHOOKS.md) Section _Delivery_) — a breaker for one
surface, so the deferral is not a contradiction of it. A guide that mandates a breaker routes here
rather than restating a rule with nothing behind it.

## What this family does not own

| Concern                                                                                     | Owner                                                                                                            |
| ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| The programmer / user / environment error taxonomy                                          | [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) → _The error taxonomy_                                                  |
| The task surface's delivery guarantee, broker eviction, argument freshness, signature drift | [`TASK-AUTHORING.md`](TASK-AUTHORING.md) → _Idempotency_                                                         |
| The task surface's class table — how a queue carries the taxonomy                           | [`TASK-AUTHORING.md`](TASK-AUTHORING.md) → _The error taxonomy on this surface_                                  |
| Failed-job visibility                                                                       | [`performance/API-AND-MONITORING.md`](performance/API-AND-MONITORING.md) → _Background Jobs and Queues (Celery)_ |
| Job classification                                                                          | [`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) → _Background Job Patterns_   |
| `transaction.atomic()` on multi-write services                                              | [`BACKEND-CODING-PRINCIPLES.md`](BACKEND-CODING-PRINCIPLES.md)                                                   |
| Error tracking and alert routing                                                            | [`LOGGING.md`](LOGGING.md)                                                                                       |

## Cross-references

- [`TASK-AUTHORING.md`](TASK-AUTHORING.md): the first surface to need these rules, and the one
  whose expression of them is written down in full
- [`MANAGEMENT-COMMANDS.md`](MANAGEMENT-COMMANDS.md): the CLI surface, which spends exit codes on
  the error classes a retry decision reads
- [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md): the error taxonomy that decides retryability
- [`DATABASE.md`](DATABASE.md): the constraints the first rung of the proof ladder relies on

_Part of the `code/docs/` documentation family._
