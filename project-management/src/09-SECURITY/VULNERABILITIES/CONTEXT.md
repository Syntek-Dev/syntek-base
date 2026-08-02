# project-management/src/09-SECURITY/VULNERABILITIES

Individual **Critical/High** vulnerability records, each tied to a user story. The base
repo ships this as a **per-story scaffold**: a `PLANNING/` template that captures a
sprint-blocking finding, and an `IMPLEMENTATION/` template that closes it with code
evidence once the fix ships. A project adds one plan + one closure per Critical/High
vulnerability it finds, mirroring the 08-GDPR split.

## Directory Tree

```text
project-management/src/09-SECURITY/VULNERABILITIES/
├── CONTEXT.md                       ← this file
├── CLAUDE.md                        ← operating rules for this folder
├── PLANNING/                        ← pre-implementation findings, one per vulnerability
│   ├── CONTEXT.md · CLAUDE.md
│   └── VULN-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/                  ← post-implementation closures, one per vulnerability
    ├── CONTEXT.md · CLAUDE.md
    └── VULN-IMPL-US000-TEMPLATE.md
```

## Frameworks

Every vulnerability record classifies the finding against three complementary frameworks,
plus a severity and a remediation status (guide: `../../../docs/SECURITY-GUIDE.md`):

| Framework        | Records                                          |
| ---------------- | ------------------------------------------------ |
| **STRIDE**       | The threat category (S/T/R/I/D/E)                |
| **OWASP Top 10** | The web-vulnerability class (A01–A10)            |
| **NIST CSF 2.0** | The risk-management function (GV/ID/PR/DE/RS/RC) |

Severity is **Critical / High** only — this folder tracks the sprint-blocking findings;
lower-severity items stay in the originating audit or assessment.

## PLANNING/ and IMPLEMENTATION/ — per story

A vulnerability is tied to a story at both ends: a **finding** before the fix and a
**closure** after, mirroring each other.

- `PLANNING/VULN-PLAN-US###-<DESCRIPTOR>.md` — the sprint-blocking finding for one story:
  classification, description, affected code, safe PoC, and the controls the remediation
  must implement. Status: **Open — sprint blocker**.
- `IMPLEMENTATION/VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` — the closure for that story,
  proving each control shipped with a code reference and named tests. Status: **Resolved**.

A Critical/High finding blocks the sprint: it needs a remediation story in the plan before
implementation begins, and a closure record before that story ships.

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `../AUDITS/` · `../THREAT-MODEL/` · `../ASSESSMENTS/` — the sibling categories that raise
  and reference these findings
- `../CONTEXT.md` — the security folder overview and the three frameworks
- `project-management/docs/SECURITY-GUIDE.md` — the governing STRIDE / OWASP / NIST guide
- `project-management/workflows/09-security-checks/` — the workflow that produces these
- `code/docs/SECURITY.md` — the code-side enforcement these records track

**Last Updated**: <%DATE%>
