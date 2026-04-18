# Refactor — Checklist

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Pre-Conditions

- [ ] Tests green before starting
- [ ] No behaviour changes included — bugs fixed separately in `code/workflows/07-debug/`

---

## Execution Checklist

- [ ] All functions have a single, clear purpose
- [ ] No file exceeds 750 lines
- [ ] Business logic is in service classes, not resolvers
- [ ] No inline imports without a documented reason
- [ ] All tests still pass after refactoring
- [ ] Coverage not reduced
- [ ] No new linter warnings introduced

---

## Definition of Done

- [ ] Behaviour is identical to before the refactor — verified by passing tests
- [ ] Refactoring notes saved to `project-management/src/REFACTORING/` if the change is significant
- [ ] Committed and pushed
