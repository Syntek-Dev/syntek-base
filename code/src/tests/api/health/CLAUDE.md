@./CONTEXT.md

# CLAUDE.md — tests/api/health/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the two requests and why each assertion exists — imported above) → this file →
`code/docs/logging/HEALTH-CONTRACT.md`, which is the contract these requests pin.

## Purpose (one line)

The HTTP-layer contract tests for `/health/` and `/health/ready/` — the only endpoints in this
repository with consumers outside it.

## How to work here

- **Routing:** run through `code/src/scripts/tests/api.sh --folder health` — never the Bruno
  CLI, `pnpm`, or `docker` directly. A change to what these assert is a **contract change** and
  opens with a grilling pass (`.claude/skills/grill-with-docs`), routed by the `logging` skill,
  because `HEALTH-CONTRACT.md` is its document.
- **Model:** Opus.
- **Concrete steps:** change `apps/health` and `HEALTH-CONTRACT.md` together → update these
  requests in the same change → run `api.sh --folder health` → run
  `code/src/scripts/tests/backend.sh` so the in-process suite agrees.
- **Definition of done:** these requests, `apps/health/tests/test_endpoints.py`, and
  `HEALTH-CONTRACT.md` all say the same thing about codes, body shape and status words.

## Guardrails

- **Assert the contract, not today's reading.** Pin the status-code pair, the one-key body and
  the enumerated words. A request that only checks `status == "operational"` passes on a healthy
  stack and notices nothing else.
- **Never assert a component breakdown.** The body carries the overall word alone because the
  endpoint is unauthenticated; a test expecting more would lock in an information leak.
- **The URL is `{{api_url}}/health/`, not `{{api_url}}/api/health/`**, and that break from the
  sibling folders is deliberate — the prefix is fixed so probes answer when `/api/` cannot.
- **Do not add auth.** Both endpoints are public by contract; a bearer token here would test a
  surface that does not exist.
- **Keep `seq` stable** — liveness `1`, readiness `2`. Liveness failing first is the more useful
  signal, because readiness cannot be meaningful when the process is not up.

## Output & naming

- **Hand-written:** both `.bru` files, this file and `CONTEXT.md`.
- **Generated:** nothing here — `api.sh` writes its output to
  `code/src/scripts/tests/reports/api/`, which is gitignored.
- Requests `kebab-case.bru`; `meta.name` follows the collection's `"<Action> (<Context>)"` form.
