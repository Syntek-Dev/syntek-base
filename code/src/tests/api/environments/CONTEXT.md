# api/environments

**Last Updated**: {{DATE}}
**Version**: 0.1.0
**Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Directory Structure

```text
environments/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules
├── host.bru          # Bruno env config (native .bru format) — test stack via nginx
├── host.json         # Test nginx on 127.0.0.1:83 — api.sh default (Bruno runs on the host)
├── docker.bru        # Bruno env config (native .bru format) — Docker test stack
├── docker.json       # Docker test stack (http://django-test:8000) — CI default
├── local.bru         # Bruno env config (native .bru format) — local dev
├── local.json        # Local dev (http://localhost:8000) — Bruno desktop app
├── production.bru    # Bruno env config (native .bru format) — production
├── production.json   # Production environment variables
├── staging.bru       # Bruno env config (native .bru format) — staging
├── staging.json      # Staging environment variables
└── variables.json    # Shared runtime variable definitions
```

Every environment defines the same three keys — `api_url`, `timeout_ms`,
`slow_threshold_ms` — and nothing else. A variable that only one suite needs belongs in
`variables.json` (runtime, injected) rather than baked into all five files.

---

## Purpose

Bruno environment configuration files. Each file sets `api_url` and shared thresholds.
Credentials are never stored here — inject via Bruno's secret panel or CI environment variables.

---

## Notes

- Parent: `../CONTEXT.md`
- `host.json` — `api.sh`'s default: Bruno runs on the host and reaches the test stack
  through its published nginx port (`127.0.0.1:83`)
- `docker.json` — the `test-api.yml` CI default, for running inside the Docker network
  (`django-test` is the hostname there)
- `local.json` — use in the Bruno desktop app against a running dev stack
- `staging.bru` / `production.bru` — resolved from `{{PRIMARY_DOMAIN}}` at instantiation
- `variables.json` — runtime variables with no committed value (currently `auth_token`,
  populated by the login request). Credentials are injected per-run with the `BRUNO_VAR_`
  prefix (e.g. `BRUNO_VAR_test_password`), never stored here
- **Keep the `.bru` and `.json` pair for an environment identical** — Bruno's desktop app
  and the CLI read different formats, and a drifted pair points two runners at two URLs
