# QA Implementation Review — US003 Absence gets an owning guide, born under 270 with every clause's tier stated

| Field        | Value                                                                                                                            |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US003 — absence gets an owning guide, born under 270 with every clause's tier stated                                             |
| **Date**     | 05/11/2026                                                                                                                       |
| **Sprint**   | SPRINT-02 (worked there ahead of US004, so the baseline procedure ran as written)                                                |
| **Reviewer** | Claude (a `22-implementation-documentation` subagent that made none of the edits), on Sam's behalf                               |
| **Branch**   | `us003/absence-guide`, cut from `testing` at `b7c7c2c`; walked at `01dd924`, re-walked at `0471087`; records staged on `0471087` |
| **Plan doc** | `../PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md`                                                                                     |
| **Outcome**  | Pass with deviations — every scenario met after the walk-fail fix; one row amended (BAN-02, F-001)                               |

---

## 1. Scope

**What shipped:** `code/docs/ABSENCE.md` — six kinds of absence, their decision order and
tie-breaks, a 30-cell crib over Python, Rust, Alpine, HTMX and mobile TypeScript, the absence-enum
and never-overload rules — at **205** counted lines; its three index rows; reciprocity from four
skills; the `owned absence-enum` drift row with fixtures; `codebase-design`'s _boundary_ ban
scoped; the Harper _Influences_ row in both READMEs. Markdown, plus one regex row and three fixture
files. There is no backend, API or frontend.

**Matches the plan's scope, re-cut at the build's first step** (plan _Key Decisions_, Q1 to Q4,
04/11/2026): the four skills measured 137 · 130 · 169 · 118, not the plan's 169 · 155 · 220 · 148;
`codebase-design` had five "boundary" lines, not four; the citation baseline was 564 findings, not
seven; the heading inventory was 33 lines, not 20. **Widened by the review-fix grilling** (D1 and
D2, 05/11/2026): the HTMX miss is stated conditionally on the listener's 4xx leg, and Alpine does
not fetch.

**No other spec applies.** The story's FLAGS read N/A for every row but `QA`. Listing every
PLANNING folder for US003 on 05/11/2026 found only this QA plan:
`project-management/src/09-GDPR/PLANNING/`, the four 10-SECURITY category PLANNING folders,
`project-management/src/12-SEO/PLANNING/`, `project-management/src/13-API-DESIGN/PLANNING/` and
`project-management/src/14-LOGGING/PLANNING/` hold nothing for US003. No other IMPLEMENTATION
record is owed.

## 2. Acceptance-criteria gaps closed

The plan resolved all seven gaps into the story on 02/09/2026, before code. Each is checked here
against what shipped.

| Gap      | Status   | Evidence                                                                                                                                                                                  |
| -------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-GAP-1 | Resolved | 30 cells, none blank, a bare dash or "varies"; Alpine's not-yet and failure each say "Cannot arise" with the reason (KINDS-05, KINDS-06)                                                  |
| AC-GAP-2 | Resolved | 20 inline markers on rule clauses, none document-level, none in a crib cell (TIER-01, TIER-04)                                                                                            |
| AC-GAP-3 | Resolved | A decision order whose sixth row is the residual, and six tie-breaks between neighbours (KINDS-02, KINDS-03). QA round 1 F-005's aggregate counter-example was refuted on row 6's wording |
| AC-GAP-4 | Resolved | The growth rule read from `docs-length.sh --since`; no edited file at or above 270 grew (LENGTH-02 to LENGTH-04, BITE-06)                                                                 |
| AC-GAP-5 | Resolved | Cells self-contained at birth: no link, path or map identifier in any cell (KINDS-07). The slices' back-link obligation is held for their stories (findings F-004, F-014)                 |
| AC-GAP-6 | Resolved | Convergence: no Codd row; the guide's parallels sentence instead, the primary source read first (CREDIT-02, CREDIT-03)                                                                    |
| AC-GAP-7 | Resolved | Each of the five lines checked under the new scope, four reworded to "seam", in the change that scoped the ban (BAN-02 amended, F-001; BAN-03)                                            |

## 3. Scenario verification

All evidence is manual: the story has no suite (`../../18-TESTS/AUTOMATED/US003-TEST-STATUS.md`).
Each row ID refers to `../../18-TESTS/MANUAL/US003-MANUAL-TESTING.md`, walked 05/11/2026 at
`01dd924` by an agent that authored neither the change nor its reviews — 46 Pass, 1 Fail
(BOUNDARY-06), one amended — then BOUNDARY-06 and the 23 rows its fix touched re-walked at
`0471087` by a second independent agent: **47 Pass, 0 Fail**.

### Happy Path

| ID    | Scenario (from plan)                                                        | Result | Evidence                                                                                                                                    |
| ----- | --------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | The guide exists with header, frontmatter and index rows                    | Pass   | GUIDE-01 to GUIDE-03 (`routing-skills.sh` exit 0, 612 names; the wrapped-array form probed), REGISTER-01                                    |
| HP-02 | Under 270; no edited file at or above 270 has grown                         | Pass   | LENGTH-01 (205, 65 clear), LENGTH-02 (`--since b7c7c2c` exit 0, 807 files), LENGTH-03 (the three approaching untouched)                     |
| HP-03 | Six kinds, exhaustive and exclusive; a 6 × 5 crib with no empty cell        | Pass   | KINDS-01, KINDS-02, KINDS-04 (five surface columns), KINDS-05 (30 cells)                                                                    |
| HP-04 | Rust cited; the absence-enum rule stated; `doctrine-drift.sh` exit 0        | Pass   | BOUNDARY-01 (`TYPES-RUST.md` → _Option and Result, never sentinels_), BOUNDARY-02, DRIFT-02                                                 |
| HP-05 | Every clause marked; every `[gate: fail]` names its gate; no `[gate: warn]` | Pass   | TIER-01 to TIER-04 — 19 `[judgement]`, 1 `[gate: fail]` naming `doctrine-drift.sh`, claim `absence-enum`, and its path-filtered CI workflow |
| HP-06 | The four skills cite the guide; `skill-conformance.sh` exit 0               | Pass   | RECIP-01, RECIP-02                                                                                                                          |
| HP-07 | One `owned` drift row, green on the baseline                                | Pass   | DRIFT-01 (`doctrine-drift.sh:94`), DRIFT-02 (exit 0, 4 claims; `--self-test` exit 0)                                                        |
| HP-08 | The ban scoped; the file's own uses compliant                               | Pass   | BAN-01; BAN-02, amended from four uses to five lines (F-001)                                                                                |
| HP-09 | Harper row; Codd row or its convergence sentence, never neither or both     | Pass   | CREDIT-01, CREDIT-02 (sentence, no row), CREDIT-03; CREDIT-04 (each row in its rule's commit; the seeded README's copy at `8a9e245`)        |

**The citation gate, read as a diff (EC-07).** `code/src/scripts/audits/doc-references.sh` exits 1
at both ends and is reported per
`../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`.
Baseline at `5baaac2`, tree clean: **564 findings, 269 identities**. After the build (`99187e7`)
and at the walk run (`01dd924`), detector sha256 matching: **499 findings, 251 identities**. **0 new
identities; 18 identities (65 findings) gone**, every one a dangling path to `code/docs/ABSENCE.md`.
The walk-fail fix changed one shipped file; the scoped run on it exits 0 (DOCREF-01). This is not a
pass: the gate is red, and the story neither caused nor owns the survivors. The automated record's
generated block adds one identity (F-025).

### Error States

| ID    | Scenario (from plan)                            | Result | Evidence                                                                                                                                                |
| ----- | ----------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | The guide born at 270 or more                   | Pass   | BITE-01: the warn tier with no allowance                                                                                                                |
| ES-02 | A named skill does not cite the guide back      | Pass   | BITE-02: exit non-zero, clause 14 named                                                                                                                 |
| ES-03 | A frontmatter name does not resolve             | Pass   | BITE-03                                                                                                                                                 |
| ES-04 | A TYPES rule duplicated in the guide's prose    | Pass   | BITE-04, as corrected 09/10/2026 to the human read-across; and **for real** at BOUNDARY-06, which caught the `case _:` restatement at `01dd924` (F-002) |
| ES-05 | A crib cell cites a clause no slice has written | Pass   | BITE-05, with the repo-rooted form. A file-relative link passes green (finding F-017)                                                                   |

### Edge Cases

| ID    | Scenario (from plan)                                  | Result | Evidence                                                                                                                     |
| ----- | ----------------------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | One absence plausibly not-supplied and not-applicable | Pass   | KINDS-03: _Not-applicable beats not-supplied_ resolves the VAT case to one kind                                              |
| EC-02 | A kind that cannot arise on a surface                 | Pass   | KINDS-06: Alpine not-yet and failure say "Cannot arise" with the reason. Absent at `8a9e245`, restored at `01dd924` under D2 |
| EC-03 | A later slice grows the guide past 270                | Pass   | BITE-06: the ratchet fires on the uncommitted growth, not the committed guide                                                |
| EC-04 | `stack-django` inside the warn band                   | Pass   | GUIDE-02: not among the four named skills                                                                                    |
| EC-05 | The Codd check returns convergence                    | Pass   | CREDIT-02: no row; the parallels sentence                                                                                    |
| EC-06 | One of the file's own uses still violates             | Pass   | BAN-02 (amended, F-001): `:36`, `:56`, `:70`, `:107` reworded in the scoping change                                          |
| EC-07 | `doc-references.sh` red before the guide is written   | Pass   | DOCREF-01, DOCREF-02 — the diff above                                                                                        |

### Permission and Access

N/A. The plan has no `PA` scenario: the story adds no runtime surface, endpoint or protected
action.

## 4. Deviations from plan

| Deviation                                                                                                                                                                | Justification                                                                                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **Figures re-cut at the build's first step** — the skills' line counts, five "boundary" lines, a 564-finding baseline, 18 forward-reference identities, eleven scenarios | Plan _Key Decisions_ Q1, settled with Sam 04/11/2026; dated trails in the story and plan                                                      |
| **The heading inventory brought into scope** — 33 lines across 27 files classified; none architectural                                                                   | Q2. The inventory read headings only, so body-line breaches surfaced at review (finding F-023)                                                |
| **No Codd row** — the guide's parallels sentence                                                                                                                         | Q3: the primary source shows convergence; the story's own negative branch (AC-GAP-6)                                                          |
| **The guide grew from 144 to 205 counted lines** across three review-fix rounds                                                                                          | Each round corrected crib cells against owner guides and library behaviour (the review record, R-001 to R-061); 65 lines clear of 270         |
| **The HTMX miss is a 200 partial, stated conditionally**                                                                                                                 | D1, settled by Sam 05/11/2026: today's 5xx-only listener; the 404 partial when the listener gains its 4xx leg (finding F-004)                 |
| **Alpine does not fetch**, so two Alpine cells state that the kind cannot arise                                                                                          | D2, settled by Sam 05/11/2026, following `code/docs/RENDERING.md`; the owner conflict with `TYPES-BROWSER.md` is finding F-008                |
| **`[gate: prose]` dropped** — the guide uses `[gate: fail]` and `[judgement]` only                                                                                       | Review R-003: Section 6 of `VISUAL-DESIGN.md` owns the legend and gives `[gate: prose]` another meaning. Departs from `N-015` (finding F-016) |
| **One manual row amended at the walk** — BAN-02                                                                                                                          | Against Q1 and Q2 (finding F-001)                                                                                                             |

## 5. New edge cases discovered

| ID          | Scenario                                                                                                       | Result | Evidence                                                    | Fold back?                                                      |
| ----------- | -------------------------------------------------------------------------------------------------------------- | ------ | ----------------------------------------------------------- | --------------------------------------------------------------- |
| BOUNDARY-06 | A review fix adds a clause restating a `TYPES-*` rule beside its citation                                      | Pass   | Failed at `01dd924`, fixed `0471087`, re-walked             | No — fixed on the branch (F-002); ES-04 now has a real instance |
| —           | A shipped guide names a template-only map slice or decision                                                    | Pass   | The walker's out-of-row note; DOCREF-01 re-walked, 18 files | Yes — carried as a check for every shipped-guide story (F-003)  |
| —           | A restatement spelt `enum.StrEnum`, `str, Enum`, `TextChoices`, a non-`Absence` name, `~~~`-fenced, Rust or TS | Open   | QA round 1 F-002; re-check RR3-03 — each exits 0            | Yes — the regex and fence toggle (F-015)                        |
| —           | A crib cell with a file-relative link to a nonexistent clause                                                  | Open   | QA round 1 F-003 — exits 0                                  | Yes — `doc-references.sh` (F-017)                               |
| —           | A back-citation inside an HTML comment satisfies clause 14                                                     | Open   | QA round 1 F-010                                            | Yes — `skill-conformance.sh` (F-018)                            |
| —           | A generated project without Rust: two `TYPES-RUST.md` links dangle                                             | Pass   | QA round 1 F-003; **Rust-only** flags added `8a9e245`       | No — by design, `code/docs/FORWARD-VOICE.md` Section 5 (F-022)  |
| —           | `shipped-readme.sh` red when a `code/docs/` guide is added without its seeded Project Tree entry               | Pass   | Red at `e1afd7b`, green at `8a9e245`                        | Yes — a close gate for such stories (F-020)                     |
| —           | Not-supplied's question read against a webhook, an integration and a stored record                             | Pass   | Rounds 1 to 3 (R-012, R-033, R-058); KINDS-01 re-walked     | No — the question names the supplier at `01dd924`               |

## 6. Deferred scenarios

None. Every scenario was walked; the re-walk covered every row the walk-fail fix touched.

## 7. Accessibility observations

- **axe-core:** N/A. No rendered route.
- **Keyboard & focus:** N/A. No interactive component.
- **Equal-weight actions:** N/A.
- **Other:** N/A. The story ships Markdown read in an editor or on a repository host. The guide's
  Alpine empty-state cell prescribes a component-local `role="status"` count as guidance; the
  missing `announce` listener it no longer relies on is finding F-009.

## 8. GDPR & security observations

- **PII at rest:** N/A. No personal data is processed.
- **PII in responses:** N/A.
- **Rights paths:** N/A.
- **Security gate:** N/A. No endpoint and no permission surface. The guide's anti-enumeration
  clause defers to `code/docs/security/AUTH-AND-AUTHZ.md`; the conflict between that owner and
  `api-design/CLIENT-PATTERNS.md` is finding F-006, not a vulnerability in shipped code.

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build (N/A, no rendered surface)
- [x] GDPR & security observations confirmed (or N/A recorded)
- [x] Coverage floors met for all modules in scope (no module in scope)
- [x] Manual testing sign-off (see `../../18-TESTS/MANUAL/US003-MANUAL-TESTING.md`) — walked by an
      independent agent, 47 Pass, 0 Fail. Countersigned by Sam on 05/11/2026 in session, at
      `23-pr-and-review`, after workflow 23 Steps 1, 2 and 6
      (`../../19-REVIEWS/REVIEW-US003-ABSENCE-GUIDE.md` → Section 2.5)
- [x] Reviewer approval — Sam, 05/11/2026 in session, at `23-pr-and-review`, accepting the recorded
      findings F-001 to F-025 and the `GAPS.md` carries, including D1's conditional HTMX cell

---

## Cross-references

- `../PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` — the pre-development plan verified here
- `../../02-STORIES/US003.md` — the story under review
- `../../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the plan, its Key Decisions (Q1 to Q4, D1, D2)
- `../../18-TESTS/AUTOMATED/US003-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US003-MANUAL-TESTING.md` — downstream test records
- `../../20-FINDINGS/FINDING-US003-ABSENCE-GUIDE-05-11-2026.md` — the findings this review cites
- `../../19-REVIEWS/REVIEW-US003-ABSENCE-GUIDE.md` — the three review rounds and the QA breaker pass
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
