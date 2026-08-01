# GDPR Plan — US000 {STORY TITLE}

_Template — copy to `GDPR-PLAN-US###-<DESCRIPTOR>.md`, replace every `{PLACEHOLDER}`
and `[EXAMPLE]` row with this story's own analysis, and delete this note once
populated. This is the **pre-implementation** GDPR gap analysis for a single story;
its post-implementation counterpart is `../IMPLEMENTATION/GDPR-IMPL-US000-TEMPLATE.md`._

| Field           | Value                                                        |
| --------------- | ------------------------------------------------------------ |
| **Story**       | US### — {short title}                                        |
| **Date**        | {DD/MM/YYYY}                                                 |
| **Author**      | {name / agent}                                               |
| **Status**      | Draft / Reviewed / Signed off                                |
| **PII in play** | Yes / No — {one line: what personal data this story touches} |

> If **PII in play = No**, complete the first two rows, record why no personal data is
> processed, and stop. The remaining sections apply only to PII-handling stories.

---

## 1. Personal data introduced or touched

What personal data this story collects, reads, or writes. One row per field.

| Data field        | Table / store   | Purpose               | Data subject | Lawful basis   | Encryption        |
| ----------------- | --------------- | --------------------- | ------------ | -------------- | ----------------- |
| [EXAMPLE] `email` | `example_table` | {why it is collected} | {subject}    | Art. 6(1)({x}) | Yes + HMAC / Hash |

_Add a row for every personal-data field the story introduces or modifies._

## 2. Lawful basis

For each processing activity in this story, state the UK GDPR Art. 6 basis (and Art. 9
condition if special-category data is involved) and the justification.

- **[EXAMPLE] {Activity}** — Art. 6(1)({x}) {basis name}; {one-line justification}.
  Where Art. 6(1)(f), attach a Legitimate Interests Assessment (LIA).

## 3. Retention & deletion

| Data category        | Retention period | Trigger / basis            | Deletion mechanism             |
| -------------------- | ---------------- | -------------------------- | ------------------------------ |
| [EXAMPLE] {category} | {e.g. 24 months} | {contract end / Art. 6(c)} | {scheduled purge / on-erasure} |

_Every PII field needs a retention period and a deletion path — no orphaned PII._

## 4. Data subject rights impact

How this story's data is served for each exercised right. Note any new path required.

- **Access (Art. 15)** — {included in the SAR export? which fields?}
- **Erasure (Art. 17)** — {erasure path for this data; any legal-retention exemption}
- **Portability (Art. 20)** — {machine-readable export applicable? }
- **Rectification / Restriction / Object / Withdraw consent** — {as applicable}

## 5. Third-party processors touched

Any sub-processor this story sends personal data to. Cross-check
`../THIRD-PARTY-PROCESSORS.md` and flag a missing Art. 28 DPA.

- **[EXAMPLE] {Processor}** — {data sent}; Art. 28 DPA {in place / GAP}; transfer
  mechanism {adequacy / SCCs}.

## 6. Consent & PECR

- {Is consent the lawful basis anywhere here? If so, how is it captured and evidenced?}
- {Any electronic marketing / cookies engaging PECR? unsubscribe + prior consent?}

## 7. GDPR tasks & open gaps

Concrete requirements to satisfy **before or during** implementation. Each becomes a
checklist item; the implementation record closes it with evidence.

- [ ] [EXAMPLE] {Add HMAC companion to `example_table.email` for erasure lookup.}
- [ ] [EXAMPLE] {Register a retention purge task for {category}.}

---

## Cross-references

- `../IMPLEMENTATION/GDPR-IMPL-US000-TEMPLATE.md` — the post-implementation record
- `../DATA-INVENTORY.md` · `../CONSENT-LAWFUL-BASIS.md` · `../RETENTION-DELETION.md` —
  the registers this plan feeds into
- `../../01-STORIES/` — the story being analysed
- `project-management/docs/GDPR-GUIDE.md` — the governing GDPR guide
- `project-management/workflows/08-gdpr-compliance/` — the workflow that produces this
