# HANDOFF — MAP-DOMAIN-OBJECTS through the PM workflows

**Written**: 21/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `5d3c22f`

## Goal

Drive `project-management/src/01-FEATURE-MAPS/MAP-DOMAIN-OBJECTS.md` through the
`project-management/workflows/` chain as a **live test of the stations themselves**. This is the
only one of the four charted maps whose frontier is empty, so it exercises the workflow machinery
against settled ground rather than against open decisions — which is why it was picked to go first.

**Standing instruction from <%DEVELOPER_NAME%>, 21/08/2026:** the maps' own "this map produces no
stories" and "no ADR is possible here" clauses are **set aside for this run**. They are the honest
position for template doctrine work; they are not a reason to skip the exercise. Do not re-litigate
them, and do not quietly narrow the run back down because the map says so.

---

## Done — this session

- **`MAP-PROGRESSIVE-ENHANCEMENT.md` corrected** — N-006's no-ADR premise was measured false
  and the node reopened as **N-026**; four sites struck rather than deleted, plus a stale
  "map is untracked" parenthetical and a stale register-triage tick. That is the only
  repository file this session changed.
- The scoping verdict below was established; no other file was touched.

- **All six requested maps loaded and classified** — four charted (`MAP-ABSENCE`,
  `MAP-PROGRESSIVE-ENHANCEMENT`, `MAP-DOMAIN-OBJECTS`, `MAP-NAVIGATION`), two seeded stubs
  (`MAP-SUBDOMAIN-ROUTING`, `MAP-UPSTREAM-TRACKING`).
- **Sixteen candidate workflows assessed** against what the four maps actually contain. The
  corrected relevant set, the skips, and the reasons are in the sibling handoffs; the route for
  _this_ map is below.
- **`code/docs/DATA-STRUCTURES.md:26` re-verified as a live defect** — it reads "All 10
  anti-patterns" and lists ten. `code/docs/data-structures/ANTI-PATTERNS.md` carries **eleven**;
  `## The ID-or-Instance Parameter` at `ANTI-PATTERNS.md:270` is the one missing from both the count
  and the list. Routed here by `MAP-ABSENCE` → _Graduated outside this map_ and **still open**.

---

## In-flight

### 1. The map is resolved; the register triage behind it is now stale

`MAP-DOMAIN-OBJECTS.md:597-603` records `GAPS.md` and `DEFERRED.md` as holding **zero open
entries**, triaged at charting on 15/08/2026. That was true then. A `GAPS.md` entry dated
**20/08/2026** has since been added — `main` unreconciled since `v3.2.2`, 80 commits behind.

So the Step 2 register triage on `workflows/01-feature-map/` is **out of date for this map**, and
its `Register claimed` table asserts an emptiness that no longer holds.

### 2. A staged `GAPS.md` deletion is sitting in the index and is not this session's work

`git status` shows `M  GAPS.md` **staged**, deleting 14 lines — the whole 20/08 entry above,
removed without the `✅ CLOSED <date>` mark that `.claude/CLAUDE.md` Section 9 requires before a
tidy pass may remove an entry.

**Do not absorb it, and do not commit it as part of this work.** Either another session closed
that gap and is mid-tidy, or the entry was deleted rather than closed. Establish which before the
Step 2 triage, because the answer decides whether the triage sees one open entry or none.

### 3. What is actually left of this epic

Every node `N-001` … `N-008` settled on 15/08/2026 and shipped. Confirmed present on disk:

- Six guides under `code/docs/data-structures/` — `TYPES-OVER-DICTIONARIES.md`,
  `TYPES-EXCEPTIONS.md`, `TYPES-PYTHON.md`, `TYPES-TYPESCRIPT.md`, `TYPES-RUST.md`,
  `TYPES-BROWSER.md`
- The gate — `code/src/scripts/audits/dict-discipline.sh`

So the map has **no frontier to resolve**. The material a story would be cut from is the residue:

| Residue                                          | Where                                                  |
| ------------------------------------------------ | ------------------------------------------------------ |
| Fog 1 — `ServiceError.code` as a `StrEnum`       | `MAP-DOMAIN-OBJECTS.md` → _Fog of war_                 |
| Fog 2 — should `dict-discipline.sh` read `{% %}` | `MAP-DOMAIN-OBJECTS.md` → _Fog of war_                 |
| The migration backlog                            | `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md` |
| The `DATA-STRUCTURES.md:26` count defect         | Verified live this session, see _Done_                 |

Fog 1 is explicitly **backlogged, not reopened** — `MAP-BASE-HEALTH` N-015 settled the four
`ServiceError` codes on 14/08/2026 and tied them to the invariant register key. Converting a
just-settled cross-cutting surface is how a decision gets re-litigated. If a story is cut from it,
say so on the story rather than treating the map as silent.

---

## How to progress it through the workflows

**Enters at `02`.** This is the only map of the four that clears
`workflows/01-feature-map/CHECKLIST.md` → _RESOLVE_ → "Every **blocking** node is resolved".

**One correction to make at `01` first, without reopening the map:** re-run **Step 2 only** — the
register triage — against the current `GAPS.md`, and update the `Register claimed` table. That is a
`task`-type touch, Opus, not a RESOLVE sitting.

Then the chain, in the order `project-management/workflows/CONTEXT.md` fixes:

| Order | Station              | What it has to settle here                                                                                              |
| ----- | -------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| 1     | `01-feature-map`     | **Step 2 only** — re-triage `GAPS.md` against the 20/08 entry; leave the frontier alone                                 |
| 2     | `02-story-creation`  | Cut the story from the residue above. One story, not four — the four items share a cause                                |
| 3     | `03-sprint-planning` | Open `SPRINT-01.md`. **No sprint record exists** — `project-management/src/03-SPRINTS/` holds only its template         |
| 4     | `10-security-checks` | Thin. `dict-discipline.sh`'s `DICT-OK:` escape hatch is a greppable bypass; confirm that is the intended threat posture |
| 5     | `11-qa-checks`       | How the audit is tested. `dict-discipline.sh` has fixtures; the story's QA plan states what a regression looks like     |
| 6     | `14-decisions`       | **Exercised deliberately.** See _Open Questions_ — the map declines an ADR for a mechanical reason, not a preference    |
| 7     | `15-sprint-plans`    | On sprint fill                                                                                                          |
| 8     | `16-story-plans`     | On sprint fill — `STORY-PLAN-US001-…`                                                                                   |

**Skipped, with the reason, so the next session does not re-derive it:** `04-database-schema` (no
model, migration or table), `05-user-flow-design` (no flow), `06-brand-guides` (no palette, type or
tone), `07-component-designs` (no components exist), `08-wireframes` (no screens),
`09-gdpr-compliance` (no personal data in scope — this is the one map of the four with no PII
hook), `12-seo-checks` (no public page), `13-api-design` (no endpoint or Schema model).

**The cadence rule binds.** `workflows/CONTEXT.md` → _The planning cadence_: take **one story** all
the way from `02` to `14` before starting the next. Do not batch the gates.

---

## Next

Establish who owns the staged `GAPS.md` deletion, then run **`01-feature-map` Step 2 alone** —
re-triage the register against the 20/08 entry and update `MAP-DOMAIN-OBJECTS.md`'s
`Register claimed` table — before touching `02-story-creation`.

---

## Next skills

`planner` + `wayfinder` for the Step 2 touch (Fable), then `story` for `02` (Fable). The map's own
`Skills to load` row names `doc-writer`, `domain-modelling`, `codebase-design`, `stack-django`,
`stack-react-native`, `stack-rust`, `stack-htmx-templates` for the substance behind it.

---

## Artefacts

- `project-management/src/01-FEATURE-MAPS/MAP-DOMAIN-OBJECTS.md` — the map
- `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` — owns the `ServiceError` decision
  (N-015) that keeps Fog 1 backlogged
- `project-management/src/01-FEATURE-MAPS/MAP-NEGATIVE-SPACE.md` — owns the "Keep — do not touch"
  list that `ANTI-PATTERNS.md` sits on
- `code/docs/data-structures/` — the six shipped `TYPES-*` guides
- `code/src/scripts/audits/dict-discipline.sh` — the gate
- `code/docs/DATA-STRUCTURES.md:26` — the live count defect
- `project-management/workflows/01-feature-map/` · `02-story-creation/` · `03-sprint-planning/`
- `handoffs/HANDOFF-MAP-ABSENCE-WORKFLOWS-21-08-2026.md` and its two siblings — the other three maps
- `handoffs/HANDOFF-MAP-BASE-HEALTH-SITTINGS-21-08-2026.md` — concurrent, unrelated work on this branch

---

## Open Questions

1. **Does `14-decisions` get exercised or skipped?** **The mechanical objection was measured false on 21/08/2026.** `copier.yml:131` excludes
   `/project-management/src/**` recursively and re-includes only `**/CONTEXT.md`, `**/CLAUDE.md`
   and `**/*TEMPLATE*`. A probe `ADR-001-PROBE.md` was placed, a real `copier copy` was run, and
   the generated project's `14-DECISIONS/` held **only** the pair plus `ADR-000-TEMPLATE.md`. An
   ADR authored here **does not travel**. `MAP-PROGRESSIVE-ENHANCEMENT` N-006 is reopened as
   **N-026** to decide whether the decline survives on its remaining, non-mechanical grounds —
   the house pattern of a guide carrying its own rationale. **That reach is undecided: N-026 may
   settle for one map or for all five that cite the constraint.** Until it does, treat the
   decline as a preference, not a constraint.
   For this map specifically: with the frontier empty there is no live trade-off for an ADR to
   record, so exercising the station means writing a retrospective one.
2. **Is the residue one story or none?** With the frontier empty and the artefacts shipped, a
   story cut here is retrospective. That is legitimate for a test run; it should be a deliberate
   choice, not an accident of the exercise.
