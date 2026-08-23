---
story: "{US###}"
title: "{STORY TITLE}"
status: "{Draft | Reviewed | Signed off}"
version: "{0.1.0}"
created: "{DD/MM/YYYY}"
---

# Logging Plan — {US###}: {STORY TITLE}

_Template — copy to `LOGGING-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]` row and
`{PLACEHOLDER}` with this story's own plan, and delete this note once populated. This is the
**pre-implementation** log surface for a single story; its post-implementation counterpart is
`../IMPLEMENTATION/LOGGING-IMPL-US000-TEMPLATE.md`._

| Field            | Value                                                        |
| ---------------- | ------------------------------------------------------------ |
| **Story**        | US### — {short title}                                        |
| **Date**         | {DD/MM/YYYY}                                                 |
| **Sprint**       | SPRINT-## — {sprint name}                                    |
| **Logging flag** | {event shortlist from the story's FLAGS table} — or `N/A`    |
| **Upstream**     | API design `{API-PLAN-US###-…}` · schema `{DB-IDEA-US###-…}` |
| **Status**       | Draft / Reviewed / Signed off                                |

> If **Logging flag = N/A** the story emits nothing new — record the reason in the story's flag
> row and do not create this file. Reaching this template means the story logs something.

---

## 1. Loggers

One row per module that logs. The name is always `logging.getLogger("apps.<app-name>")` —
never the root logger, never `print()`, never a bare `console.log()` in committed JavaScript.

| Module                             | Logger name  | Why it logs                    |
| ---------------------------------- | ------------ | ------------------------------ |
| [EXAMPLE] `apps/{app}/services.py` | `apps.{app}` | [EXAMPLE] {business decisions} |
| [EXAMPLE] `apps/{app}/api.py`      | `apps.{app}` | [EXAMPLE] {request outcomes}   |

---

## 2. Events

One row per logged event. **The field list is exhaustive** — a field not named here does not
appear in the line. Levels follow `code/docs/LOGGING.md`.

| Event                          | Level     | Trigger                       | Fields carried                    |
| ------------------------------ | --------- | ----------------------------- | --------------------------------- |
| [EXAMPLE] `{operation}.start`  | `DEBUG`   | Entry to `{service_function}` | `{entity}_id`, `action`           |
| [EXAMPLE] `{operation}.ok`     | `INFO`    | Successful completion         | `{entity}_id`, `duration_ms`      |
| [EXAMPLE] `{operation}.denied` | `WARNING` | Permission check fails        | `actor_id`, `target_id`, `action` |
| [EXAMPLE] `{operation}.failed` | `ERROR`   | Unhandled exception           | exception type, operation name    |

**Level discipline.** `DEBUG` is for development only and is off outside local. `WARNING` means
a human may need to look. `ERROR` means one definitely does — if nobody would act on it, it is
`WARNING`.

---

## 3. Safe fields

The allowlist. Anything not here needs a reason in Section 4 or it does not go in a log line.

| Field class   | Permitted                             | Never                                   |
| ------------- | ------------------------------------- | --------------------------------------- |
| Identifiers   | `{entity}_id`, `actor_id`, `trace_id` | Any natural key that is itself personal |
| Enumerations  | `action`, `status`, `reason_code`     | Free-text user input                    |
| Measurements  | `duration_ms`, `row_count`            | —                                       |
| [EXAMPLE] {…} | [EXAMPLE] {…}                         | [EXAMPLE] {…}                           |

---

## 4. Exclusions — what must never appear

Every field marked `[enc]` in this story's schema design, plus every PII attribute from its GDPR
plan. **Name the field and the surface**, so the check in `../IMPLEMENTATION/` is runnable.

| Field                       | Source                    | Excluded from                            |
| --------------------------- | ------------------------- | ---------------------------------------- |
| [EXAMPLE] `{email}` `[enc]` | `DB-IDEA-US###-…` §Tables | All log channels, and Sentry breadcrumbs |
| [EXAMPLE] `{full_name}`     | `GDPR-PLAN-US###-…`       | All log channels                         |

**Stack traces count.** An exception whose `str()` interpolates a personal value leaks it at
`ERROR`. Where that is possible, say which exception and how it is caught and re-raised.

---

## 5. Channels and retention

| Channel                    | Holds                | Retention     | Who can read it |
| -------------------------- | -------------------- | ------------- | --------------- |
| `code/src/logs/django.log` | [EXAMPLE] all levels | [EXAMPLE] {…} | [EXAMPLE] {…}   |
| Error tracking (Sentry)    | [EXAMPLE] `ERROR`    | [EXAMPLE] {…} | [EXAMPLE] {…}   |

Retention is a **business and legal decision**, not a logging one — if it is unset, say so and
raise it in the story's GDPR plan rather than inventing a number here.

---

## 6. Open questions

| ID          | Question      | Blocks | Resolution |
| ----------- | ------------- | ------ | ---------- |
| `LOG-GAP-1` | [PLACEHOLDER] | [OPEN] | —          |

Every `[OPEN]` gap is resolved — into this plan, or back into `US###.md` — before the story
clears `15-decisions`.

---

## Cross-references

- `code/docs/LOGGING.md` — the governing standard
- `code/docs/security/AUDIT-TRAIL.md` — the audit record, which is not a log line
- `../IMPLEMENTATION/LOGGING-IMPL-US000-TEMPLATE.md` — the record that closes this plan
