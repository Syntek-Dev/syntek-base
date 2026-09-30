# ADR-US004: A registered path may name a class, not only an instance — restated after the 18-TESTS split

**Status:** Accepted
**Date:** 30/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md`
**Superseded by:** —
**Related:** US004

---

## Context

`project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md`
decided that a row in `how-to/src/PROJECT-PATHS.md` may name a class of paths rather than one
instance, with `###` translated to exactly three digit classes before `is_registered()` matches,
and that US004 writes exactly two such rows — one for each per-story test record in
`project-management/src/18-TESTS/`.

**This record exists because the records that decision names have moved, not because its
reasoning did.** On 30/09/2026 `project-management/src/18-TESTS/` split into two sub-folders,
filenames unchanged (`CHANGELOG.md`, `[Unreleased]`):

- `project-management/src/18-TESTS/MANUAL/` holds `US###-MANUAL-TESTING.md`, the manual testing
  guide, now authored at `project-management/workflows/17-story-plans/` Step 7.2 before any code
  exists and walked at `project-management/workflows/22-implementation-documentation/`.
- `project-management/src/18-TESTS/AUTOMATED/` holds `US###-TEST-STATUS.md`, still written at
  `22`.

Which step touches which record is `project-management/src/18-TESTS/CLAUDE.md:30-42`, _The record
lifecycle_. The superseded record names the two records at their old root-level paths —
"project-management/src/18-TESTS/US###-MANUAL-TESTING.md" and "US###-TEST-STATUS.md" — in its
Context (`:22-23` and `:36`), its Option A (`:52`) and its Follow-on (`:117-118`) of
`project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md`.
Implemented as written, that Follow-on would register two paths nothing now creates and leave
every citation of the split paths unregistered. `project-management/src/02-STORIES/US004.md:272-276`
and `:286-287`, and
`project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md:245-246`,
already carry the split paths.

**The change that made the split first re-pointed those paths inside the Accepted record itself.**
That edit was reverted, and supersession chosen instead (settled 30/09/2026, 16-sprint-plans
grilling round 6 Q17). Each Accepted record the split touched gets its own successor, restating
its decision unchanged with the `MANUAL/` and `AUTOMATED/` paths (settled 30/09/2026,
16-sprint-plans grilling round 7 Q18): one ADR is one decision
(`project-management/src/15-DECISIONS/ADR-US000-TEMPLATE.md:7`), `Supersedes` names one filename
(`:13`), the filename carries one driving story, and a superseded decision stays in force only
where its successor states it.

**The superseded record's premise survives the split.** Both records are still forward references
written after the story that cites them exists — the guide at `17`, the automated record at `22`
(`project-management/src/02-STORIES/US004.md:272-276`). Its Context, its four options and its
reasons for choosing its Option B are unchanged and are not repeated here: read
`project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md:12-101`.
Its figures — 16 findings rising to 38, all 22 additions forward references — are that day's
measurement at the root-level paths. `project-management/src/02-STORIES/US004.md:348-353` records
that the 30/09/2026 backfill of the US001 to US009 manual guides means the figure cannot recur as
written, and that the story already requires it reproduced at implementation, never inherited.
This record does not re-measure it.

## Options considered

This record chooses only how the moved paths reach a record in force. The options for the
decision itself — one literal row per story, patterned rows with `###` translated, shell globs, a
`doc-references: ignore` marker per site — are the superseded record's, and its analysis stands:
`project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md:47-85`.

### Option A — Edit the Accepted record in place

- **Summary:** re-point the path sites inside the superseded record to `MANUAL/` and `AUTOMATED/`
  and leave it Accepted. This is what the split change first did.
- **Pros:** one record; no new file; the citations of it in US004's story and story plan stay
  pointed at the record in force.
- **Cons:** breaks `project-management/src/15-DECISIONS/CLAUDE.md:44` — Accepted ADRs are
  immutable. A record dated 02/09/2026 would name paths that did not exist until 30/09/2026, and
  nothing on it would show that its text had moved.

### Option B — Correct in place with a dated note

- **Summary:** re-point the paths and keep the old text in a dated comment, the form a story plan
  uses for a moved path
  (`project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md:395-400`).
- **Pros:** the move is visible on the page; still one record.
- **Cons:** still an edit to an Accepted decision — the dated-note form belongs to artefacts that
  are not immutable. Rejected (settled 30/09/2026, 16-sprint-plans grilling round 6 Q17).

### Option C — Supersede with a successor that restates the decision unchanged

- **Summary:** mark the 02/09/2026 record Superseded and raise this one, stating the same decision
  in full with the split paths.
- **Pros:** the superseded record stands exactly as accepted; the move is legible from both
  headers; the decision in force can be applied from this record alone.
- **Cons:** the decision is written twice, and a reader has to know which record is in force.
  Artefacts citing the superseded filename keep naming it, since none is re-pointed; a live one
  gains this record beside it.

### Option D — One successor for every record the split touched

- **Summary:** a single new record superseding all three Accepted ADRs whose paths the split
  moved.
- **Pros:** one record to write and to read.
- **Cons:** three decisions in one record, three filenames in one `Supersedes` field, and two
  driving stories (US003 and US004) behind one name. Rejected (settled 30/09/2026, 16-sprint-plans
  grilling round 7 Q18).

### Option E — Revert, and leave the record standing

- **Summary:** keep the revert and do nothing further; the 02/09/2026 record stays Accepted.
- **Pros:** no new record, and nothing edited.
- **Cons:** the decision in force would tell US004 to write its two rows at root-level paths the
  folder no longer holds — its root now holds only its `CONTEXT.md` and `CLAUDE.md`
  (`project-management/src/18-TESTS/CLAUDE.md:93`) — which is the failure the Context above names.
  Not taken: round 6 Q17 paired the revert with a supersession.

## Decision

**We take Option C.** The deciding factor is that an Accepted record is immutable, and a
superseded decision stays in force only where its successor states it. The decision in force is
therefore stated in full below, unchanged from 02/09/2026 except for the two paths, and applies
without reading the superseded record.

**A registered path may name a class, not only an instance.** `is_registered()` in
`code/src/scripts/audits/doc-references.sh` translates `###` to three digit classes before it
matches, so a row in `how-to/src/PROJECT-PATHS.md` written
`project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md` matches
`project-management/src/18-TESTS/MANUAL/US001-MANUAL-TESTING.md` and every later story's guide.
Under the fixed-string, whole-line match `is_registered()` performs today
(`code/src/scripts/audits/doc-references.sh:389-391`, `grep -qxF`), that row matches no concrete
citation at all.

**The spelling is `###`.** The register is read by a human before it is read by a script, and
`###` is how this repository writes a story number everywhere else — in `US000-TEMPLATE.md`, in
each folder's naming rules, and inside `is_naming_row` itself. A form the reader already knows
costs nothing to learn and cannot be misread as a wildcard wider than it is.

**The translation is exactly three digits**, not one or more. A four-digit story number, or
letters where the digits belong, still reports, which keeps the row a statement about a naming
convention rather than a hole.

**US004 writes exactly two rows** —
`project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md` and
`project-management/src/18-TESTS/AUTOMATED/US###-TEST-STATUS.md`. **No `17-STORY-PLANS` row**,
measured: nothing in the repository cites a story plan that does not exist, and a row for
it would be the register answering in passing.

**The alternatives lose for the reasons they lost on 02/09/2026.** One literal row per story —
`project-management/src/18-TESTS/MANUAL/US001-MANUAL-TESTING.md` and its siblings, one at a
time — is correct and unbounded: the register would accumulate two rows per story and fail closed
the first time one was missed. A real shell glob buys nothing over `###` and would be the only
glob in a repository of `###`. A `doc-references: ignore` marker on each site writes a false
justification into every line it touches — 22 of them, as measured that day.

## Consequences

- **Positive:** the decision in force states the paths the tree now holds, and the 02/09/2026
  record stands exactly as accepted, so what was decided, and when, stays legible.
- **Negative / trade-off:** the decision now exists in two records, and citations of the
  superseded filename still name the record no longer in force:
  `project-management/src/02-STORIES/US004.md:157` and
  `project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md:64`. Each
  is kept, not re-pointed, and each now has this record cited beside it, at
  `project-management/src/02-STORIES/US004.md:161` and
  `project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md:68`.
- **What changes:** the two paths only. The rows are written into `MANUAL/` and `AUTOMATED/`, where
  the superseded record wrote them at the `18-TESTS/` root.
- **What does not:** every rule, count and follow-on besides those paths — the patterned row, the
  `###` spelling, exactly three digits, exactly two rows, no `17-STORY-PLANS` row, and each
  trade-off and follow-on below.
- **Follow-on:** US004's implementation reads this record, not the superseded one. Its driving
  story's _Decisions_ list (`project-management/src/02-STORIES/US004.md:133-171`) already carries
  this record, beside the superseded one, at `project-management/src/02-STORIES/US004.md:161-164`,
  per `project-management/workflows/15-decisions/STEPS.md` Step 12.

**Carried unchanged from the superseded record**, so that they stay in force:

- **Positive:** one row binds a whole artefact class. The 22 forward references measured on
  02/09/2026 pass, and the next story's two pass without a register edit.
- **Positive:** the register stops being a place where a mechanism limit dictates the doctrine —
  before this, "what may a document promise" was answered by what `grep -qxF` could match.
- **Negative / trade-off:** the register can under-report. A citation of a per-story artefact whose
  story does not exist now passes, where a literal row would have caught it. Accepted because the
  story number in such a citation is itself the error, and `US###.md` is checkable by Check 1's new
  `project-management/src/*` arm, which US004 adds — the wrong story number is caught one hop
  away.
- **Negative / trade-off:** a patterned row is a broader promise, so the register's guardrail
  against answering in passing needs restating rather than assuming. `code/docs/FORWARD-VOICE.md`
  Section 3 must say a row may be patterned **and** that one is written only for a class something
  actually cites.
- **Follow-on:** `code/docs/FORWARD-VOICE.md` Section 3 and the register's own header gain the
  pattern form and the duty to add a row when a citation first needs one. The duty is stated there
  once and in no workflow `CHECKLIST.md`.
- **Follow-on:** the baseline-diff regime of
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
  restated unchanged on 30/09/2026 by
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  retires by its own terms when US004 lands — recorded here and in the sibling record,
  `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026.md`,
  rather than by a status change, because its reasoning was never overturned. Its supersession on
  30/09/2026, for the same path move as this record's, is not that retirement.
