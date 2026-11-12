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

## US005 — Exactly one layer decides to retry, and every budget says how long it may take

Deferred 12/11/2026 at `22-implementation-documentation`, from
"project-management/src/20-FINDINGS/FINDING-US005-RETRY-OWNERSHIP-AND-BUDGETS-12-11-2026.md".

| Item                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Finding | Target                                                   |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | -------------------------------------------------------- |
| **The retry doctrine is unenforced.** `code/docs/reliability/RETRIES.md` requires every SDK or HTTP client constructor to set its attempt count explicitly, one attempt unless a register row names the delegation, but `retry-discipline.sh` (and `outbound-timeouts.sh`) is unbuilt, so nothing fails a constructor left at a framework default. Threat model TM-02; security assessment Section 7 constraint 12. Owner: slice `S-05` of `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`, not yet cut to a story. **Deadline: the first story that wires an outbound client** — that story either lands `S-05` first or carries its own constructor check | F-017   | `S-05` (uncut); deadline the first outbound-client story |

## US007 — The story status vocabulary gets one owner

Deferred 02/11/2026 at the `23-pr-and-review` final pass, from
"project-management/src/20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md".

| Item                                                                                                                                                                                                                                                               | Finding | Target |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- | ------ |
| Line citations into US007's story file past its line 306 were already stale at `777595f` and land in its superseded criteria (US008's at its line 230). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut | F-007   | US008  |
| Line citations into US007's story file past its line 306 were already stale at `777595f` (US011's QA plan, at its lines 481, 573 and 578). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut              | F-007   | US011  |
