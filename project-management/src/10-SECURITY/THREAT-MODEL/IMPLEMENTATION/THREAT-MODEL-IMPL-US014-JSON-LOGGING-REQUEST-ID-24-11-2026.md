# Threat Model Review — US014 Structured JSON logging with a `request_id` on every entry

| Field           | Value                                                                                                                                                                                                                                                                                             |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                                                              |
| **Date**        | 24/11/2026                                                                                                                                                                                                                                                                                        |
| **Verified by** | Claude Code (Opus), `22-implementation-documentation` Step 3, the `security` skill read inline — the recorder wrote none of the story's code. Inputs: the shipped working tree, the review fix report and the Sprint Verification Checklist report of 23/11/2026, and the suite run of 24/11/2026 |
| **Plan doc**    | `../PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` (signed off 01/11/2026)                                                                                                                                                                                                          |
| **Outcome**     | **PASS with deferred items** — all twenty planned threats re-assessed: 15 **Mitigated**, 5 **Residual** (accepted by design, each tracked), **0 New** above LOW. No CRITICAL or HIGH. Read with Section 5: nine LOWs still promote to MEDIUM on the plan's Section 3a triggers                    |

> **This is not "the security gate passed"** (`code/docs/GATE-REPORTING.md`). It is a present-state
> reading of a template at posture `development` that serves nothing. The collector and edge half
> (TM-01, TM-14, TM-15, TM-16) is a **contract stated here and realised in the deploy repository**;
> this repository cannot test it, and nothing below claims it was tested.

---

## 1. Scope

The surface shipped as planned. State: branch `us014/structured-json-logging`, base `b1705408`,
build uncommitted in the working tree; unit suite green on 24/11/2026 (`tests/all.sh --coverage`,
exit 0). One addition beyond the plan's file list: the tests split into four modules plus a
support module (QA record Section 4), which changes no surface.

| File                                                                                                          | Purpose                                                                                        |
| ------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `code/src/django/apps/core/observability.py` (561 lines)                                                      | `JSONFormatter` (minimal / wide), `RequestIDFilter`, the cap, the fallback and the last resort |
| `code/src/django/apps/core/middleware.py`                                                                     | `RequestIDMiddleware` — the alphabet check, the minted id, `request.request_id`                |
| `code/src/django/config/settings/{dev,test,staging,production}.py` · `base.py`                                | Each environment's own `LOGGING`; `base.py` assigns none                                       |
| `code/src/docker/django/entrypoint.{staging,prod,test}.sh` · `code/src/docker/docker-compose.dev.yml`         | The access log dropped; staging at `warning`; the dev logs bind mount                          |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entries 13 and 15                                       | The unconditional `X-Request-ID` clause; the new log-collection section                        |
| `code/docs/logging/DJANGO-LOGGING.md` · `OBSERVABILITY.md` · `code/workflows/09-debugging-with-logs/STEPS.md` | The narrowed claims, the path rule, the selectors and the process-server selector              |
| `code/src/django/apps/core/tests/unit/test_observability*.py` · `test_middleware.py`                          | The pinning tests (156 cases, all passing)                                                     |

## 2. Trust boundaries — confirmed

| ID  | Boundary                                   | Change since plan                                                                                                                      |
| --- | ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| TB1 | Call site → `LogRecord` and formatter      | Unchanged                                                                                                                              |
| TB2 | HTTP client → `RequestIDMiddleware`        | Unchanged boundary; the middleware now also writes `request.request_id` (validated or minted)                                          |
| TB3 | Django's handlers → the pipeline           | Unchanged; the filter reads the `request` extra's stored id for `django.request` only                                                  |
| TB4 | Settings module → running logging config   | Unchanged; `base.py` no longer contributes a `LOGGING`                                                                                 |
| TB5 | Container stdout / stderr → collector      | Unchanged; the contract is now written (entry 15)                                                                                      |
| TB6 | Dev container → host filesystem            | **Now live**: `../logs:/workspace/code/src/logs` (`docker-compose.dev.yml`); `code/src/logs/django.log` exists on the host, root-owned |
| TB7 | Process server → container stdout / stderr | Narrowed: no access stream outside dev; error stream unchanged                                                                         |
| TB8 | Edge proxy → Django                        | Unchanged; entry 13 now requires the edge to overwrite the header                                                                      |

## 3. STRIDE threat re-assessment

| ID    | STRIDE | OWASP                  | NIST CSF         | TB       | Threat description                                                 | Severity | Status    | Mitigation (as shipped)                                                                                                                                                                                                                                                                                                           |
| ----- | ------ | ---------------------- | ---------------- | -------- | ------------------------------------------------------------------ | -------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | S      | `A09:2025`             | `DE.AE`          | TB2, TB8 | A client chooses its own correlation identifier                    | LOW      | Mitigated | `EDGE-REQUIREMENTS.md` entry 13: "Set the header from the edge's own `$request_id` unconditionally, discarding any client-supplied `X-Request-ID`"; the app's alphabet check stays (`middleware.py` · `_INBOUND_PATTERN`). **Contract only** — the deploy repository realises it; untestable here                                 |
| TM-02 | T      | `A09:2025`             | `DE.AE`          | TB1      | A call site forges `request_id` or shadows a fixed key             | LOW      | Mitigated | `RequestIDFilter.filter` assigns unconditionally; wide mode merges extras first then `fields.as_payload()`; minimal mode allowlists. `test_a_forged_request_id_is_overwritten` (EC-01), `test_a_colliding_extra_never_replaces_a_fixed_key` (EC-02)                                                                               |
| TM-03 | R      | `A09:2025`             | `DE.AE`          | TB3      | A returned 4xx / 5xx line loses its id                             | LOW      | Mitigated | `RequestIDMiddleware` stores `request.request_id`; `_correlation_id` falls back to it for `django.request`, never `request.META`. `TestReturnedErrorsTakeTheStoredId` — 400 and 500 × minted and inbound × `Client` and `AsyncClient` (HP-08, HP-09); `test_a_rejected_inbound_id_never_reaches_the_line` (EC-05)                 |
| TM-04 | T      | `A05:2025`             | `DE.CM`          | TB1, TB3 | A crafted value forges a second line                               | LOW      | Mitigated | `_serialise` · `json.dumps(..., ensure_ascii=True, allow_nan=False)`; `test_quote_backslash_and_newline_round_trip_on_one_line` (HP-01); strict-JSON `parse_line` in every test rejects `NaN` / `Infinity` (review M1)                                                                                                            |
| TM-05 | I      | `A09:2025`             | `PR.DS`          | TB1      | `message` carries whatever a call site interpolates                | LOW      | Residual  | Accepted by design: no redaction claimed (`DJANGO-LOGGING.md`:35-37, "nothing in `apps.core.observability` scrubs"); the correct pattern logs `user_id` (`:49-51`). Promotes per plan Section 3a                                                                                                                                  |
| TM-06 | I      | `A09:2025`             | `PR.DS`          | TB3      | A request path lands in an unscrubbed message                      | LOW      | Mitigated | Design rule written: `DJANGO-LOGGING.md` _The path rule_ — "no secret or personal data goes in a URL path segment". Query strings never reach `message` off dev (`test_keeps_the_allowlist_and_drops_everything_else`, the `request` extra dropped)                                                                               |
| TM-07 | I      | `A09:2025`             | `PR.DS`          | TB3      | Django's own records carry `str(exc)` in `message`                 | LOW      | Mitigated | Claim narrowed, not code widened: `DJANGO-LOGGING.md`:155-156; `../../../09-GDPR/DATA-INVENTORY.md` 15a; pinned by `test_bad_request_text_reaches_message_and_not_exc_info` (EC-11)                                                                                                                                               |
| TM-08 | I      | `A10:2025`             | `PR.DS`          | TB1      | Locals, source text, chained messages or notes leak via `exc_info` | LOW      | Mitigated | `_exception_shape` / `_frames`: type plus `{filename, lineno, function}`; links type-only; notes, `stack_info`, `exc_text` never emitted; no `Formatter.format` delegation. EC-08, EC-09, EC-10, `test_stack_info_and_a_cached_exc_text_never_reach_the_line`, `test_never_delegates_to_the_stdlib_formatter`                     |
| TM-09 | R      | `A10:2025`             | `DE.CM`          | TB1      | The formatter raises, the line is lost, `handleError` prints it    | LOW      | Mitigated | `JSONFormatter.format`: ordinary path → `_format_fallback` (allowlist before coercion, guarded `repr`, `str(record.msg)` on bad args) → `_last_resort` (live time, level, logger, `request_id`) → constant. EC-12, EC-17, `TestTheFormatterNeverRaises`; malformed `exc_info` keeps the line (review L5). No marker key           |
| TM-10 | I      | `A02:2025`             | `PR.PS`          | TB4      | One handler escapes the pipeline                                   | LOW      | Mitigated | `test_every_handler_carries_the_filter` and `test_each_environment_selects_its_line_shape` per environment; staging/prod `ext://sys.stdout`; `test_staging_and_production_carry_one_identical_dict`. Negative fixtures fail naming env and handler (ES-04, ES-05)                                                                 |
| TM-11 | I      | `A02:2025`             | `PR.PS`          | TB4      | `DEFAULT_LOGGING`'s `django` logger survives                       | LOW      | Mitigated | `"django": {"handlers": [], "level": "WARNING"}` in `staging.py`, `production.py`, `test.py`; asserted per env; `ADMINS` set nowhere                                                                                                                                                                                              |
| TM-12 | I      | `A02:2025`             | `PR.DS`          | TB7      | Gunicorn writes a plain-text access stream                         | LOW      | Mitigated | `--access-logfile -` absent from the three entrypoints (read 24/11/2026). Dev keeps uvicorn's access log by ruling (R2-Q8), narrowed in `code/src/docker/CONTEXT.md`                                                                                                                                                              |
| TM-13 | R, I   | `A09:2025`, `A10:2025` | `DE.CM`, `PR.DS` | TB7      | Process-server error lines outside the pipeline                    | LOW      | Residual  | Closed by stating it (R2-Q1): `DJANGO-LOGGING.md` _The process-server stream_ and entry 15 document the stream and the keeping selector `{service_name="django"} \| json \| __error__!=""`; staging at `--log-level warning`. The disclosure half remains by design. **One of the two to watch**                                  |
| TM-14 | D      | `A09:2025`             | `DE.CM`          | TB5      | The queries select on a label nothing sets                         | LOW      | Mitigated | Entry 15: read through the daemon with labels, relabel `com.docker.compose.service` → `service_name`; `OBSERVABILITY.md` diagram now reads "Compose labels relabelled to service_name and environment"; every selector `{service_name="django"}`. Relabel re-read against Alloy v1.22.0 (`LOGGING-IMPL-US014`). **Contract only** |
| TM-15 | I      | `A09:2025`             | `DE.AE`          | TB5      | Staging and production lines indistinguishable                     | LOW      | Mitigated | Entry 15: `com.docker.compose.project` → environment label. **Contract only**                                                                                                                                                                                                                                                     |
| TM-16 | D      | `A06:2025`             | `PR.IR`          | TB2, TB5 | An attacker drives log volume                                      | LOW      | Residual  | Accepted: edge rate limiting is the deploy repository's; entry 15 requires `json-file` `max-size` / `max-file`; the 4xx `WARNING` volume is recorded in the logging plan 2.3 and `LOGGING-IMPL-US014`, no `GAPS.md` row (R2-Q3)                                                                                                   |
| TM-17 | I      | `A02:2025`             | `PR.DS`          | TB6      | The dev host mount exposes the wide stream                         | LOW      | Residual  | Accepted: posture `development`; `code/src/logs/.gitignore` keeps `*.log` out of git; staging/production images copy only `code/src/django/`. Confirmed on the host: `django.log` is root-owned, mode `-rw-r--r--` (24/11/2026)                                                                                                   |
| TM-18 | R      | `A09:2025`             | `DE.AE`          | TB2      | Out-of-extent lines carry no id                                    | INFO     | Mitigated | Stated, not repaired: `DJANGO-LOGGING.md` _Uncorrelated records_; pinned by `test_a_streamed_body_logged_after_the_view_is_null` (EC-21), `test_a_thread_the_view_starts_is_uncorrelated_on_the_default_build` (EC-21b), `test_a_record_after_the_request_has_finished_is_null` (EC-07)                                           |
| TM-19 | I      | `A10:2025`             | `PR.DS`          | TB5      | Frames disclose the container layout                               | INFO     | Residual  | Accepted: the layout is public in the template                                                                                                                                                                                                                                                                                    |
| TM-20 | R      | `A09:2025`             | `DE.CM`          | TB5, TB7 | A large line breaks in transit                                     | LOW      | Mitigated | `_cap`: line plus newline ≤ `LINE_CAP_BYTES` (16 384), `"truncated": true`, outermost type and innermost frame kept; measured as bytes. `TestTheCap` in both modules, EC-13, EC-23. The 4 KiB interleave is the accepted residual, stated in `DJANGO-LOGGING.md` _Line shape_                                                     |

**Count: 15 Mitigated, 5 Residual** (TM-05, TM-13, TM-16, TM-17, TM-19). Three Mitigated rows
(TM-01, TM-14, TM-15) are mitigated **as contract text**, not as a control this repository can
exercise.

## 4. New threats identified during implementation

The post-build review raised findings; none is a new threat class, and none is above LOW.

- **N-1 (LOW, fixed) — a non-finite float made the line invalid JSON** (review M1). `json.dumps`
  writes `NaN`, which LogQL's `| json` stage rejects, so a line would fall into the
  process-server selector and out of every `__error__=""` query — a TM-09 / TM-20 variant.
  Fixed with `allow_nan=False` and text coercion; every test now parses strictly.
- **N-2 (LOW, fixed) — the last-resort line was a 1970 constant** (review L4/F3), losing level,
  logger and `request_id` — a TM-09 repudiation variant. Now built live by `_last_resort`.
- **N-3 (LOW, fixed) — a malformed `exc_info` dropped the record to the last resort** (review
  L5/F2). `_recorded_exception` now accepts only a tuple of length 2 or more.
- **N-4 (INFO, accepted) — a handler declared without the filter trusts
  `extra={"request_id": ...}`** (review L6/F4). Within the design: every shipped handler carries
  the filter (TM-10's test); one sentence in `DJANGO-LOGGING.md` says so.
- **N-5 (INFO, accepted) — `django.server` keeps Django's plain-text handler** (review F5). Only
  `runserver` writes to it and no stack runs `runserver`; `DJANGO-LOGGING.md` scopes the
  every-handler claim to "every handler in every environment's `LOGGING`".

Nothing escalates to `../../VULNERABILITIES/IMPLEMENTATION/`.

## 5. Residual & deferred items

| Item                                                                                   | Threat IDs          | Severity     | Tracked in / when                                                                                                                                        |
| -------------------------------------------------------------------------------------- | ------------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `message` unscrubbed; redaction is the deferred `syntek-observability` half            | TM-05, TM-07        | LOW → MEDIUM | `MAP-RULE-OWNERSHIP.md` Batch G1; the ADR's supersession trigger. Promotes when the collector's readers widen                                            |
| Process-server stream plain text, can carry an escaped ASGI traceback with its message | TM-13               | LOW → MEDIUM | Story plan _Accepted residuals_; promotes on the first incident it causes or one carrying personal data                                                  |
| Log volume; edge rate limiting                                                         | TM-16               | LOW          | Deploy repository; logging plan 2.3 (R2-Q3)                                                                                                              |
| Dev host mount root-owned                                                              | TM-17               | LOW          | Accepted while posture is `development`                                                                                                                  |
| Container layout in frames                                                             | TM-19               | INFO         | Accepted                                                                                                                                                 |
| Collector relabel and edge overwrite realised elsewhere                                | TM-01, TM-14, TM-15 | LOW → MEDIUM | `EDGE-REQUIREMENTS.md` entries 13 and 15; **the ADR's ordering clause — entry 13 deployed before any surface goes live or entry 2's nonce is activated** |
| The 4 KiB interleave                                                                   | TM-20               | LOW          | Accepted residual, `DJANGO-LOGGING.md` _Line shape_                                                                                                      |
| The cycle back-edge omitted, not `null`                                                | TM-08 (shape)       | INFO         | Review L3, awaiting <%DEVELOPER_NAME%>'s ruling — findings record F-003                                                                                  |

**The promotion triggers of the plan's Section 3a stand unchanged.** None has fired: no surface is
live (`.claude/CLAUDE.md` Section 0, posture `development`).

## 6. Sign-off

| Reviewer           | Role                                   | Date       |
| ------------------ | -------------------------------------- | ---------- |
| Claude Code (Opus) | Recorder — re-assessment from evidence | 24/11/2026 |
| <%DEVELOPER_NAME%> | Developer sign-off — countersignature  | 24/11/2026 |

**Overall verdict:** no CRITICAL or HIGH was planned or introduced; every planned threat is
mitigated in shipped code or contract text, or is a known, tracked residual. Not a security pass —
the collector and edge half is untested here by construction, and the developer's sign-off is owed.

**Countersigned 24/11/2026 by Sam**, the developer — not this record's author — with all US014 work: "I countersign, I give permission to tick the acceptance criteria on the stories." The TM-08 shape residual's ruling was given the same day: omit (findings F-003). The record is `../../../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` → _Countersignature — 24/11/2026_. It is not a security pass for the collector and edge half, which stays untested here.

---

## Cross-references

- `../PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` — the model re-assessed here
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` — the fourteen constraints evidenced
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` — the file walk and the review findings
- `../../../02-STORIES/US014.md` — the story reviewed
- `../../../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` — the binding line and collector contract
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `code/docs/SECURITY.md` — the code-side enforcement these claims must stay consistent with
