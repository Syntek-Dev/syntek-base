---
workflow: 19-implementation-documentation
phase: build
agent: doc-writer
skills: [global-workflow]
model: opus
---

# Implementation Documentation — Steps

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                                     |
| ---- | ----------------------------------------------------------------------------------------------------------- |
| 1    | **Internal — Live Artefacts** → src/15-STORY-PLANS/, and each spec's PLANNING/ folder                       |
| 3    | **Internal — Live Artefacts** → src/08-GDPR/, src/09-SECURITY/, src/10-QA/, src/11-SEO/, src/12-API-DESIGN/ |
| 4    | **Internal — Live Artefacts** → src/18-FINDINGS/ · **Internal — Guides** → code/docs/DATABASE.md            |
| 5–6  | **Internal — Guides** → code/docs/CODE-REVIEW-GRAPH.md (docs ⇄ graph lockstep)                              |

---

## Steps

### Step 1 — Confirm Code Phases Complete and Identify Applicable Specs

Verify all in-scope code phases have shipped for the story (`16-backend-code`,
`17-api-code`, `18-frontend-code`). Then open the story plan
(`src/15-STORY-PLANS/STORY-PLAN-US###-*.md`) and list every design/compliance spec that
carried a `PLANNING/` artefact for this story:

| Discipline | Applies when                         | PLANNING artefact                                       |
| ---------- | ------------------------------------ | ------------------------------------------------------- |
| GDPR       | Story processes personal data        | `src/08-GDPR/PLANNING/GDPR-PLAN-US###-*.md`             |
| Security   | Story ships a security surface       | `src/09-SECURITY/<CATEGORY>/PLANNING/*-PLAN-US###-*.md` |
| QA         | Always                               | `src/10-QA/PLANNING/QA-PLAN-US###-*.md`                 |
| SEO        | Story adds or changes a public route | `src/11-SEO/PLANNING/SEO-PLAN-US###-*.md`               |
| API design | Story adds/changes Django Ninja API  | `src/12-API-DESIGN/PLANNING/API-PLAN-US###-*.md`        |

Any spec with a `PLANNING/` artefact **must** end this workflow with a matching
`IMPLEMENTATION/` record — no orphaned plans.

### Step 2 — Confirm the Absorption Boundary

This workflow **writes** the implementation records; `20-pr-and-review` only **verifies**
they are complete. Do not defer record-writing downstream.

### Step 3 — Write Each Applicable Implementation Record

For each applicable discipline, copy the template into its `IMPLEMENTATION/` folder,
open the story's `PLANNING/` artefact, and document what was actually built versus the
plan — closing each planned task **with code evidence** and justifying any deviation.

| Discipline | Template                       | Record → destination                                                                     |
| ---------- | ------------------------------ | ---------------------------------------------------------------------------------------- |
| GDPR       | `GDPR-IMPL-US000-TEMPLATE.md`  | `GDPR-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/08-GDPR/IMPLEMENTATION/`             |
| Security   | `AUDIT-IMPL-US000-TEMPLATE.md` | `AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/09-SECURITY/AUDITS/IMPLEMENTATION/` |
| QA         | `QA-IMPL-US000-TEMPLATE.md`    | `QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/10-QA/IMPLEMENTATION/`                 |
| SEO        | `SEO-IMPL-US000-TEMPLATE.md`   | `SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/11-SEO/IMPLEMENTATION/`               |
| API design | `API-IMPL-US000-TEMPLATE.md`   | `API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → `src/12-API-DESIGN/IMPLEMENTATION/`        |

Security notes (read `src/09-SECURITY/CLAUDE.md` to place records correctly):

- The post-build record is the **audit** under `AUDITS/IMPLEMENTATION/`. Where the story
  also carried a threat model, assessment, or vulnerability `PLANNING/` artefact, write
  the matching `IMPLEMENTATION/` record in that category too, reusing its `<DESCRIPTOR>`.
- Any newly discovered Critical/High finding is escalated to
  `src/09-SECURITY/VULNERABILITIES/IMPLEMENTATION/` immediately.

Reuse the `PLANNING/` artefact's `<DESCRIPTOR>` (SCREAMING-KEBAB-CASE) so plan and record
pair by name. A story that ships no public URL records `SEO: N/A` with a reason; a story
that ships no Django Ninja API surface records that fact in the API record header.

### Step 4 — Record Findings

Write one findings record per story, capturing what shipping it revealed about the
project's standards — divergences observed, their smallest fix, and what the **next**
story should carry forward.

Copy `src/18-FINDINGS/FINDING-US000-TEMPLATE.md` →
`src/18-FINDINGS/FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, reusing the story's
`<DESCRIPTOR>`. Assess the delivered work against the governing guides — data-layer work
against `code/docs/DATABASE.md`, and the guides it routes to.

Give every finding a stable `F-0NN` ID, a **retrofit cost** (`Cheap` / `Expensive`), and a
disposition. Repeat the `Expensive` rows in their own section — schema shape, a missing
scope column, absent database-level constraints, a chosen primary key — so they cannot be
lost in a long table.

Three rules:

- **Record, never fix.** State the smallest fix; the fix itself lands in a later story,
  `src/19-BUGS/`, or `src/20-REFACTORING/`.
- **Never invent a rationale.** Where a migration, index, or model carries no explanation
  for its shape, record the absence and flag it; mark anything inferred `TODO(verify)`.
- **Always write the file.** A story that surfaces nothing records `Outcome: Nothing found`
  — a missing record is indistinguishable from a skipped step.

Route each finding onward by disposition: a defect to `src/19-BUGS/`, structural debt to
`src/20-REFACTORING/`, a reopened hard-to-reverse trade-off to `src/13-DECISIONS/`, a
deferral with a named target story to `DEFERRED.md`, an active blocker to `GAPS.md`.

Rows marked `Next story` are inputs to the next `src/15-STORY-PLANS/` plan — that is what
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
