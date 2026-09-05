# QA Plan — US006 The destructive dev scripts read the deployment posture

| Field         | Value                                                                                                |
| ------------- | ---------------------------------------------------------------------------------------------------- |
| **Story**     | US006 — The destructive dev scripts read the deployment posture, and refuse to run above development |
| **Date**      | 05/09/2026                                                                                           |
| **Sprint**    | SPRINT-04 — the posture guard                                                                        |
| **Wireframe** | N/A — this story ships a bash helper and Markdown, not a screen                                      |
| **Status**    | Signed off                                                                                           |

<!-- Signed off 05/09/2026. Twenty-two gaps found, all twenty-two resolved into
     project-management/src/02-STORIES/US006.md the same day. No [OPEN] gap remains, so
     16-sprint-plans is unblocked and 03-sprint-planning may open SPRINT-04.

     METHOD, recorded because the gap count is unusual and a reader is entitled to know how it
     was reached. Five adversarial lenses ran in parallel over the story and the tree —
     executability, internal contradiction, factual drift, negative space, cross-artefact
     consistency — returning 42 candidates. Each was then re-read by a verifier whose default was
     REFUTED and who had to re-open the cited file to sustain it. 28 survived; 14 did not, and two
     of the refutations are recorded in Section 8 because the reasoning is worth keeping. The 28
     collapse to the 18 below once cross-lens duplicates are merged. The story is 592 lines with
     much of its reasoning in HTML comment blocks, which is exactly why the refute-by-default step
     was needed: "the story does not say X" was wrong more often than it was right.

     A SECOND PASS then ran the same shape over this plan, the two ADRs and SPRINT-04 once they
     existed — 21 candidates over four lenses, 19 sustained, 4 of them changing the story. They are
     AC-GAP-19 to 22. Three of the four are defects this gate INTRODUCED, which is the argument for
     running it: the gate that finds eighteen gaps in a story is not thereby exempt from having its own
     own output read. -->

---

## 1. Acceptance criteria gaps

**Twenty-two gaps found — eight blocking, thirteen material, one minor. All twenty-two were
resolved into `project-management/src/02-STORIES/US006.md` on 05/09/2026. Nothing blocks
`16-sprint-plans`.**

<!-- AC-GAP-1 to 18 came from the gap hunt over the story. AC-GAP-19 to 22 came from a SECOND,
     independent adversarial pass run over this plan, the two ADRs and SPRINT-04 once they were
     written — four lenses (factual accuracy, cross-artefact consistency, house doctrine, and
     substance) returning 21 candidates, of which 19 survived refutation and 4 changed the story.
     Recorded in the same register rather than a separate one, because a gap found by reviewing
     the gate's own output is still a gap in the story. `.claude/CLAUDE.md` Section 2.3: no skill
     reviews its own work. -->

**Eight are blocking, and they cluster.** Five — AC-GAP-1, 2, 3, 4 and 5 — close a path on which
this fail-closed control fails **open**, or has no open state at all, or cannot be proved: a guard
whose only failure mode is failing open was specified with four ways to do it and one authorised
path it refused outright. The other three — AC-GAP-20, 21 and 22 — are defects **this gate
introduced** and the artefact-review pass caught.

- **AC-GAP-1** `[RESOLVED]` — **the no-tty refusal refuses the one CI caller the story requires
  to keep working.** `US006.md` 7.6 was unconditional: "Above `development`, absence of a tty is a
  refusal at exit 4". Its own CI scenario simultaneously required
  `.github/workflows/test-e2e.yml:133` to pass `--force-posture` **and** to drop `|| true` so a
  refusal fails the job loudly. In a generated project above `development` those two demand
  opposite outcomes for the same shipped line, and the story never said which wins. Nor can 7.6 be
  narrowed away by reading it as covering only unauthorised runs: an un-overridden run above
  `development` already refuses at exit 4 by the earlier criterion, so **7.6 has effect only on
  overridden runs** — which is precisely the CI teardown, and precisely
  `reset.sh --force-posture staging --yes`. As written the story left **no authorised scripted
  destructive path above `development`** and never said that was the intent. The mis-scoping
  compounds it: TM-06's hazard is the `read -r REPLY || true` abort at `reset.sh:98-103` and
  `restore.sh:100-105`, and neither `server.sh` carries a `read` or a `--yes` at all — so 7.6 bound
  two scripts in which the hazard does not exist. Resolved: 7.6 now binds **the confirmation
  prompt, not the terminal**, and a valid `--force-posture` naming the live posture satisfies the
  guard with or without a tty. The correction travels back to
  `ASSESSMENT-PLAN-US006-POSTURE-GUARD` Section 7.6, which now disagrees with the story. Added on
  05/09/2026.
- **AC-GAP-2** `[RESOLVED]` — **the bound set became six scripts at gate 10 and not one derived
  count moved.** 7.9 and its task bind `development/server.sh up --seed` and
  `database/seed-dev.sh`. Fifteen sites still carried the pre-gate five-and-four: "five callers"
  six times, "all five scripts" four times, "the four destructive scripts", "all four refusing
  scripts", and — the one that is arithmetic rather than prose — "Declare exit `4` in all five
  scripts … **ten lines in total**", which is twelve across six files, `seed-dev.sh` declaring its
  codes at `:9` and `:64` in exactly the header-plus-heredoc shape the task names. Three of the
  fifteen sit inside testable criteria, so a QA suite derived from them proves the wrong
  population and leaves the newly bound script unproven. The gate-10 comment block records the
  widening and explicitly declines to re-price the story — but re-deriving a count is not
  re-pricing, and it acknowledged the cause without fixing the effect. Resolved: the bound set is
  stated **once**, as a table, at the head of the acceptance criteria, and every count in the file
  is derived from it. `MAP-SCRIPT-GUARDS.md` S-01's script list is re-cut in the same change.
  Added on 05/09/2026.
- **AC-GAP-3** `[RESOLVED]` — **`seed-dev.sh` is bound and has no override channel at all.** 7.9
  binds both ends of one invocation, and `development/server.sh:149` is
  `bash "$SCRIPT_DIR/../database/seed-dev.sh"` with **no arguments forwarded**, while
  `seed-dev.sh:70-72` is `*) die "Unknown option '$1'…"` at exit 2. Nothing in the story's 592
  lines required `server.sh` to forward the flag, and the parser task named "all four refusing
  scripts" — a set fixed before 7.9 and excluding `seed-dev.sh`. Net effect as written: an
  operator who correctly names the live posture clears the outer guard, reaches `:149`, and is
  refused at exit 4 by the inner one with no way to satisfy it; a direct
  `seed-dev.sh --force-posture staging` dies at exit 2 instead. **A fail-closed control with no
  open state on a path the story deliberately bound.** The story also never said whether
  `seed-dev.sh` refuses or warns. Resolved: `server.sh` forwards the flag verbatim at `:149`,
  `seed-dev.sh` parses it ahead of its `die`, the mode is stated as refuse, and two proof cases
  cover both entry points. Added on 05/09/2026.
- **AC-GAP-4** `[RESOLVED]` — **a damaged carrier makes the override unconstrained, and the
  refusal it must print cannot exist.** 7.5 required `--force-posture` validated against the
  literal posture set _before_ the carrier is consulted "so it stays satisfiable in all four
  damaged-carrier states". That is a statement about the **validation step**, not about the
  **verdict**. The permit rule elsewhere is a comparison against "the posture the project is at
  now"; in a damaged carrier there is no such value, so validation collapses to membership of the
  three literals and **`--force-posture development` permits a destructive run on a project
  actually at `production`**. Not exotic — TM-08's whole point is that a `copier update` three-way
  merge produces exactly that state, so the control is weakest immediately after the carrier is
  disturbed. The second half is worse for being quieter: 7.11 requires the refusal to name "the
  live posture" and a copy-pasteable re-run command, and in these states neither exists, so the
  one criterion covering the unrecovered path mandates a message that cannot be written. TM-07 is
  the finding that leaves NIST **RC** open in the assessment, and its only mitigation was 7.5.
  Resolved: the override is **not honoured** in any damaged-carrier state, the recovery path is
  repairing the carrier, the refusal gets its own message form naming the reason and the repair
  rather than a posture, and 7.11 narrows to "the live posture where one is readable". Added on
  05/09/2026.
- **AC-GAP-5** `[RESOLVED]` — **`migrate.sh --self-test` cannot exit 0, and the fix is not free.**
  The headline criterion appears three times. Today `migrate.sh:97-102` validates the subcommand
  against `run|make|show|check|fake|fake-initial` and `die`s at exit 2 on anything else, so
  `--self-test` is an unknown command. That much is only drift. The contradiction is at
  `migrate.sh:123-124`: `cd "$PROJECT_ROOT"` then `container_running || die "django container is
not running…"` runs **before** the command dispatch at `:127`, so an arm added naively to either
  the command list or the flag loop requires a running container — which cannot coexist with the
  story's own "the refusal is therefore observable without a running stack, which is what makes it
  testable". The proof of a guard that exists for the stack-down case would fail with the stack
  down. No task constrained the placement, and all nine in-tree `--self-test` arms are in
  `audits/`, so there is no operational-script precedent to inherit it from. Resolved: the arm is
  dispatched ahead of both `:97-102` and `:123-124` and invokes no `docker`. Added on 05/09/2026.
- **AC-GAP-6** `[RESOLVED]` — **"every fixture case fails against the pre-change script" is
  unsatisfiable, and it is the criterion that was supposed to stop a vacuous test suite.** Two
  independent reasons. First, there is no pre-change subject: `find` for `posture-guard*` and a
  tree-wide grep for `--force-posture` both return nothing, and `migrate.sh --self-test` dies at
  `:101` identically for every case — so every fixture "fails" for a reason unrelated to the
  guard, which is the exact defect the criterion exists to prevent. Second, and independent of the
  venue, **three of the required cases are permits**: a `development` carrier, the template case,
  and the override naming the live posture all proceed before the change and proceed after it, so
  "fails against the pre-change script" is false by construction. The criterion appeared in three
  places and could not be ticked in any. Resolved: replaced throughout by a per-case assertion —
  refusing cases on exit code **and** message prefix together, permitting cases on running to
  completion at exit 0 — with the guard's own verdict as the discriminator. Added on 05/09/2026.
- **AC-GAP-7** `[RESOLVED]` — **the state enumeration has four different sizes in one file, and
  the largest undercounts.** "the four carrier states walked" · "the six carrier states are: …" ·
  "the fixture set covers all six, plus the template case" · "All six carrier states are walked" ·
  "Walk all four carrier states". Two of those describe the same manual activity with different
  counts. And the six-item list is already contradicted by the story's own later text, which makes
  a conflict-marked carrier its own refuse state and a duplicate or commented key a refuse state —
  none of which appear in the six — while the QA tasks add six further cases (exported variable,
  commented key, duplicate key, conflict-marked carrier, `copier.yml` precedence, no-tty). So a
  tester walking four, a tester walking six, and a reviewer ticking completeness against an
  eleven-plus suite read the same story and reach different verdicts. Resolved: **one enumerated
  proof-case list, twenty-one cases in four groups — one entry, one fixture, one verdict**, stated once at the head of the acceptance
  criteria; every other site cites it by name and restates no number. Added on 05/09/2026.
- **AC-GAP-8** `[RESOLVED]` — **7.7 bans the only call shapes that can satisfy 7.7.** The helper
  signals by return code and never calls `exit`. Under `set -euo pipefail` — `reset.sh:10`,
  `seed-dev.sh:11` — every construct that observes a non-zero return without aborting first is a
  `set -e`-suspending context: `if ! posture_guard`, `posture_guard || exit 4`, `!`-negation. A
  bare `posture_guard; rc=$?` aborts at the guard before `rc` is read. 7.7's second clause banned
  all of them, and the Gherkin made it worse by presenting the ban as a _consequence_ ("and exits,
  **so** no call site wraps it") of a premise that entails the opposite. The one literal escape —
  `set -E; trap 'exit 4' ERR` — does not "branch on the returned status explicitly", is used by no
  script in the tree, and cannot distinguish the guard's failure from any other. The concrete risk
  is an implementer resolving it the wrong way, by moving `exit` into the helper, which breaks the
  helper contract and `code/src/scripts/_lib/CLAUDE.md:25`. Resolved: 7.7 now requires the caller
  to branch explicitly and **terminate on a refusal**, with no call site discarding the status or
  continuing past it; the `set -e` property is stated as an implementation note rather than a ban.
  Added on 05/09/2026.
- **AC-GAP-9** `[RESOLVED]` — **the `_lib` convention the helper's contract appeals to does not
  exist.** The story required the helper to "signal by return code and stderr and never call
  exit, per the convention every other helper in that directory follows". All five helpers were
  read. "Never calls exit" holds. "Signals by return code" does not: `conflict-markers.sh:63`
  documents "Return 0 always; the caller counts" and signals on stdout, `frontmatter-skills.sh:45`
  says the same, `worktree-detect.sh` defines no function at all and signals by setting three
  variables at top level — which separately contradicts `_lib/CLAUDE.md:18-19`. Only `env-file.sh`
  and `wizard.sh` return meaningful codes. An acceptance criterion that inherits a two-of-five
  convention is not checkable, and 7.7 depends on the helper genuinely returning a status.
  Resolved: the contract is stated outright — returns 0 to permit, 4 to refuse, refusal on stderr,
  never calls `exit` — and flagged as **new** for `_lib/` rather than inherited. Added on
  05/09/2026.
- **AC-GAP-10** `[RESOLVED]` — **the preflight premise is false, and its replacement is vacuous in
  the sixth script.** The story's Given read "neither `development/server.sh` nor
  `tests/server.sh` has any preflight at all". Both do: `[[ -f "$ENV_FILE" ]] || die "Env file not
found: $ENV_FILE"` at `development/server.sh:100` and `tests/server.sh:91`, byte-identical, each
  dying at exit 2. The true statement is "no **container** preflight" — which is what
  `THREAT-MODEL-PLAN-US006-POSTURE-GUARD:93` and `ASSESSMENT-PLAN-US006-POSTURE-GUARD:111` already
  said, so **the story overshot its own source**. It is load-bearing: the guard must sit above that
  `die` for "the posture refusal is what the operator sees" to hold for an operator with no
  `.env.dev`, and the wiring task placed the guard only "on the `down --volumes` path" with no
  position relative to it. Second half: the story replaced "before the preflight" with "before the
  first destructive command" and claimed it "well defined in all five" — but `migrate.sh` destroys
  nothing, so the replacement is exactly as vacuous there as the phrase it replaced was in the two
  `server.sh` scripts, and 7.8's presence assertion has no anchor to test. A third, different
  placement for that same script sat in the task table. Resolved: the Given is corrected to name
  the container preflight; the guard is required to precede the env-file check; `migrate.sh`'s
  firing point is stated as "at entry, before argument dispatch"; and 7.8 becomes a **line-order
  comparison** rather than prose. Added on 05/09/2026.
- **AC-GAP-11** `[RESOLVED]` — **TM-01 has no numbered criterion, no observable, and no test.**
  All eleven Section 7 constraints were read: not one mentions Docker, `DOCKER_HOST`,
  `DOCKER_CONTEXT`, `COMPOSE_PROJECT_NAME` or a compose target. The assessment's own Section 6
  points **both** TM-01 and TM-04 at `Section 7.1`, which is TM-04's carrier-only read — so TM-01, the
  only MEDIUM the gate settled at its Q1, has no constraint of its own, and since the story's
  Security criteria are Section 7 transcribed, it has none here either. It survived as one
  unnumbered Gherkin clause and one script task, and the QA surface then dropped it entirely: no
  automated criterion and no task exercised any of the three variables. The clause also never said
  **what is read**, what counts as the local stack, what exit code the refusal uses, or whether it
  fires at `development`. Resolved: **7.12 is new** — the three variables named, read from the
  environment and never by contacting a daemon, refusing at exit 4 at every posture — with a
  matching proof case that runs with no daemon running. The renumbering travels back to the
  assessment. Added on 05/09/2026.
- **AC-GAP-12** `[RESOLVED]` — **the carrier's own path resolution is never specified, so the
  fixture tree cannot be aimed at.** Every `PROJECT_ROOT` / `BASH_SOURCE` mention in the story —
  three of them — attaches to the `copier.yml` probe. All seven mentions of `.copier-answers.yml`
  name the file bare. The self-test requires fixture answers files the guard must be pointed at,
  and nothing states the aiming mechanism, so both horns are unpicked: anchor the carrier like the
  probe and every fixture case is unconstructible; leave it cwd-relative and TM-11's threat
  re-opens on the file carrying the verdict. Resolved: the carrier is read at
  `$PROJECT_ROOT/.copier-answers.yml` resolved the same way, and **the seam is stated** — the
  entry point takes the repository root as its first positional argument, defaulting to the
  `BASH_SOURCE`-derived value, so `--self-test` drives the identical read path over a fixture
  root. A positional argument, never an environment variable, which 7.1 bans. Added on 05/09/2026.
- **AC-GAP-13** `[RESOLVED]` — **7.10 asserts the story names an owner; no owner is named
  anywhere.** The criterion requires that "this story names who updates its `--force-posture`
  literal when the posture rises", and the Gherkin asserts it has. A sweep of the file for every
  role and ownership token returns three lines: the SPRINT-04 admission decision, the assertion,
  and the criterion. No person, role or owner exists in 592 lines, and the only task touching the
  CI caller covers passing the flag and dropping `|| true`. This is TM-10's entire mitigation — a
  committed override that ships into every generated project going stale silently, answered by
  naming an owner — recorded as a requirement and left unanswered. Resolved: the owner is named,
  the trigger stated (the same commit that raises the carrier), and a task writes both as a
  comment beside the literal so they travel with the thing they govern. Added on 05/09/2026.
- **AC-GAP-14** `[RESOLVED]` — **"the one CI caller of a guarded script" is false.**
  `.github/workflows/test-e2e.yml:91` runs `bash code/src/scripts/development/server.sh up
--build` — same guarded script, same workflow, same shipped file. It is unbound only because the
  guard binds `down --volumes` and, since TM-09, `up --seed` — not `up --build`. That is a scope
  line the story itself moved once, and the only statement of the exclusion is a general clause
  about inert subcommands. So **`up` is now partially bound**, and an implementer placing the guard
  at the top of the `up` case rather than inside the `--seed` branch at
  `development/server.sh:146` refuses `:91` in every generated project above `development`. No
  criterion, fixture or task inspected `:91`. _One half of this candidate was refuted and is
  recorded as such_: "the one committed override in the tree" remains true, because `:91` carries
  no `--force-posture`. Resolved: the scenario is retitled to name the **bound subcommand**, `:91`
  is named as the second unbound caller, and a proof case asserts `up --build` proceeds above
  `development` with no override. Added on 05/09/2026.
- **AC-GAP-15** `[RESOLVED]` — **the citation-gate check binds US006 to a regime that retires
  before SPRINT-04 opens, and the baseline it records cannot cover what the story edits.** Three
  parts. (1) The check mandates reading the gate as a diff per
  `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` and "never as a bare pass". US006 opens
  SPRINT-04; US004 is SPRINT-02's sole `Must`, states that it retires that regime, and its own ADR
  records the retirement independently — so by implementation time this story's check mandates the
  wrong reading and forbids the correct one. US004's own text is the house precedent for naming
  exactly this collision at cutting; US006 named none. (2) The recorded figure is a **per-file**
  nine, which cannot detect a citation introduced into any of the thirteen-odd other files the
  story edits. (3) The measurement was never written where the ADR requires it. Re-measured
  05/09/2026 at HEAD `c6df520` on a clean tree: **103 tree-wide, 9 on this file** — and an earlier
  run the same day, with the parallel session's two US005 plans untracked, gave **153**, of which
  those two files contributed 69. Same tree, different index state, 50-finding swing: a bare total
  is not a baseline. The nine break down exactly as the story claims, with one measurable error —
  **the two US003/US001 forward references are at line 131, not 119**, a 12-line drift matching the
  gate-10 comment block inserted above them and never re-measured. Resolved: the check now names
  the US004 contingency in both directions, records the figure with its HEAD and index state, and
  a task captures a baseline over **every** file the story edits before the first edit. Added on
  05/09/2026.
- **AC-GAP-16** `[RESOLVED]` — **the Definition of Done fixes an SP figure that a live reservation
  makes unsatisfiable, and pre-commits gate 03 to the shape the doctrine warns against.** The DoD
  carried a tickable "`SPRINT-04.md` opened with this story as its first member, at 8 / 11 SP".
  `SPRINT-03.md` and `03-SPRINT-PLAN-03.md` both reserve US003's 5 SP carry to **SPRINT-04**, so
  exercising it makes SPRINT-04 13 SP — the same arithmetic SPRINT-03 used to refuse US006 — and
  the line unsatisfiable. If it is _not_ exercised, SPRINT-04 is a single all-`Must` member, which
  `project-management/docs/planning/SPRINTS.md` warns "has no give and the first surprise breaks
  it" and which SPRINT-03 named as its own one real weakness. Separately, the justification cited
  a SPRINT-02 reservation that **SPRINT-02 has since replaced** with "No `Should Have` story
  remains here" — US003 having moved to SPRINT-03 on 05/09/2026. Resolved: the DoD line becomes a
  composition rule rather than a figure, requiring the carry-over contingency disposed of
  explicitly in SPRINT-04's Notes and the MoSCoW mix recorded against the doctrine; the stale
  citation is corrected in place, superseded text preserved, on the precedent the sibling records
  set. Added on 05/09/2026.
- **AC-GAP-17** `[RESOLVED]` — **the ADR sketch predates gate 10, and the record the story is
  bound by is missing from the set gate 15 checks.** The carrier ADR sketch was written at
  `02-story-creation` round 2 Q5 and never brought forward: it proves the template by `copier.yml`
  presence and is **silent on ordering**, while the story elsewhere requires the carrier read
  **first** — which is the entire TM-05 mitigation and the one constraint that makes the template
  exemption unreachable in a project holding an answer. The gate-10 note lists four corrections and
  the Decisions block is not among them, so an ADR authored from the sketch would omit it. The
  sketch also names four refuse states where the story now has five, and no exit code. Separately,
  `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` binds every story in this backlog and
  US003, US004 and US005 each carry it in their own Decisions block; US006 cited it only inside a
  Verification Check, where **gate 15's clash check would not see it**. _One leg of this candidate
  was refuted_: the two-ADR split does not contradict the map, which assigns ADR ownership to
  neither of its two recorded changes, and the story's call that the exit code rides in the
  override record is deliberate and recorded. Resolved: the carrier sketch gains the ordering
  clause, the fifth refuse state and the exit code; the third ADR joins the Decisions block. Added
  on 05/09/2026.
- **AC-GAP-18** `[RESOLVED]` — **"298 lines" is true only under one tool, and the story names
  none.** `code/src/scripts/audits/CONTEXT.md` is 298 lines under `docs-length.sh`, which measures
  `cloc` **code** lines with blanks and HTML comments excluded; `wc -l` on the same file returns
  **357**. The story states the bare number in two places, and the Dependencies one is standalone
  with no tool named — a 59-line discrepancy against the obvious tool, on a file US006 commits not
  to touch, in a clause whose whole purpose is to prove the commitment was kept. _Weakened but not
  refuted_: the Verification Check sits in the same bullet as the command, so a reviewer running it
  sees 298, and the task is git-checkable rather than line-checkable. Resolved: the measure is
  pinned at both sites. Added on 05/09/2026.

- **AC-GAP-19** `[RESOLVED]` — **four of the five map re-cuts the story lists as pending had
  already landed, and the one that had not has no task.** `MAP-SCRIPT-GUARDS.md` was corrected in
  commit `3d149e9` — the same commit that finalised US006 — and neither the story nor the ADR was
  re-synced. The map's S-01 cell already reads `--force-posture <posture>` with `US006` in its
  Story column and already says the fail-closed set refuses at exit 4; the two divergence write-ups
  already sit beneath the Slices table; and the Standing preferences cell already carries the
  re-measured `doc-references.sh` citations and the corrected `probe()` claim, which this gate
  independently re-measured as right (5 of 6 `.github/scripts/` gates define `probe()`, exactly 2
  `st_probe()` under `audits/`). So the story carried **two false Givens and three no-op tasks** —
  and the one edit that genuinely remains, S-01's script list still naming four bound scripts with
  no `seed-dev.sh` and no `up --seed`, had no task at all. An implementer working that table ticks
  three no-ops and never reaches the edit that matters. Resolved: the scenario is re-cut to the
  map's current state, the three landed tasks are struck through rather than deleted so they read
  as done rather than dropped, and the outstanding script-list edit gains its own row. Added on
  05/09/2026.
- **AC-GAP-20** `[RESOLVED]` — **the proof-case list counted entries and was used to count
  fixtures, and the two differ.** The first cut read "sixteen cases in three groups" but grouped
  three of them as behavioural **pairs** carrying two verdicts each for two of them — the override
  live/stale, and no-tty with/without an override. So "one fixture case per entry, sixteen, none
  omitted and none doubled up" was unsatisfiable both ways: one fixture per pair doubles two
  verdicts into one case, two fixtures per pair breaks the sixteen. Two further cases existed only
  as tasks with no entry at all — the damaged carrier with a valid override, and the override
  crossing the `seed-dev.sh` shell-out. And the derived "three of the sixteen are permits" was
  stale by one, `server.sh up --build` having been added at AC-GAP-14. The untickable criterion
  propagated into SPRINT-04's Definition of Done. Resolved: the list is re-cut as **twenty-one
  numbered cases in four tables — one entry, one fixture, one verdict** — every derived figure
  re-taken from it, and the permit arithmetic replaced by naming the cases rather than counting
  them. Added on 05/09/2026.
- **AC-GAP-21** `[RESOLVED]` — **7.12 made `migrate.sh` refuse, and `migrate.sh` is the one script
  that never refuses.** The new compose-target criterion said the guard "refuses at exit 4 ... at
  every posture including `development`", and its Gherkin premise is "when a guarded script runs" —
  which includes `migrate.sh`. The bound-set table gives that script mode `warn`, "every
  subcommand, unconditionally", and its own scenario is emphatic that it proceeds at every posture,
  exits 0 on the success path, and warns rather than refuses even on an unreadable carrier. This
  plan inherited the contradiction: ES-04 said "any bound script → exit 4" while HP-06 and EC-09
  required `migrate.sh` to warn and exit 0. Since `migrate.sh` hosts the `--self-test` the whole
  design rests on, an implementer could not build the two-mode entry point without guessing, and
  two named scenarios flipped on the guess. **Second defect in the same criterion:** "points it
  elsewhere" is not decidable from an environment variable — the criterion named no accepted
  values. Resolved: 7.12 **follows the caller's mode** (the five refuse, `migrate.sh` warns), and
  the test is stated as an allowlist — `DOCKER_HOST` unset or a local socket, `DOCKER_CONTEXT`
  unset or `default`, `COMPOSE_PROJECT_NAME` unset or equal to the compose file's declared name.
  The absence of an override for it is stated as deliberate, with the narrower recovery named.
  Added on 05/09/2026.
- **AC-GAP-22** `[RESOLVED]` — **7.11 mandates a repair command that no artefact defines, and the
  damaged-state list omits one of its own members.** The criterion requires a damaged-carrier
  refusal to print "the command that repairs the carrier", and pointed the operator at
  `how-to/src/DEPLOYMENT-POSTURE.md` — which is the per-surface posture register and carries **no
  repair procedure**, so the refusal would send its reader to a document that does not answer the
  question. Separately, the not-honoured list enumerated five damaged states and omitted the
  **unrecognised carrier value**, which the carrier ADR enumerates and which refuses like the rest;
  the override ADR then characterised the whole fail-closed set as seven where the carrier ADR has
  eight. The behavioural verdict never differed, but the refusal **message** did — 7.11 splits on
  whether a posture is readable and that state sat in neither branch. Resolved: 7.11 now states the
  repair concretely — the file, the key and the three legal values — rather than deferring; the
  unrecognised value joins the not-honoured list and 7.5; and the override ADR carries a dated
  erratum correcting seven to eight. Added on 05/09/2026.

## 2. Test scenarios

Derived from the story's Gherkin scenarios and the shell tree rather than a wireframe — this
story has none. Every scenario below is executable against the repository after the change lands,
and every one maps to an entry in the story's enumerated proof-case list.

### Happy path (HP-nn)

| ID    | Given                                                                                    | When                                               | Then                                                                                                             |
| ----- | ---------------------------------------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| HP-01 | A rendered carrier naming `development`                                                  | Any of the six bound scripts runs                  | It proceeds unimpeded, and `migrate.sh` additionally prints the posture and the expand-then-contract obligation  |
| HP-02 | This repository, whose carrier holds no rendered posture and whose root has `copier.yml` | Any of the six runs                                | It proceeds at every posture, and the answers file is unmodified afterwards                                      |
| HP-03 | A carrier naming `staging`, and an operator who knows it                                 | `reset.sh --force-posture staging`                 | The guard permits, the confirmation prompt still runs, and `--yes` does not suppress it                          |
| HP-04 | A carrier naming `staging`, in CI with no tty                                            | `server.sh down --volumes --force-posture staging` | It proceeds — the override carries the authorisation, not the terminal (AC-GAP-1)                                |
| HP-05 | A carrier naming `staging`                                                               | `server.sh up --seed --force-posture staging`      | The flag crosses the shell-out at `development/server.sh:149` and `seed-dev.sh` permits (AC-GAP-3)               |
| HP-06 | A carrier naming `production`                                                            | `migrate.sh run`                                   | It warns, names the posture, proceeds without an override, and exits 0 — a warning never moves the exit code     |
| HP-07 | Any posture                                                                              | `server.sh up --build`                             | It proceeds with no override: `up` is bound on `--seed` only, and `:91` in the shipped CI is unbound (AC-GAP-14) |

### Error states (ES-nn)

The visible failures here are refusals and gate failures. Each is a check that the control bites,
not a defect to expect.

| ID    | Given                                                              | When                                   | Then                                                                                                                                                                    |
| ----- | ------------------------------------------------------------------ | -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | A carrier naming `staging` or `production`, no override            | Any of the five refusing paths runs    | Exit 4, message beginning `posture-guard: refused —`, naming the live posture and the re-run command                                                                    |
| ES-02 | The same, in a script that prompts, with no tty                    | `reset.sh` runs                        | Exit 4 with the guard prefix — **never** the exit-0 abort at `reset.sh:98-103` (TM-06)                                                                                  |
| ES-03 | A carrier naming `staging`, an override naming `development`       | `reset.sh --force-posture development` | Exit 4 — a stale override is refused, so an invocation pasted from history dies once the posture rises                                                                  |
| ES-04 | `DOCKER_HOST` pointed at a remote daemon, carrier at `development` | Any of the five refusing scripts runs  | Exit 4 with the guard prefix, at `development` too — Docker pointed elsewhere is not a posture question. `migrate.sh` **warns and proceeds**, following its caller mode |
| ES-05 | The guard call deleted from a bound script                         | The presence assertion runs            | It fails on the line-order comparison — a tested function is not an enforced control (TM-03)                                                                            |
| ES-06 | A citation added that does not resolve and is not budgeted         | `doc-references.sh` runs               | The count rises above the recorded baseline for the file that introduced it                                                                                             |

### Edge cases (EC-nn)

| ID    | Given                                                                               | When                       | Then                                                                                                                   |
| ----- | ----------------------------------------------------------------------------------- | -------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| EC-01 | A carrier whose posture key is commented out — `# DEPLOYMENT_POSTURE: development`  | The guard reads it         | It refuses. The shipped file already carries seven comment lines, so this is likely rather than exotic (TM-02)         |
| EC-02 | A carrier carrying the key twice with **different** values                          | The guard reads it         | It refuses rather than taking a first or last match — a duplicate key is a refuse state, not a precedence question     |
| EC-03 | A carrier left conflict-marked by a `copier update` three-way merge                 | The guard reads it         | It refuses via `_lib/conflict-markers.sh` — its own state, not the absent-key one (TM-08)                              |
| EC-04 | A carrier that exists but cannot be read — permissions, or a directory in its place | The guard reads it         | It refuses exactly as for an absent one; fail-closed makes the reason immaterial                                       |
| EC-05 | A damaged carrier **and** a well-formed `--force-posture production`                | Any refusing path runs     | It still refuses, and the message names the repair rather than a posture — the override is not honoured (AC-GAP-4)     |
| EC-06 | `copier.yml` present at a generated project's root **and** a legal carrier answer   | The guard runs             | The carrier wins; the template exemption is unreachable, which is what stops a stray `copier.yml` disarming it (TM-05) |
| EC-07 | `DEPLOYMENT_POSTURE` exported into the environment, carrier naming `production`     | Any bound script runs      | The carrier wins and the export is ignored — no second channel (TM-04)                                                 |
| EC-08 | No `.env.dev` present, carrier naming `staging`                                     | `server.sh down --volumes` | The posture refusal is what the operator sees, not the env-file `die` at `development/server.sh:100` (AC-GAP-10)       |
| EC-09 | The stack entirely down                                                             | `migrate.sh --self-test`   | It runs and exits 0 — dispatched ahead of `container_running` at `migrate.sh:123-124`, invoking no `docker` (AC-GAP-5) |
| EC-10 | The guard sourced from a worktree under `.claude/worktrees/`                        | `$PROJECT_ROOT` resolves   | It resolves from `BASH_SOURCE` to that worktree's own root, and reads that worktree's carrier — never cwd-relative     |

### Permission and access (PA-nn)

**None in the web sense — this story adds no endpoint, no screen and no protected action.** There
is no role boundary to cross and no identifier whose ownership could be verified. The story's
`API`, `Backend`, `Frontend` and `GDPR` flags are correctly `N/A`.

**That is not the same as saying it has no access-control content.** The authorisation boundary
here is the shell, and the subject is _which environment a destructive command may reach_. The
security gate returned eighteen findings across all six STRIDE categories, and the two that behave
most like PA scenarios are covered above: EC-06, where the template exemption is an elevation path
(TM-05, A01:2025), and ES-04, where the guard authenticates the repository while the `DROP` lands
on whatever Docker is pointed at (TM-01, A01:2025). Recorded here rather than left to be inferred
from an empty table, per `code/docs/GATE-REPORTING.md`.

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The output is a shell refusal read in a
terminal and Markdown read in an editor, neither of which this project controls or ships.

One thing that is _not_ an accessibility criterion but belongs beside it: the refusal message is
the guard's entire user interface, and QA-MANUAL-03 below reads it as an operator would. A control
whose refusal cannot be acted on has failed at the only moment it matters.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as Section 3.

## 5. GDPR & security constraints

**No PII and no new protected action** — the story creates a shell helper, wires six callers, and
edits Markdown. It introduces no field, no store and no code path that could carry personal data.
Its `GDPR` flag is correctly `N/A`.

**Security constraints do apply, and they are the substance of the story rather than a side
concern.** The twelve criteria in the story's Security section — eleven from
`ASSESSMENT-PLAN-US006-POSTURE-GUARD` Section 7, plus **7.12 added at this gate** — are not
restated here. Four are QA-visible and are the ones a tester checks directly:

- **The carrier-only read** (7.1, TM-04) — a tester exports `DEPLOYMENT_POSTURE=development`
  against a `production` carrier and confirms the guard is unmoved. The house idiom two lines away
  at `reset.sh:24-25` lets the environment win, so this is a live temptation rather than a
  theoretical one.
- **The ordering** (7.4, TM-05) — a tester puts a `copier.yml` at a fixture project's root beside a
  legal carrier and confirms the carrier wins. If it does not, the whole control is disabled by
  one unauthenticated file test.
- **The damaged-carrier verdict** (7.5 and 7.11, TM-07, AC-GAP-4) — a tester confirms that no
  damaged state plus any override permits a destructive run, and that the message names the repair
  concretely — the file, the key and the three legal values — rather than a posture or a pointer to
  a document with no repair procedure.
- **The presence assertion** (7.8, TM-03) — a tester deletes a guard call and confirms something
  fails. This is the only criterion that survives an implementer who is careless later rather than
  wrong now.

**The severities are read with their promotion triggers.** 0 CRITICAL, 0 HIGH, 9 MEDIUM, 7 LOW,
2 INFO is a fact about a tree where nothing is deployed, not a verdict on the design: five findings
promote to HIGH at the first staging surface, and TM-02 and TM-08 promote at the first
`copier update` run against a project above `development`. Per `code/docs/GATE-REPORTING.md` the
zero is never reported as the gate passing.

## 6. Developer notes — testability

- **The self-test's placement is a correctness property, not a style choice.** Dispatch it ahead
  of `migrate.sh:97-102` and `migrate.sh:123-124`. Put it anywhere else and the proof of a guard
  built for the stack-down case requires a running stack (AC-GAP-5).
- **Point the guard at the fixture root through the entry point's first positional argument.**
  Not an environment variable — 7.1 bans one, and a test seam that reuses the banned channel is
  the control's own bypass wearing a test hat (AC-GAP-12).
- **There is nothing to compare against pre-change.** No `posture-guard.sh` exists and
  `--self-test` dies at `migrate.sh:101`. Assert on the guard's own verdict per case; do not try
  to resurrect the before/after idiom that works for `audits/doc-references.sh`, where the subject
  already existed (AC-GAP-6).
- **`doc-references.sh` may or may not need a baseline, and US004 decides.** Check whether US004
  has landed before running it. If it has, the gate exits 0 on a clean tree and a plain pass is
  available; if it has not, capture the baseline over every file this story edits _before the
  first edit_, because a post-hoc baseline cannot distinguish an introduced finding from a
  pre-existing one — which is the whole property the ADR buys (AC-GAP-15).
- **Record the git index state beside any citation-gate figure.** Section 7 shows a 50-finding
  swing on this tree between two honest runs an hour apart, caused entirely by a parallel session
  committing its own artefacts. A number without its index state is not a baseline.
- **Two counts in this story are derived, and derived counts rot.** The bound set (six scripts,
  five refusing paths) and the proof-case list (twenty-one) are each stated once and cited everywhere
  else. If a later gate binds a seventh script, change the table and the list — not the fifteen
  places that used to carry the number, which is how AC-GAP-2 happened.
- **`wc -l` is not the length gate's measure.** `code/src/scripts/audits/CONTEXT.md` is 298 code
  lines and 357 file lines. Run `docs-length.sh` and read its number (AC-GAP-18).
- **No pytest, no coverage figure, no migration check.** The story's Verification Checks mark each
  `N/A` with its reason and the test record must do the same rather than leave them blank.

## 7. Gate baselines, measured 05/09/2026

Captured on a **clean working tree at HEAD `c6df520`**, before any edit this plan causes.
`ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` obliges a pre-edit capture for the citation
gate; the others are recorded on the same terms, because a regression guard with no recorded
starting point cannot show a regression.

| Gate                       | Exit | Measured 05/09/2026, HEAD `c6df520`, clean tree                                                                                                   |
| -------------------------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/doc-references.sh` | 1    | **103** citations do not resolve tree-wide · **9** cite `US006.md` · 3 cite the US006 threat model · 0 cite the assessment                        |
| `audits/docs-length.sh`    | 0    | 767 instructional files, 0 failures, 5 in the 270+ warn band. `code/src/scripts/audits/CONTEXT.md` at **298** (2 left)                            |
| `audits/docs-pairing.sh`   | 0    | 0 findings — 221 `CONTEXT.md` and 211 `CLAUDE.md` checked, 48 `code/src` directories walked                                                       |
| `audits/routing-skills.sh` | 0    | 0 findings — 591 skill names across 252 files with routing frontmatter                                                                            |
| `syntax/lint.sh`           | 0    | Every leg ran and was clean — ruff, markdownlint (906 files), ESLint, tsc, rustfmt + clippy. Exit 3, the could-not-run code, was **not** returned |

**Measured again with this gate's five artefacts staged: 127 tree-wide, +24 on the baseline.**
Every one of the 24 is either an **instance citation** of a PM artefact — the class
`ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` exempts, 21 of them — or a **forward
reference** to a file that does not exist yet: `code/docs/ABSENCE.md` (US003), `code/docs/reliability/`
(US001) and `code/src/scripts/_lib/posture-guard.sh` (this story), 12 of them across all five files.
**None is of a class this work owns**, which is the only reading `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
accepts — the total is never the verdict.

**The nine on `US006.md`, named individually** so a tenth is visible immediately: `:131` twice
(`code/docs/ABSENCE.md` and `code/docs/reliability/`, US003's and US001's deliverables), `:137`,
`:150` and `:591` (`SPRINT-04`, three times), `:149` (`MAP-RETRY-AND-IDEMPOTENCY`), `:162`
(`MAP-RULE-OWNERSHIP`), and `:199` and `:489` (this story's own `posture-guard.sh`, twice). Five
instance citations, four dangling paths, exactly as the story's disposition claims — **with one
error, at line 131 and not 119** (AC-GAP-15).

**The same tree gave 153 earlier the same day, and the difference is not a defect in either
run.** That measurement was taken with the parallel US005 session's two plan files still
untracked; they contributed **69 findings between them**, and committing them removed the lot.
Three consequences for whoever works this story:

- **A baseline is comparable only against a run in the same index state**, which is why the HEAD
  and the tree state are written beside the figure above rather than the figure alone.
- **These swings are not this story's to account for.** US006's own 9 was stable across both runs,
  which is the argument for a per-file figure — and AC-GAP-15's argument for capturing one over
  _every_ file the story edits rather than this one alone.
- **It is fresh evidence for US004**, whose whole subject is that this gate answers differently
  depending on the git index. Recorded here rather than raised as a gap: the story that owns the
  repair exists and is already SPRINT-02's sole `Must`.

**One structural fact gate 15 needs.** `project-management/src/**` sits outside the dangling-path
checkable-tree allowlist in `doc-references.sh`, so the two ADRs this story cites by full
repo-relative path produce **no finding** today and will produce none when they are written.
Writing them moves the count in neither direction, and a reviewer expecting it to is reading the
gate wrong.

## 8. Two candidates refuted, and why they are recorded

Both were raised by an adversarial lens, both were plausible, and both fail on a fact. They are
kept because the next reader will otherwise raise them again.

- **"The `=`-form parser claim is wrong."** The story justifies re-cutting the map's
  `--force-posture=<posture>` spelling by noting that the repo's one `=`-form parser sits outside
  `code/src/scripts/**`, at `00-ASSETS/scripts/export-pm-files.sh:97-105`. The candidate observed
  that that range is a **dual**-form parser: `--type=*` at `:97-100` and a space-separated
  `--type` at `:101-105`. True, and it does not touch the claim — "the repo's one `=`-form parser"
  means the only parser accepting an `=` form, and a repo-wide sweep finds no other. The map re-cut
  stands on its stated grounds.
- **"The three `copier.yml` spellings do not disagree."** The candidate counted four sites and
  found no observed disagreement. The story says _spellings_, not sites, and names three:
  `pre-pr-check.sh:80` resolves `PROJECT_ROOT` from `BASH_SOURCE`, `template-docs-readonly.sh:35`
  from `git rev-parse --show-toplevel`, and `lefthook.yml:137` tests `copier.yml` bare and
  cwd-relative. Three different resolution strategies for one test **is** the disagreement, and it
  is why 7.3 pins the anchor. TM-11 stands.

---

## Cross-references

- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan against the shipped change
- `project-management/src/02-STORIES/US006.md` — the story this plan tests, and which took all twenty-two gaps on 05/09/2026
- `project-management/src/03-SPRINTS/SPRINT-04.md` — the sprint this story opens, whose Notes carry AC-GAP-16's carry-over contingency
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` · `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` — the security gate whose Section 7 this plan amends at 7.5, 7.6, 7.7 and 7.12
- `project-management/src/15-DECISIONS/ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` · `project-management/src/15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md` — the two records AC-GAP-17 corrected before they were written
- `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — the regime Section 7 runs under, and which US004 retires
- `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` — the map whose S-01 script list AC-GAP-2 re-cuts
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` sections, Section 7 and Section 8 rest on
