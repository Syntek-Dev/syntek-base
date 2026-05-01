# Workflow 10 — Checklist: Debugging with Logs and Observability

Complete this checklist before closing a debugging session.

## Root cause

- [ ] Root cause is identified and understood (not just the symptom)
- [ ] The trigger — user action, data condition, or external dependency — is known

## Regression test

- [ ] A failing test has been written that reproduces the bug before the fix
- [ ] The test passes after the fix is applied
- [ ] The test is committed alongside the fix (not in a separate PR)

## Code fix

- [ ] Fix addresses the root cause, not just the symptom
- [ ] No unrelated changes are bundled in the same commit
- [ ] Linting and type-checking pass (`code/src/scripts/lint.sh`, `check.sh`)

## Staging / prod incidents (skip for local-only bugs)

- [ ] Bug report filed in `project-management/src/15-BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md`
- [ ] Glitchtip issue marked as **resolved** after fix is deployed
- [ ] Error rate in Grafana has returned to pre-incident baseline
- [ ] No new related errors appeared in Glitchtip within 30 minutes of deployment

## Documentation (if the bug revealed a gap)

- [ ] If a logging statement was missing: it has been added at the correct level
- [ ] If an observability gap was found: noted in `code/docs/LOGGING.md` or raised as a story
