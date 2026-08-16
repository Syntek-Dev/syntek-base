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
- `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md` — the branch promotion chain and its gate per step
- `project-management/docs/git/MIGRATION-GATES.md` — the staging verification a risky migration must pass before `staging → main`

### Related reading

- `code/docs/security/OWASP-AND-CHECKLIST.md` — pre-release security checklist (DB13, DB16 gates)
- `how-to/src/STORE-LISTING.md` · `code/docs/discoverability/APP-STORE.md` — **mobile-only** — the
  store-listing register and the rule behind it. Step 2 reaches them only when the release bumped
  `code/src/mobile/`; on a web-only project that condition never holds and both files are absent
