# HANDOFF — MAP-ABSENCE through the PM workflows

**Written**: 21/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `5d3c22f`

## Goal

Drive `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` — the six-kind absence taxonomy and
its per-surface clauses — through the `project-management/workflows/` chain as a live test of the
stations. **The map is not story-ready yet:** one blocking node stands, so this one enters at `01`
in RESOLVE mode, not at `02`.

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
- **Sixteen candidate workflows assessed** against what the maps actually contain. For this map the
  live finding is that **`13-api-design` is relevant and was not in the proposed core set** — see
  the route table.
- **Two maps identified that were not loaded and that bind this one**: `MAP-BASE-HEALTH.md` (this
  map graduates **nine** findings to it, and its **N-027 ratchet** and **N-030** constrain where
  this epic can write) and `MAP-NEGATIVE-SPACE.md` (owns the `ANTI-PATTERNS.md` Keep list).

---

## In-flight

### 1. N-008 blocks everything — the map says so in its own gate

`MAP-ABSENCE.md` → _Gate to stories_: **"N-008 must settle before any prose is written, because
every other node's output depends on where the boundary with `TYPES-*` falls."**

Frontier: **11 open · 1 blocking (N-008) · 4 fog**. Nodes run `N-008` … `N-018`.

N-008 is _the collision boundary_ — what `code/docs/ABSENCE.md` owns now that the six `TYPES-*`
guides ship, clause by clause. It is unblocked and takeable.

**Why it is genuinely load-bearing and not bookkeeping:** the `TYPES-*` family landed **hours
after** this map was charted, and the map's own refute stage found **33 absence claims overturned
across six of seven research nodes** because the ground moved mid-run. `audits/doctrine-drift.sh`
exists because a rule stated in two guides is a fork, not redundancy. Anything written before N-008
settles risks forking a document whose ink is still wet.

### 2. The suggested first batch is already chosen, on the map

- **N-008 + N-009 as one grilling pass.** The map argues they are one question — the crib's row set
  _is_ the ownership claim, so deciding them apart means deciding them twice.
- **N-012 runs alone and in parallel** — the HTMX version pin, 2 or 4. Independent because it is
  decided by django-htmx's own constraint (`django_htmx/jinja.py:41` raises unless the version is
  `2` or `4`) and the CSRF consequence, not by anything this doctrine says.

**N-012 has teeth:** pinning htmx 4 silently disables CSRF header inheritance on every non-form
`hx-delete`/`hx-patch`, because attribute inheritance became explicit and django-htmx requires
`hx-headers:inherited`. Three shipped files document the old form —
`code/docs/rendering/PITFALLS-AND-EXAMPLES.md:100`, `code/docs/api-design/CLIENT-PATTERNS.md:102`,
and `.claude/skills/stack-htmx-templates/SKILL.md`.

### 3. The register triage on this map is stale

`MAP-ABSENCE.md:100-111` records both registers as empty stubs, triaged 15/08/2026. A `GAPS.md`
entry dated **20/08/2026** has since been added (`main` unreconciled since `v3.2.2`). The Step 2
triage must be re-run.

### 4. A staged `GAPS.md` deletion is in the index and is not this session's work

`git status` shows `M  GAPS.md` **staged**, deleting the whole 20/08 entry without the
`✅ CLOSED <date>` mark `.claude/CLAUDE.md` Section 9 requires. **Do not absorb it.** Establish
whether it was closed or merely deleted before running the Step 2 triage — the answer decides
whether the triage sees one open entry or none.

### 5. Nine live defects are parked on this map and belong to another one

`MAP-ABSENCE.md` → _Graduated outside this map_ routes nine findings to `MAP-BASE-HEALTH`, none
actioned. Two of them are **RED template-integrity gates at HEAD** — `check-template-tokens.sh`
exits 1 on an unclosed delimiter at `code/src/scripts/audits/conflict-markers.sh:104`, which means
**`copier copy` from this branch is currently broken**, and `shipped-readme.sh` exits 1 with three
registration findings. Both run in `audit-template.yml`, so **any PR from this branch fails that
workflow before this epic writes a line**. Not this epic's to fix — but it is this epic's to know
about before `22-pr-and-review` is reached.

---

## How to progress it through the workflows

**Enters at `01` in RESOLVE mode.** `workflows/01-feature-map/CHECKLIST.md` gates
`02-story-creation` on "Every **blocking** node is resolved", and N-008 is open.

| Order | Station              | What it has to settle here                                                                                                                                                                                                                                                                                                             |
| ----- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1     | `01-feature-map`     | **RESOLVE.** Step 2 re-triage first, then N-008 + N-009 as one `/grill-with-docs` pass; N-012 in parallel. Redraw the frontier after each                                                                                                                                                                                              |
| 2     | `02-story-creation`  | Cut stories from the resolved map. The natural seams are the per-surface legs — N-010 Python, N-011 HTMX, N-013 Rust, N-014 mobile TS                                                                                                                                                                                                  |
| 3     | `03-sprint-planning` | Open `SPRINT-01.md`. **No sprint record exists**                                                                                                                                                                                                                                                                                       |
| 4     | `13-api-design`      | **Was not in the proposed core set, and belongs.** N-011 is a response contract — 204 vs `hx-swap="none"` vs empty partial vs 404 — and N-010 carries a live defect at `code/docs/api-design/NINJA-CONVENTIONS.md:136`, `response=OrderOut \| None` on a single-object GET, bypassing the shipped `ServiceNotFoundError` → 404 mapping |
| 5     | `10-security-checks` | The error taxonomy's exposure surface — which absences become a 4xx a caller can enumerate against, and which are a 500                                                                                                                                                                                                                |
| 6     | `11-qa-checks`       | Thin but real. `code/src/django/static/js/observability.js:60` ignores the entire 4xx band (`if (…status < 500) return;`), so a 403 or 404 produces the silent dead-click the doctrine exists to close                                                                                                                                 |
| 7     | `14-decisions`       | **Exercised deliberately.** The map records a **fifteenth consecutive decline** — see _Open Questions_                                                                                                                                                                                                                                 |
| 8     | `15-sprint-plans`    | On sprint fill                                                                                                                                                                                                                                                                                                                         |
| 9     | `16-story-plans`     | On sprint fill                                                                                                                                                                                                                                                                                                                         |

**Skipped, with the reason:** `04-database-schema` (no model, migration or table),
`05-user-flow-design` (no flow; the doctrine is about return shapes, not journeys),
`06-brand-guides`, `07-component-designs` (zero components exist), `08-wireframes` (no screens),
`09-gdpr-compliance` (**no PII hook on this map** — that is `MAP-PROGRESSIVE-ENHANCEMENT` N-022),
`12-seo-checks` (no public page).

**The cadence rule binds.** One story all the way from `02` to `14` before the next; never batched
by gate (`workflows/CONTEXT.md` → _The planning cadence_).

---

## Next

Establish who owns the staged `GAPS.md` deletion, re-run `01-feature-map` **Step 2** against the
current register, then open a `/grill-with-docs` pass on **N-008 + N-009 together** — the collision
boundary and the six-kind cross-language crib as one question.

---

## Next skills

`planner` + `wayfinder` to drive `01` (Fable), `grill-with-docs` for the N-008/N-009 pass. The map's
own `Skills to load` row: `grill-with-docs`, `doc-writer`, `stack-django`, `stack-htmx-templates`,
`stack-rust`, `stack-react-native`, `code-reviewer`, `refactor`.

---

## Artefacts

- `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` — the map
- `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` — receives the nine graduated
  findings; owns the **N-027** ratchet and **N-030** that constrain this epic
- `project-management/src/01-FEATURE-MAPS/MAP-NEGATIVE-SPACE.md` — owns the `ANTI-PATTERNS.md` Keep list
- `project-management/src/01-FEATURE-MAPS/MAP-DOMAIN-OBJECTS.md` — owns the type-shape half; the
  boundary N-008 has to draw
- `code/docs/data-structures/` — the six `TYPES-*` guides N-008 must not fork
- `code/docs/NEGATIVE-SPACE.md` — the sibling discipline; touches at one row (failure → `raise` / `Result` / 4xx)
- `code/docs/api-design/NINJA-CONVENTIONS.md:136` — the live `response=OrderOut | None` defect
- `code/src/django/static/js/observability.js:60` — the ignored 4xx band
- `code/src/scripts/audits/doctrine-drift.sh` — the one-rule-one-home gate; the cheapest leg on the map
- `handoffs/HANDOFF-MAP-DOMAIN-OBJECTS-WORKFLOWS-21-08-2026.md` and its two siblings

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
   For this map specifically: it records the decline as the **fifteenth consecutive** one on
   settled precedent. If N-026 reaches beyond its own map, that precedent chain is what it
   re-opens — so do not treat this map's decline as independently settled.
2. **Can "normalise at the boundary" be said at all?** `.claude/skills/codebase-design/SKILL.md:46`
   bans _boundary_ as a substitute for _seam_, and the `TYPES-*` family has already shipped three
   H2s using it. This map's fog of war says it **cannot settle this alone** — it binds both epics.
   Decide where it gets settled before N-008 runs, or N-008 inherits it.
3. **Should `code/docs/ABSENCE.md` exist at all**, or become a section of
   `TYPES-OVER-DICTIONARIES.md`? Scope was confirmed as a new top-level guide **before** the
   `TYPES-*` family was visible. The map explicitly says N-008 must be allowed to reverse it.
