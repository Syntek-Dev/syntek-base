# US013 — Manual Testing Guide

_The manual testing guide for US013 — the reads, renders, gate runs and the one dev-stack walk a tester follows step by step, and, once walked, whether each step passed. Authored from the specs at `17-story-plans` Step 7.2 on 01/11/2026, before any code; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 01/11/2026 · **Story**: US013 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US013.md` — the 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause
- **Story plan:** `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the code master this guide was authored beside
- **Branch:** `us013/log-debug-workflow-seam`
- **Surface:** CLI — every row is a `code/src/scripts/**/*.sh` command, a read-only tool over a file or a `/tmp` render (`mktemp -d` and `cp` into `/tmp`, `sed`, `grep -oi … | wc -l`, `git grep`, `git status`, `git diff --name-only` — the story plan's _Quality Gates_ exceptions), a read of a passage, or a read of a CI run; the outcome is what the command prints or the passage says. The _Live walk_ section types commands inside a `shell.sh` session on a running dev stack. No rendered page
- **Authored from:** `../../02-STORIES/US013.md` (Acceptance Criteria and its seven scenarios, QA Acceptance Criteria — Manual, Out of Scope, Tasks, Verification Checks, Definition of Done, Dependencies, the FLAGS provenance comment); `../../11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` (Sections 1 to 8); `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`; `../../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md`; `../../03-SPRINTS/SPRINT-08.md`; `../../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` (slices `S-01` and `S-07`); `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` (Approach P0 to P6, Key Decisions, Testing, Quality Gates, Measured divergences). No 04-08 design and no 09, 10, 12, 13 or 14 plan exists — every one of those flags reads `N/A`. Never code

> **Authored before code, walked after it.** Which workflow writes which part of this file, and
> when, is `../CLAUDE.md` → _The record lifecycle_. Every rule for filling it — authoring, open
> questions, row IDs, the two citation columns, the build captures, marking, amendments and the
> browser contract — is this folder's `CLAUDE.md`. Neither is restated here.
>
> **What this file is, and is not.** This records **executing** the manual tests and their outcome.
> Whether the story met its specified scenarios is `../../11-QA/IMPLEMENTATION/`; whether the flow
> exists as designed is `../../05-USER-FLOW/IMPLEMENTATION/`. Three records, three questions.

---

## Preconditions and environment

- **Working tree:** the `us013/log-debug-workflow-seam` branch checked out at its head, nothing
  else changed. "The six files" below are `code/workflows/09-debugging-with-logs/` `STEPS.md`,
  `CHECKLIST.md`, `CONTEXT.md`, `CLAUDE.md` and `code/src/logs/` `CONTEXT.md`, `CLAUDE.md`.
- **Stack:** for _Live walk_ only — this host's dev stack, brought up by the walk's first row
  (posture `development`; the dev log is disposable, so the in-container truncate is lawful — QA plan
  Q5). Worktree-aware scripts layer in the story's override at `127.0.0.13` where it exists.
- **Base URL:** none is read — no page is rendered. Note the URL `server.sh up` prints in the walk
  capture; never quote one from memory.
- **Seed data / accounts:** none. No secrets, real credentials or personal data are typed or kept;
  walk output is trimmed to what proves the command ran (QA plan Section 5).
- **Renders:** each `/tmp` render is a scratch copy in a fresh directory made with `mktemp -d`;
  nothing is written into the repository. **"At default"** means each other token takes the value
  CI's `[3/4] Template Generation` job renders it with — the job's `--data` answers in
  `.github/workflows/audit-template.yml` and `copier.yml`'s defaults for the rest — because the
  non-default set differs from the default set in its two named answers only (QA plan Q3; the EC-01
  ruling, 17-story-plans grilling round 1, 01/11/2026, Q1).
- **Unmeasured rows:** a row that could not be run — the stack would not come up (ES-06), or the
  baseline it compares with was missed — is marked `Fail`, with `Unmeasured — <reason>` in `Notes`
  and a row in _Failures_ routed as `code/docs/GATE-REPORTING.md` requires; the sign-off _Outcome_
  is then `Blocked`. Never `Pass`, and never left blank (17-story-plans grilling round 2, 01/11/2026,
  Q2).
- **Counting:** occurrences per file with `grep -oi <name> <file> | wc -l`, never `grep -c`; every
  site found by the anchor phrase the inventory recorded, never by a pre-edit line number (QA plan
  Section 6; re-check 5).
- **Out of scope:**
  - **Permission and access** — no endpoint, view, protected action or role boundary (QA plan PA:
    N/A).
  - **Accessibility and responsive behaviour** — no rendered page, layout or interactive component
    (QA plan Sections 3-4).
  - **The four LogQL-bound sites' mismatch for a non-Loki project, the LogQL selectors, the host-path
    reads** — `S-07` (US014); this guide checks only that the map note records them (MARKERS-04).
  - **`CHECKLIST.md`:39 and :56, and any dev-path handoff box** — `S-04`, named in the story's Out of
    Scope; CUT-03 excludes them explicitly.
  - **The `DEFERRED.md` entry** — written by `22` itself at this walk's closeout and checked under
    the story's Definition of Done, not here. There is no `GAPS.md` close: items 1-2 of the
    17/09/2026 entry left the register on 01/11/2026 (`.claude/CLAUDE.md` Section 9).
  - **Other flag combinations as separate renders** — not walked: EC-04's reading (RENDER-02) is why
    two CI paths stand for every render path (QA plan Q2, Section 8).
- **Open questions:** None. The one row the records could not decide — how EC-01's Sentry reading is
  produced — was put to <%DEVELOPER_NAME%> and answered option 1 (17-story-plans grilling round 1,
  01/11/2026, Q1); READ-03 is written from it. Two readings were settled in round 2 (17-story-plans
  grilling round 2, 01/11/2026): whether 09 `STEPS.md` Step 1's "If the issue only occurs in
  staging/prod, skip to Step 3" breaches the dev-fault scenario (Q1 — it does not; WALK-06 records
  it), and how an unrunnable row is marked (Q2 — _Unmeasured rows_ above).

---

## Recorded during the build

| Capture                                                                                                                                                                                                                                                                                                                                                                                                | Required by                                                                                 | Taken                                                 | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- | ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bash code/src/scripts/audits/doc-references.sh`, whole tree — every finding by identity, the count, `HEAD` and the git-index state. A capture missed is recorded as missed, never reconstructed, and every row reading it is `Fail` with `Unmeasured — <capture> missed` (_Unmeasured rows_)                                                                                                          | ADR-US003; the story's _QA Acceptance Criteria — Manual_; QA plan Section 6                 | Before the first edit                                 | 23/11/2026 10:08:40 to 10:16:35, `HEAD` `e306f48e`, index clean (0 staged, 0 modified) at start. Exit 1, **21 findings, all `[dangling path]`**, targets written unquoted so this record cites none of them; none in the six files or the edit set: how-to/src/OUTBOUND-TIMEOUTS.md ×11 (`03-SPRINT-PLAN-03.md`:689, :723; `06-STORY-PLAN-US005-…`:423, :440, :846; `ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md`:147; `GAPS.md`:1669; `QA-PLAN-US005-…`:84, :315, :327; `SPRINT-03.md`:582); project-management/src/21-BUGS/BUG-INDEX.md ×3 (`GAPS.md`:1672; `QA-PLAN-US011-…`:418, :643); code/src/django/apps/core/observability.py ×4 (`GAPS.md`:1670; `THREAT-MODEL-PLAN-US014-…`:95; `US014.md`:342, :706); code/src/django/apps/core/tests/unit/test_observability.py ×3 (`QA-PLAN-US014-…`:595; `US014.md`:540, :813). Overlap declared: the inventory and gate captures were written into this guide during the run; the run reports no finding in this file |
| `docs-length.sh`, `docs-pairing.sh` and `doctrine-drift.sh`, whole tree — exit code and findings each, with `HEAD`; a capture missed is recorded as missed, never reconstructed, and every row reading it is `Fail` with `Unmeasured — <capture> missed` (_Unmeasured rows_)                                                                                                                           | QA plan Section 6                                                                           | Before the first edit                                 | 23/11/2026 10:08, `HEAD` `e306f48e`, index clean (0 staged, 0 modified). `docs-length.sh` exit 0 — 818 files within 300, 3 approaching (none of the six); `docs-pairing.sh` exit 0 — 238 `CONTEXT.md` / 228 `CLAUDE.md`, split intact; `doctrine-drift.sh` exit 0 — 4 claims, each one home                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| The inventory — the ten raw `docker` calls (file and line); the 35 GlitchTip / Loki sites, each with its anchor phrase, line and disposition (18 to `<%ERROR_TRACKING%>`, 12 to `<%LOG_AGGREGATOR%>`, 4 held, 1 reworded); every Grafana, Alloy and Prometheus site; the current lines of `TEMPLATE-TOKENS.md`'s reach paragraph and `LOG_AGGREGATOR` row                                              | The story's inventory task (re-check 5); the story plan's _Measured divergences_            | Before the first edit                                 | 23/11/2026, `HEAD` `e306f48e` — in full under _Inventory at P0_ below. 10 raw calls; 35 sites (18 GlitchTip + 17 Loki: 18 / 12 / 4 held / 1 reworded); 16 Grafana, 4 Alloy, 4 Prometheus; reach paragraph `:138-141`, `LOG_AGGREGATOR` row `:125`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| The one CI `[3/4] Template Generation` run — its run ID and job URL, the commit it rendered, and its two log lines `INCLUDE_MOBILE=false — 0 unrendered tokens` and `INCLUDE_MOBILE=true — 0 unrendered tokens` (one job, one shell loop over both values, no matrix — `.github/workflows/audit-template.yml`)                                                                                         | HP-05; the story's Verification Checks ("the render paths it ran recorded")                 | When the branch head is pushed                        | 23/11/2026 — run `45161301722` (Audit — Template Integrity, `push`), job `[3/4] Template Generation` `137647123206`, <https://github.com/Syntek-Dev/syntek-base/actions/runs/45161301722/job/137647123206>; rendered the branch head `58f3c78e`; success. Log: `INCLUDE_MOBILE=false — 0 unrendered tokens` and `INCLUDE_MOBILE=true — 0 unrendered tokens`. `[1/4]`, `[2/4]`, `[4/4]` also success. Supersedes run `45158695645` on `9afc4e44`, taken before the review and QA fixes moved the head                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| The generated-project render record — the Bugsink / Fluent Bit `/tmp` render of the six files, the commit rendered, and the per-file counts TOKENS-03 and TOKENS-04 read                                                                                                                                                                                                                               | The story's _QA Acceptance Criteria — Manual_ ("the check records the paths it ran"); HP-06 | At the walk                                           | 23/11/2026, at the walk, commit `79a22cb7` (working tree clean). The six files written by `git show 79a22cb7:<path>` into a fresh `mktemp -d` directory, `/tmp/us013-render-bf-y0yc` (six regular files, no symlink), then `sed`: `ERROR_TRACKING` = Bugsink, `LOG_AGGREGATOR` = Fluent Bit, and at default `PROJECT_NAME` = CI Probe, `PROJECT_SLUG` = ci-probe (CI's `template-render.sh` answers) and `DEPLOY_REPO` = ci-probe-nixos-client-deployment (`copier.yml`'s default); no other token is in the six. `git status --short` printed nothing afterwards. **Bugsink** (TOKENS-03): 09 `STEPS.md` 9, `CHECKLIST.md` 2, `CONTEXT.md` 2, `CLAUDE.md` 3; `code/src/logs/` `CONTEXT.md` 1, `CLAUDE.md` 1 — 18. **Fluent Bit** (TOKENS-04): 5, 0, 1, 2, 2, 2 — 12. Also read: `glitchtip` 0, `sentry` 0, `loki` 10 (3, 1, 2, 2, 1, 1), surviving token delimiters 0                                                                                                       |
| The EC-01 row-check render — the Sentry `/tmp` render of 09 `STEPS.md` only, the commit rendered, and the sentence READ-03 reads. A row check, **not** part of the generated-project check                                                                                                                                                                                                             | EC-01; story plan Key Decision 9 (17-story-plans grilling round 1, 01/11/2026, Q1)          | At the walk                                           | 23/11/2026, at the walk, commit `79a22cb7`. 09 `STEPS.md` only, by `git show` into a fresh `mktemp -d` directory, `/tmp/us013-render-sentry-qwSS`, then `sed`: `ERROR_TRACKING` = Sentry, `LOG_AGGREGATOR` = Loki (default), the other three tokens as the render record above. The sentence READ-03 reads (Step 4): "Browser-side errors — an unhandled script error, or an HTMX response/network error forwarded by `observability.js` — are captured by the browser SDK, which forwards them to Sentry (Step 3), never to Loki." "Sentry's Sentry" occurs 0 times                                                                                                                                                                                                                                                                                                                                                                                                         |
| The live-walk output — the printed base URL and each command's output for WALK-01 to WALK-05, trimmed to what proves it ran, no secrets or personal data                                                                                                                                                                                                                                               | The story's _QA Acceptance Criteria — Manual_ ("its output recorded"); QA plan Sections 5-6 | At the walk                                           | 23/11/2026, walked by <%DEVELOPER_NAME%> on the main checkout's dev stack at branch head `58f3c78e`. WALK-01: `server.sh up` printed `✓ Stack is up.` and Site `http://dev.<%PROJECT_SLUG%>.localhost:81/`. WALK-02: `logs.sh — django (following)`, then the django service's `GET /health/` 200 lines, stopped with Ctrl-C. WALK-03: `shell.sh — django (bash)`, one session at the `/workspace` prompt. WALK-04: inside it, `tail -f` streamed lines of the log (stopped with Ctrl-C), the level grep printed ERROR and WARNING lines, the `apps.users` grep printed nothing, and `tail -n 100` printed the file — no missing-file error. WALK-05: in the same session the truncate ran, and `tail -n 100` afterwards printed nothing. Log contents deliberately not kept (QA plan Section 5)                                                                                                                                                                             |
| graphify inventory — every file outside `project-management/src/`, `CHANGELOG.md`, `RELEASES.md` and `VERSION-HISTORY.md` naming `code-review-graph`, each with its site kind (refresh instruction, exploration routing, MCP declaration, configuration, licence notice), with `HEAD`; a capture missed is recorded as missed, and every row reading it is `Fail` with `Unmeasured — <capture> missed` | The story's graphify inventory task (added 23/11/2026)                                      | Before the first graphify edit                        | 23/11/2026, `HEAD` `4837e2af`, index clean, before the first graphify edit: **218 lines in 122 files** — 118 exploration routing, 80 refresh instruction, 13 configuration, 4 MCP declaration, 3 licence notice. In full under _Inventory at P7_ below                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| The probe suite's red run — `bash code/src/scripts/tests/graph-update.sh` against the hook as it stood before its edit: exit code and each probe's outcome with its reason                                                                                                                                                                                                                             | The story's probe-suite task; QA plan addendum HP-16                                        | After the suite is written, before the hook is edited | 23/11/2026, suite written by a dispatched `test-writer` (not the implementer), run against the unedited hook at `83aafd23`: **exit 1, 33 passed, 18 failed**. Failing, each because today's hook never starts or reports graphify: `absent` 3 (no report by name, as unmeasured, as absent); `lock` 2 (no run started; count 0, not 1); `refuse` 4 (not started; no report, unmeasured, reason); `success` 3 (not started as `update .` at the root); `fail` 4 (not started; no report, unmeasured, failed); `detached` 1 (the run was never started — the 2 s bound passes vacuously); `one-json` 1 (graphify not reported). `regression` 7 of 7 pass, as it should before the edit                                                                                                                                                                                                                                                                                         |

### Inventory at P0

Measured 23/11/2026 at `e306f48e`, before the first edit; occurrences by `grep -oi … | wc -l`. Line
numbers are this commit's only; the anchor phrase is the locator.

**The ten raw `docker` calls.** 09 `STEPS.md`:35 (`… up`, bare), :39 (`logs -f backend`), :52, :56,
:60, :64, :71 (`exec backend`, the last the truncate), :199 (staging `pull`), :200 (staging `up -d`);
`code/src/logs/CONTEXT.md`:60 (`exec backend`, the truncate). Prose naming `docker` and not a call:
09 `CONTEXT.md`:35, 09 `CLAUDE.md`:27, :29, `code/src/logs/CLAUDE.md`:18, :23. Wrong path
`/workspace/src/logs/django.log`: 09 `STEPS.md`:53, :57, :61, :65, :72.

**`<%ERROR_TRACKING%>` — 18** (spelt `Glitchtip` at 15 of the folder's 16; `GlitchTip` at 09
`CONTEXT.md`:59):

| File                       | Line | Anchor phrase                                                   |
| -------------------------- | ---- | --------------------------------------------------------------- |
| 09 `CONTEXT.md`            | 36   | "Glitchtip exception tracker" (matrix row)                      |
| 09 `CONTEXT.md`            | 59   | "OBSERVABILITY.md — GlitchTip, Loki, Prometheus"                |
| 09 `CLAUDE.md`             | 12   | "up to Glitchtip, Loki/Alloy, and Grafana"                      |
| 09 `CLAUDE.md`             | 28   | "and Glitchtip for"                                             |
| 09 `CLAUDE.md`             | 41   | "use Loki/Glitchtip instead"                                    |
| 09 `STEPS.md`              | 77   | "Step 3 — Check Glitchtip"                                      |
| 09 `STEPS.md`              | 81   | "Open the Glitchtip project"                                    |
| 09 `STEPS.md`              | 90   | "tag the Glitchtip issue as `investigating`"                    |
| 09 `STEPS.md`              | 109  | "use the Glitchtip first-seen timestamp"                        |
| 09 `STEPS.md`              | 130  | "Browser errors surface in Glitchtip, not Loki"                 |
| 09 `STEPS.md`              | 147  | "captured by Glitchtip's browser SDK" (sentence reworded whole) |
| 09 `STEPS.md`              | 149  | "the forwarded response error in Glitchtip"                     |
| 09 `STEPS.md`              | 202  | "Confirm no new errors in Glitchtip"                            |
| 09 `STEPS.md`              | 204  | "Mark the Glitchtip issue as resolved"                          |
| 09 `CHECKLIST.md`          | 32   | "Glitchtip issue marked as **resolved**"                        |
| 09 `CHECKLIST.md`          | 34   | "No new related errors appeared in Glitchtip"                   |
| `code/src/logs/CONTEXT.md` | 32   | "Exception reports → Glitchtip"                                 |
| `code/src/logs/CLAUDE.md`  | 33   | "Exception reports go to Glitchtip"                             |

**`Loki` — 17:** 12 to `<%LOG_AGGREGATOR%>`, 4 held, 1 reworded.

| File                       | Line | Anchor phrase                              | Disposition              |
| -------------------------- | ---- | ------------------------------------------ | ------------------------ |
| 09 `CONTEXT.md`            | 37   | "Loki / Alloy (LogQL queries in Grafana)"  | Held                     |
| 09 `CONTEXT.md`            | 59   | "GlitchTip, Loki, Prometheus, Grafana"     | Token                    |
| 09 `CLAUDE.md`             | 12   | "Glitchtip, Loki/Alloy, and Grafana"       | Token ("/Alloy" dropped) |
| 09 `CLAUDE.md`             | 28   | "query Loki (LogQL)"                       | Held                     |
| 09 `CLAUDE.md`             | 41   | "use Loki/Glitchtip instead"               | Token                    |
| 09 `STEPS.md`              | 88   | "use these to query Loki next"             | Token                    |
| 09 `STEPS.md`              | 94   | "Step 4 — Query Loki in Grafana"           | Held                     |
| 09 `STEPS.md`              | 98   | "select the Loki datasource"               | Held                     |
| 09 `STEPS.md`              | 130  | "surface in Glitchtip, not Loki"           | Token                    |
| 09 `STEPS.md`              | 133  | "no frontend log stream in Loki"           | Token                    |
| 09 `STEPS.md`              | 148  | "never Loki"                               | Token                    |
| 09 `STEPS.md`              | 149  | "Loki and as the forwarded response error" | Token                    |
| 09 `STEPS.md`              | 176  | "with the Loki log lines from Step 4"      | Reworded                 |
| `code/src/logs/CONTEXT.md` | 6    | "Grafana Alloy captures and ships to Loki" | Token                    |
| `code/src/logs/CONTEXT.md` | 34   | "Aggregated logs → Loki"                   | Token                    |
| `code/src/logs/CLAUDE.md`  | 30   | "Grafana Alloy → Loki"                     | Token                    |
| `code/src/logs/CLAUDE.md`  | 33   | "aggregated logs to Loki"                  | Token                    |

**Grafana (16), Alloy (4), Prometheus (4).** 09 `CONTEXT.md`:20 ("Grafana dashboards"), :27
("Grafana metrics"), :37 (Alloy, Grafana), :38 ("Prometheus + Grafana dashboards"), :59
(Prometheus, Grafana); 09 `CLAUDE.md`:12 (Alloy, Grafana), :28 ("dashboards in Grafana"); 09
`STEPS.md`:94 (Step 4 heading), :98 ("Open Grafana → Explore"), :111 ("Grafana time picker"), :157
("Check Grafana dashboards"), :161 ("Open Grafana → Dashboards"), :203 ("error rate in Grafana",
reworded at P4); 09 `CHECKLIST.md`:33 ("Error rate in Grafana"); `code/src/logs/CONTEXT.md`:6
("Grafana Alloy"), :33 ("Metrics → Prometheus"); `code/src/logs/CLAUDE.md`:29 ("Grafana Alloy"),
:33 ("metrics to Prometheus").

**Registers.** `how-to/src/TEMPLATE-TOKENS.md` reach paragraph `:138-141` ("Four are prose-shaped;
two of those also render into the `code/docs/` guides"), `LOG_AGGREGATOR` row `:125`.
`copier.yml` comment paragraphs now `:503-516` (plan cites `:470-483`; +33 since 7.10.0), the
PostgreSQL line `:516`; `ERROR_TRACKING` `:533`, `LOG_AGGREGATOR` `:541` (its `Alloy` at `:545`).
`how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md` `LOG_AGGREGATOR` row `:124`.

### Inventory at P7

Measured 23/11/2026 at `4837e2af`, before the first graphify edit: every line naming
`code-review-graph` outside `project-management/src/`, `CHANGELOG.md`, `RELEASES.md`,
`VERSION-HISTORY.md`, `handoffs/` and `research/` — **218 lines in 122 files**. Kind, sorted by
keyword and confirmed site by site in the sweep: **E** exploration routing (118), **R** refresh
instruction (80), **C** configuration (13), **M** MCP declaration (4), **N** licence notice (3).
Line numbers are this commit's only.

- `.claude/CLAUDE.md` — E :166, :215, :220; R :271
- `.claude/hooks/CLAUDE.md` — R :66
- `.claude/hooks/CONTEXT.md` — R :10, :100
- `.claude/hooks/graph-update.sh` — R :2, :7, :29, :32; E :41
- `.claude/hooks/pre-pr-check.sh` — R :268, :275
- `.claude/settings.json` — C :233
- `.claude/skills/CLAUDE.md` — R :52; E :59
- `.claude/skills/CONTEXT.md` — E :116, :117, :118, :119, :192
- `.claude/skills/backend/SKILL.md` — E :65
- `.claude/skills/bugfix/SKILL.md` — E :43
- `.claude/skills/code-reviewer/SKILL.md` — E :40
- `.claude/skills/codebase-design/SKILL.md` — R :106
- `.claude/skills/doc-writer/SKILL.md` — R :89
- `.claude/skills/domain-modelling/SKILL.md` — R :57, :58
- `.claude/skills/explore-codebase.md` — E :8
- `.claude/skills/git/SKILL.md` — R :52
- `.claude/skills/grilling/SKILL.md` — E :103
- `.claude/skills/handoff/SKILL.md` — E :42
- `.claude/skills/implement-story/SKILL.md` — R :80
- `.claude/skills/improve-codebase-architecture/SKILL.md` — R :126
- `.claude/skills/incident/SKILL.md` — E :52
- `.claude/skills/planner/SKILL.md` — E :62
- `.claude/skills/pr/SKILL.md` — R :78
- `.claude/skills/prototype/SKILL.md` — E :25
- `.claude/skills/refactor/SKILL.md` — E :46
- `.claude/skills/research/SKILL.md` — E :32
- `.claude/skills/resolving-merge-conflicts/SKILL.md` — E :40
- `.claude/skills/review/SKILL.md` — E :40
- `.claude/skills/scale-planning/SKILL.md` — E :112; R :183
- `.claude/skills/teach/SKILL.md` — E :51
- `.claude/skills/wayfinder/SKILL.md` — E :33, :84, :86
- `.codex/config.toml` — M :39, :41
- `.copier/README.md` — E :384, :1024, :1522; R :1507
- `.dockerignore` — C :37
- `.github/scripts/shipped-readme.sh` — C :269
- `.github/workflows/audit-hook-arming.yml` — C :80
- `.gitignore` — C :94, :95
- `.mcp.json` — M :3, :5
- `.prettierignore` — C :19
- `CONTEXT.md` — R :171
- `README.md` — R :218; E :246
- `REFERENCES.md` — E :50
- `THIRD-PARTY-NOTICES.md` — N :139, :141, :150
- `code/CLAUDE.md` — R :31, :32
- `code/CONTEXT.md` — E :20
- `code/REFERENCES.md` — E :40
- `code/docs/BACKEND-CODING-PRINCIPLES.md` — E :12
- `code/docs/CODE-REVIEW-GRAPH.md` — E :13, :128; R :35, :40, :124, :126, :127, :136, :138, :145, :147, :154
- `code/docs/CONTEXT.md` — E :25, :104
- `code/docs/DESIGN-TOKENS.md` — E :14
- `code/docs/DOCUMENTATION-PAIRING.md` — R :164
- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — E :12
- `code/docs/URL-STRATEGY.md` — E :12
- `code/src/mobile/CLAUDE.md` — R :27
- `code/src/scripts/audits/skill-conformance.sh` — E :75, :341
- `code/src/scripts/development/install-hooks.sh` — R :10; E :41, :109, :182, :597, :607
- `code/src/scripts/development/sync-trees.sh` — E :126
- `code/src/scripts/tests/CONTEXT.md` — E :192
- `code/src/scripts/tests/hook-arming.sh` — R :111, :822, :830, :1653; E :140, :828, :1008, :1018, :1019, :1020, :1618, :1619, :1620, :1621, :1623, :1627, :1630, :1633, :1634, :1663, :1664
- `code/workflows/01-implement-story/CHECKLIST.md` — R :70
- `code/workflows/01-implement-story/CONTEXT.md` — E :45; R :62
- `code/workflows/01-implement-story/STEPS.md` — E :45, :117, :251, :257, :269; R :282
- `code/workflows/02-tdd-cycle/CHECKLIST.md` — R :78
- `code/workflows/02-tdd-cycle/STEPS.md` — E :208, :238; R :245
- `code/workflows/03-database-migration/STEPS.md` — E :35
- `code/workflows/04-api-design/STEPS.md` — E :33
- `code/workflows/05-mcp-server/CHECKLIST.md` — R :82
- `code/workflows/05-mcp-server/CLAUDE.md` — R :33
- `code/workflows/05-mcp-server/STEPS.md` — E :36; R :144
- `code/workflows/07-review/CLAUDE.md` — E :18
- `code/workflows/07-review/CONTEXT.md` — E :57
- `code/workflows/07-review/STEPS.md` — E :44, :68, :78; R :90
- `code/workflows/08-security-hardening/STEPS.md` — E :35
- `code/workflows/09-debugging-with-logs/CLAUDE.md` — E :26
- `code/workflows/09-debugging-with-logs/CONTEXT.md` — E :59
- `code/workflows/10-debug/CLAUDE.md` — E :20
- `code/workflows/10-debug/CONTEXT.md` — E :43
- `code/workflows/10-debug/STEPS.md` — E :64; R :101
- `code/workflows/11-refactor/CLAUDE.md` — E :18
- `code/workflows/11-refactor/CONTEXT.md` — E :46
- `code/workflows/11-refactor/STEPS.md` — E :59; R :89
- `code/workflows/12-rust-extension/CLAUDE.md` — R :32
- `code/workflows/12-rust-extension/STEPS.md` — R :144
- `code/workflows/13-desktop-app/CLAUDE.md` — R :29
- `code/workflows/13-desktop-app/STEPS.md` — R :125
- `copier.yml` — C :357
- `how-to/docs/skill-authoring/CRAFT.md` — E :183
- `how-to/docs/tooling-guide/CONFIGURATION.md` — E :61
- `how-to/src/CONTRIBUTING.md` — R :218
- `how-to/src/TEMPLATE-GUIDE/03-PREREQUISITES.md` — E :169
- `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` — E :110
- `how-to/src/TEMPLATE-GUIDE/08-CLAUDE-CODE.md` — R :216; E :223, :244
- `how-to/src/TEMPLATE-GUIDE/10-FIRST-FEATURE.md` — R :274
- `how-to/src/TEMPLATE-GUIDE/12-EXTENDING.md` — R :150, :282
- `how-to/src/TEMPLATE-GUIDE/15-TROUBLESHOOTING.md` — E :281; R :284
- `how-to/src/TEMPLATE-GUIDE/GUIDE-TO-SKILLS.md` — E :135; R :136
- `how-to/workflows/03-daily-development/STEPS.md` — E :64
- `how-to/workflows/08-debugging/STEPS.md` — E :68, :92
- `how-to/workflows/09-write-operator-guide/CHECKLIST.md` — R :60, :72
- `how-to/workflows/09-write-operator-guide/STEPS.md` — R :120
- `lefthook.yml` — C :81, :82, :84, :86, :87
- `project-management/docs/PLANNING-GUIDE.md` — E :12
- `project-management/docs/QA-GUIDE.md` — E :12
- `project-management/docs/SECURITY-GUIDE.md` — E :12
- `project-management/docs/VERSIONING-GUIDE.md` — E :12
- `project-management/workflows/01-feature-map/CHECKLIST.md` — E :35
- `project-management/workflows/01-feature-map/CLAUDE.md` — E :42
- `project-management/workflows/01-feature-map/CONTEXT.md` — E :86
- `project-management/workflows/01-feature-map/STEPS.md` — E :78
- `project-management/workflows/04-database-schema/STEPS.md` — E :30
- `project-management/workflows/07-component-designs/STEPS.md` — E :38
- `project-management/workflows/18-consolidate-design-work/CHECKLIST.md` — R :92
- `project-management/workflows/18-consolidate-design-work/STEPS.md` — R :184
- `project-management/workflows/19-backend-code/STEPS.md` — E :33
- `project-management/workflows/20-api-code/STEPS.md` — E :33
- `project-management/workflows/21-frontend-code/STEPS.md` — E :60
- `project-management/workflows/22-implementation-documentation/CHECKLIST.md` — R :93
- `project-management/workflows/22-implementation-documentation/CLAUDE.md` — R :12, :34, :51, :93
- `project-management/workflows/22-implementation-documentation/CONTEXT.md` — R :27, :28, :75
- `project-management/workflows/22-implementation-documentation/STEPS.md` — R :235
- `project-management/workflows/23-pr-and-review/CHECKLIST.md` — R :83
- `project-management/workflows/23-pr-and-review/STEPS.md` — R :171

### Sites left without graphify, with the reason (recorded at the P12 sweep)

Recorded 23/11/2026 from the sweep agents' and the gates agent's returns. Each names something that
is code-review-graph's own and has no graphify counterpart, so a graphify mention there would be
false (the sweep brief: "never force a mention that is false"):

- `.claude/skills/CLAUDE.md`, `.claude/skills/CONTEXT.md`, `.claude/skills/explore-codebase.md`,
  `.prettierignore`:19, `how-to/src/TEMPLATE-GUIDE/GUIDE-TO-SKILLS.md`:135-137 — the four task
  cards `code-review-graph install` generates; graphify generates none.
- `code/docs/DOCUMENTATION-PAIRING.md`:164 and root `CONTEXT.md`:171 — the root `/CLAUDE.md`
  `code-review-graph install` writes.
- `code/src/scripts/audits/skill-conformance.sh`, `code/src/scripts/development/install-hooks.sh`,
  `code/src/scripts/tests/hook-arming.sh`, `.github/workflows/audit-hook-arming.yml`:80 — the
  cards' conformance and code-review-graph's git-hook reclaim, keyed to its own binary.
- `README.md`:218 and :246 — _Influences_ rows crediting code-review-graph's card text, which this
  repository commits; graphify ships no text and is recorded in `THIRD-PARTY-NOTICES.md`.
- `.claude/settings.json`:233 — the SessionStart `code-review-graph status` line. No graphify
  session-start step was decided (implement-story grilling R1 Q3 chose per edit and at commit);
  adding one is a settings change for a later decision, not this sweep.

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The script seam

| ID      | Action                                                                                                                                                                                                                                                   | Expected outcome                                                                                             | Flow | QA    | Result | Notes |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| SEAM-01 | Search the fenced code blocks of the six files for a runnable `docker` command                                                                                                                                                                           | None found                                                                                                   | —    | HP-01 | Pass   |       |
| SEAM-02 | Read the prose that names what a script wraps — 09 `CONTEXT.md`'s `docker compose logs` matrix label, 09 `CLAUDE.md`'s "runs through the tooling" line — and the two rules that say never to invoke `docker` (09 `CLAUDE.md`, `code/src/logs/CLAUDE.md`) | All present and unchanged in meaning; none is a call                                                         | —    | HP-01 | Pass   |       |
| SEAM-03 | Search the six files for `backend` used as a Compose service or a `logs.sh` argument                                                                                                                                                                     | None. The LogQL selectors reading `<%PROJECT_SLUG%>-backend` in Step 4 remain and are not counted (`S-07`'s) | —    | ES-07 | Pass   |       |

### Live walk

Typed as the story leaves the files, from the branch checkout. Record each output in the walk capture.

| ID      | Action                                                                                                                                                                                             | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Flow | QA           | Result | Notes |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ------------ | ------ | ----- |
| WALK-01 | Read 09 `STEPS.md` Step 1, then type its first command as written                                                                                                                                  | It is `bash code/src/scripts/development/server.sh up`; the dev stack comes up and prints its URL. **If the stack cannot be brought up, WALK-01 to WALK-06 are marked `Fail` with `Unmeasured — <reason>` (_Unmeasured rows_ above), never `Pass`**                                                                                                                                                                                                                                                                                                                                                                                                                                              | —    | HP-02, ES-06 |        |       |
| WALK-02 | Type Step 1's follow command as written; stop it once output is seen                                                                                                                               | It is `bash code/src/scripts/development/logs.sh --service django --follow`; it follows the `django` service's output                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —    | HP-02        |        |       |
| WALK-03 | Read Step 2 and type its `shell.sh` command as written                                                                                                                                             | One shell session opens in the `django` container; Step 2 asks for no second session                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | —    | HP-03        |        |       |
| WALK-04 | Inside that session, type each Step 2 read as written                                                                                                                                              | Each reads `/workspace/code/src/logs/django.log` and returns without a missing-file error                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | —    | HP-03        |        |       |
| WALK-05 | Follow Step 2's pointer to `code/src/logs/CONTEXT.md` → _Log rotation_, and in the same session type the truncate step there; then repeat one Step 2 read                                          | Step 2 points to that section rather than restating the truncate; the truncate is a step typed inside a `shell.sh` session; the read afterwards shows `django.log` empty                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | —    | HP-04        |        |       |
| WALK-06 | Having followed the text through WALK-01 to WALK-04 as a developer whose dev-stack fault's root cause is found at Step 2, record whether the text sent you on past Step 2, then stop as instructed | Observed in this walk, not as a separate text check (HP-14): the preamble's stop instruction, above Step 1, reads "Stop as soon as the root cause is found, then hand the fix and its regression test to `code/workflows/10-debug/`"; nothing from the preamble to the end of Step 2 sends a dev reader on to Steps 3 to 5; the reader need not reach Step 5, whose `21-BUGS/` line is staging/prod only. Step 1's closing line "If the issue only occurs in staging/prod, skip to Step 3" is **not** a send-on and not a breach: it fires only for a staging/prod-only fault, and this walk's fault is on the dev stack — decided, not left to the walker (17-story-plans grilling round 2, Q1) | —    | HP-14        |        |       |

### Tokens and the Bugsink / Fluent Bit render

| ID        | Action                                                                                                                                                                                                      | Expected outcome                                                                                                                                                                                                                                                                                                     | Flow | QA    | Result | Notes |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| TOKENS-01 | Before any render, list every Copier token in the six files **in source** and check each name against `copier.yml`'s top-level questions                                                                    | Every name is a defined question — a misspelt name fails here, because Copier would render it empty and CI would not see it                                                                                                                                                                                          | —    | ES-09 | Pass   |       |
| TOKENS-02 | Copy the six files to a fresh `/tmp` directory and substitute every token with `sed` — `ERROR_TRACKING` as `Bugsink`, `LOG_AGGREGATOR` as `Fluent Bit`, every other token at default; then run `git status` | Six rendered files in `/tmp`; `git status` shows the repository unchanged by the render; the render recorded in the render capture                                                                                                                                                                                   | —    | HP-06 | Pass   |       |
| TOKENS-03 | Count `Bugsink` in each rendered file                                                                                                                                                                       | 09 `STEPS.md` 9, `CHECKLIST.md` 2, `CONTEXT.md` 2, `CLAUDE.md` 3; `code/src/logs/` `CONTEXT.md` 1, `CLAUDE.md` 1 — 18 — and each of the 18 inventoried sites, found by its anchor phrase, reads `Bugsink`                                                                                                            | —    | HP-06 | Pass   |       |
| TOKENS-04 | Count `Fluent Bit` in each rendered file                                                                                                                                                                    | 09 `STEPS.md` 5, `CHECKLIST.md` 0, `CONTEXT.md` 1, `CLAUDE.md` 2; `code/src/logs/` `CONTEXT.md` 2, `CLAUDE.md` 2 — 12 — and each of the 12 inventoried sites, found by its anchor phrase, reads `Fluent Bit`                                                                                                         | —    | HP-06 | Pass   |       |
| TOKENS-05 | Compare each count in TOKENS-03 and TOKENS-04 with its expected figure                                                                                                                                      | Every count equal. A difference is a `Fail` recording both numbers in `Notes` — never rounded, re-counted or explained to a pass                                                                                                                                                                                     | —    | ES-05 | Pass   |       |
| TOKENS-06 | Search the render case-insensitively for `glitchtip`                                                                                                                                                        | Zero hits                                                                                                                                                                                                                                                                                                            | —    | ES-01 | Pass   |       |
| TOKENS-07 | Search the render case-insensitively for `loki`, and locate each hit                                                                                                                                        | Exactly **10**: the four held sites by anchor — the Step 4 heading "Query Loki in Grafana", "select the Loki datasource", 09 `CONTEXT.md`'s "Loki / Alloy (LogQL queries in Grafana)", 09 `CLAUDE.md`'s "query Loki (LogQL)" — plus exactly one inside each of the six reference-stack markers. Any other hit fails  | —    | ES-02 | Pass   |       |
| TOKENS-08 | In the render, read the 09 `STEPS.md` sentence anchored "log lines from Step 4"                                                                                                                             | It reads "the log lines from Step 4", naming no vendor                                                                                                                                                                                                                                                               | —    | ES-02 | Pass   |       |
| TOKENS-09 | Search the render case-insensitively for `sentry`                                                                                                                                                           | Zero hits — the six files hold none today (QA plan Section 7, "Sentry 0") and the reworded Step 4 sentence names "the browser SDK". A non-zero count is a `Fail` recording the count and each hit's anchor in `Notes`, as TOKENS-05 does                                                                             | —    | —     | Pass   |       |
| TOKENS-10 | Search the render case-insensitively for `grafana`, `alloy` and `prometheus`, and locate each hit                                                                                                           | Every hit is in its file's one marker, or below it and within that file's scope — 09 `STEPS.md` the marker to the `---` closing Step 5; 09 `CHECKLIST.md` its staging / prod section; the other four the whole file below the marker. None above a marker and none outside its scope; line order alone is not a pass | —    | ES-03 | Pass   |       |
| TOKENS-11 | Search the render for a surviving Copier token delimiter                                                                                                                                                    | None                                                                                                                                                                                                                                                                                                                 | —    | ES-04 | Pass   |       |

### Reference-stack markers and the S-07 note

| ID         | Action                                                                                                                                                                                | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                           | Flow | QA    | Result | Notes                                                                                                                                                                                                                   |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| MARKERS-01 | In each of the six files, search for "The reference deployment runs"                                                                                                                  | Exactly one per file, at its anchor: 09 `STEPS.md` between the `---` closing Step 3 and the Step 4 heading; 09 `CONTEXT.md` in its introduction; 09 `CLAUDE.md` under the Purpose heading, above the purpose sentence; 09 `CHECKLIST.md` under the staging / prod heading; `code/src/logs/CONTEXT.md` in its introduction, above the staging/production blockquote; `code/src/logs/CLAUDE.md` above the dev/test-only rule | —    | ES-08 | Pass   |                                                                                                                                                                                                                         |
| MARKERS-02 | Read each marker                                                                                                                                                                      | Each opens "The reference deployment runs …", cites `how-to/src/PLATFORM-PROVIDERS.md`, and names the reference stack literally with no token — Grafana Alloy shipping to Loki, queried with LogQL in Grafana, and Prometheus — naming `Loki` exactly once. In 09 `STEPS.md`, `CONTEXT.md` and `CLAUDE.md` it also says the held sites describe the reference deployment, without naming the product a second time         | —    | ES-08 | Pass   | 09 `CLAUDE.md`'s marker names LogQL again ("The LogQL query named below describes that deployment") but not the product; read as no second naming of Loki                                                               |
| MARKERS-03 | Read the "Prometheus + Grafana dashboards" cell in 09 `CONTEXT.md`, in source and in the render                                                                                       | Literal in both, below that file's marker; not tokenised to `<%OBSERVABILITY_STACK%>`                                                                                                                                                                                                                                                                                                                                      | —    | EC-03 | Pass   |                                                                                                                                                                                                                         |
| MARKERS-04 | Read the `S-07` row of `../../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`; run `git diff --name-only main...<last build commit>`, the last build commit being P5's, before `22`'s closeout | A dated note names the four `Loki` sites held literal — 09 `STEPS.md`'s two Step 4 sites, 09 `CONTEXT.md`'s and 09 `CLAUDE.md`'s — and why (LogQL is Loki's query language); `DEFERRED.md` is not among the files the build commits (P0 to P5) change — the entry `22`'s closeout writes later is out of scope here                                                                                                        | —    | HP-13 | Pass   | The branch is cut from `dev` (plan CORRECTED 23/11/2026), so `main...9afc4e44` also lists 26 `dev`-only files (45 in all); `DEFERRED.md` is absent from it and from the build-only diff `e306f48e..9afc4e44` (19 files) |

### The workflow stops at the root cause

| ID     | Action                                                                                                                                                            | Expected outcome                                                                                                                                                                                                                                                                                                                              | Flow | QA           | Result | Notes                                                                                                                                                                                                                                                                                                                                                   |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CUT-01 | Read 09 `STEPS.md` from its preamble to its last step                                                                                                             | No step writes a regression test or a fix; the preamble hands both to `code/workflows/10-debug/`; Step 5 ends, for a staging or production incident, by filing a bug report in `project-management/src/21-BUGS/`; the steps run 1 to 7, the former 7 and 8 now 6 and 7; the Key references table carries no pytest row                        | —    | HP-07        | Pass   |                                                                                                                                                                                                                                                                                                                                                         |
| CUT-02 | Read 09 `CHECKLIST.md` top to bottom                                                                                                                              | The _Regression test_ and _Code fix_ headings and their six boxes are gone; the box that read "If a logging statement was missing: it has been added at the correct level" claims no change made inside 09, naming the missing statement in the handoff to `10-debug`; the closing references line no longer points to **External — Testing** | —    | HP-07, HP-11 | Pass   |                                                                                                                                                                                                                                                                                                                                                         |
| CUT-03 | Trace the staging / prod box "Bug report filed in `21-BUGS/`" to a step, then every other box, excluding the "observability gap" and "Committed and pushed" boxes | The bug-report box resolves to the filing line at the end of Step 5; every other box in scope has a step behind it. The two excluded boxes are `S-04`'s                                                                                                                                                                                       | —    | HP-11        | Pass   | The two root-cause boxes resolve to the preamble's stop instruction and Step 1's trigger; the missing-logging-statement box to the preamble's `10-debug` handoff; the three error-tracker and dashboard boxes to Step 6 items 1 to 3; the four Context boxes to Step 7                                                                                  |
| CUT-04 | Read 09 `CONTEXT.md` _Outputs_ and 09 `CLAUDE.md` _Definition of done_; then search the six files for "regression test"                                           | Both hand the regression test to `code/workflows/10-debug/`; no sentence in the six files says the regression test is added or written in 09                                                                                                                                                                                                  | —    | HP-12        | Pass   |                                                                                                                                                                                                                                                                                                                                                         |
| CUT-05 | Read every "Step N" reference inside 09 `STEPS.md`; then `git grep` the tree for an outside citation of a workflow-09 step number                                 | Every internal reference resolves to the renumbered step; no outside citation is found, or each one found resolves to the renumbered step                                                                                                                                                                                                     | —    | EC-06        | Pass   | Internal references (Step 3 twice, Steps 4 and 5, Step 4, Step 5) all resolve. No live doc in `code/`, `how-to/` or `.claude/` cites a 09 step number; the PM records citing the old Steps 6 to 8 (`MAP-RULE-OWNERSHIP.md`, `CUT-PLAN.md`:296, the story, QA plan and story plan) are dated records of the change itself, not pointers to the live step |
| CUT-06 | Read the verification step (Step 6, formerly 7) as a developer whose fix is not yet deployed, then its `CHECKLIST.md` box                                         | The deploy is stated as a precondition owned by `<%DEPLOY_REPO%>`, citing `how-to/docs/FEATURE-DEPLOY.md`; the step runs no command; it reads only the error tracker and the dashboards; its error-rate read names no vendor; the step and its box both give one window, 30 minutes                                                           | —    | HP-08        | Pass   |                                                                                                                                                                                                                                                                                                                                                         |

### `copier.yml` and the token registers

| ID        | Action                                                                                                         | Expected outcome                                                                                                                                                                                                                                                                                                                       | Flow | QA           | Result | Notes |
| --------- | -------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| COPIER-01 | Read the `copier.yml` comment opening "PROSE-SAFE vs CELL-ONLY" and compare it with the story's post-edit text | It matches: no token is named and no reach is claimed; it cites `how-to/src/TEMPLATE-TOKENS.md` for which token is which; the guard "Do not put a parenthetical back into a prose-safe default." and the `how-to/src/PLATFORM-PROVIDERS.md` pointer survive; the PostgreSQL line stays; no sentence refers to removed text             | —    | HP-09        | Pass   |       |
| COPIER-02 | Read `how-to/src/TEMPLATE-TOKENS.md` below its token table                                                     | The shape rule ("Shape decides where a token may be written") stays; the reach paragraph ("Four are prose-shaped; two of those also render into the `code/docs/` guides …") is gone, and nothing in the file states which **provider** tokens reach `code/docs/`. The `INCLUDE_MOBILE` and `INCLUDE_WAGTAIL` passages are out of scope | —    | HP-09        | Pass   |       |
| COPIER-03 | Read `LOG_AGGREGATOR`'s help in `copier.yml`                                                                   | It carries "Answer with a bare product name: this one is rendered into running prose.", as `OBJECT_STORE`'s and `ERROR_TRACKING`'s do, and its list reads "Loki, Vector, Fluent Bit, CloudWatch" — no `Alloy`                                                                                                                          | —    | HP-09, EC-07 | Pass   |       |
| COPIER-04 | Read the `LOG_AGGREGATOR` row of `how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md`                                     | It names the same four answers, no `Alloy`. This row claims nothing about `code/docs/logging/OBSERVABILITY.md` or `how-to/src/PLATFORM-PROVIDERS.md`, whose "proven alternates" lists are out of scope                                                                                                                                 | —    | EC-07        | Pass   |       |
| COPIER-05 | Read 09 `CLAUDE.md`'s Purpose sentence that names the observability tools                                      | It reads "`<%ERROR_TRACKING%>`, `<%LOG_AGGREGATOR%>`, and Grafana", with no "/Alloy"                                                                                                                                                                                                                                                   | —    | EC-07        | Pass   |       |

### The read-across

| ID      | Action                                                                                                                                                                                                                                                                                 | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                      | Flow | QA    | Result | Notes                                                                                                                                             |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| READ-01 | Count the `django.log` truncate across the six files in source                                                                                                                                                                                                                         | Exactly once, in `code/src/logs/CONTEXT.md` → _Log rotation_, with 09 Step 2 pointing to it. Twice, or not at all, fails                                                                                                                                                                                                                                                                                                                              | —    | EC-05 | Pass   |                                                                                                                                                   |
| READ-02 | Read 09 `STEPS.md` Step 4's browser-errors sentence in source and in the Bugsink / Fluent Bit render; then read aloud every other substituted sentence and table cell in that render                                                                                                   | In source it reads exactly "Browser-side errors — an unhandled script error, or an HTMX response/network error forwarded by `observability.js` — are captured by the browser SDK, which forwards them to `<%ERROR_TRACKING%>` (Step 3), never to `<%LOG_AGGREGATOR%>`."; in the render it ends "… forwards them to Bugsink (Step 3), never to Fluent Bit.". No other sentence breaks around `Bugsink` or `Fluent Bit`, possessives and cells included | —    | EC-02 | Pass   | Source half read with its backticks as quotation, per the plan's CORRECTED 23/11/2026 build note (review F-1): the source writes both tokens bare |
| READ-03 | Make a second `/tmp` render of 09 `STEPS.md` **only**, `ERROR_TRACKING` as `Sentry` and every other answer at default; read Step 4's browser-errors sentence. This render is this row's check alone, not part of the generated-project check; record it in the EC-01 row-check capture | It reads "… are captured by the browser SDK, which forwards them to Sentry (Step 3), never to Loki."; nothing reads "Sentry's Sentry SDK"                                                                                                                                                                                                                                                                                                             | —    | EC-01 | Pass   |                                                                                                                                                   |

### The CI render paths

| ID        | Action                                                                                                                                   | Expected outcome                                                                                                                                                                                                                                             | Flow | QA           | Result | Notes                                                                                                                                                                                                                                                                          |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| RENDER-01 | Open the `[3/4] Template Generation` run recorded under _Recorded during the build_ and read both `INCLUDE_MOBILE` iterations in its log | It rendered the branch head and is green; its log carries `INCLUDE_MOBILE=false — 0 unrendered tokens` and `INCLUDE_MOBILE=true — 0 unrendered tokens`. Only token rendering is read here — never the literal grep, which a default render cannot tell apart | —    | HP-05, ES-04 | Pass   | Run `45161301722` rendered `58f3c78e`, the pushed branch head (`origin` is at `58f3c78e`); local `79a22cb7` and this walk change only this guide, whose added tokens (`DEVELOPER_NAME`, `PROJECT_SLUG`) are defined questions. Re-read on the run for the pushed closeout head |
| RENDER-02 | Read `copier.yml`'s `_exclude` for either directory, and search the six files for Copier's block delimiter                               | No `_exclude` entry names `code/workflows/09-debugging-with-logs/` or `code/src/logs/`, and none of the six carries a block — so `INCLUDE_RUST`, `INCLUDE_DESKTOP`, `INCLUDE_CLICKUP` and `INCLUDE_WAGTAIL` render them identically                          | —    | EC-04        | Pass   |                                                                                                                                                                                                                                                                                |

### The doc gates

| ID       | Action                                                       | Expected outcome                                                                                                                                                                                                                                                                     | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GATES-01 | `bash code/src/scripts/audits/docs-length.sh`                | Exit 0; no file the story edits crosses 270 counted lines without a dated allowance; compared with the baseline captured before the first edit; a missed baseline makes this row `Fail` with `Unmeasured — baseline missed` (_Unmeasured rows_)                                      | —    | HP-10 | Pass   | Exit 0 at 11:13 on 23/11/2026: 818 files within 300, 3 approaching, none of them a file the story edits; identical to the P0 baseline                                                                                                                                                                                                                                                                                                  |
| GATES-02 | `bash code/src/scripts/audits/docs-pairing.sh`               | Exit 0; both pairs keep their four H2s, compared with the baseline captured before the first edit; a missed baseline makes this row `Fail` with `Unmeasured — baseline missed` (_Unmeasured rows_)                                                                                   | —    | HP-10 | Pass   | Exit 0: 238 `CONTEXT.md` / 228 `CLAUDE.md`, split intact, as at P0; both `CLAUDE.md` keep Purpose, How to work here, Guardrails, Output & naming                                                                                                                                                                                                                                                                                       |
| GATES-03 | `bash code/src/scripts/audits/doc-references.sh`, whole tree | Compared with the baseline **by identity**: no new finding in any file the story edits — unless US004 has landed and the gate is green. Never a bare pass while the baseline stands; a missed baseline makes this row `Fail` with `Unmeasured — baseline missed` (_Unmeasured rows_) | —    | HP-10 | Pass   | Run 23/11/2026 from 11:09 to completion, `HEAD` `79a22cb7`, index clean at start (this guide edited in the working tree during the run): exit 1, 21 `[dangling path]` findings, identical by file and target to the P0 baseline (11 OUTBOUND-TIMEOUTS.md, 3 BUG-INDEX.md, 4 observability.py, 3 test_observability.py); no new finding and none in a file the story edits. US004 still open, so read as a diff, not a pass of the gate |
| GATES-04 | `bash code/src/scripts/audits/doctrine-drift.sh`             | Exit 0 — a regression guard only; it reads fenced code, so the prose half is the read-across above; compared with the baseline captured before the first edit, and a missed baseline makes this row `Fail` with `Unmeasured — baseline missed` (_Unmeasured rows_)                   | —    | HP-10 | Pass   | Exit 0: 4 claims, each one home, as at P0                                                                                                                                                                                                                                                                                                                                                                                              |
| GATES-05 | `bash code/src/scripts/syntax/lint.sh`                       | Passes — Markdown lint and formatting                                                                                                                                                                                                                                                | —    | —     | Pass   | Exit 0 on the whole tree (markdownlint 1178 files, 0 issues); formatting read with `format.sh --file-type markdown`, exit 0                                                                                                                                                                                                                                                                                                            |

---

### graphify beside code-review-graph (added 23/11/2026)

Authored 23/11/2026 from the story's WIDENED scenarios and the QA plan's _Addendum — graphify
beside code-review-graph_, before any graphify edit; every `Result` blank.

| ID       | Action                                                                                                                                                                            | Expected outcome                                                                                                                                                                                                                                                                    | Flow | QA                                | Result | Notes |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --------------------------------- | ------ | ----- |
| GRAPH-01 | `bash code/src/scripts/audits/mcp-parity.sh`; then read the `graphify` entry in `.mcp.json` and `.codex/config.toml`                                                              | Exit 0; both declare `graphify` as `uvx --from "graphifyy[mcp]" graphify-mcp`, with no version pin                                                                                                                                                                                  | —    | HP-15                             |        |       |
| GRAPH-02 | Read the probe suite's red run under _Recorded during the build_                                                                                                                  | Red against the unedited hook, each probe failing for the reason it states; a missed capture makes this row `Fail` with `Unmeasured — red run missed`                                                                                                                               | —    | HP-16                             |        |       |
| GRAPH-03 | `bash code/src/scripts/tests/graph-update.sh`                                                                                                                                     | Exit 0, every probe green: graphify absent reported unmeasured once; a held lock starts no second run; a refusal to overwrite reported once with its reason; a successful run followed by silence on the next call; code-review-graph's refresh and untracked-file notice unchanged | —    | HP-16, ES-10, ES-11, ES-12, ES-13 |        |       |
| GRAPH-04 | Read `.claude/hooks/graph-update.sh`; then search it for `--force`                                                                                                                | graphify starts in the background under a lock and the hook does not wait for it; the hook always exits 0; zero `--force`                                                                                                                                                           | —    | HP-17, ES-12                      |        |       |
| GRAPH-05 | Read `lefthook.yml`'s pre-commit steps; then read the pre-commit output of the closeout commit                                                                                    | A graphify step sits beside `code-review-graph detect-changes`, its exit status discarded as that step's is, naming an absent tool; the closeout commit's output shows it ran and did not block                                                                                     | —    | HP-18, ES-10                      |        |       |
| GRAPH-06 | Search every file outside `project-management/src/` and the release logs for `code-review-graph`, then for `graphify`, and compare the two file lists with the graphify inventory | Every inventoried site names graphify beside code-review-graph by the role split; no inventoried file names one without the other                                                                                                                                                   | —    | HP-19                             |        |       |
| GRAPH-07 | Read `.claude/CLAUDE.md` Sections 3.1, 3.3 and 6, `code/docs/CODE-REVIEW-GRAPH.md`, and `project-management/workflows/22-implementation-documentation/STEPS.md` Step 7            | The role split is stated — code relationships to code-review-graph, cross-artefact questions to graphify, each the other's fallback; Section 6's staged-then-refreshed gate is code-review-graph's alone; graphify's refresh is advisory everywhere                                 | —    | HP-19, HP-20                      |        |       |
| GRAPH-08 | With a local `graphify-out/` present, `bash code/src/scripts/syntax/lint.sh --file-type markdown`; then read the `GAPS.md` entry on the defect                                    | No file under `graphify-out/` is read; the entry reads `✅ CLOSED 23/11/2026` against this change                                                                                                                                                                                   | —    | EC-08                             |        |       |
| GRAPH-09 | Search `install.sh` for `graphify` and `code-review-graph`                                                                                                                        | Neither is installed there; both stay host-provided                                                                                                                                                                                                                                 | —    | EC-09                             |        |       |
| GRAPH-10 | Read `THIRD-PARTY-NOTICES.md` for graphify                                                                                                                                        | graphify recorded as Apache-2.0, run as-is, needing no notice because none of its text is committed                                                                                                                                                                                 | —    | EC-10                             |        |       |

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID  | What happened | Blocks the story? | Routed to |
| --- | ------------- | ----------------- | --------- |

---

## Tester sign-off

Filled at the walk. A tester other than the author — <%DEVELOPER_NAME%>; a fresh `general-purpose`
agent may walk the mechanical rows (the gate runs and the counts), its record reviewed by
<%DEVELOPER_NAME%> (QA plan Q4).

| Field        | Value                                                                     |
| ------------ | ------------------------------------------------------------------------- |
| **Tester**   |                                                                           |
| **Date**     |                                                                           |
| **Browsers** | N/A — CLI surface; no page is rendered. CI run pages are read, not tested |
| **Outcome**  |                                                                           |
| **Blockers** |                                                                           |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass; an unmeasured row is a `Fail` with `Unmeasured — <reason>` and a _Failures_ row, never `Pass` or blank
- [ ] _Outcome_ reads `Blocked` while any row is `Fail` with `Unmeasured — <reason>` (17-story-plans grilling round 2, Q2)
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against "../AUTOMATED/US013-TEST-STATUS.md" — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US013.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the implementation plan this guide was authored beside
- "../AUTOMATED/US013-TEST-STATUS.md" — the paired automated-test record, written by `22`; every suite `N/A` with its reason, and the CI run IDs
- `../../11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — where the `QA` column's scenario IDs, the expected counts and the method are defined
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` — why GATES-03 is a diff against a baseline
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — why an unmeasured walk row or a missed baseline is never a pass
