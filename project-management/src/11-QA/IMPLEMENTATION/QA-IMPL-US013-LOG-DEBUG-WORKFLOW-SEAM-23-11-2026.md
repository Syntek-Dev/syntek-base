# QA Implementation Review — US013 The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause

| Field        | Value                                                                                                                                                                                                                           |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US013 — the 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause                                                                                              |
| **Date**     | 23/11/2026                                                                                                                                                                                                                      |
| **Sprint**   | SPRINT-08                                                                                                                                                                                                                       |
| **Reviewer** | Claude — a `22-implementation-documentation` subagent that wrote none of the story's edits, from the walked guide, the CI run and the diff; the adversarial pass was the `qa-tester` review (QA 1 to QA 7)                      |
| **Branch**   | `us013/log-debug-workflow-seam` — cut from `dev` at `e306f48e`, no worktree; reviewed at `79a22cb7` (pushed head `58f3c78e`)                                                                                                    |
| **Plan doc** | `../PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`                                                                                                                                                                          |
| **Outcome**  | **Pass with deviations — one scenario pending.** HP-14 rests on WALK-06, the developer's own reading of the stop instruction, not yet recorded; every other scenario closed with evidence. Deviations are read-only (Section 4) |

---

## 1. Scope

What shipped: the six files — `code/workflows/09-debugging-with-logs/` `STEPS.md`, `CHECKLIST.md`,
`CONTEXT.md`, `CLAUDE.md` and `code/src/logs/` `CONTEXT.md`, `CLAUDE.md` — routed through the
`code/src/scripts/**/*.sh` seam, their error-tracker and log-aggregator names tokenised, one
reference-stack marker each, and the fix and regression test cut from 09 and handed to `10-debug`;
the `copier.yml` comment (`:503-515`) and `LOG_AGGREGATOR` help; `how-to/src/TEMPLATE-TOKENS.md`;
the `05-ANSWERS.md` mirror; and the dated S-07 note on `MAP-RULE-OWNERSHIP.md`. Build commits
`9afc4e44` (P1 to P5), `552c3fc4` (review F-1, F-4), `58f3c78e` (QA 1, QA 2). The surface is
Markdown and one YAML comment: no model, no endpoint, no screen.

**Scope matches the plan**, read through the story plan's CORRECTED 23/11/2026 block: cut from
`dev`, no worktree, the `copier.yml` anchors drifted `:470-483` to `:503-516` with text unchanged,
and every F-001 count re-measured at `e306f48e` and held. No addition.

## 2. Acceptance-criteria gaps closed

All twelve gaps in the plan's Section 1 read `[RESOLVED] 31/10/2026`, written into the story then.
Each is checked here against what shipped.

| Gap                                                           | Status   | Evidence                                                                                                                                       |
| ------------------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-GAP-1 — vendor checks case-sensitive by implication        | Resolved | Every vendor search ran `grep -oi`: `glitchtip` 0 (TOKENS-06), `sentry` 0 (TOKENS-09), `loki` 10 (TOKENS-07)                                   |
| AC-GAP-2 — the Sentry SDK protocol name carve-out             | Resolved | Only the backend name is tokenised; the Sentry render reads "…forwards them to Sentry (Step 3), never to Loki.", "Sentry's Sentry" 0 (READ-03) |
| AC-GAP-3 — LogQL sentences cannot take a substituted name     | Resolved | The two LogQL-bound sites held literal under the Steps 4-5 marker (TOKENS-07, MARKERS-01); mismatch recorded against S-07 (MARKERS-04)         |
| AC-GAP-4 — `LOG_AGGREGATOR` help lacks the bare-name sentence | Resolved | The help carries the bare-name line (COPIER-03)                                                                                                |
| AC-GAP-5 — Q8's reach, inside and outside Step 4              | Resolved | Fluent Bit 5/0/1/2/2/2 = 12 (TOKENS-04); 4 held `Loki` sites (TOKENS-07); STEPS:179 reads "…with the log lines from Step 4." (TOKENS-08)       |
| AC-GAP-6 — the marker's content against the exact counts      | Resolved | Each marker names the stack with no token and Loki once, cites `PLATFORM-PROVIDERS.md` (MARKERS-02); counts by position held (TOKENS-03, -04)  |
| AC-GAP-7 — the unmarked-literal grep on the default CI paths  | Resolved | CI paths checked for unrendered tokens only (RENDER-01); the grep ran on the Bugsink / Fluent Bit render only (TOKENS-10)                      |
| AC-GAP-8 — the `10-debug` handoff unreachable on the dev path | Resolved | The handoff sits in the 09 `STEPS.md` preamble above Step 1 (CUT-01); its walk-reading is HP-14, pending (Section 6)                           |
| AC-GAP-9 — `CHECKLIST.md`:38, :39, :56 boxes                  | Resolved | `:38` reworded to the handoff, corrected again by QA 1 in `58f3c78e` (CUT-02, CUT-03); `:39` and `:56` left to S-04 as ruled                   |
| AC-GAP-10 — `Alloy` offered for `LOG_AGGREGATOR`              | Resolved | Help reads "Loki, Vector, Fluent Bit, CloudWatch" (COPIER-03); 09 `CLAUDE.md`:17 carries no "/Alloy" (COPIER-05)                               |
| AC-GAP-11 — other surfaces still offering `Alloy`             | Resolved | `05-ANSWERS.md` mirror names the same four (COPIER-04); the two "proven alternates" lists stay, for the `DEFERRED.md` entry written at close   |
| AC-GAP-12 — the recorded reason for dropping `Alloy`          | Resolved | The reason is the reference shipper's own name, as ruled; Vector and Fluent Bit stay listed (COPIER-03). Its residue is QA 3 (Section 5)       |

## 3. Scenario verification

Row IDs are `../../18-TESTS/MANUAL/US013-MANUAL-TESTING.md`'s, walked at `79a22cb7` on 23/11/2026;
no automated suite applies (a documentation-only story), so every scenario is closed by a manual
row, the CI run, or a commit. The live walk (WALK-01 to WALK-05) was typed by
<%DEVELOPER_NAME%> on the main checkout's dev stack at `58f3c78e` and is recorded in the guide's
live-walk capture; WALK-06 is not yet recorded.

### Happy Path

| ID    | Scenario (from plan)                                                        | Result      | Evidence                                                                                                                                                           |
| ----- | --------------------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| HP-01 | No runnable `docker` in a fenced block; the wrap prose and never-rules stay | Pass        | SEAM-01 (none found), SEAM-02 (matrix label, tooling line and both never-invoke rules present, meaning unchanged from `e306f48e`)                                  |
| HP-02 | Step 1 typed: `server.sh up` then `logs.sh --service django --follow`       | Pass        | Live walk WALK-01 (`✓ Stack is up.`, site URL printed), WALK-02 (`logs.sh — django (following)`, `GET /health/` 200 lines)                                         |
| HP-03 | Step 2 typed in one `shell.sh` session; each read returns from `django.log` | Pass        | Live walk WALK-03 (one session at `/workspace`), WALK-04 (`tail -f`, level grep, `apps.users` grep, `tail -n 100`; no missing-file error)                          |
| HP-04 | The Log rotation truncate empties `django.log`; Step 2 points to it         | Pass        | Live walk WALK-05 (truncate in the same session; `tail -n 100` then printed nothing); one copy, Step 2 points to it (READ-01)                                      |
| HP-05 | CI `[3/4]` renders both `INCLUDE_MOBILE` paths with 0 unrendered tokens     | Pass        | Run `45161301722`, job `137647123206`, push at `58f3c78e`, success, both `0 unrendered tokens` lines (RENDER-01). Caveat in Section 4                              |
| HP-06 | Bugsink at the 18 sites, Fluent Bit at the 12, site by site                 | Pass        | TOKENS-02 (render in `/tmp`, no symlinks, `git status` empty), TOKENS-03 (Bugsink 9/2/2/3/1/1 = 18), TOKENS-04 (Fluent Bit 5/0/1/2/2/2 = 12), each anchor read     |
| HP-07 | No step writes a test or fix; handoff in the preamble; steps renumbered     | Pass        | CUT-01 (preamble hands off to `10-debug`; Step 5 ends with the `21-BUGS/` line; steps 1 to 7), CUT-02 (six boxes and two headings gone; "External — Testing" gone) |
| HP-08 | Verify step: deploy precondition, no command, no vendor, 30 minutes         | Pass        | CUT-06 (owned by `<%DEPLOY_REPO%>`, cites `FEATURE-DEPLOY.md`, no command, vendor-free error-rate read; step and box both 30 minutes)                              |
| HP-09 | No token-reach list or claim; shape rule kept; bare-name line added         | Pass        | COPIER-01 (`copier.yml`:503-515 word for word with US013:428; PostgreSQL line survives), COPIER-02, COPIER-03                                                      |
| HP-10 | Four doc gates: three exit 0, `doc-references.sh` no new finding            | Pass        | GATES-01 (818 within 300), GATES-02 (238/228), GATES-04 (4 claims, one home each), GATES-03 (exit 1, 21 findings, identical to the P0 baseline by file and target) |
| HP-11 | The `21-BUGS/` box traces to Step 5; `:38` reworded; `:39`, `:56` excluded  | Pass        | CUT-03 (box resolves to the end of Step 5; every other box maps to a step), CUT-02; `:38`'s wording repaired by QA 1 in `58f3c78e`                                 |
| HP-12 | Outputs and Definition of done hand the regression test to `10-debug`       | Pass        | CUT-04 (Outputs, Definition of done and Guardrails all hand it off; nothing says it is written in 09)                                                              |
| HP-13 | Dated S-07 note names the four held `Loki` sites; `DEFERRED.md` untouched   | Pass        | MARKERS-04 (dated 23/11/2026 note on the S-07 row; `DEFERRED.md` absent from both the `main...` and `e306f48e..9afc4e44` diffs)                                    |
| HP-14 | A dev fault rooted at Step 2: the reader stops there                        | **Pending** | Rests on WALK-06, the developer's reading of the stop instruction, not yet recorded. The text half holds (CUT-01: the handoff sits above Step 1); not marked Pass  |

### Error States

| ID    | Scenario (from plan)                                                 | Result               | Evidence                                                                                                                             |
| ----- | -------------------------------------------------------------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| ES-01 | Non-default render: `glitchtip` case-insensitive, 0 hits             | Pass                 | TOKENS-06: 0                                                                                                                         |
| ES-02 | `loki`: the 4 held sites plus one per marker, 10 in all              | Pass                 | TOKENS-07: 10 (4 held plus 1 in each of 6 markers); TOKENS-08: STEPS:179 vendor-free                                                 |
| ES-03 | Every `grafana`, `alloy`, `prometheus` hit within its marker's scope | Pass                 | TOKENS-10: every hit at or below its file's marker and within scope (STEPS 92-164, before the `---` at 184; CHECKLIST 19-24)         |
| ES-04 | No surviving token delimiter on any of the three renders             | Pass                 | TOKENS-11 (both `/tmp` renders: no delimiters); RENDER-01 (the CI step's own 0 unrendered tokens, both paths)                        |
| ES-05 | A differing count fails and records both numbers                     | Pass — not triggered | TOKENS-05: every count equals its expected figure, so the fail path did not fire; both numbers are in the render record              |
| ES-06 | Dev stack not running: recorded unmeasured, never passed             | N/A — did not arise  | The stack came up (WALK-01), so the unmeasured path was not needed; the guide's WALK-01 row carries the rule had it been             |
| ES-07 | `backend` as a Compose service or `logs.sh` argument fails the story | Pass                 | SEAM-03: `backend` only in the LogQL selectors (S-07's), prose and the "CI Probe Backend" dashboard name                             |
| ES-08 | Exactly one marker per file at its anchor, with the minimum content  | Pass                 | MARKERS-01 (STEPS:92, CONTEXT:7, CLAUDE:11, CHECKLIST:19, logs CONTEXT:5, logs CLAUDE:29), MARKERS-02 (opening, citation, Loki once) |
| ES-09 | Every source token is a defined top-level `copier.yml` question      | Pass                 | TOKENS-01: ERROR_TRACKING ×18, LOG_AGGREGATOR ×12, PROJECT_SLUG ×5, PROJECT_NAME ×1, DEPLOY_REPO ×1, all defined                     |

### Edge Cases

| ID    | Scenario (from plan)                                               | Result | Evidence                                                                                                                                       |
| ----- | ------------------------------------------------------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | `ERROR_TRACKING` = Sentry: "…to Sentry (Step 3), never to Loki."   | Pass   | READ-03, the EC-01 row-check render of 09 `STEPS.md` at `79a22cb7`; "Sentry's Sentry" 0                                                        |
| EC-02 | `Fluent Bit` read aloud: no sentence breaks                        | Pass   | READ-02: the render ends "…to Bugsink (Step 3), never to Fluent Bit."; no substituted sentence breaks. Source half read per the F-1 build note |
| EC-03 | "Prometheus + Grafana dashboards" literal below the CONTEXT marker | Pass   | MARKERS-03: literal in source and render, below the marker                                                                                     |
| EC-04 | The opt-in surfaces render the six files identically               | Pass   | RENDER-02: no `_exclude` entry names either directory; 0 block delimiters in the six files                                                     |
| EC-05 | The `django.log` truncate appears once, Step 2 pointing to it      | Pass   | READ-01: `truncate -s` once, in logs `CONTEXT.md` Log rotation; Step 2 points to it                                                            |
| EC-06 | Every "Step N" citation of 09 resolves after the renumber          | Pass   | CUT-05: every internal reference resolves; no live doc outside 09 cites a 09 step (PM records citing old Steps 6-8 are dated history)          |
| EC-07 | Help and mirror list four answers with no `Alloy`; no "/Alloy"     | Pass   | COPIER-03 (help list), COPIER-04 (`05-ANSWERS.md` row), COPIER-05 (09 `CLAUDE.md`:17)                                                          |

### Permission and Access

**N/A** — the plan's `PA` section reads N/A: no endpoint, view, protected action or role boundary.

## 4. Deviations from plan

| Deviation                                                                                                 | Justification                                                                                                                                                                                                    |
| --------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Branch cut from `dev` at `e306f48e`, no worktree; the `copier.yml` anchors moved `:470-483` to `:503-516` | Settled at the implement-story grilling of 23/11/2026 and written into the story plan's CORRECTED block before code. Counts re-measured and held (F-001 re-measure). No scenario's intent changed                |
| Step 4's browser-errors sentence writes both tokens bare where the PM artefacts quote them in backticks   | Review F-1 (Minor), resolved by the plan's CORRECTED build note: the AC gherkin and EC-01/READ-02's render expectations fix the target as bare, so READ-02's source half is read with the backticks as quotation |
| HP-05 read on the pushed head `58f3c78e`, not the local `79a22cb7`                                        | `79a22cb7` changes only the manual guide, adding the defined tokens `DEVELOPER_NAME` and `PROJECT_SLUG`. Re-read the CI run once the closeout head is pushed (RENDER-01 Notes)                                   |
| MARKERS-04 checked `DEFERRED.md` against a `main...` base predating the decision to cut from `dev`        | The expected outcome holds on both bases (`main...9afc4e44` and the build-only `e306f48e..9afc4e44`); noted rather than amended                                                                                  |
| Live walk at `58f3c78e`, the mechanical walk at `79a22cb7`                                                | The intervening commit touches only the manual guide, none of the six files                                                                                                                                      |

## 5. New edge cases discovered

From the review (F-1 to F-4) and the `qa-tester` pass (QA 1 to QA 7), each a case the plan did not
foresee. Dispositions are recorded in the US013 findings record in `../../20-FINDINGS/`.

| ID       | Scenario                                                                                                                                                                                                        | Result      | Evidence                                                                                               | Fold back?                                           |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| F-1      | Step 4's tokens written bare against the artefacts' backtick quotation                                                                                                                                          | Resolved    | Story plan CORRECTED block, build note 23/11/2026                                                      | No — recorded                                        |
| F-2      | `.claude/CLAUDE.md` Section 6 hands `development/shell.sh` and `logs.sh` to the developer as one command block; 09 `STEPS.md` does not say so                                                                   | Open        | Outside US013's edit text                                                                              | Deferred — S-04 owns 09's shape                      |
| F-3/QA 3 | `LOG_AGGREGATOR` is "shipped and queried", but Vector and Fluent Bit are shippers: renders read falsely at "query `<%LOG_AGGREGATOR%>` next", the Django-exception and frontend-stream sites, and the logs pair | Open        | The same reason Q16/Q18 dropped `Alloy`; five sites across 09 `STEPS.md` and the `code/src/logs/` pair | Deferred — the proven-alternates `DEFERRED.md` entry |
| F-4      | The `<LA>/<ET>` slash pair in 09 `CLAUDE.md`                                                                                                                                                                    | Fixed       | `552c3fc4` ("or")                                                                                      | No                                                   |
| QA 1     | `CHECKLIST.md` logging box claimed `10-debug` "adds it"                                                                                                                                                         | Fixed       | `58f3c78e`; CUT-02, CUT-03 walked after it                                                             | No                                                   |
| QA 2     | `code/src/logs/CONTEXT.md` follow command was bare `logs.sh` under a false comment                                                                                                                              | Fixed       | `58f3c78e`                                                                                             | No                                                   |
| QA 4     | Step 6 (verify) has no re-entry from `10-debug`                                                                                                                                                                 | Open        | Workflow shape                                                                                         | Deferred — S-04 (US020 provisional)                  |
| QA 5     | Step 1 and 2 fences mix a never-ending follow with runnable commands; `tail -f` blocks the next reads                                                                                                           | Open        | Observed in the live walk (WALK-02, WALK-04 each stopped with Ctrl-C)                                  | Deferred — folded into F-2                           |
| QA 6     | Step 2 headed "(dev / test)" but `shell.sh` is hard-wired to `docker-compose.dev.yml`                                                                                                                           | Known limit | Pre-existing, not introduced by US013                                                                  | Deferred                                             |
| QA 7     | The `copier.yml`:511 comment names only `PLATFORM-PROVIDERS.md` as a render target                                                                                                                              | No action   | Exactly the story's specified text (COPIER-01)                                                         | No                                                   |
| —        | Manual rows with QA `—`: TOKENS-09 (`sentry` 0 in the non-default render), GATES-05 (whole-tree lint and format)                                                                                                | Walked      | Both `Pass` in the guide                                                                               | No — process rows, not scenarios                     |

Process notes, none a scenario: the P0 `doc-references.sh` baseline run overlapped an edit to the
guide (declared in its capture; no effect on the diff); the first CI capture (run `45158695645` on
`9afc4e44`) was superseded by run `45161301722` on `58f3c78e`; US012's carried F-001 and F-002 were
applied at P0.

## 6. Deferred scenarios

| Scenario                                         | Reason                                                                                                                     | When to address                                                    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| HP-14 — the dev reader stops at Step 2 (WALK-06) | Pending, not deferred: it is the developer's own reading of the stop instruction in the live walk, and is not yet recorded | Before sign-off, in this closeout — recorded by <%DEVELOPER_NAME%> |

## 7. Accessibility observations

N/A — no rendered screen or interactive component (plan Section 3). The ✅/❌ tool matrix in 09
`CONTEXT.md` is unchanged by the story.

- **axe-core** — N/A, no route
- **Keyboard & focus** — N/A
- **Equal-weight actions** — N/A
- **Other** — Markdown read in an editor or on a code host only

## 8. GDPR & security observations

N/A — no personal data processed (plan Section 5). The GDPR, Security, SEO, API and Logging flags
are all N/A for this story, so no other IMPLEMENTATION record is written for it.

- **PII at rest** — N/A
- **PII in responses** — N/A
- **Rights paths** — N/A
- **Security gate** — N/A, no protected action. The one data-shaped constraint holds: the live-walk
  capture keeps no log contents (QA plan Section 5), and no live `.env.*` file was read

## Sign-off checklist

- [ ] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6 — **HP-14 pending on WALK-06**
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build — N/A recorded
- [x] GDPR & security observations confirmed (or N/A recorded)
- [ ] Coverage floors met for all modules in scope — **N/A**, no Python module in scope; left unticked rather than claimed
- [ ] Manual testing sign-off (see `../../18-TESTS/MANUAL/US013-MANUAL-TESTING.md`) — 39 mechanical rows `Pass` at `79a22cb7`; WALK-01 to WALK-05 walked live by <%DEVELOPER_NAME%> at `58f3c78e`; WALK-06 pending
- [ ] Reviewer approval — **blocks merge until complete**

---

## Cross-references

- `../PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the pre-development plan verified here
- `../../02-STORIES/US013.md` — the story under review
- `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the plan, its CORRECTED 23/11/2026 block first
- `../../18-TESTS/MANUAL/US013-MANUAL-TESTING.md` — the walked guide; the automated record sits in `../../18-TESTS/AUTOMATED/`
- `../../20-FINDINGS/` — the US013 findings record, written at Step 5 of this closeout
- `../../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` — the S-07 note and the S-04 slice the deferrals route to
- `../../19-REVIEWS/` — code-review notes from the same PR, written at `23-pr-and-review`
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
