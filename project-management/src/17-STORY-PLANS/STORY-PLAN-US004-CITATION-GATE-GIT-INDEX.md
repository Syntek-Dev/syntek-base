# STORY-PLAN-US004 — The citation gate stops depending on the git index

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 02/09/2026                         |
| Branch | `us004/citation-gate-git-index`    |
| Sprint | SPRINT-02 · Wave 1 · build order 1 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

Implements `../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` (Check 2 reads
the citing file's name, never `is_template_only()`) and
`../15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md` (a registered path may
name a class, with `###` translated to three digits exactly).

> **Source authority.** Where this plan and `../02-STORIES/US004.md` differ on a **measurement**,
> **this plan wins** — its figures were produced by executing a patched copy of the script, and
> the story's two reading-derived claims were both wrong. Where they differ on **what must be
> true**, the story wins. On how a gate's result is reported, `code/docs/GATE-REPORTING.md` wins
> over both.

---

## Problem Statement

`code/src/scripts/audits/doc-references.sh` gives **different verdicts on identical bytes**
depending on whether the file has been `git add`ed. `candidates()` (`:307-310`) scans tracked
**plus** untracked-but-not-ignored files; `build_template_only()` (`:432`) reads `git ls-files`,
which returns tracked only. An uncommitted PM artefact therefore never enters `TEMPLATE_ONLY`,
`file_ships` computes `true` for a file that will never ship, and Check 3 fires on every citation
it makes to a committed, copier-excluded sibling.

Measured on `../02-STORIES/US003.md`, byte-identical between runs:

| State                     | `[template-only citation]` | `[dangling path]` |
| ------------------------- | -------------------------- | ----------------- |
| untracked (`??`)          | **5**                      | 3                 |
| `git add --intent-to-add` | **0**                      | 3                 |

Three further defects compound it, all measured at `7a82095` plus the working tree:

- **`is_exempt()` exempts nine shipped files.** The `research/`, `learning/`, `handoffs/`,
  `.copier/` and `01-FEATURE-MAPS/` arms exempt whole trees, but `copier.yml:120-146` re-includes
  `**/CONTEXT.md`, `**/CLAUDE.md` and `**/*TEMPLATE*` out of them. Those nine ship and are unpoliced.
- **Check 1 cannot see `project-management/src/`.** Its checkable-tree `case` (`:762-781`) has no
  arm for the tree, so a dead PM citation is dropped before its existence test.
- **Check 2's alternation names two dead conventions** — `ADR-[0-9]{3}`, retired 31/08/2026, and
  `QA-US[0-9]{3}` against a live `QA-PLAN-US###-<DESCRIPTOR>.md`.

The cost is live and recorded: every story since 01/09/2026 carries a written disposition for this
script's output, and `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` binds
the whole backlog to reading a red gate as a diff against a baseline **until this story lands**.
Whole-tree run at planning: **44 findings**, 989 files read, 87 exempt, 30,095 tokens, 5,665 path
tests.

## Reference Documents (code/docs gate map)

| Concern                        | Document                                                     | What it binds here                                                        |
| ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------------------- |
| Reporting a gate's result      | `code/docs/GATE-REPORTING.md`                                | Six findings survive this story; none may be reported as a pass           |
| What a document may promise    | `code/docs/FORWARD-VOICE.md`                                 | Section 3 owns the register this story makes pattern-aware                |
| The register itself            | `how-to/src/PROJECT-PATHS.md`                                | Two new rows; its rule against answering a question in passing            |
| Length limit and the ratchet   | `code/docs/DOCUMENTATION-LENGTH.md`                          | `audits/CONTEXT.md` sits at 298/300; this story may not grow it           |
| The audit register's own rules | `code/src/scripts/audits/CLAUDE.md`                          | Row conventions for the file whose `doc-references.sh` entry is refreshed |
| Story                          | `../02-STORIES/US004.md`                                     | Eight scenarios, the acceptance this plan implements                      |
| QA                             | `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` | Nine resolved AC-gaps, the scenario tables, and the measurement method    |
| Sprint plan                    | `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`                    | Build order, phase disposition, gate-honesty constraint                   |
| Feature map                    | `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`                   | Slice `S-06`, nodes `N-009` and `N-010`, and Batch D's measurements       |

**Not applicable, and why:** `../04-DATABASE/`, `../05-USER-FLOW/`, `../06-BRAND-GUIDE/`,
`../07-COMPONENTS/`, `../08-WIREFRAMES/`, `../09-GDPR/`, `../10-SECURITY/`, `../12-SEO/`,
`../13-API-DESIGN/`, `../14-LOGGING/` — the story's corresponding flags all read `N/A`. It edits
one bash script, its fixtures, one register and four Markdown files: no model, endpoint, screen,
personal-data path, log line or public page.

## Architecture Decision

**Two records, both `Accepted`, both authored at `15-decisions` because neither trade-off was
visible until `11-qa-checks` measured it.**

`ADR-US004-INSTANCE-ARTEFACT-CITER-TEST` settles that Check 2 asks whether the **citing file is
an instance artefact**, read from its filename. The obvious alternative — `is_template_only()` —
is inert in every generated project, because `build_template_only()` returns early when
`copier.yml` is unreadable and `copier.yml:36` excludes itself. `N-009` Q31 rejected that same
delegation in this same script four days earlier. The other alternative, a
`project-management/src/*` glob, exempts roughly twenty shipped files copier re-includes, two of
which carry a genuine finding today.

`ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS` settles that `is_registered()` — today
`grep -qxF`, fixed-string and whole-line — translates `###` to three digit classes, so one row
binds a per-story artefact class instead of two rows per story forever.

**The measurement that forced the phase shape**, taken by patching a scratch copy of the script
and running it scoped to `project-management/src`:

| Change                                       | dangling-path findings | Reading                                               |
| -------------------------------------------- | ---------------------- | ----------------------------------------------------- |
| Stock script                                 | 16                     | The tree is invisible to Check 1                      |
| `project-management/src/*` arm, nothing else | **38**                 | +22, **every one** a forward reference to `18-TESTS/` |

**Not one of the 22 is a naming pattern.** Check 1 already carries the line-level `is_naming_row`
guard at `:791`. The story's original plan to add a second, token-level guard was dropped at
AC-GAP-1 as a restatement — the defect this story's own map exists to remove.

## Approach

### Not applicable — Database, Service Layer, API, Frontend

This story adds no Python, no template and no component. The four layer sections the template
carries are dropped because the story touches none of them, not to dodge a gate.

### Phase plan — five phases, each red before green

**Every phase writes its failing proof first**, per `code/workflows/02-tdd-cycle/` applied to a
bash gate. The reason is structural, not stylistic: once five repairs are in, the pre-change
script no longer exists to test a fixture against without stashing, and
`../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` makes "fails against the pre-change
script" a named criterion.

| Phase | Deliverable                                | Proof mode             | Blocked by |
| ----- | ------------------------------------------ | ---------------------- | ---------- |
| P1    | `is_exempt()` fall-through arm             | Direct assertion       | —          |
| P2    | `build_template_only()` population         | Direct probe + `trap`  | —          |
| P3    | Check 2 citer test + alternation spellings | Fixture pair           | —          |
| P4    | The PM tree becomes checkable              | Fixture pair           | —          |
| P5    | The sweep, and the records it owes         | Whole-tree measurement | P1–P4      |

**P1 — the exemption arm.** One fall-through arm for `*/CONTEXT.md`, `*/CLAUDE.md` and
`*TEMPLATE*`, placed **ahead** of the tree arms so all nine shipped files enter. It mirrors
`copier.yml:120-146`'s three negations rather than listing folders, so the two cannot drift. The
standing `"none of these ship"` comment is corrected in the same edit: true of the folders, never
true of the nine files. Proved by a direct assertion that `research/CONTEXT.md` is no longer
exempt — a fixture cannot reach a predicate.

**P2 — the population.** `build_template_only()` reads the same population `candidates()` reads:
tracked plus untracked-but-not-ignored. Proved by a probe that creates a temporary untracked file
under an excluded tree, **re-runs `build_template_only` and `build_template_only_index`**, asserts
`is_template_only` answers yes, and removes it. The re-run is not optional — both builders run
once at `:485-486` and `self_test()` is not called until `:913`, so a probe without it asserts
against a set built 428 lines earlier and passes for the wrong reason (AC-GAP-8). It carries a
`trap` so a failure between creation and assertion leaks nothing.

**P3 — Check 2.** The exemption tests whether the citing file is an instance artefact — `US###`,
`SPRINT-##`, `ADR-US###`, `QA-PLAN-US###`, `STORY-PLAN-US###`, `SPRINT-PLAN-##`, `REVIEW-US###`,
`BUG-*` — with `US000` and `*TEMPLATE*` excluded, those being the allowlist's only instance-shaped
entries. The alternation gains `ADR-US[0-9]{3}`, drops `ADR-[0-9]{3}`, and corrects
`QA-US[0-9]{3}` to `QA-PLAN-US[0-9]{3}`. The `clean/` fixture must include a `US000-` file:
instance-shaped, shipped, and therefore **not** exempt.

**P4 — the PM tree, and it is one phase for a measured reason.** Check 1's `case` gains a
`project-management/src/*` arm; `is_registered()` gains the `###` translation;
`how-to/src/PROJECT-PATHS.md` gains its two rows; `code/docs/FORWARD-VOICE.md` Section 3 and the
register's header state that a row may be patterned and carry the duty to add one.

**These cannot be split.** The arm alone reddens the tree by 22 findings, and the register rows
are what makes them pass — landing the arm without the rows leaves the gate red on correct
citations, which is the false-positive mirror of the defect this story fixes. Two rows only:
`18-TESTS/US###-MANUAL-TESTING.md` and `18-TESTS/US###-TEST-STATUS.md`. **No `17-STORY-PLANS`
row** — measured, nothing in the repository cites a story plan that does not exist, and a row for
it would be the register answering a question in passing (AC-GAP-6).

**P5 — the sweep and the records.** Repair every shipped file that genuinely cites an excluded
per-project instance — `project-management/src/02-STORIES/CONTEXT.md:16`,
`project-management/src/03-SPRINTS/CONTEXT.md:17` and
`how-to/src/TEMPLATE-GUIDE/10-FIRST-FEATURE.md` at minimum, **the set re-measured rather than
taken from this list**. Mark `research/CLAUDE.md:26` `doc-references: ignore`: its backticked
`LICENSE` names an upstream source's licence file, not this repository's own, so it is a
generic-noun false positive and not the genuine finding `N-009` claimed. Record that overturned
claim on the map. Close `GAPS.md`'s 02/09/2026 entry and correct its stale blocked-by sentence.

### Pre-existing corrections this story owes

- **`MAP-RULE-OWNERSHIP.md` N-009** — its "the one finding is genuine" claim is overturned, with
  the sentence quoted, in the same change.
- **`GAPS.md` 02/09/2026** — the "blocked on that map's RESOLVE sitting" sentence was true when
  written and false since 28/08/2026. Corrected, not deleted.
- **`code/src/scripts/audits/CONTEXT.md`** — the `doc-references.sh` row's text is replaced
  **within** the row. Never a new line: the file is at 298 of 300 and US002 owns its shape.

## Key Decisions

| Decision                                    | Chosen                             | Rejected                                          | Why                                                                     |
| ------------------------------------------- | ---------------------------------- | ------------------------------------------------- | ----------------------------------------------------------------------- |
| How Check 2 knows a citer ships             | Instance-artefact filename test    | `is_template_only()` · `project-management/src/*` | Inert downstream · exempts ~20 shipped files (ADR, AC-GAP-4/5)          |
| How a register row covers a class           | `###` → three digit classes        | One row per story · shell globs · 22 markers      | Unbounded · only glob in a repo of `###` · writes a false justification |
| Whether Check 1 gains a second naming guard | No                                 | Token-level guard                                 | `:791` already carries one; a restatement (AC-GAP-1)                    |
| Whether Check 3's citer test changes too    | No — the population fix carries it | Instance test on Check 3 as well                  | Empty `TEMPLATE_ONLY` downstream is correct, not blind                  |
| What "done" means for the gate              | A class delta, survivors named     | `exits 0`                                         | Six findings belong to US002 and US003 (AC-GAP-3)                       |
| Phase shape                                 | Red → green per repair             | Repairs then proofs                               | The pre-change script stops existing to test against                    |

## Dependencies

| Story | Relationship                                                                                                                                            |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| US002 | **Softly blocking.** It shrinks `code/src/scripts/audits/CONTEXT.md` 298 → 230. Building SPRINT-01 first removes a constraint P5 otherwise works around |
| US003 | **Blocked by this story.** Its baseline-diff scenario, QA task and ADR are all written against the defect P1–P4 remove                                  |
| US001 | Independent. Its two ADRs disposed of the same defect and are unaffected                                                                                |

- **Blocked by:** nothing. `MAP-RULE-OWNERSHIP`'s frontier is empty and its `Gate to stories`
  records `02-story-creation` as unblocked. `GAPS.md`'s claim that `S-06` is blocked on that map's
  RESOLVE sitting is **stale** — the sitting closed 28/08/2026.
- **Blocks:** slice `S-01` on `../01-FEATURE-MAPS/MAP-NAVIGATION.md`, which changes the same
  script's citation emit; and the retirement of the baseline-diff regime for the whole backlog.
- **Can be done now:** all five phases. Nothing waits on another story.

## GDPR

**Not applicable.** The story's `GDPR` flag reads `N/A`. No personal data is read, written or
logged; the script reads repository documentation and emits paths. Section dropped rather than
filled with "none" per row.

## Security

The `Security` flag reads `N/A` — no endpoint, no view, no protected action, no mutation, so the
permission-check and IDOR rows the template carries have no subject. **One property is asserted
anyway**, because P2 writes inside the repository:

| Concern                    | Obligation                                                                                   |
| -------------------------- | -------------------------------------------------------------------------------------------- |
| The self-test probe's file | Created under a path the repository already owns, never `/tmp` with a predictable name       |
| Its removal                | A `trap`, firing on every exit path, so a failed assertion leaks no untracked file           |
| The script's output        | Paths taken from backticked spans in committed documentation — no secret, token or env value |

## Logging & Observability

**Not applicable.** The `Logging` flag reads `N/A`. The script's only output is its findings
report, and its shape is unchanged: `file:line [class] token`.

## Performance, Rendering, Responsive & Accessibility

**Not applicable** — no rendered surface, no layout, no breakpoint. One performance property is
inherited and must not regress: `TEMPLATE_ONLY_BASE` exists so Check 3 costs one associative
lookup per token rather than a `dirname` and a `stat`, measured at 7 s against 2m14s. **P2 widens
the population that index is built from, so the whole-tree runtime is re-measured** and recorded
beside the finding counts.

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✅ → `03-sprint-planning` ✅ → `11-qa-checks` ✅ → `15-decisions` ✅ →
`16-sprint-plans` ✅ → **`17-story-plans` (this document)** → the lane below →
`22-implementation-documentation` → `23-pr-and-review`.

**No code lane.** `19-backend-code`, `20-api-code` and `21-frontend-code` are all `N/A` on this
story's flags. The work runs directly against `code/src/scripts/audits/` and its fixtures.

### Standards gates

Every command through `code/src/scripts/**/*.sh`. ShellCheck via `syntax/lint.sh` covers the
edited script; `syntax/format.sh --file-type markdown` covers every document touched.

## Testing

**One coverage floor does not apply** — the story ships no Python path, so
`tests/all.sh --coverage` is `N/A` with a reason rather than a skipped box. The proof is the
script's own `--self-test`, which carries both modes this story needs.

| Layer               | Method                                                                               |
| ------------------- | ------------------------------------------------------------------------------------ |
| Predicates (P1, P2) | Direct assertions in the `st_set_probe` style — a fixture cannot reach a predicate   |
| Clauses (P3, P4)    | `broken/` and `clean/` fixture pairs with expected finding counts                    |
| Regression          | The existing "fixture tree is exempt from an ordinary run" assertion must still pass |
| Whole tree (P5)     | Before/after counts, exit codes, and the runtime, all recorded                       |
| Manual              | The tracked/untracked A/B reproduced before and after, index restored each time      |

**Two rules from the QA plan bind every case:** a fixture that passes both scripts proves nothing,
and no existing probe is weakened to accommodate a change — a moved expected count carries its
justification in its own comment.

**Measure by executing, never by reading.** Two claims in the story made by reading the script
were wrong and both became AC-gaps. Every figure in this plan is reproduced at implementation.

## Documentation Write-Ups (Implementation Records)

`22-implementation-documentation` owns the records and writes
`../18-TESTS/US004-TEST-STATUS.md` and `../18-TESTS/US004-MANUAL-TESTING.md` — **both of which
this story's own P4 register rows make citable in advance**, which is the story demonstrating its
own deliverable.

## CONTEXT.md & Index Updates

| File                                       | Change                                                                         |
| ------------------------------------------ | ------------------------------------------------------------------------------ |
| `code/src/scripts/audits/CONTEXT.md`       | `doc-references.sh` row text replaced **within** the row — no new line         |
| `how-to/src/PROJECT-PATHS.md`              | Two rows, plus the header note that a row may be patterned                     |
| `code/docs/FORWARD-VOICE.md`               | Section 3 gains the pattern form and the duty to add a row                     |
| `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` | `S-06`'s `Story` cell already reads `US004`; N-009's overturned claim recorded |
| `GAPS.md`                                  | 02/09/2026 entry closed; its stale blocked-by sentence corrected               |
| `../17-STORY-PLANS/CONTEXT.md`             | Plans Index row for this plan                                                  |

## Deferred Items

- **`GAPS.md`'s 01/09/2026 entry** — the three shipped files still instructing the `CONTEXT.md`
  index row. Adjacent subject, owned by no slice on any map. **Not** taken here.
- **The `MAP-GATE-PARITY` question** — whether a gate means the same thing in a generated
  project. `ADR-US004-INSTANCE-ARTEFACT-CITER-TEST` is one instance and claims none of its scope.
- **Check 1's line-level naming guard suppressing a real dangling path** on a line containing
  "e.g." — a known limitation, recorded as EC-04 in the QA plan, **not** introduced by this story
  and not fixed by it.

## Risks

| Risk                                                                   | Mitigation                                                                    |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| P4 lands the arm without the register rows and reddens the tree by 22  | The two are one phase, and the phase's exit criterion is the whole-tree delta |
| A new per-story artefact class silently loses its Check 2 exemption    | Named in the ADR's Consequences; the `clean/` fixture pins the current set    |
| The parallel session moves the tree under the before/after measurement | Both halves taken in one sitting; the count moved 22 → 44 during 02/09/2026   |
| P2 slows the whole run by widening the index population                | Runtime re-measured and recorded beside the counts                            |
| `audits/CONTEXT.md` grows past 300 before US002 lands                  | P5 replaces text within the existing row and adds no line                     |

## Definition of Done

- [ ] All five phases complete, each having failed against the pre-change script first
- [ ] `doc-references.sh --self-test` exits 0, probe count risen by one case per repair
- [ ] No finding remains of the three classes this story owns; every survivor named with its owner
- [ ] The 16 → 38 and 5 → 0 measurements reproduced and recorded, not inherited from this plan
- [ ] `GAPS.md`'s 02/09/2026 entry closed against all three retirement conditions
- [ ] N-009's overturned claim recorded on `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`
- [ ] `syntax/lint.sh` passes, including ShellCheck over the edited script
- [ ] Plans Index row added; story cross-references this plan
- [ ] Reviewed and approved; merged; `../02-STORIES/US004.md` status set to **Completed**
