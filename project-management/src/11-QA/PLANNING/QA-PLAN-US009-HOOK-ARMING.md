# QA Plan — US009 The git hooks arm on purpose at install

| Field         | Value                                                                                                   |
| ------------- | ------------------------------------------------------------------------------------------------------- |
| **Story**     | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true |
| **Date**      | 17/09/2026                                                                                              |
| **Sprint**    | SPRINT-05 — this story is its stretch `Should`, 5 of 13 SP                                              |
| **Wireframe** | N/A — this story ships bash and one JSON manifest read, not a screen                                    |
| **Status**    | Signed off · **corrected in place 30/09/2026** — see below                                              |

<!-- SIGNED OFF 30/09/2026 by <%DEVELOPER_NAME%> (settled 30/09/2026, 16-sprint-plans grilling
     round 3 Q9), against the tree at a18db0b with that gate's corrections applied. The Status row
     read "Reviewed — all nine gaps resolved into the story, 17/09/2026" until then. What was
     corrected, and why, is the note below. -->

<!-- STEP 1's GRILLING PASS DID NOT RUN. <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10
     and 11 be written for both SPRINT-05 members first and the decisions taken afterwards. Status
     is Draft, not Signed off, and every gap below is [OPEN]: none has been fed back into US009.md,
     because feeding a gap back is a story edit and the decisions have not been made.

     11-QA/PLANNING/CLAUDE.md: "do not proceed to a sprint plan while a story carries an unresolved
     [OPEN] acceptance-criteria gap". Nine [OPEN] gaps stand below, so 16-sprint-plans is BLOCKED
     on US009 as well as on US008.

     METHOD. Every line citation in the story was re-opened in the tree on 17/09/2026. All of the
     install.sh and install-frontend.sh citations hold. The pass then asked the question the story
     does not: WHERE do the hooks currently arm from? That sweep produced AC-GAP-1, which is the
     largest finding in either SPRINT-05 story, and it is the reason this gate's Security half was
     worth filling despite the map's manifest leaving it blank (US006.md:15-22).

     code/docs/GATE-REPORTING.md: the absence of the interview is stated, not implied. -->

<!-- AMENDED 28/09/2026. The comment above is the record of 17/09/2026 before `15-decisions` ran,
     and is kept as that record. By the end of that day its "Status is Draft", "every gap below is
     [OPEN]" and "16-sprint-plans is BLOCKED on US009" had each stopped being true: the Status row
     read Reviewed, and Section 1 marks all nine gaps [RESOLVED] 17/09/2026 and records
     `16-sprint-plans` as unblocked on US009.

     Corrected in place today, against the Accepted
     `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`
     and the step placement and guard `15-decisions` wrote into
     `project-management/src/02-STORIES/US009.md`. HP-01 and HP-05 are the answer itself (settled
     28/09/2026, 16-sprint-plans grilling round 2 Q8). ES-03, EC-01, PA-01, PA-02 and the
     paragraph beneath them, and the worktree note in Section 6, are calls made while applying it,
     not its answers, which <%DEVELOPER_NAME%> reviewed and accepted (settled 30/09/2026,
     16-sprint-plans grilling round 5 Q16). Each still described the story as first written.
     Every superseded wording is kept in a dated comment beside its correction. No gap, scenario
     ID or finding moved, and Status stayed Reviewed until the sign-off of 30/09/2026 below. -->

> **Corrected in place, 30/09/2026, at the `16-sprint-plans` gate, and signed off by
> <%DEVELOPER_NAME%>**: gate 11 closes when a QA plan reads `Signed off`, as gate 10 does (settled
> 30/09/2026, 16-sprint-plans grilling round 3 Q9). What the sign-off found missing or moved was
> repaired in the same pass rather than left under a signature. The missing `postinstall`
> scenarios were on the list round 3 Q11 settled (settled 30/09/2026, 16-sprint-plans grilling
> round 3 Q11); the one stale statement is a call made 30/09/2026 while applying round 3, not
> one of its answers, on the pattern round 2 Q5 set for the gate-10 plans. <%DEVELOPER_NAME%>
> reviewed every change made under this sign-off, each call labelled here and in the dated
> comments below among them, and accepted them all (settled 30/09/2026, 16-sprint-plans grilling
> round 5 Q16):
>
> - **The `postinstall` has its scenarios** (round 3 Q11). Since 17/09/2026
>   `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`
>   has replaced `prepare` with a `postinstall` that announces the unarmed state and arms nothing,
>   and the story carries it as `ST02b`, a Gherkin scenario, a probe criterion and a probe task.
>   This plan named it only in PA-02's `CI` clause. HP-08 is the printing case; EC-09, EC-10,
>   EC-11 and EC-13 are its four silences, EC-10 carrying the probe's wrong-reason pass; EC-12 and
>   EC-14 are the two checkouts where a careless guard would silence it wrongly; ES-06 is the
>   notice failing an install; PA-03 is what the script may touch. Section 5 counted four
>   QA-visible constraints and now counts five, the first being Section 7.1's closed channel and
>   its announcing replacement; Section 6 gains the probe note, and the PA section records where
>   the notice is swallowed.
> - **ES-06 is a story criterion as well** (settled 30/09/2026, 16-sprint-plans grilling
>   round 5 Q16). No line of the story stated it, so it is fed back into
>   `project-management/src/02-STORIES/US009.md` as an automated QA criterion, `:376-381`, with
>   its test task at `:508-509`, and story and plan agree
>   (`project-management/workflows/11-qa-checks/` Step 5).
> - **Two citations had moved**, both by `f045aac` (18/09/2026), the text unchanged:
>   `.copier/README.md:441` is now `:442` (HP-06) and `lefthook.yml:66-69` is now `:73-76`
>   (AC-GAP-7, EC-05's `:69` now `:76`). Each is re-pointed where it is live and kept where it
>   records the 17/09/2026 reading.
> - **Every other line citation was re-measured on 30/09/2026**, against the tree committed
>   together with the 18-TESTS split, and holds or is re-pointed. `install.sh`,
>   `install-frontend.sh`, `package.json`, `pnpm-lock.yaml`, `code/src/scripts/mobile/install.sh`,
>   `.claude/hooks/`, the five workflow files, `audit-template.yml` and the two worktree guides are
>   unchanged since `1e00a4b`, where this plan was measured. `copier.yml` is not: the 18-TESTS
>   split adds 21 lines above the `git init` task, so Section 6's `:1025` sits at `:1046`, its old
>   number kept in a dated comment beside it. The sweep behind AC-GAP-1 and AC-GAP-3 re-counts the
>   same in that tree: sixteen executable `pnpm install` invocations, five with `--ignore-scripts`,
>   eleven without, at the same lines. The story and story-plan lines the new scenarios and
>   Section 6 cite were measured the same day, against the same tree.
> - **One statement had gone stale** (the call). The cross-reference to
>   `code/docs/GATE-REPORTING.md` still spoke of "the PA rows written as failing tests", which they
>   stopped being on 28/09/2026.
> - **One divergence is settled from the record.** HP-06 asserted `.copier/README.md` unmodified,
>   as the story did, while the story plan edits it; the plan had already carved that edit out, so
>   "unmodified" covers the `lefthook install` sentence at `:442` and nothing else, and HP-06, the
>   story and SPRINT-05 now say so (recorded in 09-STORY-PLAN-US009 P3, 18/09/2026; applied
>   30/09/2026 at the 16-sprint-plans gate; Section 6). The PA section's pointer to the story
>   plan follows that plan's own correction the same day, which dropped the stderr route
>   (settled 30/09/2026, 16-sprint-plans grilling round 4 Q15). Both are changes made under this
>   sign-off, reviewed as round 4 Q12 required (settled 30/09/2026, 16-sprint-plans grilling
>   round 4 Q12) and accepted with the rest (settled 30/09/2026, 16-sprint-plans grilling
>   round 5 Q16).
> - **The section sign is gone.** The writing conventions ban it
>   (`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2); its fourteen uses read
>   "Section" now, as the gate-10 plans did.
>
> This is a correction rather than a supersession because no gap, finding or severity moved and no
> scenario was renumbered: each new scenario takes the next free ID in its table. Each superseded
> wording is kept in a dated comment beside the text that replaced it.

---

<!-- 20/09/2026: this header read "3 of 11 SP" from 17/09/2026 until today. The story was
     re-estimated 3 -> 5 SP at `15-decisions` on 17/09/2026 and SPRINT-05 recomputed to 13 / 11 at
     grace the same day; the two figures here were not carried across.
     `../../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` already recorded the divergence as
     known; this is the repair it was waiting for. Surfaced by an independent QA pass at
     `03-sprint-planning` while opening SPRINT-06 and SPRINT-07. -->

## 1. Acceptance criteria gaps

**Nine gaps found — two blocking, five material, two minor. All nine are
`[RESOLVED] 17/09/2026`:** each has been fed back into
`project-management/src/02-STORIES/US009.md` as an acceptance criterion or a task. AC-GAP-1 was
settled by `ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` — `prepare` is removed and
the story re-estimated 3 to 5 SP — and AC-GAP-2 by `ST07`, which replaces `[ -d .git ]` with
`git rev-parse --git-dir`. **`16-sprint-plans` is unblocked on US009.**

- **AC-GAP-1** `[RESOLVED] 17/09/2026` · **blocking** — **the story does not deliver its own user story, and the
  criterion that stops it doing so is `ST02`.** The User Story asks for hooks _"never arming
  themselves silently at a moment I did not choose"_; the Client Summary says the same in plainer
  words. `ST02` requires `package.json:11` — `"prepare": "[ -d .git ] && lefthook install || true"`
  — to be **byte-identical after the change**. That script runs on any `pnpm install` not told to
  skip lifecycle scripts. A repo-wide sweep on 17/09/2026 found `--ignore-scripts` on **five**
  invocations (`install-frontend.sh:67`, `:84`, `:93`, plus two in the mobile-only
  `code/src/scripts/mobile/install.sh`) and **absent from eleven**: one at
  `.claude/hooks/lib/check-lockfiles.sh:147`, which runs when a pull request is raised
  (`pre-pr-check.sh:35` gates the hook to the two PR-creation subcommands), and ten across five
  files under `.github/workflows/`. Each fires `prepare`; `prepare` runs `lefthook install`.
  **This is not a hypothesis — the evidence is in the tree**: `.git/hooks/pre-commit` exists on
  this machine, is lefthook's generated hook, dated 16/09/2026, in a repository whose `install.sh`
  has never written it. After US009 ships as specified, the hooks arm at the explicit step **and**
  continue to arm at PR time and in CI. The absence is fixed; the silence is not. **Resolution is a
  scope decision, not a wording one** — either `prepare` goes (a larger change than 3 SP prices),
  or the story states which owner wins, why both are kept, and what happens when they disagree.
  Threat model TM-01 and Section 3b; assessment Section 7.1.
- **AC-GAP-2** `[RESOLVED] 17/09/2026` · **blocking** — **the `.git` guard as specified is false in a worktree,
  and worktrees are how this project does parallel story work.** The story's task says _"Guard the
  step on `[ -d .git ]`"_ and `ST06` reasons about that same form. In a checkout created by
  `git worktree add`, `.git` is a **file** containing a `gitdir:` pointer, not a directory — so
  `[ -d .git ]` is false, the step takes the skip path, and the hooks never arm. This project
  creates such checkouts as standard: `how-to/workflows/02-worktree-setup/STEPS.md:53` and
  `how-to/docs/GIT-WORKTREES.md:109` both run `git worktree add ../<slug>-usXXX`. The net effect
  is that the story's central promise fails in precisely the checkouts where a developer is doing
  story work — and the skip is _silent by design_, because the story requires the no-`.git` path
  to "report and continue" rather than fail. `package.json:11` carries the identical defect today,
  which is why nobody has noticed. Threat model TM-03; assessment Section 7.3.
- **AC-GAP-3** `[RESOLVED] 17/09/2026` · material — **`ST01` asserts a three-line fact in language that reads as
  a repo-wide posture.** `N-019` calls `--ignore-scripts` "a deliberate supply-chain control", the
  FLAGS `Security` row reads _"`--ignore-scripts` preserved on all three `install-frontend.sh`
  branches"_, and the Verification Checks say _"`--ignore-scripts` confirmed present on all three
  `install-frontend.sh` branches in the diff"_. All true, all narrow. Eleven other invocations
  omit it, so a reviewer ticking that box has confirmed three lines of sixteen. The gap is not
  that US009 should fix the other eleven — it should not, they are out of scope — but that the
  criterion must **state its scope** so the tick means what it says. Threat model TM-02;
  assessment Section 7.2.
- **AC-GAP-4** `[RESOLVED] 17/09/2026` · material — **`ST03` requires the binary to come from `node_modules` and
  no task says how.** Measured 17/09/2026: `command -v lefthook` returns nothing;
  `node_modules/.bin/lefthook` exists. A bare `lefthook install` in a plain bash script — which is
  what `install.sh` is — does not have `node_modules/.bin` on `PATH`, so it either fails
  ("command not found", tripping the hard fail for the wrong reason) or resolves a **host-global**
  lefthook of unknown version against this repository's `lefthook.yml`. The house idiom is
  unambiguous: **23** `pnpm exec` sites across **14** files — `lefthook.yml`, two
  `.claude/hooks/lib/` checks, three workflow files and eight scripts under `code/src/scripts/`. The story's Script Task says "Run
  `lefthook install` resolved from the project's `node_modules`" — the requirement without the
  mechanism. Threat model TM-04; assessment Section 7.4.
- **AC-GAP-5** `[RESOLVED] 17/09/2026` · material — **the hard fail abandons four later steps, and nothing weighs
  that.** The story puts the step immediately after Phase 1 Step 4 (`install.sh:417-423`) and
  requires `err` plus `exit 2` on failure, matching Steps 3 and 4 (`:413`, `:421`). Both citations
  hold. What the story does not say is what sits **after**: Step 5 environment files (`:425`),
  Step 6 dev secrets (`:446`), Step 7 script permissions (`:498`), Step 8 machine spec (`:517`).
  A transient lefthook problem therefore leaves a tree with dependencies installed but **no
  `.env.*` files, no generated `SECRET_KEY`, no executable bits on any project script**. Steps 3
  and 4 hard-fail on things everything downstream needs; a git hook is not one of those. Moving the
  step to the end of Phase 1 makes hard-fail cheap: it abandons no Phase 1 step, though under
  `install.sh --full` it still stops Phase 2 (`install.sh:540`, `:580`) — `N-019`'s requirement is
  only that it run after dependency installation. Threat model TM-05; assessment Section 7.5.
- **AC-GAP-6** `[RESOLVED] 17/09/2026` · material — **the automated proof is specified into a job that cannot run
  it.** The story's first QA criterion is that the `[3/4] Template Generation` job generates on
  both answer sets and "the generated `install.sh` carries the step in each" — feasible, that is a
  grep. The second requires "a pre-commit probe asserts that after `install.sh` **completes** in a
  git checkout, `.git/hooks/pre-commit` exists", wired "into the generation job". That job's
  generation step is `uvx copier copy` in a shell loop (`audit-template.yml:151-163` — the story
  cites `:151-161`, two lines short) and never executes the generated `install.sh`. Executing it
  needs docker, uv, pnpm and `sudo tee -a /etc/hosts` against the runner. As written the criterion
  cannot be satisfied where it is placed. Threat model TM-09; assessment Section 7.9.
- **AC-GAP-7** `[RESOLVED] 17/09/2026` · material — **`install.sh` will write into `.git/hooks/` for the first
  time, over a file another tool also claims, and nothing says so.** `install.sh` touches nothing
  under `.git/` today — its only git references are a prerequisite check at `:371` and a version
  print at `:383`. `lefthook install` overwrites `.git/hooks/pre-commit` unconditionally, with no
  backup. `lefthook.yml:73-76` records the contest explicitly: _"Replaces the raw hook
  `code-review-graph install` appends to `.git/hooks/pre-commit` … If `code-review-graph install`
  is re-run it re-appends its hook — run `lefthook install`."_ So the file has two claimants and
  the story makes `install.sh` a third, silently. Threat model TM-07; assessment Section 7.7.
- **AC-GAP-8** `[RESOLVED] 17/09/2026` · minor — **`ST03` calls `package.json:22` a pin; it is a range.** The
  specifier is `"lefthook": "^2.1.10"`. `pnpm-lock.yaml:54-56` is what pins `2.1.10`. It matters
  because Step 4 runs `install-frontend.sh --local` → `pnpm install --ignore-scripts` at `:84` —
  **not** `--frozen-lockfile` — so it may resolve a newer 2.x and rewrite the lockfile, and the
  new step then arms the hooks with whatever it just resolved. Threat model TM-08;
  assessment Section 7.8.
- **AC-GAP-9** `[RESOLVED] 17/09/2026` · minor — **the renumbering task names Phase 1 and the collision is in
  Phase 2.** Measured: `usage()` lists Phase 1 as steps 1–8 at `:47-54` and **Phase 2 as 7 and 8**
  at `:57-58`; the body headers agree (`Phase 2 · Step 7` at `:540`, `Step 8` at `:580`). Phase 1
  and Phase 2 already collide on 7 and 8. Adding a ninth Phase 1 step makes the printed sequence
  read 1–9 then 7–8. The task says "renumber the subsequent Phase 1 step headers and the `usage()`
  step list" and never mentions Phase 2. Either it is renumbered too, or the pre-existing
  collision is left deliberately and recorded. Threat model TM-10; assessment Section 7.10.

<!-- AMENDED 30/09/2026: AC-GAP-7 cited `lefthook.yml:66-69` until then, the 17/09/2026 reading.
     f045aac (18/09/2026) moved the four lines to :73-76, re-measured 30/09/2026; the quoted text
     is unchanged.
     CORRECTED 30/09/2026: AC-GAP-5 read "Moving the step to the end of Phase 1 makes hard-fail
     cheap and costs nothing" until then. It abandons no Phase 1 step, but under install.sh --full
     Phase 2 follows it and a hard fail stops that; a call made 30/09/2026 while applying
     16-sprint-plans grilling round 3, not one of its answers. The gap stays RESOLVED. -->

<!-- THREE THINGS THIS PASS DID NOT FIND, recorded because their absence is informative.
     First, every install.sh and install-frontend.sh citation in the story holds: :413, :421,
     :417-423, :50 (within the usage list at :46-58), and :67 / :84 / :93. Second, the line-drift
     note in the story's PROVENANCE is correct — the map cites .copier/README.md:436 and the claim
     is at :441 today, re-measured and unmoved. Third, the story's premise is exactly right: the
     README claim IS false today, because all three install-frontend.sh branches carry
     --ignore-scripts and nothing else in install.sh arms anything. The story diagnosed the defect
     correctly; AC-GAP-1 is about the fix being partial, not about the diagnosis. -->

## 2. Test scenarios

Derived from the story's Gherkin and the shell tree rather than from a wireframe — this story has
none. Most are executable against a scratch clone; the ones that are not are marked.

### Happy path (HP-nn)

| ID    | Given                                                     | When                                       | Then                                                                                                                                                                                                                                                            |
| ----- | --------------------------------------------------------- | ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | A fresh clone with no `.git/hooks/pre-commit`             | `bash install.sh`                          | The **last** step of Phase 1 runs `lefthook install` and prints its own `ok` line                                                                                                                                                                               |
| HP-02 | The same run completing                                   | `.git/hooks/pre-commit` read               | It exists and is **lefthook's** generated hook — not some other tool's, and not a stub                                                                                                                                                                          |
| HP-03 | That clone, hooks armed                                   | A throwaway `git commit`                   | The `lefthook.yml` pre-commit legs run, observably                                                                                                                                                                                                              |
| HP-04 | A clone where the hook already exists from a previous run | `bash install.sh` again                    | The step completes, the hook is still lefthook's, and it is not duplicated                                                                                                                                                                                      |
| HP-05 | The change applied                                        | `install-frontend.sh` read                 | `--ignore-scripts` is present on `:67`, `:84` and `:93`; `package.json` has **no** `prepare` script                                                                                                                                                             |
| HP-06 | The change applied                                        | `.copier/README.md:442` read               | The sentence describes what the script does, **and that sentence is unmodified in the diff**; the `pnpm prepare` line is rewritten to `bash install.sh` and the Development-scripts table gains an "install-hooks.sh" row, the story plan's P3 edit (Section 6) |
| HP-07 | A generated project, both `INCLUDE_MOBILE` poles          | The generated `install.sh` read            | It carries the step in each — the assertion the generation job **can** make (AC-GAP-6)                                                                                                                                                                          |
| HP-08 | A git checkout with no armed hook, `CI` unset             | `pnpm install`, without `--ignore-scripts` | The `postinstall` notice prints, naming `bash install.sh` as the way to arm the hooks; nothing is written under `.git/`; exit 0 (`ST02b`; the story's third scenario, `project-management/src/02-STORIES/US009.md:238-243`)                                     |

<!-- AMENDED 28/09/2026 (settled 28/09/2026, 16-sprint-plans grilling round 2 Q8). HP-01's Then
     read "A step after "JavaScript dependencies" runs `lefthook install` and prints its own `ok`
     line" until then — the placement AC-GAP-5 found abandons Steps 5 to 8 on a hard fail, moved to
     the end of Phase 1 at `15-decisions` on 17/09/2026 (the story's first scenario and its first
     Script Task). HP-05's Then read "`--ignore-scripts` is present on `:67`, `:84` and `:93`;
     `package.json`'s `prepare` is unchanged" until then — the ST02 that
     `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`
     inverted when it removed `prepare`. -->

<!-- AMENDED 30/09/2026 at the sign-off. HP-06 cited `.copier/README.md:441` until then, the
     17/09/2026 reading; f045aac (18/09/2026) moved the sentence to :442, re-measured 30/09/2026,
     the text unchanged. ADDED 30/09/2026 (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q11): HP-08, the printing case of the `postinstall` the ADR above put in `prepare`'s place,
     which no scenario here exercised until then.
     CORRECTED 30/09/2026: HP-06's Then read "The sentence describes what the script does, **and
     the file is unmodified in the diff**" until then. "Unmodified" covers the `lefthook install`
     sentence only; the dead `pnpm prepare` line and the Development-scripts table's
     "install-hooks.sh" row are the story plan's P3 edit to that file (recorded in
     09-STORY-PLAN-US009 P3, 18/09/2026; applied 30/09/2026 at the 16-sprint-plans gate). -->

### Error states (ES-nn)

| ID    | Given                                                                                        | When                          | Then                                                                                                                                                                                                                                                                                                               |
| ----- | -------------------------------------------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ES-01 | A git checkout where `lefthook install` cannot complete                                      | `bash install.sh`             | The failure is reported in the house `err` idiom **naming `lefthook install`**, and the script exits 2                                                                                                                                                                                                             |
| ES-02 | The same                                                                                     | The exit code inspected       | 2, matching the header's declared "install failed" (`:17`) — never swallowed as a warning                                                                                                                                                                                                                          |
| ES-03 | The same                                                                                     | The tree inspected afterwards | **Steps 5 to 8 had already run**: `.env.*`, dev secrets, executable bits and machine spec are all present (AC-GAP-5)                                                                                                                                                                                               |
| ES-04 | `lefthook` absent from `node_modules` and from `PATH`                                        | The step runs                 | It fails with a message naming the missing binary — **not** a bare "command not found" (AC-GAP-4)                                                                                                                                                                                                                  |
| ES-05 | A tree exported without `.git`                                                               | `bash install.sh`             | The step reports the skip because there is no git repository, the install continues, exit code unaffected                                                                                                                                                                                                          |
| ES-06 | Any state the `postinstall` cannot evaluate — no git repository, or `git` absent from `PATH` | `pnpm install`                | The install still exits 0. A lifecycle script that exits non-zero fails the `pnpm install` that ran it, so a notice that errors breaks `.claude/hooks/lib/check-lockfiles.sh:147` and ten CI steps: the notice must never be what fails an install (`ST02b`; `project-management/src/02-STORIES/US009.md:376-381`) |

<!-- AMENDED 28/09/2026 (a call made while applying 16-sprint-plans grilling round 2 Q8, not one
     of its answers; accepted, settled 30/09/2026, 16-sprint-plans grilling round 5 Q16). ES-03's Then
     read "**Steps 5–8 did not run**: no `.env.*`, no dev secrets, no executable bits, no machine
     spec (AC-GAP-5)" until then — the cost of the step placed straight after Step 4, which is what
     AC-GAP-5 raised. `15-decisions` moved the step to the end of Phase 1 on 17/09/2026, so a hard
     fail now abandons no Phase 1 step, and the scenario asserts that instead of the cost. Under
     `install.sh --full` it still stops Phase 2 (`install.sh:540`, `:580`), which ES-03 does not
     assert. -->

<!-- ADDED 30/09/2026 (settled 30/09/2026, 16-sprint-plans grilling round 3 Q11): ES-06 is new. It
     is the failure mode of the story's own "silent ... when there is no git repository" clause:
     silence the script reaches by erroring is not silence. No story line stated it, so it is fed
     back into the story as an automated QA criterion,
     project-management/src/02-STORIES/US009.md:376-381, with its test task at :508-509 (settled
     30/09/2026, 16-sprint-plans grilling round 5 Q16; project-management/workflows/11-qa-checks/
     Step 5). -->

### Edge cases (EC-nn)

| ID    | Given                                                                                                  | When                     | Then                                                                                                                                                                                                                                                                                                                 |
| ----- | ------------------------------------------------------------------------------------------------------ | ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | A checkout created by `git worktree add`, where `.git` is a **file**                                   | `bash install.sh`        | The hooks **arm**: the `git rev-parse --git-dir` guard (`ST07`) resolves the real git directory, where `[ -d .git ]` is false (AC-GAP-2)                                                                                                                                                                             |
| EC-02 | A host-global `lefthook` of a different major on `PATH`, and one in `node_modules`                     | The step runs            | The project's own binary is used (AC-GAP-4)                                                                                                                                                                                                                                                                          |
| EC-03 | `.git/hooks/pre-commit` holding a **hand-written** hook                                                | `bash install.sh`        | The developer is told it was replaced, rather than losing it silently (AC-GAP-7)                                                                                                                                                                                                                                     |
| EC-04 | A generated project — `git init` run, **no commits, unborn HEAD**                                      | `install.sh`'s step runs | `lefthook install` succeeds. Currently an assumption, not a test (TM-11)                                                                                                                                                                                                                                             |
| EC-05 | A repository where `code-review-graph install` last wrote the hook                                     | `bash install.sh`        | lefthook reclaims it, per `lefthook.yml:76` — and the reclaim is reported                                                                                                                                                                                                                                            |
| EC-06 | The step run twice in immediate succession                                                             | The hook file compared   | Byte-identical; no duplication, no appended second block                                                                                                                                                                                                                                                             |
| EC-07 | `install.sh --spec`, which exits after regenerating the machine spec                                   | The run completes        | The hook step does **not** run — a flag that short-circuits Phase 1 must not half-arm anything                                                                                                                                                                                                                       |
| EC-08 | `install.sh --help`                                                                                    | The output read          | The Phase 1 list names the new step, and the printed sequence is contiguous (AC-GAP-9 decides what Phase 2 reads)                                                                                                                                                                                                    |
| EC-09 | A git checkout whose hooks are already armed                                                           | `pnpm install`           | The `postinstall` notice is silent — a working checkout never nags (`ST02b`)                                                                                                                                                                                                                                         |
| EC-10 | `CI` set, as in every workflow step                                                                    | `pnpm install`           | Silent. **The probe's printing case runs with `CI` unset**: the probe job's own `pnpm install` runs under `CI`, so a probe that inherits it asserts against the suppressed state and passes for the wrong reason (`project-management/src/02-STORIES/US009.md:371-375`)                                              |
| EC-11 | A tree exported without `.git`                                                                         | `pnpm install`           | Silent, exit 0 — nothing to arm and nothing to say (`ST02b`; ES-06 if the silence is reached by erroring)                                                                                                                                                                                                            |
| EC-12 | A checkout created by `git worktree add`, its hooks not armed                                          | `pnpm install`           | The notice **prints**: a worktree is a git repository, so a `[ -d .git ]` test in the notice would silence it exactly where EC-01 arms — AC-GAP-2's defect in a second place. Once the worktree's hooks are armed, it is silent                                                                                      |
| EC-13 | `bash install.sh`, whose Step 4 runs `install-frontend.sh` with `--ignore-scripts` on every branch     | The install runs         | No notice prints during Step 4. Correct: the last Phase 1 step arms the hooks in the same run, so a notice there would be false before the run ends (the ADR's Decision)                                                                                                                                             |
| EC-14 | A git checkout whose `.git/hooks/pre-commit` is `code-review-graph install`'s raw hook, not lefthook's | `pnpm install`           | The notice **prints**. Armed means the hook is lefthook's, as HP-02 asserts, never that a file exists at that path: a presence test would silence the notice on a checkout with no lefthook hook at all (`project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md:352-355`; EC-05's starting state) |

<!-- AMENDED 28/09/2026 (a call made while applying 16-sprint-plans grilling round 2 Q8, not one
     of its answers; accepted, settled 30/09/2026, 16-sprint-plans grilling round 5 Q16). EC-01's Then
     read "The hooks **arm**. As specified today they do not — `[ -d .git ]` is false and the step
     skips silently (AC-GAP-2)" until then — the guard as first specified.
     `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`
     and the story's ST07 fixed it as `git rev-parse --git-dir` on 17/09/2026, so the scenario
     names the guard it now tests rather than the one it found wanting. -->

<!-- AMENDED 30/09/2026 at the sign-off. EC-05 cited `lefthook.yml:69` until then, the 17/09/2026
     reading; f045aac (18/09/2026) moved the line to :76, re-measured 30/09/2026, the text
     unchanged. ADDED 30/09/2026 (settled 30/09/2026, 16-sprint-plans grilling round 3 Q11): EC-09
     to EC-14, the `postinstall`'s edges. EC-09 to EC-11 are the three silences the story names;
     EC-10 carries the probe trap the story's own criterion records; EC-12 applies ST07's
     reasoning to the notice, since a worktree is a git checkout with no armed hook and the
     story's third scenario prints there; EC-13 is the suppression the ADR calls correct; EC-14 is
     the story plan's definition of armed, which HP-02 already asserts of the step. None is a new
     criterion. -->

**The `postinstall` is judged by its silences as much as its notice.** Four conditions silence it
and one prints it — a git checkout whose hook is not lefthook's, with `CI` unset; a notice that
prints where the story says it is silent nags every CI log, and one that is silent where it should
print is the silent absence the ADR accepted `prepare`'s removal on the promise of closing. HP-08,
EC-12 and EC-14 are the printing cases, the last two the checkouts a careless guard gets wrong;
run all three.

### Permission and access (PA-nn)

**None in the web sense — this story adds no endpoint, no screen and no protected action.** There
is no role boundary and no identifier whose ownership could be verified. The `API`, `Backend`,
`Frontend` and `GDPR` flags are correctly `N/A`.

**The access-control content here is a supply-chain boundary**, and it is the subject of the
story's own Security flag. Three rows belong in this category rather than above:

| ID    | Given                                            | When                                                  | Then                                                                                                                                                                                                                                                  |
| ----- | ------------------------------------------------ | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PA-01 | The change applied, `prepare` removed per `ST02` | `gh pr create` is run                                 | `.claude/hooks/lib/check-lockfiles.sh:147` installs **without** `--ignore-scripts`, and nothing is written under `.git/`: no lifecycle script arms the hooks. **No unchosen moment**                                                                  |
| PA-02 | The change applied                               | Any CI workflow runs `pnpm install --frozen-lockfile` | The same, on the runner, and the `postinstall` notice is silent because `CI` is set. Ten such steps across five files                                                                                                                                 |
| PA-03 | The change applied                               | The `postinstall` body is read in the diff            | It writes only to stdout — no file, no network call, no credential read (`ST02b`, `ST05`). A lifecycle script that can only print is one nobody needs to suppress, which is the ADR's reason the supply-chain reading strengthens rather than weakens |

**PA-01 and PA-02 were written to demonstrate AC-GAP-1, and are now tests the change must pass.**
Run against the tree before the change, where `prepare` still exists, each arms the hooks at a
moment nobody chose — AC-GAP-1's evidence, recorded here rather than left to be argued about: per
`code/docs/GATE-REPORTING.md`, a gap nobody can reproduce is a gap nobody fixes. Run after the
change, each must leave `.git/` untouched.

**PA-01 does not assert that the notice reaches anyone, and on that channel it does not.**
`.claude/hooks/lib/check-lockfiles.sh:147` captures the install's stdout and stderr together
(`2>&1`) into one variable and prints it at `:149` only when the install fails, so on a successful
install the notice is swallowed whichever stream it is written to — for the contributor who never
ran `install.sh`, the one the notice exists for.
`project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` (_PA-01 and PA-02 — the
notice on the channels that still run_) offered two routes until 30/09/2026, and the first, the
notice on stderr, did not survive `:147`; it would also have breached `ST02b` and PA-03, which keep
the notice to stdout. The plan now carries only the second, corrected 30/09/2026 (settled
30/09/2026, 16-sprint-plans grilling round 4 Q15): the swallow recorded as an accepted residual
with this measurement. Any route that escapes the capture writes somewhere other than stdout or
changes `check-lockfiles.sh`, which US009 does not touch. The walk records the residual; an
unexamined swallow is the finding.

<!-- AMENDED 28/09/2026 (a call made while applying 16-sprint-plans grilling round 2 Q8, not one
     of its answers; accepted, settled 30/09/2026, 16-sprint-plans grilling round 5 Q16). Until then
     PA-01 read: Given "The change applied, `prepare` retained per `ST02`", Then
     "`check-lockfiles.sh:147` installs **without** `--ignore-scripts`, `prepare` fires, and the
     hooks arm. **Unchosen moment**"; PA-02's Then read "The same, on the runner. Ten such steps
     across five files"; and the paragraph beneath them read "**PA-01 and PA-02 are written as
     tests that currently demonstrate AC-GAP-1**, not as tests that pass. They are the proof that
     the story's user story is unmet by the story's change, and they are recorded here rather than
     left to be argued about". All three described ST02 before
     `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`
     inverted it: `prepare` is removed, the `postinstall` that replaces it arms nothing and is
     silent in CI, so the change these rows test no longer arms the hooks from either path. -->

<!-- ADDED 30/09/2026 (settled 30/09/2026, 16-sprint-plans grilling round 3 Q11): PA-03 is new, the
     `postinstall`'s own boundary. PA-01 and PA-02 prove that nothing arms the hooks; PA-03 proves
     that the one lifecycle script left in `package.json` can do nothing else either. The lead
     above the table read "Two rows belong in this category" until then. -->

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The story's entire output is terminal text
from a setup script. The house `bold` / `log` / `ok` / `warn` / `err` helpers at `install.sh:28-34`
use ANSI colour; **none of them relies on colour alone** — each carries a glyph and a word — which
is the one accessibility-adjacent property worth preserving and is preserved by following the
existing idiom.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as Section 3.

## 5. GDPR & security constraints

**No PII and no new protected action.** The story creates one step in a setup script and writes
one file under `.git/hooks/`. It introduces no field, no store, no personal-data path. The `GDPR`
flag is correctly `N/A`.

**Security constraints are this story's substance**, and the fourteen in
`ASSESSMENT-PLAN-US009-HOOK-ARMING.md` Section 7 are not restated here. Five are QA-visible:

- **The channel is closed, and its replacement only speaks** (Section 7.1, AC-GAP-1) — PA-01 and PA-02
  prove no lifecycle script arms the hooks; HP-08, EC-09 to EC-14 and PA-03 prove the `postinstall`
  prints where it should, is silent where the story says, and touches nothing.
- **The scope of the `--ignore-scripts` assertion** (Section 7.2, AC-GAP-3) — a tester confirms three
  lines and records that it is three of sixteen. Confirming three and reporting "the supply-chain
  control is in place" is the false green this gate exists to prevent.
- **The guard's shape** (Section 7.3, AC-GAP-2) — EC-01 is the test. It needs a real worktree, which
  `how-to/workflows/02-worktree-setup/` already tells a developer how to make.
- **Binary provenance** (Section 7.4, AC-GAP-4) — EC-02 needs a host-global lefthook planted on `PATH`.
  Cheap to stage, and the only way to prove the resolution rather than assume it.
- **Nothing outside `.git/hooks/` is written** (Section 7.13) — the step's whole blast radius, confirmed
  by diffing the tree before and after.

<!-- AMENDED 30/09/2026 (settled 30/09/2026, 16-sprint-plans grilling round 3 Q11): the lead above
     read "Four are QA-visible" until then, and the first bullet is new. Section 7.1 has carried
     the `postinstall` since `15-decisions` settled it on 17/09/2026; the four bullets after it
     are unchanged. -->

**One constraint is not QA-visible and must not be tested for.** Section 7.6 requires the three
`--ignore-scripts` assertions to neither depend on nor mask `install-frontend.sh:79-81`'s live
`sudo rm -rf "$PROJECT_ROOT/node_modules" log Removed.`. **Do not "test" that defect by planting a
file named `log` at the project root** — it would be deleted as root. Confirm by reading the
assertion's form: it must not treat `:79-93` as a block whose contents it has validated.

**The severities are read with their promotion triggers.** 0 CRITICAL, 0 HIGH, 7 MEDIUM, 4 LOW,
1 INFO is a fact about a repository with one developer, no deployment and no known compromised
dependency — not a verdict on the design. Five findings promote to `HIGH`, the first on the first
compromised package in the graph. Per `code/docs/GATE-REPORTING.md` the zero is never reported as
the gate passing.

## 6. Developer notes — testability

- **Do not run `install.sh` against this working tree to test it.** Step 2 appends to `/etc/hosts`
  with `sudo`, Step 4 shells to `install-frontend.sh --local` which runs `sudo rm -rf` from the
  project root, and Step 6 generates secrets into `.env.dev`. Test in a scratch clone, every time.
- **A worktree is the cheapest EC-01 fixture.** `git worktree add /tmp/us009-probe HEAD` produces
  a `.git` **file** in two seconds; `[ -d .git ]` is false against it and `git rev-parse --git-dir`
  resolves it, and running the step there is the whole test.
- **The generation job can grep, not execute.** `audit-template.yml:151-163` runs `uvx copier copy`
  in a shell loop over `INCLUDE_MOBILE` false and true — deliberately a loop rather than a matrix,
  because the file must contain no GitHub expression syntax (`:148-150`). Adding a grep assertion
  inside that loop is free; adding an `install.sh` execution is a new job with new reasoning
  (AC-GAP-6).
- **`lefthook install` writing to an unborn HEAD is untested and probably fine.** `copier.yml:1046`
  runs `git init --initial-branch=main` gated `when: copy`, so a generated project has `.git` with
  no commits. Prove it rather than assume it — it is one `git init` in `/tmp` away.
- **Record which of the sixteen `pnpm install` invocations carry `--ignore-scripts`**, not just the
  three the story names. The sweep is one `grep -rn 'pnpm install'` and its result is AC-GAP-1's
  and AC-GAP-3's shared evidence. Re-run it at close: if the count has moved, the finding has moved.
- **`.git/hooks/pre-commit` already exists on the author's machine.** Clear it before HP-01, or the
  test proves nothing. Its presence today is the evidence for AC-GAP-1 and a trap for HP-02.
- **The `postinstall` cases run through the probe script, in a scratch clone.** HP-08, ES-06,
  EC-09 to EC-12 and EC-14 each need a `pnpm install`, and a raw one typed at a terminal is what
  `.claude/CLAUDE.md` Section 6 forbids. Their home is the probe script the story plan names,
  "code/src/scripts/tests/hook-arming.sh", not yet written
  (`project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`, P4). Unset `CI`
  explicitly for the printing cases (EC-10), and keep the notice's text in one place the probe
  can match on, so a reworded notice fails the probe rather than passing it silently.
- **HP-06's "unmodified in the diff" is the sentence, not the file.** The story plan's P3 edits
  `.copier/README.md` — the `pnpm prepare` line, a command that stops existing when `prepare` is
  removed, becomes `bash install.sh`, and the Development-scripts table gains an
  "install-hooks.sh" row — and carves that edit out of the assertion, which covers the sentence
  at `:442` and nothing else
  (`project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md:356-365`). The
  story's manual criterion and Verification Check now say the same
  (`project-management/src/02-STORIES/US009.md:411-416`, `:549-552`), and so does HP-06 (recorded
  in 09-STORY-PLAN-US009 P3, 18/09/2026; applied 30/09/2026 at the 16-sprint-plans gate). The
  `pnpm prepare` line is `.copier/README.md:1091` in the tree committed together with the
  18-TESTS split, re-measured 30/09/2026 — `:1088` at `a18db0b` and `:1085` at `f045aac`, the
  story plan's reading until it re-pointed its own citation to `:1091` on 30/09/2026. The walk
  records the diff of that file line by line, never as a tick.
- **No pytest, no coverage figure, no migration check.** The story's Verification Checks mark the
  Python rows `N/A` with reasons; the test record must do the same rather than leave them blank.
- **ShellCheck has no project script.** `lint.sh`'s legs are ruff, markdownlint-cli2, ESLint and
  clippy. Run it by hand over the changed `install.sh` and record it as run or not run — never as
  a `lint.sh` pass (`code/docs/GATE-REPORTING.md`).

<!-- AMENDED 28/09/2026 (a call made while applying 16-sprint-plans grilling round 2 Q8, not one
     of its answers; accepted, settled 30/09/2026, 16-sprint-plans grilling round 5 Q16). The worktree
     note above ended "`[ -d .git ]` against it is the whole test" until then — the whole test of
     the guard as first specified. The story's ST07 replaced that guard with
     `git rev-parse --git-dir` on 17/09/2026, so the fixture now proves the replacement arms the
     hooks rather than that the original skips. -->

<!-- AMENDED 30/09/2026: the unborn-HEAD note cited the `git init` task as `copier.yml:1025` until
     then, measured against `1e00a4b` and unchanged at a18db0b. The 18-TESTS split, committed
     together with this correction, adds 21 lines above the task, which sits at :1046 in that tree,
     re-measured 30/09/2026, the text unchanged. -->

## 7. Gate readings, measured 17/09/2026 — indicative, not baselines

Taken on branch `pm/story-creation` at HEAD `1e00a4b`, working tree clean bar one untracked
handoff. **These are readings, not the story's baseline** — the citation gate's baseline must be
captured immediately before the first edit, and no edit has happened.

| Reading                                    | Value at `1e00a4b`                                                        |
| ------------------------------------------ | ------------------------------------------------------------------------- |
| `doc-references.sh` (whole tree)           | **259, exit 1** — inherited red, unchanged from `fff578f`                 |
| `pnpm install` invocations, repo-wide      | **16 total** · **5** carry `--ignore-scripts` · **11** do not             |
| …of those 11                               | 1 × `check-lockfiles.sh:147` · 10 × five files under `.github/workflows/` |
| `command -v lefthook`                      | **Not found.** `node_modules/.bin/lefthook` present                       |
| `package.json:22` · `pnpm-lock.yaml:54-56` | `"^2.1.10"` · resolves `2.1.10`                                           |
| `.git/hooks/pre-commit`                    | **Present**, lefthook's, 16/09/2026 — armed by none of this story's paths |
| `install-frontend.sh:79-81`                | The `sudo rm -rf` stray-argument defect — **still live**                  |
| `install.sh` length · `usage()` step list  | 597 lines · Phase 1 at `:47-54`, Phase 2 at `:57-58`                      |

**Two counts the next reader should not re-derive.** The 16/5/11 split is the sweep AC-GAP-1 and
AC-GAP-3 both rest on, and the 5 includes two in `code/src/scripts/mobile/install.sh:33` and `:41`
that are **mobile-only** — absent in a project generated without that surface, which is why the
story's "all three branches" framing is right about `install-frontend.sh` specifically.

## 8. Two candidates refuted, and why they are recorded

Both were raised during the pass, both were plausible, and both fail on a fact.

- **"`pre-pr-check.sh` runs on every Bash call, so the hooks re-arm constantly."** It is registered
  as a `PreToolUse` hook on the `Bash` matcher, which reads that way. It is not: `:35` greps the
  command text for the two PR-creation subcommands and `exit 0`s otherwise — a fast-path guard
  that runs before anything else. The arming moment is **raising a pull request**, not every
  command. AC-GAP-1 stands on the narrower, accurate claim — which is still one unchosen moment
  plus ten in CI.
- **"The story's `install.sh:413` and `:421` citations have drifted."** Both were re-opened:
  `:413` is `install-backend.sh --sync || { err "uv sync failed"; exit 2; }` and `:421` is
  `install-frontend.sh --local || { err "pnpm install failed"; exit 2; }`. The idiom the story
  wants to match is exactly where it says. Every `install.sh` and `install-frontend.sh` citation
  in US009 holds as at 17/09/2026.

---

## Cross-references

- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan against the shipped change
- `project-management/src/02-STORIES/US009.md` — the story this plan tests; all nine gaps above are `[RESOLVED] 17/09/2026` in it
- `project-management/src/03-SPRINTS/SPRINT-05.md` — the record this story is the stretch `Should` of
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` · `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` — the security gate whose Section 7 constraints this plan exercises
- `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` — `N-019`, which settled that the step exists but not its failure mode
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` — the record that removed `prepare` and added the `postinstall` HP-08, EC-09 to EC-14 and PA-03 test
- `project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — P3's definition of armed (EC-14), P4's probe home, and the PA-01 swallow
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` sections, the PA rows' before-and-after evidence, Section 7 and Section 8 rest on

<!-- AMENDED 30/09/2026 at the sign-off (call made 30/09/2026 while applying 16-sprint-plans grilling
     round 3): the `code/docs/GATE-REPORTING.md` entry read "the rule the `N/A` sections, the PA
     rows written as failing tests, Section 7 and Section 8 rest on" until then. The ADR and
     story-plan entries are new. -->
