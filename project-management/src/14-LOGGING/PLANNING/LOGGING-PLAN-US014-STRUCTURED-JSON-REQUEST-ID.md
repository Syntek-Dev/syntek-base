---
story: "US014"
title: "Structured JSON logging with a request_id on every entry, queried by Compose service label"
status: "Draft"
version: "0.1.0"
created: "01/11/2026"
---

# Logging Plan — US014: Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Field            | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**        | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| **Date**         | 01/11/2026                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| **Sprint**       | SPRINT-08 — admitted 01/11/2026 at `03-sprint-planning`, standing the record at 11 / 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| **Logging flag** | the pipeline itself — JSON formatter and `request_id` filter on every handler Django's `LOGGING` declares; per-environment levels and field sets, the `django` logger at `WARNING` with no handlers in staging, production and test (gates grilling 01/11/2026, Q8; round 2, R2-Q2); the process-server stderr stream documented outside it with a query that keeps it (R2-Q1); the collector relabels `com.docker.compose.service` to `service_name` and `com.docker.compose.project` to an environment label (Q10, Q11) — confirmed 01/11/2026 against Grafana Alloy v1.21 (this plan) |
| **Upstream**     | API design N/A (`US014.md` Flags table, API row, no endpoint) · schema N/A (`US014.md` Flags table, DB row, no model) · GDPR plan `GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` (gate 09, written in the same round)                                                                                                                                                                                                                                                                                                                                                                      |
| **Status**       | Draft — independently reviewed 01/11/2026; round-2 rulings folded 01/11/2026, resolving `LOG-GAP-9`, `LOG-GAP-10` and `LOG-GAP-11`; round-3 rulings and the consistency pass folded 01/11/2026, resolving `LOG-GAP-12` (R3-Q4); no `[OPEN]` row; sign-off pending <%DEVELOPER_NAME%>                                                                                                                                                                                                                                                                                                     |

<!-- Written 01/11/2026 on pm/story-creation at HEAD 66eb725. The first logging plan in the
     repository: 14-LOGGING/PLANNING/ and IMPLEMENTATION/ held only their pairs and templates, so
     there is no precedent and the template is the register.

     STEP 1's GRILLING PASS is the specify-gates round of 01/11/2026 with <%DEVELOPER_NAME%>,
     cited below as "gates grilling 01/11/2026, Qn". This gate's own questions were Q10 and Q11;
     Q3 (retention) was asked jointly with 09, and Q1, Q5, Q6, Q7 and Q8 (asked for 09, 10 and 11)
     change this plan's content and are folded in. The calls Claude stated in that round and that
     were not objected to are cited "gates grilling 01/11/2026, Claude's calls". The story's
     cutting interview, "grilling 31/10/2026, Q1-Q11", is recorded in US014.md and is not
     re-opened here.

     WHY THE TEMPLATE IS ADAPTED. The template assumes a feature story that adds named loggers and
     events. US014 adds neither: it builds the pipeline every future event travels through, and
     N-020 bars the `django.request` and `api` loggers (US014.md Backend Acceptance Criteria, Out
     of Scope). So:
     - Section 1 reads "none", with the reason, and gains a table of the loggers the settings
       CONFIGURE, which is what this story changes. Root is configured, never called.
     - Section 2 holds one row per RECORD CLASS the pipeline formats, each with its exhaustive
       per-environment field set, rather than one row per event. A record class is the unit the
       story's scenarios and tests already use.
     - Section 4 is drawn from the story's field rules and DATA-INVENTORY 15a, not from `[enc]`
       marks: there is no schema, and DB-IDEA does not exist for this story.
     - Section 5 gains 5.1, the collector contract, because the Logging flag hands this gate the
       relabel confirmation and Q10/Q11 settled what the new EDGE-REQUIREMENTS section states.

     NOTHING HERE VERIFIES A RUNNING SYSTEM. Every behaviour of Django, gunicorn and uvicorn below
     is read from source in .venv (Django 6.1.2, gunicorn 26.0.0, uvicorn 0.52.3), not observed.
     The evidence belongs to 22-implementation-documentation and ../IMPLEMENTATION/. -->

<!-- Independent review folded 01/11/2026. Eleven findings, each re-verified against source at
     HEAD 66eb725 and applied; none rejected.
     - LOG-GAP-9 rewritten: the process-server stream is gunicorn.error AND uvicorn.error, on
       stderr, at warning in prod but info in staging and test, with entrypoint.test.sh:28 added
       and its tie to the story's __error__="" AC (US014.md:281-282) and to TM-13 / QA option A/B.
     - Section 4: the stack-trace claim is narrowed to "every line Django's LOGGING emits"; a new
       exclusion row records that uvicorn.error can carry a full traceback with its message.
     - Section 2.2 and the Section 3 Identifiers row: request_id is pseudonymous personal data, as
       the GDPR plan Section 2 classes it, not a "safe identifier".
     - Section 3 Fixed keys row: message marked not scrubbed, with what it can carry and the
       answers that accept it.
     - Section 2.1: records raised outside RequestIDMiddleware (SecurityMiddleware DisallowedHost
       on the SSL-redirect path) carry request_id null.
     - Section 5: dev console gains uvicorn's own lines; a mail_admins row; docker-group read access.
     - Section 2.3: every 4xx at WARNING raised as LOG-GAP-11, OPEN.
     - 5.2 row 3: the unknown_service fallback softened to Loki's default label list.
     - The header Logging flag row carries the exact flag value returned to the story. -->

<!-- Round 2 folded 01/11/2026: the specify-gates round-2 rulings of 01/11/2026 with
     <%DEVELOPER_NAME%>, cited "gates grilling round 2, 01/11/2026, R2-Qn".
     - R2-Q1 resolves LOG-GAP-9: the claim is narrowed to "every line Django's LOGGING emits";
       the process-server stderr stream is documented with a LogQL selector that keeps it, and
       is not routed through LOGGING. Its sub-question (staging's --log-level info against
       prod's warning) is not answered by R2-Q1 and is split out as LOG-GAP-12, OPEN.
     - R2-Q2 resolves LOG-GAP-10: test.py declares the django logger too; Section 1, 2.3, 5.
     - R2-Q3 resolves LOG-GAP-11: the 4xx WARNING volume is accepted here; no GAPS.md row.
     - R2-Q4: RequestIDMiddleware stores the id on the request and the filter falls back to the
       `request` extra's stored id for a returned-error django.request record; Section 2.1, 2.2.
     - R2-Q5: the formatter fallback stays one JSON object of the fixed field set; Section 2.2.
     - R2-Q6: the exc_info JSON shape is pinned at the QA review; Section 2.2.
     - R2-Q7: a supplied request_id may have to be served under Art. 11(2); Section 2.2.
     - R2-Q8: dev keeps uvicorn's plain-text access log; "dev is JSON" means Django's lines.
     - Noted, no question: base.py:50's comment calls RequestIDMiddleware "third in the
       pipeline" though it is second; an implementer doc task, recorded in Section 2.1.
       (Cite corrected 01/11/2026 from :49, which is SecurityMiddleware; consistency pass.) -->

<!-- Round 3 and consistency pass folded 01/11/2026: the specify-gates round-3 rulings of
     01/11/2026 with <%DEVELOPER_NAME%>, cited "gates grilling round 3, 01/11/2026, R3-Qn", and
     the cross-plan consistency findings that concern this file.
     - R3-Q4 resolves LOG-GAP-12: entrypoint.staging.sh:29's --log-level becomes warning, as
       production's (entrypoint.prod.sh:30); Section 2.3, Section 5, Section 6.
     - R3-Q1: the minimal (staging/production) formatter's output is capped at 16 KiB, an
       over-long line truncated and marked "truncated": true; the >4 KiB PIPE_BUF interleave
       across workers is an accepted residual; Section 2.2.
     - R3-Q2: the fallback shape keeps the extras str()-coerced in place, still subject to the
       allowlist; on a getMessage failure message = str(record.msg) without args; all coercion
       through a guarded repr that cannot raise; Section 2.2.
     - R3-Q3: records outside RequestIDMiddleware's dynamic extent (streaming bodies, threads a
       view starts, mid-stream ASGI exceptions) are uncorrelated, request_id null, pinned by a
       test; Section 2.1.
     - Consistency: the R2-Q4 fallback is scoped to a returned-error django.request record in
       Section 2.1 and 2.2, as the story's Backend AC reads; 5.1 item 6 pins the selector the
       story pins, {service_name="django"} | json | __error__!="", with the multiline note
       (QA plan AC-GAP-13 rejects the header-only line filter); SecurityMiddleware is cited at
       base.py:49 alone (:54 is RequestIDMiddleware); the exception.py log_response cite is
       standardised on :106-113, :130-138; every US014.md line cite in the body is replaced by
       the story's section name, since the story's 01/11/2026 fold moved them all. Line cites
       inside the earlier dated comments are left as written then. -->

<!-- SCOPED QA-TESTER RE-CHECK FOLD 01/11/2026. Section 2's out-of-extent row: a ContextVar is
     not inherited by a plain threading.Thread on the default (non-free-threaded) build; Python
     3.14's free-threaded build inherits the context (QA-PLAN-US014 EC-21b). -->

---

## 1. Loggers

**None.** This story adds no module that logs and calls no `logging.getLogger`: there is no
`import logging` anywhere in `code/src/django/` at HEAD, and N-020 bars the `django.request` and
`api` loggers because nothing writes to them (`US014.md` Backend Acceptance Criteria). A generated
project adds its own `apps.<app>` loggers when it has features to log (`US014.md` Out of Scope,
"Named loggers"); the checklist's
`apps.<app>` row is therefore N/A for this story.

What the story **does** change is the configuration of loggers it never calls. These are the
targets the settings modules carry after the story, and the implementation record checks them:

| Logger               | Environment        | Level     | Handlers                | Propagate | Source of the rule                                                         |
| -------------------- | ------------------ | --------- | ----------------------- | --------- | -------------------------------------------------------------------------- |
| root                 | dev                | `DEBUG`   | `console`, `file`       | —         | `US014.md` "Levels follow the environment" (grilling 31/10/2026, Q10)      |
| `django`             | dev                | `INFO`    | `console`, `file`       | `False`   | `dev.py`:65, unchanged (`US014.md` Backend Acceptance Criteria)            |
| `django.db.backends` | dev                | `WARNING` | `file`                  | `False`   | `dev.py`:68, unchanged — SQL parameters stay out of the console            |
| root                 | test               | `WARNING` | `console`, no formatter | —         | `US014.md` "Levels follow the environment"; `test.py`:38-43                |
| `django`             | test               | `WARNING` | `[]` — none of its own  | `True`    | gates grilling round 2, 01/11/2026, R2-Q2 — the same neutralisation        |
| root                 | staging/production | `WARNING` | `console` (stdout)      | —         | `US014.md` "Levels follow the environment" (Q10); at HEAD both read `INFO` |
| `django`             | staging/production | `WARNING` | `[]` — none of its own  | `True`    | gates grilling 01/11/2026, Q8 — the `DEFAULT_LOGGING` survivor neutralised |

**Why the `django` row exists off dev (Q8).** Django applies its `DEFAULT_LOGGING` before the
project's `LOGGING` (`django/utils/log.py`:20-66), and that config declares `django` at `INFO`
with a `console` handler (`require_debug_true`) and `mail_admins` (`require_debug_false`), neither
carrying the `request_id` filter. Staging and production declare no `django` logger at HEAD, so it
keeps level `INFO` and its INFO records propagate to root's handler despite root's `WARNING`.
Declaring `"django": {"handlers": [], "level": "WARNING"}` with propagation on strips the surviving
handlers and binds Q10 to `django.*` in effect, not only in the dict. `test.py` declares the same
logger (gates grilling round 2, 01/11/2026, R2-Q2), so `mail_admins` and `django.*` INFO are off
there too; the settings test asserts it in staging, production and test.
The `django.server` logger in the same default config is used only by `runserver`, which no
staging or production entrypoint runs; it is out of reach and not declared.

---

## 2. Events

**None new** — see Section 1. This section is one row per **record class** the pipeline formats,
which is the unit the story's scenarios test. **The field list is exhaustive.**

### 2.1 Record classes

| Record class                                                           | Environment        | Fields carried                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ---------------------------------------------------------------------- | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Any record                                                             | staging/production | `timestamp`, `level`, `logger`, `message`, `request_id`; plus any of `duration_ms`, `status_code`, `method` the call site passed                                                                                                                                                                                                                                                                                                                                                                                 |
| Any record                                                             | dev                | `timestamp`, `level`, `logger`, `message`, `request_id`; plus every extra the call site passed, an unserialisable one as its `str()`                                                                                                                                                                                                                                                                                                                                                                             |
| Any record                                                             | test               | Standard library default line (no formatter); the filter is attached so the every-handler invariant holds (`US014.md` "Levels follow the environment")                                                                                                                                                                                                                                                                                                                                                           |
| Record with `exc_info`                                                 | staging/production | The above, plus `exc_info` holding the exception type and its frames — no message                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Record with `exc_info`                                                 | dev                | The above, plus `exc_info` holding the full standard-library traceback, message included (`US014.md` exception scenario)                                                                                                                                                                                                                                                                                                                                                                                         |
| Record logged outside a request (start-up, management command)         | all but test       | As its class above, with `request_id` present and `null` — never `""`, never missing (`US014.md` "request_id is always present")                                                                                                                                                                                                                                                                                                                                                                                 |
| `django.request` record for a **returned** 4xx/5xx (`log_response`)    | all but test       | As its class above, with `request_id` equal to the same response's `X-Request-ID` header — not `null`, although Django logs it after the middleware has reset its `ContextVar` (`US014.md` "request_id is always present"). Mechanism: `RequestIDMiddleware` stores the id on the request, and for a returned-error `django.request` record the filter falls back to the id stored on the `request` extra (gates grilling round 2, 01/11/2026, R2-Q4); a `request` extra with no stored id gives `null`          |
| `django.request` / `django.security.*` record for a **raised** error   | all but test       | As its class above; `request_id` from the `ContextVar` when raised inside `RequestIDMiddleware`. Raised by middleware outside it — `SecurityMiddleware` (`base.py`:49), e.g. `DisallowedHost` from `request.get_host()` on the SSL-redirect path (`SECURE_SSL_REDIRECT = True`, `staging.py`:20, `production.py`:20) — `request_id` is `null`                                                                                                                                                                    |
| Record logged outside the middleware's dynamic extent within a request | all but test       | As its class above, with `request_id` `null` — **uncorrelated**: a streaming body iterated after the middleware returns, a thread the view starts (a `ContextVar` is not inherited by a plain `threading.Thread` on the default (non-free-threaded) build; Python 3.14's free-threaded build inherits the context (QA-PLAN-US014 EC-21b)), an ASGI exception raised mid-stream. Recorded in `US014.md` Out of Scope and in `DJANGO-LOGGING.md`, and pinned by a test (gates grilling round 3, 01/11/2026, R3-Q3) |

**The edit set grows with R2-Q4.** `apps/core/middleware.py`, its test under `apps/core`, and the
middleware row of `apps/core/CONTEXT.md` join US014's edit set. **Doc task, no question:**
`base.py`:50's comment calls `RequestIDMiddleware` "Third in the pipeline", but `base.py`:49-54
lists it second, after `SecurityMiddleware`; the implementer checks and corrects it. **R3-Q4
adds** `entrypoint.staging.sh`:29, whose `--log-level info` becomes `warning` (Section 2.3).

### 2.2 Field contract

| Field        | Value                                                                                                                                                                                                                                                                                                                                         | Settled by                                                                                |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `timestamp`  | ISO-8601 in UTC with an explicit offset; the exact string form is pinned in the QA plan                                                                                                                                                                                                                                                       | grilling 31/10/2026, Q4; gates grilling, Claude's calls                                   |
| `level`      | `record.levelname`, upper case — `OBSERVABILITY.md` queries `level="ERROR"`                                                                                                                                                                                                                                                                   | gates grilling 01/11/2026, Claude's calls                                                 |
| `logger`     | `record.name`                                                                                                                                                                                                                                                                                                                                 | grilling 31/10/2026, Q4                                                                   |
| `message`    | `record.getMessage()` — **not scrubbed** (grilling 31/10/2026, Q9)                                                                                                                                                                                                                                                                            | grilling 31/10/2026, Q4, Q9                                                               |
| `request_id` | `apps.core.middleware.current_request_id()`; for a returned-error `django.request` record, the filter falls back to the id stored on the `request` extra (round 2, R2-Q4); `""` mapped to `null`; written by the filter **unconditionally**, so a call-site extra cannot forge it; the formatter emits `null` when a handler lacks the filter | `US014.md` "request_id is always present"; gates grilling, Claude's calls; round 2, R2-Q4 |
| `exc_info`   | Present only when the record has one. Staging/production: type, and frames as `(filename, lineno, function)` only — no source-line text, no `f_locals`; `__cause__` and `__context__` walked type-only; PEP 678 notes dropped. Dev: the full traceback. The exact JSON shape is pinned at the QA review                                       | grilling 31/10/2026, Q11; gates grilling, Claude's calls; round 2, R2-Q6                  |
| `truncated`  | Staging/production only: present, `true`, only on a line the minimal formatter shortened to keep its output within **16 KiB**; absent otherwise. Dev's wide formatter is not capped                                                                                                                                                           | gates grilling round 3, 01/11/2026, R3-Q1                                                 |

**Fixed keys win.** In dev's wide mode the fixed keys are written after the extras, so an extra
named `level` or `request_id` cannot shadow them. **The formatter never raises:** where
`json.dumps(..., default=str)` still fails (a non-`str` key, a circular reference), it falls back
to **one JSON object of the fixed field set**, each unserialisable value `str()`-coerced, rather
than losing the line through `Handler.handleError` (gates grilling 01/11/2026, Claude's calls;
round 2, R2-Q5). The fallback line is still valid JSON, so the one-object-per-line claim holds.

**The fallback shape** (gates grilling round 3, 01/11/2026, R3-Q2). The extras stay **in place**,
each `str()`-coerced, and still pass through the allowlist — so staging and production keep only
`duration_ms`, `status_code` and `method`, and dev keeps every extra. Where `record.getMessage()`
itself fails, `message` is `str(record.msg)` without its args. Every coercion runs through a
**guarded `repr`** that cannot raise, so a value whose `__str__` or `__repr__` raises still yields
a line.

**Line size** (gates grilling round 3, 01/11/2026, R3-Q1). The minimal formatter caps its output
at **16 KiB** — Docker's `json-file` driver splits a longer line into fragments, which
`| json | __error__=""` would drop silently. An over-long line is truncated and carries
`"truncated": true`; it stays one JSON object, so the one-object-per-line claim holds. **Accepted
residual:** a line over 4 KiB (`PIPE_BUF`) can interleave with another worker's write on the
shared pipe; this is rare, and recorded rather than prevented.

**`request_id` is a pseudonymous identifier, safe for line integrity.** An inbound value must
match `[A-Za-z0-9._-]{1,200}`, or a UUID4 hex is minted (`middleware.py`:17, :40-41): it cannot
carry `@`, whitespace or a newline. That makes it safe for the line, not non-personal: joined to
the edge access log it yields a client IP, and the user is shown it to quote back, so it is
pseudonymous personal data (`GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` Section 2). Its
retention and access follow Section 5. Where a data subject supplies their `request_id`, a
request under Art. 11(2) may have to be served from the lines it keys, flagged for legal
sign-off (gates grilling round 2, 01/11/2026, R2-Q7; the GDPR plan owns the position).
Which value it holds is the edge's: entry 13 of `EDGE-REQUIREMENTS.md` gains the clause that the
edge sets `X-Request-ID` from its own `$request_id` **unconditionally**, discarding any client
value (gates grilling 01/11/2026, Q7), so a caller cannot choose the id an audit entry joins on.

### 2.3 Level policy per environment

| Environment | Root      | `django`                       | `django.db.backends` | Off by construction                   |
| ----------- | --------- | ------------------------------ | -------------------- | ------------------------------------- |
| dev         | `DEBUG`   | `INFO` (`dev.py`:65)           | `WARNING`, file only | —                                     |
| test        | `WARNING` | `WARNING`, no handlers (R2-Q2) | not declared         | no file, no formatter                 |
| staging     | `WARNING` | `WARNING`, no handlers (Q8)    | not declared         | `DEBUG`; the gunicorn access log (Q1) |
| production  | `WARNING` | `WARNING`, no handlers (Q8)    | not declared         | `DEBUG`; the gunicorn access log (Q1) |

**Where the `WARNING` line sits.** Off dev, only `WARNING` and above reach stdout. That is the
level at which a human may need to look; `INFO` from a future `apps.<app>` logger appears only once
a project declares that logger at `INFO` (`US014.md` Logging Acceptance Criteria, the
`logger="api"` query), because root will not pass it.
**One consequence is accepted:** `log_response` logs every returned or raised 4xx at `WARNING`
(`exception.py`:77-79 for `Http404`, :89-91 for `PermissionDenied`), so every scanner 404 and
every 403 is a `WARNING` line on staging and production stdout. That volume is accepted for this
story, which names no loggers (N-020), and recorded here only — no `GAPS.md` row (gates grilling
round 2, 01/11/2026, R2-Q3; closes `LOG-GAP-11`).

**The gunicorn access log is removed, not reformatted** (gates grilling 01/11/2026, Q1).
`--access-logfile -` (`entrypoint.prod.sh`:31, `entrypoint.staging.sh`:30, `entrypoint.test.sh`:27)
writes a plain-text line per request holding the peer address and the full path with its query
string, and no `request_id`. It is dropped; the edge access log owns access records, keyed on the
same `request_id` (`EDGE-REQUIREMENTS.md` entry 13).

**The process-server level matches production** (gates grilling round 3, 01/11/2026, R3-Q4;
closes `LOG-GAP-12`). `entrypoint.staging.sh`:29 changes `--log-level info` to `warning`, as
`entrypoint.prod.sh`:30 reads, so staging's stderr carries the same `gunicorn.error` and
`uvicorn.error` lines production does. `entrypoint.test.sh`:26 is not in the ruling and keeps
`info`.

---

## 3. Safe fields

| Field class  | Permitted                                                                                                                                                                                                                                                                                                                                                                                       | Never                                                      |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| Fixed keys   | `timestamp`, `level`, `logger`, `message`, `request_id`, `exc_info`. **`message` is not scrubbed** and can carry a client path (`exception.py`:79, :91, :109, :148) and the `str(exc)` of `BadRequest` / `SuspiciousOperation` — `DisallowedHost`'s holds the client's `Host` header (:130-138). Accepted, not permitted by default: grilling 31/10/2026, Q9; gates grilling 01/11/2026, Q5, Q6 | A fixed key overwritten by an extra                        |
| Identifiers  | `request_id` — pseudonymous (validated alphabet, or minted); personal when joined to the edge log, so retained and read per Section 5                                                                                                                                                                                                                                                           | A natural key that is itself personal; a raw client IP     |
| Enumerations | `method`, `status_code`                                                                                                                                                                                                                                                                                                                                                                         | Free-text user input as an extra                           |
| Measurements | `duration_ms`                                                                                                                                                                                                                                                                                                                                                                                   | —                                                          |
| Exception    | Type name and `(filename, lineno, function)` frames, off dev                                                                                                                                                                                                                                                                                                                                    | The exception message, source-line text, `f_locals`, notes |

The three extras are the **whole** staging/production allowlist (grilling 31/10/2026, Q9). Dev
keeps every extra by design; that is why the dev file is dev-only, host-mounted and gitignored.

---

## 4. Exclusions — what must never appear

No field in this story is marked `[enc]`: it has no schema (`US014.md` Flags table, DB row). The rows below are
drawn from the story's field rules, DATA-INVENTORY 15a (`DATA-INVENTORY.md`:195-201) and the
existing never-log rules, each naming the field and the surface.

| Field                                                                                      | Source                                               | Excluded from                                                                                                                                                                                                                                                                          |
| ------------------------------------------------------------------------------------------ | ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Any extra outside `duration_ms`, `status_code`, `method` — e.g. `email`, `path`, `user_id` | `US014.md` allowlist scenario (Q9)                   | Staging and production stdout — **dropped**, not masked, not renamed                                                                                                                                                                                                                   |
| `django.request`'s `request` extra (its repr carries the query string)                     | `US014.md` allowlist scenario                        | Staging and production stdout (not on the allowlist). Present in dev by design                                                                                                                                                                                                         |
| The exception message inside `exc_info`                                                    | `US014.md` exception scenario (Q11)                  | Staging and production stdout                                                                                                                                                                                                                                                          |
| Source-line text, `f_locals`, PEP 678 notes of a frame                                     | gates grilling 01/11/2026, Claude's calls            | Staging and production stdout                                                                                                                                                                                                                                                          |
| SQL and its parameters (`django.db.backends`)                                              | `dev.py`:66-68                                       | Every console; reaches the dev file only at `WARNING`                                                                                                                                                                                                                                  |
| A raw client IP                                                                            | `code/docs/logging/DJANGO-LOGGING.md`:27-36          | Every channel. The rule stands; its helpers `get_client_ip` / `hash_client_ip` do not exist at HEAD and sit outside this story                                                                                                                                                         |
| Peer address and query string of the gunicorn access line                                  | gates grilling 01/11/2026, Q1                        | Staging, production and test stdout — the access log is not written                                                                                                                                                                                                                    |
| A client-supplied `X-Request-ID`                                                           | gates grilling 01/11/2026, Q7                        | The application's `request_id`, once the edge overwrites it (entry 13); the app's own alphabet check stays the backstop                                                                                                                                                                |
| The exception message — **outside the claim, documented, not excluded**                    | Review 01/11/2026; `uvicorn/workers.py`:35-38; R2-Q1 | Barred from formatter output only. `uvicorn.error` can log "Exception in ASGI application" with the full traceback and message, plain text, to staging and production stderr — rare. Accepted and documented, not routed through `LOGGING` (gates grilling round 2, 01/11/2026, R2-Q1) |

**Stack traces — answered for every line Django's `LOGGING` emits**, which is the whole claim
(gates grilling round 2, 01/11/2026, R2-Q1). The process-server stream (`gunicorn.error`,
`uvicorn.error`) is outside the formatter and can carry an unhandled exception's traceback with
its message; it is documented as such, with a query that keeps it (Section 5.1), not routed
through `LOGGING`. Within Django's
`LOGGING`, `exc_info` off dev carries no message text, so a
`ValueError("user a@example.com not found")` publishes nothing personal there (`US014.md` exception scenario).
**But `message` is not scrubbed, and Django writes exception text into it** (gates grilling
01/11/2026, Q6): `BadRequest` logs `str(exc)` with the path, and every `SuspiciousOperation`
subclass logs `str(exc)` as the whole message under `django.security.*`
(`django/core/handlers/exception.py`:106-113, :130-138) — `DisallowedHost`'s carries the offending
`Host` header. These records are caught by Django's own handler and converted to a 400, never
re-raised; the claim is therefore narrowed rather than enforced: "on every line Django's `LOGGING` emits, `exc_info` carries no exception
message off dev; Django's `BadRequest` and `SuspiciousOperation` records carry `str(exc)` in the
unscrubbed `message`." The Security AC, `DJANGO-LOGGING.md` and the DATA-INVENTORY row take that
wording.

**Request paths are logged** (gates grilling 01/11/2026, Q5). Every `django.request` line carries
`request.path` in `message` (`exception.py`:79, :91, :109, :148) — never `get_full_path()`, so no
query string reaches a staging or production message. Accepted as a design rule rather than
handled: `DJANGO-LOGGING.md`'s staging/production section gains the sentence that paths are
logged, so no secret or personal value goes in a URL path segment.

### 4.1 Audit-trail boundary

No record class here is an audit record. The security and audit stream is out of scope
(`US014.md` Out of Scope); the story writes the two-stream split into
`MONITORING-AND-INCIDENT.md`:40-45 — its field list governs security and audit events, this
pipeline is the application stream, and `request_id` is the field that crosses both. Anything that
must survive retention, resist tampering or answer a legal request is a database write
(`code/docs/security/AUDIT-TRAIL.md`), never a line here.

---

## 5. Channels and retention

| Channel                                              | Holds                                                                                                                                                                                                                                                                                                                                                            | Retention                                                                                                      | Who can read it                                                                                                          |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `code/src/logs/django.log` (dev only)                | Every level from root `DEBUG`, wide JSON                                                                                                                                                                                                                                                                                                                         | **Size-bounded**, not age-bounded: `RotatingFileHandler`, 10 MB × (1 + 5 backups) = 6 × 10 MB (`dev.py`:55-61) | The developer, on the host via the bind mount; gitignored                                                                |
| Dev console (`docker compose logs`)                  | As the file, minus `django.db.backends`; plus uvicorn's own plain-text `uvicorn.error` and `uvicorn.access` lines at `--log-level debug` (`entrypoint.dev.sh`:27-32) — client address and full path with query string — kept: dev is disposable under the `development` posture (gates grilling round 2, 01/11/2026, R2-Q8). Only Django's lines are JSON in dev | Docker's own, on a developer machine                                                                           | The developer                                                                                                            |
| Test console                                         | `WARNING` and above, default format                                                                                                                                                                                                                                                                                                                              | **None kept** — the test run's output only                                                                     | Whoever runs the suite; CI logs                                                                                          |
| Staging stdout → collector → log store               | `WARNING` and above, minimal JSON                                                                                                                                                                                                                                                                                                                                | **14 days** — reference default; the controller confirms                                                       | The operators of the staging log store                                                                                   |
| Production stdout → collector → log store            | `WARNING` and above, minimal JSON                                                                                                                                                                                                                                                                                                                                | **90 days** — reference default; the controller confirms                                                       | The operators of the production log store                                                                                |
| Process-server stderr (staging/production)           | `gunicorn.error` and `uvicorn.error` (`--error-logfile -`), plain text, no `request_id`, at the entrypoint's `--log-level` — `warning` in both once R3-Q4 lands: worker timeouts, boot failures, rarely an "Exception in ASGI application" traceback with its message. Outside Django's `LOGGING`; collected with stdout (R2-Q1)                                 | As the staging / production store above                                                                        | As the staging / production store above                                                                                  |
| Host `json-file` driver files (staging/production)   | The same stdout and stderr, before collection                                                                                                                                                                                                                                                                                                                    | **Bounded by `max-size` / `max-file`**, required on the host (Q11); the values are the deploy repo's           | Root and members of the host's `docker` group (via `docker logs`)                                                        |
| Email to `ADMINS` (`mail_admins`, `DEFAULT_LOGGING`) | Traceback and request repr, `ERROR`, `require_debug_false` (`django/utils/log.py`:46-50, :56-59)                                                                                                                                                                                                                                                                 | —                                                                                                              | Removed in staging and production (Q8) and in test (R2-Q2); dev's own `django` handlers (`dev.py`:65) already replace it |
| Error tracking (Sentry)                              | Declared, not wired — `sentry-sdk` has no call site                                                                                                                                                                                                                                                                                                              | —                                                                                                              | —                                                                                                                        |

**Retention is recorded as surfaced, not decided** (gates grilling 01/11/2026, Q3). The 14 / 90
figures are `OBSERVABILITY.md`:156-157's, cited as a **reference default the controller
confirms**; each generated project is the controller and sets its own. The GDPR plan carries the
same position into DATA-INVENTORY 15a, and the new `EDGE-REQUIREMENTS.md` log-collection section
gains a retention line, because the collector in the deploy repo is where it is enforced.

### 5.1 Collector contract — the new `EDGE-REQUIREMENTS.md` section

Stated **collector-neutrally** (gates grilling 01/11/2026, Q11), for the section and its summary
row:

1. The collector reads each container's stdout through the Docker daemon, with the container's
   labels attached.
2. It relabels `com.docker.compose.service` to `service_name`. Both stacks name the service
   `django` (`docker-compose.staging.yml`:15, `docker-compose.prod.yml`:16), so every documented
   query is `{service_name="django"}`.
3. It relabels `com.docker.compose.project` to an environment label (gates grilling 01/11/2026,
   Q10). The project names differ — `<%PROJECT_SLUG%>-staging` (`docker-compose.staging.yml`:12)
   and `<%PROJECT_SLUG%>-prod` (`docker-compose.prod.yml`:13) — so one log store collecting both
   cannot merge them silently. The documented queries stay `{service_name="django"}`.
4. It retains per Section 5's retention line.
5. The host's Docker `json-file` driver rotates, with `max-size` and `max-file` set (Q11).
6. It collects the container's stderr with its stdout, so the process-server stream reaches the
   same store. The documented JSON queries (`| json | __error__=""`) drop those plain-text lines,
   so the guides also document a selector that keeps them (gates grilling round 2, 01/11/2026,
   R2-Q1). **Pinned (amended 01/11/2026, consistency pass):** the selector is exactly
   `{service_name="django"} | json | __error__!=""`, with the note that a traceback arrives one
   entry per line unless the collector runs a multiline stage. It is written into the four
   documents the story names — `DJANGO-LOGGING.md`, `OBSERVABILITY.md`, the
   `EDGE-REQUIREMENTS.md` log-collection section and `code/workflows/09-debugging-with-logs/STEPS.md`
   — as `US014.md` Logging Acceptance Criteria require. The header-only line filter this item
   first gave as an example (`|= "Exception in ASGI application"`) is withdrawn: it returns only
   a traceback's first line, so it does not keep the stream (QA plan `AC-GAP-13`).

**Reference realisation (Grafana Alloy):** `discovery.docker` → `discovery.relabel` →
`loki.source.docker`. A file tail of `/var/lib/docker/containers/*/*.log` carries no Compose labels,
so the relabel cannot work there: `OBSERVABILITY.md`:120's diagram, which says the shipper reads
that path, is corrected in the same change (Q11).

### 5.2 Relabel confirmed against the reference collector

The Logging flag left this confirmation to this gate (`US014.md` Flags table, Logging row; Logging
Acceptance Criteria, the relabel bullet). **Confirmed.**

| Claim                                                                                                                                                                                                                                                             | Source, as read                                                                                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `discovery.docker` exports each container label as `__meta_docker_container_label_<labelname>`, dots and other non-alphanumerics sanitised to underscores — so `com.docker.compose.service` arrives as `__meta_docker_container_label_com_docker_compose_service` | grafana.com/docs/alloy/latest/reference/components/discovery/discovery.docker/ — _Exported fields_ and its sanitising note, v1.21 (latest); re-read 01/11/2026 through `scrapling` |
| `loki.source.docker` reads container logs through the daemon and accepts `relabel_rules`, so a rule with that source label and `target_label = "service_name"` yields `{service_name="django"}`                                                                   | grafana.com/docs/alloy/latest/reference/components/loki/loki.source.docker/ — v1.21, read by the scoping pass 01/11/2026 through `scrapling` `get`                                 |
| The relabel must be explicit: without it Loki derives `service_name` from its default label list (which includes `container` / `container_name`) or falls back to `unknown_service` — never to the Compose service name                                           | grafana/loki `docs/sources/get-started/labels/_index.md`:39-66, read by the scoping pass 01/11/2026                                                                                |

**Tier note** (`code/docs/GATE-REPORTING.md`): `context7` was unavailable — its API key was
rejected — so the reads above are tier 4, the primary pages themselves. **Not quoted from a primary
page:** that `__`-prefixed labels are dropped after relabelling; that rests on the Prometheus
relabel convention Alloy inherits. **Could not look:** the deploy repo's Loki version and any
customised `discover_service_name` limits — outside this tree.

---

## 6. Open questions

| ID           | Question                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Blocks                                                       | Resolution                                                                                                                                                                                                                                                                                                                                                                                           |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `LOG-GAP-1`  | Does a request path inside a `django.request` message need handling, given `message` is not scrubbed? (`US014.md` Security Acceptance Criteria, the path rule)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | —                                                            | `[RESOLVED] 01/11/2026` — accepted, with the design-rule sentence in `DJANGO-LOGGING.md` (gates grilling, Q5); owned by gate 10                                                                                                                                                                                                                                                                      |
| `LOG-GAP-2`  | What retention does each channel have?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | —                                                            | `[RESOLVED] 01/11/2026` — 14 / 90 days as a reference default the controller confirms; dev size-bounded; test none; a retention line in `EDGE-REQUIREMENTS.md` (gates grilling, Q3)                                                                                                                                                                                                                  |
| `LOG-GAP-3`  | Can staging and production be told apart in one log store?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —                                                            | `[RESOLVED] 01/11/2026` — relabel `com.docker.compose.project` to an environment label; queries unchanged (gates grilling, Q10)                                                                                                                                                                                                                                                                      |
| `LOG-GAP-4`  | How does the new section name the collector, given `OBSERVABILITY.md`:120's file tail carries no labels?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | —                                                            | `[RESOLVED] 01/11/2026` — collector-neutral contract, Alloy as the reference realisation, `:120` corrected, host `json-file` rotation required (gates grilling, Q11)                                                                                                                                                                                                                                 |
| `LOG-GAP-5`  | Django's `DEFAULT_LOGGING` `django` logger survives off dev at `INFO` with unfiltered handlers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | —                                                            | `[RESOLVED] 01/11/2026` — declared `WARNING`, no handlers, propagating, in staging and production; asserted (gates grilling, Q8)                                                                                                                                                                                                                                                                     |
| `LOG-GAP-6`  | The gunicorn access log is plain text on stdout, outside the pipeline                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | —                                                            | `[RESOLVED] 01/11/2026` — `--access-logfile -` dropped from three entrypoints (gates grilling, Q1)                                                                                                                                                                                                                                                                                                   |
| `LOG-GAP-7`  | Django puts `str(exc)` into `message` for `BadRequest` and `SuspiciousOperation`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | —                                                            | `[RESOLVED] 01/11/2026` — the claim narrowed; three documents reworded (gates grilling, Q6)                                                                                                                                                                                                                                                                                                          |
| `LOG-GAP-8`  | `.claude/skills/logging/SKILL.md`:83 says "timestamps <%TIMEZONE%>", contradicting the UTC timestamp                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | —                                                            | `[RESOLVED] 01/11/2026` — a US014 documentation task: line timestamps are UTC ISO-8601, message prose en_GB (gates grilling, Claude's calls); fed back                                                                                                                                                                                                                                               |
| `LOG-GAP-9`  | How does the process-server stream relate to "every log line is one valid JSON object"? `--error-logfile -` stays in all three entrypoints (`entrypoint.prod.sh`:30-32, `entrypoint.staging.sh`:29-31, `entrypoint.test.sh`:26-28). gunicorn builds it as a plain `StreamHandler` to **stderr** (`gunicorn/glogging.py`), and `UvicornWorker` hands `uvicorn.error` the same handlers with `propagate=False` (`uvicorn/workers.py`:35-38). So `gunicorn.error` and `uvicorn.error` write at the entrypoint's `--log-level` — `warning` in prod, `info` in staging and test — as plain text, with no `request_id`, outside the formatter. That includes worker timeouts, boot failures and "Exception in ASGI application" with its full traceback and message. The story's `__error__=""` AC (`US014.md` Logging Acceptance Criteria) silently drops these lines from the documented queries, so it depends on the same decision. Option A: narrow the claim to "every line Django's `LOGGING` emits", and document the process-server stream with a query that keeps it (TM-13's proposal; QA plan option A). Option B: route `gunicorn.error` and `uvicorn.error` through the JSON formatter and the filter (QA plan option B; widens the story). Also: should staging's `--log-level info` match prod's `warning`? | —                                                            | `[RESOLVED] 01/11/2026` — option A: the claim narrowed to "every line Django's `LOGGING` emits"; the process-server stream documented (plain text, stderr, can carry an escaped ASGI traceback with its message — rare) with a LogQL selector that keeps it (Section 5.1); not routed through `LOGGING` (gates grilling round 2, R2-Q1). The `--log-level` sub-question is split out as `LOG-GAP-12` |
| `LOG-GAP-10` | `test.py` declares no `django` logger, so the `DEFAULT_LOGGING` survivor keeps `INFO` there and `django.*` INFO propagates to test's console past root `WARNING`; its `mail_admins` handler stays on, inert while `ADMINS` is unset. Does `test.py` also declare `"django": {"handlers": [], "level": "WARNING"}`, or does the story record the difference?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | —                                                            | `[RESOLVED] 01/11/2026` — `test.py` declares it too; the settings test asserts staging, production and test (gates grilling round 2, R2-Q2)                                                                                                                                                                                                                                                          |
| `LOG-GAP-11` | `django.request` logs every returned or raised 4xx at `WARNING` (`exception.py`:77-79, :89-91), so every scanner 404 and 403 is a `WARNING` line on staging and production stdout. Is that volume accepted for this story (no named loggers, N-020), or raised as a gap?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | — (changes no field)                                         | `[RESOLVED] 01/11/2026` — accepted and recorded here (Section 2.3); no `GAPS.md` row (gates grilling round 2, R2-Q3)                                                                                                                                                                                                                                                                                 |
| `LOG-GAP-12` | Should staging's process-server `--log-level info` (`entrypoint.staging.sh`:29-31) match production's `warning` (`entrypoint.prod.sh`:30-32)? At `info`, staging's stderr carries gunicorn's and uvicorn's informational lines that production does not. Split out of `LOG-GAP-9`: R2-Q1 settled the claim and the stream's documentation, not this level                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | Staging parity with production for the process-server stream | `[RESOLVED] 01/11/2026` — match: `entrypoint.staging.sh`:29's `--log-level` becomes `warning`, as production's; joins US014's edit set (Section 2.3) (gates grilling round 3, R3-Q4)                                                                                                                                                                                                                 |

**No `[OPEN]` row remains** (amended 01/11/2026). `LOG-GAP-12` was resolved by the round-3
ruling of 01/11/2026 (R3-Q4); it changes no field and no line Django's `LOGGING` emits.
`LOG-GAP-9`, `LOG-GAP-10` and `LOG-GAP-11` were resolved by the round-2 rulings of 01/11/2026;
`LOG-GAP-9`'s resolution bounds the claim the contract is stated under. The plan stays Draft,
sign-off pending <%DEVELOPER_NAME%>.

---

## Cross-references

- `project-management/src/02-STORIES/US014.md` — the story this plan specifies
- `project-management/src/09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — retention, lawful basis and rights, as surfaced
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` — request paths, `str(exc)`, inbound `X-Request-ID`
- `project-management/src/11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the pinned `timestamp` form and the tests
- `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` — slice `S-07`, node N-020
- `code/docs/LOGGING.md` — the governing standard
- `code/docs/logging/DJANGO-LOGGING.md` · `code/docs/logging/OBSERVABILITY.md` — the guides this story corrects
- `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — entry 13 and the new log-collection section
- `code/docs/security/AUDIT-TRAIL.md` — the audit record, which is not a log line
- `code/docs/GATE-REPORTING.md` — the rule behind the tier note and every "could not look"
- `../IMPLEMENTATION/LOGGING-IMPL-US000-TEMPLATE.md` — the record that closes this plan
