# project-management/src/10-SECURITY/VULNERABILITIES/PLANNING

Pre-implementation vulnerability findings — **one per Critical/High vulnerability**, each
tied to a user story. A finding here is a sprint blocker: it names the threat, classifies
it against the three frameworks, and lists the controls the remediation story must ship
before the vulnerable code can proceed.

## Directory Tree

```text
project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/
├── CONTEXT.md                       ← this file
├── CLAUDE.md                        ← operating rules for this folder
├── VULN-PLAN-US000-TEMPLATE.md      ← copy this to raise a story's vulnerability finding
└── VULN-PLAN-US###-<DESCRIPTOR>.md  ← one finding per Critical/High vulnerability
```

## How it works

A finding is tied to a story, mirroring its closure counterpart in `../IMPLEMENTATION/`.
Copy `VULN-PLAN-US000-TEMPLATE.md` to `VULN-PLAN-US###-<DESCRIPTOR>.md` and complete it:
the classification (severity + STRIDE + OWASP + NIST CSF), the description and broken
invariant, the affected code, a safe (non-working) proof of concept, the required
controls, and remediation ownership. Those controls are then closed — with code evidence
— in the matching `../IMPLEMENTATION/VULN-IMPL-US###-*.md` record.

Each finding originates in a sibling category — a planning-phase audit under
`../../AUDITS/PLANNING/` or a threat model under `../../THREAT-MODEL/PLANNING/` — and is
referenced from the posture assessment under `../../ASSESSMENTS/PLANNING/`.

## When to write one

- When a planning-phase audit or threat model raises a Critical or High finding
- When running `project-management/workflows/10-security-checks/`, before sprint planning
- Whenever a Critical/High vulnerability is discovered against a story's design

Status is **Open — sprint blocker**: a remediation `US###` must be in the sprint plan
before the vulnerable code proceeds. Lower-severity items stay in the originating audit.

## Cross-references

- `VULN-PLAN-US000-TEMPLATE.md` — the per-story finding template
- `../IMPLEMENTATION/` — the closure records that answer these findings
- `../CONTEXT.md` — the VULNERABILITIES overview and the three frameworks
- `../../AUDITS/PLANNING/` · `../../THREAT-MODEL/PLANNING/` — where findings originate
- `../../ASSESSMENTS/PLANNING/` — the assessment that references these findings
- `project-management/docs/SECURITY-GUIDE.md` — the governing STRIDE / OWASP / NIST guide
- `project-management/workflows/10-security-checks/` — the workflow that produces these

**Last Updated**: <%DATE%>
