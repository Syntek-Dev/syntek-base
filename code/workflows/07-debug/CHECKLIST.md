# Debug — Checklist

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Pre-Conditions

- [ ] Bug is reproducible
- [ ] Failing test written that pins the bug (test must fail before the fix)

---

## Execution Checklist

- [ ] Root cause identified — not just the symptom
- [ ] Fix is minimal — no unrelated refactoring in the same commit
- [ ] Regression test passes after the fix
- [ ] All other existing tests still pass
- [ ] Coverage not reduced by the change

---

## Definition of Done

- [ ] Regression test committed alongside the fix
- [ ] Bug report in `project-management/src/15-BUGS/` updated or closed if one exists
- [ ] Committed and pushed
