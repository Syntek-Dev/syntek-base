---
type: guide
skills: [backend, stack-django]
model: opus
---

# Background Task Authoring

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus (the enqueue boundary, the delivery guarantee, limits, queue routing, testing)

**Status: declared, not wired.** `celery[redis]>=5.7` is declared in the root
`pyproject.toml` and nothing consumes it. There is no `config/celery.py`, no task module
anywhere under `code/src/django/apps/`, no `CELERY_*` setting under
`code/src/django/config/settings/`, and no `worker` or `beat` service in any Compose file
under `code/src/docker/` (none of the four declares anything beyond `db`, `cache`, the Django
app, and `nginx`; staging and production declare the Django app alone).
`code/src/django/config/__init__.py` records that absence deliberately. This
guide is the design of record for the day a feature needs a task; it is written in the
present tense because that is what a project implements when it stands the surface up, not
because it exists today.

---

## When work belongs in a task

Move work off the request when it must **outlive** the request (an export, a sweep, a
file pipeline), or when its failure **must not fail** the request (a send, a webhook, a
ping). Everything else stays inline, where it is easier to reason about, test, and observe.

A task is a distributed system in miniature: a second process, a message that can be
delivered twice, and an ordering problem with the database. Each task added is a new
failure mode, so add one when a named problem requires it, never because the work "feels
slow". The job classification (fire-and-forget, deferred result, scheduled, chained) and
the general job rules live in
[`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) →
_Background Job Patterns_ and are not restated here.

**The task body stays thin.** A task validates its arguments, calls a service, and records
the outcome. Business logic lives in the service, exactly as it does behind a Ninja
endpoint. A task is a third adapter over the service layer, not a place to keep logic that
did not fit anywhere else.

## The enqueue boundary

**A task is never enqueued inside a transaction that may still roll back.** The broker is
not part of the database transaction. The instant the dispatch call returns, the message
exists in the broker and a worker may pick it up, before the surrounding `COMMIT` has
landed. The worker then reads a row that does not exist yet, or that never will.

This failure is timing-dependent, which is what makes it dangerous: with one local worker
and a fast commit it does not reproduce, and it appears the day the worker wins the race in
staging.

```text
inside transaction.atomic():
    write rows
    enqueue                ← a worker may run NOW, before the commit
    COMMIT

inside transaction.atomic():
    write rows
    register the dispatch to run on commit
    COMMIT  ─────────────► the enqueue happens here, once, and only if the commit landed
```

**The rule: register the dispatch with Django's `transaction.on_commit()`, always.** Not
"at the end of the atomic block": the end of the block is still inside the transaction.
Registering unconditionally is the safe habit, because outside a transaction the callback
runs immediately anyway, and a service method that is atomic today may be wrapped by an
atomic caller tomorrow.

Two consequences follow:

- **A nested atomic block is a savepoint, not a commit.** The callback fires on the
  outermost commit, which is the behaviour you want, and is also why a test that only
  asserts the dispatch call happened proves nothing about ordering.
- **Pass identifiers, never model instances.** Arguments are serialised into the broker. A
  serialised instance is a snapshot that is already stale when the worker reads it, and it
  masks the not-yet-committed bug instead of fixing it. Pass the primary key and re-read
  inside the task.

**`on_commit` closes the ordering race, not the delivery one.** The callback runs after the
commit, in the same process. If that process dies between the commit and the dispatch call,
the rows are durable and the task was never enqueued — and nothing anywhere records that it
should have been. This is the accepted consequence rather than an oversight: the state change
is the source of truth, so a dispatch lost this way is recoverable by re-reading it.

It stops being acceptable the moment a second party depends on the event, because then the
loss is invisible from the database alone. The remedy is a **transactional outbox** — write
the intent as a row inside the same transaction as the state change, and let a sweeper
dispatch it. That invariant is already in force here for audit entries: an entry is written
inside the same `transaction.atomic()` block as the change it records, so the two commit
together or roll back together ([`security/AUDIT-TRAIL.md`](security/AUDIT-TRAIL.md) → _The
transaction rule_). An outbox is that same rule applied to work dispatch. Deferred, with a
trigger, below.

## No request, no middleware

A worker has no request, so nothing the request pipeline arranges is present.

- **No session and no authenticated user.** Identity arrives as an argument, and the task
  treats it as data to be verified, not as a caller.
- **No row-security session variable.** The middleware that sets it runs per request
  ([`DATABASE.md`](DATABASE.md)). A task touching scoped rows establishes the scope
  itself, explicitly, from an argument it was given. A task that queries scoped tables
  without doing so is either reading nothing or reading everything.
- **The permission decision was made at enqueue time.** If the task runs minutes later,
  that decision may no longer hold. Anything irreversible or outward-facing re-checks
  authorisation at run time, from the identifiers it was passed.
- **Correlation is not automatic.** The request ID is propagated as an explicit argument or
  the task's logs cannot be joined to the request that caused it
  ([`LOGGING.md`](LOGGING.md)).

Each worker process also opens its own database connections. Count them in the connection
budget ([`DATABASE.md`](DATABASE.md) → _Connection handling_) before adding workers.

## Idempotency

**Every task is idempotent.** The contract, the proof ladder and the run-twice acceptance test
are the reliability family's — [`reliability/IDEMPOTENCY.md`](reliability/IDEMPOTENCY.md) — and
hold here unmodified. This section owns what a queue adds to them: a redelivery, or a task
re-queued after its worker died, is a second run of a task that may already have done its work.

**At-least-once is configured, not inherited.** Celery acknowledges a message _before_ the task
body runs — `task_acks_late` is disabled by default — so under the defaults a worker killed
mid-flight **loses** its task instead of repeating it. That is the opposite failure from the one
idempotency defends against, and it is silent. Wiring the task surface therefore sets
`task_acks_late` and `task_reject_on_worker_lost` deliberately and records which guarantee was
chosen, because late acknowledgement is what makes redelivery possible and redelivery is what
idempotency is for. Note the pairing: re-queueing on worker loss without the idempotency contract
turns a poisoned task into an endless loop, which is why the two are decided together.

**A message the store may evict is not queued work.** No acknowledgement setting recovers a
message that was evicted rather than delivered. The broker's keyspace must therefore sit outside
the cache's eviction policy — and today it does not: cache and broker share DB 0
(`how-to/src/SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md`), so cache pressure reaches queued
messages directly. The eviction policy is a deploy-repo knob recorded with no owner named
(`how-to/src/SCALE-ARCHITECTURE/SIZING-ENVELOPE.md`), so wiring the task surface both states the
requirement — a policy that cannot evict broker keys, or a broker instance of its own — and
confirms it against the deployment rather than assuming it.

**The same transport redelivers on a timer.** On Celery's Redis and Valkey transport a message not
yet acknowledged — one held for its ETA or countdown included — is redelivered to another worker
once `visibility_timeout` (default 3600 s) lapses, and again each time it lapses. That timeout is
the redelivery bound every counted-down retry wait stays below
([`reliability/BUDGETS.md`](reliability/BUDGETS.md) Section _No counted-down wait outlasts
redelivery_); wiring the task surface records the value it sets.

Arguments must still make sense whenever the task runs, which may be well after it was
enqueued. A task that acts on "the current" anything re-reads it; a task handed a derived
value acts on a value that has moved on.

**They must also still be _accepted_ by the code that runs them.** A rolling deploy has both
releases live at once, so a message enqueued a minute ago carries the argument shape the
**previous** one emitted. Renaming a parameter, removing one, or making an optional argument
required breaks every message already queued — as a `TypeError` raised when the worker calls
the function, before the body runs and where no idempotency check reaches it. A signature
change is therefore a two-release change: add the parameter with a default, deploy, drain,
then remove the old one — the add-nullable-then-constrain rule
([`DATABASE.md`](DATABASE.md)) applied to a message instead of a column.

## The error taxonomy on this surface

The three classes ([`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) Section _The error taxonomy_) hold here
too, but a queue has no status code and nobody reading it — so they are carried by **what
happens next**:

| Class                 | Raise                                                 | What follows                                   |
| --------------------- | ----------------------------------------------------- | ---------------------------------------------- |
| **Programmer error**  | `InvariantViolation`                                  | permanent — never retried, one tracker event   |
| **Environment error** | `DependencyUnavailable`                               | retryable — backoff and bounds, aggregated     |
| **Exhausted, parked** | `RetriesExhausted` (declared, not yet in `errors.py`) | terminal — recorded and alerted, never retried |
| **User error**        | —                                                     | **empty on this surface**                      |

**A remote's answer is classified at the adapter.** A timeout, a 429, a 503 or any other 5xx raises
`DependencyUnavailable`. Any other remote 4xx is permanent, but it is a **recorded failure** of the
operation — the row marked failed, the delivery counted — never an `InvariantViolation` and never
a programmer-error tracker event: the remote refused, the code did not break.

**The parked outcome is an environment error that has run out of budget.** It is terminal: it is
never named in any `autoretry_for` tuple and never subclasses `DependencyUnavailable`, so nothing
catches it to schedule another attempt
([`reliability/RETRIES.md`](reliability/RETRIES.md) Section _Honouring `Retry-After`_). On the
declarative path there is no such raise: exhaustion surfaces as the re-raised
`DependencyUnavailable`, logged at `ERROR` and scrubbed as that guide's Section _What a failure
record carries_ says.

**The empty class is the load-bearing one.** A task has nobody to tell, so an argument it
cannot act on was put there by code — a programmer error, even where the identical value
arriving on an endpoint would be a 422. The user error, if there was one, happened at
**enqueue** time on the surface that had a user, and was either caught there or never checked.
A task that validates and then returns quietly converts a bug into a silent no-op.

This table is the task surface's input to the retry classification
([`reliability/RETRIES.md`](reliability/RETRIES.md)). The sibling surface keeps all three classes
and spends exit codes on them instead ([`MANAGEMENT-COMMANDS.md`](MANAGEMENT-COMMANDS.md)).

## Retries and backoff

**The retry doctrine is the reliability family's**, and a task follows it unmodified:
[`reliability/RETRIES.md`](reliability/RETRIES.md) — classify before retrying, jittered
exponential backoff, a stated end, and what a failure record carries — and
[`reliability/BUDGETS.md`](reliability/BUDGETS.md) for the bounds by attempts and by age. Retrying presumes the idempotency above; why the two are one rule is
[`RELIABILITY.md`](RELIABILITY.md). On this surface the class comes from the table above.

## Time limits and rate limits

**Every task carries a time limit.** A task without one can hold a worker slot for ever;
enough of them and the queue stops draining while every health check stays green. Set a
soft limit that raises inside the task, so it can clean up and record how far it got, and a
hard limit above it that kills the process. Derive both from the measured p99 of the work
plus headroom, not from a round number.

**Long work is chunked, not lengthened.** A task that processes one batch and enqueues the
next with a cursor is resumable, observable, and cancellable; one task running for an hour
is none of those. This is the shape [`DATABASE.md`](DATABASE.md) already requires of a
backfill: batched, idempotent, resumable, throttled, observed.

**A rate limit belongs to the constraint it protects.** If a remote allows N calls a
second, the limit sits on the task that calls it. If the constraint is the database, the
answer is a smaller batch or a queue served by fewer workers, not a per-task rate limit.
Either way, a task calling an external service sets connect and read timeouts on that call:
the task time limit is a backstop, not a substitute.

## Queue routing

**Default to one queue.** Routing exists to stop one class of work starving another, and
until two classes actually compete there is nothing to separate. Split when:

- **Latency requirements differ.** A password-reset email queued behind a nightly export is
  a user-visible outage.
- **A class needs its own concurrency or rate limit**, and applying it to everything would
  throttle work that has no such constraint.
- **A class must be paused or drained independently**, so a poisoned queue can be stopped
  without stopping everything.

Never split by domain for tidiness. Each queue costs a worker deployment to serve, a metric
to watch, and an alert to maintain.

**Every queue has an owner condition, a depth metric, and an alert on both depth and
oldest-message age.** Depth alone lies: a queue draining exactly as fast as it fills can sit
at a constant depth while running hours behind.

Scheduled work carries one more rule. The schedule is a deployment-time fact, and starting
`worker` or `beat` in a long-lived environment is a reviewed act, not a config flip, because
the first tick acts on the whole historical backlog. That review is
`how-to/docs/CELERY-FIRST-RUN.md`; it gates the first start in each environment.

## Testing without a broker

Three levels, none of which needs a broker running.

| Level                  | What it tests                                        | How                                                                                                  |
| ---------------------- | ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **The service**        | The logic the task delegates to                      | An ordinary service test. No task, no broker, no eager mode. This is why task bodies stay thin       |
| **The task body**      | Argument handling, idempotency, failure classifying  | Call the task synchronously as a plain function. Assert the double-run property here                 |
| **The enqueue itself** | That the dispatch is registered, and fires on commit | Capture the on-commit callbacks in the test (pytest-django's fixture, or Django's `TestCase` helper) |

The third level is the one people skip and the one that catches the real bug. A test that
patches the dispatch and asserts it was called proves the call happened; it says nothing
about whether it happened after the commit.

**Eager mode is not a substitute.** Running tasks inline is a reasonable default for the
`test` settings module and nowhere else, because it hides two properties the real system
has: the serialisation boundary (an unserialisable argument passes fine inline) and the
commit ordering.

**Retry behaviour is tested by classification, not by waiting.** Make the dependency fail
and assert that a retryable error is treated as retryable and a permanent one is not. The
backoff arithmetic is configuration; no test should sleep through it.

Tests run through `code/src/scripts/tests/backend.sh`. Unit-marked tests open no database
connection, so any task test that touches the database is marked `integration`. Task code
counts towards the same coverage floors as everything else
([`testing/COVERAGE.md`](testing/COVERAGE.md)).

## What this guide does not own

| Concern                                                             | Owner                                                                               |
| ------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Job classification and the general background-job rules             | [`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md)  |
| Audit writes made atomic with the data write                        | Same guide → _Audit Logging from Services_                                          |
| `transaction.atomic()` on multi-write services, TTL jitter, warmers | [`BACKEND-CODING-PRINCIPLES.md`](BACKEND-CODING-PRINCIPLES.md)                      |
| Enabling `worker` and `beat` in an environment for the first time   | `how-to/docs/CELERY-FIRST-RUN.md`                                                   |
| Backfills as batched background jobs                                | [`data-structures/SCHEMA-MIGRATIONS.md`](data-structures/SCHEMA-MIGRATIONS.md)      |
| Error tracking, metrics, and alert routing                          | [`LOGGING.md`](LOGGING.md) · [`logging/OBSERVABILITY.md`](logging/OBSERVABILITY.md) |
| The idempotency contract and proof ladder; the retry doctrine       | [`RELIABILITY.md`](RELIABILITY.md) and its `reliability/` sub-documents             |

## Deferred, with a trigger

Each of these is deliberately absent. Every deferral records the condition that reopens it,
a trigger, not a shrug.

| Deferred                                                          | Revisit when                                                                                                                                                                                                                                                                                                   |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Wiring the task surface at all** (app module, settings, worker) | The first feature has work that must outlive its request or must not fail it. Wire it in that feature's change, never ahead of it                                                                                                                                                                              |
| **A second queue**                                                | Two classes of work with different latency needs are shown to compete, or one class needs its own concurrency, rate limit, or pause control                                                                                                                                                                    |
| **A scheduled (`beat`) surface**                                  | A recurring obligation exists with a stated interval (retention sweep, digest, cache warmer). Its first start is gated on `how-to/docs/CELERY-FIRST-RUN.md`                                                                                                                                                    |
| **A dead-letter queue**                                           | Retry exhaustion has actually happened and the parked messages were worth inspecting, rather than a hypothesis                                                                                                                                                                                                 |
| **A broker separate from the cache**                              | The wiring change points the broker at Valkey, which already serves the cache and today shares DB 0 with it. Revisit when broker traffic is shown to evict cache keys, when the cache's eviction policy is shown to leave queue keys evictable, or when the two need different failover                        |
| **A transactional outbox for domain events**                      | A second party depends on an event whose loss the state change alone would not reveal — an external subscriber, a search index, or an off-box audit store. Until then `transaction.on_commit` is the recorded remedy and its committed-but-unpublished window is stated in _The enqueue boundary_, not implied |
| **A result backend**                                              | A caller genuinely needs a task's return value. Deferred-result work normally writes its result to a row instead, which is durable, queryable, and already permission-checked                                                                                                                                  |

## Cross-references

- [`RELIABILITY.md`](RELIABILITY.md): the cross-surface retry and idempotency doctrine this
  surface expresses
- [`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md): the
  service layer a task delegates to, and the job classification table
- [`MANAGEMENT-COMMANDS.md`](MANAGEMENT-COMMANDS.md): the sibling surface — the shared
  no-request rules are stated here and routed to from there; it owns the operator, the shell,
  and the exit codes
- [`PROCESS-MODEL.md`](PROCESS-MODEL.md): the process family a worker belongs to, and the
  ORM's synchronous boundary that constrains what a task body may do
- [`BACKEND-CODING-PRINCIPLES.md`](BACKEND-CODING-PRINCIPLES.md): transactions and error
  handling
- [`DATABASE.md`](DATABASE.md): constraints, scope columns, the connection budget, and the
  batched-backfill shape
- [`LOGGING.md`](LOGGING.md): where a failed task becomes visible
- [`SECURITY.md`](SECURITY.md): the permission rules a task re-applies without a request
- `how-to/docs/CELERY-FIRST-RUN.md`: the operator review that gates the first start
- `.claude/skills/stack-django/SKILL.md`: the backend idioms loaded on demand

_Part of the `code/docs/` documentation family._
