# Security Hardening — Checklist

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] All GraphQL mutations check permissions explicitly
- [ ] No user-supplied IDs used without ownership verification
- [ ] `DEBUG=False` verified in staging/production settings
- [ ] CORS `ALLOWED_ORIGINS` is an explicit allowlist
- [ ] All secrets come from environment variables
- [ ] No sensitive data logged or exposed in error responses
- [ ] QA agent confirmed no regressions

---

## Definition of Done

- [ ] All critical and high findings resolved
- [ ] Audit summary saved to `project-management/src/SECURITY/AUDITS/`
- [ ] Committed and pushed
