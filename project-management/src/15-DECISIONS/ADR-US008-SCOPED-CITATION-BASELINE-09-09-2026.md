# ADR-US008: The citation criterion is the scoped `code/docs` run, and the whole-tree red is reported, never claimed

**Status:** Accepted
**Date:** 09/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US008 · `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` (stands as decided and binds this story; this record is a scoped exception to its method and replaces nothing in it) · `project-management/src/15-DECISIONS/ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026.md` (the story's other record, on the migration key; decides nothing argued here)

---

## Context

US008 lands the cookie doctrine: five documents under `code/docs/` re-specified so that one owns
cookie scope and the other four defer to it — `code/docs/URL-STRATEGY.md`,
`code/docs/security/CRYPTO-AND-DATA.md`, `code/docs/api-design/AUTH-STRATEGY.md`,
`code/docs/security/AUTH-AND-AUTHZ.md` and `code/docs/security/OWASP-AND-CHECKLIST.md`. Every one
of them ships into every generated project, so a citation the sweep gets wrong is a citation a
stranger will follow. The gate that catches it is `code/src/scripts/audits/doc-references.sh`,
and this record decides how US008 reads that gate. Settled as Q6 of the 08/09/2026 grilling pass
and confirmed by <%DEVELOPER_NAME%>, recorded here when the story was cut; it is to be checked,
not re-opened, at US008's own `15-decisions` pass.

**The rule that binds.**
`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` decided
that while the gate is red its criterion is a diff: the finding set is captured before the first
edit, the story ships no **new** unresolved citation from a shipped file it writes or edits, and
the gate is "never reported as the gate passing while the baseline stands". It "applies to every
story in this backlog until the gate is green", and it retires when slice `S-06` of
`project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` lands **and the gate goes green**
— a conjunction, not one event
(`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md:119`).
That slice is carried by US004, and `project-management/src/02-STORIES/US004.md:4` reads `Open` —
SPRINT-03's sole `Must Have` (`project-management/src/03-SPRINTS/SPRINT-03.md:87`), with SPRINT-03
itself still `Planned` (`:20`). The retirement condition is unmet. **US008 is on that record's
baseline-diff branch, not its plain-pass branch.** Both of its supersession fields read `—`, and
nothing here touches either.

**Where the idiom lives, and where it does not.** `code/docs/GATE-REPORTING.md` is the guide a
story reaches for when it wants to say "the gate is red and the red is not mine". It does not carry
that idiom: across its 119 lines there is no occurrence of _inherited_, _baseline_, _pre-existing_
or _already-red_, measured 09/09/2026. What it owns is Section 1 (`:18-25`) — "could not look" is
never reported as "looked, and it was clean" — and Section 6's review question (`:117`): **"For
every success line this change can print — name what ran to earn it."** The baseline-and-diff
idiom lives in the ADR alone: Option B at `:60-66`, the Decision at `:90-104`. A story that cited
the guide for the regime would be citing a document for a rule it does not state, so US008 cites
both files, each for what it owns and neither for the other's.

**The gate's state, measured 09/09/2026 at `ff24084` on a clean tree.**

| Run                | Read                          | Tokens checked / tested as paths | Verdict                                                                                                                                                  |
| ------------------ | ----------------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Whole tree         | 1035 files, 91 exempt by rule | 38099 / 6791                     | exit 1 — **253 citation(s) do not resolve**: 135 `[instance citation]`, 106 `[dangling path]`, 12 `[template-only citation]`, no `[plan prefix]` finding |
| `--path code/docs` | 174 files, 4 exempt by rule   | 6803 / 1353                      | exit 0 — **Clean — every citation resolves.**                                                                                                            |

The 253 are 243 citations from `project-management/src/` (74 from sprint records, 44 from story
plans, 44 from sprint plans, 32 from QA plans, 32 from stories, 12 from ADRs, 5 from security
artefacts), 9 from `GAPS.md` (`:418-456` at `ff24084`; the register's own 09/09/2026 correction to
that entry's Summary sits above the last of them) and 1 from
`how-to/src/TEMPLATE-GUIDE/10-FIRST-FEATURE.md:130`. **None sits under `code/docs/`.** The count
was 22 when the baseline record was written on 02/09/2026
(`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md:37`);
it is 253 now, more than eleven times that, and the detector itself moved on 08/09/2026
(`project-management/src/15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`), so
a whole-tree figure is comparable only under one detector — the reason
`project-management/src/02-STORIES/US007.md` records each baseline's detector by content hash.

**Nine of the 253 are `GAPS.md`'s own**, every one a `[template-only citation]` against a
`project-management/src/` artefact the register names by full path and without the
`<!-- doc-references: template-only -->` marker. US008 adds two rows to that register — the
duplicated settings block, and the advisory the update script never shows — and both carry the
marker on every per-project path they cite, so the register's count does not move: measured
09/09/2026 with both rows on disk, `--path GAPS.md` reports the same nine, none of them in the new
rows. The 02/09/2026 entry in `GAPS.md` is that defect's own record.

**Two precedents for citing the binding record without touching it.**
`project-management/src/02-STORIES/US006.md:329-332` carries it as a plain Decisions bullet — "it
binds every story in the backlog, not US003 alone" — and its Verification Checks (`:981-991`) name
the regime as contingent on US004, recording the whole-tree figure beside the count on the story
file itself. `project-management/src/02-STORIES/US007.md:269-273` does the same — "binds this
story, not only US003" — and its criterion (`:1231-1235`) reads the diff by identity under a
recorded detector hash. Neither amends the record. That is the shape this one takes.

## Options considered

### Option A — the whole-tree baseline-and-diff, as the binding record prescribes

- **Summary:** capture the 253 by identity before the first edit; at close, diff; the criterion is
  no new finding attributable to a shipped file US008 edits.
- **Pros:** the rule as written, with no exception to argue. The method US003, US006 and US007
  used.
- **Cons:** for US008 the diff is over 253 findings, none of which sits in the population the
  shipped edits land in — so the discriminating power over the five files is bought by a person
  reading 253 lines twice. The close-run delta is a fact about the index and not about the
  edits — empty with the story's PM artefacts tracked, a non-empty block of
  `[template-only citation]` with them untracked, measured both ways on 09/09/2026 — so the criterion is not "empty diff"
  but "state the index and classify each new line", which is the exercise the record's own con
  warns "a new finding can hide inside" — and it is more than eleven times larger than the
  set that con was priced against. The success line at the end is a person's, not the gate's:
  Section 6 asks what ran to earn it, and the answer is "someone compared two lists".

### Option B — the scoped run is the criterion (the decision)

- **Summary:** `bash code/src/scripts/audits/doc-references.sh --path code/docs` exits 0 at close
  and prints "Clean — every citation resolves." — read as a plain pass, because it is one. The
  whole-tree run is still executed, before the first edit and at close, and its verdict is
  recorded and never reported as passing; it is not a criterion.
- **Pros:** the verdict is the script's, over exactly the population the shipped doctrine edits
  land in — the five files and every citer of them inside the tree; 174 files, 1353 path tests.
  `--path` is a sanctioned scope: the script normalises it to the repo-relative form and refuses
  one that is absent or outside the repository at exit 2. Nothing is diffed by hand and nothing is
  classified. A citation the sweep gets wrong reddens the run.
- **Cons:** scope-blind. It says nothing about a citer outside `code/docs/`, nothing about the PM
  artefacts, and nothing about the three shipped, scanned files US008 edits outside that scope.
  Each is named and bounded in the Decision; none is hidden by it. It is also a second idiom
  beside the diff — a reader of the story layer now meets three regimes, all dated.

### Option C — both as criteria

- **Summary:** the scoped run and the whole-tree identity diff must each pass.
- **Pros:** nothing uncovered.
- **Cons:** the second is never a pass while the baseline stands, and its delta turns on the index
  state rather than on the edits, so "no new finding" becomes "no new finding I did not expect" —
  Option A's classification exercise, duplicated beside a criterion that is already green. Two
  criteria for one gate, one always green and one always a judgement, is the arrangement under
  which the green one gets ticked and the other gets reasoned away. The whole-tree run belongs in
  the report with its delta explained by class and the index state named; it is not a pass/fail
  line.

### Option D — narrow the scope to the five files

- **Summary:** `--path` on each of the five; five runs, five verdicts.
- **Pros:** the smallest population, and each verdict names one file.
- **Cons:** it reads the five files' outbound citations and none of their inbound ones. The
  Browser Storage Policy is cited from `code/docs/api-design/AUTH-AND-ERRORS.md:27`,
  `code/docs/api-design/AUTH-STRATEGY.md:134` and `:178`, and indexed at
  `code/docs/SECURITY.md:23` and `code/docs/security/CONTEXT.md:13`. A directory scope reads those
  citers; a file scope does not. `code/docs` is the smallest scope that reads both directions.

### Option E — skip the whole-tree run

- **Summary:** the scoped run is the whole story, and the 253 is somebody else's problem.
- **Pros:** least work.
- **Cons:** it is what the binding record forbids in as many words. A story that prints one green
  line and no red one has reported the gate as passing while the baseline stands. `GAPS.md` is
  scanned and deliberately not exempt, US008 edits it, and whether the count moved is something
  only the run can say; a story that does not run the gate cannot say it.

## Decision

**We will take Option B. US008's citation criterion is the scoped run —
`bash code/src/scripts/audits/doc-references.sh --path code/docs`, exit 0, "Clean — every
citation resolves." — and the whole-tree run is executed, recorded, and never claimed.**

The deciding factor is Section 6's question. The scoped run's success line is earned by an
execution: the script read 174 files, tested 1353 paths over the population the shipped edits and
their citers sit in, and printed the verdict itself. The whole-tree diff's success line is earned
by a person, over 253 findings none of which sits in that population, with the discriminating part
of the work — telling an expected new line from a defect — done by eye. B keeps the gate's signal
for what US008 ships; A buries it under what US008 does not.

**This is an exception to the binding record's method, scoped to US008 — not a release from its
rule.** The rule's two obligations stand, and each is met in a stated way:

- **No new unresolved citation from a shipped file US008 edits.** The scoped run proves it for
  `code/docs/`. Three shipped, scanned files sit outside that scope and are edited by this story —
  `code/src/scripts/audits/negative-space.sh`, `code/src/django/config/settings/CONTEXT.md` and
  `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` — and each takes the same idiom: one
  `--path <file>` run, exit 0. Each is Clean today (36, 61 and 190 tokens; 0, 2 and 10 tested as
  paths), so a plain pass is available and honest for each. **That per-file criterion is derived
  in this record, not settled at the grilling pass**: Q6 named a scope and the reason for it — the
  population the shipped edits land in — and the binding record's first obligation reaches these
  three, so they take the same shape rather than a second one. No other edit qualifies: the three
  settings modules ship but are not scanned (`candidates()` reads `.md` and `.sh` only), and
  `copier.yml` is not scanned either and does not ship — `_exclude` names `/copier.yml`; the new migration script is a `.sh` that `is_exempt()` excludes at its `.copier/*` arm
  and that copier removes at generation; the map cell sits in a tree `is_exempt()` names and
  copier empties; and `GAPS.md`, which the script scans and reads as shipped because its seed
  lands at the same path downstream, is red today at nine and stays on the binding record's own
  diff — the same nine before and after this story's two rows, measured 09/09/2026, none of them
  in the rows. A criterion that read the doctrine and not the gate script would verify the sweep
  and not the story.
- **Never reported as passing while the baseline stands.** The whole-tree run is executed before
  the first edit and at close, at a named HEAD, with the detector's `git hash-object` beside each
  figure, and both figures — count, exit code, breakdown by class — are written into the story's
  Verification Checks. The delta is attributed by citer and explained by class. It is a report,
  not a criterion; a differing detector hash is reported as detector-confounded, not as US008's.

**What the exception does not do is generalise.** A scoped plain pass is possible for US008 because
every shipped, scanned file it edits sits in a directory or file the script reports Clean on today
— `GAPS.md` apart, which stays on the binding record's diff and is moved by nothing here. A story
whose shipped edits land where the script is red today has no clean scope to run and stays on the
diff. US008's own PM artefacts — the story file and these two records — are neither case: none
ships, so the obligation does not reach them, and the gate reads them only while they are
untracked (`build_template_only` takes its copier-excluded set from `git ls-files`), which is why
every whole-tree figure here is recorded with the index state beside it. Making this the
backlog's rule would be a second decision about a file whose ownership `S-06` exists to settle,
and the record that retires the diff is US004's to write.

**Bound: void the moment US008 moves, renames or deletes a file.** The gate resolves a cited path
after peeling a line anchor (`:N`, `:N-M`, `:N:M`) and never resolves a heading fragment, so an
in-place edit inside `code/docs/` cannot redden a citer outside it — only a file that goes can.
US008 edits five files in place and adds none under `code/docs/`; if that changes, the binding
record's method applies as written. What the scoped run also does not catch is the converse: a
line anchor that drifts. The same peel means a citation into a section US008 rewrites in place
still resolves while pointing at the wrong lines, so where this record and the story cite an
edited file they cite the section name or say which HEAD the anchor was read at. The two anchors
kept here (`code/docs/api-design/AUTH-STRATEGY.md:134` and `:178`, read at `ff24084`) sit below
the one line US008 edits in that file, the table row at `:67`, whose cell is replaced in place and
moves nothing beneath it.

## Consequences

- **Positive:** every success line the story prints traces to a run. The criterion is one command
  whose output is quoted, not a comparison whose method is trusted.
- **Positive:** the whole-tree figure at close is expected to be **253 under the same detector,
  not higher**, and that is stated before the first edit. Nine of the 253 are `GAPS.md`'s own
  because those nine carry no marker; US008's two new rows carry
  `<!-- doc-references: template-only -->` on every per-project path they cite and add nothing —
  measured 09/09/2026 with both rows on disk and the story's three PM artefacts in the index: 253,
  the same 135 / 106 / 12 split, `--path GAPS.md` still exactly nine. The only rise this story can
  produce belongs to the index, not to the edits: while the story file and its two records are
  untracked the gate reads them as shipped and reports every per-project path they cite, and the
  same three files in the index report nothing. The per-file counts are deliberately not pinned
  here. They move with every edit to the artefacts — measured three times on 09/09/2026 at three
  different values as this change was corrected, once rising because a sibling record's inert
  suppression markers were removed. What is stable is the mechanism: `build_template_only` reads
  `git ls-files`, so an unindexed file is not recognised as copier-excluded, `file_ships` stays
  true, and its citations are reported. That is the defect US004 removes, so the close figure is
  recorded with the index state beside it, and a reviewer who reads a rise as a regression is
  reading a number this record has already explained. `--path code/docs` is untouched by all of it.
- **Negative / trade-off:** scope-blindness, accepted and bounded. The scoped run reads citers
  under `code/docs/` and nothing else; the three outside files take per-file runs; the PM
  artefacts are read by nothing that can pass, which is the defect `GAPS.md`'s 02/09/2026 entry
  records and not this story's to fix.
- **Negative / trade-off:** the gate reads a path, not a name. A bare `CRYPTO-AND-DATA.md` — the
  form the subdomain-routing map uses — carries no slash, so Check 1 never tests it and neither
  scope catches it (the guard is recorded at
  `project-management/src/15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md:40-43`).
  The sweep writes the full path, `code/docs/security/CRYPTO-AND-DATA.md`, as a rule in the story;
  the gate does not prove it.
- **Negative / trade-off:** three regimes now sit in the story layer — US001's flat must-pass, the
  diff, and this scoped pass. Accepted: each is dated and argued in its own record, and all three
  collapse to a plain pass when US004 lands and the whole-tree run exits 0, which is the only fix
  and is not US008's.
- **Negative / trade-off:** nothing enforces this. Like the record it excepts from, it is a
  criterion in the story and a check at QA. The scoped run is one command; the discipline is that
  it is run at close, not before, and quoted rather than summarised.
- **Follow-on:** **retirement.** This exception dies with the rule it excepts from. When US004
  lands and the whole-tree gate goes green, the plain whole-tree pass is correct again, the scope
  is pointless, and the record that supersedes the binding record marks this one `Superseded` in
  the same change, by full filename on both. An exception cannot outlive its rule.
- **Follow-on:** `code/docs/GATE-REPORTING.md` is not edited. Whether the inherited-red idiom
  should have a guide home is a question for the story that retires it; until then its home is the
  ADR, and US008 cites it there.
- **Follow-on:** the story's Verification Checks carry this shape and no other: the whole-tree
  figure before the first edit (HEAD, detector hash, count, classes); the scoped run at close, as
  the criterion; the three per-file runs at close; the whole-tree figure at close with its delta
  attributed by citer and class. `GAPS.md` gains nothing from this record.
