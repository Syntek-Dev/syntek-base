@./CONTEXT.md

# CLAUDE.md — apps/health/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the two endpoints and what each module is for — imported above) → this file →
`code/docs/logging/HEALTH-CONTRACT.md`, which is the contract, not a suggestion.

## Purpose (one line)

Liveness and readiness for the web deployable — the only app whose consumers are outside
this repository.

## How to work here

- **Routing:** backend work → `stack-django` skill (Opus); anything touching what the
  endpoints publish → the `logging` skill, because `HEALTH-CONTRACT.md` is its document.
  A change to a status code, a path or a status word is a **contract change** and opens with
  a grilling pass (`.claude/skills/grill-with-docs`), never a direct edit.
- **Model:** Opus.
- **Concrete steps:** add the probe to `checks.py` with its `Criticality` → add its row to
  `PROBES` → cover it in `tests/unit/test_checks.py` → run
  `code/src/scripts/tests/backend-coverage.sh` → update `HEALTH-CONTRACT.md` in the **same
  change** if what is published moved.
- **Definition of done:** the aggregation rule untouched by the new probe; the endpoint
  tests still assert the wire contract; `HEALTH-CONTRACT.md` and this app say the same thing.

## Guardrails

- **`/health/` touches no dependency, ever.** It answers whether the process is up. Adding a
  database query here makes a container restart the response to a database blip, which turns
  one outage into a rolling one.
- **The readiness body carries the overall status and nothing else.** No component
  breakdown, no versions, no hostnames — the endpoint is unauthenticated, so anything more
  is reconnaissance. The per-component detail is the admin surface's, behind `health.view`.
- **`503` is for `down` only.** `degraded` returns `200` with a body that says `degraded`;
  the deploy repo's probe keys on `[BODY].status == operational` to catch it.
- **Never add a probe for a surface that is not wired.** A probe that cannot fail reports
  health it never measured, which is worse than the gap it appears to close.
- **The URL prefix is fixed.** Unlike `DJANGO_ADMIN_PATH`, it is consumed by every
  Dockerfile's `HEALTHCHECK` and by a repository this one cannot see. Moving it silently
  breaks both.
- This app owns **no models**. Adding one makes `health` a migration dependency of the
  project and needs a recorded decision first.

## Output & naming

- **Hand-written:** every `.py` here, and the tests.
- **Generated:** nothing.
- Modules `snake_case`; the app is registered as `apps.health`; documentation
  `SCREAMING-SNAKE-CASE.md`.
