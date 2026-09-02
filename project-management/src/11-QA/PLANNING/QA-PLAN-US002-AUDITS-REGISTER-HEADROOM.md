# QA Plan — US002 The audits register regains the headroom nine new gates need

| Field         | Value                                                     |
| ------------- | --------------------------------------------------------- |
| **Story**     | US002 — The audits register regains its headroom          |
| **Date**      | 02/09/2026                                                |
| **Sprint**    | SPRINT-01 — the homes and the headroom wave 1 writes into |
| **Wireframe** | N/A — this story edits Markdown in a scripts directory    |
| **Status**    | Signed off                                                |

---

## 1. Acceptance criteria gaps

Eleven gaps found. Six independent lenses ran over the story's seven Gherkin scenarios, and every
candidate was handed to an adversarial refuter with different search targets: **24 candidates
raised, 13 refuted, 11 upheld**. Four of the upheld set were contested between lenses and were
settled here by direct measurement — **three of the four refuters were wrong**, and those
measurements are given inline below rather than cited to the agent that made them.

**All eleven were resolved into `project-management/src/02-STORIES/US002.md` on 02/09/2026**, in
the same pass, before the sprint plan locks scope. Sign-off is <%DEVELOPER_NAME%>'s.

- **AC-GAP-1** `[RESOLVED]` — **`doctrine-drift.sh` cannot open either file this story edits.** Its
  `SCAN_DIRS` at `code/src/scripts/audits/doctrine-drift.sh:61-67` is exactly five trees —
  `code/docs`, `.claude/skills`, `code/workflows`, `project-management/workflows`,
  `how-to/workflows`. **`code/src/scripts/**` is in none of them.** The story's QA flag names this
  gate and its Verification Checks require it to pass; it will pass, having examined neither
  `CONTEXT.md` nor `CLAUDE.md`. This is the `code/docs/GATE-REPORTING.md` defect in its purest
  form, and **worse than US001's AC-GAP-1** — that gate at least read the tree and was merely
  blind to prose. _Contested between lenses; settled by reading the script._
- **AC-GAP-2** `[RESOLVED]` — **Scenario 6 requires `doc-references.sh` to exit 0, which US002 cannot
  cause.** Measured 02/09/2026: the gate exits 1 with **22 findings, none of them under
  `code/src/scripts/audits/`**. They belong to committed work and to the concurrent US003 session,
  and the count has risen through the day. A criterion a correct implementation cannot satisfy
  either blocks the story or teaches its reader to ignore the gate.
- **AC-GAP-3** `[RESOLVED]` — **the clause protecting the AI-slop rationale is already true, so it
  protects nothing.** Scenario 2 asks that the split rationale be "still stated somewhere in the
  pair"; `code/src/scripts/audits/CLAUDE.md:103-110` states both halves **today**, before a line
  is cut. Meanwhile those two `CONTEXT.md` sections are **70 counted lines** — the cheapest single
  route to the target. An implementation that deletes them outright lands under 230, keeps every
  register Scenario 2 enumerates, and passes all four gates. `code/docs/DOCUMENTATION-PAIRING.md:62-64`
  names that very heading as the exemplar of a `CONTEXT.md`'s highest-value content.
- **AC-GAP-4** `[RESOLVED]` — **no gate can decide the repointing criterion.** Scenario 6 asks that
  "every document that cited a section this story removed points at that section's new owner".
  `doc-references.sh` tests whether a backticked **path** resolves; it never reads the section name
  after the arrow, and `peel_anchor()` strips a trailing line anchor before the existence test.
  **Eight inbound citations** point into this file by section or line and none is checkable:
  `.github/workflows/audit-css-slop.yml:2`, `.github/workflows/audit-render-slop.yml:2`,
  `.github/workflows/audit-style-check.yml:2`, `code/src/scripts/desktop/CONTEXT.md:17` (all
  → _The AI-slop family_), `code/src/scripts/audits/CLAUDE.md:35` (→ _Common Flags_), `:160`
  (→ _Markdown: two limits, two scripts_), `:168-169` (→ _Reports_), and the line anchor at
  `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md:476` <!-- doc-references: template-only --> citing
  `code/src/scripts/audits/CONTEXT.md:154`. That anchor has drifted once already.
- **AC-GAP-5** `[RESOLVED]` — **the command named to prove the headline figure cannot print it.** A
  bare `bash code/src/scripts/audits/docs-length.sh` lists only files **at or above the 270 warn
  tier**; measured, it prints three lines and `code/src/scripts/audits/CLAUDE.md` at 165 is not
  among them. The moment the shrink succeeds, the file disappears from the gate's output and the
  230 figure becomes unreportable by the command the story names.
  `docs-length.sh --path code/src/scripts/audits --limit 1` does print every file's count and is
  the command that belongs in the criterion. _Contested; settled by running both forms._
- **AC-GAP-6** `[RESOLVED]` — **a registration costs three counted lines, not two, so the headroom
  figure is wrong.** Measured in `code/src/scripts/audits/`: **24 scripts · 26 Directory Tree rows
  (24 + the pair) · 24 inventory rows · 20 Dependencies rows.** Every script therefore carries a
  **tree row, an inventory row and a dependencies row**. Nine new scripts need **27 lines**, and
  the Dependencies table is **exactly 4 rows behind** — so the real future demand is **31 counted
  lines, not the 22 the story states**. _Four lenses raised this and three refuters denied it; the
  register counts above settle it._
- **AC-GAP-7** `[RESOLVED]` — **Scenario 7's second clause cannot be observed at ship time.** "No story
  in that set has had to edit this file for any reason other than its own rows" is a claim about
  nine future stories. Per the QA grilling of 02/09/2026 it is replaced by a simulation that is
  decidable today — **27** rows dry-run into the shrunk file, asserting it stays under 270.
- **AC-GAP-8** `[RESOLVED]` — **an unnamed collision.** `MAP-PROGRESSIVE-ENHANCEMENT.md` <!-- doc-references: template-only --> slice `S-01`
  owns a correction inside an inventory row this story will move. Neither artefact names the
  other, so whichever lands second silently reverts or duplicates the first.
- **AC-GAP-9** `[RESOLVED]` — **"still present and still complete" has no oracle, and one register is
  incomplete on arrival.** Scenario 2 requires each register "still complete" while Scenario 1
  budgets the Dependencies table's four missing rows as future work. The two scenarios contradict
  each other. **Resolved: US002 fills the four rows**, making "complete" decidable and dropping the
  forward demand from 31 to 27.
- **AC-GAP-10** `[RESOLVED]` — **nothing caps the share paid by relocation.** `CLAUDE.md` is at 165
  counted lines with **105 to spare before 270**, so the entire 68-line reduction could be paid by
  moving text next door. Every scenario still passes, and the wall has moved rather than gone. The
  story's only ceiling on the sibling — "still under 270" — licenses filling it to 269.
- **AC-GAP-11** `[RESOLVED]` — **the 230 figure needs its status stated.** Per the QA grilling of
  02/09/2026 it is a **target**, not a gate: 270 is the gate, and a landing between 231 and 269
  ships only with a recorded reason and a statement of what the next story inherits.

## 2. Test scenarios

Derived from the story's Gherkin rather than a wireframe — this story has none. Every scenario is
executable against the repository after the change lands.

### Happy path (HP-nn)

| ID    | Given                                                              | When            | Then                                                                                 |
| ----- | ------------------------------------------------------------------ | --------------- | ------------------------------------------------------------------------------------ |
| HP-01 | `audits/CONTEXT.md` is at 298 counted lines                        | The story ships | `docs-length.sh --path code/src/scripts/audits --limit 1` reports it at 230 or fewer |
| HP-02 | The file owns seven registers, including the Directory Tree        | The story ships | Each is present, and the Directory Tree still carries one row per script             |
| HP-03 | Passages restate `VISUAL-DESIGN.md` §6 and `DOCUMENTATION-LENGTH`  | The story ships | Each is replaced by a route naming its owner, never by silence                       |
| HP-04 | Operating rules sit in the orientation half                        | The story ships | They are in `audits/CLAUDE.md`, and `docs-pairing.sh` exits 0                        |
| HP-05 | `CONTEXT.md:8` carries a `docs-length-allow` for 298 of 300        | The story ships | It is deleted, or rewritten to the newly measured figure with a new date             |
| HP-06 | Eight documents cite this file by section or line                  | The story ships | Each has been re-resolved by hand and repointed where its target moved               |
| HP-07 | Nine audits need three rows each; the four backlog rows are filled | The story ships | A 27-row dry run into the shrunk file leaves it under 270                            |

### Error states (ES-nn)

For a documentation story the visible failures are gate failures. Each checks the gate still bites.

| ID    | Given                                                       | When                     | Then                                                           |
| ----- | ----------------------------------------------------------- | ------------------------ | -------------------------------------------------------------- |
| ES-01 | The pair loses one half                                     | `docs-pairing.sh` runs   | It exits non-zero naming the unpaired directory                |
| ES-02 | A citation under `code/src/scripts/audits/` stops resolving | `doc-references.sh` runs | A finding appears with that path — the baseline count rises    |
| ES-03 | The shrink overshoots and the file lands at 271             | `docs-length.sh` runs    | It reports the file in the warn tier with no dated allowance   |
| ES-04 | Content is moved into `CLAUDE.md` past 270                  | `docs-length.sh` runs    | The sibling enters the warn tier — the wall moved, not removed |

### Edge cases (EC-nn)

The numeric ladder the target sits on, plus the failure modes the gates cannot see.

| ID    | Given                                                                | When                    | Then                                                                                     |
| ----- | -------------------------------------------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------- |
| EC-01 | The file lands at 229, 230 and 231 in three trial shrinks            | Each is measured        | 229 and 230 satisfy the target; 231 ships only with a recorded reason (AC-GAP-11)        |
| EC-02 | The file lands at 269                                                | `docs-length.sh` runs   | The gate passes and the target does not — the difference must be recorded, not inferred  |
| EC-03 | 27 rows are added to a file that landed at 243                       | The dry run is measured | 270 exactly — the boundary case, and the reason 230 carries a margin rather than a floor |
| EC-04 | The whole reduction is paid by moving text into `CLAUDE.md`          | Both files are measured | The relocation share is recorded and does not exceed the cap set at feedback (AC-GAP-10) |
| EC-05 | `CONTEXT.md:59-146` is deleted outright                              | All four gates run      | All four pass — which is why AC-GAP-3's enumerated survival list, not a gate, catches it |
| EC-06 | The `docs-length-allow` comment is rewritten to an unmeasured figure | The comment is read     | The figure matches a run recorded in the manual-testing file on the same date            |

### Permission and access (PA-nn)

**None — this story adds no runtime surface, no endpoint and no protected action.** There is no
role boundary to cross and no ID to verify ownership of; the story's `Security: N/A` and
`API: N/A` rows are correct.

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The output is Markdown read in an editor or
on a repository host, neither of which this project ships. Recorded as a skip with its reason
rather than omitted, per `code/docs/GATE-REPORTING.md`.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as section 3.

## 5. GDPR & security constraints

**None — no PII, no new protected action.** The story edits two Markdown files; it introduces no
field, no store and no code path that could carry personal data.

## 6. Developer notes — testability

- **Two of the four gates in the QA flag cannot see this story's work.** `doctrine-drift.sh` never
  opens either edited file (AC-GAP-1) and `doc-references.sh` is red for reasons outside the diff
  (AC-GAP-2). Report both as **declared blind**, never as green. A run of all four that reports
  "all pass" is the exact defect `code/docs/GATE-REPORTING.md` names.
- **Use `--limit 1` to read the figure.** The bare `docs-length.sh` run goes silent about any file
  under 270, so the moment the story succeeds its own headline becomes unreportable by it
  (AC-GAP-5).
- **Capture the register counts before cutting.** HP-02 and the 31-row arithmetic are only
  checkable if the "before" side — 24 scripts, 26 tree rows, 24 inventory rows, 20 dependencies
  rows — was recorded while the file was intact.
- **The most valuable content is the cheapest to cut, and no gate defends it.** EC-05 is not a
  hypothetical: deleting `CONTEXT.md:59-146` reaches the target in one edit and passes everything.
  The enumerated survival list from AC-GAP-3 is the only thing standing between the story and that
  outcome, and it is closed by a human read-across.

---

## Cross-references

- `../IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies
  this plan against the shipped change
- `project-management/src/02-STORIES/US002.md` — the story this plan tests and feeds its gaps into
- `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` <!-- doc-references: template-only --> — why a
  human read-across, not a gate, closes a prose-doctrine check
- `code/docs/GATE-REPORTING.md` — the rule that a skip is never reported as a pass
- `code/docs/DOCUMENTATION-PAIRING.md` · `code/docs/DOCUMENTATION-LENGTH.md` — the two guides the
  shrink is measured against
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produces this plan
