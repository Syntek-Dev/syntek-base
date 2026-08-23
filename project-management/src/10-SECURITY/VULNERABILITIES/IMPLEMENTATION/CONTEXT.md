# project-management/src/10-SECURITY/VULNERABILITIES/IMPLEMENTATION

Post-implementation vulnerability closures — **one per Critical/High vulnerability**, each
tied to a user story. A closure proves, with code evidence, that a finding raised in
`../PLANNING/` has been fixed and verified, and flips that finding to Resolved.

## Directory Tree

```text
project-management/src/10-SECURITY/VULNERABILITIES/IMPLEMENTATION/
├── CONTEXT.md                                 ← this file
├── CLAUDE.md                                  ← operating rules for this folder
├── VULN-IMPL-US000-TEMPLATE.md                ← copy this to close a story's vulnerability
└── VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md ← one closure per resolved vulnerability
```

## When to create a file here

Write a closure during `project-management/workflows/22-implementation-documentation/` once the
remediation story ships. Copy `VULN-IMPL-US000-TEMPLATE.md`, open the finding in
`../PLANNING/VULN-PLAN-US###-*.md`, and document how each planned control was met.

## What belongs in each closure

- Story reference (US###), date, and a link to the pre-implementation finding
- The classification carried unchanged from the plan (severity + STRIDE + OWASP + NIST)
- A restatement of the original finding
- Each control from the plan closed **with a code reference** (or Deferred with an owner)
- The verification — named tests or manual steps proving the exploit path is closed
- Residual / accepted risk and its owner, and any justified deviation from the plan
- Resolved-in — the PR number or commit SHA that fixed it

## Cross-references

- `VULN-IMPL-US000-TEMPLATE.md` — the per-story closure template
- `../PLANNING/` — the pre-implementation findings these closures answer
- `../CONTEXT.md` — the VULNERABILITIES overview and the three frameworks
- `../../ASSESSMENTS/IMPLEMENTATION/` · `../../AUDITS/IMPLEMENTATION/` — the sibling
  categories that reference these closures
- `code/docs/SECURITY.md` — the code-side enforcement these closures track
- `project-management/workflows/22-implementation-documentation/` — where these closures are written

**Last Updated**: <%DATE%>
