# ADR-US010: A map's Status header opens with one of five plain enum values, and any prose follows the first middle dot

**Status:** Accepted
**Date:** 21/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US010 · `project-management/src/02-STORIES/US010.md` · `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` N-002, N-003 and slice S-03 · `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` (the reader-side rule this format is read by)

---

## Context

**A map's status is the one register value nothing can read as a value today, and US010 is the
story that has to mirror it.** N-002 gave every register index a `Status` column holding "the
artefact's **own** value, mirrored verbatim — never translated"
(`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:182`). N-003 made that column
gate-read: the row's `Status` "**string-equals** the file's" (the same map, :242). The map records
why that is a gate decision rather than a style one — "a coarse shared lifecycle would make the
gate assert a mapping table instead" (:192-195). US010 backfills MAP-INDEX.md, so it is the first
story that must produce a map's status as a string.

**The enum exists, and almost nothing writes it.** It has one definition site, the map template
`project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md`, whose :4 reads
`**Status**: Charting / Resolving / Blockers clear — stories may start / Complete`. Neither
`.claude/skills/wayfinder/SKILL.md` nor `.claude/skills/scale-planning/SKILL.md` contains the word
"status" in any case (grep, 21/09/2026: zero lines in each), so that template line is the only
statement of the value set and the format. The folder's own
`project-management/src/01-FEATURE-MAPS/CONTEXT.md:49-50` tells a writer to keep the status in a
map's index row current as nodes resolve, but not what the value is. Measured 21/09/2026 across the fifteen tracked
live maps, all under `project-management/src/01-FEATURE-MAPS/`:

| State of the `**Status**` header                               | Maps (file:line)                                                                                                                                                                                                                     | Count |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----- |
| A plain enum value — parses as the format                      | MAP-INSTRUCTION-DELIVERY.md:4, MAP-NATIVE-MOBILE-SURFACE.md:4, MAP-PROGRESSIVE-ENHANCEMENT.md:4, all `Charting`                                                                                                                      | 3     |
| An enum value, wrapped in bold                                 | MAP-RULE-OWNERSHIP.md:19                                                                                                                                                                                                             | 1     |
| An enum value in bold, a `;` separator, three lines            | MAP-REGISTER-INDEXES.md:6-8                                                                                                                                                                                                          | 1     |
| Not an enum value, but passes a naive "starts with `Charting`" | MAP-BUN-TOPOLOGY.md:4, `Charting complete`                                                                                                                                                                                           | 1     |
| Free prose                                                     | MAP-ABSENCE.md:4-5, MAP-CAP-POSTURE.md:6, MAP-CLAUDE-DESIGN-HANDOFF.md:4, MAP-GATE-PARITY.md:15, MAP-NAVIGATION.md:4, MAP-RETRY-AND-IDEMPOTENCY.md:5, MAP-SCRIPT-GUARDS.md:4, MAP-SUBDOMAIN-ROUTING.md:4, MAP-UPSTREAM-TRACKING.md:4 | 9     |

Twelve of fifteen fail the format. The key sits at :4, :5, :6, :15 or :19 depending on the map, two
values wrap onto the line below, and ten of the twelve bold their value.

**Parsing is not the same as holding the right value.** Decision item 3 below derives each value by
measurement, and one of the three headers that parse fails that test.
`project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md:4` reads `Charting`. Its own
:5 records the frontier closed on 31/08/2026 with 0 blocking open, and :10-11 say no blocking node
remains and authoring may begin. Its value therefore changes even though its header already parses.
It does not change to `Complete`, because its fog of war still holds one item (:526). The other two
hold `Charting` over a frontier that has been drawn: 12 open at MAP-INSTRUCTION-DELIVERY.md:5 and 21
at MAP-NATIVE-MOBILE-SURFACE.md:5. That is the boundary between `Charting` and `Resolving`, and
item 3 now tests it by a count rather than a reading: a drawn frontier with no node resolved stays
`Charting` while Blocking open is above 0, as it is on both maps (8 and 9), and the first resolved
node, with Blocking open above 0, makes a map `Resolving` (settled 27/09/2026, grilling round 3
Q18; the Blocking-open condition on `Charting` AMENDED 27/09/2026, grilling round 6 Q31). Whether
either map holds a resolved node is measured in US010's derivation.
**So at least thirteen of the fifteen headers change, and all fifteen
are re-derived.** Twelve, the figure settled at round 2 Q11, counts the headers that fail the
format.

**One value is written outside the enum, by the one map that ships.**
`.copier/MAP-SCALE-PLANNING.md:4` reads `**Status**: Not started`. It is the stub every generated
project receives — moved into place at `copier.yml:979`, inside the copy-gated `_tasks` entry — its
frontier is "every node below" (:5), and it is the only writer of that value anywhere. Against a
four-value enum its index seed row has nothing legal to mirror: US010 as cut gives that row `TBD` in
every column (`project-management/src/02-STORIES/US010.md:349`, as read 21/09/2026), which fails
N-003's status clause against `Not started` in every generated project on the day S-03 ships. The
row now reads `Not started` in US010, written back 27/09/2026 (now at
`project-management/src/02-STORIES/US010.md:607` and :976-980). From US010, as settled at the final pass of
27/09/2026, its agreement with the seeded map is asserted at template time, by the seed-row clause of the
third `.github/scripts/shipped-registers.sh` family (the same story, :608 and :636-637; settled
27/09/2026, grilling round 7 Q34).

**The separator has been corrected once already.** Round 4 Q1 of US010's `02-story-creation`
(20/09/2026) settled a leading enum value and first wrote the separator as an em-dash. The third
value contains one, so "the text before the em-dash" is ambiguous for one value in four — and the
map carrying that value is MAP-REGISTER-INDEXES itself. The middle dot replaced it before it was
written down (`project-management/src/02-STORIES/US010.md:92-100` as read 21/09/2026, now at
`project-management/src/02-STORIES/US010.md:101-115`, and the S-02 Acceptance cell at
`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:350`).

**What makes this hard to reverse is a gate that does not exist yet.** Today nothing reads the
header, and every rewrite is an edit that can be edited back. That lasts until S-03 ships, and the
argument turns on S-03 shipping, not on when: the irreversibility below holds whenever it lands
(settled 27/09/2026, grilling round 3 Q20). S-03 has no sprint (CUT-PLAN.md P8; map-order row 10),
which supersedes the timing settled on 21/09/2026 at grilling round 1 Q1 and round 2 Q13, that it
is cut straight after this pass. Round 1 Q1's ordering, S-03 after US011, stands. AMENDED
27/09/2026 at the final pass: this read "the 21/09/2026 settlement that it is cut straight after
this pass (grilling round 1 Q1 and round 2 Q13)", which could be read as P8 overturning the
ordering as well as the timing. Whenever it ships, its `register-indexes.sh` travels on
`copier update` while the maps a project has written do not; and the map records the consequence
as S-03's own acceptance — a release changing a gate-read column "**ships a `.copier/migrations/`
script in the same commit**" (`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:351`,
reasoned at :562-566). The template ships into every generated project — `copier.yml:164`
re-includes `**/*TEMPLATE*` — so the format reaches maps this repository will never see. US010
already called the prefix hard to reverse on exactly that ground
(`project-management/src/02-STORIES/US010.md:283-285` as read 21/09/2026, now at
`project-management/src/02-STORIES/US010.md:471-473`).

**Scope.** This record decides what a map **writes**. How an index **reads** any register's status,
maps included, is the companion
`project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`. The two are
separate records — writer format and reader rule — so either can be superseded without the other
(settled 21/09/2026, grilling round 2, the consequential calls accepted with Q11).

**Line numbers in `project-management/src/02-STORIES/US010.md`.** Every citation of that file in
this record was read on 21/09/2026 in the working copy, which includes a concurrent session's
uncommitted edits. At HEAD the same line numbers point elsewhere. The feedback edits returned with
this record lengthen that file's Decisions section, which moves every line below it again. Each
US010 citation here is therefore re-verified before sign-off (discharged 27/09/2026 — see the
AMENDED note). **AMENDED 27/09/2026:** the edits landed in the working copy with the write-back
and fix pass of 27/09/2026, still uncommitted, and the file grew from 577 lines to 1,154 by the
time these citations were re-measured. Every citation that locates where this record lands in
US010 now names its current line ("now at", measured 27/09/2026); the rest stay as read
21/09/2026. **AMENDED AGAIN 27/09/2026, AT THE FINAL PASS:** US010.md does not change after the
Stories phase, and every "now at" citation of it here was re-measured on 27/09/2026 against its
final pre-commit text, 1,211 lines, by searching for the cited text rather than shifting by an
offset. A citation marked "as read 21/09/2026" locates the text as it stood then and is not
re-pointed. This paragraph had closed "All are re-verified once the US010 commit exists"; the
commit moves no line of a file that no longer changes, so the re-measure of 27/09/2026 is the
verification.

## Options considered

### Option A — do nothing: the header stays free prose

- **Summary:** maps keep writing status as prose, and MAP-INDEX.md mirrors the header or a value
  derived from it.
- **Pros:** no rewrites and no format to teach. Prose carries nuance a value cannot — "fog closed
  01/09/2026 (1 answered · 1 cleared · 3 stay with triggers)".
- **Cons:** mirroring prose verbatim puts a three-line paragraph into a table cell
  (MAP-REGISTER-INDEXES.md:6-8), and deriving a value is a translation — which N-002 forbids, and
  which leaves the gate asserting a mapping table or not asserting status for maps at all: one
  register in seven exempt from the clause the gate exists for. The naive middle course fails
  silently: `Charting complete` passes "starts with `Charting`".

### Option B — an enum prefix, separated by an em-dash

- **Summary:** `<enum> — <prose>`, round 4 Q1's first wording.
- **Pros:** the em-dash is house style, and the one non-ASCII mark the writing rules endorse
  (`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md:80-82`); most current prose already
  follows its opening phrase with one.
- **Cons:** `Blockers clear — stories may start` contains one. A reader splitting on the first
  em-dash reads `Blockers clear` for that value; splitting on the last breaks on any prose holding
  an em-dash, which is most of it. Unparseable for one value in five, measured rather than feared.

### Option C — an enum prefix, separated by a middle dot (the decision)

- **Summary:** `**Status**: <enum> · <prose>` — the value plain, with no bold and no backticks, then
  space, middle dot, space, then any prose. With no prose the line is `**Status**: <enum>`.
- **Pros:** no enum value contains a middle dot, so the first one is unambiguous for all five. It
  is already the header block's field separator — the template's :3 and :5 use it on the lines
  either side of Status — and the findings register separates its metadata fields the same way
  (`project-management/src/20-FINDINGS/FINDING-US000-TEMPLATE.md:5`), so the companion read rule
  cuts at one separator for every register rather than one per register. Existing prose survives
  after it, unedited.
- **Cons:** the middle dot already appears inside current Status prose on three maps —
  MAP-CAP-POSTURE.md:6, MAP-SUBDOMAIN-ROUTING.md:4 and MAP-REGISTER-INDEXES.md:8 — so the format is
  safe only because the first one wins, and a rewrite that drops the enum but keeps the prose reads
  its first prose clause as a status. It is non-ASCII against "Prefer plain ASCII punctuation"
  (`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md:80`); the Status line adds no character
  the template's header block does not already carry. And plain-not-bold reverses the habit of ten
  of the twelve maps being rewritten.

### Option D — a separate `**Map state**` field

- **Summary:** leave `**Status**` as prose and add a header line holding the enum alone, which the
  index mirrors.
- **Pros:** prose untouched, no separator to get wrong, and a line that holds nothing but the value.
- **Cons:** two status surfaces on one file that can disagree — prose reading `Fully charted` over a
  state of `Resolving` is the drift this whole line of work exists to stop, moved inside a single
  file. The index's `Status` column would mirror a field not called Status, so the read rule would
  need a key exception for maps alone. And it is not cheaper: all fifteen maps gain a line, where C
  changes only the headers whose format or value is wrong (at least thirteen, measured above). It
  widens the interface — two fields to learn — to hide nothing.
- **Not the same as S-04's mirror.** The artefact frontmatter settled for S-04 also gives every map
  a second `Status` surface
  (`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:285-286`). That surface is a
  copy: it "mirrors the body, which stays canonical" (:292-294). A mirror and its source hold one
  value if they read the body the same way, and the companion record hands that reading to S-04. D's
  two fields hold two different things, an enum and prose, and nothing makes them agree. The
  objection is to that, and it does not apply to S-04.

### Option E — keep four values

- **Summary:** leave the template's :4 at four values, and fit the seeded map to it or exempt it.
- **Pros:** the enum stays as charted, and no value enters it with a single writer.
- **Cons:** every way of fitting the seed is false or fails. Rewriting it to `Charting` asserts a
  charting that has not happened — nothing is charted until `/scale-planning` runs. Leaving its seed
  row `TBD` fails N-003 in every generated project once S-03 ships. Exempting it by name puts a
  special case into a gate whose instance test is exceptionless by design
  (`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:231-236`).

### Option F — let the index read S-04's frontmatter `Status` instead

- **Summary:** leave the header as prose, and have MAP-INDEX.md mirror the `Status` key that S-04's
  artefact frontmatter will put on every map.
- **Pros:** frontmatter is a single machine-read field, so there is no separator in a line of prose.
- **Cons:** the frontmatter `Status` "mirrors the body, which stays canonical"
  (`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:292-294`), so the body still
  needs a value that can be parsed before the mirror has anything to copy. The problem moves; it is
  not removed. And the index would mirror a copy of the file rather than the file itself.
- **Schedule argument dropped** (settled 27/09/2026, grilling round 3 Q20). This entry also argued
  from the schedule: S-04 is not cut (its Story cell reads `—` and its Nodes `TBD`, :352) while
  S-03 was to be cut next, so the gate would wait on a slice with no schedule. S-03 has no sprint
  either (CUT-PLAN.md P8), so the schedule does not separate the options. F stays rejected on its
  remaining Cons above: the body still needs a parseable value, and the index would mirror a copy.

## Decision

**We will take Option C with five values. A map's `**Status**` header is `<enum> · <prose>`: the
value plain, drawn from `Charting`, `Resolving`, `Blockers clear — stories may start`, `Complete`
and `Not started`, and any prose after the first middle dot.** Settled 21/09/2026, grilling round 2
Q11; the fifth value, round 1 Q4. The record stays `Proposed` until the developer signs it off
(settled 21/09/2026, grilling round 2, the consequential calls). AMENDED 27/09/2026 at the final
pass: that sign-off is its acceptance in the 27/09/2026 write-back pass, only after an independent
review and before the US010 commit (settled 27/09/2026, grilling round 4 Q27). Until that review
is done and the Status line above flips, the record is `Proposed`.

The deciding factor is that **the header is written by people and read by a gate, and only C gives
each of them one thing to hold.** The writer keeps their prose after a separator the header block
already uses; the reader gets the value by one cut that is unambiguous for every value in the set.
A and D both leave a file with two readings of its own status — A between the prose and whatever the
index derives, D between two fields — and a gate built over either asserts one reading while a human
reads the other. B fails on a fact about the enum, not a preference. F still needs a value in the
body, because the frontmatter only copies it, and it would have the index mirror that copy rather
than the file; its schedule argument is dropped (settled 27/09/2026, grilling round 3 Q20).

**Five, because the enum should describe what maps already say.** One map says `Not started`, and it
is the map every generated project receives. It is the pre-charting state — nothing charted, its
Charted reading `TBD`, `/scale-planning` not yet run (aligned 27/09/2026 to item 3's test, settled
at grilling round 3 Q18). It ends the moment charting starts. No skill moves a map out of it today;
US010 gives wayfinder's chart step the one line that moves a map out of it when it writes the map's
first node. The step fills Charted and writes the value item 3's counts give: `Charting` while
Blocking open is above 0, otherwise `Blockers clear — stories may start`. It never asserts
`Charting` (the step settled 27/09/2026, grilling round 3 Q24; the value by the counts, round 6
Q31; the two reconciled by the call recorded 27/09/2026, where this read "moves a map to
`Charting`"). The Consequences below cover the gap until then.

What the decision fixes:

1. **The value is one of the five, verbatim and plain.** The read rule strips bold; the format does
   not lean on that, because a writer who sees a bold value in one map copies it into the next.
2. **Prose follows the first middle dot.** It may contain further middle dots — three maps already
   do — and they are prose.
3. **The value is derived by measurement, never asserted, and each value's test reads the map's
   own counts** (settled 27/09/2026, grilling round 3 Q18; the overlap between `Charting` and
   `Blockers clear — stories may start` resolved 27/09/2026, grilling round 6 Q31):
   - `Not started` — nothing charted: Charted reads `TBD`, as `.copier/MAP-SCALE-PLANNING.md:3-5`
     does.
   - `Charting` — charted, no node resolved, and Blocking open above 0.
   - `Resolving` — at least one node resolved, and Blocking open above 0.
   - `Blockers clear — stories may start` — Blocking open 0, and not `Complete`.
   - `Complete` — Frontier open 0 and Fog of war empty (`.claude/skills/wayfinder/SKILL.md:216`;
     `project-management/src/02-STORIES/US010.md:328` as read 21/09/2026, now at
     `project-management/src/02-STORIES/US010.md:584`).

   A charted map with nothing resolved and Blocking open 0 is
   `Blockers clear — stories may start`.

   On 21/09/2026 only `Complete` and `Not started` had a written test; the tracked tree held no
   criteria for the other three (grep, 21/09/2026), the template listed them without criteria, and
   wayfinder defined only when a map is done. The five are written here now, and US010 writes them
   into the template's :4 when it is built; this record does not edit the template. US010's
   derivation for each map (`project-management/src/02-STORIES/US010.md:447-449` as read
   21/09/2026, now at `project-management/src/02-STORIES/US010.md:876-883`) applies them rather
   than standing in for them, so two people reading the same counts place a map the same way.
   MAP-BUN-TOPOLOGY.md:4-5, with a drawn frontier of 29 open and 21 blocking, was the example of a
   map readable as either `Charting` or `Resolving`; it now turns on one count, whether any of its
   nodes is resolved. **The one case round 3 left open is closed** (AMENDED 27/09/2026, grilling
   round 6 Q31). As round 3 Q18 worded the tests, a charted map with no node resolved and Blocking
   open 0 met both `Charting` and `Blockers clear — stories may start`, and Q18 did not say which
   won. `Blockers clear — stories may start` wins, so `Charting` now also requires Blocking open
   above 0. A charted map with Blocking open above 0 is `Charting` or `Resolving`, split by whether
   any node is resolved; one with Blocking open 0 is `Blockers clear — stories may start` or
   `Complete`.

4. **The template's :4 is the definition site**, and in US010 it gains the fifth value, a one-line
   statement of the format, and item 3's five criteria (settled 27/09/2026, grilling round 3 Q18;
   the `Charting` criterion as amended by round 6 Q31). That is where a set belongs:
   `project-management/src/02-STORIES/US007.md:400-402` scopes a `Status` value "to the register
   whose template declares it". So `Not started` becomes a map value and nothing else. US007
   describes it as "a value in no set anywhere" (:572-573) in the sprint-plan story cells it
   corrects. Once this record is accepted, "anywhere" is no longer true, because the map register
   declares the value. US007's correction still holds under its own scoping rule: the cells it
   corrects belong to a register whose template does not declare `Not started`.
5. **The seed row mirrors the seed.** The seeded MAP-INDEX.md's one row reads `Not started`, its
   Instance links the seeded map, its Summary is a generic line naming nothing syntek-base-specific
   or `TBD`, and its Updated is `TBD` (round 1 Q4).

## Consequences

- **Positive:** every map's status is machine-readable for the first time, and MAP-INDEX.md
  mirrors a value rather than a paragraph. S-03's status clause covers maps with no mapping table
  and no exemption.
- **Positive:** the seeded map needs no edit — `.copier/MAP-SCALE-PLANNING.md:4` is already in the
  set — so a generated project's map index agrees with its only map from its first commit. From
  US010 that agreement is asserted at template time rather than read by hand: the seed-row clause
  of the third `.github/scripts/shipped-registers.sh` family fails when the two seeds' Status values
  disagree under the read rule (AMENDED 27/09/2026 at the final pass; settled 27/09/2026, grilling round 7
  Q34).
- **Negative / trade-off:** all fifteen headers are re-derived, and at least thirteen change: the
  twelve that fail the format and MAP-PROGRESSIVE-ENHANCEMENT, whose header parses but whose value
  is wrong. Each derivation is recorded by hand
  (`project-management/src/02-STORIES/US010.md:447-449` as read 21/09/2026, now at
  `project-management/src/02-STORIES/US010.md:876-883`). The key's line varies from :4 to :19, so
  the rewrite finds the key rather than a line number. The population is re-counted at
  implementation, because it moved from 14 to 15 on the day US010 was cut.
- **Negative / trade-off:** the format is taught in one place. Neither wayfinder nor scale-planning
  mentions status today; after US010, wayfinder carries one line, for the move out of `Not started`
  (settled 27/09/2026, grilling round 3 Q24), and the format itself is still stated only at the
  template's :4. So a map written without copying the template — or rewritten by a skill that
  never read its :4 — gets no instruction. Until S-03 ships, nothing but a reviewer catches a
  malformed header on a map that this repository or a generated project writes. The seeded pair
  is checked earlier, and only for agreement: from US010, the seed-row clause of the third
  `.github/scripts/shipped-registers.sh` family checks at template time that the map-index seed's
  one row, read under the companion read rule, string-equals `.copier/MAP-SCALE-PLANNING.md:4`
  read the same way (settled 27/09/2026, grilling round 7 Q34;
  `project-management/src/02-STORIES/US010.md:636-637` and :765-773). Like S-03's status clause,
  it proves that the two agree, not that either holds one of the five values in the format. After
  S-03 ships, the status clause catches a malformed header only where the index row already holds
  a legal value. AMENDED 27/09/2026 at the final pass: this read "Until S-03 ships nothing catches
  a malformed header but a reviewer", which Q34 made inexact for the seeded pair.
- **Negative / trade-off:** until US010 lands, nothing moves a map out of the fifth value.
  `/scale-planning` hands charting to wayfinder (`.claude/skills/scale-planning/SKILL.md:121-131`),
  and neither skill writes a status today. US010 closes that for the value this record creates, the
  one every generated project receives: when wayfinder's chart step writes the map's first node, it
  fills Charted and writes the value item 3's counts give, `Charting` while Blocking open is above 0
  and otherwise `Blockers clear — stories may start`, never asserting `Charting`; scale-planning,
  charting through wayfinder, needs no line of its own (settled 27/09/2026, grilling round 3 Q24;
  the value by the counts, round 6 Q31; the two reconciled by the call recorded 27/09/2026, where
  this read "moves a map to `Charting`"). Round 3 gives no skill the later transitions; a
  writer places each against item 3's counts. A header that is not moved — edited by hand, or
  charted outside wayfinder — can still read `Not started` over a drawn frontier, and S-03 stays
  green in that case, because the seed row mirrors the stale value: the gate proves that the index
  agrees with the file, not that the file is true. The same limit applies to every value, since the
  gate checks agreement and never the derivation.
- **Negative / trade-off:** the format and the read rule are coupled at the separator. Superseding
  either one's separator supersedes the other; they are two records so that anything else about
  either can change alone.
- **Follow-on:** once S-03 reads the column, this format is a gate-read surface. Renaming or
  removing a value, changing the separator, or moving the value off the key's line changes how
  headers a project already holds are read, and so ships a `.copier/migrations/` script in the
  same commit, on the precedent of the seven scripts already there. Adding a sixth value rewrites
  no existing header; it supersedes this record, and whether it owes a migration is for S-03's
  compatibility statement to say. Until S-03 ships every such change is still an edit; this record
  exists so that the change afterwards is a supersession rather than an edit.
- **Follow-on** `[RESOLVED] 27/09/2026` — US010's own text said four when this record was written.
  Its status scenario (`project-management/src/02-STORIES/US010.md:323-329`), its manual check
  (:447-449) and its map task (:518-520) were to move to five values, written plain, the map task
  also re-deriving all fifteen headers, including the three that already parse; its seed row
  (:349), its seed task (:490-491) and `ST03`'s wording (:409-410) were to move from an all-`TBD`
  row to one reading `Not started`. Those lines are as read 21/09/2026, and the changes were
  returned as feedback because a concurrent session held that file. The write-back of 27/09/2026
  carried all of them: the status scenario is now at
  `project-management/src/02-STORIES/US010.md:579-586`, the manual check at :876-883, the map tasks
  at :1077-1095 (the template's :4 at :1077-1087, the fifteen headers at :1088-1095), the seed row
  at :607, the seed task at :976-980 and `ST03` at :757-758 (re-measured 27/09/2026 against the
  final pre-commit text).
- **Follow-on** `[RESOLVED] 27/09/2026` — two Acceptance cells in
  `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` contradicted this record. S-01's
  cell (:349) gave MAP-INDEX.md's seed "one `TBD` row", which should read "one row reading
  `Not started`". S-02's cell (:350) said "four-value enum", which should say five. Both rows are
  US010's, and US010 is told to check them and not re-cut them
  (`project-management/src/02-STORIES/US010.md:523-527` as read 21/09/2026, now at
  `project-management/src/02-STORIES/US010.md:1103-1114`), so it would have checked them against the
  stale wording. Neither this pass nor S-03's cutting could make the edit on its own authority.
  `02-story-creation` allows one edit to a map, the Story column
  (`project-management/workflows/02-story-creation/STEPS.md:94-96`), and the 20/09/2026 back-fill
  changed only the cutting story's own rows. The map names a different owner for its Acceptance
  cells: "this map's next RESOLVE sitting fills them" (:356-357). **That sitting ran on 27/09/2026**
  (settled 27/09/2026, grilling round 5 Q30). It corrected both cells, S-01's to one row reading
  `Not started` and S-02's to five values, and N-003's instance test with them
  (`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:231-236` and :349-350; session
  log :617). US010's verify task checks against that wording. The :420-421 ordering text, which
  round 1 Q1 left to S-03's cutting, was not touched and stays with that cutting; S-03 has no sprint
  (`project-management/src/02-STORIES/CUT-PLAN.md` P8).
- **Follow-on** `[RESOLVED] 27/09/2026` — criteria for `Charting`, `Resolving` and
  `Blockers clear — stories may start` were not written (Decision item 3). They are now, as item 3's
  five count-derived tests, and the template's :4 gains them beside the format line in US010, when
  it is built; the template is not edited before then (settled 27/09/2026, grilling round 3 Q18).
  Each map's placement is still the derivation US010 records, now made against those tests. The
  one detail left for sign-off, where `Charting` and `Blockers clear — stories may start` both
  matched, is settled: `Blockers clear — stories may start` wins, and `Charting` requires Blocking
  open above 0 (AMENDED 27/09/2026, grilling round 6 Q31; item 3).
- **Follow-on** `[RESOLVED] 27/09/2026` — the fifth value had no writer that ends it (Negative
  above). Wayfinder's chart step gains the one line: when it writes the map's first node, it fills
  Charted and moves the map out of `Not started` to the value item 3's counts give, `Charting`
  while Blocking open is above 0 and otherwise `Blockers clear — stories may start`, never
  asserting `Charting`. US010 carries that edit to `.claude/skills/wayfinder/SKILL.md` (now at
  `project-management/src/02-STORIES/US010.md:1018-1027`, with its scenario at :691-695).
  Scale-planning charts through wayfinder, so it gains no line (settled 27/09/2026, grilling round
  3 Q24; the value by the counts, round 6 Q31; the two reconciled by the call recorded 27/09/2026,
  where this read "moves a map out of `Not started`, to `Charting`"). Neither skill is edited by
  this record; where the line sits among wayfinder's CHART steps is left to US010's build.
