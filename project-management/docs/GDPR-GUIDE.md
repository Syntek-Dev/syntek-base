---
type: guide
agent: gdpr
skills: [global-workflow]
model: fable
---

# GDPR Guide

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** fable — GDPR compliance patterns, lawful basis, retention, data rights

GDPR compliance patterns for <%PROJECT_NAME%> Django apps. Compliance is **mandatory, non-optional**
and wired in from the initial migration — not a phase that happens at the end of a story.

**Key principles:**

1. **Data minimisation** — collect only what you need; store only for as long as you need it.
2. **Purpose limitation** — data collected for one purpose cannot be repurposed without a new
   lawful basis.
3. **Storage limitation** — personal data must not be kept longer than necessary. Automated
   retention tasks are mandatory.
4. **Integrity and confidentiality** — personal data must be encrypted at rest and in transit
   (GDPR Article 32). See [`code/docs/ENCRYPTION-GUIDE.md`](../../code/docs/ENCRYPTION-GUIDE.md).
5. **Accountability** — every processing activity must be documentable and demonstrable.

## Sub-documents

| Document                                     | Covers                                                                                                                                                                                                           |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`gdpr/DATA-RIGHTS.md`](gdpr/DATA-RIGHTS.md) | PII app ownership table, per-app `gdpr_erase`/`gdpr_export` service function signatures, Right to Erasure (Art. 17), Subject Access Request (Art. 15), Data Portability (Art. 20), Consent Management (Art. 6–7) |
| [`gdpr/COMPLIANCE.md`](gdpr/COMPLIANCE.md)   | Celery Beat retention tasks, token purge tasks, Article 32 encryption at rest, GDPR audit logging, Breach Notification (Art. 33–34), UK DPA 2018 specifics, quick checklist                                      |

## Authoritative references

- [UK GDPR](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/)
- [EU GDPR](https://gdpr.eu/)
- [UK Data Protection Act 2018](https://www.legislation.gov.uk/ukpga/2018/12/contents)
- [ICO guidance](https://ico.org.uk/)

_Part of the `project-management/docs/` documentation family._
