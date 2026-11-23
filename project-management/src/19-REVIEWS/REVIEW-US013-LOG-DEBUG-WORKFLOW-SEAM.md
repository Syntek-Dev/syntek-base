# Code Review — US013 The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause

**Last Updated**: 23/11/2026 · **Story**: US013 · **Status**: In Review

| Field        | Value                                                                                                                                                                                                      |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US013 — workflow 09 runs through the scripts, renders its vendor names from the answers, and stops at the root cause; widened at build to run graphify beside code-review-graph                            |
| **Branch**   | `us013/log-debug-workflow-seam` (base `e306f48e`; head `6bece79f`) — **already merged** to `dev` via PR #43 at `73cee9a5`. This record is written on `dev` after the merge, at the developer's instruction |
| **PR**       | #43, merged 23/11/2026. `git diff 6bece79f 73cee9a5` is empty, so the merge tree is the reviewed head                                                                                                      |
| **Reviewer** | Claude (Opus), `code-reviewer` skill, independent dispatch, 23/11/2026 — wrote none of the story's code and none of the records it reads                                                                   |
| **Date**     | 23/11/2026                                                                                                                                                                                                 |
| **Verdict**  | **Approve-with-nits.** No Critical, High or Medium finding. One Low record gap (R-001), one Nit (R-002, R-003), three Info                                                                                 |

**Codes from:** `../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`.
**Story:** `../02-STORIES/US013.md` — the acceptance criteria the change must satisfy.

---

## 0. What this review covers

The story diff is `git diff e306f48e...6bece79f` — 149 files, +3855 / -640. It has two parts.

1. **The original documentation slice** — workflow `09-debugging-with-logs` (all four files), the
   `code/src/logs/` pair, the `copier.yml` provider comment and `LOG_AGGREGATOR` help,
   `how-to/src/TEMPLATE-TOKENS.md` and `TEMPLATE-GUIDE/05-ANSWERS.md`.
2. **The build-time widening (23/11/2026)** — graphify beside code-review-graph: the executable
   surface `.claude/hooks/graph-update.sh` (+280), its probe suite
   `code/src/scripts/tests/graph-update.sh` (new, 937 lines), the `lefthook.yml` step, the two MCP
   declarations, CI and pre-push registration, and the role-split sweep over 122 files.

Already reviewed and dispositioned — **not re-reported here**: the build-time review (M1-M3, m1-m5,
n1-n4) and QA (findings 1-13), the hung-run bug and its two follow-ups, and every item F-001 to
F-038 in `../20-FINDINGS/archive/FINDING-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md`. This record
checks that none of them regressed and reviews what they did not cover.

---

## 1. Scope & files reviewed

Read in full or at the changed hunks:

| File                                                                                                                   | What was checked                                                                     |
| ---------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `.claude/hooks/graph-update.sh`                                                                                        | Every line: modes, lock, fingerprint, bound, outcome file, JSON emission, exit paths |
| `code/src/scripts/tests/graph-update.sh`                                                                               | Section outline; run on the host                                                     |
| `lefthook.yml`, `.mcp.json`, `.codex/config.toml`                                                                      | The graphify step and the two declarations                                           |
| `.github/scripts/template-integrity.sh`, `.github/workflows/audit-template.yml`, `template-hooks.sh`, `hook-arming.sh` | Self-test registration and fixtures                                                  |
| `copier.yml`, `.dockerignore`, `.markdownlint-cli2.jsonc`, `shipped-readme.sh`, `sync-trees.sh`                        | `graphify-out` exclusions; the suite's copier exclusion                              |
| `code/workflows/09-debugging-with-logs/*`, `code/src/logs/{CONTEXT,CLAUDE}.md`                                         | Every acceptance criterion of the first seven scenarios                              |
| `how-to/src/TEMPLATE-TOKENS.md`, `TEMPLATE-GUIDE/05-ANSWERS.md`, `THIRD-PARTY-NOTICES.md`                              | The reach prose removal, the Alloy drop, the notice                                  |
| `code/docs/CODE-REVIEW-GRAPH.md`, `.claude/hooks/{CONTEXT,CLAUDE}.md`, `.claude/CLAUDE.md`                             | The role split, the advisory status, Section 6 unchanged                             |

**Out of scope:** GDPR, Security (endpoint), SEO, API, Logging, accessibility of rendered markup —
every flag reads `N/A`, and no model, route or screen changed. The CI `Audit — Doc References`
failure is the 21-path baseline deferred to US014 (`DEFERRED.md`:50) and is not this branch's.

---

## 2. Findings

Most severe first. `R-0NN` are this record's; `F-0NN` the archived findings record's.

| ID    | Severity | Axis      | File:line                                            | Issue                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Resolution/Status                                                                                                                                        |
| ----- | -------- | --------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R-001 | Low      | Spec      | `../02-STORIES/US013.md:332`, `:362-365`             | The story still states **full parity** ("wherever the latter is named", R1 Q1 = 3) and a scenario whose Given is "every file outside project-management/src/ and the release logs" and whose Then is "each names graphify". What shipped is narrower, by decision: the inventory also excludes `handoffs/` and `research/` (three `research/` notes name code-review-graph alone), and 12 files are confirmed exemptions. F-020 amended the guide row GRAPH-06 with its trail; the story's own Gherkin and WIDENED comment were not amended, and neither the story nor the plan cites F-020 | Open — add a dated AMENDED note under the WIDENED comment citing F-020/F-022 and the inventory scope line, or record the gap against F-020. Not blocking |
| R-002 | Nit      | Standards | `.claude/hooks/CONTEXT.md:46`                        | The _Files_ table row for `graph-update.sh` still reads "refreshes the graph, names the untracked files it missed". The intro (`:9-11`) and the section at `:100-116` describe the graphify run; this one row does not                                                                                                                                                                                                                                                                                                                                                                      | Open — append "; starts graphify's advisory update" to the row                                                                                           |
| R-003 | Nit      | Standards | `.claude/hooks/graph-update.sh:101-102`, `:152`      | `GRAPH_UPDATE_GRAPHIFY_TIMEOUT` is filtered to digits but not to a range. A value past 64 bits passes, `timeout` accepts it (saturates), and `[ ... -ge "$G_TIMEOUT" ]` then errors ("integer expected", rc 2), so a bound-fired run would read as failed rather than timed out. Measured on the host 23/11/2026. Unreachable in practice: such a bound never fires                                                                                                                                                                                                                         | Optional — cap the digit count in the `case` (e.g. reject more than 6 digits as the fallback)                                                            |
| R-004 | Info     | Standards | `code/src/scripts/tests/graph-update.sh` (937 lines) | Past the 750/800 source limit, but shell scripts are exempt (`code/src/scripts/CLAUDE.md:46`); `hook-arming.sh` (1770) and `doc-references.sh` (3796) are precedent. Its sections are cleanly cut (probes, review-fix, QA-fix, bugfix, bugfix 2)                                                                                                                                                                                                                                                                                                                                            | No action                                                                                                                                                |
| R-005 | Info     | Standards | `.claude/hooks/graph-update.sh:205-219`              | With graphify on PATH, any tree change after a finished run starts another full `graphify update .` (bounded at 600 s). During an active editing session that is close to continuous background CPU. This is the decided cadence (R1 Q3 = per edit), the lock keeps it to one run, and the fingerprint (M1 fix) stops idle re-runs. Its cost on a large tree is unmeasured                                                                                                                                                                                                                  | No action — note for US014 if a latency complaint arrives                                                                                                |
| R-006 | Info     | Spec      | `../02-STORIES/US013.md` _Tasks_                     | Every task box is `[ ]` while the story is `In Review`. Not a defect: US012 and the archived stories carry the same convention, and completion is evidenced by the guide (55 Pass, 0 Fail) and the QA record                                                                                                                                                                                                                                                                                                                                                                                | No action                                                                                                                                                |

No Critical or High finding, so nothing is escalated to `src/10-SECURITY/VULNERABILITIES/`.

---

## 3. Dimension checklists

### 3.1 Standards axis

- [x] **The hook, line by line.** Always exits 0 on every path (`:90`, `:91`, `:130`, `:132`,
      `:142`, `:161`, `:238`, `:288`). `GRAPHIFY_FORCE` unset (`:80`); no `--force` anywhere; every
      git call read-only with `GIT_OPTIONAL_LOCKS=0` (`:81`, `:109-113`). The outcome lands by one
      rename (`:156`); the trailer always starts its own line (`:150`); the exit code is reduced to
      digits before JSON (`:189`); every message is a fixed string plus digits or a constant path, so
      the unescaped `printf` at `:286` cannot emit a quote. The killed-run marker is written and
      cleared under the lock (`:135`, `:157`). F-017 to F-029 hold at HEAD.
- [x] **Probe suite green:** `bash code/src/scripts/tests/graph-update.sh` — **199 passed, 0
      failed**, on the host, 23/11/2026, matching `../18-TESTS/AUTOMATED/US013-TEST-STATUS.md:114`.
- [x] **MCP parity:** `bash code/src/scripts/audits/mcp-parity.sh` — "Claude and Codex declare the
      same MCP servers". Both run `uvx --from "graphifyy[mcp]" graphify-mcp`, unpinned.
- [x] **lefthook step** runs `graph-update.sh --commit || true`; commit mode makes no
      code-review-graph call and starts only the detached run, so the commit never waits.
- [x] **Self-test registration agrees in three places:** `template-integrity.sh` `SELF_TESTS`,
      `audit-template.yml` [1/4], and `template-hooks.sh`'s pre-push oracle. `hook-arming.sh` hides
      graphify so its commit fixtures start no real refresh.
- [x] **Copier exclusion** of the suite is declared on its doc lines with `template-only`
      (`code/src/scripts/tests/CONTEXT.md:39`, `:67`, `:198`; `CLAUDE.md:18`). `graphify-out` is
      excluded from copier, Docker, markdownlint, `sync-trees.sh` and `shipped-readme.sh`, and is
      gitignored (`.gitignore:116-117`).
- [x] **Provider neutrality:** graphify is developer tooling, not an infrastructure dependency, so
      no `PLATFORM-PROVIDERS.md` row is owed; `THIRD-PARTY-NOTICES.md` records Apache-2.0, run as-is.
- [x] **Doc gates on the host, 23/11/2026:** `docs-length.sh` (818 files within 300, 3 approaching),
      `docs-pairing.sh` (split intact), `doctrine-drift.sh` (4 claims, one home each),
      `skill-conformance.sh` (every skill conforms), `pm-board.sh --check` (8 boards current,
      `archive/` untouched).
- [x] **Writing conventions** (`VERSIONING-AND-DOCS.md` Section 2) in the added prose read: no
      U+00A7; British spelling.
- [x] Nits R-002 and R-003 only.

**Standards verdict: Pass with minor changes** (R-002, R-003 — both Nit).

### 3.2 Spec axis — each criterion traced

| Scenario                                                 | Satisfied at                                                                                                                                                                                                                                                                                                               | Result                                                                                      |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Every command runs through the project scripts           | 09 `STEPS.md:35` `server.sh up`, `:39` `logs.sh --service django --follow`, `:53-67` one `shell.sh` session at `/workspace/code/src/logs/django.log`, `:70-71` points to the pair; no `backend` service argument in scope                                                                                                  | Met                                                                                         |
| No vendor literal survives unmarked                      | Case-insensitive grep of the four 09 files and the logs pair: every Loki/Grafana/Alloy/Prometheus site sits under its file's marker (`STEPS.md:93-96`, `CHECKLIST.md:19-20`, `CONTEXT.md:7-8`, `CLAUDE.md:11-12`, logs `CONTEXT.md:5-6`, `CLAUDE.md:29-30`); the browser-errors sentence at `STEPS.md:150-152` is verbatim | Met                                                                                         |
| A project with its own answers reads its own names       | Tokens at every backend site; render proof is the guide's RENDER rows (Pass, Bugsink / Fluent Bit sed render)                                                                                                                                                                                                              | Met                                                                                         |
| The workflow stops at the root cause                     | Preamble `STEPS.md:10-12`; fix boxes gone (`CHECKLIST.md` diff); `:182-183` the 21-BUGS filing at the end of Step 5; `CHECKLIST.md:29-30` reworded; no External — Testing                                                                                                                                                  | Met                                                                                         |
| A dev fault found early is still handed to 10-debug      | Handoff sits in the preamble above Step 1; Steps 1-2 send nowhere further                                                                                                                                                                                                                                                  | Met                                                                                         |
| Verification with no deploy runs nothing                 | `STEPS.md:191-197`: precondition owned by `<%DEPLOY_REPO%>`, cites `FEATURE-DEPLOY.md`, no command, 30 minutes, dashboards not Grafana                                                                                                                                                                                     | Met                                                                                         |
| The copier and register enumerations of token reach gone | `copier.yml:508-519` no token list or reach claim, guard and pointer kept; `TEMPLATE-TOKENS.md` reach paragraph deleted; `LOG_AGGREGATOR` help (`:544-550`) gains the bare-name sentence and drops Alloy; `05-ANSWERS.md:124` matches                                                                                      | Met                                                                                         |
| graphify declared to both hosts                          | `.mcp.json`, `.codex/config.toml`; parity audit exit 0                                                                                                                                                                                                                                                                     | Met                                                                                         |
| Per-edit hook refreshes graphify detached                | Hook `:205-219`, `:241-249`; 199 probes                                                                                                                                                                                                                                                                                    | Met                                                                                         |
| Commit runs graphify as an advisory                      | `lefthook.yml` `graphify` step; commit mode `:236-239`                                                                                                                                                                                                                                                                     | Met                                                                                         |
| Every code-review-graph site names graphify by its role  | 112 inventoried files name both; 12 confirmed exemptions (F-020, F-022); `.claude/CLAUDE.md` 3.1, 3.3 and `CODE-REVIEW-GRAPH.md` state the split; Section 6's gate unchanged                                                                                                                                               | Met as narrowed by decision — the story text still states the un-narrowed criterion (R-001) |
| A project without graphify loses nothing but the graph   | `absent` path reports unmeasured and starts nothing; `install.sh` names neither tool                                                                                                                                                                                                                                       | Met                                                                                         |
| graphify's output never reaches the lint                 | `.markdownlint-cli2.jsonc` ignores `graphify-out/**`; guide GRAPH-08 Pass (amended, F-021)                                                                                                                                                                                                                                 | Met                                                                                         |

**Spec verdict: Meets spec**, with R-001 a record gap rather than a functional one.

### 3.3 Step 6 verification (records from `22`)

- [x] **QA plan applies** (the only non-N/A flag): `../11-QA/IMPLEMENTATION/QA-IMPL-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md` present, approved by the developer (`6bece79f`).
- [x] **Automated record** `US013-TEST-STATUS.md`: generated block empty by design (shell suites
      carry no story marker); Sections 2-3 by hand; the 199 / 69 / 432 counts match this review's
      run of the first and the recorded runs of the other two.
- [x] **Manual guide** `US013-MANUAL-TESTING.md`: 55 Pass, 0 Fail; GRAPH-06 and GRAPH-08 amended
      with trail and finding (F-020, F-021); _Failures_ "None."
- [x] **Findings record** archived, F-001 to F-038 each with a disposition.

### 3.4 Security, GDPR, performance, accessibility

- [x] **Security:** no endpoint, secret or `.env` read. The hook executes host binaries from `PATH`
      under the same trust as code-review-graph, passes only a digit fingerprint to its own detached
      re-invocation, and writes only under the gitignored `.code-review-graph/`.
- [x] **GDPR/PII:** N/A — no personal data.
- [x] **Performance:** per-call cost is three read-only git listings and a `cksum`; see R-005.
- [x] **Accessibility:** N/A — no UI.

---

## 4. Required actions before the story is accepted

None blocking. R-001 is a cheap record amendment; R-002 and R-003 are optional polish. If left,
they need no re-review.

---

## 5. Verdict & status transition

- **Verdict:** Approve-with-nits.
- **Reasoning:** Every acceptance criterion traces to the merged tree. The one executable surface is
  sound on every exit path, its 199-probe suite is green, and the earlier review, QA and bug fixes
  hold at HEAD. What remains is one Low record gap and two Nits.
- **Status transition:** none from this step. US013 stays `In Review`; `In Review` -> `Accepted`
  is recorded by `completion` through `23-pr-and-review` Step 5.

---

## 6. Notes and limits

- **Not run here:** the code-review-graph review playbook (`detect_changes` and the rest) — the
  change is one shell hook plus documentation, which the graph indexes only at file level, so
  `git diff`, Read and Grep were used instead. The generated-project render, the live dev-stack
  command walk and CI were not re-run; their evidence is the guide's walked rows and the CI runs
  recorded in F-012.
- **Not loaded, by instruction:** `qa-tester`, `test-writer` and `review` (F-036, F-037). The final
  QA pass is the QA implementation record's.
- The host gates ran against the working tree on `dev`, which held another session's uncommitted
  PM edits (US012 records, US013 status line); none touches a file this review judges.

---

## Cross-references

- `../02-STORIES/US013.md` — the story under review
- `../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the plan
- `../18-TESTS/AUTOMATED/US013-TEST-STATUS.md` · `../18-TESTS/MANUAL/US013-MANUAL-TESTING.md`
- `../11-QA/IMPLEMENTATION/QA-IMPL-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md`
- `../20-FINDINGS/archive/FINDING-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md` — F-001 to F-038
- `../21-BUGS/archive/BUG-US013-GRAPHIFY-HOOK-HUNG-RUN-SILENT-23-11-2026.md` — fixed at `a3a4f86d`
- `project-management/workflows/23-pr-and-review/` · `code/workflows/07-review/`
