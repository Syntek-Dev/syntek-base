# QA Implementation Review — US002 The audits register regains the headroom nine new gates need

| Field        | Value                                                                                                        |
| ------------ | ------------------------------------------------------------------------------------------------------------ |
| **Story**    | US002 — the audits register regains the headroom nine new gates need                                         |
| **Date**     | 03/11/2026                                                                                                   |
| **Sprint**   | SPRINT-02                                                                                                    |
| **Reviewer** | Claude (a `22-implementation-documentation` subagent that made none of the edits), on Sam's behalf           |
| **Branch**   | `us002/audits-register-headroom`, cut from `testing` at `81a80a2`; walked at `9da4e30`, records at `cd09348` |
| **Plan doc** | `../PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`                                                      |
| **Outcome**  | Pass with deviations — one scenario failed (HP-04, manual row OPS-01)                                        |

---

## 1. Scope

**What shipped:** Markdown only, plus the header comments of three CI workflow files (comments only). `code/src/scripts/audits/CONTEXT.md`
shrank from 299 to 226 counted lines by routing restatements to their owners; the AI-slop split
rationale moved whole into a new `code/src/scripts/audits/slop-family/` pair; the Dependencies
register gained its five owed rows; the `docs-length-allow` comment was retired; and every line
anchor into the register across the PM tree became a section and row name. There is no backend,
API or frontend.

**Matches the plan's scope, re-cut at the build's first step.** The plan was written against 298
lines, 24 scripts and a 27-row forward demand; the build measured 299, 27 scripts and re-cut the
demand to 33 rows (plan _Key Decisions_ Q1, Q1a to Q1c, settled with Sam 03/11/2026). The citation
set widened beyond the plan's eight to every live anchor into the file (Q1b).

**No other spec applies.** The story's FLAGS read N/A for every row but `QA`. Listing every
PLANNING folder for US002 on 03/11/2026 found only this QA plan:
`project-management/src/09-GDPR/PLANNING/`, the four 10-SECURITY category PLANNING folders,
`project-management/src/12-SEO/PLANNING/`, `project-management/src/13-API-DESIGN/PLANNING/` and
`project-management/src/14-LOGGING/PLANNING/` hold nothing for US002. No other IMPLEMENTATION
record is owed.

## 2. Acceptance-criteria gaps closed

The plan resolved all eleven gaps into the story on 02/09/2026, before code. Each is checked here
against what shipped.

| Gap       | Status   | Evidence                                                                                                                                                                                               |
| --------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| AC-GAP-1  | Resolved | `code/src/scripts/audits/doctrine-drift.sh` recorded N/A with its cause, never run as evidence (manual guide _Preconditions_; `../../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`) |
| AC-GAP-2  | Resolved | `code/src/scripts/audits/doc-references.sh` read as an identity diff against a baseline captured before the first edit: 0 new identities; 12 identities (16 findings) gone (DOCREF-01)                 |
| AC-GAP-3  | Resolved | (a), (b) and (c) named individually and each found whole in `code/src/scripts/audits/slop-family/CONTEXT.md` (RATIONALE-01 to RATIONALE-04)                                                            |
| AC-GAP-4  | Resolved | Every section-name citation and line anchor re-resolved by hand and listed with its target; never reported as gate-verified (CITE-01 to CITE-04)                                                       |
| AC-GAP-5  | Resolved | The figure read from `docs-length.sh --path code/src/scripts/audits --limit 1` (LENGTH-01)                                                                                                             |
| AC-GAP-6  | Resolved | Three rows per audit; counts recorded before and after: 27 · 29 · 27 · 22 → 27 · 32 · 27 · 27 (REGISTER-04)                                                                                            |
| AC-GAP-7  | Resolved | Replaced by a dry run — 33 rows (re-cut from 27), 259 counted lines (DRYRUN-01, amended, F-003)                                                                                                        |
| AC-GAP-8  | Resolved | The collision with "MAP-PROGRESSIVE-ENHANCEMENT" `S-01` stays named in the story; the inventory rows' text is US002's, and `S-01` inherits it                                                          |
| AC-GAP-9  | Resolved | The five owed Dependencies rows filled (five, not four — Q1); 27 rows for 27 scripts (REGISTER-03)                                                                                                     |
| AC-GAP-10 | Resolved | Relocation 58 and deletion 29 recorded separately; `CLAUDE.md` held at 183 against its 200 ceiling (ROUTE-05, LENGTH-03). The ceiling is held at review, not gated (F-008)                             |
| AC-GAP-11 | Resolved | 226 lands under the 230 target; the 231–269 band was not needed (LENGTH-02)                                                                                                                            |

## 3. Scenario verification

All evidence is manual: the story has no suite (`../../18-TESTS/AUTOMATED/US002-TEST-STATUS.md`).
Each row ID refers to `../../18-TESTS/MANUAL/US002-MANUAL-TESTING.md`, walked 03/11/2026 at
`9da4e30` by an agent that authored neither the change, its review nor its QA pass: 35 Pass, 1 Fail,
four amended. The QA breaker pass's own scenario verdicts (at `6745d12`) are cited beside each.

### Happy Path

| ID    | Scenario (from plan)                                     | Result   | Evidence                                                                                                                                                                                                                                                                                        |
| ----- | -------------------------------------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | The file reaches 230 or fewer by `--limit 1`             | Pass     | LENGTH-01, LENGTH-02: 226. QA pass: Pass                                                                                                                                                                                                                                                        |
| HP-02 | Every register present; one tree row per script          | Pass     | REGISTER-01 to REGISTER-04: eight registers present; 32 tree rows, 27 inventory, 27 Dependencies. QA pass: Pass                                                                                                                                                                                 |
| HP-03 | Restatements replaced by routes, never by silence        | Pass     | ROUTE-01 to ROUTE-04, each route read in place. QA pass: Pass                                                                                                                                                                                                                                   |
| HP-04 | Operating rules in `CLAUDE.md`; `docs-pairing.sh` exit 0 | **Fail** | OPS-02 and OPS-03 Pass. **OPS-01 Fail**: the Playwright install instruction stays in `CONTEXT.md` → _Dependencies_, kept because `code/src/scripts/audits/playwright-pin.sh` reads it as a pin site, with no recorded decision licensing the keep (F-001). QA pass: Pass — the walk is stricter |
| HP-05 | The allowance deleted or re-dated against a run          | Pass     | ALLOW-01: deleted                                                                                                                                                                                                                                                                               |
| HP-06 | The hand-checked citations re-resolved                   | Pass     | CITE-01 to CITE-04 (CITE-03 amended, F-002). QA pass: Pass with caveat L-2, fixed `9da4e30`                                                                                                                                                                                                     |
| HP-07 | The forward demand dry-run stays under 270               | Pass     | DRYRUN-01, amended to 33 rows (F-003): 259                                                                                                                                                                                                                                                      |

**The citation gate, read as a diff (Scenario 8).** `code/src/scripts/audits/doc-references.sh`
exits 1 at both ends and is reported per
`../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`. Baseline
at `357db65`, tree clean: 579 findings, 280 identities. Walk run at `9da4e30`, same index state,
detector sha256 matching: 563 findings, 268 identities. **0 new identities**; 12 identities (16 findings) gone — 5 identities / 8 findings on
`slop-family/` (planned), 6 / 7 on the superseded "SLOP-FAMILY.md" (Q1c), and 1 / 1 GAPS anchor. This is not
a pass: the gate is red, and the story neither caused nor owns the survivors. The automated record's
generated block is expected to add one identity (F-015).

### Error States

| ID    | Scenario (from plan)                          | Result | Evidence                                                                                                                                                 |
| ----- | --------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | The pair loses one half                       | Pass   | BITE-01, amended (F-004): a staged deletion exits 1 naming the missing `CLAUDE.md`. As first written it exits 2 with no finding — filed as a bug (F-014) |
| ES-02 | A citation under the register stops resolving | Pass   | BITE-02: exactly one new identity, naming the broken path                                                                                                |
| ES-03 | The file lands at 271                         | Pass   | BITE-03, amended (F-005): `--since HEAD` exits 1 with a ratchet finding; the bare form lists it and exits 0                                              |
| ES-04 | Content moved into `CLAUDE.md` past 270       | Pass   | BITE-04: the sibling enters the warn tier; `--since HEAD` exits 1                                                                                        |

### Edge Cases

| ID    | Scenario (from plan)                                    | Result    | Evidence                                                                                                                                                                        |
| ----- | ------------------------------------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | Three trial shrinks at 229, 230, 231                    | N/A       | Not re-run: the build has one landing figure. LENGTH-02 applies the rule to 226 (manual guide _Out of scope_)                                                                   |
| EC-02 | A landing at 269                                        | Pass      | LENGTH-02 applies the rule; not reached                                                                                                                                         |
| EC-03 | The boundary case of the dry run                        | Pass      | DRYRUN-01: boundary re-cut to 236 for 33 rows; 226 sits 10 below it                                                                                                             |
| EC-04 | The whole reduction paid by relocation into `CLAUDE.md` | Deviation | ROUTE-05: relocation 58 (into the new pair, one rule into `CLAUDE.md`), deletion 29, recorded separately. Shares measured with raw `cloc` (F-010); ceilings review-held (F-008) |
| EC-05 | The rationale deleted outright                          | Pass      | RATIONALE-01 to RATIONALE-04: all three arguments present at the new home                                                                                                       |
| EC-06 | The allowance rewritten to an unmeasured figure         | N/A       | ALLOW-01: deleted, not rewritten                                                                                                                                                |

### Permission and Access

N/A. The plan has no `PA` scenario: the story adds no runtime surface, endpoint or protected
action.

## 4. Deviations from plan

| Deviation                                                                                                                                           | Justification                                                                                                                            |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Figures re-cut at the build's first step.** 298 → 299 lines; 24 → 27 scripts; 4 → 5 owed rows; 27 → 33 forward rows; 236 the new dry-run boundary | Plan _Key Decisions_ Q1 and Q1a, settled with Sam 03/11/2026; dated trails in the story and plan                                         |
| **Citation sweep widened** from eight to every live anchor into the register, and the seven "SLOP-FAMILY.md" findings cleared                       | Q1b and Q1c                                                                                                                              |
| **The scope table routed, not kept.** Q3 kept "only the scope table that guide lacks"; `code/docs/VISUAL-DESIGN.md` Section 6 already carried it    | Review R-001. The new file keeps a route and a member-to-scope mapping only (F-007)                                                      |
| **One operating rule kept in `CONTEXT.md`** — the Playwright install instruction                                                                    | Not licensed by a recorded decision: HP-04 fails (OPS-01, F-001). Moving it means changing `playwright-pin.sh`'s site in the same change |
| **Four manual rows amended at the walk** — CITE-03, DRYRUN-01, BITE-01, BITE-03                                                                     | Each against a recorded decision: Q4/Q1b, and the plan's _Verification corrections, 03/11/2026 (QA triage)_ (F-002 to F-005)             |
| **The section shares measured with raw `cloc`**, not `docs-length.sh`                                                                               | `docs-length.sh` measures whole files only; the method is stated beside the figures and reconciled against the gate's net (F-010)        |

## 5. New edge cases discovered

| ID      | Scenario                                                                                                                       | Result | Evidence                                              | Fold back?                                                                           |
| ------- | ------------------------------------------------------------------------------------------------------------------------------ | ------ | ----------------------------------------------------- | ------------------------------------------------------------------------------------ |
| BITE-01 | An **unstaged** deletion of a tracked `CLAUDE.md`: `docs-pairing.sh` exits 2 with `grep` errors and no finding                 | Open   | QA M-3; reproduced 03/11/2026 in a throwaway worktree | Yes — `../../21-BUGS/BUG-US002-DOCS-PAIRING-UNSTAGED-DELETION-03-11-2026.md` (F-014) |
| —       | An unstaged deletion of a tracked `CONTEXT.md`: exit 1, but with false findings against the missing file                       | Open   | QA L-7; reproduced the same day                       | Yes — the same bug                                                                   |
| BITE-01 | `git rm --cached` with the file left on disk exits 0, because the gate also reads untracked files                              | Pass   | The walk's BITE-01 notes                              | No — recorded in the row's amendment                                                 |
| BITE-03 | The bare `docs-length.sh` at 271 only warns; the ratchet is `--since`                                                          | Pass   | QA L-4                                                | Yes — amended (F-005)                                                                |
| —       | A generated project without the desktop surface: `slop-family/CONTEXT.md` carries three dangling desktop citations, one before | Pass   | QA M-1; the walk's rendered-project check (F-006)     | No — by design, `code/docs/FORWARD-VOICE.md` Section 5; prose flag added             |
| —       | Neither receiving-file ceiling (200, 100) is enforced by any gate                                                              | Open   | QA M-4                                                | Yes — F-008, held at review                                                          |

## 6. Deferred scenarios

EC-01's three trial shrinks — not re-run, because the build has one landing. Everything else was
walked.

## 7. Accessibility observations

- **axe-core:** N/A. No rendered route.
- **Keyboard & focus:** N/A. No interactive component.
- **Equal-weight actions:** N/A.
- **Other:** N/A. The story ships Markdown read in an editor or on a repository host.

## 8. GDPR & security observations

- **PII at rest:** N/A. No personal data is processed.
- **PII in responses:** N/A.
- **Rights paths:** N/A.
- **Security gate:** N/A. No endpoint and no permission surface.

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified — bar OPS-01, which is a Fail, not a deviation
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build (N/A, no rendered surface)
- [x] GDPR & security observations confirmed (or N/A recorded)
- [x] Coverage floors met for all modules in scope (no module in scope)
- [x] Manual testing sign-off (see `../../18-TESTS/MANUAL/US002-MANUAL-TESTING.md`).
      **The walk failed one row**: 35 Pass, 1 Fail (OPS-01), 4 amended (F-002 to F-005). Signed off by
      Sam on 03/11/2026 in session, **accepting OPS-01 / F-001 as a known Fail** — the Playwright
      install instruction stays in `code/src/scripts/audits/CONTEXT.md` as a `playwright-pin.sh` pin
      site, routed to the `GAPS.md` entry. The tick records that acceptance, not a pass
- [x] Reviewer approval — Sam, 03/11/2026 in session, at `23-pr-and-review`, accepting OPS-01 / F-001
      as above and the review-held ceilings (F-008)

---

## Cross-references

- `../PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — the pre-development plan verified here
- `../../02-STORIES/US002.md` — the story under review
- `../../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — the plan, its Key Decisions and QA-triage corrections
- `../../18-TESTS/AUTOMATED/US002-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US002-MANUAL-TESTING.md` — downstream test records
- `../../20-FINDINGS/FINDING-US002-AUDITS-REGISTER-HEADROOM-03-11-2026.md` — the findings this review cites
- `../../19-REVIEWS/REVIEW-US002-AUDITS-REGISTER-HEADROOM.md` — the code review and QA breaker pass
- `../../21-BUGS/BUG-US002-DOCS-PAIRING-UNSTAGED-DELETION-03-11-2026.md` — the gate defect surfaced at BITE-01
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
