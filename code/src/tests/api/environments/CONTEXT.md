# api/environments

**Last Updated**: 24/04/2026
**Version**: 1.0.0
**Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Directory Structure

```text
environments/
├── CONTEXT.md
├── local.json        # Local dev (http://localhost:8000) — Bruno desktop app
├── docker.json       # Docker test stack (http://backend-test:8000) — api.sh + CI
├── staging.json      # Staging environment variables
├── production.json   # Production environment variables
└── variables.json    # Shared variable definitions used across environments
```

---

## Purpose

Bruno environment configuration files. Fill in `api_url` and credentials for each environment before running the collection.

---

## Notes

- Parent: `../CONTEXT.md`
- `local.json` is pre-configured for `http://localhost:8000` — use in the Bruno desktop app against a running dev stack
- `docker.json` points to `http://backend-test:8000` — used by `api.sh` and the `test-api.yml` CI workflow (Bruno runs inside the Docker network)
- `staging.json` and `production.json`: update `api_url` to the project's deployed domain
- Never commit real credentials — use Bruno's secret variable feature or environment injection from CI
- `test_password` in `variables.json` is marked secret; set it in Bruno's environment panel, not in the file
