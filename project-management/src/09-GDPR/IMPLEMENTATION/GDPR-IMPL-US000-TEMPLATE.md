# GDPR Implementation — US000 {STORY TITLE}

_Template — copy to `GDPR-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`{PLACEHOLDER}` and `[EXAMPLE]` row with this story's verified outcome, and delete this
note once populated. This is the **post-implementation** record; it answers, with
evidence, the plan in `../PLANNING/GDPR-PLAN-US000-TEMPLATE.md`._

| Field           | Value                                           |
| --------------- | ----------------------------------------------- |
| **Story**       | US### — {short title}                           |
| **Date**        | {DD/MM/YYYY}                                    |
| **Verified by** | {name / agent}                                  |
| **Plan doc**    | `../PLANNING/GDPR-PLAN-US###-<DESCRIPTOR>.md`   |
| **Outcome**     | Compliant / Compliant with deviations / Blocked |

---

## 1. Data flows implemented

What personal data the shipped code actually collects, reads, or writes, and the lawful
basis applied. Confirm this matches the plan; flag any addition.

| Data field        | Table / store   | Lawful basis   | Encryption applied | Evidence (file · symbol)   |
| ----------------- | --------------- | -------------- | ------------------ | -------------------------- |
| [EXAMPLE] `email` | `example_table` | Art. 6(1)({x}) | Yes + HMAC         | `code/…/models.py:Example` |

## 2. Retention configured

| Data category        | Retention | Deletion mechanism shipped         | Evidence          |
| -------------------- | --------- | ---------------------------------- | ----------------- |
| [EXAMPLE] {category} | {period}  | {scheduled task / on-erasure hook} | `code/…/tasks.py` |

## 3. Data subject rights verified

Confirm each applicable right works against the shipped data. Point at the code.

- **Access (Art. 15)** — {verified: field appears in SAR export — evidence}
- **Erasure (Art. 17)** — {verified: erasure nulls/deletes the data — evidence}
- **Portability (Art. 20)** — {verified / N/A}
- **Rectification / Restriction / Object / Withdraw consent** — {as applicable}

## 4. Processors & DPA status

- **[EXAMPLE] {Processor}** — data sent: {…}; Art. 28 DPA {signed DD/MM/YYYY / GAP —
  blocks production}; entry updated in `../THIRD-PARTY-PROCESSORS.md`.

## 5. Plan gaps closed

Each open item from the plan's §7, closed **only with evidence** (never mark done
without pointing at the shipped code that does it).

| Plan gap                         | Status   | Evidence                        |
| -------------------------------- | -------- | ------------------------------- |
| [EXAMPLE] {HMAC companion added} | Closed   | `code/…/migrations/00xx.py`     |
| [EXAMPLE] {Retention purge task} | Deferred | tracked in `GAPS.md` — {reason} |

## 6. Deviations from plan

Any departure from `../PLANNING/GDPR-PLAN-US###-*.md`, with justification. "None" is a
valid entry.

- {Deviation and why it was necessary — or "None."}

---

## Cross-references

- `../PLANNING/GDPR-PLAN-US###-<DESCRIPTOR>.md` — the pre-implementation plan answered here
- `../DATA-INVENTORY.md` · `../RETENTION-DELETION.md` · `../THIRD-PARTY-PROCESSORS.md` —
  registers updated as a result of this story
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
- `project-management/workflows/21-implementation-documentation/` — where this record is written
