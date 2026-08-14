---
workflow: 06-gdpr-enforcement
phase: compliance
skills: [gdpr-mechanics, stack-django]
model: opus
---

# GDPR Enforcement — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                  |
| ---- | ---------------------------------------------------------------------------------------- |
| 1    | **Guides in code/docs/** → encryption/FIELD-ENCRYPTION.md, encryption/LOOKUP-TOKENS.md   |
| 2–4  | **Guides in code/docs/** → rls/TESTING-AND-AUDIT.md, security/AUTH-AND-AUTHZ.md          |
| 2–4  | **External — Security & Standards** → UK GDPR (ICO)                                      |
| 5    | **Guides in code/docs/** → logging/DJANGO-LOGGING.md (no PII in logs or error responses) |

---

## Prerequisites

- [ ] `project-management/src/09-GDPR/DATA-INVENTORY.md` exists and is up to date
- [ ] PM-layer GDPR compliance review is complete

---

## Steps

### Step 1 — Review the Data Inventory

> **Model:** opus · **MCP:** none

Read `project-management/src/09-GDPR/DATA-INVENTORY.md` and confirm which fields in
the current feature are classified as personal data. Cross-reference
`code/docs/encryption/FIELD-ENCRYPTION.md` for the encryption strategy.

### Step 2 — Enforce Consent in Resolvers

Every resolver that reads or writes personal data must verify consent or lawful
basis before proceeding.

```text
backend [add consent and permission checks to resolvers handling PII]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **MCP:** none

### Step 3 — Apply Field-Level Encryption to PII Fields

Encrypt all fields classified as personal data at rest, following the patterns in
`code/docs/encryption/FIELD-ENCRYPTION.md`.

```text
backend [encrypt PII model fields per encryption/FIELD-ENCRYPTION.md]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **MCP:** none

### Step 4 — Implement Deletion and Anonymisation Functions

Implement DSAR-ready deletion: anonymise PII fields rather than hard-deleting
rows where audit trails must be preserved.

```text
backend [implement deletion and anonymisation functions for DSAR compliance]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **MCP:** none

### Step 5 — Verify No PII Leaks

Check that no personal data appears in:

- Log output (`logging.getLogger(...)` calls)
- Error responses returned to the client
- Any serialised representation sent outside the service boundary

### Step 6 — Run Tests

```bash
bash code/src/scripts/tests/backend.sh
```

### Step 7 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

### Step 8 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
