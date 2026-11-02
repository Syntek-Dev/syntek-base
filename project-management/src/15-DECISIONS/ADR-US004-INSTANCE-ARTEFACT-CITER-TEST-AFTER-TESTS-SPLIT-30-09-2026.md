# ADR-US004: The citation gate asks the filename, not copier, whether a citer ships — restated after the 18-TESTS split

**Status:** Accepted
**Date:** 30/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`
**Superseded by:** —
**Related:** US004

---

## Context

`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` decided
on 02/09/2026 how Check 2 of `code/src/scripts/audits/doc-references.sh` tells whether a citing
file ships: by testing the citer's own **filename** against the instance forms, not by asking
`is_template_only()` and not by globbing `project-management/src/*`. **This record changes nothing
about that decision.** It exists because two paths the decision names have moved.

**What moved.** On 30/09/2026 `project-management/src/18-TESTS/` split into `MANUAL/` and
`AUTOMATED/`, filenames unchanged. The two test-record templates now sit at
`project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md` and
`project-management/src/18-TESTS/AUTOMATED/US000-TEST-STATUS.md`, and `copier.yml:185-186`
re-includes them there. The superseded record names them twice: as `18-TESTS/US000-*` in the copier
allowlist its Context weighs
(`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md:46`), and
as `US000-MANUAL-TESTING.md` in the Follow-on that fixes US004's fixture pair
(`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md:115`).

**Why a successor rather than an edit.** The split first re-pointed those paths inside the Accepted
record, in place. That edit is reverted — the record's text is its committed text, bar the Status
and Superseded by lines set in the same change as this record — and supersession is taken instead
(settled 30/09/2026, 16-sprint-plans grilling round 6 Q17). One successor per superseded record,
each restating its record's decision unchanged with the `MANUAL/` and `AUTOMATED/` paths
(settled 30/09/2026, 16-sprint-plans grilling round 7 Q18), because
`project-management/src/15-DECISIONS/CLAUDE.md` holds a record to one decision, one filename in
Supersedes and one driving story in its name — and a superseded decision stays in force only if its
successor states it.

**What did not move.** The problem, the forces and the options analysis are the superseded record's,
read against the tree of 02/09/2026, and are cited rather than copied: its _Context_
(`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md:12-53`)
for why Check 2 must ask whether the citer ships, why `is_template_only()` is vacuous in a generated
project (`N-009` Q31), and why `project-management/src/` is not a proxy for "does not ship"; its
_Options considered_
(`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md:55-87`)
for the three ways of answering that question. One line anchor has drifted without the decision
moving: the superseded record reads copier's `project-management/src/` re-includes at
`copier.yml:120-146`; on 30/09/2026 they read at `copier.yml:160-188`, under the exclude at
`copier.yml:157`.

**The split adds shipped files under `18-TESTS/`, and none of them reaches this decision.** `MANUAL/`
and `AUTOMATED/` each carry a `CONTEXT.md` and `CLAUDE.md`. They ship by class, through the two
any-depth negations for `CONTEXT.md` and `CLAUDE.md` at `copier.yml:160-161`, not through the named
allowlist — and a pair file is not instance-shaped, so the filename test cannot reach one. The named
allowlist has two entries moved and none added or removed.

## Options considered

Numbered rather than lettered, so they cannot be read as the superseded record's Options A to C,
which the Decision below restates. **The superseded record's own options analysis — its Options A,
B and C on how Check 2 decides whether a citer ships — stands unchanged and is not re-argued here.**

### Option 1 — edit the Accepted record in place

- **Summary:** re-point `18-TESTS/US000-*` and `US000-MANUAL-TESTING.md` inside the superseded
  record, as the split first did.
- **Pros:** one record, no successor; a reader of the old filename sees the current paths.
- **Cons:** rewrites an Accepted record, which `project-management/src/15-DECISIONS/CLAUDE.md`
  forbids — Accepted ADRs are immutable. A reader can no longer tell what the record said on the
  day it was accepted, and its 02/09/2026 measurements silently become claims about a tree it never
  read. Rejected on immutability.

### Option 2 — correct in place with a dated note

- **Summary:** as Option 1, but mark the change with a dated **Corrected:** header line, the shape
  `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md:5-8`
  uses.
- **Pros:** the change is visible on the record itself; no second record to keep in step.
- **Cons:** that precedent justifies itself by the record not yet having reached a commit, so no
  reader could have relied on it. This record was committed on 02/09/2026 (`7f978a9`) and is cited
  as a decision, among others at `project-management/src/02-STORIES/US004.md:149`. Rejected
  (settled 30/09/2026, 16-sprint-plans grilling round 6 Q17).

### Option 3 — supersede with a successor that restates the decision unchanged

- **Summary:** this record. The superseded record keeps its text and gains only its Status and its
  Superseded by line; the decision is stated here in full, with the moved paths.
- **Pros:** the Accepted record stays as it was accepted; the decision stays in force by being
  stated in a record that is in force; the path change is legible as a change rather than hidden in
  one.
- **Cons:** one decision's history now spans two records, and a reader wanting the reasoning
  follows Supersedes to find it. A citer of the superseded filename points at a Superseded record,
  and reaches this one through its Superseded by line unless this record is cited beside it.

### Option 4 — revert, and leave the record standing

- **Summary:** keep the revert and do nothing further; the superseded record stays Accepted.
- **Pros:** no new record, and nothing edited.
- **Cons:** the decision in force would weigh an allowlist entry, `18-TESTS/US000-*`, at a root that
  now holds only its `CONTEXT.md` and `CLAUDE.md` (`project-management/src/18-TESTS/CLAUDE.md:93`),
  and would fix US004's fixture by a bare filename the tree now holds only under `MANUAL/`. Not
  taken: round 6 Q17 paired the revert with a supersession.

### Option 5 — one successor for all three re-pointed records

- **Summary:** a single record superseding this one and the two other Accepted records the split
  re-pointed,
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` and
  `project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md`.
- **Pros:** one record for one cause.
- **Cons:** three decisions in one ADR
  (`project-management/src/15-DECISIONS/ADR-US000-TEMPLATE.md:7`), three filenames in a
  **Supersedes** field that takes one (`:13`), and two driving stories, US003 and US004, under a
  name that carries one (`project-management/src/15-DECISIONS/CLAUDE.md:60-61`). Rejected
  (settled 30/09/2026, 16-sprint-plans grilling round 7 Q18).

## Decision

**We will take Option 3: supersede, and restate the superseded record's decision unchanged.** The
deciding factor is immutability — the only option that leaves the Accepted record intact while the
decision it carries stays in force with the paths the tree now holds
(settled 30/09/2026, 16-sprint-plans grilling round 6 Q17). One successor per superseded record
keeps one decision, one **Supersedes** filename and one driving story to each ADR
(settled 30/09/2026, 16-sprint-plans grilling round 7 Q18).

**The decision this record carries, in full — the superseded record's Option C.** Check 2 of
`code/src/scripts/audits/doc-references.sh` exempts a citer from the instance-citation ban when
the **citing file's own filename** matches the instance forms — `US###`, `SPRINT-##`, `ADR-US###`,
`QA-PLAN-US###`, `STORY-PLAN-US###`, `SPRINT-PLAN-##`, `REVIEW-US###`, `BUG-*` — with the `US000`
and `*TEMPLATE*` forms excluded. It does not key the exemption on `is_template_only()`, and it does
not key it on a `project-management/src/*` path glob. It reuses the alternation Check 2 already
maintains for the cited side, so there is one list to keep current.

The deciding factor is that the question Check 2 needs answered is not _"does copier exclude this
file"_ but _"is this file a per-project instance"_ — and the second is answerable from the filename
alone, in both trees, without reading a file that does not travel. `is_template_only()` answers a
proxy question correctly here and not at all downstream: `copier.yml` excludes itself, so in every
generated project the set it derives is empty and the exemption silently never applies. A
`project-management/src/*` glob answers the right question with the wrong instrument, and its cost
was measured at twenty shipped files on 02/09/2026: `copier.yml:160-188` re-includes the `CONTEXT.md` and
`CLAUDE.md` pairs, every `*TEMPLATE*`, and a named allowlist the superseded record counted at
roughly twenty further files — the `00-ASSETS/scripts/*.sh` tooling,
`06-BRAND-GUIDE/guide-build/*`, `07-COMPONENTS/component-build/*`,
`08-WIREFRAMES/SHARED/wireframe.css`, six `09-GDPR/*.md` registers,
`18-TESTS/{MANUAL,AUTOMATED}/US000-*`, `23-INCIDENTS/INCIDENT-INDEX.md` and the `WALK-TESTS/` pair.
A glob would exempt every one of them, blinding the gate on shipped files.

The `US000` and `*TEMPLATE*` exclusions are not decoration: they are the allowlist's only
instance-shaped entries, and without them the test would exempt the very templates the gate must
keep policing.

## Consequences

- **What changes — the paths, and only the paths.** The allowlist entry `18-TESTS/US000-*` reads
  `18-TESTS/{MANUAL,AUTOMATED}/US000-*`; the fixture Follow-on names
  `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md` where the superseded record gave
  the bare filename; the copier anchor reads `copier.yml:160-188` for `copier.yml:120-146`.
- **What does not change:** the filename test, its instance forms, its two exclusions, the
  rejection of `is_template_only()` and of the path glob, the "roughly twenty" count as the
  superseded record gave it, and every consequence below other than a path. They are restated so
  this record can be applied without reading the one it supersedes.
- **Positive:** the exemption behaves identically in `syntek-base` and in a generated project. The
  gate stops giving a different answer on the two sides of the copier seam for a reason no reader
  could see.
- **Positive:** the twenty-file allowlist becomes irrelevant to this clause rather than a list to
  mirror, so `copier.yml:160-188` growing a row costs this script nothing.
- **Negative / trade-off:** two predicates in one script now answer "does this ship". The boundary
  must be stated in the script's header and held: `is_template_only()` answers **what a citation
  points at**; the instance test answers **whether the citer is an instance**. A future reader who
  conflates them will reintroduce the `is_template_only()` keying this decision rejects.
- **Negative / trade-off:** the alternation is a hand-maintained list. A new per-story artefact
  class loses its exemption silently until added — the same maintenance burden the cited side
  already carries, now doubled in consequence rather than in length.
- **Follow-on:** the fixture pair added by US004 must cover
  `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md` — instance-shaped, shipped, and
  therefore **not** exempt — because that is the case the two exclusions exist for.
- **Follow-on:** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
  **retires by its own terms when US004 lands.** It is not superseded — its reasoning was correct
  and its stated condition is simply met — but a reader of that record would otherwise have no way
  to discover it had lapsed. Recorded here rather than by a status change. _Carried forward
  unchanged. "Not superseded" means not superseded by US004's landing: on 30/09/2026 that record
  was superseded for the same 18-TESTS split by
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  which restates its decision unchanged, so the retirement attaches to that decision wherever it
  is recorded._
- **Follow-on:** the wider question of a gate meaning the same thing downstream is
  `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md`'s. This record is one instance of it
  and claims none of its scope.
- **Follow-on:** US004's implementation reads this record, not the superseded one, for Check 2's
  citer exemption.
