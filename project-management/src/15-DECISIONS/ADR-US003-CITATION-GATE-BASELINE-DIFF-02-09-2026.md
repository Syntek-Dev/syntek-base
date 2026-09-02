# ADR-US003: A red citation gate is read as a diff against a recorded baseline

**Status:** Accepted
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US003

---

## Context

`code/src/scripts/audits/doc-references.sh` **exits 1 before US003 writes a line.** Measured
02/09/2026 at `82ec176`: seven unresolved citations, every one a `[template-only citation]`
against a per-project artefact under `project-management/src/`. The defect is recorded in
`GAPS.md` dated 02/09/2026, and the first edit to that script belongs to
`project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06`, which is blocked
on its own map's RESOLVE sitting. **Neither this story nor any story in this backlog may fix
it.**

US001 set the precedent of listing the gate in a story's Verification Checks as a flat
must-pass. That was written when the gate was believed green. It is not, and a criterion that
cannot be satisfied by anything the story does is a criterion that gets ticked anyway — which
is the exact failure `code/docs/GATE-REPORTING.md` names: a gate that could not look, reported
as a gate that looked and found nothing.

**The problem is not hypothetical, and this story sharpened it.** US003's own artefacts add
findings the story cannot clear while remaining correct:

| Source                                                                              | Findings | Class                                                                   |
| ----------------------------------------------------------------------------------- | -------- | ----------------------------------------------------------------------- |
| Pre-existing at `82ec176`                                                           | 7        | PM-`src/` template-only — the `GAPS.md` entry's class                   |
| the story, `project-management/src/02-STORIES/US003.md`                             | 8        | 3 forward references to the guide it creates; 5 PM-`src/` template-only |
| the sprint, `project-management/src/03-SPRINTS/SPRINT-02.md`                        | 2        | 1 forward reference; 1 PM-`src/` template-only                          |
| the QA plan, `project-management/src/11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` | 5        | 3 forward references; 2 PM-`src/` template-only                         |
| **Total**                                                                           | **22**   | **10 forward references · 12 PM-`src/` template-only**                  |

The ten forward references all name `code/docs/ABSENCE.md` and clear the moment the guide
lands. The twelve template-only findings are citations written in the form
`project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`
mandates — correct by doctrine, and invisible to the gate by defect.

**A story cannot be blocked on a gate it is forbidden to repair.** But it also cannot report a
red gate as green. This record decides how the difference is stated.

## Options considered

### Option A — Keep US001's flat must-pass

- **Summary:** The story's Verification Checks say `doc-references.sh` passes, unchanged.
- **Pros:** Consistent with the one story already written; no new vocabulary.
- **Cons:** Unsatisfiable. The only honest ways to tick it are to clear seven findings this
  story may not touch, or to tick it falsely — and the second is what actually happens, because
  a checklist item that blocks a PR gets ticked. It manufactures the false green
  `code/docs/GATE-REPORTING.md` exists to prevent.

### Option B — Baseline-and-diff

- **Summary:** Record the finding count and their identities before any file is edited. The
  criterion becomes: no **new** unresolved citation from any shipped file this story writes or
  edits, read as a diff against that baseline, and never reported as the gate passing while the
  baseline stands.
- **Pros:** States exactly what was checked and what was not, which is the `GATE-REPORTING.md`
  idiom. Keeps the gate's real signal — a citation this story got wrong still reddens against
  the diff. Costs one recorded measurement per story.
- **Cons:** The baseline is per-story state that someone has to actually capture, and a new
  finding can hide inside a growing baseline if the diff is done carelessly rather than
  mechanically. It also normalises a red gate, which is a real cost: a gate nobody expects to be
  green stops being read.

### Option C — Block the backlog on `S-06`

- **Summary:** No story ships until `doc-references.sh` is repaired.
- **Pros:** The gate returns to a single unambiguous meaning, and nobody has to reason about
  baselines.
- **Cons:** `S-06` is blocked on a RESOLVE sitting that is not scheduled. This stops three
  wave-0 stories, two sprints and the whole absence epic on a defect that costs a recorded
  number to work around. The blocker is procedural, not technical.

### Option D — Exempt the PM `src/` tree in the script now

- **Summary:** Add the missing arm and take the fix here.
- **Pros:** Fixes the cause rather than reporting around it.
- **Cons:** `S-06` owns the first edit to this file, and its ownership is the thing that map's
  sitting exists to settle. Taking it here creates a second unreviewed editor of exactly the
  file whose ownership is contested — the objection
  `ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` raised and measurement did not disturb.

## Decision

**We will take Option B, and it applies to every story in this backlog until the gate is green,
not to US003 alone.**

The deciding factor is that B is the only option that leaves the gate's signal intact. A is
dishonest, C is disproportionate, and D takes a file this story has no standing to touch. B
costs one measurement recorded in `../18-TESTS/US###-MANUAL-TESTING.md` before editing begins,
and in exchange a citation the story genuinely got wrong still reddens — because it appears in
the diff and not in the baseline.

**The baseline is captured before the first edit, never reconstructed afterwards.** A baseline
measured after the change cannot distinguish a pre-existing finding from one the story
introduced, which is the entire property being bought.

## Consequences

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
- **Follow-on:** `GAPS.md`'s 02/09/2026 entry gains the measurement above as further evidence of
  the defect's live cost.
