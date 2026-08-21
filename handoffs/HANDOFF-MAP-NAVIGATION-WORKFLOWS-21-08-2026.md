# HANDOFF — MAP-NAVIGATION through the PM workflows

**Written**: 21/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `5d3c22f`

## Goal

Drive `project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md` — can this repository describe
itself to a cold agent, and does it need a third `map/` surface — through the
`project-management/workflows/` chain as a live test of the stations. **This is the only one of
the four that may legitimately end in a refusal**, and that changes how it is run.

**Standing instruction from <%DEVELOPER_NAME%>, 21/08/2026:** the maps' own "this map produces no
stories" and "no ADR is possible here" clauses are **set aside for this run**. Do not re-litigate
them and do not narrow the run back down because the map says so.

---

## Done — this session

- **`MAP-PROGRESSIVE-ENHANCEMENT.md` corrected** — N-006's no-ADR premise was measured false
  and the node reopened as **N-026**; four sites struck rather than deleted, plus a stale
  "map is untracked" parenthetical and a stale register-triage tick. That is the only
  repository file this session changed.
- The scoping verdict below was established; no other file was touched.

- **Six maps loaded and classified** — four charted, two seeded stubs.
- **Sixteen candidate workflows assessed.** This map is the thinnest of the four against the PM
  chain: it touches no data, no UI, no endpoint and no personal data, so most stations are skips.
- **Its destination is unconfirmed** — see _In-flight_ 1. That is a harder blocker than any node.

---

## In-flight

### 1. The destination has never been confirmed, and the checklist says so

`MAP-NAVIGATION.md` → _Gate to stories_, first box: **"Destination and out-of-scope bounds
confirmed — not yet; Sam has not confirmed"**.

Every other map in this set cleared that box at charting. This one did not. `workflows/
01-feature-map/STEPS.md` **Step 3** is where it gets pinned, via `/grill-with-docs` — so this map
is not merely mid-RESOLVE, it has an **unfinished CHART**.

### 2. Three blocking nodes, and one unblocked node that may close the epic outright

Frontier: **10 open · 3 blocking (N-004, N-005, N-006) · 5 fog**.

**N-003 is the only unblocked node and the highest-leverage on the map:** can `code-review-graph`
index markdown? The map states plainly that **a yes may close the epic as a configuration change**.
Settle it before designing anything.

**N-004 is the gate**, and refusal is a named, legitimate destination — the map's own Destination
says _"either a written refusal naming what already covers the need, or a built surface"_, and
_"both are acceptable outcomes; an unresolved 'we should probably do this' is not."_

### 3. The census already moved the gate, and it cut against the epic

Both research nodes (N-001, N-002) settled 16/08/2026 and are **evidence only — they became tables
in this map and nothing outside it**. The map names the consequence explicitly: **if N-004 refuses,
both censuses die with it.**

What they found:

- **Four questions survive the deletion test** — _who cites this_ · _what moves if I change this
  rule_ · _is this reachable_ · _which directory owns this concept_. So refusal on coverage grounds
  alone is **not available** to N-004.
- **But the cheapest answer may not be a `map/` layer at all.** 817 of 870 tracked markdown files
  (**93.9%**) already carry a path-shaped `.md` citation — 8,516 backticked plus 1,138 links,
  naming 1,036 distinct targets — and `code/src/scripts/audits/doc-references.sh` **parses every
  one and keeps none**, because its `record()` fires only on failure. The edge set a `map/` would
  draw is already computed once per run and discarded. N-004 must weigh **an output mode on an
  existing audit** against a new surface; that option did not exist when the map was charted.
- A frontmatter-keyed generator reaches **36%** of the estate (312 of 870 files) and misses the
  structural half entirely — **0 of 409** `CONTEXT.md`/`CLAUDE.md` pairs carry any key. A
  citation-keyed one reaches 94% with no authoring change.

### 4. The register triage on this map is stale

`MAP-NAVIGATION.md:529-537` records both registers as holding zero open entries, triaged
16/08/2026. A `GAPS.md` entry dated **20/08/2026** has since been added. The Step 2 triage must be
re-run.

### 5. A staged `GAPS.md` deletion is in the index and is not this session's work

`git status` shows `M  GAPS.md` **staged**, deleting the whole 20/08 entry without the
`✅ CLOSED <date>` mark `.claude/CLAUDE.md` Section 9 requires. **Do not absorb it.** Establish
whether it was closed or merely deleted before running the Step 2 triage.

---

## How to progress it through the workflows

**Enters at `01`, and the unfinished business is CHART before RESOLVE.** Pin the destination
(Step 3) before taking any node — a frontier resolved against an unconfirmed destination is a
frontier resolved against nothing.

| Order | Station              | What it has to settle here                                                                                                                                               |
| ----- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1     | `01-feature-map`     | **Step 2 re-triage → Step 3 destination → then N-003 → then N-004.** In that order. N-003 may close the epic before N-004 opens                                          |
| 2     | —                    | **Decision point.** If N-004 refuses, the outcome is a written refusal and the chain stops here. That is a **success condition**, not a failed test run                  |
| 3     | `02-story-creation`  | Only if N-004 accepts. The seams are then N-005 (the repeating unit), N-006 (the generated/hand-edited boundary), N-008 (the generator), N-009 (the mandate at `21`)     |
| 4     | `03-sprint-planning` | Open `SPRINT-01.md`. **No sprint record exists**                                                                                                                         |
| 5     | `10-security-checks` | **Thin, and honestly so.** The only real surface is what a generated map would expose about repository structure, and whether the generator reads anything it should not |
| 6     | `11-qa-checks`       | What "the map has rotted" looks like as a test. `MAP-BASE-HEALTH`'s standing lesson applies — **a checklist item nobody runs is false green**                            |
| 7     | `14-decisions`       | **Exercised deliberately.** This map is the strongest ADR candidate of the four — see _Open Questions_                                                                   |
| 8     | `15-sprint-plans`    | On sprint fill                                                                                                                                                           |
| 9     | `16-story-plans`     | On sprint fill                                                                                                                                                           |

**Skipped, with the reason:** `04-database-schema` (no model, migration or table),
`05-user-flow-design` (no user journey — the "cold agent" is not a product user),
`06-brand-guides`, `07-component-designs`, `08-wireframes` (no visual surface at all),
`09-gdpr-compliance` (**no personal data anywhere in this epic**), `12-seo-checks` (no public page),
`13-api-design` (no endpoint or Schema model).

**Four constraints N-007 inherits, found at charting — do not re-derive them:** the repository root
is **exempt from the pairing rule**; `/CLAUDE.md` is **already gitignored and generated** by
`code-review-graph install`; any _other_ new directory needs a `CONTEXT.md` + `CLAUDE.md` pair; and
a generated project starts near-empty, so a `map/` shipped at generation is empty scaffolding.

**One constraint that does not bite**, recorded so it is not re-litigated: `.claude/CLAUDE.md`
Section 2.3's "a skill never self-edits" does not block N-012 — the skill would write `map/`, not
its own definition.

**The cadence rule binds** if the chain gets past station 2 (`workflows/CONTEXT.md` → _The planning
cadence_).

---

## Next

Establish who owns the staged `GAPS.md` deletion, re-run `01-feature-map` **Step 2**, then run
**Step 3** — put the destination and out-of-scope bounds to <%DEVELOPER_NAME%> and get them
confirmed. Only then take **N-003**: can `code-review-graph` index markdown.

---

## Next skills

`planner` + `wayfinder` to drive `01` (Fable), `grill-with-docs` for Step 3 and for N-004. The
map's own `Skills to load` row: `doc-writer`, `scaffold`, `codebase-design`, `domain-modelling`,
`grill-with-docs`.

---

## Artefacts

- `project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md` — the map, including both census tables
- `code/src/scripts/audits/doc-references.sh` — computes the document edge set every run and
  discards it; the cheapest candidate answer to N-004
- `code/src/scripts/audits/doctrine-drift.sh` — already models rules and their one enforcement
  point, which is closer to N-005's repeating unit than any object card
- `code/src/scripts/audits/docs-pairing.sh` · `docs-length.sh` · `routing-skills.sh` — the other
  gates the census measured, and the ones a generated tree may need exemptions from
- `code/docs/DOCUMENTATION-PAIRING.md` — owns the pairing doctrine N-007 must not reopen
- `code/docs/CODE-REVIEW-GRAPH.md` — the surface N-003 interrogates
- `project-management/workflows/21-implementation-documentation/` — Steps 5 and 6, where three of
  the proposal's four elements already exist and are already mandated
- `handoffs/HANDOFF-MAP-DOMAIN-OBJECTS-WORKFLOWS-21-08-2026.md` and its two siblings

---

## Open Questions

1. **Does a refusal at N-004 end the test run, or is the chain walked anyway?** The map treats
   refusal as a legitimate destination. For a run whose purpose is testing the **stations**, a
   refusal at station 1 means the remaining stations go untested on this map. Decide up front
   whether that is an acceptable outcome or whether this map should be run last, after the other
   three have exercised the chain.
2. **Does `14-decisions` get exercised or skipped?** This is the **strongest ADR candidate of the
   four** — "should this repository have a third map surface" is exactly the hard-to-reverse,
   options-weighed shape an ADR exists for, and **the blocker that was thought to rule it out has
   gone.** **The mechanical objection was measured false on 21/08/2026.** `copier.yml:131` excludes
   `/project-management/src/**` recursively and re-includes only `**/CONTEXT.md`, `**/CLAUDE.md`
   and `**/*TEMPLATE*`. A probe `ADR-001-PROBE.md` was placed, a real `copier copy` was run, and
   the generated project's `14-DECISIONS/` held **only** the pair plus `ADR-000-TEMPLATE.md`. An
   ADR authored here **does not travel**. `MAP-PROGRESSIVE-ENHANCEMENT` N-006 is reopened as
   **N-026** to decide whether the decline survives on its remaining, non-mechanical grounds —
   the house pattern of a guide carrying its own rationale. **That reach is undecided: N-026 may
   settle for one map or for all five that cite the constraint.** Until it does, treat the
   decline as a preference, not a constraint.
   So on this map the question is now live rather than foreclosed: N-004's outcome, accept or
   refuse, is a genuine ADR candidate.
3. **Is `REFERENCES.md` absorbed, replaced or duplicated?** The map's fog of war names it as the
   closest existing thing to the proposal — a curated index of every guide, hand-maintained and
   ungated. N-004 cannot answer honestly without saying what happens to it.
