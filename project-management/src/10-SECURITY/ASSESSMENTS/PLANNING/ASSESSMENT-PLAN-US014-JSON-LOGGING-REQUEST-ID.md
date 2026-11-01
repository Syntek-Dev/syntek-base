# Security Posture Assessment (Plan) — US014 Structured JSON logging with a `request_id` on every entry

| Field          | Value                                                                                                |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| **Story**      | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label |
| **Date**       | 01/11/2026                                                                                           |
| **Author**     | Claude Code — `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**                    |
| **Sprint**     | SPRINT-08 — admitted 01/11/2026 at `03-sprint-planning`, 8 SP; the record stands at 11 / 11          |
| **Status**     | Draft — sign-off pending <%DEVELOPER_NAME%>                                                          |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10, 2025) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC)                             |

> This assessment establishes the security **baseline** for the story before any code is
> written. It synthesises the story's STRIDE threat model and maps overall posture against
> OWASP Top 10 and NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or
> HIGH finding — those are release blockers.

<!-- Citations: "gates grilling 01/11/2026, Qn" is the combined specify-gate round of that date;
     Q5, Q6 and Q7 are this gate's. "grilling 31/10/2026, Qn" is the story-level round recorded in
     US014.md. Measured at HEAD 66eb725; Django 6.1.2 read from the installed package. -->

<!-- INDEPENDENT REVIEW 01/11/2026, folded the same day with the threat model's (see its review
     comment for the full list). Here: Section 1's adversary sentence matches the model's 3a; the
     gate-09 plan is read, not called absent; the A10 row's "Both" fixed and TM-13 added to it;
     7.3 names the RequestIDMiddleware change; 7.4 adds stack_info and exc_text; 7.5's fallback is
     one JSON object, proved by json.loads; 7.12 and Section 8 cover TM-13's disclosure half.
     Section 8 now carries two items OPEN with <%DEVELOPER_NAME%>. -->

<!-- GRILLING ROUND 2 01/11/2026, folded the same day with the threat model's (see its round-2
     comment). Cited "gates grilling round 2, 01/11/2026, R2-Qn". Both Section 8 items are
     RESOLVED: TM-13 takes option (a), claims narrowed to Django's LOGGING and the process-server
     stream documented with a LogQL selector that keeps it, no routing through LOGGING (R2-Q1);
     TM-09's fallback stays one JSON object with str()-coerced values (R2-Q5). 7.3 names option A
     (R2-Q4), 7.7 adds test.py (R2-Q2), 7.12 is no longer conditional, and the A09/A10 rows and
     Section 1 now read settled. Nothing is OPEN with <%DEVELOPER_NAME%>; severities unchanged;
     sign-off still pending. -->

<!-- GRILLING ROUND 3 AND CONSISTENCY PASS 01/11/2026, folded the same day with the threat
     model's (see its round-3 comment). Cited "gates grilling round 3, 01/11/2026, R3-Qn". TM-20 is
     added: the 16 KiB output cap with a `"truncated": true` marker, and the accepted PIPE_BUF
     interleave residual (R3-Q1), as 7.13. 7.5 carries the guarded-repr fallback, extras coerced in
     place under the allowlist and `message` = str(record.msg) without args (R3-Q2). 7.14 records
     the uncorrelated out-of-extent records, pinned by a test (R3-Q3). 7.8 adds staging's
     process-server --log-level warning, as production (R3-Q4). Consistency pass: US014.md:NNN
     cites replaced by section names; the GDPR-plan hand-off re-cited by section; base.py:50 for
     the "third in the pipeline" comment; entry 13 cited :276-292. Counts: twenty findings, 0
     CRITICAL, 0 HIGH, 0 MEDIUM, 18 LOW, 2 INFO; nine LOWs promote, across seven trigger rows.
     Nothing is OPEN with <%DEVELOPER_NAME%>; sign-off still pending. -->

<!-- SCOPED QA-TESTER RE-CHECK FOLD 01/11/2026. 7.5: a dated note that the fallback carries no
     format_error marker (QA-PLAN-US014 AC-GAP-11, asserted by EC-12 and EC-17); adding one changes
     the ruled shape (R3-Q2) and goes back to <%DEVELOPER_NAME%>. GDPR-plan cites re-verified as
     section names against that plan as it now stands; no line-number cite into it remains. -->

---

## 1. Summary

**The pipeline is sound and the claims around it are where the risk sits.** US014 makes a
promise the repository already publishes and does not keep — a correlation identifier in every
entry (`code/docs/security/MONITORING-AND-INCIDENT.md:42-43`) — and its settled shape keeps it
honestly: no redaction claimed, an extras allowlist off dev, and the exception message dropped
from `exc_info`. Twenty findings were raised across all six STRIDE categories: **0 CRITICAL,
0 HIGH, 0 MEDIUM, 18 LOW, 2 INFO**. Nothing gates sprint planning and no vulnerability record is
written.

That zero needs its reason: **this is a template repository at posture `development` that serves
nothing, and no generated project is known to be live.** The threat model's Section 3a names the
event that promotes each finding, and **nine of the eighteen `LOW`s promote to `MEDIUM`**, across
seven trigger rows. Per `code/docs/GATE-REPORTING.md` this is not reported as "the security gate
passed".

**The principal finding is a claim, not a control.** Django writes `str(exc)` into the `message`
of every `BadRequest` and `SuspiciousOperation` record (`django/core/handlers/exception.py:106-113`,
`:130-138`), so the Security criterion that the exception message "never" reaches staging or
production stdout (the story's Security Acceptance Criteria, before Q6) would ship false (TM-07). **Settled 01/11/2026:** the claim
is narrowed to what the pipeline guarantees, rather than a partial scrub added that would be a
guarantee that is not one (gates grilling 01/11/2026, Q6).

**The identifier is the only finding with an adversary who gains something.** The app reuses any well-formed inbound
`X-Request-ID`, and the edge contract says to pass one without saying a client's is discarded — so
a caller can forge the id the log, the edge access log and the audit trail join on, and would make
entry 2's dormant CSP nonce repeatable per chosen id (TM-01).
**Settled 01/11/2026:** the edge sets it unconditionally (Q7).

**The one finding left open by the first round is settled by narrowing the claim.** Gunicorn's and
Uvicorn's own error lines are plain text on stderr, outside the pipeline: the guides'
`__error__=""` filter drops them silently, and an exception that escapes the ASGI application
writes its traceback, message included, there (TM-13). **Settled 01/11/2026 (gates grilling
round 2, 01/11/2026, R2-Q1):** every claim is narrowed to the lines Django's `LOGGING` emits, and
the process-server stream is documented with a LogQL selector that keeps it — not routed through
`LOGGING`. The review's refinement of the formatter's fallback is confirmed too (R2-Q5). Nothing in
this assessment is OPEN with <%DEVELOPER_NAME%>.

**Round 3 added one finding and refined three** (gates grilling round 3, 01/11/2026). TM-20 is
new: a line over `PIPE_BUF` (4 KiB) can interleave across Gunicorn workers on one pipe, and Docker
splits a line over 16 KiB, so the fragments fail the guides' `json` stage. The minimal formatter
caps its output at 16 KiB with a `"truncated": true` marker, and the interleave between 4 KiB and
the cap is an accepted residual, still findable through the non-JSON selector (R3-Q1). The
fallback coerces through a guarded `repr` and never prints a record's arguments (R3-Q2, TM-09);
records outside the middleware's dynamic extent are stated as uncorrelated (R3-Q3, TM-18); and
staging's process-server level matches production's (R3-Q4, TM-13).

## 2. Scope

| Dimension  | Coverage                                                                                                                                                                   |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Story      | US014 — JSON formatter and `request_id` filter on every handler; per-environment `LOGGING`; dev log mount; the documents that describe the pipeline                        |
| User flow  | **None** — no screen, route or journey; the data path reviewed instead is call site to `LogRecord` to filter to formatter to stream to collector                           |
| Wireframe  | **None**, and none is possible                                                                                                                                             |
| Schema     | **None** — no model, no migration. Personal data is incidental: unscrubbed `message`, dev's request `repr`, and the edge join on `request_id`                              |
| Decisions  | **None recorded as ADRs** (the story's Decisions section); N-020 on `MAP-RULE-OWNERSHIP.md` Batch G1; grilling 31/10/2026 Q1-Q11; gates grilling 01/11/2026, rounds 1 to 3 |
| Frameworks | STRIDE · OWASP Top 10 (2025) · NIST CSF 2.0                                                                                                                                |

**Deviation, stated rather than silently absent.** `10-security-checks` Step 1 reviews user flows
and wireframes; this story has neither. The trust boundaries were derived from the log data path,
the middleware, Django's own writers and the process server instead. **Gate 09 ran in the same
pass:** the US014 GDPR plan,
`project-management/src/09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md`, was read at
review. Its one hand-off to this gate, the app server's error log (Section 2's "Outside the JSON
pipeline" bullet and Section 10's RESOLVED process-server item), is TM-13's disclosure half.

## 3. Threat models referenced

- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md`
  — 20 findings, 8 trust boundaries (TB1 call site · TB2 client to middleware · TB3 Django's
  handlers · TB4 settings module · TB5 stdout to collector · TB6 dev container to host · TB7
  process server · TB8 edge to Django)

Its trust boundaries and severities are adopted here unchanged.

## 4. OWASP Top 10 — baseline coverage

| ID       | Category                              | Status      | Notes (open findings, controls relied on)                                                                                                                                                                                                    |
| -------- | ------------------------------------- | ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | N/A         | No endpoint, permission or object lookup. Who may read the collector is the deploy repository's; TM-05 and TM-07 promote when that readership widens                                                                                         |
| A02:2025 | Security Misconfiguration             | Partial     | TM-10, TM-11, TM-12, TM-17 — a handler that escapes the pipeline, Django's surviving `django` logger, Gunicorn's second access stream, the dev mount. All but TM-17 closed by settled criteria                                               |
| A03:2025 | Software Supply Chain Failures        | Addressed   | The formatter is written, not imported (the story's Dependencies, _No library_); nothing joins `pyproject.toml` or `uv.lock`. No finding                                                                                                     |
| A04:2025 | Cryptographic Failures                | N/A         | No secret, key or hash is read or written. `request_id` is a correlation value, not a credential                                                                                                                                             |
| A05:2025 | Injection                             | Addressed   | TM-04 — log injection, closed by `json.dumps` escaping and the inbound alphabet; the round-trip test is already a criterion                                                                                                                  |
| A06:2025 | Insecure Design                       | Partial     | TM-16 — attacker-driven log volume, an accepted residual whose controls are the edge's. The pipeline's shape was argued to a decision on N-020; no design finding against it                                                                 |
| A07:2025 | Authentication Failures               | N/A         | No credential, session or MFA path changes. `MONITORING-AND-INCIDENT.md:33` still bans session IDs and tokens from any line                                                                                                                  |
| A08:2025 | Software and Data Integrity Failures  | N/A         | Nothing is deserialised, imported or signed. Log immutability belongs to the security stream, out of scope                                                                                                                                   |
| A09:2025 | Security Logging & Alerting Failures  | **Partial** | **The story's category.** TM-01, -02, -03, -05, -06, -07, -13, -14, -15, -18, -20. Every row is closed by a settled answer or accepted; TM-13 by narrowing the claims (R2-Q1); TM-20 by the 16 KiB cap, its interleave half accepted (R3-Q1) |
| A10:2025 | Mishandling of Exceptional Conditions | Partial     | TM-08, TM-09, TM-13, TM-19 — the exception shape, a formatter that could raise, uvicorn's escaped-exception traceback. TM-08, TM-09 and TM-13 settled (TM-09, TM-13 in round 2; TM-09 refined in round 3, R3-Q2); TM-19 accepted             |

## 5. NIST CSF 2.0 — function summary

| Fn  | Function | Design-stage posture                                                                                                                                                                                                                               |
| --- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | **Improved by this story.** The two field contracts become two named streams, and every shipped "JSON on stdout" claim becomes true or is reworded. Retention stays the controller's                                                               |
| ID  | Identify | Strong. Eight boundaries named, including two streams — the process server's and Django's own messages — that the story as cut did not see                                                                                                         |
| PR  | Protect  | **Partial, by design.** The allowlist and the dropped exception message protect off dev; `message` is not scrubbed (TM-05) and paths are logged (TM-06), both stated rather than hidden                                                            |
| DE  | Detect   | **The story's subject, and Partial until Section 7 lands.** Every Django entry gains its id, error lines included (TM-03); TM-13's process-server lines get a selector of their own (R2-Q1); the 16 KiB cap keeps a long line whole (TM-20, R3-Q1) |
| RS  | Respond  | Improved. One request becomes one id across the edge, the app and the audit trail, once the edge sets it unconditionally (TM-01)                                                                                                                   |
| RC  | Recover  | Not moved. Retention is a reference default the controller confirms; recovery of the logs themselves is the deploy repository's                                                                                                                    |

## 6. Findings

Grouped by severity. All twenty are carried from the threat model unchanged; see it for the full
mitigation text and the promotion triggers.

| ID    | STRIDE | OWASP    | NIST         | TB       | Threat Description                                                                                                                       | Severity | Planned Mitigation                                                                                                           |
| ----- | ------ | -------- | ------------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | S      | A09      | DE.AE        | TB2, TB8 | A client chooses its own correlation identifier                                                                                          | LOW      | The edge sets `X-Request-ID` unconditionally (Q7) (7.10)                                                                     |
| TM-02 | T      | A09      | DE.AE        | TB1      | A call site forges `request_id` or shadows a fixed key                                                                                   | LOW      | Unconditional set; fixed keys after extras (settled call) (7.1, 7.2)                                                         |
| TM-03 | R      | A09      | DE.AE        | TB3      | A returned 4xx / 5xx line is logged after the `ContextVar` resets                                                                        | LOW      | The id stored on the request (R2-Q4); tested under `Client` and `AsyncClient` (7.3)                                          |
| TM-04 | T      | A05      | DE.CM        | TB1, TB3 | A crafted value forges a second line                                                                                                     | LOW      | `json.dumps` escaping; the round-trip criterion; the inbound alphabet                                                        |
| TM-05 | I      | A09      | PR.DS        | TB1      | `message` carries whatever a call site interpolates                                                                                      | LOW      | Accepted residual; no redaction claimed; the correct pattern passes an id (7.9)                                              |
| TM-06 | I      | A09      | PR.DS        | TB3      | A request path lands in an unscrubbed message                                                                                            | LOW      | No secret or PII in a path segment, stated in the guide (Q5) (7.9)                                                           |
| TM-07 | I      | A09      | PR.DS        | TB3      | Django's own records carry `str(exc)` in `message`; the criterion says "never"                                                           | LOW      | The claim is narrowed in the criterion, the guide and the inventory row (Q6) (7.9)                                           |
| TM-08 | I      | A10      | PR.DS        | TB1      | Locals, source text, chained messages or notes leak through "type and frames"                                                            | LOW      | `(filename, lineno, function)` only; chain type-only; notes dropped (7.4)                                                    |
| TM-09 | R      | A10      | DE.CM        | TB1      | The formatter raises, the line is lost and `handleError` prints it                                                                       | LOW      | The formatter never raises; its fallback is one JSON object through a guarded `repr` (R2-Q5, R3-Q2) (7.5)                    |
| TM-10 | I      | A02      | PR.PS        | TB4      | One handler escapes the pipeline — no filter, wrong mode, or stderr                                                                      | LOW      | Per-environment assertions on every handler, mode and stream (7.6)                                                           |
| TM-11 | I      | A02      | PR.PS        | TB4      | `DEFAULT_LOGGING`'s `django` logger survives at `INFO` with two undeclared handlers                                                      | LOW      | `django` declared with no handlers at `WARNING` (Q8) (7.7)                                                                   |
| TM-12 | I      | A02      | PR.DS        | TB7      | Gunicorn writes a plain-text access stream with address and query string                                                                 | LOW      | `--access-logfile -` dropped from three entrypoints (Q1) (7.8)                                                               |
| TM-13 | R, I   | A09, A10 | DE.CM, PR.DS | TB7      | Process-server error lines are plain text, dropped by the queries, and carry an escaped exception's message                              | LOW      | Claims narrowed to Django's `LOGGING`; stream documented with a selector (R2-Q1); staging at `warning` (R3-Q4) (7.8, 7.12)   |
| TM-14 | D      | A09      | DE.CM        | TB5      | The queries select on a label nothing sets                                                                                               | LOW      | The label contract and its reference realisation (Q11) (7.11)                                                                |
| TM-15 | I      | A09      | DE.AE        | TB5      | Staging and production lines are indistinguishable                                                                                       | LOW      | An environment label from the Compose project (Q10) (7.11)                                                                   |
| TM-16 | D      | A06      | PR.IR        | TB2, TB5 | An attacker drives log volume through 404s and bad `Host` headers                                                                        | LOW      | Accepted residual; edge controls; `json-file` rotation bounds the disk (7.11)                                                |
| TM-17 | I      | A02      | PR.DS        | TB6      | The dev host mount exposes root-owned files holding the wide stream                                                                      | LOW      | Accepted residual; posture `development`; gitignored; never in an image                                                      |
| TM-20 | R      | A09      | DE.CM        | TB5, TB7 | A line over 4 KiB can interleave across workers; Docker splits one over 16 KiB; the fragments fail the `json` stage                      | LOW      | 16 KiB cap with a `"truncated": true` marker; the 4 KiB interleave an accepted residual (R3-Q1) (7.13)                       |
| TM-18 | R      | A09      | DE.AE        | TB2      | Short-circuited, out-of-request and out-of-extent lines (streaming bodies, view-started threads, mid-stream ASGI exceptions) carry no id | INFO     | Accepted doctrine; `null`, never absent (grilling 31/10/2026, Q5); out-of-extent cases stated and test-pinned (R3-Q3) (7.14) |
| TM-19 | I      | A10      | PR.DS        | TB5      | Frames disclose the container layout                                                                                                     | INFO     | Accepted                                                                                                                     |

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/PLANNING/`, and that
absence is a recorded outcome rather than an unrun check — Section 1 gives its reason and the
threat model's Section 3a names what promotes each finding. **TM-07's severity is not its
importance**: it is `LOW` because the leak is Django's documented behaviour and the fix is a
sentence, and it is the finding most worth reading first, because left alone it is a shipped
security claim the tests would never catch — the scenario's own `ValueError` never takes that path.

## 7. Security tasks & open gaps

Fourteen constraints, each checkable by reading the shipped module, the settings, the entrypoints
and the two edge clauses. Each becomes a US014 acceptance criterion; the implementation assessment
closes it with evidence.

- [ ] **7.1** The filter sets `record.request_id` from `current_request_id()` **unconditionally** —
      never `setdefault` — mapping `""` to `None` and returning `True`; a call site's
      `extra={"request_id": ...}` is overwritten, proved by a test (A09, TM-02)
- [ ] **7.2** In dev's wide mode the five fixed keys — `timestamp`, `level`, `logger`, `message`,
      `request_id` — are written **after** the extras, so no extra shadows one; proved by a test
      with a colliding extra (A09, TM-02)
- [ ] **7.3** A view that **returns** a 4xx or 5xx yields a `django.request` line whose
      `request_id` equals the response's `X-Request-ID`, under both `Client` and `AsyncClient`.
      `log_response` passes `request` and `status_code`, not `response`
      (`django/utils/log.py:291-323`), and the middleware keeps the id only in the `ContextVar` and
      on the response (`middleware.py:45-48`). **Settled, option A (gates grilling round 2,
      01/11/2026, R2-Q4):** `RequestIDMiddleware` stores the id on the request, and the filter falls
      back to the `request` extra's stored id for a returned-error `django.request` record; the
      stored id is the validated or minted one, never the raw header. `middleware.py`, its
      `apps/core` test and the `apps/core/CONTEXT.md` middleware row join the edit set (A09, TM-03)
- [ ] **7.4** Minimal-mode `exc_info` is the exception **type** plus `(filename, lineno, function)`
      per frame — no source-line text, no `f_locals`; `__cause__` and `__context__` walked
      type-only; PEP 678 notes dropped; neither `record.stack_info` nor a cached `record.exc_text`
      is emitted, and minimal mode never delegates to `logging.Formatter.format` or
      `formatException`. The "appears nowhere" assertion is scoped to `exc_info` and covers a
      chained exception. The `exc_info` JSON shape is pinned at the QA review (R2-Q6) (A10, TM-08)
- [ ] **7.5** The formatter **never raises**: a payload `json.dumps` cannot serialise — a key
      that is not `str`, `int`, `float`, `bool` or `None` (a tuple, say), or a self-referencing
      dict — still yields **one JSON object**: the fixed field set, with unserialisable values
      coerced to `str()` (gates grilling round 2, 01/11/2026, R2-Q5). **Refined (gates grilling
      round 3, 01/11/2026, R3-Q2):** the extras stay, coerced in place and still subject to the
      allowlist; on a `getMessage()` failure `message` is `str(record.msg)` without the arguments;
      every coercion goes through a guarded `repr` that cannot raise, so nothing reaches
      `Handler.handleError`'s plain-text `Message` / `Arguments` print on stderr. Proved by
      `json.loads` on that line asserting the key set and `message`. **Noted (01/11/2026, scoped qa-tester re-check fold):** the fallback carries **no** `format_error` marker — QA-PLAN-US014 AC-GAP-11 pins none, and EC-12 and EC-17 assert none; adding one changes the ruled shape (gates grilling round 3, 01/11/2026, R3-Q2) and goes back to <%DEVELOPER_NAME%>. (A10, TM-09)
- [ ] **7.6** Every handler of every environment's `LOGGING` declares the filter; the staging and
      production console handlers declare `ext://sys.stdout`; the formatter mode is asserted per
      environment — the story's own _The filter is on every handler_ scenario and Backend
      Acceptance Criteria (A02, TM-10)
- [ ] **7.7** Staging, production and test declare `"django": {"handlers": [], "level": "WARNING"}`
      with propagation on, and the settings test asserts all three (gates grilling 01/11/2026, Q8;
      gates grilling round 2, 01/11/2026, R2-Q2) (A02, TM-11)
- [ ] **7.8** `--access-logfile -` is removed from `entrypoint.staging.sh:30`,
      `entrypoint.prod.sh:31` and `entrypoint.test.sh:27` (gates grilling 01/11/2026, Q1). Dev keeps
      uvicorn's plain-text access log, and every "dev is JSON" claim is narrowed to Django's lines
      (R2-Q8). `entrypoint.staging.sh:29`'s `--log-level info` becomes `warning`, as
      `entrypoint.prod.sh:30` (gates grilling round 3, 01/11/2026, R3-Q4) (A02, TM-12, TM-13)
- [ ] **7.9** `DJANGO-LOGGING.md`'s staging/prod section states three things exactly: `message` is
      not scrubbed; **paths are logged, so no secret or PII goes in a URL path segment** (Q5);
      `exc_info` carries no exception message, **but Django's `BadRequest` and
      `SuspiciousOperation` records carry `str(exc)` in `message`** (Q6). The story's Security Acceptance
      Criterion and the `DATA-INVENTORY.md` row are reworded to match (A09, TM-05, TM-06,
      TM-07)
- [ ] **7.10** `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entry 13 (`:276-292`; its deploy clause `:288-292`) gains one
      clause: **the edge sets `X-Request-ID` from its own `$request_id` unconditionally, discarding
      any client-supplied value** (gates grilling 01/11/2026, Q7). The app's alphabet check stays
      (A09, TM-01)
- [ ] **7.11** The new log-collection section states the label contract collector-neutrally —
      `com.docker.compose.service` to `service_name`, `com.docker.compose.project` to an
      environment label — with Grafana Alloy as the reference realisation, `json-file` rotation
      (`max-size` / `max-file`) on the host, and the retention line; `OBSERVABILITY.md:120` is
      corrected in the same change (Q3, Q10, Q11). The 4xx `WARNING` volume from `django.request` is
      accepted and recorded in the logging plan, with no `GAPS.md` row (R2-Q3) (A09, TM-14, TM-15,
      TM-16)
- [ ] **7.12** The "every line", "every entry carries `request_id`" and "no exception message off
      dev" claims are scoped to the lines Django's `LOGGING` emits, and the process-server stream —
      plain text, stderr, rarely an escaped ASGI traceback with its message — is documented where
      the pipeline is described, with a LogQL selector that keeps it. Nothing routes it through
      `LOGGING` (gates grilling round 2, 01/11/2026, R2-Q1) (A09, A10, TM-13)
- [ ] **7.13** The minimal (staging and production) formatter caps its output at **16 KiB** —
      the encoded line, newline included — truncating with a `"truncated": true` marker, so the line
      still parses as one JSON object and Docker never splits it. A line between 4 KiB
      (`PIPE_BUF`) and the cap can still interleave across workers; that is recorded as an
      **accepted residual**, and the non-JSON selector (R2-Q1) still returns the fragments (gates
      grilling round 3, 01/11/2026, R3-Q1) (A09, TM-20)
- [ ] **7.14** Records outside `RequestIDMiddleware`'s dynamic extent — a streaming or file body
      generated after `get_response` returns, a thread a view starts, an exception raised
      mid-stream under ASGI — are stated as **uncorrelated** (`request_id` null) in the story's Out
      of Scope and `DJANGO-LOGGING.md`, and a test pins the null (gates grilling round 3,
      01/11/2026, R3-Q3) (A09, TM-18)

**None of the fourteen is a sprint-planning blocker** — no CRITICAL or HIGH was raised. **7.9 is the
one to read first**, because it is the constraint that keeps a published security claim true.
**None is still open:** 7.12 and 7.5 were settled in round 2 (R2-Q1, R2-Q5); 7.13 and 7.14 were
added, and 7.5 and 7.8 refined, in round 3 (R3-Q1 to R3-Q4).

## 8. What this assessment could not settle

**Three of this gate's questions are settled** (gates grilling 01/11/2026, Q5, Q6 and Q7), and
each is named against its constraint above. **The two items that arose after that round closed
were OPEN with <%DEVELOPER_NAME%> and are now RESOLVED** (gates grilling round 2, 01/11/2026):

1. **TM-13 — what does "every log line" cover, and does the escaped-exception traceback need
   handling off dev?** Gunicorn's and Uvicorn's error lines (`entrypoint.staging.sh:29` at `info`,
   `entrypoint.prod.sh:30` at `warning`; `uvicorn/workers.py:35-38`) are plain text on stderr with
   no `request_id`, `code/workflows/09-debugging-with-logs/STEPS.md:104-106`'s `json` stage with
   `__error__=""` drops them, and an escaped ASGI exception is logged with its full traceback,
   message included (`uvicorn/protocols/http/httptools_impl.py:426-427`). **RESOLVED (R2-Q1),
   option (a):** the claims are narrowed to every line Django's `LOGGING` emits, and the
   process-server stream — plain text, stderr, rarely an escaped ASGI traceback with its message —
   is documented with a LogQL selector that keeps it. No routing through `LOGGING`. The gate-09
   plan held the same item (`GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md`, Section 10's RESOLVED
   process-server item). Round 3 sets staging's level to `warning`, as production's (R3-Q4).
2. **TM-09 — the formatter's fallback.** **RESOLVED (R2-Q5):** the fallback stays one JSON object,
   the fixed field set with unserialisable values `str()`-coerced (7.5); round 3 refines it to
   extras coerced in place under the allowlist, through a guarded `repr` (R3-Q2).

**Round 3 raised and settled the rest the same day** (gates grilling round 3, 01/11/2026): the
16 KiB cap and the accepted `PIPE_BUF` interleave (R3-Q1, 7.13), the uncorrelated out-of-extent
records (R3-Q3, 7.14), and the process-server level parity (R3-Q4, 7.8).

**Nothing is OPEN with <%DEVELOPER_NAME%>.** The assessment as a whole awaits his sign-off.

**Noted, no question:** `base.py:50`'s comment calls `RequestIDMiddleware` "third in the pipeline"
though it is second — a doc task for the implementer to check and correct.

**Could not be checked from this tree:** whether the deploy repository's Nginx already overwrites
`X-Request-ID` or rejects unknown `Host` headers; the collector's real relabel (`14-logging-checks`
confirms it); and any runtime behaviour, because the formatter and filter do not exist and every
Django, Gunicorn and Uvicorn behaviour above was read from source. Line citations into files US013
edits are re-measured after it merges (the story's Dependencies, _US013 merges first_).

---

## Cross-references

- `project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record that verifies this baseline
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` — the STRIDE model this assessment synthesises
- `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — escalated CRITICAL/HIGH findings; none from this assessment
- `project-management/src/02-STORIES/US014.md` — the story being assessed
- `project-management/src/09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the gate-09 plan, written in the same pass
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP and NIST CSF standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` · `code/docs/security/MONITORING-AND-INCIDENT.md` — the code-side doctrine these targets must stay consistent with
