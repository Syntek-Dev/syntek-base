---
workflow: 22-implementation-documentation
phase: build
skills: [doc-writer, global-workflow]
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
| 1    | **Internal — Live Artefacts** → src/17-STORY-PLANS/, and each spec's PLANNING/ folder                       |
| 3    | **Internal — Live Artefacts** → src/09-GDPR/, src/10-SECURITY/, src/11-QA/, src/12-SEO/, src/13-API-DESIGN/ |
| 4    | **Internal — Live Artefacts** → src/18-TESTS/ · **Internal — Guides** → code/docs/TESTING.md                |
| 5    | **Internal — Live Artefacts** → src/20-FINDINGS/ · **Internal — Guides** → code/docs/DATABASE.md            |
| 6–7  | **Internal — Guides** → code/docs/CODE-REVIEW-GRAPH.md (docs ⇄ graph lockstep)                              |

---

## Steps

### Step 1 — Confirm Code Phases Complete and Identify Applicable Specs

<!-- UPDATED 08/09/2026. The story-plan filename pattern below gained its `<exec-order>-`
     prefix; superseded form, quoted without backticks so no dead name is recorded as a fresh
     citation: "src/17-STORY-PLANS/STORY-PLAN-US###-*.md". The prefix is the story's position in
     the settled build order, renumbered whenever that order changes — the OPPOSITE of the
     two-number sprint-plan rule in `project-management/src/16-SPRINT-PLANS/CLAUDE.md`, where a
     mismatch is deliberate and never "corrected". Rule:
     `project-management/src/17-STORY-PLANS/CLAUDE.md`. -->

Verify all in-scope code phases have shipped for the story (`19-backend-code`,
`20-api-code`, `21-frontend-code`). Then open the story plan
(`src/17-STORY-PLANS/<exec-order>-STORY-PLAN-US###-*.md`) and list every design/compliance
spec that carried a `PLANNING/` artefact for this story:

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

This workflow **writes** the implementation records; `23-pr-and-review` only **verifies**
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

Where the QA record's evidence for a scenario is a **manual** verification, it may cite the
`src/18-TESTS/` row ID that exercised it (`SIGNUP-03`) instead of a test name — see Step 4, and
walk the guide before closing that row. An automated test name stays preferred where one exists.

Reuse the `PLANNING/` artefact's `<DESCRIPTOR>` (SCREAMING-KEBAB-CASE) so plan and record
pair by name. A story that ships no public URL records `SEO: N/A` with a reason; a story
that ships no Django Ninja API surface records that fact in the API record header.

#### SEO — audit the built page before writing its record

> **↳ New dispatch:** `general-purpose` · **Skill:** `seo` · **Model:** opus

The SEO record is the **only** one whose evidence must be gathered from a running page, because
`12-seo-checks` set targets before the page existed. Do this before writing the record:

1. Run the `seo` skill against the story's route(s) — metadata, Open Graph, canonical, JSON-LD,
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

### Step 4 — Write the Two Test Records

Unlike Step 3, this pair is **not** conditional on a `PLANNING/` artefact and has none. It is
written for **every** story, because its subject is not plan-versus-built but whether executing
the tests passed. Copy both templates out of `src/18-TESTS/`:

| Record    | Template                  | Record → destination                        |
| --------- | ------------------------- | ------------------------------------------- |
| Automated | `US000-TEST-STATUS.md`    | `US###-TEST-STATUS.md` → `src/18-TESTS/`    |
| Manual    | `US000-MANUAL-TESTING.md` | `US###-MANUAL-TESTING.md` → `src/18-TESTS/` |

**The automated record's generated block is generated, never typed.** Run the story's suites
through `code/src/scripts/tests/**/*.sh`, then run the generator over their report artefacts:

```bash
bash code/src/scripts/tests/test-record.sh US###
```

Run it **after the suites, green or red**. It is deliberately separate from the runners — their
exit-code contract is untouched, so a **failing** run still records — and it is the only writer of
everything between `<!-- BEGIN GENERATED: test-record -->` and `<!-- END GENERATED -->`, the
coverage figures included; the ban on hand-editing inside them is `src/18-TESTS/CLAUDE.md`'s.
Everything after the block — how to reproduce the run, the outstanding gaps and flaky
tests, the status line — is yours to write.

**A test only reaches the record if it declares its story.** A pytest test carries
`@pytest.mark.story("US###")`, inheritable from its class or module via `pytestmark`; a Bruno
request carries `tags: [US###]` in its `meta` block, read from the `.bru` source so one
whole-collection run still feeds every story — the marker registry is `code/docs/testing/TAXONOMY.md`.
Enforcement warns and exits 0:

```bash
bash code/src/scripts/audits/story-markers.sh
```

Because it never fails a build, **an unmarked test is silently absent from the record** — a short
table is not evidence of a small suite. Read the audit's output before trusting one.

**The manual guide is walked, not drafted** — marked row by row as each step is executed, by a
human tester or by Claude Chrome against the same file. Drafting it from the code and marking it
afterwards is the one way this record can lie.

Read `src/18-TESTS/CLAUDE.md` before writing either file. The three-record boundary, the
journey-area sections and their `{AREA}-{NN}` row IDs, the `QA` citation column, the marking rule,
the overwrite-on-re-run rule and the browser-tool contract are all owned there, and none of them is
restated here.

A red suite or a failed manual row is an **input** to Step 5, never a reason to skip this step.

### Step 5 — Record Findings

Write one findings record per story, capturing what shipping it revealed about the
project's standards — divergences observed, their smallest fix, and what the **next**
story should carry forward.

Copy `src/20-FINDINGS/FINDING-US000-TEMPLATE.md` →
`src/20-FINDINGS/FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, reusing the story's
`<DESCRIPTOR>`. Assess the delivered work against the governing guides — data-layer work
against `code/docs/DATABASE.md`, and the guides it routes to.

Give every finding a stable `F-0NN` ID, a **retrofit cost** (`Cheap` / `Expensive`), and a
disposition. Repeat the `Expensive` rows in their own section — schema shape, a missing
scope column, absent database-level constraints, a chosen primary key — so they cannot be
lost in a long table.

Three rules:

- **Record, never fix.** State the smallest fix; the fix itself lands in a later story,
  `src/21-BUGS/`, or `src/22-REFACTORING/`.
- **Never invent a rationale.** Where a migration, index, or model carries no explanation
  for its shape, record the absence and flag it; mark anything inferred `TODO(verify)`.
- **Always write the file.** A story that surfaces nothing records `Outcome: Nothing found`
  — a missing record is indistinguishable from a skipped step.

Route each finding onward by disposition: a defect to `src/21-BUGS/`, structural debt to
`src/22-REFACTORING/`, a reopened hard-to-reverse trade-off to `src/15-DECISIONS/`, a
deferral with a named target story to `DEFERRED.md`, an active blocker to `GAPS.md`.

**Then close what the story actually retired.** If the story's feature map
(`src/01-FEATURE-MAPS/MAP-<FEATURE>.md` → _Register claimed_) claimed a `GAPS.md` or `DEFERRED.md`
entry, settle it here — **this workflow is the only place the register closes**. Mark the
`GAPS.md` entry `✅ CLOSED DD/MM/YYYY`, or remove the `DEFERRED.md` row, **only against shipped
code**; a claim the story did not in fact retire stays open, and the reason why becomes a finding.
Charting made the promise; this step is the evidence.

Rows marked `Next story` are inputs to the next `src/17-STORY-PLANS/` plan — that is what
this record is for.

### Step 6 — Update Touched Context and Documentation

For every layer the implementation touched (`code/`, `how-to/`, `project-management/`):

1. Update the directory tree in the relevant `CONTEXT.md` to reflect new files or folders
2. Bump the `**Last Updated**` date at the top of any `CONTEXT.md`/`CLAUDE.md` modified
3. Record any new constraint, pattern, or decision in the relevant `CONTEXT.md`
4. For any new directory created, add its `CONTEXT.md` + `CLAUDE.md` pair

This is the documentation hard gate — it must be complete before any commit.

### Step 7 — Refresh the Code-Review-Graph

Run `code-review-graph update` (or the `build_or_update_graph_tool` MCP tool) so the
layered docs and the graph stay in lockstep. See `code/docs/CODE-REVIEW-GRAPH.md`.

### Step 8 — Confirm Every Record Is Linked and No Plan Is Orphaned

Cross-check each record against Step 1: every applicable spec now has an
`IMPLEMENTATION/` record naming its `US###` and linking back to its `PLANNING/` artefact.
No spec is left with a `PLANNING/` record but no `IMPLEMENTATION/` record.

The `src/18-TESTS/` pair has no `PLANNING/` side and is therefore outside that check. Confirm
instead that **both** files exist for the story, that the generated block was regenerated against
the last suite run, and that every manual row carries a `Pass` or a `Fail`.

### Step 9 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

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
