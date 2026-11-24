# US014 — Test Status

_The automated-test record for US014: what each automated check proves and whether it passed. Written at `22-implementation-documentation` Step 4 on 24/11/2026, on `us014/structured-json-logging` (base `b1705408`, the working tree carrying the uncommitted P1 to P5 build and its review fixes). US014's suite is pytest: four new modules under `code/src/django/apps/core/tests/unit/` — `test_observability.py`, `test_observability_limits.py`, `test_observability_requests.py` and `test_observability_settings.py`, each with module-level `pytestmark = pytest.mark.story("US014")` — plus `TestStoredIdentifier` in `test_middleware.py` under a function-level marker, and `code/src/django/tests/unit/test_story_map.py`, the regression tests for the story-map defect fixed under US014 (F-001 of the findings record; `../../21-BUGS/BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md`). Regenerated 24/11/2026 after that fix: the generated block now lists all 160._

**Last Updated**: 24/11/2026 · **Story**: US014 · **Status**: Green — 160 US014 test cases pass, listed by the generator

- **Story:** `../../02-STORIES/US014.md` — Structured JSON logging with a `request_id` on every entry, queried by Compose service label
- **Story plan:** `../../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the code master this record closes the loop on
- **Manual guide:** `../MANUAL/US014-MANUAL-TESTING.md` — authored at `17`, its build slots filled; **not yet walked** (a different tester's)
- **QA record:** `../../11-QA/IMPLEMENTATION/QA-IMPL-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` — scenario by scenario, with test names
- **Branch:** `us014/structured-json-logging`, cut from `dev` at `b1705408`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US014
```

**The block was empty until 24/11/2026, and why.** `code/src/django/conftest.py` used to
overwrite `reports/story-map.json` at the end of **every** pytest session, and the backend runners
run two — the unit phase, then the integration phase. Every US014 test is unit-tier, so the
integration session wiped the map to `[]` and the generator wrote 0 rows (F-001). The writer now
merges across sessions by `nodeid`, under
`../../21-BUGS/BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md`, so the block
lists the tests. It reads `reports/backend-coverage/results-unit.xml` (timestamp 24/11/2026
09:02:24 UTC, the run in Section 2): **160 US014 cases, 0 failures, 0 errors** of the file's
231 — the 156 the story wrote plus the bug's 4 regression tests.

The coverage figures in the block are whole-project backend figures from the same run, so they
measure US014's modules among others; `observability.py` (93.4% line, 87.8% branch) and
`middleware.py` (100%) are the two the story wrote. The auth-critical row is left as the
generator writes it: no module in the authentication, session or permission path is in scope
(`apps/users/` does not exist).

The floors are **one floor, not one per layer**. On `staging` and `main` the pre-PR gate raises
every floor to **80%**; `observability.py` clears it on both line and branch.

<!-- BEGIN GENERATED: test-record -->

### 1.1 Suite summary

| Suite      | Report artefact                     | Tests   | Result                | Coverage  |
| ---------- | ----------------------------------- | ------- | --------------------- | --------- |
| Unit       | `backend-coverage/results-unit.xml` | 160     | 160 Pass / 0 Fail     | 95.7%     |
| **Totals** |                                     | **160** | **160 Pass / 0 Fail** | **95.7%** |

### 1.2 Coverage vs floors

| Scope                       | Floor | This story                                       | Met? |
| --------------------------- | ----- | ------------------------------------------------ | ---- |
| All modules — line + branch | 75%   | 95.7% line / 88.5% branch                        | Yes  |
| Auth-critical modules       | 90%   | _{state the modules in scope and their figures}_ | _{}_ |

_The line floor above is read from `pyproject.toml`; the 90% auth floor is not machine-readable and is stated by `code/docs/testing/COVERAGE.md`, which owns both. The auth-critical row is not derivable either — which modules sit in the authentication, session and permission path is a judgement. Name them and read their figures from the per-module table below._

| Module                                           | Statements | Missed | Branch | Cover  |
| ------------------------------------------------ | ---------- | ------ | ------ | ------ |
| `code/src/django/apps/core/apps.py`              | 4          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/management/base.py`   | 17         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/middleware.py`        | 24         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/observability.py`     | 305        | 20     | 87.8%  | 93.4%  |
| `code/src/django/apps/core/schemas.py`           | 8          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/services/errors.py`   | 20         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/templatetags/core.py` | 7          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/apps.py`            | 3          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/checks.py`          | 51         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/urls.py`            | 5          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/views.py`           | 24         | 0      | 100.0% | 100.0% |

### 1.3 Tests by module

#### `code.src.django.apps.core.tests.unit.test_middleware`

##### `TestStoredIdentifier`

| What it checks                                                         | Why                                                                             | Test                                                                       | Result | Notes |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | ------ | ----- |
| Stores the validated or minted id never the raw header — absent        | EC-16 — the stored id equals the response header, inside the view and after it. | `test_stores_the_validated_or_minted_id_never_the_raw_header[absent]`      | Pass   |       |
| Stores the validated or minted id never the raw header — rejected      | EC-16 — the stored id equals the response header, inside the view and after it. | `test_stores_the_validated_or_minted_id_never_the_raw_header[rejected]`    | Pass   |       |
| Stores the validated or minted id never the raw header — well / formed | EC-16 — the stored id equals the response header, inside the view and after it. | `test_stores_the_validated_or_minted_id_never_the_raw_header[well-formed]` | Pass   |       |

#### `code.src.django.apps.core.tests.unit.test_observability`

##### `TestEveryLineIsOneJsonObject`

| What it checks                                                     | Why                                                     | Test                                                                     | Result | Notes |
| ------------------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------------------------------ | ------ | ----- |
| An empty exc info triple writes no exc info key — minimal          | EC-20 — `logger.exception()` outside an `except` block. | `test_an_empty_exc_info_triple_writes_no_exc_info_key[minimal]`          | Pass   |       |
| An empty exc info triple writes no exc info key — wide             | EC-20 — `logger.exception()` outside an `except` block. | `test_an_empty_exc_info_triple_writes_no_exc_info_key[wide]`             | Pass   |       |
| Quote backslash and newline round trip on one line — minimal       | HP-01.                                                  | `test_quote_backslash_and_newline_round_trip_on_one_line[minimal]`       | Pass   |       |
| Quote backslash and newline round trip on one line — wide          | HP-01.                                                  | `test_quote_backslash_and_newline_round_trip_on_one_line[wide]`          | Pass   |       |
| The key set is exactly the fixed five                              | HP-02.                                                  | `test_the_key_set_is_exactly_the_fixed_five`                             | Pass   |       |
| Timestamp is utc to the millisecond whatever tz — America/New_York | HP-03 — 1 700 000 000.5 is 14/11/2023 22:13:20.500 UTC. | `test_timestamp_is_utc_to_the_millisecond_whatever_tz[America/New_York]` | Pass   |       |
| Timestamp is utc to the millisecond whatever tz — Asia/Kolkata     | HP-03 — 1 700 000 000.5 is 14/11/2023 22:13:20.500 UTC. | `test_timestamp_is_utc_to_the_millisecond_whatever_tz[Asia/Kolkata]`     | Pass   |       |
| Timestamp is utc to the millisecond whatever tz — UTC              | HP-03 — 1 700 000 000.5 is 14/11/2023 22:13:20.500 UTC. | `test_timestamp_is_utc_to_the_millisecond_whatever_tz[UTC]`              | Pass   |       |

##### `TestMinimalExceptionShape`

| What it checks                                                 | Why                                                                                    | Test                                                                  | Result | Notes |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ------ | ----- |
| A 2000 link cause chain is walked without recursion and capped | EC-19 — about 100 KB uncapped; a cut link is omitted, never written `null`.            | `test_a_2000_link_cause_chain_is_walked_without_recursion_and_capped` | Pass   |       |
| A context cycle terminates with each exception once            | EC-18.                                                                                 | `test_a_context_cycle_terminates_with_each_exception_once`            | Pass   |       |
| A group lists member types only                                | EC-10.                                                                                 | `test_a_group_lists_member_types_only`                                | Pass   |       |
| A note is dropped                                              | EC-09.                                                                                 | `test_a_note_is_dropped`                                              | Pass   |       |
| An explicit cause is a type only link                          | EC-08 — `raise KeyError("k") from ValueError("user a@example.com")`.                   | `test_an_explicit_cause_is_a_type_only_link`                          | Pass   |       |
| An explicit cause with a note is a type only link              | Gherkin: ValueError raised from KeyError("a@example.com"), noted "user a@example.com". | `test_an_explicit_cause_with_a_note_is_a_type_only_link`              | Pass   |       |
| An implicit context is a type only link                        | EC-08, the `__context__` half.                                                         | `test_an_implicit_context_is_a_type_only_link`                        | Pass   |       |
| Never delegates to the stdlib formatter                        | Threat-model constraint 4 — neither `Formatter.format` nor `formatException`.          | `test_never_delegates_to_the_stdlib_formatter`                        | Pass   |       |
| Stack info and a cached exc text never reach the line          | AC — no `record.stack_info`, no cached `record.exc_text`, no source text.              | `test_stack_info_and_a_cached_exc_text_never_reach_the_line`          | Pass   |       |
| Type and frames with no message                                | HP-05.                                                                                 | `test_type_and_frames_with_no_message`                                | Pass   |       |

##### `TestMinimalExtras`

| What it checks                                            | Why                                                                               | Test                                                           | Result | Notes |
| --------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------------------------------------------- | ------ | ----- |
| A non finite float is text so the line stays json — / inf | EC-12 — `NaN`/`Infinity` are not JSON; LogQL's `\| json` would mark the line.     | `test_a_non_finite_float_is_text_so_the_line_stays_json[-inf]` | Pass   |       |
| A non finite float is text so the line stays json — inf   | EC-12 — `NaN`/`Infinity` are not JSON; LogQL's `\| json` would mark the line.     | `test_a_non_finite_float_is_text_so_the_line_stays_json[inf]`  | Pass   |       |
| A non finite float is text so the line stays json — nan   | EC-12 — `NaN`/`Infinity` are not JSON; LogQL's `\| json` would mark the line.     | `test_a_non_finite_float_is_text_so_the_line_stays_json[nan]`  | Pass   |       |
| A self referencing allowlisted value takes the fallback   | EC-12 — a circular reference defeats `json.dumps`; the value is its guarded text. | `test_a_self_referencing_allowlisted_value_takes_the_fallback` | Pass   |       |
| An unserialisable allowlisted value takes the fallback    | EC-12 — a tuple key defeats `default=str`; the allowlist still runs first.        | `test_an_unserialisable_allowlisted_value_takes_the_fallback`  | Pass   |       |
| Keeps the allowlist and drops everything else             | HP-04.                                                                            | `test_keeps_the_allowlist_and_drops_everything_else`           | Pass   |       |

##### `TestTheCap`

| What it checks                          | Why                                               | Test                                           | Result | Notes |
| --------------------------------------- | ------------------------------------------------- | ---------------------------------------------- | ------ | ----- |
| A line just under the cap is not cut    | EC-23, last record — the cap must not fire early. | `test_a_line_just_under_the_cap_is_not_cut`    | Pass   |       |
| A lone surrogate is escaped and not cut | EC-13.                                            | `test_a_lone_surrogate_is_escaped_and_not_cut` | Pass   |       |

##### `TestTheFilter`

| What it checks                                                             | Why                                                                                  | Test                                                                             | Result | Notes |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------- | ------ | ----- |
| A forged request id is overwritten                                         | EC-01 — inside a request the middleware's value; outside, null.                      | `test_a_forged_request_id_is_overwritten`                                        | Pass   |       |
| A record after the request has finished is null                            | EC-07 — the middleware's reset holds; nothing leaks onto the next unit of work.      | `test_a_record_after_the_request_has_finished_is_null`                           | Pass   |       |
| A request extra with no stored id is null — django.request                 | EC-15 — the DisallowedHost shape, raised before `RequestIDMiddleware` runs.          | `test_a_request_extra_with_no_stored_id_is_null[django.request]`                 | Pass   |       |
| A request extra with no stored id is null — django.security.DisallowedHost | EC-15 — the DisallowedHost shape, raised before `RequestIDMiddleware` runs.          | `test_a_request_extra_with_no_stored_id_is_null[django.security.DisallowedHost]` | Pass   |       |
| A returned error record takes the id stored on the request                 | Backend AC — logged after the middleware's `finally`, so only the stored id is left. | `test_a_returned_error_record_takes_the_id_stored_on_the_request`                | Pass   |       |
| Never drops a record and maps empty to none — django.request / 10          | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[django.request-10]`            | Pass   |       |
| Never drops a record and maps empty to none — django.request / 20          | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[django.request-20]`            | Pass   |       |
| Never drops a record and maps empty to none — django.request / 40          | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[django.request-40]`            | Pass   |       |
| Never drops a record and maps empty to none — django.request / 50          | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[django.request-50]`            | Pass   |       |
| Never drops a record and maps empty to none — root / 10                    | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[root-10]`                      | Pass   |       |
| Never drops a record and maps empty to none — root / 20                    | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[root-20]`                      | Pass   |       |
| Never drops a record and maps empty to none — root / 40                    | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[root-40]`                      | Pass   |       |
| Never drops a record and maps empty to none — root / 50                    | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[root-50]`                      | Pass   |       |
| Never drops a record and maps empty to none — us014.any / 10               | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[us014.any-10]`                 | Pass   |       |
| Never drops a record and maps empty to none — us014.any / 20               | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[us014.any-20]`                 | Pass   |       |
| Never drops a record and maps empty to none — us014.any / 40               | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[us014.any-40]`                 | Pass   |       |
| Never drops a record and maps empty to none — us014.any / 50               | ES-02 — `current_request_id()` is `""` outside a request.                            | `test_never_drops_a_record_and_maps_empty_to_none[us014.any-50]`                 | Pass   |       |
| Outside a request request id is present and null                           | ES-01.                                                                               | `test_outside_a_request_request_id_is_present_and_null`                          | Pass   |       |
| The formatter alone still writes request id                                | EC-04 — a handler built without the filter.                                          | `test_the_formatter_alone_still_writes_request_id`                               | Pass   |       |

##### `TestWideMode`

| What it checks                                                    | Why                                                                              | Test                                                                     | Result | Notes |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------ | ------ | ----- |
| A colliding extra never replaces a fixed key                      | EC-02.                                                                           | `test_a_colliding_extra_never_replaces_a_fixed_key`                      | Pass   |       |
| A non finite float is text so the line stays json — inf           | EC-12, wide half — nested too, since the fallback coerces the extra as a whole.  | `test_a_non_finite_float_is_text_so_the_line_stays_json[inf]`            | Pass   |       |
| A non finite float is text so the line stays json — nan           | EC-12, wide half — nested too, since the fallback coerces the extra as a whole.  | `test_a_non_finite_float_is_text_so_the_line_stays_json[nan]`            | Pass   |       |
| A self referencing extra takes the fallback and keeps every extra | EC-12, wide half — the circular value is its text; its neighbours are untouched. | `test_a_self_referencing_extra_takes_the_fallback_and_keeps_every_extra` | Pass   |       |
| A tuple keyed extra takes the fallback and keeps every extra      | EC-12, wide half.                                                                | `test_a_tuple_keyed_extra_takes_the_fallback_and_keeps_every_extra`      | Pass   |       |
| An unserialisable extra is its str                                | EC-03 — the request's repr, query string included.                               | `test_an_unserialisable_extra_is_its_str`                                | Pass   |       |
| Every extra is kept                                               | HP-06 against HP-04's record.                                                    | `test_every_extra_is_kept`                                               | Pass   |       |
| Exc info is the full traceback with its message                   | HP-06 against HP-05's record.                                                    | `test_exc_info_is_the_full_traceback_with_its_message`                   | Pass   |       |
| No reserved attribute leaks into an empty record                  | HP-06 — no `taskName`, `args`, `msg` or `created`.                               | `test_no_reserved_attribute_leaks_into_an_empty_record`                  | Pass   |       |

#### `code.src.django.apps.core.tests.unit.test_observability_limits`

##### `TestTheCap`

| What it checks                                                                        | Why                                                                               | Test                                                                                | Result | Notes |
| ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ------ | ----- |
| A 64 kib message is cut and keeps its start                                           | EC-13 — the message is cut, never replaced.                                       | `test_a_64_kib_message_is_cut_and_keeps_its_start`                                  | Pass   |       |
| A line at the cap is uncut and one byte over is cut                                   | The boundary is newline-inclusive: 16 383 bytes plus `\n` travels whole.          | `test_a_line_at_the_cap_is_uncut_and_one_byte_over_is_cut`                          | Pass   |       |
| A pathological logger name still fits                                                 | Every cuttable field gone and still over: the bounded last-resort shape.          | `test_a_pathological_logger_name_still_fits`                                        | Pass   |       |
| Each oversized record is capped and marked — 1000 / member / group                    | EC-23 — non-ASCII input expands into the escaped output, so the cap counts that.  | `test_each_oversized_record_is_capped_and_marked[1000-member-group]`                | Pass   |       |
| Each oversized record is capped and marked — 20000 / e / acute                        | EC-23 — non-ASCII input expands into the escaped output, so the cap counts that.  | `test_each_oversized_record_is_capped_and_marked[20000-e-acute]`                    | Pass   |       |
| Each oversized record is capped and marked — 20kib / method                           | EC-23 — non-ASCII input expands into the escaped output, so the cap counts that.  | `test_each_oversized_record_is_capped_and_marked[20kib-method]`                     | Pass   |       |
| Each oversized record is capped and marked — 5000 / emoji                             | EC-23 — non-ASCII input expands into the escaped output, so the cap counts that.  | `test_each_oversized_record_is_capped_and_marked[5000-emoji]`                       | Pass   |       |
| Each oversized record is capped and marked — 64kib / message                          | EC-23 — non-ASCII input expands into the escaped output, so the cap counts that.  | `test_each_oversized_record_is_capped_and_marked[64kib-message]`                    | Pass   |       |
| Each oversized record is capped and marked — fallback / tuple / keyed / status / code | EC-23 — non-ASCII input expands into the escaped output, so the cap counts that.  | `test_each_oversized_record_is_capped_and_marked[fallback-tuple-keyed-status-code]` | Pass   |       |
| Each oversized record is capped and marked — recursion / error                        | EC-23 — non-ASCII input expands into the escaped output, so the cap counts that.  | `test_each_oversized_record_is_capped_and_marked[recursion-error]`                  | Pass   |       |
| Each record reaches stdout as one line — 1000 / member / group                        | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[1000-member-group]`                    | Pass   |       |
| Each record reaches stdout as one line — 20000 / e / acute                            | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[20000-e-acute]`                        | Pass   |       |
| Each record reaches stdout as one line — 20kib / method                               | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[20kib-method]`                         | Pass   |       |
| Each record reaches stdout as one line — 5000 / emoji                                 | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[5000-emoji]`                           | Pass   |       |
| Each record reaches stdout as one line — 64kib / message                              | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[64kib-message]`                        | Pass   |       |
| Each record reaches stdout as one line — fallback / tuple / keyed / status / code     | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[fallback-tuple-keyed-status-code]`     | Pass   |       |
| Each record reaches stdout as one line — lone / surrogate                             | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[lone-surrogate]`                       | Pass   |       |
| Each record reaches stdout as one line — recursion / error                            | EC-13 and EC-23 through the handler — `.out` one line, `.err` empty.              | `test_each_record_reaches_stdout_as_one_line[recursion-error]`                      | Pass   |       |
| The last resort frame keeps the end of a long filename                                | The innermost frame survives the cut — and a path's meaning is at its end.        | `test_the_last_resort_frame_keeps_the_end_of_a_long_filename`                       | Pass   |       |
| The last resort shape keeps a full length request id                                  | The join survives the cut: an inbound id may be 200 characters (`middleware.py`). | `test_the_last_resort_shape_keeps_a_full_length_request_id`                         | Pass   |       |
| Wide mode is never capped                                                             | Dev's file never leaves the host; the cap is staging's and production's.          | `test_wide_mode_is_never_capped`                                                    | Pass   |       |

##### `TestTheFormatterNeverRaises`

| What it checks                                                               | Why                                                                               | Test                                                                          | Result | Notes |
| ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------ | ----- |
| A malformed exc info is no exception not a lost line — 1 / tuple / minimal   | A hand-built record's `exc_info` that is not a triple — `Logger._log` never makes | `test_a_malformed_exc_info_is_no_exception_not_a_lost_line[1-tuple-minimal]`  | Pass   |       |
| A malformed exc info is no exception not a lost line — 1 / tuple / wide      | A hand-built record's `exc_info` that is not a triple — `Logger._log` never makes | `test_a_malformed_exc_info_is_no_exception_not_a_lost_line[1-tuple-wide]`     | Pass   |       |
| A malformed exc info is no exception not a lost line — instance / minimal    | A hand-built record's `exc_info` that is not a triple — `Logger._log` never makes | `test_a_malformed_exc_info_is_no_exception_not_a_lost_line[instance-minimal]` | Pass   |       |
| A malformed exc info is no exception not a lost line — instance / wide       | A hand-built record's `exc_info` that is not a triple — `Logger._log` never makes | `test_a_malformed_exc_info_is_no_exception_not_a_lost_line[instance-wide]`    | Pass   |       |
| A malformed exc info is no exception not a lost line — true / minimal        | A hand-built record's `exc_info` that is not a triple — `Logger._log` never makes | `test_a_malformed_exc_info_is_no_exception_not_a_lost_line[true-minimal]`     | Pass   |       |
| A malformed exc info is no exception not a lost line — true / wide           | A hand-built record's `exc_info` that is not a triple — `Logger._log` never makes | `test_a_malformed_exc_info_is_no_exception_not_a_lost_line[true-wide]`        | Pass   |       |
| A msg nothing can print still yields a message                               | EC-17 (e) — the guard's fixed text, naming the type only.                         | `test_a_msg_nothing_can_print_still_yields_a_message`                         | Pass   |       |
| A record that defeats even the fallback writes the last resort               | The constant line: still one JSON object of the fixed keys.                       | `test_a_record_that_defeats_even_the_fallback_writes_the_last_resort`         | Pass   |       |
| A value nothing can print names at most its type                             | EC-17 (d) — still written when even naming the type raises.                       | `test_a_value_nothing_can_print_names_at_most_its_type`                       | Pass   |       |
| An extra whose str raises is its guarded repr                                | EC-17 (b) — coerced in place through the guard's `repr` step, still allowlisted.  | `test_an_extra_whose_str_raises_is_its_guarded_repr`                          | Pass   |       |
| An unknown mode is a configuration error                                     | Raised at construction — dictConfig fails at boot, never on a request.            | `test_an_unknown_mode_is_a_configuration_error`                               | Pass   |       |
| Bad percent args log the bare msg                                            | EC-17 (a) — `str(record.msg)` without its arguments.                              | `test_bad_percent_args_log_the_bare_msg`                                      | Pass   |       |
| One line with the ruled key set — a / bad / percent / args                   | The fixed five plus the kept extras — no `format_error` or other marker key.      | `test_one_line_with_the_ruled_key_set[a-bad-percent-args]`                    | Pass   |       |
| One line with the ruled key set — b / extra / str / raises                   | The fixed five plus the kept extras — no `format_error` or other marker key.      | `test_one_line_with_the_ruled_key_set[b-extra-str-raises]`                    | Pass   |       |
| One line with the ruled key set — c / exception / outside / except           | The fixed five plus the kept extras — no `format_error` or other marker key.      | `test_one_line_with_the_ruled_key_set[c-exception-outside-except]`            | Pass   |       |
| One line with the ruled key set — d / str / repr / and / type / name / raise | The fixed five plus the kept extras — no `format_error` or other marker key.      | `test_one_line_with_the_ruled_key_set[d-str-repr-and-type-name-raise]`        | Pass   |       |
| One line with the ruled key set — e / msg / str / raises                     | The fixed five plus the kept extras — no `format_error` or other marker key.      | `test_one_line_with_the_ruled_key_set[e-msg-str-raises]`                      | Pass   |       |
| The last resort falls back to constants for unreadable fields                | A record whose level, name and id are not text still yields the fixed five.       | `test_the_last_resort_falls_back_to_constants_for_unreadable_fields`          | Pass   |       |

#### `code.src.django.apps.core.tests.unit.test_observability_requests`

##### `TestCorrelatedInsideTheChain`

| What it checks                                | Why                                                                    | Test                                                 | Result | Notes |
| --------------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------- | ------ | ----- |
| A raised permission denied is correlated      | HP-10, `Client` — logged by `response_for_exception` inside the chain. | `test_a_raised_permission_denied_is_correlated`      | Pass   |       |
| A raised permission denied under async client | HP-10, `AsyncClient`.                                                  | `test_a_raised_permission_denied_under_async_client` | Pass   |       |
| A sync view line carries the minted id        | HP-07, `Client`.                                                       | `test_a_sync_view_line_carries_the_minted_id`        | Pass   |       |
| Async client — async / view                   | HP-07 through `AsyncClient`; HP-07b for an `async def` view.           | `test_async_client[async-view]`                      | Pass   |       |
| Async client — sync / view                    | HP-07 through `AsyncClient`; HP-07b for an `async def` view.           | `test_async_client[sync-view]`                       | Pass   |       |

##### `TestReturnedErrorsTakeTheStoredId`

| What it checks                                                                  | Why                                                                      | Test                                                                              | Result | Notes |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------ | --------------------------------------------------------------------------------- | ------ | ----- |
| A non ascii path is logged escaped                                              | EC-22 — Django escapes the path argument, and the line is ASCII.         | `test_a_non_ascii_path_is_logged_escaped`                                         | Pass   |       |
| A rejected inbound id never reaches the line                                    | EC-05 — the filter never falls back to `request.META`.                   | `test_a_rejected_inbound_id_never_reaches_the_line`                               | Pass   |       |
| A returned 400 carries the id                                                   | HP-08.                                                                   | `test_a_returned_400_carries_the_id`                                              | Pass   |       |
| A returned 400 under async client                                               | HP-09 — the path production runs, `get_response_async`.                  | `test_a_returned_400_under_async_client`                                          | Pass   |       |
| Each returned error and id source under async client — returned / 400 / inbound | HP-09 — the same matrix through `AsyncClient`, the path production runs. | `test_each_returned_error_and_id_source_under_async_client[returned-400-inbound]` | Pass   |       |
| Each returned error and id source under async client — returned / 400 / minted  | HP-09 — the same matrix through `AsyncClient`, the path production runs. | `test_each_returned_error_and_id_source_under_async_client[returned-400-minted]`  | Pass   |       |
| Each returned error and id source under async client — returned / 500 / inbound | HP-09 — the same matrix through `AsyncClient`, the path production runs. | `test_each_returned_error_and_id_source_under_async_client[returned-500-inbound]` | Pass   |       |
| Each returned error and id source under async client — returned / 500 / minted  | HP-09 — the same matrix through `AsyncClient`, the path production runs. | `test_each_returned_error_and_id_source_under_async_client[returned-500-minted]`  | Pass   |       |
| Each returned error and id source under client — returned / 400 / inbound       | HP-08 — 4xx and 5xx, minted and well-formed inbound, through `Client`.   | `test_each_returned_error_and_id_source_under_client[returned-400-inbound]`       | Pass   |       |
| Each returned error and id source under client — returned / 400 / minted        | HP-08 — 4xx and 5xx, minted and well-formed inbound, through `Client`.   | `test_each_returned_error_and_id_source_under_client[returned-400-minted]`        | Pass   |       |
| Each returned error and id source under client — returned / 500 / inbound       | HP-08 — 4xx and 5xx, minted and well-formed inbound, through `Client`.   | `test_each_returned_error_and_id_source_under_client[returned-500-inbound]`       | Pass   |       |
| Each returned error and id source under client — returned / 500 / minted        | HP-08 — 4xx and 5xx, minted and well-formed inbound, through `Client`.   | `test_each_returned_error_and_id_source_under_client[returned-500-minted]`        | Pass   |       |

##### `TestTheMessageIsNotScrubbed`

| What it checks                                    | Why | Test                                                     | Result | Notes |
| ------------------------------------------------- | --- | -------------------------------------------------------- | ------ | ----- |
| Bad request text reaches message and not exc info |     | `test_bad_request_text_reaches_message_and_not_exc_info` | Pass   |       |

##### `TestUncorrelatedOutsideTheExtent`

| What it checks                                                | Why                                                                               | Test                                                                 | Result | Notes |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ------ | ----- |
| A streamed body logged after the view is null                 | EC-21 — the generator runs after the middleware's `finally`, as on a real server. | `test_a_streamed_body_logged_after_the_view_is_null`                 | Pass   |       |
| A thread the view starts is uncorrelated on the default build | EC-21b — read the build's flag rather than assume it.                             | `test_a_thread_the_view_starts_is_uncorrelated_on_the_default_build` | Pass   |       |
| Two overlapping requests keep their own ids                   | EC-06 — threads behind a barrier: gathered `AsyncClient` calls never overlap.     | `test_two_overlapping_requests_keep_their_own_ids`                   | Pass   |       |

#### `code.src.django.apps.core.tests.unit.test_observability_settings`

##### `TestEveryEntryBuilds`

| What it checks                                                       | Why                                                                               | Test                                                                       | Result | Notes |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | ------ | ----- |
| Each entry builds and maps to the observability classes — dev        |                                                                                   | `test_each_entry_builds_and_maps_to_the_observability_classes[dev]`        | Pass   |       |
| Each entry builds and maps to the observability classes — production |                                                                                   | `test_each_entry_builds_and_maps_to_the_observability_classes[production]` | Pass   |       |
| Each entry builds and maps to the observability classes — staging    |                                                                                   | `test_each_entry_builds_and_maps_to_the_observability_classes[staging]`    | Pass   |       |
| Each entry builds and maps to the observability classes — test       |                                                                                   | `test_each_entry_builds_and_maps_to_the_observability_classes[test]`       | Pass   |       |
| Each environment selects its line shape — dev / True                 | Backend AC — the extras and exception shape are chosen by the environment's dict. | `test_each_environment_selects_its_line_shape[dev-True]`                   | Pass   |       |
| Each environment selects its line shape — production / False         | Backend AC — the extras and exception shape are chosen by the environment's dict. | `test_each_environment_selects_its_line_shape[production-False]`           | Pass   |       |
| Each environment selects its line shape — staging / False            | Backend AC — the extras and exception shape are chosen by the environment's dict. | `test_each_environment_selects_its_line_shape[staging-False]`              | Pass   |       |

##### `TestEveryEnvironmentsDict`

| What it checks                                                             | Why                                                                         | Test                                                                             | Result | Notes |
| -------------------------------------------------------------------------- | --------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | ------ | ----- |
| An undeclared app logger inherits warning — production                     | EC-14 — a project's INFO logger joins only once it is declared.             | `test_an_undeclared_app_logger_inherits_warning[production]`                     | Pass   |       |
| An undeclared app logger inherits warning — staging                        | EC-14 — a project's INFO logger joins only once it is declared.             | `test_an_undeclared_app_logger_inherits_warning[staging]`                        | Pass   |       |
| Base assigns no logging                                                    | ES-03.                                                                      | `test_base_assigns_no_logging`                                                   | Pass   |       |
| Dev is debug with its django loggers unchanged                             | HP-11 — root DEBUG; `django` INFO; `django.db.backends` WARNING, file only. | `test_dev_is_debug_with_its_django_loggers_unchanged`                            | Pass   |       |
| Every handler carries the filter — dev                                     | HP-11 — and off dev the `django` logger holds no handler of its own.        | `test_every_handler_carries_the_filter[dev]`                                     | Pass   |       |
| Every handler carries the filter — production                              | HP-11 — and off dev the `django` logger holds no handler of its own.        | `test_every_handler_carries_the_filter[production]`                              | Pass   |       |
| Every handler carries the filter — staging                                 | HP-11 — and off dev the `django` logger holds no handler of its own.        | `test_every_handler_carries_the_filter[staging]`                                 | Pass   |       |
| Every handler carries the filter — test                                    | HP-11 — and off dev the `django` logger holds no handler of its own.        | `test_every_handler_carries_the_filter[test]`                                    | Pass   |       |
| Staging and production carry one identical dict                            | HP-11 — two hand-maintained copies that cannot drift.                       | `test_staging_and_production_carry_one_identical_dict`                           | Pass   |       |
| Test keeps one console with no formatter                                   | Gherkin — the filter rides along only for the every-handler invariant.      | `test_test_keeps_one_console_with_no_formatter`                                  | Pass   |       |
| The check fails naming the env and handler without the filter — dev        | ES-05.                                                                      | `test_the_check_fails_naming_the_env_and_handler_without_the_filter[dev]`        | Pass   |       |
| The check fails naming the env and handler without the filter — production | ES-05.                                                                      | `test_the_check_fails_naming_the_env_and_handler_without_the_filter[production]` | Pass   |       |
| The check fails naming the env and handler without the filter — staging    | ES-05.                                                                      | `test_the_check_fails_naming_the_env_and_handler_without_the_filter[staging]`    | Pass   |       |
| The check fails naming the env and handler without the filter — test       | ES-05.                                                                      | `test_the_check_fails_naming_the_env_and_handler_without_the_filter[test]`       | Pass   |       |
| The check fails naming the env when the django logger goes — production    | ES-04.                                                                      | `test_the_check_fails_naming_the_env_when_the_django_logger_goes[production]`    | Pass   |       |
| The check fails naming the env when the django logger goes — staging       | ES-04.                                                                      | `test_the_check_fails_naming_the_env_when_the_django_logger_goes[staging]`       | Pass   |       |
| The check fails naming the env when the django logger goes — test          | ES-04.                                                                      | `test_the_check_fails_naming_the_env_when_the_django_logger_goes[test]`          | Pass   |       |

##### `TestStagingConsoleUnderCapsys`

| What it checks                                                                    | Why                                                                         | Test                                                                            | Result | Notes |
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------ | ----- |
| Bad percent args log the bare msg                                                 | EC-17 (a) — `str(record.msg)` without its arguments.                        | `test_bad_percent_args_log_the_bare_msg`                                        | Pass   |       |
| Each record reaches stdout as one line — 1000 / member / group                    | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[1000-member-group]`                | Pass   |       |
| Each record reaches stdout as one line — 20000 / e / acute                        | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[20000-e-acute]`                    | Pass   |       |
| Each record reaches stdout as one line — 20kib / method                           | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[20kib-method]`                     | Pass   |       |
| Each record reaches stdout as one line — 5000 / emoji                             | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[5000-emoji]`                       | Pass   |       |
| Each record reaches stdout as one line — 64kib / message                          | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[64kib-message]`                    | Pass   |       |
| Each record reaches stdout as one line — fallback / tuple / keyed / status / code | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[fallback-tuple-keyed-status-code]` | Pass   |       |
| Each record reaches stdout as one line — lone / surrogate                         | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[lone-surrogate]`                   | Pass   |       |
| Each record reaches stdout as one line — recursion / error                        | EC-13 and EC-23, through the handler.                                       | `test_each_record_reaches_stdout_as_one_line[recursion-error]`                  | Pass   |       |
| One json line on stdout and nothing on stderr                                     | HP-12.                                                                      | `test_one_json_line_on_stdout_and_nothing_on_stderr`                            | Pass   |       |
| The formatter never raises — a / bad / percent / args                             | EC-17 — the fallback writes the fixed five plus kept extras, no marker key. | `test_the_formatter_never_raises[a-bad-percent-args]`                           | Pass   |       |
| The formatter never raises — b / extra / str / raises                             | EC-17 — the fallback writes the fixed five plus kept extras, no marker key. | `test_the_formatter_never_raises[b-extra-str-raises]`                           | Pass   |       |
| The formatter never raises — c / exception / outside / except                     | EC-17 — the fallback writes the fixed five plus kept extras, no marker key. | `test_the_formatter_never_raises[c-exception-outside-except]`                   | Pass   |       |
| The formatter never raises — d / str / repr / and / type / name / raise           | EC-17 — the fallback writes the fixed five plus kept extras, no marker key. | `test_the_formatter_never_raises[d-str-repr-and-type-name-raise]`               | Pass   |       |
| The formatter never raises — e / msg / str / raises                               | EC-17 — the fallback writes the fixed five plus kept extras, no marker key. | `test_the_formatter_never_raises[e-msg-str-raises]`                             | Pass   |       |

#### `code.src.django.tests.unit.test_story_map`

| What it checks                                                 | Why                                                                                     | Test                                                                  | Result | Notes |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ------ | ----- |
| A later session keeps an earlier sessions story entries        | A unit phase's marked test survives an integration phase that selects none.             | `test_a_later_session_keeps_an_earlier_sessions_story_entries`        | Pass   |       |
| A rerun test replaces its own entry rather than duplicating it | The same node id written twice is one entry, carrying the latest markers.               | `test_a_rerun_test_replaces_its_own_entry_rather_than_duplicating_it` | Pass   |       |
| A test that loses its marker leaves the map                    | A session is authoritative for the tests it ran: an unmarked rerun drops the old entry. | `test_a_test_that_loses_its_marker_leaves_the_map`                    | Pass   |       |
| An unreadable previous map is replaced not fatal               | A corrupt map from an interrupted run never fails the next session; it is rewritten.    | `test_an_unreadable_previous_map_is_replaced_not_fatal`               | Pass   |       |

<!-- END GENERATED -->

---

## 2. How to reproduce

Run the suites through the project scripts only — never `pytest`, `manage.py`, `bru` or
`playwright` directly. The run this record reads, started for it on 24/11/2026:

| Command                                            | Exit | Summary line                                                                                                                                                                                                                                            |
| -------------------------------------------------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bash code/src/scripts/tests/all.sh --coverage`    | 0    | unit "231 passed, 28 deselected in 21.57s"; integration "22 passed, 237 deselected in 1.65s"; "Required test coverage of 75% reached. Total coverage: 94.50%"; mobile 16 of 16; "all.sh — all suites passed." Auth check skipped — `apps/users/` absent |
| `bash code/src/scripts/tests/test-record.sh US014` | 0    | "wrote 160 test rows"                                                                                                                                                                                                                                   |
| `bash code/src/scripts/audits/story-markers.sh`    | 0    | "93 carry a story marker; 72 do not" (warn-only). No US014 module is in the unmarked list; the unmarked tests predate the convention                                                                                                                    |

To run only US014's modules: `bash code/src/scripts/tests/backend.sh -k "observability or middleware or story_map"`.
No seed data, no management command and no running dev stack is needed — every test is unit-tier,
opens no database connection, and builds handlers from the environments' own `LOGGING` entries
without `dictConfig` (QA plan Section 6).

---

## 3. Outstanding gaps and flaky tests

| Item                                                                | Type                   | Reason / owner                                                                                                                                                                                                            |
| ------------------------------------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The test layout differs from QA plan Section 2                      | Deviation              | The plan put every automated row bar EC-16 in one `test_observability.py`; it shipped as four modules plus a support module (`observability_support.py`) to stay inside 750 lines. Review finding L2; QA record Section 4 |
| HP-13, HP-14, ES-07, ES-08 and the dev host write                   | Manual — not automated | The dev-stack DEVLOG journey; the manual guide's walk, by a tester other than the author                                                                                                                                  |
| ES-10's runtime half (no `uvicorn.access` line from the test stack) | Unmeasured by design   | No script reads the test stack's output (`code/docs/GATE-REPORTING.md`); the static half is read at review                                                                                                                |
| Browser e2e, accessibility, Bruno API                               | Out of scope           | No page, component or `/api/*` endpoint (QA plan Sections 3 and 4)                                                                                                                                                        |
| `observability.py` uncovered lines                                  | Coverage below 100%    | 93.4% line / 87.8% branch — above both the 75% floor and the 80% pre-PR gate; the misses are innermost guards in the never-raise fallback                                                                                 |
| Flaky tests                                                         | None observed          | Three full runs green on 23 and 24/11/2026; EC-06 uses a `threading.Barrier`, not timing                                                                                                                                  |

**Unmarked tests are invisible here.** Every US014 module carries the marker, and all of them
are in the table.

---

## 4. Status line

**Green** — 160 US014 test cases (of 231 unit, 22 integration), 0 failures, all listed by the
generator; total backend coverage 94.50%, `observability.py` 93.4% line / 87.8% branch, all floors
met · verified 24/11/2026.

---

## Cross-references

- `../../02-STORIES/US014.md` — the story under test
- `../../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the implementation plan this record closes
- `../MANUAL/US014-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; a manual `Fail` beside a green suite is a missing test
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` — whether the specified scenarios were met
- `../../20-FINDINGS/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` — F-001, the story-map overwrite
- `../../21-BUGS/BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md` — its bug record and fix
- `../../21-BUGS/BUG-US014-TEST-RECORD-ESCAPED-PIPE-SPLITS-CELL-24-11-2026.md` — the generator defect that broke this block's lint on regeneration, fixed the same day
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
