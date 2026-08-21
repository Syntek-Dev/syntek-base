# HANDOFF — MAP-BASE-HEALTH sittings

**Written**: 21/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `5d3c22f`
**Supersedes** the sitting-1 edition of this file, written at `5d7d264`.
**Rewritten after the review returned** — tree and live ruleset both re-measured at that point
and unchanged: 13 modified files (10 this session's), ruleset `20221742` still at **20**.

## Goal

Resolve the open frontier of `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` —
syntek-base's register of open items against itself — in **sittings grouped by shared file**
rather than by defect batch. Sittings 1 and 2 are settled; **sitting 2 is written but not
committed**. Four remain.

---

## Done — sitting 1, committed at `5d7d264`

N-044 settled (nothing corrected), N-052 settled (measured and refused), N-031 settled
(`is_exempt()` narrowed, 12 sites marked `template-only`), N-060 charted. Full detail is the
_Session log_ row dated 21/08/2026 in the map; do not re-derive it here.

## Done — sitting 2, **WRITTEN, REVIEWED, AND NOT COMMITTABLE AS IT STANDS**

The decisions are settled and the prose is written. An 82-agent adversarial review then found
two blocking classes of defect in it; both are in _In-flight 1_ and neither is a re-litigation
of a decision. **Nothing is staged.**

**N-057 + N-050 + N-051**, settled over thirteen grilling questions in four rounds. One doctrine
ran through every answer: **stop keeping a second copy of a fact that has an authoritative
source.** Ten files changed, all gates green, nothing staged.

| Path                                                                | What changed                                                                                                                                                                                                                                                                                                                                                                                                        |
| ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md`             | The **11-row required-set table is deleted**, replaced by a new `### Changing the set` H3 holding the criteria and a `gh api 'repos/{owner}/{repo}/rulesets'` invocation · `as of 3.2.2` and "promotion target" gone · the `:57-58` and `:60-61` falsehoods corrected · the guarded-job rule **narrowed** to surface-presence vs event-type · the dead `N-029` deferral replaced · one `template-only` marker added |
| `project-management/docs/git/CLAUDE.md`                             | Guardrail rewritten — never write the membership down here                                                                                                                                                                                                                                                                                                                                                          |
| `project-management/docs/git/CONTEXT.md`                            | "the target required set" → "what earns a place in the required set"                                                                                                                                                                                                                                                                                                                                                |
| `.github/workflows/audit-conflict-markers.yml`                      | The false _"only audit here"_ without a path filter corrected (six of 26 are unfiltered) · the N-029 deferral replaced with the promotion                                                                                                                                                                                                                                                                           |
| `.github/workflows/audit-deps.yml`                                  | A note on why it is **not** required and must not become one while its triggers stand                                                                                                                                                                                                                                                                                                                               |
| `.claude/skills/version/SKILL.md`                                   | Steps completed to the guide's six (adds `README.md`, `CONTEXT.md`); `:23-25` rewritten from "does not restate it" to **executes it**                                                                                                                                                                                                                                                                               |
| `.claude/skills/git/SKILL.md`                                       | `:61-62` list deleted, routes to `VERSIONING-GUIDE.md`                                                                                                                                                                                                                                                                                                                                                              |
| `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md`             | `:25-32` list deleted, routes; changelog-first ordering made explicit                                                                                                                                                                                                                                                                                                                                               |
| `project-management/workflows/23-release/STEPS.md` · `CHECKLIST.md` | List deleted and routed, taking the `pyproject.toml` instruction `VERSIONING-GUIDE.md:173` forbids                                                                                                                                                                                                                                                                                                                  |
| `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md`         | 3 rows to _Resolved_ · **N-061 charted** · counts **15 + 46 = 61** · collision table closed + 2 new rows · `MAP-RULE-OWNERSHIP` added as the eighth sibling · gate items and session log                                                                                                                                                                                                                            |

**The project audits are green; the two lint gates are NOT.** `doc-references.sh` 0 ·
`--self-test` 7/7 · `docs-length.sh` 0 (755 files) · `docs-pairing.sh` 0 ·
`skill-conformance.sh` 0 (64 skills) · `routing-skills.sh` 0 (585 names) · `doctrine-drift`,
`template-orphans`, `copy-emdash`, `template-slop` 0 · both edited workflows parse under
`yaml.safe_load`. **Prettier and markdownlint-cli2 both fail** — see BLOCKER B. Running the
audits alone was not enough to know that, which is the lesson of this sitting's review.

### Three findings the pre-flight produced that no node had

- **Sitting 1 closed N-031 with its own evidence row 1 half-repaired** — five citations left
  unmarked, and `doc-references.sh --path` on the file returns **exit 0, clean**, because the
  site writes the slashless token N-052 refused to widen Check 1 to catch. Four of the five were
  discharged by **deleting the table they sat in**; one was marked.
- **A shipped rule was condemning its own gate suite.** `:83-84` banned a job-level guard on a
  required check; **all eight `[n/8]` jobs in `claude.yml` carry one** and three are required.
  Narrowed, not enforced.
- **N-050's asymmetry was killed by `866d59d` — the commit that wrote the node.** Fifth instance
  on this map of a node producing a member of its own class.

---

## In-flight

### 1. The adversarial review RETURNED, and the diff is NOT committable as it stands

Workflow **`wn6444fhb`** (run `wf_053d9246-011`) — 82 agents, five review dimensions →
per-finding adversarial verification → completeness critic. **76 findings raised, 38 survived
refutation**: 10 graded BLOCKER, 17 MAJOR, 11 MINOR/NIT. Journal:
`…/subagents/workflows/wf_053d9246-011/journal.jsonl`; script at
`…/workflows/scripts/sitting-2-review-wf_053d9246-011.js` (read-only, re-runnable).

**The ten BLOCKERs reduce to two root causes, and both were re-verified by hand.**

#### BLOCKER A — the ruleset was never flipped, and four files say it was

`gh api 'repos/{owner}/{repo}/rulesets/20221742'` still returns **20 contexts**, still contains
`Audit JS + Python dependencies`, and contains **none** of the three promotions. Its
`updated_at` is **2026-08-16T12:32:15+01:00** — no 21/08 edit occurred at all. Population
closed three ways: `rules/branches/main` returns the identical 20, `branches/main/protection`
404s, `rulesets?includes_parents=true` returns one repository-source ruleset.

Every one of these is a completed-past-tense claim about a setting that has not moved:

| File                                           | The false line                                                                                                                               |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `MAP-BASE-HEALTH.md`                           | `:68` "the required-check set moved 20 → 22" · session log "Set **20 → 22**"                                                                 |
| `.github/workflows/audit-deps.yml`             | "NOT A REQUIRED CHECK, AND IT MUST NOT BECOME ONE" · "required from 16/08/2026 **to 21/08/2026**" (the start date is right, which hides it)  |
| `.github/workflows/audit-conflict-markers.yml` | "REQUIRED since 21/08/2026"                                                                                                                  |
| `PR-AND-REQUIRED-CHECKS.md`                    | "deliberately **not** required now" · "reporting twin … required instead" · "three of them are required and all three report" (only two are) |

**The map refused this exact move on this exact file at `:865-866` and in N-030's row**, naming
_a written claim ahead of its enforcement_ as the batch's own defect class. Meanwhile every PR
into `main` still pends forever on `Audit JS + Python dependencies` — the failure the guide
opens by describing. **Flip the ruleset, or restate all four as pending. Do not commit as is.**

#### BLOCKER B — Prettier and markdownlint both fail, so lefthook will reject the commit

Reproduced directly, and causation isolated by the verifiers against a clean HEAD baseline:

- `pnpm exec prettier --check` fails on **`project-management/docs/git/CONTEXT.md`** (the `:24`
  cell was widened without re-padding the separator or the other three rows) and on
  **`PR-AND-REQUIRED-CHECKS.md`**.
- `pnpm exec markdownlint-cli2` — **27 issues in 3 files**, MD060 table-column-style, including
  `MAP-BASE-HEALTH.md:2497`, `:2847`, `:3298` (the collision rows and the session-log row) and
  `git/CONTEXT.md:24`.
- **`PR-AND-REQUIRED-CHECKS.md:115`** splits a code span across a line break — `` `Ruff — ``
  newline `` Lint` `` — in the new "Copy the names, never retype them" bullet.
- `syntax-markdown.yml` is unfiltered and `markdownlint-cli2` is a **required context**, so this
  reddens CI as well as the local hook.

**Running `--write` is not enough**: Prettier will reflow the map's giant table rows, so check
what it does to `MAP-BASE-HEALTH.md` before accepting it.

#### The MAJORs worth acting on — all re-verified by hand

1. **`PR-AND-REQUIRED-CHECKS.md:63-64` widened a scoped claim into a false absolute.** HEAD said
   _"this sentence deliberately keeps no second copy of it"_; the change says _"nothing in this
   repository keeps a second copy of it"_. **`CONTRIBUTING.md:211-227` keeps exactly such a
   copy** — a table under _"these checks must pass before it can merge"_, 8 of its 11 rows
   naming live contexts. Either narrow the sentence or take `CONTRIBUTING.md` into the sitting.
2. **`MAP-BASE-HEALTH.md` N-061's bullet is false, by the node's own invocation.** It says
   sitting 2 closed _"exactly one of the ten … the other nine were left"_. Re-running the census
   returns **8**, not 9 — the diff also closed `audit-conflict-markers.yml`. Two closed, eight
   remain.
3. **`.claude/skills/version/SKILL.md:92-93` — "They were 1 to 4 for eleven releases" is wrong.**
   The list was written by `14809c7` on 12/08, the commit that created the file; three
   independent populations put the span at **seventeen**.
4. **`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md:30` — "named four of six" is wrong.**
   The copy it deleted named **three** of six (`VERSION`, `VERSION-HISTORY.md`, `CHANGELOG.md`).
5. **`MAP-BASE-HEALTH.md:862` — N-030's verdict block is now stale.** It describes the `Hold`
   row and `Routing skills resolve` as living in the guide; both strings return 0 there after
   the table deletion.
6. **`how-to/workflows/06-quality-gates/CONTEXT.md:42` — pre-existing and now plainly false.**
   _"An audit is never a required status check"_ — **seven** of the 20 live required contexts
   come from `audit-*.yml`. Not introduced here; squarely in the blast radius.
7. **The `23-release` pair now contradicts itself.** `STEPS.md:37` says **"It never touches
   `pyproject.toml`"** (absolute, and false on its nearest reading — the `version` skill does
   touch it on a sub-package bump); `CHECKLIST.md:22` says "unless its own code changed"
   (conditional, correct). At HEAD the pair **agreed and were both wrong**; the fix made them
   disagree — **N-051's own defect class, reproduced by N-051's remedy.** Scope STEPS to
   "the root bump never moves it".
8. **`git/CLAUDE.md`'s new standing prohibition is recorded nowhere.** _"never write the
   membership down here"_ is the sitting's most durable output — its doctrine turned into a rule
   binding every future edit to the four git guides — and the map names neither `git/CLAUDE.md`
   nor `git/CONTEXT.md` in any row. `grep -c 'git/CLAUDE\.md' MAP-BASE-HEALTH.md` → **0**.
   Add it to N-057's Resolved row and the session-log row.

#### What the review cleared

`docs-length`, `docs-pairing`, `doc-references`, `skill-conformance`, `doctrine-drift`,
`template-orphans`, `copy-emdash`, `template-slop` — **all exit 0**. The heading-rename sweep
`git/CLAUDE.md` warns about is **clean**: all six HEAD headings in `PR-AND-REQUIRED-CHECKS.md`
survive character-for-character with one added, and ~20 citations into it still resolve. 35 of
the 76 findings were graded NOT-A-FINDING by their adversary.

### 2. How to apply the ruleset change — the mechanics behind BLOCKER A

**The sandbox classifier refuses the `gh api PUT`. This is not retry-able** — do not burn turns
on it. <%DEVELOPER_NAME%> applies it in the GitHub UI.

- **Target: 22 contexts.** Remove `Audit JS + Python dependencies`; add `[8/8] Security`,
  `Routing skills resolve`, `Unresolved conflict-marker audit`.
- **Four names carry an em dash, not a hyphen** — `Ruff — Lint`, `Ruff — Format`,
  `basedpyright — Typecheck`, `TruffleHog — Secrets Scan`. Pick them from the search box.
- **Observed 18:24:** the UI showed 20 with the first two changes made while `gh api` returned
  the old 20 — an **unsaved** edit. Re-measured at the last write: still 20, `updated_at` still
  16/08. **Trust the API, not the form.**
- The payload is built and correct at `/tmp/ruleset-patch.json`; the pre-change snapshot is
  `/tmp/ruleset-20221742-before.json`. **Both are in `/tmp` and will not survive a reboot** —
  rebuild by fetching the ruleset, dropping one context and appending three.
- Read the live set with:
  `gh api 'repos/{owner}/{repo}/rulesets/20221742' --jq '.rules[] | select(.type=="required_status_checks") | .parameters.required_status_checks[].context'`
- **`audit-routing-skills.yml`'s own header was not touched by this sitting** and still does not
  say it is required. If the flip happens, that header wants a line — the other two promoted
  workflows got one.

### 3. The other session's work is in the tree and is not ours

`GAPS.md` is **staged**, `MAP-PROGRESSIVE-ENHANCEMENT.md` is modified, and
`MAP-RULE-OWNERSHIP.md` plus four handoffs are untracked. <%DEVELOPER_NAME%> confirmed that
session has finished and the diff simply was not committed. **Commit sitting 2 with explicit
pathspecs** (the ten files above plus this handoff) rather than `git add -A`, then ask whether
the rest should go in the same commit or its own.

### 4. Two cross-sitting collisions are now charted and both anchors moved today

Recorded on the map's collision table, re-measured after this sitting's edits:

- `.claude/skills/git/SKILL.md` — N-051's remedy at `:61-62`; **N-058 (sitting 5)** owns the bare
  `pre-pr-check.sh` invocation, now at **`:76`** (moved +1).
- `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` — N-051's remedy at `:25-32`;
  **N-049 (sitting 6)** owns the comment-rule scope, now at **`:126-131`** and **`:135-138`**
  (everything below `:111` moved +2).

**Sittings 2, 5 and 6 are not the disjoint surfaces the plan claimed.**

### 5. `MAP-RULE-OWNERSHIP` is the eighth sibling and claims a file three maps now want

Charted by a parallel session at 17:44 — **after** sitting 2's sibling read ran. Its **N-009 and
N-011 work `doc-references.sh` `is_exempt()` at `:158-168`**. With `MAP-NAVIGATION` N-004 and this
map's **N-060**, three maps claim that one script. The gate item now says a sibling read is
**re-run before the commit**, not only before the first node.

---

## Next

**Clear BLOCKER A first — it is a decision, not an edit.** Either <%DEVELOPER_NAME%> saves the
GitHub ruleset at 22 contexts, or every completed-past-tense claim in the four files above is
restated as pending. Nothing else should be touched until that is settled, because the wording
of eight separate sentences depends on which way it goes.

**Then, in order:** fix the eight MAJORs · re-run Prettier and markdownlint and inspect what
`--write` does to the map's tables · re-run the eight audits · commit with **explicit
pathspecs** (the ten files plus this handoff, never `git add -A`) · open the PR.

<%DEVELOPER_NAME%> asked to verify the CI workflows are correct **after the PR and the merge to
`main`** — the required-set change is exactly why: a PR raised while the ruleset is mid-edit
shows contexts matching neither state.

**One thing the critic flagged that outlives this sitting:** once this merges, the table is
gone, the map says N-057 is settled, and `git/CLAUDE.md` forbids writing the membership down
again — so **no in-repo artefact would ever reveal that the flip did not happen.** The guide's
`gh api` block is the only detector and it needs a human to run it. That is the argument for
flipping before committing rather than after.

### The remaining sitting plan

| #   | Nodes                                             | Surface                                                                                   |
| --- | ------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| 3   | N-048 + N-054, and N-020's `health-check.sh` half | `code/docs/logging/HEALTH-CONTRACT.md`                                                    |
| 4   | N-047 + N-059                                     | `copier.yml:641` · `lefthook.yml:116-118` — one doctrine, two sites                       |
| 5   | N-056 + N-058                                     | `audits/*.sh` · two bare `pre-pr-check.sh` sites — **now collides with sitting 2's file** |
| 6   | N-023 + N-039 + N-045 + N-049                     | **no longer disjoint** — N-049 shares a file with sitting 2                               |

**Parked deliberately:** N-021 · N-026. **Unscheduled:** N-060, N-061.

**Sitting 3 keeps its sequencing constraint:** N-054 must land before anything writes
`health-check.sh`, or the caller is written against a table publishing an endpoint nothing serves.

---

## Next skills

`wayfinder` (RESOLVE) → `grill-with-docs` → `doc-writer` → `git` for the commit and PR.
Sitting 3 also wants `cicd`; sitting 5 wants `code-reviewer`.

---

## Artefacts by path

- `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` — read _Frontier_, the batch
  tables, the collision table in _Batch E_, the sibling table, and the **two** _Session log_ rows
  dated 21/08/2026
- `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` — the eighth sibling, untracked
- `.claude/skills/wayfinder/SKILL.md` — RESOLVE steps · `.claude/skills/grilling/SKILL.md` — the
  question format
- `project-management/docs/VERSIONING-GUIDE.md` — the canonical root file list every N-051 site
  now routes to; `:173` is the sub-package prohibition
- `code/docs/FORWARD-VOICE.md` Section 4 — the `template-only` token, per line, on the line or
  the one above
- `git diff` — sitting 2's uncommitted work; `git show 5d7d264` — sitting 1's

## Open questions

- ~~Does the map's session-log row assert a ruleset state that is not yet live?~~ **Answered, and
  it is BLOCKER A** — it does, and so do three other files. Re-measured at the last write:
  ruleset `20221742` holds **20** contexts, `updated_at` **2026-08-16T12:32:15+01:00**. The
  question is now a decision: **flip, or restate as pending.** It gates everything else.
- **Does the other session's diff belong in this commit?** It is finished but uncommitted, and
  three of its files are maps this sitting cites.
- **Should the two blast-radius files outside the sitting be taken in?**
  `CONTRIBUTING.md:211-227` (the second copy of the required set) and
  `how-to/workflows/06-quality-gates/CONTEXT.md:42` (_"an audit is never a required status
  check"_, false seven times over). Both are now visibly wrong; neither was in sitting 2's
  scope, and taking them in widens a sitting that has already grown twice.
- **N-060 and `MAP-NAVIGATION` N-004 and `MAP-RULE-OWNERSHIP` N-009/N-011 all edit
  `doc-references.sh`.** Nobody has asked whether they are one change.
