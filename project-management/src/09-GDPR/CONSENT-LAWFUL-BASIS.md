# Consent and Lawful Basis Register

_Template — replace every `[EXAMPLE]` row and `{PLACEHOLDER}` with your project's own data, and delete this note once populated._

This document records the lawful basis under UK GDPR Article 6 for every processing activity carried out by the project, together with any consent mechanism required and the current status of each activity.

**Last reviewed:** {DATE — fill in on first review}

---

## How to read this register

- **One row per processing activity.** Each activity that touches personal data is listed once, with the Article 6 lawful basis it relies on.
- **Lawful basis + Article** cite the specific Art. 6(1) ground. Where a processing activity relies on more than one basis (for example contract and legal obligation), record both.
- **Consent mechanism** is completed only where the basis is consent (Art. 6(1)(a)) or where a transparency notice (Art. 13/14) is required at the point of collection. Consent must be freely given, specific, informed, and unambiguous, and must be as easy to withdraw as to give (Art. 7(3)).
- **Status** records the current state of the activity — for example `Documented`, `Implementation pending`, or `Acceptable`. A fresh register starts with the lawful basis documented for every activity before any personal data is processed.

---

## Lawful Basis Reference

| Basis                | Article      | When applicable                                                                                                                                                                                      |
| -------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Consent              | Art. 6(1)(a) | Processing based on freely given, specific, informed, and unambiguous consent — primarily marketing, optional features, and non-essential cookies. Withdrawable at any time under Art. 7(3)          |
| Contract             | Art. 6(1)(b) | Processing necessary to perform a contract with the data subject, or to take steps at their request before entering a contract                                                                       |
| Legal obligation     | Art. 6(1)(c) | Processing necessary to comply with a legal obligation — primarily financial records, tax, and statutory reporting                                                                                   |
| Vital interests      | Art. 6(1)(d) | Processing necessary to protect the life of the data subject or another person — rare; typically genuine emergencies                                                                                 |
| Public task          | Art. 6(1)(e) | Processing necessary to perform a task carried out in the public interest or in the exercise of official authority                                                                                   |
| Legitimate interests | Art. 6(1)(f) | Processing necessary for the organisation's legitimate interests, where those interests are not overridden by the data subject's rights — requires a Legitimate Interests Assessment (LIA) on record |

---

## Processing Activities Register

| Processing activity                                  | Data categories                                | Lawful basis                            | Article      | Consent mechanism                                                                                                                              | Status     |
| ---------------------------------------------------- | ---------------------------------------------- | --------------------------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| **[EXAMPLE]** Creating and maintaining user accounts | Name, email, password hash (e.g. `users_user`) | Contract — service delivery to the user | Art. 6(1)(b) | None required — contractual necessity; Art. 13 transparency notice at sign-up                                                                  | Documented |
| **[EXAMPLE]** Newsletter subscription                | Email, IP address, user agent                  | Consent                                 | Art. 6(1)(a) | Double opt-in; consent record stored with timestamp, IP, and user agent; unsubscribe link in every email; withdrawable at any time (Art. 7(3)) | Documented |

_Record one row per processing activity: name the activity, the personal-data categories it touches, the Art. 6 lawful basis relied on (with the consent or LIA evidence behind it), the Article cited, any consent or transparency mechanism, and its current status. Cross-reference sibling registers where relevant — see `DATA-INVENTORY.md`, `RETENTION-DELETION.md`, and `THIRD-PARTY-PROCESSORS.md`._

---

## Special Category Data (Article 9)

Special category data — personal data revealing racial or ethnic origin, political opinions, religious or philosophical beliefs, or trade union membership; genetic data; biometric data processed for the purpose of uniquely identifying a person; and data concerning health, sex life, or sexual orientation (Art. 9(1)) — may not be processed unless **one of the conditions in Art. 9(2) applies in addition to an Art. 6 lawful basis**.

Common Art. 9(2) conditions relied on by organisations:

| Condition    | Applies when                                                                               |
| ------------ | ------------------------------------------------------------------------------------------ |
| Art. 9(2)(a) | The data subject has given explicit consent to the specific processing                     |
| Art. 9(2)(b) | Processing is necessary for obligations in the field of employment and social security law |
| Art. 9(2)(h) | Processing is necessary for the provision of health or social care                         |

Record here any activity that intentionally — or foreseeably — processes special category data, the Art. 9(2) condition relied on, and the technical and organisational safeguards applied (access restrictions, encryption, UI warnings against entering such data into free-text fields).

| Processing activity                                              | Data categories                                       | Art. 6 basis | Art. 9(2) condition | Safeguards                                                                      | Status     |
| ---------------------------------------------------------------- | ----------------------------------------------------- | ------------ | ------------------- | ------------------------------------------------------------------------------- | ---------- |
| **[EXAMPLE]** Attached receipt files that may reveal health data | Uploaded files potentially showing health information | Art. 6(1)(b) | Art. 9(2)(b)        | Access restricted by permission level; UI warning on upload; at-rest encryption | Documented |

_If no special category data is intentionally collected, note that here and identify any free-text or file-upload fields where such data could be entered accidentally, together with the mitigation in place._
