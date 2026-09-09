@./CONTEXT.md

# CLAUDE.md — src/18-TESTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(template list, naming, record-tier position — imported above) → this file.

## Purpose (one line)

The per-story record of tests **executed** — one `US###-TEST-STATUS.md` carrying what each
automated test checks and whether it passed, and one `US###-MANUAL-TESTING.md` carrying the
journey a tester or Claude Chrome walked and whether each step passed.

## How to work here

- **Routing:** both records are written by `project-management/workflows/22-implementation-documentation/`,
  the documentation closeout, and only **verified** by `23-pr-and-review/`. The automated figures
  come from suites run via `code/src/scripts/tests/**/*.sh` — never invoke `pytest`, `bru` or
  `playwright` directly.
- **Model:** **Opus** for the whole job. These are mechanical implementation records, not
  planning artefacts.
- **Concrete steps:** identify the `US###` → copy both `US000-…` templates to `US###-…` →
  run the suites, then `bash code/src/scripts/tests/test-record.sh US###` to write the generated
  block → walk the manual journeys and mark each row → fill the hand-written sections → link the
  story and its plan → append the update date.
- **Definition of done:** both files present, every manual row marked `Pass` or `Fail`, every
  `Fail` carrying a reason and a destination, the generated block regenerated against the last
  suite run, story and story-plan cross-linked, British English, dates DD/MM/YYYY.

### The three-record boundary

Three folders look alike and answer different questions. Keep them apart:

| Folder                            | Answers                                     |
| --------------------------------- | ------------------------------------------- |
| `../11-QA/`                       | Were the **specified scenarios** met?       |
| `../05-USER-FLOW/IMPLEMENTATION/` | Does the **flow exist** as it was designed? |
| **here**                          | Did **executing the tests** pass?           |

`11-QA/PLANNING/` owns the `HP-nn` / `ES-nn` / `EC-nn` / `PA-nn` scenario IDs and
`11-QA/IMPLEMENTATION/` verifies them; the manual guide **cites** those IDs in its `QA` column and
never redefines them. Its own row IDs are `{AREA}-{NN}`, reusing the step numbers of
`../05-USER-FLOW/CONSOLIDATED-IDEAS/USER-FLOW-CONSOLIDATED-{AREA}.md`.

**Accessibility evidence has three homes and they follow the same split** — the question decides,
not the subject:

| Evidence                                                      | Home                                                   |
| ------------------------------------------------------------- | ------------------------------------------------------ |
| The axe gate's own pass or fail                               | the generated block of `US###-TEST-STATUS.md`          |
| A check a person ran — focus order, contrast, a screen reader | the accessibility journey in `US###-MANUAL-TESTING.md` |
| Whether the story met the accessibility it was specified      | `../11-QA/IMPLEMENTATION/` Section 7                   |

A WCAG failure found while walking a journey is a `Fail` on the row that found it, routed like any
other; it is not moved into Section 7, which records what was **asked for**, not what was run.

### Running the manual guide in the browser

The guide is written so a human **or** Claude Chrome can follow it. For an agent run:

- **Load the tool schemas in one `ToolSearch` call**, never one per tool. Start with
  `tabs_context_mcp`, `tabs_create_mcp`, `navigate`, `read_page`, `computer`, `tabs_close_mcp`;
  add `form_input` where the journey submits a form.
- **Call `tabs_context_mcp` first and create a new tab.** Never reuse a tab ID from another
  session, and never work in a tab <%DEVELOPER_NAME%> did not offer.
- **Resolve controls by their visible or accessible name**, via `read_page` or `find` — the rows
  name what a person sees precisely so the walk does not depend on markup. A control that cannot
  be found by name is a WCAG 2.2 AA failure: record it as one rather than reaching for a selector.
- **Never trigger an alert, confirm, or other modal dialog.** It blocks every subsequent command
  and the run cannot recover without a human dismissing it. Warn before touching a control that
  might raise one.
- **Mark each row as you go**, `Pass` or `Fail` with the reason. An empty `Result` means the step
  was not run — it is never a pass.
- **Stop and ask after two or three failed attempts** at the same step, or on any unexpected
  state. A blocked walk reported honestly is worth more than a guessed row.
- Optionally record the walk with `gif_creator`, named for the journey.

## Guardrails

- **Never hand-edit between `<!-- BEGIN GENERATED: test-record -->` and `<!-- END GENERATED -->`.**
  The next run of `test-record.sh` discards it without warning. Corrections belong in the test, or
  in Section 3.
- **A re-run overwrites.** One current state per story; git holds the history. Never append a
  dated run block or a per-run column.
- **Documentation only** — a record of outcomes, never test code. Tests live under
  `code/src/django/**/tests/` and `code/src/tests/` (Bruno); this folder points at them.
- **No secrets, tokens, real credentials, or personal data** — seeded fixtures via the project
  scripts, never live values, and never a real value pasted into a Notes cell.
- **Flat folder** — every file is `US###-TEST-STATUS.md` or `US###-MANUAL-TESTING.md` at the root,
  plus the two `US000-…` templates. No sub-folders, no other document types.
- **Keep the pair honest** — a green `TEST-STATUS` beside a failing manual row is a missing test,
  not a passing story. Never record a pass the suites or the walk do not support, and never treat
  a short generated table as coverage without checking `audits/story-markers.sh` first.

## Output & naming

- **Hand-written:** both `.md` files per story, bar the generated block — the manual guide
  entirely, and the automated record's Sections 2 to 4.
- **Generated:** `US###-TEST-STATUS.md` Section 1, written by
  `code/src/scripts/tests/test-record.sh` from the suites' JUnit XML, Bruno JSON, axe JSON and
  `coverage.xml`. Never hand-edited.
- Files strictly `US###-TEST-STATUS.md` and `US###-MANUAL-TESTING.md` — `US` + zero-padded
  three-digit story number; dates DD/MM/YYYY.

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
