# QA Plan — US001 Reliability doctrine gets an owning guide

| Field         | Value                                             |
| ------------- | ------------------------------------------------- |
| **Story**     | US001 — Reliability doctrine gets an owning guide |
| **Date**      | 01/09/2026                                        |
| **Sprint**    | SPRINT-01 — the doctrine homes wave 1 writes into |
| **Wireframe** | N/A — this story ships Markdown, not a screen     |
| **Status**    | Signed off                                        |

---

## 1. Acceptance criteria gaps

Six gaps found. All six were resolved into `project-management/src/02-STORIES/US001.md` on 01/09/2026 in the
same pass, before the sprint plan locks scope.

- **AC-GAP-1** `[RESOLVED]` — **a named gate cannot check what the story asks of it.**
  `code/src/scripts/audits/doctrine-drift.sh` registers three claims, all API-envelope JSON
  shapes, and reads fenced code only — its own header states that prose may narrate a rule
  freely. Retry and idempotency doctrine is prose. The story's manual check read
  "no rule is stated in both its new home and its old one", which the gate would answer green
  having examined nothing — the defect `code/docs/GATE-REPORTING.md` names, where a skip
  reaches a pass's verdict. Resolved: the check is re-scoped to **no new drift introduced**,
  and the duplicate-detection it was standing in for is now an explicit human read-across.
  Added to `project-management/src/02-STORIES/US001.md` on 01/09/2026.
- **AC-GAP-2** `[RESOLVED]` — **nothing asserted the migration was lossless.** Scenarios 2–4
  name rules that must move and rules that must stay; a rule dropped in transit satisfies all
  six scenarios and both gates. Resolved: a rule-inventory criterion now requires every rule in
  the three source sections to be accounted for as moved, kept, or deliberately deleted.
  Added to `project-management/src/02-STORIES/US001.md` on 01/09/2026.
- **AC-GAP-3** `[RESOLVED]` — **an orphan task.** `project-management/src/02-STORIES/US001.md` states "All tasks below map
  directly to an acceptance criterion above", but the routing-frontmatter task
  (`type: guide` · `skills:` · `model:`) had no criterion. Resolved: scenario 1 gained the
  clause. Added to `project-management/src/02-STORIES/US001.md` on 01/09/2026.
- **AC-GAP-4** `[RESOLVED]` — **an undefined destination.** Scenario 4 reduces the
  _Background Jobs and Queues_ section to failed-job visibility plus a pointer, and deletes what
  duplicates `code/docs/TASK-AUTHORING.md`. It said nothing about a rule there that is neither
  monitoring nor a duplicate — leaving the implementer to invent a destination mid-move.
  Resolved: scenario 4 now routes any such rule to the reliability family. Added to `project-management/src/02-STORIES/US001.md`
  on 01/09/2026.
- **AC-GAP-5** `[RESOLVED]` — **an untestable criterion.** "The family's file names are decided
  in this story, not inherited from the map" describes an activity, not an observable end state,
  and no criterion set a floor for what a guide file must contain — a family of one near-empty
  file passed. Resolved: each guide file must now state at least one rule that migrated into it,
  and the family's `CONTEXT.md` must record why the split falls where it does. Added to
  `project-management/src/02-STORIES/US001.md` on 01/09/2026.
- **AC-GAP-6** `[RESOLVED]` — **the QA flag under-counted its own gates.** The FLAGS row named
  three scripts; the story's QA acceptance criteria named four. Per
  `project-management/docs/planning/CADENCE.md` the flag is a manifest and this gate may add to
  it. Resolved: the flag now names all four, and SPRINT-01's flag union was recomputed in the
  same pass. Added to `project-management/src/02-STORIES/US001.md` on 01/09/2026.

## 2. Test scenarios

Derived from the story's six Gherkin scenarios rather than a wireframe — this story has none.
Every scenario below is executable against the repository after the change lands.

### Happy path (HP-nn)

| ID    | Given                                                                                 | When            | Then                                                                                                                              |
| ----- | ------------------------------------------------------------------------------------- | --------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | No code/docs/reliability/ directory exists                                            | The story ships | The family exists with its `CONTEXT.md` + `CLAUDE.md` pair, each guide carries routing frontmatter, and `docs-pairing.sh` exits 0 |
| HP-02 | `TASK-AUTHORING.md` states the idempotency proof ladder                               | The story ships | The ladder is stated in the family and absent from `TASK-AUTHORING.md`, which cites the family instead                            |
| HP-03 | `TASK-AUTHORING.md` carries a _Retries and backoff_ section                           | The story ships | Those bullets are in the family; the task-surface class table remains where it was                                                |
| HP-04 | `performance/API-AND-MONITORING.md` carries a Celery section                          | The story ships | It states only failed-job visibility plus a pointer to the family                                                                 |
| HP-05 | `PROCESS-MODEL.md`, `NEGATIVE-SPACE.md`, `code/docs/CONTEXT.md` point at the old home | The story ships | Each points at the family, and `doc-references.sh` exits 0 with no dangling citation                                              |
| HP-06 | The three source sections held a countable set of rules                               | The story ships | The rule inventory balances — every rule is moved, kept, or deliberately deleted, with none unaccounted for                       |

### Error states (ES-nn)

For a documentation story the visible failures are gate failures. Each is a check that the gate
still bites, not a defect to expect.

| ID    | Given                                                         | When                     | Then                                                                |
| ----- | ------------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------- |
| ES-01 | The family ships a `CONTEXT.md` with no `CLAUDE.md` beside it | `docs-pairing.sh` runs   | It exits non-zero naming the unpaired directory                     |
| ES-02 | A pointer still cites a rule's old location after the move    | `doc-references.sh` runs | It exits non-zero naming the dangling citation                      |
| ES-03 | A new guide is born at or above 270 counted lines             | `docs-length.sh` runs    | It reports the file in the warn tier, and no dated allowance exists |

### Edge cases (EC-nn)

| ID    | Given                                                                               | When                           | Then                                                                                         |
| ----- | ----------------------------------------------------------------------------------- | ------------------------------ | -------------------------------------------------------------------------------------------- |
| EC-01 | A rule is simultaneously cross-surface retry doctrine and a Celery specific         | The split is decided           | It lands in exactly one home, and the other cites it — never both, never neither             |
| EC-02 | A new guide sits at 269 and another at 270 counted lines                            | `docs-length.sh` runs          | 269 passes silently; 270 enters the warn tier — the boundary is inclusive at 270             |
| EC-03 | `doctrine-drift.sh`'s three existing API-envelope claims are unrelated to this move | The gate runs after the change | All three still resolve to exactly one home — no collateral drift introduced                 |
| EC-04 | `code/docs/CONTEXT.md` must both gain an index row and have a citation repointed    | Both edits land                | Both obligations are satisfied in one change; neither edit reverts the other                 |
| EC-05 | The family's name collides with an existing `code/docs/` directory                  | The directory is created       | The collision is caught before the move begins, not after the rules have left their old home |

### Permission and access (PA-nn)

**None — this story adds no runtime surface, no endpoint, and no protected action.** There is no
role boundary to cross and no ID to verify ownership of; the FLAGS table's `Security: N/A` and
`API: N/A` rows are correct.

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The story's output is Markdown read in an
editor or on a repository host, neither of which this project controls or ships. Recorded as a
skip with its reason rather than omitted, per `code/docs/GATE-REPORTING.md`.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as section 3.

## 5. GDPR & security constraints

**None — no PII, no new protected action.** The story creates and edits documentation only; it
introduces no field, no store, and no code path that could carry personal data.

## 6. Developer notes — testability

- **Run the rule inventory before deleting anything.** HP-06 is only checkable if the "before"
  side was captured while the source sections were intact. Capture it first; it is not
  reconstructible from the diff once the sections are reduced.
- **`doctrine-drift.sh` is a regression guard here, not a duplicate detector.** Read AC-GAP-1
  before reporting its result — a green run says the three API claims are undisturbed, and says
  nothing at all about retry doctrine appearing in two places.
- **The four gates are the story's whole automated surface.** There is no pytest run, no
  coverage figure, and no migration check to report; `project-management/src/02-STORIES/US001.md`'s Verification Checks mark each
  `N/A` with its reason, and the QA record must do the same rather than leave them blank.

---

## Cross-references

- `../IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies
  this plan against the shipped change
- `project-management/src/02-STORIES/US001.md` — the story this plan tests and fed all six gaps back into
- `project-management/src/03-SPRINTS/SPRINT-01.md` — the sprint whose flag union this plan's AC-GAP-6 corrected
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule AC-GAP-1 rests on
