# GAPS.md — Active Gaps, Blockers & Sprint Dependencies

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Tracks active architectural gaps, blockers, and sprint dependencies for <%PROJECT_NAME%>.
**Not** a memory store — feedback, patterns, and observations go in `.claude/MEMORY.md`
instead. Deferred work goes in `DEFERRED.md`.

Resolved entries are marked `✅ CLOSED <date>` and removed on the next tidy pass. Permanent
architectural decisions are promoted to the doc that owns them — the promotion table is in
`.claude/CLAUDE.md` Section 9, which owns this workflow; it is not restated here.

**Read at the discovery gate.** `project-management/workflows/01-feature-map/` reads this file and
`DEFERRED.md` before charting a feature — to **suggest** candidate features from what has
accumulated, and to triage every open entry against the feature being charted (closes / blocks /
unrelated). An entry a feature will close is **claimed** on its `MAP-<FEATURE>.md`; the
`✅ CLOSED` mark itself is only applied by `workflows/21-implementation-documentation/`, against
shipped code.

## Format

Append a new entry at the top, newest first:

```text
## DD/MM/YYYY — <title>

**Type:** <Infrastructure gap | Planned feature | Sprint dependency | Active gap>
**Summary:** …
**Blocked by / Action:** …
```

---

## 20/08/2026 — `main` has not been reconciled since v3.2.2, and v6.0.0 stacks a second MAJOR on the gap

**Type:** Active gap
**Summary:** `main` sits at `a1e0f68` / `v3.2.2`, **80 commits behind** `pm/base-health-map`.
Every tag from `v4.0.0` to `v6.0.0` was cut on this branch line and none has been merged back, so
the default branch names a version no release has matched for three majors. There are no open pull
requests. Carried out of `HANDOFF-V6-RELEASE-AND-N031-20-08-2026.md` Open Question 3 when that
handoff was pruned; it was never a blocker for the release sequence and is not one now, which is
precisely why it has gone unaddressed through four of them.
**Blocked by / Action:** A decision, not a task — whether `main` is reconciled by merging the
branch line into it, by moving the default branch, or by leaving it as an abandoned marker. Costs
nothing today and grows by one MAJOR each release. Route through
`project-management/workflows/22-pr-and-review/`.
