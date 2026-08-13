---
type: guide
skills: [security, stack-django, stack-htmx-templates]
model: opus
---

# Security — Logging, Monitoring, and Incident Response

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Security event logging, monitoring, alerting, and incident response

---

## Security Logging and Monitoring

Security logging is distinct from application logging. Security events require specific retention,
alerting, and tamper protection.

### Events that must be logged

| Event category     | Specific events                                                                                           |
| ------------------ | --------------------------------------------------------------------------------------------------------- |
| Authentication     | Successful login, failed login, logout, MFA success, MFA failure, password reset request, password change |
| Authorisation      | Access denied (403), privilege escalation attempt, role change, permission grant/revoke                   |
| Admin actions      | User creation/deletion, role assignment, configuration change, secret rotation                            |
| Data access        | Access to Restricted-tier data, bulk data export, API key creation/revocation                             |
| Security incidents | Rate limit triggered, account lockout, invalid CSRF token, malformed request rejected, WAF block          |

### What must never be logged

- Passwords (plaintext or hashed).
- Authentication tokens, session IDs, API keys, or any other credential.
- Full credit card numbers, CVVs, or bank account numbers.
- Unmasked PII beyond what is necessary for identification in the log (e.g., log user ID, not full
  name + email + address).

### Log format and integrity

- Use structured logging (JSON) with consistent fields: `timestamp`, `event_type`, `actor` (user ID
  or service name), `resource`, `action`, `outcome` (success/failure), `ip_address`, `request_id`.
- Include a correlation ID / request ID in every log entry so that events from the same request can
  be traced across services.
- Store security logs separately from application logs where possible. Security logs should have a
  longer retention period and stricter access controls.
- Security logs must be append-only. Application code must not be able to delete or modify existing
  log entries. In production, forward logs to a centralised system (ELK, Loki, CloudWatch, or
  equivalent) that enforces immutability.

### Alerting

- Alert immediately on: multiple failed login attempts from the same IP (threshold: 10 in 5
  minutes), successful login from a new country/region, privilege escalation, access to
  Restricted-tier data outside normal patterns, and any rate limit breach on authentication
  endpoints.
- Review security logs weekly for anomalies even in the absence of alerts.

---

## Incident Response (Developer-Facing)

> **The operator playbook is [`how-to/docs/INCIDENT-PRACTICE.md`](../../../how-to/docs/INCIDENT-PRACTICE.md).**
> This document keeps owning the **build** side — the controls, what must be logged, and the
> regulatory duty; `INCIDENT-PRACTICE.md` owns what a human does while it is happening: declaring,
> running it, the shift handover, standing down, and the blameless postmortem. The postmortem's
> residue lands in `project-management/src/22-INCIDENTS/`, which is **PII-free by rule** — the
> substance goes to the project's incident tracker, never into the repository.
>
> **Four security-specific recoveries are still unwritten, and named here deliberately:** the
> concrete Django shell commands for account compromise (admin token revocation via `admin_db`),
> audit log tampering, Valkey cache compromise, and emergency key rotation. `INCIDENT-PRACTICE.md`
> is the general practice, not those four runbooks. The gap is recorded in
> `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` — write the commands down as you use them.

When you discover a security vulnerability or suspect a breach, follow this process. Speed matters —
the faster the response, the smaller the impact.

### 1. Contain

- If a secret is compromised, rotate it immediately. Do not wait for approval — rotate first,
  document later.
- If a vulnerability is actively exploited, disable the affected endpoint or feature.
- If user data may have been exposed, preserve all relevant logs before they rotate out.

### 2. Notify

- Notify the project lead and security contact within 1 hour of discovery.
- Do not discuss the vulnerability in public channels (Slack, GitHub issues, public commits) until
  it is resolved.
- If the vulnerability affects user data, the project lead will determine whether regulatory
  notification is required (e.g., ICO notification under UK GDPR within 72 hours).

### 3. Investigate

- Determine the scope: what data was exposed, how many users were affected, how the vulnerability
  was introduced, and how long it has been present.
- Review access logs, deployment history, and git history for the affected components.
- Document findings as you go — the incident report will be assembled from these notes.

### 4. Fix

- Develop and test the fix in a private branch if the vulnerability is not yet public.
- The fix must include a test that verifies the vulnerability is closed.
- Deploy the fix to production as a priority. Follow the normal deployment process but escalate
  review times.

### 5. Document

- Write an incident report covering: timeline, root cause, impact, fix applied, and follow-up
  actions to prevent recurrence. The format is `how-to/docs/INCIDENT-PRACTICE.md` § 5.
- **The report splits in two, and the split is a security control, not a filing preference.** A
  PII-free register entry — that it happened, severity, dates, outcome, status — goes to
  `project-management/src/22-INCIDENTS/`, which is in git and ships. Everything else — log
  excerpts, identifiers, affected counts, and any report touching personal data or credentials —
  goes to the project's incident tracker, or outside the repository where there is none. Never
  relax that to keep a report in one piece.
- Update security controls, checklists, and this document if the incident reveals a gap.

### Rules

- Never attempt to "quietly fix" a security issue without notifying the team.
- Never blame an individual. Incident reports focus on process, systems, and controls — not people.
- Every incident results in at least one follow-up action. An incident that produces no follow-up
  action was not investigated thoroughly.

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
