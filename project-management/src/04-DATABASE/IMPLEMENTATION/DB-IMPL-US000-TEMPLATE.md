# DB-IMPL-US000-[DESCRIPTOR] — Schema As Built

**Story**: US### · **Date**: DD/MM/YYYY · **Sprint**: ## · **Recorded by**: [name]
**Consolidated schema**: `../CONSOLIDATED-IDEAS/DB-CONSOLIDATED-<DOMAIN>.md`
**Stage-1 design**: `../USER-STORY-IDEAS/DB-IDEA-US###-<DESCRIPTOR>.md`
**Outcome**: Matches consolidated / Matches with deviations / Blocked

> Copy to `DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Replace every `[PLACEHOLDER]`, delete the
> `[EXAMPLE]` rows. Mark an element Present **only** with a migration file as evidence.

---

## 1 — Migrations shipped

| Migration                           | App                  | What it does |
| ----------------------------------- | -------------------- | ------------ |
| [EXAMPLE] `0004_add_audit_scope.py` | `apps.<%AUDIT_APP%>` | [EXAMPLE]    |

---

## 2 — Tables and columns vs the consolidated schema

| Table | Column | Consolidated says | Status | Evidence (migration · line) |
| ----- | ------ | ----------------- | ------ | --------------------------- |
|       |        |                   |        |                             |

**Status:** Present · Changed · Missing · N/A (not in this story's slice)

---

## 3 — Constraints as created

Application-level validation is not a substitute. Every bounded column needs its `CHECK`.

| Table | Constraint | Type                           | Present | Evidence |
| ----- | ---------- | ------------------------------ | ------- | -------- |
|       |            | FK / NOT NULL / UNIQUE / CHECK |         |          |

- **FKs with explicit delete behaviour:** [ ] all present
- **`NOT NULL` on every non-optional column:** [ ] all present
- **`CHECK` on every bounded or enum-like column:** [ ] all present

---

## 4 — Indexes as created

| Table | Index | Columns | Built concurrently | Evidence |
| ----- | ----- | ------- | ------------------ | -------- |
|       |       |         |                    |          |

---

## 5 — PII and encryption

| Table | Column | Encrypted | Mechanism | Evidence |
| ----- | ------ | --------- | --------- | -------- |
|       |        |           |           |          |

- [ ] Every PII column from the consolidated schema is encrypted at rest
- [ ] Every PII column appears in `../../09-GDPR/` with a lawful basis and retention period

---

## 6 — RLS and scoping

A scope column with no policy reading it is a defect, not a partial implementation.

| Table | Scope column | Policy present | Index present | Middleware sets session var | Evidence |
| ----- | ------------ | -------------- | ------------- | --------------------------- | -------- |
|       |              |                |               |                             |          |

---

## 7 — Migration safety

- [ ] No migration held a long `ACCESS EXCLUSIVE` lock on a large table
- [ ] Add-nullable → backfill → constrain followed where a column became required
- [ ] Indexes built concurrently on populated tables
- [ ] No manual DDL run against a deployed database

---

## 8 — Deviations from the consolidated schema

The interesting section. For each deviation, say **which side was wrong**.

| ID    | Deviation | Consolidation was wrong / build was wrong | Justification | Routed to |
| ----- | --------- | ----------------------------------------- | ------------- | --------- |
| D-001 |           |                                           |               |           |

**Routing:** consolidation error → `../../19-FINDINGS/` · build error → `../../20-BUGS/` ·
accepted trade-off → note here with a reason.

- [ ] No unexplained deviation remains

---

## Sign-off

- [ ] Every consolidated element for this story has a status and evidence
- [ ] Constraints, indexes, PII, and RLS all verified present
- [ ] Migration safety confirmed
- [ ] Every deviation justified and routed
- [ ] Story `US###`, consolidated-doc link, and date present

**Recorded by**: [name] · **Date**: DD/MM/YYYY
