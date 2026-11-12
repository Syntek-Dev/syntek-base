---
type: guide
skills: [gdpr-mechanics, global-workflow]
model: opus
---

# GDPR Guide — Compliance Obligations

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — GDPR retention tasks, Celery Beat purge scheduling, anonymisation

---

## Data Retention — Celery Beat Tasks

Personal data must be deleted or anonymised after its retention period expires. Every app with
time-limited personal data must define a Celery Beat task and schedule it at startup.

### Standard retention task

```python
# apps/myapp/tasks.py
import logging
from datetime import timedelta

from celery import shared_task
from django.conf import settings
from django.db import DatabaseError
from django.utils import timezone

from apps.myapp.models import MyModel

logger = logging.getLogger("apps.myapp")


class PurgeFailed(Exception):
    """Terminal: recorded and alerted, never retried. Carries identifiers only."""


@shared_task(
    name="apps.myapp.purge_expired_data",
    time_limit=300,  # hard limit, seconds
)  # no autoretry_for, no max_retries: the next Beat run is the retry
def purge_expired_data() -> int:
    """Delete rows past the configured retention window; return how many were deleted.

    Idempotent: a repeat recomputes the cutoff and finds nothing older left to delete.
    """
    retention_days = getattr(settings, "MYAPP", {}).get("RETENTION_DAYS", 365)
    cutoff = timezone.now() - timedelta(days=retention_days)
    try:
        deleted, _ = MyModel.objects.filter(created_at__lt=cutoff).delete()
    except DatabaseError:
        deleted = None  # the driver's error goes no further than this block
    if deleted is None:
        raise PurgeFailed("apps.myapp.purge_expired_data") from None  # after the block
    logger.info("apps.myapp: purged %d expired rows", deleted)
    return deleted
```

**The purge makes one attempt, and the schedule is its retry.** It runs daily on Beat and is
idempotent, so tomorrow's run deletes whatever today's failed to — and exactly one layer decides to
repeat an operation ([`code/docs/reliability/RETRIES.md`](../../../code/docs/reliability/RETRIES.md)
Section _One layer decides to retry_). Here that layer is Beat, so the task carries no
`autoretry_for` and no `max_retries`: a task-level retry would be a second deciding layer on top of
the schedule, for a job a day's delay does not harm. `time_limit=` stays, because a task without a
time limit can hold a worker slot for ever.

**A failure is recorded with identifiers only, then alerted.** The driver's message can name hosts
and SQL, and an uncaught `DatabaseError` would carry it into the `ERROR` line Celery writes and into
the tracker. So the fence drops the driver's error inside the `except` block and raises
`PurgeFailed` after it, `from None`, naming only the task — the shorter of the two safe shapes. The
other leaves the driver's error uncaught and relies on a filter on Celery's `celery.app.trace`
logger plus a tracker scrubber to drop its text, and nothing at baseline wires either. A fault outside the database — a bad setting, a missing field — is not a
`DatabaseError`, so it still fails with its own traceback ([`code/docs/reliability/RETRIES.md`](../../../code/docs/reliability/RETRIES.md) Section
_What a failure record carries_).

### Scheduling in settings

**The task only retries through its schedule if it is on one**: every retention task gets its entry
in the project's `CELERY_BEAT_SCHEDULE` below, as `purge_expired_data` does. A retention task
absent from it never runs again after a failure.

```python
# config/settings/base.py
from celery.schedules import crontab

CELERY_BEAT_SCHEDULE = {
    "apps.<%IDENTITY_APP%>.purge_expired_tokens": {
        "task": "apps.<%IDENTITY_APP%>.tasks.purge_expired_tokens",
        "schedule": crontab(hour=1, minute=0),  # daily 01:00 UTC
    },
    "apps.<%AUDIT_APP%>.purge_expired_entries": {
        "task": "apps.<%AUDIT_APP%>.tasks.purge_expired_entries",
        "schedule": crontab(hour=1, minute=30),  # daily 01:30 UTC
    },
    "apps.<%AUDIT_APP%>.run_audit_integrity_check": {
        "task": "apps.<%AUDIT_APP%>.tasks.run_audit_integrity_check",
        "schedule": crontab(hour=3, minute=0),  # daily 03:00 UTC
    },
    "apps.myapp.purge_expired_data": {  # the standard retention task above
        "task": "apps.myapp.purge_expired_data",
        "schedule": crontab(hour=2, minute=0),  # daily 02:00 UTC
    },
}
```

### Rules

- Retention tasks must use `admin_db` when querying user-scoped rows to bypass RLS.
- Tasks log success at `INFO`. A failure is not caught to be logged: it is raised once, identifiers
  only, and reaches the error tracker as
  [`code/docs/reliability/RETRIES.md`](../../../code/docs/reliability/RETRIES.md) Section _What a
  failure record carries_ says — never with the driver's message. Alerting on it is monitoring's
  rule; until the task surface is wired it is unenforced, not met.
- A scheduled retention task does not retry itself — the next scheduled run is its retry.
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

See [`code/docs/ENCRYPTION-GUIDE.md`](../../../code/docs/ENCRYPTION-GUIDE.md) for the full
encryption reference.

See [`code/docs/RLS-GUIDE.md`](../../../code/docs/RLS-GUIDE.md) for PostgreSQL Row Level Security.

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
