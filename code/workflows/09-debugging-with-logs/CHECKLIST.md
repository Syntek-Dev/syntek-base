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

## Regression test

- [ ] A failing test has been written that reproduces the bug before the fix · _opus_
- [ ] The test passes after the fix is applied · _opus_
- [ ] The test is committed alongside the fix (not in a separate PR) · _opus_

## Code fix

- [ ] Fix addresses the root cause, not just the symptom · _opus_
- [ ] No unrelated changes are bundled in the same commit · _opus_
- [ ] Linting and type-checking pass (`code/src/scripts/syntax/lint.sh`, `syntax/check.sh`) · _opus_

## Staging / prod incidents (skip for local-only bugs)

- [ ] Bug report filed in `project-management/src/20-BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md` · _opus_
- [ ] Glitchtip issue marked as **resolved** after fix is deployed · _opus_
- [ ] Error rate in Grafana has returned to pre-incident baseline · _opus_
- [ ] No new related errors appeared in Glitchtip within 30 minutes of deployment · _opus_

## Documentation (if the bug revealed a gap)

- [ ] If a logging statement was missing: it has been added at the correct level · _opus_
- [ ] If an observability gap was found: noted in `code/docs/logging/OBSERVABILITY.md` or raised as a story · _opus_

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (logging/DJANGO-LOGGING.md, logging/FRONTEND-LOGGING.md, logging/OBSERVABILITY.md) · **External — Testing** for supporting references.

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Committed and pushed
