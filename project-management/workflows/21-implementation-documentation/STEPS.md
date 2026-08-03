---
workflow: 21-implementation-documentation
phase: build
agent: doc-writer
skills: [global-workflow]
model: opus
---

# Implementation Documentation — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                                     |
| ---- | ----------------------------------------------------------------------------------------------------------- |
| 1    | **Internal — Live Artefacts** → src/16-STORY-PLANS/, and each spec's PLANNING/ folder                       |
| 3    | **Internal — Live Artefacts** → src/09-GDPR/, src/10-SECURITY/, src/11-QA/, src/12-SEO/, src/13-API-DESIGN/ |
| 4    | **Internal — Live Artefacts** → src/19-FINDINGS/ · **Internal — Guides** → code/docs/DATABASE.md            |
| 5–6  | **Internal — Guides** → code/docs/CODE-REVIEW-GRAPH.md (docs ⇄ graph lockstep)                              |

---

## Steps

### Step 1 — Confirm Code Phases Complete and Identify Applicable Specs

Verify all in-scope code phases have shipped for the story (`18-backend-code`,
`19-api-code`, `20-frontend-code`). Then open the story plan
(`src/16-STORY-PLANS/STORY-PLAN-US###-*.md`) and list every design/compliance spec that
carried a `PLANNING/` artefact for this story:

| Discipline | Applies when                         | PLANNING artefact                                       |
| ---------- | ------------------------------------ | ------------------------------------------------------- |
| GDPR       | Story processes personal data        | `src/09-GDPR/PLANNING/GDPR-PLAN-US###-*.md`             |
| Security   | Story ships a security surface       | `src/10-SECURITY/<CATEGORY>/PLANNING/*-PLAN-US###-*.md` |
| QA         | Always                               | `src/11-QA/PLANNING/QA-PLAN-US###-*.md`                 |
| SEO        | Story adds or changes a public route | `src/12-SEO/PLANNING/SEO-PLAN-US###-*.md`               |
| API design | Story adds/changes Django Ninja API  | `src/13-API-DESIGN/PLANNING/API-PLAN-US###-*.md`        |

Any spec with a `PLANNING/` artefact **must** end this workflow with a matching
`IMPLEMENTATION/` record — no orphaned plans.

### Step 2 — Confirm the Absorption Boundary

This workflow **writes** the implementation records; `22-pr-and-review` only **verifies**
they are complete. Do not defer record-writing downstream.

### Step 3 — Write Each Applicable Implementation Record

For each applicable discipline, copy the template into its `IMPLEMENTATION/` folder,
open the story's `PLANNING/` artefact, and document what was actually built versus the
plan — closing each planned task **with code evidence** and justifying any deviation.

| Discipline | Template                       | Record → destination                                                                     |
| ---------- | ------------------------------ | ---------------------------------------------------------------------------------------- |
| GDPR       | `GDPR-IMPL-US000-TEMPLATE.md`  | `GDPR-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/09-GDPR/IMPLEMENTATION/`             |
| Security   | `AUDIT-IMPL-US000-TEMPLATE.md` | `AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/10-SECURITY/AUDITS/IMPLEMENTATION/` |
| QA         | `QA-IMPL-US000-TEMPLATE.md`    | `QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/11-QA/IMPLEMENTATION/`                 |
| SEO        | `SEO-IMPL-US000-TEMPLATE.md`   | `SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/12-SEO/IMPLEMENTATION/`               |
| API design | `API-IMPL-US000-TEMPLATE.md`   | `API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/13-API-DESIGN/IMPLEMENTATION/`        |

Security notes (read `src/10-SECURITY/CLAUDE.md` to place records correctly):

- The post-build record is the **audit** under `AUDITS/IMPLEMENTATION/`. Where the story
  also carried a threat model, assessment, or vulnerability `PLANNING/` artefact, write
  the matching `IMPLEMENTATION/` record in that category too, reusing its `<DESCRIPTOR>`.
- Any newly discovered Critical/High finding is escalated to
  `src/10-SECURITY/VULNERABILITIES/IMPLEMENTATION/` immediately.

Reuse the `PLANNING/` artefact's `<DESCRIPTOR>` (SCREAMING-KEBAB-CASE) so plan and record
pair by name. A story that ships no public URL records `SEO: N/A` with a reason; a story
that ships no Django Ninja API surface records that fact in the API record header.

#### SEO — audit the built page before writing its record

> **↳ Agent:** `seo` · **Model:** opus

The SEO record is the **only** one whose evidence must be gathered from a running page, because
`12-seo-checks` set targets before the page existed. Do this before writing the record:

1. Run the `seo` agent against the story's route(s) — metadata, Open Graph, canonical, JSON-LD,
   sitemap, robots.
2. Open the page and confirm each planned tag actually renders — `12-seo-checks` planned the
   values; this is where they are checked against the DOM.
3. Run Lighthouse (Navigation, Desktop + Mobile) and **record the numbers**, not an impression:
   LCP < 2.5 s · CLS < 0.1 · INP < 200 ms. Export to
   `src/12-SEO/IMPLEMENTATION/LIGHTHOUSE-US###-<ROUTE>-DD-MM-YYYY.json`.
4. Verify image `alt` text and heading hierarchy — both are SEO **and** WCAG 2.2 AA obligations.
5. Mark each planned dimension Pass / Fail / Deviation with the rendered tag or measured value
   as evidence, and close every `SEO-GAP-n` from the plan.

A dimension marked Pass without a rendered value or a measured number is not evidence.

### Step 4 — Record Findings

Write one findings record per story, capturing what shipping it revealed about the
project's standards — divergences observed, their smallest fix, and what the **next**
story should carry forward.

Copy `src/19-FINDINGS/FINDING-US000-TEMPLATE.md` →
`src/19-FINDINGS/FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, reusing the story's
`<DESCRIPTOR>`. Assess the delivered work against the governing guides — data-layer work
against `code/docs/DATABASE.md`, and the guides it routes to.

Give every finding a stable `F-0NN` ID, a **retrofit cost** (`Cheap` / `Expensive`), and a
disposition. Repeat the `Expensive` rows in their own section — schema shape, a missing
scope column, absent database-level constraints, a chosen primary key — so they cannot be
lost in a long table.

Three rules:

- **Record, never fix.** State the smallest fix; the fix itself lands in a later story,
  `src/20-BUGS/`, or `src/21-REFACTORING/`.
- **Never invent a rationale.** Where a migration, index, or model carries no explanation
  for its shape, record the absence and flag it; mark anything inferred `TODO(verify)`.
- **Always write the file.** A story that surfaces nothing records `Outcome: Nothing found`
  — a missing record is indistinguishable from a skipped step.

Route each finding onward by disposition: a defect to `src/20-BUGS/`, structural debt to
`src/21-REFACTORING/`, a reopened hard-to-reverse trade-off to `src/14-DECISIONS/`, a
deferral with a named target story to `DEFERRED.md`, an active blocker to `GAPS.md`.

**Then close what the story actually retired.** If the story's feature map
(`src/01-FEATURE/MAP-<FEATURE>.md` → _Register claimed_) claimed a `GAPS.md` or `DEFERRED.md`
entry, settle it here — **this workflow is the only place the register closes**. Mark the
`GAPS.md` entry `✅ CLOSED DD/MM/YYYY`, or remove the `DEFERRED.md` row, **only against shipped
code**; a claim the story did not in fact retire stays open, and the reason why becomes a finding.
Charting made the promise; this step is the evidence.

Rows marked `Next story` are inputs to the next `src/16-STORY-PLANS/` plan — that is what
this record is for.

### Step 5 — Update Touched Context and Documentation

For every layer the implementation touched (`code/`, `how-to/`, `project-management/`):

1. Update the directory tree in the relevant `CONTEXT.md` to reflect new files or folders
2. Bump the `**Last Updated**` date at the top of any `CONTEXT.md`/`CLAUDE.md` modified
3. Record any new constraint, pattern, or decision in the relevant `CONTEXT.md`
4. For any new directory created, add its `CONTEXT.md` + `CLAUDE.md` pair

This is the documentation hard gate — it must be complete before any commit.

### Step 6 — Refresh the Code-Review-Graph

Run `code-review-graph update` (or the `build_or_update_graph_tool` MCP tool) so the
layered docs and the graph stay in lockstep. See `code/docs/CODE-REVIEW-GRAPH.md`.

### Step 7 — Confirm Every Record Is Linked and No Plan Is Orphaned

Cross-check each record against Step 1: every applicable spec now has an
`IMPLEMENTATION/` record naming its `US###` and linking back to its `PLANNING/` artefact.
No spec is left with a `PLANNING/` record but no `IMPLEMENTATION/` record.

### Step 8 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` + `CLAUDE.md` inside it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
