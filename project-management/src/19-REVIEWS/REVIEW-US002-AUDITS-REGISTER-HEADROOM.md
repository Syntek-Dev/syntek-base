# Code Review — US002 The audits register regains the headroom nine new gates need

**Last Updated**: 03/11/2026 · **Story**: US002 · **Status**: In Review

| Field        | Value                                                                                                                                    |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US002 — the audits register regains the headroom nine new gates need                                                                     |
| **Branch**   | `us002/audits-register-headroom` (cut from `testing` at `81a80a2`; build commits `3be5115` and `992ec1b`, fixes `6745d12` and `9da4e30`) |
| **PR**       | Raised at `23-pr-and-review` Step 3 · target `testing`                                                                                   |
| **Reviewer** | Claude — separate `code-reviewer` and `qa-tester` dispatches during the build, neither of which wrote it                                 |
| **Date**     | 03/11/2026                                                                                                                               |
| **Verdict**  | Request changes, small (code review, at `992ec1b`) · No Critical or High (QA breaker pass, at `6745d12`) — every fix landed in the build |

**Codes from:** `../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`
→ _The one lane — documentation_, _Key Decisions_ (Q1 to Q5, Q1a to Q1c, settled 03/11/2026) and
_Verification corrections, 03/11/2026 (QA triage)_.
**Story:** `../02-STORIES/US002.md` — the acceptance criteria this review judges against.

---

## 1. Scope & files reviewed

Markdown only, plus three one-line YAML comment repoints: the audits register pair, the new
`slop-family/` pair that received the split rationale, the inbound citations into them, the PM
artefacts that asserted a bare line count for the register, and US002's own records. No Python,
template, endpoint, migration or UI. The pre-existing items in Section 6 were found by these passes
and are out of this story's scope.

| File                                                                                                                                                                                                           | Change                                                                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/CONTEXT.md`                                                                                                                                                                           | 299 → 226 counted lines: restatements routed, the family section reduced to a route, five Dependencies rows added, the `docs-length-allow` retired                                        |
| `code/src/scripts/audits/CLAUDE.md`                                                                                                                                                                            | 178 → 183: one operating rule received, read order re-routed, the 200-line receiving-file ceiling stated; citations into `CONTEXT.md` re-resolved                                         |
| `code/src/scripts/audits/slop-family/CONTEXT.md` · `code/src/scripts/audits/slop-family/CLAUDE.md`                                                                                                             | Created — the split rationale (a)–(c) moved intact, a member-to-scope mapping, the 100-line ceiling                                                                                       |
| `.github/workflows/audit-css-slop.yml` · `.github/workflows/audit-render-slop.yml` · `.github/workflows/audit-style-check.yml`                                                                                 | Line-2 comment repointed to `slop-family/CONTEXT.md` by section name                                                                                                                      |
| `code/src/scripts/desktop/CONTEXT.md`                                                                                                                                                                          | Citation of _The AI-slop family_ repointed                                                                                                                                                |
| `GAPS.md`                                                                                                                                                                                                      | One line anchor into US002's story repointed to a section name                                                                                                                            |
| Seven feature maps, the cut plan, US004, US006, US007, US008, four sprint records, four sprint plans, three story plans, three QA plans, US008's threat model and assessment plan, the superseded register ADR | Line anchors into the register become section and row names; bare 298/299 figures become dated history or cite `docs-length.sh`; superseded "SLOP-FAMILY.md" citations quoted with trails |
| US002's story, plan and manual guide; the three boards                                                                                                                                                         | Re-cut at the build's first step with dated trails; build captures and the walk; regenerated boards                                                                                       |

---

## 2. Findings

Two independent passes. **R-001 to R-019** are the `code-reviewer` dispatch over
`testing...992ec1b` (verdict: Standards — request changes, small; Spec — gaps in Scenarios 4 and
9); **R-020 to R-030** are the `qa-tester` breaker pass at `6745d12` (no Critical or High), whose
own IDs are kept in the Issue column. Severity is the pass's own grade; a nit is recorded Low.

| ID    | Severity | File:line                                                                              | Issue                                                                                                                                                                             | Resolution/Status                                                                                                                                |
| ----- | -------- | -------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| R-001 | Medium   | `code/src/scripts/audits/slop-family/CONTEXT.md` (the scope table)                     | M1: the `slop-allow` scope table restated `code/docs/VISUAL-DESIGN.md` Section 6 and was relocated with a Member column added, not routed                                         | Fixed `6745d12` — duplicated columns dropped; a route plus a member-to-scope mapping kept. Q3's premise was false (finding F-007)                |
| R-002 | Medium   | Same file, the Member column                                                           | M2: "a ratio or count, decided across a file" omitted the prose leg; `copy-slop.sh` implements a file-scoped `exclamation-count`                                                  | Fixed `6745d12` — mapping verified against each script's code. The script's own header contradiction is out of diff (finding F-011)              |
| R-003 | Medium   | `code/src/scripts/audits/slop-family/` pair                                            | M3: `code/docs/DOCUMENTATION-LENGTH.md` Section 6 gives a receiving file its own ceiling in the same change; the new file had none                                                | Fixed `6745d12` — 100 counted lines, stated in `slop-family/CLAUDE.md` → _Guardrails_. Held at review, not gated (finding F-008)                 |
| R-004 | Medium   | `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` (the standing guard)                         | M4: a "not grown, measured at 299 of 300" guard the Scenario 9 sweep missed                                                                                                       | Fixed `6745d12` — cites `docs-length.sh`                                                                                                         |
| R-005 | Low      | `slop-family/CONTEXT.md` ("nothing else in this folder carries")                       | L1: the folder now holds no scripts                                                                                                                                               | Fixed `6745d12`                                                                                                                                  |
| R-006 | Low      | `slop-family/CONTEXT.md` vs `.github/workflows/audit-style-check.yml:1`                | L2: "the fifth leg" against "the fourth member"                                                                                                                                   | Fixed `6745d12` — one count in both places                                                                                                       |
| R-007 | Low      | The quoted "SLOP-FAMILY.md" trails                                                     | L3: trails did not say the baseline findings are now cleared                                                                                                                      | Fixed `6745d12`                                                                                                                                  |
| R-008 | Low      | `slop-family/CONTEXT.md` frontmatter                                                   | L4: the only `CONTEXT.md` in the repository carrying routing frontmatter; `.claude/CLAUDE.md` Section 2.5 scopes it to `docs/` and `workflows/`                                   | Kept — plan Step B sanctioned it. Recorded as a one-off convention (finding F-009)                                                               |
| R-009 | Low      | `code/src/scripts/audits/CONTEXT.md` → _Exit Codes_                                    | L5: rule-like passages kept ("A warn tier is earned…", "Self-guarding is only honest…") were unclassified in the cut/kept table                                                   | Fixed `6745d12` — three rows classified as sole-owner facts with reasons                                                                         |
| R-010 | Low      | `code/src/scripts/audits/CONTEXT.md` → _Dependencies_ (the Playwright install block)   | L5b: an install instruction kept in the orientation half, with a raw `uv run` in a doc; predates the story                                                                        | Open — the walk failed OPS-01 on it. Finding F-001, dated `GAPS.md` entry                                                                        |
| R-011 | Low      | Manual guide _After the build_ (shares and dry run)                                    | L6: measured with raw `cloc`, not `docs-length.sh`                                                                                                                                | Fixed in part `6745d12` — the dry run re-measured by the gate (259). The section shares stay cloc's, the method stated (finding F-010)           |
| R-012 | Low      | `../02-STORIES/US002.md` (four sites)                                                  | L7: the story not fully re-cut — "two Markdown files", "No new file … no index surface", "eight citations", "27 rows"                                                             | Fixed `6745d12` — re-cut with dated trails                                                                                                       |
| R-013 | Low      | `code/src/scripts/audits/CLAUDE.md:6`                                                  | L8: read order said the imported `CONTEXT.md` carries "the slop-family split", now only a route                                                                                   | Fixed `6745d12` — routes to `slop-family/CLAUDE.md`                                                                                              |
| R-014 | Low      | `slop-family/CONTEXT.md:74`                                                            | Nit: stale skill name "code-reviewer.md"                                                                                                                                          | Fixed `6745d12` — `.claude/skills/code-reviewer/SKILL.md`                                                                                        |
| R-015 | Low      | `code/src/scripts/audits/slop-family/CLAUDE.md`                                        | Nit: says "do not restate them here" then restates four; Concrete steps partly repeat the parent's _Adding an audit_                                                              | Fixed `6745d12`                                                                                                                                  |
| R-016 | Low      | `code/src/scripts/audits/slop-family/CLAUDE.md` → _Output & naming_                    | Nit: a SCREAMING-SNAKE naming rule for a folder holding only the pair                                                                                                             | Fixed `6745d12`                                                                                                                                  |
| R-017 | Low      | `code/src/scripts/audits/CONTEXT.md` → _Reports_                                       | Nit: a ~150-character unwrapped line                                                                                                                                              | Fixed `6745d12` — rewrapped (+1 counted line, 225 → 226)                                                                                         |
| R-018 | Low      | `../15-DECISIONS/ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES-02-09-2026.md`        | Nit: a NOTE added inside an immutable ADR — acceptable, borderline per `../15-DECISIONS/CLAUDE.md`                                                                                | Kept — a dated repoint note, not a re-decision (finding F-009)                                                                                   |
| R-019 | Low      | `../02-STORIES/CUT-PLAN.md`                                                            | Nit: an awkward parenthetical                                                                                                                                                     | Fixed `6745d12`                                                                                                                                  |
| R-020 | Medium   | `slop-family/CONTEXT.md` (the three desktop citations), in a generated default project | QA M-1: `../../desktop/style-check.sh` and `../../desktop/CONTEXT.md` twice dangle where `INCLUDE_DESKTOP` is false; the baseline had one, and none carried the desktop-only flag | Fixed `9da4e30` — each carries the prose desktop-only flag. The dangling itself is by design (finding F-006)                                     |
| R-021 | Medium   | Manual guide row DRYRUN-01                                                             | QA M-2: still 27 rows, nine each, boundary 243, against a recorded 33-row run                                                                                                     | Resolved by a walk amendment against the plan's _Verification corrections_ (finding F-003)                                                       |
| R-022 | Medium   | Manual guide row BITE-01                                                               | QA M-3: an unstaged move-aside exits 2 with `grep` errors and no finding; only a staged deletion gives the expected exit 1                                                        | Resolved by a walk amendment (finding F-004); the gate defect filed (`../21-BUGS/BUG-US002-DOCS-PAIRING-UNSTAGED-DELETION-03-11-2026.md`, F-014) |
| R-023 | Medium   | `code/src/scripts/audits/CLAUDE.md` · `slop-family/CLAUDE.md` · the split-target ADR   | QA M-4: neither receiving-file ceiling is enforced; the 200 lived only in the story and plan; the ADR's "the ceiling is enforced" is true only of 300/270                         | Fixed in part `9da4e30` — both ceilings stated in their files as held at review. Not gated (finding F-008)                                       |
| R-024 | Low      | `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md:548`                           | QA L-1: "a file with almost no headroom that US002 owns" — undated, false once US002 ships, and US006's stated reason for rejecting a new audits gate                             | Fixed `9da4e30` — dated                                                                                                                          |
| R-025 | Low      | `GAPS.md`, US007's story, the cut plan                                                 | QA L-2: three line anchors into US002's story, stale after the story grew                                                                                                         | Fixed `9da4e30` — section names                                                                                                                  |
| R-026 | Low      | Manual guide _After the build_ (the share row)                                         | QA L-3: the share row netted to 225 while the first row said 226                                                                                                                  | Fixed `9da4e30` — reconciled (+1 rewrap)                                                                                                         |
| R-027 | Low      | Manual guide row BITE-03                                                               | QA L-4: the bare `docs-length.sh` at 271 only warns and exits 0; `--since` is the ratchet                                                                                         | Resolved by a walk amendment (finding F-005)                                                                                                     |
| R-028 | Low      | `../02-STORIES/US002.md` Scenario 2 and the manual QA checklist                        | QA L-5: "seven registers" over a list of eight; `doctrine-drift.sh` still in the manual checklist                                                                                 | Fixed `9da4e30` — re-cut with trails                                                                                                             |
| R-029 | Low      | The superseded ADR NOTE; `slop-family/CONTEXT.md` frontmatter                          | QA L-6: both borderline, harmless to gates                                                                                                                                        | Kept — as R-008 and R-018 (finding F-009)                                                                                                        |
| R-030 | Low      | `code/src/scripts/audits/docs-pairing.sh` (out of diff)                                | QA L-7: an unstaged deletion of a tracked `CONTEXT.md` yields "no prose between title and first section" against a nonexistent file                                               | Filed — `../21-BUGS/BUG-US002-DOCS-PAIRING-UNSTAGED-DELETION-03-11-2026.md` (finding F-014)                                                      |

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- N/A — no endpoint, permission, secret or setting is touched. The story's Security flag reads N/A.

### 3.2 GDPR / PII

- N/A — no personal data processed.

### 3.3 Test coverage vs floors

- N/A for the code floors — no source changed and no automated test declares US002
  (`../18-TESTS/AUTOMATED/US002-TEST-STATUS.md`).
- [x] Every manual QA acceptance criterion has at least one manual row, walked: 35 Pass, 1 Fail
      (OPS-01), four amended (F-002 to F-005).

### 3.4 Quality, DRY & file length

- [x] Restatements of `code/docs/VISUAL-DESIGN.md` Section 6, `code/docs/DOCUMENTATION-LENGTH.md`,
      `code/docs/GATE-REPORTING.md` and the sibling `CLAUDE.md` replaced by routes, each read in place
      (ROUTE-01 to ROUTE-03).
- [x] The register at 226 counted lines, under the 230 target; `CLAUDE.md` at 183, under its 200
      ceiling; the new pair at 84 and 34 (`code/src/scripts/audits/docs-length.sh --limit 1`).
- [x] Pairing intact — `code/src/scripts/audits/docs-pairing.sh` exit 0 (OPS-03).
- [ ] No operating rule left in the orientation half — **one remains** (OPS-01, finding F-001).
- [x] Prettier and markdownlint clean on the story's files; the whole-tree Markdown leg fails only
      in the gitignored `graphify-out/`, pre-existing and filed.

### 3.5 Performance

- N/A — no runtime path.

### 3.6 Accessibility (WCAG 2.2 AA)

- N/A — no user-facing UI in this story.

---

## 4. Required actions before merge

One decision, not a fix: **OPS-01 / F-001** holds HP-04 until Sam decides the Playwright install
instruction — re-class it as a _Dependencies_ fact on the record, or move it to `CLAUDE.md` with
`code/src/scripts/audits/playwright-pin.sh`'s site, header and eight-site parity changed in the same
change. Every other Medium and Low is fixed, resolved by a walk amendment, or kept on the record.
The known red is in Section 6.

---

## 5. Verdict & status transition

- **Verdict:** Request changes, small (code review) and no Critical or High (QA), every fix applied
  in the build and walked; one manual row failed on a pre-existing passage.
- **Reasoning:** the register lands at 226 with every register intact and the Dependencies table
  complete (27 rows for 27 scripts); the three rationale arguments moved whole to a measured path;
  the citation gate gains no identity the story wrote and loses 12 identities (16 findings); the 33-row dry run reaches 259.
  What is not met is HP-04's literal clause, for one install instruction the story kept because a
  gate reads it where it stands.
- **Status transition:** none recorded here. `In Progress` → `In Review` and onward are recorded
  through the `completion` skill at `23-pr-and-review`.

---

## 6. Notes

### Pre-existing, found by these passes, not this story's

| Item                                                                                                                                                       | Owner / disposition                                                                 |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| `code/src/scripts/audits/copy-slop.sh` header (`:130`, `--help` at `:217`) says `exclamation-count` cannot be annotated; `:725-733` implement exactly that | Finding F-011 — dated `GAPS.md` entry                                               |
| `code/src/scripts/audits/docs-pairing.sh` reads its population from the git index and the files from disk                                                  | Finding F-014 — `../21-BUGS/BUG-US002-DOCS-PAIRING-UNSTAGED-DELETION-03-11-2026.md` |
| The Playwright install instruction in the register's _Dependencies_                                                                                        | Finding F-001 — dated `GAPS.md` entry                                               |

### Gate evidence

| Gate                                                                                                                                 | Before (`357db65`) | At the walk (`9da4e30`) | Reading                                                                                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/doc-references.sh`                                                                                          | exit 1, 579 / 280  | exit 1, 563 / 268       | Identity diff: 0 new identities; 12 identities (16 findings) gone: 5 identities / 8 findings on `slop-family/`, 6 / 7 on "SLOP-FAMILY.md", 1 / 1 GAPS anchor. A diff, not a pass |
| `code/src/scripts/audits/docs-length.sh --path … --limit 1`                                                                          | 299 · 178          | 226 · 183 · 84 · 34     | Register under target; both ceilings held at review                                                                                                                              |
| `code/src/scripts/audits/docs-pairing.sh`                                                                                            | exit 0             | exit 0                  | Pairs intact; decides nothing about the move                                                                                                                                     |
| `code/src/scripts/audits/doctrine-drift.sh`                                                                                          | —                  | —                       | **N/A** — blind to `code/src/scripts/**` (`../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`)                                                                  |
| `routing-skills.sh` · `playwright-pin.sh` · `skill-conformance.sh` · `mcp-parity.sh` · `template-orphans.sh` · `pm-board.sh --check` | —                  | exit 0 / pass           | Run by the two passes                                                                                                                                                            |

Findings over identities, compared as a multiset with line numbers stripped, per
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`. The walk
figures predate this closeout's records; the automated record's generated block is expected to add
one identity of its own (finding F-015).

### Known reds for the PR body

- `Audit — Doc References` / `Citations resolve` — 563 pre-existing findings owned outside this
  story, plus the line the generated test record adds (F-015).

---

## Workflow 23 final passes, 03/11/2026

Run at `8f8c830` by `23-pr-and-review` before the PR, each by a dispatch that wrote none of the
work.

| Pass           | Result                                                                                                              |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
| Final QA       | No Critical, High or Medium                                                                                         |
| Code review    | Standards: **Approve**. Spec: **Met**, bar OPS-01 (F-001)                                                           |
| Records verify | Complete. One High refuted: the story's `Accepted` status is a Step 5 item, recorded after merge, not a records gap |

**Low and Nit findings, all dispositioned in the records correction that follows these passes:**

| ID             | Finding                                                                                     | Disposition                                                                            |
| -------------- | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| CR-01 · QA3-01 | The citation diff reported as "16 identities gone"; it is 12 identities, 16 findings        | Corrected here, in the QA review, the automated record and the findings record         |
| CR-02          | US002's doc-references Verification Check claimed no new finding without qualifying it      | Qualified: no new finding at the walk (`9da4e30`); one generated identity since, F-015 |
| CR-03          | Five map nodes still claim US002 as a blocker with no discharge note                        | Finding F-016, routed to `01-feature-map`'s next resolve pass                          |
| CR-04 · S6-03  | QA review header cited records at `43fe621` + staged                                        | Repointed to `cd09348`                                                                 |
| QA3-02         | Ten Script Tasks cells in US002 read `[[x]`                                                 | Corrected to `[x]`                                                                     |
| QA3-03 · S6-01 | Manual-testing sign-off and reviewer approval unticked                                      | Ticked on Sam's sign-off below                                                         |
| QA3-04         | "Three YAML comment lines" understated the CI change                                        | Reworded: the header comments of three CI workflow files (comments only)               |
| S6-02          | Workflow 23 marks GDPR and Security implementation records "Always"; workflow 22 gates them | Finding F-017 and a dated `GAPS.md` entry — a template-maintenance fix                 |

**Sign-off.** Sam signed the story off on 03/11/2026 in session, accepting **OPS-01 / F-001 as a
known Fail** — the Playwright install instruction kept in `code/src/scripts/audits/CONTEXT.md` as a
`playwright-pin.sh` pin site, routed to the `GAPS.md` entry — and the review-held ceilings (F-008).
Section 4's one decision is therefore taken.

---

## Cross-references

- `../02-STORIES/US002.md` — the story under review
- `../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — the plan, its Key Decisions and its QA-triage corrections
- `../18-TESTS/AUTOMATED/US002-TEST-STATUS.md` · `../18-TESTS/MANUAL/US002-MANUAL-TESTING.md` — the test records
- `../11-QA/IMPLEMENTATION/QA-IMPL-US002-AUDITS-REGISTER-HEADROOM-03-11-2026.md` — the paired QA review
- `../20-FINDINGS/FINDING-US002-AUDITS-REGISTER-HEADROOM-03-11-2026.md` — the findings
- `../21-BUGS/BUG-US002-DOCS-PAIRING-UNSTAGED-DELETION-03-11-2026.md` — the gate defect the walk surfaced
- `project-management/workflows/22-implementation-documentation/` — the workflow this record is written in; `23-pr-and-review` verifies it
