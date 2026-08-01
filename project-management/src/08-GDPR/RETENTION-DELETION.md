# Retention and Deletion Register

_Template — replace every `[EXAMPLE]` row and `{PLACEHOLDER}` with your project's own data, and delete this note once populated._

This document records the retention period for every personal data category the organisation holds for the project, the trigger event that starts the retention clock, the deletion or anonymisation mechanism, and whether an automated purge task exists for that category.

**Last reviewed:** {DATE — fill in on first review}

---

## How to Read This Register

- **Trigger:** The event that starts the retention clock (e.g., account deactivation, contract end, last activity, submission date).
- **Mechanism:** How deletion or anonymisation is carried out — a scheduled purge task, an application signal/hook, an erasure-service call, or a documented manual procedure.
- **Purge task exists:** Whether an automated deletion task has been defined and scheduled for this category, as opposed to a manual or event-driven process.

---

## Retention Schedule

Record one row per personal data category. Give each category its own retention period, trigger, and deletion mechanism; never leave a category of personal data without a documented retention period.

| Data category                                               | Table        | Retention period                                                   | Trigger                        | Deletion mechanism                                                          | Purge task exists                             |
| ----------------------------------------------------------- | ------------ | ------------------------------------------------------------------ | ------------------------------ | --------------------------------------------------------------------------- | --------------------------------------------- |
| `[EXAMPLE]` Admin user account (email, name, password hash) | `users_user` | Duration of employment/contract + a reasonable deactivation window | Staff departure / contract end | Erasure-service call nullifies the PII fields and sets the account inactive | Scheduled deletion task defined and scheduled |

_Guidance: add a row for every category of personal data the project processes — name the data, its store, the retention period and the statutory or business basis for it, the event that starts the clock, how deletion or anonymisation is carried out, and whether an automated purge task exists. Draw the categories from `DATA-INVENTORY.md`._

---

## Legal Retention — Article 17(3)(b)

The right to erasure (Art. 17) does **not** apply where processing is necessary for compliance with a legal obligation (Art. 17(3)(b)). Where a statutory retention period applies, the record must be retained for that period even if the data subject requests erasure; only non-essential fields (for example, free-text notes) may be cleared before the period expires.

Common UK statutory retention drivers include:

- **Financial and accounting records** — 6 years (Companies Act 2006 / HMRC obligation).
- **Records needed to bring or defend a legal claim** — up to 6 years (Limitation Act 1980).

When a category is retained under Art. 17(3)(b), record the governing statute and its retention period in the schedule above, and disclose the retention to the data subject in the relevant privacy notice.
