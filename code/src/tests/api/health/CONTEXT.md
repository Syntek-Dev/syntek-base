# tests/api/health — Liveness and Readiness Contract

The first folder in this collection, and the one that breaks its rule: every other domain here
targets `{{api_url}}/api/`, while these two requests sit at the **root**. That is not an
oversight — `apps.health` mounts at `/health/` deliberately, so the probes answer while the API
surface is unwired, unreachable, or itself the thing that is broken.

## Directory Tree

```text
code/src/tests/api/health/
├── CONTEXT.md      ← this file
├── CLAUDE.md       ← operating rules
├── liveness.bru    ← GET /health/ — seq 1
└── readiness.bru   ← GET /health/ready/ — seq 2
```

## What each request pins

| Request         | Endpoint         | Pins                                                                    |
| --------------- | ---------------- | ----------------------------------------------------------------------- |
| `liveness.bru`  | `/health/`       | `200`, the literal body `ok`, `text/plain`, and that it is never cached |
| `readiness.bru` | `/health/ready/` | The status code pair, the one-key body, and the three permitted words   |

## Why the assertions are shaped this way

These endpoints have **consumers outside this repository** — the `HEALTHCHECK` in every
Dockerfile and the deploy repository's uptime probe, which keys on `status == operational`. So
the requests assert the **contract** rather than the current reading:

- **The body has exactly one key.** A component breakdown, a version or a hostname appearing here
  is an information leak on an unauthenticated endpoint, and this assertion is what catches it.
- **`503` accompanies `down` and only `down`.** `degraded` is a `200` on purpose; a change that
  made it a `503` would take a public status page red for a cache fault users cannot see.
- **The three words are enumerated.** Adding a fourth is a contract change, and it should fail
  here before it reaches a probe nobody in this repository can see.

`readiness.bru` also asserts the stack under test is `operational`. That one is a health check on
the test environment rather than on the contract — if it fails alone while the others pass, the
suite is telling you about the stack, not about the code.

## Cross-references

- `code/docs/logging/HEALTH-CONTRACT.md` — the contract these requests pin
- `code/src/django/apps/health/CONTEXT.md` — the app implementing it
- `code/src/django/apps/health/tests/test_endpoints.py` — the same contract asserted in-process
- `how-to/docs/HEALTH-PROBES.md` — what an operator does when one of these goes red

**Last Updated**: <%DATE%>
