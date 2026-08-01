# code/docs/logging

**Claude Model:** opus — Logging sub-doc index: Django, frontend, observability, health, Cloudinary

Sub-documents for logging and observability. Covers Django logging configuration, browser logging
via the Sentry SDK, the observability stack, the health/metrics deploy contract, and Cloudinary
media logging.

## Files

| File                  | Purpose                                                                          |
| --------------------- | -------------------------------------------------------------------------------- |
| `DJANGO-LOGGING.md`   | Django logging configuration and Django Ninja request/exception logging          |
| `FRONTEND-LOGGING.md` | Browser logging via the Sentry SDK + project logger                              |
| `OBSERVABILITY.md`    | Observability stack and monitoring (GlitchTip, Loki, Prometheus, Grafana, Alloy) |
| `HEALTH-CONTRACT.md`  | Health endpoints + Gatus/Prometheus contract (app ↔ deploy repo)                 |
| `CLOUDINARY.md`       | Cloudinary file and media storage configuration                                  |

Parent guide: `code/docs/LOGGING.md`
