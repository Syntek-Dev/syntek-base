# USER-FLOW-CONSOLIDATED-[AREA] — End-to-End Journey

**Date**: DD/MM/YYYY · **Consolidated by**: [name] · **Workflow**: `17-consolidate-design-work`
**Fragments stitched**: `USER-FLOW-IDEA-US###-*.md`, `USER-FLOW-IDEA-US###-*.md`, …

> Copy to `USER-FLOW-CONSOLIDATED-<AREA>.md`. Replace every `[PLACEHOLDER]`, delete the
> `[EXAMPLE]` rows. Wireframes and code follow **this** document, not the fragments.

---

## 1 — Scope

| Field                | Value                                           |
| -------------------- | ----------------------------------------------- |
| Area                 | [e.g. SIGN-UP]                                  |
| Stories contributing | US###, US###, US###                             |
| Fragments read       | `USER-FLOW-IDEA-US###-*.md` … (list every one)  |
| Entry points         | [PLACEHOLDER — how a user arrives in this area] |
| Exit points          | [PLACEHOLDER — where a completed journey lands] |

---

## 2 — The journey

Sequenced end to end. Every decision node must answer **both** outcomes.

| Step | Screen / state | Decision node | On success → | On failure → | Owning story |
| ---- | -------------- | ------------- | ------------ | ------------ | ------------ |
| 1    |                |               |              |              | US###        |
| 2    |                |               |              |              | US###        |

- [ ] No step has an unanswered failure path
- [ ] No step leads to a state absent from this table

---

## 3 — Seam log

One row per handoff between story fragments. **An empty table means the pass was shallow** —
state which fragments were compared.

| ID    | Seam                                  | Fragments     | Verdict        | Resolution                |
| ----- | ------------------------------------- | ------------- | -------------- | ------------------------- |
| S-001 | [EXAMPLE] registration → verification | US004 → US007 | Joined cleanly | —                         |
| S-002 | [EXAMPLE] verification bounce         | US007 → —     | **Gap**        | [EXAMPLE] raised as US0## |
| S-003 | [PLACEHOLDER]                         | US### ↔ US### | Contradiction  | [PLACEHOLDER]             |

**Verdicts:** Joined cleanly · Gap · Contradiction · Overlap (two fragments cover the same step)

**Gaps raised as new stories** — never absorbed silently:

- [PLACEHOLDER] — raised as US###

---

## 4 — Data touchpoints

Every point personal data is collected, read, or transmitted. Cross-check `../../09-GDPR/`.

| Step | Data | Purpose | Lawful basis | Register entry |
| ---- | ---- | ------- | ------------ | -------------- |
|      |      |         |              |                |

---

## 5 — Routes

Follows `code/docs/URL-STRATEGY.md`.

| Step | Route | Surface (marketing / portal / admin) | Auth required |
| ---- | ----- | ------------------------------------ | ------------- |
|      |       |                                      |               |

---

## 6 — Story plans corrected

A journey change must correct any plan that assumed the old shape.

| Story plan              | What changed | Corrected |
| ----------------------- | ------------ | --------- |
| `STORY-PLAN-US###-*.md` |              | [ ]       |

---

## 7 — Diagram (Mermaid)

```mermaid
flowchart TD
```

Re-export to `../DIAGRAMS/flow-<area>-<screen>.png` on sign-off.

---

## Sign-off

- [ ] Every fragment listed in §1 and carried forward or recorded as superseded
- [ ] Every decision node resolves both outcomes across the whole journey
- [ ] Seam log complete; every gap resolved or raised as a `US###`
- [ ] Data touchpoints cross-checked against `../../09-GDPR/`
- [ ] Every affected story plan corrected
- [ ] Diagram re-exported

**Consolidated by**: [name] · **Date**: DD/MM/YYYY
