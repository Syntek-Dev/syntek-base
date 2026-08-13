---
type: guide
skills: [logging, stack-django]
model: opus
---

# Logging — Django Configuration

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Django logging config, logger usage, structured-logging patterns

---

## Rules — always use the logger, never `print`

| Never commit this                      | Always use this instead                                   |
| -------------------------------------- | --------------------------------------------------------- |
| `print("user created:", user.id)`      | `logger.info("user created", extra={"user_id": user.id})` |
| bare module code with no module logger | `logger = logging.getLogger(__name__)` at module top      |

`print()` bypasses every handler — it never appears in `code/src/logs/django.log`, never
reaches Loki, and is invisible to GlitchTip. Any log written this way is lost the moment the
terminal scrolls or the container restarts. (Browser-side `console.*` is covered in
[`FRONTEND-LOGGING.md`](FRONTEND-LOGGING.md).)

**Never log a raw client IP.** A client IP is personal data under UK GDPR, so it must not appear in
a log line, a `WARNING`, or a GlitchTip event. `apps.core.utils.get_client_ip` deliberately never
logs the IP it resolves; the rate-limit middleware `WARNING` lines log the error, not the IP. When a
log line _must_ reference the caller's IP (e.g. to correlate repeated upload failures), log
`apps.core.utils.hash_client_ip(ip)` — a one-way SHA-256 prefix — never the raw value (e.g.
`logger.error("Contact upload failed ip_hash=%s", hash_client_ip(ip))`). When an IP must be
persisted for security attribution (e.g. the audit log) it is stored one-way hashed
(`hashlib.sha256`, via `hash_client_ip(ip, full=True)`), never in plaintext. GlitchTip scrub hooks
(`apps.core.observability`) redact secret-bearing fields; do not rely on them to remove an IP you
should not have logged in the first place.

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

---

## Log levels

Use the correct level consistently — Loki and GlitchTip filter by level.

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

### dev / test (`config/settings/dev.py`, `config/settings/test.py`)

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
        "django.request": {"handlers": ["console", "file"], "level": "INFO", "propagate": False},
        "django.db.backends": {"handlers": ["file"], "level": "DEBUG", "propagate": False},
        "api": {"handlers": ["console", "file"], "level": "INFO", "propagate": False},
    },
}
```

### staging / prod (`config/settings/staging.py`, `config/settings/production.py`)

Structured JSON to stdout only — Grafana Alloy (running on the server host) reads Docker
container stdout and ships it to Loki. No file handler: ephemeral containers must not write
to disk.

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
        "django.request": {"handlers": ["console"], "level": "INFO", "propagate": False},
        "api": {"handlers": ["console"], "level": "INFO", "propagate": False},
    },
}
```

---

## Django Ninja request & exception logging

The JSON API is served by Django Ninja. Log one line per API request (name, status, duration) and
one line per unhandled exception, both on the `api` logger — this gives endpoint-level visibility in
Loki without touching every handler.

### Request timing middleware (`apps/core/middleware.py`)

```python
import logging
import time

logger = logging.getLogger("api")


class RequestLogMiddleware:
    """Log one line per /api/ request with method, path, status, and duration."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if not request.path.startswith("/api/"):
            return self.get_response(request)
        start = time.perf_counter()
        response = self.get_response(request)
        duration_ms = round((time.perf_counter() - start) * 1000)
        logger.info(
            "api request",
            extra={
                "method": request.method,
                "path": request.path,
                "status": response.status_code,
                "duration_ms": duration_ms,
            },
        )
        return response
```

Register it after `AuthenticationMiddleware` in `MIDDLEWARE`.

### Ninja exception handler (`config/api.py`)

Register a catch-all handler on the `NinjaAPI` instance so unhandled exceptions are logged at
`ERROR` (which forwards to GlitchTip) before a safe JSON error is returned. Validation errors
(Pydantic `Schema` failures → `422`) are user-facing, not bugs — log them at `INFO`, not `ERROR`.

> **Which class an error belongs to is not decided here.** The programmer / user / environment
> taxonomy, the exception type each raises, and the status, log level and tracker behaviour each
> gets are owned by [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) § _The error taxonomy_. This
> section is one of that taxonomy's consequences — the wiring, not the rule.

```python
import logging

from ninja import NinjaAPI
from ninja.errors import ValidationError

logger = logging.getLogger("api")

api = NinjaAPI(title="<%PROJECT_NAME%> API", docs_url="/api/docs")


@api.exception_handler(ValidationError)
def on_validation_error(request, exc):
    logger.info("api validation error", extra={"path": request.path})
    return api.create_response(request, {"detail": exc.errors}, status=422)


@api.exception_handler(Exception)
def on_unhandled(request, exc):
    logger.error("api request failed", exc_info=True, extra={"path": request.path})
    return api.create_response(request, {"detail": "Internal server error."}, status=500)
```

> Ninja auto-generates the OpenAPI schema and Swagger UI at `/api/docs`. Every state-changing
> endpoint carries its own explicit permission check (OWASP A01); logging never substitutes for it.

_Part of the `code/docs/` documentation family. See [`../LOGGING.md`](../LOGGING.md) for the full index._
