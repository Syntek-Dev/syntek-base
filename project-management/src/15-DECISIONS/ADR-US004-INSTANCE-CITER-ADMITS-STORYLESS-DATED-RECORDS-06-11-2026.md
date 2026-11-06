# ADR-US004: The derived instance-citer rule admits the four story-less dated record families

**Status:** Proposed — for <%DEVELOPER_NAME%>'s acceptance at US004's `23-pr-and-review`
**Date:** 06/11/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-CITER-IS-A-DERIVED-RULE-05-11-2026.md`, on acceptance; that record's Status is flipped in the same change
**Superseded by:** —
**Related:** US004

---

## Context

`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-CITER-IS-A-DERIVED-RULE-05-11-2026.md`
decided that Check 2 of `code/src/scripts/audits/doc-references.sh` exempts a citer whose
basename carries `US[0-9]{3}` or `SPRINT-(PLAN-)?[0-9]{2}`, or starts `BUG-`, unless it carries
`US000` or `-TEMPLATE.`. Its deciding factor was that the rule tracks the naming convention
rather than a copy of it. That record is Accepted, and an Accepted record is not rewritten in
place (`project-management/src/15-DECISIONS/CLAUDE.md`).

**Four conventions name a per-project record with no story or sprint number.** Each record folder
allows a cross-cutting fallback form:

| Form                                     | Owner of the convention                           |
| ---------------------------------------- | ------------------------------------------------- |
| `FINDING-<DESCRIPTOR>-DD-MM-YYYY.md`     | `project-management/src/20-FINDINGS/CLAUDE.md`    |
| `REVIEW-<DESCRIPTOR>-DD-MM-YYYY.md`      | `project-management/src/19-REVIEWS/CLAUDE.md`     |
| `REFACTORING-<DESCRIPTOR>-DD-MM-YYYY.md` | `project-management/src/22-REFACTORING/CLAUDE.md` |
| `INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md`    | `project-management/src/23-INCIDENTS/CLAUDE.md`   |

None carries a story number, so the 05/11/2026 rule read each as a shipped file, and a story
citation inside one fired `[instance citation]`. Workflow 23's review raised it on 06/11/2026
(QA-F02); <%DEVELOPER_NAME%> instructed that day that every review finding is fixed in US004.
The fix as first written matched any name ending in a real date, anywhere; the second review pass
(H-04) showed that a dated shipped guide would then lose Check 2, so it was narrowed to the four
families. Findings F-024 and F-042 in
`project-management/src/20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md`.

## Options considered

### Option 1 — a fourth clause, scoped to the four families

- **Summary:** add `^(FINDING|REVIEW|REFACTORING|INCIDENT)-.*-[0-9]{2}-[0-9]{2}-[0-9]{4}\.[A-Za-z0-9]+$`
  to the rule; the `US000` and `-TEMPLATE.` exclusions still apply.
- **Pros:** derived from the four conventions, as the 05/11/2026 rule is from the story and sprint
  conventions; a real date is required, so a `-DD-MM-YYYY` template name stays checked.
- **Cons:** a fifth story-less family needs a new clause. That is a convention change made in its
  owner's `CLAUDE.md`, so it is visible when it happens, unlike a missed per-story form.

### Option 2 — any basename ending in a real date

- **Summary:** the first fix: a date arm with no family scope.
- **Pros:** covers a future family with no edit.
- **Cons:** over-reaches. A shipped guide named with a date would be exempt from Check 2 and its
  instance citations would reach every generated project unchecked (H-04, reproduced).

### Option 3 — leave the families checked and mark each citation

- **Summary:** keep the 05/11/2026 rule; silence each story citation in a story-less record with a
  `doc-references: ignore` marker.
- **Pros:** no change to the rule.
- **Cons:** a marker per citation in every such record, for files that never ship. It is the
  per-site suppression the 05/11/2026 record rejected.

## Decision

**We will take Option 1.** Check 2 exempts a citer whose basename carries `US[0-9]{3}` or
`SPRINT-(PLAN-)?[0-9]{2}`, starts `BUG-`, or matches one of the four story-less dated families
with a real `DD-MM-YYYY` date, unless the basename carries `US000` or `-TEMPLATE.`. Everything
else the 05/11/2026 record decided stands, with the reasoning it gives: the test reads the
citer's filename, never `is_template_only()`, and the numbers are bounded.

## Consequences

- **Positive:** a story-less finding, review, refactoring or incident record can cite a story
  without a finding, as a story-anchored one already could.
- **Negative / trade-off:** copier must never ship a non-template file in one of the four
  families. It ships none today; the 05/11/2026 record's review duty on `copier.yml` re-includes
  covers this clause too.
- **Follow-on:** the clause is in `INSTANCE_CITER_RE` in the working tree of 06/11/2026. Its
  proofs are the clean fixtures `FINDING-`, `REVIEW-`, `REFACTORING-` and
  `INCIDENT-FIXTURE-ONLY-05-11-2026.md`, and the guard `broken/GUIDE-FIXTURE-ONLY-05-11-2026.md`
  with the `MIGRATION-GUIDE-01-01-2026.md` probe, all under
  `code/src/scripts/audits/fixtures/doc-references/`.
- **Follow-on:** if <%DEVELOPER_NAME%> rejects this record, the clause is removed before merge
  and the four clean fixtures with it.
