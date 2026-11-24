---
type: guide
skills: [logging, stack-django]
model: opus
---

# Observability — Error Tracking, Log Aggregation, Metrics and Traces

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the four observability interfaces, the default behind each, and what
each one captures

**Status: declared, not wired.** `sentry-sdk[django]` and `django-prometheus>=2.3.1` are declared
in the root `pyproject.toml`, but nothing configures either: there is no `sentry_sdk.init(...)`
in `config/settings/`, and `django_prometheus` is not in `INSTALLED_APPS`. What follows is the
shape to build to, not a description of running code.

Each section below leads with the **interface** the code is written against; the product named as
the default is one implementation behind it, and a project that answered differently is still
on-doctrine ([`../architecture/PROVIDER-NEUTRALITY.md`](../architecture/PROVIDER-NEUTRALITY.md);
register: [`how-to/src/PLATFORM-PROVIDERS.md`](../../../how-to/src/PLATFORM-PROVIDERS.md)).

> The collector side — log shipper, metrics store, dashboards — is **server infrastructure**. It
> does not run in the local Docker Compose stack; it is provisioned by the NixOS deploy repo.

---

## Error tracking

**Interface:** the Sentry SDK wire protocol, via `sentry-sdk[django]`
**Seam kind:** protocol
**Default:** <%ERROR_TRACKING%>
**Proven alternates:** Sentry · Bugsink

The seam is the wire protocol, not the product. Any backend that speaks it is reached by changing
one environment variable and no code — which is why the DSN variable is named for the protocol
(`SENTRY_DSN`, the SDK's own convention) rather than for whichever backend is receiving it.

### Backend (Django)

Add `sentry-sdk[django]` to the backend dependencies, then configure it in
`config/settings/base.py`:

```python
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration
from sentry_sdk.integrations.logging import LoggingIntegration

SENTRY_DSN = env("SENTRY_DSN", default="")

if SENTRY_DSN:
    sentry_sdk.init(
        dsn=SENTRY_DSN,
        integrations=[
            DjangoIntegration(),
            LoggingIntegration(level=logging.ERROR, event_level=logging.ERROR),
        ],
        send_default_pii=False,  # GDPR: never send PII automatically
        include_local_variables=False,  # frame locals hold exceptions and payloads; on by default
    )
```

`SENTRY_DSN` is left blank in dev/test, where the SDK is a no-op. **`include_local_variables` is
off** because a frame's locals can hold a client's exception, URL or body that a scrubbed message
left out ([`../reliability/RETRIES.md`](../reliability/RETRIES.md) Section _What a failure record
carries_).

**There is no `traces_sample_rate` here, and its absence is deliberate.** That option sends
transactions over the Sentry wire protocol, which would be a **second instrumentation path**
alongside the one adopted under _Distributed tracing_ below. This section captures errors; spans
are OTLP's.

**Touch no backend-specific API.** One call to a product-only endpoint or field and the seam is
gone — silently, and usually years before anyone tries to swap.

### Browser

The browser SDK is initialised from `SENTRY_BROWSER_DSN`, rendered into the page as a `<meta>`
tag — a separate DSN from the backend. Full setup, the project logger, HTMX error forwarding, and
usage patterns live in [`FRONTEND-LOGGING.md`](FRONTEND-LOGGING.md); leave the DSN unset in
dev/test.

### What is captured

| Source          | What is captured                                                                                   |
| --------------- | -------------------------------------------------------------------------------------------------- |
| Django (server) | Unhandled exceptions in views, Django Ninja endpoints, and Celery tasks; `logger.error(...)` calls |
| Browser         | Unhandled JS errors; forwarded HTMX response and network errors                                    |

### What is not captured automatically

- Django Ninja validation errors (`422` from Pydantic `Schema` validation — user-facing, not bugs;
  logged at `INFO` by the exception handler)
- Intentional 4xx responses

---

## Log aggregation

**Interface:** structured JSON on stdout (12-factor) — every line Django's `LOGGING` emits
**Seam kind:** protocol
**Default:** <%LOG_AGGREGATOR%>
**Proven alternates:** Vector · Fluent Bit · Alloy · CloudWatch Logs

The application's whole obligation is to write every line Django's `LOGGING` emits as structured
JSON to stdout (`DJANGO-LOGGING.md`). What reads it, ships it and stores it is a deployment choice
with **no application-side configuration at all** — which is what makes this the cheapest seam in
the stack. The one exception is the process-server stream below. Browser errors do not flow through
it; they reach the stack via the error tracker above.

### Log pipeline

The reference deployment runs Grafana Alloy on the server host, shipping Docker stdout/stderr to
<%LOG_AGGREGATOR%>. The collector contract — labels, relabels, rotation, retention — is
`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section _Log collection_:

```text
django service (stdout — Django's lines, JSON;     Celery worker (forward reference —
  stderr — process-server lines, plain text)          joins once Celery is wired)
    │                                                │
    └───────────────────┬───────────────────────────┘
                        │
     Docker log driver (json-file, max-size/max-file rotation)
                        │
                 Log shipper on server host
   (reads container stdout and stderr through the Docker daemon,
    with Compose labels relabelled to service_name and environment)
                        │
                  Log store and index
                        │
                Query UI / dashboards
```

> **The worker service does not exist yet.** `celery[redis]` is declared in `pyproject.toml`, but
> no Compose file defines a `worker` or `beat` service — so the right-hand leg above, and the worker
> query below, are **forward references** gated on Celery being wired
> (`how-to/docs/CELERY-FIRST-RUN.md`).

### Key queries

Written in LogQL, the query language of the default. A different collector expresses the same
five questions in its own dialect; the questions are the portable part.

Selectors use the Compose service label as relabelled, `service_name`, never a container name.

```logql
# All backend errors
{service_name="django"} | json | level="ERROR"

# Slow API operations — applies once a project declares the `api` logger at INFO
# (root is WARNING in staging and production, so nothing writes INFO to it today)
{service_name="django"} | json | logger="api" | duration_ms > 500

# Specific Django logger — applies once a project declares apps.users.* at INFO
{service_name="django"} | json | logger=~"apps.users.*"

# Celery worker errors — forward reference, gated on Celery: no worker service exists, so this
# is not relabelled yet; it takes the worker's service_name once Celery is wired
{container="<%PROJECT_SLUG%>-worker"} | json | level="ERROR"

# Combined error stream — the worker leg joins once Celery is wired
{service_name="django"} | json | level=~"ERROR|CRITICAL"

# Process-server stream (gunicorn.error / uvicorn.error, boot output): plain text on stderr,
# no request_id — `| json | __error__=""` drops it, this keeps it
{service_name="django"} | json | __error__!=""
```

The process-server stream sits outside Django's `LOGGING`, can rarely carry an escaped "Exception
in ASGI application" traceback with its message, and arrives **one entry per line** unless the
collector runs a multiline stage (`DJANGO-LOGGING.md`, _The process-server stream_).

### Retention

Reference defaults **the controller confirms**, enforced by the collector
(`EDGE-REQUIREMENTS.md`, _Log collection_):

- Staging: 14 days
- Production: 90 days

---

## Metrics and dashboards

**Interface:** the Prometheus exposition format / OpenMetrics
**Seam kind:** protocol
**Default:** <%OBSERVABILITY_STACK%>
**Proven alternates:** VictoriaMetrics · Grafana Mimir · Alloy · vendor scrape agents

The application exposes text in the exposition format at a loopback-only endpoint and does not
care what scrapes it. Metrics come from the Django backend only — there is no Node server, so
there are no Node-process metrics; browser performance is observed via the error tracker and
(optionally) client telemetry, not a scrape.

### Backend — `django-prometheus`

The library is named for the format, not for a scraper, and serves every alternate above equally.
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

`/metrics/` is loopback-only — restrict it to internal access at the edge proxy:

```nginx
location /metrics/ {
    allow 127.0.0.1;
    deny all;
    proxy_pass http://app_upstream;
}
```

### Scrape configuration (server-side)

Provisioned by the deploy repo, never in this one. The reference form:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: <%ORG_SLUG%>-backend
    static_configs:
      - targets: ["127.0.0.1:8000"]
    metrics_path: /metrics/
    scrape_interval: 15s
```

The job name is a contract, not a preference — it is spelled the same way in
[`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`](../../../how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md)
Section 8, and both must move together.

### Dashboards

Dashboards read the metrics store and the log store together. They are **not a separate seam** —
the register classes them with metrics, because a dashboard tool is chosen with its query
backends rather than independently.

| Panel                    | Data source | Query                                                                             |
| ------------------------ | ----------- | --------------------------------------------------------------------------------- |
| Request rate             | Metrics     | `rate(django_http_requests_total[5m])`                                            |
| Error rate (5xx)         | Metrics     | `rate(django_http_requests_total{status=~"5.."}[5m])`                             |
| P95 latency              | Metrics     | `histogram_quantile(0.95, rate(django_http_request_duration_seconds_bucket[5m]))` |
| DB query rate            | Metrics     | `rate(django_db_execute_total[5m])`                                               |
| Backend error log stream | Logs        | `{service_name="django"} \| json \| level="ERROR"`                                |

**Browser errors are viewed in the error tracker, not the dashboard.** Configure it as a
datasource, or use dashboard annotations to correlate deployments with browser error spikes
alongside the backend panels above.

---

## Distributed tracing

**Interface:** OTLP — the OpenTelemetry Protocol, via the OpenTelemetry SDK and its OTLP exporter
**Seam kind:** protocol
**Default:** <%TRACING_BACKEND%>
**Proven alternates:** Grafana Tempo · Jaeger · SigNoz · Honeycomb · Uptrace

**The seam is adopted; the backend is deferred.** Nothing here is wired — no `opentelemetry-*`
package is declared in `pyproject.toml`, and no call site is instrumented. This is the one
section that names a seam ahead of any use of it, and the asymmetry is the whole reason:

| Retrofitting later | Costs                                                                |
| ------------------ | -------------------------------------------------------------------- |
| The **backend**    | One environment variable, once                                       |
| The **seam**       | Every instrumented call site, in whatever library it was written for |

A project that instruments against a vendor's tracing SDK and later wants a different backend
rewrites the instrumentation. A project that instruments against OTLP changes an endpoint. The
difference lands at exactly the moment tracing is wanted — mid-incident, on a system already
under strain.

### What instrumenting against OTLP means

When the trigger below fires, three things bind. They are the protocol-seam evidence bar from
[`../architecture/PROVIDER-NEUTRALITY.md`](../architecture/PROVIDER-NEUTRALITY.md), applied here:

1. **Spans are created through the OpenTelemetry API**, never a vendor tracing SDK. The exporter
   is the OTLP one; the backend sits on the far side of it.
2. **No backend-specific span attribute or API is touched.** This is the point that gets violated
   later, by a small convenience, in a pull request nobody reads twice.
3. **The endpoint variable is `OTEL_EXPORTER_OTLP_ENDPOINT`** — OpenTelemetry's own name, not one
   named for whichever collector receives it. An identifier follows the interface (exception 3 in
   the neutrality rule; the same reasoning that makes the DSN `SENTRY_DSN`).

### One instrumentation path, not two

The error tracker captures **errors**; this section owns **spans**. Keeping them apart is what
makes the seam claimable, and it costs nothing: `sentry-sdk` ships an OpenTelemetry span
processor that converts OTel spans into its own transactions. Spans reach the error tracker
_through_ the OTLP instrumentation rather than beside it — so adopting OTLP never means giving up
trace context there, and there is never a reason to set `traces_sample_rate`.

---

## Deferred, with a trigger

Each of these is deliberately absent. Every deferral records the condition that reopens it, a
trigger, not a shrug.

| Deferred                                                 | Revisit when                                                                                                                                                                                                                                                                          |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`sentry_sdk.init(...)` in the settings module**        | The first environment exists that is not local — the SDK is a no-op without a DSN, so wiring it early costs nothing but proves nothing either                                                                                                                                         |
| **`django_prometheus` in `INSTALLED_APPS`**              | A scrape target exists to read `/metrics/`. Exposing the endpoint with nothing scraping it is an unmonitored public surface, not an early win                                                                                                                                         |
| **The browser SDK bundle**                               | The first non-local environment, as above. `FRONTEND-LOGGING.md` holds the shape                                                                                                                                                                                                      |
| **Tracing instrumentation, and a backend to send it to** | **Either** is sufficient: a **second deployable** exists, so a trace crosses a process boundary; **or** a latency budget in [`../PERFORMANCE.md`](../PERFORMANCE.md) is breached and metrics plus logs cannot localise it. The seam is already settled above — only the backend waits |
| **The worker log leg (forward reference)**               | Celery is wired and a `worker`/`beat` service exists in a Compose file (`how-to/docs/CELERY-FIRST-RUN.md`)                                                                                                                                                                            |
| **Log-based alerting rules**                             | An on-call rotation exists to receive them. Until then the status page and the error tracker are the signal (`HEALTH-CONTRACT.md`)                                                                                                                                                    |

---

## Health endpoints + status page

Live system health (the admin Health tab, the public `/health/ready/` readiness endpoint, and the
public status page at `status.<%PRIMARY_DOMAIN%>`) is documented separately — including the
reference status-page config and the app scrape jobs the deploy repo must provision. See
[`HEALTH-CONTRACT.md`](HEALTH-CONTRACT.md).

_Part of the `code/docs/` documentation family. See [`../LOGGING.md`](../LOGGING.md) for the full index._
