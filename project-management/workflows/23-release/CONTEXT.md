# Workflow: Release

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/23-release/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when cutting a release — version bump, changelog update, and deployment.

## Prerequisites

- [ ] Staging branch is green and accepted
- [ ] All stories for this release are marked complete
- [ ] Changelog entries are up to date

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/VERSIONING-GUIDE.md` — version bump rules and file checklist; must be followed exactly
- `project-management/docs/GIT-GUIDE.md` — branch promotion chain and staging verification gates

### Soft references — consult during execution

- `code/docs/security/OWASP-AND-CHECKLIST.md` — pre-release security checklist (DB13, DB16 gates)
