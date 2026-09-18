# STORY-PLAN-US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 18/09/2026                         |
| Branch | `us009/hook-arming`                |
| Sprint | SPRINT-05 · Wave 1 · build order 2 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

<!-- BORN WITH ITS PREFIX, 18/09/2026. The number `09-` was reserved for this story on 17/09/2026,
     recorded in `../02-STORIES/US009.md` (its Dependencies section, "This story builds ninth, at a
     `09-` prefix reserved in project-management/src/17-STORY-PLANS/ and not yet written") and as a
     no-file row in `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Story Plans — the code master_.
     The prefix is the story's position in the settled build order across the WHOLE backlog —
     US007, US001, US002, US003, US004, US005, US006, US008, US009 — not its sprint and not a
     per-sprint counter, so US009 is ninth, second in SPRINT-05 behind US008. It is RENUMBERED
     whenever build order changes, which is the OPPOSITE of the sibling rule for the sprint plans:
     a sprint plan carries two numbers and a mismatch between them is information, while a story
     plan carries one, so its prefix must track build order or it says nothing. `./CLAUDE.md` owns
     the rule. Re-derived 18/09/2026 against the run on disk, contiguous `00-` to `08-` after
     US008's plan landed earlier the same day, and confirmed still current. The descriptor
     `HOOK-ARMING` matches the story's QA plan, its threat model and its assessment, as every
     existing pair does. Build order 2 is second of {US008, US009}, the order
     `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Build order_ settled on 17/09/2026 on the
     MoSCoW tiering rule in `../../docs/planning/SPRINTS.md` (`:47-55`).
     `../../docs/planning/CADENCE.md` carries the one-story-at-a-time rule that
     `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` cites for US008-first; it carries no
     `Must`-before-`Should` rule, and an earlier draft of this comment attributed the tiering
     to it. -->

Implements `../15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` (`package.json`'s
`prepare` script is **removed** so the root `install.sh` becomes the only thing in this repository
that writes `.git/hooks/`, and the silent-absence cost that creates is closed by a `postinstall`
that announces and arms nothing; its Option D — adding `--ignore-scripts` to the other eleven
invocations — is declined and stays out of scope). No other ADR binds this story: `N-019` was
settled on `../01-FEATURE-MAPS/MAP-GATE-PARITY.md` on 27/08/2026, and the slice split that produced
`S-11` is a charting act rather than an architecture decision.

---

## Problem Statement

**A shipped setup instruction describes behaviour that does not exist, and the behaviour it
describes is happening anyway — at a moment nobody chose.**

Two halves, and the story is only worth 5 SP because they are one change:

1. **The absence.** `.copier/README.md:442` tells a reader that `bash install.sh` "runs
   `lefthook install`, which registers the pre-commit hooks". The root `install.sh` writes nothing
   under `.git/` — measured 18/09/2026, its only git references are a prerequisite check at `:371`
   and a version print at `:383`. `how-to/src/CONTRIBUTING.md:155` makes the same claim in four
   words: "Hooks are installed by `bash install.sh`." Both are false today.
2. **The silence.** `package.json:11` is
   `"prepare": "[ -d .git ] && lefthook install || true"`, and npm and pnpm run `prepare` after any
   install not told to skip lifecycle scripts. **Sixteen executable `pnpm install` invocations exist
   in this repository; five carry `--ignore-scripts` and eleven do not** — re-measured 18/09/2026 at
   HEAD `f045aac`, unchanged from the 17/09/2026 sweep the story, the ADR and the QA plan all rest
   on. So raising a pull request arms the hooks, and so does every CI run.

**The evidence is in this working tree, not in an argument.** `.git/hooks/pre-commit` exists on this
machine and is lefthook's generated hook, in a repository whose `install.sh` has never written a
byte under `.git/`. Something armed it, and nothing recorded when.

**What makes this a story rather than a one-line fix** is that closing the absence without closing
the silence ships a change whose own User Story is still false afterwards. That is
`QA-PLAN-US009-HOOK-ARMING.md` AC-GAP-1, the largest finding in either SPRINT-05 member, and
`ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` is the decision that answers it: one
arming path, chosen and reported, with a `postinstall` notice for the contributor who never runs
`install.sh`.

**What this story is not.** It does not fix the eleven unsuppressed invocations (threat model
TM-02 — **and the register row that is supposed to hold them does not exist yet**; see
_Deferred Items_), it does not fix `install-frontend.sh:79-81`'s live `sudo rm -rf`
defect (the `GAPS.md` row of 11/09/2026), and it does not touch the Bun swap. Each is named in
_Dependencies_ so a later reader does not re-merge them into this one.

---

## Reference Documents (code/docs gate map)

| Guide                                       | Why it binds this story                                                                                                                                                                                                                                                                                                 |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/GATE-REPORTING.md`               | **The single most load-bearing guide here.** ShellCheck has no project script, the Python gates are all `N/A`, and both facts are reported as readings, not passes                                                                                                                                                      |
| `code/docs/FORWARD-VOICE.md`                | Why every path this story creates is written in double quotes below and never in backticks — the citation gate reads a backticked token as a path that must resolve                                                                                                                                                     |
| `code/docs/DOCUMENTATION-PAIRING.md`        | The new script earns a row in `code/src/scripts/development/CONTEXT.md`; the folder's `CLAUDE.md` is checked for a rule that must move with it                                                                                                                                                                          |
| `code/docs/DOCUMENTATION-LENGTH.md`         | `code/src/scripts/development/CONTEXT.md` gains a row and a tree line; the 300-line limit and the 270 ratchet are measured at P0, not assumed                                                                                                                                                                           |
| `code/docs/security/AUDIT-TRAIL.md`         | Named to record that it does **not** apply — TM-12's "nothing records whether the hooks were armed" is an accepted residual, and that guide covers the application                                                                                                                                                      |
| `project-management/docs/SECURITY-GUIDE.md` | STRIDE / OWASP 2025 / NIST CSF 2.0, and the rule that only CRITICAL and HIGH gate sprint planning. This model produced neither                                                                                                                                                                                          |
| `project-management/docs/QA-GUIDE.md`       | The manual walk-through shape the three unautomatable scenarios take                                                                                                                                                                                                                                                    |
| `how-to/docs/GIT-WORKTREES.md`              | The loopback rule (`:61-64`, final octet equals the story number), and that this project creates worktrees as standard. **It does not say `.git` is a file in a linked worktree** — `:214` reads "All worktrees share the same `.git` directory". The guard's justification is git's measured behaviour, not this guide |
| `code/src/scripts/CLAUDE.md`                | **The binding rule for the new script, and the one `code/src/scripts/development/CLAUDE.md` does not carry**: `:29-30`'s Definition of done requires the common `--output` / `--quiet` / `--help` conventions. All three siblings comply                                                                                |
| `how-to/workflows/02-worktree-setup/`       | The procedure that creates the checkouts ST07 exists for                                                                                                                                                                                                                                                                |
| `code/docs/CODING-PRINCIPLES.md`            | Applies to the bash this story ships — function length, error handling, the guard-clause form                                                                                                                                                                                                                           |

**Four guides are deliberately absent, and their absence is the reading.** `code/docs/DATABASE.md`,
`code/docs/API-DESIGN.md`, `code/docs/ACCESSIBILITY.md` and `code/docs/DESIGN-TOKENS.md` bind
nothing here: this story ships bash and one JSON manifest edit, and its `DB`, `API`, `Frontend` and
`Backend` flags all read `N/A`. `code/docs/TESTING.md`'s coverage floors do not apply either —
there is no Python in the diff and therefore no coverage figure to regress. Stating that is
`code/docs/GATE-REPORTING.md`'s rule, not politeness.

---

## Architecture Decision

**One arming path, and the script that walks it is its own file.**

The ADR settles _that_ `install.sh` becomes the sole arming path. It does not settle _where the
code lives_, and this plan does, because the story's own automated criterion cannot be met
otherwise.

**The step is extracted into "code/src/scripts/development/install-hooks.sh", called by the root
`install.sh`.** Settled with <%DEVELOPER_NAME%> on 18/09/2026, against two rejected alternatives:

| Option                                                | Why not                                                                                                                                                                                                                    |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Inline in `install.sh`, probe by running `install.sh` | The probe cannot run. `install.sh` needs docker, uv, pnpm and `sudo tee -a /etc/hosts`, and Step 4 shells to a script that runs `sudo rm -rf` from the project root (AC-GAP-6)                                             |
| Inline in `install.sh`, probe manually only           | Converts the story's two automated criteria into a walk-through, which is the criterion being weakened to fit the implementation rather than the other way round                                                           |
| **Extract to "install-hooks.sh", probe it directly**  | **Chosen.** The arming logic becomes independently executable in CI with no docker, no sudo and no secrets. **Not against a bare `git init`** — see the fixture below, which is the correction that makes this option real |

This is the same shape `.claude/CLAUDE.md` Section 6 already requires of every dev operation — the
work lives in `code/src/scripts/**/*.sh` and the caller invokes it — and it puts the new file in the
`install-*.sh` family that `code/src/scripts/development/CONTEXT.md:20-23` already documents.

**The fixture is part of the decision, not an implementation detail.** Measured 18/09/2026, in a
temporary directory with this repository's pinned lefthook 2.1.10:

```text
$ git init -q --initial-branch=main .  &&  lefthook install
Config not found, creating...
Added config:/tmp/.../lefthook.yml
sync hooks: done
$ ls .git/hooks/pre-commit   ->   No such file or directory
```

**A bare `git init` proves nothing, and would have failed three ways.** It carries no
`lefthook.yml` defining a `pre-commit` job, so lefthook installs `prepare-commit-msg` alone and the
file every happy-path scenario asserts on never appears; it **writes a `lefthook.yml` into the
tree**, which is a write outside `.git/hooks/` and a breach of §7.13; and `pnpm exec` cannot resolve
the binary outside the workspace (`ERR_PNPM_RECURSIVE_EXEC_NO_PACKAGE`). **The probe therefore runs
against a checkout of this repository** — its own `lefthook.yml`, its own `package.json`, and an
installed `node_modules` — with a scratch git directory. P4 specifies it.

**Three consequences are stated rather than discovered later:**

1. **It is a scope addition beyond the story's task list**, which names only `install.sh`,
   `package.json` and the probes. It is taken because the alternative is an unrunnable criterion.
2. **It carries a CI cost the story never priced** — a workflow that sets up node and pnpm, which
   `.github/workflows/audit-template.yml` does not. P4 names the file and the steps.
3. **The estimate does not move.** US009 stays at **5 SP as a stated wide 5** — see _Key Decisions_.

**`code/src/scripts/development/CONTEXT.md:6` is NOT edited, and an earlier draft of this plan was
wrong to say it was.** That line reads "the three `install-*.sh` scripts run on the host, because
what they install is **the host's own toolchain**: `uv` for Python, `pnpm` for the repo JS tooling,
and a signature-verified binary for the static-analysis engine". The three counts **toolchain
installers**, not glob members — there are already four files matching `install-*.sh`, the
forwarder among them — and "install-hooks.sh" installs no toolchain. Changing the numeral would
leave "four" standing in front of an enumeration of three. Only the tree block (`:20-23`) and the
script table (`:46-49`) move.

---

## Approach

### Phase plan — six phases, and two of them are independent of each other

| Phase | Deliverable                                                                                                                                                                                                  | Blocked by          |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- |
| P0    | The baselines, captured **before any edit** — the citation figure by identity, the 16/5/11 sweep re-run, ShellCheck probed and recorded, the length figures, and `.git/hooks/pre-commit` cleared             | The branch existing |
| P1    | "code/src/scripts/development/install-hooks.sh" — the guard, the resolved binary, the third-claimant report, the exit codes — plus its `CONTEXT.md` row, tree line and the stale "three" at `:6`             | P0                  |
| P2    | The root `install.sh` — the Phase 1 Step 9 section calling P1's script, and the numbering settled across `usage()` and both Phase 2 body headers                                                             | P1                  |
| P3    | `package.json` — `prepare` removed, `postinstall` added with its three silence clauses                                                                                                                       | P0                  |
| P4    | The probes and their new workflow — the three fixtures, the pre-commit probe against P1's script, the worktree and unborn-HEAD cases, the `postinstall` probe, PA-01/PA-02, and the four manifest assertions | P1, P2, P3          |
| P5    | The documentation surface — two claims re-read and **not** edited, four enumerations edited, and two files the story names that turn out to enumerate nothing                                                | P2, P3              |
| —     | The test record and the register reconciliation — **`22-implementation-documentation`'s**, not this story's to write                                                                                         | P1 to P5            |

**P3 is independent of P1 and P2, and that is deliberate.** The manifest edit shares no file with
the script work and can land first or last. Keeping it uncoupled means a failure in the
`postinstall`'s silence clauses localises to the manifest rather than to the arming path — the same
reasoning `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` applies to its own P4.

**P1 precedes P2, and the order is forced by the proof.** The story's automated criterion is that a
probe asserts `.git/hooks/pre-commit` exists and is lefthook's after the arming code completes. That
probe runs the extracted script, so the script must exist before the caller is wired to it —
otherwise the only way to run the assertion is to run `install.sh`, which is the thing AC-GAP-6
found cannot be done in CI.

**P5 waits on P2 and on P3, and an earlier draft justified the first edge wrongly.** Neither
enumeration prints a step number — `how-to/workflows/01-first-time-setup/STEPS.md:46-53` is six
unnumbered bullets and `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:69-71` is a prose sentence — so
the numbering is irrelevant to both. **The real edge is that the step must exist before it can be
described.** The P3 edge is new: `.copier/README.md:1085` is a documentation consequence of the
manifest edit, and P5 is the documentation phase.

**Every phase is testable on its own:** P0 by the recorded figures and their states; P1 by running
the extracted script against a scratch `git init` and reading `.git/hooks/pre-commit`; P2 by
`bash install.sh --help` and a diff of the three numbered sites; P3 by `pnpm install` in a scratch
clone with and without an armed hook, with and without `CI` set; P4 by the probes themselves in CI
on both answer sets; P5 by re-reading each cited line against the changed scripts.

### P0 — The baselines, and the one that is a trap

**`.git/hooks/pre-commit` exists on this machine right now and is lefthook's.** It is the evidence
for AC-GAP-1 and it is a trap for the happy-path proof: a probe that finds the hook present proves
nothing if the hook was already there.

**So P0 records it and does not delete it, which corrects an earlier draft of this plan.** Clearing
the hook in this working tree disarms lefthook — and lefthook is the sole runner of `sync-trees`,
`docs-pairing`, `docs-length`, `template-integrity`, `markdownlint`, `prettier` and `eslint`. Every
commit on `us009/hook-arming` from P0 onward would bypass all seven, silently, for the life of the
branch, and this plan forbids running `install.sh` here to re-arm. **The clearing is a probe-time
act performed in the scratch fixture**, where an absent hook is the starting state by construction.
The working tree's hook is recorded as evidence and left armed; if it is ever cleared by accident,
`pnpm exec lefthook install` puts it back.

| Baseline                                  | How it is taken                                                                                                            |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Citation gate, whole tree, by identity    | `bash code/src/scripts/audits/doc-references.sh` before the first edit, recorded with HEAD, detector hash, count and class |
| Citation gate, scoped                     | `--path` against each file this story edits, exit 0 expected                                                               |
| The `pnpm install` sweep                  | Re-run the 16 / 5 / 11 split. **If the count has moved, the finding has moved** — the QA plan's own instruction            |
| ShellCheck                                | Probed with `command -v shellcheck` and recorded. **Measured 18/09/2026: present, version 0.11.0**                         |
| `code/src/scripts/development/CONTEXT.md` | Line count against the 300 limit and the 270 ratchet, before it gains a row                                                |
| `.git/hooks/pre-commit`                   | Its presence, its owner and its date recorded. **Not removed from this working tree** — see below                          |

### P1 — "code/src/scripts/development/install-hooks.sh"

The whole of the arming logic, in one file that needs no docker, no sudo and no secrets.

| Requirement                      | Shape                                                                                                                                                                                                       | Criterion           |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| The guard                        | `git rev-parse --git-dir`, never `[ -d .git ]` — a `git worktree add` checkout has `.git` as a **file**, and this project creates such checkouts                                                            | ST07, §7.3          |
| On no repository                 | `warn` that hook installation was skipped because there is no git repository, and return 0 — the install continues, the exit code is unaffected                                                             | ST07, §7.14         |
| The binary                       | `pnpm exec lefthook install` — the house idiom — **23 occurrences across 14 files, of which 20 across 13 are executable invocations** (three are comments), re-measured 18/09/2026. Never a bare `lefthook` | ST03, §7.4          |
| On failure of `lefthook install` | `err` naming `lefthook install`, then `exit 2` — see the exit-code note below                                                                                                                               | ST03, §7.5          |
| On the binary being **absent**   | A distinct failure naming the **missing binary**, never a bare `command not found` from `pnpm exec`. ES-04, and a different state from the row above                                                        | AC-GAP-4            |
| Arguments                        | A header comment block, a `usage()`, `--help`/`-h`, and a `die` on an unknown option — `code/src/scripts/CLAUDE.md:29-30`, which all three siblings honour                                                  | `scripts/CLAUDE.md` |
| Output helpers                   | The script **defines its own** `bold` / `log` / `ok` / `warn` / `err`, of the same shape as the caller's. They cannot be inherited — see below                                                              | —                   |
| The third-claimant report        | The step states it wrote `.git/hooks/pre-commit` and what it replaced, rather than overwriting in silence                                                                                                   | §7.7, AC-GAP-7      |
| The blast radius                 | No network fetch, no credential read, no write outside `.git/hooks/`                                                                                                                                        | ST05, §7.13         |

**The helpers cannot be inherited, and an earlier draft of this plan said they could.**
`install.sh` defines seven helpers at `:27-34` — `bold`, `log`, `ok`, `warn`, `err`, `die`,
`section` — and **does not export any of them**, so a script invoked as a child process cannot see
them. `install-backend.sh:26-28` defines its own three (`bold`, `log`, `die`) and carries neither
`ok` nor `err`, both of which this script needs. It therefore defines the five it uses, matching the
caller's shape so the combined output reads as one script.

**The exit code is `2`, and it follows the caller rather than its siblings — deliberately.**
`install.sh:17` declares `1 = requirement missing`, `2 = install failed`; but
`install-backend.sh:19` and `install-frontend.sh:20` both declare `1 = command failed`,
`2 = script error`, under which a lefthook failure would be `1`. **The caller's contract wins**,
because the story's criterion is that the failure exits 2 matching `install.sh`'s header, and
because this script exists to be a step of that script. **Its header says so explicitly**, or the
next reader reconciles two contracts and picks the other one.

**The third-claimant report is a sentence with a measured citation behind it.** `lefthook.yml:73-76`
records that `code-review-graph install` appends a raw hook to `.git/hooks/pre-commit` which
`lefthook install` replaces, and that re-running it re-appends. `install.sh` becomes the third
writer. **That citation has moved and the story's `:66-69` is not wrong** — see _Measured
divergences_.

**Two ordering facts inside P1, because P1 is one commit and the order within it is
load-bearing.** The `CONTEXT.md` tree row is written **before** the new script is staged: the
`sync-trees` pre-commit leg (`lefthook.yml:89-91`) otherwise inserts a `TODO:` row and **fails the
commit**. And the file is committed **executable** — every one of the fourteen `*.sh` files in
`code/src/scripts/development/` is tracked at mode `100755`, **no gate catches a `100644` script**,
and `install.sh:510-511` chmods only at runtime, which masks the defect on a machine that has run
the installer and leaves it broken on a fresh clone that has not.

### P2 — The root `install.sh`, and the numbering

**The section is the last step of Phase 1** — specifically **between `:522` and `:524`**, after the
machine-spec step's `ok` line and **before `:524`'s `# Phase 2 (--full only)` banner**. That
boundary is the point: `:525` opens `if [[ "$FULL" == "false" ]]; then … exit 0; fi`, so a step
placed below it is never reached by a plain `bash install.sh` — the invocation every Gherkin
scenario uses. "After `:517`" is too loose to build from, and an earlier draft of this plan said
only that. **The call form is `bash "$PROJECT_ROOT/code/src/scripts/development/install-hooks.sh"`**,
matching `:421` and `:584`, so it does not depend on the executable bit. Not after the
JavaScript dependencies step at `:417-423`, which was the original placement: a hard fail there
abandons Step 5 environment files (`:425`), Step 6 dev secrets (`:446`), Step 7 script permissions
(`:498`) and Step 8 machine spec (`:517`), leaving a tree with dependencies installed, no `.env.*`,
no generated `SECRET_KEY` and no executable bits. **At the end of Phase 1 the hard fail costs
nothing**, because nothing follows it — which is what makes keeping it free (AC-GAP-5, §7.5, and
the threat model's Section 4a Q2, settled).

**The numbering, and the arithmetic the recorded decision has to be read with:**

| Site                                     | Today                                          | After                                                                                                                   |
| ---------------------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `install.sh:47-54` — `usage()` Phase 1   | Steps 1–8                                      | Steps 1–**9**, the new step last                                                                                        |
| `install.sh:57-58` — `usage()` Phase 2   | Steps **7 and 8** — a live collision           | Steps **10 and 11**                                                                                                     |
| `install.sh:540` — body header           | `Phase 2 · Step 7`                             | `Phase 2 · Step 10`                                                                                                     |
| `install.sh:580` — body header           | `Phase 2 · Step 8`                             | `Phase 2 · Step 11`                                                                                                     |
| `install.sh`, a **new** body comment     | —                                              | `# ── Phase 1 · Step 9 — Git hooks ──`, matching `:222`, `:361`, `:390`, `:408`, `:417`, `:425`, `:446`, `:498`, `:517` |
| `install.sh:3-7` — the file's own header | Enumerates what the script does; names no hook | Gains the hook clause — the same class as the two enumerations P5 edits                                                 |

**Nothing in Phase 1 is renumbered.** Because the step goes last, Steps 1–8 keep their numbers and
the new one is simply 9 — the printed Phase 1 sequence is contiguous without touching a single
existing line. The only renumbering is Phase 2's, and it exists because `usage()` already prints
Phase 2 as steps 7 and 8, colliding with Phase 1's own 7 and 8, with the body headers agreeing
(`:540`, `:580`). Measured 18/09/2026, unchanged.

**The decision recorded on 18/09/2026 was "renumber Phase 2 to 9 and 10", and 9 is unavailable.**
Phase 1 ends at 9 after this story, so Phase 2 starting at 9 reproduces the collision the renumber
exists to remove. The decision's substance — _Phase 2 continues the sequence rather than restarting
it, and the collision is not left recorded_ — is what this plan implements, and continuing a
sequence that now ends at 9 gives **10 and 11**. **Flagged rather than silently applied**: if
<%DEVELOPER_NAME%> intended the literal 9 and 10, the only way to have it is to leave the new step
unnumbered in the printed list, which contradicts the story's own task to add it to that list.

**The body already uses a sub-letter form for Step 1** — `Phase 1 · Step 1a` at `:222` and
`Step 1b` at `:361`, both covered by the single `usage()` entry "1. Check prerequisites". That
asymmetry is pre-existing, is not touched here, and is recorded so the next reader does not read
the new step's clean 9 as evidence the two lists are in exact correspondence.

### P3 — `package.json`

- **`prepare` is removed.** `package.json:11`, `"prepare": "[ -d .git ] && lefthook install || true"` —
  deleted, not guarded. After this, nothing in the manifest writes anywhere under `.git/`.
- **`postinstall` is added**, and it announces and arms nothing: it writes only to stdout, makes no
  network call, reads no credential. It is **silent in three cases** — when the hooks are already
  armed, when `CI` is set in the environment, and when there is no git repository. It names
  `bash install.sh` as the way to arm them.
- **Its git guard is `git rev-parse --git-dir`, the same as P1's**, and for the same reason. The
  `prepare` being removed used `[ -d .git ]`, so a `postinstall` copying that form would be silent
  in exactly the worktree checkouts where the notice matters most — the trap ST07 exists to close,
  reintroduced one line away from where it was closed.
- **"Already armed" is defined, not assumed**: `.git/hooks/pre-commit` exists **and** carries
  lefthook's marker. Presence alone is satisfied by `code-review-graph install`'s raw hook, which
  would silence the notice on a checkout with no lefthook hook at all. This is the test HP-02
  already asserts, and stating it once keeps the script and the probe in agreement.
- **One shipped line is made false by this edit and moves with it.** `.copier/README.md:1085` reads
  `pnpm prepare          # Install Lefthook git hooks (runs automatically after install.sh)`.
  Removing `prepare` turns that into a setup instruction naming a command that does not exist —
  **the exact defect class this story exists to close, newly created by its own fix**. It becomes
  `bash install.sh`, and the Development-scripts table at `:1088-1103` gains an "install-hooks.sh"
  row for parity with `code/src/scripts/development/CONTEXT.md`. **This is carved out of the
  "`.copier/README.md` unmodified" assertion explicitly**: that assertion covers `:442`, the claim
  the story makes true, and nothing else. Nothing gates it — `shipped-readme.sh` checks the project
  tree, the audits register and the skills register, never the root-scripts code block.
- **`install-frontend.sh` is not edited.** Its three `--ignore-scripts` flags at `:67`, `:84` and
  `:93` are asserted by P4 and changed by nobody. They also suppress the new `postinstall`, which is
  correct: `install.sh` calls that script and arms the hooks itself moments later, so a notice
  printed there would be false three lines before it was made false.

### P4 — The probes, and the one that could not live where the story put it

| Probe                        | What it asserts                                                                                               | Home                                 |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| Pre-commit, positive         | After "install-hooks.sh" completes, `.git/hooks/pre-commit` exists and is **lefthook's**                      | The new workflow, fixture A          |
| Pre-commit, negative         | A tree with no `.git` reports the skip and continues — exit code unaffected                                   | The new workflow, fixture C          |
| Worktree                     | A `git worktree add` checkout, where `.git` is a file, **arms** rather than skipping                          | The new workflow, fixture A          |
| Unborn HEAD                  | `git init` with no commits — `lefthook install` succeeds against it                                           | The new workflow, fixture B          |
| `postinstall` notice         | Prints in a git checkout with no armed hook; silent when armed, when `CI` is set, and when there is no `.git` | The new workflow, fixtures A and C   |
| Step presence, both poles    | The generated `install.sh` carries the step on `INCLUDE_MOBILE` false and true                                | `[3/4] Template Generation`, by grep |
| The four manifest assertions | `--ignore-scripts` on `install-frontend.sh:67`, `:84`, `:93`; and `package.json` carries **no** `prepare`     | The new workflow, no fixture         |
| `template-integrity`         | The existing pre-commit leg (`lefthook.yml:229-242`) still passes                                             | Locally, against the armed hook      |
| PA-01, PA-02                 | The notice's behaviour on the two channels that still run unsuppressed — see below                            | The new workflow, fixture A          |

### The fixtures, and the workflow that holds them

**Three fixtures, because no one of them can carry every scenario.**

| Fixture | Shape                                                                                                                                 | Serves                              |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| A       | A checkout of this repository — its own `lefthook.yml`, `package.json` and an installed `node_modules` — with **at least one commit** | HP-02, EC-01's worktree, the notice |
| B       | The same tree, `git init`-ed fresh with **no commits** — an unborn HEAD                                                               | EC-04                               |
| C       | A copy with `.git` removed entirely                                                                                                   | ES-05, the notice's silent case     |

**A and B cannot be one fixture**: `git worktree add` refuses an unborn HEAD, so EC-01 needs a
commit and EC-04 needs none. **None of the three is a bare `git init`** — see _Architecture
Decision_ for the measurement that rules that out.

**§7.13 is restated so that it is achievable.** "No write outside `.git/hooks/`" is scoped to **the
repository the script arms**. Running `lefthook install` where no `lefthook.yml` exists makes
lefthook create one, so the unqualified form is false of any tree without a config — and every
fixture above carries this repository's own config precisely so the tree under test never gains a
file.

**The workflow is named, because the story delegated that to this gate and a table column is not an
answer.** `../02-STORIES/US009.md` `:304` reads "the probe's home is settled at `17-story-plans`". **No existing
workflow can host it**: `audit-template.yml` sets up **uv only** (`:143-144`) — no node, no pnpm —
and the workflows that do have them are single-purpose. So the probes land in a new
".github/workflows/audit-hook-arming.yml", on push and pull request, with the setup block
`.github/workflows/syntax-js-ts.yml:31-47` already establishes: `actions/checkout` →
`pnpm/action-setup` → `actions/setup-node` → `pnpm install --frozen-lockfile` → the probes. **The
probe body lives in "code/src/scripts/tests/hook-arming.sh"**, per `.claude/CLAUDE.md` Section 6 —
the workflow calls the script and never inlines the assertions.

**That setup block is itself a twelfth unsuppressed `pnpm install`**, and it fires the new
`postinstall`. Recorded here rather than discovered in a CI log: the notice is silent there because
`CI` is set, which is one of P3's three clauses — so the positive-case probe must run with
**`env -u CI`**, or it asserts against the suppressed state and passes for the wrong reason.

**The generation job keeps only the grep, and that is the finding rather than a compromise.**
`.github/workflows/audit-template.yml:151-163` generates with `uvx copier copy` in a shell loop over
both `INCLUDE_MOBILE` poles and **never executes the generated `install.sh`** — which would need
docker, uv, pnpm and `sudo tee -a /etc/hosts` against the runner. Adding a grep inside that loop is
free; adding an execution is a new job with new reasoning (AC-GAP-6, §7.9). **The story cites that
step as `:151-161` and it is `:151-163`** — see _Measured divergences_.

**The unborn-HEAD case is covered by a probe, not by a written assumption.** Settled with
<%DEVELOPER_NAME%> 18/09/2026 against the assessment's §7.11, which offered either. `copier.yml:1025`
runs `git init --initial-branch=main` gated `when: copy`, so a generated project has `.git` with no
commits, and whether `lefthook install` succeeds there is currently assumed by everyone and tested
by nobody. It is one `git init` in a temporary directory away, so the assumption is not worth
writing down.

### PA-01 and PA-02 — the notice on the channels that still run

The QA plan carries two PA rows written, before the ADR, as demonstrations that the silent channel
was open. **After the ADR they invert**: they are the two places the new `postinstall` actually
runs. They are carried here rather than dropped alongside the finding they were written for.

| ID    | Channel                                                     | What it now asserts                                                    |
| ----- | ----------------------------------------------------------- | ---------------------------------------------------------------------- |
| PA-01 | `gh pr create` → `.claude/hooks/lib/check-lockfiles.sh:147` | Nothing is written to `.git/`. **The notice is swallowed** — see below |
| PA-02 | Ten CI steps across five workflow files                     | Nothing is written to `.git/`; the notice is silent, `CI` being set    |

**PA-01 carries a live defect in the ADR's own reasoning, found at this gate.**
`check-lockfiles.sh:147` is
`lpnpm_o=$(cd "$PROJECT_ROOT" && pnpm install --frozen-lockfile 2>&1) || lpnpm_e=$?` — stdout is
**captured into a variable** and printed at `:149` only on failure. The ADR calls this channel "the
exact channel the contributor already runs through", and it is the **only local one of the eleven**.
On a successful install the notice is swallowed, so the contributor who never ran `install.sh` —
the precise person the `postinstall` exists for — never sees it.

**The plan does not silently accept that.** The implementer either writes the notice to **stderr**,
which `:147` does not capture separately and where `install.sh`'s own `warn` and `err` already go,
or records the swallow as an accepted residual with this measurement beside it. **What is ruled out
is shipping it unexamined**, which is what an unwritten PA row would have done.

**The three `--ignore-scripts` assertions neither depend on nor mask
`install-frontend.sh:79-81`.** That block is the live `sudo rm -rf` defect —

```text
79:  sudo rm -rf \
80:    "$PROJECT_ROOT/node_modules" \
81:  log "Removed."
```

— where line 80's trailing `\` makes `log` and `Removed.` arguments to `rm -rf`. **`:84` is the
next `pnpm install` after that block**, so an assertion written as "lines 79 to 93 are unchanged"
would tick while walking straight past it. **Each assertion names its own single line and asserts
the flag on that line only.** The `GAPS.md` row of 11/09/2026 owns the defect; US009 does not fix
it (§7.6, TM-06).

**Do not stage that defect to test it.** Planting a file named `log` or `Removed.` at the project
root to prove the finding would have it deleted as root. The assertion's **form** is what is
confirmed, by reading it.

### P5 — The documentation surface

**Two claims become true and are not edited:**

| Claim                            | Reads                                                            | After |
| -------------------------------- | ---------------------------------------------------------------- | ----- |
| `.copier/README.md:442`          | "…runs `lefthook install`, which registers the pre-commit hooks" | True  |
| `how-to/src/CONTRIBUTING.md:155` | "Hooks are installed by `bash install.sh`."                      | True  |

Both are re-read against the changed script and both are confirmed **unmodified in the diff**. The
story names only the first; the second is the same claim in four words and is found by this plan —
see _Measured divergences_.

**Two enumerations are edited, because they list what `install.sh` does:**

| File                                            | What it carries                                                                                                                                                                   |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `how-to/workflows/01-first-time-setup/STEPS.md` | A six-bullet list of what `bash install.sh` does — gains the hook step                                                                                                            |
| `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md`    | A prose sentence enumerating the same effects — gains the same clause                                                                                                             |
| `install.sh:3-7`                                | The script's own header, enumerating what it does — gains the hook clause                                                                                                         |
| `code/docs/CODE-REVIEW-GRAPH.md:148`            | Tells a reader to "run `lefthook install` to reclaim the hook" — a raw invocation breaching Section 6's script-first rule once "install-hooks.sh" exists. Repointed at the script |

**Both substitutions are scope additions, and both are counted.** The story's Documentation Task
names two files; this plan edits four others instead and adds two more. That is the second scope
addition after the extraction itself, and the 5 SP defence in _Key Decisions_ covers it.
`04-QUICKSTART.md` sits under `how-to/src/TEMPLATE-GUIDE/**`, which `template-docs-readonly.sh` and
its lefthook job guard — **both stand down in syntek-base** (`.claude/hooks/CONTEXT.md:92-93`), so
the edit is permitted, and saying so saves a reviewer discovering a guarded path in the diff.

**And two files the story names turn out to enumerate nothing.** The story's Documentation Task
says to update `how-to/docs/DEVELOPMENT.md` and `how-to/docs/CLI-TOOLING.md` "where either
enumerates `install.sh`'s steps". Measured 18/09/2026: **neither does**, and both of their
`install.sh` references are to `code/src/scripts/development/install.sh` — a **different script**,
a 9-line forwarder to `install-frontend.sh`. The task is recorded **`N/A` with that reason**, never
left blank and never satisfied by an invented edit (`code/docs/GATE-REPORTING.md`).

---

## Key Decisions

| #   | Decision                                                                                                                         | Why, and what was rejected                                                                                                                                                                                                                                                                                                                             |
| --- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | **The arming logic is extracted to "code/src/scripts/development/install-hooks.sh"**, called by the root `install.sh`            | The story's automated criterion needs the arming code runnable in CI. `install.sh` needs docker, uv, pnpm and `sudo`, so it cannot be. Rejected: a manual-only probe (weakens the criterion to fit the implementation) and provisioning a runner for the whole of `install.sh` (a new job, new secrets, new reasoning). <%DEVELOPER_NAME%>, 18/09/2026 |
| 2   | **`usage()`'s Phase 2 is renumbered — to 10 and 11**                                                                             | The collision is not left recorded. Phase 1 ends at 9 after this story, so the recorded "9 and 10" reproduces the collision; continuing the sequence gives 10 and 11. Rejected: leaving the pre-existing collision deliberately, and renumbering phase-locally. <%DEVELOPER_NAME%>, 18/09/2026 — **the arithmetic is flagged, see P2**                 |
| 3   | **The generated-project unborn-HEAD case is covered by a probe**                                                                 | §7.11 offered "cover it or record the assumption". It is one `git init` away, so an assumption is not worth writing. Rejected: writing the assumption down, and guarding the step against an unborn HEAD. <%DEVELOPER_NAME%>, 18/09/2026                                                                                                               |
| 4   | **`prepare` is removed rather than guarded**                                                                                     | `ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`, Option C over A, B and D. Not re-decided here; carried                                                                                                                                                                                                                                      |
| 5   | **The step is the last of Phase 1, and the hard fail is kept**                                                                   | Threat model Section 4a Q2, settled 17/09/2026. At the end of Phase 1 a hard fail abandons nothing, so it costs what it always should have                                                                                                                                                                                                             |
| 6   | **The guard is `git rev-parse --git-dir`**                                                                                       | ST07. `[ -d .git ]` is false in a `git worktree add` checkout, which is how this project does parallel story work. Not an ADR — there is no trade-off, the other form is simply wrong                                                                                                                                                                  |
| 7   | **The probes get a new workflow, ".github/workflows/audit-hook-arming.yml", and a probe script under `code/src/scripts/tests/`** | The story delegated the probe's home to this gate. No existing workflow has node and pnpm — `audit-template.yml` sets up uv only. Rejected: inlining the assertions in a workflow (breaches Section 6), and bolting them onto an unrelated single-purpose workflow                                                                                     |
| 8   | **The probe fixture is a checkout of this repository, never a bare `git init`**                                                  | Measured: a bare `git init` produces no `pre-commit` hook, writes a `lefthook.yml` into the tree, and defeats `pnpm exec`. Three fixtures, because EC-01 needs a commit and EC-04 needs none                                                                                                                                                           |
| 9   | **The estimate stays 5 SP, as a stated wide 5**                                                                                  | Decisions 1 and 7 add files the task list does not carry. See below                                                                                                                                                                                                                                                                                    |

### The estimate is a wide 5, and saying so is the point

**US009 stays at 5 SP.** Beyond the story's task list this plan adds: the extracted script and its
two `CONTEXT.md` edits (Decision 1); a new CI workflow and a probe script (Decision 7); four
documentation sites the story does not name, in place of the two it does; and the one
`.copier/README.md` line the manifest edit falsifies.

**It is not re-estimated to 8, for the same reason
`../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` holds its own 8 as a wide 8:**

- The surface does not change shape — bash files in existing families, one manifest edit, one
  caller, and the probes the story already priced. The seam count does not move.
- **The additions are consequences of one decision**, not a widening of the subject. The extraction
  forces the workflow, the workflow forces the probe script, and the manifest edit forces the
  README line. A story that had priced the extraction would have priced all of them.
- `../../docs/planning/STORIES.md` puts the advisory split at >8 and the epic threshold at 13.
  Neither is near, and the story keeps one subject.
- **Fibonacci offers nothing between 5 and 8.** Moving to 8 for one extra file would price this
  story equal to US008 — six phases across settings, a gate, two migration entries and a repaired
  preview channel — which it plainly is not.
- **SPRINT-05 is already at 13 / 11 SP, the grace ceiling, and closed.** An 8 would take it to
  16 / 11 and force a re-plan of a sprint whose `Must` has not started.

**This is now the top of the 5 band and pressing on the boundary — the honest reading rather than
a comfortable one.** If the implementer finds the new workflow costs more than the setup block it
copies, 8 is the right answer and the sprint is re-planned. Naming that threshold now is what stops
the estimate being defended after the fact.

**And the original reading still holds.** As SPRINT-05's
only `Should`, it is the first work dropped if US008 overruns, and dropping it fails nothing —
which is the same sentence the story already carries, now with the extra file in view.

---

## Dependencies

| Depends on                           | State                                                                                                                                                                                                                                       |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nothing blocking**                 | Verified 17/09/2026 against US001–US008, all `Status: Open`: none writes `install.sh`, `install-frontend.sh`, `package.json`, `lefthook.yml` or `.copier/README.md`. Re-confirmed 18/09/2026 — US008's plan landed and touches none of them |
| `pnpm-lock.yaml:54-56`               | Pins `lefthook` at `2.1.10`. `package.json:22` is `"^2.1.10"`, a **range** — the lockfile is what pins                                                                                                                                      |
| `lefthook` present in `node_modules` | `node_modules/.bin/lefthook` exists; `command -v lefthook` returns nothing. The step runs after dependency install                                                                                                                          |
| US008                                | **Not a dependency.** Same sprint, built first as the `Must`; shares no file with this story                                                                                                                                                |

**Blocked by:** nothing. **Blocks:** nothing — no story in the backlog waits on US009, verified
18/09/2026 across US001–US008. **Can be done now:** all of it; P3 in particular shares no file with
P1 or P2 and can land first.

### Named and not owned — four things a later reader must not re-merge

1. **The eleven unsuppressed `pnpm install` invocations** (TM-02). **The register row that is
   supposed to carry them does not exist** — measured 18/09/2026, `GAPS.md` contains no occurrence
   of `pnpm install`, `unsuppressed`, `prepare` or `lefthook`, and its three 17/09/2026 rows are the
   audits-register headroom, the three self-refuting feature maps, and the backlog register. The
   ADR's follow-on says "`GAPS.md` carries it from 17/09/2026" and an earlier draft of this plan
   inherited that claim instead of measuring it. **`22-implementation-documentation` opens the
   row**, which is where a `GAPS.md` write belongs; until it does, §7.2's second limb is
   **unsatisfied, and it is carried in the Definition of Done** rather than ticked. Their
   `prepare` target disappears with P3, so they stop arming anything — but the surface is open for
   the next lifecycle script anyone adds. **Out of scope**, and ST01 is scoped in its own wording so
   a tick reads as three lines of sixteen rather than as a posture (AC-GAP-3, §7.2).
2. **`install-frontend.sh:79-81`'s `sudo rm -rf`** — the `GAPS.md` row of 11/09/2026 owns it. This
   story reads that file, asserts against three of its lines, and must neither depend on the defect
   nor mask it (§7.6, TM-06). Re-confirmed live 18/09/2026.
3. **`../01-FEATURE-MAPS/MAP-GATE-PARITY.md`'s `S-03`**, the retained half (N-006 + N-017) — ships after `S-05`, not
   after this story. The two halves were split at slice selection on 17/09/2026 and are not
   re-merged.
4. **The Bun swap.** `../01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md` `:62` puts `install.sh` inside its surface and `:220`
   records that lefthook's hook template has no bun branch. That map is **29 open / 21 blocking**
   and cannot produce a story, so this one ships against pnpm as the tree stands.

---

## GDPR

**`N/A`, and the flag reads `N/A` in the story.** This story introduces no field, no store and no
personal-data path. It creates one bash file, edits one JSON manifest and writes one file under
`.git/hooks/`. There is no data subject, no lawful basis to state, no retention window and no DSAR
surface.

`project-management/workflows/09-gdpr-compliance/` did not run and is recorded as not run, per
`code/docs/GATE-REPORTING.md` — the gate is skipped because its entry condition is absent, which is
a different thing from a gate nobody thought about.

---

## Security

**This story's Security flag is filled where the map's slice manifest left it blank**, on the
`../02-STORIES/US006.md:15-22` precedent: a manifest written for one kind of slice must not skip the
only gate able to check what the story actually ships. **That reasoning is vindicated here** — the
three largest findings, TM-01, TM-02 and TM-03, are all outside the state list the story gave QA,
and none would have surfaced from `11-qa-checks` alone.

### The findings, and the zero that is a reading

`../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` raised **twelve
threats across five STRIDE categories: 0 CRITICAL, 0 HIGH, 7 MEDIUM, 4 LOW, 1 INFO.** Nothing
escalates to `../10-SECURITY/VULNERABILITIES/PLANNING/` and sprint planning is not gated.

**That zero is a measured outcome with its reason, never "the security gate passed".** Every
severity is a present-state reading of a template repository with one developer, no deployment and
no known compromised dependency. **Five findings promote to `HIGH`**, and the model's Section 3a
names the event for each — the first compromised package in the graph (TM-02), a second contributor
joining (TM-01), the next worktree story (TM-03), a host-global `lefthook` of a different major
(TM-04), and anything named `log` or `Removed.` appearing at the project root (TM-06).

**Two things that zero does not mean.** TM-01 is `MEDIUM` and is the most consequential row in the
table, because it says the story does not achieve its stated goal — a scope question, not a severity
one, and `ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` is the answer. And TM-02 is not
closed: it is pre-existing, raised here rather than absorbed.

### The fourteen constraints, mapped to phases

`../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` Section 7 carries
**fourteen** constraints, 7.1 to 7.14. Each is an acceptance criterion; the implementation
assessment closes it with evidence.

| §    | Constraint                                                                                                  | Built in | Proved in — and the TM / AC-GAP it closes                                                                                                                               |
| ---- | ----------------------------------------------------------------------------------------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.1  | `prepare` is settled, not merely preserved                                                                  | P3       | P4's manifest assertion — **TM-01, AC-GAP-1**                                                                                                                           |
| 7.2  | `--ignore-scripts` asserted on three lines, **with its scope stated**                                       | P4       | Three per-line assertions **plus the register row, which is owed** — **TM-02, AC-GAP-3**                                                                                |
| 7.3  | The guard tests for a repository, not a directory                                                           | P1       | P4's worktree probe, fixture A — **TM-03, AC-GAP-2**                                                                                                                    |
| 7.4  | The binary comes from `node_modules` by `pnpm exec`, never `PATH`                                           | P1       | Read the shipped line; EC-02 plants a host-global binary — **TM-04, AC-GAP-4**                                                                                          |
| 7.5  | The step's position is justified against its failure mode                                                   | P2       | The step sits between `:522` and `:524`; nothing follows a hard fail — **TM-05, AC-GAP-5**                                                                              |
| 7.6  | The assertions neither depend on nor mask `install-frontend.sh:79-81`                                       | P4       | Read the assertion's form — per line, never a block — **TM-06**                                                                                                         |
| 7.7  | The step reports what it wrote into `.git/hooks/` and what it replaced                                      | P1       | P4's EC-03 and EC-05; `lefthook.yml:73-76` names the contest — **TM-07, AC-GAP-7**                                                                                      |
| 7.8  | ST03's wording corrected — the lockfile pins, the manifest ranges                                           | P0       | Recorded at baseline: `^2.1.10` against `pnpm-lock.yaml:54-56` — **TM-08, AC-GAP-8**                                                                                    |
| 7.9  | The generation job's criterion is what it can do — grep, not execute                                        | P4       | The grep inside `audit-template.yml:151-163`'s loop — **TM-09, AC-GAP-6**                                                                                               |
| 7.10 | The renumbering names Phase 2 as well as Phase 1                                                            | P2       | `usage()`, both Phase 2 body headers and the new one, in one edit — **TM-10, AC-GAP-9**                                                                                 |
| 7.11 | The unborn-HEAD case is covered, or the assumption written down                                             | P4       | **Covered** — Decision 3, fixture B. A probe, not an assumption — **TM-11**                                                                                             |
| 7.12 | The step runs after dependency installation                                                                 | P2       | Its position, last in Phase 1, is after Step 4 by construction — **ST04**                                                                                               |
| 7.13 | No new network fetch, credential read, or write outside `.git/hooks/` **of the repository the script arms** | P1       | Diff each fixture before and after — **ST05**. The scoping is P4's, and it is what makes this achievable                                                                |
| 7.14 | The guard tests for a repository and nothing else                                                           | P1       | Read the guard — it never becomes a general try/ignore. **ST06's surviving half**; ST06 itself is retired by the ADR, the lifecycle script it reasoned about being gone |

**Section 7's opening line reads "Eleven constraints" and the list runs to fourteen.** The item
count is **fourteen**; the section's own closing sentence agrees ("None of the fourteen…").
Correcting the opening line belongs to `10-security-checks`, not to this plan — see _Measured
divergences_.

### The trust boundaries this story moves

| TB  | Boundary                                         | What this story does to it                                                                                                 |
| --- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| TB1 | Operator shell → `install.sh`                    | **Changed.** The guard stops reading `.git`'s _shape_ and asks git whether this is a repository                            |
| TB2 | `install.sh` → the lefthook binary               | **Narrowed.** `pnpm exec` fixes resolution to the project's own `node_modules`, never `PATH`                               |
| TB3 | The pnpm lifecycle → `.git/hooks/`               | **Closed.** P3 deletes the only script that crossed it — the one boundary this story removes                               |
| TB4 | `install.sh` → `.git/hooks/pre-commit`           | **Opened.** `install.sh` writes nothing under `.git/` today and after this story it does, which is why 7.7's report exists |
| TB5 | This template → a generated project              | **Exercised, not changed.** HP-07's grep and EC-04's unborn-HEAD probe are its tests                                       |
| TB6 | The npm dependency graph → the host / the runner | **Untouched and named** — TM-02, and the register row that is owed                                                         |

---

## Logging & Observability

**`N/A`, and the flag reads `N/A`.** This story emits no log line. The step prints to a terminal
through `install.sh`'s own `bold` / `log` / `ok` / `warn` / `err` helpers at `:28-34`, and a
terminal report is not a log: nothing is collected, nothing is structured, nothing persists.

**TM-12 is an accepted residual, named rather than assumed.** Nothing records whether the hooks
were armed for a given commit, so a commit made on an unarmed checkout is indistinguishable
afterwards. It is `INFO`, and `code/docs/security/AUDIT-TRAIL.md` covers the application rather
than a setup script. Recording it here is what stops the next reader treating the silence as an
oversight.

---

## Performance, Rendering, Responsive & Accessibility

**All four are `N/A`, and each for its own reason rather than as a block.**

- **Performance** — the step runs once, at install, and adds one `pnpm exec` invocation to a script
  that already runs two dependency installs. There is no request path and no query.
- **Rendering** — no template, no component, no HTMX or Alpine surface. The `Frontend` flag is `N/A`.
- **Responsive** — no rendered screen.
- **Accessibility** — no rendered screen, so WCAG 2.2 AA has no subject. **One
  accessibility-adjacent property is worth preserving, and the claim is narrower than an earlier
  draft of this plan made it:** of `install.sh`'s **seven** helpers at `:27-34`, three use colour —
  `ok` (green), `warn` (yellow) and `err` (red) — and **each of the three pairs its colour with a
  glyph or a word**, so none relies on colour alone. `bold` uses weight and `log` no escape at all;
  neither carries a glyph, and neither needs one. The new script defines helpers of the same shape
  rather than raw `printf` — it cannot inherit them, see P1.

---

## Implementation Workflows & Standards

### PM workflow chain (in order)

`02-story-creation` ✅ → `03-sprint-planning` ✅ → `10-security-checks` ✅ **(both artefacts `Status: Draft`, unreviewed)** → `11-qa-checks` ✅ →
`15-decisions` ✅ → `16-sprint-plans` ✅ → `17-story-plans` **(this plan)** → `19-backend-code` →
`22-implementation-documentation` → `23-pr-and-review` → `24-release`.

**`20-api-code` and `21-frontend-code` are skipped, and the skip is the reading.** The `API` and
`Frontend` flags both read `N/A`; there is no Ninja surface, no MCP tool and no rendered page.
`04-database-schema`, `05-user-flow-design`, `06-brand-guides`, `07-component-designs`,
`08-wireframes`, `09-gdpr-compliance`, `12-seo-checks`, `13-api-design` and `14-logging-checks` did
not run, each because its entry-condition flag reads `N/A`.

**`19-backend-code` is entered even though `Backend` reads `N/A`**, because it is the build phase
`01-implement-story` is entered at and this story has a build lane — bash and a manifest. The flag
describes the Django surface, not whether code is written.

### Code workflows invoked

`01-implement-story` wraps the build. **No stack skill applies** — this story ships bash and one
JSON manifest edit, so `stack-django`, `stack-htmx-templates` and `stack-fastmcp` all have no
subject. `02-tdd-cycle` applies in its shell form: the probes are written before the script they
probe, which is what makes P1's extraction testable at all.

### Standards gates

| Gate                        | Applies                                                                                                                                                                                                                                                                                                                                                     |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/doc-references.sh`  | **Yes** — baseline by identity at P0, scoped runs per edited file, re-run at close                                                                                                                                                                                                                                                                          |
| `audits/docs-length.sh`     | **Yes** — `code/src/scripts/development/CONTEXT.md` gains a row and a tree line                                                                                                                                                                                                                                                                             |
| `audits/docs-pairing.sh`    | **Yes** — the new script lands in a directory that already carries both files; neither is created                                                                                                                                                                                                                                                           |
| `syntax/lint.sh`            | **Yes, for markdown.** Its legs are ruff, markdownlint-cli2, ESLint and clippy — **none of them reads bash**                                                                                                                                                                                                                                                |
| `syntax/format.sh`          | **Yes** — Prettier formats the changed `package.json` and every changed Markdown file                                                                                                                                                                                                                                                                       |
| `syntax/check.sh`           | **`N/A`** — no Python, no TypeScript and no Rust in the diff; its legs are basedpyright, tsc and cargo. Its Python leg also dies with "No containers are running", and this story starts no stack. The story's Verification Checks name it, so it is recorded rather than dropped — `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` already reads `N/A` for US009 |
| **ShellCheck**              | **Yes, and by hand.** No project script runs it. Present on this host at 0.11.0 (18/09/2026)                                                                                                                                                                                                                                                                |
| `audits/dict-discipline.sh` | `N/A` — no Python, no dictionary                                                                                                                                                                                                                                                                                                                            |
| `audits/css-tokens.sh`      | `N/A` — no CSS                                                                                                                                                                                                                                                                                                                                              |
| `tests/all.sh --coverage`   | `N/A` — no Python in the diff, so no coverage figure and no regression to measure                                                                                                                                                                                                                                                                           |

**ShellCheck is the gate this story most needs and the one no script runs.** `lint.sh` cannot see
bash. It is run by hand over "install-hooks.sh" and the changed `install.sh`, and **recorded as run
or as not run — never as a `lint.sh` pass** (`code/docs/GATE-REPORTING.md`).

---

## Execution & Verification via Claude Dynamic Workflows

### Stage 0 — Plan verification (before any code)

This plan is read against the story, the ADR, the threat model, the assessment and the QA plan, and
the four _Measured divergences_ below are re-resolved by quoted text before any number in them is
believed. **`f045aac` moved two citations this story rests on**, and a fifth move between this
plan's writing and the branch being cut is the expected case, not the surprising one.

### Stage 1 — Build (the shell TDD inner loop)

Per phase: write the probe → watch it fail for the stated reason → write the script → watch it pass
→ ShellCheck by hand → scoped citation gate. **The probe must fail for the right reason first**: a
pre-commit probe that fails because `.git/hooks/pre-commit` is absent proves something; one that
fails because the probe's own path is wrong proves nothing, and the two look identical in a CI log.

### Stage 2 — Continuous verification gates

After every meaningful change: `bash code/src/scripts/syntax/format.sh --fix` scoped to the changed
paths, `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <file>`, ShellCheck by
hand, and `bash code/src/scripts/audits/doc-references.sh --path <file>`.

**Every gate is scoped to this story's own paths.** SPRINT-05's `Must` may be in flight in a
sibling worktree, and a repo-wide `--fix` run while another session is live cannot be proved not to
have touched its files.

### Stage 3 — Review (before raising the PR)

`code-reviewer` for standards and spec, then `qa-tester` for the hostile pass, then `security` —
the last is not optional here, because the story's own subject is a supply-chain boundary. **No
skill reviews its own work**: each is dispatched independently, naming the skill in the prompt.

### Stage 4 — Behavioural verification

The three manual walk-throughs, in a **scratch clone, every time**. Never against this working
tree: `install.sh` Step 2 appends to `/etc/hosts` with `sudo`, Step 4 shells to a script that runs
`sudo rm -rf` from the project root, and Step 6 generates secrets into `.env.dev`.

### Stage 5 — PR and release

`23-pr-and-review` → `24-release`. This story carries **no** release-time obligation — no version
key, no migration entry, nothing derived against a tag.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**This story runs no container, and that is unusual enough to state.** Every other SPRINT-05
artefact reaches Docker through the dev stack; this one does not. `install.sh --full` builds the
stack at Phase 2, and Phase 2 is untouched by this story except for two header renumbers. The
probes run against a scratch `git init` on the runner, with no service of any kind.

### Canonical commands

| Purpose               | Command                                                                                      |
| --------------------- | -------------------------------------------------------------------------------------------- |
| Markdown lint         | `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <file>`                    |
| Format                | `bash code/src/scripts/syntax/format.sh --fix --file-type markdown --path <file>`            |
| Citation gate, scoped | `bash code/src/scripts/audits/doc-references.sh --path <file>`                               |
| Length gate           | `bash code/src/scripts/audits/docs-length.sh --path code/src/scripts/development/CONTEXT.md` |
| Pairing gate          | `bash code/src/scripts/audits/docs-pairing.sh --path code/src/scripts/development`           |

### The two exceptions, and why each is allowed

1. **`pnpm exec lefthook install` inside the shipped script.** `.claude/CLAUDE.md` Section 6 bans a
   raw `pnpm` invocation. This is not one: it is the house idiom at 23 occurrences across 14 files, 20 of them executable,
   it is what `lefthook.yml` itself uses, and it is the content of a project script rather than a
   command run instead of one.
2. **ShellCheck, run by hand.** No project script wraps it. Running it directly is the only way to
   run it at all, and the alternative — not running it — leaves the story's entire diff unlinted.

---

## Testing

**No pytest, no coverage figure, no migration check — and each is recorded `N/A` with its reason
rather than left blank.** There is no Python in this diff.

### Automated

| ID       | Scenario                                                                      | Where                                 |
| -------- | ----------------------------------------------------------------------------- | ------------------------------------- |
| HP-02    | `.git/hooks/pre-commit` exists and is lefthook's after the script completes   | The probe step, against P1's script   |
| HP-07    | The generated `install.sh` carries the step, both `INCLUDE_MOBILE` poles      | `audit-template.yml:151-163`, by grep |
| ES-05    | A tree with no `.git` — the skip reports and the exit code is unaffected      | The probe step                        |
| EC-01    | A `git worktree add` checkout, `.git` a **file** — the hooks **arm**          | The probe step                        |
| EC-04    | `git init`, no commits, unborn HEAD — `lefthook install` succeeds             | The probe step (Decision 3)           |
| ST01 ×3  | `--ignore-scripts` on `install-frontend.sh:67`, `:84`, `:93`, per line        | The probe step                        |
| ST02     | `package.json` carries **no** `prepare` script                                | The probe step                        |
| ST02b ×4 | The `postinstall` prints when unarmed; silent when armed, `CI` set, no `.git` | The probe step                        |

**Five scenarios carried from the QA plan with an explicit disposition, so none reads as dropped:**

| ID           | Disposition                                                                                                                                                                   |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-05        | **Half superseded.** Its `--ignore-scripts` clause stands; its second clause — "`package.json`'s `prepare` is unchanged" — is reversed by the ADR and is now ST02's inversion |
| EC-05        | **Carried.** A checkout where `code-review-graph install` last wrote the hook: lefthook reclaims it, and the reclaim is reported (7.7)                                        |
| EC-07        | **Satisfied by construction, and measured.** `install.sh --spec` short-circuits at `:203-206`, far above the new step, so the flag cannot half-arm anything                   |
| ES-04        | **Carried as its own state** — the binary absent from both `node_modules` and `PATH`, failing with a message naming it rather than a bare `command not found`                 |
| PA-01, PA-02 | **Inverted and carried** — see P4. They now test the notice rather than demonstrate the silence                                                                               |

### Manual — four, and each because its proof is a real clone

| ID                  | Walk-through                                                                                       |
| ------------------- | -------------------------------------------------------------------------------------------------- |
| HP-01, HP-03        | Clean clone → `bash install.sh` → a throwaway `git commit`; the pre-commit legs observed running   |
| HP-04, EC-06        | The same clone re-run through `bash install.sh`; no duplication, no error, the hook byte-identical |
| ES-01, ES-02, ES-03 | A broken `lefthook install`: reported in the `err` idiom naming it, exit 2, never swallowed        |

| HP-06 | `.copier/README.md:442` and `how-to/src/CONTRIBUTING.md:155` re-read against the changed script and confirmed true, with the re-reads recorded and both files confirmed unmodified at those lines |

**A tester other than the author signs the walk-through off**, and the output is recorded in it.
**The scratch clone starts with no `.git/hooks/pre-commit`** — which a fresh clone does by
construction — or HP-01 proves nothing. **This working tree's hook is not cleared**; see P0.

**One story task is superseded and recorded as such.** `../02-STORIES/US009.md`'s QA task "wire
both probes into the generation job so they run on both `INCLUDE_MOBILE` poles" cannot be done as
written — AC-GAP-6, and P4 above. The generation job keeps the grep; the probes move to their own
workflow. Recorded `N/A — superseded`, the same treatment the two documentation files get.

### Two scenarios that stage a fixture, and one that must not

`EC-02` — a host-global `lefthook` of a different major planted on `PATH`, proving the project's own
binary wins — is cheap to stage and is the only way to prove the resolution rather than assume it.
`EC-03` — a hand-written hook in place, proving the developer is told it was replaced — is one
`echo` into the file.

**`§7.6` is not tested and must not be.** Do not plant a file named `log` or `Removed.` at the
project root to demonstrate `install-frontend.sh:79-81`: it would be deleted as root. The
constraint is confirmed by **reading the assertion's form**.

---

## Documentation Write-Ups (Implementation Records)

Owned by `../../workflows/22-implementation-documentation/`, **not by this story**. Named here so
the implementer knows what that workflow will ask for.

| Record                     | Destination                                                                                                                            | Carries                                                                                                |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Implementation record      | The per-discipline `IMPLEMENTATION/` folders the rows below name, plus "project-management/src/19-REVIEWS/" for the code-review record | The divergences re-resolved; the ShellCheck reading; what `.git/hooks/pre-commit` held at P0           |
| Test record                | "project-management/src/18-TESTS/US009-TEST-STATUS.md" and "project-management/src/18-TESTS/US009-MANUAL-TESTING.md"                   | The three walk-throughs with their output, and every `N/A` row with its reason rather than blank       |
| Security assessment (impl) | `../10-SECURITY/ASSESSMENTS/IMPLEMENTATION/`                                                                                           | The fourteen constraints closed with evidence, and the twelve threats re-assessed against shipped code |
| QA record (impl)           | `../11-QA/IMPLEMENTATION/`                                                                                                             | The nine AC-GAPs verified closed in the shipped change                                                 |

**And one register row it must open.** `22-implementation-documentation` owns every `GAPS.md`
write, and §7.2's second limb — the eleven unsuppressed invocations raised as their own entry — has
no row today. It is opened there rather than here, and this plan's Definition of Done carries it
until it is.

**Three things the implementation record must carry that no gate will ask for:**

1. **The `pnpm install` sweep re-run at close.** The QA plan's own instruction: if the 16 / 5 / 11
   split has moved between P0 and the close, the finding has moved, and AC-GAP-1's and AC-GAP-3's
   shared evidence has to be restated rather than inherited.
2. **The map's line drift.** `../01-FEATURE-MAPS/MAP-GATE-PARITY.md` `:326` cites `.copier/README.md:436`; the claim is at
   `:442` today. Substance intact, and the map is not edited by this story.
3. **What `.git/hooks/pre-commit` held at P0** — present, lefthook's, and armed by none of this
   story's paths. It is the evidence the silent channel was live, and it is destroyed by the
   baseline that records it.

---

## CONTEXT.md & Index Updates

| File                                      | Change                                                                                                                                                   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/development/CONTEXT.md` | **Three edits.** The tree block gains "install-hooks.sh"; the script table gains its row; and `:6`'s "the three `install-*.sh` scripts" becomes four     |
| `code/src/scripts/development/CLAUDE.md`  | Read for a rule that must move with the new script; edited only if one is found                                                                          |
| `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` | The US009 row in _Story Plans — the code master_, the `Should` table's two cells, and the branch reference — **Step 10 of this workflow, not the build** |
| `../02-STORIES/US009.md`                  | The plan cited under _Decisions_, in the form US006 and US007 use — **Step 10**                                                                          |
| `../17-STORY-PLANS/CONTEXT.md`            | **Nothing.** It ships and holds no index by recorded decision                                                                                            |

**`code/src/scripts/development/CONTEXT.md:6` is the edit most likely to be missed**, because it is
prose rather than a table row and no gate counts the members of an `install-*.sh` family against a
word. It is named here so it is not found by a reviewer instead.

---

## Status Propagation & ClickUp Sync

`../02-STORIES/US009.md`'s `**Status:**` moves `Open` → `In Progress` at the first commit on
`us009/hook-arming`, and → `Completed` only at `completion`, after review and QA have passed. This
plan's own `| Status |` header row moves with it.

**The ClickUp export is opt-in and is not wired in this repository.** Nothing is pushed by this
story; the row is recorded so the absence is a reading rather than a gap.

---

## Deferred Items

| Deferred                                                                       | To                                                                                                       | Why                                                                                                                                                    |
| ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| The eleven unsuppressed `pnpm install` invocations                             | A later story — **but the `GAPS.md` row does not exist yet**; `22-implementation-documentation` opens it | TM-02. Eleven edits across six files for a control whose only consumer this story deletes. §7.2's second limb is unsatisfied until the row is written  |
| `install-frontend.sh:79-81`'s `sudo rm -rf`                                    | The `GAPS.md` row of 11/09/2026                                                                          | Not this story's defect. This story must not mask it, which is a different obligation from fixing it                                                   |
| Whether Step 4 should use `--frozen-lockfile`                                  | A dependency-management story                                                                            | TM-08. `install-frontend.sh:84` carries `--ignore-scripts` but **not** `--frozen-lockfile`, so Step 4 may resolve a newer 2.x and rewrite the lockfile |
| Persisting whether the hooks were armed for a commit                           | **Nothing — accepted residual**                                                                          | TM-12, `INFO`. A setup script is not the audit trail                                                                                                   |
| `../01-FEATURE-MAPS/MAP-GATE-PARITY.md`'s `S-03` retained half (N-006 + N-017) | After `S-05`, which lands the shared `_lib/template-tree.sh`                                             | Cutting it now writes three ad-hoc guards `S-05` then rewrites                                                                                         |
| Section 7's "Eleven constraints" opening line                                  | `10-security-checks`                                                                                     | The assessment owns its own header; a story plan does not correct a gate's text                                                                        |

**Nothing here is deferred _by_ this story in the `DEFERRED.md` sense** — each row is work that was
already someone else's, named so it is not absorbed. `DEFERRED.md` gains no entry.

---

## Risks

| Risk                                                                                                  | Likelihood | Impact   | Mitigation                                                                                                                                     |
| ----------------------------------------------------------------------------------------------------- | ---------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **A citation moves again before the branch is cut**                                                   | **High**   | Low      | Every number below is re-resolved by **quoted text** at P0. `f045aac` moved two already                                                        |
| The `postinstall`'s silence clauses leak a notice into CI logs                                        | Medium     | Low      | The `CI` clause is probed directly, in both states, rather than reasoned about                                                                 |
| `lefthook install` fails against an unborn HEAD                                                       | Low        | Medium   | Decision 3 — probed, not assumed. If it does fail, the story learns it in CI rather than a generated project                                   |
| The extracted script drifts from the caller                                                           | Low        | Medium   | The caller does nothing but invoke it and report; there is no logic in `install.sh` to drift from                                              |
| **Phase 2's renumber is applied as 9 and 10** and reproduces the collision                            | Medium     | Medium   | P2 states the arithmetic explicitly and flags the divergence from the literal decision. A reviewer reads 10 / 11                               |
| A repo-wide gate run damages a sibling worktree's uncommitted work                                    | Medium     | Medium   | Every gate scoped with `--path`. SPRINT-05's `Must` may be in flight                                                                           |
| The manual walk-through is run against this working tree                                              | Low        | **High** | Stated three times, including here: `sudo rm -rf` from the project root, `/etc/hosts`, generated secrets                                       |
| **The probe is written against a bare `git init`** and passes for the wrong reason, or fails opaquely | **High**   | **High** | P4 names three fixtures and the measurement that rules the bare case out. This is the defect an earlier draft of this plan shipped             |
| The `postinstall` notice is swallowed on its one local channel                                        | **High**   | Medium   | Measured at P4: `check-lockfiles.sh:147` captures stdout. The implementer writes to stderr or records the residual — never ships it unexamined |
| The new workflow costs more than the setup block it copies                                            | Medium     | Medium   | Named as the 5-to-8 threshold in _Key Decisions_; the sprint is re-planned rather than the estimate defended                                   |

---

## Docker & Nginx Infrastructure

**N = 9.** `how-to/docs/GIT-WORKTREES.md:61-64` fixes the loopback rule — the final octet equals the
story number, `127.0.0.1` being the main stack — so the IP is `127.0.0.9`. **Verified free
18/09/2026**: `git grep -E '127\.0\.0\.9([^0-9]|$)'` returns **no tracked hit outside this
plan**, and no sibling plan in this folder names it. Subnets follow `code/src/docker/CONTEXT.md`: second octet the story
number, third octet 1 for dev and 0 for test.

| File                                            | Purpose                                                                                                                                                                                     |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us009.dev.yml"  | Dev stack override — copied from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us009`; nginx published on `127.0.0.9:3080:80`; subnet `10.9.1.0/24` |
| "code/src/docker/docker-compose.us009.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us009`; `127.0.0.9:3081:80`; subnet `10.9.0.0/24`                        |
| "code/src/docker/nginx/dev-us009.conf"          | Named per `./CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                                 |
| "code/src/docker/nginx/test-us009.conf"         | Same                                                                                                                                                                                        |

**The two Nginx files are named because this folder's rule names them, and the docker layer says
they do not exist.** `code/src/docker/nginx/CONTEXT.md:28-29` states that `dev.conf` and `test.conf`
are `server_name _` catch-alls a worktree stack reuses unchanged, and that "there are no per-story
Nginx variants to generate". The four-file rule is satisfied by the two Compose overrides plus that
recorded absence; inventing two config files nothing reads would be worse than naming the
contradiction.

**And the stack is very likely never started.** This story runs no container: the probes need a
scratch `git init` and nothing else, and the manual walk-throughs need a clean clone rather than a
worktree. The isolation files are specified because `./CLAUDE.md` requires them of every plan and
because the worktree is still where the branch is developed — not because the work needs a
database.

---

## Measured divergences

**Seven live claims in a sibling artefact that the tree does not support, each with its owner.**
None is corrected by this plan; a plan is not the writer of the record it reads.

| Divergence                                                                                                               | Measured                                                                                                                                                                   | Owner                                              |
| ------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| **`lefthook.yml:66-69`** — cited by `../02-STORIES/US009.md`, the threat model, the assessment **and the QA plan**       | The block is at **`:73-76`** at HEAD `f045aac`. It was at **`:66-69`** at `1e00a4b`, where all four measured it — **every one of them was right**                          | This plan cites `:73-76`; the four artefacts stand |
| **`.copier/README.md:441`** — the claim the story makes true                                                             | The claim is at **`:442`** at `f045aac`; it was at `:441` at `1e00a4b` — **again right when measured**                                                                     | This plan cites `:442`                             |
| **`audit-template.yml:151-161`** — the story's first QA criterion                                                        | The generation step is **`:151-163`**, two lines longer; the story's range truncates the `done`. AC-GAP-6 already found this on 17/09/2026                                 | The QA plan has it right; the story does not       |
| **`lefthook.yml:222-236`** — the `template-integrity` leg, cited by `../02-STORIES/US009.md`                             | The leg is at **`:229-242`** at `f045aac`. Same commit, same class as the two above                                                                                        | This plan cites `:229-242`                         |
| **`how-to/src/CONTRIBUTING.md:155`** — "Hooks are installed by `bash install.sh`"                                        | **False today**, and made true by this story without being edited. **No artefact names it** — the story, the QA plan and the assessment all name `.copier/README.md` alone | Found at this gate; carried in P5                  |
| **Assessment Section 7 opens "Eleven constraints"** and lists **fourteen** (7.1 to 7.14), closing "None of the fourteen" | The item count is **fourteen**                                                                                                                                             | `10-security-checks`                               |
| **The assessment and QA plan headers read "3 of 11 SP"**                                                                 | The story is **5 SP** and SPRINT-05 is **13 / 11 at grace**, both since the re-estimate of 17/09/2026                                                                      | `10-security-checks` and `11-qa-checks`            |

**One citation of a citation is also off by one, and it is in the bullet about line drift.**
`../02-STORIES/US009.md` reports the map's `.copier/README.md:436` reference as sitting at
`../01-FEATURE-MAPS/MAP-GATE-PARITY.md` `:326`; it is at **`:325`**. The map also carries a second,
dated re-measurement at **`:504`** — "`:436` then, `:441` today, re-measured 17/09/2026" — and
`:504` is the one `f045aac` actually invalidated. Neither is edited by this story.

**Four of the seven moved in the same commit, and none is a defect in the story.** `f045aac` —
the Playwright-pin change of 18/09/2026 — edited both `lefthook.yml` and `.copier/README.md`. The
story's citations were **correct at the commit it measured against**, which is the whole reason
`../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`'s rule exists: **re-resolve
by quoted text, never trust the number**. This plan carries the numbers as at `f045aac` and expects
them to move again.

---

## Sprint Verification Checklist

- [ ] `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <each changed .md>` — clean
- [ ] `bash code/src/scripts/syntax/format.sh --fix` scoped to the changed paths — clean
- [ ] `bash code/src/scripts/audits/doc-references.sh --path <each changed file>` — exit 0
- [ ] `bash code/src/scripts/audits/doc-references.sh` whole tree — compared to P0 **by identity**,
      not by count
- [ ] `bash code/src/scripts/audits/docs-length.sh --path code/src/scripts/development/CONTEXT.md` — under 300
- [ ] `bash code/src/scripts/audits/docs-pairing.sh --path code/src/scripts/development` — clean
- [ ] **ShellCheck by hand** over "install-hooks.sh" and the changed `install.sh`, recorded as run
      or not run — **never as a `lint.sh` pass**
- [ ] The `[3/4] Template Generation` job green on both `INCLUDE_MOBILE` poles
- [ ] `bash code/src/scripts/syntax/check.sh` — **`N/A`, recorded with its reason**: no Python,
      TypeScript or Rust in the diff, and its Python leg needs a stack this story never starts
- [ ] The new ".github/workflows/audit-hook-arming.yml" green: pre-commit positive (fixture A,
      **`env -u CI`**), no-`.git` negative (C), worktree (A), unborn HEAD (B), `postinstall` ×4,
      `--ignore-scripts` ×3, no-`prepare`, PA-01 and PA-02
- [ ] The `template-integrity` pre-commit leg (`lefthook.yml:229-242`) still passes
- [ ] The three manual walk-throughs run in a **scratch clone** and signed off by someone other
      than the author
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **`N/A`, recorded with its reason**: no
      Python in the diff
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] `how-to/src/CONTRIBUTING.md` confirmed **unmodified**; `.copier/README.md` modified **only**
      at `:1085` and its scripts table — `:442`, the claim this story makes true, confirmed
      untouched

---

## Definition of Done

- [ ] "code/src/scripts/development/install-hooks.sh" exists, guards on `git rev-parse --git-dir`,
      runs `pnpm exec lefthook install`, reports what it wrote and what it replaced, and exits 2 on
      a genuine failure
- [ ] The root `install.sh` calls it as the **last** step of Phase 1, after `:517`
- [ ] `usage()` prints Phase 1 as steps 1–9 and Phase 2 as **10 and 11**, with the body headers at
      `:540` and `:580` agreeing — the pre-existing collision gone, not recorded
- [ ] `package.json` carries **no `prepare` script**, and its `postinstall` writes nothing outside
      stdout and is silent in all three stated cases
- [ ] `--ignore-scripts` confirmed on `install-frontend.sh:67`, `:84` and `:93` — **three of
      sixteen, and the assertion says so**; `install-frontend.sh` otherwise unchanged
- [ ] The three assertions are written per line and **neither depend on nor mask** `:79-81`
- [ ] `.copier/README.md:442` and `how-to/src/CONTRIBUTING.md:155` re-read and confirmed true, the
      re-reads recorded, and **neither line edited**
- [ ] `.copier/README.md:1085`'s `pnpm prepare` replaced, so removing the script does not leave a
      shipped instruction naming a command that no longer exists
- [ ] "code/src/scripts/development/install-hooks.sh" carries a header, a `usage()`, `--help`/`-h`
      and a `die` on an unknown option, and is committed at mode `100755`
- [ ] The probes live in ".github/workflows/audit-hook-arming.yml" calling
      "code/src/scripts/tests/hook-arming.sh"; the generation job keeps only the grep
- [ ] The `postinstall`'s swallow on `check-lockfiles.sh:147` is either fixed by writing to stderr
      or recorded as an accepted residual — **not left unexamined**
- [ ] `how-to/workflows/01-first-time-setup/STEPS.md` and
      `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md` carry the step; `how-to/docs/DEVELOPMENT.md` and
      `how-to/docs/CLI-TOOLING.md` recorded **`N/A` — neither enumerates `install.sh`'s steps**
- [ ] `code/src/scripts/development/CONTEXT.md` carries the tree line and the table row — **and
      `:6` is left alone**, its "three" counting toolchain installers rather than glob members
- [ ] All fourteen assessment constraints closed with evidence in the implementation assessment
- [ ] The twelve threats re-assessed against shipped code; the five promotion triggers restated
- [ ] The nine AC-GAPs verified closed in the shipped change
- [ ] `../01-FEATURE-MAPS/MAP-GATE-PARITY.md`'s `S-11` Slices row **confirmed still reading US009** — it was written at the 17/09/2026 split, so this is a check rather than an edit; its `Acceptance` cell is the part a close can still change
- [ ] **The `GAPS.md` row for the eleven unsuppressed `pnpm install` invocations is open** (§7.2's second limb), or its absence is restated as still owed — **never ticked as covered**
- [ ] Every gate above run and recorded per `code/docs/GATE-REPORTING.md`; nothing skipped silently
