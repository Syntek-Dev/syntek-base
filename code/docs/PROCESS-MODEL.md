---
type: guide
skills: [backend, stack-django]
model: opus
---

# Process Model

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus, covering worker class, event loop, the ORM's sync boundary, and the task worker

Worker class, event loop and the ORM's synchronous boundary are one topic, not three. Decide
any of them alone and the other two decide themselves badly. This guide is where that topic
lives; the surface guides that touch it route back here rather than restating it.

**Status: the web process family runs; the task family is declared, not wired.** Everything in
_What actually runs_ below is verified against `code/src/docker/`. Celery is a different matter:
`celery[redis]>=5.6` is declared in the root `pyproject.toml` and nothing else exists. There is
no `config/celery.py`, no task module, no `CELERY_*` setting, and no `worker` or `beat` service
in any of the four Compose files. `code/src/django/config/__init__.py` records that deliberately.
The task-worker material here is written in the forward voice for the first feature that needs
one; the first-run review it must pass is
[`../../how-to/docs/CELERY-FIRST-RUN.md`](../../how-to/docs/CELERY-FIRST-RUN.md).

---

## What actually runs

One entry point, `config.asgi:application`, served four ways:

| Environment | Server                       | Workers                       | Why this shape                                             |
| ----------- | ---------------------------- | ----------------------------- | ---------------------------------------------------------- |
| dev         | Uvicorn directly, `--reload` | 1                             | watchfiles reloads on `.py` and `.html` changes            |
| test        | Gunicorn + `UvicornWorker`   | 1                             | deterministic; the container stays up for the test scripts |
| staging     | Gunicorn + `UvicornWorker`   | `GUNICORN_WORKERS`, default 2 | production shape at a smaller size                         |
| prod        | Gunicorn + `UvicornWorker`   | `GUNICORN_WORKERS`, default 4 | the deployed arrangement                                   |

Dev is the one deliberate divergence: Gunicorn's `--reload` with the Uvicorn worker is unreliable
against editors that replace inodes, so dev runs Uvicorn on its own. The comment in
`code/src/docker/django/entrypoint.dev.sh` says so, and staging and prod are unchanged by it.

`config/wsgi.py` exists and `WSGI_APPLICATION` is set in `config/settings/base.py`, but **no
container serves it**. Treat WSGI as a compatibility artefact, not a supported path. Anything
that would only work under WSGI is a defect.

Start and stop the stack with `bash code/src/scripts/development/server.sh up` (and `down`,
`restart`, `status`); tests run through `code/src/scripts/tests/*.sh`.

## The worker class is not a preference

**The Gunicorn worker class must be the Uvicorn one. A WSGI worker cannot serve streamable
HTTP.** That statement is stated at its point of consequence in
[`mcp-server/MOUNTING.md`](mcp-server/MOUNTING.md), and it generalises: any surface that streams
a response (an MCP tool call, server-sent events, a long download rendered lazily) needs an ASGI
worker underneath it, and switching the class to "make Django simpler" silently breaks that
surface rather than failing loudly at boot.

Two consequences follow from the same fact and are easy to miss.

**`GUNICORN_TIMEOUT` is not a per-request deadline.** Under an async worker it is how long the
arbiter waits for the worker's heartbeat before killing it. A worker whose event loop is blocked
stops heartbeating, so the arbiter kills the worker and takes **every** in-flight request on it,
not the one that misbehaved. Per-request deadlines belong to the outbound call (an HTTP client
timeout, a statement timeout), never to the arbiter.

**In-worker state does not survive a second worker.** Anything held in a worker's memory is
invisible to its siblings, and the request that finds it is chosen by the arbiter, not by the
client. `MOUNTING.md` works this through for MCP sessions and reaches the rule that applies
everywhere: solve it in the application (stateless, or shared through Valkey or Postgres), never
by asking the edge for sticky sessions. Affinity pushes a correctness requirement into the deploy
repository, where nobody reading the code will find it.

## Sync and async views

**Sync is the default and stays the default.** An ASGI server does not make a Django view
asynchronous; it makes the process capable of hosting both.

| A view is    | Runs                                           | Costs                                                      |
| ------------ | ---------------------------------------------- | ---------------------------------------------------------- |
| `def` (sync) | off the loop, in a thread, via `sync_to_async` | a thread hop per request; thread-sensitive work serialises |
| `async def`  | on the event loop itself                       | every blocking call in it blocks the whole worker          |

Django hands a sync view to a thread with `sync_to_async(thread_sensitive=True)`. The
thread-sensitivity is the point: connection and transaction state must stay coherent on one
thread, so that work is deliberately confined rather than fanned out. Sync throughput therefore
scales with **worker processes**, not with the loop. `GUNICORN_WORKERS` is the knob.

Reach for `async def` only when a view's latency is dominated by outbound I/O it can genuinely
overlap: several independent third-party calls, or a response it streams. Do not reach for it
because "async is faster". A single blocking call inside an async view (a synchronous HTTP
client, a file read, a broker publish, an unwrapped ORM query) stalls every other request that
worker is serving, which is a strictly worse failure than one slow thread.

**Never mix the two in one call chain without a wrapper.** `sync_to_async` and `async_to_sync`
are the only legal crossings, and each crossing is a real cost, not a syntax formality.

## The ORM's sync boundary

The Django ORM is synchronous. Its `a`-prefixed methods (`aget`, `acreate`, `afirst`, async
iteration) are safety wrappers that move the call to a thread; they remove the exception, not the
thread hop, and there is no native async database path underneath them.

Three rules, in the order they bite:

1. **A bare ORM call in an async context raises `SynchronousOnlyOperation`.** Prefer writing the
   whole unit of work synchronously and wrapping it **once** at the boundary, over sprinkling
   `await` through a service. One crossing per operation, not one per query.
2. **Transactions do not cross the boundary.** `transaction.atomic` is thread-local state. An
   atomic block must open and close inside the same synchronous callable; splitting it across an
   `await` is not a slow version of the right thing, it is a different thing.
3. **Nothing closes stale connections outside the request cycle.** `conn_max_age=600` and
   `conn_health_checks=True` are set in `config/settings/base.py`, and Django's
   `request_finished` signal is what reaps connections. Work that runs outside a request (an MCP
   tool call, a management command, a task) must call `close_old_connections` itself, either side
   of its ORM access. The worked decorator is in
   [`mcp-server/TESTING-AND-OPS.md`](mcp-server/TESTING-AND-OPS.md) → _The ORM connection rule_.
   Left undone, this surfaces as an intermittent `InterfaceError` after an idle period, in
   production only. **One of the three has this solved structurally:**
   `apps.core.management.base.ManagementCommand` closes on entry and exit, so a command
   satisfies the rule by subclassing it and a command invoked through `call_command()` — which
   never reaches the `run_from_argv` cleanup Django does provide — behaves like one invoked from
   a shell ([`MANAGEMENT-COMMANDS.md`](MANAGEMENT-COMMANDS.md)). A task and an MCP tool still
   carry it themselves.

**Connections are counted per process, not per deployment.** Worst case is roughly
`(web workers + task workers + schedulers) × database aliases`. Compute it before adding a
process family, and read [`DATABASE.md`](DATABASE.md) → _Connection handling_ for the pooler
trigger it feeds.

## The panic blast radius (rust-only)

**Present only in a project generated with the Rust surface.** A Rust panic crossing into CPython
is undefined territory, and under `panic = "abort"` there is no catching at all: the **Gunicorn
worker dies**, taking every in-flight request with it. That is why the panicking paths are denied
at the lint level rather than handled at review, and why `panic = "abort"` is never set in a
profile the extension module is built under. The full rule, the lint table, and the error-mapping
contract are in [`rust/PYO3-BOUNDARY.md`](rust/PYO3-BOUNDARY.md).

It belongs in this guide because the blast radius is a property of the process model, not of
Rust. Under an async worker a killed process drops every concurrent request on that loop, so the
same panic costs more here than it would under a one-request-per-worker arrangement. The GIL
point in that guide reads the same way: a long Rust call blocks the interpreter, so it releases
the GIL with `allow_threads` for anything measured in milliseconds.

## Where a task worker sits

When the first feature needs one, it is a **separate process family**, not another view.

- **Its own container, from the same image.** Every entrypoint under
  `code/src/docker/django/` already honours a command passed by Compose (`exec "$@"`), and the
  dev, staging and production entrypoints name that reuse as the reason the hook is kept. (The
  test entrypoint carries the same hook for a different stated reason: passing `pytest` arguments.) The worker service passes a command;
  it does not need a second image.
- **No event loop, no request cycle.** A task is ordinary synchronous Python. It therefore owns
  its own connection hygiene (rule 3 above) and its own transaction boundaries.
- **Exactly one `beat`.** A scheduler is a singleton by construction; two of them fire every
  schedule twice.
- **Enqueue after commit.** Publish with `transaction.on_commit` so a worker cannot pick up an
  ID whose row is not yet visible, or worse, was rolled back. This is the most common wiring
  defect and it is invisible until the queue drains faster than the transaction commits.
- **`.delay()` is a blocking broker round-trip.** From an async view it must be wrapped like any
  other synchronous I/O, and it can fail: a broker outage must not become a 500 on a request that
  had otherwise succeeded.

Task content rules (idempotency, retries and back-off, passing IDs rather than objects) belong to
[`performance/API-AND-MONITORING.md`](performance/API-AND-MONITORING.md) → _Background Jobs and
Queues_. The first-start review, which is the gate that actually matters because a dormant
schedule fires against the whole historical backlog, is
[`../../how-to/docs/CELERY-FIRST-RUN.md`](../../how-to/docs/CELERY-FIRST-RUN.md).

## Choosing where work runs

| The work is                                        | Put it                                 |
| -------------------------------------------------- | -------------------------------------- |
| Fast, transactional, needed in the response        | A sync view or Ninja endpoint          |
| Several independent outbound calls, all needed now | An async view, each call wrapped       |
| Slow, retryable, or a third party's reliability    | A task worker                          |
| Periodic, with no user waiting                     | A task worker, scheduled by `beat`     |
| A backfill over existing rows                      | A task worker, never a migration       |
| Streaming a response of unbounded length           | An async view, with edge buffering off |

The last two are cross-guide constraints, not judgement calls: [`DATABASE.md`](DATABASE.md)
requires backfills to be batched, resumable background jobs rather than migrations, and
`MOUNTING.md` requires the edge not to buffer a streaming prefix.

## Deferred, with a trigger

Each of these is deliberately absent. Each records the condition that reopens it: a trigger, not
a shrug.

| Deferred                                                  | Revisit when                                                                                                                                            |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The task-worker family** (`worker` and `beat` services) | Work on the request path either breaches the response budget or can fail for a third party's outage, or the first backfill over existing rows is needed |
| **Any `async def` view**                                  | A single view's latency is dominated by outbound I/O it can genuinely overlap, and the overlap is measured rather than assumed                          |
| **A second process family for long-lived connections**    | A streaming surface shares workers with page traffic and held connections are shown to starve ordinary requests                                         |
| **WebSockets (Channels)**                                 | Real-time delivery is a stated requirement. `pyproject.toml` records this as a stack change argued in an ADR, because it adds a process family          |
| **A per-request deadline enforced in the application**    | A dependency is shown to hang rather than fail, and its own client timeout cannot be set                                                                |

Adding a process family is never free on a single-node deployment: it takes memory and database
connections from the same budget as the web workers and Postgres. Size it before adding it, never
from spare capacity.

## Cross-references

- [`mcp-server/MOUNTING.md`](mcp-server/MOUNTING.md): the worker-class rule at its point of
  consequence, session mode, and the edge-buffering requirement
- [`mcp-server/TESTING-AND-OPS.md`](mcp-server/TESTING-AND-OPS.md): the connection-reaping
  decorator for work outside the request cycle
- [`rust/PYO3-BOUNDARY.md`](rust/PYO3-BOUNDARY.md): **rust-only**, never panic across the
  boundary, and the GIL rule for long calls
- [`DATABASE.md`](DATABASE.md): connection arithmetic, the pooler trigger, backfills as jobs
- [`BACKEND-CODING-PRINCIPLES.md`](BACKEND-CODING-PRINCIPLES.md): Django, Python and Celery
  authoring style
- [`performance/API-AND-MONITORING.md`](performance/API-AND-MONITORING.md): queued-job content
  rules and monitoring
- [`architecture/CORE-AND-SCALING.md`](architecture/CORE-AND-SCALING.md): the scaling
  phase-gates these process decisions are sized against
- [`logging/OBSERVABILITY.md`](logging/OBSERVABILITY.md): the log legs per container, including
  the worker leg that only applies once Celery is wired
- [`../../how-to/docs/CELERY-FIRST-RUN.md`](../../how-to/docs/CELERY-FIRST-RUN.md): the
  env-by-env first-start review

> Worker counts, concurrency and the edge are catalogued as the deploy contract in
> `how-to/src/SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md`; this doc keeps owning the "why",
> SERVER-ARCHITECTURE owns "what the server provides".

_Part of the `code/docs/` documentation family._
