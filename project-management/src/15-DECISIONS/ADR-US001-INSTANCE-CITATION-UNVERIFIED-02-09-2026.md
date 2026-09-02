# ADR-US001: The full-path citation convention stands, but nothing verifies it

**Status:** Proposed
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-FULL-PATHS-02-09-2026.md`
**Superseded by:** —
**Related:** US001, US002

---

## Context

`project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-FULL-PATHS-02-09-2026.md` chose
Option B — cite PM instance artefacts by full repo-relative path — over Option A, stripping the
backticks. Its deciding argument was that B alone keeps the citation doing its job:

> Passes legitimately through the gate's own existence test rather than by evading it. The
> citation stays clickable and **machine-verified**, so a moved or renamed artefact **breaks the
> gate** — which is what a citation is for.

**That argument is false, and it was measured false on the day the record was accepted.** A full
repo-relative path to a PM `src/` artefact is tested by neither of the two checks that could test
it, so it does not pass the existence test — it never reaches one.

**Check 2 is `^`-anchored.** `code/src/scripts/audits/doc-references.sh:675` reads
`grep -qE '^(ADR-[0-9]{3}|US[0-9]{3}|SPRINT-[0-9]{2}|…)'`. The token
`project-management/src/02-STORIES/US001.md` begins `project-`, so it does not match the
alternation and never enters the block containing the `[ ! -e "$token" ]` test the superseded
record quotes. The bare form `US###.md` **does** match, which is why the short form reddens and
the long form does not — but the long form's silence is a miss, not a pass.

**Check 1 has no arm for this tree.** The checkable-tree `case` at
`code/src/scripts/audits/doc-references.sh:762-780` lists `code/docs/*`, `code/workflows/*`,
`code/src/scripts/*`, `code/src/django/*`, `how-to/docs/*`, `how-to/workflows/*`, `how-to/src/*`,
`project-management/docs/*`, `project-management/workflows/*`, `.claude/*` and `.github/*`.
**`project-management/src/*` is absent**, so the token falls to `*) continue` and is dropped
before Check 1's own existence test.

**Proven in this tree, not argued.** `project-management/src/02-STORIES/US001.md` cites
`../18-TESTS/US001-MANUAL-TESTING.md` twice, in its QA Acceptance Criteria and again in its QA
Tasks. That file does not exist — `project-management/src/18-TESTS/` holds `CLAUDE.md`,
`CONTEXT.md`, `US000-MANUAL-TESTING.md` and `US000-TEST-STATUS.md` and nothing else. **The audit
exits 0.** A dead citation of exactly the class the superseded record promised would "break the
gate" sits in the story that record was written for, and the gate is green.

**Two further defects surfaced by the same measurement**, both independent of the anchor:

- Check 2's alternation still carries `ADR-[0-9]{3}`, the monotonic counter **retired 31/08/2026**
  (`project-management/src/15-DECISIONS/CLAUDE.md`, _There is no index_). The live convention is
  `ADR-US###-<DECISION>-DD-MM-YYYY.md`, which matches neither `^ADR-[0-9]{3}` nor `^US[0-9]{3}`.
  **No ADR filename in this repository is checkable by Check 2 in any form**, short or long.
- It carries `QA-US[0-9]{3}` against a live convention of `QA-PLAN-US###-<DESCRIPTOR>.md` — the
  spelling corrected across `project-management/workflows/11-qa-checks/` on 02/09/2026. Same
  result: the short form is uncheckable too.

The superseded record is not merely incomplete. It states a property the tree does not have, and
`code/docs/GATE-REPORTING.md` names that failure precisely: a gate that could not look reported as
a gate that looked and found nothing. An ADR asserting machine-verification where none exists
manufactures exactly that false green in the reader.

**One further tell, visible in the superseded record itself.** Its Option B summary reads _"Always
write `project-management/src/02-STORIES/US001.md`, never
`project-management/src/02-STORIES/US001.md`"_ — both halves identical, the contrast the sentence
needs destroyed by the convention it was arguing for. Its Context paragraph carries the same
collapse. A convention that cannot state its own counter-example is a convention worth re-reading.

## Options considered

### Option A — Revert to the short form and accept the findings

- **Summary:** Cite by bare `US###.md` filename, let Check 2 fire, and treat the red gate as the
  honest signal.
- **Pros:** No false claim of verification; the noise is visible rather than silent.
- **Cons:** A permanently red gate stops being read — the cost the superseded record's Option D
  named correctly. It also does not gain verification: the finding fires on the citation's
  _class_, not on whether the target exists, so a red gate here still says nothing about
  correctness.

### Option B — Keep the full path, and withdraw the verification claim

- **Summary:** The convention stands unchanged on its readability merits. The record stops
  claiming the gate checks it, and states plainly that **no gate currently checks any PM `src/`
  citation in either form**.
- **Pros:** Costs nothing to adopt — the artefacts already carry full paths. Honest about what is
  and is not enforced, per `code/docs/GATE-REPORTING.md`. The path is still clickable in an editor
  and unambiguous to a reader, which were always its real benefits.
- **Cons:** Leaves a real hole open. Between now and the script fix, a renamed or deleted PM
  artefact leaves dead citations that nothing catches — the phantom above is the proof it is not
  hypothetical.

### Option C — Fix `doc-references.sh` now, in US002

- **Summary:** Add a `project-management/src/*` arm to Check 1's checkable-tree `case`, and correct
  Check 2's alternation for the retired `ADR-###` and the `QA-PLAN-US###` rename.
- **Pros:** The only option that produces the verification the superseded record claimed.
- **Cons:** `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> slice `S-06` owns the
  first edit to this script and is blocked on that map's RESOLVE sitting. Taking it here creates
  the second unreviewed editor of a file whose ownership is the thing being settled — the same
  objection the superseded record raised, and it still holds.

## Decision

**We will take Option B, and escalate Option C from "later" to a named blocker.**

The convention itself was never the problem — full repo-relative paths are more readable, survive
a file moving between sibling directories, and cost only characters. What has to go is the claim
attached to it. This record therefore keeps the form and deletes the justification, replacing it
with the measured statement that **no gate verifies a PM `src/` instance citation in either form
today**.

Option C is not taken here for the reason the superseded record gave and which measurement did not
disturb: `S-06` owns the file. But its status changes. The superseded record filed the script fix
as an open gap that could wait on a blocked slice; the phantom citation proves the interim has a
live cost, so the `GAPS.md` entry is corrected in the same change as this record and re-scoped from
"the rule over-applies" to "the rule over-applies **and under-applies**, and the second half lets
dead citations through".

## Consequences

- **Positive:** The repository stops asserting a verification it does not perform. The three
  measured defects — the `^` anchor, the missing Check 1 tree arm, and the two stale conventions in
  the alternation — are written down where the fix will read them, rather than being rediscovered.
- **Negative / trade-off:** PM `src/` citations remain unverified until `S-06` lands. Every story,
  QA plan, sprint record and ADR written before then may carry a dead citation nobody is told
  about. **A human read-across is the only check**, which is the same conclusion
  `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` reached
  for prose doctrine, and for the same reason.
- **Follow-on — the phantom is not fixed by this record.**
  `project-management/src/02-STORIES/US001.md`'s two citations of
  `../18-TESTS/US001-MANUAL-TESTING.md` are a forward reference to a file its implementation
  creates, so they are correct as intent and dead as of today. They are left in place and named
  here so that the next reader knows the gate did not clear them.
- **Follow-on:** `GAPS.md`'s 02/09/2026 entry is corrected in this change — it repeated the same
  false mechanism, stating that "a full repo-relative path passes and a bare filename does not",
  which describes an existence test that the anchored regex means never runs.
