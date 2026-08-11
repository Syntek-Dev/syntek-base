# Workflow: PR and Code Review

**Last Updated**: <%DATE%>

This workflow owns the process — promotion, approvals, merge gates — and deliberately not
the content, which `code/workflows/07-review/` already reviewed. Two different failures, two
different checks.

## Directory Tree

```text
project-management/workflows/22-pr-and-review/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when a feature branch is complete and ready to be reviewed
and merged through the branch promotion chain.

## Cross-references

### Governing documents

- `project-management/docs/GIT-GUIDE.md` — branch promotion chain gates are blocking; read before raising any PR

### Upstream — the code-layer counterpart

- `code/workflows/07-review/` — reviews the **content** of the change (security, patterns,
  coverage, coding principles) and must be signed off before this workflow runs. This workflow
  owns the **process**: branch promotion, approvals, merge gates. Content there, process here —
  do not duplicate either side's checklist.
- `code/workflows/08-security-hardening/` — where any security finding raised in review is fixed.

### Related reading

- `project-management/docs/VERSIONING-GUIDE.md` — version bump rules if this PR completes a release
- `project-management/docs/GDPR-GUIDE.md` — for completing GDPR implementation records
- `project-management/src/09-GDPR/` — GDPR implementation record destination
- `project-management/src/10-SECURITY/` — security implementation record destination
- `project-management/src/11-QA/` — QA implementation record destination
- `code/docs/CODING-PRINCIPLES.md` — review checklist: file length, single-purpose functions, error handling (thin index)
- `code/docs/SECURITY.md` — OWASP A01–A10 review points, permission checks, IDOR prevention (thin index)
- `code/docs/security/OWASP-AND-CHECKLIST.md` — OWASP checklist for PR security review
- `code/docs/testing/COVERAGE.md` — coverage floor verification (75% line and branch / 90% auth — one floor, not one per layer)
