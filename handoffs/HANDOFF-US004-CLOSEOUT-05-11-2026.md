# Handoff — US004 closeout, ready for workflow 23 after one evidence fix

## Goal

Finish US004 (the citation gate stops depending on the git index, and the PM tree becomes
checkable): settle one held manual row, then take the story through `23-pr-and-review` into
`testing`.

## Done

- Branch `us004/citation-gate-git-index`, cut from `testing` at `173abff`. Last commit is
  `1ca7468`, **pushed to origin on 05/11/2026**. The push was made for safekeeping before shutdown
  and was not explicitly requested.
- **Detector:** `code/src/scripts/audits/doc-references.sh`.
  - P1–P4, round 2 (derived citer rule, volume specs, multi-anchor, date placeholders), round 4
    (seeded citers) and every phase 9 finding are in, each red first.
  - `--self-test` passes 130/130. ShellCheck exits 0.
  - Whole tree: **28 findings, all named survivors** (US005 ×10, US006 ×10, US014 ×6, US010 ×2).
    Baseline was 502, exit 1, 438 s.
- **ADR:** `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-CITER-IS-A-DERIVED-RULE-05-11-2026.md`
  is Accepted and supersedes the 30/09/2026 citer record. `ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`
  is Accepted.
- **Register and docs:** two class rows in `how-to/src/PROJECT-PATHS.md`, a short pattern paragraph
  in `code/docs/FORWARD-VOICE.md` Section 3, and the `doc-references.sh` row in
  `code/src/scripts/audits/CONTEXT.md` rewritten within the row.
- **P5 sweep:** shipped instance citations repaired, and dead PM paths corrected in place with
  dated `UPDATED` comments.
- **Every ruling by <%DEVELOPER_NAME%>** is in the plan's _Key Decisions_:
  `project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`.
- **Records (workflow 22):**
  - QA-IMPL, `US004-TEST-STATUS.md`, the review draft and the findings record (F-001 to F-019).
  - The manual guide is walked.
  - US005's plan carries the `Next story` rows.
  - Two `GAPS.md` entries: the self-test fails downstream, and the regime outlives US004.
  - `MEMORY.md` gained a feedback entry: take the capture slots before the red phase.

## In-flight

- `project-management/src/18-TESTS/MANUAL/US004-MANUAL-TESTING.md:119` — **BASELINE-01** is held
  Fail because the checker judged its evidence not pre-edit. **That judgement is wrong, and here is
  the proof:**
  - The checker read a copy at `/tmp/us004-evidence/…`, whose 23:14 mtime came from `cp`. That
    copy matched the walk's stock-clone output, which is expected: same detector, byte-identical
    tree.
  - The **original** capture is `/home/sam-desktop/.claude/tmp/tmp.X6zOVdkES2/base.txt`, mtime
    **12:06:43** on 05/11/2026. Its exit code and wall time are in `base-run-exit-and-wall.txt`
    beside it (`exit=1 secs=438`, same mtime).
  - The branch's first commit `8fbe020` is 15:29:26, and its first source edit `e3d5187` is
    15:43:26.
  - The run was on `151a4e3`, whose tree equals `173abff` (`git diff --stat` is empty).
  - Finding lines: 462 instance, 29 dangling, 10 template-only, 1 plan-prefix.
- `:135` **AFTER-01** and `:142` **CLASSIFY-01** fail only because they read BASELINE-01.
- `:231-232` and the BASELINE-01 Failures row route to "Sam, at 23".
- `project-management/src/20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md:46`
  (F-001) and its Section 5 say BASELINE-01 is pending. The QA-IMPL record does the same.
- Walk tally now: **25 Pass, 10 Fail**. Seven are the accepted F-001 deviations (BASELINE-02 to 05,
  SELFTEST-01, EXEMPT-01, GATES-01), and three are held on BASELINE-01.

## Next

Dispatch a records agent (not the session that writes this, so the work is not self-reviewed).
It should:

1. Mark BASELINE-01 Pass using the original capture and timestamps above, citing the evidence by
   absolute path in prose.
2. Re-mark AFTER-01 and CLASSIFY-01 against the 502-finding capture, and drop their three Failures
   rows. That takes the tally to **28 Pass, 7 Fail**.
3. Update F-001 and its Section 5, plus the QA-IMPL outcome.

Commit, then enter `project-management/workflows/23-pr-and-review/`.

## Next skills

`doc-writer` (the evidence fix), then `pr` — which runs `review` (`code-reviewer` + `qa-tester`),
`completion` (US004 to In Review) and `git`.

## Artefacts

- Story: `project-management/src/02-STORIES/US004.md`.
- Plan: `project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`.
- QA plan: `project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`.
- Records:
  - `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md`
  - `project-management/src/18-TESTS/AUTOMATED/US004-TEST-STATUS.md`
  - `project-management/src/19-REVIEWS/REVIEW-US004-CITATION-GATE-GIT-INDEX.md` (draft; 23 sets
    the verdict)
  - `project-management/src/20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md`
- Commits: `git log --oneline origin/testing..us004/citation-gate-git-index`.
- Phase 9 evidence, preserved outside `/tmp`, in `/home/sam-desktop/.claude/tmp/tmp.X6zOVdkES2/`:
  `us004-phase9-evidence.json` and `us004-p9-findings.json`.

## Open Questions

None. Every ruling is recorded. The BASELINE-01 fix applies evidence and needs no new decision.
