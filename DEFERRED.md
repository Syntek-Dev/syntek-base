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
"project-management/src/20-FINDINGS/archive/FINDING-US005-RETRY-OWNERSHIP-AND-BUDGETS-12-11-2026.md".

| Item                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Finding | Target                                                   |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | -------------------------------------------------------- |
| **The retry doctrine is unenforced.** `code/docs/reliability/RETRIES.md` requires every SDK or HTTP client constructor to set its attempt count explicitly, one attempt unless a register row names the delegation, but `retry-discipline.sh` (and `outbound-timeouts.sh`) is unbuilt, so nothing fails a constructor left at a framework default. Threat model TM-02; security assessment Section 7 constraint 12. Owner: slice `S-05` of `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`, not yet cut to a story. **Deadline: the first story that wires an outbound client** — that story either lands `S-05` first or carries its own constructor check | F-017   | `S-05` (uncut); deadline the first outbound-client story |

## US007 — The story status vocabulary gets one owner

Deferred 02/11/2026 at the `23-pr-and-review` final pass, from
"project-management/src/20-FINDINGS/archive/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md".

| Item                                                                                                                                                                                                                                                               | Finding | Target |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- | ------ |
| Line citations into US007's story file past its line 306 were already stale at `777595f` and land in its superseded criteria (US008's at its line 230). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut | F-007   | US008  |
| Line citations into US007's story file past its line 306 were already stale at `777595f` (US011's QA plan, at its lines 481, 573 and 578). Re-resolve each by its quoted text at the build's first step, and repoint it to a heading or to the re-cut              | F-007   | US011  |

## US013 — The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause

Deferred 23/11/2026 at `22-implementation-documentation`, from
"project-management/src/20-FINDINGS/archive/FINDING-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md" and the
story plan's _Deferred Items_.

| Item                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Finding      | Target                                                                                             |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | -------------------------------------------------------------------------------------------------- |
| **09 never hands `shell.sh` and `logs.sh --follow` to the developer.** `.claude/CLAUDE.md` Section 6 says an AI hands `development/shell.sh` and `development/logs.sh` to the developer as one command block; 09 Steps 1 and 2 do not say so, and their fences mix a never-ending follow or `tail -f` with commands meant to run after it. One handover sentence, and each never-ending command in its own fence                                                                                                                                                                                                                                                       | F-002, F-008 | `S-04` of `MAP-RULE-OWNERSHIP` (uncut, provisional US020)                                          |
| **09 Step 2 claims a test-stack reach it lacks.** Headed "(dev / test)", but `shell.sh` is hard-wired to `code/src/docker/docker-compose.dev.yml`. Drop "/ test", or give `shell.sh` an environment argument. Pre-existing                                                                                                                                                                                                                                                                                                                                                                                                                                             | F-009        | `S-04` of `MAP-RULE-OWNERSHIP` (uncut, provisional US020) — 09's workflow shape; routed 23/11/2026 |
| **09 Step 6 has no re-entry from `10-debug`.** 09 now hands the fix to `10-debug` at the root cause, but Step 6 verifies the fix and nothing returns the reader to it once the fix is deployed. Settled with the workflow shape and terminal contract                                                                                                                                                                                                                                                                                                                                                                                                                  | F-007        | `S-04` of `MAP-RULE-OWNERSHIP` (uncut, provisional US020)                                          |
| **`Audit — Doc References` is red on `dev` and on PR #43.** The 21 dangling-path findings of US013's P0 baseline, none in a US013 file (paths written unquoted so this row adds no finding of its own): how-to/src/OUTBOUND-TIMEOUTS.md ×11 and project-management/src/21-BUGS/BUG-INDEX.md ×3, which exist nowhere and are stale citations to correct; code/src/django/apps/core/observability.py ×4 and its tests/unit/test_observability.py ×3, which US014 creates (or a `how-to/src/PROJECT-PATHS.md` row each, `code/docs/FORWARD-VOICE.md` Direction A). Left red on #43 by <%DEVELOPER_NAME%>'s decision, 23/11/2026; #43 is not merged until other work lands | —            | US014                                                                                              |
