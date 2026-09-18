# QA Plan — US009 The git hooks arm on purpose at install

| Field         | Value                                                                                                   |
| ------------- | ------------------------------------------------------------------------------------------------------- |
| **Story**     | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true |
| **Date**      | 17/09/2026                                                                                              |
| **Sprint**    | SPRINT-05 — this story is its stretch `Should`, 3 of 11 SP                                              |
| **Wireframe** | N/A — this story ships bash and one JSON manifest read, not a screen                                    |
| **Status**    | Reviewed — all nine gaps resolved into the story, 17/09/2026                                            |

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

---

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
  Threat model TM-01 and Section 3b; assessment §7.1.
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
  which is why nobody has noticed. Threat model TM-03; assessment §7.3.
- **AC-GAP-3** `[RESOLVED] 17/09/2026` · material — **`ST01` asserts a three-line fact in language that reads as
  a repo-wide posture.** `N-019` calls `--ignore-scripts` "a deliberate supply-chain control", the
  FLAGS `Security` row reads _"`--ignore-scripts` preserved on all three `install-frontend.sh`
  branches"_, and the Verification Checks say _"`--ignore-scripts` confirmed present on all three
  `install-frontend.sh` branches in the diff"_. All true, all narrow. Eleven other invocations
  omit it, so a reviewer ticking that box has confirmed three lines of sixteen. The gap is not
  that US009 should fix the other eleven — it should not, they are out of scope — but that the
  criterion must **state its scope** so the tick means what it says. Threat model TM-02;
  assessment §7.2.
- **AC-GAP-4** `[RESOLVED] 17/09/2026` · material — **`ST03` requires the binary to come from `node_modules` and
  no task says how.** Measured 17/09/2026: `command -v lefthook` returns nothing;
  `node_modules/.bin/lefthook` exists. A bare `lefthook install` in a plain bash script — which is
  what `install.sh` is — does not have `node_modules/.bin` on `PATH`, so it either fails
  ("command not found", tripping the hard fail for the wrong reason) or resolves a **host-global**
  lefthook of unknown version against this repository's `lefthook.yml`. The house idiom is
  unambiguous: **23** `pnpm exec` sites across **14** files — `lefthook.yml`, two
  `.claude/hooks/lib/` checks, three workflow files and eight scripts under `code/src/scripts/`. The story's Script Task says "Run
  `lefthook install` resolved from the project's `node_modules`" — the requirement without the
  mechanism. Threat model TM-04; assessment §7.4.
- **AC-GAP-5** `[RESOLVED] 17/09/2026` · material — **the hard fail abandons four later steps, and nothing weighs
  that.** The story puts the step immediately after Phase 1 Step 4 (`install.sh:417-423`) and
  requires `err` plus `exit 2` on failure, matching Steps 3 and 4 (`:413`, `:421`). Both citations
  hold. What the story does not say is what sits **after**: Step 5 environment files (`:425`),
  Step 6 dev secrets (`:446`), Step 7 script permissions (`:498`), Step 8 machine spec (`:517`).
  A transient lefthook problem therefore leaves a tree with dependencies installed but **no
  `.env.*` files, no generated `SECRET_KEY`, no executable bits on any project script**. Steps 3
  and 4 hard-fail on things everything downstream needs; a git hook is not one of those. Moving the
  step to the end of Phase 1 makes hard-fail cheap and costs nothing — `N-019`'s requirement is
  only that it run after dependency installation. Threat model TM-05; assessment §7.5.
- **AC-GAP-6** `[RESOLVED] 17/09/2026` · material — **the automated proof is specified into a job that cannot run
  it.** The story's first QA criterion is that the `[3/4] Template Generation` job generates on
  both answer sets and "the generated `install.sh` carries the step in each" — feasible, that is a
  grep. The second requires "a pre-commit probe asserts that after `install.sh` **completes** in a
  git checkout, `.git/hooks/pre-commit` exists", wired "into the generation job". That job's
  generation step is `uvx copier copy` in a shell loop (`audit-template.yml:151-163` — the story
  cites `:151-161`, two lines short) and never executes the generated `install.sh`. Executing it
  needs docker, uv, pnpm and `sudo tee -a /etc/hosts` against the runner. As written the criterion
  cannot be satisfied where it is placed. Threat model TM-09; assessment §7.9.
- **AC-GAP-7** `[RESOLVED] 17/09/2026` · material — **`install.sh` will write into `.git/hooks/` for the first
  time, over a file another tool also claims, and nothing says so.** `install.sh` touches nothing
  under `.git/` today — its only git references are a prerequisite check at `:371` and a version
  print at `:383`. `lefthook install` overwrites `.git/hooks/pre-commit` unconditionally, with no
  backup. `lefthook.yml:66-69` records the contest explicitly: _"Replaces the raw hook
  `code-review-graph install` appends to `.git/hooks/pre-commit` … If `code-review-graph install`
  is re-run it re-appends its hook — run `lefthook install`."_ So the file has two claimants and
  the story makes `install.sh` a third, silently. Threat model TM-07; assessment §7.7.
- **AC-GAP-8** `[RESOLVED] 17/09/2026` · minor — **`ST03` calls `package.json:22` a pin; it is a range.** The
  specifier is `"lefthook": "^2.1.10"`. `pnpm-lock.yaml:54-56` is what pins `2.1.10`. It matters
  because Step 4 runs `install-frontend.sh --local` → `pnpm install --ignore-scripts` at `:84` —
  **not** `--frozen-lockfile` — so it may resolve a newer 2.x and rewrite the lockfile, and the
  new step then arms the hooks with whatever it just resolved. Threat model TM-08;
  assessment §7.8.
- **AC-GAP-9** `[RESOLVED] 17/09/2026` · minor — **the renumbering task names Phase 1 and the collision is in
  Phase 2.** Measured: `usage()` lists Phase 1 as steps 1–8 at `:47-54` and **Phase 2 as 7 and 8**
  at `:57-58`; the body headers agree (`Phase 2 · Step 7` at `:540`, `Step 8` at `:580`). Phase 1
  and Phase 2 already collide on 7 and 8. Adding a ninth Phase 1 step makes the printed sequence
  read 1–9 then 7–8. The task says "renumber the subsequent Phase 1 step headers and the `usage()`
  step list" and never mentions Phase 2. Either it is renumbered too, or the pre-existing
  collision is left deliberately and recorded. Threat model TM-10; assessment §7.10.

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

| ID    | Given                                                     | When                            | Then                                                                                             |
| ----- | --------------------------------------------------------- | ------------------------------- | ------------------------------------------------------------------------------------------------ |
| HP-01 | A fresh clone with no `.git/hooks/pre-commit`             | `bash install.sh`               | A step after "JavaScript dependencies" runs `lefthook install` and prints its own `ok` line      |
| HP-02 | The same run completing                                   | `.git/hooks/pre-commit` read    | It exists and is **lefthook's** generated hook — not some other tool's, and not a stub           |
| HP-03 | That clone, hooks armed                                   | A throwaway `git commit`        | The `lefthook.yml` pre-commit legs run, observably                                               |
| HP-04 | A clone where the hook already exists from a previous run | `bash install.sh` again         | The step completes, the hook is still lefthook's, and it is not duplicated                       |
| HP-05 | The change applied                                        | `install-frontend.sh` read      | `--ignore-scripts` is present on `:67`, `:84` and `:93`; `package.json`'s `prepare` is unchanged |
| HP-06 | The change applied                                        | `.copier/README.md:441` read    | The sentence describes what the script does, **and the file is unmodified in the diff**          |
| HP-07 | A generated project, both `INCLUDE_MOBILE` poles          | The generated `install.sh` read | It carries the step in each — the assertion the generation job **can** make (AC-GAP-6)           |

### Error states (ES-nn)

| ID    | Given                                                   | When                          | Then                                                                                                      |
| ----- | ------------------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------- |
| ES-01 | A git checkout where `lefthook install` cannot complete | `bash install.sh`             | The failure is reported in the house `err` idiom **naming `lefthook install`**, and the script exits 2    |
| ES-02 | The same                                                | The exit code inspected       | 2, matching the header's declared "install failed" (`:17`) — never swallowed as a warning                 |
| ES-03 | The same                                                | The tree inspected afterwards | **Steps 5–8 did not run**: no `.env.*`, no dev secrets, no executable bits, no machine spec (AC-GAP-5)    |
| ES-04 | `lefthook` absent from `node_modules` and from `PATH`   | The step runs                 | It fails with a message naming the missing binary — **not** a bare "command not found" (AC-GAP-4)         |
| ES-05 | A tree exported without `.git`                          | `bash install.sh`             | The step reports the skip because there is no git repository, the install continues, exit code unaffected |

### Edge cases (EC-nn)

| ID    | Given                                                                              | When                     | Then                                                                                                              |
| ----- | ---------------------------------------------------------------------------------- | ------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| EC-01 | A checkout created by `git worktree add`, where `.git` is a **file**               | `bash install.sh`        | The hooks **arm**. As specified today they do not — `[ -d .git ]` is false and the step skips silently (AC-GAP-2) |
| EC-02 | A host-global `lefthook` of a different major on `PATH`, and one in `node_modules` | The step runs            | The project's own binary is used (AC-GAP-4)                                                                       |
| EC-03 | `.git/hooks/pre-commit` holding a **hand-written** hook                            | `bash install.sh`        | The developer is told it was replaced, rather than losing it silently (AC-GAP-7)                                  |
| EC-04 | A generated project — `git init` run, **no commits, unborn HEAD**                  | `install.sh`'s step runs | `lefthook install` succeeds. Currently an assumption, not a test (TM-11)                                          |
| EC-05 | A repository where `code-review-graph install` last wrote the hook                 | `bash install.sh`        | lefthook reclaims it, per `lefthook.yml:69` — and the reclaim is reported                                         |
| EC-06 | The step run twice in immediate succession                                         | The hook file compared   | Byte-identical; no duplication, no appended second block                                                          |
| EC-07 | `install.sh --spec`, which exits after regenerating the machine spec               | The run completes        | The hook step does **not** run — a flag that short-circuits Phase 1 must not half-arm anything                    |
| EC-08 | `install.sh --help`                                                                | The output read          | The Phase 1 list names the new step, and the printed sequence is contiguous (AC-GAP-9 decides what Phase 2 reads) |

### Permission and access (PA-nn)

**None in the web sense — this story adds no endpoint, no screen and no protected action.** There
is no role boundary and no identifier whose ownership could be verified. The `API`, `Backend`,
`Frontend` and `GDPR` flags are correctly `N/A`.

**The access-control content here is a supply-chain boundary**, and it is the subject of the
story's own Security flag. Two rows belong in this category rather than above:

| ID    | Given                                             | When                                                  | Then                                                                                                                      |
| ----- | ------------------------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| PA-01 | The change applied, `prepare` retained per `ST02` | `gh pr create` is run                                 | `check-lockfiles.sh:147` installs **without** `--ignore-scripts`, `prepare` fires, and the hooks arm. **Unchosen moment** |
| PA-02 | The change applied                                | Any CI workflow runs `pnpm install --frozen-lockfile` | The same, on the runner. Ten such steps across five files                                                                 |

**PA-01 and PA-02 are written as tests that currently demonstrate AC-GAP-1**, not as tests that
pass. They are the proof that the story's user story is unmet by the story's change, and they are
recorded here rather than left to be argued about — per `code/docs/GATE-REPORTING.md`, a gap
nobody can reproduce is a gap nobody fixes.

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
`ASSESSMENT-PLAN-US009-HOOK-ARMING.md` Section 7 are not restated here. Four are QA-visible:

- **The scope of the `--ignore-scripts` assertion** (§7.2, AC-GAP-3) — a tester confirms three
  lines and records that it is three of sixteen. Confirming three and reporting "the supply-chain
  control is in place" is the false green this gate exists to prevent.
- **The guard's shape** (§7.3, AC-GAP-2) — EC-01 is the test. It needs a real worktree, which
  `how-to/workflows/02-worktree-setup/` already tells a developer how to make.
- **Binary provenance** (§7.4, AC-GAP-4) — EC-02 needs a host-global lefthook planted on `PATH`.
  Cheap to stage, and the only way to prove the resolution rather than assume it.
- **Nothing outside `.git/hooks/` is written** (§7.13) — the step's whole blast radius, confirmed
  by diffing the tree before and after.

**One constraint is not QA-visible and must not be tested for.** §7.6 requires the three
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
  a `.git` **file** in two seconds; `[ -d .git ]` against it is the whole test.
- **The generation job can grep, not execute.** `audit-template.yml:151-163` runs `uvx copier copy`
  in a shell loop over `INCLUDE_MOBILE` false and true — deliberately a loop rather than a matrix,
  because the file must contain no GitHub expression syntax (`:148-150`). Adding a grep assertion
  inside that loop is free; adding an `install.sh` execution is a new job with new reasoning
  (AC-GAP-6).
- **`lefthook install` writing to an unborn HEAD is untested and probably fine.** `copier.yml:1025`
  runs `git init --initial-branch=main` gated `when: copy`, so a generated project has `.git` with
  no commits. Prove it rather than assume it — it is one `git init` in `/tmp` away.
- **Record which of the sixteen `pnpm install` invocations carry `--ignore-scripts`**, not just the
  three the story names. The sweep is one `grep -rn 'pnpm install'` and its result is AC-GAP-1's
  and AC-GAP-3's shared evidence. Re-run it at close: if the count has moved, the finding has moved.
- **`.git/hooks/pre-commit` already exists on the author's machine.** Clear it before HP-01, or the
  test proves nothing. Its presence today is the evidence for AC-GAP-1 and a trap for HP-02.
- **No pytest, no coverage figure, no migration check.** The story's Verification Checks mark the
  Python rows `N/A` with reasons; the test record must do the same rather than leave them blank.
- **ShellCheck has no project script.** `lint.sh`'s legs are ruff, markdownlint-cli2, ESLint and
  clippy. Run it by hand over the changed `install.sh` and record it as run or not run — never as
  a `lint.sh` pass (`code/docs/GATE-REPORTING.md`).

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
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` sections, the PA rows written as failing tests, Section 7 and Section 8 rest on
