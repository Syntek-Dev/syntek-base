# Security Posture Assessment (Implementation) — US014 Structured JSON logging with a `request_id` on every entry

| Field           | Value                                                                                                                                                                                                                                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Story**       | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                                                                               |
| **Date**        | 24/11/2026                                                                                                                                                                                                                                                                                                         |
| **Verified by** | Claude Code (Opus), `22-implementation-documentation` Step 3, the `security` skill read inline — the recorder wrote none of the story's code. Evidence: the shipped working tree, the QA and security review fix report and the Sprint Verification Checklist report (23/11/2026), and the suite run of 24/11/2026 |
| **Sprint**      | SPRINT-08                                                                                                                                                                                                                                                                                                          |
| **Plan doc**    | `../PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` (signed off 01/11/2026)                                                                                                                                                                                                                             |
| **Outcome**     | **PASS with deferred items** — all **fourteen constraints closed with evidence** (Section 6); 0 CRITICAL, 0 HIGH, 0 MEDIUM introduced; the twenty planned findings re-read as 15 Resolved and 5 Residual. Not "the security gate passed" (`code/docs/GATE-REPORTING.md`)                                           |

---

## 1. Scope

As planned: the formatter and filter module, the middleware, the four environments' `LOGGING`
and `base.py`'s absence of one, the three entrypoints and the dev mount, and the two edge
entries. State: `us014/structured-json-logging`, base `b1705408`, the build uncommitted.

| File                                                                                                      | What was assessed here                                                               |
| --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `code/src/django/apps/core/observability.py`                                                              | Constraints 1, 2, 4, 5, 13 — filter, modes, exception shape, never-raise, the cap    |
| `code/src/django/apps/core/middleware.py`                                                                 | Constraint 3 — the stored id                                                         |
| `code/src/django/config/settings/{dev,test,staging,production,base}.py`                                   | Constraints 6, 7                                                                     |
| `code/src/docker/django/entrypoint.{staging,prod,test}.sh`                                                | Constraint 8                                                                         |
| `code/docs/logging/DJANGO-LOGGING.md` · `OBSERVABILITY.md` · 09 `STEPS.md` · `MONITORING-AND-INCIDENT.md` | Constraints 9, 12, 13, 14                                                            |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entries 13 and 15                                   | Constraints 10, 11                                                                   |
| `code/src/django/apps/core/tests/unit/test_observability*.py` · `test_middleware.py`                      | The pinning tests — 156 cases, 0 failures (`results-unit.xml`, 24/11/2026 00:38 UTC) |

## 2. OWASP Top 10 — coverage

| ID       | Category                              | Status | Evidence / Notes                                                                                                                                                                                                    |
| -------- | ------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | N/A    | No endpoint, view or role boundary; the test views are fixtures under `pytest.mark.urls`, mounted nowhere (QA plan, PA N/A)                                                                                         |
| A02:2025 | Security Misconfiguration             | PASS   | Constraints 6, 7, 8 — filter on every handler, `django` logger handler-less off dev, no access log; `DEBUG=False` off-local unchanged                                                                               |
| A03:2025 | Software Supply Chain Failures        | PASS   | No dependency added — `pyproject.toml` and `uv.lock` unchanged; `install-backend.sh --check` "uv.lock is up-to-date"; `audits/security.sh` exit 0 (Sprint Verification Checklist, 23/11/2026)                       |
| A04:2025 | Cryptographic Failures                | N/A    | No secret, key or encrypted field; entry 2's nonce coupling is closed by entry 13 (A09 row)                                                                                                                         |
| A05:2025 | Injection                             | PASS   | Log injection closed by construction — `json.dumps(..., ensure_ascii=True, allow_nan=False)`; HP-01 round-trip; inbound alphabet `[A-Za-z0-9._-]{1,200}`                                                            |
| A06:2025 | Insecure Design                       | PASS   | TM-16 accepted residual; rotation and retention stated in entry 15                                                                                                                                                  |
| A07:2025 | Authentication Failures               | N/A    | No authentication surface                                                                                                                                                                                           |
| A08:2025 | Software and Data Integrity Failures  | PASS   | `request_id` cannot be forged by a call site (constraint 1) or chosen by a client once entry 13 is deployed (constraint 10)                                                                                         |
| A09:2025 | Security Logging & Alerting Failures  | PASS   | The story's surface: every line Django's `LOGGING` emits is one JSON object carrying `request_id`, including returned 4xx/5xx (constraints 1–3, 6, 12); `MONITORING-AND-INCIDENT.md`:41-43 now true for that stream |
| A10:2025 | Mishandling of Exceptional Conditions | PASS   | Constraints 4, 5, 13 — message-free `exc_info`, never-raise fallback, the 16 KiB cap; review M1, L4, L5 fixed test-first                                                                                            |

## 3. NIST CSF 2.0 — coverage

| Fn  | Function | Status | Evidence                                                                                                                            |
| --- | -------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | PASS   | ADR-US014 binds the line contract; a rename needs a superseding ADR (`observability.py` module docstring)                           |
| ID  | Identify | PASS   | The process-server stream and the uncorrelated cases are named, not hidden (constraints 12, 14)                                     |
| PR  | Protect  | PASS   | Minimisation off dev — allowlist, message-free `exc_info` (constraints 2, 4); no access log (8)                                     |
| DE  | Detect   | PASS   | Correlatable, parseable lines; `{service_name="django"}` selectors; the keeping selector for non-JSON lines (constraints 3, 11, 12) |
| RS  | Respond  | PASS   | A supplied `request_id` reaches every correlated line, the error lines included (constraint 3); 09 `STEPS.md` queries corrected     |
| RC  | Recover  | N/A    | No recovery surface                                                                                                                 |

## 4. Findings

Findings raised against the shipped code by the review of 23/11/2026, adversarially verified
before they were acted on. **No CRITICAL or HIGH was identified**; nothing escalates to
`../../VULNERABILITIES/IMPLEMENTATION/`.

| ID    | STRIDE | OWASP    | NIST CSF | Severity | Finding                                                                                     | Recommendation                                       | Status                                                                                     |
| ----- | ------ | -------- | -------- | -------- | ------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| F-001 | R      | A10:2025 | DE.CM    | MEDIUM   | NaN / Infinity serialised as `NaN`, an invalid JSON line the `json` stage drops (review M1) | `allow_nan=False`; non-finite values written as text | **Resolved** — `_serialise`, `_json_value`, wide fallback; strict `parse_line`             |
| F-002 | R      | A09:2025 | DE.AE    | MEDIUM   | The returned-error criterion half covered — 500 and inbound ids untested (review M2)        | 400/500 × minted/inbound × `Client`/`AsyncClient`    | **Resolved** — `TestReturnedErrorsTakeTheStoredId`; no code bug                            |
| F-003 | R      | A10:2025 | DE.CM    | LOW      | Self-referencing dict extra untested (L1)                                                   | Pin both modes                                       | **Resolved** — EC-12 tests                                                                 |
| F-004 | R      | A10:2025 | DE.AE    | LOW      | `__context__` cycle back-edge written `null`, which reads "no context" (L3)                 | Omit the key                                         | **Resolved, ruling owed** — back-edge omitted; omit vs `null` is <%DEVELOPER_NAME%>'s call |
| F-005 | R      | A09:2025 | DE.AE    | LOW      | Last-resort line a 1970 constant, losing level, logger and `request_id` (L4)                | Build it live                                        | **Resolved** — `_last_resort`                                                              |
| F-006 | R      | A10:2025 | DE.CM    | LOW      | A malformed `exc_info` dropped the line to the last resort (L5)                             | Accept only a 2+-tuple                               | **Resolved** — `_recorded_exception`                                                       |
| F-007 | T      | A09:2025 | DE.AE    | INFO     | A handler without the filter trusts `extra={"request_id": ...}` (L6)                        | Document                                             | **Accepted** — `DJANGO-LOGGING.md` sentence                                                |
| F-008 | I      | A02:2025 | PR.PS    | INFO     | `django.server` keeps its plain-text handler (F5)                                           | Scope the claim                                      | **Accepted** — claim scoped to every environment's `LOGGING`                               |
| F-009 | I      | A10:2025 | PR.DS    | INFO     | Wide mode drops `stack_info` (dev only)                                                     | Developer's call — adds a dev key                    | **Open** — not a review fix; findings record F-004                                         |

The two MEDIUMs were defects in the built code and its tests, fixed in the same build; neither
is a residual. The severity is the review's, against the unfixed code.

## 5. Planning-phase findings — status update

| Plan finding                      | Status   | Evidence / Notes                                               |
| --------------------------------- | -------- | -------------------------------------------------------------- |
| TM-01, TM-02, TM-03, TM-04, TM-06 | Resolved | Constraints 10, 1–2, 3, (A05 row), 9                           |
| TM-07, TM-08, TM-09, TM-10, TM-11 | Resolved | Constraints 9, 4, 5, 6, 7                                      |
| TM-12, TM-14, TM-15, TM-18, TM-20 | Resolved | Constraints 8, 11, 11, 14, 13                                  |
| TM-05, TM-13, TM-16, TM-17, TM-19 | Residual | Accepted by design and tracked — threat-model record Section 5 |

Full row-by-row evidence: `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` Section 3.

## 6. Plan gaps closed — the fourteen constraints

Threat model Section 4b and this plan's Section 7 number the same fourteen. Each closed **only
with evidence**: a test that passed in the 24/11/2026 run, or a line read in the working tree that
day.

| #    | Constraint                                                                                                                           | Status | Evidence                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------ | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.1  | Filter sets `request_id` unconditionally, `""` → `None`, returns `True`                                                              | Closed | `observability.py` · `RequestIDFilter.filter` assigns `record.request_id = _correlation_id(record)` and returns `True`; tests `test_a_forged_request_id_is_overwritten` (EC-01), `test_never_drops_a_record_and_maps_empty_to_none` (ES-02), `test_outside_a_request_request_id_is_present_and_null` (ES-01)                                                                                                                                                                                 |
| 7.2  | Wide: fixed keys after extras; minimal: only the three extras                                                                        | Closed | `JSONFormatter._format` (wide: extras minus `_FIXED`, then `fields.as_payload()`; minimal: `_allowlisted`); `test_a_colliding_extra_never_replaces_a_fixed_key` (EC-02), `test_keeps_the_allowlist_and_drops_everything_else` (HP-04)                                                                                                                                                                                                                                                        |
| 7.3  | Returned 4xx/5xx line carries the response's `X-Request-ID`, `Client` and `AsyncClient`; stored id never raw header                  | Closed | `middleware.py` · `request.request_id = request_id` (validated or `uuid4().hex`); `observability.py` · `_correlation_id` reads `getattr(record.__dict__.get("request"), "request_id", None)` for `django.request` only; `TestReturnedErrorsTakeTheStoredId` (HP-08, HP-09 — 400 and 500 × minted and `abc-123_XY.z` inbound × both clients); `test_a_rejected_inbound_id_never_reaches_the_line` (EC-05); `test_stores_the_validated_or_minted_id_never_the_raw_header` (EC-16, three cases) |
| 7.4  | Minimal `exc_info` type plus frames; chain type-only; no notes, locals, `stack_info`, `exc_text`; no stdlib delegation               | Closed | `_exception_shape`, `_frames`; `test_type_and_frames_with_no_message` (HP-05), `test_an_explicit_cause_is_a_type_only_link` (EC-08), `test_a_note_is_dropped` (EC-09), `test_a_group_lists_member_types_only` (EC-10), `test_stack_info_and_a_cached_exc_text_never_reach_the_line`, `test_never_delegates_to_the_stdlib_formatter`                                                                                                                                                          |
| 7.5  | Never raises; one JSON object; extras coerced in place under the allowlist; `str(record.msg)` on bad args; guarded `repr`; no marker | Closed | `JSONFormatter.format` → `_format_fallback` → `_last_resort` → `_LAST_RESORT`; the allowlist runs before coercion (`kept = … _allowlisted(record)`); `TestTheFormatterNeverRaises` (`test_one_line_with_the_ruled_key_set`, `test_bad_percent_args_log_the_bare_msg`, `test_an_extra_whose_str_raises_is_its_guarded_repr`), the tuple-key and self-referencing tests (EC-12), U-capsys EC-17. No `format_error` key anywhere in the module                                                  |
| 7.6  | Filter on every handler; staging/prod `ext://sys.stdout`; mode per environment                                                       | Closed | `staging.py`, `production.py` · `"stream": "ext://sys.stdout"`, `"filters": ["request_id"]`; `test_every_handler_carries_the_filter` (HP-11, four envs), `test_each_environment_selects_its_line_shape` (HP-11b), `test_one_json_line_on_stdout_and_nothing_on_stderr` (HP-12), negative fixtures ES-04, ES-05                                                                                                                                                                               |
| 7.7  | Staging, production, test declare `django` with no handlers at `WARNING`                                                             | Closed | `"django": {"handlers": [], "level": "WARNING"}` in `staging.py`, `production.py`, `test.py`; `test_the_check_fails_naming_the_env_when_the_django_logger_goes` (ES-04); `test_an_undeclared_app_logger_inherits_warning` (EC-14)                                                                                                                                                                                                                                                            |
| 7.8  | No `--access-logfile -` in staging, production, test; staging at `warning`                                                           | Closed | `entrypoint.staging.sh`:29-30 (`--log-level warning`, `--error-logfile -`), `entrypoint.prod.sh`:30-31, `entrypoint.test.sh`:26-27 — read 24/11/2026; QA ES-06 static                                                                                                                                                                                                                                                                                                                        |
| 7.9  | `DJANGO-LOGGING.md` states: `message` unscrubbed; the path rule; `str(exc)` in `BadRequest` / `SuspiciousOperation`                  | Closed | `DJANGO-LOGGING.md`:155-156 ("`message` is not scrubbed: Django's `BadRequest` and `SuspiciousOperation` records carry `str(exc)` in it"); _The path rule_ :158-159; `DATA-INVENTORY.md` 15a and the story's Security criterion reworded to match; pinned by EC-11                                                                                                                                                                                                                           |
| 7.10 | Entry 13: the edge sets `X-Request-ID` unconditionally, discarding a client value                                                    | Closed | `EDGE-REQUIREMENTS.md` entry 13, the _Deploy repo must implement_ bullet (`:301-305` on 24/11/2026); entry 13 also corrected to "registered second in `MIDDLEWARE`" (`:292`), matching `base.py`:50. **Contract — realised in the deploy repository**                                                                                                                                                                                                                                        |
| 7.11 | New section: label contract, `json-file` rotation, retention                                                                         | Closed | `EDGE-REQUIREMENTS.md` entry 15 (`:336-366`): daemon read with labels, service and project relabels, rotation, 14/90-day reference retention; Status summary row 15. Reference realisation re-read against Alloy v1.22.0 (`LOGGING-IMPL-US014`)                                                                                                                                                                                                                                              |
| 7.12 | Every "every line" claim scoped to Django's `LOGGING`; process-server stream documented with the keeping selector                    | Closed | `DJANGO-LOGGING.md`:156 and _The process-server stream_; `OBSERVABILITY.md`:101, :106, :166-170; 09 `STEPS.md`:117, :169-174; `MONITORING-AND-INCIDENT.md`:41-43, :50; entry 15 _Source_. Nothing routes `gunicorn.error` / `uvicorn.error` through `LOGGING`                                                                                                                                                                                                                                |
| 7.13 | Minimal line plus newline ≤ 16 KiB, `"truncated": true`, still one object; 4 KiB interleave documented                               | Closed | `LINE_CAP_BYTES = 16_384`, `_cap`; `TestTheCap` (`test_a_line_at_the_cap_is_uncut_and_one_byte_over_is_cut`, `test_each_oversized_record_is_capped_and_marked`, `test_wide_mode_is_never_capped`), EC-13, EC-23 measured as bytes; `DJANGO-LOGGING.md` _Line shape_ states the residual                                                                                                                                                                                                      |
| 7.14 | Out-of-extent records stated uncorrelated and pinned                                                                                 | Closed | `../../../02-STORIES/US014.md` _Out of Scope_ ("Correlating records outside `RequestIDMiddleware`'s dynamic extent"); `DJANGO-LOGGING.md` _Uncorrelated records_; tests EC-07, EC-21, EC-21b (the thread test reads `sys.flags.thread_inherit_context`)                                                                                                                                                                                                                                      |

**Deferred:** none of the fourteen. **Residual:** the five accepted findings of Section 5.

## 7. Deviations from plan

- **The tests are five modules, not one** (`test_observability.py` plus `_limits`, `_requests`,
  `_settings`, and `observability_support.py`), to keep each under 750 lines. No constraint's
  evidence changes; the QA record carries it (review L2).
- **The fallback coerces through a guarded `repr`** (`_safe_text`), and non-finite floats become
  text — the plan said "`str()`-coerced". Stricter, not wider: the allowlist still runs first.
- **A cycle's back-edge is omitted** rather than `null`. Matches ADR-US014's reading that `null`
  means "no cause"; awaits <%DEVELOPER_NAME%>'s ruling (findings record F-003).

## 8. Sign-off

| Reviewer           | Role                                 | Date       |
| ------------------ | ------------------------------------ | ---------- |
| Claude Code (Opus) | Recorder — evidence against the plan | 24/11/2026 |
| <%DEVELOPER_NAME%> | Security sign-off — **owed**         | —          |

**Overall verdict:** the story meets the plan's posture targets — fourteen of fourteen
constraints closed with evidence, no CRITICAL or HIGH introduced, the two review MEDIUMs fixed.
The collector and edge half is contract text this repository cannot exercise; the developer's
security sign-off and the L3 ruling are owed before merge.

---

## Cross-references

- `../PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` — the baseline answered here
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` — the STRIDE re-assessment
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` — the file walk and checklist
- `../../../02-STORIES/US014.md` — the source story
- `../../../11-QA/IMPLEMENTATION/QA-IMPL-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` — scenario evidence
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
