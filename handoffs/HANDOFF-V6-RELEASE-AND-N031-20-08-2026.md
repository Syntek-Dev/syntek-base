# HANDOFF — two branches shipped and pushed; the rebase and the tag decision remain

**Written**: 20/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `2b1a5bf` · **Pushed**: yes
· **Tree**: clean · **Second worktree**: `../syntek-base-v6` on `pm/v6-rename-feature-surfaces`
at `c155801`, **committed and pushed, tree clean**

## Goal

Resolve `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` one sitting at a time. This
session settled **N-037** and moved **N-042**, and in parallel finished and shipped the **v6.0.0
rename** on its own branch. **Both branches are committed and pushed; nothing is uncommitted
anywhere.** The next session **rebases `pm/v6-rename-feature-surfaces` onto `pm/base-health-map`**,
resolves the version-document conflicts, and decides whether a `5.6.0` tag is cut at all.

Frontier now **19 open · 0 blocking · 40 resolved** — recounted from the tables, `19 + 40 = 59 =
N-059`. Per batch: A 0 · B 4 · D 4 · E 7 · unbatched 4.

## Done

Eight commits on `pm/base-health-map`, all pushed, **every one through lefthook without
`--no-verify`** — which ends the three-commit streak that preceded them.

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
- **`../syntek-base-v6/CHANGELOG.md` says the bump is from `5.5.0`, and that is CURRENTLY TRUE.**
  `pm/base-health-map` was never bumped — `VERSION` there still reads `5.5.0` — so a rebase today
  leaves the claim correct. **It becomes false only if `5.6.0` is cut first**, which is Open
  Question 1. Decide the tag before the rebase, not after, because the changelog prose is a
  content edit and `git` will take both hunks happily and leave a false predecessor standing.
- **`REFERENCES.md` — edited on both branches.** Non-adjacent lines (the main branch added a
  `PROJECT-PATHS.md` row; the worktree fixed labels at `:124`, `:166`, `:209`), so the conflict is
  real but small.
- **No version bump on `pm/base-health-map`.** `VERSION` still reads `5.5.0` there, deliberately —
  <%DEVELOPER_NAME%> asked for commits without versioning.

## Next

**Settle Open Question 1 — is a `5.6.0` tag cut at all — and then rebase
`pm/v6-rename-feature-surfaces` onto `pm/base-health-map`.** The answer changes the changelog prose,
so it comes first. `doc-references.sh` is red on the v6 branch on five `PROJECT-PATHS.md` findings
and goes green the moment the rebase brings that file across; that red is expected and external.

## Then, in order

1. **Decide whether `5.6.0` is cut at all (Open Question 1).** If it is: MINOR, and the row is
   decidable without judgement:
   `CONTRIBUTING.md:200-203`, _"Adding a question with a default, a new guide, a new skill, a new
   workflow"_. Two new guides shipped (`FORWARD-VOICE.md`, `PROJECT-PATHS.md`). Nothing in the eight
   commits removes a question, a token, a routing contract, or an inherited directory.
2. **Rebase `pm/v6-rename-feature-surfaces` onto `pm/base-health-map`** — linear history on one
   branch, which is what v6-design Q12 wanted before a second worktree existed. Expect a conflict
   in `REFERENCES.md` on non-adjacent lines: this branch added a `PROJECT-PATHS.md` row, the v6
   branch fixed workflow labels at `:124`, `:166` and `:209`.
3. **Rewrite the v6 changelog entry ONLY IF `5.6.0` was cut**, to name the real predecessor. It
   is correct as it stands if it was not. Do not hand-merge version state either way: `.claude/skills/resolving-merge-conflicts/SKILL.md` names it as a file class that must
   not be merged blind.
4. **Tag and release** through `project-management/workflows/23-release/`. **No tag exists and none
   should be created before the rebase** — verified `git tag -l 'v6*'` is empty, 63 tags, latest
   `v5.5.0`.

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

`version` (the 5.6.0 bump and its whole file set) · `resolving-merge-conflicts` (the rebase and the
version documents) · `release` then `git` (tag and push) · `cicd` if the migration needs adjusting
after the rebase. Roster: `.claude/skills/CONTEXT.md`.

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

1. **Does the v6 branch rebase onto `5.6.0`, or does the 5.6.0 bump ride the same release?** The
   plan above assumes the former. If v6.0.0 ships immediately after, a separate 5.6.0 tag may not be
   worth cutting — <%DEVELOPER_NAME%>'s call, and it changes step 1.
2. **Prune `HANDOFF-FORWARD-VOICE-N037-N031-18-08-2026.md`?** Its work has resumed and completed, so
   `handoffs/CLAUDE.md` says prune. It is committed, so deletion is recoverable.
