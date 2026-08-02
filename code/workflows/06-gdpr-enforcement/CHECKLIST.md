---
workflow: 06-gdpr-enforcement
phase: compliance
agent: gdpr
skills: [stack-django]
model: opus
---

# GDPR Enforcement — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (encryption/FIELD-ENCRYPTION.md, encryption/LOOKUP-TOKENS.md, rls/TESTING-AND-AUDIT.md, logging/DJANGO-LOGGING.md) · **External — Security & Standards** (UK GDPR) for supporting references.

## Pre-Conditions

- [ ] `project-management/src/08-GDPR/DATA-INVENTORY.md` exists and covers this feature
- [ ] PM-layer GDPR compliance review is complete
- [ ] Feature implementation is in place and tests are green

---

## Execution Checklist

- [ ] Consent or lawful basis verified before any PII is accessed in a resolver · _opus_
- [ ] All PII fields encrypted at rest per `code/docs/encryption/FIELD-ENCRYPTION.md` · _opus_
- [ ] Deletion function anonymises PII — does not expose raw data post-deletion · _opus_
- [ ] Deletion function is tested end-to-end · _opus_
- [ ] No PII present in any log statement · _opus_
- [ ] No PII present in any error response returned to the client · _opus_
- [ ] All tests passing after changes · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] `project-management/src/08-GDPR/` documentation updated to reflect implementation
- [ ] All tests green
- [ ] Committed and pushed
