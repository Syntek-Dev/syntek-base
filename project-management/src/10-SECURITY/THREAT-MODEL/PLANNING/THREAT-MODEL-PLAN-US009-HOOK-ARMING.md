# Threat Model Plan — US009 The git hooks arm on purpose at install

| Field               | Value                                                                                                                          |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Story**           | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true                        |
| **Date**            | 17/09/2026                                                                                                                     |
| **Author**          | Claude Code — `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**                                              |
| **Status**          | Draft                                                                                                                          |
| **Feature surface** | No runtime surface. One new step in `install.sh`, one guard, three read-only assertions over `install-frontend.sh`, two probes |

<!-- STEP 1's GRILLING PASS DID NOT RUN, and that is a deviation rather than an omission.
     <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10 and 11 be written for both SPRINT-05
     members first and the decisions taken afterwards, so this model was derived from the story
     and the tree rather than from an interview. Status is Draft; Section 4a lists what the
     interview must settle, and it now includes a question the story does not currently ask.

     code/docs/GATE-REPORTING.md: a pass that could not run is never reported as a pass that ran. -->

---

## 1. Scope

This model covers **a supply-chain boundary and the moment a git hook is written**, not a
feature. US009 adds no endpoint, no model, no screen and no log line; eleven of its thirteen flags
read `N/A`. It ships bash.

**Two things are modelled, and only one of them is the story's own.** The first is the new step:
what it executes, where it resolves its binary from, what it overwrites, and what it does when it
fails. The second is the surface the story _asserts against_ rather than changes —
`--ignore-scripts`, the `prepare` lifecycle script, and the question of whether the story's own
user story is delivered by the change it specifies. Section 3's first two rows are that second
thing, and they are the substance of this model.

**One live observation frames everything below.** On the machine this model was written on,
`.git/hooks/pre-commit` **exists** and is lefthook's, dated 16/09/2026 — in a repository where
`install.sh` has never installed it and where all three `install-frontend.sh` branches carry
`--ignore-scripts`. Something armed it. Section 3b names what, and the answer is the story's
premise proved rather than assumed.

### Surface under review

- **The new step** — `install.sh`, inserted after Phase 1 Step 4 (`:417-423`), running
  `lefthook install`
- **The guard** — a `.git` test whose exact form the story states as `[ -d .git ]`
- **The asserted surface** — `code/src/scripts/development/install-frontend.sh:67`, `:84`, `:93`
- **The channel the story leaves open** — `package.json:11`,
  `"prepare": "[ -d .git ] && lefthook install || true"`
- **The claim** — `.copier/README.md:441`, which the story makes true without editing it

### Measured state of the surface, 17/09/2026

| Fact                                                     | Reading                                                                            |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `install.sh` Phase 1 Step 4, JavaScript dependencies     | `:417-423`, ending `\|\| { err "pnpm install failed"; exit 2; }` at `:421`         |
| `install.sh` Step 3's matching idiom                     | `:413`, same shape. Both citations in the story hold                               |
| `install.sh` header exit codes (`:17`)                   | `0 = success   1 = requirement missing   2 = install failed`                       |
| `--ignore-scripts` in `install-frontend.sh`              | `:67`, `:84`, `:93` — all three present, exactly as the story asserts              |
| `pnpm install` **without** `--ignore-scripts`, repo-wide | **11 invocations** — 1 local hook + 10 CI steps. See TM-01                         |
| `command -v lefthook`                                    | **Not on `PATH`.** `node_modules/.bin/lefthook` exists                             |
| `package.json:22` lefthook specifier                     | `"^2.1.10"` — a **range**; `pnpm-lock.yaml:54-56` resolves `2.1.10`                |
| `.copier/README.md:441`                                  | "…runs `lefthook install`, which registers the pre-commit hooks" — **false today** |
| `copier.yml:1025`                                        | `git init --initial-branch=main`, gated `when: copy`                               |
| `install-frontend.sh:79-81`                              | The `sudo rm -rf` stray-argument defect — **still live**                           |
| `.git/hooks/pre-commit` on this machine                  | **Present**, lefthook's, 16/09/2026                                                |

### Severity scale

| Level      | Definition                                                                |
| ---------- | ------------------------------------------------------------------------- |
| `CRITICAL` | Exploitable without authentication, or full compromise / credential theft |
| `HIGH`     | Exploitable with low-privilege access; significant data or integrity risk |
| `MEDIUM`   | Exploitable under specific conditions; moderate impact                    |
| `LOW`      | Minor impact; defence-in-depth measure                                    |
| `INFO`     | Observation with no immediate exploitability                              |

Only **CRITICAL** and **HIGH** block sprint planning
(`project-management/docs/SECURITY-GUIDE.md`). **This model produced none of either** — read
Section 4 with Section 3a, never alone.

## 2. Trust boundaries

| ID  | From                     | To                       | Data crossing                                                     |
| --- | ------------------------ | ------------------------ | ----------------------------------------------------------------- |
| TB1 | Operator shell           | `install.sh`             | Flags, cwd, the presence and **shape** of `.git`, tty state       |
| TB2 | `install.sh`             | The `lefthook` binary    | Which binary is resolved, and at what version                     |
| TB3 | The pnpm lifecycle       | `.git/hooks/`            | `prepare`, fired by any `pnpm install` without `--ignore-scripts` |
| TB4 | `install.sh`             | `.git/hooks/pre-commit`  | A file overwrite, unconditional, with no backup                   |
| TB5 | This template            | A generated project      | The rendered `install.sh`, and a `.git` with no commits           |
| TB6 | The npm dependency graph | The host / the CI runner | Whatever a package's install scripts execute when not suppressed  |

## 3. STRIDE threat table

**Status is `Proposed` at planning time.** Re-assessed against shipped code in the
`../IMPLEMENTATION/` counterpart.

| ID    | STRIDE | OWASP      | NIST CSF | TB  | Threat description                                                                                                                                                                                                            | Severity | Status   | Mitigation (proposed control)                                                                                                                                              |
| ----- | ------ | ---------- | -------- | --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | T      | `A03:2025` | `PR.PS`  | TB3 | **The silent-arming channel stays open, so the story does not deliver its own user story.** `prepare` is kept byte-identical by ST02, and **11** `pnpm install` invocations omit `--ignore-scripts`. Section 3b               | MEDIUM   | Proposed | Either `prepare` is removed — the explicit step makes it redundant — or the story states which of the two owners wins and why both are kept. Section 4a Q1                 |
| TM-02 | E      | `A03:2025` | `PR.PS`  | TB6 | **`--ignore-scripts` is three lines in one script, asserted in language that reads as a posture.** The same lockfile installs 11 times without it — on a CI runner holding workflow secrets, and on the developer host        | MEDIUM   | Proposed | ST01 is **narrowed in wording** to the three branches it actually proves, and the wider gap is raised as its own register entry rather than implied to be covered          |
| TM-03 | D      | `A10:2025` | `PR.PS`  | TB1 | **The `.git` guard as written is false in a worktree.** `git worktree add` makes `.git` a **file**, not a directory, so `[ -d .git ]` skips — in every parallel-story checkout this project's own workflow creates            | MEDIUM   | Proposed | The guard tests for a repository, not a directory — `git rev-parse --git-dir` or a test admitting both shapes. `package.json:11` carries the identical defect today        |
| TM-04 | S      | `A03:2025` | `PR.PS`  | TB2 | **`lefthook` is not on `PATH` and the resolution mechanism is unspecified.** A bare `lefthook install` either fails or silently runs a **host-global** binary of unknown version against this repo's `lefthook.yml`           | MEDIUM   | Proposed | `pnpm exec lefthook install` — the house idiom at 23 sites. ST03 states the requirement; no task names the mechanism, and the two are not the same thing                   |
| TM-05 | D      | `A10:2025` | `RC.RP`  | TB1 | **A hard fail at the new step abandons four later steps.** Inserted after Step 4 and exiting 2, it leaves a tree with dependencies but **no `.env.*`, no generated dev secrets, no executable bits, no machine spec**         | MEDIUM   | Proposed | Either the step moves to the end of Phase 1, or the hard fail is justified against what it abandons. **This is the story's own open question** — Section 4a Q2             |
| TM-06 | E      | `A01:2025` | `PR.PS`  | TB1 | **The new step runs immediately downstream of a live root-privileged deletion with unvalidated arguments.** `install.sh:421` → `install-frontend.sh:79-81`, `sudo rm -rf "$PROJECT_ROOT/node_modules" log Removed.`           | MEDIUM   | Proposed | The story says its assertions "neither depend on that defect nor mask it". That needs a **criterion**, not a sentence — ST01 reads `:84`, inside the broken block          |
| TM-07 | T      | `A08:2025` | `PR.DS`  | TB4 | **`lefthook install` overwrites `.git/hooks/pre-commit` unconditionally.** `install.sh` touches nothing under `.git/` today; `lefthook.yml:66-69` records `code-review-graph install` appending its own hook there            | LOW      | Proposed | The step reports that it wrote the hook and what it replaced, rather than writing in silence. Developer-local, but it is the first write `install.sh` makes into `.git/`   |
| TM-08 | T      | `A03:2025` | `PR.PS`  | TB2 | **The "pinned devDependency" is a caret range, and Step 4 can move it.** `package.json:22` is `^2.1.10`; `install-frontend.sh:84` is `pnpm install --ignore-scripts` — **not** `--frozen-lockfile` — so it may resolve higher | LOW      | Proposed | ST03's wording is corrected: the lockfile pins, the manifest ranges. Whether Step 4 should be frozen is a separate question this story does not own                        |
| TM-09 | D      | `A10:2025` | `DE.CM`  | TB5 | **The automated proof cannot run where the story puts it.** The `[3/4] Template Generation` job runs `uvx copier copy` only (`:151-163`); it never executes the generated `install.sh`, which needs docker, uv and sudo       | MEDIUM   | Proposed | The generation job asserts the **step is present** by grep; executing `install.sh` needs its own job with its own reasoning, or the criterion is honest about being manual |
| TM-10 | T      | `A02:2025` | `PR.PS`  | TB1 | **The renumbering walks into a numbering defect already present.** `usage()` lists Phase 1 as steps 1–8 (`:47-54`) and Phase 2 as **7 and 8** (`:57-58`) — a collision the body's headers share (`:540`, `:580`)              | LOW      | Proposed | The renumbering task names Phase 2 as well as Phase 1, or explicitly leaves the pre-existing collision and says so                                                         |
| TM-11 | S      | `A03:2025` | `PR.PS`  | TB5 | **A generated project's `.git` has no commits.** `copier.yml:1025` runs `git init` gated to `copy`, so `HEAD` is unborn. Whether `lefthook install` succeeds against that is assumed, not tested                              | LOW      | Proposed | The generation probe covers it, or the assumption is written down as an assumption                                                                                         |
| TM-12 | R      | `A09:2025` | `DE.AE`  | TB4 | **Nothing records whether the hooks were armed for a given commit.** The step prints `ok` to a terminal and persists nothing; a commit made on an unarmed checkout is indistinguishable afterwards                            | INFO     | Proposed | Accepted residual — `code/docs/security/AUDIT-TRAIL.md` covers the application, not a setup script. Named rather than left to be assumed                                   |

## 3b. TM-01 in full — the moment nobody chose, named

The story's User Story asks for hooks that are _"either armed and visible from the first commit,
or absent and known — never arming themselves silently at a moment I did not choose."_ The story
never names the moment. It is nameable, and naming it changes the acceptance criteria.

**The channel.** `package.json:11` is `"prepare": "[ -d .git ] && lefthook install || true"`.
npm and pnpm run `prepare` after any install that is not told to skip lifecycle scripts. ST02
requires this line to be **byte-identical after the change**.

**The suppressors, and what they cover.** `--ignore-scripts` appears on exactly three lines —
`install-frontend.sh:67`, `:84`, `:93` — plus two more in the mobile-only
`code/src/scripts/mobile/install.sh`. Those are the invocations US009 asserts on.

**The eleven that are not suppressed**, measured 17/09/2026 by a repo-wide sweep:

| Where                                      | Count | When it fires                                                  |
| ------------------------------------------ | ----- | -------------------------------------------------------------- |
| `.claude/hooks/lib/check-lockfiles.sh:147` | 1     | On `gh pr create` / `gh pr new`, gated by `pre-pr-check.sh:35` |
| `.github/workflows/*.yml`                  | 10    | On push and pull request, across **five** workflow files       |

`check-lockfiles.sh:147` is `lpnpm_o=$(cd "$PROJECT_ROOT" && pnpm install --frozen-lockfile …)`,
guarded at `:145` on `node_modules` already existing. `--frozen-lockfile` freezes **resolution**;
it does not suppress lifecycle scripts. So raising a pull request runs `prepare`, which runs
`lefthook install`, which writes `.git/hooks/pre-commit`.

**This is not theoretical, and the evidence is in the working tree.** `.git/hooks/pre-commit`
exists on this machine, is lefthook's generated hook, and is dated 16/09/2026 — in a repository
whose `install.sh` has never installed it. It was armed by one of the eleven.

**The consequence for the story.** After US009 ships exactly as written, all eleven still fire.
The hooks will arm at the explicit step **and** continue to arm at PR time and in CI. The story
closes the _absence_ it set out to close — `.copier/README.md:441` becomes true — but it does not
close the _silence_, which is the half its User Story leads with.

**Two readings, and the story has not chosen between them.** Either `prepare` is now redundant and
should go, in which case the change is bigger than the story prices; or it is a deliberate belt
and braces, in which case ST06's observation that `|| true` "is correct for a lifecycle script and
wrong for an explicit step" is the _start_ of an argument the story never finishes — two owners of
one outcome, with different failure semantics and no stated precedence. Section 4a Q1.

## 3a. Design-state severity and promotion triggers

**Every severity above is a present-state reading of a template repository with a single
developer and no live deployment.** Read the table with this one.

| Threat       | Present state | Design state | Promotes when                                                                             |
| ------------ | ------------- | ------------ | ----------------------------------------------------------------------------------------- |
| TM-02        | MEDIUM        | **HIGH**     | The first compromised package enters the graph — 11 unsuppressed install-time hooks       |
| TM-01        | MEDIUM        | **HIGH**     | A second contributor joins, and "were your hooks on?" stops being answerable by memory    |
| TM-03        | MEDIUM        | **HIGH**     | The next worktree story — the guard is false in every one this project's workflow creates |
| TM-04        | MEDIUM        | **HIGH**     | A host-global `lefthook` of a different major exists on any contributor's machine         |
| TM-06        | MEDIUM        | **HIGH**     | Anything named `log` or `Removed.` appears at the project root                            |
| TM-07, TM-08 | LOW           | **MEDIUM**   | A developer keeps a hand-written hook, or lefthook ships a behaviour change in 2.x        |

## 4. Blocking findings & escalations

**None.** No `CRITICAL` and no `HIGH` finding was raised, so no record is written to
`../../VULNERABILITIES/PLANNING/` and sprint planning is not gated by this model.

That zero is a measured outcome with its reason: twelve threats were raised across five STRIDE
categories and every one resolves to `MEDIUM` or below **because this repository has one
developer, no deployment, and no known compromised dependency**. Section 3a names the event that
promotes each, and **five promote to `HIGH`**.

**Two things that zero does not mean.** It does not mean TM-01 is minor — it is the finding that
says the story does not do what its own user story promises, which is a scope question rather than
a severity one, and `11-qa-checks` carries it as a blocking acceptance-criteria gap. And it does
not mean TM-02 is closed — it is **pre-existing and outside US009's scope**, and it is raised here
rather than escalated precisely so that it is not silently absorbed into a story that only
asserts three lines of it.

Per `code/docs/GATE-REPORTING.md` this is never reported as "the security gate passed".

## 4a. What the grilling pass must settle

<!-- SETTLED 17/09/2026 at `15-decisions`. All three were answered in the grilling pass this
     section asked for; the questions are kept as written, each with its answer beneath, because a
     question deleted once answered leaves the next reader unable to see what was weighed.
     TM-02's count at Section 3's table read 13 until 17/09/2026 and is corrected to 11 there — a
     leftover from the draft that Sections 3a and 5 already carried correctly. -->

**All three are settled.** Q1 by
`project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` —
`prepare` is removed, `install.sh` becomes the sole arming path, and an announcing `postinstall`
closes the silent-absence cost; the story is re-estimated 3 to 5 SP. Q2 as an acceptance
criterion — the step moves to the **end of Phase 1**, keeping the hard fail, which then costs
nothing because nothing follows it. Q3 as `ST07` — the guard is `git rev-parse --git-dir`.

Step 1's interview did not run at the time. Three questions were open, and the first was not
asked anywhere in the story:

1. **Does `package.json:11`'s `prepare` script survive this story?** ST02 requires it
   byte-identical. Section 3b shows that keeping it leaves the silent-arming channel open through
   eleven unsuppressed invocations, so the story's stated goal is not met by the story's stated
   change. Removing it is a bigger change than the 3 SP estimate assumes. **This is the question
   the whole story turns on, and it is not in the story.**
2. **What does the step do when `lefthook install` fails?** The story states guard-on-`.git`,
   hard-fail otherwise, and names itself as the criterion to change if `15-decisions` disagrees.
   The security reading TM-05 adds: fail-closed is correct when the thing being closed is a
   security boundary, and an unarmed quality gate is not one — while the cost of closing is four
   abandoned setup steps. Moving the step to the end of Phase 1 makes hard-fail cheap.
3. **What shape is the `.git` guard?** TM-03 — `[ -d .git ]` is false in a worktree, and this
   project's own parallel-story workflow creates worktrees.

## 4b. Developer constraints carried forward

Checkable by reading the shipped script. These become US009 acceptance criteria; the assessment
numbers them.

1. The guard tests for a **repository**, not for a directory — a worktree's `.git` is a file
2. The binary is resolved from the project's own `node_modules`, by the house `pnpm exec` idiom,
   and never from `PATH`
3. The step introduces no new network fetch, no new credential read, and no write outside
   `.git/hooks/`
4. The step runs **after** dependency installation, so it can never arm a hook referencing a
   toolchain not yet present
5. `--ignore-scripts` remains on `install-frontend.sh:67`, `:84` and `:93` — asserted, and the
   assertion's **scope is stated** so it is not read as a repo-wide claim
6. The `.git` guard does not become a general try/ignore that would hide a real failure
7. The step reports what it wrote into `.git/hooks/`, rather than overwriting in silence
8. Whatever precedence is settled at Q1 between the explicit step and `prepare` is **written
   down**, not left to be inferred from two surviving mechanisms

## 5. Out of scope

- **The unsuppressed `pnpm install` invocations** (TM-02) — pre-existing, eleven of them, and
  not this story's to fix. Raised here and routed, never absorbed
- **`install-frontend.sh:79-81`'s `sudo rm -rf`** — the `GAPS.md` row of 11/09/2026 owns it. This
  story reads that file and must not mask it (TM-06)
- **The Bun swap** — `MAP-BUN-TOPOLOGY.md` puts `install.sh` and four lefthook legs in its
  surface; that map is 29 open / 21 blocking and cannot produce a story
- **`copier.yml`'s `--trust` execution surface** — untouched by this story
- **Whether Step 4 should use `--frozen-lockfile`** (TM-08) — a dependency-management question,
  not a hook-arming one

---

## Cross-references

- `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US000-TEMPLATE.md` — the post-implementation review that re-assesses this model
- `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` — the posture assessment that consumes this model
- `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — where blocking findings escalate; none from this model
- `project-management/src/02-STORIES/US009.md` — the story being modelled
- `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` — `S-11` and node `N-019`, where the hook lifecycle was settled
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 (2025) / NIST CSF 2.0 reference
- `project-management/workflows/10-security-checks/` — the workflow that produces this model
- `code/docs/SECURITY.md` — the code-side enforcement these controls specify
- `code/docs/GATE-REPORTING.md` — why Section 4's absence, and the header's missing grilling pass, are stated rather than left implied
