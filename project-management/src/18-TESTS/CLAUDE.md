@./CONTEXT.md

# CLAUDE.md — src/18-TESTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the two sub-folders, why they split, record-tier position — imported above) → this file → the
target sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The per-story test record store — `MANUAL/US###-MANUAL-TESTING.md`, the journey guide authored
from the specs before code and walked after it, and `AUTOMATED/US###-TEST-STATUS.md`, what each
automated test checks and whether it passed.

## How to work here

- **Routing:** pick the record, then work from that sub-folder's pair — `MANUAL/CLAUDE.md` owns
  every rule of the manual guide, `AUTOMATED/CLAUDE.md` every rule of the automated record. This
  file owns only what spans both: the lifecycle and the three-record boundary below, and the
  guardrails. Suites run through `code/src/scripts/tests/**/*.sh` — never `pytest`, `bru` or
  `playwright` directly.
- **Model:** **Opus** for the whole job — authoring a guide from the specs is judgement; writing
  the automated record and marking a walked row are mechanical touches.
- **Concrete steps:** find the stage in _The record lifecycle_ → run that workflow step → follow
  the sub-folder `CLAUDE.md` of the record it touches.
- **Definition of done:** each sub-folder's own. Across both, by the PR a story has **both**
  records, every manual row marked, the generated block current against the last suite run, and
  each record cross-linked to the other, to the story and to its plan.

### The record lifecycle

Which workflow touches which record, and when. The PM workflows live under
`project-management/workflows/`; a stage not listed here does not write to this folder.

| Stage       | Workflow step                                         | `MANUAL/US###-MANUAL-TESTING.md`                                          | `AUTOMATED/US###-TEST-STATUS.md`                          |
| ----------- | ----------------------------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------------- |
| Plan        | `17-story-plans` Step 7                               | **Authored** from the specs, every `Result` blank                         | —                                                         |
| Consolidate | `18-consolidate-design-work` Step 7                   | `Flow` column set; rows the consolidation invalidated corrected           | —                                                         |
| Build       | `code/workflows/01-implement-story`, from Step 1      | **Captures** filled under _Recorded during the build_ — no row touched    | —                                                         |
| Red         | `code/workflows/02-tdd-cycle` Phase 1 (`test-writer`) | **Read** — every row triaged automatable or manual-only; never edited     | —                                                         |
| Closeout    | `22-implementation-documentation` Step 4              | **Walked**, every row marked; a deliberate deviation amended with a trail | **Written** — generated block, then the hand-written rest |
| PR          | `23-pr-and-review` Step 6                             | **Verified**                                                              | **Verified**                                              |

The Red-phase triage — which rows become automated tests and which stay manual — belongs to the
`test-writer` skill, and its outcome is named in that skill's handoff rather than in the guide.
Every row is still walked — `MANUAL/CLAUDE.md` → _Walking and marking_. What the build may write,
and when: `MANUAL/CLAUDE.md` → _Recorded during the build_.

### The three-record boundary

Three folders look alike and answer different questions. Keep them apart:

| Folder                            | Answers                                     |
| --------------------------------- | ------------------------------------------- |
| `../11-QA/`                       | Were the **specified scenarios** met?       |
| `../05-USER-FLOW/IMPLEMENTATION/` | Does the **flow exist** as it was designed? |
| **here**                          | Did **executing the tests** pass?           |

Each record **cites** the identifiers the others own and redefines none of them: `11-QA/PLANNING/`
owns the `HP-nn` / `ES-nn` / `EC-nn` / `PA-nn` scenario IDs, `05-USER-FLOW/CONSOLIDATED-IDEAS/`
owns the flow step numbers, and the manual guide owns its own row IDs. How the guide cites the
first two: `MANUAL/CLAUDE.md` → _The Flow and QA columns_.

**Accessibility evidence has three homes and they follow the same split** — the question decides,
not the subject:

| Evidence                                                      | Home                                                          |
| ------------------------------------------------------------- | ------------------------------------------------------------- |
| The axe gate's own pass or fail                               | the generated block of `AUTOMATED/US###-TEST-STATUS.md`       |
| A check a person ran — focus order, contrast, a screen reader | the accessibility journey in `MANUAL/US###-MANUAL-TESTING.md` |
| Whether the story met the accessibility it was specified      | `../11-QA/IMPLEMENTATION/` Section 7                          |

A WCAG failure found while walking a journey is a `Fail` on the row that found it, routed like any
other; it is not moved into Section 7, which records what was **asked for**, not what was run.

## Guardrails

- **Each record in its own sub-folder** — the manual guide in `MANUAL/`, the automated record in
  `AUTOMATED/`. Nothing at this root but this pair; no third sub-folder, no other document types.
- **A re-run overwrites.** One current state per record per story; git holds the history. Never
  append a dated run block or a per-run column. A manual row's amendment trail is part of its
  current state, not a run log (`MANUAL/CLAUDE.md` → _Changing a row after authoring_).
- **Documentation only** — a record of intended and actual outcomes, never test code. Tests live
  under `code/src/django/**/tests/` and `code/src/tests/` (Bruno); this folder points at them.
- **No secrets, tokens, real credentials, or personal data** — seeded fixtures via the project
  scripts, never live values, and never a real value pasted into a Notes cell.
- **Keep the pair honest** — a green `TEST-STATUS` beside a failing manual row is a missing test,
  not a passing story. Never record a pass the suites or the walk do not support, and never treat
  a short generated table as coverage without checking `audits/story-markers.sh` first.

## Output & naming

- **This root holds only** `CONTEXT.md` and `CLAUDE.md`. What is hand-written, what is generated
  and each filename pattern belong to the record's sub-folder — `MANUAL/CLAUDE.md` and
  `AUTOMATED/CLAUDE.md` → _Output & naming_.
- Neither filename carries a descriptor or a date: each file is the one current state of its
  record for its story (Guardrails above). Dates inside them DD/MM/YYYY.

<!-- UPDATED 09/09/2026. Two decisions are argued here rather than in an ADR, because
     "../15-DECISIONS/" keys every record to a driving story and this change ships as template
     maintenance under no US###. Both were settled by the grilling pass of 09/09/2026.

     FIRST — the three-record boundary above. Before it, this folder's manual guide grouped its
     rows Happy path / Error states / Edge cases / Permission and security, which is the exact
     taxonomy "../11-QA/PLANNING/" defines and "../11-QA/IMPLEMENTATION/" verifies, under the
     exact same HP/ES/EC/PA IDs. Three files therefore carried the same four headings and none of
     them owned it. The split is by QUESTION, not by grouping: specified-and-met is 11-QA,
     exists-as-designed is 05-USER-FLOW, and executing-it-passed is here. That is why the rows
     regrouped by journey area and kept the scenario ID only as a citation.

     SECOND — a test declares the story it belongs to. The suites run whole-project and their
     report artefacts carry no story attribution, so a per-story record cannot be generated by
     filtering on a path or a branch diff: a path breaks the moment a story spans two apps, and a
     diff misses every test a later fix touches. A pytest test therefore carries
     @pytest.mark.story("US###"), inheritable from its class or module and repeatable where more
     than one story genuinely tests it; a Bruno request carries the same value in meta tags, read
     from the .bru source so one whole-collection run still feeds every story's record. The
     marker is deliberately NOT a hard gate — "code/src/scripts/audits/story-markers.sh" warns and
     exits 0 — because failing it would block every shared helper and all 50 tests that predate
     the convention. The cost of that choice is that an unmarked test is silently absent from a
     record, which is why Section 3 of the template tells the reader to run the audit before
     trusting a short table.

     The routing line above also changed: these records read "updated as part of the code
     workflows and finalised in 23-pr-and-review", while
     "../../workflows/22-implementation-documentation/CLAUDE.md" declared itself the writer of
     every implementation record and 23 the verifier, and 23's own STEPS.md listed both files in
     its Write table. Three files, three answers, and zero records ever written. 22 writes. -->

<!-- UPDATED 30/09/2026. The folder split into MANUAL/ and AUTOMATED/, and the manual guide's
     authorship moved from 22 to 17. Argued here rather than in an ADR for the reason the
     09/09/2026 comment above gives: "../15-DECISIONS/" keys every ADR to a driving story, and
     this ships as template maintenance under no US###. Settled by the grilling pass of
     30/09/2026.

     AUTHORSHIP MOVED TO 17. The 09/09/2026 design had 22 write both records after the code, and
     "../../workflows/22-implementation-documentation/STEPS.md" already named the risk: drafting
     the manual guide from the code and marking it afterwards "is the one way this record can
     lie". Walking rather than drafting was the weak defence against that. Authoring the guide
     from the specs before any code exists is the strong one, because a guide that predates the
     build cannot have been shaped by it. It is then an independent oracle; it can be a named
     input to the Red phase, where every automatable row becomes a test — which is what gives "a
     manual Fail beside a green suite is a missing test" its teeth — and 22 walks it rather than
     writes it. The automated record did not move: it records a suite run, and cannot exist
     before one.

     THE FLAT-FOLDER RULE WAS DROPPED. It read: every file is US###-TEST-STATUS.md or
     US###-MANUAL-TESTING.md at the root, plus the two US000 templates, no sub-folders. It held
     while one workflow wrote both records at one moment under one set of rules. With two authors
     at two stages the rules split as well — the generated-block ban concerns only the automated
     record; the row IDs, the Flow column, the walk contract and the amendment trail concern only
     the guide — and one CLAUDE.md carrying both was a file every reader had to filter. A
     sub-folder per record type gives each rule set one home. Filenames did not change, so a
     citation needed only its folder added, and the copier migration shipped with this change
     carries a generated project's existing records across.

     The row-ID reversal that authoring at 17 forced is argued where that rule now lives:
     "MANUAL/CLAUDE.md". -->
