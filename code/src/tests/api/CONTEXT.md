# tests/api — Bruno API Test Collection

**Last Updated**: <%DATE%>
**Version**: 0.1.0
**Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Directory Structure

```text
api/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── bruno.json              # Bruno collection config: name, version, ignore patterns
├── environments/           # per-environment variable files (host, docker, local, staging, production)
└── health/                 ← liveness + readiness contract; the one folder not under /api/
```

**`health/` is the only folder at baseline.** The Django project serves no API — there is no
`NinjaAPI` and no router — so there is nothing under `/api/` to assert against yet. The two
health probes are the exception on purpose: they are plain Django views mounted at the root
so they answer when `/api/` does not exist or cannot respond, and they have consumers outside
this repository. Domain folders appear beside it as endpoints ship, one folder per domain
(`auth/`, `users/`, …).

`code/src/scripts/tests/api.sh` counts the requests before it starts anything, so the run is a
real one from the first folder onwards rather than the stated no-op it used to be.

> The annotated request template lives one level up at `../template-test.bru`, **outside**
> the collection root. The Bruno CLI runs the collection recursively, so any `.bru` inside
> `api/` executes — a placeholder kept here would run and fail. Copy it into the right
> folder and rename when adding a request.

---

## Purpose

Bruno API testing collection for the <%PROJECT_NAME%> Django Ninja API. Run against a live
backend to verify endpoint contracts, auth flows, and performance thresholds.

All requests target the Django Ninja API at `{{api_url}}/api/` — bar `health/`, which targets
`{{api_url}}` directly because the probes are root-mounted by contract
(`code/docs/logging/HEALTH-CONTRACT.md`).

- **Host runner (default)**: the `host` environment — the test stack's nginx on `:83`
- **CI / inside the Docker network**: the `docker` environment (`http://django-test:8000`)
- **Local dev**: the `local` environment — the dev stack's nginx (`http://dev.<%PROJECT_SLUG%>.localhost:81`)
- **Staging / production checks**: the `staging` and `production` environments

---

## Adding the first requests

1. Build the endpoint first, and confirm it in the OpenAPI schema at `/api/docs`.
2. Create the domain folder (`kebab-case/`) with its `CONTEXT.md` + `CLAUDE.md` pair.
3. Copy `../template-test.bru` in, rename it `snake_case.bru`, and set its `seq`.
4. Run the folder, then the whole suite:

```bash
# Whole collection against the Docker test stack
bash code/src/scripts/tests/api.sh

# Single folder
bash code/src/scripts/tests/api.sh --folder auth

# Against staging
bash code/src/scripts/tests/api.sh --env staging

# With JSON reporter (CI)
bash code/src/scripts/tests/api.sh --env docker --output reports/api
```

Requests needing an authenticated caller also need a fixture-user seed command
(`seed_api_test_user`); `api.sh` skips seeding, with a warning, while none is registered.

---

## Notes

- Parent: `../CONTEXT.md`
- Bruno collection format: plain `.bru` files, human-readable and version-control-friendly
- Never commit real credentials — use Bruno's secret variable feature or inject via CI
- The CLI does **not** honour `bruno.json`'s `ignore` list — tag environment-dependent or
  destructive requests (`wip`, `manual`) and exclude them with `--exclude-tags`
- All endpoints must be verified against the live Django Ninja OpenAPI schema before
  committing new `.bru` files
