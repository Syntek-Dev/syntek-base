@./CONTEXT.md

# CLAUDE.md — src/18-TESTS/MANUAL/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `../CLAUDE.md` (the record lifecycle,
the three-record boundary, the guardrails both records share) → this folder's `CONTEXT.md`
(what a guide holds and its seven columns — imported above) → this file.

## Purpose (one line)

The per-story manual testing guide — authored from the specs before code, walked and marked after
it — and the one home of every rule that governs it.

## How to work here

- **Routing:** authored by `project-management/workflows/17-story-plans/` Step 7.2, driven by the
  `planner` skill; its `Flow` column set by `18-consolidate-design-work/` Step 7; read at the Red
  phase by `test-writer`; its build captures filled during `code/workflows/01-implement-story`;
  walked and marked by `22-implementation-documentation/` Step 4; verified by `23-pr-and-review/`
  Step 6. The stage table: `../CLAUDE.md` → _The record lifecycle_.
- **Model:** Opus throughout — writing rows from the specs, and deciding whether a departure was
  deliberate, are judgement; marking a walked row is a mechanical touch.
- **Concrete steps — authoring:** copy `US000-MANUAL-TESTING.md` → `US###-MANUAL-TESTING.md` →
  read the inputs `17-story-plans` Step 7.2 names → fill the header and preconditions → a slot
  under _Recorded during the build_ for every capture a spec requires → one section per journey
  area, each row given its ID, Action, Expected outcome and `QA` citation, `Flow` as `—`, `Result`
  blank → raise every row the records cannot decide → link the story and the plan.
- **Concrete steps — the build:** fill each _Recorded during the build_ slot at the moment it
  names, and touch nothing else in the file.
- **Concrete steps — walking:** open the story's guide → walk each section in order, marking each
  row as it is executed → change a row only per _Changing a row after authoring_ → fill
  _Failures_ and the sign-off → set the header status and date.
- **Definition of done — authored:** every row traced to a spec named on the _Authored from_ line
  or to a recorded answer, every `Result` blank, every QA-plan scenario exercised or its absence
  explained, no row guessed — a row still undecided carries its question. **Walked:** every row
  but a retired stub marked `Pass` or `Fail`, every `Fail` with a reason and a destination, every
  changed row carrying its trail (and, at the walk, its finding), the sign-off complete. British
  English and DD/MM/YYYY throughout.

### Authoring — from the specs, never from the code

- **A guide is authored at `17-story-plans` Step 7.2, from the specification artefacts that step
  names, and from nothing else** — never from code, a branch or a prototype. A guide drafted from
  the build can only confirm the build; it is an oracle only because it predates it. The header's
  _Authored from_ line lists the artefacts actually read.
- **A guide missing when `22` begins is authored there first, exactly as at 17, before it is
  walked** — from the specs, never from the code now in front of you. When its absence is also a
  finding: `22-implementation-documentation` Step 4.
- **The story's _QA Acceptance Criteria — Manual_ is the bar the guide is judged against**: each
  criterion there is met by at least one row. Every `HP` / `ES` / `EC` / `PA` scenario in the QA
  plan is exercised by at least one row, or the _Out of scope_ line names it and says why a person
  cannot walk it.
- **A row the records cannot decide is a question, never a guess.** Where no spec states the
  expected outcome, or the set-up the row depends on, put it to <%DEVELOPER_NAME%> through
  `.claude/skills/grill-with-docs`, which records the answer in the artefact that should have held
  it, then write the row from that. **Until it is answered**, the question is listed under
  _Preconditions_ → _Open questions_ and every row it holds carries `Awaiting answer — <question>`
  in `Notes`. Such a row is not yet an oracle: `test-writer` raises it rather than testing to it,
  and the walk does not mark it until the answer is in and the row rewritten from it.
- **`Result` is blank on every row**, and `Notes` is empty unless the row awaits an answer or a
  walker needs something the row cannot say. A blank `Result` means not yet walked.
- **One `###` section per journey area**, its rows in the order a person moves through the product
  — never grouped by test category. The header's _Surface_ (Browser / CLI / Gate / API) decides
  the row vocabulary. The permission, accessibility and responsive journeys stay wherever the
  surface has them; on a surface that has none — responsive behaviour on a CLI — the section is
  dropped and named under _Out of scope_ with its reason.
- **Actions name what a person sees, never a selector** — "Click the **Book now** button in the
  hero", not `[data-testid="book-now"]`. On a CLI, Gate or API surface the action is the
  `code/src/scripts/**/*.sh` command a person runs, and the outcome is what it prints or returns.

### Row IDs

- **`{AREA}-{NN}`** — `{AREA}` a short SCREAMING code for the journey area (`SIGNUP`), `{NN}` two
  digits from `01`, in walk order as first authored. `{AREA}` need not match a consolidated flow's
  name; the `Flow` column carries that link.
- **Permanent.** Assigned at authoring, never renumbered, never reused. A row added later takes
  the next unused `{NN}` in its area wherever it sits in the table — walk order is row order, not
  number order.
- **A row dropped before the walk is retired, not deleted.** It stays as a stub —
  `Retired DD/MM/YYYY — <reason>` in _Action_ and `—` in every other cell, `Result` included — so
  its number can never be taken again, and it is not walked. From the walk on, a row is amended,
  never retired or deleted.
- **They are cited** — by the QA implementation record as manual evidence, by the guide's own
  _Failures_ table, by findings and bug reports — so a renumber silently re-points every citation.

### The Flow and QA columns

Both **cite** an identifier another record owns. Neither keys the row, and neither identifier is
redefined here.

- **`Flow`** — the consolidated user-flow step the row exercises, written `<AREA> <step>`: the
  `<AREA>` of `../../05-USER-FLOW/CONSOLIDATED-IDEAS/USER-FLOW-CONSOLIDATED-<AREA>.md` and the
  step number from its journey table (`SIGN-UP 3`; a comma list where the row crosses a
  transition). `—` at authoring, because no consolidated flow exists before `18`, and wherever the
  row maps to no step. `18-consolidate-design-work` Step 7 sets it; a flow step renumbered later
  is re-cited in the same change.
- **`QA`** — the scenario the row exercises from `../../11-QA/PLANNING/QA-PLAN-US###-*.md`
  (`HP-nn`, `ES-nn`, `EC-nn`, `PA-nn`), or `—`. An untraced row is not a defect: it is a scenario
  the plan did not foresee, recorded at the walk in the QA implementation record under _New edge
  cases discovered_.

### Recorded during the build

Some specs require this file to hold evidence that is not a step — a baseline or an inventory
captured before the first edit, a figure measured once the change is in, output a walked row is
asked to keep. A row cannot carry it: a row run before the first edit could not be walked at `22`.

- **One section, `## Recorded during the build`**, between _Preconditions_ and _Journeys_. It is
  authored at `17` like the rest — one slot per capture a spec requires, each naming the spec,
  what is captured and when — with every value blank.
- **Each slot is filled at the moment it names, by whoever works then** — the implementer before
  the first edit and during the build (`code/workflows/01-implement-story` Step 1), the walker at
  `22` for a slot that pairs a walk-time reading with a build-time one. A capture missed at its
  moment is recorded as missed, never reconstructed, and no row that reads it can be marked
  `Pass`.
- **It has no `Result` and is never walked.** The rows read it — "compare with the baseline under
  _Recorded during the build_" — and it is the row that is marked. It is the only part of the
  guide the build writes.

### Walking and marking

- **Every row is walked at `22`**, a retired stub excepted, including the rows `test-writer`
  turned into automated tests — a green test does not mark a row.
- **Mark each row as it is executed**, `Pass` or `Fail` — never afterwards from memory, from the
  code or from an earlier walk. An empty `Result` means the step was not run; it is never a pass.
- **A `Fail` carries its reason in `Notes` and a row in _Failures_** naming where it is routed,
  exactly as `../../20-FINDINGS/` routes a finding. A `Pass` leaves `Notes` alone unless a later
  tester needs something.
- A re-walk overwrites the `Result` cells — `../CLAUDE.md` → _Guardrails_.

### Changing a row after authoring

A changed row is corrected in place, keeps its ID, and **says why in its `Notes`**:

- **At consolidation (`18`, before code)** — where consolidation changed a shape the row
  asserted: `Corrected at consolidation DD/MM/YYYY — <consolidated artefact>`. `Result` stays
  blank.
- **At the walk (`22`)** — where the build **deliberately** departs from the row. Deliberate means
  a recorded decision someone can point to: a corrected plan, an ADR, or <%DEVELOPER_NAME%>'s
  confirmation. Amend the row, then walk it against the amended text. `Notes` carries the trail —
  `Amended DD/MM/YYYY — was: <old text>; why: <reason>; evidence: <path>; finding: F-0NN` — and
  the same amendment is recorded as a finding in `../../20-FINDINGS/`
  (`22-implementation-documentation` Step 5).
- **A departure with no decision behind it is not an amendment. It is a `Fail`.**

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
- **Mark each row as you go** — _Walking and marking_ above.
- **Stop and ask after two or three failed attempts** at the same step, or on any unexpected
  state. A blocked walk reported honestly is worth more than a guessed row.
- Optionally record the walk with `gif_creator`, named for the journey.

## Guardrails

- **Never rewrite a row to match the code.** A row changed without its trail — or, at the walk,
  without its finding — is a silent rewrite, and a guide rewritten to agree with the build has
  stopped testing it.
- **The build writes only _Recorded during the build_, and the Red phase reads the guide and
  never edits it.** `test-writer`'s triage of each row is named in that skill's handoff; the guide
  gains no column for it.
- Documentation only, no secrets and no personal data — `../CLAUDE.md` → _Guardrails_.

## Output & naming

- **Hand-written:** `US###-MANUAL-TESTING.md`, one per story, in four passes — the rows and the
  empty capture slots at `17`; the `Flow` cells at `18`; the build's captures during the build;
  and at `22` the `Result` and `Notes` cells, any walk-time capture, _Failures_ and the sign-off.
- **Template:** `US000-MANUAL-TESTING.md` — the copy source; never filled in, never deleted.
- **Generated:** none.
- `US###-MANUAL-TESTING.md` — `US` + the zero-padded three-digit story number, no descriptor and
  no date (`../CLAUDE.md` → _Output & naming_).

<!-- UPDATED 30/09/2026. This file was created when "../CLAUDE.md" split the folder, and every
     rule of the manual guide moved here from it. Two of those rules changed on the way. Both were
     settled by the grilling pass of 30/09/2026 and are argued here rather than in an ADR because
     "../../15-DECISIONS/" keys every ADR to a driving story, and this ships as template
     maintenance under no US###.

     ROW IDS ARE THE ROW'S OWN, AND THE FLOW STEP IS CITED. This REVERSES the 09/09/2026 rule —
     stated in the template's own 09/09/2026 comment and in
     "../../05-USER-FLOW/IMPLEMENTATION/CLAUDE.md" — that {NN} reuses the step number of the
     area's consolidated flow, so that one number named a flow step, its diagram node and the
     walked row. Two facts broke it. (a) The guide is now authored at 17-story-plans, and
     consolidation runs at 18-consolidate-design-work, once every story is planned: the number
     the rule keyed on does not exist when the row is written. (b) When this was decided,
     "../../05-USER-FLOW/" held no flows at all, only its templates, so every guide written or
     backfilled would have had nothing to key on. Keying on a number another stage owns would
     also have moved a row's ID whenever consolidation re-sequenced its journey, silently
     re-pointing every QA record, finding and bug report that cites the row. So the row owns a
     permanent ID, and the flow step becomes a citation in a Flow column of its own — exactly as
     the QA column already cites the HP/ES/EC/PA scenario IDs — which 18 sets and corrects.

     AN AMENDMENT CARRIES A TRAIL AND A FINDING. A guide written before the code will sometimes
     be wrong about the code for a good reason: the build took a decision the specs did not
     foresee. Rewriting the row to match is the one thing this guide exists to prevent — a record
     reshaped by the thing it checks — so the change is allowed only with its before-text, reason
     and evidence in Notes, and with a finding in 20-FINDINGS, where a spec that proved wrong
     becomes an input to the next plan. A departure nobody decided is not amended at all; it is
     a Fail.

     THE BUILD WRITES ONE SECTION. Added by the review of the same change. The accepted
     ADR-US003-CITATION-GATE-BASELINE-DIFF puts a baseline in this file "before editing begins",
     and several stories put inventories and read-across records here too — writes at neither
     17, 18 nor 22. The first backfilled guides met that three ways: a build section, an evidence
     section, and journey rows run before the first edit, which contradicted "every row is walked
     at 22". An ADR's decision text is not rewritten to suit a folder rule, so the rule took the
     write instead, bounded to one template-defined section with no Result: the rows stay the
     oracle and the build only records what they will be compared with. The same review made a
     dropped row a stub rather than a deletion, because "never reused" cannot hold once the
     highest-numbered row of an area leaves no trace. -->
