# DEFERRED.md — Cross-Story Deferred Items

Items in this file were explicitly deferred from a completed story to a future story during implementation. Sprint planners should check this file before planning any story listed in the **Target** column — the deferred item may affect scope, acceptance criteria, or implementation
order.

**Maintained by:** Written during implementation reviews · **Language:** British English (en_GB)

**Add a row when:** an implementation doc (assessment, audit, or sprint plan) marks something
`DEFERRED (US###)` or `DEFERRED (apps.xxx)`. Remove the row when a map or story claims it, or
else when the target story ships it.

**Read at the discovery gate.** `project-management/workflows/01-feature-map/` reads this file and
`GAPS.md` before charting a feature — to **suggest** candidate features from what has
accumulated, and to triage every open row against the feature being charted (closes / blocks /
unrelated). **A row a map claims, or a story is cut carrying, leaves this file in that change**
(rule: `.claude/CLAUDE.md` Section 9).

---

## US007 — The story status vocabulary gets one owner

Deferred 02/11/2026 at the `23-pr-and-review` final pass, from
"project-management/src/20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md".

| Item                                                                                                                                                                                                                                                               | Finding | Target |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- | ------ |
| Line citations into US007's story file past its line 306 were already stale at `777595f` and land in its superseded criteria (US008's at its line 230). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut | F-007   | US008  |
| Line citations into US007's story file past its line 306 were already stale at `777595f` (US011's QA plan, at its lines 481, 573 and 578). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut              | F-007   | US011  |
| A release that changes a planned story's subject leaves the story's criteria stale until its build. At the build's first step, check whether a release since the plan was written changed the story's subject; if it did, re-cut the story before any edit         | F-013   | US001  |
