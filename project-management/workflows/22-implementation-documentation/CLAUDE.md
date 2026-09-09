@./CONTEXT.md

# CLAUDE.md — workflows/22-implementation-documentation/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, when-to-run, inputs, outputs, quality gates — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The documentation closeout after code is built — update every touched `CONTEXT.md`/`CLAUDE.md`
and refresh the code-review-graph (the documentation hard gate), write the
IMPLEMENTATION-side record for each design/compliance spec that applied to the story, write
the story's two `src/18-TESTS/` test records, and record its findings in `src/20-FINDINGS/`,
before the PR is raised in `23-pr-and-review`.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `doc-writer` skill (Opus). It runs
  after the code workflows (`19-backend-code`, `20-api-code`, `21-frontend-code`) and
  before `23-pr-and-review`. Read `code/docs/CODE-REVIEW-GRAPH.md` before touching docs.
  Each record is copied from its `.../IMPLEMENTATION/US000-TEMPLATE.md`; where deeper
  verification is needed, the discipline skill (`gdpr-mechanics`, `security`, `qa-tester`,
  `seo`, `planner`) may be loaded against the story's already-approved `PLANNING/` artefact.
- **Model:** Opus throughout — this is a documentation/mechanical closeout that records
  what shipped against approved plans, not a design grill. No Fable pass here.
- **Concrete steps:** identify which specs applied to the story → copy each applicable
  `IMPLEMENTATION/` template, noting what was built vs the plan and any deviation → copy both
  `src/18-TESTS/US000-…` templates to `US###-…`, run the suites through
  `code/src/scripts/tests/**/*.sh` then `test-record.sh US###` for the generated block, and walk
  the manual guide marking every row → write the findings record from
  `src/20-FINDINGS/FINDING-US000-TEMPLATE.md` → update the touched
  `CONTEXT.md`/`CLAUDE.md` across every layer → refresh the code-review-graph → confirm
  every record is cross-linked to its `US###` → satisfy `CHECKLIST.md`.
- **Definition of done:** every applicable IMPLEMENTATION record written from template and
  linked to `US###`; no spec left with a `PLANNING/` record but no `IMPLEMENTATION/`
  record; both `src/18-TESTS/` records present, the generated block regenerated against the
  last suite run and every manual row marked `Pass` or `Fail`; a findings record written
  (even if `Nothing found`) with every finding carrying a
  retrofit cost and a disposition; touched docs complete and the graph refreshed; British
  English; DD/MM/YYYY.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`skills`/`model` frontmatter — read it first (see
  `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Documentation is a hard gate** — implementation docs and every touched
  `CONTEXT.md`/`CLAUDE.md` must be complete, and the code-review-graph refreshed, **before
  any commit**. Not optional.
- **This workflow writes the records; `23-pr-and-review` only verifies them** — do not
  defer record-writing to the PR workflow. **That includes the `src/18-TESTS/` pair**, which is
  written here for every story and merely checked there.
- **The test pair is unconditional and has no `PLANNING/` side** — it is not part of the
  no-orphaned-plan check, and a story with no automated suite still records that fact rather than
  skipping the file. Its rules — the generated-block ban, the overwrite-on-re-run rule, the
  `{AREA}-{NN}` row IDs and the browser-tool contract — belong to
  `project-management/src/18-TESTS/CLAUDE.md`; route there rather than restating them.
- **Close a plan gap only with evidence** — never mark a GDPR, security, QA, SEO, or API
  task done without pointing at the shipped code; keep every claim consistent with
  `code/docs/SECURITY.md`.
- **This workflow is the only place `GAPS.md` and `DEFERRED.md` close.** `01-feature-map` claims
  entries on the feature map; the close happens here, against shipped code. A claim the story did
  not in fact retire stays open and the reason becomes a finding.
- **Findings are recorded, never fixed here** — the record states the smallest fix; the fix
  lands in a later story, `src/21-BUGS/`, or `src/22-REFACTORING/`. Where a migration, index,
  or model carries no explanation for its shape, **flag the absence rather than inventing the
  reasoning**, and mark anything inferred `TODO(verify)`.
- **Expensive-to-retrofit findings are escalated separately** — schema shape, a missing scope
  column, absent database-level constraints. They must not sit as one row in a long table.
- **Per story** — one record per applicable spec per `US###`, and one findings record; do not
  batch stories. A story that surfaces no findings still gets a record.
- Documentation workflow — no code here. Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the per-story IMPLEMENTATION records under
  `src/09-GDPR/IMPLEMENTATION/`, `src/10-SECURITY/<CATEGORY>/IMPLEMENTATION/`,
  `src/11-QA/IMPLEMENTATION/`, `src/12-SEO/IMPLEMENTATION/`,
  `src/13-API-DESIGN/IMPLEMENTATION/`, each linked to its `US###`; the per-story findings
  record under `src/20-FINDINGS/`; and, under `src/18-TESTS/`, the whole of
  `US###-MANUAL-TESTING.md` plus everything in `US###-TEST-STATUS.md` outside its generated block.
- **Generated:** the code-review-graph — refreshed, never hand-edited; and
  `US###-TEST-STATUS.md`'s `BEGIN GENERATED: test-record` block, written by
  `code/src/scripts/tests/test-record.sh` after the suites run, green or red.
- Findings `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`;
  records `<TYPE>-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (descriptor SCREAMING-KEBAB-CASE);
  test records `US###-TEST-STATUS.md` and `US###-MANUAL-TESTING.md`, no descriptor and no date
  in the name (`../../src/18-TESTS/CLAUDE.md` owns that pattern and the reason for it);
  documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.

<!-- UPDATED 09/09/2026. This workflow now writes the two `src/18-TESTS/` records, settled by the
     grilling pass of 09/09/2026 and argued here rather than in an ADR, because
     `../../src/15-DECISIONS/` keys every ADR to a driving story and this ships as template
     maintenance under no US###.

     THE OWNERSHIP FIX. Three files gave three answers and the records were therefore never
     written by anyone:

       1. this file — claimed the workflow writes the IMPLEMENTATION-side record for every
          design/compliance spec, while `STEPS.md` Step 3's discipline table listed only GDPR,
          Security, QA, SEO and API design, so 18-TESTS fell outside the only enumeration;
       2. `../23-pr-and-review/STEPS.md` — listed both test files in its "Write (PR-stage
          records)" table, claiming authorship at the PR stage;
       3. `../../src/18-TESTS/CLAUDE.md` — said the records were updated as part of the code
          workflows and finalised in `23-pr-and-review`, naming a third writer again.

     Zero records had ever been written. 22 WRITES; 23 VERIFIES. That is the whole rule, and it
     matches how every other implementation record already flows.

     WHY ITS OWN STEP AND NOT A ROW IN STEP 3. Step 3 is conditional — its table maps a story's
     `PLANNING/` artefacts to their `IMPLEMENTATION/` records, and Steps 1 and 8 both police the
     no-orphaned-plan invariant across exactly that set. The test pair has no `PLANNING/` side
     and is written for every story regardless, so a row in that table would have made an
     unconditional obligation look conditional and put a plan-less record inside a plan-to-record
     check. It sits at Step 4 instead, beside the other always-written record (findings) and
     ahead of it, because a red suite or a failed manual row is a findings input. The old Steps
     4-8 became 5-9. -->
