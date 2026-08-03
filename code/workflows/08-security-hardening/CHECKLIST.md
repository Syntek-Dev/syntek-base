---
workflow: 08-security-hardening
phase: harden
agent: security
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Security Hardening — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (SECURITY.md) · **External — Security & Standards** for supporting references.

## Execution Checklist

- [ ] All state-changing Django Ninja endpoints check permissions explicitly · _opus_
- [ ] No user-supplied IDs used without ownership verification · _opus_
- [ ] `DEBUG=False` verified in staging/production settings · _opus_
- [ ] CORS `ALLOWED_ORIGINS` is an explicit allowlist · _opus_
- [ ] All secrets come from environment variables · _opus_
- [ ] No sensitive data logged or exposed in error responses · _opus_
- [ ] QA agent confirmed no regressions · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] All critical and high findings resolved
- [ ] Audit summary saved to `project-management/src/10-SECURITY/AUDITS/`
- [ ] Committed and pushed
