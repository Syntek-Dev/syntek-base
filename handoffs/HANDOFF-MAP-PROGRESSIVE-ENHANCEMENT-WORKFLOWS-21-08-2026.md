# HANDOFF — MAP-PROGRESSIVE-ENHANCEMENT through the PM workflows

**Written**: 21/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `5d3c22f`

## Goal

Drive `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` — the technology
ladder, the no-JS floor and the browser contract — through the `project-management/workflows/`
chain as a live test of the stations. **This is the widest of the four and the least ready:**
three blocking nodes stand and one of them needs a `/research` pass re-run before anything
downstream of it can move.

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
- **Sixteen candidate workflows assessed.** For this map, two corrections to the proposed core set:
  **`09-gdpr-compliance` and `11-qa-checks` were omitted and are both core**, and
  `05-user-flow-design` is marginal rather than core. Reasons in the route table.
- **This map is the reason `09` and `11` are in the run at all** — no other map of the four carries
  a PII finding or a test-lane node.

---

## In-flight

### 1. Three blocking nodes, and N-024 is the true critical path

Frontier: **16 open · 3 blocking (N-011, N-012, N-024) · 9 resolved**.

`MAP-PROGRESSIVE-ENHANCEMENT.md` → _Gate to authoring_: **"Authoring may begin once N-011, N-012
and N-024 are settled — and N-024 gates N-012, so it is the true critical path."**

**N-024 is a delivery failure, not a decision.** Two of the three research nodes returned
**addenda only**; the main report bodies never arrived and `SendMessage` was unavailable in that
session. What is missing:

| Lost body                      | Why it matters                                                         |
| ------------------------------ | ---------------------------------------------------------------------- |
| N-008's Q1–Q6 main report      | The cited Edge engine verdict and the per-feature CSS divergence table |
| **N-009's Sections 1, 2, 5–7** | **The rung-2 feature table — the whole evidential basis of N-012**     |

The rung-2 table is the SAFE TODAY / NEEDS FALLBACK / NOT YET VIABLE verdicts for `<details>`,
`<dialog>`, Popover, `:has()`, `:focus-within`, CSS tabs and scroll-driven animations. **N-012
cannot be settled without it.** N-024 re-runs both as one scoped `/research` pass.

### 2. Six nodes are takeable right now and depend on nothing

`N-010` · `N-017` · `N-019` · `N-022` · `N-024` · `N-025`. Nothing is in flight.

- **N-022 is the most urgent in absolute terms** and it is a **UK GDPR finding, not a compatibility
  one.** HTMX's history cache is `localStorage` (`historyCacheSize` default 10, full DOM
  snapshots), so any page rendering personal data persists rendered PII to disk. Alpine's
  `$persist` defaults to `localStorage` and carries the same exposure. The rule is
  `hx-history="false"` on any page rendering personal data. **This crosses out of PE doctrine into
  GDPR and security doctrine — the map says it graduates to a different guide.**
- **N-019 corrects eight statements that are false today** and blocks nothing. The largest is the
  **Lightning CSS fiction — 7 line-sites across 6 files**, swept 15/08/2026 and listed in the map.
  `code/docs/design-tokens/EDITOR.md:54` is the one with teeth: it tells a developer prefixing is
  handled automatically, and **nothing is prefixing anything**.
- **N-025 reopens a settled decision on a falsified premise.** N-005 excluded Firefox from the e2e
  matrix on install cost and "the smallest of the three divergences". **Both halves measured
  false:** cost is +108 MiB / 302 MB, under a minute; and Firefox is the **only** engine with no
  `animation-timeline` support at all — the **#1 ranked risk**, not the smallest.

### 3. The register triage on this map is stale

`MAP-PROGRESSIVE-ENHANCEMENT.md:58-66` records both registers as empty, triaged 15/08/2026. A
`GAPS.md` entry dated **20/08/2026** has since been added. The Step 2 triage must be re-run.

### 4. A staged `GAPS.md` deletion is in the index and is not this session's work

`git status` shows `M  GAPS.md` **staged**, deleting the whole 20/08 entry without the
`✅ CLOSED <date>` mark `.claude/CLAUDE.md` Section 9 requires. **Do not absorb it.** Establish
whether it was closed or merely deleted before running the Step 2 triage.

### 5. The premise that shapes every story cut from here

**The frontend does not exist.** One template (`500.html`), zero CSS files, zero HTMX attributes,
zero Alpine directives, zero routes beyond Django admin at `/control/`. There is **no remediation
backlog** — only forward commitment. Any story cut here is doctrine plus a gate, not a change to
running code, and it costs nothing today that it will not cost tenfold after ten stories.

---

## How to progress it through the workflows

**Enters at `01` in RESOLVE mode**, and the first sitting is a **research node, not a grilling**.

| Order | Station               | What it has to settle here                                                                                                                                                                                                                                                                                                                                                                               |
| ----- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1     | `01-feature-map`      | **RESOLVE.** Step 2 re-triage → **N-024 first** (the `/research` re-run) → then N-010/N-011/N-012 as one grilling (map Batch **B**). N-019 and N-022 can run alongside; both depend on nothing                                                                                                                                                                                                           |
| 2     | `02-story-creation`   | Cut stories from the resolved map. The map's own **Batches C–G** are the natural story seams — they were drawn for exactly this                                                                                                                                                                                                                                                                          |
| 3     | `03-sprint-planning`  | Open `SPRINT-01.md`. **No sprint record exists**                                                                                                                                                                                                                                                                                                                                                         |
| 4     | `05-user-flow-design` | **Marginal, include only if a story needs it.** Tier A — "every critical flow completes server-side" — is a rule _about_ flows; there is no flow to map yet                                                                                                                                                                                                                                              |
| 5     | `09-gdpr-compliance`  | **Was not in the proposed core set, and is the sharpest fit on any of the four maps.** N-022: rendered PII persisted to `localStorage` by HTMX history and Alpine `$persist`. Lawful basis, retention and the rights path for client-side persisted personal data                                                                                                                                        |
| 6     | `10-security-checks`  | N-022's other half — client-side storage as an exposure surface; plus the CSP collision at `code/docs/api-design/CLIENT-PATTERNS.md:143`, which recommends inline `hx-on:` that htmx evaluates via the `Function` constructor against a CSP the edge requirements say must never gain `unsafe-inline`                                                                                                    |
| 7     | `11-qa-checks`        | **Was not in the proposed core set, and two nodes are entirely QA planning.** N-017 — the no-JS lane (`@pytest.mark.browser_context_args(java_script_enabled=False)`, `data-testid` on every `<noscript>`, and the rule never to return a promise from `page.evaluate` or Firefox hangs the run with no timeout). N-018 — the engine matrix, and writing down that **Playwright's WebKit is not Safari** |
| 8     | `12-seo-checks`       | **Skip unless a story adds a public page.** Adjacent in spirit — a no-JS floor is a crawlability floor — but no node touches head, JSON-LD or canonical                                                                                                                                                                                                                                                  |
| 9     | `14-decisions`        | **Exercised deliberately.** This map gives the mechanical reason for the standing decline — see _Open Questions_                                                                                                                                                                                                                                                                                         |
| 10    | `15-sprint-plans`     | On sprint fill                                                                                                                                                                                                                                                                                                                                                                                           |
| 11    | `16-story-plans`      | On sprint fill                                                                                                                                                                                                                                                                                                                                                                                           |

**Skipped, with the reason:** `04-database-schema` (no model, migration or table),
`06-brand-guides` (no palette, type or tone), `07-component-designs` (per-component rung records
are **fog of war** on this map, and zero components exist), `08-wireframes` (no screens),
`13-api-design` (no endpoint or Schema model — the API-shaped work is on `MAP-ABSENCE`).

**The cadence rule binds.** One story all the way from `02` to `14` before the next
(`workflows/CONTEXT.md` → _The planning cadence_).

---

## Next

Establish who owns the staged `GAPS.md` deletion, re-run `01-feature-map` **Step 2**, then open
**N-024** as a scoped `/research` pass recovering both lost report bodies — N-008's Q1–Q6 with the
CSS divergence table, and **N-009's rung-2 feature table**. Nothing downstream of N-012 moves until
that table exists.

---

## Next skills

`planner` + `wayfinder` to drive `01` (Fable); `research` for N-024. The map's own `Skills to load`
row: `doc-writer`, `frontend`, `stack-htmx-templates`, `test-writer`, `cicd`, `scaffold`.
For station 5 add `gdpr-mechanics`; for station 7 add `qa-tester` and `test-writer`.

---

## Artefacts

- `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` — the map, including the
  A–G batch table and the N-019 defect sweep
- `code/docs/design-tokens/EDITOR.md:54` · `code/docs/DESIGN-TOKENS.md:62` ·
  `code/docs/FRONTEND-CODING-PRINCIPLES.md:146` · `code/src/scripts/audits/css-tokens.sh:8` ·
  `code/src/scripts/audits/CONTEXT.md:153` · `code/src/scripts/audits/css-slop.sh:363` — the seven
  Lightning CSS line-sites N-019 corrects
- `code/docs/api-design/CLIENT-PATTERNS.md:143` — the inline `hx-on:` / CSP collision
- `code/docs/rendering/PITFALLS-AND-EXAMPLES.md:147-151` — the doctrine table with no 4xx row
- `code/docs/RENDERING.md` — loses its claim to be the placement authority under N-003/N-015
- `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — the CSP contract N-022 and station 6 read
- `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` — shares the HTMX surface; the two must
  not fork the 4xx doctrine
- `handoffs/HANDOFF-MAP-ABSENCE-WORKFLOWS-21-08-2026.md` and its two siblings

---

## Open Questions

1. **N-026 — does the no-ADR decline survive?** **This map owned the false claim and now owns
   its correction.** **The mechanical objection was measured false on 21/08/2026.** `copier.yml:131` excludes
   `/project-management/src/**` recursively and re-includes only `**/CONTEXT.md`, `**/CLAUDE.md`
   and `**/*TEMPLATE*`. A probe `ADR-001-PROBE.md` was placed, a real `copier copy` was run, and
   the generated project's `14-DECISIONS/` held **only** the pair plus `ADR-000-TEMPLATE.md`. An
   ADR authored here **does not travel**. `MAP-PROGRESSIVE-ENHANCEMENT` N-006 is reopened as
   **N-026** to decide whether the decline survives on its remaining, non-mechanical grounds —
   the house pattern of a guide carrying its own rationale. **That reach is undecided: N-026 may
   settle for one map or for all five that cite the constraint.** Until it does, treat the
   decline as a preference, not a constraint.
   Four sites in the map were struck rather than deleted, per its own N-005 → N-025 precedent.
   **N-026 is takeable now, batch F, and blocks nothing** — but it should settle before
   `14-decisions` is reached, because it decides what that station is even for.
2. **Does N-022 stay on this map or graduate immediately?** It is a live GDPR exposure with a
   one-attribute fix, and the map already says it belongs to a **different** guide. Running it
   through `09-gdpr-compliance` as a test story and fixing it are not the same act; decide which is
   happening before the station opens.
3. **How wide is the engine matrix?** N-025 reopens Firefox on a falsified premise, and N-018
   cannot size the work until it lands. One engine, two, or three changes what `11-qa-checks`
   plans for.
