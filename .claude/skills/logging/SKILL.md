---
name: logging
description: >-
  Instrument <%PROJECT_NAME%> with structured logging and observability — Django `LOGGING`
  config and module loggers, error tracking, log aggregation and metrics, and closing off
  sensitive-data leakage into any of them. Load when log instrumentation has to be added, a
  channel configured, or a leak stopped. Not root-causing a fault from the logs once they exist
  (`bugfix`), not ruling on whether a field is sensitive (`security`), not testing log behaviour
  (`test-writer`), and not wiring collector endpoints into a pipeline (`cicd`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-django
---

# Instrument Logging and Observability (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable instrumentation task whose output is logger
calls and configuration).

> **Status: declared, not wired.** `sentry-sdk[django]` and `django-prometheus` are declared
> dependencies with **no call site**. Check `code/docs/logging/OBSERVABILITY.md` before
> assuming any of it is running.

**There is no Node server, so there is no Node logger.** Browser errors are captured by the
Sentry browser SDK and reach the tracker — never the log pipeline.

---

## The brief arrives settled

A fork cannot ask, so the brief must name **which events at which levels**, **the channel per
environment** (file, error tracker, log pipeline, metrics), **the PII-redaction rules for the
fields in scope**, and **the retention expected**. Where those are open, that is a `grilling`
pass run inline first.

## Three interfaces, and the product behind each is a per-project answer

The code is written against an **interface**; which product implements it is configuration, and
**never something to assume**:

| Capability      | The interface the code targets                     |
| --------------- | -------------------------------------------------- |
| Error tracking  | the **Sentry SDK wire protocol** (`sentry-sdk`)    |
| Log aggregation | **structured JSON on stdout** (12-factor)          |
| Metrics         | the **Prometheus exposition format** / OpenMetrics |

**"Sentry" is a valid answer for the first row, not a banned one** — the register lists it as a
proven alternate. The per-environment matrix is `code/docs/LOGGING.md` Section _Stack by
environment_; the verdicts and alternates are `how-to/src/PLATFORM-PROVIDERS.md`; the rule is
`code/docs/architecture/PROVIDER-NEUTRALITY.md`. **Read them rather than restating them — a
restatement here is exactly how this section was wrong before.**

## How to work

1. **Check for an existing logger setup before adding one.** A parallel config is worse than no
   config, because the one that loses is silent.
2. **Backend** — the module logger (`logging.getLogger(__name__)`), never `print`. Emit
   structured extras; never string-format a value into the message. Levels and handlers live in
   Django `LOGGING` per `code/docs/logging/DJANGO-LOGGING.md`.
3. **Error tracking and metrics are staging and production only** — gate them by environment.
   DSNs and endpoints come from environment variables, **named for the interface**
   (`SENTRY_DSN`, because the SDK's own convention names the protocol), never for the product.
4. **Health signals are load-bearing.** The gate-trigger measurements the scaling phase-gates
   key to — read p95, primary CPU and IO — must actually be observable
   (`code/docs/logging/HEALTH-CONTRACT.md`).
5. **Verify** by exercising the affected path and reading the result
   (`bash code/src/scripts/development/logs.sh`, dev and test only), confirming no sensitive
   field appears. Hand the tests to `test-writer`.

## Guardrails

- **Never log** a password, token, session ID, API key, card or financial datum, or PII —
  unless a documented audit requirement demands it, and then masked. **When in doubt the ruling
  is `security`'s, not this skill's.**
- **Structured over interpolated** — context goes in fields, not baked into the message string.
  An interpolated value cannot be redacted downstream.
- All DSNs, endpoints and secrets via environment variables; `.env.*.example` carries names
  only.
- `DEBUG=False` outside local, and debug-level logging is never enabled in production.
- Messages in British English; timestamps <%TIMEZONE%>.

## Definition of done

The instrumentation reaches the configured channel for the environment it runs in; nothing
sensitive appears in any of them; no parallel logging config was created; every DSN and
endpoint is an environment variable named for its interface; the touched `CONTEXT.md` updated.

## Handoff

Report the events instrumented and at what level, the configuration changed, and every new
environment variable by name. Then name what is owed: `qa-tester` to confirm nothing sensitive
reaches the logs, `cicd` to set the tracker and collector configuration in the staging and
production pipelines, `test-writer` for tests over log behaviour, `security` for a ruling on a
field whose sensitivity is genuinely arguable, and `doc-writer` where usage documentation needs
updating.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/09-debugging-with-logs/` — the observability procedure
- `how-to/workflows/08-debugging/` — when the stack itself is unhealthy rather than the code

## Cross-references

- `code/docs/LOGGING.md` — the index; then the sub-doc for the layer being touched
- `code/docs/logging/DJANGO-LOGGING.md` — the `LOGGING` config, request logging, the levels
- `code/docs/logging/OBSERVABILITY.md` — the three interfaces, pipeline, retention, dashboards
- `code/docs/logging/HEALTH-CONTRACT.md` — the signals the scaling phase-gates key to
- `how-to/docs/HEALTH-PROBES.md` — the operator's half of that contract: reading a red probe, and the memo that can hide an outage for one TTL
- `code/docs/security/MONITORING-AND-INCIDENT.md` — the sensitive-data rules this enforces
- `code/docs/security/AUDIT-TRAIL.md` — the audit record, which is not the log pipeline
- `.claude/plugins/log-tool.py` · `.claude/plugins/env-tool.py` — read-only orientation
