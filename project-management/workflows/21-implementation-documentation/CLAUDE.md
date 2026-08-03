@./CONTEXT.md

# CLAUDE.md — workflows/21-implementation-documentation/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, when-to-run, inputs, outputs, quality gates — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The documentation closeout after code is built — update every touched `CONTEXT.md`/`CLAUDE.md`
and refresh the code-review-graph (the documentation hard gate), write the
IMPLEMENTATION-side record for each design/compliance spec that applied to the story, and
record the story's findings in `src/19-FINDINGS/`, before the PR is raised in
`22-pr-and-review`.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `doc-writer` agent (Opus). It runs
  after the code workflows (`18-backend-code`, `19-api-code`, `20-frontend-code`) and
  before `22-pr-and-review`. Read `code/docs/CODE-REVIEW-GRAPH.md` before touching docs.
  Each record is copied from its `.../IMPLEMENTATION/US000-TEMPLATE.md`; where deeper
  verification is needed, the discipline agent (`gdpr`, `security`, `qa-tester`, `seo`,
  `planner`) may be consulted against the story's already-approved `PLANNING/` artefact.
- **Model:** Opus throughout — this is a documentation/mechanical closeout that records
  what shipped against approved plans, not a design grill. No Fable pass here.
- **Concrete steps:** identify which specs applied to the story → copy each applicable
  `IMPLEMENTATION/` template, noting what was built vs the plan and any deviation → write
  the findings record from `src/19-FINDINGS/FINDING-US000-TEMPLATE.md` → update the touched
  `CONTEXT.md`/`CLAUDE.md` across every layer → refresh the code-review-graph → confirm
  every record is cross-linked to its `US###` → satisfy `CHECKLIST.md`.
- **Definition of done:** every applicable IMPLEMENTATION record written from template and
  linked to `US###`; no spec left with a `PLANNING/` record but no `IMPLEMENTATION/`
  record; a findings record written (even if `Nothing found`) with every finding carrying a
  retrofit cost and a disposition; touched docs complete and the graph refreshed; British
  English; DD/MM/YYYY.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`agent`/`skills`/`model` frontmatter — read it first (see
  `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Documentation is a hard gate** — implementation docs and every touched
  `CONTEXT.md`/`CLAUDE.md` must be complete, and the code-review-graph refreshed, **before
  any commit**. Not optional.
- **This workflow writes the records; `22-pr-and-review` only verifies them** — do not
  defer record-writing to the PR workflow.
- **Close a plan gap only with evidence** — never mark a GDPR, security, QA, SEO, or API
  task done without pointing at the shipped code; keep every claim consistent with
  `code/docs/SECURITY.md`.
- **This workflow is the only place `GAPS.md` and `DEFERRED.md` close.** `01-feature` claims
  entries on the feature map; the close happens here, against shipped code. A claim the story did
  not in fact retire stays open and the reason becomes a finding.
- **Findings are recorded, never fixed here** — the record states the smallest fix; the fix
  lands in a later story, `src/20-BUGS/`, or `src/21-REFACTORING/`. Where a migration, index,
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
  `src/13-API-DESIGN/IMPLEMENTATION/`, each linked to its `US###`; and the per-story findings
  record under `src/19-FINDINGS/`.
- **Generated:** the code-review-graph — refreshed, never hand-edited.
- Findings `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`;
  records `<TYPE>-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (descriptor SCREAMING-KEBAB-CASE);
  documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
