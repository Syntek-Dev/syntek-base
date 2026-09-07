# HANDOFF — US008 slice selection, settled but not cut

**Written**: 07/09/2026 · **Branch**: `pm/story-creation` · **HEAD at write**: `0b6543a`
**Workflow in play**: `project-management/workflows/02-story-creation/` — Step 0 complete, Step 1
(grill, then generate) not started

---

## Goal

Choose which slice becomes **`US008`** and cut it through `02-story-creation`. The selection is
settled: **`MAP-SUBDOMAIN-ROUTING` `S-02` — "The cookie doctrine lands"**. Nothing has been
written to the repository yet.

---

## Done

**No repository changes were made this session.** Everything below is a finding, not an edit.

### The cross-map slice census — 66 rows, 61 uncut, 4 eligible

A 67-agent workflow inventoried every slice row on all twelve maps in
`project-management/src/01-FEATURE-MAPS/`, then adversarially attacked each uncut slice's
eligibility. Results:

- **5 slices are cut**: `MAP-RETRY-AND-IDEMPOTENCY` `S-01`→`US001` and `S-02`→`US005`;
  `MAP-ABSENCE` `S-01`→`US003`; `MAP-RULE-OWNERSHIP` `S-06`→`US004`; `MAP-SCRIPT-GUARDS`
  `S-01`→`US006`. `US002` and `US007` were **not** cut from slice rows.
- **61 uncut. 57 refuted, 4 survived.** The refutations fall in two classes: roughly half need a
  `01-feature-map` **Step 8a** return (a `TBD` acceptance cell or an absent flag manifest —
  `MAP-PROGRESSIVE-ENHANCEMENT` is 0/8 cut and every slice on it needs one); the rest sit behind
  an unshipped upstream story.

| Survivor                           | Blocker found by the verify pass                                                                   |
| ---------------------------------- | -------------------------------------------------------------------------------------------------- |
| **`MAP-SUBDOMAIN-ROUTING` `S-02`** | **None.** Zero file overlap with `US001`–`US007`                                                   |
| `MAP-RETRY-AND-IDEMPOTENCY` `S-03` | `US001` creates the file it writes into, and is `Open`                                             |
| `MAP-ABSENCE` `S-04`               | `US003` creates `code/docs/ABSENCE.md`; one acceptance clause already discharged in the tree       |
| `MAP-GATE-PARITY` `S-10`           | `US002` owns `code/src/scripts/audits/CONTEXT.md`; its own map ranks it last of 10, blast radius 0 |

### Why `S-02` won

- `MAP-SUBDOMAIN-ROUTING.md:317-318` names it first — `S-01`'s rule section **defers to the
  doctrine `S-02` lands**.
- Flag manifest present (`Security`), corroborated by the ticked gate box at `:448`, so Step 0's
  send-back to `01-feature-map` Step 8a does not fire.
- Header reads `Frontier open: 0 · Blocking open: 0 · Resolved: 26`. `S-02`'s `Nodes` cell is a
  bare dash because its work is `N-004`–`N-008`, all settled 01/09/2026 **before** the cut.
- Deliverable measurably unbuilt: `__Host-` and `CSRF_COOKIE_HTTPONLY` return **zero hits**
  tree-wide.
- Sized **3 SP** by the 05/09/2026 census.

### Three corrections the story must carry

1. **An ownership wording tension, for the PROVENANCE block.** `N-004`'s own section
   (`MAP-SUBDOMAIN-ROUTING.md:227-229`) and the gate box at `:446-447` say the
   `code/docs/URL-STRATEGY.md` rewrite and the `N-004`–`N-008` deliverables graduate "with the
   slice `N-019` gates" — which reads as `S-01`. Round 7's explicit cut and the
   Deliverables-held-for-slices list assign them to `S-02`, and are later and more specific, so
   **`S-02` owns them**. Record the divergence rather than trip over it; `US004` and `US006` set
   the precedent for a story carrying a map disagreement in its provenance.
2. **A stale preamble on the map.** It calls `S-02` "the only slice with no open nodes" — true at
   Round 7 when the slices were cut, false by Round 8 the same day, which settled `N-010`–`N-013`,
   `N-015`, `N-017`, `N-018`, `N-020`, `N-022`, `N-023`. All four `Nodes` cells now read
   "(all settled)". What survives is the **deferral**, not the exclusivity.
3. **A gate-scope risk against `US002`, to settle at Step 1.** The map's standing preference is
   "a rule ships with a gate", and both `US004` (Q6) and `US006` (round-3 Q1) diverged from a
   slice manifest to add the gate the manifest omitted. If grilling applies that here, `US008`
   registers an audit and needs two rows in `code/src/scripts/audits/CONTEXT.md` — measured at
   **299 counted lines against the 300 ceiling**, i.e. behind `US002`, which sits unbuilt in the
   closed `SPRINT-02`. The map's own accounting says only `S-01` registers a gate
   (`hosts-register.sh`), so this is a risk to settle, not a measured blocker. Incidental:
   `US002.md`'s "298" headroom figure has drifted to 299.

---

## In-flight

**Nothing is mid-edit.** The session ended at a decision point, not inside a change.

- `project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md:317-318` — the slice table.
  `S-02`'s `Story` column reads `—`; Step 4 back-fills it to `US008` when the story is written.
- `project-management/src/02-STORIES/US008.md` — **does not exist.** `US008` is a free number;
  the string appears nowhere in the repository or its history.

### Working tree, not this session's doing

`git status` carries **28 modified files plus 4 untracked**, none of them written here. The
07/09/2026 four-sprint cascade (`SPRINT-01`–`SPRINT-04`, the three sprint plans, four story
plans, `US003.md`, `US006.md`) is **uncommitted**, as are `US007.md`,
`research/WAGTAIL-CMS-INTEGRATION.md`, `code/docs/WAGTAIL.md`, `code/docs/wagtail/` and
`.claude/skills/stack-wagtail/`. Establish what is intended to be committed before adding to it.

---

## Next

**Run `02-story-creation` Step 0 → Step 1 against `MAP-SUBDOMAIN-ROUTING` `S-02`: load the slice
row and its `Security` flag manifest, then open the grilling pass before drafting any Gherkin.**

---

## Next skills

`story` + `grill-with-docs` for the cut itself; `security` for the cookie doctrine's substance
(`__Host-` prefix, `CSRF_COOKIE_HTTPONLY`, cookie scope); `global-workflow` for the artefact
conventions. Roster: `.claude/skills/CONTEXT.md`.

---

## Open questions

- **`US008` has no sprint home, and that is Sam's call.** All four sprints are closed by decision
  — `SPRINT-01` 10/11, `SPRINT-02` 8/11, `SPRINT-03` 8/11 holding a 5 SP reservation, `SPRINT-04`
  13/11 at grace — and `SPRINT-04.md:186` records **"No SPRINT-05 is created"**. `US007` at 5 SP
  is itself unplaced. `02-story-creation` Step 0 imposes **no sprint precondition**, and `US007`
  was cut on 07/09 into a re-planned `SPRINT-01`, so this is a `03-sprint-planning` consequence
  rather than an eligibility bar — but the second unplaced story in two days is a planning
  decision, not a cutting one.
- **Is `S-02` the right pick on merit, or only on freedom-from-edges?** It won because it is
  unblocked. `MAP-GATE-PARITY` `S-03` is called by its own map "the **highest-priority slice** …
  the only defect that _stops work_", and `MAP-REGISTER-INDEXES` `S-01` ranked first on blast
  radius (11) in the 05/09 census. Both were refuted as not landable first. If the next cut
  should be chosen on value rather than on being unblocked, that reopens.

---

## Artefacts

| Path                                                                                                                                                                       | What it is                                                                                                                                                                                     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md`                                                                                                          | The chosen map. `:317-318` slice table · `:227-229` and `:446-447` the ownership tension · `:448` the ticked manifest gate                                                                     |
| `project-management/workflows/02-story-creation/STEPS.md`                                                                                                                  | The procedure of record — resume at Step 0, then Step 1                                                                                                                                        |
| `project-management/src/01-FEATURE-MAPS/CONTEXT.md`                                                                                                                        | The Map index, still reading `_None charted yet_` against 12 maps — a **recorded** decline, not drift (see below)                                                                              |
| `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`                                                                                                           | `S-01` relocates that index to a seeded `MAP-INDEX.md`; the decline stands until it ships                                                                                                      |
| `project-management/src/02-STORIES/US001.md` … `US007.md`                                                                                                                  | The seven PROVENANCE blocks the census was verified against. `US007.md` is uncommitted                                                                                                         |
| `project-management/src/03-SPRINTS/SPRINT-04.md:186`                                                                                                                       | "No SPRINT-05 is created" — the sprint-home blocker                                                                                                                                            |
| `code/src/scripts/audits/CONTEXT.md`                                                                                                                                       | 299 of 300 counted lines. `US002` owns it; the gate-scope risk lands here if it materialises                                                                                                   |
| `GAPS.md:387-444`                                                                                                                                                          | Why `doc-references.sh` is red at **131** findings and must not be fixed until `US004` lands the mechanism. Whatever ships next inherits it and must say so, per `code/docs/GATE-REPORTING.md` |
| `handoffs/HANDOFF-US007-STATUS-VOCABULARY-06-09-2026.md`                                                                                                                   | The prior session's handoff — `US007`'s own thread                                                                                                                                             |
| `/home/sam-dev/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/4fc7f42b-ac9d-48b2-afc6-1bdb4fa33376/subagents/workflows/wf_bd72c322-2a5/journal.jsonl`           | The full census — 67 agent returns, all 66 slice rows with evidence, all 61 verdicts. **Local only, not committed**                                                                            |
| `/home/sam-dev/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/4fc7f42b-ac9d-48b2-afc6-1bdb4fa33376/workflows/scripts/us008-slice-candidates-wf_bd72c322-2a5.js` | The census script, re-runnable via `resumeFromRunId: wf_bd72c322-2a5`. **Local only**                                                                                                          |

---

## Two things to check

1. **`MAP-PROGRESSIVE-ENHANCEMENT.md:4` is stale.** Its header reads `**Status**: Charting` while
   line 5 records the frontier closed on 31/08/2026 with 27 nodes resolved. Cosmetic, but it is
   the only map whose status line contradicts its own body.
2. **`MAP-SCALE-PLANNING.md` is absent.** `01-FEATURE-MAPS/CONTEXT.md` states it is seeded into
   this folder at generation and that six shipped guides route to it. The file does not exist in
   this tree. Whether that is a template-side seeding gap or a deliberate local deletion was not
   established.

---

**Last Updated**: 07/09/2026
