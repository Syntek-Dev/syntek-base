---
workflow: 22-implementation-documentation
phase: build
skills: [doc-writer, global-workflow]
model: opus
---

# Implementation Documentation — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Live Artefacts**
> (src/09-GDPR/, src/10-SECURITY/, src/11-QA/, src/12-SEO/, src/13-API-DESIGN/,
> src/17-STORY-PLANS/, src/18-TESTS/) · **Internal — Guides**
> (code/docs/CODE-REVIEW-GRAPH.md, code/docs/TESTING.md) for supporting references.

## Execution Checklist

- [ ] All in-scope code phases shipped (`19-backend-code`, `20-api-code`, `21-frontend-code`)
- [ ] Every spec that carried a `PLANNING/` artefact for the story identified
- [ ] GDPR IMPLEMENTATION record written from template (if the story processes personal data)
- [ ] Security IMPLEMENTATION record(s) written from template under `AUDITS/IMPLEMENTATION/`
      (plus threat-model / assessment / vulnerability closures where planned)
- [ ] QA IMPLEMENTATION record written from template
- [ ] SEO IMPLEMENTATION record written from template (or `SEO: N/A` recorded with a reason)
- [ ] API IMPLEMENTATION record written from template (if the story adds or changes the Django Ninja API)
- [ ] Each record notes what was built versus the plan, with deviations justified by evidence
- [ ] Every record is linked to its `US###` and back to its `PLANNING/` artefact
- [ ] No spec left with a `PLANNING/` record but no matching `IMPLEMENTATION/` record
- [ ] Any newly discovered Critical/High finding escalated to `VULNERABILITIES/IMPLEMENTATION/`

---

## Test records

- [ ] Both `src/18-TESTS/` records copied from their `US000-…` templates — `US###-TEST-STATUS.md`
      and `US###-MANUAL-TESTING.md`, every story, whatever the suites returned
- [ ] Story's suites run through `code/src/scripts/tests/**/*.sh`, then
      `bash code/src/scripts/tests/test-record.sh US###` run **after** them — green or red
- [ ] Nothing between `<!-- BEGIN GENERATED: test-record -->` and `<!-- END GENERATED -->`
      hand-edited, the coverage figures included — the next run discards any edit
- [ ] `bash code/src/scripts/audits/story-markers.sh` run and its output read — it warns and
      exits 0, and an **unmarked test is silently absent from the record**
- [ ] Every test the story owns declares it — `@pytest.mark.story("US###")` (or `pytestmark`
      on its class or module), `tags: [US###]` in a Bruno request's `meta` block
- [ ] Manual guide **walked** by a tester or Claude Chrome, one section per journey area, every
      row marked `Pass` or `Fail` — an empty `Result` is never a pass
- [ ] Every `Fail` carries its reason in `Notes` and a destination
- [ ] Hand-written halves completed — reproduction, gaps, flaky tests and the status line in the
      automated record; preconditions, failures and sign-off in the manual guide
- [ ] Both records cross-linked to `US###` and its `src/17-STORY-PLANS/` plan
- [ ] Surface named in the manual guide's header (Browser / CLI / Gate / API), so a non-UI story
      still has rows

---

## Findings

- [ ] `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` written to `src/20-FINDINGS/` from template —
      written even when nothing was found (`Outcome: Nothing found`)
- [ ] Delivered work assessed against the governing guides (`code/docs/DATABASE.md` and the
      guides it routes to, for any data-layer work)
- [ ] Every finding carries an `F-0NN` ID, a retrofit cost (`Cheap` / `Expensive`), and a disposition
- [ ] `Expensive` findings repeated in their own section and escalated — schema shape, missing
      scope column, absent database-level constraints, chosen primary key
- [ ] Nothing fixed in this pass — each finding states its smallest fix and is routed onward
      (`src/21-BUGS/`, `src/22-REFACTORING/`, `src/15-DECISIONS/`, `DEFERRED.md`, `GAPS.md`)
- [ ] No rationale invented — absent explanations flagged, inferences marked `TODO(verify)`
- [ ] `Next story` rows carried into the next `src/17-STORY-PLANS/` plan
- [ ] Every _Register claimed_ row on the story's feature map checked: retired entries closed
      here (`GAPS.md` → `✅ CLOSED DD/MM/YYYY`, `DEFERRED.md` → row removed) **against shipped
      code**; a claim the story did not retire left open, with the reason recorded as a finding

---

## Context

- [ ] Touched `CONTEXT.md`/`CLAUDE.md` across every layer updated (trees, constraints)
- [ ] `**Last Updated**` date is current in any `CONTEXT.md`/`CLAUDE.md` modified
- [ ] Every new directory created during this workflow has a `CONTEXT.md` + `CLAUDE.md`
- [ ] Code-review-graph refreshed (`code-review-graph update` / `build_or_update_graph_tool`)
- [ ] Every instructional `.md` touched stays ≤ 300 code lines — `bash code/src/scripts/audits/docs-length.sh`

---

## Definition of Done

- [ ] All applicable IMPLEMENTATION records written, linked, and committed
- [ ] Both `src/18-TESTS/` records written — generated block regenerated against the last suite
      run, manual guide walked and every row marked
- [ ] Findings record written and its `Next story` rows carried forward
- [ ] Documentation hard gate met — docs complete and graph refreshed before any commit
- [ ] Ready to proceed to `workflows/23-pr-and-review` (which now only verifies these records)
