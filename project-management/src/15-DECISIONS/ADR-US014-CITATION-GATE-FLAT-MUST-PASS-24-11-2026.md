# ADR-US014: The citation gate is a flat must-pass again — the baseline-diff regime retires

**Status:** Accepted
**Status note:** Accepted 24/11/2026 by <%DEVELOPER_NAME%>, 15-decisions grilling Q2 = 1 (both retirement conditions are measured facts)
**Date:** 24/11/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md, ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md
**Superseded by:** None
**Related:** US014 (cleared the last surviving findings); US004 (slice `S-06`, which repaired the gate)

---

## Context

`code/src/scripts/audits/doc-references.sh` was red for most of the backlog. Its findings were
real dangling citations, but slice `S-06` of `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`
owned the script, and no other story was allowed to repair it. A flat "the gate must pass" rule
would have blocked every story on work none of them could do.

Two decisions covered that gap:

- `ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` set the **baseline-diff
  regime**. Every story captures the gate's findings by identity before its first edit, keeps the
  baseline in its manual testing guide, re-baselines after any upstream merge, and at review reads
  the gate as a diff — no new finding in a file the story edits — rather than as pass or fail.
- `ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md` excepted US008 from part of that rule while
  the gate stayed red.

Both stated the same exit. ADR-US003's _Consequences_: "This record **retires when `S-06` lands**
and the gate goes green … a new record should supersede this one rather than editing it."
ADR-US008-SCOPED: "This exception dies with the rule it excepts from."

**Both conditions now hold, measured 24/11/2026:**

- **`S-06` landed** as US004 (`project-management/src/02-STORIES/US004.md`, Completed, shipped in
  7.9.0).
- **The gate is green.** US014 cleared the last 21 surviving findings: six by building the files
  they cited, twelve by quoting forward and historical references, and three by retiring the
  `GAPS.md` entry that held them (US014 Key Decision 18). `doc-references.sh` exits 0 —
  "Clean — every citation resolves" — on `dev` at the PR #44 merge `94db8f02`.

`GAPS.md`'s 05/11/2026 entry on the regime names the author of this record: "The story that
clears the last survivor writes one superseding ADR retiring the regime and ADR-US008-SCOPED by
full filename on both." That story is US014.

## Options considered

### Option A — Do nothing; leave the regime in force

- **Summary:** keep capturing a baseline before every story's first edit and reading the gate as a
  diff.
- **Pros:** no record to write; nothing changes for a story already in its plan.
- **Cons:** keeps a ceremony whose reason has gone. Worse, a diff against a clean baseline hides
  less than nothing: a pass/fail gate reports the same regression more simply, and a baseline that
  someone captured wrongly can mask it. The two records would also keep stating a premise — a red
  gate no story may fix — that is no longer true.

### Option B — Retire the regime; the gate is a flat must-pass

- **Summary:** a story's PR requires `doc-references.sh` to exit 0. No baseline before the first
  edit, no upstream re-baseline, no diff reading.
- **Pros:** the rule both records promised on retirement; simpler for every future story; a
  regression fails loudly instead of being netted against a baseline.
- **Cons:** a story that introduces a dangling citation must fix it before its PR rather than
  carry it — which is the intent.

### Option C — Retire the regime and correct ADR-US001 in the same record

- **Summary:** also supersede `ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`, which still
  says no gate verifies a PM `src/` citation (Check 1 has done so since US004).
- **Pros:** one record clears both stale premises the `GAPS.md` entry names.
- **Cons:** two decisions with different subjects in one record, against "one ADR = one decision"
  (`ADR-US000-TEMPLATE.md`). Rejected at grilling Q1 = 1.

## Decision

**We take Option B.** `doc-references.sh` is a flat must-pass gate again: a story's pull request
requires it to exit 0, exactly as every other audit. The baseline-diff regime of
`ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` and the exception of
`ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md` are both superseded.

It beat Option A because the two records set this exact retirement condition for themselves, and
it is now met on measured evidence; keeping the regime would be keeping a workaround after the
fault it worked around was repaired. It beat Option C because the ADR-US001 correction is a
separate decision, and stays open in `GAPS.md` until a story drives it.

## Consequences

- **Positive:** every later story drops the citation baseline from its P0, its manual guide's
  build slots and its review. A dangling citation now fails the gate on the change that adds it.
- **Negative / trade-off:** a story can no longer carry a pre-existing citation finding forward;
  whoever turns the gate red fixes it in that change.
- **Neutral — nothing shipped changes.** No workflow, skill or template prescribes the citation
  baseline: only the two superseded records and the per-story plans did, and those plans are
  history. The manual guide's general _Recorded during the build_ section stays, because it serves
  other build-time captures (`project-management/src/18-TESTS/MANUAL/CLAUDE.md`).
- **Neutral — no story is mid-switch.** US012, US013 and US014, the three stories that used the
  regime last, are past their build (In Review); none has yet to start under it.
- **Follow-on:** both superseded records are marked `Superseded` with this filename in
  **Superseded by**, and may then be archived through `pm-archive.sh`. `GAPS.md`'s 05/11/2026
  entry keeps only its ADR-US001 half, still unclaimed. `audits/doc-references.sh` is unchanged —
  it already exits 1 on any finding; what changes is that nobody reads that exit as a diff.
