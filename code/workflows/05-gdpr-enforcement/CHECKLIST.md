# GDPR Enforcement — Checklist

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Pre-Conditions

- [ ] `project-management/src/GDPR/DATA-INVENTORY.md` exists and covers this feature
- [ ] PM-layer GDPR compliance review is complete
- [ ] Feature implementation is in place and tests are green

---

## Execution Checklist

- [ ] Consent or lawful basis verified before any PII is accessed in a resolver
- [ ] All PII fields encrypted at rest per `code/docs/ENCRYPTION-GUIDE.md`
- [ ] Deletion function anonymises PII — does not expose raw data post-deletion
- [ ] Deletion function is tested end-to-end
- [ ] No PII present in any log statement
- [ ] No PII present in any error response returned to the client
- [ ] All tests passing after changes

---

## Definition of Done

- [ ] `project-management/src/GDPR/` documentation updated to reflect implementation
- [ ] All tests green
- [ ] Committed and pushed
