# Security Hardening — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Security Review

```text
/syntek-dev-suite:security [scope to review]
```

### Step 2 — Address Findings

Address all findings from the security agent in severity order (critical first).
Commit after each group of fixes.

### Step 3 — QA Verification

```text
/syntek-dev-suite:qa-tester [verify security fixes]
```

### Step 4 — Log Audit

Save a security audit summary to `project-management/src/SECURITY/AUDITS/`.

### Step 5 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
