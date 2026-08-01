---
workflow: 09-security-checks
phase: harden
agent: security
skills: [stack-django, stack-htmx-templates]
model: fable
---

# Security Checks — Checklist

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (SECURITY-GUIDE.md) · **External — Compliance & Legal** (OWASP Top 10, STRIDE, NIST CSF) · **Internal — Live Artefacts** (src/09-SECURITY/) for supporting references.

## Execution Checklist

- [ ] All authentication and authorisation flows identified and reviewed
- [ ] All data submission and storage points identified
- [ ] STRIDE analysis completed for each identified threat surface
- [ ] OWASP A01–A10 category mapped to each finding
- [ ] NIST CSF 2.0 function mapped to each finding (GV / ID / PR / DE / RS / RC)
- [ ] Security agent (`security`) run against the feature design
- [ ] All `HIGH` and `CRITICAL` findings resolved before proceeding
- [ ] Threat model document saved in `project-management/src/09-SECURITY/THREAT-MODEL/`
- [ ] Assessment document saved in `project-management/src/09-SECURITY/ASSESSMENTS/`
- [ ] Individual vulnerability reports created for all `CRITICAL` and `HIGH` findings in `project-management/src/09-SECURITY/VULNERABILITIES/`
- [ ] Wireframes or user flows updated if structural design changes were required

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] No unresolved `HIGH` or `CRITICAL` security findings
- [ ] Security documentation committed and pushed
- [ ] Ready to proceed to `workflows/10-qa-checks`
