# ADR-US004: Check 2 admits a plan's exec-order prefix as optional, and enforces nothing about it

<!-- PROVENANCE. This decision was first written on 08/09/2026 as an appendix onto
     project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md.
     That record is Accepted and therefore immutable, so the appendix was reverted the same day
     and the record is byte-identical to its committed state. The decision was real; this file
     is where it belongs. It does NOT supersede that record: its Option C stands as decided.
     Written outside the per-story loop, so it enters as Proposed and is checked at US004's own
     15-decisions pass alongside the story's two Accepted records. -->

**Status:** Proposed <!-- checked, and Accepted or superseded, at US004's own 15-decisions pass -->
**Date:** 08/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US004 · `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` (stands as decided; this record replaces nothing in it)

---

## Context

Check 2 of `code/src/scripts/audits/doc-references.sh` bans a citation to a per-project instance
artefact. It reads the raw backticked token against one `^`-anchored alternation — `US[0-9]{3}`,
`SPRINT-[0-9]{2}`, `SPRINT-PLAN-[0-9]{2}`, `STORY-PLAN-US[0-9]{3}` and their siblings — and a
token that matches and names no file on disk is an `[instance citation]`. The two plan arms have
read that way since the check was written on 11/08/2026 (`af15f4e`, v2.19.0). This alternation is
the list `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`
Option C proposes to reuse on the citer's side, which is why that record calls it "one list to
keep current".

**Both plan families are named for their position in the build order, not only for what they
plan.** `project-management/src/16-SPRINT-PLANS/` has named a plan
`<exec-order>-SPRINT-PLAN-<sprint-number>.md` since its template was added on 01/08/2026 — ten
days before the alternation was written without the prefix. `project-management/src/17-STORY-PLANS/`
adopted `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` on 08/09/2026, by `git mv` of
its six plans, in the working tree as this is written. So `STORY-PLAN-US###` in the citer-test
record's Option C names a plan basename from the story number onwards, not the whole of it — and
`SPRINT-PLAN-##` there never named the whole of one.

**Anchoring made the gap silent.** A bare basename carrying the prefix — `NN-SPRINT-PLAN-NN.md`,
`NN-STORY-PLAN-US###-<DESC>.md` — matched neither `^SPRINT-PLAN-` nor `^STORY-PLAN-US`. It then
fell past Check 1 as well, whose `*/*` path guard drops any token without a slash before the
existence test. A token that matches nothing is not a finding; it is nothing, and the run's count
line reported it among the tokens examined. The sprint half of that hole had been open since
11/08/2026, against a folder whose template already carried the prefix; the story half opened on
08/09/2026 with the rename.

**Measured on this tree, with the prefix admitted** — `read 1030 file(s); 92 exempt by rule`,
`checked 35756 backticked token(s)`, 254 findings, exit 1 — the run reports **39**
`[instance citation]` findings whose token begins with a two-digit prefix: 34 on the sprint-plan
arm, 5 on the story-plan arm, across 13 citing files, every one under `project-management/src/`.
None of the 39 was reported before the alternation moved. The population moves as the day's
cascade repoints citations, so the figure is dated to this run rather than claimed as fixed; the
number that does not move is the one before the fix, which was zero.

**The edit landed outside US004 and before US004's own baseline.** `git log` shows no commit to
the script since `28fb14b` (01/09/2026); the uncommitted diff of 08/09/2026 — this correction,
together with `Check 4 — plan prefix` — is the first edit since three Accepted records each
recorded that slice `S-06` of `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`,
carried by US004, owns the first edit to it:
`project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`,
`project-management/src/15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` and
`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`. The
third states that "the baseline is captured before the first edit, never reconstructed
afterwards"; `project-management/src/02-STORIES/US004.md` schedules the whole-tree baseline before
any file is edited, and
`project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` records the
before/after counts. That property is gone for this file: **US004's before/after measurement now
starts from a moved detector**, whose "before" already contains this correction. This record
states the fact; what US004 does with it is decided at US004's own `15-decisions` pass, where this
record is checked.

The decision below is confined to the alternation. Whether a cited name is spelt to the convention
on disk is a different judgement — made from the string, never from existence — and it is Check
4's. This record does not argue Check 4.

## Options considered

### Option A — require the prefix in both arms

- **Summary:** `[0-9]{2}-SPRINT-PLAN-[0-9]{2}` and `[0-9]{2}-STORY-PLAN-US[0-9]{3}`; the
  alternation names the on-disk form and only that.
- **Pros:** the regex and the two folders' naming rules say the same thing, so a reader of one
  learns the other. One spelling per family.
- **Cons:** the unprefixed spelling leaves Check 2's population, and Check 1's guard drops it for
  having no slash — so the hole is not closed but moved, onto the form a dated history note is most
  likely to carry. A plan may still be cited by the unprefixed name it was written under, and the
  story family carried that name until 08/09/2026; a story plan's prefix is renumbered whenever
  build order changes, so every spelling other than today's is one a correct citation has
  legitimately had. And `[0-9]{2}-` verifies **presence** only — any two digits match — so A buys
  the one property an existence check cannot use and Check 4 already owns, at the price of an
  existence check over every citation in the unprefixed spelling.

### Option B — admit the prefix as optional (the decision)

- **Summary:** `([0-9]{2}-)?SPRINT-PLAN-[0-9]{2}` and `([0-9]{2}-)?STORY-PLAN-US[0-9]{3}`. Both
  spellings of each family stay inside the population; nothing else in the clause — `base`, the
  seeded lookup, the map lookup — moves.
- **Pros:** closes both halves of the hole with one optional group per arm. The unprefixed name
  still counts as the citation it is; a renumbered prefix, being any two digits, still matches, so
  a renumber never changes what the gate examines. The same alternation, read on the citer's side
  once US004 lands, will recognise a prefixed plan as an instance citer — which the alternation as
  it stood would not have done for any sprint plan, or for any story plan after 08/09/2026.
- **Cons:** **the alternation enforces nothing about the prefix.** Present, absent, stale or
  wrong, Check 2 reports all four identically and says nothing about the name — which is why a
  separate `Check 4 — plan prefix` exists, and where this record's interest in the prefix ends.
  And the list is still hand-maintained: the citer-test record priced that as "a new per-story
  artefact class loses its exemption silently until someone adds it", and a rename of an existing
  class turns out to cost the same.

### Option C — leave the alternation; carry the prefixed form in a separate clause

- **Summary:** keep `^SPRINT-PLAN-` and `^STORY-PLAN-US` as written; a new clause matches the
  prefixed bare basename and records it as an instance citation.
- **Pros:** the regex already fixtured stays byte-identical, and the new clause could carry the
  naming rule in the same place.
- **Cons:** two clauses answer one question — is this token an instance artefact? — for one
  family. The last time this script held two copies of one judgement, the anchor peel, both
  drifted and only one could be fixtured (corrected 01/09/2026, `28fb14b`). The prefixed form is
  not a new artefact class; it is the same artefact spelt to a newer convention, and a second
  clause would say otherwise. It also leaves the alternation reading as a statement about naming
  that is false on disk.

### Option D — do nothing

- **Summary:** leave the 39 unchecked.
- **Pros:** no edit to a file whose first edit three Accepted records assign to US004.
- **Cons:** the sprint half has been unchecked since the day the check was written, with the count
  line reporting the population as examined. A measured hole is not an option. The ownership cost
  is real and is recorded in the Context above; leaving the gate blind would not avoid it.

## Decision

**We will take Option B: the two-digit exec-order prefix is optional on both plan arms of Check
2's alternation.**

The deciding factor is what the alternation is for. Check 2 is an **existence** check over an
artefact class, and the class has more than one legitimate spelling — the name a plan was written
under, and the name it carries after each renumber. A citation is a claim about a document; an
alternation that recognised only today's spelling would decide, at every renumber, that
yesterday's correct citations were citations of nothing. Option A closes the prefixed half by
opening the unprefixed one, because Check 1 drops both; it moves the hole rather than closing it,
and the only thing it adds — that a prefix is present — is a naming judgement, not an existence
one. Option C keeps the regex untouched at the cost of a second copy of the question, in a file that
has already shown what two copies do.

What B gives up is stated, not hidden: **the alternation enforces nothing about the prefix.** It
decides membership of the class and nothing more. Whether the name is spelt to the convention —
present, current, and for a story plan matching build order — is a judgement made from the string
rather than from existence, and it lives in `Check 4 — plan prefix`, added the same day with its
own long comment. This record argues the alternation and stops there.

## Consequences

- **Positive:** 39 citations checked by nothing are now inside Check 2's population — 34
  sprint-plan, 5 story-plan, 13 citing files, measured on this run — and the run's count line now
  counts them as what they are.
- **Positive:** a renumber no longer changes what the gate examines. The class is recognised in
  every spelling it has had, so the rule in `project-management/src/17-STORY-PLANS/CLAUDE.md` —
  renumber the whole affected run and repoint every citation in the same change — can be followed
  without the gate going quiet on the citations in between.
- **Positive:** the citer-test record's Option C reuses this alternation on the citer's side. As
  it stood, that reuse would have recognised no sprint plan — they have always been prefixed —
  and, after 08/09/2026, no story plan; every citation from a plan to its own story would have
  fired. Read on the alternation as it now stands, a prefixed plan is an instance citer.
- **Negative / trade-off:** the hand-maintained alternation's cost has now been paid once, and not
  for the reason the citer-test record priced. That record anticipated a **new** artefact class
  arriving unlisted; the trigger was a **rename** of an existing one, which it did not anticipate,
  and the cost fell on the cited side it took to be already carried. Anchoring is what made the
  gap silent: the `^` that keeps a path-form token from reading as a bare basename is the same
  `^` that stopped a prefixed bare basename from reading at all, and a token that matches nothing
  raises no finding. The next rename of a listed class will do the same, and only a fixture on the
  new spelling catches it.
- **Negative / trade-off:** the alternation enforces nothing about the prefix. A prefix that has
  since been renumbered passes Check 2 exactly as a current one does; so does no prefix at all.
  That is by design here — neither the correct file nor the stale one exists on this side of
  generation, so an existence check cannot tell them apart — and it is the whole reason Check 4
  exists as a separate clause. Nothing in this record decides Check 4.
- **Negative / trade-off:** ownership. This is the first edit to the script since three Accepted
  records assigned that edit to US004, and it landed before US004's baseline. The property
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` bought
  — a baseline captured before the first edit — cannot be recovered for this file. Recorded, not
  excused; what US004 does about its before/after is its own `15-decisions` pass's call.
- **Follow-on:** **the two plan conventions are not one rule, and the alternation must not be
  read as saying they are.** It treats the families alike because it reads the presence or
  absence of two digits and nothing more. A sprint plan carries **two** numbers, and a mismatch
  between them is deliberate information that must never be "corrected" —
  `project-management/src/16-SPRINT-PLANS/CLAUDE.md` owns that rule. A story plan carries **one**,
  so a prefix drifted from build order says nothing and is a defect —
  `project-management/src/17-STORY-PLANS/CLAUDE.md` owns that one. Anything that ever reads the
  prefix's **value** reads those two files separately, from the folder that owns each. This
  record creates no rule in either.
- **Follow-on:** US004's story plan edits this same alternation again — `ADR-US###` added, the
  retired `ADR-###` counter dropped, the `QA-PLAN-US###` spelling corrected — and owes the
  citer-test fixture pair. Both land against the alternation as it now reads, not against
  `28fb14b`, and the fixture pair should include a prefixed plan as citer, because the optional
  group is what makes that citer recognisable. The shape of the fixture is US004's.
