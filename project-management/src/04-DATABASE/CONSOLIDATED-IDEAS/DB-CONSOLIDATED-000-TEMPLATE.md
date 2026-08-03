# DB-CONSOLIDATED-[DOMAIN] — Unified Schema

**Date**: DD/MM/YYYY · **Consolidated by**: [name] · **Workflow**: `17-consolidate-design-work`
**Stage-1 designs reconciled**: `DB-IDEA-US###-*.md`, `DB-IDEA-US###-*.md`, …

> Copy this file to `DB-CONSOLIDATED-<DOMAIN>.md`. Replace every `[PLACEHOLDER]` and delete the
> `[EXAMPLE]` rows. This document — not the stage-1 designs — is what `18-backend-code` builds
> from.

---

## 1 — Scope

| Field                | Value                                                        |
| -------------------- | ------------------------------------------------------------ |
| Domain               | [e.g. identity-and-audit]                                    |
| Django apps in scope | `apps.[app]`, `apps.[app]`                                   |
| Stories reconciled   | US###, US###, US###                                          |
| Stage-1 designs read | `DB-IDEA-US###-*.md` … (list every one, including no-change) |

---

## 2 — Resolution log

The heart of this document. One row per finding across the stage-1 designs. **An empty table
means the consolidation pass was shallow, not that the designs agreed** — say which searches
were run.

| ID    | Type          | Found in     | The conflict                                           | Canonical form chosen              | Rejected                         | Why                                        | ADR     |
| ----- | ------------- | ------------ | ------------------------------------------------------ | ---------------------------------- | -------------------------------- | ------------------------------------------ | ------- |
| R-001 | Duplicate     | US004, US011 | [EXAMPLE] Both define a `status` enum for the same row | [EXAMPLE] `apps.core.StatusChoice` | [EXAMPLE] per-app duplicate enum | [EXAMPLE] one vocabulary, one migration    | —       |
| R-002 | Divergence    | US007, US012 | [EXAMPLE] `created_by` FK, differing delete behaviour  | [EXAMPLE] `PROTECT`                | [EXAMPLE] `CASCADE`              | [EXAMPLE] audit rows must survive user del | ADR-0## |
| R-003 | Contradiction | US003, US009 | [PLACEHOLDER]                                          | [PLACEHOLDER]                      | [PLACEHOLDER]                    | [PLACEHOLDER]                              | —       |
| R-004 | Orphan        | US015        | [PLACEHOLDER] table nothing downstream references      | [PLACEHOLDER] dropped / kept       | —                                | [PLACEHOLDER]                              | —       |

**Types:** Duplicate · Divergence · Contradiction · Orphan.
**Capability gaps found** — each must become a new `US###`, never a quiet addition here:

- [PLACEHOLDER] — raised as US###

---

## 3 — Canonical tables

### `[app]_[table]`

| Column | Type | Null | Default | Constraint | PII | Notes |
| ------ | ---- | ---- | ------- | ---------- | --- | ----- |
|        |      |      |         |            |     |       |

- **Supersedes:** `DB-IDEA-US###-*.md` § [table], `DB-IDEA-US###-*.md` § [table]
- **Primary key:** [PLACEHOLDER]
- **Unique constraints:** [PLACEHOLDER]
- **Check constraints:** [PLACEHOLDER — every bounded or enum-like column]

_(repeat per table)_

---

## 4 — Foreign keys

Every FK carries an explicit delete behaviour. No implicit defaults.

| From | To  | On delete | Reason |
| ---- | --- | --------- | ------ |
|      |     |           |        |

---

## 5 — PII classification

| Table | Column | Category | Lawful basis | Encrypted | Retention |
| ----- | ------ | -------- | ------------ | --------- | --------- |
|       |        |          |              |           |           |

Cross-check against `../../09-GDPR/` registers. Every personal-data column appears in both.

---

## 6 — RLS and scoping

A scope column, the policy that reads it, its supporting index, and the middleware that sets its
session variable **ship together**. A scope column with no policy is a defect.

| Table | Scope column | Policy | Index | Session variable |
| ----- | ------------ | ------ | ----- | ---------------- |
|       |              |        |       |                  |

---

## 7 — Index strategy

| Table | Index | Columns | Why | Concurrent build |
| ----- | ----- | ------- | --- | ---------------- |
|       |       |         |     |                  |

---

## 8 — Migration order

Lock-safe and ordered: add-nullable → backfill → constrain; indexes built concurrently on
populated tables. No migration may hold a long `ACCESS EXCLUSIVE` lock on a large table.

1. [PLACEHOLDER]
2. [PLACEHOLDER]

**Cross-app ordering constraints:** [PLACEHOLDER]

---

## 9 — Story plans corrected

Consolidation that changes a shape a story plan assumed **must** correct that plan — the
developer codes from the plan, not from here.

| Story plan              | What changed | Corrected |
| ----------------------- | ------------ | --------- |
| `STORY-PLAN-US###-*.md` |              | [ ]       |

---

## 10 — ERD (Mermaid)

```mermaid
erDiagram
```

Re-export to `../ERD-DIAGRAMS/erd-<domain>.png` on sign-off.

---

## Sign-off

- [ ] Every stage-1 design listed in §1 and either carried forward or recorded as superseded
- [ ] Resolution log complete; no unresolved duplicate remains
- [ ] Every hard-to-reverse resolution cites an ADR
- [ ] Every capability gap raised as a new `US###`
- [ ] Constraints, FKs, PII, RLS, indexes, and migration order complete
- [ ] Every affected story plan corrected
- [ ] ERD re-exported

**Consolidated by**: [name] · **Date**: DD/MM/YYYY
