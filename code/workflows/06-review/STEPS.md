# Code Review — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Prerequisites

- [ ] Tests green
- [ ] Linters clean

---

## Steps

### Step 1 — Code Review

Run the code review agent across the scope being reviewed.

```text
/syntek-dev-suite:review [scope — file, app, or feature]
```

Address all findings before proceeding.

### Step 2 — Security Check

Run the security agent to verify OWASP compliance on the same scope.

```text
/syntek-dev-suite:security [scope]
```

Address all critical and high findings. Document any accepted lower-severity risks.

### Step 3 — QA Verification

```text
/syntek-dev-suite:qa-tester [scope]
```

Confirm no regressions and that acceptance criteria are met.

### Step 4 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
