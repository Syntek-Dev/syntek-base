---
type: guide
skills: [logging, stack-django]
model: opus
---

# Logging, Observability & Media — Reference Guide

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Structured logging, error tracking, metrics, and Cloudinary media storage

Logging configuration, observability tooling, and media storage patterns for the Django-served
stack (Django + Django Ninja + templates/HTMX/Alpine). Covers structured
logging, error tracking, log aggregation, metrics, distributed tracing, and Cloudinary file
storage. There is no Node/Next server — server logging is Django-only, and browser errors reach
the error tracker rather than the log pipeline.

## Sub-documents

| Document                                                     | Covers                                                                                                                                                                                                                                                      |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`logging/DJANGO-LOGGING.md`](logging/DJANGO-LOGGING.md)     | Django `LOGGING` config (dev/test and staging/prod), Django Ninja request/exception logging, log levels, logger-not-print rule, never-log-raw-IP rule                                                                                                       |
| [`logging/FRONTEND-LOGGING.md`](logging/FRONTEND-LOGGING.md) | Browser logging via the Sentry browser SDK + a small project logger, dev vs prod behaviour, the no-`console` rule                                                                                                                                           |
| [`logging/OBSERVABILITY.md`](logging/OBSERVABILITY.md)       | The four observability interfaces and the default behind each — error tracking (Django + browser), log aggregation (pipeline, queries, retention), metrics and dashboards (Django `/metrics/`), distributed tracing (OTLP — seam adopted, backend deferred) |
| [`logging/HEALTH-CONTRACT.md`](logging/HEALTH-CONTRACT.md)   | Health/metrics endpoints the app exposes and what the NixOS deploy repo must provision (uptime probe, metrics scrape)                                                                                                                                       |
| [`logging/CLOUDINARY.md`](logging/CLOUDINARY.md)             | Cloudinary media storage configuration, required env vars summary                                                                                                                                                                                           |

## Stack by environment

**Capability first, product second** — the left column is what the code is written against, the
next is this project's answer. Swapping an answer is configuration
([`architecture/PROVIDER-NEUTRALITY.md`](architecture/PROVIDER-NEUTRALITY.md); register:
[`how-to/src/PLATFORM-PROVIDERS.md`](../../how-to/src/PLATFORM-PROVIDERS.md)).

| Capability             | This project            | Layer   | dev | test | staging | prod | Notes                                        |
| ---------------------- | ----------------------- | ------- | --- | ---- | ------- | ---- | -------------------------------------------- |
| File logging           | Django `FileHandler`    | Backend | ✅  | ✅   | ❌      | ❌   | `code/src/logs/django.log` — local artefacts |
| Error tracking         | <%ERROR_TRACKING%>      | Both    | ❌  | ❌   | ✅      | ✅   | Django + browser, via the Sentry SDK         |
| Log shipping           | Alloy                   | Infra   | ❌  | ❌   | ✅      | ✅   | Server host → the log store; no app config   |
| Log aggregation        | <%LOG_AGGREGATOR%>      | Infra   | ❌  | ❌   | ✅      | ✅   | Reads structured JSON on stdout              |
| Metrics and dashboards | <%OBSERVABILITY_STACK%> | Backend | ❌  | ❌   | ✅      | ✅   | Exposition format via `django-prometheus`    |
| Distributed tracing    | <%TRACING_BACKEND%>     | Backend | ❌  | ❌   | ❌      | ❌   | Seam adopted (OTLP); nothing instrumented    |
| Media storage          | Cloudinary              | Both    | ✅  | ✅   | ✅      | ✅   | Hypothetical seam — one implementation       |

## Cross-references

- `code/src/logs/CONTEXT.md` — where local log files are written in dev/test
- `code/workflows/09-debugging-with-logs/` — step-by-step debugging workflow
- `code/src/docker/CONTEXT.md` — observability section (per-environment summary)
- `code/docs/SECURITY.md` — security logging requirements (audit trails, sensitive data)
- `code/docs/PERFORMANCE.md` — application metrics for performance monitoring
- `code/docs/architecture/PROVIDER-NEUTRALITY.md` — why each heading above names a capability

_Part of the `code/docs/` documentation family._
