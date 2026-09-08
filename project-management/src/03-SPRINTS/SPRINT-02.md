# SPRINT-02

**Last Updated**: 08/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** The audits register regains the headroom nine new gates need, and the absence guide is
born behind it.

<!-- The goal read "The citation gate stops depending on the git index." from 05/09/2026 until
     07/09/2026, when US004 moved to SPRINT-03 and US002 and US003 arrived on the US007 re-plan
     the Notes record. A goal naming a deliverable no member carries is the drift the Story
     Summary exists to prevent, so it is rewritten from the two members' own titles and Client
     Summaries. The closing clause is deliberately the one this record cut on 05/09/2026 — see the
     comment below — because the deliverable it names is back. -->

<!-- The goal read "…and the absence guide is born behind it" until 05/09/2026, when US003 moved
     to SPRINT-03. A goal naming a deliverable no member carries is the drift the Story Summary
     exists to prevent. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **3 SP Must + 5 SP Should = 8 / 11 SP** — inside capacity, and
**CLOSED**. See Notes.

<!-- Read "**8 / 11 SP** — inside capacity, and closed" from 05/09/2026 until 07/09/2026. The
     figure is unchanged and the members are not: US004's 8 left for SPRINT-03, and US002's 3 plus
     US003's 5 arrived. An unchanged figure and an unrecomputed one are indistinguishable in the
     result, so the recomputation is recorded here — 3 + 5 = 8 — and the tier split is new: this
     record has a stretch tier again, which it did not on 05/09/2026. -->

<!-- Was "8 SP Must + 5 SP Should = 13 / 11 SP — at grace" until 05/09/2026, when US003 moved to
     SPRINT-03. This sprint no longer needs grace; the reasoning that admitted it is kept in the
     Notes rather than deleted, because it is the record of a decision that was taken. -->

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Recomputed 07/09/2026 on the re-plan — US004 DEPARTED to SPRINT-03, US002 ARRIVED from
     SPRINT-01, US003 RETURNED from SPRINT-03 — and CHANGED in one row. The QA value loses its
     unit type, because "gate self-test, fixture pair" entered this union with US004 alone and a
     union narrows only when a member leaves; it regains routing-skills and skill-conformance,
     which left with US003 on 05/09/2026 and return with it; and it gains docs-pairing, which
     US002 alone names. The result is the union of US002.md's and US003.md's own FLAGS tables and
     nothing more — six manual gates and no automated type. Twelve rows stay N/A because both
     members ship documentation only: one register shrunk, one guide born, four skills and a
     README edited; no model, no endpoint, no screen, no personal-data path, no log line, no
     public page.
     SPELLING, so it is not read as drift: US002's flag writes the script names with .sh and
     US003's without. The union writes all six with .sh, following the precedent SPRINT-03's
     FLAGS comment set for the same two spellings in its 05/09/2026 entry (kept there as
     history), and reversing this record's own 05/09/2026 choice to omit
     the suffix — that choice matched US004's flag, and US004 is no longer here. The full paths
     are in the Verification Checks, and neither story's own flag is rewritten to match the other.
     US002's "(scoped)" qualifier on doc-references.sh and US003's baseline-diff reading of the
     same gate are one regime — ADR-US003-CITATION-GATE-BASELINE-DIFF — stated once in the
     Verification Checks rather than carried into the cell.
     DE-NUMBERED 08/09/2026: the union sentence read "the union of US002.md:54 and US003.md:29 and
     nothing more" until that day. On 08/09/2026 :54 is still the QA row of US002's FLAGS table
     and :29 the QA row of US003's, so both resolved; the sentence now names the tables because a
     line number into a story file moves with every edit above it and a table name does not.
     HISTORY, kept because a recomputation nobody ran and one that changed nothing are
     indistinguishable in the result:
     Computed 02/09/2026 on US003's admission.
     Recomputed 05/09/2026 on US003's DEPARTURE to SPRINT-03 and CHANGED in one row: the QA
     value narrows, because routing-skills and skill-conformance entered this union with US003
     alone. A union narrows only when a member leaves, which is exactly this case and not the
     Part A / Part B narrowing SPRINTS.md permits — the story did not split, it moved.
     AMENDED 05/09/2026, same day: the surviving three documentation gates were briefly carried
     here on the grounds that US004 "still runs" them, which is an independently-authored value
     the union rule forbids. US004's own flag was widened instead to name the three gates its
     Verification Checks actually run — the manifest-may-be-added-to route CADENCE.md provides —
     so this row is once again the union of its members and nothing more.
     Recomputed 02/09/2026 on US004's admission and CHANGED in one row. Twelve rows stay N/A
     because both stories ship documentation and one bash script between them: no model, no
     endpoint, no screen, no personal-data path, no log line, no public page. The QA row is the
     union of two different test types — US003's five-gate manual value and US004's unit value,
     which is the sprint's first automated one. Per SPRINTS.md the union is never narrowed, so
     both halves are carried in full and the automated QA sections below are no longer removed.
     Script names are written without the .sh suffix here to match the stories' own flags; the
     full paths are in the Verification Checks. -->

| Flag       | Value                                                                                                                               |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                 |
| User Flow  | N/A                                                                                                                                 |
| Brand      | N/A                                                                                                                                 |
| Components | N/A                                                                                                                                 |
| Wireframes | N/A                                                                                                                                 |
| GDPR       | N/A                                                                                                                                 |
| Security   | N/A                                                                                                                                 |
| QA         | manual — `docs-length.sh`, `docs-pairing.sh`, `doc-references.sh`, `doctrine-drift.sh`, `routing-skills.sh`, `skill-conformance.sh` |
| SEO        | N/A                                                                                                                                 |
| API        | N/A                                                                                                                                 |
| Logging    | N/A                                                                                                                                 |
| Backend    | N/A                                                                                                                                 |
| Frontend   | N/A                                                                                                                                 |

---

## Story Summary

| ID    | Title                                                                        | MoSCoW      | SP  |
| ----- | ---------------------------------------------------------------------------- | ----------- | --- |
| US002 | The audits register regains the headroom nine new gates need                 | Must Have   | 3   |
| US003 | Absence gets an owning guide, born under 270 with every clause's tier stated | Should Have | 5   |

**Total:** 8 SP — **3 committed, 5 stretch**

<!-- US004 (Must Have, 8 SP) was here from 02/09/2026 until 07/09/2026 and is now in
     project-management/src/03-SPRINTS/SPRINT-03.md. Removed from this table rather than struck
     through, for the reason the comment below gives. The move and its reasoning are in the
     Notes. -->

<!-- US003 (Should Have, 5 SP) was here until 05/09/2026 and is now in
     project-management/src/03-SPRINTS/SPRINT-03.md. Removed from this table rather than struck
     through, because SPRINTS.md computes this sprint's flag union and capacity FROM this table
     and a story in two Story Summaries is counted twice. The move and its reasoning are in the
     Notes.
     07/09/2026: US003 is back in the table above, returned from SPRINT-03 on the re-plan the
     Notes record. This comment is kept because the first move happened; the row above is the
     live fact. -->

## Dependencies

- **Neither member's own story file names an upstream dependency, and neither depends on the
  other.** Both are wave 0 of their maps' cutting orders. `project-management/src/02-STORIES/US003.md`
  names US002 as parallel work that "neither blocks", and they share no file — US002 edits the
  `code/src/scripts/audits/` pair and creates `slop-family/` beneath it; US003 creates
  `code/docs/ABSENCE.md` and edits four `SKILL.md` files, `README.md`, three index surfaces and
  the drift table. **The build order US002 then US003 is therefore set by tier, not by
  dependency**: the committed `Must` is worked first and the stretch `Should` second, so an
  overrun costs the stretch and never the commitment.
- **US002 gains one upstream constraint on this re-plan, and it is cross-sprint: US007, in
  SPRINT-01, ships first.** `project-management/src/02-STORIES/US007.md` Dependencies: US002
  unblocks `MAP-REGISTER-INDEXES.md` slice `S-03`, which builds `register-indexes.sh` and its
  `broken/` + `clean/` status fixtures, and those fixtures are built against whichever
  `**Status:**` vocabulary is canonical when they are written — so the vocabulary is settled
  before the line of work that will string-compare it opens. This is the constraint the whole
  cascade of 07/09/2026 exists to honour, and it is why US002 is here rather than in SPRINT-01.
  **`project-management/src/02-STORIES/US002.md`'s own Dependencies still read "No upstream
  dependencies"** (re-read 08/09/2026) —
  true of its content, and now false of its ordering. The story-file edit is owed by
  `02-story-creation` and is not made here.
- **The US004-before-US003 ordering settled on 02/09/2026 is REVERSED by this re-plan, and the
  reversal is recorded rather than left to be discovered.** US003 is worked here, in SPRINT-02;
  US004 is worked in SPRINT-03. `project-management/src/02-STORIES/US004.md` Dependencies name the
  collision and admit either order — "if US003 lands first, the three `code/docs/ABSENCE.md`
  forward references resolve on their own. Whichever lands second reads the other's disposition
  rather than re-deriving it." US003 was only ever blocked in ordering, not in content: its
  baseline-diff scenario is written for exactly the regime it will now be worked under. Two
  consequences follow and both are stated in this record. The **revision pass** of 05/09/2026 —
  recast the scenario as a plain pass once US004 has landed — is inapplicable while US003 is
  worked here, and revives only if US003 slips into SPRINT-03 and is worked after US004 there.
  And **US004, landing second, reads US003's disposition**: the three `code/docs/ABSENCE.md`
  survivors its Verification Checks name at cutting will have cleared before it is worked.
- **One dependency runs SPRINT-02 → SPRINT-03 and is concrete.** US002 shrinks
  `code/src/scripts/audits/CONTEXT.md` from 298 to 230 counted lines, and US004 must edit a row
  in that file against a 300-line hard limit — recorded as `AC-GAP-9` of
  `project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`. The sprint
  plan of 05/09/2026 argued this as "SPRINT-01 before SPRINT-02"; it is now "SPRINT-02 before
  SPRINT-03" — the same direction, one sprint later on each side — and it agrees with the build
  order rather than fighting it.
- **Both members read `doc-references.sh` as a diff against a recorded baseline, never as a
  pass**, per `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
  because the gate's own repair — US004 — now lands **after** this sprint. Every survivor US004's
  Verification Checks name at cutting belongs to a member of this sprint: the three
  `code/docs/ABSENCE.md` forward references are US003's and clear when the guide lands; the three
  `code/src/scripts/audits/SLOP-FAMILY.md` citations are US002's
  (`project-management/src/02-STORIES/US004.md` -> Acceptance Criteria, the scenario _The classes
  this story owns are cleared, and the baseline regime retires_) and are US002's to disposition
  when it ships.
- **US003's carry is reserved into SPRINT-03.** The Definition of Done below provides that the
  `Should Have` member is `Completed` here or explicitly carried there. If it carries, it lands
  beside US004 — and the intra-sprint order there is US004 then US003, the original order of
  02/09/2026, which is what revives the revision pass named above.
  `project-management/src/03-SPRINTS/SPRINT-03.md` carries the reservation from its side. **US003
  the story is not split** — this is a scheduling reservation, not a Part A / Part B, and no new
  story number exists for it.
- **US002 unblocks nine audit registrations across eight slices and seven maps** — every story
  that adds a script under `code/src/scripts/audits/` needs three counted lines in a register
  with two lines of headroom. Its full table is in `project-management/src/02-STORIES/US002.md`.
- **US003 unblocks five slices** on `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` —
  `S-02` (the Python `None` clause), `S-03` (the HTMX contract), `S-04` (the optional-surface
  remainders), `S-05` (tiers and the mechanical legs) and `S-06` (consumer wiring). Every one
  cites the guide US003 creates, and three of them inherit its crib back-link obligation.
- **None of those downstream slices is yet cut into a story**, so none could be admitted here even
  if this record were open — and per the Notes it is not.
- **Neither member depends on SPRINT-01's US001, and neither blocks a SPRINT-04 member.** US006
  names `code/src/scripts/audits/CONTEXT.md` as a file it does not write because US002 owns its
  headroom (`project-management/src/03-SPRINTS/SPRINT-04.md` Dependencies) — a non-collision, not
  a dependency.

<!-- The doc-references bullet above cited "the three code/src/scripts/audits/SLOP-FAMILY.md
     citations are US002's (US004.md:294-295)" until 08/09/2026 — quoted here without its
     backticks, so the citation gate does not read a forward reference twice. Those lines had
     already drifted: on 08/09/2026 :294-295 are the untracked-file probe clauses of the scenario
     _Both proof modes are used, and each repair is proved in the one that can reach it_, and the
     hand-off of the three SLOP-FAMILY.md citations to US002 sits in the next scenario, _The
     classes this story owns are cleared, and the baseline regime retires_ — which the bullet now
     names. A section name survives an edit above it; a line number does not. -->

<!-- The Dependencies replaced on 07/09/2026 read, in full:
     "- **US004 has no upstream dependency.** It is cut from
     project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md slice S-06, whose map has an
     empty frontier and whose Gate to stories records 02-story-creation as unblocked.
     - **US004 must still be built before US003, and US003 now sits in the next sprint** (settled
     at 03-sprint-planning 02/09/2026, and unchanged by the move on 05/09/2026). US003's
     acceptance reads doc-references.sh as a diff against a recorded baseline, and US004 removes
     the defect that baseline exists for. Building US004 first means US003 is worked against a
     gate that simply passes, and the regime
     project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md
     imposes is never exercised. **The ordering is therefore now cross-sprint**, and is restated
     in project-management/src/03-SPRINTS/SPRINT-03.md Dependencies rather than left only here —
     a constraint recorded only in the sprint a story has left is a constraint nobody reads.
     - **US003's revision pass travelled with the story on 05/09/2026.** Three parts of it are
     written against a defect US004 removes: the Gherkin scenario "The citation gate is read
     against a recorded baseline, never as a bare pass", the QA task recording before/after
     finding counts, and the ADR above. This record said that if US003 left unworked the flag
     would go to GAPS.md. **It went to SPRINT-03 instead**, into that record's Dependencies and
     its QA Tasks. The condition was "left unworked" and the purpose was that the obligation not
     be lost; it is stated in the record whoever picks US003 up will actually read, which
     GAPS.md — owned by 22-implementation-documentation for writes and closes — would not have
     been. If US003 leaves SPRINT-03 unworked as well, the register entry becomes the right home.
     - **US004 unblocks** slice S-01 on project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md,
     which changes the same script's citation emit and must not land first.
     - **US004 depends on no SPRINT-01 member and blocks none."
     Every US004 fact travelled with the story to SPRINT-03; the US004-before-US003 ordering is
     reversed above, with its reasoning; the revision-pass obligation is restated above in its
     new conditional form and has come back with US003 rather than staying in SPRINT-03. -->

## Notes

**Re-planned 07/09/2026, before any sprint was worked.** US007 — the story status vocabulary gets
one owner — was cut that day at 5 SP `Must Have`, and it has to ship before US002 (Dependencies).
<%DEVELOPER_NAME%> settled the shape as a full cascade across all four records rather than an
execution reorder: US007 enters SPRINT-01 and US002 leaves it for this record; US004 leaves this
record for SPRINT-03 and US003 returns from SPRINT-03 to this one; US005 leaves SPRINT-03 for
SPRINT-04. **In this record: US004 (`Must`, 8) departed, US002 (`Must`, 3) and US003 (`Should`, 5)
arrived, and the capacity figure is 8 / 11 as it was — by arithmetic coincidence, not by
inaction.** The four records after the cascade:

| Sprint      | Members, in build order                        | SP                                  |
| ----------- | ---------------------------------------------- | ----------------------------------- |
| `SPRINT-01` | US007 then US001                               | 10 / 11                             |
| `SPRINT-02` | US002 then US003 — **this record**             | 8 / 11, US003 the stretch           |
| `SPRINT-03` | US004, plus US003's reserved carry if it slips | 8 / 11, or 13 / 11 with the carry   |
| `SPRINT-04` | US005 then US006                               | 13 / 11 — grace, taken deliberately |

**It is a re-plan, not a carry-over** — the distinction
`project-management/src/03-SPRINTS/SPRINT-03.md` drew on 05/09/2026 for US003's first move, and
the precedent this one follows. Every sprint is `Planned` and unworked, so no story leaves with a
failure attached and none arrives carrying one; every story's `**Status:**` stays `Open`, and only
membership moves. What a move costs is the six-artefact discipline the 05/09/2026 move set — the
departing record, the receiving record, the story plan's `| Sprint |` row, the story file's own
move note, and both sprint plans. This record is one of the six for three stories; the others
are named at the end of these Notes.

**US003 is back, and the first move is not pretended away.** It was this sprint's `Should`
stretch from 02/09/2026, left for SPRINT-03 on 05/09/2026 to give a single-member all-`Must`
sprint some give, and returns on 07/09/2026 because SPRINT-03 now holds US004 alone and its give
is the reserved carry rather than a second member. **Its demotion to `Should Have` on 02/09/2026
stands, and for the same reason:** this sprint still needs a member that can slip without the
sprint failing, nothing inside it depends on US003, and the five slices US003 blocks are not yet
cut. The `Must` tier is now US002's 3 SP rather than US004's 8, which makes the stretch a larger
share of the sprint than before — 5 of 8 rather than 5 of 13 — and that is the correct shape for
a sprint whose committed work is small and whose stretch has somewhere reserved to go.

**The 3 SP of headroom is still not an invitation — and US002 and US003 are not what it warned
against.** The paragraph this replaces argued that filling this sprint's headroom with an
unrelated story would be the padding `project-management/docs/planning/CADENCE.md` tells a record
to call out. That argument stands, and it stands for the new members too: US002's natural
successors are the nine registering slices and US003's are the five absence slices, none of them
cut, so any story that could fill 3 SP here today would be unrelated to both. **But US002 and
US003 did not arrive to fill headroom.** They arrived because US007 has to precede US002 and the
developer chose a cascade over a reorder; the headroom is what the cascade left, not what it was
aimed at. A dependency re-plan that lands at 8 is the case `CADENCE.md` names as correct — "a
sprint that lands on 10 SP because the next story is a 5 is a correct sprint, not an under-filled
one" — and padding is admitting a story to move the figure. Nothing here was.

<!-- The paragraph replaced here read: "**This sprint stays CLOSED**, now by decision rather than
     by ceiling. Its 3 SP of headroom is not an invitation: US004's own unblocking chain runs into
     MAP-NAVIGATION slice S-01, which is not cut, and admitting an unrelated story to fill 3 SP is
     the padding project-management/docs/planning/CADENCE.md tells this record to call out
     instead." True from 05/09/2026 until 07/09/2026; US004 and its chain are now SPRINT-03's, and
     the argument is re-made above for the members that replaced it. -->

**This sprint is CLOSED at two members and 8 of 11 SP, by decision** (07/09/2026, carrying
forward the closure of 05/09/2026). Capacity is a trigger and not a target
(`project-management/docs/planning/CADENCE.md`, _Sprint capacity — the trigger_); `SPRINT-01.md`
carries the precedent for closing a ledger by call, and `SPRINT-03.md` did until 07/09/2026 and
keeps that closure as history; and nothing that clears `15-decisions` next is admitted here
regardless.

**Grace is no longer this record's story; it is SPRINT-04's, and it is a different shape.** The
history block below records this sprint taking grace at 13 / 11 on 02/09/2026 as **8 `Must` +
5 `Should`** — "grace covers the ceiling, not the commitment".
`project-management/src/03-SPRINTS/SPRINT-04.md` takes grace on 07/09/2026 at 13 / 11 as
**US005 (5) + US006 (8), both `Must`** — the one case `CADENCE.md` reserves grace for, chosen by
<%DEVELOPER_NAME%> over a `SPRINT-05` holding US006 alone, and that record is closed to further
admission. There the grace covers the commitment. A reader should not carry this record's
"ceiling, not commitment" reading across to SPRINT-04: the two records took grace for different
reasons and each says which. SPRINT-04's contingency of 05/09/2026 — that US003's carry might land
there — is retired by this re-plan; the carry now targets SPRINT-03.

**What this move cost elsewhere was paid the same day, bar one story-file note.** On the
discipline of 05/09/2026: `project-management/src/16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` took the
mirroring edit on 07/09/2026 — its capacity line reads `3 SP Must + 5 SP Should = 8 / 11 ·
Stories: 2`, its `Stories` section carries US002 under _Must_ and US003 under _Should_, and its
goal is this record's verbatim. The three story plans were repointed the same day:
`project-management/src/17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`'s
`| Sprint |` row reads "SPRINT-02 · Wave 0 · build order 1",
`project-management/src/17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md`'s reads
"SPRINT-02 · Wave 0 · build order 2", and
`project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`'s reads
"SPRINT-03 · Wave 1 · build order 1". `project-management/src/02-STORIES/US003.md` -> _MoSCoW
Priority_, in the comment beneath the tier, carries its return note — "MOVED BACK TO SPRINT-02,
07/09/2026" — beneath the 05/09/2026 "MOVED TO SPRINT-03" one; the FLAGS comment at the head of
that file carries neither. Still open as read on 08/09/2026: `project-management/src/02-STORIES/US002.md`'s
Dependencies do not yet name the US007 ordering, which is `02-story-creation`'s edit (see
Dependencies above). Named so it is not lost.

<!-- The paragraph above read, until 08/09/2026: "**What this move costs elsewhere, and is not
     made here.** On the discipline of 05/09/2026: `02-SPRINT-PLAN-02.md` is written for US004
     alone at 8 / 11 and no longer describes this sprint — rewriting it against the settled set
     {US002, US003} is a `16-sprint-plans` run. 'STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md'
     line 7 reads `SPRINT-01`, 'STORY-PLAN-US003-ABSENCE-GUIDE.md' line 7 reads `SPRINT-03`, and
     'STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md' line 7 reads `SPRINT-02`; all three are owed a
     repoint by `17-story-plans`. `US003.md`'s FLAGS comment carries a "MOVED TO SPRINT-03" note
     that is owed a return note, and `US002.md` is owed the US007 ordering (Dependencies). None
     of those is this record's to write; each is named so it is not lost." Written in the
     parallel pass of 07/09/2026 while the plan, the three story plans and US003.md were taking
     those very edits; each was re-read on 08/09/2026 and carries its corrected value, as the
     paragraph above quotes it — the three `| Sprint |` rows read "SPRINT-02 · Wave 0 · build
     order 1", "SPRINT-02 · Wave 0 · build order 2" and "SPRINT-03 · Wave 1 · build order 1",
     not the line-7 values quoted here. Only the US002.md debt was still open. Two corrections
     to this record's own 08/09/2026 wording, made later the same day: this sentence said each
     "carries the value quoted above", which pointed the reader at the stale values; and the
     paragraph named US003.md's "FLAGS comment" as the return note's home, when the move notes
     sit in the comment under that story's _MoSCoW Priority_ heading. -->

<!-- 08/09/2026 — STORY-PLAN FILENAMES GAINED AN `<exec-order>-` PREFIX, and the three citations
     in the paragraph above were repointed the same day. The form is
     `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, the prefix 2-digit zero-padded,
     `00-` the template. The prefix is the story's position in the settled build order ACROSS THE
     WHOLE BACKLOG — not its sprint, and not a per-sprint counter — so this record's two members
     read `03-` (US002) and `04-` (US003) while both sit in SPRINT-02, and US004's plan reads
     `05-` from SPRINT-03. It is RENUMBERED whenever build order changes.

     The prefix is NOT this record's sprint number and carries no membership: nothing about who is
     in this sprint can be read off it. That is also the OPPOSITE of the sibling rule in
     ../16-SPRINT-PLANS/CLAUDE.md — a sprint plan carries TWO numbers,
     `<exec-order>-SPRINT-PLAN-<sprint-number>`, and the PAIR carries the meaning, so a mismatch
     between them is deliberate and must never be "corrected". A story plan carries ONE, so its
     prefix must track build order or it says nothing. Do not read that guardrail across.

     Dated comments in this file quote the pre-rename names, because that is what they named at
     the time. No membership, capacity, status or build order changed with the rename. -->

**Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) run for this sprint once
every member has cleared `15-decisions`.** Both have: each member's ADRs are listed in its
story's Decisions section, and neither QA plan carries an `[OPEN]` gap — US002's eleven and
US003's seven are all `[RESOLVED]`. The story plans exist for both and were repointed on
07/09/2026; the sprint plan mirrors this record as of the same day, so nothing on disk describes
a member that has left. That mirroring edit is the sprint-plan half of the six-artefact
discipline, not a fresh `16-sprint-plans` pass with its own grilling; whether one is wanted on
top is that workflow's call, and with both members through `15` nothing blocks it.

<!-- The paragraph above ended, until 08/09/2026: "The story plans exist for both and need only
     the repoint above; the sprint plan needs the rewrite above. Until they are done, the plan on
     disk describes a member that has left, and a reader should trust this record over it." The
     repoint and the rewrite had both landed on 07/09/2026, in the same parallel pass that wrote
     the sentence, so the instruction to trust this record over the plan pointed a reader away
     from a correct file. Deleted rather than softened. -->

<!-- This paragraph read, from 05/09/2026: "Both are written:
     project-management/src/16-SPRINT-PLANS/02-SPRINT-PLAN-02.md, now at 8 / 11 with US004 alone,
     and project-management/src/17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md." True
     until 07/09/2026, when US004 left; both files still exist and both now describe SPRINT-03's
     member. -->

<!-- This paragraph read "US004 — now the only member — has cleared 02-story-creation and
     03-sprint-planning only; the rest of its per-story loop is still to run, so neither plan can
     be written yet" until 05/09/2026. Both plans were on disk when it was written, and
     02-SPRINT-PLAN-02.md was edited the same day for US003's departure. Corrected rather than
     deleted, because the claim is the kind a later reader would otherwise trust. -->

---

**History, from 05/09/2026 — superseded by the re-plan above.**

<!-- The paragraph below was the live Notes opening from 05/09/2026 until 07/09/2026. Its
     arithmetic was true when written — SPRINT-02 at 8 / 11 with US004 alone, SPRINT-03 at
     10 / 11 with US005 and US003 — and is true of neither record now. Kept verbatim as the record
     of the first move; the return is recorded above. -->

**US003 moved to `project-management/src/03-SPRINTS/SPRINT-03.md` on 05/09/2026, before this
sprint was worked, and this record is now a single-member sprint at 8 / 11 SP.** The three
paragraphs below argue why grace was taken to admit it; they are kept because they record a
decision that was actually taken, not because they still describe this sprint. **Read them as
history.** What replaces them is simpler: SPRINT-03 opened with US005 alone as a 5 SP all-`Must`
sprint, which `project-management/docs/planning/SPRINTS.md` warns has no give, and it had no
candidate for a `Should` tier that was not blocked on its own member. US003 is that give, it was
never worked here, and moving it puts **both** sprints inside capacity — this one at 8 / 11 and
SPRINT-03 at 10 / 11 — where before one was at grace and the other had no stretch at all. The
ordering constraint and the revision pass travelled with it; see Dependencies.

---

**History, from 02/09/2026 — superseded by the move above.**

**This sprint admits 13 SP against a capacity of 11 and commits to 8 of them.**
`project-management/docs/planning/CADENCE.md` reserves grace for one situation — the next story
overshoots and splitting it would produce two halves that make no sense alone. US004 meets that
on the record: `02-story-creation` settled (Q12, 02/09/2026) that splitting it means two stories
editing `code/src/scripts/audits/doc-references.sh` and two runs of the same before/after
measurement. **SPRINT-01 declined grace for the opposite reason** — US003 had no split problem
and that sprint did not have to have it — so this is not the routine allowance CADENCE warns
about.

**What grace covers here changed at `16-sprint-plans`, and the shift is recorded rather than
quietly dropped.** US003 was demoted to `Should Have` because
`project-management/docs/planning/SPRINTS.md` is explicit that an all-Must plan has no give and
"the first surprise breaks it". So **grace now covers the ceiling, not the commitment**: the Must
tier is 8 SP, inside capacity, and the 5 SP above it is stretch that slips to SPRINT-03 without
the sprint failing. The 13 SP is still admitted work and the sprint is still closed at two
members.

**The alternative was leaving SPRINT-02 at 5 and opening SPRINT-03, and it was declined on a
measured fact:** this sprint's 6 SP of headroom is otherwise unfillable. Its natural next
members are the five absence slices above, and every one of them blocks on US003 — this
sprint's own member — shipping first. US004 depends on nothing, which makes it the only story
that can occupy that room.

**The goal names two subjects because the sprint has two**, and it is written in execution
order rather than pretending they share one. US004 is a different epic on a different map; it is
here on capacity and independence, not on theme.

**This sprint is CLOSED at two members.** It stands past capacity, so nothing further is
admitted regardless of what clears `15-decisions` next.

---

## Acceptance Criteria

Two independent outcomes, one per member, and the six documentation gates run against both —
each read the way its own story says it is read, and never reported as a bare pass where a
baseline stands.

**US002** — `code/src/scripts/audits/CONTEXT.md` reaches a target of 230 counted lines — 270 is
the gate, 230 the target — with every register it owns intact and complete, the four missing
Dependencies rows added so that "complete" is decidable, the lines paid for by deleting
restatements of rules owned elsewhere rather than by deleting facts, the AI-slop rationale
relocated whole rather than summarised, and the headroom proved by dry-running the 27 rows nine
future registrations will cost.

**US003** — `code/docs/ABSENCE.md` exists as the single owner of what an absence means — six kinds
and a five-surface runtime crib — born inside the length ratchet, registered on every surface it
owes, with each clause carrying an honest enforcement tier and every rule another guide already
owns cited rather than restated.

<!-- US004's outcome — "code/src/scripts/audits/doc-references.sh gives the same verdict on the
     same citation whether or not its file is committed, polices the nine shipped files copier
     lifts out of the exempt trees, checks the project-management/src/ tree without firing on
     naming conventions, and exits 0 on a clean tree" — moved with the story to
     project-management/src/03-SPRINTS/SPRINT-03.md on 07/09/2026. The opening line "One outcome,
     one member." went with it. -->

<!-- US003's outcome moved with the story to project-management/src/03-SPRINTS/SPRINT-03.md
     on 05/09/2026 — and returned with it on 07/09/2026; the paragraph above is the live one. -->

### QA Acceptance Criteria — Manual

<!-- The automated QA sections are removed since 07/09/2026: this sprint's QA flag names a manual
     type and no automated one, matching both members, which ship documentation and no code path
     between them. The unit type — the gate self-test and its fixture pair — entered this record
     with US004 on 02/09/2026 and left with it. Per code/docs/GATE-REPORTING.md the skip is
     recorded here rather than left to be inferred, and the section it replaces is quoted below
     rather than deleted. -->

<!-- The section replaced here read, under "QA Acceptance Criteria — Automated" (introduced
     "New at US004's admission: this sprint's QA union names a unit type. Since US003's move on
     05/09/2026, US004 is the only contributor to every row below."):
     "bash code/src/scripts/audits/doc-references.sh --self-test exits 0, its probe count risen
     by one case per repair US004 makes · Every fixture case US004 adds fails against the
     pre-change script and passes against the post-change one — a fixture that passes both proves
     nothing · No existing probe is weakened to accommodate a change; any moved expected count
     carries its justification in the probe's own comment · Coverage floors — N/A, neither story
     ships a Python path; US004's proof is the script's own --self-test."
     All of it was US004's, and it travelled to SPRINT-03 on 07/09/2026. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US002-MANUAL-TESTING.md` and
      `project-management/src/18-TESTS/US003-MANUAL-TESTING.md` each carry a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in either member's QA plan —
      `project-management/src/11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` (eleven
      `AC-GAP` entries, all `[RESOLVED]`) or
      `project-management/src/11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` (seven, all
      `[RESOLVED]`)

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### QA Tasks — Manual

- [ ] US002 — the counted-line baseline, the full register inventory and the `doc-references.sh`
      finding set — by identity, not count — are recorded in
      `project-management/src/18-TESTS/US002-MANUAL-TESTING.md` **before** any line is cut
- [ ] US002 — the three documentation gates named in its own flag run, and their output recorded
      in the same file, `doc-references.sh` read against that recorded baseline rather than
      against exit 0
- [ ] US002 — a human read-across of the shrunk file against each guide it routes to; every route
      lands on a section that actually states the rule
- [ ] US002 — the before/after register inventory balances: every cut line accounted for as
      restatement removed, content relocated, or fact deliberately deleted with a reason, with the
      deletion share and the relocation share recorded separately
- [ ] US002 — the eight section and line-anchor citations no gate can check are re-resolved by
      hand and repointed where their target moved
- [ ] US002 — the nine future registrations are dry-run into the shrunk file as **27** rows, and
      the resulting figure recorded
- [ ] US002 — a tester other than the author has signed the walk-through off
- [ ] US003 — the five documentation gates named in its own flag run, and their output recorded
      in `project-management/src/18-TESTS/US003-MANUAL-TESTING.md`
- [ ] US003 — **the `doc-references.sh` baseline is captured before any file is edited, and the
      baseline-diff scenario stands as written.** This re-plan (07/09/2026) works US003 ahead of
      US004, so the regime its scenario was written for is the one it is worked under. The
      revision pass recorded on 05/09/2026 — recast the scenario, the before/after QA task and
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
      as a plain pass once US004 has landed — applies **only** if US003 slips to SPRINT-03 and is
      worked after US004 there, and then travels with the carry
- [ ] US003 — the before/after `doc-references.sh` finding counts are recorded and the delta from
      US003's own shipped files is zero, the three forward references to `code/docs/ABSENCE.md`
      resolving the moment the guide lands
- [ ] US003 — a human read-across of the new guide against the six
      `code/docs/data-structures/TYPES-*.md` files; no rule stated in two homes
- [ ] US003 — the Codd primary source is checked before its attribution row is written, to confirm
      derivation rather than convergence
- [ ] US003 — a developer who opens the guide cold can name which of the six kinds a given
      `return None` means, without opening a second file
- [ ] US003 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

<!-- US004's QA tasks — automated: the self-test run recorded in US004-TEST-STATUS.md, and each
     new fixture case run against both the pre- and post-change script with both results
     recorded; manual: the whole-tree run recorded before and after with both finding counts and
     both exit codes, the tracked-versus-untracked A/B reproduced before any edit and again after
     with the git index restored each time, every finding the widened gate exposes classified in
     writing as genuine, generic-noun false positive, or another story's, and a tester other than
     the author signing off — moved with the story to
     project-management/src/03-SPRINTS/SPRINT-03.md on 07/09/2026. -->

<!-- US003's five manual checks moved with the story to
     project-management/src/03-SPRINTS/SPRINT-03.md on 05/09/2026 — and returned with it on
     07/09/2026, above. -->

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships
     documentation only, and per code/docs/GATE-REPORTING.md a skip is never reported as a pass. -->

- [ ] `bash code/src/scripts/audits/doc-references.sh` — **read as a diff, not as a pass**, per
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
      because the gate's own repair — US004 — is in SPRINT-03 and lands after this sprint. Each
      member captures its baseline by identity before its first edit and records it in its own
      `project-management/src/18-TESTS/US###-MANUAL-TESTING.md`; no shipped file either member
      writes or edits adds an unresolved citation of any class; every survivor is named with the
      story that owns it. The three `code/docs/ABSENCE.md` forward references clear when US003's
      guide lands; the three `code/src/scripts/audits/SLOP-FAMILY.md` citations are US002's to
      disposition. A bare pass is unavailable to this sprint
- [ ] `bash code/src/scripts/audits/docs-length.sh` — with `--path code/src/scripts/audits --limit 1`,
      `code/src/scripts/audits/CONTEXT.md` at or under **230** counted lines and
      `code/src/scripts/audits/CLAUDE.md` at or under **200**, both US002's; `code/docs/ABSENCE.md`
      under **270** at birth, US003's; and no file either member edits that already sits at or
      above 270 grows at all — the ratchet's rule, which "enters the warn tier" would read green on
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — US002 moves operating rules from
      `code/src/scripts/audits/CONTEXT.md` into its sibling `CLAUDE.md`, neither half carrying the
      other's headings afterwards, and creates `code/src/scripts/audits/slop-family/`, which owes
      both halves of its pair (`project-management/src/02-STORIES/US002.md` Scenarios 3 and 4).
      US003 creates no directory. The gate exits 0 today as well, so it confirms the pairs are
      intact and decides nothing about whether the move happened — which rules moved is recorded
      by hand
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **US003's alone**: its new `owned` row
      pinning the absence-enum rule is green and no existing claim forks. It reads fenced code
      only, so it does not check the guide's prose doctrine
      (`project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`),
      and for US002 it is **declared blind** — its scan roots exclude `code/src/scripts/**`
      (`project-management/src/15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`) —
      so a green run is never reported as having checked either
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — every name in US003's routing frontmatter
      resolves, including through the wrapped-array form Prettier forces. **US003's alone**; US002
      adds no frontmatter
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` — clause 14 discharged for every skill
      US003's guide names: `backend`, `frontend`, `code-reviewer` and `refactor`. **US003's alone**
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — the leg that reads Markdown, via
      markdownlint-cli2
- [ ] `bash code/src/scripts/syntax/check.sh` — **N/A**, it type-checks Python, TypeScript and Rust
      and has no Markdown leg; this sprint ships Markdown only, so it has nothing to look at
- [ ] `bash code/src/scripts/audits/doc-references.sh --self-test` — **N/A here since
      07/09/2026**; it entered this record with US004 and is the proof of a script this sprint no
      longer edits. Marked with its reason rather than deleted, per `code/docs/GATE-REPORTING.md`
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a code path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component
      added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **N/A**, the sprint's Security flag reads
      `N/A`
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface; it ships
      Markdown read in an editor

<!-- The rows replaced on 07/09/2026, every one written for US004 and travelled with it to
     SPRINT-03:
     "doc-references.sh — **no finding remains of the three classes US004 owns**, each survivor
     named with the story that owns it. Corrected 02/09/2026 by
     project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md AC-GAP-3:
     this does **not** become a plain pass on US004's completion. Three survivors are US003's
     forward references to code/docs/ABSENCE.md, which now clear in **SPRINT-03**, not here;
     three cite code/src/scripts/audits/SLOP-FAMILY.md and belong to **US002 in SPRINT-01**, so a
     bare pass is unavailable to this sprint on its own" — both survivor classes are now THIS
     sprint's, see the live row above.
     "doc-references.sh --self-test exits 0" — now N/A here, above.
     "docs-length.sh — no file created or edited this sprint enters the warn tier without a dated
     allowance, and code/src/scripts/audits/CONTEXT.md is not grown while at 298; US002 in
     SPRINT-01 owns its headroom" — US002 is here and shrinks it, above.
     "doctrine-drift.sh — **regression only**; US004 adds no claims row, and US003's new owned
     row moved to SPRINT-03 with the story" — the row is back with US003, above.
     "routing-skills.sh — **N/A here since 05/09/2026**; it entered this record with US003 and
     ran only against that story's routing frontmatter. Marked with its reason rather than
     deleted, per code/docs/GATE-REPORTING.md" and "skill-conformance.sh — **N/A here since
     05/09/2026**; same reason as the row above" — both apply again since 07/09/2026, above.
     "docs-pairing.sh — regression only; this sprint creates no directory and so owes no new
     pair" — US002 creates one, above.
     "syntax/lint.sh and syntax/check.sh pass, including ShellCheck over the script US004 edits"
     — no script is edited here, so the ShellCheck clause went with US004. -->

<!-- Until 08/09/2026 the syntax row read "`lint.sh` and `check.sh` pass" as one box. Split on
     SPRINT-01's precedent of 07/09/2026: this record's own FLAGS comment says both members ship
     documentation only, check.sh type-checks Python, TypeScript and Rust with no Markdown leg,
     and per code/docs/GATE-REPORTING.md a gate with nothing to look at is not reported as having
     looked. -->

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its
      own DoD complete) — US002 alone
- [ ] **The `Should Have` story is either Completed or explicitly carried to SPRINT-03 with its
      reason recorded here; it is never dropped silently.** US003 has moved twice already — out
      of this record on 05/09/2026 and back into it on 07/09/2026 — and a carry records all three
      moves, here and in `project-management/src/03-SPRINTS/SPRINT-03.md`, which reserves the
      5 SP from its side
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in either member's QA plan
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)

<!-- Two rows replaced on 07/09/2026. The Must row read "— US004 alone"; US004 is SPRINT-03's.
     The second row read: "**No `Should Have` story remains here.** US003 was this sprint's
     stretch tier and moved to project-management/src/03-SPRINTS/SPRINT-03.md on 05/09/2026
     before the sprint opened, with its reason recorded in the Notes. It was not dropped and it
     was not silent." True from 05/09/2026 until 07/09/2026, when US003 returned and the carry
     clause above became live again — now reserving into SPRINT-03 rather than, as SPRINT-03's
     own clause did, into SPRINT-04. project-management/src/02-STORIES/US006.md -> Dependencies
     cites the second row above as the live reservation, since its own correction of 07/09/2026,
     and until 08/09/2026 it did so two ways at once: by section name (_Definition of Done_,
     second row), which is durable, and by line (SPRINT-02.md:584-588, as it then read), which the repair passes
     of 08/09/2026 falsified by growing this record — those lines are Verification Checks rows
     now. The line half was de-numbered in US006.md on 08/09/2026 and the section-name half alone
     stands. This comment's own history: on 07/09/2026 it said US006.md "cites the carry clause
     by line and is owed a re-resolve", when the section-name half had already been added in the
     same parallel pass; on 08/09/2026 it over-corrected to "cites the second row above by
     section name ... no re-resolve is owed", overlooking the line half that survived beside it.
     Both superseded the same day by the sentences above. -->
