---
name: gdpr-mechanics
description: >-
  Build UK GDPR into <%PROJECT_NAME%>'s stack — PII classified and encrypted at rest, consent
  records, the DSAR export endpoint, right-to-erasure as soft-delete then anonymise, retention
  windows as configuration, and the audit trail that proves all of it. Load when a feature
  touches personal data. Mechanics only: it never gives legal advice, drafts a policy
  (`legal-documents`), or sets a retention period or lawful basis — those are business and legal
  decisions it surfaces. Not the access-control audit over what it builds (`security`), and not
  the file generation a DSAR export uses (`export`).
model: opus
metadata:
  skills: global-workflow grilling stack-django
---

# Build the Data-Protection Mechanics (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the inputs it needs are decisions, and they come from the
conversation, not the repository). A fork could read the schema; it could not be told which
fields are lawful to keep and for how long.

---

## Open with a grilling pass

Name what must be settled and wait — the round shape and the question format belong to the
`grilling` skill (`.claude/CLAUDE.md` § 10). **This inverts the proceed-by-default posture**:
data protection is the one area where a reasonable guess is still an unlawful one.

**Read first, ask second.** The schema, the models and the existing registers under
`project-management/src/09-GDPR/` answer more than they are given credit for. Four inputs are
genuinely not derivable and must be asked:

| Input                      | Why it decides something                                    |
| -------------------------- | ----------------------------------------------------------- |
| **Data categories**        | Which fields are PII, and so encrypt versus hash            |
| **Lawful basis**           | Consent versus contract versus legitimate interest          |
| **Retention window**       | Erasure versus anonymise-and-keep — **a business decision** |
| **Third-party processors** | The DPA and sub-processor register's scope                  |

**Retention and lawful basis are surfaced, never invented.** Recording a made-up window in code
is how an unlawful retention period acquires the authority of a config value.

## What to build

1. **PII classification and storage** — mark the PII fields; Fernet-encrypt what must be read
   back for display or operation; hash what is only ever looked up or authenticated against.
   Keep identifiers separate from PII where the schema allows it. **Never invent a scheme** —
   `code/docs/ENCRYPTION-GUIDE.md` is canonical.
2. **Consent records** — a model capturing the consent type, the granted and withdrawn
   timestamps, the version, and the source. Granular categories — necessary, functional,
   analytics, marketing — with double opt-in for marketing.
3. **DSAR export (Articles 15 and 20)** — a permission-checked, ownership-scoped endpoint
   returning the subject's data in a machine-readable form. **Hand the file generation to
   `export`** rather than hand-rolling it.
4. **Right to erasure (Article 17)** — soft-delete then hard-delete or anonymise, inside
   `transaction.atomic()`, cascading correctly. **Anonymise rather than delete** where a record
   must be retained for a legal or financial reason.
5. **Retention** — the windows are configuration, environment-driven, enforced by a scheduled
   task. **Never bury a literal retention period in code.**
6. **The audit trail** — every data-subject action (export, consent change, erasure, admin PII
   access) is recorded through `code/docs/security/AUDIT-TRAIL.md`'s write path.

## Non-negotiables

- **Every state-changing endpoint** — a consent change, an erasure request, an export trigger —
  carries its explicit named permission check.
- **No IDOR: a subject can export or erase only their own data.** Cross-subject access needs a
  named admin permission, and it is audited.
- **PII is encrypted at rest through the Fernet pipeline.** Passwords are hashed by Django's
  hasher — never encrypted, never reversible.
- Encryption keys and the DPO contact come from environment variables.

## Output

```text
## GDPR: <feature / component>

### Data inventory
| Field | PII? | Protection (encrypt/hash) | Lawful basis | Retention |

### What changed        <file — purpose>
### Migrations          <consent table · anonymisation columns · …>
### Compliance checklist
- [ ] Consent recorded   - [ ] DSAR export (permission-checked, ownership-scoped)
- [ ] Erasure / anonymise   - [ ] PII encrypted   - [ ] Audit logging
### Env vars introduced <NAME — purpose, names only>
### Needs legal or business sign-off
- <retention period, DPA, policy text — flagged, never decided here>
```

## Handoff

Report the inventory and the sign-off list first — **that list is the deliverable a controller
reads.** Then name what is owed: `qa-tester` to verify data is genuinely erased or anonymised
and the export complete, `security` to audit the PII access controls, `export` for the DSAR
file itself, `frontend` for consent and cookie UI, `doc-writer` for the data-handling
documentation, `support-articles` for user-facing help on consent, export and deletion, and
`legal-documents` for the Privacy Policy, the Article 13/14 notice, the DPA or the registers.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/09-gdpr-compliance/` — the compliance review, **completed first**
- `code/workflows/06-gdpr-enforcement/` — enforcing it in code; the procedure of record
- `project-management/workflows/21-implementation-documentation/` — where `GDPR-IMPL-US###` lands

## Cross-references

- `project-management/docs/GDPR-GUIDE.md` — the obligations, lawful bases and data rights
- `code/docs/ENCRYPTION-GUIDE.md` — **canonical**: the Fernet pipeline and its lookup tokens
- `code/docs/security/AUDIT-TRAIL.md` — what the audit record holds, and its retention
- `code/docs/security/AUTH-AND-AUTHZ.md` — the permission check and the anti-enumeration rules
- `code/docs/API-DESIGN.md` — the conventions a DSAR or erasure endpoint follows
- `project-management/src/09-GDPR/` — the six registers this work keeps true
