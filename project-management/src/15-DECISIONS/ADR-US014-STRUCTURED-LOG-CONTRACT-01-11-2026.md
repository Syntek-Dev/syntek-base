# ADR-US014: The application log line is a hand-written JSON contract, the collector's labels and the correlation id are the edge's, and the pipeline minimises rather than redacts

**Status:** Accepted — 01/11/2026 by <%DEVELOPER_NAME%>
**Date:** 01/11/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US014 · `project-management/src/02-STORIES/US014.md` · `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` Batch G1, node N-020, slice S-07 · `project-management/src/09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` · `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` · `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` · `project-management/src/11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` · `project-management/src/14-LOGGING/PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md`

<!-- Written 01/11/2026 at 15-decisions for US014, on pm/story-creation at HEAD 5441954, after the
     five gate plans were signed off. One ADR, not three, settled with <%DEVELOPER_NAME%> in the
     15-decisions grilling, round 1, Q1 (option 2): the line contract, the edge/collector contract
     and the no-redaction position are one decision about what a generated project's log store
     can rely on, and each half is only true with the other two. Cites: "grilling 31/10/2026, Qn"
     is the story's cutting interview; "gates grilling 01/11/2026, Qn", "R2-Qn" and "R3-Qn" are the
     three specify-gate rounds recorded in US014.md's FLAGS comment and in the five plans. Every
     fact below is drawn from those sources; nothing was re-measured for this record. -->

---

## Context

**US014 makes a promise twelve shipped documents already make and nothing delivers**: staging and
production write one JSON object per line, every line carries a `request_id`, and the LogQL
queries in the guides return what they describe (`US014.md` Client Summary and User Story;
`MAP-RULE-OWNERSHIP.md` Batch G1, _"Batch G1 in full"_). Today the `base.py`, `staging.py` and
`production.py` `LOGGING` dicts are byte-identical plain text, no `logging.Filter` exists although
`RequestIDMiddleware`'s own comment names one as its consumer, no JSON dependency is installed, and
the guides query container strings Compose never produces (`US014.md` FLAGS comment, _"The slice
was re-measured at cutting"_). `code/docs/security/MONITORING-AND-INCIDENT.md` _Log format and
integrity_ requires a correlation id in every log entry, so the repository fails its own security
guide.

**Most of what US014 settles is reversible inside this repository** — a field value is one line in
one module, a level is one key in one settings dict (`US014.md` _Decisions_, the N-020 bullet). The
part that is not reversible here is **what crosses a boundary this repository does not own**:

- **The line shape is read by queries this repository will never see.** A generated project's
  LogQL — in its runbooks, dashboards and alert rules — keys on `level`, `logger`, `request_id`
  and the extras. Renaming a field after generation breaks every one of those silently: the
  `| json | __error__=""` stage returns nothing, and nothing fails.
- **Whatever labels the queries select on are set by a collector in the deploy repository.**
  Which labels those are, whether stderr is collected, the retention window and the host's
  `json-file` rotation are all enforced there, from what
  `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` states (`LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md` Section 5.1).
- **The correlation id is joined across three records** — the application line, the edge access
  log and the audit trail (`code/docs/security/AUDIT-TRAIL.md`) — and entry 2's dormant CSP nonce
  is derived from it (`EDGE-REQUIREMENTS.md` entries 2 and 13). Who sets it is an edge obligation.
- **Whether the line is redacted or only minimised is a position a later scrub package may
  revisit.** The map defers the scrub half of observability to a `syntek-observability` package
  with a stated trigger (`MAP-RULE-OWNERSHIP.md` Batch G1, the _"`syntek-modules` was considered"_
  note). A deferral with a destination needs a record that the later decision can explicitly
  supersede.

**Constraints in force.** `code/docs/coding-principles/STYLE-AND-PROCESS.md` _Dependencies_: _"Don't
add a dependency for something you can write correctly in under 50 lines"_ (N-020's governing
gate). Data is minimised by design and the posture is `development`. Every one of the twenty threats
raised reads `LOW` or `INFO` because nothing is deployed and the settled answers close fifteen in
design (`THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` Section 4); Section 3a names the events that promote nine of
them to `MEDIUM`, most of which fire on a live surface whether or not this contract holds. The process-server stream
(`gunicorn.error`, `uvicorn.error`) is plain text on stderr, outside Django's `LOGGING`, and the
claim was narrowed to exclude it rather than route it through (gates grilling round 2, R2-Q1).
Docker's `json-file` driver splits a line over 16 KiB into partial records (moby
`daemon/logger/copier.go`, cited in `US014.md` FLAGS comment, _"Scoped qa-tester re-check"_).

**Assumption.** The reference collector is Grafana Alloy into Loki, with the deploy repository free
to realise the contract with another collector; the relabel was confirmed against Alloy v1.21's
primary documentation (`LOGGING-PLAN-US014-*` Section 5.2). **Unmeasured, not confirmed**
(`code/docs/GATE-REPORTING.md`): that `__`-prefixed labels are dropped after relabelling was not
quoted from a primary page and rests on the Prometheus relabel convention Alloy inherits; the
deploy repository's Loki version and any customised `discover_service_name` limits, and whether
its Nginx already overwrites `X-Request-ID`, could not be looked at from this tree
(`LOGGING-PLAN-US014-*` Section 5.2, _Could not look_; `ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` Section 8,
_Could not be checked from this tree_).

## Options considered

The decision has three axes — **how the line is produced**, **how the collector finds it**, and
**what the line is allowed to carry** — and the options are grouped by axis. Each axis's options
were realistic: the map recommended Option B before reversing itself, and the scrub, the container
selectors and the client-chosen id are what the shipped documents described before US014.

### Axis 1 — producing the line

#### Option A — do nothing: correct the documents to say plain text

- **Summary:** leave the three byte-identical plain-text dicts, and rewrite the twelve documents
  and their queries to match what ships.
- **Pros:** no code; no new module to maintain; the documents stop lying.
- **Cons:** `MONITORING-AND-INCIDENT.md` _Log format and integrity_ still requires a correlation id
  in every entry, and no filter writes one — the repository goes on failing its own security guide
  (`MAP-RULE-OWNERSHIP.md` Batch G1, _"A mandatory shipmate"_). Plain text cannot be queried by
  field, so the LogQL the guides teach has no replacement. Every generated project inherits the
  gap, as `syntek-modules` already has at v7.4.1.

#### Option B — `python-json-logger`

- **Summary:** depend on `python-json-logger` for the formatter, configured from each settings
  module, with a hand-written `request_id` filter beside it.
- **Pros:** a maintained, widely used formatter; `default=str`-style coercion and extras merging
  come with it.
- **Cons:** fails the `STYLE-AND-PROCESS.md` _Dependencies_ gate, question 1 — it can be written
  simply without it. Its claimed advantage was false on measurement: `level` needs **both** a
  `fmt` naming it and `rename_fields`, and `rename_fields` is **silently ignored** when the
  formatter is declared with `"class"` rather than `"()"` (`MAP-RULE-OWNERSHIP.md` Batch G1,
  _"The library question"_). In design vocabulary it is a **shallow** win: the contract-specific
  behaviour — the allowlist, the type-only exception shape, the 16 KiB cap, the never-raise
  fallback, the stored-id fallback for a returned error (R2-Q4, R2-Q5, R2-Q6, R3-Q1, R3-Q2) — is
  still hand-written, now split between a dependency's configuration surface and our own module,
  so **locality** is lost and nothing is hidden that we did not have to write anyway.

#### Option C — `structlog`

- **Summary:** adopt structlog as the logging front end, with `contextvars` binding for the
  request id and its structured tracebacks.
- **Pros:** **the better tool, and it is not close** — `contextvars` binding, structured
  tracebacks and test capture, with the larger community (`MAP-RULE-OWNERSHIP.md` Batch G1). It
  would also serve the deferred half (tracing, metrics) if that were un-deferred.
- **Cons:** the same dependency gate, and a wider one: structlog changes how a call site logs, so
  every future `apps.<app>` logger in every generated project learns its interface rather than the
  standard library's. Django's own framework records — today the pipeline's only records, since no
  `import logging` exists in the tree — still arrive through the standard library, so the bridge
  is configuration on top of `LOGGING`, not instead of it. The exception shape US014 pins
  (type-only `cause`/`context` links, group member types, notes dropped, type and innermost frame
  surviving the cap) is specific to this contract, so it would be a hand-written processor
  whichever library hosts it.

#### Option D — a hand-written formatter and filter in `apps/core/observability.py`

- **Summary:** one module holding a `logging.Formatter` subclass with a minimal mode (staging,
  production) and a wide mode (dev), and a `logging.Filter` that writes `request_id` from
  `current_request_id()`, falling back to the id `RequestIDMiddleware` stores on the request.
  Standard library only; each environment's settings module carries its own complete `LOGGING`,
  and `base.py` none (`US014.md` _Dependencies_, _"No library"_; Backend Acceptance Criteria).
- **Pros:** a **deep** module — the settings modules learn two class paths and a mode, and the
  serialisation, allowlist, exception shape, cap, fallback and correlation all sit behind them.
  The deletion test passes: inline it and the same logic reappears in five settings modules. The
  filter sits beside the middleware whose `ContextVar` it reads, so the correlation's whole
  behaviour has **locality** in `apps.core`. The module lands at the path
  `code/docs/logging/DJANGO-LOGGING.md` already cites, under `apps/core/CONTEXT.md`'s rule that a
  module lands when its governing decision does. The interface is the test surface: the QA plan's
  unit cases exercise it through `format()` and `filter()` alone (`QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` Section 2).
- **Cons:** ours to maintain. It has grown past the map's ~30-line estimate — the guarded `repr`,
  the iterative chain walk and the cap were added by the gate rounds — and every edge case a
  library would have met in the field is one we meet in a unit test instead (EC-12, EC-17, EC-19,
  EC-23 in `QA-PLAN-US014-*`).

#### Option E — hold the pipeline in `syntek-modules`

- **Summary:** ship the logging setup as a first-party package that a generated project chooses.
- **Pros:** one copy for every Syntek product; a project could swap it.
- **Cons:** `syntek-modules` is generated **from** `syntek-base` and has already inherited this
  defect, so a fix living only there cannot fix it; `syntek-base`'s own skeleton must pass its own
  gates; a first-party package is still a dependency under `STYLE-AND-PROCESS.md`; and
  `syntek-modules` has no packages yet, so US014 would block on standing up publishing and
  versioning for one module. The choice it wanted already has a seam in `copier.yml`'s
  `LOG_AGGREGATOR` and `OBSERVABILITY_STACK` (`MAP-RULE-OWNERSHIP.md` Batch G1, the
  _"`syntek-modules` was considered"_ note).

### Axis 2 — finding the line and correlating it

#### Option F — container-name selectors

- **Summary:** set `container_name:` on each Compose service and query by container name, as the
  guides' `-backend`, `-web` and `(web|worker)` strings assumed.
- **Pros:** no relabel in the collector; the label is visible in `docker ps`.
- **Cons:** a fixed `container_name` cannot scale past one replica, and without one the name
  carries a replica suffix (`<%PROJECT_SLUG%>-prod-django-1`), so a selector that matches one
  replica misses the next. The guides already carry four different wrong strings
  (`US014.md` FLAGS comment); a name-based contract invites a fifth. It also says nothing about
  which environment a line came from (TM-15).

#### Option G — the collector relabels the Compose labels (`service_name`, environment)

- **Summary:** the collector reads each container's stdout **and stderr** through the Docker
  daemon with its labels, relabels `com.docker.compose.service` to `service_name` and
  `com.docker.compose.project` to an environment label, retains per a stated window, and the host
  rotates `json-file` with `max-size` and `max-file`. Every documented query reads
  `{service_name="django"}`; the stream outside the pipeline is kept by
  `{service_name="django"} | json | __error__!=""` (`LOGGING-PLAN-US014-*` Section 5.1; gates
  grilling Q3, Q10, Q11, R2-Q1).
- **Pros:** the only selector that survives more than one replica (`MAP-RULE-OWNERSHIP.md`
  Batch G1, _"The rest of the settled shape"_); both stacks already name the service `django`;
  staging and production cannot merge silently in one store; stated collector-neutrally, with
  `discovery.docker` -> `discovery.relabel` -> `loki.source.docker` as the reference realisation,
  confirmed against Alloy v1.21 (`LOGGING-PLAN-US014-*` Section 5.2). A file tail of
  `/var/lib/docker/containers/*/*.log` carries no Compose labels, so this also corrects
  `OBSERVABILITY.md`'s diagram (TM-14).
- **Cons:** it makes `EDGE-REQUIREMENTS.md` load-bearing for logs where it had no log row, and
  the queries are only as true as a repository we do not control. Without the explicit relabel,
  Loki derives `service_name` from its default list or falls back to `unknown_service`.

#### Option L — the application ships its own lines (Loki or OTLP push)

_Recorded at the planner review of 01/11/2026 so a later reader does not reopen it; it was not
raised in the grilling rounds. Lettered out of sequence for that reason._

- **Summary:** a logging handler in each worker pushes lines to Loki or an OTLP endpoint, with the
  service and environment set from settings rather than by a collector relabel.
- **Pros:** removes the relabel obligation on the deploy repository; the environment label is set
  in-app, so a misconfigured collector cannot merge staging and production.
- **Cons:** a dependency under the same `STYLE-AND-PROCESS.md` _Dependencies_ gate; an outbound
  network path from every worker, and a lost or blocking line when the endpoint is down; and OTLP
  wiring is the half of observability explicitly deferred to `syntek-observability`
  (`MAP-RULE-OWNERSHIP.md` Batch G1). The stdout stream still exists, so a collector is still
  needed for the process-server lines outside `LOGGING` (R2-Q1).

#### Option H — the application mints every id, ignoring the edge

- **Summary:** `RequestIDMiddleware` discards any inbound `X-Request-ID` and always mints its own.
- **Pros:** a client can never choose the id (TM-01) whatever the edge does; no edge obligation.
- **Cons:** the edge access log — the only access record once gunicorn's is dropped (gates
  grilling Q1) — then holds a different id from the application line, so the join that makes the
  access log useful is lost, and entry 13's requirement that the CSP nonce and the access log use
  the same id cannot hold (`EDGE-REQUIREMENTS.md` entries 2 and 13).

#### Option I — the edge sets `X-Request-ID` from its own `$request_id`, unconditionally

- **Summary:** entry 13 gains the clause that the edge sets the header from its own
  `$request_id` on every request, discarding any client value, and records the same value in its
  access-log format; the application keeps reading the inbound header, its alphabet check
  (`[A-Za-z0-9._-]{1,200}`) and its minted fallback as the backstop (gates grilling Q7).
- **Pros:** one id joins the application line, the edge access log, the audit trail and the
  nonce; a caller cannot choose the id an audit entry joins on (TM-01 closed in design); local dev
  and test, with no edge, still get an id from the fallback.
- **Cons:** an edge obligation the application cannot verify, so on a misconfigured edge a client
  id is accepted again, limited only by the alphabet check.

### Axis 3 — what the line may carry

#### Option J — ship a scrub now

- **Summary:** a key and pattern list in `observability.py` that redacts secret-bearing fields
  and personal values from `message` and the extras, as `DJANGO-LOGGING.md` already credits
  `apps.core.observability` with doing.
- **Pros:** closes TM-05 and TM-07 in principle; makes the existing sentence in
  `DJANGO-LOGGING.md` true.
- **Cons:** **no document anywhere lists the keys or patterns** — only the class
  (`MAP-RULE-OWNERSHIP.md` Batch G1, _"Redaction is deferred with a destination"_). A thin scrub
  is a redaction guarantee that is not one, which is the map's class **B**, false green: a reader
  trusts `message` because something called scrub ran over it. A scrub hook with no curated list
  behind it is a seam with no real adapter.

#### Option K — minimise, never redact, and say so

- **Summary:** the staging/production line keeps only the fixed keys and the three allowlisted
  extras (`duration_ms`, `status_code`, `method`), dropped not masked; `exc_info` carries the type
  and `(filename, lineno, function)` frames, with type-only `cause`/`context` links and no message,
  source text, locals or notes; `message` is **not scrubbed**, and the claim names what it still
  carries — a request path, and `str(exc)` for `BadRequest` and `SuspiciousOperation`
  (grilling 31/10/2026, Q9, Q11; gates grilling Q5, Q6). No document claims redaction.
- **Pros:** every claim is one a test can hold (`QA-PLAN-US014-*`); the minimisation is
  structural, so it does not depend on a pattern list being complete; the GDPR position is stated
  on what is true (`GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` Sections 2 and 8.2).
- **Cons:** whatever a call site interpolates into `message` reaches stdout intact (TM-05); a
  request path does too, so the rule moves to design — no secret or personal value in a URL path
  segment (gates grilling Q5, TM-06).

## Decision

**We will take Options D, G, I and K together: a hand-written JSON formatter and `request_id`
filter in `apps/core/observability.py`, a line contract stated field by field, a collector
contract stated in `EDGE-REQUIREMENTS.md` keyed on the Compose service label with an environment
label and the edge setting `X-Request-ID` unconditionally, and minimisation in place of
redaction.**

**The line contract, as this record fixes it.** In staging and production every line Django's
`LOGGING` emits is one JSON object, terminated by one newline, carrying:

| Key          | Contract                                                                                                                                                                                                                                                                                                                                          |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `timestamp`  | ISO-8601 UTC, `YYYY-MM-DDTHH:MM:SS.mmm+00:00`, independent of `TZ`                                                                                                                                                                                                                                                                                |
| `level`      | `record.levelname`, upper case                                                                                                                                                                                                                                                                                                                    |
| `logger`     | `record.name`                                                                                                                                                                                                                                                                                                                                     |
| `message`    | `record.getMessage()`, not scrubbed; `str(record.msg)` without its args if that fails                                                                                                                                                                                                                                                             |
| `request_id` | Written by the filter unconditionally; `null` outside the middleware's dynamic extent, never `""` and never missing; a returned-error `django.request` line takes the id stored on the request                                                                                                                                                    |
| extras       | Only `duration_ms`, `status_code`, `method` off dev; every extra in dev, an unserialisable one as its `str()`                                                                                                                                                                                                                                     |
| `exc_info`   | Present only with an exception. Off dev: `{"type", "frames", "cause", "context"}`; `type` is the class `__name__`; frames `{filename, lineno, function}`; `cause`/`context` a type-only link `{type, cause, context}` with no frames, or `null`; group `members` as type names; notes dropped; no `stack_info` or `exc_text`. Dev: full traceback |
| `truncated`  | `true` only on a line the minimal formatter cut to keep the line plus its newline within 16 384 bytes; absent otherwise. Every fixed key stays present; the exception type and innermost frame survive the cut; a cut link is **omitted**, never written as `null`, which means "no cause"                                                        |

**The formatter never raises.** Where serialisation fails it emits one JSON object of the fixed
field set, the extras `str()`-coerced in place and still allowlisted, every coercion through a
guarded `repr` that cannot raise (R2-Q5, R3-Q2). Sources: `US014.md` Acceptance Criteria;
`LOGGING-PLAN-US014-*` Sections 2.2 and 3; `QA-PLAN-US014-*` AC-GAP-4 and AC-GAP-10;
`ASSESSMENT-PLAN-US014-*` Section 7.4; gates grilling R2-Q6, R3-Q1, R3-Q3.

**What tipped each axis.**

- **Axis 1: the contract-specific code is ours under every option, and then locality.** The
  exception shape, the cap with its ordered cutting and the never-raise fallback are hand-written
  whichever option hosts them (`QA-PLAN-US014-*` AC-GAP-4, AC-GAP-10, AC-GAP-11), so a library adds
  a dependency without removing the code that makes the line safe. That is the
  `STYLE-AND-PROCESS.md` _Dependencies_ gate's question 1 — can it be implemented simply without
  it — answered yes, and it holds whatever the line count: the module may well exceed the gate's
  50-line threshold now the gate rounds have added to it (Option D, Cons), and Option C is the
  better library and still loses. With the formatter, the filter and the middleware's `ContextVar`
  in one place, the whole correlation story is one module a reviewer reads and one surface a test
  drives. Option E fails because it cannot reach the tree that has the defect.
- **Axis 2: replicas and the join.** Option G is the only selector a second replica does not
  break, and the environment label is what stops an investigation reading production while
  believing it is in staging. Option I beats Option H because the id is only worth having if the
  edge access log, the audit trail and the nonce carry the same one; the application's alphabet
  check stays as the backstop the edge cannot remove.
- **Axis 3: a guarantee we cannot keep is worse than none.** No document lists what a scrub
  would scrub, so Option J would ship the class-B defect this map exists to remove. Option K
  states what the line carries, minimises structurally where it can, and names the residual,
  `message`, rather than claiming it away.

**Why one record.** The three halves only hold together: a correct line under the wrong label
returns nothing (`MAP-RULE-OWNERSHIP.md` Batch G1), a correlation id the client chose undermines
the join the line exists to support, and the GDPR and threat positions rest on the minimisation
being the whole of what the line promises. A later decision that changes any half — most
plausibly the scrub — supersedes this record and has to restate the other two.

## Consequences

- **Positive:** the twelve documents' promise becomes true for every line Django's `LOGGING`
  emits, and `MONITORING-AND-INCIDENT.md` _Log format and integrity_ is met for the application
  stream; the documented queries return the lines they describe, on any replica count, in either
  environment.
- **Positive:** no dependency is added — nothing in `pyproject.toml` or `uv.lock` moves — and
  every generated project inherits a working pipeline rather than a gap.
- **Positive:** every claim the documents make about the line is one a named test holds, so a
  regression fails a test rather than an incident query. **The field set is pinned by these, and
  changing it means a superseding ADR:** the key-set and `exc_info`-shape assertions in
  `QA-PLAN-US014-*` Section 2 (HP-02, HP-05, EC-08 to EC-10, EC-12, EC-17, EC-19, EC-23) are the
  rename tripwire; the filter-overwrite and colliding-extra tests (`ASSESSMENT-PLAN-US014-*`
  Sections 7.1, 7.2); the returned-4xx test under `Client` and `AsyncClient` (7.3); the
  per-environment settings test — the filter on every handler, `ext://sys.stdout`, the formatter
  mode, and the `django` logger in staging, production and test (7.6, 7.7); and the null pin for
  out-of-extent records (7.14). That no redaction is claimed is a `US014.md` GDPR acceptance
  criterion checked at review, not by a test. **The collector and edge half has no automated
  check here**; it is checkable only in the deploy repository.
- **Negative / trade-off:** `message` is unscrubbed. A project call site that interpolates an
  email reaches staging and production stdout intact (TM-05), and the Art. 11 position holds only
  while call sites keep identifiers out of `message` and out of URL path segments
  (`GDPR-PLAN-US014-*` Section 5). This is a discipline, stated in `DJANGO-LOGGING.md`, not a
  control.
- **Negative / trade-off:** the formatter is ours. Its fallback, cap and chain walk carry edge
  cases a library would have met in the field, and the line contract is now a published interface
  — renaming a field is a breaking change to every generated project's queries, so it needs a new
  ADR and a `copier update` advisory, not an edit.
- **Negative / trade-off:** the queries are only as true as the deploy repository. Every label,
  the stderr collection, the retention and the rotation are obligations this repository states
  and cannot test; a collector that skips the relabel returns `unknown_service` and nothing fails.
- **Negative / trade-off:** what is outside the claim stays outside it — the process-server stream
  is plain text on stderr and can rarely carry an escaped ASGI traceback with its message (TM-13);
  records outside the middleware's dynamic extent are uncorrelated (TM-18); a line over 4 KiB can
  interleave across workers (TM-20); every 4xx is a `WARNING` line (R2-Q3).
- **Follow-on — this repository, inside US014:** `apps/core/observability.py` and its unit tests;
  the five settings modules (`base.py`'s block deleted, a dated exception to
  `code/src/django/config/settings/CLAUDE.md`); `RequestIDMiddleware`'s stored id; the three
  entrypoints (`--access-logfile` dropped, staging at `--log-level warning`); the dev log mount;
  `EDGE-REQUIREMENTS.md` entry 13 and its new log-collection section; and the documents
  `US014.md` _Documentation Tasks_ names, including `DJANGO-LOGGING.md`'s scrub sentence marked a
  forward reference and `OBSERVABILITY.md`'s file-tail diagram corrected.
- **Follow-on — the deploy repository (`<%DEPLOY_REPO%>`):** the edge sets `X-Request-ID` from its
  own `$request_id` unconditionally and logs it in the access-log format; the collector reads
  stdout and stderr through the daemon, relabels `com.docker.compose.service` to `service_name` and
  `com.docker.compose.project` to an environment label, and retains per the stated window — 14
  days staging, 90 days production, as reference defaults the controller confirms; the host sets
  `json-file` `max-size` and `max-file`. The edge access log's own retention is the controller's
  and is not set here (`GDPR-PLAN-US014-*` Section 4). **Ordering:** the edge clause must be
  deployed before any surface goes live or entry 2's nonce is activated (`THREAT-MODEL-PLAN-US014-*`
  Section 3a, TM-01).
- **Follow-on — the controller of each generated project:** the LIA under Art. 6(1)(f), the
  retention figures and the Art. 11 position, a supplied `request_id` included, are surfaced for
  legal sign-off, not decided (`GDPR-PLAN-US014-*` Sections 3 to 5).
- **Follow-on — the trigger that supersedes Axis 3:** a `syntek-observability` package in
  `syntek-modules`, holding the curated scrub key list, OTLP tracing wiring and metrics, is built
  when **a second Syntek product needs the same scrub list, or tracing is un-deferred, whichever
  comes first** (`MAP-RULE-OWNERSHIP.md` Batch G1). That decision supersedes this record by full
  filename and restates the line and collector contracts it keeps. It is the only supersession
  trigger.
- **Follow-on — re-review, not supersession:** the deployment posture leaving `development`
  (`.claude/CLAUDE.md` Section 0) is the event that sends this record back for review against a
  live surface.
- **Follow-on — severity promotions, not reopenings:** the `THREAT-MODEL-PLAN-US014-*` Section 3a
  rows raise a threat to `MEDIUM` and send a project to the `incident` skill or the security path,
  not to a new ADR. TM-01's reads: _"Any surface goes live with audit entries joined on
  `request_id`, or entry 2's CSP nonce activated, and Q7's edge clause not yet deployed"_. TM-14
  and TM-15's — _"A deploy repository realises the collector without the label contract the new
  section states"_ — is a breach of this record, not grounds to supersede it.
