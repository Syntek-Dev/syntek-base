---
workflow: 09-debugging-with-logs
phase: verify
skills: [bugfix, stack-django]
model: opus
---

# Workflow 09 — Checklist: Debugging with Logs and Observability

Complete this checklist before closing a debugging session.

## Root cause

- [ ] Root cause is identified and understood (not just the symptom) · _opus_
- [ ] The trigger — user action, data condition, or external dependency — is known · _opus_

## Staging / prod incidents (skip for local-only bugs)

The reference deployment runs Grafana Alloy shipping logs to Loki, queried with LogQL in
Grafana, and Prometheus for metrics (`how-to/src/PLATFORM-PROVIDERS.md`).

- [ ] Bug report filed in `project-management/src/21-BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md` · _opus_
- [ ] <%ERROR_TRACKING%> issue marked as **resolved** after fix is deployed · _opus_
- [ ] Error rate in Grafana has returned to pre-incident baseline · _opus_
- [ ] No new related errors appeared in <%ERROR_TRACKING%> within 30 minutes of deployment · _opus_

## Documentation (if the bug revealed a gap)

- [ ] If a logging statement was missing: it is named in the handoff to `code/workflows/10-debug/`, which adds it · _opus_
- [ ] If an observability gap was found: noted in `code/docs/logging/OBSERVABILITY.md` or raised as a story · _opus_

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (logging/DJANGO-LOGGING.md, logging/FRONTEND-LOGGING.md, logging/OBSERVABILITY.md) for supporting references.

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Committed and pushed
