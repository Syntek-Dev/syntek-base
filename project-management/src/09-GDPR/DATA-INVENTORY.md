# Data Inventory

_Template — replace every `[EXAMPLE]` row and `{PLACEHOLDER}` with your project's own data, and delete this note once populated._

This document records every category of personal data the project collects, the model or table that holds it, the purpose for which it is collected, the class of data subject it relates to, its encryption status, and the user story that introduced it.

**Last reviewed:** {DATE — fill in on first review}

---

## How to Read This Inventory

- **Data subject types:** Admin Member (the organisation's staff or contractor), Client (business client), Portal User (a client's team member accessing the portal), Prospect (pre-sales individual), Public Visitor (unauthenticated site visitor). Adjust this list to the subject classes your project actually holds.
- **Encrypted:** `Yes` = application-layer field encryption (e.g. `EncryptedField`, AES-256-GCM). `HMAC` = a keyed-hash lookup companion enabling exact-match search over encrypted data. `Hash` = one-way hashing (e.g. Argon2id), irreversible. `No` = plaintext at rest (record the justification).
- Source stories are referenced in the `Introduced` column in the format `US###`.

---

## 1. User Identity and Authentication

| Data field          | Table        | Purpose                               | Data subject | Encrypted                                               | Introduced |
| ------------------- | ------------ | ------------------------------------- | ------------ | ------------------------------------------------------- | ---------- |
| `[EXAMPLE]` `email` | `users_user` | Account authentication, notifications | Admin Member | Yes — encrypted email field + HMAC companion for lookup | {US###}    |

_Record each identity and authentication field: which table holds it, why it is collected, whose data it is, and how it is protected at rest._

### 1a. Public Account Users

| Data field                 | Table        | Purpose                                            | Data subject | Encrypted          | Introduced |
| -------------------------- | ------------ | -------------------------------------------------- | ------------ | ------------------ | ---------- |
| `[EXAMPLE]` `display_name` | `users_user` | Public-facing display name on profile and comments | Public User  | No — public-facing | {US###}    |

_Record fields added for public / self-service accounts that are distinct from internal staff identity fields._

### 1b. Passkey Devices

| Data field                  | Table                 | Purpose                                                              | Data subject | Encrypted                       | Introduced |
| --------------------------- | --------------------- | -------------------------------------------------------------------- | ------------ | ------------------------------- | ---------- |
| `[EXAMPLE]` `credential_id` | `users_passkeydevice` | WebAuthn credential handle — random bytes, not a personal identifier | Public User  | No — not PII by WebAuthn design | {US###}    |

_Record WebAuthn / passkey device fields. Note where a field is not personal data by design (a credential handle or public key does not identify an individual without the linked account row)._

### 1c. MFA Recovery Codes

| Data field                       | Table                   | Purpose                                                            | Data subject | Encrypted                      | Introduced |
| -------------------------------- | ----------------------- | ------------------------------------------------------------------ | ------------ | ------------------------------ | ---------- |
| `[EXAMPLE]` `recovery_code_hash` | `users_mfarecoverycode` | Hashed one-time recovery codes; raw codes shown once, never stored | Public User  | Hash (Argon2id — irreversible) | {US###}    |

_Record MFA recovery / backup code storage. Raw codes should be displayed once and never persisted._

---

## 2. Prospect Users

| Data field          | Table                | Purpose                              | Data subject | Encrypted                     | Introduced |
| ------------------- | -------------------- | ------------------------------------ | ------------ | ----------------------------- | ---------- |
| `[EXAMPLE]` `email` | `users_prospectuser` | Prospect portal invitation and login | Prospect     | Yes + HMAC (lookup companion) | {US###}    |

_Record personal data held about pre-sales prospects — invitation tokens, login credentials, and invitation audit fields._

---

## 3. Client Records

| Data field                  | Table            | Purpose                       | Data subject | Encrypted                     | Introduced |
| --------------------------- | ---------------- | ----------------------------- | ------------ | ----------------------------- | ---------- |
| `[EXAMPLE]` `contact_email` | `clients_client` | Primary contact communication | Client       | Yes + HMAC (lookup companion) | {US###}    |

_Record client organisation and primary-contact fields — company name, contact identity, contact channels, and free-text notes._

---

## 4. Client Portal Users

| Data field          | Table               | Purpose                        | Data subject | Encrypted                     | Introduced |
| ------------------- | ------------------- | ------------------------------ | ------------ | ----------------------------- | ---------- |
| `[EXAMPLE]` `email` | `portal_portaluser` | Portal login and notifications | Portal User  | Yes + HMAC (lookup companion) | {US###}    |

_Record personal data for a client's team members who log in to the portal — login identity, display name, and credentials._

---

## 5. Enquiries and Contact Forms

| Data field               | Table             | Purpose                            | Data subject   | Encrypted                     | Introduced |
| ------------------------ | ----------------- | ---------------------------------- | -------------- | ----------------------------- | ---------- |
| `[EXAMPLE]` `ip_address` | `contact_enquiry` | Rate limiting and fraud prevention | Public Visitor | Yes + HMAC (lookup companion) | {US###}    |

_Record data submitted through public enquiry / contact forms, and any consent-evidence fields (IP address, user agent) captured alongside._

---

## 6. Blog Comments

| Data field                    | Table              | Purpose                          | Data subject   | Encrypted | Introduced |
| ----------------------------- | ------------------ | -------------------------------- | -------------- | --------- | ---------- |
| `[EXAMPLE]` `commenter_email` | `blog_blogcomment` | Moderate and contact a commenter | Public Visitor | Yes       | {US###}    |

_Record fields captured when a visitor submits a comment — name, email, optional website, and the comment body itself._

---

## 7. Newsletter

| Data field          | Table                   | Purpose                           | Data subject   | Encrypted                     | Introduced |
| ------------------- | ----------------------- | --------------------------------- | -------------- | ----------------------------- | ---------- |
| `[EXAMPLE]` `email` | `newsletter_subscriber` | Deliver newsletter communications | Public Visitor | Yes + HMAC (lookup companion) | {US###}    |

_Record subscriber data and the consent-evidence fields (IP, user agent, consent timestamp) that prove the lawful basis. Per-type consent and retention of consent evidence after unsubscribe are recorded in `RETENTION-DELETION.md`._

---

## 8. Cookie and Document Consent

| Data field               | Table                 | Purpose                    | Data subject   | Encrypted | Introduced |
| ------------------------ | --------------------- | -------------------------- | -------------- | --------- | ---------- |
| `[EXAMPLE]` `ip_address` | `legal_cookieconsent` | Evidence of cookie consent | Public Visitor | Yes       | {US###}    |

_Record the consent-evidence fields captured for cookie banners and document (terms) acceptance — IP address and user agent at the moment of consent._

---

## 9. Proposals and Amendments

| Data field                   | Table                | Purpose                          | Data subject | Encrypted                     | Introduced |
| ---------------------------- | -------------------- | -------------------------------- | ------------ | ----------------------------- | ---------- |
| `[EXAMPLE]` `prospect_email` | `proposals_proposal` | Deliver proposal and communicate | Prospect     | Yes + HMAC (lookup companion) | {US###}    |

_Record personal data held in proposals and negotiation amendments — recipient identity and any free-text negotiation comments._

---

## 10. Outreach Sent Email Log

| Data field                    | Table                | Purpose                                | Data subject              | Encrypted                     | Introduced |
| ----------------------------- | -------------------- | -------------------------------------- | ------------------------- | ----------------------------- | ---------- |
| `[EXAMPLE]` `recipient_email` | `outreach_sentemail` | Record who received the outreach email | Prospect / Public Visitor | Yes + HMAC (lookup companion) | {US###}    |

_Record outbound email audit data. Flag any field (e.g. a rendered body snapshot or subject line) that may contain PII after merge substitution, and note whether it is encrypted._

---

## 11. Client Portal: Communications and Collaboration

| Data field            | Table            | Purpose                             | Data subject         | Encrypted | Introduced |
| --------------------- | ---------------- | ----------------------------------- | -------------------- | --------- | ---------- |
| `[EXAMPLE]` `content` | `portal_message` | Client-admin message thread content | Client / Portal User | Yes       | {US###}    |

_Record free-text and IP-capture fields across portal collaboration features — messages, comments, sign-off reasons, review feedback, and the IP recorded at each approval action._

---

## 12. Contract and Document Signing

| Data field                | Table                        | Purpose                           | Data subject         | Encrypted | Introduced |
| ------------------------- | ---------------------------- | --------------------------------- | -------------------- | --------- | ---------- |
| `[EXAMPLE]` `signer_name` | `documents_signabledocument` | Legal identity of contract signer | Client / Portal User | Yes       | {US###}    |

_Record signer identity and the IP address captured at the moment of signing and countersigning._

---

## 13. Invoices and Financial Records

| Data field          | Table             | Purpose                                                | Data subject | Encrypted | Introduced |
| ------------------- | ----------------- | ------------------------------------------------------ | ------------ | --------- | ---------- |
| `[EXAMPLE]` `notes` | `clients_invoice` | Invoice free-text notes (may reference client context) | Client       | Yes       | {US###}    |

_Record any free-text on financial records that may contain personal data. The core invoice record (client reference, line items, amounts, due date) is financial data held under legal obligation (Art. 6(1)(c)); note where it is transferred to an accounting sub-processor — see `THIRD-PARTY-PROCESSORS.md`._

---

## 14. Support Tickets

| Data field                 | Table                   | Purpose                                                    | Data subject         | Encrypted | Introduced |
| -------------------------- | ----------------------- | ---------------------------------------------------------- | -------------------- | --------- | ---------- |
| `[EXAMPLE]` `browser_info` | `support_supportticket` | Auto-captured debugging context (browser, OS, device, URL) | Client / Portal User | Yes       | {US###}    |

_Record auto-captured debugging context on support tickets. Ensure encryption is applied consistently with the equivalent fields elsewhere in this inventory (e.g. user-agent data in consent tables)._

---

## 15. Audit Log

| Data field            | Table            | Purpose                                                             | Data subject               | Encrypted / PII?                                                                             | Introduced |
| --------------------- | ---------------- | ------------------------------------------------------------------- | -------------------------- | -------------------------------------------------------------------------------------------- | ---------- |
| `[EXAMPLE]` `ip_hash` | `audit_auditlog` | One-way (or keyed-HMAC) hash of the request IP; raw IP never stored | Admin Member / Portal User | Not reversible without the original IP — disclosed in SAR as "IP address reference (hashed)" | {US###}    |

_Record audit-log fields. Design the audit table to hold no raw PII: store identifiers as opaque integers (FKs), one-way hashes, or hash prefixes only._

**Lawful basis:** Art. 6(1)(c) — legal obligation (security logging required under UK GDPR Art. 32). Audit rows are **exempt from the Right to Erasure** under Art. 17(3)(b). Record the retention period in `RETENTION-DELETION.md`. Where a keyed-HMAC is used for the IP hash, note that rotating the key de-correlates historical hashes without re-deriving any raw IP.

---

## 15a. Application Debug Logs

| Data field                       | Description                                                      | PII?                                                                                      | Retention                          | Lawful basis                                                               |
| -------------------------------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------- | -------------------------------------------------------------------------- |
| `[EXAMPLE]` Structured log lines | Schema-keyed JSON: timestamp, level, logger, message, request id | No PII — query strings stripped, DB backend logs suppressed; no email, name, or IP logged | {retention period per environment} | Art. 6(1)(f) — legitimate interests (operational monitoring and debugging) |

_Record what the application's structured logs contain, confirm PII is scrubbed at source, and state the retention period per environment._

---

## 16. GDPR Request Records

| Data field          | Table             | Purpose                                         | Data subject | Encrypted                     | Introduced |
| ------------------- | ----------------- | ----------------------------------------------- | ------------ | ----------------------------- | ---------- |
| `[EXAMPLE]` `email` | `gdpr_sarrequest` | Verify data-subject identity and deliver export | Any          | Yes + HMAC (lookup companion) | {US###}    |

_Record the personal data held to process subject-access and erasure requests — requester identity, contact email, and admin case notes._

---

## 17. Testimonials, Portfolios, and Case Studies

| Data field                | Table                      | Purpose                                      | Data subject | Encrypted | Introduced |
| ------------------------- | -------------------------- | -------------------------------------------- | ------------ | --------- | ---------- |
| `[EXAMPLE]` `client_name` | `testimonials_testimonial` | Publicly attribute a testimonial to a client | Client       | Yes       | {US###}    |

_Record fields displayed publicly with attribution to a named individual or organisation. Public display of a named individual requires a documented consent basis (Art. 6(1)(a)) or a Legitimate Interests Assessment — record the consent mechanism and the `consent_given_at` evidence field for each contribution table._

---

## 18. Analytics and Observability

| Data field                         | Description                                                   | Purpose                  | Data subject   | Encrypted            | Introduced |
| ---------------------------------- | ------------------------------------------------------------- | ------------------------ | -------------- | -------------------- | ---------- |
| `[EXAMPLE]` IP address (analytics) | Collected by an analytics provider; anonymised before storage | Website usage statistics | Public Visitor | Anonymised at source | {US###}    |

_Record analytics and error-monitoring data. Confirm PII is anonymised or scrubbed before storage; note whether a self-hosted tool removes the need for an Art. 28 sub-processor agreement._

---

## 19. Integration Credentials

| Data field          | Table                     | Purpose                                  | Data subject                          | Encrypted | Introduced |
| ------------------- | ------------------------- | ---------------------------------------- | ------------------------------------- | --------- | ---------- |
| `[EXAMPLE]` `value` | `integrations_credential` | Store OAuth tokens and API keys securely | Not personal PII — system credentials | Yes       | {US###}    |

_Record stored third-party credentials. These are system secrets rather than personal data, but must still be encrypted at rest._

---

## 20. Email Inbox — Admin Member Mailbox Data

Personal data held about admin members, and third-party correspondents, within an email inbox feature.

| Data field                                | Table           | Purpose                                            | Data subject         | Encrypted    | Introduced |
| ----------------------------------------- | --------------- | -------------------------------------------------- | -------------------- | ------------ | ---------- |
| `[EXAMPLE]` Sender email address (cached) | `email_message` | Metadata cache — `From:` address for inbox display | Third party (sender) | Yes (+ HMAC) | {US###}    |

_Record mailbox and cached message-metadata fields. Cached email metadata inherently contains third-party PII (external senders' and recipients' names and addresses). State the lawful basis — typically Art. 6(1)(f) legitimate interests, supported by a Legitimate Interests Assessment — and the retention period in `RETENTION-DELETION.md`._

---

## 21. Expenses

| Data field          | Table              | Purpose                                                         | Data subject | Encrypted | Introduced |
| ------------------- | ------------------ | --------------------------------------------------------------- | ------------ | --------- | ---------- |
| `[EXAMPLE]` `notes` | `expenses_expense` | Free-text notes — may contain personal context about an expense | Admin Member | Yes       | {US###}    |

_Record expense fields and any uploaded receipt files. Receipts may constitute special-category (Art. 9) data if they contain medical or pharmacy items — restrict access and warn on upload. Record the statutory retention period (e.g. tax-record obligations) in `RETENTION-DELETION.md`._

---

## 22. Client Contribution Consent Records

Consent-timestamp fields across contribution tables are personal data retained as evidence of the lawful consent basis (Art. 7(1)).

| Data field                     | Table                      | Purpose                                         | Retention note                                              |
| ------------------------------ | -------------------------- | ----------------------------------------------- | ----------------------------------------------------------- |
| `[EXAMPLE]` `consent_given_at` | `testimonials_testimonial` | Proof that consent was given for public display | Retained even after withdrawal, per `RETENTION-DELETION.md` |

_Record each `consent_given_at` timestamp that evidences consent for public display, and its retention rule on withdrawal._

---

## 23. Document Uploaded Files

| Data field             | Table                    | Purpose                                                           | Data subject | Encrypted                  | Introduced |
| ---------------------- | ------------------------ | ----------------------------------------------------------------- | ------------ | -------------------------- | ---------- |
| `[EXAMPLE]` `filename` | `documents_uploadedfile` | Original filename of an uploaded document — may identify a client | Admin Member | Yes — encrypted text field | {US###}    |

_Record uploaded-file metadata (filename, object-store key) and whether it is encrypted. Consider using a separate key envelope for filename and object key so a compromise of one key does not expose the other. Non-PII technical metadata (MIME type, size, key version) may remain plaintext._
