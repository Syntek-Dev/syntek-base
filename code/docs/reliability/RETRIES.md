---
type: guide
skills: [backend, stack-django]
model: opus
---

# Retries and Backoff

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — who retries, classifying a failure, backoff, `Retry-After`, the end of retrying

Part of the reliability family — [`../RELIABILITY.md`](../RELIABILITY.md) is its index, and
states why nothing here applies to an operation that is not idempotent
([`IDEMPOTENCY.md`](IDEMPOTENCY.md)). **How much** an operation may retry — the attempt, the
budget table, overrides, the worst case, the persisted schedule — is [`BUDGETS.md`](BUDGETS.md)'s;
this guide owns who retries, which failures repeat, and what each attempt and failure records.

## One layer decides to retry

**Exactly one layer decides to repeat an operation, and every layer beneath it makes a single
attempt.** Retries compose by multiplication: a task allowed three attempts, calling a client that
retries three times, through an SDK that retries three times, sends twenty-seven requests to a
provider that is already failing. Every layer looks reasonable on its own; the product is a load
spike the system aims at its own supplier. Naming one owner per operation is what makes the budget
a stated property, readable at one site, rather than an emergent one.

**Two alternatives are rejected**: tuned numbers on every layer leave a budget nobody states, which
any one layer's change re-multiplies; the outermost layer always owning the repeat discards the
layer best placed to decide. A clamped client failing on a blip is the cost accepted, not a mistake.

### SDK transport retries are clamped off

**SDK-internal retries are off by default.** Vendors ship them on — an unconfigured `botocore`
client makes up to 5 attempts in `legacy` mode (still the default) or 3 in `standard`, and which
mode it runs in is itself set from outside the code — so a client configured with nothing silently
becomes a second retrying layer. The worked form for boto3:

```python
from botocore.config import Config

S3_CONFIG = Config(retries={"total_max_attempts": 1})  # one attempt: the request itself
```

**Never `retries={"max_attempts": 1}`.** In a `Config` object `max_attempts` counts **retries**,
so `1` is the request plus one retry — two attempts — and clamps nothing. `total_max_attempts`
exists only on `Config` and always counts total requests, which is why it is the form named here.

**The same identifier counts differently by configuration source.** Set through the
`AWS_MAX_ATTEMPTS` environment variable or the AWS config file, `max_attempts` **includes** the
initial request; in a `Config` object it does not. So a client that passes no `retries` dict can
be re-budgeted by an environment variable the application never set, and only an explicit dict at
the constructor takes precedence over that route. That makes the rule below a control, not a style
preference:

> **Every outbound client sets its attempt count explicitly — one attempt, unless a row in the
> outbound timeout register names the delegation and its reason.** "Every" is every client that
> leaves the process: SDK and HTTP clients, the broker publish (Celery's `task_publish_retry` is on
> by default), the cache and database drivers, and the error-tracker transport.

A publish retried from a served surface is a repeat its caller cannot see, so there it is clamped
to one attempt or named in that register — never left at the framework's default.

### The delegation escape hatch

A client that should keep its transport retries — a dropped TCP segment or a stale pooled
connection is genuinely better recovered beneath the application — does so through a row in the
outbound timeout register (how-to/src/OUTBOUND-TIMEOUTS.md). **That register is a forward
reference: it is not yet written.** Until it exists no client delegates, and every client makes
one attempt.

The pattern is the `DICT-OK:` escape hatch's ([`../data-structures/TYPES-EXCEPTIONS.md`](../data-structures/TYPES-EXCEPTIONS.md)):
the exception is legitimate, visible, and carries its reason at one greppable site. **A delegating
row records the delegated attempt count and interval as numbers, never as "the vendor default"**,
so the worst-case formula still resolves ([`BUDGETS.md`](BUDGETS.md) Section _The worst case is
derived, never copied_) — and an unobservable budget is not a budget.

### Served surfaces never retry inbound work

**An endpoint, an MCP tool and a management command are each the layer beneath their caller.**
They make one attempt and report the failure's class; the caller owns any repeat. FastMCP's
`RetryMiddleware` is therefore **deliberately unwired**, and the CLI's expression of the rule is
exit `75` — a scheduler retries on it and on nothing else
([`../MANAGEMENT-COMMANDS.md`](../MANAGEMENT-COMMANDS.md) Section _The error taxonomy on this
surface_).

**The caller is obliged to bound the repeat it now owns**, by this guide's rules on its own side.
The rule moves the repeat outwards; it does not remove it, and an agent re-sending a tool call is
the case [`../mcp-server/AUTH-AND-THREATS.md`](../mcp-server/AUTH-AND-THREATS.md) Section
_MCP-specific threats_ names as _Unbounded cost / runaway loops_. **Inbound rate limiting is a
dependency, not an assumption**: it is specified ([`../security/INPUT-AND-API.md`](../security/INPUT-AND-API.md)
Section _Throttling_, and per key on `/mcp/`) and nothing at baseline wires it, so no served
surface may count on it to absorb a caller that ignores its bound.

### Only an idempotent operation is repeated

**A layer may only repeat an operation it can show is idempotent.** The proof is a rung of the
ladder in [`IDEMPOTENCY.md`](IDEMPOTENCY.md) Section _Proving it — the ladder_. An operation with no
rung makes one attempt and its failure is the outcome — on every surface, an HTTP client's `POST`
and a re-run command included. A retried `POST` whose first attempt succeeded remotely and timed
out locally has executed twice.

## Classify the failure first

**Classify the failure where it happens.** A timeout, a 5xx from a remote, a 429, or lock
contention is retryable. A validation failure, any other 4xx, or a row that will never exist is
permanent. Retrying a permanent failure repeats the work, holds the caller, and fails anyway.

**429 and 503 are carved out of the permanent class explicitly.** Both are the remote saying "not
now", both may carry a `Retry-After`, and both are environment errors. A reader who takes "a 4xx is
permanent" and the `Retry-After` rule below together must not be able to satisfy both and still be
wrong.

**The class decides retryability**, rather than it being judged again per call site — so a surface
guide routes here rather than listing which failures it repeats. The classes are the error
taxonomy's ([`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) Section _The error taxonomy_), and each
surface states how it carries them — the _Per-surface expression_ table below.

## Backoff is exponential and jittered

Unjittered backoff synchronises: every caller that failed in one incident retries at the same
instant and hits the recovering dependency with the wave that knocked it over. Same rule the
cache TTLs already carry ([`../BACKEND-CODING-PRINCIPLES.md`](../BACKEND-CODING-PRINCIPLES.md)
Section _Caching_). **Jitter only ever lengthens a wait on every path this project writes the
countdown for** — the manual form and a persisted schedule — as the next section draws it. The
declarative path is Celery's: `retry_jitter` draws each countdown between zero and the computed
interval, so there jitter shortens a wait, and that path's worst case uses the unjittered
intervals as an upper bound ([`BUDGETS.md`](BUDGETS.md) Section _The worst case is derived, never
copied_).

## Honouring `Retry-After`

**The retry owner waits `W = max(backoff, Retry-After)` — and only when `W` fits both the row's
interval cap `C` and its remaining total age `A`.** `A` is net of the attempt the wait leads to:
`A = T - elapsed - t` on a counted-down row and `A = T - elapsed - p - q - t` on a persisted one,
because there the sweep may enqueue a due row up to `p` late and the claim's lease is `t + q`, so
an attempt can start up to `q` after its claim. A counted-down attempt can also start late, when no
worker is free at its ETA, so it is scheduled with `expires = first_attempt_at + T - t`: a late
start is exhausted rather than run. Either way the last attempt completes within `T`
(`T`, `t`, `p` and `q` are the row's, in [`BUDGETS.md`](BUDGETS.md) Section _The budget table_).
This is the one statement of `A`. If `W > C`, `W > A`, or the attempts are spent, the work is
**exhausted**: park it as _State what happens after the last attempt_ says. Never shorten a
`Retry-After` to fit a cap, never retry before it, and never sleep past the bound.

**`Retry-After` is untrusted input that decides how long a worker sleeps**, so the clamp is a
control, not a courtesy: a remote can otherwise hold a worker slot for as long as it names.
**A missing `Retry-After` counts as `0`**, so `W` is the backoff. **Whether the work parks is
decided on `W`, never on a random draw**, and **jitter never lowers `W`**: on the manual form below
and on a persisted schedule ([`BUDGETS.md`](BUDGETS.md) Section _No counted-down wait outlasts
redelivery_) alike, its draw is added within the headroom `min(C, A) - W`, with or without a
`Retry-After`. So a persisted row's worst case is within `T`, via the `A` check, and its unjittered
sum is a reference only. The final countdown is still checked against `C` and `A` immediately
before it is scheduled; an oversized result parks.

**The one sanctioned manual retry.** The declarative `autoretry_for` path cannot read a response
header to extend its own wait, so honouring `Retry-After` on Celery needs `self.retry` with an
explicit countdown. **`retry_backoff_max` does not bound that call**: Celery applies it only when
autoretry computes the interval, and `Task.retry(countdown=...)` passes an explicit countdown
through unchanged. The owner therefore makes both checks itself, and the call receives only the
checked countdown. The example copies the _Header-aware push_ row of [`BUDGETS.md`](BUDGETS.md)
Section _The budget table_: `INTERVAL_CAP`, `TOTAL_AGE_CEILING` and `PER_ATTEMPT_CEILING` are its
`C`, `T` and `t`. **`RemoteThrottled` is declared, not yet built**: a `DependencyUnavailable`
subclass the adapter raises for a 429 or 503, carrying only the parsed `retry_after`. It is not in
`apps/core/services/errors.py` yet, and the manual task never names it in an `autoretry_for`.

```python
@app.task(bind=True, max_retries=2, time_limit=30)  # Header-aware push: 3 attempts, t = 30 s
def push_invoice(self, invoice_id: int, first_attempt_at: float) -> None:
    try:
        send_invoice(invoice_id)
        return
    except RemoteThrottled as exc:  # a 429 or 503; retry_after is None when the header is absent
        retry_after = exc.retry_after or 0  # copy the one value out of the block
    wait = max(backoff(self.request.retries), retry_after)  # W
    elapsed = time.time() - first_attempt_at
    bound = min(INTERVAL_CAP, TOTAL_AGE_CEILING - elapsed - PER_ATTEMPT_CEILING)  # C, A
    if self.request.retries >= self.max_retries or wait > bound:
        raise RetriesExhausted(invoice_id) from None  # terminal; identifiers only
    countdown = wait + jitter(0, bound - wait)  # never lowers W, never crosses the bound
    if countdown > bound:  # checked again, immediately before scheduling
        raise RetriesExhausted(invoice_id) from None
    raise self.retry(countdown=countdown)  # only the checked countdown
```

**`RetriesExhausted` is terminal** — the parked outcome in
[`../TASK-AUTHORING.md`](../TASK-AUTHORING.md) Section _The error taxonomy on this surface_. It is
never a subclass of `DependencyUnavailable` and never named in an `autoretry_for` tuple: autoretry
catching it would schedule a repeat before `Retry-After`, the one wait this form exists to honour.

## What an attempt log records

**Each attempt logs its attempt number, the elapsed budget (age since the first attempt, against
`T`) and the error class.** The first attempt's time travels with the work on both paths — a task
argument, as in the manual example, or a message header set at enqueue. It **never** records the exception message, the request URL or the
provider's response body: the exception carried through a retry path embeds the URL and often the
body, a presigned URL in a log line is a credential
([`../security/MONITORING-AND-INCIDENT.md`](../security/MONITORING-AND-INCIDENT.md)), and `n`
attempts write it `n` times. The numbering is what lets an operator tell one failed call from
thirty.

**The retry owner emits this record, and the framework's own line is kept out.** On Celery the
three fields are logged from a `task_retry` signal handler, which receives the request and the
reason and so can write the class without the text. Celery's built-in retry line, logged by
`celery.app.trace` at `INFO`, interpolates the exception itself — so that logger is filtered, or
raised above the shipped level, in the same change that wires the task surface. **Until then the
property is unenforced, not satisfied**: nothing at baseline wires Celery, no handler or filter
exists, and no gate checks for either ([`../GATE-REPORTING.md`](../GATE-REPORTING.md)).

## Work that goes stale

Intent replayed at the end of a long budget may no longer be the intent — a cancellation, a
correction or a deletion can land while the chain sleeps. The escape hatch is **a timestamp
argument the attempt checks against current state, or a per-message `expires`**, and a stale
attempt is exhausted rather than executed. **It is mandatory, not merely available, whenever the
operation's payload can be superseded before the row's worst-case total age elapses**
([`BUDGETS.md`](BUDGETS.md) Section _The worst case is derived, never copied_).

## State what happens after the last attempt

The row is marked failed, an alert fires, or the message is parked for inspection. Silent
exhaustion is the failure mode a customer discovers for you.

## What a failure record carries

A failure that reaches the error tracker carries the operation's name and its arguments'
**identifiers** — never their contents and never personal data.

**Exhaustion is the attempt-log rule's last attempt.** On the declarative path the final failure
is re-raised, `celery.app.trace` logs it at `ERROR` with its message, and the tracker captures it.
So the exception exhaustion surfaces as carries **identifiers only in its message, and is raised
`from None`** — the boundary that translates a client's exception into `DependencyUnavailable` does
so, or scrubs the cause before the tracker sees it. The error class is kept; the message is not.

**Frame locals are captured too**: the Sentry SDK's `include_local_variables` is on by default.
Python unbinds the `except` name when the block exits, so the leak is not that name — it is every
other local in the translating frame, the `url`, `body` or `response` the call left behind, wherever
the raise sits. So capture is off (`include_local_variables=False`,
[`../logging/OBSERVABILITY.md`](../logging/OBSERVABILITY.md)) or a `before_send` scrubber drops
every frame's variables. **The terminal raise still follows the block**, as the manual example's
does: raised inside it, the new exception would carry the client's as `__context__`, and anything
logged in the block would carry its text. That the failure is seen at all is monitoring's rule, not this one's
([`../performance/API-AND-MONITORING.md`](../performance/API-AND-MONITORING.md) Section
_Background Jobs and Queues (Celery)_, and [`../LOGGING.md`](../LOGGING.md)).

## Per-surface expression

| Surface          | How the surface carries the class, and where it is stated                                                                                                                    |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Background tasks | By what happens next — permanent, retryable, or empty — [`../TASK-AUTHORING.md`](../TASK-AUTHORING.md) Section _The error taxonomy on this surface_                          |
| The CLI          | By exit code; `75` alone tells the caller to repeat — [`../MANAGEMENT-COMMANDS.md`](../MANAGEMENT-COMMANDS.md)                                                               |
| The JSON API     | By status; an environment error is a 503 with `Retry-After` where known — [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) Section _The error taxonomy_                        |
| MCP tools        | By the text the model reads; the server never retries an inbound call — [`../mcp-server/TOOL-DESIGN.md`](../mcp-server/TOOL-DESIGN.md) Section _The type decides who speaks_ |

## Cross-references

- [`BUDGETS.md`](BUDGETS.md): how many attempts, over how long — the budget table, overrides, the
  worst case, the persisted schedule
- [`IDEMPOTENCY.md`](IDEMPOTENCY.md): the contract every retried operation must already meet
- [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md): the taxonomy that decides retryability
- [`../RELIABILITY.md`](../RELIABILITY.md): the family index, and the circuit-breaker deferral
- [`../architecture/SERVICE-AND-MIDDLEWARE.md`](../architecture/SERVICE-AND-MIDDLEWARE.md): job
  classification
- [`../api-design/WEBHOOKS.md`](../api-design/WEBHOOKS.md): the surface whose delivery budget is an
  override row in `BUDGETS.md`

_Part of the `code/docs/` documentation family._
