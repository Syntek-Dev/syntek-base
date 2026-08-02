# Breach Notification Procedure

_Template — replace every `[EXAMPLE]` row and `{PLACEHOLDER}` with your project's own data, and delete this note once populated._

This document defines the personal data breach response procedure for the project, covering detection, containment, assessment, ICO notification, data subject notification, and post-incident review. It operates under UK GDPR Articles 33 and 34 and the UK Data Protection Act 2018.

**Last reviewed:** {DATE — fill in on first review}

---

## Legal Framework

| Obligation                               | Article            | Requirement                                                                                                           |
| ---------------------------------------- | ------------------ | --------------------------------------------------------------------------------------------------------------------- |
| Controller notification to ICO           | UK GDPR Art. 33    | Within **72 hours** of becoming aware of a breach likely to result in a risk to individuals                           |
| Controller documentation of all breaches | UK GDPR Art. 33(5) | All breaches must be documented, including those not reported to the ICO                                              |
| Data subject notification                | UK GDPR Art. 34    | Without undue delay if the breach is likely to result in **high risk** to individuals                                 |
| Supervisory authority                    | UK DPA 2018        | The ICO is the relevant supervisory authority. ICO breach portal: ico.org.uk/make-a-complaint/data-security-concerns/ |

The 72-hour clock starts from the moment any person in the organisation becomes aware of the breach, not from the time it is confirmed or assessed.

---

## Definition of a Personal Data Breach

A personal data breach is a breach of security leading to the accidental or unlawful:

- **Destruction** of personal data
- **Loss** of personal data (including backups)
- **Alteration** of personal data
- **Unauthorised disclosure** of personal data
- **Unauthorised access** to personal data

### Example Breach Scenarios

The scenarios that constitute a breach depend on the personal data the project holds. Record the project's own scenarios below, rating each against the severity classification.

| Scenario                                                     | Data at risk                                                                                                                      | Severity |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [EXAMPLE] Primary database credential leaked or brute-forced | All personal data across every table (encrypted-at-rest fields remain protected only while the encryption keys are uncompromised) | Critical |

_Guidance: list the concrete breach scenarios specific to the project's data stores, integrations, and encryption boundaries, and assign each a severity._

---

## Severity Classification

| Severity     | Description                                                                                                                                                         | Examples                                                                                |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| **Critical** | Encryption key exposure or full database dump with key access; breach affects all or most data subjects; irreversible harm likely                                   | Encryption key leaked; privileged database credential exposed alongside encryption keys |
| **High**     | Significant PII categories exposed for a large number of data subjects; financial data, health information, or credentials included; third-party system compromised | Third-party processor compromised; admin access token theft; backup with keys leaked    |
| **Medium**   | Moderate number of data subjects affected; limited category of PII; harm possible but not certain; integrity breach without confidentiality breach                  | Single-user account compromise; wrong-recipient email; audit log tampering              |
| **Low**      | Small number of data subjects; low-sensitivity data; harm unlikely                                                                                                  | Single enquiry email to wrong address; minor misconfiguration without confirmed access  |

---

## Response Procedure

### Phase 1 — Detection and Initial Notification (0–2 hours)

1. Any team member who becomes aware of a potential breach **must immediately** notify the designated incident contact.
2. Record the date and time of first awareness — the 72-hour ICO clock starts here.
3. Do not attempt to remediate before preserving evidence.

**Immediate internal actions:**

- Notify the responsible incident lead or area owner without delay.
- Create an incident record at `docs/INCIDENTS/BREACH-{YYYY-MM-DD}-{SHORT-TITLE}.md` within the repository (or an equivalent secure location if the repository itself may be affected).
- Assign a severity rating using the classification table above.

---

### Phase 2 — Containment (0–4 hours)

Take the following containment steps depending on the nature of the breach. Do not skip evidence preservation in favour of rapid remediation.

**Evidence preservation (before containment):**

- Capture a database snapshot and relevant cache / session-store state before any credentials are rotated.
- Download and preserve current application logs (web server, application server, background workers) before they rotate.
- Capture error-monitoring events for the relevant time window.

**Containment actions:**

| Scenario                                                               | Containment action                                                                                                                                                                         |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Credentials or access token compromised                                | Revoke all active sessions and access/refresh tokens for the affected account; rotate the application secret key; rotate affected database credentials; deactivate the compromised account |
| Encryption key exposed                                                 | Rotate the affected encryption key(s); re-encrypt affected fields with the new key using the project's zero-downtime key-rotation procedure                                                |
| Database accessible without authentication                             | Restrict database network access immediately; rotate all database credentials                                                                                                              |
| Object / file storage credentials compromised                          | Rotate storage access keys; revoke the compromised credentials; audit access and pre-signed URL logs; assess which files were reachable                                                    |
| [EXAMPLE] Third-party processor account compromised (e.g. a media CDN) | Revoke the processor's API credentials via its dashboard; issue new credentials; update the stored integration record (see `THIRD-PARTY-PROCESSORS.md`)                                    |

_Guidance: add a containment row for each credential, key, or integration the project relies on, naming the concrete rotation or revocation step._

**Broader incident response:** this procedure covers the data-protection notification duties of a personal-data breach; for the organisation's wider security incident-response plan (roles, escalation, communications), see `../09-SECURITY/`.

---

### Phase 3 — Assessment (0–24 hours, before ICO notification)

Complete the following assessment to determine notification obligations:

**Questions to answer:**

1. What categories of personal data are affected?
   - Identity (name, username)
   - Contact (email, phone)
   - Financial (invoice data, payment references)
   - Authentication credentials (password hashes, MFA secrets)
   - Legal records (signed contracts, sign-offs, IP-capture records)
   - Communications (message threads, comments, enquiry messages)
   - Special category data (Art. 9), if any is held
   - Third-party-held data (see `THIRD-PARTY-PROCESSORS.md`)

2. How many data subjects are likely affected? Break this down by the data-subject categories the project holds, for example:
   - Staff and contractors
   - Clients / customers and their users
   - Prospects
   - Public visitors (enquirers, subscribers, commenters)

3. Are the encryption keys confirmed as not compromised? If so, the encrypted fields remain protected even if the database is dumped.

4. What are the likely consequences for data subjects? (Financial harm, identity theft, reputational damage, loss of confidentiality of professional communications)

5. What measures are in place or being taken to mitigate harm?

---

### Phase 4 — ICO Notification (within 72 hours of awareness)

**If the breach is likely to result in a risk to individuals, notify the ICO.**

Low-risk breaches (e.g., encrypted laptop lost with no key exposure, minor misconfiguration with no confirmed access) may not require ICO notification. Document the rationale for not notifying in the incident record.

**ICO notification portal:** https://ico.org.uk/make-a-complaint/data-security-concerns/

**Information required by the ICO:**

- Nature of the breach (categories and approximate number of records affected)
- Categories and approximate number of data subjects affected
- Name and contact details of the Data Protection Officer or lead contact
- Likely consequences of the breach
- Measures taken or proposed to address the breach and mitigate effects
- If full details are not available within 72 hours, an initial notification must still be submitted — the ICO accepts phased reporting

---

### Phase 5 — Data Subject Notification (if High Risk — Art. 34)

If the breach is likely to result in **high risk** to individuals, data subjects must be notified without undue delay.

**Notification is not required if:**

- The affected data was encrypted and the encryption key was not compromised
- Subsequent measures make high risk to individuals unlikely

**If notification is required, notify via:**

- Email to the affected data subject's last known email address
- In-application or in-portal notification for active account holders
- For public contacts with no account, use the email address held on the relevant contact record where it can be retrieved

**Notification content must include:**

- Plain-English description of the nature of the breach
- Name and contact details of the organisation's privacy contact or DPO
- Likely consequences of the breach for the individual
- Measures taken or proposed to address the breach
- What the individual can do to protect themselves

---

### Phase 6 — Post-Incident Review (within 30 days of containment)

Complete the incident record at `docs/INCIDENTS/BREACH-{YYYY-MM-DD}-{SHORT-TITLE}.md` with:

- Full timeline: when the breach occurred, when discovered, when contained, when notified
- Root cause analysis
- Categories of data affected and count of data subjects
- Whether ICO notification was made (include ICO reference number)
- Whether data subject notification was made (and to how many individuals)
- Lessons learned
- Technical and process changes implemented to prevent recurrence

---

## Incident Record Template

Create at `docs/INCIDENTS/BREACH-{YYYY-MM-DD}-{SHORT-TITLE}.md`.

```markdown
# Breach Record — {SHORT-TITLE}

**Date of occurrence:** DD/MM/YYYY (estimated if unknown)
**Date of discovery:** DD/MM/YYYY HH:MM (<%TIMEZONE%>)
**Date of containment:** DD/MM/YYYY HH:MM
**Severity:** Critical / High / Medium / Low
**ICO notified:** Yes / No — Reference: {ICO-REF} (if yes)
**Data subjects notified:** Yes / No — Count: {N}

## Data categories affected

<!-- List all affected categories from the inventory -->

## Number of data subjects affected (approximate)

## Likely consequences

## Containment actions taken

## Mitigating factors

## ICO notification submitted

## Data subject notification details

## Lessons learned and remediation actions
```

---

## Notification Obligations by Severity

| Severity | ICO notification                        | Data subject notification                                  | Deadline                                          |
| -------- | --------------------------------------- | ---------------------------------------------------------- | ------------------------------------------------- |
| Critical | Required                                | Required if encryption keys compromised                    | ICO: 72 hours; data subjects: without undue delay |
| High     | Required                                | Required unless data was encrypted with uncompromised keys | ICO: 72 hours; data subjects: without undue delay |
| Medium   | Assess case by case — likely required   | Required only if high risk confirmed                       | ICO: 72 hours if risk present                     |
| Low      | Likely not required — document decision | Not required                                               | Document rationale within 72 hours                |

All breaches, including those not reported to the ICO, must be documented under Art. 33(5).
