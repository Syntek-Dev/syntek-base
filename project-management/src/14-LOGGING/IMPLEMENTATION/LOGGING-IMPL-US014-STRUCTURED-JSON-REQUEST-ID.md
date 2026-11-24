---
story: "US014"
title: "Structured JSON logging with a request_id on every entry, queried by Compose service label"
status: "Verified"
version: "0.1.0"
created: "24/11/2026"
---

# Logging Record — US014: Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Field      | Value                                                                                                                                               |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**  | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                |
| **Date**   | 24/11/2026                                                                                                                                          |
| **Plan**   | `../PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md` (signed off 01/11/2026)                                                              |
| **Commit** | **None yet** — base `b1705408`, the build uncommitted on `us014/structured-json-logging`. The commit is the session's, after the documentation gate |
| **Status** | **Verified** — every planned row confirmed against the working tree; the exclusion check run and pasted (Section 3); developer sign-off owed        |

---

## 1. Planned events — verdict per row

**The story adds no event and names no logger** (plan Section 1); what it plans is the
configuration of loggers it never calls. Each planned row of Sections 1 and 2.3, against what
shipped:

| Logger / record class                                     | Environment         | Planned                                                               | Shipped                                                                     | Match? | Verdict / reason                                                   |
| --------------------------------------------------------- | ------------------- | --------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------ |
| root                                                      | dev                 | `DEBUG`, `console` + `file`                                           | `dev.py` · `"root": {"handlers": ["console", "file"], "level": "DEBUG"}`    | yes    | As planned; `test_dev_is_debug_with_its_django_loggers_unchanged`  |
| `django`                                                  | dev                 | `INFO`, `console` + `file`, `propagate: False`                        | `dev.py` · unchanged                                                        | yes    | As planned                                                         |
| `django.db.backends`                                      | dev                 | `WARNING`, `file` only                                                | `dev.py` · unchanged                                                        | yes    | As planned                                                         |
| root                                                      | test                | `WARNING`, console, no formatter                                      | `test.py` · console with the filter, no formatter                           | yes    | As planned; `test_test_keeps_one_console_with_no_formatter`        |
| `django`                                                  | test                | `WARNING`, no handlers (R2-Q2)                                        | `test.py` · `"django": {"handlers": [], "level": "WARNING"}`                | yes    | As planned                                                         |
| root                                                      | staging, prod       | `WARNING`, minimal JSON to `ext://sys.stdout`                         | `staging.py`, `production.py` · identical dicts                             | yes    | As planned; `test_staging_and_production_carry_one_identical_dict` |
| `django`                                                  | staging, prod       | `WARNING`, no handlers (Q8)                                           | `"django": {"handlers": [], "level": "WARNING"}`                            | yes    | As planned                                                         |
| Undeclared `apps.<app>` logger                            | staging, prod       | Inherits `WARNING`; `INFO` dropped                                    | Inherits root                                                               | yes    | `test_an_undeclared_app_logger_inherits_warning` (EC-14)           |
| `django.request` returned / raised 4xx                    | staging, prod       | One `WARNING` line each — **accepted volume** (2.3, R2-Q3)            | As planned; correlated through the stored id                                | yes    | Accepted, recorded here only, **no `GAPS.md` row** (R2-Q3)         |
| Process-server stream (`gunicorn.error`, `uvicorn.error`) | staging, prod       | Plain text on stderr, outside `LOGGING`; staging at `warning` (R3-Q4) | `entrypoint.staging.sh`:29, `entrypoint.prod.sh`:30 — `--log-level warning` | yes    | As planned; documented with the keeping selector                   |
| Process-server stream                                     | test                | Keeps `info` (not in the ruling)                                      | `entrypoint.test.sh`:26 · `--log-level info`                                | yes    | As planned                                                         |
| Gunicorn access log                                       | staging, prod, test | Not written (Q1)                                                      | `--access-logfile -` removed from all three                                 | yes    | As planned                                                         |
| uvicorn access log                                        | dev                 | Kept, plain text (R2-Q8)                                              | `entrypoint.dev.sh` unchanged                                               | yes    | As planned; every "dev is JSON" claim narrowed to Django's lines   |

**Field contract (plan 2.2), as shipped.** Five fixed keys — `timestamp` (UTC, millisecond),
`level`, `logger`, `message`, `request_id` (null outside a request) — plus `exc_info` when
present and `truncated` when cut; off dev only `duration_ms`, `status_code`, `method`
(`observability.py` · `LineFields`, `ALLOWLIST`). **One shape detail beyond the plan:** a
`__context__` cycle's back-edge key is omitted rather than written `null` (review L3; awaiting
<%DEVELOPER_NAME%>'s ruling — findings record F-003). A non-finite float is written as text
(review M1). Neither adds a key.

## 2. Unplanned events

| Event | Level | Fields | Why it was added                                                                                                                             | Should the plan have had it? |
| ----- | ----- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| None  | —     | —      | `observability.py` and `middleware.py` call no logger; `grep getLogger` over `apps/` and `config/` outside tests returns nothing (Section 3) | —                            |

---

## 3. Exclusion check — the evidence

**How the flows were exercised.** The excluded fields are excluded from **staging and
production stdout**, and no script in this repository runs a staging or production stack, so the
flows were exercised through the suite, which builds staging's own handler from its `LOGGING`
entry and formats real records, and real requests through `Client` / `AsyncClient` (QA plan
Section 6). Each test plants the excluded value and asserts it is absent from the written line.
The dev host file was then grepped for the two exclusions that also bind dev.

```text
$ bash code/src/scripts/tests/backend.sh --output "$PWD/code/src/scripts/tests/reports/us014-exclusion" -v -k "allowlist_and_drops or type_and_frames_with_no_message or note_is_dropped or group_lists_member_types or stack_info_and_a_cached or never_delegates or bad_request_text_reaches_message or rejected_inbound_id_never or one_json_line_on_stdout or bad_percent_args or identical_dict or undeclared_app_logger or extra_whose_str_raises"
[backend] Phase 1/2: unit tests…
collected 255 items / 240 deselected / 15 selected
====================== 15 passed, 240 deselected in 1.06s ======================
[backend] Phase 2/2: integration tests…
collected 255 items / 255 deselected / 0 selected
[backend] Phase 2/2: no tests collected — nothing matches -m integration yet.
exit=0
```

The fifteen cases, read from that run's `results-unit.xml` (0 failures):

```text
test_observability.TestMinimalExtras::test_keeps_the_allowlist_and_drops_everything_else
test_observability.TestMinimalExceptionShape::test_type_and_frames_with_no_message
test_observability.TestMinimalExceptionShape::test_never_delegates_to_the_stdlib_formatter
test_observability.TestMinimalExceptionShape::test_a_note_is_dropped
test_observability.TestMinimalExceptionShape::test_a_group_lists_member_types_only
test_observability.TestMinimalExceptionShape::test_stack_info_and_a_cached_exc_text_never_reach_the_line
test_observability_limits.TestTheFormatterNeverRaises::test_bad_percent_args_log_the_bare_msg
test_observability_limits.TestTheFormatterNeverRaises::test_an_extra_whose_str_raises_is_its_guarded_repr
test_observability_requests.TestReturnedErrorsTakeTheStoredId::test_a_rejected_inbound_id_never_reaches_the_line
test_observability_requests.TestTheMessageIsNotScrubbed::test_bad_request_text_reaches_message_and_not_exc_info
test_observability_settings.TestEveryEnvironmentsDict::test_staging_and_production_carry_one_identical_dict
test_observability_settings.TestEveryEnvironmentsDict::test_an_undeclared_app_logger_inherits_warning[staging]
test_observability_settings.TestEveryEnvironmentsDict::test_an_undeclared_app_logger_inherits_warning[production]
test_observability_settings.TestStagingConsoleUnderCapsys::test_one_json_line_on_stdout_and_nothing_on_stderr
test_observability_settings.TestStagingConsoleUnderCapsys::test_bad_percent_args_log_the_bare_msg
```

```text
$ grep -c '"logger": "django.db.backends"' code/src/logs/django.log
0
$ grep -c "a@example.com" code/src/logs/django.log
0
$ wc -l code/src/logs/django.log
169
$ git check-ignore -v code/src/logs/django.log   # output tab shown as spaces
code/src/logs/.gitignore:1:*.log    code/src/logs/django.log
```

The host file's 169 lines are 166 `django_components` and 3 `django.request` records, written by
the dev stack the gate run brought up on 23/11/2026; no line is quoted here.

| Excluded field (plan Section 4)                                  | Command run                                                                                                                                                                    | Result                                                                                    | Clean?          |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| Any extra outside the three (e.g. `email`)                       | `test_keeps_the_allowlist_and_drops_everything_else`                                                                                                                           | Key set exactly fixed five + three; `a@example.com` absent from the line                  | yes             |
| `django.request`'s `request` extra (query string)                | Same allowlist test; `TestTheMessageIsNotScrubbed`                                                                                                                             | Not in the allowlist, so never serialised off dev                                         | yes             |
| The exception message inside `exc_info`                          | `test_type_and_frames_with_no_message`; `test_bad_request_text_reaches_message_and_not_exc_info`                                                                               | `a@example.com` and "not found" absent; `exc_info` holds the type only                    | yes             |
| Source text, `f_locals`, PEP 678 notes, `stack_info`, `exc_text` | `test_a_note_is_dropped`, `test_a_group_lists_member_types_only`, `test_stack_info_and_a_cached_exc_text_never_reach_the_line`, `test_never_delegates_to_the_stdlib_formatter` | Absent; no stdlib delegation                                                              | yes             |
| SQL and its parameters (`django.db.backends`)                    | `grep -c` on the dev host file                                                                                                                                                 | `0` lines on the file in dev; off dev the logger is not raised above the `WARNING` root   | yes             |
| A raw client IP                                                  | —                                                                                                                                                                              | No code path in the story writes one; the dev uvicorn access line does, by ruling (R2-Q8) | yes, off dev    |
| Gunicorn access line (peer address, query string)                | Read of the three entrypoints                                                                                                                                                  | No `--access-logfile` in staging, production or test                                      | yes (static)    |
| A client-supplied `X-Request-ID`                                 | `test_a_rejected_inbound_id_never_reaches_the_line`                                                                                                                            | `bad id!` absent from the raw handler output; the minted id is on the line                | yes             |
| `getMessage()` arguments on a failure                            | `test_bad_percent_args_log_the_bare_msg` (both modules)                                                                                                                        | `message` is `str(record.msg)`; nothing on stderr                                         | yes             |
| The process-server exception message                             | —                                                                                                                                                                              | **Outside the claim, documented, not excluded** (plan Section 4, last row)                | n/a — by design |
| The test stack's `uvicorn.access` line at runtime                | —                                                                                                                                                                              | **Not run** — no script reads the test stack's output (`code/docs/GATE-REPORTING.md`)     | **unmeasured**  |

### Committed-code checks

- [x] No bare `print()` on any server path added by this story —
      `grep -nE "\bprint\(" code/src/django/apps/core/observability.py code/src/django/apps/core/middleware.py`
      exit 1, no match
- [x] No `console.*` in any JavaScript committed by this story —
      `git status --porcelain -- '*.js' '*.ts'` lists nothing; the story touches no script
- [x] Every log call uses the named logger from the plan's Section 1 — the plan names none and the
      story adds none: `grep -rn getLogger` over `apps/` and `config/`, tests excluded, exit 1
- [x] No `[enc]` field value reachable through an exception's `str()` at `ERROR` — the story has
      no `[enc]` field (plan Section 4)

---

## 4. Channels as shipped

| Channel                                     | Configured as planned? | Divergence / reason                                                                                                                                       |
| ------------------------------------------- | ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/logs/django.log` (dev, wide JSON) | yes                    | Bind mount `../logs:/workspace/code/src/logs` in `docker-compose.dev.yml`; the file exists on the host, root-owned (TM-17, accepted), gitignored          |
| Dev console                                 | yes                    | Django's lines wide JSON; uvicorn's plain text (R2-Q8)                                                                                                    |
| Test console                                | yes                    | `WARNING`, default format, nothing kept                                                                                                                   |
| Staging / production stdout → collector     | yes (app side)         | Minimal JSON; the collector half is **contract text** in `EDGE-REQUIREMENTS.md` entry 15                                                                  |
| Process-server stderr                       | yes                    | Plain text; documented with `{service_name="django"} \| json \| __error__!=""` in `DJANGO-LOGGING.md`, `OBSERVABILITY.md`, entry 15 and 09 `STEPS.md`:174 |
| Host `json-file` driver                     | yes (contract)         | `max-size` / `max-file` required by entry 15; values are the deploy repository's                                                                          |
| `mail_admins`                               | yes                    | Removed off dev by the handler-less `django` logger; `ADMINS` set nowhere                                                                                 |
| Sentry                                      | yes                    | Declared, not wired — unchanged                                                                                                                           |

### 4.1 Reference realisation re-read (plan 5.2) — Grafana Alloy **v1.22.0**

Re-read 24/11/2026, through `context7` (`/grafana/alloy/v1.22.0`, the newest version it lists;
the plan confirmed against v1.21 on 01/11/2026) and, where `context7` returned no exported-fields
text, the primary source itself through `scrapling`.

| Claim                                                                                                                                                               | Source, as read 24/11/2026                                                                                                                                                                                                                  | Holds?  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `discovery.docker` exports `__meta_docker_container_label_<labelname>`, dots and other non-alphanumerics sanitised to underscores                                   | `grafana/alloy` tag `v1.22.0`, `docs/sources/reference/components/discovery/discovery.docker.md` → _Exported fields_ and its note ("converts dots and other non-alphanumeric characters to underscores"), read through `scrapling` (tier 4) | yes     |
| `loki.source.docker` reads container logs through the daemon (`host`, `targets`) and accepts `relabel_rules` from `discovery.relabel`, which can set `service_name` | `context7` `/grafana/alloy/v1.22.0`, `docs/sources/monitor/monitor-docker-containers.md` (the `loki.source.docker` arguments and the `discovery.relabel` rule with `target_label = "service_name"`)                                         | yes     |
| So the rule `source_labels = ["__meta_docker_container_label_com_docker_compose_service"]`, `target_label = "service_name"` yields `{service_name="django"}`        | Follows from the two rows above; the Alloy example relabels from `__meta_docker_container_name` instead, which is the container-name selector the story removed                                                                             | yes     |
| Without the explicit relabel Loki derives `service_name` from its default list or `unknown_service`                                                                 | **Not re-read** — carried from the plan's reading of `grafana/loki` `docs/sources/get-started/labels/_index.md`. Recorded unmeasured for this record                                                                                        | carried |

**Could not look:** the deploy repository's Alloy and Loki versions — outside this tree.

---

## 5. Follow-ups

| Item                                                                                        | Routed to                                                           | Target                                        |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------- |
| The 4xx `WARNING` volume off dev                                                            | **Accepted here** (plan 2.3, R2-Q3) — deliberately no `GAPS.md` row | —                                             |
| The Prometheus scrape job's `-backend` / `service = "web"` label (`HEALTH-CONTRACT.md`:106) | `DEFERRED.md` (US014 section)                                       | The `/metrics/` wiring story — findings F-002 |
| The cycle back-edge: omit or `null`                                                         | `../../20-FINDINGS/` F-003                                          | <%DEVELOPER_NAME%>'s ruling before merge      |
| Wide mode drops `stack_info` in dev                                                         | `../../20-FINDINGS/` F-004                                          | <%DEVELOPER_NAME%>'s call                     |
| The test stack's runtime access-line check                                                  | Unmeasured, stated in the QA record (ES-10)                         | —                                             |

---

## Cross-references

- `../PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md` — the plan this closes
- `code/docs/LOGGING.md` · `code/docs/logging/DJANGO-LOGGING.md` — the governing standard and its staging/production section
- `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entry 15 — the collector contract
- `code/docs/GATE-REPORTING.md` — why an unrun check is never reported as a clean one
- `../../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` · `../../19-REVIEWS/` — the sibling records
