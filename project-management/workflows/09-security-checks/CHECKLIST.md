# Security Checks — Checklist

**Last Updated**: 28/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] All authentication and authorisation flows identified and reviewed
- [ ] All data submission and storage points identified
- [ ] STRIDE analysis completed for each identified threat surface
- [ ] Security agent (`/syntek-dev-suite:security`) run against the feature design
- [ ] All `HIGH` and `CRITICAL` findings resolved before proceeding
- [ ] Threat model document saved in `project-management/src/09-SECURITY/THREAT-MODEL/`
- [ ] Assessment document saved in `project-management/src/09-SECURITY/ASSESSMENTS/`
- [ ] Wireframes or user flows updated if structural design changes were required

---

## Definition of Done

- [ ] No unresolved `HIGH` or `CRITICAL` security findings
- [ ] Security documentation committed and pushed
- [ ] Ready to proceed to `workflows/10-qa-checks`
