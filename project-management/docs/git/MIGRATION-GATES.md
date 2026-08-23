---
type: guide
skills: [git, global-workflow]
model: opus
---

# Git Guide — Migration Gates

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — migration review gates, staging verification and sign-off

The extra checks a Django migration earns over an ordinary change — once at code review, and
again on staging when its failure mode is data loss. Index: [`../GIT-GUIDE.md`](../GIT-GUIDE.md).

---

## Database Migration PR Gates

These checks are **mandatory** for any PR that adds or modifies a Django migration. They run
during code review at the `us###/feature → testing` step. A PR that fails any of these gates
must not be merged.

### Gate 1 — HMAC Token Completeness Check

Every migration that adds an **encrypted, uniquely-looked-up PII field** must add its HMAC
companion column in the same migration. Cross-check it against the encryption spec in the
story's database-design and QA docs (`src/04-DATABASE/`, `src/11-QA/`).

For each such field, verify **all** of the following before approving:

- [ ] The HMAC companion column exists in the migration (e.g. `email_token VARCHAR(64)`)
- [ ] The data type is `VARCHAR(64)` (not `TEXT` or `CHAR`)
- [ ] The correct index type is created — `UNIQUE` or non-unique, as the field requires
- [ ] A `RunSQL` block or `models.Index` creates the index explicitly (not left to Django auto)
- [ ] The pre-save signal or model `save()` override populates the token before every `INSERT`
- [ ] Both the encrypted field and its HMAC companion are nulled together on GDPR erasure

**Do not approve the PR if any encrypted-unique field is missing its companion column, has the
wrong data type, is missing its index, or the pre-save signal is not wired up.**

---

### Gate 2 — `app_user` Grant Check

Every migration that creates a table must include explicit `GRANT` statements for `app_user`
on that table — the runtime role has no implicit privileges under row-level security:

- [ ] `GRANT SELECT, INSERT, UPDATE, DELETE ON <table> TO app_user;` present for each table
- [ ] `GRANT USAGE, SELECT ON SEQUENCE <table>_id_seq TO app_user;` present for each table
- [ ] For INSERT-only tables (e.g. an audit log): `UPDATE` and `DELETE` are explicitly revoked

Where a CI check verifies grant completeness after each migration, the reviewer must confirm
it passed before approving.

---

## Staging Migration Gates

These checks apply at the `dev → staging` promotion step for any **risky** migration — a data
migration, a schema change with a backfill, a new constraint or trigger, or a grant change.

Run **before** the migration is applied on staging, and again **after**, then record the results
in the PR description before requesting the `staging → main` sign-off.

### Which migrations need staging verification?

Any migration whose failure mode is data loss or a privilege gap. Record each one in the
story's database QA doc with its risk, following this shape:

| Migration          | Story   | Risk                                                         |
| ------------------ | ------- | ------------------------------------------------------------ |
| `<migration name>` | `US###` | `<what could go wrong — e.g. row-count integrity on change>` |

### Staging verification procedure

For each affected migration:

1. **Record the pre-migration count** with the verification query for that migration. Paste
   the result into the PR description.

2. **Apply the migration on staging:**

   ```bash
   bash code/src/scripts/database/migrate.sh run
   ```

3. **Run the post-apply verification queries** and paste the results into the PR
   description.

4. **For data migrations:** confirm the total row count is identical before and after (no
   rows created or deleted beyond what is documented in the migration).

5. **For `app_user` grant migrations:** run the privilege check queries:

   ```sql
   SELECT has_table_privilege('app_user', '<table_name>', 'SELECT');
   SELECT has_table_privilege('app_user', '<table_name>', 'INSERT');
   SELECT has_table_privilege('app_user', '<table_name>', 'UPDATE');
   SELECT has_table_privilege('app_user', '<table_name>', 'DELETE');
   ```

6. **Sign off in the PR description** with the format:

   ```text
   Staging migration verified — <migration name>
   Pre-apply: <count> rows
   Post-apply: <count> rows (expected: <N>)
   Grant check: PASS
   Verified by: <name>, <DD/MM/YYYY>
   ```

**The `staging → main` PR is blocked until staging verification sign-off is present in the PR
description for every affected migration.**
