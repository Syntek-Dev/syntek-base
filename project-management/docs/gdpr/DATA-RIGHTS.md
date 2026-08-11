---
type: guide
agent: gdpr
skills: [global-workflow]
model: fable
---

# GDPR Guide — Data Subject Rights

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** fable — Data subject rights, per-app erasure and export service logic

---

## GDPR Compliance in <%PROJECT_NAME%>

GDPR compliance is built directly into whichever Django apps hold personal data — typically an
identity app (`apps/<%IDENTITY_APP%>`), an audit log (`apps/<%AUDIT_APP%>`), and any app storing
user-authored content or notifications. There is no external GDPR orchestration package: each
app owns its own erasure and export logic, and the GDPR views/tasks call those service functions
directly.

App names below are **placeholders** — substitute the real ones from this project's
`code/src/django/apps/`. The code blocks are reference implementations of the required shape,
not shipped code.

**Where PII lives and who owns it:**

| App                          | Personal data held                                                         | On erasure                                  |
| ---------------------------- | -------------------------------------------------------------------------- | ------------------------------------------- |
| `apps.<%IDENTITY_APP%>`      | Email, full name, password hash, MFA secrets, login sessions, IP addresses | Delete or nullify PII fields                |
| `apps.<%CONTENT_APP%>`       | User-authored content, if applicable                                       | Delete or anonymise                         |
| `apps.<%AUDIT_APP%>`         | Actor IDs, IP addresses                                                    | Anonymise — **do not delete** the event row |
| `apps.<%NOTIFICATIONS_APP%>` | User IDs and notification content                                          | Delete                                      |

**Consent records** (stored in `apps.<%IDENTITY_APP%>`) must never be erased — they are evidence of the
lawful basis for processing.

---

## Per-App GDPR Service Functions

Every app that owns personal data must expose `gdpr_export()` and `gdpr_erase()` service
functions. These are called directly by the GDPR views and Celery tasks. Providing these
functions is a **blocking criterion** for merge on any new PII-bearing table.

### Service function signatures

```python
# apps/<%IDENTITY_APP%>/services/gdpr.py
from __future__ import annotations

from django.db import transaction


@transaction.atomic
def gdpr_erase(user_id: str) -> None:
    """Delete or anonymise all personal data for ``user_id`` in apps.<%IDENTITY_APP%>.

    Must be idempotent — calling twice must not raise.
    Uses admin_db to bypass RLS (the user's session may be compromised).
    """
    from apps.<%IDENTITY_APP%>.models import User, LoginSession, VerificationCode

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
    """Return all personal data held for ``user_id`` in apps.<%IDENTITY_APP%> as a serialisable dict.

    Decrypts fields before returning — the export is for the data subject (plaintext).
    Never includes data belonging to other users.
    """
    from apps.<%CORE_APP%>.encryption import decrypt_field, get_field_key
    from apps.<%IDENTITY_APP%>.models import User

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
# apps/<%AUDIT_APP%>/services/gdpr.py
@transaction.atomic
def gdpr_erase(user_id: str) -> None:
    """Anonymise audit log entries for ``user_id`` — do not delete the event rows."""
    from apps.<%AUDIT_APP%>.models import AuditLog

    # actor_id is a uuid column, so erasure nulls it rather than writing a sentinel.
    # actor_type is NOT NULL and survives, so the class of actor outlives the identity.
    AuditLog.objects.using("admin_db").filter(actor_id=user_id).update(
        actor_id=None,
        ip_hash=None,
    )


def gdpr_export(user_id: str) -> dict:
    """Return audit entries for ``user_id`` as a serialisable list."""
    from apps.<%AUDIT_APP%>.models import AuditLog

    entries = list(
        AuditLog.objects.using("admin_db")
        .filter(actor_id=user_id)
        .values("action", "target_id", "timestamp")
    )
    return {"audit_entries": entries}
```

### Which apps must provide GDPR service functions

| App                          | Must provide? | Notes                                                                  |
| ---------------------------- | ------------- | ---------------------------------------------------------------------- |
| `apps.<%IDENTITY_APP%>`      | **Yes**       | Holds email, full name, MFA secrets, login sessions, IP addresses      |
| `apps.<%AUDIT_APP%>`         | **Yes**       | Holds actor IDs and IP addresses — anonymise on erasure, do not delete |
| `apps.<%CONTENT_APP%>`       | Yes           | Holds user-authored content — delete or anonymise on erasure           |
| `apps.<%NOTIFICATIONS_APP%>` | Yes           | Holds user IDs and notification content                                |

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

**Never delete audit log entries.** Null the identifying columns (`actor_id` and `ip_hash`) while
retaining the event record. The schema is owned by
[`code/docs/security/AUDIT-TRAIL.md`](../../../code/docs/security/AUDIT-TRAIL.md): there is no raw
`ip_address` or `user_agent` column on the audit table, because that guide's PII rule forbids
storing a raw address at all.

### Erasure via `admin_db`

All erasure handlers must use `using("admin_db")` to bypass RLS. At the time of erasure, the
user's session may be compromised — RLS protecting their own rows is the wrong behaviour here.

```python
User.objects.using("admin_db").filter(pk=user_id).update(
    email=None, email_token=None,
    phone=None, phone_token=None,
    is_active=False,
)
```

---

## Subject Access Request (Art. 15)

A SAR (Subject Access Request) entitles a data subject to receive a copy of all personal data
held about them.

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

**Do not export** password hashes, TOTP seeds, internal lookup tokens, or cryptographic key
material. Export the plaintext personal data that the subject provided or that was derived from
their activity.

---

## Data Portability (Art. 20)

Data portability applies when processing is based on consent or contract and is carried out by
automated means. The GDPR export view calls each app's `gdpr_export()` service function and
aggregates the results into a single JSON response. CSV output can be generated from the same
structured data if required.

---

## Consent Management (Art. 6–7)

| Basis                                   | When to use                                             | Notes                                                    |
| --------------------------------------- | ------------------------------------------------------- | -------------------------------------------------------- |
| **Consent (Art. 6(1)(a))**              | Marketing, optional features, non-essential cookies     | Must be freely given, specific, informed, unambiguous    |
| **Contract (Art. 6(1)(b))**             | Necessary to provide the service the user signed up for | Email for account, payment data for purchases            |
| **Legitimate interests (Art. 6(1)(f))** | Analytics, fraud prevention, security logging           | Requires LIA (Legitimate Interests Assessment) on record |
| **Legal obligation (Art. 6(1)(c))**     | Financial records, tax, anti-money-laundering           | UK-specific obligations under Companies Act, HMRC rules  |

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
```

_Part of the `project-management/docs/` documentation family. See [`../GDPR-GUIDE.md`](../GDPR-GUIDE.md) for the full index._
