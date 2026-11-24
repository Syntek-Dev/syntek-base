# GDPR Implementation — US014 Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Field           | Value                                                                                                                                                                                                                                                                                                       |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                                                                        |
| **Date**        | 24/11/2026                                                                                                                                                                                                                                                                                                  |
| **Verified by** | Claude Code (Opus), `22-implementation-documentation` Step 3, `gdpr-mechanics` read inline — the recorder wrote none of the story's code                                                                                                                                                                    |
| **Plan doc**    | `../PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` (signed off 01/11/2026)                                                                                                                                                                                                                            |
| **Outcome**     | **Compliant with deviations** — every Section 10 task closed against the working tree of `us014/structured-json-logging` (base `b1705408`, build uncommitted); the controller-owned items stay open by design, and **the Art. 11 position is carried unchanged and flagged for legal sign-off** (Section 3) |

> **Who the controller is.** This record verifies the template's pipeline. Each generated project
> is the controller of its own log data; the lawful basis, the retention numbers and the rights
> position below are **surfaced** to it, never decided here (plan, header comment).

---

## 1. Data flows implemented

No personal-data field is collected, stored or added to any model. Personal data reaches a line
**incidentally**, by the routes the plan's Section 2 lists. The shipped code matches the plan's
Section 1 environment by environment; nothing is added.

| Data element                         | Stream / store                                         | Lawful basis                                               | At rest                                   | Evidence (file · symbol)                                                                                                                                                                                                          |
| ------------------------------------ | ------------------------------------------------------ | ---------------------------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `request_id` (pseudonymous)          | Every line Django's `LOGGING` emits, every env         | Art. 6(1)(f) — register example default; LIA owed (Sec. 5) | Collector-side (staging/prod); host (dev) | `apps/core/observability.py` · `RequestIDFilter.filter`, `_correlation_id`; `apps/core/middleware.py` · `RequestIDMiddleware.__call__` stores `request.request_id` (validated or minted, never the raw header)                    |
| `message` free text (not scrubbed)   | Every line                                             | As above                                                   | As above                                  | `observability.py` · `JSONFormatter._format` (`record.getMessage()`); `test_bad_request_text_reaches_message_and_not_exc_info` (EC-11) pins that `BadRequest` text reaches `message` and not `exc_info`                           |
| Extras outside the allowlist         | **Dropped** in staging and production; dev only        | As above                                                   | Dev host disk only                        | `observability.py` · `ALLOWLIST`, `_allowlisted`; `test_keeps_the_allowlist_and_drops_everything_else` (HP-04)                                                                                                                    |
| Exception message inside `exc_info`  | **Dropped** in staging and production; dev only        | As above                                                   | Dev host disk only                        | `observability.py` · `_exception_shape`, `_frames` (type plus `filename`, `lineno`, `function`); `test_type_and_frames_with_no_message` (HP-05), `test_a_note_is_dropped` (EC-09), `test_a_group_lists_member_types_only` (EC-10) |
| `request` repr with query string     | Dev only — a wide extra                                | As above                                                   | `code/src/logs/` on the host (gitignored) | `config/settings/dev.py` · `LOGGING` `"mode": "wide"`; `test_an_unserialisable_extra_is_its_str` (EC-03)                                                                                                                          |
| Dev app-server access line           | Dev only — uvicorn's default access logger (R2-Q8)     | As above                                                   | Container stdout on the developer machine | `code/src/docker/django/entrypoint.dev.sh` unchanged (`--log-level debug`, no access flag)                                                                                                                                        |
| App-server access line (address, QS) | **Not written** in staging, production or test         | —                                                          | —                                         | `entrypoint.staging.sh`, `entrypoint.prod.sh`, `entrypoint.test.sh`: `--access-logfile -` removed, `--error-logfile -` kept (read 24/11/2026)                                                                                     |
| Email to `ADMINS`                    | **No route** — `django` logger has no handlers off dev | —                                                          | —                                         | `staging.py`, `production.py`, `test.py` · `"django": {"handlers": [], "level": "WARNING"}`; `ADMINS` assigned in no settings module (grep, 24/11/2026); `test_every_handler_carries_the_filter` and ES-04                        |

**Outside the pipeline, as the plan said and the docs now say.** The process-server stream
(`gunicorn.error`, `uvicorn.error`) stays plain text on stderr and can rarely carry an escaped
ASGI traceback with its message. Staging now runs it at `--log-level warning`, as production
(`entrypoint.staging.sh`:29). Documented in `code/docs/logging/DJANGO-LOGGING.md` → _The
process-server stream — outside the pipeline_, with the keeping selector
`{service_name="django"} | json | __error__!=""`.

## 2. Retention configured

| Data category                    | Retention                                                       | Deletion mechanism shipped                                            | Evidence                                                                                                               |
| -------------------------------- | --------------------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Staging application log lines    | 14 days — **reference default the controller confirms**         | The collector's retention (deploy repository) — **stated, not built** | `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entry 15, _Retention_ bullet                                     |
| Production application log lines | 90 days — **reference default the controller confirms**         | As above                                                              | As above                                                                                                               |
| Host copy of container stdout    | Bounded by size                                                 | `json-file` `max-size` / `max-file` — **required, deploy-side**       | Entry 15, _Rotate on the host_ bullet                                                                                  |
| Dev log file                     | Six files of 10 MB at most                                      | `RotatingFileHandler` rollover                                        | `config/settings/dev.py` · `LOGGING["handlers"]["file"]` (unchanged size and backup count)                             |
| Edge proxy access log            | **Not set here** — the controller's and the deploy repository's | The deploy repository's own rotation                                  | Entry 15: "The edge access log's own retention is an obligation this deploy repository records, set by the controller" |
| Test log stream                  | None kept                                                       | Discarded with the test container                                     | `config/settings/test.py` · console handler only, no file                                                              |

**Nothing in this repository deletes a log line.** Every staging and production period is enforced
outside the Django app, by the collector, as the plan required (plan Section 4).

## 3. Data subject rights verified

**Carried unchanged from the plan's Section 5, and flagged for legal sign-off.** No per-subject
search over the log store is built — confirmed: no module, script or command searching the log
store exists anywhere in the change.

> **Position (plan Section 5, unchanged).** The pipeline adds no direct identifier to a staging or
> production line, and the allowlist drops every extra but three. `message` can still carry one,
> so the position holds **only while a project's call sites keep identifiers out of `message` and
> out of URL path segments** (gates grilling 01/11/2026, Q5) — that condition is part of what the
> legal sign-off covers. On that premise, Art. 11(1) does not require a controller to acquire
> identifying information solely to serve a right, so no per-subject search is built.
>
> **Art. 11(2) — a supplied `request_id`.** Where a subject quotes a `request_id` from an error
> page, identification is offered rather than acquired, and Arts 15 to 20 reapply: **a supplied
> `request_id` may have to be served** against the lines that id keys, within the retention
> window (gates grilling round 2, 01/11/2026, R2-Q7). How a project serves one is its
> controller's decision, within the legal sign-off. An uncorrelated record (`request_id` null) is
> not among the lines a supplied id reaches, and is bounded by retention alone.

- **Access (Art. 15)** — not served by a per-subject search; the logs are not part of the SAR
  export. Bounded by the retention window. **Flagged for legal sign-off.**
- **Erasure (Art. 17)** — met by retention expiry, not a targeted delete. **Flagged.**
- **Portability (Art. 20)** — not engaged: the processing rests on Art. 6(1)(f). **Flagged.**
- **Object (Art. 21)** — answered by the controller's LIA; `../DATA-SUBJECT-RIGHTS.md` Right 6
  already names logging among the legitimate-interests objection paths.
- **Rectification / Restriction / Withdraw consent** — N/A: events, not facts held about a
  person; consent is not the basis.

**The condition the position rests on is documented where a developer reads it.**
`code/docs/logging/DJANGO-LOGGING.md` → _The path rule_ ("no secret or personal data goes in a URL
path segment"), and its correct call-site pattern logs `extra={"user_id": user.pk}`, not an
email. **What no gate checks:** that a future call site keeps an identifier out of `message`. That
is review's, and the reason the position needs its sign-off.

## 4. Processors & DPA status

**N/A — no processor added.** The collector and log store are realised per deployment; a project
that ships logs to a hosted service records it in its own `../THIRD-PARTY-PROCESSORS.md` with an
Art. 28 DPA (the 15a guidance line now says so, `../DATA-INVENTORY.md`:201). Nothing in this
repository sends a log line to a third party: `sentry-sdk` remains initialised nowhere.

## 5. Plan gaps closed

Each Section 10 task of the plan, closed **only with evidence** from the working tree.

| Plan task (Section 10)                                                               | Status                   | Evidence                                                                                                                                                                                       |
| ------------------------------------------------------------------------------------ | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Remove `--access-logfile -` from the staging, production and test entrypoints        | Closed                   | `entrypoint.staging.sh`:29-30, `entrypoint.prod.sh`:30-31, `entrypoint.test.sh`:26-27 end on `--error-logfile -` with no access flag; QA ES-06 (static)                                        |
| Mark `DJANGO-LOGGING.md`:34-35's redaction claim a forward reference                 | Closed                   | `DJANGO-LOGGING.md`:35-37 — "Scrub hooks … are a forward reference: they are the deferred `syntek-observability` half, not yet built, and nothing in `apps.core.observability` scrubs"         |
| Write the narrowed minimisation claim (Q6)                                           | Closed                   | `DJANGO-LOGGING.md`:148-156 — `exc_info` carries no exception message; "`message` is not scrubbed: Django's `BadRequest` and `SuspiciousOperation` records carry `str(exc)` in it"             |
| Replace `extra={"email": email}` with an identifier                                  | Closed                   | `DJANGO-LOGGING.md`:49-51 — `logger.info("user created", extra={"user_id": user.pk})`                                                                                                          |
| Apply Section 9's wording to `DATA-INVENTORY.md` :199 and :201                       | Closed                   | `../DATA-INVENTORY.md`:199 matches the plan's Section 9 row **byte for byte after whitespace normalisation** (`cmp`, 24/11/2026); :201 matches its guidance line                               |
| Retention line beside `json-file` rotation in the new log-collection section         | Closed                   | `EDGE-REQUIREMENTS.md` entry 15, _Rotate on the host_ and _Retention_ bullets                                                                                                                  |
| Carry the Section 5 rights position unchanged, flagged for legal sign-off; no search | Closed                   | Section 3 of this record; no per-subject search in the change                                                                                                                                  |
| **Open, the controller's:** LIA, confirmed retention, Art. 11 legal sign-off         | **Open by design**       | Surfaced in `../DATA-INVENTORY.md` 15a and entry 15; never closed by the template                                                                                                              |
| **Open, the controller's:** the edge access log's retention                          | **Open by design**       | Entry 15 names it the deploy repository's obligation, set by the controller                                                                                                                    |
| RESOLVED R2-Q1 — narrow "every line" claims; document the process-server stream      | Closed                   | `DJANGO-LOGGING.md`:156 ("The claim covers every line Django's `LOGGING` emits, and nothing else") and _The process-server stream_ section with the keeping selector; entry 15 _Source_ bullet |
| RESOLVED R2-Q7 — carry the Art. 11(2) statement unchanged                            | Closed                   | Section 3 above; `../../02-STORIES/US014.md` Out of Scope bullet on the per-subject search                                                                                                     |
| RESOLVED R2-Q8 — narrow every "dev is JSON" claim to Django's lines                  | Closed                   | `code/src/docker/CONTEXT.md` _Logs and observability_ table ("uvicorn access and error lines, plain text, console"); `config/settings/dev.py` comment above `LOGGING`                          |
| ANSWERED by QA (AC-GAP-14, ES-10) — the test-stack access-line check                 | **Unmeasured** (runtime) | Static half read: no `--access-logfile` in `entrypoint.test.sh`. Runtime half not run — no script reads the test stack's output (`code/docs/GATE-REPORTING.md`). Never reported as passed      |

**Countersigned 24/11/2026 by Sam**, the developer, with all US014 work: "I countersign, I give permission to tick the acceptance criteria on the stories." It closes none of the rows above marked **Open by design**: the LIA, the confirmed retention numbers, the edge access log's retention and the Art. 11 legal sign-off stay the controller's. The countersignature is the developer's sign-off of the template's engineering work, **not a legal sign-off**. The record is `../../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` → _Countersignature — 24/11/2026_.

## 6. Deviations from plan

- **None to the data flows, the claims or the rights position.**
- **Wording only, one place.** The plan's Section 2 says an unserialisable value is "`str()`-coerced";
  the shipped fallback coerces through a guarded `repr` (`observability.py` · `_safe_text`), and a
  non-finite float is written as text (`"nan"`) so the line stays strict JSON (review finding M1).
  Neither adds a field or widens what the allowlist drops; the allowlist runs **before** coercion
  (`_format_fallback`), as R3-Q2 required.
- **A cycle's back-edge is omitted** rather than written `null` (review finding L3, awaiting
  <%DEVELOPER_NAME%>'s ruling). It removes content and adds none, so it changes nothing here.

---

## Cross-references

- `../PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the pre-implementation plan answered here
- `../DATA-INVENTORY.md` (15a) · `../DATA-SUBJECT-RIGHTS.md` (Right 6) · `../THIRD-PARTY-PROCESSORS.md` —
  the registers this story touched or points at
- `../../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` —
  TM-05, TM-06, TM-07 and TM-13, the disclosure half of the same claims
- `../../14-LOGGING/IMPLEMENTATION/LOGGING-IMPL-US014-STRUCTURED-JSON-REQUEST-ID.md` — the exclusion check
- `code/docs/logging/DJANGO-LOGGING.md` · `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entry 15
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
- `project-management/workflows/22-implementation-documentation/` — where this record is written
