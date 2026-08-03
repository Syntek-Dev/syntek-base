# project-management/src/10-SECURITY

Security artefacts — threat models, posture assessments, audits, and vulnerability
records. The base repo ships this as a **per-story scaffold**: four categories, each
with a pre-implementation `PLANNING/` template and a post-implementation
`IMPLEMENTATION/` template tied to a user story, mirroring the 09-GDPR split.

## Directory Tree

```text
project-management/src/10-SECURITY/
├── CONTEXT.md · CLAUDE.md
├── THREAT-MODEL/          ← STRIDE threat models (per story)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── PLANNING/          ← THREAT-MODEL-PLAN-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
│   └── IMPLEMENTATION/    ← THREAT-MODEL-IMPL-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
├── ASSESSMENTS/          ← OWASP + NIST CSF posture assessments (per story)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── PLANNING/          ← ASSESSMENT-PLAN-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
│   └── IMPLEMENTATION/    ← ASSESSMENT-IMPL-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
├── AUDITS/               ← security code audits (per story)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── PLANNING/          ← AUDIT-PLAN-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
│   └── IMPLEMENTATION/    ← AUDIT-IMPL-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
└── VULNERABILITIES/      ← individual Critical/High findings (per story)
    ├── CONTEXT.md · CLAUDE.md
    ├── PLANNING/          ← VULN-PLAN-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
    └── IMPLEMENTATION/    ← VULN-IMPL-US000-TEMPLATE.md (+ CONTEXT/CLAUDE)
```

Each `PLANNING/`/`IMPLEMENTATION/` folder ships one `US000-TEMPLATE.md`; a project copies
it per story. Security planning is **per story** — there is no top-level cross-cutting
`PLANNING/` report folder (that role is served by the per-story plans, as in 09-GDPR).

## When to use this

Outputs from `workflows/10-security-checks/` are saved here — run after wireframes are
signed off and the GDPR review is complete, before sprint planning begins.

## Frameworks

Three frameworks are applied at every review (guide: `docs/SECURITY-GUIDE.md`):

| Framework        | Purpose                                                  |
| ---------------- | -------------------------------------------------------- |
| **STRIDE**       | Threat modelling per feature surface and trust boundary  |
| **OWASP Top 10** | Web vulnerability categories (A01–A10) per finding       |
| **NIST CSF 2.0** | Risk-management function per finding (GV/ID/PR/DE/RS/RC) |

## The four categories

- **`THREAT-MODEL/`** — STRIDE threat tables with trust boundaries; `PLANNING/` is the
  pre-implementation model, `IMPLEMENTATION/` re-assesses each threat post-ship.
- **`ASSESSMENTS/`** — broader posture over OWASP A01–A10 and NIST CSF; `PLANNING/` sets
  the baseline, `IMPLEMENTATION/` verifies the controls shipped.
- **`AUDITS/`** — a checklist audit of a story's code; `PLANNING/` is the scope,
  `IMPLEMENTATION/` records findings and verified fixes.
- **`VULNERABILITIES/`** — one Critical/High finding per file; `PLANNING/` is the
  sprint-blocking triage, `IMPLEMENTATION/` is the closure with evidence.

## Naming conventions

| Phase          | Pattern                                        |
| -------------- | ---------------------------------------------- |
| Planning       | `<TYPE>-PLAN-US###-<DESCRIPTOR>.md`            |
| Implementation | `<TYPE>-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` |

`<TYPE>` ∈ {`THREAT-MODEL`, `ASSESSMENT`, `AUDIT`, `VULN`}; `<DESCRIPTOR>` in
`SCREAMING-KEBAB-CASE`.

## Cross-references

- `project-management/workflows/10-security-checks/` — the workflow that produces these
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/src/09-GDPR/` — the GDPR compliance scaffold (prerequisite)
- `code/docs/SECURITY.md` — the coding-layer security implementation guide

**Last Updated**: <%DATE%>
