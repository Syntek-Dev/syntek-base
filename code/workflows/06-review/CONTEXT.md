# Workflow: Code Review

> **Agent hints — Model:** Opus · **MCP:** `code-review-graph`

## Directory Tree

```text
code/workflows/06-review/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when performing a code quality review before raising a PR. This
covers the _content_ of the code — security, patterns, coverage, and coding principles.
For the PR merge process (branch promotion, approvals, gates) use
`project-management/workflows/16-pr-and-review/`.

## Prerequisites

- [ ] TDD cycle complete — tests are green
- [ ] Linters are clean (`ruff`, ESLint, markdownlint)
- [ ] No known outstanding bugs on this scope

## Key concepts

- OWASP A01–A10 are the security baseline — all must be addressed before a PR is raised
- NIST SP 800-63B governs authentication, password policy, and MFA requirements
- Every mutation must verify authentication and permissions explicitly via named Policy classes
- User-supplied IDs must be validated against caller ownership (no IDOR)
- Coverage floors: 75% backend (90% auth), 70% frontend
- No hardcoded secrets, no bare `except:`, no inline imports without documentation

## Cross-references

- `code/docs/CODING-PRINCIPLES.md` — coding rules and style
- `code/docs/SECURITY.md` — OWASP A01–A10 and NIST SP 800-63B, permission and IDOR requirements
- `code/docs/TESTING.md` — coverage floors and test philosophy
- `project-management/workflows/16-pr-and-review/` — the subsequent PR merge workflow
