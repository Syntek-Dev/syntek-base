# HANDOFF — MAP-BASE-HEALTH sittings

**Written**: 22/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `64c9aa9`
**Supersedes** the sitting-3 edition written at `8825224`, whose five in-flight items are now
**two discharged, two still open, and one re-framed after the word it was carried under turned
out to be wrong.**

## Goal

Resolve the open frontier of `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` —
syntek-base's register of open items against itself — in **sittings grouped by shared file**
rather than by defect batch. **The maintainer's standing instruction is that the map is completed
before this branch is proposed**, so the PR waits on the frontier. **Sittings 1 to 4 are settled
and committed. Two remain, plus three dispositions and the fog-of-war question.**

---

## Done

### Sittings 1, 2 and 3 — committed at `5d7d264`, `e3407cf` and `8825224`

N-044, N-052, N-031, N-060 charted (sitting 1); N-057, N-050, N-051 plus an 82-agent adversarial
review (sitting 2); N-054, N-048, N-020 (sitting 3), which produced **SL-2**, the first node
closed as _accepted_ rather than _fixed_. Detail is the _Session log_ rows on the map. **Do not
re-derive it here.**

### `2ff476e` — the two register items, this session

Both were **omissions no node had**, fixed in place rather than charted.

- **`audit-routing-skills.yml` gained its `ELIGIBLE FOR THE REQUIRED SET` block.** N-057 wrote
  the rule and rewrote three files to it; the fourth file that rule binds is the one N-057's own
  decision made load-bearing by adding `Routing skills resolve` to the set. Every claim in the
  comment was verified against the parsed YAML, not read off the file.
- **The `main` item now lives in `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`**, in the
  uncharted-entry slot — **not** `Standing limitations`, which takes only gaps closed as
  _accepted_. It carries an explicit **do-not-chart** and a **delete-when-the-merge-lands**
  instruction.

### `64c9aa9` — sitting 4: N-047 and N-059

Settled as one batch **because N-059's own charted text said so** — its open half was _"the same
question N-047 is typed `grilling` for, one decision in two sites; settle them together"_. Five
questions over two rounds. Six files. **Charted nothing.**

**The thesis: in both nodes the recorded reason was false, and correcting the reason changed the
remedy.**

| Settled   | How                                                                                                                                                                                                                                      |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **N-047** | `copier.yml` gains a **compensating `v4.0.0` key** beside the existing `v5.0.0` one, both running the same advisory. The script header moved in the same change                                                                          |
| **N-059** | The measured order-sensitivity rule replaces the false one at `lefthook.yml:116-118`; `CHANGELOG.md` and `VERSION-HISTORY.md` corrected **in place**; **no gate**, because the rule condemns a population of zero — Batch B's own defect |

**N-047's central objection did not survive measurement.** The node said re-keying _"rewrites
what a published tag meant"_. It does not: `copier update` checks out the target tag and reads
`_migrations` from **HEAD**, so a key is a forward-evaluated predicate, not a historical record.
With copier's documented trigger rule — fire when `old_version < key <= new_version` — **the
node's own first option was the only one that breaks a population currently served**: a project
in the `v4.0.0`–`v4.1.1` band is reached today by the `v5.0.0` key and would have been reached by
nothing. Hence two keys, not one.

**N-059's mechanism was re-driven, not inherited.** A 2×2 through pinned lefthook **2.1.10** in a
scratch repo reproduced every charted claim: braces expand, `/` inside a group works, and what
silently mis-compiles is a **multi-alternative group whose wildcard-bearing alternative is not
last**.

**Anchor drift on both nodes — the fourth and fifth on this map.** `copier.yml:641` → `:694` ·
`CHANGELOG.md:263` → `:357` · `VERSION-HISTORY.md:21` → `:24`. Only `lefthook.yml:116-118` held.
The new lefthook comment therefore cites its sibling legs **by name, not by line**.

**Counts recounted from the tables and verified by script**: **9 + 51 = 60 = N-060**, no overlap,
no duplicates. Per batch: A 0 · B 3 · D 1 · E 4 · unbatched 1.

**Gates at both commits**: docs-length · docs-pairing · doc-references · copy-emdash · copy-slop ·
template-orphans · template-slop · stubs · conflict-markers · seam-contract · doctrine-drift ·
routing-skills · skill-conformance · the three `--self-test`s · check-template-tokens ·
shipped-readme · shipped-memory · check-template-parsers · `syntax/lint.sh` (markdownlint **0
issues in 808 files**) · `syntax/check.sh` · `format.sh` dry-run — **all exit 0**.

---

## In-flight

### 1. `64c9aa9` is NOT pushed

`origin/pm/base-health-map` tracks **`2ff476e`**; HEAD is **`64c9aa9`**, one commit ahead.
`gh pr list --head pm/base-health-map` returns nothing. `project-management/docs/git/COMMITS.md`
→ _Before Every Push_ wants `code/src/scripts/tests/backend.sh` green first — **that suite was
not run this session.**

### 2. The `_migrations` addition is a contract change and no release note exists

`copier.yml`'s new `v4.0.0` entry is **functional**, not documentation — it changes which updates
fire the advisory. Neither commit bumped the version, on the branch's standing instruction.
**Whoever cuts the release that ships this branch must account for it in the increment.** Flagged
in `64c9aa9`'s message and nowhere else.

### 3. The branch-protection ruleset has NOT moved, and that is still deliberate

Ruleset `20221742` held **20 contexts** at last measurement. The maintainer applies the flip
**after the PR merges**.

- **Target: 22.** Remove `Audit JS + Python dependencies`; add `[8/8] Security`,
  `Routing skills resolve`, `Unresolved conflict-marker audit`.
- **Four names carry an em dash, not a hyphen** — `Ruff — Lint`, `Ruff — Format`,
  `basedpyright — Typecheck`, `TruffleHog — Secrets Scan`. Pick them from the search box.
- **The sandbox classifier refuses `gh api PUT`. Do not burn turns on it.**
- Nothing in the tree asserts the flip has happened, so no wording depends on the timing.

### 4. Discharged — the eligibility line and the `main` item

Both were items 1 and 3 of the previous edition. **Fixed at `2ff476e`** — see _Done_.

**One correction rides with the second, and it matters more than the fix.** `main` was carried as
a **reconciliation** by four consecutive handoffs. It is not one:
`git merge-base --is-ancestor main HEAD` **succeeds**, so no commit on `main` is absent from here.
Measured 22/08/2026: **88 behind, 0 ahead**, `a1e0f68` / `v3.2.2` against `6.0.0`, three MAJORs
stacked. The merge is a **fast-forward**. The standing instruction not to absorb `main` was never
deferring work — there is none — and reading it as a deferral is what kept the item alive.

---

## Next

**Open sitting 5** — `/wayfinder resolve` on the map, nodes **N-056 + N-058**.

**Read the collision entry first** (`MAP-BASE-HEALTH.md:2554`, _Batch E_ collision table): sitting
5 shares `.claude/skills/git/SKILL.md` with sitting 2. **N-051's half is already settled there**
(`:60-62` now routes to `VERSIONING-GUIDE.md`); **N-058's half is open**. Do not re-fix N-051's.

**N-058's anchors, measured 22/08/2026 — and its population needs settling before its remedy:**

| Site                                                     | Reading                                                                                                                            |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `.claude/skills/git/SKILL.md:76`                         | `bash .claude/hooks/pre-pr-check.sh` — **bare**, and still at `:76`; the only charted anchor in five sittings that has NOT drifted |
| `how-to/workflows/06-quality-gates/CHECKLIST.md:49`      | `bash .claude/hooks/pre-pr-check.sh` — **bare**; the likely second member                                                          |
| `how-to/workflows/07-dependency-updates/CHECKLIST.md:34` | `pre-pr-check.sh` green end to end — prose, no `bash`; a **third candidate** the node's "two" does not account for                 |
| `.claude/skills/git/SKILL.md:134`                        | A reference-list mention, not an invocation — decide whether N-058 owns it                                                         |

The correct form pipes JSON — `how-to/workflows/06-quality-gates/STEPS.md:122` and
`07-dependency-updates/STEPS.md:117` both show it. **N-056's subject** includes
`code/src/scripts/development/sync-trees.sh`, which exists and has no exit case for "matched
nothing".

### The remaining plan

| #   | Nodes                         | Surface                                                                              |
| --- | ----------------------------- | ------------------------------------------------------------------------------------ |
| 5   | N-056 + N-058                 | `audits/*.sh` · `sync-trees.sh` · the bare invocations — **collides with sitting 2** |
| 6   | N-023 + N-039 + N-045 + N-049 | **not disjoint** — N-049 shares `VERSIONING-AND-DOCS.md` with sitting 2              |

**Three dispositions, not sittings** — the map cannot reach its Destination without them:
**N-021** and **N-026** (parked; both have unmeasured premises) and **N-060** (unscheduled).
**SL-2 is the worked precedent** for closing one as _accepted_.

**Also required for Destination:** _Fog of war_ must be empty. **Sitting 4 moved its premise
without answering it** — the unbatched residue fell from three to one, so the _"settle it before a
fifth joins them"_ argument has receded rather than been resolved. This is recorded on the map so
a smaller residue is not mistaken for a decided question. Nobody is scheduled against it.

---

## Next skills

`wayfinder` (RESOLVE) → `grill-with-docs` → `doc-writer` for sitting 5; it also wants
`code-reviewer` for the `audits/*.sh` half. Sitting 6 wants `doc-writer`. The PR, when the
frontier is empty, runs `git` then `pr`.

---

## Artefacts by path

- `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` — the header count paragraph, the
  batch tables, the collision table in _Batch E_ (`:2554`), and the **four** _Session log_ rows
  dated 21–22/08/2026
- `copier.yml` → `_migrations:` — the compensating `v4.0.0` entry, the trigger rule and the
  accepted duplicate-report cost, all stated inline; the `v6.0.0` entry already cited N-047
- `.copier/migrations/v5.0.0-git-guide-split.sh` — header records that it is keyed twice and why
  the filename keeps `v5.0.0`
- `lefthook.yml:116-118` — the measured order-sensitivity rule, naming `a05b1c7` so the
  `git log -S` reader is routed out of the one immutable surface
- `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` — `## Standing limitations` holds SL-1 and SL-2;
  the `main` entry sits **below** them in the uncharted slot, marked do-not-chart
- `.github/workflows/audit-routing-skills.yml` — the eligibility block added at `2ff476e`
- `project-management/docs/git/COMMITS.md` → _Before Every Push_ ·
  `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md` → _Changing the set_ — the only in-repo
  detector that the ruleset flip happened

## Open questions

- **Do N-021 and N-026 close as accepted, following SL-2?** Sitting 3 established the mechanism
  and deliberately did not apply it; both still have unmeasured premises.
- **`doc-references.sh` is claimed by three maps** — this map's N-060, `MAP-NAVIGATION`'s N-004,
  and `MAP-RULE-OWNERSHIP`'s N-009/N-011. Nobody has asked whether they are one change.
- **Does `MAP-RULE-OWNERSHIP` stay separate?** It declines to be folded in; the measured cost of
  that split is on this map.
- **Who schedules the taxonomy question?** It is the last fog-of-war item and blocks Destination.
- **Ruled and recorded, not open:** the sub-package version tracks
  (`code/src/django/`, `code/src/mobile/`) stay at `0.1.0`. `code/src/django/` has taken 20
  commits since its row, including a whole new app, but the maintainer ruled these are **seeds
  for a generated project** — only the root track is versioned here. In the session log so it is
  not re-found.
