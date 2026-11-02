# ADR-US003: A red citation gate is read as a diff against a recorded baseline — restated after the 18-TESTS split

**Status:** Accepted
**Date:** 30/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
**Superseded by:** —
**Related:** US003

---

## Context

`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` decided
on 02/09/2026 that while `code/src/scripts/audits/doc-references.sh` is red, a story's citation
criterion is a diff against a baseline captured before the first edit. Its decision names one path:
the diff "costs one measurement recorded in `../18-TESTS/US###-MANUAL-TESTING.md` before editing
begins" (`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md:97`).

**That location no longer exists.** On 30/09/2026 `project-management/src/18-TESTS/` split by
record type: the manual testing guide moved into `MANUAL/` and the automated record into
`AUTOMATED/`, filenames unchanged. Each record now sits in its own sub-folder, and the root holds
only its `CONTEXT.md` and `CLAUDE.md` (`project-management/src/18-TESTS/CLAUDE.md:78-79`, `:93`).
The guide the decision writes to is now `project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md`.

**The change that made the split re-pointed that path inside the Accepted record, in place.** The
edit was reverted, because Accepted ADRs are immutable
(`project-management/src/15-DECISIONS/CLAUDE.md:44-46`), and supersession was chosen instead
(settled 30/09/2026, 16-sprint-plans grilling round 6 Q17). The superseded record's text is its
committed text, bar the two supersession lines set in the same change as this record. Each record
the split re-pointed gets its own successor, restating its decision unchanged with the new path
(settled 30/09/2026, 16-sprint-plans grilling round 7 Q18): one ADR is one decision, with one
filename in **Supersedes** and one driving story in its name, and a superseded decision stays in
force only where its successor states it.

**Nothing else about the problem has moved.** The superseded record's Context stands as written
(`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md:12-45`):
the red gate, the seven pre-existing findings measured at `82ec176`, the fifteen more that US003's
own artefacts added (22 in all), and slice `S-06`'s ownership of the script, which forbids any
story in this backlog to repair it. Those figures are dated evidence of 02/09/2026, and this record neither
re-measures nor restates them.

**The split also gave the guide a home for this kind of capture.** The template's
`## Recorded during the build` section
(`project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md:36`) holds evidence a spec
requires that is not a step — "a baseline or an inventory captured before the first edit"
(`project-management/src/18-TESTS/MANUAL/CLAUDE.md:102-118`). It is authored at `17-story-plans`
with every value blank, filled by the implementer before the first edit
(`code/workflows/01-implement-story/STEPS.md:73-74`), carries no `Result` and is never walked, and
a capture missed at its moment "is recorded as missed, never reconstructed". That folder rule was
shaped with this decision in view: its dated rationale records that "an ADR's decision text is not
rewritten to suit a folder rule, so the rule took the write instead"
(`project-management/src/18-TESTS/MANUAL/CLAUDE.md:214-222`). US003's own guide already carries
the slot (`project-management/src/18-TESTS/MANUAL/US003-MANUAL-TESTING.md:61`). **Which section of
the guide holds the baseline is that folder rule's to say, not this record's.** The Decision below
binds the file, as the superseded record did, and names no section.

## Options considered

The superseded record's own options analysis — keep US001's flat must-pass, baseline-and-diff,
block the backlog on `S-06`, exempt the PM `src/` tree in the script now — stands as written
(`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md:47-88`)
and is not re-argued here. The options below are about how that decision crosses the split, not
about the decision.

### Option A — Re-point the path inside the Accepted record

- **Summary:** Edit `:97` of the superseded record to the `MANUAL/` path and leave it `Accepted` —
  the edit the split made, since reverted.
- **Pros:** One line changed. Every artefact citing the 02/09/2026 filename keeps pointing at a
  live decision with a correct path.
- **Cons:** Rewrites an Accepted record's decision text, which
  `project-management/src/15-DECISIONS/CLAUDE.md:44-46` forbids. Nothing in the record would show
  that it changed, or when: "an edited record hides that the reasoning moved, and the next reader
  re-litigates it" (`project-management/workflows/15-decisions/STEPS.md:51-52`).

### Option B — Correct in place under a dated note

- **Summary:** Re-point the path and add a dated `Corrected:` header line saying why, as
  `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md:5-8`
  did.
- **Pros:** The change is visible and dated, and no second record exists.
- **Cons:** That precedent justified itself "because the record had not yet reached a commit and no
  reader could have relied on it" (`:7`). This record was committed on 02/09/2026 at `c57a8ed` and
  is cited across the backlog. Rejected under round 6 Q17.

### Option C — Revert, and leave the record standing

- **Summary:** Keep the revert and do nothing further.
- **Pros:** No new record, and nothing edited.
- **Cons:** The decision in force would direct every story's baseline to the folder root, which
  now holds only its `CONTEXT.md` and `CLAUDE.md` (`project-management/src/18-TESTS/CLAUDE.md:93`).
  The `:97` path is not evidence measured on 02/09/2026, which could stand as history; it tells
  every later story where to write. Not taken: round 6 Q17 paired the revert with a supersession.

### Option D — One successor for all three re-pointed records

- **Summary:** A single record superseding this one and the two US004 records the split also
  re-pointed,
  `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` and
  `project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md`.
- **Pros:** One record for one cause.
- **Cons:** Three decisions in one ADR
  (`project-management/src/15-DECISIONS/ADR-US000-TEMPLATE.md:7`), three filenames in a
  **Supersedes** field that takes one (`:13`), and two driving stories under a name that carries
  one (`project-management/src/15-DECISIONS/CLAUDE.md:60-61`). Rejected under round 7 Q18.

### Option E — Supersede this record alone, restating its decision unchanged

- **Summary:** This record. The 02/09/2026 record goes `Superseded` with its text otherwise
  untouched, and this one states the same decision in full with the one path corrected.
- **Pros:** Both records stay true to their dates. The superseded one still shows what was decided
  and where it pointed on 02/09/2026, and this one is what applies. It is the route
  `project-management/src/15-DECISIONS/CLAUDE.md:44-46` prescribes.
- **Cons:** Two records for one decision. Every artefact citing the 02/09/2026 filename now
  reaches a record whose Status says to read on.

## Decision

**We will take Option E. This record's decision is the superseded record's decision, unchanged
but for the path it names.** Stated in full:

**While `code/src/scripts/audits/doc-references.sh` is red, a story's citation criterion is a
baseline and a diff, and it applies to every story in this backlog until the gate is green, not to
US003 alone.** Before any file is edited, the story records the gate's finding count and every
finding by identity. The criterion is then that no **new** unresolved citation comes from any
shipped file the story writes or edits, read as a diff against that baseline. The result is never
reported as the gate passing while the baseline stands.

**The baseline is recorded in the story's manual testing guide,
`project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md`, before editing begins.**

**The baseline is captured before the first edit, never reconstructed afterwards.** A baseline
measured after the change cannot distinguish a pre-existing finding from one the story introduced,
which is the entire property being bought.

The deciding factor is unchanged: the baseline and diff is the only option that leaves the gate's
signal intact. Keeping US001's flat must-pass is dishonest, blocking the backlog on `S-06` is
disproportionate, and exempting the tree in the script takes a file this story has no standing to
touch. The diff costs one recorded measurement per story. In exchange, a citation the story
genuinely got wrong still reddens, because it appears in the diff and not in the baseline.

Option E beat the other ways of carrying the decision across the split because it corrects the
path without rewriting an Accepted record (A, B) and without leaving the decision in force pointing
at a location the folder no longer has (C). One successor per superseded record keeps one decision,
one **Supersedes** filename and one driving story to each ADR (D).

## Consequences

- **What changes — only the path.** The baseline's recorded location is
  `project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md`, where the superseded record
  wrote "../18-TESTS/US###-MANUAL-TESTING.md".
- **What does not change — everything else.** Every rule, count and follow-on of the superseded
  record other than that path carries over: the scope (every story in this backlog until the gate
  is green), the before-the-first-edit capture, the diff criterion, the never-a-pass reporting, and
  the figures measured on 02/09/2026. Its consequences
  (`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md:107-123`)
  are restated in full below, so that they stay in force; the only wording adapted is the
  `GAPS.md` Follow-on's "the measurement above", which now points at the superseded record's table.
- **Where in the guide — the folder rule's, not this decision.** Which section of the guide holds
  the baseline is set by `project-management/src/18-TESTS/MANUAL/CLAUDE.md:102-118`, today
  `## Recorded during the build`. Under that rule the capture carries no `Result` and is never
  walked, and a capture missed at its moment is recorded as missed. Those follow from the folder
  rule, which owns them; a later rename or move of that section changes the rule, never this
  record.
- **Positive:** The decision in force names a location that exists. The superseded record still
  shows, unaltered, what was decided and where it pointed on 02/09/2026, so the path's move is on
  the record rather than hidden in an edit.
- **Negative / trade-off:** Two records for one decision. The artefacts that cite the 02/09/2026
  filename still name it, and none of them is re-pointed: where the same change found a live
  citation it added this record beside it, and a historical citation is left as written. A reader
  who reaches the superseded record follows its **Superseded by** line here.
- **Negative / trade-off:** Records that relate to the superseded decision relate to the same
  decision, now stated here, and none of them is edited.
  `project-management/src/15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md` is a
  scoped exception to its method. **This supersession is not the retirement that record's
  Follow-on names**
  (`project-management/src/15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md:248-251`),
  though this record does supersede the record it calls binding: this one restates a path, and
  that Follow-on is triggered by US004 landing with the whole-tree gate green. ADR-US008-SCOPED
  stays Accepted, now excepting from the method as this record states it, and its trigger is
  unchanged. That the regime retires when US004 lands is stated in force by
  `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026.md`
  and
  `project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-AFTER-TESTS-SPLIT-30-09-2026.md`.
- **Follow-on:** US003's implementation reads this record, not the superseded one. Its baseline
  goes in `project-management/src/18-TESTS/MANUAL/US003-MANUAL-TESTING.md`, whose
  `## Recorded during the build` section already carries the slot (`:61`, `:74`, `:79`), and the
  story's own scenario already names that path (`project-management/src/02-STORIES/US003.md:310-311`).

**Carried unchanged from the superseded record**, so that they stay in force:

- **Positive:** The repository stops asserting a verification it does not perform, in the story
  layer as well as the guide layer. Every story's QA record states the number it measured, so a
  reader can see the gate's real condition rather than a tick.
- **Positive:** US003's Verification Checks and QA plan already carry this wording, so the
  record documents a practice rather than proposing an unimplemented one.
- **Negative / trade-off:** A red gate is normalised for the duration. Between now and `S-06`,
  anyone reading a green tick beside `doc-references.sh` in an older artefact is reading a
  claim this record retires. **US001's flat must-pass is inconsistent with this decision** and
  is left standing deliberately — that story predates the measurement, and editing a shipped
  story's criteria to match a later record would hide that the reasoning moved.
- **Negative / trade-off:** The discipline depends on a human diffing carefully. Nothing
  enforces the baseline capture; it is a task in the story and a check in the QA plan.
- **Follow-on:** This record **retires when `S-06` lands** and the gate goes green. At that
  point the baseline discipline is unnecessary and the flat must-pass is correct again — a new
  record should supersede this one rather than editing it.
- **Follow-on:** `GAPS.md`'s 02/09/2026 entry gains the measurement of 02/09/2026
  (`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md:31-37`)
  as further evidence of the defect's live cost.
