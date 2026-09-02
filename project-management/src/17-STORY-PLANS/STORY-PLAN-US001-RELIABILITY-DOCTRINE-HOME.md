# STORY-PLAN-US001 — Reliability doctrine gets an owning guide, and every pointer reaches it

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 02/09/2026                         |
| Branch | `us001/reliability-doctrine-home`  |
| Sprint | SPRINT-01 · Wave 0 · build order 2 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

Rests on `../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` <!-- doc-references: template-only -->
(prose doctrine is verified by human read-across; `doctrine-drift.sh` is a regression guard only)
and `../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` <!-- doc-references: template-only -->
(no gate verifies a PM `src/` citation in either form).

> **Source authority.** Where this plan and `../02-STORIES/US001.md` <!-- doc-references: template-only --> differ on what
> must survive the migration, **the story wins**. On what a documentation file may weigh and which
> half of a pair a line belongs in, `code/docs/DOCUMENTATION-LENGTH.md` and
> `code/docs/DOCUMENTATION-PAIRING.md` win over both. This plan records the engineering route.

---

## Problem Statement

**Retry and idempotency doctrine has three claimants and they disagree.** The rules governing what
happens when a network call fails, and whether repeating an operation is safe, are stated across
`code/docs/TASK-AUTHORING.md`, `code/docs/performance/API-AND-MONITORING.md` and — by reference —
`code/docs/PROCESS-MODEL.md`, while the concerns span six surfaces: HTTP clients, database
transactions, queue consumers, webhooks, MCP tools and the CLI.

The measured cause is structural, not editorial: **the doctrine grew inside the guide for one
surface**. `TASK-AUTHORING.md` owns background tasks, and cross-surface rules accreted there
because that was the first surface to need them. A developer writing an HTTP client reads a Celery
guide to find out whether to retry, or does not find it at all.

This story gives the cross-surface doctrine one owning home under `code/docs/`, migrates the rules
that belong to it, and repoints every document that currently states them instead of routing to
them.

**A live length pressure sharpens it.** `TASK-AUTHORING.md` is at **266 counted lines, four below
the 270 warn tier** — so the guide that has been absorbing cross-surface doctrine is nearly out of
room to absorb any more.

## Reference Documents (code/docs gate map)

| Concern                            | Document                                                                                              | What it binds here                                                               |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| Length limit and the ratchet       | `code/docs/DOCUMENTATION-LENGTH.md`                                                                   | Every new file under 270 at birth; Section 6 on relocation versus deletion       |
| The pair, and which half owns what | `code/docs/DOCUMENTATION-PAIRING.md`                                                                  | The new directory owes a `CONTEXT.md` + `CLAUDE.md`; route, don't restate        |
| Reporting a gate's result          | `code/docs/GATE-REPORTING.md`                                                                         | `doctrine-drift.sh` cannot see prose; its green must not be reported as coverage |
| The rules being moved              | `code/docs/TASK-AUTHORING.md`                                                                         | `## Idempotency` (45 counted) · `## Retries and backoff` (17 counted)            |
| The section being reduced          | `code/docs/performance/API-AND-MONITORING.md`                                                         | `## Background Jobs and Queues (Celery)` (24 counted)                            |
| Pointers to repoint                | `code/docs/PROCESS-MODEL.md` · `code/docs/NEGATIVE-SPACE.md` · `code/docs/CONTEXT.md`                 | Each currently points at the old home                                            |
| Story                              | `../02-STORIES/US001.md` <!-- doc-references: template-only -->                                       | Seven scenarios and the QA acceptance criteria                                   |
| QA                                 | `../11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` <!-- doc-references: template-only --> | Six resolved AC-gaps, HP/ES/EC scenario tables                                   |
| Sprint plan                        | `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` <!-- doc-references: template-only -->                      | Build order, phase disposition, the gate-honesty constraint                      |

**Not applicable, and why:** `../04-DATABASE/` through `../10-SECURITY/`, `../12-SEO/`,
`../13-API-DESIGN/`, `../14-LOGGING/` — the story's corresponding flags all read `N/A`. It ships
Markdown only: no model, endpoint, screen, personal-data path, log line or public page.

## Architecture Decision

**No new ADR.** The story's two cross-cutting choices are already recorded — how prose doctrine is
verified, and how a PM `src/` citation is checked — and its remaining decisions are local to the
migration. The one open choice is deliberately left to implementation:

**The family's file names are decided in the story, not inherited from the map**, with the
reasoning recorded in the family's own `CONTEXT.md` (`project-management/src/02-STORIES/US001.md` <!-- doc-references: template-only --> Scenario 1). This plan does not
pre-empt them; it fixes the constraints they must satisfy — one directory under `code/docs/`, a
`CONTEXT.md` + `CLAUDE.md` pair, each guide carrying routing frontmatter, each under 270 counted
lines at birth, and each stating at least one rule that migrated into it.

The measurements that bound the naming:

| Source                                         | Counted | Disposition                                           |
| ---------------------------------------------- | ------- | ----------------------------------------------------- |
| `TASK-AUTHORING.md` — `## Idempotency`         | 45      | The proof ladder migrates; Celery specifics stay      |
| `TASK-AUTHORING.md` — `## Retries and backoff` | 17      | Doctrine bullets migrate; the class table stays       |
| `API-AND-MONITORING.md` — Celery section       | 24      | Reduces to failed-job visibility plus a route         |
| `TASK-AUTHORING.md` total                      | 266     | **4 below the warn tier** — the migration relieves it |

## Approach

### Not applicable — Database, Service Layer, API, Frontend

No Python, no template, no component. The four layer sections are dropped because the story
touches none of them, not to dodge a gate.

### The one lane — documentation

**Step A: capture the rule inventory before moving anything.** The story's Scenario 6 requires
every rule in the three source sections to be accounted for as moved, kept or deliberately
deleted. **That inventory is not reconstructible from the diff** once the sections are reduced, so
it is captured first and recorded in `../18-TESTS/US001-MANUAL-TESTING.md`. This is US001's
AC-GAP-2 and it is the single highest-risk step in the story.

Capture alongside it the `doc-references.sh` baseline — the finding **identities**, not the count.

**Step B: decide the family's shape and name it.** One directory under `code/docs/`, its file
names chosen here and the reasoning written into its `CONTEXT.md`. Each guide carries routing
frontmatter — `type: guide` · `skills:` · `model:`.

**Step C: create the directory with both halves of its pair.** `docs-pairing.sh` is
directory-level: a new directory under `code/docs/` owes a `CONTEXT.md` **and** a `CLAUDE.md`, and
neither may carry the other's headings.

**Step D: migrate the idempotency proof ladder.** The database-constraint → conditional
state-transition → idempotency-key ladder moves out of `TASK-AUTHORING.md` into the family.
**`task_acks_late`, broker eviction and signature drift stay** — they are Celery specifics, not
cross-surface doctrine. `TASK-AUTHORING.md` cites the family for the ladder rather than restating
it.

**Step E: migrate the retries-and-backoff doctrine bullets.** `## Retries and backoff`
(`TASK-AUTHORING.md:195-213`) is **entirely bullets — it contains no table.** The story's
"task-surface class table stays" names the table at `:179-183`, which sits inside
`## The error taxonomy on this surface` and is **not in the section being migrated at all**. It
survives by default; stated so the criterion is checkable rather than true by accident.

**Step E2: bring `## The error taxonomy on this surface` (`:173-194`) into the inventory as a
fourth source section.** It was omitted from the story's three, and it is where the class table
and the retryable/permanent classification actually live — so a cross-surface rule sitting there
would otherwise be invisible to Step A's accounting. Nothing is presumed to move from it; it is
accounted for.

**Step F: reduce the Celery section in `API-AND-MONITORING.md` to a monitoring residue.** What
remains is failed-job visibility — that guide's own remit — plus a route to the family. Rules that
duplicate `TASK-AUTHORING.md` are **deleted, not moved**; rules that are neither failed-job
monitoring nor a duplicate **move to the family rather than being dropped**. The distinction is
the whole of Scenario 4 and it cannot be made mechanically.

**Step G: repoint the three pointers.** `PROCESS-MODEL.md`, `NEGATIVE-SPACE.md` and
`code/docs/CONTEXT.md` each point at the old home today. Note `NEGATIVE-SPACE.md` carries **five**
`TASK-AUTHORING.md` citations (`:89`, `:103`, `:227`, `:248`, `:318`) and only those naming the
migrated rules are repointed — the enqueue-boundary and error-taxonomy citations still point
correctly at `TASK-AUTHORING.md` and must be left alone.

**Step H: add the family's index rows to four surfaces.** The root `REFERENCES.md`,
`code/REFERENCES.md`, `code/docs/CONTEXT.md` and `code/CONTEXT.md`. `code/docs/CONTEXT.md` takes
**two** edits — an index row and a repointed citation — and neither may revert the other
(`QA-PLAN-US001` EC-04).

**Step I: check nothing is born over the limit.** Every new file under **270** counted lines at
birth, measured with `docs-length.sh --path code/docs --limit 1`; no edited file crosses 270
without a dated allowance.

### Phase plan

One phase, in a dependency chain rather than a preference order. **A precedes everything** — the
inventory is unrecoverable once editing starts. **G and H follow B–F**, because a pointer cannot be
repointed until its target exists and the file names are settled.

## Key Decisions

| Decision                                    | Chosen                                            | Rejected                                   | Why                                                                                                      | Reference                                                                                         |
| ------------------------------------------- | ------------------------------------------------- | ------------------------------------------ | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| How prose doctrine is verified              | Human read-across; the gate is a regression guard | `doctrine-drift.sh` as the duplicate check | It reads **fenced code only** and this doctrine is prose — a green run would examine nothing             | `ADR-US001-PROSE-DOCTRINE-VERIFICATION`                                                           |
| How PM artefacts cite one another           | Full repo-relative path, understood as unverified | Bare filename; or stripping the backticks  | The path is readable; nothing checks it either way, and the record says so rather than claiming coverage | `ADR-US001-INSTANCE-CITATION-UNVERIFIED`                                                          |
| Where the family's file names are decided   | In this story, reasoning in its `CONTEXT.md`      | Inherited from the feature map             | The map is an index, not a vault; names are an implementation concern the story owns                     | `project-management/src/02-STORIES/US001.md` <!-- doc-references: template-only --> Scenario 1    |
| Celery specifics in `TASK-AUTHORING.md`     | Stay                                              | Move with the ladder                       | They are one surface's expression, not cross-surface doctrine — the split the whole story turns on       | `project-management/src/02-STORIES/US001.md` <!-- doc-references: template-only --> Scenarios 2–3 |
| Duplicated rules in `API-AND-MONITORING.md` | Deleted                                           | Moved to the family                        | A duplicate has a home already; moving it would recreate the two-claimants problem in a new place        | `project-management/src/02-STORIES/US001.md` <!-- doc-references: template-only --> Scenario 4    |

## Dependencies

| Story | Relationship | Detail                                                                                    |
| ----- | ------------ | ----------------------------------------------------------------------------------------- |
| US002 | Independent  | Shares no file. The sprint plan runs US002 first on blast radius; either order is correct |
| US003 | Independent  | SPRINT-02                                                                                 |

- **Blocked by:** nothing. Wave 0.
- **Blocks:** `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` <!-- doc-references: template-only --> slices `S-02` and `S-03`, both of which write into the
  family this story creates, and the **reliability half** of `project-management/src/01-FEATURE-MAPS/MAP-CAP-POSTURE.md` <!-- doc-references: template-only --> `S-01`. That map's
  architecture half is not blocked.
- **Can be done now:** yes, in full, once `pm/story-creation` is merged and the branch is cut.

## GDPR

**Not applicable.** The story's `GDPR` flag reads `N/A`. It creates and edits Markdown: no field,
no store, no code path that could carry personal data.

## Security

**Not applicable.** The story's `Security` flag reads `N/A`. **It introduces no mutation**, so the
template's rule that every mutation carries an explicit permission check and ownership
verification has no subject — no endpoint, no state change, no user-supplied ID, no role boundary.
Stated rather than deleted, because a missing Security section and one that says "no mutations
exist" read very differently.

## Logging & Observability

**Not applicable.** The `Logging` flag reads `N/A`. No runtime code, so no log line. Note the
story _documents_ retry and failure behaviour — it does not implement or instrument any.

## Performance, Rendering, Responsive & Accessibility

**Not applicable.** No rendered surface.

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✓ → `03-sprint-planning` ✓ → `11-qa-checks` ✓ → `15-decisions` ✓ →
`16-sprint-plans` ✓ → **`17-story-plans` (this document)** → `22-implementation-documentation` →
`23-pr-and-review`. Gates `04`–`10` and `12`–`14` skipped on `N/A` flags.

### Code workflows invoked

**None.** No Python, no endpoint, no template.

### Standards gates

`docs-length.sh` · `docs-pairing.sh` · `doc-references.sh` · `doctrine-drift.sh` (as a **regression
guard**, not a duplicate detector) · markdown lint and format.

**`doctrine-drift.sh` is genuinely in scope for this story**, unlike US002's: its scan roots
include `code/docs`, which is where every file here lives. What it cannot do is read prose — see
the ADR. The distinction between the two stories is recorded in
`../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` <!-- doc-references: template-only -->.

## Testing

**No automated test suite.** No code path, so no unit, integration, API, contract or browser test,
and **no coverage figure**. `code/docs/TESTING.md`'s floors bind code and none is added — recorded
rather than left to be inferred as a pass.

| Check                                    | How                                                                           |
| ---------------------------------------- | ----------------------------------------------------------------------------- |
| The family exists and is paired          | `docs-pairing.sh` exits 0                                                     |
| Nothing born over the limit              | `docs-length.sh --path code/docs --limit 1`; every new file under 270         |
| No dangling citation                     | `doc-references.sh`                                                           |
| No **new** drift                         | `doctrine-drift.sh` — its three API-envelope claims still one-homed           |
| **No rule in two homes**                 | **Human read-across.** No gate can decide this — see the ADR                  |
| The migration lost nothing               | The Step A inventory balances: every rule moved, kept, or deleted with reason |
| A cold reader reaches the migrated rules | Open `TASK-AUTHORING.md` cold and reach them in one hop                       |

**On `doc-references.sh`:** US001's story carries a **flat must-pass**, which
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` <!-- doc-references: template-only --> records as
inconsistent with its baseline-diff decision and **deliberately leaves standing** — that story
predates the measurement, and editing a signed-off story to match a later record would hide that
the reasoning moved. **The implementer should nonetheless capture the baseline in Step A**: the
gate is red on the tree for reasons US001 does not own, and the diff is the only way to tell
whether this story broke a citation.

## Documentation Write-Ups (Implementation Records)

Owned by `22-implementation-documentation`. This story produces
`../18-TESTS/US001-MANUAL-TESTING.md` carrying the before/after rule inventory, the
`doc-references.sh` baseline, the gate output, and the read-across sign-off.

**That file is cited twice by `project-management/src/02-STORIES/US001.md` <!-- doc-references: template-only --> today and does not exist** — a live forward reference no
gate catches, named in `ADR-US001-INSTANCE-CITATION-UNVERIFIED`. It is created by this story, which
clears it.

## CONTEXT.md & Index Updates

- **The new directory owes a `CONTEXT.md` + `CLAUDE.md` pair** — non-negotiable, and
  `docs-pairing.sh` enforces it.
- Index rows in four surfaces: root `REFERENCES.md`, `code/REFERENCES.md`, `code/docs/CONTEXT.md`,
  `code/CONTEXT.md`.
- `code/docs/CONTEXT.md` takes two independent edits — an index row and a repointed citation.
- **The Plans Index row is declined, on the record.**
  `project-management/workflows/17-story-plans/STEPS.md` Step 10.2 requires a row in
  `../17-STORY-PLANS/CONTEXT.md` → _Plans Index_. **That section does not exist, and the row is
  not added.** `CONTEXT.md` is re-included by `copier.yml` <!-- doc-references: template-only --> and therefore **ships**, so an
  instance row naming a `STORY-PLAN-US###` would put a per-project citation in a shipped file —
  the same defect ten feature maps declined for `../01-FEATURE-MAPS/CONTEXT.md`, and the reason
  that index still reads _"None charted yet"_ against twelve maps. `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` <!-- doc-references: template-only --> slice
  `S-01` owns relocating these indexes into seeded files and its `N-003` gate names
  `STORY-PLAN-INDEX.md` specifically. **The decline stands until that slice lands.**

## Deferred Items

- **`project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` <!-- doc-references: template-only --> `S-02` and `S-03`** write the retry and idempotency doctrine
  bodies into the family this story creates. Not deferred work — scheduled successors, unblocked
  by this story.
- **The `doc-references.sh` repair** — owned by `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> `S-06`, blocked on that map's
  RESOLVE sitting.

## Risks

| Risk                                                                    | Likelihood | Impact   | Mitigation                                                                                        |
| ----------------------------------------------------------------------- | ---------- | -------- | ------------------------------------------------------------------------------------------------- |
| The rule inventory is captured after editing starts and cannot balance  | Medium     | **High** | Step A is first in a stated chain; the QA plan carries it as its own task; it is AC-GAP-2         |
| A rule is dropped in transit and every gate still passes                | Medium     | **High** | The inventory is the only detector — no gate can see a missing rule                               |
| The cross-surface / Celery-specific split is drawn wrongly              | Medium     | Medium   | Scenarios 2–4 name what stays and what moves; closed by read-across, not by a gate                |
| A duplicated rule is moved instead of deleted, recreating two claimants | Medium     | Medium   | Scenario 4 states it explicitly; the read-across checks no rule sits in two homes                 |
| `NEGATIVE-SPACE.md`'s non-migrating citations are repointed by mistake  | Medium     | Low      | Five citations enumerated in Step G; only those naming migrated rules move                        |
| A new guide is born at 270+                                             | Low        | Medium   | Step I measures with `--limit 1` at birth; splitting is the answer, not an allowance              |
| `doctrine-drift.sh` green is reported as "no duplication"               | Medium     | Medium   | The ADR forbids it, the QA plan repeats it, and this plan's Testing table says what it can decide |

## Definition of Done

- [ ] The reliability family exists under `code/docs/` with its `CONTEXT.md` + `CLAUDE.md` pair
- [ ] The family's file names are decided here and the reasoning is in its `CONTEXT.md`
- [ ] Each new guide carries routing frontmatter and states at least one migrated rule
- [ ] The idempotency proof ladder is in the family and gone from `TASK-AUTHORING.md`, which cites it
- [ ] `task_acks_late`, broker eviction and signature drift remain in `TASK-AUTHORING.md`
- [ ] The retries-and-backoff bullets moved; the class table at `TASK-AUTHORING.md:179-183` — in
      `## The error taxonomy on this surface`, not in the migrated section — is untouched
- [ ] `## The error taxonomy on this surface` is accounted for in the rule inventory as the fourth
      source section
- [ ] `API-AND-MONITORING.md`'s Celery section is failed-job visibility plus a route
- [ ] The three pointers reach the family; `NEGATIVE-SPACE.md`'s other citations are untouched
- [ ] Index rows exist in all four surfaces
- [ ] Every new file under 270 counted lines at birth
- [ ] `docs-length.sh`, `docs-pairing.sh`, `doc-references.sh`, `doctrine-drift.sh`, lint and format pass
- [ ] `../18-TESTS/US001-MANUAL-TESTING.md` exists and its rule inventory balances
- [ ] The human read-across is done and signed off by someone other than the author
- [ ] Story `**Status:**` moved to `Completed`; the Plans Index row updated
