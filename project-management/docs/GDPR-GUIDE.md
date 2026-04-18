# GDPR Guide

**Last Updated**: 18/04/2026 **Version**: 1.1.0 **Maintained By**: Syntek Development Team
**Language**: British English (en_GB) **Timezone**: Europe/London

---

## Table of Contents

- [Overview](#overview)
- [GDPR Compliance in syntek-website](#gdpr-compliance-in-syntek-website)
- [Per-App GDPR Service Functions](#per-app-gdpr-service-functions)
- [Data Retention — Celery Beat Tasks](#data-retention--celery-beat-tasks)
- [Token Purge Tasks](#token-purge-tasks)
- [Right to Erasure (Art. 17)](#right-to-erasure-art-17)
- [Subject Access Request (Art. 15)](#subject-access-request-art-15)
- [Data Portability (Art. 20)](#data-portability-art-20)
- [Consent Management (Art. 6–7)](#consent-management-art-67)
- [Article 32 — Encryption at Rest](#article-32--encryption-at-rest)
- [GDPR Audit Logging](#gdpr-audit-logging)
- [Breach Notification (Art. 33–34)](#breach-notification-art-3334)
- [UK DPA 2018 Specifics](#uk-dpa-2018-specifics)
- [Quick Checklist](#quick-checklist)

---

## Overview

GDPR compliance is a **mandatory, non-optional** requirement for every app that processes
personal data. It is not a phase that happens at the end of a story — it is wired in from the
initial migration.

This guide covers the syntek-website patterns for implementing GDPR compliance across Django
backend apps. For the authoritative legal text, refer to:

- [UK GDPR](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/)
- [EU GDPR](https://gdpr.eu/)
- [UK Data Protection Act 2018](https://www.legislation.gov.uk/ukpga/2018/12/contents)
- [ICO guidance](https://ico.org.uk/)

**Key principles that apply to all code:**

1. **Data minimisation** — collect only what you need; store only for as long as you need it.
2. **Purpose limitation** — data collected for one purpose cannot be repurposed without a new lawful
   basis.
3. **Storage limitation** — personal data must not be kept longer than necessary. Automated
   retention tasks are mandatory.
4. **Integrity and confidentiality** — personal data must be encrypted at rest and in transit (GDPR
   Article 32). See [`code/docs/ENCRYPTION-GUIDE.md`](../../code/docs/ENCRYPTION-GUIDE.md).
5. **Accountability** — every processing activity must be documentable and demonstrable.

---

## GDPR Compliance in syntek-website

GDPR compliance for **syntek-website** is built directly into the Django apps (`apps/users`,
`apps/audit`, `apps/content`, `apps/notifications`). There is no external GDPR orchestration
package — each app owns its own erasure and export logic, and the GDPR views/tasks call those
service functions directly.

**Where PII lives and who owns it:**

| App                  | Personal data held                                                         | On erasure                                  |
| -------------------- | -------------------------------------------------------------------------- | ------------------------------------------- |
| `apps.users`         | Email, full name, password hash, MFA secrets, login sessions, IP addresses | Delete or nullify PII fields                |
| `apps.content`       | User-authored content, if applicable                                       | Delete or anonymise                         |
| `apps.audit`         | Actor IDs, IP addresses                                                    | Anonymise — **do not delete** the event row |
| `apps.notifications` | User IDs and notification content                                          | Delete                                      |

**Consent records** (stored in `apps.users`) must never be erased — they are evidence of the
lawful basis for processing.

---

## Per-App GDPR Service Functions

Every app that owns personal data must expose `gdpr_export()` and `gdpr_erase()` service
functions. These are called directly by the GDPR views and Celery tasks — there is no registry
or dynamic dispatch layer. Providing these functions is a **blocking criterion** for merge,
with the same priority as a missing migration on a new PII-bearing table.

### Service function signatures

```python
# apps/users/services/gdpr.py
from __future__ import annotations

from django.db import transaction


@transaction.atomic
def gdpr_erase(user_id: str) -> None:
    """Delete or anonymise all personal data for ``user_id`` in apps.users.

    Must be idempotent — calling twice must not raise.
    Uses admin_db to bypass RLS (the user's session may be compromised).
    """
    from apps.users.models import User, LoginSession, VerificationCode

    User.objects.using("admin_db").filter(pk=user_id).update(
        email=None,
        email_token=None,
        full_name=None,
        phone=None,
        phone_token=None,
        mfa_secret=None,
        is_active=False,
    )
    LoginSession.objects.using("admin_db").filter(user_id=user_id).delete()
    VerificationCode.objects.using("admin_db").filter(user_id=user_id).delete()


def gdpr_export(user_id: str) -> dict:
    """Return all personal data held for ``user_id`` in apps.users as a serialisable dict.

    Decrypts fields before returning — the export is for the data subject (plaintext).
    Never includes data belonging to other users.
    """
    from apps.core.encryption import decrypt_field, get_field_key
    from apps.users.models import User

    user = User.objects.using("admin_db").get(pk=user_id)
    key_email = get_field_key("EMAIL")
    return {
        "email": decrypt_field(user.email, key_email, "User", "email"),
        "full_name": user.full_name,
        "created_at": user.created_at.isoformat(),
        "mfa_enabled": user.mfa_enabled,
        # Do NOT include: password hashes, TOTP secrets, internal tokens
    }
```

```python
# apps/audit/services/gdpr.py
from __future__ import annotations

from django.db import transaction


@transaction.atomic
def gdpr_erase(user_id: str) -> None:
    """Anonymise audit log entries for ``user_id`` — do not delete the event rows."""
    from apps.audit.models import AuditEntry

    AuditEntry.objects.using("admin_db").filter(actor_id=user_id).update(
        actor_id="[anonymised]",
        ip_address=None,
        user_agent=None,
    )


def gdpr_export(user_id: str) -> dict:
    """Return audit entries for ``user_id`` as a serialisable list."""
    from apps.audit.models import AuditEntry

    entries = list(
        AuditEntry.objects.using("admin_db")
        .filter(actor_id=user_id)
        .values("event", "resource_id", "created_at")
    )
    return {"audit_entries": entries}
```

### Which apps must provide GDPR service functions

| App                  | Must provide? | Notes                                                                  |
| -------------------- | ------------- | ---------------------------------------------------------------------- |
| `apps.users`         | **Yes**       | Holds email, full name, MFA secrets, login sessions, IP addresses      |
| `apps.audit`         | **Yes**       | Holds actor IDs and IP addresses — anonymise on erasure, do not delete |
| `apps.content`       | Yes           | Holds user-authored content — delete or anonymise on erasure           |
| `apps.notifications` | Yes           | Holds user IDs and notification content                                |

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
# config/settings/base.py (or environment override)
from celery.schedules import crontab

CELERY_BEAT_SCHEDULE = {
    "apps.users.purge_expired_tokens": {
        "task": "apps.users.tasks.purge_expired_tokens",
        "schedule": crontab(hour=1, minute=0),   # daily 01:00 UTC
    },
    "apps.audit.purge_expired_entries": {
        "task": "apps.audit.tasks.purge_expired_entries",
        "schedule": crontab(hour=1, minute=30),  # daily 01:30 UTC
    },
    "apps.audit.run_audit_integrity_check": {
        "task": "apps.audit.tasks.run_audit_integrity_check",
        "schedule": crontab(hour=3, minute=0),   # daily 03:00 UTC
    },
}
```

### Rules

- Retention tasks must run on the `default` database connection — they do not need to bypass RLS
  because they are system-level maintenance tasks. If they query user-scoped rows, use `admin_db`.
- Tasks must log both success and failure at `INFO` / `ERROR` level respectively.
- Tasks must be idempotent — running twice in the same window must be a no-op.
- Retention periods are configured via `<APP>['RETENTION_DAYS']` in Django settings. Never
  hardcode periods.

---

## Token Purge Tasks

Authentication tokens, verification codes, and session tokens that expire must be purged
regularly to prevent unbounded table growth and to comply with data minimisation obligations.

### apps.users token purge

`apps.users` provides `apps.users.tasks.purge_expired_tokens` as a Celery task. It purges:

- `VerificationCode` rows past their TTL
- `AccessTokenDenylist` rows past their TTL
- `LoginSession` rows past `SESSION_TIMEOUT`

Schedule in settings:

```python
CELERY_BEAT_SCHEDULE = {
    "apps.users.purge_expired_tokens": {
        "task": "apps.users.tasks.purge_expired_tokens",
        "schedule": crontab(hour=1, minute=0),
    },
}
```

The purge task writes an audit entry via `apps.audit` summarising how many rows were deleted.
This audit entry is itself subject to the audit retention policy.

---

## Right to Erasure (Art. 17)

A data subject has the right to request deletion of their personal data when:

- The data is no longer necessary for its original purpose.
- Consent has been withdrawn (and there is no other lawful basis).
- They have objected to processing under Art. 21 and there is no overriding legitimate interest.
- The data has been processed unlawfully.

### What must be erased

| Data type                                | Action                 | Exception                                       |
| ---------------------------------------- | ---------------------- | ----------------------------------------------- |
| PII fields (name, email, phone, address) | Delete or nullify      | Legal holds, financial records (Art. 17(3)(b))  |
| Login sessions                           | Delete                 | None                                            |
| Verification tokens                      | Delete                 | None                                            |
| Audit log entries                        | Anonymise (not delete) | Required for legal/accountability obligations   |
| Financial transactions                   | Anonymise PII fields   | Must retain transaction record for 7 years (UK) |
| Consent records                          | Retain (evidence)      | Cannot be erased — they prove the lawful basis  |

**Never delete audit log entries.** They exist for accountability and legal compliance. Anonymise
the PII fields (`actor_id` → anonymised, IP → deleted, user_agent → deleted) while retaining the
event record.

### Erasure via `admin_db`

All erasure handlers must use `using("admin_db")` to bypass RLS. At the time of erasure, the
user's session may be compromised — RLS protecting their own rows is the wrong behaviour here.

```python
# Correct — uses admin_db to ensure RLS does not block deletion
User.objects.using("admin_db").filter(pk=user_id).update(
    email=None, email_token=None,
    phone=None, phone_token=None,
    is_active=False,
)
```

---

## Subject Access Request (Art. 15)

A SAR (Subject Access Request) entitles a data subject to receive a copy of all personal data
held about them, along with information about how it is processed.

### Response requirements

The response must include:

- All personal data held (categories, specific data)
- The purposes of processing
- The retention periods or criteria used to determine them
- Any third-party recipients (payment processors, email providers)
- The source of the data (if not collected from the subject directly)

### Implementation

Each app's `gdpr_export()` service function returns a structured dict. The GDPR view aggregates
the responses from each app and produces a JSON download for the data subject.

```python
# apps/users/services/gdpr.py
def gdpr_export(user_id: str) -> dict:
    """All personal data for this user from apps.users."""
    # Decrypt fields before exporting — the export is for the data subject
    from apps.core.encryption import decrypt_field, get_field_key

    user = User.objects.using("admin_db").get(pk=user_id)
    key_email = get_field_key("EMAIL")
    return {
        "email": decrypt_field(user.email, key_email, "User", "email"),
        "created_at": user.created_at.isoformat(),
        "mfa_enabled": user.mfa_enabled,
        # Do NOT include: password hashes, TOTP secrets, internal tokens
    }
```

**Do not export** password hashes, TOTP seeds, internal lookup tokens, or cryptographic key
material. Export the plaintext personal data that the subject provided or that was derived from
their activity.

---

## Data Portability (Art. 20)

Data portability applies when processing is based on consent or contract and is carried out by
automated means. The data subject can request their data in a structured, commonly used,
machine-readable format (typically JSON or CSV).

The GDPR export view calls each app's `gdpr_export()` service function and aggregates the results
into a single JSON response. CSV output can be generated from the same structured data if
required.

---

## Consent Management (Art. 6–7)

Lawful processing requires a valid lawful basis. For direct-to-consumer services the most common
bases are:

| Basis                                   | When to use                                             | Notes                                                    |
| --------------------------------------- | ------------------------------------------------------- | -------------------------------------------------------- |
| **Consent (Art. 6(1)(a))**              | Marketing, optional features, non-essential cookies     | Must be freely given, specific, informed, unambiguous    |
| **Contract (Art. 6(1)(b))**             | Necessary to provide the service the user signed up for | Email for account, payment data for purchases            |
| **Legitimate interests (Art. 6(1)(f))** | Analytics, fraud prevention, security logging           | Requires LIA (Legitimate Interests Assessment) on record |
| **Legal obligation (Art. 6(1)(c))**     | Financial records, tax, anti-money-laundering           | UK-specific obligations under Companies Act, HMRC rules  |

### Consent records

Consent records must be retained even after a user withdraws consent — they are evidence that
consent was freely given at the time. Do **not** erase consent records in erasure handlers.

```python
class ConsentRecord(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    purpose = models.CharField(max_length=100)  # e.g. "marketing_email"
    given_at = models.DateTimeField()
    withdrawn_at = models.DateTimeField(null=True, blank=True)
    ip_address = EncryptedField()  # PII — encrypted
    user_agent = EncryptedField()  # PII — encrypted

    class Meta:
        db_table = "users_consentrecord"
```

---

## Article 32 — Encryption at Rest

GDPR Article 32 requires "appropriate technical measures" to protect personal data. For
syntek-website, this means:

- **All PII fields** use `EncryptedField` (AES-256-GCM — implemented in Python via the `cryptography` library).
- **All unique PII fields** have a companion HMAC-SHA256 lookup token.
- **Encryption keys** are stored in environment variables, never in the database or codebase.
- **Key rotation** is zero-downtime using versioned `SYNTEK_FIELD_KEY_{FIELD}_V1/V2/…` env vars.
- **Transport security** uses TLS 1.2+ for all connections.

See [`code/docs/ENCRYPTION-GUIDE.md`](../../code/docs/ENCRYPTION-GUIDE.md) for the full encryption
reference.

See [`code/docs/RLS-GUIDE.md`](../../code/docs/RLS-GUIDE.md) for PostgreSQL Row Level Security — a
complementary technical measure that restricts which rows any given database session can read,
independent of application-layer filters.

---

## GDPR Audit Logging

All data-subject rights operations must be recorded in the audit log:

```python
from apps.audit.services import write_audit

# When an erasure request is processed
write_audit(
    "gdpr_erasure",
    actor_pk=requesting_user_pk,   # the admin or automated system processing it
    resource_id=str(subject_user_pk),
    extra={"apps_erased": ["apps.users", "apps.content"]},
)

# When a SAR export is generated
write_audit(
    "gdpr_sar_export",
    actor_pk=subject_user_pk,
    resource_id=str(subject_user_pk),
)
```

These audit entries are themselves subject to the audit retention policy
(`AUDIT['RETENTION_DAYS']`). The GDPR retention period for processing records is typically
the duration of the data processing activity plus the applicable limitation period (usually 6
years under the UK Limitation Act 1980).

---

## Breach Notification (Art. 33–34)

If a personal data breach occurs, the controller must notify the relevant supervisory authority
**within 72 hours** of becoming aware of it (Art. 33, UK GDPR / ICO). If the breach is likely to
result in a high risk to individuals, the data subjects must also be notified without undue delay
(Art. 34).

### Definition of a breach

A personal data breach is a breach of security leading to the accidental or unlawful destruction,
loss, alteration, unauthorised disclosure of, or access to, personal data.

Examples:

- Database dumped and exfiltrated by an attacker
- Email containing PII sent to the wrong recipient
- Backup decryption key leaked
- Audit log entries modified (integrity breach)

### Immediate actions

1. **Contain** — revoke compromised credentials, disable affected endpoints. See
   [`how-to/src/CONTRIBUTING/INCIDENT-RESPONSE.md`](../../how-to/src/CONTRIBUTING/INCIDENT-RESPONSE.md).
2. **Preserve evidence** — take database and log snapshots before they rotate.
3. **Assess** — determine the categories of data affected, the number of data subjects, and the
   likely consequences.
4. **Notify the ICO** within 72 hours via the ICO breach notification portal if the breach is likely
   to result in a risk to individuals. Low-risk breaches (e.g. encrypted laptop lost with no key
   leaked) may not require notification.
5. **Notify affected users** if the breach is likely to result in a **high** risk to them.
6. **Document** all breaches, even those not reported to the ICO (Art. 33(5) record-keeping
   obligation).

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

The UK Data Protection Act 2018 implements UK GDPR following Brexit. Key differences from EU GDPR:

- **Supervisory authority** — the ICO (Information Commissioner's Office) is the UK supervisory
  authority. Breach notifications go to the ICO, not EU DPAs.
- **Adequacy** — the UK has received an adequacy decision from the EU (current as of April 2026),
  allowing data transfers between UK and EU without additional safeguards.
- **Law enforcement** — Part 3 of the DPA 2018 covers law enforcement processing (EU Directive
  2016/680 equivalent). This is separate from UK GDPR and applies to police/law enforcement bodies.
- **Special category data** — same as EU GDPR Article 9 (health, biometric, genetic, racial/ethnic
  origin, religious beliefs, political opinions, trade union membership, sex life/orientation).
- **Retention** — financial records must be retained for 6 years (HMRC). Employment records: 6 years
  after employment ends. Payroll: 3 years.
- **ICO registration** — most organisations that process personal data must register with the ICO
  and pay the data protection fee.

---

## Quick Checklist

When adding a new app or new PII fields to an existing app:

- [ ] All PII fields use `EncryptedField` — not `CharField`, `TextField`, or `EmailField`
- [ ] Unique PII fields have companion `*_token` columns (HMAC-SHA256)
- [ ] The app provides `gdpr_erase(user_id)` and `gdpr_export(user_id)` service functions in
      `services/gdpr.py`, called directly by the GDPR views/tasks
- [ ] The `gdpr_erase` function uses `using("admin_db")` to bypass RLS
- [ ] The `gdpr_export` function decrypts fields before returning them (data subject gets plaintext)
- [ ] A Celery Beat task for retention purging is defined and documented in `CELERY_BEAT_SCHEDULE`
- [ ] Retention period is configurable via `<APP>['RETENTION_DAYS']` in Django settings
- [ ] Consent records are never deleted in the `gdpr_erase` handler
- [ ] Audit log entries are anonymised, not deleted, in the `gdpr_erase` handler
- [ ] The app's RLS policies are in place (see
      [`code/docs/RLS-GUIDE.md`](../../code/docs/RLS-GUIDE.md))
- [ ] The lawful basis for each type of personal data processing is documented
- [ ] `apps.audit` writes an event for every data-subject rights operation
- [ ] Tests cover: erase handler deletes PII, export handler returns plaintext PII, no data for
      other users is returned or deleted
