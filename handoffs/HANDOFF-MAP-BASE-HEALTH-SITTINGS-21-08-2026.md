# HANDOFF — MAP-BASE-HEALTH sittings

**Written**: 21/08/2026 · **Branch**: `pm/base-health-map`
**Supersedes** the sitting-3 edition written at `e3407cf`, whose four in-flight items are now
**one discharged, two still open, one re-measured and worse than it read.**

## Goal

Resolve the open frontier of `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` —
syntek-base's register of open items against itself — in **sittings grouped by shared file**
rather than by defect batch. **The maintainer's standing instruction is that the map is completed
before this branch is proposed**, which inverts the previous edition's order: the PR waits on the
frontier, not the other way round. **Sittings 1, 2 and 3 are settled and committed. Three
remain, plus three dispositions.**

---

## Done

### Sittings 1 and 2 — committed at `5d7d264` and `e3407cf`

N-044, N-052, N-031 and N-060 charted (sitting 1); N-057, N-050, N-051 plus an 82-agent
adversarial review whose 38 surviving findings were all fixed in place (sitting 2). Detail is the
two _Session log_ rows dated 21/08/2026 on the map. **Do not re-derive it here.**

### Sitting 3 — this session

**N-054, N-048 and N-020 settled over nine questions in two rounds**, on one file plus its
downstream readers. Eleven items, ten files, every gate green. **Nothing was charted.**

**Two questions dissolved on lookup rather than reaching the maintainer** — `OBSERVABILITY.md`
_Deferred, with a trigger_ already held the `/metrics/` reopening condition, and
`TEMPLATE-GAPS.md` already held the standing-limitation format.

**The thesis: neither half of N-054 was a drift between equals.** Both were omissions on one
side. `apps/health/checks.py` → `Component` already said `API` and `PAGES` are _"named in the
contract but deliberately absent… each arrives with its surface"_, and three shipped documents
already carried the `django_prometheus`-not-wired qualifier. **The file calling itself the single
source of truth was the only one missing what every sibling stated.**

| Settled   | How                                                                                                                                                                                                 |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **N-054** | `HEALTH-CONTRACT.md` — the endpoint table's `/metrics/` row **kept** and given its trigger; the readiness line now names two probed and two reserved. Celery floor `>=5.3` → `>=5.6` at three sites |
| **N-048** | `-backend` wins on the **ownership** rule, not on merit — both names imply a front/back split this stack does not have. Two sites moved, three already conformed                                    |
| **N-020** | **Closed as _accepted_, not _fixed_ — `TEMPLATE-GAPS.md` → SL-2.** The first node on this map to take the second of the Destination's three outcomes                                                |

**Three findings no node had.** `OBSERVABILITY.md` asserted the two job names were _"spelled the
same way"_ — **made true rather than deleted**, being the only sentence keeping them in step;
`config/CONTEXT.md` claimed dev Compose _"probes `/`"_ when four probe points all use `/health/`;
and the **Frontier opener read 19 through three consecutive sittings** while the header block
beneath it was recounted three times.

**Two claims corrected before they shipped:**

- **N-048's remedy claim, withdrawn.** The node said `doctrine-drift.sh` could hold the drift and
  derived that from `SCAN_DIRS` alone. **Three things block it** — the owner path is rooted at
  `DOCS_DIR="code/docs"` (`:207`, `:212`) and the owner is not in it, `how-to/src` is never
  scanned, and only fenced code is read while SERVER-ARCHITECTURE states rules in prose on
  purpose. **The map's twice-stated pessimism stands; the counter-example was the error.** The
  scope now lives in the script beside `DOCS_DIR`, where the next person will be standing.
- **SL-2's trigger, re-measured before commit.** Drafted _"reopens when a workflow builds and
  pushes an image"_; `test-api.yml:75` **already builds one**. It says **publishes** — measured
  across all 35 workflow files, no `docker push`, no `docker/login-action`, no `ghcr.io`.

**Counts recounted from the tables and verified by script**: **11 + 49 = 60 = N-060**, no overlap.
Per batch: A 0 · B 3 · D 1 · E 4 · unbatched 3.

**Gates at the commit:** prettier · markdownlint (0 in 808) · docs-length (755) · docs-pairing ·
doc-references (+ `--self-test` 7/7) · routing-skills (+ `--self-test` 7/7) · doctrine-drift
(+ `--self-test`) · skill-conformance (64) · seam-contract · template-orphans · template-slop ·
copy-emdash · copy-slop · stubs · conflict-markers (1273) · `syntax/lint.sh` · `syntax/check.sh`
— **all exit 0**.

---

## In-flight

### 1. `audit-routing-skills.yml` still has no eligibility line — carried a second time

`.github/workflows/audit-routing-skills.yml` has a full explanatory header and **no
`ELIGIBLE FOR THE REQUIRED SET` line**, while four workflows carry one:
`audit-conflict-markers.yml:15` · `audit-deps.yml:18` · `syntax-python.yml:52` and `:65` ·
`test.yml:4`. It was outside sitting 2's file set and outside sitting 3's. **It is a two-line
comment and has now been deferred twice.** `Routing skills resolve` is one of the three contexts
joining the required set, so the file will be load-bearing the moment the ruleset moves.

### 2. The branch-protection ruleset has NOT moved, and that is still deliberate

`gh api 'repos/{owner}/{repo}/rulesets/20221742'` returned **20 contexts** at
**2026-08-16T12:32:15+01:00**. The maintainer applies the flip **after the PR merges**.

- **Target: 22.** Remove `Audit JS + Python dependencies`; add `[8/8] Security`,
  `Routing skills resolve`, `Unresolved conflict-marker audit`.
- **Four names carry an em dash, not a hyphen** — `Ruff — Lint`, `Ruff — Format`,
  `basedpyright — Typecheck`, `TruffleHog — Secrets Scan`. Pick them from the search box.
- **The sandbox classifier refuses `gh api PUT`. Do not burn turns on it.** The UI is the route,
  and **the API is the source of truth, not the form**.
- **No wording depends on the timing.** Nothing in the tree asserts the flip has happened.

### 3. `GAPS.md`'s `main`-reconciliation entry is still deleted, and the gap has grown

Re-measured this session: `main` is at **`a1e0f68`** (`v3.2.2`), **85 commits behind this branch
and 0 ahead** — 86 once this session's commit lands. The entry was deleted at `e3407cf` on the
maintainer's explicit instruction **without** the `✅ CLOSED` mark, because it is not closed.
Four handoffs have independently said not to absorb `main`. **The reconciliation decision still
has no register entry tracking it.** Restore with `git show 5d3c22f:GAPS.md`.

### 4. Pushed through the previous commit; no PR exists

`origin/pm/base-health-map` tracked `e3407cf` with **0 unpushed commits** before this session.
`gh pr list --head pm/base-health-map` returns nothing. `project-management/docs/git/COMMITS.md`
→ _Before Every Push_ wants `code/src/scripts/tests/backend.sh` green first.

### 5. Discharged — the stale `is_exempt()` anchor

The previous edition's item 3 (siblings table citing `:158-168`) **is fixed**: corrected to
`:158-170` in sitting 3, with the reason recorded inline and the instruction to re-locate by
string rather than by line.

---

## Next

**Open sitting 4** — `/wayfinder resolve` on the map, nodes **N-047 + N-059**, surface
`copier.yml:641` and `lefthook.yml:116-118`: one doctrine, two sites. **Re-measure both anchors
before grilling** — sitting 3 found that _every_ charted anchor in N-048 had drifted, and the map
has now recorded anchor drift on three separate nodes.

### The remaining plan

| #   | Nodes                         | Surface                                                                        |
| --- | ----------------------------- | ------------------------------------------------------------------------------ |
| 4   | N-047 + N-059                 | `copier.yml:641` · `lefthook.yml:116-118` — one doctrine, two sites            |
| 5   | N-056 + N-058                 | `audits/*.sh` · two bare `pre-pr-check.sh` sites — **collides with sitting 2** |
| 6   | N-023 + N-039 + N-045 + N-049 | **not disjoint** — N-049 shares `VERSIONING-AND-DOCS.md` with sitting 2        |

**Three dispositions, not sittings** — the map cannot reach its Destination without them:
**N-021** and **N-026** (parked; both have unmeasured premises) and **N-060** (unscheduled).
**SL-2 is the worked precedent** for closing one as _accepted_ rather than _fixed_, and N-021 is
the likeliest candidate — three of its four runbooks have no subject and may never have one here.

**Also required for Destination:** _Fog of war_ must be empty. The taxonomy question — whether the
five defect classes become a shipped taxonomy — is still open there and nobody has scheduled it.

---

## Next skills

`wayfinder` (RESOLVE) → `grill-with-docs` → `doc-writer` for sitting 4; it also wants `cicd` for
the `lefthook.yml` half. Sitting 5 wants `code-reviewer`. The PR, when the frontier is empty,
runs `git` then `pr`.

---

## Artefacts by path

- `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` — read the header block's count
  paragraph, the batch tables, the collision table in _Batch E_, the siblings table, and the
  **three** _Session log_ rows dated 21/08/2026
- `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` → `## Standing limitations` — **SL-1 and now
  SL-2**; the register the Destination requires to hold standing limitations only
- `code/docs/logging/HEALTH-CONTRACT.md` — sitting 3's subject; `code/docs/logging/OBSERVABILITY.md`
  → _Deferred, with a trigger_ holds the `/metrics/` reopening condition
- `code/src/django/apps/health/checks.py` → `Component` — the docstring that already held N-054's
  answer, and the reason the contract was the defective side
- `code/src/scripts/audits/doctrine-drift.sh` — the scope comment beside `DOCS_DIR` recording what
  the audit cannot reach, and why widening `DOCS_DIR` is the change that would fix it
- `project-management/docs/git/COMMITS.md` → _Before Every Push_ · `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md`
  → _Changing the set_ — the only in-repo detector that the ruleset flip happened

## Open questions

- **Does the `main` reconciliation get a fresh `GAPS.md` entry?** Asked in the previous edition
  and still unanswered; the gap is live at 85 commits and grows with every sitting.
- **Do N-021 and N-026 close as accepted, following SL-2?** Sitting 3 established the mechanism
  and deliberately did not apply it to either, both having unmeasured premises.
- **`doc-references.sh` is claimed by three maps** — this map's N-060, `MAP-NAVIGATION`'s N-004,
  and `MAP-RULE-OWNERSHIP`'s N-009/N-011. Nobody has asked whether they are one change.
- **Does `MAP-RULE-OWNERSHIP` stay separate?** It declines to be folded in; the measured cost of
  that split is on this map.
