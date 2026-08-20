# HANDOFF — two branches shipped and pushed; the tag is decided, the rebase remains

**Written**: 20/08/2026 · **Versioning settled**: 20/08/2026 · **Branch**: `pm/base-health-map` ·
**HEAD**: `1877c3b` · **Pushed**: yes · **Tree**: clean · **Second worktree**: `../syntek-base-v6`
on `pm/v6-rename-feature-surfaces` at `c155801`, **committed and pushed, tree clean**

## Goal

Resolve `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` one sitting at a time. This
session settled **N-037** and moved **N-042**, and in parallel finished and shipped the **v6.0.0
rename** on its own branch. **Both branches are committed and pushed; nothing is uncommitted
anywhere.** The next session **writes the `[Unreleased]` changelog prose**, then **rebases
`pm/v6-rename-feature-surfaces` onto `pm/base-health-map`**, reconciles the version documents, and
tags **`v6.0.0`**.

**`5.6.0` is NOT cut. Settled 20/08/2026 — the reasoning is _The versioning decision_ below, and it
supersedes what the first draft of this handoff proposed.**

Frontier now **19 open · 0 blocking · 40 resolved** — recounted from the tables, `19 + 40 = 59 =
N-059`. Per batch: A 0 · B 4 · D 4 · E 7 · unbatched 4.

## Done

Eight commits on `pm/base-health-map`, all pushed, **every one through lefthook without
`--no-verify`** — which ends the three-commit streak that preceded them.

> **This list is a session record, not a release range — do not size a version bump from it.** It
> counts from the branch fork at `84ebd50`. A tag counts from the previous tag, `v5.5.0` at
> `b4f00db`, which is **seven commits earlier**. See _The versioning decision_.

- **`84ebd50`** `docs(code)` — `FORWARD-VOICE.md` had shipped in `785705e` and was indexed in
  **none** of the three surfaces a code guide is indexed in. Cleared two red gates.
- **`6c920b1`** `feat(docs)` — the register `how-to/src/PROJECT-PATHS.md` (**three rows**) and the
  `code/src/django/*` arm, landed together because neither is green without the other.
- **`a6e90d3`** `fix(docs)` — components placement settled; `COMPONENTS` wired into
  `code/src/django/config/settings/base.py`; two CSS audits stopped reporting a clean run over
  nothing.
- **`3b87426`** `fix(skills)` · **`ea78457`** `fix(docs)` · **`797e2a5`** `fix(pm)` ·
  **`d9fcca8`** `fix(scripts)` — the four-surface sweep.
- **`692ad63`** `fix(scripts)` — `lint.sh` stopped reporting an absent system library as a lint
  defect in our code.
- **`61c4560`** `docs(pm)` — the map closeout.

**Verification not to repeat**: `doc-references.sh` clean with the arm live (my own run,
`GATE_EXIT=0`, on exactly the pushed content) · `--self-test` 7 probes · `backend.sh` **72 passed**,
the exact pre-change baseline · `ruff`, `ruff format`, `basedpyright` all clean on `base.py` ·
`docs-length` 755 files · `skill-conformance` 64 skills · `routing-skills` 585 names.

## In-flight

**Nothing is mid-edit anywhere — both trees are clean and both branches are pushed.** What follows is not half-done work but the state the rebase has to reconcile.

- **`../syntek-base-v6` at `c155801` — committed and pushed, 33 files, tree clean.**
  `.copier/migrations/v6.0.0-rename-feature-surfaces.sh` (24.6 KB, mode 755, **24** mutation-proven
  self-test assertions) · `copier.yml:724` carries the `v6.0.0` `_migrations` entry · `VERSION`
  reads `6.0.0` · labels and roster prose swept. The v6 design record is now durable: the
  `CHANGELOG.md` `[6.0.0]` entry and the migration script's header, both committed.
- **`../syntek-base-v6/CHANGELOG.md` says the bump is from `5.5.0`, and that now stays TRUE.** No
  `5.6.0` is cut, so the predecessor it names is correct and needs no edit — Open Question 1 is
  closed, and this bullet's warning with it. **It still needs WIDENING, for a different reason**:
  the `[6.0.0]` entry describes the trunk plus itself, so the eleven `pm/base-health-map` commits
  would ship inside the `6.0.0` release with no prose anywhere. `git` takes that hunk happily
  during the rebase; widen it deliberately afterwards, from the `[Unreleased]` section.
- **`REFERENCES.md` — edited on both branches.** Non-adjacent lines (the main branch added a
  `PROJECT-PATHS.md` row; the worktree fixed labels at `:124`, `:166`, `:209`), so the conflict is
  real but small.
- **No version bump on `pm/base-health-map`.** `VERSION` still reads `5.5.0` there, deliberately —
  <%DEVELOPER_NAME%> asked for commits without versioning. **It stays that way**: the bump lands
  once, as `6.0.0`, carried in by the rebase and reconciled on top.
- **`CHANGELOG.md` has no `[Unreleased]` section on either branch** — grepped 20/08/2026, there is
  none. Twelve of the fifteen unreleased commits have changelog prose nowhere. This is the first
  work of the next session, not a closeout chore.

## Next

**Write the `[Unreleased]` section of `CHANGELOG.md`, covering all fifteen commits in
`v5.5.0..pm/base-health-map`.** The `version` skill treats the changelog as the **input** to a bump
rather than a by-product, so it comes before the rebase and before any version file moves.

`doc-references.sh` is red on the v6 branch on five `PROJECT-PATHS.md` findings and goes green the
moment the rebase brings that file across; that red is expected and external. **Re-verified
20/08/2026**: `how-to/src/PROJECT-PATHS.md` is present on `pm/base-health-map`, absent on
`pm/v6-rename-feature-surfaces`, and `6c920b1` (which creates it) is not an ancestor of the v6
branch — so replaying `c155801` on top of this branch clears the red with no edit.

## The versioning decision — settled 20/08/2026

**One jump: `5.5.0` -> `6.0.0`. No `5.6.0`.** This reverses step 1 as this handoff first wrote it.

**What was wrong with the `5.6.0` proposal.** Its justification — _"nothing in the eight commits
removes a question, a token, a routing contract, or an inherited directory"_ — is **true of those
eight commits and irrelevant to a tag**. It counted from the branch fork at `84ebd50`; a tag counts
from `v5.5.0` at `b4f00db`, **seven commits earlier**. The excluded range is where the break lives.

**What forces MAJOR — and it is already inside this branch.** `785705e refactor(docs)`, an ancestor
of **both** branches, moves four directories a generated project inherits:

| From                                       | To                                             |
| ------------------------------------------ | ---------------------------------------------- |
| `.claude/skills/feature/`                  | `.claude/skills/implement-story/`              |
| `code/workflows/01-new-feature/`           | `code/workflows/01-implement-story/`           |
| `project-management/workflows/01-feature/` | `project-management/workflows/01-feature-map/` |
| `project-management/src/01-FEATURE/`       | `project-management/src/01-FEATURE-MAPS/`      |

`CONTRIBUTING.md:204` — _"Moving or deleting a directory a generated project inherits"_ — **MAJOR**.
The commit's own message says so unprompted, citing `CONTRIBUTING.md:208` for the mandatory
`_migrations:` entry. `code/docs/FORWARD-VOICE.md` was also **added** in that excluded range, so one
of the two new guides cited for the MINOR was never in the eight either.

**Why `5.6.0` is not merely understated but unsafe.** Cutting it at this HEAD would:

- label four moved inherited directories as MINOR — recoverable only by a further release
  (`project-management/docs/VERSIONING-GUIDE.md`, _Recovering from a Wrong Release_, line 145);
- **cross no migration.** `.copier/migrations/` on this branch holds v2/v3/v4/v5 only; the `v6.0.0`
  script exists solely on `pm/v6-rename-feature-surfaces`. Every existing project would strand
  files for one release between the break and its rescue — N-042's fault class, at template scale.

**Why one jump and not an intermediate.** A MAJOR absorbs the MINOR content (`FORWARD-VOICE.md`,
`PROJECT-PATHS.md`, the `doc-references.sh` django arm) and the PATCH-class gate repairs. Semver
does not require the skipped numbers to exist, and no intermediate is safely cuttable: every commit
at or after `785705e` already carries the break.

**The alternative, if a rename-only `6.0.0` is wanted** — reverse the rebase direction: reorder
`6c920b1` below `c155801`, tag `6.0.0` there, cut `6.1.0` at the tip. Buys a tidier boundary and
makes `c155801`'s `5.5.0 -> 6.0.0` claim true untouched; **costs a commit reorder on an
already-pushed branch**, and saves none of the changelog work. Not recommended.

**One claim in `c155801`'s commit message is stale — do not re-copy it into the release note.** It
records _"git diff --stat v5.5.0..HEAD over code/src/django, mobile, rust and pyproject.toml is
empty"_, measured at the fork. On `pm/base-health-map` it is false: `a6e90d3` changed
`code/src/django/config/settings/base.py` by 61 lines.

**Sub-package: nothing owed, despite that.** Precedent is unambiguous — `47e84cf` built the whole
`apps.health` surface, shipped in **`v4.0.0`** (first tag containing it; `git tag --contains`,
verified 20/08/2026), and `code/src/django/CHANGELOG.md` is still `0.1.0`, as is `pyproject.toml`.
That track is seeded for the generated project, not moved by the template. `mobile` likewise
`0.1.0`.

## Then, in order

1. **Write `[Unreleased]` in `CHANGELOG.md`** for all fifteen commits in
   `v5.5.0..pm/base-health-map` — the _Next_ action above, and the input the bump reads.
2. **Rebase `pm/v6-rename-feature-surfaces` onto `pm/base-health-map`** — linear history on one
   branch, which is what v6-design Q12 wanted before a second worktree existed. Expect a conflict
   in `REFERENCES.md` on non-adjacent lines: this branch added a `PROJECT-PATHS.md` row, the v6
   branch fixed workflow labels at `:124`, `:166` and `:209`. **Do not hand-merge version state** —
   `.claude/skills/resolving-merge-conflicts/SKILL.md` names it as a file class that must not be
   merged blind.
3. **Widen `c155801`'s `[6.0.0]` changelog entry** to absorb `[Unreleased]`. Its `5.5.0`
   predecessor claim needs **no** edit; the missing eleven commits do.
4. **Reconcile the version file set at the new tip.** `VERSION` already reads `6.0.0` from
   `c155801`; `VERSION-HISTORY.md`, `RELEASES.md` and every `**Version**: 5.5.0` metadata header on
   a file touched by `pm/base-health-map` do not. Run through the `version` skill, not by hand.
5. **Tag `v6.0.0` and release** through `project-management/workflows/23-release/`. **No tag exists
   and none should be created before step 2** — verified `git tag -l 'v6*'` is empty, 63 tags,
   latest `v5.5.0`.

## Chart, do not do

- **N-031 is unblocked and not settled.** `Citations resolve` is green, so its PR is no longer
  blocked at a required check. Direction B — reading `copier.yml`'s `_exclude` and comparing it
  against citations — is its remaining work, and `is_exempt()` was deliberately left untouched.
- **`code/docs/discoverability/CONTEXT.md:27`** declares a deliberate dangle in **prose**. That is
  Direction B's precedent case and should carry `doc-references: template-only` instead.
- **`syntax/check.sh` cannot type-check Rust on a host without `fontconfig`** — it reports
  `3, could not run`, correctly. CI installs `libfontconfig-dev`; local is blind until
  `nix shell nixpkgs#fontconfig`.
- **`cloc` is a hard dependency of `docs-length.sh` that nothing in this repository installs** —
  not `install.sh`, no nix file, no npm package. It is on this host now; that is a property of the
  disk, which is N-042's fault class in a second script.

**Carried forward from `HANDOFF-FORWARD-VOICE-N037-N031-18-08-2026.md`, which is pruned with this
session.** Its third item was fixed today rather than carried; these two remain:

- **`--self-test` covers the NEW clauses only.** The two checks that shipped before them — dangling
  path and instance citation — have no probe, including the fresh-checkout behaviour that produced
  N-042. The script prints this on every run (`doc-references.sh:486`) rather than leaving a reader
  to infer it, so it is a stated gap and not a hidden one.
- **The `copier.yml` self-citation sweep — 33 shipped files**, re-measured 20/08/2026 (the earlier
  handoff said 32). `copier.yml` excludes itself, so every one of those sentences dangles
  downstream. **This is Direction B and therefore N-031's**, not a separate task.
- ~~`.github/workflows/audit-doc-references.yml:19` claims it is "not a required status check"~~ —
  **fixed 20/08/2026.** Measured against the live API before editing: `Citations resolve` is one of
  the **20** required contexts on ruleset `20221742`.

## Next skills

`version` (the `[Unreleased]` prose **first**, then the whole `6.0.0` file set) ·
`resolving-merge-conflicts` (the rebase and the version documents) · `release` then `git` (tag and
push) · `cicd` if the migration needs adjusting after the rebase. Roster:
`.claude/skills/CONTEXT.md`.

## Standing duties this map imposes

- **Recount from the tables, never from prose** — and this session found the map breaking its own
  rule: `N-042` was fixed on 18/08 and its row left in the open Batch B table for two days, so every
  count taken since was over by one.
- **Re-verify before acting, including a node's own facts.** Six register candidates were proposed;
  **four were killed by an adversarial reader** for naming no creator.
- **A claim measured once is not measured forever.** A `doc-references.sh` run started before an
  edit lands measures a tree that no longer exists; one such run was discarded this session for
  exactly that.
- **New this session:** three consecutive passes each fixed false claims **and introduced new
  ones** — 34 findings, then 10 more from the remediation, then 15 survivors. Only a reader who had
  not done the work ever caught them.

## Artefacts

- `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` — N-037 and N-042 in _Resolved
  decisions_, the residue charted, three 20/08 session-log rows
- `code/docs/FORWARD-VOICE.md` · `how-to/src/PROJECT-PATHS.md` — the rule and the register
- `code/src/scripts/audits/doc-references.sh` — the arm, `is_registered()`, the line-anchor peel,
  `--self-test`
- `code/src/scripts/audits/fixtures/doc-references/` — the six fixtures
- `code/src/scripts/rust/_common.sh` — the cargo classifier, one home
- **Both prior handoffs were pruned with this session, and this is the only one left.**
  `handoffs/CLAUDE.md` says prune once the work has resumed, and both had. Neither pruning lost
  anything — that was checked rather than assumed:
  - `HANDOFF-FORWARD-VOICE-N037-N031-18-08-2026.md` — its three "chart, do not do" items were all
    still live. Two are carried into _Chart, do not do_ above; the third was fixed today.
  - `HANDOFF-V6-RENAME-FEATURE-SURFACES-18-08-2026.md` — it warned that `/grill-me` recorded
    nothing, so it WAS the record of thirteen decisions. **Twelve of the thirteen now live in
    better homes**: `CHANGELOG.md` `[6.0.0]` in the worktree carries Q1's plural-artefact-noun
    reasoning, Q2, Q3, Q5, Q8, Q10, Q11 and Q13 in its own voice, and the migration script's
    header carries Q4, Q5, Q6 and Q7. The thirteenth was Q12 — which branch to work on — which
    this session overrode anyway when the work moved to a worktree on its own branch.
  - **Both are recoverable if either judgement was wrong**:
    `git show 61c4560:handoffs/HANDOFF-V6-RENAME-FEATURE-SURFACES-18-08-2026.md`
- Commits `84ebd50` · `6c920b1` · `a6e90d3` · `3b87426` · `ea78457` · `797e2a5` · `d9fcca8` ·
  `692ad63` · `61c4560`

## Open questions

1. ~~**Does the v6 branch rebase onto `5.6.0`, or does the 5.6.0 bump ride the same release?**~~ —
   **closed 20/08/2026. Neither: no `5.6.0` is cut.** See _The versioning decision_.
2. ~~**Prune `HANDOFF-FORWARD-VOICE-N037-N031-18-08-2026.md`?**~~ — **already done.** It was pruned
   with this session; `handoffs/` holds only this file. The question contradicted this handoff's own
   _Artefacts_ section and should not have shipped open.
3. **Does `main` get reconciled before another MAJOR stacks on it?** It sits at `a1e0f68` / `v3.2.2`,
   **77 commits behind**, and every tag from `v4.0.0` to `v5.5.0` was cut on this branch line and
   never merged. No open PRs. Not a blocker for the sequence above — a decision of its own, and it
   grows by one MAJOR the moment `v6.0.0` lands.
