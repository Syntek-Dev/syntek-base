# project-management/src/10-SECURITY/ASSESSMENTS

Broad security **posture assessments** — **one per user story**. Each assessment maps a
story's posture across OWASP Top 10 (A01–A10) and NIST CSF 2.0 (GV/ID/PR/DE/RS/RC),
synthesising its STRIDE threat model, with STRIDE-tagged findings and a severity per
finding. The base repo ships this as a **per-story scaffold**: one `PLANNING/` plan
before implementation and one `IMPLEMENTATION/` record after, mirroring the 09-GDPR split.

## Directory Tree

```text
project-management/src/10-SECURITY/ASSESSMENTS/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── PLANNING/                           ← pre-implementation baseline assessments, one per story
│   ├── CONTEXT.md · CLAUDE.md
│   └── ASSESSMENT-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/                     ← post-implementation review assessments, one per story
    ├── CONTEXT.md · CLAUDE.md
    └── ASSESSMENT-IMPL-US000-TEMPLATE.md
```

Each phase folder ships one `US000-TEMPLATE.md`; a project copies it per story.

## Frameworks

Every assessment applies all three (guide: `project-management/docs/SECURITY-GUIDE.md`):

| Framework        | Purpose                                                  |
| ---------------- | -------------------------------------------------------- |
| **STRIDE**       | Tags each finding by threat class and trust boundary     |
| **OWASP Top 10** | Baseline posture across categories A01–A10               |
| **NIST CSF 2.0** | Risk-management function per finding (GV/ID/PR/DE/RS/RC) |

The **OWASP A01–A10 coverage table** and the **NIST CSF function mapping** are the
reusable scaffold each template keeps.

## PLANNING/ and IMPLEMENTATION/ — per story

A posture assessment is tied to a story at both ends, the two mirroring each other.

- `PLANNING/ASSESSMENT-PLAN-US###-*.md` — the pre-implementation **baseline**: scope and
  methodology, OWASP A01–A10 and NIST CSF targets, STRIDE-tagged findings, and the
  security tasks that gate implementation.
- `IMPLEMENTATION/ASSESSMENT-IMPL-US###-*.md` — the post-implementation **verification**:
  OWASP and NIST coverage re-evaluated against shipped code, each planning finding marked
  Resolved / Residual / New, closing the baseline with evidence.

## Severity levels

| Level        | Criteria                                                    |
| ------------ | ----------------------------------------------------------- |
| **CRITICAL** | Exploitable with no authentication; direct data breach risk |
| **HIGH**     | Exploitable with low-privilege access; significant impact   |
| **MEDIUM**   | Requires specific conditions; moderate impact               |
| **LOW**      | Informational or minor hardening gap                        |

CRITICAL/HIGH findings are release blockers — escalate each to `../VULNERABILITIES/`.

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `../CONTEXT.md` — the security folder overview and the four categories
- `../THREAT-MODEL/` — the STRIDE models these assessments synthesise
- `../VULNERABILITIES/` — the CRITICAL/HIGH findings escalated from assessments
- `project-management/workflows/10-security-checks/` — the workflow that produces these
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards

**Last Updated**: <%DATE%>
