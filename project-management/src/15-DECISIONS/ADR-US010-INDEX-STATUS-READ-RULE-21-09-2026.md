# ADR-US010: An index reads every register's Status by one rule — strip the markup, cut at the first middle dot, trim

**Status:** Accepted
**Date:** 21/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US010 · US011 · `project-management/src/02-STORIES/US010.md` · `project-management/src/02-STORIES/US011.md` · `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` N-002, N-003 and slice S-03 · `project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md` (the writer-side format for maps)

---

## Context

**N-003 asserts that two strings are equal and never says how either is read.** Its status clause
is one line — "The row's `Status` **string-equals** the file's"
(`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:242`) — and N-002 requires the row
to hold "the artefact's **own** value, mirrored verbatim — never translated" (the same map, :182).
Neither defines "the file's" status, and the seven registers do not carry one the same way. Measured
21/09/2026, tracked files only. Each register's instance pattern is in brackets, and every count was
re-measured under it on 27/09/2026 and is unchanged:

- **`01-FEATURE-MAPS`** (`MAP-*.md`) — a bold-key line, `**Status**:`, at :4 to :19 depending on
  the map; not in the format on twelve of fifteen today, `<enum> · <prose>` after the companion
  record. 15 instances. (AMENDED 27/09/2026 at the final pass: this read "free prose on twelve of
  fifteen"; the companion record measures nine of the twelve as free prose and three as failing the
  format some other way.)
- **`02-STORIES`** (`US[0-9]{3}.md`) — `**Status:**` at :4. 11 instances, all `Open`. A twelfth,
  `project-management/src/02-STORIES/US012.md`, matches the pattern and reads `Open`, but is still
  untracked on 27/09/2026 and is not counted.
- **`03-SPRINTS`** (`SPRINT-[0-9]{2}.md`) — `**Status:**` at :20 to :41 in the working tree, or :20
  to :33 at HEAD. A concurrent session has moved SPRINT-07's to :41. 7 instances, all `Planned`.
- **`15-DECISIONS`** (`ADR-*.md`) — `**Status:**` at :3, or :11 in one record. 20 instances: 15
  `Accepted`, 3 `Superseded`, 2 `Proposed`. This pass's two records, this one and
  `project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`, match
  the pattern and read `Proposed`, but are untracked on 27/09/2026 and are not counted.
- **`17-STORY-PLANS`** (`[0-9]{2}-STORY-PLAN-US[0-9]{3}-*.md`) — a table row at :9 whose value cell
  is backticked. 9 instances: 8 `Open`, 1 `Blocked`.
- **`20-FINDINGS`** (`FINDING-*.md`) — `**Status**:` as the last middle-dot-separated field of a
  metadata line, `project-management/src/20-FINDINGS/FINDING-US000-TEMPLATE.md:5`. 0 instances.
- **`21-BUGS`** (`BUG-*.md`) — a table row whose key cell is bold,
  `project-management/src/21-BUGS/BUG-US000-TEMPLATE.md:17`. 0 instances.

**An instance is a tracked file that matches its register's pattern: the test is positive**
(settled 27/09/2026, grilling round 3 Q22; "tracked" added 27/09/2026 at the final pass, to agree
with N-003 at `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:232` and with
`project-management/src/02-STORIES/US010.md:563`). N-003's test as charted was negative. It
counted a tracked `.md` that is not `CONTEXT.md`, not `CLAUDE.md`, not `*TEMPLATE*` and not the
index itself
(`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:231-234`, as read 21/09/2026).
That counted every other Markdown file a register folder gains, and one such file already exists:
`project-management/src/02-STORIES/CUT-PLAN.md`, syntek-base's cut plan. It has no `**Status:**`
carrier line, so once tracked the status clause would have had no file-side value for it. The
patterns in brackets replace that test, and N-003 now states them: its wording was corrected on the
map on 27/09/2026, at the wayfinder resolve sitting, not here (settled 27/09/2026, grilling round 5
Q30; `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:231-236`, session log :617;
Follow-on below). The patterns still exclude `*TEMPLATE*` and the index itself, and `CUT-PLAN.md`
matches none of them, so it is not an instance. The two tests agree on every tracked file today,
because `CUT-PLAN.md` is untracked; that is why no count above moved. Both exclusions still do
work. `*TEMPLATE*` removes the template in five registers, all but stories and sprints, whose
template names do not match the pattern. The index exclusion removes `MAP-INDEX.md`,
`FINDING-INDEX.md` and `BUG-INDEX.md`, each of which matches its own register's pattern. Each
pattern was checked on 27/09/2026 against the files on disk and against its register's `CLAUDE.md`
naming rule, and none needed correcting.

**Programme plans are not instances, and are not permitted** (SETTLED 27/09/2026, grilling round 6
Q32; left open by this record until then). `project-management/src/17-STORY-PLANS/CLAUDE.md` also
names cross-cutting programme plans, `PLAN-<DESCRIPTOR>.md`, which the story-plan pattern does not
match. None exists, so no count moves. Round 6 Q32 goes further than the instance question:
`PLAN-<DESCRIPTOR>.md` is not permitted in syntek-base or in any generated project, because every
artefact follows one of the 24 `project-management/workflows/`. The permission still stands in
three shipped files, and US010 removes it from all three, as a task and a criterion (settled
27/09/2026, grilling round 6 Q33): `project-management/src/17-STORY-PLANS/CLAUDE.md:11`, :72 and
:79-80; `project-management/src/17-STORY-PLANS/CONTEXT.md:18` and :25; and
`project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md:254` and :713-714. US010's
`ST05` already admits writes under `project-management/src/`.

**Two stories have already given three answers, each where its case was met.**

- Maps: the index cell "string-equals that leading enum value"
  (`project-management/src/02-STORIES/US010.md:329`, as read 21/09/2026).
- Decisions: "its row carries the enum value alone", for the one ADR whose Status line carries a
  trailing HTML comment (`project-management/src/02-STORIES/US011.md:230`, as read 21/09/2026).
- Plans: "with the backticks stripped and the value preserved" (the same story, :217, as read
  21/09/2026).

Those quotations are the three answers as written. The write-back of 27/09/2026 replaced each with a
case of the rule below: maps now at `project-management/src/02-STORIES/US010.md:577` and :586
(the spine at :555); the decision now at `project-management/src/02-STORIES/US011.md:325`, and the plans at :304
and :307 of the same story (re-measured 27/09/2026 against the final pre-commit text).

Each is silent on the others' cases — "leading enum value" presumes a prefix only maps will have,
"enum value alone" says nothing about backticks, "backticks stripped" nothing about comments — and
US010's carrier inventory names five registers and omits findings and bugs
(`project-management/src/02-STORIES/US010.md:467-471`, as read 21/09/2026). The two registers with
no instance yet are the two with no reading.

**The markup is measured, not imagined.**

- **A trailing HTML comment on a Status line:**
  `project-management/src/15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md:11`
  follows `Proposed` with a comment deferring the value to US004's own `15-decisions` pass.
- **A template that produces it:** `project-management/src/15-DECISIONS/ADR-US000-TEMPLATE.md:10`
  follows `Proposed` with a comment listing the four values, and :13 and :14 put one on Supersedes
  and Superseded by. Nineteen of twenty live records stripped the Status one; any record copied by
  workflow Step 5 inherits all three unless it is stripped.
- **The same on the decision register's tail:** the Supersedes line of
  `project-management/src/15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md:6` and
  the Superseded by line of
  `project-management/src/15-DECISIONS/ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES-02-09-2026.md:7`
  each end in a citation-marker comment.
- **Bold:** every prose-line key and the bug row's key cell are bold, and ten live maps bold their
  value as well.
- **Backticks:** every story plan's value.
- **The middle dot:** the findings line puts fields beside Status, and after the companion record
  every map's prose follows one.

**Why now, and not with the gate.** S-03 follows US011 (settled 21/09/2026, grilling round 1 Q1).
US011 writes one row per instance across four registers, 43 at cutting
(`project-management/src/02-STORIES/US011.md:318` as read 21/09/2026, now at
`project-management/src/02-STORIES/US011.md:450`; 47 tracked on 27/09/2026, :46-47) and
re-counted at build. Whatever reading US011
uses becomes the rows S-03 is later built against.

**Line numbers in `project-management/src/02-STORIES/US010.md`.** Every citation of that file in
this record was read on 21/09/2026 in the working copy, which includes a concurrent session's
uncommitted edits. At HEAD the same line numbers point elsewhere. The feedback edits returned with
this record lengthen that file's Decisions section, which moves the lines below it again. Each US010
citation here is therefore re-verified before sign-off (discharged 27/09/2026 — see the AMENDED
note). **AMENDED 27/09/2026:** the edits landed in the working copy with the write-back and
fix pass of 27/09/2026, still uncommitted; by the time these citations were re-measured US010 had
grown from 577 to 1,154 lines and `project-management/src/02-STORIES/US011.md` from 379 to 511.
Every citation of either story that locates where this record lands now names its current line
("now at", measured 27/09/2026); the rest stay as read 21/09/2026. **AMENDED AGAIN 27/09/2026, AT
THE FINAL PASS:** neither story changes after the Stories phase, and every "now at" citation of
either here was re-measured on 27/09/2026 against its final pre-commit text, US010 at 1,211 lines
and US011 at 524, by searching for the cited text rather than shifting by an offset. The US011
citations all held; the US010 ones were re-pointed. A citation marked "as read 21/09/2026"
locates the text as it stood then and is not re-pointed. This paragraph had closed "All are
re-verified once each story's commit exists"; a commit moves no line of a file that no longer
changes, so the re-measure of 27/09/2026 is the verification.

## Options considered

### Option A — do nothing: each story answers its own case

- **Summary:** the three answers stand where they are written; findings and bugs are answered when
  each gains an instance; S-03 reconciles.
- **Pros:** no new record, and each answer was reasoned where its case arose.
- **Cons:** three readings for one clause, with a fourth and fifth owed. A gate implementing them all
  implements a table of readings per register — the mapping N-002 rejected at
  `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:192-195`, moved from values to
  readings — and inherits the reconciling after the rows are written. The deletion test runs in
  reverse here: the rule does not exist, and its complexity has already reappeared at three call
  sites.

### Option B — normalise the sources

- **Summary:** make every carrier bare — drop the comment from the US004 record's :11, strip the
  template's trailing comments, un-backtick the plan cells, un-bold the map values.
- **Pros:** the reader becomes trivial — the text after the key.
- **Cons:** ownership. The US004 record's comment is US004's open question, and US011 already
  refuses to edit another story's ADR "to make its own criterion easier"
  (`project-management/src/02-STORIES/US011.md:66-68`, :232, as read 21/09/2026; now at
  `project-management/src/02-STORIES/US011.md:84-86` and :327). The ADR template ships into every
  generated project and its comments are its authoring guidance; the plan cell's backticks are the
  story-plan template's format. And it holds only until the next file is copied from a template that
  still produces the markup: the sources are normalised once, and the templates produce the case
  indefinitely.

### Option C — one read rule, designed in US010's spine (the decision)

- **Summary:** one sentence defines the normalised Status for all seven registers. US010 designs it
  with the spine it already designs, US011 applies it, S-03 inherits it.
- **Pros:** a deep module in the `codebase-design` sense — a four-strip-and-trim interface over seven
  carriers — with leverage over two writing stories and one gate, and locality: a new carrier shape
  is checked in one place. The leverage extends to S-04's frontmatter mirror if its cutting adopts
  the rule (Follow-on below). Findings and bugs are covered before their first instance.
- **Cons:** lossy by design — what a comment on a Status line says never reaches the index. It
  constrains every future status vocabulary: no value in any of the seven may contain a middle dot.
  And it reads; it does not validate.

### Option D — defer the rule to S-03

- **Summary:** leave the reading unspecified until the gate is cut, and settle it there, beside the
  code and the fixtures that execute it.
- **Pros:** the rule is designed with the only thing that runs it.
- **Cons:** every row US011 writes is written before the reading it must satisfy exists, and S-03 is
  then designed against rows already written to private readings — the failure the map calls a gate
  designed against a guess (:194-195), inverted. US011's own acceptance could not be evaluated by
  anyone, because its status criterion would have no defined left-hand side.

## Decision

**We will take Option C. An index row's `Status` is the register's carrier value with bold markers,
backticks, any trailing HTML comment, and everything from the first middle dot onward removed, then
trimmed.** Settled 21/09/2026, grilling round 1 Q5. The record stays `Proposed` until the developer
signs it off (settled 21/09/2026, grilling round 2, the consequential calls). AMENDED 27/09/2026 at
the final pass: that sign-off is its acceptance in the 27/09/2026 write-back pass, only after an
independent review and before the US010 commit (settled 27/09/2026, grilling round 4 Q27). Until
that review is done and the Status line above flips, the record is `Proposed`.

The terms, precisely:

- **An instance** is a tracked file whose name matches its register's pattern in the Context
  above, excluding `*TEMPLATE*` and the index itself (settled 27/09/2026, grilling round 3 Q22;
  "tracked" added 27/09/2026 at the final pass, as in the Context). The rule
  reads the carrier of instances only. A file that matches no pattern, such as
  `project-management/src/02-STORIES/CUT-PLAN.md`, is not indexed and is never read. A programme
  plan, `PLAN-<DESCRIPTOR>.md`, is not an instance, and is not permitted at all (settled
  27/09/2026, grilling round 6 Q32).
- **The carrier line** is the one line each register's status is read from. The key string also
  appears elsewhere in these files: `**Status:**` occurs on 21 lines of
  `project-management/src/02-STORIES/US007.md` and 7 of
  `project-management/src/03-SPRINTS/SPRINT-01.md`, `project-management/src/02-STORIES/US008.md:219`
  quotes a sprint's `**Status:** Planned` mid-line, and maps carry `| **Status** |` table rows
  (`project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md:547`). So the carrier line is fixed
  per register:
  - Maps, stories, sprints and decisions: the first line that **begins** with the key.
  - Findings: the first line that contains `**Status**:`, which is the metadata line.
  - Story plans and bugs: the first table row whose first cell is the key.
- **The carrier value** is what follows the key on that line. The key is `**Status**:` for maps and
  findings, `**Status:**` for stories, sprints and decisions, and the `Status` or `**Status**` cell
  for story plans and bugs, where the value is the cell after it. The line bounds the value: a
  status that wraps onto the next line is read on its first line only, and the companion record
  keeps every map's value there.
- **A trailing HTML comment** runs from its opener to the end of the line. **Bold markers** are every
  double-asterisk occurrence. **Backticks** are every backtick character.
- **The middle dot** is the three-character separator space, U+00B7, space. The first one on the
  line ends the value.
- **Trimmed** means leading and trailing whitespace removed. Nothing else is touched: the em-dash
  inside `Blockers clear — stories may start` is part of the value.
- **The strips run in a fixed order:** the comment, then bold markers, then backticks, then the cut
  at the first middle dot, then the trim. No reading measured on 21/09/2026 depends on the order. It
  is fixed so that an edge case, such as a bold span that crosses the separator, has only one
  reading.

Worked readings, from the tree on 21/09/2026: a story's `**Status:** Open` reads `Open`; the plan at
`project-management/src/17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md:9` reads
`Blocked`; the US004 record's :11 reads `Proposed`;
`project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md:4` reads `Charting`; and a map
rewritten to the companion format — `Blockers clear — stories may start`, a middle dot, then prose —
reads `Blockers clear — stories may start`.

The deciding factor is that **equality is defined only once both sides are reduced by the same
reading**, and there are two sides and seven carriers. N-003 chose string-equality over a mapping
precisely so the gate would compare like with like; a reading per register is a mapping of another
kind. One rule, written before the first row, is the only option under which US011's rows and S-03's
gate agree by construction rather than by review. B makes the reader trivial by editing files these
stories do not own, and leaves the templates producing the case. A and D leave it to be reconciled
after the rows exist.

**Why these four strips and no more.** Each answers a measured case above, and each removes markup,
never words. The rule never translates — `Superseded` stays `Superseded` — so N-002's "never
translated" holds; which values are legal stays with each register's declaring template, where
`project-management/src/02-STORIES/US007.md:400-402` puts it.

**It dissolves the three answers rather than overruling them.** "The leading enum value" is what the
cut at the first middle dot yields from a map in the companion format; "the enum value alone" is the
comment strip; "backticks stripped" is the backtick strip. The trailing comments the ADR template
puts after `Proposed` and on its supersession fields dissolve the same way: the decision register's
Supersedes and Superseded by values are read by the same strips, before US010's tail design renders
them.

**Out of scope, each settled separately on 21/09/2026:** the map writer format (the companion
record); `Updated`, which is the instance file's last commit date (round 1 Q6); and row ordering per
register (round 1 Q7).

## Consequences

- **Positive:** one reading for seven registers, stated before any row is written, so US011's rows
  and S-03's gate reduce both sides the same way.
- **Positive:** the US004 record reads `Proposed` without being edited, so the trailing-comment case
  stops being a divergence US011 must record and becomes an ordinary reading.
- **Positive:** findings and bugs have their reading before their first instance. Both key
  spellings (`**Status**:` in maps and findings, `**Status:**` in stories, sprints and decisions)
  are named in the carrier definition, so neither register's key has to be edited to match the
  other.
- **Negative / trade-off:** lossy by design. The US004 record's comment — that the value is checked
  at US004's own pass — never reaches the index, which shows a bare `Proposed`. The file stays
  canonical and the caveat stays in it; an index reader sees the state, not its qualification.
- **Negative / trade-off:** a constraint on every future vocabulary. No status value in any of the
  seven registers may contain a middle dot, or it is read as its first half. None does today. Two
  templates use the middle dot to separate the values in a legend. One is inside the seven: the
  story-plan template's carrier line itself lists eleven values separated that way
  (`project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md:9`). The other is the
  refactoring template (`project-management/src/22-REFACTORING/REFACTORING-US000-TEMPLATE.md:19`).
  `22-REFACTORING` is outside the seven, and a later index for it inherits this rule and this
  constraint together.
- **Negative / trade-off:** the rule reads; it does not validate. A map header that lost its enum and
  kept its prose reads as its first prose clause, and the rule returns that string without
  complaint. A template legend copied without a value being chosen reads the same way. A story plan
  copied from its template's :9 without a choice reads `Open (default)`. A bug copied without
  editing its row reads `Open / Fixed / Verified`
  (`project-management/src/21-BUGS/BUG-US000-TEMPLATE.md:17`). A finding reads its placeholder
  `{Open → Triaged}` (`project-management/src/20-FINDINGS/FINDING-US000-TEMPLATE.md:5`). None of
  these raises an error. Checking that a value belongs to its register's vocabulary is a separate
  check that nobody has designed. S-03's equality catches the fault only where the index row holds a
  legal value and the file does not.
- **Negative / trade-off:** the rule is line-scoped, so a value wrapped onto a second line is
  truncated. The companion format keeps every map's value on the key's line, and no other register
  wraps its status today.
- **Follow-on** `[RESOLVED] 27/09/2026` — US010 writes the rule into its spine — each index's
  reading rule and each seed — and its carrier inventory
  (`project-management/src/02-STORIES/US010.md:467-471` as read 21/09/2026) gains findings and
  bugs. The write-back of 27/09/2026 carried both into US010's text: the inventory, findings and
  bugs included, is now at `project-management/src/02-STORIES/US010.md:931-943`, and the task that
  writes each index's `## How to read a row` at :944-951 (re-measured 27/09/2026 against the final
  pre-commit text). The build writes them into the files.
- **Follow-on** `[RESOLVED] 27/09/2026` — US011 applies the rule and cites this record. Its
  Gherkin lines at `project-management/src/02-STORIES/US011.md:217` and :230 were to become cases
  of it, and its task at :315-317 was to record a reading rather than a divergence (lines as read
  21/09/2026). The write-back of 27/09/2026 carried both: the carrier scenario is now at
  `project-management/src/02-STORIES/US011.md:303-310`, the trailing-comment scenario at :322-327,
  and the task at :444-449. **US011 carries no ADR of its own**: its candidate (:183-187 as read
  21/09/2026) is subsumed here (settled 21/09/2026, grilling round 2, the consequential calls), and
  US011 now records it as closed as subsumed at :245-253, with the no-ADR entry at :259-264.
- **Follow-on** `[RESOLVED] 27/09/2026` — the positive instance test (Context above) is adopted, by
  this record and by US011's count (settled 27/09/2026, grilling round 3 Q22). US011's text stated
  N-003's negative test (`project-management/src/02-STORIES/US011.md:26-29` and its Gherkin at
  :205, as read 21/09/2026). The write-back of 27/09/2026 corrected it before US011 is built: the
  provenance at `project-management/src/02-STORIES/US011.md:46-62` replaces the test still quoted
  at :26-29, the Gherkin is now at :286, and the measurement task at :414-419. N-003's wording
  (`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:231-234`, as read 21/09/2026)
  was corrected on 27/09/2026 at the wayfinder resolve sitting on that map, which also made its two
  Acceptance-cell fixes (settled 27/09/2026, grilling round 5 Q30;
  `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:231-236`, session log :617;
  `project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`,
  Follow-on). Neither this record nor US011 edited the map. S-03's gate is built to the corrected
  N-003.
- **Follow-on** `[RESOLVED] 27/09/2026` — US010 removes the `PLAN-<DESCRIPTOR>.md` permission from
  `project-management/src/17-STORY-PLANS/CLAUDE.md`,
  `project-management/src/17-STORY-PLANS/CONTEXT.md` and
  `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`, as a task and a
  criterion, at the lines the Context names (settled 27/09/2026, grilling round 6 Q33). US010 now
  carries it as a task (`project-management/src/02-STORIES/US010.md:1036-1045`), a scenario
  (:668-674) and a manual check (:891-893), re-measured 27/09/2026 against the final pre-commit
  text. The build removes the permission from the files. This record edits none of the three.
- **Follow-on:** S-03 inherits the rule, and N-003's status clause is asserted against the
  normalised value. How the gate implements the reading, whether it also normalises the index cell
  or requires it written already normalised, and the fixtures that prove each strip, are S-03's.
- **Follow-on:** S-04's artefact frontmatter is a second machine reader of the same carriers, and
  this record does not bind it. The frontmatter puts a universal `Status` key on every artefact
  (`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:285-286`). That key "mirrors the
  body, which stays canonical" (:292-294), and a mirror `--check` enforces it (:352). The mirror
  was settled on 31/08/2026 without saying how it reads the body. If it copies the carrier value
  as written, every map in the companion format puts `<enum> · <prose>` into its frontmatter while
  its index row holds the enum alone. Two mirrors of one file would then disagree. S-04 is uncut
  (Story `—`, :352), so the choice goes to its cutting: read the body by this rule, so that
  frontmatter, index and file agree, or name the divergence and argue for it there.
- **Follow-on:** the sign-off of
  `project-management/src/15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` is
  scheduled nowhere. It entered as Proposed on 08/09/2026, to be checked "at US004's own
  15-decisions pass" (its :8-9); that pass ran on 02/09/2026, before the record existed
  (`project-management/src/02-STORIES/US004.md:165-166`), and US004's Decisions list names four other
  records (:129-148). On 21/09/2026, among files tracked before this pass, the filename is cited
  only by US011, `project-management/src/15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md`
  and `project-management/src/17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md`.
  This pass's untracked artefacts also cite it: this record,
  `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
  and `project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md`. Two
  citers were added since, re-measured 27/09/2026: US010, whose Decisions section names the
  sign-off as this record's Follow-on and leaves that ADR unedited
  (`project-management/src/02-STORIES/US010.md:479-481`, in its final pre-commit text), and
  `project-management/src/11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md`, whose AC-GAP-14
  resolution says the same, cited by entry because that plan's lines were still moving on
  27/09/2026. At HEAD 71a32d7 the same three tracked files, and no others, cite it on 27/09/2026,
  and a session handoff under `handoffs/` lists the filename among files to read. None of them
  schedules the sign-off.
  **Named here, not acted on**: this record neither flips nor edits it, and makes its trailing
  comment harmless to the index either way.
- **Follow-on:** the ADR template keeps its trailing comments — they are its authoring guidance, and
  this rule makes them harmless to an index. Both records written at this pass strip them from their
  own headers, as nineteen of twenty live records already did.
