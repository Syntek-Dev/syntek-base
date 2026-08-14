# Workflow 21 — Implementation Documentation

**Last Updated**: <%DATE%>

Documentation written after the PR is documentation written from memory. This closeout owns the
records, the findings and the graph refresh, and it sits before the PR so the hard gate is real
rather than aspirational.

## Directory Tree

```text
project-management/workflows/21-implementation-documentation/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (purpose, when to run, inputs, outputs)
└── STEPS.md                 ← ordered steps to execute
```

## Purpose

The documentation closeout after code is built. It runs **after** the code workflows
(`18-backend-code`, `19-api-code`, `20-frontend-code`) and **before** `22-pr-and-review`,
and carries three responsibilities:

1. **Developer docs + graph.** Update every `CONTEXT.md` and `CLAUDE.md` across each layer
   the implementation touched — this is the project's **documentation hard gate**: docs
   must be complete before any commit — then refresh the code-review-graph
   (`code-review-graph update`, or the `build_or_update_graph_tool` MCP tool) so the
   layered docs and the graph stay in lockstep.
2. **PM implementation records.** Write the IMPLEMENTATION-side record for each
   design/compliance spec that applied to the story — GDPR, security, QA, SEO, API — one
   per story, copied from its `US000-TEMPLATE.md` and closing the matching `PLANNING/`
   artefact with evidence of what was actually built and any deviation.
3. **Findings.** Write one `FINDING-US###-*.md` into `src/19-FINDINGS/` recording what
   shipping the story revealed about the project's standards — each divergence with its
   smallest fix, its retrofit cost, and a disposition. Findings are **recorded, never fixed
   here**; the rows marked `Next story` become inputs to the next story plan.

> **This workflow absorbs the implementation-record duty that used to live in
> `22-pr-and-review`.** `22-pr-and-review` now only **verifies** these records exist and
> are complete — it does not write them.

## When to run

- All code phases for the story are complete: backend (`18-backend-code`), API
  (`19-api-code`), and frontend (`20-frontend-code`) as applicable.
- Before the PR is raised in `22-pr-and-review` — the records and docs are a merge gate.

## Inputs

- The user story (`src/02-STORIES/US###.md`) and its story plan (`src/16-STORY-PLANS/`).
- Every applicable `PLANNING/` artefact for the story: GDPR plan, security plans
  (threat model / assessment / audit / vulnerability), QA plan, SEO plan, API contract.
- The shipped code diff for the story, and the `CONTEXT.md`/`CLAUDE.md` pairs in each
  touched layer (`code/`, `how-to/`, `project-management/`).

## Outputs

- One IMPLEMENTATION record per applicable spec, filed under its `.../IMPLEMENTATION/`
  folder and cross-linked to the story `US###`.
- One findings record in `src/19-FINDINGS/`, written whether or not anything was found.
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

- **Upstream:** `18-backend-code`, `19-api-code`, `20-frontend-code` — the code this
  workflow documents and records.
- **Context:** `14-decisions`, `15-sprint-plans`, `16-story-plans` — the decisions and
  plans whose implementation is recorded here.
- **Downstream:** `22-pr-and-review` — now only verifies these records; `23-release`.

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
- `project-management/src/19-FINDINGS/` — `FINDING-US000-TEMPLATE.md`; one record per story
- `code/docs/DATABASE.md` — the data-layer rules findings are assessed against
- `project-management/src/20-BUGS/` · `src/21-REFACTORING/` · `src/14-DECISIONS/` — where a
  finding is routed by its disposition
- `project-management/src/16-STORY-PLANS/` — the master plan the developer coded from, and
  the next plan a finding's `Next story` rows feed
- `project-management/workflows/22-pr-and-review/` — where these records are verified
