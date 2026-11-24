# QA Implementation Review — US014 Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Field        | Value                                                                                                                                                                                                                                                                                                                                                                                     |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                                                                                                                                                      |
| **Date**     | 24/11/2026                                                                                                                                                                                                                                                                                                                                                                                |
| **Sprint**   | SPRINT-08                                                                                                                                                                                                                                                                                                                                                                                 |
| **Reviewer** | Claude Code (Opus), `22-implementation-documentation` Step 3, the `qa-tester` skill read inline — the recorder wrote none of the story's code                                                                                                                                                                                                                                             |
| **Branch**   | `us014/structured-json-logging` (base `b1705408`; build `e2dfde22`, walk fixes `2a849997`)                                                                                                                                                                                                                                                                                                |
| **Plan doc** | `../PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` (signed off 01/11/2026)                                                                                                                                                                                                                                                                                                            |
| **Outcome**  | **Pass with deviations** — every automated scenario green on 24/11/2026 (156 US014 cases, 0 failures); the static rows read true; **the manual walk passed** 24/11/2026 — `../../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` Outcome Pass, 41 of 41 walked (DOCS-04 and CLOSE-03 re-walked at `2a849997`; CLOSE-04 retired), so HP-13, HP-14 and ES-08 pass and ES-07's branch did not arise |

---

## 1. Scope

The backend lane only (`19-backend-code`; `20` and `21` N/A): `apps/core/observability.py`, the
stored id in `RequestIDMiddleware`, the four environments' `LOGGING` and `base.py`'s deletion, the
three entrypoints, the dev logs mount, and the documentation set. Matches the plan; the one
addition is the test layout (Section 4).

**Evidence run:** `bash code/src/scripts/tests/all.sh --coverage`, 24/11/2026, exit 0 — unit
"227 passed, 28 deselected", integration "22 passed", total coverage 94.50%, `observability.py`
93.4% line / 87.8% branch, `middleware.py` 100%. Test names below are classes or functions in
`code/src/django/apps/core/tests/unit/`; module prefixes: `obs` = `test_observability.py`, `lim` =
`_limits`, `req` = `_requests`, `set` = `_settings`, `mid` = `test_middleware.py`.

## 2. Acceptance-criteria gaps closed

All eighteen were `[RESOLVED]` at planning; each is now closed against shipped behaviour.

| Gap                                                     | Status   | Evidence                                                                                                                                |
| ------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| AC-GAP-1 — container stdout not all JSON (access log)   | Resolved | `--access-logfile -` gone from the three entrypoints (ES-06)                                                                            |
| AC-GAP-2 — `DEFAULT_LOGGING`'s `django` logger survives | Resolved | Handler-less `django` at `WARNING` in staging, production, test; `set` `test_every_handler_carries_the_filter`, ES-04                   |
| AC-GAP-3 — returned-error id unrecoverable              | Resolved | `request.request_id` + the filter's fallback; `req` `TestReturnedErrorsTakeTheStoredId`; `mid` EC-16; `middleware.py` comment rewritten |
| AC-GAP-4 — "type and frames" undefined                  | Resolved | `obs` `TestMinimalExceptionShape` pins `{type, frames, cause, context}` and `{filename, lineno, function}`                              |
| AC-GAP-5 — field values unpinned                        | Resolved | `obs` `test_timestamp_is_utc_to_the_millisecond_whatever_tz` (`+00:00`, ms); `ensure_ascii=True` in `_serialise`                        |
| AC-GAP-6 — returned 4xx named no handler path           | Resolved | `AsyncClient` legs of HP-08/HP-09 (`get_response_async`)                                                                                |
| AC-GAP-7 — the manual staging-settings row              | Resolved | Replaced by U-capsys HP-12, staging's own handler on `sys.stdout`                                                                       |
| AC-GAP-8 — Django writes `str(exc)` into `message`      | Resolved | Claim narrowed in `DJANGO-LOGGING.md`:155-156; `req` `test_bad_request_text_reaches_message_and_not_exc_info` (EC-11)                   |
| AC-GAP-9 — plain-text lines dropped silently            | Resolved | The keeping selector in four documents (ES-09)                                                                                          |
| AC-GAP-10 — large lines break in transit                | Resolved | `_cap`, 16 384 bytes with the newline; `lim` / `obs` `TestTheCap`                                                                       |
| AC-GAP-11 — the fallback's shape                        | Resolved | `lim` `TestTheFormatterNeverRaises` — the ruled key set, no marker                                                                      |
| AC-GAP-12 — no test resolves a formatter path           | Resolved | `set` `TestEveryEntryBuilds` through `DictConfigurator(copy.deepcopy(...))`                                                             |
| AC-GAP-13 — the selector kept only a first line         | Resolved | `{service_name="django"} \| json \| __error__!=""` with the multiline note, as pinned                                                   |
| AC-GAP-14 — gate 09's unobservable Gherkin clauses      | Resolved | Static ES-06 and ES-10; the runtime half recorded **unmeasured**                                                                        |
| AC-GAP-15 — one wording across gates                    | Resolved | "every line Django's `LOGGING` emits" in `DJANGO-LOGGING.md`, `OBSERVABILITY.md`, `MONITORING-AND-INCIDENT.md`, 09 `STEPS.md`, entry 15 |
| AC-GAP-16 — cycle, deep chain, `(None, None, None)`     | Resolved | `obs` EC-18, EC-19, EC-20 — see Section 4 on the back-edge                                                                              |
| AC-GAP-17 — out-of-extent records                       | Resolved | `req` EC-21, EC-21b; `DJANGO-LOGGING.md` _Uncorrelated records_; the story's Out of Scope                                               |
| AC-GAP-18 — non-ASCII search                            | Resolved | `req` `test_a_non_ascii_path_is_logged_escaped` (EC-22); `DJANGO-LOGGING.md` _Line shape_                                               |

## 3. Scenario verification

### Happy Path

| ID     | Scenario (from plan)                                          | Result | Evidence                                                                                                                                                                                                                               |
| ------ | ------------------------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01  | Quote, backslash, newline round-trip on one line              | Pass   | `obs` `test_quote_backslash_and_newline_round_trip_on_one_line` (both modes)                                                                                                                                                           |
| HP-02  | Exactly the fixed five keys                                   | Pass   | `obs` `test_the_key_set_is_exactly_the_fixed_five`                                                                                                                                                                                     |
| HP-03  | UTC to the millisecond whatever `TZ`                          | Pass   | `obs` `test_timestamp_is_utc_to_the_millisecond_whatever_tz`                                                                                                                                                                           |
| HP-04  | Allowlist kept, `email` dropped                               | Pass   | `obs` `test_keeps_the_allowlist_and_drops_everything_else`                                                                                                                                                                             |
| HP-05  | Message-free `exc_info`                                       | Pass   | `obs` `test_type_and_frames_with_no_message`                                                                                                                                                                                           |
| HP-06  | Wide mode: every extra, the full traceback                    | Pass   | `obs` `TestWideMode` (`test_every_extra_is_kept`, `test_exc_info_is_the_full_traceback_with_its_message`, `test_no_reserved_attribute_leaks_into_an_empty_record`)                                                                     |
| HP-07  | A view's WARNING carries the minted id                        | Pass   | `req` `test_a_sync_view_line_carries_the_minted_id`, `test_async_client`                                                                                                                                                               |
| HP-07b | An `async def` view under sync-only middleware                | Pass   | `req` `test_async_client` (async-view parameter)                                                                                                                                                                                       |
| HP-08  | Returned error, `Client`                                      | Pass   | `req` `test_a_returned_400_carries_the_id`, `test_each_returned_error_and_id_source_under_client` (400/500 × minted/inbound)                                                                                                           |
| HP-09  | Returned error, `AsyncClient`                                 | Pass   | `req` `test_a_returned_400_under_async_client`, `test_each_returned_error_and_id_source_under_async_client`                                                                                                                            |
| HP-10  | Raised `PermissionDenied` correlated                          | Pass   | `req` `test_a_raised_permission_denied_is_correlated`, `…_under_async_client`                                                                                                                                                          |
| HP-11  | Each environment's dict                                       | Pass   | `set` `TestEveryEnvironmentsDict`                                                                                                                                                                                                      |
| HP-11b | Every entry instantiates                                      | Pass   | `set` `TestEveryEntryBuilds`                                                                                                                                                                                                           |
| HP-12  | Staging's console: one JSON line on stdout, nothing on stderr | Pass   | `set` `test_one_json_line_on_stdout_and_nothing_on_stderr`                                                                                                                                                                             |
| HP-13  | Dev stack writes the probe line to the host file              | Pass   | Manual — `DEVLOG-02`, `DEVLOG-03`, `DEVLOG-04` walked Pass 24/11/2026: the probe 404 carried `X-Request-ID`, and its `django.request` `WARNING` line reached `code/src/logs/django.log` on the host                                    |
| HP-14  | The host line parses with `jq .` and carries the header's id  | Pass   | Manual — `DEVLOG-05`, `DEVLOG-06`, `DEVLOG-07` walked Pass 24/11/2026: one JSON object whose `request_id` equals DEVLOG-03's header, extras unreplaced; slot C's host-path reads ran as written (the walk also found F-008, Section 5) |
| HP-15  | The four doc gates                                            | Pass   | `docs-length`, `docs-pairing`, `doc-references`, `doctrine-drift` all exit 0 (23/11/2026 checklist run; re-run 24/11/2026 after these records, see the session report); `GATES-01` to `GATES-05` walked Pass 24/11/2026                |

### Error States

| ID    | Scenario (from plan)                                | Result                                   | Evidence                                                                                                                                                                                                                                      |
| ----- | --------------------------------------------------- | ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | Outside a request: `request_id` present and `null`  | Pass                                     | `obs` `test_outside_a_request_request_id_is_present_and_null`                                                                                                                                                                                 |
| ES-02 | `""` → `None`, never dropped                        | Pass                                     | `obs` `test_never_drops_a_record_and_maps_empty_to_none`                                                                                                                                                                                      |
| ES-03 | `base.py` has no `LOGGING`                          | Pass                                     | `set` `test_base_assigns_no_logging`                                                                                                                                                                                                          |
| ES-04 | Missing `django` entry fails, naming the env        | Pass                                     | `set` `test_the_check_fails_naming_the_env_when_the_django_logger_goes`                                                                                                                                                                       |
| ES-05 | Missing filter fails, naming env and handler        | Pass                                     | `set` `test_the_check_fails_naming_the_env_and_handler_without_the_filter`                                                                                                                                                                    |
| ES-06 | No `--access-logfile` in three entrypoints          | Pass                                     | Static — read 24/11/2026; `ENTRY-01` and `ENTRY-02` walked Pass 24/11/2026                                                                                                                                                                    |
| ES-07 | Dev stack not running at the walk                   | **Not arisen**                           | Manual — `DEVLOG-02` walked Pass 24/11/2026: `DEVLOG-01` found the stack already running and `server.sh up` printed its URL, so the not-running branch (unmeasured, never passed) was not exercised. The guard stands in DEVLOG-02's row text |
| ES-08 | `django.log` untracked and ignored                  | Pass                                     | Manual — `DEVLOG-08` walked Pass 24/11/2026: `!! code/src/logs/django.log`, ignored, never `??`. Static half: `git check-ignore` matches `code/src/logs/.gitignore:1`                                                                         |
| ES-09 | Claims narrowed to Django's `LOGGING`; the selector | Pass                                     | Static — `DJANGO-LOGGING.md`:156, `OBSERVABILITY.md`:101-106, 09 `STEPS.md`:117, entry 15                                                                                                                                                     |
| ES-10 | Entry 13 and the uvicorn source                     | Pass (static) / **Unmeasured** (runtime) | Static half read; runtime half — no script reads the test stack's output                                                                                                                                                                      |
| ES-11 | Uncorrelated cases named in two places              | Pass                                     | Static — `US014.md` Out of Scope; `DJANGO-LOGGING.md` _Uncorrelated records_. `DOCS-04` failed at the first walk (the story omitted the `X-Request-ID` clause, F-009) and was re-walked Pass at `2a849997` after the story was corrected      |

### Edge Cases

| ID     | Scenario (from plan)                                   | Result    | Evidence                                                                                                                                            |
| ------ | ------------------------------------------------------ | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01  | A forged `request_id` overwritten                      | Pass      | `obs` `test_a_forged_request_id_is_overwritten`                                                                                                     |
| EC-02  | Colliding extras never replace a fixed key             | Pass      | `obs` `test_a_colliding_extra_never_replaces_a_fixed_key`                                                                                           |
| EC-03  | Unserialisable extra is its `str()`                    | Pass      | `obs` `test_an_unserialisable_extra_is_its_str`                                                                                                     |
| EC-04  | Formatter without the filter still writes `request_id` | Pass      | `obs` `test_the_formatter_alone_still_writes_request_id`                                                                                            |
| EC-05  | Rejected inbound id never reaches the line             | Pass      | `req` `test_a_rejected_inbound_id_never_reaches_the_line`                                                                                           |
| EC-06  | Two overlapping requests keep their own ids            | Pass      | `req` `test_two_overlapping_requests_keep_their_own_ids` (`threading.Barrier`)                                                                      |
| EC-07  | After the request finishes: `null`                     | Pass      | `obs` `test_a_record_after_the_request_has_finished_is_null`                                                                                        |
| EC-08  | Cause and context type-only                            | Pass      | `obs` `test_an_explicit_cause_is_a_type_only_link`, `test_an_implicit_context_is_a_type_only_link`                                                  |
| EC-09  | A note is dropped                                      | Pass      | `obs` `test_a_note_is_dropped`, `test_an_explicit_cause_with_a_note_is_a_type_only_link`                                                            |
| EC-10  | Group members as type names                            | Pass      | `obs` `test_a_group_lists_member_types_only`                                                                                                        |
| EC-11  | `BadRequest` text in `message`, not `exc_info`         | Pass      | `req` `test_bad_request_text_reaches_message_and_not_exc_info`                                                                                      |
| EC-12  | Unserialisable payload takes the fallback              | Pass      | `obs` tuple-key, self-referencing and non-finite tests in both modes                                                                                |
| EC-13  | 64 KiB message; lone surrogate                         | Pass      | `lim` `test_a_64_kib_message_is_cut_and_keeps_its_start`; `obs` `test_a_lone_surrogate_is_escaped_and_not_cut`                                      |
| EC-14  | An `apps.x` INFO logger under staging                  | Pass      | `set` `test_an_undeclared_app_logger_inherits_warning`                                                                                              |
| EC-15  | `request` extra with no stored id → `null`             | Pass      | `obs` `test_a_request_extra_with_no_stored_id_is_null`                                                                                              |
| EC-16  | The stored id, never the raw header                    | Pass      | `mid` `test_stores_the_validated_or_minted_id_never_the_raw_header` (absent, rejected, well-formed)                                                 |
| EC-17  | The staging handler never raises (a) to (e)            | Pass      | `lim` `TestTheFormatterNeverRaises`; `set` `test_the_formatter_never_raises`, `test_bad_percent_args_log_the_bare_msg`; malformed `exc_info` matrix |
| EC-18  | `__context__` cycle terminates                         | Deviation | `obs` `test_a_context_cycle_terminates_with_each_exception_once` — passes; the back-edge is **omitted**, not `null` (Section 4)                     |
| EC-19  | 2000-link cause chain                                  | Pass      | `obs` `test_a_2000_link_cause_chain_is_walked_without_recursion_and_capped`                                                                         |
| EC-20  | `exc_info=(None, None, None)`                          | Pass      | `obs` `test_an_empty_exc_info_triple_writes_no_exc_info_key`                                                                                        |
| EC-21  | Streaming body is uncorrelated                         | Pass      | `req` `test_a_streamed_body_logged_after_the_view_is_null`                                                                                          |
| EC-21b | A view-started thread is uncorrelated (default build)  | Pass      | `req` `test_a_thread_the_view_starts_is_uncorrelated_on_the_default_build`                                                                          |
| EC-22  | Non-ASCII path escaped                                 | Pass      | `req` `test_a_non_ascii_path_is_logged_escaped`                                                                                                     |
| EC-23  | Pathological records capped, measured in bytes         | Pass      | `lim` `TestTheCap`; `obs` `test_a_line_just_under_the_cap_is_not_cut`; `set` `test_each_record_reaches_stdout_as_one_line`                          |

### Permission and Access

| ID  | Scenario (from plan) | Result | Evidence                                                                              |
| --- | -------------------- | ------ | ------------------------------------------------------------------------------------- |
| PA  | —                    | N/A    | No endpoint, view or role boundary (plan Section 2); the fixtures are mounted nowhere |

## 4. Deviations from plan

| Deviation                                                                                                                                                                                                                                             | Justification                                                                                                                                                                                                                                         |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Test layout (review L2).** The plan put every automated row bar EC-16 in one `test_observability.py`; it shipped as `test_observability.py` (569 lines), `_limits` (318), `_requests` (336), `_settings` (294) and `observability_support.py` (198) | 156 cases would breach the 750-line source limit in one module. Each module carries `pytestmark = pytest.mark.story("US014")`; EC-16 stays function-level in `test_middleware.py`. Scenario IDs unchanged. Findings F-005 carries the planning lesson |
| **EC-18's back-edge (review L3).** A `__context__` cycle's back-edge key is omitted rather than written `null`; the line carries no `truncated` flag                                                                                                  | AC-GAP-4's shape reads `null` as "no cause"; a cycle has one, so omission is the faithful reading. **Ruled 24/11/2026:** <%DEVELOPER_NAME%> chose option 1, omit — the deviation stands as the contract (findings F-003, plan Key Decision 20)        |
| **Strict JSON (review M1).** Non-finite floats are written as text, and every test parses with `NaN` / `Infinity` rejected                                                                                                                            | `NaN` is not JSON; LogQL's `\| json` would drop the line. Stricter than the plan; adds no key                                                                                                                                                         |

## 5. New edge cases discovered

| ID    | Scenario                                                         | Result | Evidence                                                                                                                                          | Fold back?                                       |
| ----- | ---------------------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| EC-24 | Non-finite float in an extra, nested, both modes (M1)            | Pass   | `obs` `test_a_non_finite_float_is_text_so_the_line_stays_json` (×2)                                                                               | Yes — a row of the next logging-touching QA plan |
| EC-25 | Returned 500, and a well-formed inbound id (M2)                  | Pass   | `req` `test_each_returned_error_and_id_source_under_*`                                                                                            | Yes — HP-08/HP-09 should have named the matrix   |
| EC-26 | Last resort builds a live line; unreadable fields fall back (L4) | Pass   | `lim` `test_a_record_that_defeats_even_the_fallback_writes_the_last_resort`, `test_the_last_resort_falls_back_to_constants_for_unreadable_fields` | No — implementation detail of EC-17              |
| EC-27 | Malformed `exc_info` (`True`, bare instance, 1-tuple) (L5)       | Pass   | `lim` `test_a_malformed_exc_info_is_no_exception_not_a_lost_line`                                                                                 | No — part of EC-17                               |
| EC-28 | An unknown formatter mode is a configuration error               | Pass   | `lim` `test_an_unknown_mode_is_a_configuration_error`                                                                                             | No                                               |

IDs EC-24 to EC-28 are assigned here, not in the frozen plan.

**The walk (24/11/2026) found no new edge case.** It found two documentation defects, routed as
findings and fixed in US014 at `2a849997`: **F-008**, the logs pair's `grep '"level":"ERROR"'`,
which the formatter's `"level": "ERROR"` spacing meant could never match (seen beside
`DEVLOG-07`), and **F-009**, the story's _Out of Scope_ bullet omitting that the response still
carries `X-Request-ID` (`DOCS-04`). Both are in
`../../20-FINDINGS/archive/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md`.

## 6. Deferred scenarios

| Scenario                    | Reason                                  | When to address                                      |
| --------------------------- | --------------------------------------- | ---------------------------------------------------- |
| ES-10 runtime half          | No script reads the test stack's output | Unmeasured by design (`code/docs/GATE-REPORTING.md`) |
| The collector and edge half | Realised in the deploy repository       | The deploy repository; untestable here               |

## 7. Accessibility observations

**N/A — no rendered screen or interactive component** (plan Section 3). No axe run applies.

## 8. GDPR & security observations

- **PII at rest** — no new field; the dev host file is gitignored and disposable (TM-17).
- **PII in output** — off dev the allowlist and the message-free `exc_info` hold (HP-04, HP-05,
  EC-11); **`message` is not scrubbed**, by decision, and the docs say so. Evidence:
  `../../14-LOGGING/IMPLEMENTATION/LOGGING-IMPL-US014-STRUCTURED-JSON-REQUEST-ID.md` Section 3.
- **Rights paths** — no per-subject log search; the Art. 11 position is carried, flagged for
  legal sign-off (`../../09-GDPR/IMPLEMENTATION/GDPR-IMPL-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md`).
- **Security gate** — no permission or IDOR surface; the fourteen constraints are closed in
  `../../10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md`.

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified — the EC-18 back-edge ruled 24/11/2026 (omit, option 1)
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build — N/A
- [x] GDPR & security observations confirmed
- [x] Coverage floors met for all modules in scope — `observability.py` 93.4% / 87.8%, `middleware.py` 100%
- [x] Manual testing sign-off (see `../../18-TESTS/MANUAL/US014-MANUAL-TESTING.md`) — walked 24/11/2026, Outcome Pass, 41 of 41 walked (CLOSE-04 retired); DOCS-04 and CLOSE-03 re-walked at `2a849997`; countersigned by Sam 24/11/2026
- [x] Reviewer approval — **blocks merge until complete** — Sam, 24/11/2026: his countersignature of all US014 work covers the workflow-22 records at `86823ad6`, this one among them (`../../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` → _Countersignature — 24/11/2026_), and he merged PR #44 at `94db8f02`. Ticked at `23-pr-and-review` Step 6; the code review record is `../../19-REVIEWS/REVIEW-US014-STRUCTURED-JSON-LOGGING.md`

---

## Cross-references

- `../PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the pre-development plan verified here
- `../../02-STORIES/US014.md` — the story under review
- `../../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US014-MANUAL-TESTING.md`
  — downstream test records
- `../../20-FINDINGS/archive/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` — the findings this review routes
- `../../19-REVIEWS/` — code-review notes from the same PR
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
