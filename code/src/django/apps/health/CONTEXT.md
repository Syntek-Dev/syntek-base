# apps/health — Liveness and Readiness

The second app the template ships, and the only one whose consumers live outside this
repository: the container `HEALTHCHECK` in every Dockerfile, and the deploy repository's
uptime probe behind the public status page. It owns **no models** and no domain concepts —
it answers two questions about the process and its dependencies, and nothing else.

**Last Updated**: <%DATE%>

## Directory Tree

```text
apps/health/
├── __init__.py       ← package marker
├── apps.py           ← HealthConfig — registered as `apps.health`
├── checks.py         ← the dependency probes and the aggregation rule
├── urls.py           ← /health/ and /health/ready/ — a fixed prefix, not a setting
├── views.py          ← liveness and readiness — plain Django views, not Ninja
├── tests/            ← the suite: the rule in isolation, then the contract over HTTP
│   ├── unit/test_checks.py   ← the aggregation rule and probe containment (no DB)
│   └── test_endpoints.py     ← the wire contract, against a real database
├── CONTEXT.md        ← this file
└── CLAUDE.md         ← operating rules
```

No `models/`, no `migrations/` — for the same reason `core` has none. Both arrive with the
first model, and an empty migrations package on a model-less app is scaffolding that has to
be explained.

## The two endpoints

| Endpoint             | Answers            | Codes       | Touches            |
| -------------------- | ------------------ | ----------- | ------------------ |
| `GET /health/`       | Is the process up? | `200`       | Nothing            |
| `GET /health/ready/` | Can it serve?      | `200`/`503` | PostgreSQL, Valkey |

Both are public and neither is cacheable at the HTTP layer. The shapes, the status codes
and the three status words are decided in `code/docs/logging/HEALTH-CONTRACT.md` — this app
implements that contract and does not re-decide it.

**Liveness deliberately touches no dependency.** An orchestrator restarting a container
because PostgreSQL was briefly unreachable turns a database blip into a rolling outage.
Taking a pod out of service is readiness's job, and it does that without killing anything.

## What is here, and why each thing is here

| Module      | Why it exists                                                                                                                            |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `checks.py` | One probe per dependency plus the aggregation rule. Criticality lives on the dependency, so a new probe arrives without editing the rule |
| `views.py`  | Maps a status to a status code and serialises one field. Holds no judgement about what "ready" means                                     |
| `urls.py`   | The prefix is fixed rather than configurable, unlike `DJANGO_ADMIN_PATH` — it is a contract with consumers this repository cannot see    |

`Component` names only `DATABASE` and `CACHE`. The contract also lists the Ninja API and a
set of curated pages; neither surface is wired at baseline, and **a probe that always passes
is worse than no probe**, because it reports health it never measured. Each arrives with the
surface it measures.

## Configuration

| Setting                    | Default | Purpose                                                |
| -------------------------- | ------- | ------------------------------------------------------ |
| `HEALTH_CACHE_TTL_SECONDS` | `15`    | How long `/health/ready/` may serve a memoised verdict |

## Cross-references

- `code/docs/logging/HEALTH-CONTRACT.md` — the contract this app implements, and what the
  deploy repository must provision against it
- `code/src/docker/CONTEXT.md` — the container healthchecks that probe `/health/`
- `code/docs/URL-STRATEGY.md` — route naming and why the admin prefix moves but this one does not
