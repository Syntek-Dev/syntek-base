# GDPR Enforcement — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Prerequisites

- [ ] `project-management/src/GDPR/DATA-INVENTORY.md` exists and is up to date
- [ ] PM-layer GDPR compliance review is complete

---

## Steps

### Step 1 — Review the Data Inventory

Read `project-management/src/GDPR/DATA-INVENTORY.md` and confirm which fields in
the current feature are classified as personal data. Cross-reference
`code/docs/ENCRYPTION-GUIDE.md` for the encryption strategy.

### Step 2 — Enforce Consent in Resolvers

Every resolver that reads or writes personal data must verify consent or lawful
basis before proceeding.

```text
/syntek-dev-suite:backend [add consent and permission checks to resolvers handling PII]
```

### Step 3 — Apply Field-Level Encryption to PII Fields

Encrypt all fields classified as personal data at rest, following the patterns in
`code/docs/ENCRYPTION-GUIDE.md`.

```text
/syntek-dev-suite:backend [encrypt PII model fields per ENCRYPTION-GUIDE.md]
```

### Step 4 — Implement Deletion and Anonymisation Functions

Implement DSAR-ready deletion: anonymise PII fields rather than hard-deleting
rows where audit trails must be preserved.

```text
/syntek-dev-suite:backend [implement deletion and anonymisation functions for DSAR compliance]
```

### Step 5 — Verify No PII Leaks

Check that no personal data appears in:

- Log output (`logging.getLogger(...)` calls)
- Error responses returned to the client
- Any serialised representation sent outside the service boundary

### Step 6 — Run Tests

```bash
docker compose exec backend pytest
```

### Step 7 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
