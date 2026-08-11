---
type: guide
agent: security
skills: [stack-django]
model: opus
---

# Security: The Audit Trail

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus (audit table schema, atomic write path, PII rule, retention, tamper resistance)

This is the owning guide for the audit trail, the record half of the OWASP **A09:2025 (Security
Logging and Alerting Failures)** control in this stack, which is why the A09 row in
[`OWASP-AND-CHECKLIST.md`](OWASP-AND-CHECKLIST.md) names this guide for the record and its
neighbour [`MONITORING-AND-INCIDENT.md`](MONITORING-AND-INCIDENT.md) for alerting and response.
That neighbour owns incident practice: which events must be observed, how alerting is configured,
and what a responder does. This guide owns the **record**.

---

## The spine: a table, not log output

The audit trail is **a PostgreSQL table with legal weight**. It is not a log file, not a
GlitchTip event, and not a Loki stream. The distinction decides every rule below.

|                | Audit trail                                        | Application logs                         |
| -------------- | -------------------------------------------------- | ---------------------------------------- |
| Lives in       | A relational table in the primary database         | Files, stdout, Loki, GlitchTip           |
| Written by     | The service layer, inside the business transaction | Any module, at any point                 |
| Answers        | "Who changed what, when, and was it allowed?"      | "Why did this request behave like that?" |
| Lost on        | Nothing short of losing the database               | Rotation, container restart, sampling    |
| Deleted by     | A dated retention policy only                      | Rotation, freely                         |
| Evidence value | Disclosable, relied on in a breach report          | Diagnostic only                          |

Because the trail is queried, joined, constrained and backed up like any other table, it survives
the failure modes that make logs unusable as evidence. That is the whole point: when the ICO asks
what happened to a data subject's record on a given date, a rotated log file is not an answer.

**Not yet built.** This template ships no application code beyond the Django skeleton, so
everything below describes what a feature **must build** the first time it needs the trail, not
shipped code. The first feature to write user-owned data stands up `apps.<%AUDIT_APP%>` in full,
because a trail added later has a hole in it exactly where the early stories are.

---

## The schema

One table, `audit_auditlog`, owned by `apps.<%AUDIT_APP%>`.

| Column            | Type                        | Rule                                                           |
| ----------------- | --------------------------- | -------------------------------------------------------------- |
| `id`              | `uuid` primary key          | Never a sequential integer: the count leaks activity volume    |
| `timestamp`       | `timestamptz NOT NULL`      | Server time, indexed, defaulted in the database                |
| `action`          | `text NOT NULL`             | Registered constant, `DOMAIN.SUBJECT.VERB` (see write path)    |
| `actor_type`      | `text NOT NULL`, `CHECK`    | Bounded set: admin, portal user, system, task                  |
| `actor_id`        | `uuid NULL`                 | Null means a system or unauthenticated actor, or an erased one |
| `target_type`     | `text NOT NULL`, `CHECK`    | The kind of thing acted on                                     |
| `target_id`       | `uuid NULL`                 | The instance acted on, where there is one                      |
| `affected_module` | `text NULL`, `CHECK`        | The permission module in a grant or revoke                     |
| `outcome`         | `text NOT NULL`, `CHECK`    | `success` or `failure`: a refusal is an entry, not a non-event |
| `ip_hash`         | `text NULL`                 | One-way hash, never a raw address (see the PII rule)           |
| `request_id`      | `text NULL`                 | The correlation ID that ties the entry to its log lines        |
| `metadata`        | `jsonb NOT NULL`, defaulted | Bounded structured detail, never free text, never PII          |

Two consequences of [`../DATABASE.md`](../DATABASE.md) that bite here specifically:

- **Every bounded column carries a database `CHECK`.** An audit row that application code
  believed was valid, and the database never verified, is worth nothing in an incident.
- **`actor_id` and `target_id` carry no foreign key**, and this is the deliberate exception to
  the standing rule. `ON DELETE CASCADE` would let deleting a user erase the record of what that
  user did; `RESTRICT` would block a lawful erasure. The trail references by value and says so in
  `db_table_comment`, alongside the reason.

Indexes follow the two questions the trail is actually asked (see _Reading it_ below), never
speculation.

---

## The write path

**One entry point, in the service layer.** Views, Django Ninja endpoints, templates and Celery
tasks never write to the table directly; they call the audit app's single write function. Existing
examples in this tree spell that seam `AuditService.log()` (in
[`../architecture/SERVICE-AND-MIDDLEWARE.md`](../architecture/SERVICE-AND-MIDDLEWARE.md)) and
`write_audit()` (in
[`project-management/docs/gdpr/COMPLIANCE.md`](../../../project-management/docs/gdpr/COMPLIANCE.md)).
They describe the same seam, and a project keeps exactly one of them: two write paths mean two sets
of rules and one of them will be wrong. Everything below is written in the first spelling, matching
the service-layer guide; a project that settles on the other renames the call and changes nothing
else.

**Action strings are registered before use.** They live in `apps/<%AUDIT_APP%>/constants.py` in
`DOMAIN.SUBJECT.VERB` form, and the write function raises `ValueError` for an unregistered action.
An unregistered string is a typo that silently splits a query result in half two years later.

### The transaction rule

**An audit entry that records a data change is written inside the same `transaction.atomic()`
block as that change.** The two commit together or roll back together. There is no ordering in
which a change lands without its entry, or an entry claims a change that never landed.

```python
from apps.<%AUDIT_APP%> import constants as audit_constants
from apps.<%AUDIT_APP%>.services import AuditService

with transaction.atomic():
    item.save()
    AuditService.log(
        audit_constants.ORDER_CREATED,
        actor_id=actor.pk,
        actor_type="admin",
        target_type="order",
        target_id=item.pk,
        outcome="success",
    )
```

The [AdminMember/ModulePermission contract](../architecture/AUTH-CONTRACT.md) is the strictest
case: a privilege change is not done until its entry is in the same block.

### The one exception, and its boundary

An entry recording something that **did not change data** has no partner write to roll back: a
denied request (403), a rate-limit trip, a read of Restricted-tier data. Those are written on
their own, best effort, outside any business transaction, so that a failure to record cannot turn
a correct refusal into a 500. That is the entire scope of the exception. Best-effort writing is
never a way to make a data change cheaper.

---

## What must be recorded

The event categories are owned by [`MONITORING-AND-INCIDENT.md`](MONITORING-AND-INCIDENT.md) and
are not restated here. Four classes reach the **table** specifically, because a log line would not
be sufficient evidence:

1. **Every state-changing service operation**, with its actor, target and outcome.
2. **Every authorisation refusal** on a privileged path, including the failed attempt that the
   auth contract rejects at the area-admin or superadmin gate.
3. **Every data-subject rights operation**: erasure, subject access export, consent given or
   withdrawn, restriction, objection. The GDPR guide requires this as an Article 30 accountability
   record, not as diagnostics.
4. **Every retention or purge run**, with the row counts it affected. That entry is itself subject
   to the retention policy below.

---

## The PII rule

The trail is a security control that happens to hold personal data, which makes it the easiest
place in the system to create a liability while trying to reduce one.

- **Never store a credential.** No passwords (hashed or not), no tokens, no session IDs, no API
  keys, no MFA secrets. This is absolute and has no justified exception.
- **Store identifiers, not identities.** An `actor_id` is sufficient to attribute an action.
  A name, an email address and a postal address in the same row are not attribution, they are a
  copy of the user record with a worse access-control story.
- **An IP address is personal data, so it is stored one-way hashed and named for what it holds:
  `ip_hash`, never `ip_address`.** Hash with the full-length one-way helper described in
  [`../logging/DJANGO-LOGGING.md`](../logging/DJANGO-LOGGING.md), not the truncated prefix that
  guide uses for log lines. A hash still answers the question the trail is asked ("did this same
  origin appear on those other entries?") without holding the datum, and it is disclosed in a
  subject access response as an IP address reference (hashed).
- **`metadata` is where PII leaks.** It carries bounded, named keys chosen at design time. Never
  a serialised request body, never a diff of a record's contents, never an exception message.

---

## Retention and immutability

**Entries are anonymised on erasure, never deleted.** When a data subject exercises Article 17,
the audit app's erasure handler nulls `actor_id` and `ip_hash` and leaves the row, its action, its
target and its timestamp intact. The reasoning is not a technicality: the entry is the evidence
that the erasure was performed lawfully and on time, so deleting it destroys the proof of the
compliance it was performed for. A subject request never deletes an audit row. The handler runs in
one `transaction.atomic()` block and writes its own entry (class 3 above) recording that the
erasure happened.

**Where this guide overrules the GDPR sub-document.** The `gdpr_erase` example in
[`project-management/docs/gdpr/DATA-RIGHTS.md`](../../../project-management/docs/gdpr/DATA-RIGHTS.md)
describes an earlier shape of this table and disagrees with the schema above on four points. This
guide owns the audit trail, so the schema above is the authority and that example is the thing to
correct:

- **The model is `AuditLog` in `apps.<%AUDIT_APP%>`, table `audit_auditlog`**, not `AuditEntry`
  in `audit_auditentry`. `audit_auditlog` is the name the story template, the sprint template and
  the auth contract already write their checklists against, so the example moves, not the tree.
- **`actor_id` is set to `NULL`, not to an `[anonymised]` sentinel string.** The column is `uuid`,
  and widening it to text so that a few rows can carry a marker would forfeit the type constraint
  on every other row. What the sentinel was carrying is not lost: `actor_type` is `NOT NULL` and
  erasure does not touch it, so the class of actor survives the erasure even though the identity
  does not. Distinguishing an **erased** actor from one that never had an id is a separate
  question, and a null `actor_id` alone does not answer it (the schema gives that null three
  meanings). A story that needs the distinction records it explicitly, as a `metadata` key set by
  the erasure handler, never inferred from `actor_type`.
- **There is no `ip_address` column to null.** The PII rule above forbids storing a raw address at
  all, so the handler nulls `ip_hash`, which is the column that exists.
- **There is no `user_agent` column either.** A user-agent string, if a story ever justifies
  recording one, is a bounded `metadata` key, and the same handler drops that key.

**Deletion is time-based only.** A scheduled purge removes entries past
the audit app's `RETENTION_DAYS` setting, configured in Django settings and never hardcoded, run from
the Celery Beat schedule, and idempotent. The retention window for processing records is normally
the duration of the processing activity plus the applicable limitation period, six years under the
UK Limitation Act 1980. Full obligations:
[`project-management/docs/gdpr/COMPLIANCE.md`](../../../project-management/docs/gdpr/COMPLIANCE.md).

**Nothing else writes over an entry.** No admin edit surface, no correction workflow, no
"tidy-up" migration. An entry that was wrong when written stays wrong and is superseded by a new
entry recording the correction.

---

## Tamper resistance

Audit log tampering is a named incident category in
[`MONITORING-AND-INCIDENT.md`](MONITORING-AND-INCIDENT.md), and that guide is explicit that no
operator runbook for it exists yet. Design so the tampering is hard and visible:

- **Enforce append-only at the database role, not in Python.** The role the Django application
  connects as holds `INSERT` and `SELECT` on the table and nothing else. Application code that
  cannot issue an `UPDATE` cannot be tricked into issuing one.
- **The two legitimate mutations run elsewhere.** Retention purge and GDPR anonymisation are the
  only paths that delete or overwrite, and both run through `admin_db` because
  [`project-management/docs/gdpr/COMPLIANCE.md`](../../../project-management/docs/gdpr/COMPLIANCE.md)
  requires it: retention tasks query user-scoped rows through `admin_db`, and the `gdpr_erase`
  handler uses `using("admin_db")` to bypass RLS. Neither path is covered by the `admin_db`
  allowlist in [`OWASP-AND-CHECKLIST.md`](OWASP-AND-CHECKLIST.md), which enumerates login,
  password-reset token lookup and superuser audit PII resolution, and whose pre-commit hook
  excludes only the two authentication files. **The audit app's purge task and erasure handler
  therefore need their own enumerated exception, added to that allowlist and to the hook when the
  app is built.** Adding any further mutation path is a security decision, not an implementation
  detail.
- **Detect what you cannot prevent.** A database superuser can still edit rows, so the trail needs
  one of two backstops, chosen when the audit app is built: a per-row hash chained over the
  previous row (verified by a scheduled integrity check that alerts on a break), or shipping every
  entry off-box to an append-only store as it is written. Pick one deliberately and record the
  choice in an ADR; shipping neither means tampering is undetectable, which is the A09 failure in
  its pure form.
- **Reading the trail is itself an audited event** when the read resolves personal data.

---

## Reading it during an incident

The trail answers exactly two questions, and its indexes exist to serve them:

1. **What did this actor do?** `(actor_id, timestamp DESC)`.
2. **Who touched this resource?** `(target_type, target_id, timestamp DESC)`.

A third, `(action, timestamp DESC)`, supports "how often has this happened lately", which is what
alert triage asks.

**The trail and the logs are read together, and neither substitutes for the other.** The trail
says what changed and whether it was permitted; Loki and GlitchTip say what the request was doing
when it changed. `request_id` is the join between them, which is why it is a column rather than
something buried in `metadata`.

**Snapshot it before anything else.** The containment step in
[`MONITORING-AND-INCIDENT.md`](MONITORING-AND-INCIDENT.md) says to preserve logs before they
rotate. The trail does not rotate, and that is precisely why it is the artefact to snapshot first:
it is the only account of the incident that will still be complete a week later. Take the database
snapshot, then work from the copy, so the investigation cannot be accused of having altered the
evidence.

The response procedure itself, containment through to the incident report, stays in
[`MONITORING-AND-INCIDENT.md`](MONITORING-AND-INCIDENT.md).

---

## Cross-references

- [`OWASP-AND-CHECKLIST.md`](OWASP-AND-CHECKLIST.md): the A09 row and the pre-deploy checklist
- [`MONITORING-AND-INCIDENT.md`](MONITORING-AND-INCIDENT.md): event categories, alerting, incident procedure
- [`../architecture/AUTH-CONTRACT.md`](../architecture/AUTH-CONTRACT.md): the privileged-change contract the trail closes
- [`../architecture/SERVICE-AND-MIDDLEWARE.md`](../architecture/SERVICE-AND-MIDDLEWARE.md): where the write sits in the service layer
- [`../logging/DJANGO-LOGGING.md`](../logging/DJANGO-LOGGING.md): the hashing helper and the never-log-a-raw-IP rule
- [`../DATABASE.md`](../DATABASE.md): constraints in the database, index discipline, lock-safe migrations
- [`project-management/docs/gdpr/COMPLIANCE.md`](../../../project-management/docs/gdpr/COMPLIANCE.md): retention scheduling and the anonymise-never-delete obligation
- [`project-management/docs/gdpr/DATA-RIGHTS.md`](../../../project-management/docs/gdpr/DATA-RIGHTS.md): the erasure and export handlers the audit app must provide (its `gdpr_erase` example predates this guide: see _Retention and immutability_ for the four points on which this guide overrules it)

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
