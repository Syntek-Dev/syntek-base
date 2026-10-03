# STORY-PLAN-US012 — A seeded file that never lands is reported, and the gate's header claim becomes true

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 03/10/2026                         |
| Branch | `us012/seed-presence-gate`         |
| Sprint | SPRINT-07 · Wave 2 · build order 1 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

<!-- BORN WITH ITS PREFIX, 03/10/2026. The number `11-` was reserved for this story on 21/09/2026,
     recorded in `../02-STORIES/US012.md` (its Dependencies, the bullet on SPRINT-07's close: "for
     this story at its reserved `11-`") and in `../03-SPRINTS/SPRINT-07.md` -> Dependencies, and on
     03/10/2026 as a no-file row in `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Story Plans — the
     code master_. The prefix is the story's position in the settled build order across the WHOLE
     backlog — US007, US001, US002, US003, US004, US005, US006, US008, US009, US010, US012 — not
     its sprint and not a per-sprint counter, so US012 is eleventh, opening SPRINT-07 behind
     SPRINT-06's US010. It is RENUMBERED whenever build order changes, which is the OPPOSITE of the
     sibling rule for the sprint plans: a sprint plan carries two numbers and a mismatch between
     them is information, while a story plan carries one, so its prefix must track build order or
     it says nothing. `./CLAUDE.md` owns the rule.

     Re-derived 03/10/2026 and confirmed still current. The sprint plans in their own exec-order
     sequence are 01- to 07-; `../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` builds US010 alone, US009's
     carry held in reserve and not landed, and `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Build
     order_ builds US012 then US011. The tracked run is contiguous `00-` to `09-` at `282ec0b`
     (C4); US010's plan takes "10-" in its own story-plan change, committed immediately before this
     one (settled 03/10/2026, 16-sprint-plans grilling round 9 Q22) and already on disk, untracked,
     in the working tree this plan was written in — so this plan is the eleventh file and "12-"
     stays reserved for US011. If US009's carry lands in SPRINT-06, US010 and US009 swap "09-" and
     "10-" and this prefix does not move (06-SPRINT-PLAN-06 -> _Build order_). The
     descriptor `SEED-PRESENCE-GATE` matches the story's QA plan, as every existing pair does. Wave
     2 is the story's position in its map's cutting order — slice `S-02` of
     `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md`, cut 21/09/2026 after `S-01` became US006 on
     05/09/2026 (`:4`, `:165-166`) — and does not move with the sprint; build order 1 is first of
     {US012, US011}, the `Must` before the stretch tier. -->

<!-- STEP 1 DREW ITS ROUND FROM THE RECORDED ANSWERS (.claude/skills/grilling/SKILL.md -> A decision
     already recorded is a fact). The story's own rounds settled its scope on 21/09/2026 — the
     MAP-SCRIPT-GUARDS interview round, Q1 (ownership of the loop and the probe) and Q2 (Must, 2 SP,
     SPRINT-07), and the follow-up round, Q1 (SPRINT-07 closed), Q2 (the red run is a deliberately
     red commit on the story branch) and Q3 (Must on the narrowed rationale) — and gate 11 resolved
     nine AC-GAPs into it the same day. Two answers of 03/10/2026 bind this plan: US012 owes a manual
     testing guide (settled 03/10/2026, 16-sprint-plans grilling round 9 Q21), and the guide is
     written straight after this plan and committed with it (round 9 Q22). The 17-story-plans
     grilling round 1 of 03/10/2026 was asked for US010 and US012 together; its three answers (Q1,
     US010's build phasing; Q2, one generated-tree grep, built by US010; Q3, who reads an index as a
     stranger) bind US010 and US011 and none of them binds this story. No residue for US012 was put
     to <%DEVELOPER_NAME%>: every question this plan needed answered is recorded in the story, its QA
     plan or SPRINT-07's plan. The plan-level calls it makes are in _Key Decisions_, each reversible
     and named as a call. -->

**Implements no ADR, and the absence is the story's own reading.** `../02-STORIES/US012.md` ->
_Decisions_ records none: the ownership split with US010 is a scoping decision either story could
reverse by moving two criteria back, and the remedy wording is a message string.
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` binds every
story's **citation criterion** while `doc-references.sh` is red, and this story has none — its
criteria run no citation gate (`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Decisions binding this
sprint_) — so no baseline is owed; why that holds is under _Testing_.

> **Source authority.** Where this plan conflicts with `../02-STORIES/US012.md` or
> `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md`, the story and then the sprint plan win, and the conflict
> is a defect in this plan. This plan records the engineering route, not the requirement.

Three template sections are dropped: the **Table of Contents** (a single-lane, single-file plan),
the **As-Built Summary** (this plan is forward-looking) and **Pre-existing bug fixes** (none is
fixed en route; a defect the build finds beyond the story goes to `../21-BUGS/`, per _Documentation
Write-Ups_). The four per-layer sections are dropped under _Approach_, each with its reason.

---

## Problem Statement

**Why this story exists.** `.github/scripts/shipped-artefacts.sh` tells every reader that check 4
catches the too-tight failure mode of its allowlist, and for the files `SEEDED` names it does not.
Measured 03/10/2026 at `282ec0b`, unchanged since `90600c9`: `SEEDED` is declared at `:105` with one
entry, `01-FEATURE-MAPS/MAP-SCALE-PLANNING.md`, and read in one place only — check 3's leak
allowlist at `:197`. Check 4 loops `NAMED_SHIPPED` and `SHIPPED_GLOBS` and nothing else
(`:215-224`); the header's claim that "3 catches the first, 4 the second" is at `:40-43`. On a
fixture, deleting the seed produced **zero findings and exit 0** from the full run and from
`--self-test` alike (`../11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md` Section 7). The story
is `../02-STORIES/US012.md`.

**Current state — what is silent, narrowed.** A one-sided break of the seeding already fails
generation, because the copy-gated `_tasks` entry is one `&&` chain ending `rmdir .copier`
(`copier.yml:994-1005`) and Copier fails a non-zero task. What no job reports is a seed that landed
and was removed by a later step: `MAP-SCALE-PLANNING.md`, which six shipped guides route to
(`copier.yml:982-986`), resolving to nothing in every project generated afterwards. Once US010 grows
`SEEDED` to eight the silence widens to its seven index seeds, whose target paths are populated
in-tree, so a seed removed together with its `mv` is silent too (AC-GAP-6, settled 21/09/2026).

**What this story delivers** — one file, `.github/scripts/shipped-artefacts.sh`:

- a third loop in check 4 asserting every `SEEDED` entry landed, its finding carrying the seed's own
  repair and never a `!` negation;
- the closing guidance the full run prints beneath its findings stopped sending a seed finding to the
  `copier.yml` allowlist;
- a sixth `--self-test` probe that moves the **last** `SEEDED` entry and sees exactly one finding,
  shown red in CI before it is shown green;
- the header contract, the `--help` text and the two comments rewritten so the script stops claiming
  a coverage it lacks.

**Out of scope, each owned elsewhere:** growing `SEEDED` (US010); whether a seed's **content** is
right (US010's `ST03`, `ST04` and `ST06`, and the header's "What it CANNOT check" paragraph, which
stays unchanged); the root seeds, which the `[3/4]` job asserts present by other means (the
completeness step at `.github/workflows/audit-template.yml:230-248`, and `shipped-ai.py`); and any
`GAPS.md` row — the entry this story's slice claimed was removed at charting
(`../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md:38-41`), and retiring the map's claim at `:46` is
`22-implementation-documentation`'s write against the shipped change.

**Layer scope.**

| Layer                         | In scope? | Notes                                                                                 |
| ----------------------------- | --------- | ------------------------------------------------------------------------------------- |
| Database / models / migration | —         | `DB: N/A`                                                                             |
| Service layer                 | —         | No Python                                                                             |
| Django Ninja API              | —         | `API: N/A`                                                                            |
| Frontend (templates)          | —         | `Frontend: N/A`                                                                       |
| Infrastructure / DevOps       | ✓         | One CI integrity script under `.github/scripts/`; no workflow, Compose or deploy file |
| GDPR / PII                    | —         | `GDPR: N/A` — the script reads file names in a generated tree and prints paths        |

---

## Reference Documents (code/docs gate map)

| Concern (when it gates)                           | Authoritative doc(s)                                                                                                                                                                                | Applies?        |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| **Gate reporting** (every check this story runs)  | `code/docs/GATE-REPORTING.md` — ShellCheck has no project script, the coverage and migration rows are `N/A`, and a green self-test reads one tree; each is a reading, never a pass                  | ✓               |
| **Coding principles** (the bash this story ships) | `code/docs/CODING-PRINCIPLES.md` — function length, the guard-clause form; the script's existing `probe()` and `finding()` idiom is followed rather than re-invented                                | ✓               |
| **Forward voice** (every path this plan names)    | `code/docs/FORWARD-VOICE.md` — a file that does not exist yet is written in double quotes, never backticks, because `audits/doc-references.sh` reads a backticked token as a path that must resolve | ✓               |
| **Testing** (any code change)                     | `code/docs/TESTING.md` — named to record that its coverage floor binds nothing: there is no Python in the diff                                                                                      | ✓ (`N/A` floor) |
| **The script-first rule**                         | `.claude/CLAUDE.md` Section 6 — no raw `uvx copier copy`, so every generated-tree run is CI's                                                                                                       | ✓               |

> Cross-layer: `project-management/docs/QA-GUIDE.md` (the scenario shape the guide cites) and
> `project-management/docs/GIT-GUIDE.md` (the branch, and the red commit pushed to it).

**Every other row of the template's gate map is checked and absent, and the absence is the
reading.** URL, architecture, data structures, API design, encryption, RLS, rendering, responsive,
accessibility, design tokens, performance, scale, logging and Cloudinary bind nothing: the story
ships one bash script, and its `DB`, `API`, `Frontend`, `Backend`, `GDPR`, `Security` and `Logging`
flags read `N/A`. The Security row is `N/A` by flag with its reason — see _Security_.

---

## Architecture Decision

**No architectural choice is made here; every structural fact is fixed upstream, and this plan
names which.**

| Fixed by                                                          | What it fixes                                                                                                                                                        |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| MAP-SCRIPT-GUARDS interview round, 21/09/2026, Q1                 | This story owns the check-4 `SEEDED` loop **and** the seeded-deletion probe, because the probe tests the loop; US010 keeps only the growing of `SEEDED`              |
| `../02-STORIES/US010.md` -> _Dependencies_, as amended 27/09/2026 | **One region of the script is shared by design** — the comment above `SEEDED`; whichever story lands second extends the other's wording rather than contradicting it |
| AC-GAP-2, settled 21/09/2026                                      | `probe()` gains no forbidden-substring argument; the finding is shaped path-then-seed-wording so one substring carries the positive half                             |
| AC-GAP-4, settled 21/09/2026 (follow-up round, Q2)                | The red run is a deliberately red commit pushed to the `us012/` branch, for CI's `[3/4]` job to run                                                                  |
| AC-GAP-5, settled 21/09/2026                                      | The probe moves the **last** `SEEDED` entry by index expression — never the first, never a literal, never `[-1]`                                                     |
| AC-GAP-1 and AC-GAP-8                                             | The closing guidance must not send a seed finding to the allowlist (its form left to the build); the finding computes no `.copier/` source path                      |

**What this plan is free to choose, and chooses:** the commit shape between red and green, where the
probe's wording is fixed, and how the `SEEDED` comment is worded in each landing order. Each is a
reversible call recorded under _Key Decisions_.

**No infrastructure dependency is introduced.** The proof runs in the existing `[3/4] Template
Generation` job on GitHub Actions, which already runs `--self-test` at
`.github/workflows/audit-template.yml:225` and the full check at `:228`; the story adds no step, so
there is no new seam to give a verdict to and no `how-to/src/PLATFORM-PROVIDERS.md` row.

**The file stays well under the source limit.** `shipped-artefacts.sh` is 344 lines, measured
03/10/2026; the loop, the probe and the rewritten prose add a few dozen at most, so no 750-line split
is foreseen.

---

## Approach

### Not applicable — Database, Service Layer, API, Frontend

The story adds no model, no Python, no template and no component. The four layer sections the
template carries are dropped because the story touches none of them, not to dodge a gate; the sprint
plan records the same three `N/A` phases with their reasons.

### Phase plan — the first two phases are the story's own red-then-green proof

| Phase | Deliverable                                                                                                                                                                    | Blocked by                                                                  |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| P0    | The state the build starts from, read — how many entries `SEEDED` holds and whether US010 has landed, which decide which entry the probe moves and whose comment is extended   | The `us012/` branch existing, cut from `main`                               |
| P1    | **The red commit** — the sixth `--self-test` probe, alone, pushed; `[3/4]` red on the probe's own line                                                                         | P0, and the status flip already committed on its own (_Status Propagation_) |
| P2    | **The green commit** — the check-4 loop and its finding, pushed; `[3/4]` green at **6 probes**, the full run over every generated tree exiting 0; the probe unchanged since P1 | P1's red run seen and its ID taken                                          |
| P3    | The closing guidance, the header contract, `--help` and the two comments; pushed and green again; the parse check, ShellCheck, the string test and the no-negation read        | P2                                                                          |
| —     | The automated test record, the walk of the manual guide and the map's claim — **`22-implementation-documentation`'s**, not this story's build                                  | P1 to P3                                                                    |

**P1 precedes P2, and the order is forced by the proof.** The story's criterion is that the probe is
seen red against today's check 4 before the loop turns it green "with no change to the probe"
(`../02-STORIES/US012.md` -> _Acceptance Criteria_, the scenario "The probe discriminates"). A
loop committed first, or with the probe, leaves no run in which the probe could fail for the right
reason.

**P3 is separate from P2 by this plan's call** (_Key Decisions_ 1): the red-to-green diff then
carries the loop and its finding alone, so the green is attributable to the loop and "no change to
the probe" is a one-region diff read. None of P3's text is read by any probe, so splitting it out
moves no proof. P3 is prose — or prose and one condition, if the build takes the closing guidance's
conditional form (AC-GAP-1) — and **no run parses the closing guidance**, which is why P3 carries
its own parse check (see P3).

**Every phase is testable on its own:** P1 by the red run's probe line; P2 by the green run's
success line and the full run; P3 by the parse check,
`bash .github/scripts/shipped-artefacts.sh --help`, a diff of the header and comments, and the
branch-head `[3/4]` run.

### P0 — The state the build starts from, read rather than captured

**Nothing in P0 needs capturing**, because every value is re-readable from the pre-edit commit at any
time — which is why the manual guide's _Recorded during the build_ is empty. P0 reads two things:

- **How many entries `SEEDED` holds** at the commit the branch is cut from: one if US010 has not
  landed, eight if it has. The probe moves the last, so with one entry it moves `MAP-SCALE-PLANNING.md`
  and with eight it moves the eighth, an index seed — the non-first position the loop must reach
  (AC-GAP-5).
- **Whether US010's rewrite of the comment above `SEEDED` is already in.** It decides whose wording
  P3 extends — see _The landing order with US010_ below.

The branch is cut from `main` only after `pm/story-creation` is merged there, so that every planning
artefact this story rests on is on the branch (`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Branch
Naming Reference_).

### P1 — The probe, alone: the red commit

| Requirement      | Shape                                                                                                                                                                                                                     | From              |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| Position         | After the check-4 named-file probe (`:277-280` on 03/10/2026) and before check 5's, mirroring the check-4 probe's shape                                                                                                   | Story task        |
| What it moves    | The **last** `SEEDED` entry, addressed as `${SEEDED[${#SEEDED[@]}-1]}` — never a literal path, and never `${SEEDED[-1]}`, which bash 3.2 rejects — from the copy's `project-management/src/` to `$tmpdir/held`, then back | AC-GAP-5          |
| The holding path | `$tmpdir/held`, reused: the check-4 probe has already moved its file back by then                                                                                                                                         | QA plan Section 6 |
| What it asserts  | `probe` on a substring running **from the moved path into the seed's own wording**, so a finding copied from the named-file message fails it                                                                              | AC-GAP-2          |
| Restoration      | The file is moved back before the next probe runs, so check 5's probe does not inherit the deletion                                                                                                                       | HP-04             |

**The seed wording is fixed here, at P1, and not at P2.** The probe's substring carries it, and the
probe may not change between red and green, so the finding P2 writes must reproduce the wording P1
chose — never the other way round. The wording itself is the implementer's; the shape is not. The
QA plan measured its red with the label "check 4 fires when a seeded file does not land" and a
finding beginning "`<path>` was seeded but did not land"; either may be used, and nothing requires
it.

**Committed alone and pushed to the `us012/` branch** — alone in the commit, not only in the
script, as the story's _QA Tasks — Automated_ reads ("Commit the probe alone"): the story's status
flip is a commit of its own before this one (_Status Propagation_), so the red commit changes
`.github/scripts/shipped-artefacts.sh` and nothing else. `[3/4]` runs on a push to any branch
(`.github/workflows/audit-template.yml:32-34`). The self-test step fails with exit 1, printing the
probe's own line — "produced 0 finding(s): (none);" — while the other five probe lines pass. **That
line is the evidence, never the exit code alone**: a tree lacking the moved seed aborts the probe's
`mv` under `set -e` with the same exit 1 and no probe line (ES-05). The run's ID is taken at the push
(the story's _QA Tasks — Automated_) and written into the automated record at `22`.

**Every later step of the job is skipped in the red run, and that is expected.** No step of
`[3/4]` carries a condition (measured 03/10/2026), so the job stops at the failing self-test; the
full run and the completeness step do not run on the red commit. The red run proves the probe
discriminates and nothing else; the full run is P2's.

### P2 — The loop and its finding: the green commit

- **The loop is a third loop in check 4**, after the `NAMED_SHIPPED` loop at `:215-218` and so inside
  check 3's `else`: a generated tree with no `project-management/src/` stays one finding, not one per
  seed (EC-05).
- **It iterates `"${SEEDED[@]}"`, never `"${SEEDED}"`.** Bash expands an unsubscripted array to its
  first element, so the second form passes on one entry and silently checks one of eight once US010
  lands — the defect class this story exists to close (AC-GAP-5). It asserts each entry is a file
  under the generated `project-management/src/`.
- **Its finding is shaped path, then seed wording, then pointer**: the seeded path; directly after it,
  that the path was seeded and did not land — the substring P1's probe matches; then a pointer to its
  `mv .copier/...` line in the copy-gated `_tasks` entry of `copier.yml`. It carries **no** `!`
  negation advice and computes **no** `.copier/` source path from the entry (AC-GAP-1, AC-GAP-8).
- **The probe is not touched.** The P1-to-P2 diff sits in check 4 alone.

Pushed, `[3/4]` reads green: the self-test's success line counts **6 probes** where it counted 5, the
new probe's line passes, and the full run over both generated trees exits 0 with no check-4 finding
and no check-3 leak for any seed. **A green run printing 5 probes means the probe was never added,
and one printing 7 means something else was** (QA plan Section 7). The green run's ID is taken at
the push.

**If US010 has landed, the loop asserts eight seeds and the probe moves the eighth.** If it has not,
the loop asserts one and the probe moves `MAP-SCALE-PLANNING.md`; US010's own green run is then where
the last-entry probe first moves off that file (QA plan Section 6).

### P3 — The closing guidance, the header contract and the comments

| Site (as at `282ec0b`)              | After                                                                                                                                                                                                                                                                                              |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Closing guidance, `:340-343`        | Never directs a seed finding to the `copier.yml` allowlist — **either** the seed's repair is named beside the allowlist's, **or** the allowlist paragraph prints only when an allowlist finding is among the findings. The form is the build's (AC-GAP-1)                                          |
| Header numbered list, `:36-37`      | Check 4's entry names seeded files beside named shipped files                                                                                                                                                                                                                                      |
| Too-tight paragraph, `:40-43`       | Names a seed that did not land as a failure check 4 catches — a copy-gated move that did not happen, not a tight allowlist                                                                                                                                                                         |
| `SELF-TEST` paragraph, `:48-52`     | Names the seeded-file deletion among the mutations                                                                                                                                                                                                                                                 |
| Header exit codes, `:59-61`         | Exit 1 names a seeded file that did not land                                                                                                                                                                                                                                                       |
| `--help`, `:122-123` and `:126-127` | The `--self-test` line names the seeded-file deletion; the exit-code line names a seeded file that did not land                                                                                                                                                                                    |
| Comment above check 4, `:209-214`   | No longer describes check 4's failures as dropped `!` negations alone                                                                                                                                                                                                                              |
| Comment above `SEEDED`, `:103-104`  | States both reads — check 3's allowlist, check 4's presence — and the repair rule: a seed that fails to land is repaired at its `.copier/` file or its `mv` line, and an entry leaves `SEEDED` only when the seed is retired on purpose, with its `.copier/` file and its `mv` line, in one change |
| "What it CANNOT check", `:45-46`    | **Unchanged**, byte for byte — presence is asserted, content is not                                                                                                                                                                                                                                |

Pushed, the branch-head `[3/4]` run is green again at 6 probes, which is the run the Verification
Checks read. Then, at the close of the build:

- **The parse check**, `bash -n .github/scripts/shipped-artefacts.sh`, by hand — it parses the whole
  file and runs none of it. **No run of this story parses the closing guidance**: it sits after the
  full run's green `exit 0` (`:337` as at `282ec0b`), the self-test exits at `:313` and `--help` at
  `:135`, and bash reads a script one command at a time, so a syntax error there would surface only
  on a real failing full run, and then as bash's exit 2 rather than the contract's 1. It matters
  most if the build takes the conditional form, which puts logic there. Recorded as clean or with
  its error, beside ShellCheck.
- **ShellCheck**, by hand over the script, recorded as clean, as findings, or as not run with its
  reason. `command -v shellcheck` found nothing on the authoring host on 03/10/2026; no project
  script runs it, and it is **never** recorded as a `lint.sh` pass, which has no shell leg.
- **The string test**, by hand: a bash `[[ ... == *...* ]]` comparison of the probe's substring with
  the named-file message for the same path, which must not match (EC-07's positive half). It needs no
  tree.
- **The no-negation read**: the finding and the closing guidance read, and recorded as read — never
  as asserted, because `probe()` carries one substring's presence and nothing else (AC-GAP-2).
- **The scoped citation run over the script**, `doc-references.sh` with `--path` set to the script
  (the command is under _Quality Gates_). It reads `.sh` files, so new comment text is in its
  scope. Measured clean 03/10/2026 at `282ec0b` — one file read, 11 backticked tokens, none tested as
  a repo path — and nothing else edits the file in this story, so a finding it raises is this
  story's own wording and is fixed in the wording. It is hygiene, not a story criterion.

### The landing order with US010, and the one region both stories write

**Neither story blocks the other, and the landing order is not fixed** (`../02-STORIES/CUT-PLAN.md`
P9, 27/09/2026, lifted the two sessions' holds and fixed no order). Build order expects US010 first,
in SPRINT-06.

| US010 has    | `SEEDED` holds | The probe moves            | The comment above `SEEDED`                                                                                                                                                                           |
| ------------ | -------------- | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Landed first | Eight entries  | The eighth — an index seed | P3 **extends** US010's wording — the allowlist check 3 reads, covering the seven index seeds — to both reads and the repair rule, never replacing its account                                        |
| Not landed   | One entry      | `MAP-SCALE-PLANNING.md`    | P3 writes both reads and the repair rule for the one seed; US010 later extends it to cover the seven index seeds, never replacing this story's account of check 4's presence read (US010's own task) |

**Whichever lands second rebases rather than waits.** If the rebase falls between P1's push and
`22`, the red commit's hash changes; its run stays in the branch's Actions history and is found
there, and the probe line it printed is unchanged.

### What the gate can and cannot see

- **The self-test reads one generated tree and the full run reads every one.** `:225` passes the
  `INCLUDE_MOBILE` false tree alone, and the script's self-test reads only its first target (`:250`);
  the full run at `:228` reads both. No record may read a green self-test as proof over every tree
  (EC-09; `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Gate honesty_). Seeds are not mobile-gated,
  so the full run covers the true tree.
- **No CI run of this story prints the seed finding's text.** `probe()` prints only its pass line on
  a pass, the red run's line shows `(none)`, and the full run on clean trees prints no finding. The
  finding's wording and the closing guidance are therefore **read in the source**, never in a log.
- **A tree lacking a seed cannot be made lawfully.** No project script generates a tree, `[3/4]` is
  CI-only by design (`lefthook.yml:177-181`), and a raw `uvx copier copy` is what `.claude/CLAUDE.md`
  Section 6 bans. A hand-built fixture under a scratch directory is lawful for iterating and is
  indicative only (QA plan Section 6); it is never the proof of record.
- **The pre-PR gate does not run this script, and checks that CI still does.**
  `.claude/hooks/lib/check-audits.sh:124-128` names it out of the integrity scope because it exits 2
  bare, and requires `.github/workflows/audit-template.yml` to keep naming it. This story leaves the
  workflow unchanged, so that guard keeps holding.

---

## Key Decisions

| Decision                                      | Chosen                                                                                                                                                                                 | Rejected / Alternative                                                                                | Reason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1. Commit shape                               | The status flip in a commit of its own, first on the branch; red = the probe alone; green = the loop and its finding; then the closing guidance, header and comments in a third commit | One green commit carrying the loop and every prose change; the status flip riding with the red commit | The red commit carries the probe alone, as the story's QA task reads, and the red-to-green diff carries the loop alone, so the green is attributable to it and "no change to the probe" is a one-region diff read. None of P3's text is read by a probe — prose, or prose and one condition if the conditional form is chosen, its syntax proved by the parse check (P3). **This plan's call, 03/10/2026, reversible**                                                                |
| 2. Where the seed wording is fixed            | At P1, in the probe's substring; P2's finding reproduces it                                                                                                                            | Choosing the finding's wording at P2 and adjusting the probe to match                                 | The probe may not change between red and green (the story's scenario "The probe discriminates"). This plan's call, following from the story                                                                                                                                                                                                                                                                                                                                           |
| 3. The closing guidance's form                | Left to the build — either of the story's two forms                                                                                                                                    | Deciding the form here                                                                                | The story's task offers both and the QA plan leaves the form to the build (AC-GAP-1); the constraint, not the form, is the requirement                                                                                                                                                                                                                                                                                                                                                |
| 4. The negative half of the finding's wording | Read at review and recorded as read; walked as a guide row                                                                                                                             | A forbidden-substring argument to `probe()`                                                           | Settled 21/09/2026 (AC-GAP-2, follow-up round): new machinery the story declined. Carried, not re-decided                                                                                                                                                                                                                                                                                                                                                                             |
| 5. Which entry the probe moves                | The last, by `${SEEDED[${#SEEDED[@]}-1]}`                                                                                                                                              | The first; `${SEEDED[-1]}`; a literal path; a second probe                                            | Settled 21/09/2026 (AC-GAP-5). A first-entry probe cannot see a first-entry-only loop; `[-1]` fails on bash 3.2. Carried                                                                                                                                                                                                                                                                                                                                                              |
| 6. Where the red and green runs happen        | CI's `[3/4]` on the pushed `us012/` branch                                                                                                                                             | A local generation; a hand-built fixture as proof                                                     | Settled 21/09/2026 (AC-GAP-4, follow-up round Q2); `.claude/CLAUDE.md` Section 6 bans a raw `uvx copier copy`. Carried                                                                                                                                                                                                                                                                                                                                                                |
| 7. The manual testing guide's surface         | Gate — CI run reads, source reads, one runnable `--help`                                                                                                                               | Staging ES-01, ES-03, EC-01, EC-03, EC-04 or EC-08 on a hand-built fixture                            | The guide is owed (settled 03/10/2026, 16-sprint-plans grilling round 9 Q21), and what it holds is this plan's to decide (`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Story Plans — the code master_). A fixture is indicative only and never the proof of record (QA plan Section 6), so no walk of one could mark the shipped change `Pass` or `Fail`; EC-08's emptied `SEEDED` is a state the story never ships. **This plan's call within that answer, 03/10/2026, reversible** |
| 8. The citation baseline                      | None captured                                                                                                                                                                          | A `doc-references.sh` baseline before the first edit                                                  | The ADR binds a story's citation criterion and this story has none (`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Decisions binding this sprint_); see _Testing_                                                                                                                                                                                                                                                                                                                      |
| 9. The estimate                               | Stays **2 SP**                                                                                                                                                                         | Re-estimating                                                                                         | Settled 21/09/2026, MAP-SCRIPT-GUARDS interview round Q2 (`../02-STORIES/US012.md` -> _Story Points_). This plan adds nothing that reopens it — no file, no CI edit and no phase the story did not price; the status-flip and third commits split work the story already carries. Carried                                                                                                                                                                                             |

---

## Dependencies

| Story / Artefact                                             | Model / Feature                                                                        | Required for                                                                                                                                                             | Current state                                                                       |
| ------------------------------------------------------------ | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------- |
| US010                                                        | Grows `SEEDED` from one entry to eight and rewrites the comment above it               | **Not required** — either order works; it decides which entry the probe moves and whose comment wording is extended                                                      | `Open`, unbuilt; SPRINT-06's `Must`, its plan written in the change before this one |
| US011                                                        | Runs `shipped-artefacts.sh --self-test` and does not edit it                           | **Not required** — its "passes unchanged by US011's diff" criterion holds whichever lands first; landing this story first means US011 is exercised by the stronger check | `Open`; blocked by US010                                                            |
| US006                                                        | `S-01` of the same map — the posture guard                                             | Nothing — the two slices share no file                                                                                                                                   | `Open`                                                                              |
| US016 (provisional, `../02-STORIES/CUT-PLAN.md:201`, `:218`) | Renames the 18-TESTS templates, making `NAMED_SHIPPED`'s entries at `:98-99` deletable | Nothing — a later merge-order item beside this story's region of the script                                                                                              | Not cut                                                                             |
| `pm/story-creation` merged to `main`                         | Every planning artefact this story rests on                                            | Cutting the `us012/` branch from `main`                                                                                                                                  | Not merged (`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Branch Naming Reference_) |

**Blocked by:** none.
**Blocks:** none — US011's criterion reads its own diff and holds in either order.
**Can be done now:** no code until `pm/story-creation` is merged to `main` and the `us012/` branch is
cut from it; from then, all of it, P1 first.

> No cross-cutting programme plan (`17-STORY-PLANS/PLAN-<DESCRIPTOR>.md`) exists in this repository,
> measured 03/10/2026, so there is no serialisation gate to cross-reference beyond the US010 landing
> order above.

### Named and not owned — what a later reader must not re-merge

1. **Growing `SEEDED`** — US010's. This story leaves the array's entries alone and must pass on one
   or eight.
2. **A seed's content** — US010's `ST03`, `ST04` and `ST06`, gated in
   `.github/scripts/shipped-registers.sh`.
3. **The root seeds** — asserted present by the completeness step and by `shipped-ai.py`.
4. **The map's _Register claimed_ `S-02` row** — retired by `22-implementation-documentation` against
   the shipped change; no `GAPS.md` row exists to close.
5. **US010's TM-02 co-control.** US010's threat model names this story's no-negation finding as the
   co-control for the one edit that would leak an index seed's rows (see _Security_). It is satisfied
   by the finding's wording this story already requires, and adds nothing to it.

---

## GDPR

**`N/A`, and the flag reads `N/A` in the story.** The script reads file names in a generated tree and
prints paths. There is no data subject, no lawful basis, no retention window and no DSAR surface;
`09-gdpr-compliance` did not run, its entry condition being absent (`code/docs/GATE-REPORTING.md`).

---

## Security

**`N/A` by flag, with the story's reason, and no security artefact is owed** (settled 28/09/2026,
16-sprint-plans grilling round 1 Q2). The story adds a presence assertion to a CI integrity gate — no
authentication, no personal data, no endpoint, no control whose pass condition it loosens; its one
failure mode is silence, which the self-test probe proves against. **That is a flag reading, never
"the security gate passed"**: no security check runs for this story. There is no mutation, so no
permission or ownership check is owed (OWASP A01 has no subject).

**US010's two signed-off security plans are the only security artefacts naming this story, and they
overturn nothing.** They are carried in so the implementer knows what leans on this story's wording:

| Row (US010's)                                                                  | Severity | What it says of this story                                                                                                                                                                                            |
| ------------------------------------------------------------------------------ | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-02 — a `!` negation re-including an index path leaks this repository's rows | MEDIUM   | The likeliest route to one is the named-file finding at `:217`; this story's "never a negation" finding is the co-control (`../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md`) |
| TM-09 — `SEEDED` is an allowlist already read as a control                     | LOW      | Presence is this story's loop and probe; content is US010's `ST06`                                                                                                                                                    |
| TM-15 — the change edits the gates that judge it                               | LOW      | US010's probe counts were measured with five here; this story may add the sixth first                                                                                                                                 |

**One QA-visible constraint has a security shape** (QA plan Section 5): for a seed whose target path is
populated in-tree, a `!` negation renders syntek-base's own rows into a project wherever the
copy-gated `mv` does not run, which is every `copier update` — the one-way door `copier.yml:988-993`
names. So advice to add one is advice to open that door, which is why the finding and the closing
guidance are read for it. **The wrong-reason red leaks a temporary directory** holding a copy of a
generated tree (ES-05); a generated tree carries no secret, so this is hygiene, and it is why the red
run is taken with every seed present.

---

## Logging & Observability

**`N/A`, and the flag reads `N/A`.** Check 4's finding prints to the `[3/4]` job's output, which is a
report and not a log: nothing is collected, structured or kept beyond the run.

---

## Performance, Rendering, Responsive & Accessibility

**All four are `N/A`, each for its own reason.** Performance: one more loop over at most eight paths
in a CI step. Rendering and responsive: no rendered surface. Accessibility: the output is terminal
text, and **the one property worth keeping is kept by following the idiom** — the failing probe line
is red but carries a cross glyph and the words "produced N finding(s)", so colour is never the only
signal (QA plan Section 3). The new probe and finding use `probe()` and `finding()` and inherit it;
the guide walks it once, on the red run.

---

## Implementation Workflows & Standards

### PM workflow chain (in order)

`02-story-creation` (done) -> `03-sprint-planning` (done, admitted 21/09/2026) -> `11-qa-checks`
(done, `Signed off` 30/09/2026) -> `16-sprint-plans` (done,
`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md`, 03/10/2026) -> `17-story-plans` **(this plan and its
guide)** -> `19-backend-code` -> `22-implementation-documentation` -> `23-pr-and-review` ->
`24-release` when a version is cut.

**`19-backend-code` is entered although `Backend` reads `N/A`**, because it is where
`01-implement-story` is entered and this story has a build lane — bash. The flag names the Django
surface, not whether code is written (the `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`
reading). **`20-api-code` and `21-frontend-code` are skipped**, their flags reading `N/A`.
`04-database-schema` to `10-security-checks`, `12-seo-checks`, `13-api-design` and `14-logging-checks`
did not run, each because its flag reads `N/A`; `15-decisions` had nothing to accept, the story
recording no decision.

### Code workflows invoked

`01-implement-story` wraps the build; `02-tdd-cycle` applies in its shell form — the probe is written
and seen red before the loop it probes; `07-review` before the PR. `08-security-hardening` is not
entered, Security reading `N/A` by flag. **No stack skill applies** — `stack-django`,
`stack-htmx-templates` and `stack-fastmcp` have no subject; the map's own _Skills to load_ names
`cicd`, `security` and `global-workflow` for this domain, and `security` has no subject here, the
flag reading `N/A`.

### Standards gates

| Gate                                               | Applies                                                                                                                                         |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `.github/scripts/shipped-artefacts.sh`             | **Yes — the story's proof.** `--self-test` and the full run, in CI's `[3/4]` only; `--help` runs anywhere                                       |
| **ShellCheck**                                     | **Yes, and by hand.** No project script runs it; absent on the authoring host on 03/10/2026; recorded as run or as not run                      |
| **The parse check** (`bash -n`)                    | **Yes, and by hand**, at P3 — the one reading that parses the closing guidance; recorded as clean or with its error                             |
| `audits/doc-references.sh`                         | Scoped over the script at P3, as hygiene — see P3. No baseline is owed                                                                          |
| `syntax/lint.sh`                                   | **Markdown only**, over the PM records `22` writes. Its legs read no bash                                                                       |
| `syntax/format.sh`                                 | Markdown only, the same records                                                                                                                 |
| `syntax/check.sh`                                  | **`N/A`** — no Python, TypeScript or Rust in the diff                                                                                           |
| `tests/all.sh --coverage`                          | **`N/A`** — the story ships no Python; its proof is the `--self-test`                                                                           |
| `database/migrate.sh check`                        | **`N/A`** — no model and no migration                                                                                                           |
| `audits/docs-length.sh` · `audits/docs-pairing.sh` | **`N/A`** — no `CONTEXT.md` or `CLAUDE.md` is edited and no directory is created; `.github/` carries no documentation pair, measured 03/10/2026 |

---

## Execution & Verification via Claude Dynamic Workflows

**The internal procedure comes first** (`.claude/CLAUDE.md` Section 2.7): each stage names the
workflow it executes.

### Stage 0 — Plan verification (before any code)

This plan and its guide are reviewed adversarially at `17-story-plans` Step 9 before either is
treated as codeable. Before building, the implementer re-resolves every line number in this plan
**by quoted text**: the anchors are as at `282ec0b`, and US010 landing first moves `SEEDED`'s line
and everything below it.

### Stage 1 — Build (the shell red-green loop)

P1 -> push -> read the red line -> P2 -> push -> read the green line and the full run -> P3 ->
push. **The probe must fail for the right reason first**: a zero-finding line proves the loop is
missing; an `mv: cannot stat` proves only that the seed was absent, and the two exit alike.

### Stage 2 — Continuous verification gates

After each phase: `bash .github/scripts/shipped-artefacts.sh --help` locally, the pushed `[3/4]` run,
the parse check (`bash -n`) after any edit below the full run's green `exit 0`, ShellCheck by hand
where present, and the scoped citation run over the script. **Every gate is scoped
to this story's own paths**: US010 and US011 may be in flight in sibling worktrees, and a repo-wide
`--fix` cannot be proved not to have touched their files.

### Stage 3 — Review (before raising the PR)

`code/workflows/07-review/` — `code-reviewer` for standards and spec, then `qa-tester` for the hostile
pass, each dispatched independently and named in the prompt; **no skill reviews its own work**. The
reviewer reads the finding and the closing guidance for any negation or allowlist advice and records
the read as a read. A `security` pass is not dispatched: no auth, permission, PII or endpoint is in
scope.

### Stage 4 — Behavioural verification

The behaviour is the CI runs, red then green, and the manual guide walked at `22`. There is no
running app to start.

### Stage 5 — PR and release

`23-pr-and-review` -> `24-release` if a version is cut. The change is template-only — `.github/scripts`
never reaches a generated project (`.github/workflows/audit-template.yml:201-205`) — so whether it
earns a bump is `24-release`'s to judge under `project-management/docs/VERSIONING-GUIDE.md`, not this
plan's.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**This story runs no container, and that is unusual enough to state.** Every proof runs on a GitHub
Actions runner over trees Copier generated there; nothing reaches Docker, so there is no
local-versus-Docker pair to keep aligned.

### Canonical commands

| Purpose                    | Command                                                                                          | Runs        |
| -------------------------- | ------------------------------------------------------------------------------------------------ | ----------- |
| The script's usage         | `bash .github/scripts/shipped-artefacts.sh --help`                                               | Anywhere    |
| The parse check            | `bash -n .github/scripts/shipped-artefacts.sh`                                                   | Anywhere    |
| The self-test and full run | `bash .github/scripts/shipped-artefacts.sh --self-test <generated-tree>` and the full form       | **CI only** |
| Citation gate, scoped      | `bash code/src/scripts/audits/doc-references.sh --path .github/scripts/shipped-artefacts.sh`     | Local       |
| Markdown lint and format   | `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <file>` · `format.sh` likewise | Local       |

### The three exceptions, and why each is allowed

1. **ShellCheck, run by hand.** No project script wraps it; running it directly is the only way to
   run it at all. If it is not on the host, the reading is "not run" with that reason — this plan
   does not install it.
2. **The string test, typed at a terminal.** A bash `[[ ... ]]` comparison is not a tool
   `.claude/CLAUDE.md` Section 6 bans, and the story asks for it as a test that needs no tree.
3. **The parse check, `bash -n` over the script.** No project script parses a shell file, and bash
   is not a tool Section 6 bans; `-n` reads the whole file and executes none of it, so it is the one
   reading that reaches the closing guidance on a clean tree (P3).

**Never a raw `uvx copier copy`**, whether to make a tree for the probe or to reproduce a CI run. A
hand-built fixture is lawful for iterating and indicative only (QA plan Section 6).

---

## Testing

**No pytest, no coverage figure, no migration check — each recorded `N/A` with its reason.**
`code/docs/TESTING.md`'s one floor (75% line and branch, 90% auth) has nothing to bind: there is no
Python in the diff. The proof is the `--self-test`.

**No citation baseline is owed, and the reason is stated rather than assumed.**
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` makes **a
story's citation criterion** a diff against a baseline, and reads it over "any shipped file the story
writes or edits". This story has no citation criterion, and the one file it edits never ships:
`.github/workflows/audit-template.yml:201-205` asserts `.github/scripts` absent from every generated
project. The scoped run under P3 is hygiene over that file, not this ADR's regime.

### Automated — where each scenario is proved

| QA scenario                | Proof                                                                                                                 | Where                                         |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| ES-04                      | The red run: the probe's own zero-finding line, the other five passing, exit 1                                        | CI `[3/4]`, the P1 commit                     |
| HP-02, HP-03, HP-04, HP-05 | The green run: **6 probes**; the new probe's line passes; check 3's map-leak and check 5's probes still pass after it | CI `[3/4]`, the P2 commit                     |
| HP-01                      | The full run over every generated tree exits 0                                                                        | CI `[3/4]`, the P2 commit and the branch head |
| EC-07 (positive)           | The string test: the probe's substring does not match the named-file message for the same path                        | By hand; no tree                              |
| —                          | The parse check, `bash -n` over the script, recorded — the one reading that parses the closing guidance               | By hand; no tree                              |
| —                          | ShellCheck over the script, recorded                                                                                  | By hand                                       |

Every run's ID, the red probe line, the green success line, the string test, the parse check and
the ShellCheck reading go into "project-management/src/18-TESTS/AUTOMATED/US012-TEST-STATUS.md",
written at `22`, with the coverage and migration rows `N/A` and their reasons rather than blank.
**Two homes are the specs', the rest this plan's call:** the run IDs and probe lines by the story
(_QA Acceptance Criteria — Automated_, its second criterion) and QA plan AC-GAP-4, and the `N/A`
rows by QA plan Section 6; the string test, the parse check and the ShellCheck reading are homed
there by this plan, the story asking only that the string test be shown and the ShellCheck result recorded; the parse check is this plan's own addition (P3).

**Scenarios not proved by any run, with their disposition:** ES-01 and ES-03 need a generated tree
lacking a seed, which cannot be made lawfully (see _What the gate can and cannot see_) — the finding
they would print is the one the new probe produces inside its own copy, and the refusal path ES-03
reads is unchanged by the diff. ES-02, EC-02, EC-05, EC-06, HP-06 and EC-07's negative half are
reads of the source. ES-05 is the red to avoid, not a red to take. EC-01, EC-03 and EC-04 are fixture
readings the QA plan recorded and no criterion needs, and the guide does not stage them (_Key
Decisions_ 7). EC-08 — an emptied `SEEDED` aborting the
probe's subscript under `set -u` — is a known limitation the QA plan records as not fixed: retiring
the last seed removes the probe in the same change. EC-09 is the one-tree self-test, read.

### Manual testing

- `../18-TESTS/MANUAL/US012-MANUAL-TESTING.md` — authored from the specs beside this plan at
  `17-story-plans` Step 7.2, and walked, not written, at `22`. A pointer, never a list of its own.

---

## Documentation Write-Ups (Implementation Records)

| Record                                | This story                                                                                                                                                        |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| This plan                             | Always — this file                                                                                                                                                |
| ADR                                   | **Not required** — the story records no decision                                                                                                                  |
| User story · sprint plan · record     | `../02-STORIES/US012.md` · `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` · `../03-SPRINTS/SPRINT-07.md`                                                               |
| QA plan · QA implementation review    | `../11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md`, `Signed off`; the `IMPLEMENTATION/` review at `22`, verified at `23-pr-and-review`                       |
| Manual testing guide                  | `../18-TESTS/MANUAL/US012-MANUAL-TESTING.md` — authored here, walked at `22`, verified at `23`                                                                    |
| Automated test record                 | "project-management/src/18-TESTS/AUTOMATED/US012-TEST-STATUS.md", written at `22` — the run IDs, the probe lines, the string test, the parse check and ShellCheck |
| Code review record                    | `../19-REVIEWS/`, at `23-pr-and-review`                                                                                                                           |
| Security · GDPR · SEO · API · Logging | **Not required** — each flag reads `N/A`, with its reason above                                                                                                   |
| Schema / ERD · migration notes        | **Not required** — `DB: N/A`                                                                                                                                      |
| Bug · refactoring records             | Conditional — only if the build finds a defect beyond the story                                                                                                   |
| Release                               | Conditional — `24-release`'s, if a version is cut                                                                                                                 |

**And one register duty, which is a discharge rather than a write.** `22` marks the `S-02` row of
`../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md`'s _Register claimed_ table retired against the shipped
change, and confirms the `S-02` Slices row still names US012 (**verify, do not re-cut**). No
`GAPS.md` row is closed, none existing; `DEFERRED.md` gains no entry.

---

## CONTEXT.md & Index Updates

| File                                      | Change                                                                                                                                                                                                                                                                                                                                                |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` | **Paid 03/10/2026 by `17-story-plans` Step 10.** The US012 row of _Story Plans — the code master_ points at this file, its Status cell "Not started" as that plan's own section defines the column; the `Must` table's Story-plan cell names this file, and its Git-branch cell and the _Branch Naming Reference_ row take `us012/seed-presence-gate` |
| `../02-STORIES/US012.md`                  | **Paid 03/10/2026 by Step 10.** The story cites this plan and its guide under _Decisions_, and its Dependencies record the reservation taken up                                                                                                                                                                                                       |
| `../17-STORY-PLANS/CONTEXT.md`            | **Nothing.** It ships and holds no index by recorded decision (its _The plans index_ section)                                                                                                                                                                                                                                                         |
| "STORY-PLAN-INDEX.md"                     | Created by US010; this plan's row is part of the population US011 back-fills, its `Updated` this plan's last commit date. Not written by this story                                                                                                                                                                                                   |
| `GAPS.md` · `DEFERRED.md`                 | Nothing — see _Documentation Write-Ups_                                                                                                                                                                                                                                                                                                               |

**The build edits no `CONTEXT.md`.** `.github/` and `.github/scripts/` carry no documentation pair,
measured 03/10/2026, and no shipped guide describes check 4's coverage or the self-test's probe count
— a search of the tree outside the PM layer and the release logs found none — so the header
contract is the only documentation surface, and it is in the script.

---

## Status Propagation & ClickUp Sync

`../02-STORIES/US012.md`'s `**Status:**` moves first — `Open` -> `In Progress` in a commit of its
own, the first on `us012/seed-presence-gate` and before P1's red commit, so that the red commit
carries the probe alone (_Key Decisions_ 1) — and -> `Completed` only at `completion`, after review
and QA. This plan's `| Status |` header row moves with it, in the same commits. The sprint plan's
_Story Plans_ Status cell reads "Not started" and **does not mirror this plan's `Open`**, by that
plan's own definition of the column, pending `../02-STORIES/US007.md` Scenario 8.
`../03-SPRINTS/SPRINT-07.md`'s Story Summary carries no status column.

**The ClickUp export is opt-in and is not wired in this repository**, so nothing is pushed by this
story; the row is recorded so the absence is a reading rather than a gap.

---

## Deferred Items

**Nothing is deferred by this story in the `DEFERRED.md` sense.** Each row below is a limit already
recorded, or work that is someone else's, named so it is not absorbed.

| Item                                                            | To                                | Why                                                                                               |
| --------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------- |
| An emptied `SEEDED` aborts the probe's subscript (EC-08)        | **Nothing — accepted limitation** | Recorded by the QA plan as not fixed: retiring the last seed removes the probe in the same change |
| A forbidden-substring argument to `probe()`                     | **Nothing — declined**            | AC-GAP-2, settled 21/09/2026; the negative half is a read                                         |
| Whether a seed's content is right                               | US010 (`ST03`, `ST04`, `ST06`)    | Out of scope by the story's own Dependencies                                                      |
| SPRINT-07's Notes naming `S-09` as the slice editing the script | `03-sprint-planning`              | See _Measured divergences_                                                                        |

---

## Risks

| Risk                                                                                          | Likelihood | Impact | Mitigation                                                                                                                                                      |
| --------------------------------------------------------------------------------------------- | ---------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The red run is taken on a tree lacking the moved seed**, and its exit 1 is read as the red  | Medium     | High   | The probe line is the evidence, never the exit code; an `mv: cannot stat` with no probe line is ES-05 and is re-taken, not recorded                             |
| The loop is written over `"${SEEDED}"` and passes while `SEEDED` holds one entry              | Medium     | High   | The last-entry probe catches it once `SEEDED` holds more than one (EC-02); with one entry it is read at review (guide LOOP-01)                                  |
| The probe is edited between red and green to match the finding                                | Low        | High   | Key Decision 2 fixes the wording at P1; the guide diffs the probe across the two commits                                                                        |
| The closing guidance still sends a seed finding to the allowlist, unseen by any run           | Medium     | Medium | No run prints it on a clean tree; it is read in the source at review and walked as a guide row                                                                  |
| The closing guidance carries a syntax error no run parses — likeliest in its conditional form | Low        | Medium | The parse check at P3 (`bash -n`); ShellCheck where present. Unchecked, it would surface only on a real failing full run, as exit 2 rather than 1               |
| A line number moves before the branch is cut, most likely by US010 landing first              | **High**   | Low    | Every anchor here is as at `282ec0b` and re-resolved by quoted text at Stage 0                                                                                  |
| US010 lands broken and a seed is missing from `main`'s generated tree                         | Low        | Medium | The green run's baseline then refuses with exit 2 and the seed finding — this story working as designed; the defect is US010's, routed there, never masked here |
| The red commit's hash is rewritten by a rebase before `22` records its run                    | Medium     | Low    | Its run stays in the branch's Actions history; the ID is taken at the push                                                                                      |
| The two stories' rewrites of the `SEEDED` comment contradict each other                       | Medium     | Low    | Whichever lands second extends the other's wording (US010.md -> Dependencies; the story's own Dependencies as corrected 03/10/2026); the guide reads it         |
| A repo-wide `--fix` touches a sibling worktree's files                                        | Medium     | Medium | Every gate scoped with `--path`                                                                                                                                 |

---

## Docker & Nginx Infrastructure

**N = 12.** `how-to/docs/GIT-WORKTREES.md:63` fixes the loopback rule — the final octet equals the
story number — so the IP is `127.0.0.12`. **Verified free 03/10/2026**: a `git grep` for the
address, anchored so `127.0.0.120` does not match, returns no tracked hit, and no sibling plan names
it. Subnets follow
`code/src/docker/CONTEXT.md:101-102`: `10.12.1.0/24` for dev and `10.12.0.0/24` for test, both
free on the same search.

| File                                            | Purpose                                                                                                                                                                      |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us012.dev.yml"  | Dev stack override — from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us012`; nginx on `127.0.0.12:3080:80`; subnet `10.12.1.0/24` |
| "code/src/docker/docker-compose.us012.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us012`; `127.0.0.12:3081:80`; subnet `10.12.0.0/24`       |
| "code/src/docker/nginx/dev-us012.conf"          | Named per `./CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                  |
| "code/src/docker/nginx/test-us012.conf"         | Same                                                                                                                                                                         |

**The two Nginx files are named because this folder's rule names them, and the docker layer says they
do not exist.** `code/src/docker/nginx/CONTEXT.md:28-29` states that `dev.conf` and `test.conf` are
`server_name _` catch-alls a worktree stack reuses unchanged; the four-file rule is satisfied by the two
Compose overrides plus that recorded absence. **And the stack is very likely never started**: every
proof runs in CI, and the worktree is only where the branch is developed.

`/etc/hosts`, once, through `bash code/src/scripts/development/hosts-story-add.sh 012` — the story
number, never `us012`, which the script refuses (`:26`, numeric only; see _Measured divergences_):

```text
127.0.0.12 dev-us012.<%PROJECT_SLUG%>.localhost test-us012.<%PROJECT_SLUG%>.localhost
```

---

## Measured divergences

**Five claims in sibling artefacts that the tree does not support, or that a settled plan in the
tree contradicts, each with its owner.** Two are corrected in this change, by the Step 10 edit of
the story; one is moved by that same edit and left to its owner; two are not this plan's to correct.

| Divergence                                                                                                                                                                                                                            | Measured 03/10/2026                                                                                                                                                                                                                                                                                                                                                                  | Owner                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| `../02-STORIES/US012.md`'s negation comment cites the seed task as `copier.yml:973-984` and the one-way door as `:967-972`                                                                                                            | The task is at `:994-1005` and the door's paragraph at `:988-993`, both moved 21 lines down by the 18-TESTS split in `90600c9`; the story's body was re-pointed then, its comment was not                                                                                                                                                                                            | Corrected in this change                                                                                      |
| `../02-STORIES/US012.md` -> _Dependencies_ says the two stories' edits "sit in different regions" of the script                                                                                                                       | One region is shared by design — the comment above `SEEDED` (US010.md -> _Dependencies_, amended 27/09/2026)                                                                                                                                                                                                                                                                         | Corrected in this change                                                                                      |
| `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` `:94` and TM-02 at `:224` cite the scenario "The finding names the seed's own repair, never a negation" at `../02-STORIES/US012.md:265-271` | Right at `282ec0b`. This change's edits above the story's _Acceptance Criteria_ move the scenario to `:308-314`, and `:265-271` then falls in _Decisions_. The text is unchanged, so the citation re-resolves by the scenario's name                                                                                                                                                 | `10-security-checks`, at the threat model's next correction — this change's file list does not include it     |
| `../03-SPRINTS/SPRINT-07.md` -> _Notes_ names `S-09` (Batch H) as the slice editing the script beside this story                                                                                                                      | Matches the map as it stands — `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md:186` still routes N-024 to `S-09` — and contradicts the settled cut plan: `../02-STORIES/CUT-PLAN.md` splits `S-09` (`:169`), giving N-024 to an appended `S-11`, map-order row 4 (`:201`), US016 (provisional), and keeping N-023 on `S-09` (`:204`); the map's write-back is owed at US016's cut (`:218`) | `03-sprint-planning`                                                                                          |
| `./00-STORY-PLAN-US000-TEMPLATE.md:503` and `:707` give the hosts command as `hosts-story-add.sh us###`, and the US007, US006, US008 and US010 plans copy it                                                                          | The script takes the story number alone and exits 1 on `us012` ("Story number must be numeric", `code/src/scripts/development/hosts-story-add.sh:26`); `how-to/workflows/02-worktree-setup/STEPS.md:79` uses the numeric form. This plan uses `012`                                                                                                                                  | `22-implementation-documentation`, which owns the `GAPS.md` write — the template is not this change's to edit |

---

## Sprint Verification Checklist

```bash
# Local — needs no generated tree
bash .github/scripts/shipped-artefacts.sh --help
bash -n .github/scripts/shipped-artefacts.sh
bash code/src/scripts/audits/doc-references.sh --path .github/scripts/shipped-artefacts.sh

# CI — the [3/4] Template Generation job on the pushed us012/ branch runs these
#   bash .github/scripts/shipped-artefacts.sh --self-test "$RUNNER_TEMP/gen-false"
#   bash .github/scripts/shipped-artefacts.sh "$RUNNER_TEMP/gen-false" "$RUNNER_TEMP/gen-true"
```

- [ ] The red run recorded before the green, each by run ID — the red evidenced by the probe's own
      zero-finding line, never by the exit code alone
- [ ] `--self-test` exits 0 with **6 probes**, in CI's `[3/4]` on the pushed branch
- [ ] The `[3/4] Template Generation` job green on every render path the template offers (today:
      `INCLUDE_MOBILE` true and false) — the self-test at `audit-template.yml:225`, reading the false
      tree alone, and the full run at `:228`, reading both
- [ ] The string test recorded: the probe's substring does not match the named-file message
- [ ] The no-negation read recorded as read, over the finding and the closing guidance
- [ ] The parse check, `bash -n` over the script, recorded clean
- [ ] ShellCheck over the script recorded as run or as not run — **never as a `lint.sh` pass**
- [ ] `database/migrate.sh check` and `tests/all.sh --coverage` — **`N/A`**, each with its reason
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] The code-review-graph refreshed **after staging**, per `code/docs/CODE-REVIEW-GRAPH.md`

---

## Definition of Done

- [ ] Check 4 loops `"${SEEDED[@]}"`, inside check 3's `else`, and reports a seeded file that did not
      land with the path, then the seed wording, then a pointer to its `mv .copier/...` line — no `!`
      advice, no computed source path
- [ ] The closing guidance never directs a seed finding to the `copier.yml` allowlist
- [ ] The sixth probe moves the last `SEEDED` entry by index expression, matches a substring running
      from the path into the seed wording, and restores the file before the next probe
- [ ] Shown red, then green, in CI — the probe unchanged between the two commits
- [ ] The header list, too-tight paragraph, `SELF-TEST` paragraph, both exit-code lines, `--help`, the
      check-4 comment and the `SEEDED` comment rewritten; "What it CANNOT check" byte-identical
- [ ] `SEEDED`'s entries unchanged by this story; `.github/workflows/audit-template.yml` unchanged
- [ ] "project-management/src/18-TESTS/AUTOMATED/US012-TEST-STATUS.md" written at `22`, and
      `../18-TESTS/MANUAL/US012-MANUAL-TESTING.md` walked and signed off
- [ ] The map's `S-02` _Register claimed_ row marked retired by `22`; the Slices row confirmed, not
      re-cut; no `GAPS.md` row closed
- [ ] Code workflows `02-tdd-cycle` (shell form) and `07-review` complete; PR raised and promoted via
      `23-pr-and-review`; review record in `../19-REVIEWS/`
- [ ] Status set to the final value across the story, this plan and the sprint plan's row as that
      plan defines it; nothing pushed to ClickUp, the sync being unwired
- [ ] Every gate above run and recorded per `code/docs/GATE-REPORTING.md`; nothing skipped silently
