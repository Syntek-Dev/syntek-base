# Workflow 22 — Implementation Documentation

**Last Updated**: <%DATE%>

Documentation written after the PR is documentation written from memory. This closeout owns the
records, the findings and the graph refresh, and it sits before the PR so the hard gate is real
rather than aspirational.

## Directory Tree

```text
project-management/workflows/22-implementation-documentation/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (purpose, when to run, inputs, outputs)
└── STEPS.md                 ← ordered steps to execute
```

## Purpose

The documentation closeout after code is built. It runs **after** the code workflows
(`19-backend-code`, `20-api-code`, `21-frontend-code`) and **before** `23-pr-and-review`,
and carries three responsibilities:

1. **Developer docs + graph.** Update every `CONTEXT.md` and `CLAUDE.md` across each layer
   the implementation touched — this is the project's **documentation hard gate**: docs
   must be complete before any commit — then refresh the code-review-graph
   (`code-review-graph update`, or the `build_or_update_graph_tool` MCP tool) so the
   layered docs and the graph stay in lockstep.
2. **PM implementation records.** Write the IMPLEMENTATION-side record for each
   design/compliance spec that applied to the story — GDPR, security, QA, SEO, API — one
   per story, copied from its `US000-TEMPLATE.md` and closing the matching `PLANNING/`
   artefact with evidence of what was actually built and any deviation. **The two
   `src/18-TESTS/` records are part of this responsibility**, and are the one pair with no
   `PLANNING/` side to close. This workflow **writes** `AUTOMATED/US###-TEST-STATUS.md`, half of
   it generated from the suites' own report artefacts, and **walks**
   `MANUAL/US###-MANUAL-TESTING.md` — the guide `17-story-plans` authored from the specs before
   any code — marking every row step by step, by a tester or by Claude Chrome.
3. **Findings.** Write one `FINDING-US###-*.md` into `src/20-FINDINGS/` recording what
   shipping the story revealed about the project's standards — each divergence with its
   smallest fix, its retrofit cost, and a disposition. Findings are **recorded, never fixed
   here**; the rows marked `Next story` become inputs to the next story plan.

> **This workflow absorbs the implementation-record duty that used to live in
> `23-pr-and-review`.** `23-pr-and-review` now only **verifies** these records exist and
> are complete — it does not write them. That includes the automated test record and the walk of
> the manual testing guide; the guide itself is authored earlier, at `17-story-plans`.

## When to run

- All code phases for the story are complete: backend (`19-backend-code`), API
  (`20-api-code`), and frontend (`21-frontend-code`) as applicable.
- Before the PR is raised in `23-pr-and-review` — the records and docs are a merge gate.

## Inputs

- The user story (`src/02-STORIES/US###.md`) and its story plan (`src/17-STORY-PLANS/`).
- The story's manual testing guide (`src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md`), authored at
  `17-story-plans` and given its `Flow` column at `18-consolidate-design-work`.
- Every applicable `PLANNING/` artefact for the story: GDPR plan, security plans
  (threat model / assessment / audit / vulnerability), QA plan, SEO plan, API contract.
- The shipped code diff for the story, and the `CONTEXT.md`/`CLAUDE.md` pairs in each
  touched layer (`code/`, `how-to/`, `project-management/`).

## Outputs

- One IMPLEMENTATION record per applicable spec, filed under its `.../IMPLEMENTATION/`
  folder and cross-linked to the story `US###`.
- `src/18-TESTS/AUTOMATED/US###-TEST-STATUS.md`, written for every story whatever the suites
  returned, and `src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md` walked — every row marked, any
  deliberate departure amended with its trail and recorded as a finding.
- One findings record in `src/20-FINDINGS/`, written whether or not anything was found.
- Updated `CONTEXT.md`/`CLAUDE.md` (trees, `Last Updated` dates, new constraints) across
  every touched layer.
- A refreshed code-review-graph matching the updated docs.

## Key decisions

- **Which specs applied.** GDPR whenever the story processes personal data; security
  whenever it ships a security surface; QA always; SEO only when a public route is added
  or changed; API only when the Django Ninja API surface is added or changed.
- **Plan vs built.** Each record states what shipped against what was planned, and
  justifies any deviation with evidence rather than restating the plan.
- **No orphaned plan.** No spec may end with a `PLANNING/` artefact but no matching
  `IMPLEMENTATION/` record — the tiers mirror at both ends.
- **Cheap vs expensive to retrofit.** Every finding is classified. Schema shape, a missing
  scope column, and absent database-level constraints get materially costlier with each
  story that ships on top of them, and are escalated separately from cosmetic findings.

## Related workflows

- **Upstream:** `19-backend-code`, `20-api-code`, `21-frontend-code` — the code this
  workflow documents and records.
- **Context:** `15-decisions`, `16-sprint-plans`, `17-story-plans` — the decisions and
  plans whose implementation is recorded here, and the manual testing guide walked here.
- **Downstream:** `23-pr-and-review` — now only verifies these records; `24-release`.

## Cross-references

### Governing documents

- `code/docs/CODE-REVIEW-GRAPH.md` — the graph-refresh procedure the docs must stay in
  lockstep with; the documentation hard gate is non-negotiable (`.claude/CLAUDE.md` Section 6).

### Related reading

- `project-management/src/09-GDPR/IMPLEMENTATION/` — `GDPR-IMPL-US000-TEMPLATE.md`
- `project-management/src/10-SECURITY/` — post-build audit record under
  `AUDITS/IMPLEMENTATION/` (`AUDIT-IMPL-US000-TEMPLATE.md`), plus threat-model,
  assessment, and vulnerability closures per its `CLAUDE.md`
- `project-management/src/11-QA/IMPLEMENTATION/` — `QA-IMPL-US000-TEMPLATE.md`
- `project-management/src/12-SEO/IMPLEMENTATION/` — `SEO-IMPL-US000-TEMPLATE.md`
- `project-management/src/13-API-DESIGN/IMPLEMENTATION/` — `API-IMPL-US000-TEMPLATE.md`
- `project-management/src/18-TESTS/` — its `CLAUDE.md` owns the record lifecycle and the
  three-record boundary; `AUTOMATED/` holds `US000-TEST-STATUS.md` and its `CLAUDE.md` the
  generated-block rule; `MANUAL/` holds `US000-MANUAL-TESTING.md` and its `CLAUDE.md` the walk,
  the amendment trail and the browser-tool contract
- `project-management/src/20-FINDINGS/` — `FINDING-US000-TEMPLATE.md`; one record per story
- `code/docs/DATABASE.md` — the data-layer rules findings are assessed against
- `project-management/src/21-BUGS/` · `src/22-REFACTORING/` · `src/15-DECISIONS/` — where a
  finding is routed by its disposition
- `project-management/src/17-STORY-PLANS/` — the master plan the developer coded from, and
  the next plan a finding's `Next story` rows feed
- `project-management/workflows/23-pr-and-review/` — where these records are verified
