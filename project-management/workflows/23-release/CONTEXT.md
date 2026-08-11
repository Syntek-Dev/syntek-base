# Workflow: Release

**Last Updated**: <%DATE%>

A release is the one operation where a mistake reaches users. The version, the changelog and
the deploy move together so that what shipped can always be identified afterwards.

## Directory Tree

```text
project-management/workflows/23-release/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when cutting a release — version bump, changelog update, and deployment.

## Cross-references

### Governing documents

- `project-management/docs/VERSIONING-GUIDE.md` — version bump rules and file checklist; must be followed exactly
- `project-management/docs/GIT-GUIDE.md` — branch promotion chain and staging verification gates

### Related reading

- `code/docs/security/OWASP-AND-CHECKLIST.md` — pre-release security checklist (DB13, DB16 gates)
