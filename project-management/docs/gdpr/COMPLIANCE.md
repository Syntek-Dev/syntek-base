---
type: guide
agent: gdpr
skills: [global-workflow]
model: fable
---

# GDPR Guide — Compliance Obligations

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** fable — GDPR retention tasks, Celery Beat purge scheduling, anonymisation

---

## Data Retention — Celery Beat Tasks

Personal data must be deleted or anonymised after its retention period expires. Every app with
time-limited personal data must define a Celery Beat task and schedule it at startup.

### Standard retention task

```python
# apps/myapp/tasks.py
from celery import shared_task


@shared_task(name="apps.myapp.purge_expired_data", bind=True, max_retries=3)
def purge_expired_data(self) -> dict:
    """Delete rows past the configured retention window.

    Returns a summary dict with the count of rows deleted/anonymised.
    """
    import logging
    from django.conf import settings
    from django.utils import timezone

    logger = logging.getLogger("apps.myapp")
    cfg = getattr(settings, "MYAPP", {})
    retention_days = cfg.get("RETENTION_DAYS", 365)
    cutoff = timezone.now() - timezone.timedelta(days=retention_days)

    try:
        deleted, _ = MyModel.objects.filter(created_at__lt=cutoff).delete()
        logger.info("apps.myapp: purged %d expired rows", deleted)
        return {"deleted": deleted}
    except Exception as exc:
        logger.error("apps.myapp: purge_expired_data failed", exc_info=True)
        raise self.retry(exc=exc)
```

### Scheduling in settings

```python
# config/settings/base.py
from celery.schedules import crontab

CELERY_BEAT_SCHEDULE = {
    "apps.<%IDENTITY_APP%>.purge_expired_tokens": {
        "task": "apps.<%IDENTITY_APP%>.tasks.purge_expired_tokens",
        "schedule": crontab(hour=1, minute=0),   # daily 01:00 UTC
    },
    "apps.<%AUDIT_APP%>.purge_expired_entries": {
        "task": "apps.<%AUDIT_APP%>.tasks.purge_expired_entries",
        "schedule": crontab(hour=1, minute=30),  # daily 01:30 UTC
    },
    "apps.<%AUDIT_APP%>.run_audit_integrity_check": {
        "task": "apps.<%AUDIT_APP%>.tasks.run_audit_integrity_check",
        "schedule": crontab(hour=3, minute=0),   # daily 03:00 UTC
    },
}
```

### Rules

- Retention tasks must use `admin_db` when querying user-scoped rows to bypass RLS.
- Tasks must log both success and failure at `INFO` / `ERROR` level respectively.
- Tasks must be idempotent — running twice in the same window must be a no-op.
- Retention periods are configured via `<APP>['RETENTION_DAYS']` in Django settings. Never
  hardcode periods.

---

## Token Purge Tasks

Authentication tokens, verification codes, and session tokens that expire must be purged
regularly to prevent unbounded table growth and to comply with data minimisation obligations.

`apps.<%IDENTITY_APP%>` provides `apps.<%IDENTITY_APP%>.tasks.purge_expired_tokens` as a Celery task. It purges:

- `VerificationCode` rows past their TTL
- `AccessTokenDenylist` rows past their TTL
- `LoginSession` rows past `SESSION_TIMEOUT`

The purge task writes an audit entry via `apps.<%AUDIT_APP%>` summarising how many rows were deleted.
This audit entry is itself subject to the audit retention policy.

---

## Article 32 — Encryption at Rest

GDPR Article 32 requires "appropriate technical measures" to protect personal data:

- **All PII fields** use `EncryptedField` (AES-256-GCM via the `cryptography` library).
- **All unique PII fields** have a companion HMAC-SHA256 lookup token.
- **Encryption keys** are stored in environment variables, never in the database or codebase.
- **Key rotation** is zero-downtime using versioned `PROJECTNAME_FIELD_KEY_{FIELD}_V1/V2/…` env vars.
- **Transport security** uses TLS 1.2+ for all connections.

See [`code/docs/ENCRYPTION-GUIDE.md`](../../code/docs/ENCRYPTION-GUIDE.md) for the full
encryption reference.

See [`code/docs/RLS-GUIDE.md`](../../code/docs/RLS-GUIDE.md) for PostgreSQL Row Level Security.

---

## GDPR Audit Logging

All data-subject rights operations must be recorded in the audit log:

```python
from apps.<%AUDIT_APP%>.services import write_audit

# When an erasure request is processed
write_audit(
    "gdpr_erasure",
    actor_pk=requesting_user_pk,
    resource_id=str(subject_user_pk),
    extra={"apps_erased": ["apps.<%IDENTITY_APP%>", "apps.<%CONTENT_APP%>"]},
)

# When a SAR export is generated
write_audit(
    "gdpr_sar_export",
    actor_pk=subject_user_pk,
    resource_id=str(subject_user_pk),
)
```

These audit entries are themselves subject to the audit retention policy
(`AUDIT['RETENTION_DAYS']`). The GDPR retention period for processing records is typically the
duration of the data processing activity plus the applicable limitation period (usually 6 years
under the UK Limitation Act 1980).

---

## Breach Notification (Art. 33–34)

If a personal data breach occurs, the controller must notify the ICO **within 72 hours** of
becoming aware of it (Art. 33). If the breach is likely to result in a high risk to individuals,
data subjects must also be notified without undue delay (Art. 34).

### Immediate actions

1. **Contain** — revoke compromised credentials, disable affected endpoints.
2. **Preserve evidence** — take database and log snapshots before they rotate.
3. **Assess** — determine the categories of data affected, the number of data subjects, and the
   likely consequences.
4. **Notify the ICO** within 72 hours via the ICO breach notification portal if the breach is
   likely to result in a risk to individuals.
5. **Notify affected users** if the breach is likely to result in a **high** risk to them.
6. **Document** all breaches, even those not reported to the ICO (Art. 33(5) obligation).

### Documentation template

Create a breach record at `docs/INCIDENTS/BREACH-{YYYY-MM-DD}-{SHORT-TITLE}.md` covering:

- Date and time breach occurred / was discovered
- Categories of data affected (names, emails, financial data, etc.)
- Approximate number of data subjects affected
- Likely consequences
- Measures taken to address the breach and mitigate its effects
- Whether ICO notification was made (and reference number)
- Whether data-subject notification was made

---

## UK DPA 2018 Specifics

- **Supervisory authority** — the ICO is the UK supervisory authority. Breach notifications go to
  the ICO, not EU DPAs.
- **Adequacy** — the UK has received an adequacy decision from the EU (current as of April 2026),
  allowing data transfers between UK and EU without additional safeguards.
- **Special category data** — same as EU GDPR Article 9 (health, biometric, genetic, racial/ethnic
  origin, religious beliefs, political opinions, trade union membership, sex life/orientation).
- **Retention** — financial records: 6 years (HMRC). Employment records: 6 years after employment
  ends. Payroll: 3 years.
- **ICO registration** — most organisations that process personal data must register with the ICO
  and pay the data protection fee.

---

## Quick Checklist

When adding a new app or new PII fields to an existing app:

- [ ] All PII fields use `EncryptedField` — not `CharField`, `TextField`, or `EmailField`
- [ ] Unique PII fields have companion `*_token` columns (HMAC-SHA256)
- [ ] The app provides `gdpr_erase(user_id)` and `gdpr_export(user_id)` service functions in
      `services/gdpr.py`
- [ ] The `gdpr_erase` function uses `using("admin_db")` to bypass RLS
- [ ] The `gdpr_export` function decrypts fields before returning them
- [ ] A Celery Beat task for retention purging is defined and documented in `CELERY_BEAT_SCHEDULE`
- [ ] Retention period is configurable via `<APP>['RETENTION_DAYS']` in Django settings
- [ ] Consent records are never deleted in the `gdpr_erase` handler
- [ ] Audit log entries are anonymised, not deleted, in the `gdpr_erase` handler
- [ ] The app's RLS policies are in place
- [ ] The lawful basis for each type of personal data processing is documented
- [ ] `apps.<%AUDIT_APP%>` writes an event for every data-subject rights operation
- [ ] Tests cover: erase handler deletes PII, export handler returns plaintext PII, no data for
      other users is returned or deleted

_Part of the `project-management/docs/` documentation family. See [`../GDPR-GUIDE.md`](../GDPR-GUIDE.md) for the full index._
