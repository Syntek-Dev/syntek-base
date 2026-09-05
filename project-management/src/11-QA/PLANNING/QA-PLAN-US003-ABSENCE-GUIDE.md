# QA Plan — US003 Absence gets an owning guide

| Field         | Value                                                       |
| ------------- | ----------------------------------------------------------- |
| **Story**     | US003 — Absence gets an owning guide                        |
| **Date**      | 02/09/2026                                                  |
| **Sprint**    | SPRINT-03 — the absence guide, and the five slices it frees |
| **Wireframe** | N/A — this story ships Markdown, not a screen               |
| **Status**    | Signed off                                                  |

<!-- The Sprint field read SPRINT-02 until 05/09/2026, when the story moved to SPRINT-03 at
     03-sprint-planning, before either sprint was worked. Nothing else in this plan changes: its
     seven gaps, its scenarios and its gates are properties of the story, not of the sprint that
     carries it. The reasoning for the move is in the two sprint records; the build-order
     constraint on US004 and this story's revision pass travelled with it. -->

---

## 1. Acceptance criteria gaps

Seven gaps found. All seven were resolved into
`project-management/src/02-STORIES/US003.md` on 02/09/2026 in the same pass, before the sprint
plan locks scope — the disposition US001 set on 01/09/2026.

- **AC-GAP-1** `[RESOLVED]` — **the crib had no content floor.** The scenario required a crib
  mapping six kinds onto five surfaces and set no minimum for a cell, so a table of thirty
  dashes satisfied it. This is US001's AC-GAP-5 in a different table: a structure criterion
  with no floor on what fills the structure. Resolved: every cell must name a concrete
  expression or state why that kind cannot arise on that surface, and no cell may be blank, a
  bare dash, or the word "varies".
- **AC-GAP-2** `[RESOLVED]` — **"clause" was undefined in the criterion that counts clauses.**
  The tier scenario demands an inline marker on every clause. With no definition, a guide
  carrying one document-level marker passes, and the whole point of N-015 — that a reader can
  see what enforces the rule **in front of them** — is lost. Resolved: a clause is any sentence
  or bullet stating a rule a reader is expected to obey; headings, worked examples and crib
  cells are explicitly not clauses.
- **AC-GAP-3** `[RESOLVED]` — **the six kinds were never asserted exhaustive or mutually
  exclusive.** "Each named and distinguished from the other five" buys distinctness only. The
  absence feature map's _Done looks like_ is that a developer can name **which** of the six
  they mean — singular — and two kinds that both plausibly apply to one absence defeat that
  while passing every criterion. Resolved: the six must be exhaustive over the absences this
  stack produces and mutually exclusive, and where two could apply the guide states the
  tie-break.
- **AC-GAP-4** `[RESOLVED]` — **two criteria misstated the gate they invoked.** Both the birth
  scenario and the reciprocity scenario said no edited file may "enter the warn tier".
  `code/src/scripts/audits/docs-length.sh` does not work that way: at or above 270 it warns and
  never fails, and the **ratchet** fails a file that is at or above 270 **and grew**. A file
  already at 293 cannot "enter" anything, so the criterion read green on precisely the case the
  ratchet exists to catch — `code/docs/GATE-REPORTING.md`'s failure, arrived at from the story
  side rather than the script side. Resolved: both now state the growth rule.
- **AC-GAP-5** `[RESOLVED]` — **the crib's four unbuilt surfaces had no stated disposition.**
  Only the Rust row has a citable target today (`code/docs/data-structures/TYPES-RUST.md:156`);
  the Python, Alpine, HTMX and mobile-TypeScript clauses land in slices `S-02` to `S-04`, in the
  guides that already own those surfaces. Nothing said whether the crib should cite forward at
  targets that do not exist — which would be a dangling citation of exactly the class this
  story's own scenario 10 forbids. Resolved (Sam, 02/09/2026): cells are **self-contained at
  birth**, and each later slice retro-fits its own back-link in the change that creates the
  target.
- **AC-GAP-6** `[RESOLVED]` — **the attribution scenario had no negative branch.** It required
  the Codd row be written "only after the primary source is checked to confirm the ancestry is
  derivation rather than convergence", and then said nothing about what to do if the check
  returns convergence — leaving an implementer mid-task with no instruction. This is US001's
  AC-GAP-4 exactly: a decision procedure with an undefined destination. Resolved (Sam,
  02/09/2026): no row is written, and the guide states that the split parallels Codd's
  applicable/inapplicable marks while claiming no derivation.
- **AC-GAP-7** `[RESOLVED]` — **scoping a ban said nothing about the file that breaks it.** The
  absence feature map's argument for scoping `codebase-design`'s _boundary_ ban is that the
  banning file violates it four times. The criterion scoped the ban and left those four
  untouched, so the rule's own defining file could still break it after the fix. Resolved
  (Sam, 02/09/2026): each of the four is checked against the new scope and reworded if it still
  violates, in the same change.

## 2. Test scenarios

Derived from the story's ten Gherkin scenarios rather than a wireframe — this story has none.
Every scenario below is executable against the repository after the change lands.

### Happy path (HP-nn)

| ID    | Given                                                    | When            | Then                                                                                                                    |
| ----- | -------------------------------------------------------- | --------------- | ----------------------------------------------------------------------------------------------------------------------- |
| HP-01 | No `code/docs/ABSENCE.md` exists                         | The story ships | It exists with its header block, routing frontmatter, and index rows in both `REFERENCES.md` and `code/docs/CONTEXT.md` |
| HP-02 | The 270-line ratchet is live                             | The story ships | The guide measures under 270 counted lines, and no edited file at or above 270 has grown                                |
| HP-03 | A developer needs to name which absence they mean        | They open it    | Six kinds, exhaustive and mutually exclusive, and a 6 × 5 crib with no empty cell                                       |
| HP-04 | The `TYPES-*` family owns what shape a value has         | The story ships | Rust is cited at `:156`, the absence-enum rule is stated, and `doctrine-drift.sh` exits 0                               |
| HP-05 | N-015 settled a four-marker tier vocabulary              | The story ships | Every clause carries a marker, every `[gate: fail]` names its gate, and none takes `[gate: warn]`                       |
| HP-06 | Clause 14 binds every skill named in routing frontmatter | The story ships | `backend`, `frontend`, `code-reviewer` and `refactor` each cite the guide, and `skill-conformance.sh` exits 0           |
| HP-07 | The absence-enum rule is owned by nobody                 | The story ships | The drift table gains one `owned` row pinning it, green on the baseline                                                 |
| HP-08 | `codebase-design/SKILL.md` breaks its own _boundary_ ban | The story ships | The ban is scoped, and the file's own four uses are compliant under the new scope                                       |
| HP-09 | Section 6 requires the licence check before deriving     | The story ships | The Harper row exists; the Codd row exists or its convergence fallback sentence does — never neither, never both        |

### Error states (ES-nn)

For a documentation story the visible failures are gate failures. Each is a check that the gate
still bites, not a defect to expect.

| ID    | Given                                                            | When                        | Then                                                       |
| ----- | ---------------------------------------------------------------- | --------------------------- | ---------------------------------------------------------- |
| ES-01 | The guide is born at or above 270 counted lines                  | `docs-length.sh` runs       | It reports the file in the warn tier with no allowance     |
| ES-02 | A named skill does not cite the guide back                       | `skill-conformance.sh` runs | It exits non-zero naming the undischarged clause 14        |
| ES-03 | A frontmatter name does not resolve to a skill directory         | `routing-skills.sh` runs    | It exits non-zero naming the unresolved skill              |
| ES-04 | The guide restates a `TYPES-*` H2 that the drift table pins      | `doctrine-drift.sh` runs    | It exits non-zero naming the forked claim                  |
| ES-05 | A crib cell cites a per-surface clause that no slice has written | `doc-references.sh` runs    | It exits non-zero with a dangling path — the AC-GAP-5 case |

### Edge cases (EC-nn)

| ID    | Given                                                                     | When                           | Then                                                                                               |
| ----- | ------------------------------------------------------------------------- | ------------------------------ | -------------------------------------------------------------------------------------------------- |
| EC-01 | An absence plausibly reads as both `not-supplied` and `not-applicable`    | A developer classifies it      | The guide's stated tie-break resolves it to exactly one — the AC-GAP-3 case                        |
| EC-02 | A kind genuinely cannot arise on one of the five surfaces                 | The crib is filled             | The cell says so with its reason; it is not left blank — the AC-GAP-1 case                         |
| EC-03 | The guide lands at 269, and a later slice adds two lines to it            | `docs-length.sh --since` runs  | The addition crosses 270 and the ratchet fires on the slice that grew it, not on this story        |
| EC-04 | `stack-django/SKILL.md` sits at 293 with an allowance expiring 01/11/2026 | The frontmatter is finalised   | It is not among the four named skills, so no clause-14 edit reaches a file inside the warn band    |
| EC-05 | The Codd check returns convergence rather than derivation                 | The attribution step runs      | No README row; the guide states the parallel instead — the AC-GAP-6 case                           |
| EC-06 | Scoping the ban leaves one of the file's own four uses still violating    | The self-audit runs            | That use is reworded in the same change — the AC-GAP-7 case                                        |
| EC-07 | `doc-references.sh` is red at 17 findings before the guide is written     | The gate runs after the change | The three `code/docs/ABSENCE.md` danglers clear; the remainder is read as the baseline, not a pass |

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

- **Capture the `doc-references.sh` baseline before editing anything.** EC-07 is only checkable
  against a "before" figure, and the gate is already red at 17 for reasons outside this story.
  The three findings this story can clear are the `code/docs/ABSENCE.md` forward references;
  everything else is the `GAPS.md` entry's class and stays.
- **`doctrine-drift.sh` is a regression guard plus one new row, not a prose checker.** It reads
  fenced code only. A green run says the registered claims are undisturbed and says nothing
  about the six kinds appearing in a second guide — that is the human read-across, per
  `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`.
- **The read-across target is the six `code/docs/data-structures/TYPES-*.md` files.** They are
  the collision the absence feature map exists to resolve, and the one place a restated rule
  would do real damage.
- **Write the crib before the prose.** AC-GAP-1 and AC-GAP-3 both bite on the crib, and a table
  that cannot be filled without a blank cell is evidence the six kinds are not yet exhaustive —
  which is cheaper to discover at the table than after the prose is written around it.
- **The five gates are the story's whole automated surface.** No pytest run, no coverage figure,
  no migration check; the story's Verification Checks mark each `N/A` with its reason, and this
  record does the same rather than leaving them blank.

---

## Cross-references

- `../IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies
  this plan against the shipped change
- `project-management/src/02-STORIES/US003.md` — the story this plan tests and fed all seven
  gaps back into
- `project-management/src/03-SPRINTS/SPRINT-03.md` — the sprint this story is now a member of ·
  `project-management/src/03-SPRINTS/SPRINT-02.md` — the sprint it opened, and left on 05/09/2026
  before either was worked
- `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` — slice `S-01`, the source of the story
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule AC-GAP-4 rests on
