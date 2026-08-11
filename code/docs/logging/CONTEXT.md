# code/docs/logging

Sub-documents for logging and observability. Covers Django logging configuration, browser logging
via the Sentry SDK, the observability stack, the health/metrics deploy contract, and Cloudinary
media logging.

## Directory Tree

```text
code/docs/logging/
├── CLAUDE.md           ← operating rules
├── CONTEXT.md          ← this file
├── DJANGO-LOGGING.md   ← Django logging configuration and Django Ninja request/exception logging
├── FRONTEND-LOGGING.md ← Browser logging via the Sentry SDK + project logger
├── OBSERVABILITY.md    ← The four observability interfaces — error tracking, log aggregation, metrics, traces
├── HEALTH-CONTRACT.md  ← Health endpoints + uptime-probe/metrics-scrape contract (app ↔ deploy repo)
└── CLOUDINARY.md       ← Cloudinary file and media storage configuration
```

## Cross-references

- `code/docs/LOGGING.md` — the index these sub-documents belong to
