# GDPR Plan — US014 Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Field           | Value                                                                                                                                                                                                                                                        |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Story**       | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                         |
| **Date**        | 01/11/2026                                                                                                                                                                                                                                                   |
| **Author**      | Claude (`gdpr-mechanics`), for <%DEVELOPER_NAME%>                                                                                                                                                                                                            |
| **Status**      | Draft — sign-off pending <%DEVELOPER_NAME%>; the lawful basis, the retention numbers and the rights position are surfaced to each generated project's controller, and the rights position is flagged for legal sign-off (Section 5)                          |
| **PII in play** | Yes — incidental, no new field. The story adds no personal-data column or form; personal data can reach the log stream through the unscrubbed `message`, through dev's wide extras, and through `request_id`, which the edge access log joins to a client IP |

<!-- Written 01/11/2026 on pm/story-creation at HEAD 66eb725. Every line number below was
     re-measured against that tree the same day; none is inherited from the story or the scoping
     pass. Lines in files US013 also edits are re-measured again after US013 merges, as US014's
     Dependencies require.

     STEP 1's GRILLING PASS is the specify-gates grilling round 1 of 01/11/2026, <%DEVELOPER_NAME%>,
     cited below as "gates grilling 01/11/2026, Qn". Q1 to Q4 are this gate's; Q5, Q6 and Q7 are
     10-security-checks', Q8 and Q9 are 11-qa-checks', Q10 and Q11 are 14-logging-checks'. Q6 and
     Q11 are cited here because they change what this plan may claim about `message` and about the
     host copy of the stream. Claude's calls put in the same round and not objected to are settled
     too; the one this gate owns is PII in play = Yes (incidental, no new field). The story's own
     cutting interview, "grilling 31/10/2026, Q1 to Q11", is recorded in US014.md and is not
     re-opened.

     WHO THE CONTROLLER IS. This plan describes the template's pipeline. Each generated project is
     the controller of its own log data; what it inherits from this gate is the pipeline's
     behaviour and the DATA-INVENTORY.md 15a example row (copier.yml:157 excludes
     project-management/src/**, and :178 re-includes DATA-INVENTORY.md). So this plan can make the
     shipped wording true. It does not decide any project's lawful basis, retention period or
     rights handling: each is recorded as surfaced (.claude/skills/gdpr-mechanics/SKILL.md:41-42).

     TEMPLATE ADAPTATIONS. This is the first GDPR plan in the repository, and US014 is a
     pipeline-only story with no table, form or endpoint. Each departure from
     GDPR-PLAN-US000-TEMPLATE.md is deliberate:
     - Section 1, Data flows, is ADDED. The template opens on fields in tables; a logging story's
       subject is where a line goes, per environment. The matching IMPLEMENTATION template opens on
       "1. Data flows implemented", so the plan and its record now align section for section.
     - Section 2's columns: "Table / store" reads the log stream and its store; "Encryption" reads
       "At rest", which for staging and production is the collector's property, deploy-side, and
       is not decided in this repository.
     - Section 4's retention is per environment and enforced outside the Django app.
     - Section 5 has no export or erasure endpoint to name; the position recorded instead is the
       Art. 11 one, flagged for legal sign-off.
     - Sections 6 and 7 are N/A, each with its reason, rather than deleted, so the record can
       close them.
     - Sections 8 and 9 are ADDED: the two field decisions this gate settled (the access log, and
       what `message` still carries), and the target wording for the shipped register row, which is
       an implementation task of US014 and is not edited at this gate.
     - The template's "[EXAMPLE]" rows are all replaced; none is kept. Where "example default"
       appears in Section 2 it quotes the shipped DATA-INVENTORY.md marker on the 15a row
       (Section 3), not an unfilled template row.

     INDEPENDENT REVIEW 01/11/2026 (09-gdpr-compliance independent pass), folded the same day.
     Applied: Section 5's "no direct identifier by construction" narrowed to what the pipeline
     adds, conditional on call sites keeping identifiers out of `message` and URL paths (Q5);
     Art. 11(2) stated, so a request that supplies a `request_id` may have to be served, and that
     joins the legal sign-off; the gunicorn error log re-routed from 10/11 (whose answers closed
     without ruling on it) to OPEN with <%DEVELOPER_NAME%>; dev keeping uvicorn's access log
     re-cited as this plan's inference, not Q9, and OPEN with <%DEVELOPER_NAME%>, with its client
     address and query string added to Section 2 and the Section 9 dev clause, and the dev row
     re-cited to uvicorn's default access logger rather than entrypoint.dev.sh:32; Section 8.1
     reworded, the hasHandlers() reason added, uvicorn 0.52.3 and Django 6.1.2 pinned
     (uv.lock:1921-1922, :611-612); the edge access log's retention surfaced as the deploy
     repository's and the controller's (CHECKLIST.md:20); the Section 2 lawful-basis cells and
     this comment made consistent. Story feedback amended in the gate's return, not here.

     ROUND 2 01/11/2026, <%DEVELOPER_NAME%>, cited as "gates grilling round 2, 01/11/2026, Qn".
     It settles all three items this plan had left OPEN with <%DEVELOPER_NAME%>: the gunicorn and
     uvicorn error stream on stderr (Q1: the claim is narrowed to "every line Django's LOGGING
     emits", and the process-server stream is documented with a LogQL selector that keeps it,
     not routed through LOGGING); Art. 11(2) (Q7: a supplied request_id may have to be served,
     flagged for legal sign-off); and dev's uvicorn access log (Q8: kept, as disposable while the
     posture is development, with every "dev is JSON" claim narrowed to Django's lines). Also
     folded where they touch this plan: test.py declares the django logger with no handlers too
     (Q2); 4xx WARNING lines from django.request are accepted (Q3); the middleware stores the id
     on the request, and the filter falls back to it for a returned-error django.request record
     (Q4); the formatter's fallback stays one JSON object (Q5). Q6 (the exc_info JSON shape) is
     QA's and changes nothing here. No item is left OPEN with <%DEVELOPER_NAME%>; the
     controller-owned items stay open by design.

     ROUND 3 AND CONSISTENCY PASS 01/11/2026, <%DEVELOPER_NAME%>, cited as "gates grilling
     round 3, 01/11/2026, Qn". None of it adds a data element, a field or a store; each changes
     what an existing line holds. Folded: Q1, the minimal formatter's 16 KiB cap with a
     `"truncated": true` marker, which removes content and adds none (Sections 1 and 2); Q2, the
     fallback keeps extras str()-coerced in place under the allowlist and, on a getMessage
     failure, writes str(record.msg) without its args, so the args never reach the line
     (Section 2); Q3, records outside the middleware's dynamic extent are uncorrelated, with
     request_id null, so they join to no edge record and cannot be found by a supplied id
     (Sections 2 and 5); Q4, staging's process-server --log-level becomes warning, as
     production (Sections 1 and 2). Q5 (story points) changes nothing here. Consistency
     findings applied: the django/core/handlers/exception.py cites standardised on the story's
     form, BadRequest :106-113 and SuspiciousOperation :130-138, re-measured at Django 6.1.2
     (Sections 2 and 8.2); the Section 10 suggestion to 11-qa-checks marked answered by QA
     AC-GAP-14 and ES-10, with the runtime half recorded unmeasured. Line cites into the
     entrypoints and the Django source re-measured the same day. -->

<!-- SCOPED QA-TESTER RE-CHECK FOLD 01/11/2026. Section 2's request_id bullet: the thread a view
     starts is uncorrelated on the default (non-free-threaded) build; Python 3.14's free-threaded
     build inherits the context (QA-PLAN-US014 EC-21b). -->

---

## 1. Data flows per environment

What reaches each environment's log stream once US014 ships. "Minimal" and "wide" are the
formatter modes US014 settles (grilling 31/10/2026, Q9, Q11).

| Environment    | What writes                                                                                                                                                                                                                                                                                                                                                                                                            | Line content                                                                                                                                                                                                                                                                                                  | Where it lands                                                                                                                                                                                                                         |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Staging**    | Django's root logger at WARNING through the JSON formatter, minimal, and the `request_id` filter, to `sys.stdout`. The app server's access log is **not written** (Section 8.1). Gunicorn's error log stays on `--error-logfile -`: the process-server stream, outside `LOGGING`, at `--log-level warning` as production (`entrypoint.staging.sh`:29, from `info`; gates grilling round 3, 01/11/2026, Q4) (Section 2) | `timestamp` (UTC), `level`, `logger`, `message`, `request_id` (null for an uncorrelated record, round 3 Q3); `exc_info` only when the record has one, as type and frames; extras only `duration_ms`, `status_code`, `method`; a line is capped at 16 KiB and marked `"truncated": true` when cut (round 3 Q1) | Container stdout -> the Docker `json-file` driver on the host, rotated by `max-size` / `max-file` (gates grilling 01/11/2026, Q11) -> the collector, which relabels the Compose labels -> the log store, kept for the retention window |
| **Production** | As staging                                                                                                                                                                                                                                                                                                                                                                                                             | As staging                                                                                                                                                                                                                                                                                                    | As staging; the collector relabels `com.docker.compose.project` to an environment label, so staging and production lines never share a query (gates grilling 01/11/2026, Q10)                                                          |
| **Dev**        | Django's root logger at DEBUG through the JSON formatter, wide, and the filter, to the console and to the existing `RotatingFileHandler`. Uvicorn runs directly at `--log-level debug` (`entrypoint.dev.sh:27-32`) and its default access logger stays on (`uvicorn/config.py`:111 at 0.52.3) — kept, as disposable while the posture is development (gates grilling round 2, 01/11/2026, Q8)                          | Every extra, an unserialisable one as its `str()` — so a `django.request` record's `request` appears as `<ASGIRequest: METHOD 'full_path'>`, query string included — and the full traceback, exception message included; plus uvicorn's plain-text access line, client address and query string included      | Container stdout on the developer machine, and `code/src/logs/django.log` on the **host** through the new bind mount, six files of 10 MB at most (`dev.py:55-60`)                                                                      |
| **Test**       | One console handler, no formatter, root at WARNING, carrying the filter only so the every-handler invariant holds (`test.py:38-43`, as rewritten); the `django` logger declared with no handlers at WARNING (gates grilling round 2, 01/11/2026, Q2). The access log is **not written** (Section 8.1)                                                                                                                  | Plain text of synthetic test data                                                                                                                                                                                                                                                                             | The test container's stream, discarded with the container                                                                                                                                                                              |

**Outside this repository but keyed on this stream.** The edge proxy's access log records the
same `request_id` (`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`:288-290) beside the
request line and, in an access-log format such as Nginx's default, the client address. It is the deploy repository's
store, not this pipeline, and it is the reason `request_id` is pseudonymous rather than anonymous
(Section 2). Once Q1 drops the app server's access log it is the **only** access record, holding
the client IP against `request_id`, so its retention is personal-data retention too. That period
is the deploy repository's and the controller's decision, surfaced here rather than set
(Section 4).

**No email egress.** `ADMINS` is set in no settings module, so Django's default `mail_admins`
handler (ERROR, `require_debug_false`) sends nothing; and 11-qa-checks' settled answer declares
the `django` logger with `"handlers": []` in staging and production (gates grilling 01/11/2026,
Q8), and in test too (gates grilling round 2, 01/11/2026, Q2), which removes that handler
outright. No request data leaves by email, and a project that
later sets `ADMINS` does not reopen the route by doing so.

## 2. Personal data introduced or touched

No field is introduced. These are the routes by which personal data can be present in a line.

| Data element                  | Stream / store                                       | Purpose                                                    | Data subject                        | Lawful basis                                                      | At rest                                                     |
| ----------------------------- | ---------------------------------------------------- | ---------------------------------------------------------- | ----------------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------- |
| `request_id`                  | Every line, every environment                        | Correlate one request's lines with each other and the edge | Any requester                       | Art. 6(1)(f) — the shipped register's example default (Section 3) | Collector-side, deploy repo (staging/prod); host disk (dev) |
| `message` free text           | Every line; not scrubbed                             | The event's description                                    | Whoever a call site or Django names | Art. 6(1)(f) — the shipped register's example default (Section 3) | As above                                                    |
| `request` repr (query string) | Dev only — a wide extra                              | Debugging on a developer machine                           | The requester                       | Art. 6(1)(f) — the shipped register's example default (Section 3) | Host disk, `code/src/logs/` (gitignored)                    |
| Full traceback with message   | Dev only — the wide exception shape                  | Debugging on a developer machine                           | Whoever the exception text names    | Art. 6(1)(f) — the shipped register's example default (Section 3) | As above                                                    |
| Dev app-server access line    | Dev only — uvicorn's default access logger (R2-Q8)   | Request trace on a developer machine                       | The requester                       | Art. 6(1)(f) — the shipped register's example default (Section 3) | Container stdout on the developer machine                   |
| Any other extra               | Dev only — dropped, not masked, in staging/prod (Q9) | Whatever a call site passes                                | Any                                 | Art. 6(1)(f) — the shipped register's example default (Section 3) | As above                                                    |

- **`request_id` is pseudonymous personal data.** It is a `uuid4().hex`, or a client-supplied
  value matching `[A-Za-z0-9._-]{1,200}` (`code/src/django/apps/core/middleware.py`:17, :40-41).
  On its own it identifies no one; joined to the edge access log it yields an IP, and the user is
  shown it to quote back. The middleware also stores it on the request, and the filter falls
  back to that stored id for a returned-error `django.request` record (gates grilling round 2,
  01/11/2026, Q4), so those lines carry it too — the same pseudonymous value, not a new one.
  A record written outside the middleware's dynamic extent — a streaming body, a thread a view
  starts (on the default (non-free-threaded) build; Python 3.14's free-threaded build inherits the context (QA-PLAN-US014 EC-21b)), a mid-stream ASGI exception — is **uncorrelated**: its `request_id` is null (gates
  grilling round 3, 01/11/2026, Q3). It joins to no edge record and no supplied id finds it;
  its `message` is still unscrubbed, so the retention window is what bounds it. This is the basis of the PII-in-play Yes. Whether a client-chosen id is
  a threat is 10-security-checks' (gates grilling 01/11/2026, Q7, where the edge discards any
  client value).
- **`message` is not scrubbed** (grilling 31/10/2026, Q9). What it can carry in staging and
  production: a request path from `django.request`, never its query string — Django formats
  `request.path`, not `get_full_path()` (`django/core/handlers/exception.py`:77-79, :106-113,
  :145-148, at Django 6.1.2), and one such WARNING line for every returned 4xx, a volume accepted (gates grilling
  round 2, 01/11/2026, Q3); `str(exc)` for `BadRequest` and every `SuspiciousOperation` (Section 8.2); and
  whatever a project's own call sites write. The no-PII-in-a-path-segment rule that covers the
  first is 10-security-checks' (gates grilling 01/11/2026, Q5).
- **What staging and production never carry**: any extra outside `duration_ms`, `status_code`
  and `method`, so `request`, `email`, `path` and the rest are dropped (grilling 31/10/2026, Q9);
  the exception message inside `exc_info` (Q11); SQL and its parameters (`django.db.backends`
  is not raised above the WARNING root); the app server's access line with its client address
  and query string (Section 8.1).
- **Outside the JSON pipeline in staging and production**: the app server's own error log,
  `--error-logfile -`, plain text on stderr. Docker's `json-file` driver captures stderr as well
  as stdout, so these lines reach the collector and the log store. In normal running they are
  worker warnings and errors — staging now runs the process server at `--log-level warning`, as
  production, so its info-level lifecycle lines are no longer written (gates grilling round 3,
  01/11/2026, Q4); an exception that escapes the ASGI application writes its traceback, message
  included, which the Q11 minimisation does not cover. **RESOLVED** (gates grilling round 2,
  01/11/2026, Q1): it is not routed through `LOGGING`. US014's claim is narrowed to "every line
  Django's `LOGGING` emits", and the process-server stream (`gunicorn.error` and
  `uvicorn.error`) is documented as what it is — plain text on stderr that can carry an escaped
  ASGI traceback with its message, rarely — with a LogQL selector that keeps it. It lands in the
  same log store, so the Section 4 retention window bounds it too.
- **A line the formatter cannot serialise** stays one JSON object: the fixed field set, with any
  unserialisable value `str()`-coerced (gates grilling round 2, 01/11/2026, Q5). The extras
  are coerced in place and stay subject to the allowlist; if `getMessage()` fails, `message` is
  `str(record.msg)` without its args, so the args never reach the line; all coercion runs
  through a guarded repr that cannot raise (gates grilling round 3, 01/11/2026, Q2). The
  fallback adds no field and widens nothing the allowlist drops.
- **A line over 16 KiB is truncated** in staging and production and marked `"truncated": true`
  (gates grilling round 3, 01/11/2026, Q1). Truncation only removes content; the marker is a
  boolean and holds no personal data. The rare interleave of two workers' lines above 4 KiB
  (`PIPE_BUF`) is an accepted residual: it can mix fragments of two lines, but adds nothing the
  two lines did not already hold.
- **Frames carry no source text and no locals.** "Type and frames" is `(filename, lineno,
function)` per frame; the `__cause__` / `__context__` chain is walked type-only and PEP 678
  notes are dropped (Claude's call in gates grilling 01/11/2026, not objected to). A personal
  data literal in source or a local variable therefore cannot reach `exc_info`.

## 3. Lawful basis

- **Operational logging of the application stream** — Art. 6(1)(f) legitimate interests
  (operational monitoring and debugging), kept as the shipped `[EXAMPLE]` default, with **"LIA
  owed by the project's controller"** added (gates grilling 01/11/2026, Q2). Surfaced, not
  decided for any project. Under (f) the register requires a Legitimate Interests Assessment on
  record (`../CONSENT-LAWFUL-BASIS.md`:29); none exists in the template and none is written here.
- **Not widened.** No `[EXAMPLE]` "application logging" rows are added to
  `../CONSENT-LAWFUL-BASIS.md` or `../RETENTION-DELETION.md`: the option was put and not chosen
  (Q2), and the 15a row in `../DATA-INVENTORY.md` remains the one place the shipped template
  states it.
- **Out of scope:** the security and audit stream, whose field list and retention are
  `code/docs/security/MONITORING-AND-INCIDENT.md`'s (US014 Out of Scope), and the audit trail's
  Art. 6(1)(c) basis in `../DATA-INVENTORY.md` Section 15.

## 4. Retention & deletion

| Data category                    | Retention period                                                                                   | Trigger / basis                  | Deletion mechanism                                                                                                               |
| -------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Staging application log lines    | 14 days — **reference default the controller confirms** (`code/docs/logging/OBSERVABILITY.md`:156) | Age of the line in the log store | The collector's retention, enforced by the deploy repository, stated in `EDGE-REQUIREMENTS.md`'s new log-collection section (Q3) |
| Production application log lines | 90 days — **reference default the controller confirms** (`OBSERVABILITY.md`:157)                   | As above                         | As above                                                                                                                         |
| Host copy of container stdout    | Bounded by size, not age                                                                           | `json-file` rotation on the host | `max-size` / `max-file` on the Docker log driver, required in the same section (gates grilling 01/11/2026, Q11)                  |
| Dev log file                     | Bounded by size: six files of 10 MB at most (`dev.py:55-60`)                                       | `RotatingFileHandler` rollover   | Rotation overwrites the oldest; the data is disposable while the posture is development (`.claude/CLAUDE.md` Section 0)          |
| Edge proxy access log            | **Not set here** — the deploy repository's and the controller's decision, surfaced                 | Age of the line                  | The deploy repository's own rotation; the only access record once Q1 ships, holding the client IP against `request_id`           |
| Test log stream                  | None kept                                                                                          | The test container's lifetime    | Discarded with the container                                                                                                     |

The numbers are the controller's (gates grilling 01/11/2026, Q3). `OBSERVABILITY.md`:154-157 is
the only retention value the template ships for logs; citing it as a reference default removes
the conflict with the 15a placeholder without inventing a window, and putting the line in
`EDGE-REQUIREMENTS.md` puts it where the deploy repository reads its obligations.

## 5. Data subject rights impact

**Position recorded, flagged for legal sign-off** (gates grilling 01/11/2026, Q4). The pipeline
adds no direct identifier to a staging or production line, and the allowlist drops every extra
but three. `message` can still carry one (Section 2), so the position below holds **only while a
project's call sites keep identifiers out of `message` and out of URL path segments** (gates
grilling 01/11/2026, Q5). That condition is part of what the legal sign-off covers. On that
premise, Art. 11(1) does not require a controller to acquire identifying information solely to
serve a right, so no per-subject search over the log store is built.

- **Access (Art. 15)** — not served by a per-subject search; the logs are not part of the SAR
  export. Exposure is bounded by the retention window in Section 4.
- **Erasure (Art. 17)** — met by retention expiry, not by a targeted delete.
- **Portability (Art. 20)** — not engaged: the processing rests on Art. 6(1)(f), and the right
  applies to processing based on consent or contract (Art. 20(1)(a)). Part of the same legal
  sign-off.
- **Object (Art. 21)** — answered by the LIA owed in Section 3; `../DATA-SUBJECT-RIGHTS.md`
  Right 6 already names logging among the legitimate-interests objection paths a project
  records.
- **Rectification / Restriction / Withdraw consent** — N/A: the lines record events, not facts
  held about a person, and consent is not the basis.

**Art. 11(2) — a supplied `request_id`.** A subject who quotes a `request_id` from an error page
is the one case where identification is offered rather than acquired. Art. 11(2) then reapplies
Arts 15 to 20: where the subject provides information that enables identification, the
controller may have to serve the request against the lines that id keys, within the retention
window. Q4 settled that no per-subject search is built; it did not settle that such a request
may be refused, and this plan does not say it may. **RESOLVED** (gates grilling round 2,
01/11/2026, Q7): the plan states that **a supplied `request_id` may have to be served**, and
that statement is **flagged for legal sign-off** with the rest of this section. How a project
serves one is its controller's decision, within that sign-off. A supplied id reaches only the
lines that carry it: an uncorrelated record (`request_id` null, gates grilling round 3,
01/11/2026, Q3) is not among them, and is bounded by the retention window alone.

## 6. Third-party processors touched

N/A for this story — it adds none. The collector and log store are the reference stack, and
whether either is hosted is decided per project. A project that ships its logs to a hosted
service records it in its own `../THIRD-PARTY-PROCESSORS.md` as a sub-processor with an Art. 28
DPA; one that self-hosts records it there as self-hosted infrastructure.

## 7. Consent & PECR

N/A. Consent is not the lawful basis, and the story has no UI, cookie or electronic marketing
(US014 FLAGS: no screen, component, page or endpoint).

## 8. Field decisions this gate settled

### 8.1 The app server's access log is dropped

`--access-logfile -` is removed from `code/src/docker/django/entrypoint.staging.sh`:30,
`entrypoint.prod.sh`:31 and `entrypoint.test.sh`:27 (gates grilling 01/11/2026, Q1). Measured
at uvicorn 0.52.3 (`uv.lock`:1921-1922). With the flag present, gunicorn hands `uvicorn.access`
its own handlers with `propagate=False` (`uvicorn/workers.py`:40-43), so each request writes a
plain-text line holding the client address and the query string — outside the JSON formatter
and the filter, and false to "every line is one JSON object". With the flag removed, the logger
has no handlers and does not propagate, so `access_logger.hasHandlers()` is false and the
protocol writes no access line at all (`uvicorn/protocols/http/h11_impl.py`:57). The edge access
log owns access records, keyed on the same `request_id`.

Dev is not covered by Q1, which names only the staging, production and test entrypoints. Dev
runs uvicorn directly, whose default access logger writes to stdout (`uvicorn/config.py`:111).
**RESOLVED** (gates grilling round 2, 01/11/2026, Q8): dev keeps uvicorn's plain-text access
log, client address and query string included, as disposable while the posture is development
(`.claude/CLAUDE.md` Section 0). Every "dev is JSON" claim US014 writes is narrowed to Django's
lines.

### 8.2 `str(exc)` still reaches `message` — the claim narrowed

`exc_info` carries no exception message in staging and production (grilling 31/10/2026, Q11).
That is narrower than "no exception text reaches stdout", and the plan says so (gates grilling
01/11/2026, Q6): Django's `BadRequest` record formats `"%s: %s"` from `str(exc)` and
`request.path` (`django/core/handlers/exception.py`:106-113, measured at Django 6.1.2, `uv.lock`:611-612), and every `SuspiciousOperation`
record logs `str(exc)` as its message to `django.security.<ClassName>` (:130-138). Both land in
the unscrubbed `message`. The wording owed in `DJANGO-LOGGING.md`, the Security AC and the 15a
row must state this, and nothing written for US014 may claim exception text never reaches
staging or production stdout.

## 9. Target wording for `DATA-INVENTORY.md` 15a

An implementation task of US014, applied in `../DATA-INVENTORY.md` itself and **not edited at
this gate**. Measured at HEAD: the row is :199 and the guidance line :201. The implementer
re-measures before editing.

**:199 — the row**, columns unchanged:

| Data field                       | Description                                                                                                                                                                                                                                                                                       | PII?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Retention                                                                                                                                                                                                          | Lawful basis                                                                                                     |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| `[EXAMPLE]` Structured log lines | One JSON object per line on container stdout: timestamp (UTC), level, logger, message, request id, exc_info only when present. Staging/production keep only the extras duration_ms, status_code and method, and log an exception as type and frames; dev keeps every extra and the full traceback | Minimised, not scrubbed — no redaction ships. Staging/production drop every other extra and the exception message from exc_info; DB backend logs suppressed; the app server writes no access log outside dev, and its own error log, plain text on stderr, is outside this pipeline. The message is not scrubbed: it can hold a request path (never its query string) and, for Django's BadRequest and SuspiciousOperation records, the exception text. The request id is pseudonymous — the edge access log holds the IP against it. Dev serialises a request's repr, query string included, and dev's app-server access line holds the client address and query string | Staging 14 days, production 90 days — reference defaults the controller confirms, enforced by the log collector; host copies bounded by json-file rotation; dev size-bounded (six 10 MB files); test keeps nothing | Art. 6(1)(f) — legitimate interests (operational monitoring and debugging); LIA owed by the project's controller |

**:201 — the guidance line**:

> _Record what the application's structured logs contain and what the pipeline minimises — the
> staging/production extras allowlist and the dropped exception message — and state that
> `message` is not scrubbed. Name the controller's Legitimate Interests Assessment, confirm the
> retention period per environment and where the collector enforces it, and record any hosted
> collector in `THIRD-PARTY-PROCESSORS.md`._

What each clause of the shipped row becomes, so none is lost silently:

| Shipped clause (:199 / :201)         | Becomes                                                                                                                                |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| "No PII"                             | "Minimised, not scrubbed" — `message` and `request_id` can carry personal data (Section 2)                                             |
| "query strings stripped"             | "never its query string" — true of the staging/prod Django pipeline, with the access log dropped (Section 8.1); dev keeps both (R2-Q8) |
| "DB backend logs suppressed"         | Kept: true as stated                                                                                                                   |
| "no email, name, or IP logged"       | Removed — cannot be promised while `message` is not scrubbed; the IP sits in the edge log, joined by `request_id`                      |
| "{retention period per environment}" | The reference defaults and their enforcement point (Section 4)                                                                         |
| "confirm PII is scrubbed at source"  | "state that `message` is not scrubbed" — nothing scrubs at source (N-020)                                                              |

## 10. GDPR tasks & open gaps

Concrete requirements to satisfy **during** implementation. The record
`../IMPLEMENTATION/GDPR-IMPL-US014-*.md`, written at `22-implementation-documentation`, closes
each one with evidence.

- [ ] Remove `--access-logfile -` from `entrypoint.staging.sh`:30, `entrypoint.prod.sh`:31 and
      `entrypoint.test.sh`:27 (Section 8.1; gates grilling 01/11/2026, Q1)
- [ ] Mark `DJANGO-LOGGING.md`:34-35's redaction claim a forward reference (US014 GDPR task; N-020)
- [ ] Write the minimisation claim into `DJANGO-LOGGING.md`'s staging/prod section, narrowed per
      Section 8.2: `exc_info` carries no exception message, but `BadRequest` and
      `SuspiciousOperation` records carry `str(exc)` in the unscrubbed `message` (Q6)
- [ ] Replace `DJANGO-LOGGING.md`:47's `extra={"email": email}` with an identifier (US014 GDPR task)
- [ ] Apply Section 9's wording to `../DATA-INVENTORY.md`:199 and :201, re-measured first
      (Q1, Q2, Q3, Q6)
- [ ] Add the retention line to `EDGE-REQUIREMENTS.md`'s new log-collection section — the 14 / 90
      day reference defaults, confirmed by the controller, enforced by the collector — beside the
      `json-file` rotation requirement (Q3, Q11)
- [ ] Carry the Section 5 rights position into the implementation record unchanged, still
      flagged for legal sign-off; build no per-subject log search (Q4)
- [ ] **Open, the controller's:** the LIA for Art. 6(1)(f), the confirmed retention numbers, and
      the legal sign-off of the Art. 11 position — surfaced to each generated project, never
      closed by this template
- [ ] **Open, the controller's:** the edge access log's retention — the only access record once
      Q1 ships, holding the client IP against `request_id`; recorded by the deploy repository,
      never set by this template (Section 4)
- [ ] **RESOLVED (gates grilling round 2, 01/11/2026, Q1) — the process-server error stream.**
      Gunicorn's `--error-logfile -` and `uvicorn.error` stay plain text on stderr in staging,
      production and test, and reach the log store through the `json-file` driver. Not routed
      through `LOGGING`. Task: narrow every "every log line is one valid JSON object" claim US014
      writes to "every line Django's `LOGGING` emits", and document the process-server stream —
      plain text, stderr, can carry an escaped ASGI traceback with its message (rare) — with a
      LogQL selector that keeps it (Section 2)
- [ ] **RESOLVED (gates grilling round 2, 01/11/2026, Q7) — Art. 11(2).** The plan states that a
      supplied `request_id` may have to be served, flagged for legal sign-off. Task: carry that
      statement, unchanged, into the implementation record and US014's Out of Scope bullet;
      build no per-subject search (Section 5; gates grilling 01/11/2026, Q4)
- [ ] **RESOLVED (gates grilling round 2, 01/11/2026, Q8) — dev's access log.** Dev keeps
      uvicorn's plain-text access log, client address and query string included, as disposable
      while the posture is development. Task: narrow every "dev is JSON" doc claim US014 writes
      to Django's lines (Section 8.1)
- [ ] **ANSWERED by 11-qa-checks (QA-PLAN AC-GAP-14, ES-10; 01/11/2026) — the suggested
      behavioural check** that a request served by the test stack writes no `uvicorn.access`
      line. QA records it as a static row plus a source reading: entry 13 requires `$request_id`
      in the edge access log, and with no `--access-logfile` `uvicorn.access` has no handlers and
      does not propagate, so `hasHandlers()` is false (Section 8.1). The **runtime half is
      unmeasured** — no script reads the test stack's output (`code/docs/GATE-REPORTING.md`);
      the implementation record carries it as unmeasured, never as passed

---

## Cross-references

- `../../02-STORIES/US014.md` — the story analysed; its GDPR flag, ACs and tasks <!-- doc-references: template-only -->
- `../IMPLEMENTATION/GDPR-IMPL-US000-TEMPLATE.md` — the template for the record that closes
  Section 10
- `../DATA-INVENTORY.md` (15a) · `../CONSENT-LAWFUL-BASIS.md` · `../RETENTION-DELETION.md` ·
  `../DATA-SUBJECT-RIGHTS.md` (Right 6) · `../THIRD-PARTY-PROCESSORS.md` — the registers this
  plan feeds
- `code/docs/logging/DJANGO-LOGGING.md` · `code/docs/logging/OBSERVABILITY.md` ·
  `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — the documents the tasks edit
- `project-management/docs/GDPR-GUIDE.md` — the governing GDPR guide
- `project-management/workflows/09-gdpr-compliance/` — the workflow that produced this plan
