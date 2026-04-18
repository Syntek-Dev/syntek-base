# Logging, Observability & Media — Reference Guide

## Stack by environment

| Tool         | dev | test | staging | prod | Purpose                            |
| ------------ | --- | ---- | ------- | ---- | ---------------------------------- |
| File logging | ✅  | ✅   | ❌      | ❌   | `code/src/logs/` — local artefacts |
| Console logs | ✅  | ✅   | ✅      | ✅   | stdout/stderr (Docker captures)    |
| Glitchtip    | ❌  | ❌   | ✅      | ✅   | Exception and error tracking       |
| Loki         | ❌  | ❌   | ✅      | ✅   | Log aggregation (via Promtail)     |
| Prometheus   | ❌  | ❌   | ✅      | ✅   | Application metrics                |
| Grafana      | ❌  | ❌   | ✅      | ✅   | Dashboards (Loki + Prometheus)     |
| Cloudinary   | ✅  | ✅   | ✅      | ✅   | File / media storage               |

---

## Rules — always use the logger, never the console

| ❌ Never commit this              | ✅ Always use this instead                                  |
| --------------------------------- | ----------------------------------------------------------- |
| `print("user created:", user.id)` | `logger.info("user created", extra={"user_id": user.id})`   |
| `console.log("response:", data)`  | `logger.info("graphql response", { data })` (server)        |
| `console.error("failed:", err)`   | `logger.error("operation failed", { error: err })` (server) |

**`print()` and `console.log()` bypass every handler.** They never appear in `code/src/logs/`,
never reach Loki, and are invisible to Glitchtip. Any log written this way is lost the moment
the terminal scrolls or the container restarts.

Temporary `print()` / `console.log()` statements are acceptable **only** while actively tracing
a bug in a local branch. They must be removed before the fix is committed — treat them the same
as a commented-out block of code. The linter will not catch them automatically; the code reviewer
must.

### Python — correct pattern

```python
import logging

logger = logging.getLogger(__name__)   # one per module, at module level

def create_user(email: str) -> User:
    logger.debug("creating user", extra={"email": email})
    user = User.objects.create(email=email)
    logger.info("user created", extra={"user_id": user.id})
    return user
```

### TypeScript (Next.js server components / API routes) — correct pattern

```typescript
import { logger } from "@/lib/logger"; // project logger utility

export async function createUser(email: string) {
  logger.debug("creating user", { email });
  const user = await db.user.create({ data: { email } });
  logger.info("user created", { userId: user.id });
  return user;
}
```

> The `@/lib/logger` utility will be set up during frontend scaffolding. Until then, use
> `console` only in client components (browser) where no server-side logger is available,
> and remove all such statements before merging to main.

## Log levels

Use the correct level consistently — Loki and Glitchtip filter by level.

| Level      | When to use                                                        |
| ---------- | ------------------------------------------------------------------ |
| `DEBUG`    | Diagnostic detail only useful during development                   |
| `INFO`     | Normal operational events (user login, record created)             |
| `WARNING`  | Recoverable unexpected state (deprecated API call, fallback taken) |
| `ERROR`    | Failure that affects a request but the process continues           |
| `CRITICAL` | Failure that may bring the process down                            |

Never swallow exceptions silently. Always log at `ERROR` or `WARNING` before handling:

```python
import logging

logger = logging.getLogger(__name__)

try:
    result = do_something()
except SomeException:
    logger.error("do_something failed", exc_info=True)
    raise
```

---

## Django LOGGING configuration

### dev / test (`config/settings/local.py`, `config/settings/test.py`)

Human-readable format, output to console and to a rotating file in `code/src/logs/`:

```python
from pathlib import Path

LOGS_DIR = Path(__file__).resolve().parents[4] / "src" / "logs"
LOGS_DIR.mkdir(exist_ok=True)

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "{asctime} {levelname} {name} {message}",
            "style": "{",
            "datefmt": "%Y-%m-%d %H:%M:%S",
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "verbose",
        },
        "file": {
            "class": "logging.handlers.RotatingFileHandler",
            "filename": LOGS_DIR / "django.log",
            "maxBytes": 10 * 1024 * 1024,  # 10 MB
            "backupCount": 5,
            "formatter": "verbose",
        },
    },
    "root": {
        "handlers": ["console", "file"],
        "level": "DEBUG",
    },
    "loggers": {
        "django": {"handlers": ["console", "file"], "level": "INFO", "propagate": False},
        "django.request": {"handlers": ["console", "file"], "level": "WARNING", "propagate": False},
        "django.db.backends": {"handlers": ["file"], "level": "DEBUG", "propagate": False},
    },
}
```

### staging / prod (`config/settings/staging.py`, `config/settings/production.py`)

Structured JSON to stdout only — Promtail captures Docker stdout and ships it to Loki.
No file handler: ephemeral containers must not write to disk.

```python
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "json": {
            "format": '{"time": "%(asctime)s", "level": "%(levelname)s", '
                      '"logger": "%(name)s", "message": "%(message)s"}',
            "datefmt": "%Y-%m-%dT%H:%M:%S",
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "json",
        },
    },
    "root": {"handlers": ["console"], "level": "INFO"},
    "loggers": {
        "django": {"handlers": ["console"], "level": "INFO", "propagate": False},
        "django.request": {"handlers": ["console"], "level": "WARNING", "propagate": False},
    },
}
```

---

## Glitchtip — error and exception tracking

Glitchtip is a self-hostable, Sentry-compatible error tracking platform.
It uses the official Sentry Python SDK.

### Installation

```bash
uv add sentry-sdk[django]
```

### Configuration (`config/settings/base.py`)

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
        traces_sample_rate=0.1,      # 10% of transactions; tune per environment
        send_default_pii=False,      # GDPR: never send PII automatically
    )
```

`GLITCHTIP_DSN` is left blank in dev/test (SDK is a no-op when DSN is empty).
Set it as an environment variable in staging and prod.

### What Glitchtip captures

- Unhandled exceptions in views and resolvers
- `logger.error(...)` calls (via `LoggingIntegration`)
- Failed background tasks (if Celery is added later)

### What it does NOT capture automatically

- Validation errors returned as GraphQL errors (these are user-facing, not bugs)
- Intentional 4xx responses

---

## Loki — log aggregation

Loki aggregates container logs in staging and production. No Python-side configuration
is required — Promtail runs as a sidecar on the server and ships Docker stdout/stderr
to Loki automatically.

### How it works

```text
Docker container stdout
    → Promtail (sidecar, reads /var/lib/docker/containers/*)
    → Loki (stores log streams)
    → Grafana (queries via LogQL)
```

### Why JSON logging matters

Staging/prod settings use a JSON formatter so Loki can index structured fields
(level, logger name, request ID, user ID) and allow precise LogQL filtering:

```logql
{container="syntek-backend"} | json | level="ERROR"
{container="syntek-backend"} | json | logger=~"apps.users.*"
```

### Retention

Configure Loki retention on the server. Recommended:

- Staging: 14 days
- Production: 90 days

---

## Prometheus — application metrics

Prometheus scrapes Django request metrics exposed at `/metrics/`.

### Installation

```bash
uv add django-prometheus
```

### Configuration (`config/settings/base.py`)

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

### URL routing (`config/urls.py`)

```python
from django.urls import include, path

urlpatterns = [
    path("", include("django_prometheus.urls")),  # exposes /metrics/
    # … other urls
]
```

### Key metrics exposed

| Metric                                   | Description                           |
| ---------------------------------------- | ------------------------------------- |
| `django_http_requests_total`             | Request count by method, view, status |
| `django_http_request_duration_seconds`   | Latency histogram                     |
| `django_db_execute_total`                | Database query count                  |
| `django_cache_get_total` / `_miss_total` | Cache hit/miss rates                  |

### Prometheus scrape config (server-side)

```yaml
# prometheus.yml
scrape_configs:
  - job_name: syntek-backend
    static_configs:
      - targets: ["127.0.0.1:8000"]
    metrics_path: /metrics/
    scrape_interval: 15s
```

---

## Grafana — dashboards

Grafana queries both Loki (logs) and Prometheus (metrics) and is provisioned on the server.

### Recommended panels

| Panel             | Data source | Query                                                                             |
| ----------------- | ----------- | --------------------------------------------------------------------------------- |
| Request rate      | Prometheus  | `rate(django_http_requests_total[5m])`                                            |
| Error rate (5xx)  | Prometheus  | `rate(django_http_requests_total{status=~"5.."}[5m])`                             |
| P95 latency       | Prometheus  | `histogram_quantile(0.95, rate(django_http_request_duration_seconds_bucket[5m]))` |
| DB query rate     | Prometheus  | `rate(django_db_execute_total[5m])`                                               |
| Error log stream  | Loki        | `{container="syntek-backend"} \| json \| level="ERROR"`                           |
| Recent exceptions | Loki        | `{container="syntek-backend"} \| json \| level=~"ERROR\|CRITICAL"`                |

Grafana also links to Glitchtip — configure a Glitchtip datasource or use dashboard
annotations to correlate deployments with error spikes.

---

## Cloudinary — file and media storage

Cloudinary handles all file uploads in every environment. There is no local `/media/`
directory and no Django `FileSystemStorage` — `DEFAULT_FILE_STORAGE` always points to
Cloudinary. This eliminates the ephemeral-container media loss problem entirely.

### Installation

```bash
uv add cloudinary django-cloudinary-storage
```

### Configuration (`config/settings/base.py`)

```python
INSTALLED_APPS = [
    "cloudinary",
    "cloudinary_storage",
    # … other apps
]

CLOUDINARY_STORAGE = {
    "CLOUD_NAME": env("CLOUDINARY_CLOUD_NAME"),
    "API_KEY": env("CLOUDINARY_API_KEY"),
    "API_SECRET": env("CLOUDINARY_API_SECRET"),
}

DEFAULT_FILE_STORAGE = "cloudinary_storage.storage.MediaCloudinaryStorage"
```

### What Cloudinary provides

- CDN delivery — no Nginx `/media/` proxy required
- Automatic image optimisation (format negotiation, quality, resizing)
- Secure signed URLs for private assets (if needed)
- Direct browser-to-Cloudinary uploads via signed upload presets (avoids server as proxy)

### Required env vars (all environments)

| Variable                | Description                               |
| ----------------------- | ----------------------------------------- |
| `CLOUDINARY_CLOUD_NAME` | Cloud name from Cloudinary dashboard      |
| `CLOUDINARY_API_KEY`    | API key                                   |
| `CLOUDINARY_API_SECRET` | API secret — never hardcode, never commit |

---

## Required environment variables — summary

| Variable                | dev | test | staging | prod |
| ----------------------- | --- | ---- | ------- | ---- |
| `CLOUDINARY_CLOUD_NAME` | ✅  | ✅   | ✅      | ✅   |
| `CLOUDINARY_API_KEY`    | ✅  | ✅   | ✅      | ✅   |
| `CLOUDINARY_API_SECRET` | ✅  | ✅   | ✅      | ✅   |
| `GLITCHTIP_DSN`         | ❌  | ❌   | ✅      | ✅   |

Prometheus and Loki are configured on the server — no application env vars required.

---

## Cross-references

- `code/src/logs/CONTEXT.md` — where local log files are written in dev/test
- `code/workflows/10-debugging-with-logs/` — step-by-step debugging workflow
- `code/src/docker/CONTEXT.md` — observability section (per-environment summary)
- `code/docs/SECURITY.md` — security logging requirements (audit trails, sensitive data)
- `code/docs/PERFORMANCE.md` — Prometheus metrics for performance monitoring
