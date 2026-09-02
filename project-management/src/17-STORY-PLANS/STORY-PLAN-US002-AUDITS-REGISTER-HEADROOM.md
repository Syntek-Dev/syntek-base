# STORY-PLAN-US002 — The audits register regains the headroom nine new gates need

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 02/09/2026                         |
| Branch | `us002/audits-register-headroom`   |
| Sprint | SPRINT-01 · Wave 0 · build order 1 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

Implements `../15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md` <!-- doc-references: template-only -->
(a register under length pressure splits rather than relocating) and
`../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` <!-- doc-references: template-only -->
(a gate that cannot read the files under test leaves the manifest).

> **Source authority.** Where this plan and `../02-STORIES/US002.md` <!-- doc-references: template-only --> differ on a line
> count, **this plan wins** — its figures are measured section by section and reconcile to
> `docs-length.sh`. Where they differ on what must survive, **the story wins**. On what a
> documentation file may weigh and which half of a pair a line belongs in,
> `code/docs/DOCUMENTATION-LENGTH.md` and `code/docs/DOCUMENTATION-PAIRING.md` win over both.

---

## Problem Statement

`code/src/scripts/audits/CONTEXT.md` is at **298 counted lines against a 300-line limit — two
lines of headroom**. It is the register for the audit suite, and every new audit script must add
**three rows** to it: a Directory Tree row, a script-inventory row and a Dependencies row.

**Nine audits are queued across eight slices and seven maps**, so 27 lines are due. The
Dependencies table is separately **four rows short for scripts that already exist** — 24 scripts,
20 rows. The next story to write a gate cannot register it, and an audit absent from the register
reads as a suite that is complete when it is not.

This story is wave 0 and Must because those nine stories all land red without it.

## Reference Documents (code/docs gate map)

| Concern                      | Document                                                                                             | What it binds here                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Length limit and the ratchet | `code/docs/DOCUMENTATION-LENGTH.md`                                                                  | The 300 limit, the 270 warn tier, the dated allowance, and Section 6 on relocation        |
| Which half a line belongs in | `code/docs/DOCUMENTATION-PAIRING.md`                                                                 | Orientation vs operating rules; `:62-64` names rationale as the highest-value orientation |
| Reporting a gate's result    | `code/docs/GATE-REPORTING.md`                                                                        | Two of this story's gates cannot see it; neither may be reported as a pass                |
| The register's own rules     | `code/src/scripts/audits/CLAUDE.md`                                                                  | "Add the row to `CONTEXT.md`'s inventory and requirements tables in the same change"      |
| Story                        | `../02-STORIES/US002.md` <!-- doc-references: template-only -->                                      | Nine scenarios, the acceptance the plan implements                                        |
| QA                           | `../11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` <!-- doc-references: template-only --> | Eleven resolved AC-gaps and the scenario tables                                           |
| Sprint plan                  | `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` <!-- doc-references: template-only -->                     | Build order, phase disposition, gate-honesty constraint                                   |

**Not applicable, and why:** `../04-DATABASE/`, `../05-USER-FLOW/`, `../06-BRAND-GUIDE/`,
`../07-COMPONENTS/`, `../08-WIREFRAMES/`, `../09-GDPR/`, `../10-SECURITY/`, `../12-SEO/`,
`../13-API-DESIGN/`, `../14-LOGGING/` — the story's corresponding flags all read `N/A`. It edits
Markdown in a scripts directory: no model, endpoint, screen, personal-data path, log line or
public page.

## Architecture Decision

**The rationale splits into its own file; it does not relocate into the operating-rules half.**
Settled at `../15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md` <!-- doc-references: template-only -->,
which supersedes the first split record: the rule stands, the **target** moved to a bound path.

The measurement that forced it, reconciling exactly to `docs-length.sh`'s 298:

| Section                                                                       | Counted | Disposition                |
| ----------------------------------------------------------------------------- | ------- | -------------------------- |
| Directory Tree · Scripts · Common Flags · Exit Codes · Reports · Dependencies | 177     | Registers — cannot be cut  |
| _The AI-slop family — why four scripts and not one_                           | 70      | Rationale — must survive   |
| `security.sh` · _Markdown: two limits_ · _Cargo tree_ · TDD bypass            | 46      | The only unprotected prose |
| Preamble                                                                      | 5       | —                          |

**Deleting all 46 unprotected lines and adding the four owed Dependencies rows lands at 256, not 230.** The target is unreachable by deletion alone, which is why the story's approach is
structural rather than editorial.

## Approach

### Not applicable — Database, Service Layer, API, Frontend

This story adds no Python, no template and no component. The four layer sections the template
carries are dropped because the story touches none of them, not to dodge a gate.

### The one lane — documentation

**Step A: capture the baseline before touching anything.** Three measurements, recorded in
`../18-TESTS/US002-MANUAL-TESTING.md`:

1. `bash code/src/scripts/audits/docs-length.sh --path code/src/scripts/audits --limit 1` — the
   `--limit 1` form is required, because a bare run prints only files at or above 270 and would go
   silent about this file the moment the shrink succeeds.
2. The register counts: 24 scripts, 26 Directory Tree rows, 24 inventory rows, 20 Dependencies rows.
3. `bash code/src/scripts/audits/doc-references.sh` — **the finding identities, not just the
   count**, per `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` <!-- doc-references: template-only -->.

**Step B: create a **slop-family** sub-folder under `code/src/scripts/audits/` with its `CONTEXT.md` + `CLAUDE.md` pair.**
The rationale lands in that `CONTEXT.md` — a basename `docs-length.sh` measures, unlike a bare
sibling file, which `is_instructional()` would never admit. The whole of `CONTEXT.md:59-146`
moves across intact — the four-scripts-by-input-language argument, the second-axis argument for
`render-slop.sh`, the design-time scope note, and the `slop-allow` annotation table. It carries routing frontmatter, and at ~70 lines is
well inside the 300 limit the gate now genuinely applies to it.

**Step C: leave a route, not a summary.** `CONTEXT.md` keeps roughly four lines naming the family,
its four members and the new file. A summary that restates the argument reintroduces the
duplication the split exists to remove.

**Step D: register the sub-folder.** About four Directory Tree lines — the folder and its pair,
matching how `rules/` and `reports/` are already shown. This is a line the story spends, and it
is counted in the arithmetic below rather than treated as free.

**Step E: route the restatements.** `## Markdown: two limits, two scripts, and the gap that
existed between them` (12 lines) restates `code/docs/DOCUMENTATION-LENGTH.md`; it becomes a
~3-line route. Any passage in `security.sh`, the Cargo-tree section or the TDD bypass that
restates a rule owned elsewhere goes the same way. **Facts with no other home stay.**

**Step F: complete the Dependencies register.** Add rows for the four scripts that have none, so
"every register complete" is decidable rather than asserted.

**Step G: retire the allowance.** `CONTEXT.md:8`'s `docs-length-allow` comment is deleted — the
file no longer needs one. It must not be left asserting 298, nor rewritten to claim a remedy this
story did not use.

**Step H: repoint the eight citations no gate can check.** Four to `_The AI-slop family_`
(`.github/workflows/audit-css-slop.yml:2`, `audit-render-slop.yml:2`, `audit-style-check.yml:2`,
`code/src/scripts/desktop/CONTEXT.md:17`) now point at the new file. Three inside
`code/src/scripts/audits/CLAUDE.md` (`:35`, `:160`, `:168-169`) are re-resolved. The line anchor
at `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` <!-- doc-references: template-only --> line 476 citing `CONTEXT.md:154` is re-pinned to whatever line the
`css-tokens.sh` inventory row ends up on.

### The arithmetic, stated so it can be checked

| Step                                        | Δ   | Running |
| ------------------------------------------- | --- | ------- |
| Baseline                                    | —   | **298** |
| B — the rationale leaves                    | −70 | 228     |
| C — the route stub                          | +4  | 232     |
| D — the Directory Tree row for the new file | +1  | 233     |
| F — four owed Dependencies rows             | +4  | 237     |
| E — _Markdown: two limits_ becomes a route  | −9  | 228     |
| G — the allowance comment retired           | 0   | **228** |

**231 against a target of 230, and a gate of 270.** The sub-folder costs three lines more than a
bare file would have — the price of a ceiling a script enforces. Step E takes the last one to three
lines from the remaining unprotected prose in `security.sh` and the Cargo-tree section, which holds
~30. The forward demand is 27, so even at 231 the file keeps 39 lines below the warn tier.

<!-- The allowance comment is a whole-line HTML comment, which cloc does not count as code, so
     deleting it changes the counted total by zero. Stated because it looks like a saving. -->

### Phase plan

One phase. The order above is a dependency chain, not a preference: the baseline (A) is
unrecoverable once editing starts, and the repointing (H) cannot be done until the new file exists
(B) and the inventory rows have settled (E, F).

## Key Decisions

| Decision                                          | Chosen                                    | Rejected                            | Why                                                                                               | Reference                                         |
| ------------------------------------------------- | ----------------------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| Where the last 26 lines come from                 | Split the rationale into its own file     | Relocate ~26 lines into `CLAUDE.md` | Relocation buys lines without reducing anything, and puts a why in the operating half             | `ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES` |
| Whether to keep `doctrine-drift.sh` in the flag   | Remove it, record `N/A` with the cause    | Re-scope it as US001 did            | Its scan roots exclude `code/src/scripts/**`; there is no narrowed claim it could answer          | `ADR-US002-BLIND-GATE-LEAVES-THE-FLAG`            |
| How `doc-references.sh` is read                   | Identity diff against a captured baseline | Exit 0                              | The gate is red before the story starts, for 22 findings it does not own                          | `ADR-US003-CITATION-GATE-BASELINE-DIFF`           |
| Whether US002 fills the four owed Dependency rows | Yes                                       | Leave room for them as future work  | "Every register complete" is otherwise undecidable, and the two scenarios contradicted each other | `QA-PLAN-US002` AC-GAP-9                          |
| The `CLAUDE.md` ceiling                           | 200 counted lines                         | The 270 warn tier                   | 270 licenses filling the sibling from 165 to 269 — moving the wall rather than removing it        | `code/docs/DOCUMENTATION-LENGTH.md` Section 6     |

## Dependencies

| Story | Relationship | Detail                                                                                          |
| ----- | ------------ | ----------------------------------------------------------------------------------------------- |
| US001 | Independent  | Shares no file. Either order is correct; the sprint plan recommends US002 first on blast radius |
| US003 | Independent  | SPRINT-02. Its baseline-diff ADR binds this story                                               |

- **Blocked by:** nothing. Wave 0.
- **Blocks:** nine audit registrations across eight slices and seven maps — the table in
  `../02-STORIES/US002.md` <!-- doc-references: template-only --> names each.
- **Can be done now:** yes, in full, once `pm/story-creation` is merged and the branch is cut.
- **Known collision:** `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` <!-- doc-references: template-only --> slice `S-01` owns a correction inside an
  inventory row this story moves. This story settles the row's final text; `S-01` inherits it.

## GDPR

**Not applicable.** The story's `GDPR` flag reads `N/A`. It creates and edits Markdown in a
scripts directory: no field, no store, no code path that could carry personal data, and no data
subject involved. Section dropped rather than filled with "none" per row.

## Security

**Not applicable.** The story's `Security` flag reads `N/A`. **It introduces no mutation**, so the
template's rule that every mutation carries an explicit permission check and ownership
verification has no subject here — there is no endpoint, no state change, no user-supplied ID and
no role boundary. Stated explicitly rather than by deleting the section, because a missing
Security section and a Security section that says "no mutations exist" read very differently.

## Logging & Observability

**Not applicable.** The story's `Logging` flag reads `N/A`. No runtime code, so no log line.

## Performance, Rendering, Responsive & Accessibility

**Not applicable.** No rendered surface. The output is Markdown read in an editor or on a
repository host, neither of which this project ships.

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✓ → `03-sprint-planning` ✓ → `11-qa-checks` ✓ → `15-decisions` ✓ →
`16-sprint-plans` ✓ → **`17-story-plans` (this document)** → `22-implementation-documentation` →
`23-pr-and-review`.

Gates `04`–`10` and `12`–`14` were skipped on `N/A` flags, each with its reason in the story's
FLAGS table.

### Code workflows invoked

**None.** `19-backend-code`, `20-api-code` and `21-frontend-code` have no subject: the story ships
no Python, no endpoint and no template. This is the only story shape where the code-workflow chain
is legitimately empty, and the sprint plan records the same disposition.

### Standards gates

`docs-length.sh` · `docs-pairing.sh` · `doc-references.sh` (as a diff) · markdown lint and format.
`doctrine-drift.sh` is **declared blind** — its scan roots exclude this tree.

## Testing

**No automated test suite.** The story adds no code path, so there is no unit, integration, API,
contract or browser test to write, and **no coverage figure to report**. `code/docs/TESTING.md`'s
75%/90% floors bind code, and none is added — recorded here rather than left to be inferred as a
pass.

The verification is the audit suite plus a recorded human read-across. The read-across is not a
convenience: three of this story's acceptance criteria are decidable by nothing else.

| Check                           | How                                                                          |
| ------------------------------- | ---------------------------------------------------------------------------- |
| The target is met               | `docs-length.sh --path code/src/scripts/audits --limit 1`                    |
| The pair is intact              | `docs-pairing.sh` exits 0                                                    |
| No new citation broken          | `doc-references.sh` diffed by identity against Step A's baseline             |
| The rationale survived whole    | Human read-across of `SLOP-FAMILY.md` against the three enumerated arguments |
| Each route lands on a real rule | Human read-across — open each route's target and confirm it states the rule  |
| The register inventory balances | Before/after counts recorded in `../18-TESTS/US002-MANUAL-TESTING.md`        |
| The forward demand fits         | 27 rows dry-run into the shrunk file; it stays under 270                     |

## Documentation Write-Ups (Implementation Records)

Owned by `22-implementation-documentation`. This story produces
`../18-TESTS/US002-MANUAL-TESTING.md` carrying the baseline, the before/after register inventory,
the relocation-versus-deletion split required by `code/docs/DOCUMENTATION-LENGTH.md` Section 6, the
27-row dry run, and the read-across sign-off.

## CONTEXT.md & Index Updates

- `code/src/scripts/audits/CONTEXT.md` — the Directory Tree gains a row for `SLOP-FAMILY.md`.
- `code/src/scripts/audits/CLAUDE.md` — re-resolve its three citations into `CONTEXT.md`; do not
  let it absorb content, and confirm it ends at or under 200 counted lines.
- **The Plans Index row is declined, on the record.**
  `project-management/workflows/17-story-plans/STEPS.md` Step 10.2 requires a row in
  `../17-STORY-PLANS/CONTEXT.md` → _Plans Index_. **That section does not exist, and the row is
  not added.** `CONTEXT.md` is re-included by `copier.yml` <!-- doc-references: template-only --> and therefore **ships**, so an
  instance row naming a `STORY-PLAN-US###` would put a per-project citation in a shipped file —
  the same defect ten feature maps declined for `../01-FEATURE-MAPS/CONTEXT.md`, and the reason
  that index still reads _"None charted yet"_ against twelve maps. `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` <!-- doc-references: template-only --> slice
  `S-01` owns relocating these indexes into seeded files and its `N-003` gate names
  `STORY-PLAN-INDEX.md` specifically. **The decline stands until that slice lands.**
- **No new directory**, so no new `CONTEXT.md`/`CLAUDE.md` pair is owed. `SLOP-FAMILY.md` is a
  third file in an existing paired directory, and `docs-pairing.sh` is directory-level.

## Deferred Items

- **The `doc-references.sh` repair itself.** Owned by `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> slice `S-06` and blocked
  on that map's RESOLVE sitting. This story works around it by diff and does not touch the script.
- **Widening `doctrine-drift.sh`'s scan roots** to include `code/src/scripts`. Same owner, same
  blocker; recorded in `ADR-US002-BLIND-GATE-LEAVES-THE-FLAG` as the condition that retires it.

## Risks

| Risk                                                                                                                                                  | Likelihood | Impact | Mitigation                                                                                  |
| ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------ | ------------------------------------------------------------------------------------------- |
| Step E yields fewer lines than the 9 estimated, and the file lands above 230                                                                          | Medium     | Low    | ~30 further unprotected lines remain; and 270 is the gate, 230 the target, per the story    |
| The baseline is captured after the first edit and cannot distinguish new findings                                                                     | Low        | High   | Step A is first in a stated dependency chain, and the QA plan carries it as a separate task |
| The rationale is summarised into the route stub rather than moved                                                                                     | Medium     | Medium | The read-across checks all three arguments survive **in the new file**, not "somewhere"     |
| The four external workflow citations are missed because no gate checks them                                                                           | Medium     | Medium | All eight are enumerated in the story and in Step H; closed by recorded read-across         |
| `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` <!-- doc-references: template-only --> `S-01` later reverts the inventory row | Low        | Low    | The collision is named in both the story and this plan; `S-01` inherits this story's text   |

## Definition of Done

- [ ] `code/src/scripts/audits/CONTEXT.md` at or under 230 counted lines, measured with `--limit 1`
- [ ] `slop-family/CONTEXT.md` exists, carries the three arguments whole, and is
      registered in the Directory Tree
- [ ] `code/src/scripts/audits/CLAUDE.md` at or under 200 counted lines
- [ ] The Dependencies register carries a row for all 24 scripts
- [ ] The `docs-length-allow` comment is retired
- [ ] All eight inbound citations re-resolved and repointed
- [ ] `docs-length.sh`, `docs-pairing.sh`, markdown lint and format all pass
- [ ] `doc-references.sh` shows no new finding against the recorded baseline
- [ ] `doctrine-drift.sh` recorded `N/A` with its cause — never as a pass
- [ ] `../18-TESTS/US002-MANUAL-TESTING.md` carries the baseline, the inventory balance, the
      deletion/relocation split and the 27-row dry run
- [ ] A tester other than the author has signed the read-across off
- [ ] Story `**Status:**` moved to `Completed`; the Plans Index row updated
