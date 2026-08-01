# Findings — US000 {STORY TITLE}

_Template — copy to `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. This record captures what shipping one story revealed about the project's standards — what diverged, why it matters, the smallest fix, and what the next story should carry forward. It records; it does not fix._

**Last Updated**: {DD/MM/YYYY} · **Story**: US### · **Status**: {Open → Triaged}

| Field                | Value                                                  |
| -------------------- | ------------------------------------------------------ |
| **Story**            | US### — {short title}                                  |
| **Completed**        | {DD/MM/YYYY}                                           |
| **Recorded by**      | {name / agent}                                         |
| **Assessed against** | `code/docs/DATABASE.md` + {other governing guides}     |
| **Outcome**          | {N findings · M expensive-to-retrofit} / Nothing found |

**Codes from:** `../15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md` — the implementation
master this story was built from.
**Story:** `../01-STORIES/US###.md` — the acceptance criteria the work satisfied.

---

## 1. Scope

One or two lines: what this story delivered, and which standards it was assessed against
(data layer, architecture, security, accessibility). State anything deliberately not
assessed and why.

---

## 2. Findings

Every divergence observed while closing the story, most consequential first. Give each a
stable `F-0NN` ID so the next story's plan can reference it. **Retrofit** is the load-bearing
column: `Expensive` means changing it later requires a data migration, a schema rewrite, or
touching every call site; `Cheap` means it can be inserted as a layer when it hurts.

| ID                | Area          | Where                | Why it matters                                                                   | Smallest fix                                            | Retrofit    | Disposition           |
| ----------------- | ------------- | -------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------- | ----------- | --------------------- |
| _[EXAMPLE] F-001_ | _Schema_      | _`{table}`_          | _No scope column; splitting rows later means a backfill under load_              | _Add the column nullable now, backfill, then constrain_ | _Expensive_ | _Next story_          |
| _[EXAMPLE] F-002_ | _Constraints_ | _`{table}.{column}`_ | _Bounded value enforced only in application code; a direct write can violate it_ | _Add a CHECK constraint in the next migration_          | _Cheap_     | _Deferred — US###_    |
| _[EXAMPLE] F-003_ | _Migration_   | _`{migration}`_      | _Index added without CONCURRENTLY; would lock a populated table_                 | _Re-issue as a concurrent index build_                  | _Cheap_     | _Refactor_            |
| _[EXAMPLE] F-004_ | _Query_       | _`{service}`_        | _Relation walked in a loop — N+1 on a request path_                              | _Eager-load the relation at the service boundary_       | _Cheap_     | _Bug — US###_         |
| _[EXAMPLE] F-005_ | _Docs_        | _`{guide}`_          | _Guide asserts a rule the codebase does not follow_                              | _Correct the guide, or record why the exception stands_ | _Cheap_     | _Accepted — {reason}_ |

**Area** — Schema · Constraints · Indexes · Migration · Query · Search · Scoping/RLS ·
Encryption · Docs · Tooling.
**Disposition** — `Next story` (feeds the next plan) · `Deferred — US###` (named target,
also recorded in `DEFERRED.md`) · `Bug — US###` (a defect; file in `../19-BUGS/`) ·
`Refactor` (structural debt; action in `../20-REFACTORING/`) · `ADR` (reopens a
hard-to-reverse trade-off; graduate to `../13-DECISIONS/`) · `Accepted — {reason}` (a
deliberate, recorded exception).

> Mark anything **inferred** from the code rather than found stated as `TODO(verify)`.
> Where a migration or model carries no explanation for its shape, record the absence —
> never reconstruct a rationale that was never written down.

---

## 3. Expensive to retrofit

Repeat only the `Expensive` rows from §2, so they cannot be lost in a long table. These are
the findings that get materially more costly with every story that ships on top of them —
schema shape, a missing scope column, absent database-level constraints, a chosen primary
key. Escalate each explicitly; do not leave one sitting as a table row.

| ID                | Finding      | Cost of delay                                      | Escalated to             |
| ----------------- | ------------ | -------------------------------------------------- | ------------------------ |
| _[EXAMPLE] F-001_ | _{one line}_ | _Grows with row count; needs a backfill once live_ | _Next sprint plan / ADR_ |

"None — no expensive-to-retrofit findings." is a valid entry.

---

## 4. Carried into the next story

The point of this record. Each row becomes an input to the next `STORY-PLAN`, so state it as
work, not as an observation.

| ID                | Carried as                                                 | Target  |
| ----------------- | ---------------------------------------------------------- | ------- |
| _[EXAMPLE] F-001_ | _Add the scope column ahead of the next schema change_     | _US###_ |
| _[EXAMPLE] F-003_ | _Adopt concurrent index builds in the migration checklist_ | _US###_ |

"None — nothing carried forward." is a valid entry.

---

## 5. Notes

Anything worth recording that is not a finding — a standard confirmed as correctly applied,
a deliberate deviation with a rationale, or a pattern worth promoting to a guide. Keep it
factual.

- _[EXAMPLE] {observation}._

> **Nothing found?** Say so explicitly here and set **Outcome** to `Nothing found` in the
> header. A story that surfaces nothing still gets a record — a missing file is
> indistinguishable from a skipped step.

---

## Cross-references

- `../01-STORIES/US###.md` — the story these findings came from
- `../15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md` — the plan this closes the loop on
- `../17-REVIEWS/REVIEW-US###-<DESCRIPTOR>.md` — the merge-gating review from the same PR
- `../19-BUGS/` — file a report for any finding that is a defect
- `../20-REFACTORING/` — action any finding that is structural debt
- `../13-DECISIONS/` — graduate any finding that reopens a hard-to-reverse trade-off
- `code/docs/DATABASE.md` — the data-layer rules §2 is assessed against
- `GAPS.md` · `DEFERRED.md` — active blockers, and deferrals with a named target story
- `project-management/workflows/19-implementation-documentation/` — where this is written

> **Cross-cutting findings** — a sweep not tied to a single story (a periodic schema audit,
> a dependency review) is filed as `FINDING-<DESCRIPTOR>-DD-MM-YYYY.md`; drop the
> story-specific header rows and the `US###` links, and set them to `N/A — cross-cutting`.
