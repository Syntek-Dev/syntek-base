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

## US001 — Reliability doctrine gets an owning guide

Deferred 03/11/2026 at `22-implementation-documentation`, from
"project-management/src/20-FINDINGS/FINDING-US001-RELIABILITY-DOCTRINE-HOME-03-11-2026.md".

| Item                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Finding | Target |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------ |
| `code/docs/TASK-AUTHORING.md` → _Retries and backoff_ is now a route that lists the retry doctrine's topics. Once `code/docs/reliability/RETRIES.md` has grown, accept the list as written or trim it to a bare route                                                                                                                                                                                                                                                                                                                                                             | F-004   | US005  |
| `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` → _Background Job Patterns_ → _Rules_ states "Failed jobs must be monitored", duplicating the failed-job visibility `code/docs/performance/API-AND-MONITORING.md` keeps. Reduce the line to a route there; no map slice schedules it                                                                                                                                                                                                                                                                                           | F-005   | US005  |
| `code/docs/TASK-AUTHORING.md` → _Testing without a broker_ states "Retry behaviour is tested by classification, not by waiting", a cross-surface retry rule outside US001's inventoried sections. Inventory it and decide its home                                                                                                                                                                                                                                                                                                                                                | F-006   | US005  |
| Find the pointers to a doctrine's old home by a whole-tree grep for its path and section names at the first build step, and record the hit list beside the inventory — US001's enumerated three missed five                                                                                                                                                                                                                                                                                                                                                                       | F-008   | US005  |
| US005's line citations into `code/docs/TASK-AUTHORING.md` and `code/docs/performance/API-AND-MONITORING.md` (TA:204, AM:46, AM:57, AM:69, AM:142) predate US001's edits to both, and its quoted references to "TASK-AUTHORING.md's proof ladder" (US005.md:277; its story plan :292 and :712) now name a route, the ladder having moved to `code/docs/reliability/IDEMPOTENCY.md`. Re-resolve each by its quoted text before any edit; AM:57 was the `max_retries=3` sample US001 deleted (inventory row A-07), and AM:69 the `max_retries` rule it deleted as a duplicate (A-09) | F-010   | US005  |
| `project-management/docs/gdpr/COMPLIANCE.md:27-48` carries a sample task retrying every exception (`max_retries=3`, `except Exception: raise self.retry(exc=exc)`) with no jitter and no age bound — the pattern US001 deleted from AM as A-07 — and its line 77 restates "Tasks must be idempotent" without a route. Reduce the sample to the doctrine and route to `code/docs/RELIABILITY.md`                                                                                                                                                                                   | F-012   | US005  |

## US007 — The story status vocabulary gets one owner

Deferred 02/11/2026 at the `23-pr-and-review` final pass, from
"project-management/src/20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md".

| Item                                                                                                                                                                                                                                                               | Finding | Target |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- | ------ |
| Line citations into US007's story file past its line 306 were already stale at `777595f` and land in its superseded criteria (US008's at its line 230). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut | F-007   | US008  |
| Line citations into US007's story file past its line 306 were already stale at `777595f` (US011's QA plan, at its lines 481, 573 and 578). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut              | F-007   | US011  |
