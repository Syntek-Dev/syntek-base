---
type: guide
agent: logging
skills: [stack-django]
model: opus
---

# Logging, Observability & Media — Reference Guide

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Structured logging, error tracking, metrics, and Cloudinary media storage

Logging configuration, observability tooling, and media storage patterns for the Django-served
stack (Django + Django Ninja + templates/HTMX/Alpine). Covers structured
logging, error tracking, log aggregation, metrics, and Cloudinary file storage. There is no
Node/Next server — server logging is Django-only; browser logging is captured to GlitchTip.

## Sub-documents

| Document                                                     | Covers                                                                                                                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`logging/DJANGO-LOGGING.md`](logging/DJANGO-LOGGING.md)     | Django `LOGGING` config (dev/test and staging/prod), Django Ninja request/exception logging, log levels, logger-not-print rule, never-log-raw-IP rule   |
| [`logging/FRONTEND-LOGGING.md`](logging/FRONTEND-LOGGING.md) | Browser logging via the Sentry browser SDK + a small project logger, dev vs prod behaviour, the no-`console` rule                                       |
| [`logging/OBSERVABILITY.md`](logging/OBSERVABILITY.md)       | GlitchTip error tracking (Django + browser), Loki log aggregation (pipeline, LogQL, retention), Prometheus metrics (Django `/metrics/`), Grafana, Alloy |
| [`logging/HEALTH-CONTRACT.md`](logging/HEALTH-CONTRACT.md)   | Health/metrics endpoints the app exposes and what the NixOS deploy repo must provision (Gatus status page, Prometheus scrape)                           |
| [`logging/CLOUDINARY.md`](logging/CLOUDINARY.md)             | Cloudinary media storage configuration, required env vars summary                                                                                       |

## Stack by environment

| Tool               | Layer   | dev | test | staging | prod | Purpose                                        |
| ------------------ | ------- | --- | ---- | ------- | ---- | ---------------------------------------------- |
| File logging       | Backend | ✅  | ✅   | ❌      | ❌   | `code/src/logs/django.log` — local artefacts   |
| GlitchTip (Sentry) | Both    | ❌  | ❌   | ✅      | ✅   | Exception/error tracking (Django + browser)    |
| Alloy              | Infra   | ❌  | ❌   | ✅      | ✅   | Log shipping (server host → Loki)              |
| Loki               | Infra   | ❌  | ❌   | ✅      | ✅   | Log aggregation and storage                    |
| Prometheus         | Backend | ❌  | ❌   | ✅      | ✅   | Django application metrics (django-prometheus) |
| Grafana            | Infra   | ❌  | ❌   | ✅      | ✅   | Dashboards (Loki + Prometheus)                 |
| Cloudinary         | Both    | ✅  | ✅   | ✅      | ✅   | File / media storage                           |

## Cross-references

- `code/src/logs/CONTEXT.md` — where local log files are written in dev/test
- `code/workflows/10-debugging-with-logs/` — step-by-step debugging workflow
- `code/src/docker/CONTEXT.md` — observability section (per-environment summary)
- `code/docs/SECURITY.md` — security logging requirements (audit trails, sensitive data)
- `code/docs/PERFORMANCE.md` — Prometheus metrics for performance monitoring

_Part of the `code/docs/` documentation family._
