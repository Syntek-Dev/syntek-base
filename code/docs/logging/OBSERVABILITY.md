---
type: guide
agent: logging
skills: [stack-django]
model: opus
---

# Logging — Observability Stack

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Observability stack: GlitchTip error tracking, Loki, Prometheus, Grafana

---

## GlitchTip — error and exception tracking

GlitchTip is a self-hostable, Sentry-compatible error tracking platform. It captures both Django
server exceptions and browser errors.

### Backend (Django) — `sentry-sdk[django]`

Add `sentry-sdk[django]` to the backend dependencies, then configure it in
`config/settings/base.py`:

```python
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration
from sentry_sdk.integrations.logging import LoggingIntegration

GLITCHTIP_DSN = env("GLITCHTIP_DSN", default="")

if GLITCHTIP_DSN:
    sentry_sdk.init(
        dsn=GLITCHTIP_DSN,
        integrations=[
            DjangoIntegration(),
            LoggingIntegration(level=logging.ERROR, event_level=logging.ERROR),
        ],
        traces_sample_rate=0.1,
        send_default_pii=False,      # GDPR: never send PII automatically
    )
```

`GLITCHTIP_DSN` is left blank in dev/test (SDK is a no-op).

### Browser — `@sentry/browser`

The browser SDK is initialised from `GLITCHTIP_BROWSER_DSN`, rendered into the page as a `<meta>`
tag — a separate DSN from the backend. Full setup, the project logger, HTMX error forwarding, and
usage patterns live in [`FRONTEND-LOGGING.md`](FRONTEND-LOGGING.md); leave the DSN unset in
dev/test.

### What GlitchTip captures

| Source          | What is captured                                                                                   |
| --------------- | -------------------------------------------------------------------------------------------------- |
| Django (server) | Unhandled exceptions in views, Django Ninja endpoints, and Celery tasks; `logger.error(...)` calls |
| Browser         | Unhandled JS errors; forwarded HTMX response and network errors                                    |

### What GlitchTip does NOT capture automatically

- Django Ninja validation errors (`422` from Pydantic `Schema` validation — user-facing, not bugs;
  logged at `INFO` by the exception handler)
- Intentional 4xx responses

---

## Loki — log aggregation

Loki aggregates container logs in staging and production. No application-side configuration
is required — Grafana Alloy runs on the server host and ships Docker stdout/stderr to Loki
automatically. Browser errors do **not** flow through Loki; they reach the stack via GlitchTip.

> Alloy, Loki, Grafana, Prometheus, and GlitchTip are **server infrastructure** and do not
> run in the local Docker Compose stack — they live in the NixOS deploy repo.

### Log pipeline

```text
Django web container (stdout — structured JSON)   Celery worker container (stdout — JSON)
    │                                                │
    └───────────────────┬───────────────────────────┘
                        │
              Docker log driver (json-file)
                        │
              Grafana Alloy on server host
              (reads /var/lib/docker/containers/*/*.log)
                        │
                       Loki
                        │
              Grafana Explore / dashboards (LogQL)
```

### Key LogQL queries

```logql
# All backend errors
{container="{{PROJECT_SLUG}}-web"} | json | level="ERROR"

# Slow API operations (requires duration_ms field in log)
{container="{{PROJECT_SLUG}}-web"} | json | logger="api" | duration_ms > 500

# Specific Django logger
{container="{{PROJECT_SLUG}}-web"} | json | logger=~"apps.users.*"

# Celery worker errors
{container="{{PROJECT_SLUG}}-worker"} | json | level="ERROR"

# Combined error stream across app containers
{container=~"{{PROJECT_SLUG}}-(web|worker)"} | json | level=~"ERROR|CRITICAL"
```

### Retention

- Staging: 14 days
- Production: 90 days

---

## Prometheus — application metrics

Prometheus scrapes metrics from the Django backend only. There is no Node/Next server, so there are
no Node-process metrics — browser performance is observed via GlitchTip and (optionally) client
telemetry, not a Prometheus scrape.

### Backend — `django-prometheus`

Add `django-prometheus` to the backend dependencies, then configure it in
`config/settings/base.py`:

```python
INSTALLED_APPS = [
    "django_prometheus",
    # … other apps
]

MIDDLEWARE = [
    "django_prometheus.middleware.PrometheusBeforeMiddleware",
    # … other middleware …
    "django_prometheus.middleware.PrometheusAfterMiddleware",
]
```

URL routing (`config/urls.py`):

```python
from django.urls import include, path

urlpatterns = [
    path("", include("django_prometheus.urls")),  # exposes /metrics/
    # … other urls
]
```

Key metrics exposed:

| Metric                                   | Description                           |
| ---------------------------------------- | ------------------------------------- |
| `django_http_requests_total`             | Request count by method, view, status |
| `django_http_request_duration_seconds`   | Latency histogram                     |
| `django_db_execute_total`                | Database query count                  |
| `django_cache_get_total` / `_miss_total` | Cache hit/miss rates (Valkey)         |

`/metrics/` is loopback-only — restrict it to internal access in Nginx:

```nginx
location /metrics/ {
    allow 127.0.0.1;
    deny all;
    proxy_pass http://app_upstream;
}
```

### Prometheus scrape config (server-side)

```yaml
# prometheus.yml
scrape_configs:
  - job_name: {{ORG_SLUG}}-web
    static_configs:
      - targets: ["127.0.0.1:8000"]
    metrics_path: /metrics/
    scrape_interval: 15s
```

---

## Grafana — dashboards

Grafana queries Loki (logs) and Prometheus (Django metrics).

### Backend panels

| Panel                    | Data source | Query                                                                             |
| ------------------------ | ----------- | --------------------------------------------------------------------------------- |
| Request rate             | Prometheus  | `rate(django_http_requests_total[5m])`                                            |
| Error rate (5xx)         | Prometheus  | `rate(django_http_requests_total{status=~"5.."}[5m])`                             |
| P95 latency              | Prometheus  | `histogram_quantile(0.95, rate(django_http_request_duration_seconds_bucket[5m]))` |
| DB query rate            | Prometheus  | `rate(django_db_execute_total[5m])`                                               |
| Backend error log stream | Loki        | `{container="{{PROJECT_SLUG}}-web"} \| json \| level="ERROR"`                     |

### Browser errors

Browser errors are viewed in GlitchTip, not Grafana. Configure a GlitchTip datasource or use
dashboard annotations to correlate deployments with browser error spikes alongside the backend
panels above.

## Health endpoints + status page

Live system health (the admin Health tab, the public `/health/ready/` readiness endpoint, and the
Gatus public status page at `status.{{PRIMARY_DOMAIN}}`) is documented separately — including the reference
Gatus config and the Prometheus app-scrape jobs the deploy repo must provision. See
[`HEALTH-CONTRACT.md`](HEALTH-CONTRACT.md).

_Part of the `code/docs/` documentation family. See [`../LOGGING.md`](../LOGGING.md) for the full index._
