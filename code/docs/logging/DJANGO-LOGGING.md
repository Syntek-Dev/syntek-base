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
(`hashlib.sha256`, via `hash_client_ip(ip, full=True)`), never in plaintext. **No redaction is
claimed anywhere.** Scrub hooks that redact secret-bearing fields are a forward reference: they are
the deferred `syntek-observability` half, not yet built, and nothing in `apps.core.observability`
scrubs. Keep an IP, a secret or an identifier out of the line in the first place.

### Python — correct pattern

Pass an identifier, never the personal data itself:

```python
import logging

logger = logging.getLogger(__name__)  # one per module, at module level


def create_user(email: str) -> User:
    user = User.objects.create(email=email)
    logger.info("user created", extra={"user_id": user.pk})
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

**Each environment module carries its own complete `LOGGING`; `base.py` assigns none**
(`config/settings/CLAUDE.md` carries the exception). The formatter and filter are
`apps.core.observability.JSONFormatter` and `RequestIDFilter`, and **every handler in every
environment's `LOGGING` carries the `request_id` filter** — Django's own `django.server` logger,
written only by `runserver`, which no environment runs, keeps its plain-text handler. A handler
attached in code without the filter writes whatever `extra={"request_id": ...}` a caller passed,
so the filter goes wherever the formatter does. The line contract — five fixed keys
(`timestamp` UTC ISO-8601 to the millisecond, `level`, `logger`, `message`, `request_id`), then
`exc_info` and `truncated` — is a published interface: every documented query and the collector
contract read these names, so renaming or adding a key is a breaking change that needs a
superseding ADR, never an edit to `apps/core/observability.py` alone.

### dev / test (`config/settings/dev.py`, `config/settings/test.py`)

**dev** — Django's lines are JSON in **wide** mode (every extra, the fixed keys written after
them, the full traceback, never `stack_info`), to the console and to a `RotatingFileHandler` at
`code/src/logs/django.log` (10 MB × 5), bind-mounted to the host. Root `DEBUG`; `django` at
`INFO`; `django.db.backends` at `WARNING`, file only, so SQL parameters never reach the file.
**Dev's console is not all JSON:** uvicorn's access and error lines there stay plain text, and the
access line holds the client address and query string — disposable while the posture is
`development`.

```python
"formatters": {"json": {"()": "apps.core.observability.JSONFormatter", "mode": "wide"}},
"handlers": {
    "console": {"class": "logging.StreamHandler", "formatter": "json", "filters": ["request_id"]},
    "file": {"class": "logging.handlers.RotatingFileHandler", "filename": _LOGS_DIR / "django.log",
             "maxBytes": 10 * 1024 * 1024, "backupCount": 5,
             "formatter": "json", "filters": ["request_id"]},
},
```

**test** — one console handler with **no formatter**, root `WARNING`, and `django` at `WARNING`
with no handlers. Test keeps **no** log file. The console carries the filter only so the
every-handler invariant holds.

### staging / prod (`config/settings/staging.py`, `config/settings/production.py`)

The two dicts are **identical, deliberately** — a test asserts it. Minimal JSON to **stdout**; the
collector reads each container's stdout and stderr through the Docker daemon
(`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`, _Log collection_). No file handler:
ephemeral containers must not write to disk.

```python
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "filters": {"request_id": {"()": "apps.core.observability.RequestIDFilter"}},
    "formatters": {"json": {"()": "apps.core.observability.JSONFormatter", "mode": "minimal"}},
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "stream": "ext://sys.stdout",
            "formatter": "json",
            "filters": ["request_id"],
        },
    },
    "root": {"handlers": ["console"], "level": "WARNING"},
    "loggers": {"django": {"handlers": [], "level": "WARNING"}},  # drops mail_admins
}
```

**What a line carries — minimisation, not redaction.** Staging and production serialise only the
fixed keys and three extras — `duration_ms`, `status_code`, `method` — and drop every other extra.
`exc_info` is `{"type", "frames", "cause", "context"}`: the class name and
`{filename, lineno, function}` frames, with **no exception message**, no notes and no locals; a
cycle's back-edge is omitted, never `null` ("no context"). A non-finite float is written as text
(`"nan"`), because `NaN` is not JSON.
**`message` is not scrubbed**: Django's `BadRequest` and `SuspiciousOperation` records carry
`str(exc)` in it. The claim covers every line Django's `LOGGING` emits, and nothing else.

**The path rule.** `django.request` logs the request path in `message` (every returned or raised
4xx is a `WARNING` line), so **no secret or personal data goes in a URL path segment**.

**Line shape.** Lines are ASCII-escaped (`ensure_ascii=True`) and Django `unicode_escape`s path
arguments, so search for a non-ASCII path in its escaped form (`/caf\xe9/`). The minimal line plus
its newline is capped at **16 KiB**; a longer one is cut and carries `"truncated": true`, keeping
the exception type and innermost frame, so Docker never splits it. A line over 4 KiB (`PIPE_BUF`)
written by two workers at once can still interleave on the pipe — an **accepted residual**.

**Uncorrelated records.** `request_id` is set from the request being served, so a record logged
outside `RequestIDMiddleware`'s dynamic extent carries it **null**, though the response still
carries `X-Request-ID`: a streaming or file response body generated after the view returns, a
thread or executor a view starts on the default (non-free-threaded) build, and an exception raised
mid-stream under ASGI, which reaches the process-server stream instead. These are uncorrelated by
design, never promised.

### The process-server stream — outside the pipeline

Gunicorn's and Uvicorn's own error lines (`gunicorn.error`, `uvicorn.error`) and the boot output are
**plain text on stderr, with no `request_id`**, and are not routed through `LOGGING`. They can
rarely carry an escaped "Exception in ASGI application" traceback **with its message**, so they are
outside the minimisation claim. No app-server access log is written outside dev (the edge access
log owns access records). `| json | __error__=""` drops these lines; the selector that keeps them is

```logql
{service_name="django"} | json | __error__!=""
```

A traceback arrives **one entry per line** unless the collector runs a multiline stage.

---

## Django Ninja request & exception logging

**Call-site examples, not shipped code.** Nothing declares the `api` logger, and root is `WARNING`
in staging and production, so the `INFO` lines below appear there only once a project declares
`"api": {"level": "INFO"}` in each environment's `LOGGING` (propagating to root, so the filter and
formatter still apply). They use the allowlisted keys — `status_code`, not `status` — and `path`
is an extra that minimal mode **drops off dev**.

### Request timing middleware (`apps/core/middleware.py`)

```python
import logging
import time

logger = logging.getLogger("api")


class RequestLogMiddleware:
    """Log one line per /api/ request with method, status and duration."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if not request.path.startswith("/api/"):
            return self.get_response(request)
        start = time.perf_counter()
        response = self.get_response(request)
        logger.info(
            "api request",
            extra={
                "method": request.method,
                "status_code": response.status_code,
                "duration_ms": round((time.perf_counter() - start) * 1000),
                "path": request.path,  # dev only — dropped by the minimal formatter
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
> gets are owned by [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) Section _The error taxonomy_. This
> section is one of that taxonomy's consequences — the wiring, not the rule.
>
> **Nor is the response body.** The error envelope, the `error.code` vocabulary and the full set of
> six handlers belong to
> [`../api-design/AUTH-AND-ERRORS.md`](../api-design/AUTH-AND-ERRORS.md) Section _The error
> envelope_. The examples below show **where the logging call goes** and elide the body for that
> reason — they returned a competing `{"detail": ...}` shape until 14/08/2026, and nobody looked for
> an API contract in a logging guide.

```python
import logging

from ninja import NinjaAPI
from ninja.errors import ValidationError

logger = logging.getLogger("api")

api = NinjaAPI(title="<%PROJECT_NAME%> API", docs_url="/api/docs")


@api.exception_handler(ValidationError)
def on_validation_error(request, exc):
    logger.info("api validation error", extra={"status_code": 422, "method": request.method})
    return api.create_response(request, VALIDATION_ENVELOPE, status=422)  # AUTH-AND-ERRORS.md


@api.exception_handler(Exception)
def on_unhandled(request, exc):
    logger.error("api request failed", exc_info=True, extra={"status_code": 500})
    return api.create_response(request, INTERNAL_ENVELOPE, status=500)  # AUTH-AND-ERRORS.md
```

> Ninja auto-generates the OpenAPI schema and Swagger UI at `/api/docs`. Every state-changing
> endpoint carries its own explicit permission check (OWASP A01); logging never substitutes for it.

_Part of the `code/docs/` documentation family. See [`../LOGGING.md`](../LOGGING.md) for the full index._
