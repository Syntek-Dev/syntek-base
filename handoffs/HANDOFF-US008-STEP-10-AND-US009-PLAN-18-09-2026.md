# HANDOFF — US008's plan is written and Step 9 is closed; Step 10 and the whole of US009's plan remain

**Written**: 18/09/2026 · **Branch**: `pm/story-creation` · **HEAD at writing**: `f045aac`
**Next workflow**: `project-management/workflows/17-story-plans/` — **Step 10 for US008, then Steps 1 to 11 for US009**

---

## Goal

Finish the `17-story-plans` gate for SPRINT-05. US008's plan
(`project-management/src/17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`) is written and
its adversarial review is closed; what remains is **Step 10's repointing for US008** and then
**US009's plan end to end**, whose three open decisions are already settled below. Nothing in this
session is committed.

---

## Done

### 1. US008's story plan — written, reviewed, gates green

`project-management/src/17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`, **1386 lines**,
copied from `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` and shaped on
`project-management/src/17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`.

| Field        | Value                                                                                                   |
| ------------ | ------------------------------------------------------------------------------------------------------- |
| Branch fixed | `us008/host-only-cookies` — confirmed by <%DEVELOPER_NAME%> 18/09/2026                                  |
| Status       | `Open` · Sprint line `SPRINT-05 · Wave 1 · build order 1`                                               |
| Phases       | **Six** — P0 baselines, P1 gate, P2 settings, P3 guides + edge clause, P4 preview repair, P5 migrations |
| Worktree     | `N = 8`, `127.0.0.8`, subnets `10.8.1.0/24` dev / `10.8.0.0/24` test                                    |

**Gate readings, 18/09/2026, scoped to the plan:**

| Gate                                                               | Result                                                                 |
| ------------------------------------------------------------------ | ---------------------------------------------------------------------- |
| `bash code/src/scripts/audits/doc-references.sh --path <the plan>` | **Clean — every citation resolves** (1066 tokens, 131 tested as paths) |
| `bash code/src/scripts/syntax/lint.sh --file-type markdown`        | **0 issues on the plan**                                               |
| `bash code/src/scripts/syntax/format.sh` · `prettier --check`      | **Clean**                                                              |

### 2. Step 9's adversarial review — three independent agents, 38 findings, all resolved

Dispatched on <%DEVELOPER_NAME%>'s explicit authorisation. Lenses: fidelity to source · citation
integrity and gate honesty · executability and sequencing. **Six were blocking.** The four that
changed the plan's substance:

- **The migration key was resolved wrongly and is now the sources' reading.** P5 writes the entry
  with its derived-at-release comment; the **key value is written at `24-release`** with
  `git tag --sort=-v:refname | head -1`. `--sort` is load-bearing — a bare `git tag` sorts
  lexicographically and calls `v7.9.0` newer than `v7.10.0`.
- **US008 now adds one line to `project-management/workflows/24-release/CHECKLIST.md`.** That
  workflow contains zero occurrences of `migration`, `copier` or `key` (measured 18/09/2026), so
  the obligation reached nobody. This is a **scope addition beyond the story's task list**, taken
  because it is the story's own `ADR-US008-MITIGATION-OWNS-ITS-CHANNEL` rule applied to itself.
- **P4's proof was unrunnable and is now specified.** `code/src/scripts/development/template-update.sh:102`
  refuses to run here — this repository's `.copier-answers.yml` is the Jinja template with **zero**
  `_commit:` literals. P4 needs a generated scratch project from a ref below `v3.0.0`, taken at a
  commit boundary because `:106` dies on a dirty tree, and expects **four banner lines from three
  advisories** (`.copier/migrations/v5.0.0-git-guide-split.sh` is declared twice in `copier.yml`,
  at `:889` and `:903`, deliberately).
- **P5 carries the `v7.6.0` tag prerequisite in its `Blocked by` cell**, with a concrete entry
  test, rather than only in prose.

### 3. US009's grilling pass — three decisions settled

Its story defers these to this workflow explicitly. All three answered by <%DEVELOPER_NAME%>
18/09/2026:

1. **The pre-commit probe's home** — extract the step into
   `code/src/scripts/development/install-hooks.sh`, called by `install.sh`, and probe **that**
   directly in CI. Chosen over a manual-only probe and over provisioning a runner for the whole
   `install.sh`.
2. **The `usage()` collision** — **renumber Phase 2 to 9 and 10**. Not left as a recorded
   collision, not renumbered phase-locally.
3. **The generated-project unborn-HEAD case** (assessment 7.11) — **cover it with a probe**, not
   write the assumption down and not guard the step.

---

## In-flight

**Nothing is half-written.** Two whole pieces of work remain, both unstarted.

### A. Step 10 for US008 — four cells and one bullet

| Anchor                                                            | Current text                                    | Becomes                                                 |
| ----------------------------------------------------------------- | ----------------------------------------------- | ------------------------------------------------------- |
| `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md:98`  | `_none yet — 08- reserved_` and `_not yet set_` | the plan's path, and `us008/host-only-cookies`          |
| `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md:104` | `_none yet — 09- reserved_` and `_not yet set_` | US009's plan path once written, and `us009/hook-arming` |
| `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md:464` | `_not yet set_`                                 | `us008/host-only-cookies`                               |
| `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md:465` | `_not yet set_`                                 | `us009/hook-arming`                                     |
| `project-management/src/02-STORIES/US008.md:374`                  | "**No story plan is cited yet.**"               | cite the plan, in the form US006 and US007 use          |

Nothing is added to `project-management/src/17-STORY-PLANS/CONTEXT.md` — it ships and holds no
index by recorded decision.

### B. US009's story plan — not started

Filename `project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`, prefix `09-`
reserved. Branch `us009/hook-arming`, confirmed. `N = 9`, `127.0.0.9` **measured free 18/09/2026**
(zero tracked hits), subnets `10.9.1.0/24` dev and `10.9.0.0/24` test. Status `Open` — no blockers.

**Three facts <%DEVELOPER_NAME%> asked to be carried into that plan as stated content, not
footnotes:**

1. **`lefthook.yml:66-69` has drifted to `:73-76`** in the working tree — an uncommitted 8-line
   insertion on this branch. The citation was **correct at HEAD when the story measured it**, so
   the plan records the drift and does not "correct" the story.
2. **`code/src/scripts/development/install-frontend.sh:79-81`'s `sudo rm -rf` defect is live** —
   line 80's trailing `\` makes `log` and `Removed.` arguments to `rm -rf`. This is the concrete
   reason assessment 7.6 demands the three `--ignore-scripts` assertions neither depend on nor
   mask it: `:84` sits immediately past the block, so a QA pass reading only the asserted lines
   walks straight by. `GAPS.md`'s row of 11/09/2026 owns the defect; US009 does **not** fix it.
3. **`ASSESSMENT-PLAN-US009-HOOK-ARMING.md` Section 7 opens "Eleven constraints" and lists
   fourteen** (7.1 to 7.14), closing "None of the fourteen". Record it the way US008's plan records
   the 298-versus-299 figure: the item count is fourteen, and correcting the opening line belongs
   to `10-security-checks`.

**Also settled and not to be re-derived:** the `lefthook install` failure mode is **already decided**
(threat model Section 4a Q2 — step at the end of Phase 1, hard fail kept, which then costs nothing);
the guard is `git rev-parse --git-dir` (ST07); the binary is `pnpm exec lefthook install` (ST03 —
`lefthook` confirmed **not** on `PATH`, `node_modules/.bin/lefthook` present); 16 executable
`pnpm install` invocations, **5** carrying `--ignore-scripts`, **11** without.

**State the SP consequence out loud.** Decision 1 adds `install-hooks.sh` and its row in
`code/src/scripts/development/CONTEXT.md`, which the story's task list does not carry. The plan
holds US009 at **5 SP as a stated wide 5**, the way US008's estimate comment holds its 8 — the
logic is the same logic in a different home, SPRINT-05 is already at the 13/11 grace ceiling, and
Fibonacci offers nothing between 5 and 8 for one extra file.

---

## Next

**Run Step 10 for US008 first** — the five anchors in section A above — then
`project-management/workflows/17-story-plans/` Steps 2 to 9 for US009, then Step 10 for US009, then
Step 11's commit.

---

## Next skills

`planner` for US009's drafting · `global-workflow` for naming and Markdown style · `git` for the
Step 11 commit. **No stack skill applies to US009** — it ships bash and one manifest edit, and its
`Backend` flag reads `N/A`. Step 9's reviewers are dispatched through the Agent tool as
`general-purpose`, naming the skill to load in the prompt; <%DEVELOPER_NAME%> authorised that
dispatch on 18/09/2026 and the authorisation should be re-confirmed for US009.

---

## Open questions

1. **Does US009's plan get the same three-reviewer Step 9 pass?** US008's found six blocking
   defects, so the value is demonstrated — but it is <%DEVELOPER_NAME%>'s call and a fresh session
   holds no standing authorisation. If it is declined, each plan records the review as **not run**
   per `code/docs/GATE-REPORTING.md`; do not write it up as passed.
2. **Is the `24-release/CHECKLIST.md` line accepted?** It was flagged as a scope addition beyond
   US008's task list and not explicitly ruled on. If declined, the gap must be filed instead — the
   key otherwise has no channel that reaches the workflow which writes it.

---

## Artefacts, by path

| Path                                                                                              | What it is                                                                      |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `project-management/src/17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`                  | The finished plan — read its _Key Decisions_ before changing anything           |
| `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`                           | The superset to copy for US009 — ★ always, ◇ if the concern applies             |
| `project-management/src/17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`                      | The house shape; US008's plan follows it                                        |
| `project-management/src/17-STORY-PLANS/CLAUDE.md`                                                 | The `<exec-order>` prefix rule                                                  |
| `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`                                     | The two tables Step 10 repoints                                                 |
| `project-management/src/02-STORIES/US009.md`                                                      | The story — its FLAGS comment names the decisions deferred to this workflow     |
| `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`     | The one ADR binding US009                                                       |
| `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md`                              | Nine AC-GAPs, all `[RESOLVED] 17/09/2026`                                       |
| `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` | Twelve threats; Section 4b's eight constraints; Section 3a's promotion triggers |
| `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md`    | Section 7's fourteen constraints — see the stale header above                   |
| `code/docs/GATE-REPORTING.md`                                                                     | Why every `N/A`, every zero and every un-run review is stated                   |
| `code/docs/FORWARD-VOICE.md`                                                                      | Why a path that does not exist yet is written in double quotes, never backticks |

---

## Context the next session should not re-derive

- **HEAD moved again during this session.** A parallel session committed `f045aac`
  (Playwright pin) at 09:21 and was **still editing at 09:38** —
  `code/src/scripts/audits/CONTEXT.md`, `.copier/README.md`,
  `how-to/src/TEMPLATE-GUIDE/15-TROUBLESHOOTING.md`, `.claude/CLAUDE.md`, `.claude/MEMORY.md` and
  others carry its uncommitted content. **Check `git status` before assuming any of it is yours.**
- **I ran `format.sh --file-type markdown --fix` repo-wide rather than scoped, while that session
  was live.** No whitespace-only damage is visible — every changed file carries content changes
  that are theirs — but it could not be proved clean. **Scope every gate to your own paths.**
- **The previous handoff is gone.** `handoffs/HANDOFF-STORY-PLANS-US008-US009-17-09-2026.md` was
  `git add -N`'d only, so its content never entered git, and the parallel session deleted the
  working-tree file. Nothing is lost that is not restated here.
- **`code/src/scripts/audits/CONTEXT.md` is at 299 of 300, not 298**, and `f045aac` rewrote it by
  43 lines to pay for a new register row out of compression. The `negative-space.sh` row is at
  **`:174`, not `:170`** — and `project-management/src/02-STORIES/US008.md:876` carries the same
  wrong pointer. Re-read the file at P0 rather than inheriting any figure.
- **`v7.6.0` is still NOT tagged.** 77 tags, newest `v7.5.0`, `git tag --points-at 16aac54` empty.
  Two binding records say otherwise in passing —
  `project-management/src/02-STORIES/US008.md:675` and
  `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md:145` — and
  both contradict themselves elsewhere. `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md:175`
  has it right: "**must be** tagged". US008's plan carries that form and names the slip.
- **`code/src/scripts/audits/negative-space.sh` defines twelve clauses; `EXPECTED` holds eleven**,
  omitting `register-absent`. US008 grows `EXPECTED` to fourteen and leaves that omission alone —
  closing it would make the target fifteen and fail the plan's Definition of Done.
- **ShellCheck has no project script**, and it **is** on this host's `PATH`. Both SPRINT-05 members
  ship bash; run it by hand and record it as run or as not run, never as a `lint.sh` pass.
- **The citation gate reads an untracked file as shipping** — `build_template_only()` uses
  `git ls-files`. `git add -N` before measuring, **and again at close**, which is where it bites.
