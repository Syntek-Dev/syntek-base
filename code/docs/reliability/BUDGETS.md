---
type: guide
skills: [backend, stack-django]
model: opus
---

# Retry Budgets

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — how many attempts, over how long: the budget table, overrides, the worst case

Part of the reliability family — [`../RELIABILITY.md`](../RELIABILITY.md) is its index. This guide
owns **how much** an operation may retry. **Who** retries, which failures repeat, how a
`Retry-After` is honoured and what each attempt records are [`RETRIES.md`](RETRIES.md)'s, and
nothing here applies to an operation that is not idempotent ([`IDEMPOTENCY.md`](IDEMPOTENCY.md)).

## Every retry is bounded

**By attempt count and by total age.** An operation must not be able to retry for ever, and its
budget is a row of the table below. A surface guide's prose never restates a budget; a worked
example may carry a row's values only where it names the row it is copying.

### Attempt, defined once

**An attempt is one execution of the operation, the first included.** Each parameter says which it
counts: Celery's `max_retries` counts **retries**, so `max_retries=3` is four attempts and three
attempts is `max_retries=2`; botocore's `total_max_attempts` counts attempts.

### The declarative default

The default takes **Celery's declarative path** — `autoretry_for` naming the environment-error
types (never `Exception`, which is retry-everything in declarative clothing). The interval cap and
jitter are Celery's own defaults; **three attempts and `b = 1 s` are this table's choice**, because
Celery's defaults are four attempts (`max_retries=3`) and no backoff at all (`retry_backoff=False`).
So every task that retries — declares `autoretry_for` or calls `self.retry` — sets `max_retries`
explicitly, and every declarative one sets `retry_backoff` too, as every client sets its attempt
count:

```python
@app.task(
    autoretry_for=(DependencyUnavailable,),
    dont_autoretry_for=(RemoteThrottled,),  # a named Retry-After takes the Header-aware push row
    max_retries=2,  # 3 attempts
    retry_backoff=1,  # first interval b, seconds
    retry_backoff_max=600,  # interval cap C, seconds
    retry_jitter=True,
)
```

`RemoteThrottled` is declared, not yet built — [`RETRIES.md`](RETRIES.md) Section _Honouring
`Retry-After`_ — so the `dont_autoretry_for` line arrives with the class.

### The budget table

| Row                                                                                                                | Attempts `n` (`max_retries`) | First interval `b` | Interval cap `C` | Jitter | Per-attempt ceiling `t`    | Total-age ceiling `T` | Worst-case total age                                                                                                                 | Reason                                                                                                                             |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------- | ------------------ | ---------------- | ------ | -------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| **Default**                                                                                                        | 3 (`2`)                      | 1 s                | 600 s            | on     | the task's hard time limit | the worst case        | `min(1, 600) + min(2, 600) + 3t` = `3 s + 3t`                                                                                        | —                                                                                                                                  |
| **Header-aware push** (manual `Retry-After` form; counted down)                                                    | 3 (`2`)                      | 1 s                | 600 s            | on     | 30 s                       | 1800 s                | `min(T, 2 x 600 + 3 x 30)` = 1290 s, within `T`                                                                                      | The manual form needs `T` as a number so `A` is computable; the default's `T` is derived from intervals a `Retry-After` can exceed |
| **Outbound webhook delivery** (override; persisted schedule, sweep period `p` = 60 s, queue-wait bound `q` = 60 s) | 5 (`4`)                      | 3600 s             | 28800 s          | on     | 10 s                       | 24 h (86400 s)        | within `T`, via the `A` check; unjittered reference only: `3600 + 7200 + 14400 + 28800 + 4 x 60 + 5 x 60 + 5 x 10` = 54590 s (~15 h) | A consumer's downtime is measured in hours, not seconds; waits past the visibility timeout, so the schedule is persisted (below)   |

**`t` is the total deadline of one attempt** — connect, read and overall wall clock together, or
the task's hard time limit, whichever binds first. A read timeout alone is not `t`: a slow trickle
of bytes can hold a connection open far beyond it. **The webhook row's 10 s is the delivery's total
deadline, held here only until the outbound timeout register exists**; from then the register row
is its one home and this cell cites it.

### The worst case is derived, never copied

```text
worst = sum for k = 0 .. n-2 of min(b * 2^k, C)  +  n * t
```

**It assumes every layer beneath the owner makes one attempt**, so one attempt lasts at most `t`.
On the declarative path it uses the unjittered intervals as an upper bound, for the reason
[`RETRIES.md`](RETRIES.md) Section _Backoff is exponential and jittered_ gives. A row that
delegates transport retries replaces `t` with the delegated attempts times `t` plus the delegated
intervals — which is why its register row records those numbers. On a row using the manual
`Retry-After` form each wait may reach `C`, so it is bounded by `(n - 1) * C + n * t`, and the
remaining-age check `A` stops it within `T` ([`RETRIES.md`](RETRIES.md) Section _Honouring
`Retry-After`_ defines `A` for each row form). A persisted-schedule row's unjittered reference sum
adds `(n - 1) * p + n * q`; `p` is the sweep's period, set once by its Beat schedule entry, and `q`
the queue-wait bound, both recorded in the row's label. Its jitter lengthens a wait, so its worst
case is within `T`, via the `A` check, and that sum is a reference only.

**On the declarative path total age is bounded by construction only.** The worst case sums the
intervals and the attempts; it excludes the time each message waits in the queue, so a backed-up
queue can carry an operation well past it. Where age must actually be bounded — the operation's
payload can go stale, as [`RETRIES.md`](RETRIES.md) Section _Work that goes stale_ says — each
message carries the one absolute deadline of [`RETRIES.md`](RETRIES.md) Section _Honouring
`Retry-After`_, `expires = first_attempt_at + T - t`, so the last attempt still completes within
`T`, and an expired message is exhausted rather than run. **That work takes a row whose `T` is a
number** — an override, as the Header-aware row is — never the Default row, whose `T` is its own
derived worst case and leaves no room for queue wait.

### No counted-down wait outlasts redelivery

**A wait must not exceed whatever redelivers unacknowledged work beneath it**, or the redelivery
is a hidden second retrying layer. So on a **counted-down** row `C`, and any manual-form wait, sits
below that bound — on the task surface, `visibility_timeout` ([`../TASK-AUTHORING.md`](../TASK-AUTHORING.md)
Section _Idempotency_). **A persisted-schedule row is exempt**: its wait lives in `next_attempt_at`.

**Longer waits are persisted, not counted down** — a row carrying `first_attempt_at`,
`next_attempt_at` and the attempt count, and a periodic (Beat) sweep enqueuing what is due. **The
first attempt is enqueued directly, not through the sweep**, which is why the sweep's latency term
is `(n - 1) * p`: in one transaction the row is inserted with
`attempt_count = 1`, `started_attempt = 0`, `first_attempt_at = now` and
`next_attempt_at = now + t + q` (`now` is the transaction's start, so `q` also covers the
enclosing transaction), and that enqueue is registered with `transaction.on_commit`
([`../TASK-AUTHORING.md`](../TASK-AUTHORING.md) Section _The enqueue boundary_). So the first
attempt already holds a lease, its queue wait counts toward `elapsed`, which is what the `A` check
reads, and a publish lost after commit is claimed by the sweep as the next attempt once that lease
lapses, at the cost of one of the row's `n` attempts.

**A due row is parked or claimed, never simply re-enqueued.** A due row whose `attempt_count` is
`n`, or whose `elapsed` already exceeds `T - p - q - t`, is **parked** — marked failed and
alerted — whether its last attempt failed cleanly, crashed, or overran its lease. Otherwise **the
sweep claims it before enqueueing**, by the conditional transition of
[`IDEMPOTENCY.md`](IDEMPOTENCY.md) Section _Proving it — the ladder_: one
`UPDATE ... SET attempt_count = k, next_attempt_at = now + t + q WHERE attempt_count = k - 1 AND
attempt_count < n AND next_attempt_at <= now`, judged by rows changed — or
`select_for_update(skip_locked=True)`, which makes both changes inside the same lock. **The
advanced `next_attempt_at` is the claim's lease**: `t` plus `q`, the queue-wait bound the row
states, so an attempt still queued or running is not swept again.

**The message carries its claimed attempt number `k`, and the attempt makes its own conditional
transition before sending** — `UPDATE ... SET started_attempt = k WHERE attempt_count = k AND
started_attempt < k AND next_attempt_at - t > now`, proceeding only when it changed one row — so
a duplicated or redelivered message, or one starting more than `q` after its claim, is a no-op,
and an attempt that starts always finishes inside its lease. **Each enqueue is one attempt**, with
no `autoretry_for` of its own. A failed attempt writes its next wait into `next_attempt_at` only
while it still holds the claim — `WHERE attempt_count = k AND started_attempt = k`, judged by rows
changed — and under the `C` and `A` checks, its jitter drawn
into the headroom as [`RETRIES.md`](RETRIES.md) Section _Honouring `Retry-After`_ states. The
webhook row takes this form.

### Overrides

**An override is a recorded row in this table, stating every parameter it changes**, so its worst
case recomputes from the row alone. It is legitimate only when the operation's own contract needs a
horizon the default cannot give — a webhook consumer whose downtime is measured in hours — and the
row's _Reason_ cell states that reason, its recomputed worst case fits its `T`, and the operation
still meets the idempotency precondition. **The manual `Retry-After` form always takes its own row**,
stating `T` as a number or a stated derivation, because its remaining-age check cannot be computed
against the default row's `T`. A surface guide cites the row; it never carries the numbers itself.

**A repeated webhook delivery is re-signed each attempt and keeps its identity**: a fresh
signature timestamp over the same body, and the original delivery's event `id`. **The consumer's
de-duplication on that `id` is the replay defence**, not the timestamp; the receiver's 300-second
tolerance window stays as it is, and a repeat signed hours earlier would fail it
([`../api-design/WEBHOOKS.md`](../api-design/WEBHOOKS.md) Sections _Signing_ and _Inbound
Webhooks (we receive)_).

### Manual `self.retry`

**Manual `self.retry` is banned as the routine environment-error path.** A hand-written
`except ... self.retry` loses the declarative path's backoff and jitter, and every copy is a budget
nobody else can read. The one sanctioned manual form is [`RETRIES.md`](RETRIES.md) Section
_Honouring `Retry-After`_, on the _Header-aware push_ row above.

## Cross-references

- [`RETRIES.md`](RETRIES.md): who retries, classifying a failure, `Retry-After`, the attempt log
- [`IDEMPOTENCY.md`](IDEMPOTENCY.md): the contract every retried operation must already meet, and
  the conditional transition the persisted schedule claims by
- [`../TASK-AUTHORING.md`](../TASK-AUTHORING.md): the task surface, and the `visibility_timeout`
  every counted-down wait stays below
- [`../api-design/WEBHOOKS.md`](../api-design/WEBHOOKS.md): the surface whose delivery budget is the
  override row above

_Part of the `code/docs/` documentation family._
