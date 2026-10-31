# QA Plan — US013 The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause

| Field         | Value                                                                                                                                                                                                                                |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Story**     | US013 — The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause                                                                                                   |
| **Date**      | 31/10/2026                                                                                                                                                                                                                           |
| **Sprint**    | SPRINT-08 — admitted as its `Must`, 3 SP standing the record at 3 / 11; the record itself is written by `03-sprint-planning`                                                                                                         |
| **Wireframe** | N/A — this story rewrites six Markdown files, one register paragraph, one `copier.yml` comment and one `copier.yml` help text, with its one-line mirror in `TEMPLATE-GUIDE/05-ANSWERS.md`: no model, no endpoint, no screen, no page |
| **Status**    | Reviewed — all twelve gaps resolved 31/10/2026 (AC-GAP-6 to -10 in 11-qa round 3, AC-GAP-11 and -12 in 11-qa round 4); the `qa-tester` run and its scoped re-check are done; sign-off is <%DEVELOPER_NAME%>'s                        |

<!-- Written 31/10/2026 on pm/story-creation at HEAD 9ee3ea7, over a clean working tree. Every line
     number below was re-measured against that tree the same day; none is inherited from the story.

     STEP 1's GRILLING PASS is 11-qa-checks grilling round 1, <%DEVELOPER_NAME%>, 31/10/2026, Q1 to
     Q9, cited below as "11-qa round 1, Qn". It settled the generated-project check's method (Q1),
     what "every render path" means (Q2), the non-default answer set (Q3), the second tester (Q4),
     the live walk (Q5), and four acceptance-criteria gaps (Q6 to Q9). Two calls of Claude's were
     put in the same round and accepted: an inline reason on the Security, SEO and Logging FLAGS
     rows, and the doc-references baseline recaptured finding by finding before the first edit
     (Section 6). The story's own cutting interview, grilling round 1 of 31/10/2026, is a different
     round and is not re-asked here.

     GATE TRIAGE, 31/10/2026, ahead of this pass: every flag other than QA — 04 to 08, 09, 10, 12,
     13 and 14 — was confirmed N/A, each under an adversarial attempt to refute it, and all held.
     The closest calls were Logging (the story edits a document ABOUT logs, but adds or changes no
     logger, event, field or retention) and Brand (the copier answer tokens it writes are not design
     tokens). The dispositions are recorded where US012 recorded its own — in the story's FLAGS
     provenance comment — and summarised here only. 15-decisions runs and yields no ADR (the
     story's Decisions section carries the dated outcome).

     STEP 2 HAS NO WIREFRAME TO REVIEW. The scenarios in Section 2 are derived from the story's seven
     Gherkin scenarios (six at writing; round 3 Q14 added the seventh, 31/10/2026) and its QA
     criteria, as QA-PLAN-US012 and QA-PLAN-US007 derived theirs.

     STEP 3 — THE qa-tester DISPATCH IS OWED AND GATES SIGN-OFF. 11-qa-checks CHECKLIST.md requires
     "`qa-tester` skill run for each story" (STEPS.md:60 dispatches it as general-purpose), and
     QA-PLAN-US012 ran it as a forked skill, twice, before its sign-off. No qa-tester output is
     folded into this plan at writing; the adversarial reading it carries is the gate triage above
     and the candidates re-opened with REFUTED as the default in Section 8, one of which survived
     as AC-GAP-5. That reading does not discharge the dispatch. Its findings are folded in by a
     dated amendment, never silently.

     AMENDED 31/10/2026 after an independent review of this plan and the story amendments: HP-11,
     HP-12, ES-08 and HP-13 added; ES-03 made case-insensitive; EC-05 and EC-06 restated; AC-GAP-5
     widened to carry the per-site reading of Step 4 and corrected for STEPS.md:88; this comment
     and Status name the owed dispatch. The review's findings are folded in pending
     <%DEVELOPER_NAME%>'s ruling on AC-GAP-5; nothing it raised reopens a settled answer.

     AMENDED 31/10/2026 after 11-qa-checks grilling round 2, <%DEVELOPER_NAME%>, 31/10/2026, Q10
     and Q11, cited below as "11-qa round 2, Qn". It closed AC-GAP-5: inside Step 4 only :94 and
     :98 stay literal (Q10); outside it :176 is reworded vendor-free and 09 CONTEXT.md:37 and
     CLAUDE.md:28 stay literal under their file's existing marker (Q11). The expected
     <%LOG_AGGREGATOR%> count is 12, re-measured at the working tree the same day; HP-06, ES-02,
     Section 6, AC-GAP-3's note and the story carry it.

     SIGN-OFF is <%DEVELOPER_NAME%>'s, which is why Status reads Reviewed. One thing gates it:
     the qa-tester dispatch, owed; it runs next.

     STEP 3 — THE qa-tester DISPATCH, RUN 31/10/2026 (read-only, against the working tree after 11-qa
     round 2; nothing edited, staged or committed by it). It returned eleven findings, six major and
     five minor, none blocking, numbered here qa-tester 1 to 11 in the order returned. Each was
     re-verified at the working tree the same day and every one holds; none was rejected.
     Dispositions:
       - FOLDED, no ruling needed (Claude's calls, put to <%DEVELOPER_NAME%> for acceptance at
         sign-off): 3 (copier.yml :470-483 given as post-edit text; HP-09 widened), 6 (the
         :146-148 sentence stated whole; EC-01 restated), 7 (marker anchors fixed; :203 reworded
         vendor-free; ES-03 bounded to the marker's section), 9 (ES-09 source-side token check;
         HP-06 and ES-02 asserted per site), 10 (counting method named in Section 6), 11
         (CHECKLIST.md:43 and the 15/30-minute window; HP-07, HP-08 widened). 8 in part: EC-07
         (LOG_AGGREGATOR=Alloy) added and 09 CLAUDE.md:12's "/Alloy" dropped.
       - OPEN with <%DEVELOPER_NAME%>, not applied: 1 (AC-GAP-6), 2 (AC-GAP-7), 4 (AC-GAP-8),
         5 (AC-GAP-9) — each returned needs_sam — and the remainder of 8 (AC-GAP-10), which
         asks a question the fold cannot answer without choosing a reading of copier.yml's help.
     The previous paragraph's "it runs next" is the record of round 2, kept as written. Sign-off
     now waits on AC-GAP-6 to -10, and then on <%DEVELOPER_NAME%>.

     AMENDED 31/10/2026 after 11-qa-checks grilling round 3, <%DEVELOPER_NAME%>, 31/10/2026, Q12 to
     Q16, cited below as "11-qa round 3, Qn". It closed AC-GAP-6 to -10, each on Claude's
     recommendation: the marker names the reference stack literally and the counts go by position
     (Q12, option A); the CI default paths check token rendering only and the unmarked-literal grep
     runs on the sed render only (Q13, A); the 10-debug handoff rides the STEPS.md preamble's stop
     instruction (Q14, A); this story rewords CHECKLIST.md:38 only; :39 and :56 go to S-04 (Q15,
     C); Alloy leaves LOG_AGGREGATOR's help list (Q16, A). HP-06, HP-07, HP-11, ES-02, ES-03,
     ES-08, EC-07, Section 6 and Section 8 amended; HP-14 added; the story and SPRINT-08 carry the
     rulings. Every gap is resolved and the qa-tester run is done: sign-off is
     <%DEVELOPER_NAME%>'s alone.

     RE-CHECKED 31/10/2026 by a scoped qa-tester pass over the round-3 application (read-only;
     nothing edited, staged or committed by it). Not refuted: Q12 to Q16 applied faithfully and
     the three files agree. It returned seven findings, two major and five minor, numbered here
     re-check 1 to 7 in the order returned; each was re-verified at the working tree the same day
     and every one holds. Dispositions:
       - APPLIED, no ruling needed (Claude's calls, put to <%DEVELOPER_NAME%> for acceptance at
         sign-off): 1 (ES-03 and the story's Then bounded by a per-file marker scope — 09
         STEPS.md Steps 4 to 5, 09 CHECKLIST.md its staging / prod section, the other four the
         whole file below the marker — since Q12's minimum content names no section; Q12 is not
         reopened), 4 (HP-14 given its own live-walk observable; the absent unconditional
         dev-path handoff box named S-04's in Out of Scope, under Q15's reading that
         CHECKLIST.md's shape beyond :38 is S-04's), 5 (each tokenised and held site recorded by
         anchor phrase as well as line number; HP-06 and ES-02 assert against the anchors), 6
         (the held-sites sentence refers to them without naming the product), 7 (this comment's
         Q15 clause reworded above). 3 in part: Section 8's "shipper-to-store" corrected — it is
         this plan's own text, not a ruling.
       - OPEN with <%DEVELOPER_NAME%>, not applied: 2 (AC-GAP-11 — three other surfaces still
         offer Alloy as a LOG_AGGREGATOR answer; scope is his) and the remainder of 3
         (AC-GAP-12 — Q16's written reason, "a collector, not a store", fits Vector and Fluent
         Bit too; rewording a ruling is his). EC-07 is narrowed now to what the help text
         proves, which holds whatever AC-GAP-11 rules.
     The paragraph above is kept as the record of round 3. Sign-off now waits on AC-GAP-11 and
     -12, and then on <%DEVELOPER_NAME%>.

     AMENDED 31/10/2026 after 11-qa-checks grilling round 4, <%DEVELOPER_NAME%>, 31/10/2026, Q17
     and Q18, cited below as "11-qa round 4, Qn". It closed AC-GAP-11 and -12, each on Claude's
     recommendation: Q16's removal reaches the answer guide's copy of the help list,
     how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md:124, and stops there; OBSERVABILITY.md:100 and
     PLATFORM-PROVIDERS.md:38 go to the story's Out of Scope and the DEFERRED.md entry 22 writes
     (Q17, option A); the recorded reason for dropping Alloy is the defect AC-GAP-10 found — it is
     the reference deployment's own shipper, so answering it renders "Grafana Alloy … ships to
     Alloy" — replacing "a collector, not a store" (Q18, A). The three lines were re-measured at the
     working tree the same day and hold. EC-07, AC-GAP-10's ruling and Section 8 amended; the story
     and SPRINT-08 carry the rulings. Every gap is resolved and the qa-tester run and its scoped
     re-check are done: sign-off is <%DEVELOPER_NAME%>'s alone. The paragraph above is kept as the
     record of the re-check. -->

---

## 1. Acceptance criteria gaps

**Twelve gaps found. AC-GAP-1 to -5 are `[RESOLVED] 31/10/2026` into
`project-management/src/02-STORIES/US013.md`;** four are precision repairs settled in 11-qa round
1, and the fifth, a consequence of Q8 that round did not reach, was settled in 11-qa round 2.
**AC-GAP-6 to -10 are `[RESOLVED] 31/10/2026`**, raised by the `qa-tester` run of 31/10/2026 and
settled in 11-qa round 3 (Q12 to Q16), each into the story. **AC-GAP-11 and -12 are `[RESOLVED] 31/10/2026`**,
raised by the scoped `qa-tester` re-check of 31/10/2026 and settled in 11-qa round 4 (Q17, Q18),
each into the story. None
moves the priority, the estimate or the sprint.

- **AC-GAP-1** `[RESOLVED] 31/10/2026` · material — **the vendor-literal checks were
  case-sensitive by implication, and the folder spells the product wrongly.** 15 of the 16 GlitchTip
  sites in the 09 folder read `Glitchtip`; only 09 `CONTEXT.md`:59 reads `GlitchTip` (measured
  31/10/2026). A grep for `GlitchTip` would report the folder nearly clean before any edit.
  **Resolution:** "case-insensitive" added to the QA FLAGS row, to the generated-project QA
  criterion and to the _No vendor literal survives unmarked_ scenario (11-qa round 1, Q6).
- **AC-GAP-2** `[RESOLVED] 31/10/2026` · material — **"Sentry" was in the search set with no
  carve-out for the SDK protocol.** `copier.yml`:461 makes the Sentry SDK wire protocol the
  error-tracking seam, so "the Sentry SDK" names an interface, not a backend, and tokenising it
  would make a Bugsink project read "the Bugsink SDK". The one in-scope sentence that binds the
  backend to an SDK is 09 `STEPS.md`:147, "captured by Glitchtip's browser SDK". **Resolution:**
  only the backend name is tokenised; the scenario exempts the protocol name; `:147` is reworded
  to "the browser SDK forwards to `<%ERROR_TRACKING%>`", added as a task and a Then (Q7). No
  `Sentry` literal sits in the six files today (measured), so the exemption is forward-facing.
  **Restated 31/10/2026 after the `qa-tester` run (item 6):** spliced into `:146-148` as a phrase,
  Q7's wording made the sentence ungrammatical ("are captured by the browser SDK forwards to …").
  The story now states the whole post-edit sentence — "… are captured by the browser SDK, which
  forwards them to `<%ERROR_TRACKING%>` (Step 3), never to `<%LOG_AGGREGATOR%>`." — keeping Q7's
  verb and its one error-tracker site; EC-01 checks that exact rendering. Q7 is not reopened.
- **AC-GAP-3** `[RESOLVED] 31/10/2026` · material — **Step 4's LogQL sentences cannot take a
  substituted aggregator name.** The three LogQL blocks are Loki's query language; a sentence that
  reads "Query Fluent Bit in Grafana … select the Fluent Bit datasource" above a LogQL block is
  false for every non-default answer. **Resolution:** Step 4's LogQL-bound sentences stay literal
  under the reference-stack marker at the head of Steps 4-5, and the semantic mismatch is recorded
  against `S-07`, which owns the LogQL blocks (N-020). Scenario, tasks and Out of Scope amended
  (Q8). Measured: Step 4 (`STEPS.md`:94-153) holds **6** `Loki` sites — `:94`, `:98`, `:130`,
  `:133`, `:148`, `:149`. **Which of the six are "LogQL-bound" was settled sentence by sentence
  in 11-qa round 2, Q10** — only `:94` and `:98`; the other four are tokenised (AC-GAP-5).
- **AC-GAP-4** `[RESOLVED] 31/10/2026` · minor — **`LOG_AGGREGATOR` is classed prose-shaped and
  its help text does not say so.** `how-to/src/TEMPLATE-TOKENS.md`:121 classes it "bare name ·
  **prose**", and this story writes it into running sentences; `OBJECT_STORE` and `ERROR_TRACKING`
  carry "Answer with a bare product name: this one is rendered into running prose." in their help
  (`copier.yml`:497, :505) and `LOG_AGGREGATOR` (`:508-513`) does not. **Resolution:** a task and
  an acceptance line added to the story to append that sentence to `LOG_AGGREGATOR`'s help (Q9).
  `copier.yml` is not edited by this pass.
- **AC-GAP-5** `[RESOLVED] 31/10/2026` · material — **Q8's reach was unsettled in two
  directions: inside Step 4, sentence by sentence, and outside it.** Re-opened with REFUTED as the
  default and not refuted; settled by <%DEVELOPER_NAME%> in 11-qa round 2 (Q10, Q11), both parts
  together because they move the same count.
  - **(a) Inside Step 4 — sentence-scoped (Q10).** Only the two sites bound to the LogQL blocks
    below them stay literal under the Steps 4-5 reference-stack marker: `:94` (the heading "Query
    Loki in Grafana") and `:98` ("select the Loki datasource"). The other four say **where an
    error surfaces**, not what a query reads, and are tokenised to `<%LOG_AGGREGATOR%>`: `:130`
    (the heading "Browser errors surface in Glitchtip, not Loki"), `:133` ("no frontend log stream
    in Loki"), `:148` and `:149`. A Fluent Bit project therefore reads `:147-149` in one vendor
    voice: "which forwards them to Bugsink (Step 3), never to Fluent Bit … as the Django exception
    in Fluent Bit and as the forwarded response error in Bugsink" (wording per AC-GAP-2's
    restatement, `qa-tester` item 6).
  - **(b) Outside Step 4 (Q11).** `STEPS.md`:176 ("the Loki log lines from Step 4") is **reworded
    vendor-free** to "the log lines from Step 4" — no token, no literal. 09 `CONTEXT.md`:37 ("Loki
    / Alloy (LogQL queries in Grafana)") and 09 `CLAUDE.md`:28 ("query Loki (LogQL)") **stay
    literal under their file's existing marker** (the intro marker and the Purpose marker), so no
    new marker is written. `STEPS.md`:88 stays **tokenised**: it sits in Step 3, above the Steps
    4-5 marker, and "use these to query `<%LOG_AGGREGATOR%>` next" reads correctly for any answer.

  **Settled `<%LOG_AGGREGATOR%>` count: 12**, re-measured at the working tree 31/10/2026 — 17
  `Loki` sites (13 in the 09 folder, 4 in the `code/src/logs/` pair), less the 2 held in Step 4
  (`:94`, `:98`), less the 3 handled outside it (`:176` reworded, CONTEXT `:37` and CLAUDE `:28`
  held). The 12 are 09 `STEPS.md` `:88`, `:130`, `:133`, `:148`, `:149`; 09 `CONTEXT.md`:59; 09
  `CLAUDE.md` `:12`, `:41`; and the pair's 4. `<%ERROR_TRACKING%>` stays **18**.

  | Disposition                                    | Sites                                                                           | Count  |
  | ---------------------------------------------- | ------------------------------------------------------------------------------- | ------ |
  | Tokenised to `<%LOG_AGGREGATOR%>`              | `STEPS.md` :88, :130, :133, :148, :149 · CONTEXT :59 · CLAUDE :12, :41 · pair 4 | **12** |
  | Literal under the Steps 4-5 marker (Q10)       | `STEPS.md` :94, :98                                                             | 2      |
  | Literal under the file's existing marker (Q11) | 09 `CONTEXT.md`:37 · 09 `CLAUDE.md`:28                                          | 2      |
  | Reworded vendor-free (Q11)                     | `STEPS.md`:176                                                                  | 1      |
  | **Total `Loki` sites**                         |                                                                                 | **17** |

  **Resolution:** the story's vendor-literal scenario, generated-project scenario and criterion,
  tokenise and inventory tasks, S-07 note task and Out of Scope bullet amended to the ruling; HP-06,
  ES-02 and Section 6 carry 12.

The five gaps below were raised by the `qa-tester` run of 31/10/2026 (`qa-tester` items 1, 2, 4,
5 and the remainder of 8). Each was verified at the working tree the same day and left open for
<%DEVELOPER_NAME%>'s ruling; each carries the question, its options and Claude's recommendation
as put to 11-qa round 3, then the ruling and its disposition.

- **AC-GAP-6** `[RESOLVED] 31/10/2026` · material — **the reference-stack marker's content and the
  exact counts cannot both hold.** The story mandates six markers phrased as
  `code/docs/logging/OBSERVABILITY.md`:109, and that precedent itself carries
  `<%LOG_AGGREGATOR%>` (`:109-110`, re-read 31/10/2026). A marker that follows it adds token sites
  and `Fluent Bit` exceeds 12 (HP-06 fails); one naming the real aggregator adds a `loki` hit (ES-02
  fails); one naming neither passes ES-08 while never saying the held `Loki` sites are
  reference-only. `qa-tester` item 1. **Question — what may the marker name?**
  - **A.** It names the reference stack literally — Grafana Alloy shipping to Loki, queried with
    LogQL in Grafana, and Prometheus — and cites `PLATFORM-PROVIDERS.md`. HP-06 and ES-02 count
    only the 30 listed pre-edit sites by position; ES-02 allows 4 + N, N the markers naming Loki;
    markers add no token.
  - **B.** It names no aggregator — only Grafana, Alloy, Prometheus and the sections it covers. The
    counts stand; ES-08 gains a minimum content. The held `Loki` sites go unexplained.
  - **C.** It follows `OBSERVABILITY.md`:109 with the token; HP-06 counts 12 + N. A Fluent Bit
    marker then sits above "Query Loki in Grafana", which contradicts it.
  - **Recommendation: A.** Only a marker that names Loki can tell a non-Loki reader why `:94` and
    `:98` still say Loki, and counting by position keeps the 12 exact.
  - **Ruling: A (11-qa round 3, Q12).** The marker names the reference stack literally — Grafana
    Alloy shipping to Loki, LogQL in Grafana, Prometheus — and says the held `Loki` sites describe
    the reference deployment, citing `how-to/src/PLATFORM-PROVIDERS.md`. **Disposition:** HP-06
    and ES-02 count the 30 listed pre-edit sites by position, not a raw file-wide total; ES-02
    allows the 4 held sites plus exactly one `Loki` mention per marker that names it; ES-08 gains
    that minimum content; the story's marker scenario and task carry it.
- **AC-GAP-7** `[RESOLVED] 31/10/2026` · material — **"on every render path … no unmarked vendor
  literal survives" cannot pass on the two default CI renders.** `copier.yml`:506 and :513 default
  to `GlitchTip` and `Loki`, so every tokenised site renders back to a literal, most above or
  outside any marker (`STEPS.md`:77 and :88 sit above the Steps 4-5 marker); in a rendered tree a
  token and a literal are byte-identical. The CI step greps only for an unrendered token
  (`.github/workflows/audit-template.yml`:180). `qa-tester` item 2. **Question — what does each
  path check?**
  - **A.** Split the criterion: the CI default paths check only that every token renders; the
    unmarked-literal grep runs on the non-default (Bugsink / Fluent Bit) `sed` render only.
  - **B.** As A, and the grep also runs as a literal grep of the edited source, where a held literal
    and a token still differ.
  - **C.** Keep the wording and compare the default-path hit count with an expected default count.
  - **Recommendation: A.** The non-default render is the one place a missed token shows as a
    literal; B's source grep proves the same thing twice, and C turns a presence check into a
    second count to maintain. The QA FLAGS row, the story criterion and Section 6 are reworded to
    match once ruled.
  - **Ruling: A (11-qa round 3, Q13).** On the two CI default render paths the check is only that
    every token renders — no unresolved token — plus ES-09's defined-question check; the
    case-insensitive unmarked-literal grep runs on the Bugsink / Fluent Bit `sed` render only.
    **Disposition:** the story's QA FLAGS row and QA criterion, SPRINT-08's flag row and QA task,
    ES-03 and Section 6 reworded to say so.
- **AC-GAP-8** `[RESOLVED] 31/10/2026` · material — **the `10-debug` handoff, moved to the end of Step
  5, is never reached on the dev path.** Step 5 is headed "(staging / prod only)" (`STEPS.md`:157),
  and the preamble tells the reader to stop as soon as the root cause is found (`:10-11`), so a dev
  fault rooted at Step 1 or 2 never reaches it. HP-07 and HP-11 still pass. `qa-tester` item 4.
  **Question — where does the handoff live?**
  - **A.** In the `:10-11` preamble: "Stop as soon as the root cause is found, then hand the fix and
    its regression test to `code/workflows/10-debug/`"; the `21-BUGS/` line stays at the end of
    Step 5, where only staging/prod needs it.
  - **B.** An unconditional closing paragraph after Step 5, outside its staging/prod heading,
    carrying both lines — no new step, no renumbering.
  - **C.** Leave it at the end of Step 5, as the story reads today.
  - **Recommendation: A.** The stop instruction is the one line every path obeys, so the handoff
    rides on it; add a scenario — a dev-only fault rooted at Step 2 routes the reader to `10-debug`.
  - **Ruling: A (11-qa round 3, Q14).** The handoff lives in the 09 `STEPS.md` preamble
    (`:10-11`): "Stop as soon as the root cause is found, then hand the fix and its regression test
    to `code/workflows/10-debug/`"; the `21-BUGS/` filing line stays at the end of Step 5.
    **Disposition:** the story's re-home task and _stops at the root cause_ Thens amended, and a
    story scenario added; HP-07 restated and HP-14 added.
- **AC-GAP-9** `[RESOLVED] 31/10/2026` · material — **HP-11's "no box without a step behind it" fails
  against the story's own edit set.** `CHECKLIST.md`:38 ("If a logging statement was missing: it
  has been added") claims a code change inside 09, contradicting the story's "no box claims one"
  (US013 _The workflow stops at the root cause_); `:39` raises docs or a story; `:56` "Committed and
  pushed" has no commit step in a workflow that now writes nothing. The story deletes only `:19-21`
  and `:25-27`. `S-04` owns "the shape of 09 `CHECKLIST.md`". `qa-tester` item 5. **Question — who
  repairs the three boxes?**
  - **A.** `S-04`: narrow HP-11 to the staging/prod bug-report box and name `:38`, `:39`, `:56` in
    Out of Scope.
  - **B.** This story: reword `:38` to hand a missing log line to `logging` / `10-debug`, keep
    `:39` as observational, and remove or re-home `:56`.
  - **C.** Split: this story rewords `:38` only, because it breaks this story's own Then; `:39` and
    `:56` go to `S-04` in Out of Scope, and HP-11 is scoped to match.
  - **Recommendation: C.** `:38` fails a scenario US013 writes, so it cannot wait; the other two are
    box-shape questions `S-04` already owns.
  - **Ruling: C (11-qa round 3, Q15).** This story rewords `CHECKLIST.md`:38 only, because it
    claims a fix and breaks US013's "no box claims one"; `:39` and `:56` go to `S-04`
    (`MAP-RULE-OWNERSHIP.md`, US020 provisional), the owner of the workflow's shape.
    **Disposition:** a `:38` task and Then added to the story, `:39` and `:56` named in its Out
    of Scope; HP-11 narrowed to exclude them explicitly.
- **AC-GAP-10** `[RESOLVED] 31/10/2026` · minor — **`Alloy` is a listed answer for `LOG_AGGREGATOR`,
  and it renders the logs pair as a shipper shipping to itself.** `copier.yml`:512 lists "Loki,
  Vector, Fluent Bit, Alloy, CloudWatch"; with `Alloy` answered, `code/src/logs/CONTEXT.md`:6 reads
  "Grafana Alloy captures and ships to Alloy" and `CLAUDE.md`:29-30 "Grafana Alloy → Alloy".
  `qa-tester` item 8; its 09 `CLAUDE.md`:12 half is folded (the "/Alloy" is dropped) and EC-07
  added. **Question — is the defect the help list or the sentences?**
  - **A.** The help list: drop `Alloy` from it in the same edit as Q9's sentence — it is a collector
    and queries nothing, and the question asks where logs are shipped **and queried**.
  - **B.** The sentences: put the shipper in a reference-deployment clause under the pair's marker
    and accept the tautology as the answer's own, as `OBSERVABILITY.md`:109-110 renders it today.
  - **C.** Neither: EC-07 records the reading and nothing changes.
  - **Recommendation: A.** One word in a help text the story already edits removes the reading at
    every site, including the precedent this story copies.
  - **Ruling: A (11-qa round 3, Q16).** `Alloy` is dropped from `LOG_AGGREGATOR`'s help-text list
    (`copier.yml`:508-513) in the same edit as Q9's bare-name sentence — `Alloy` is the reference
    deployment's own shipper, so answering it renders "Grafana Alloy … ships to Alloy" (reason
    restated 31/10/2026, 11-qa round 4, Q18; it read "a collector, not a store" until then, and
    option A's "queries nothing" is kept above as put). **Disposition:** the story's Q9 task and its Then carry it; with `Alloy` no longer
    offered, the logs pair's "ships to Alloy" reading has no listed answer to produce it, so EC-07
    is restated as a check on the help list and the 09 `CLAUDE.md`:12 half it already held.
    **Narrowed 31/10/2026 (re-check 2):** EC-07 now claims only what the help text proves; the
    other surfaces still offering `Alloy` are AC-GAP-11. **Widened 31/10/2026 (11-qa round 4,
    Q17):** EC-07 also checks the `05-ANSWERS.md`:124 mirror.

The two gaps below were raised by the scoped `qa-tester` re-check of 31/10/2026 (re-check 2 and
the remainder of 3), verified at the working tree the same day, and settled in 11-qa round 4 the
same day.

- **AC-GAP-11** `[RESOLVED] 31/10/2026` · material — **dropping `Alloy` from `copier.yml`'s help leaves three
  other surfaces offering it for `LOG_AGGREGATOR`.** `how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md`:124
  copies the help-text list word for word ("Loki, Vector, Fluent Bit, Alloy, CloudWatch") and
  drifts from it in this change; `code/docs/logging/OBSERVABILITY.md`:100 ("**Proven
  alternates:** Vector · Fluent Bit · Alloy · CloudWatch Logs", under `<%LOG_AGGREGATOR%>`) and
  `how-to/src/PLATFORM-PROVIDERS.md`:38 (the Logs row, which the new markers cite) list it as an
  alternate. `TEMPLATE-TOKENS.md`:121 lists no answers. None of the three is in the story's scope
  or Out of Scope, so a reader of any of them may still answer `Alloy`. **Question — how far does
  Q16's removal reach?**
  - **A.** The mirror only: add `05-ANSWERS.md`:124 to the Q16 task and its Then; name
    `OBSERVABILITY.md`:100 and `PLATFORM-PROVIDERS.md`:38 in Out of Scope as "proven alternates"
    lists (a shipper is a proven alternate component, not an answer), recorded in the
    `DEFERRED.md` entry `22` writes.
  - **B.** All three: drop `Alloy` from each `LOG_AGGREGATOR` list in this story. Widens the edit
    set by two docs outside the 09 seam, and reverses their claim that `Alloy` is a proven
    alternate.
  - **C.** The help text only, as ruled: name all three in Out of Scope and accept that the
    answer guide disagrees with `copier.yml` until a later story.
  - **Recommendation: A.** `05-ANSWERS.md`:124 is a copy of the text this story edits, so leaving
    it is drift the story itself creates; the other two are a different claim ("proven
    alternates") and belong to whoever owns provider neutrality. Note `05-ANSWERS.md` sits under
    `how-to/src/TEMPLATE-GUIDE/**`, the protected template-owner path, so the edit is the
    template's own and goes through that path's rule.
  - **Ruling: A (11-qa round 4, Q17).** The removal reaches the mirror only: `Alloy` is dropped
    from `05-ANSWERS.md`:124 in the same change as `copier.yml`'s help, re-measured at the working
    tree 31/10/2026. The template-docs guard stands down in syntek-base, where those files are the
    product being maintained (`.claude/hooks/CONTEXT.md`:91-93). `OBSERVABILITY.md`:100 and
    `PLATFORM-PROVIDERS.md`:38, both re-measured the same day, are "proven alternates" lists and
    stay. **Disposition:** the story's Q9/Q16 task and its copier Then carry the mirror; the two
    lists are named in its Out of Scope and in the `DEFERRED.md` entry
    `22-implementation-documentation` writes at close; EC-07 widened.
- **AC-GAP-12** `[RESOLVED] 31/10/2026` · minor — **Q16's written reason contradicts the list it leaves.** The
  ruling and the story (`US013`'s copier Then, "a collector that queries nothing"; the Q9/Q16
  task, "a collector, not a store") give a reason that fits Vector and Fluent Bit equally — both
  stay listed, and Fluent Bit is this plan's own test answer — while the help text itself still
  calls every listed answer "the collector". Section 8's "shipper-to-store" is corrected; the
  ruling's own words are not, because they are <%DEVELOPER_NAME%>'s. **Question — what reason
  does the story record for dropping `Alloy`?**
  - **A.** The actual defect: `Alloy` is the reference deployment's own shipper, so answering it
    renders "Grafana Alloy … ships to Alloy". Reword the Then and the task to say so.
  - **B.** Keep "a collector, not a store" and also drop Vector and Fluent Bit, making the list
    stores only (Loki, CloudWatch). Changes the plan's non-default test answer and Q16's scope.
  - **C.** Leave the wording; the removal is right whatever the reason says.
  - **Recommendation: A.** It is the reason AC-GAP-10 actually found, it removes nothing else,
    and it does not disturb the `Fluent Bit` test answer.
  - **Ruling: A (11-qa round 4, Q18).** The recorded reason is the real defect: `Alloy` is the
    reference deployment's own shipper, so answering it renders "Grafana Alloy … ships to Alloy".
    It replaces "a collector, not a store" wherever it was written — the story's copier Then and
    Q9/Q16 task, AC-GAP-10's ruling above, and Section 8. **Disposition:** Vector and Fluent Bit
    stay listed; the `Fluent Bit` test answer is untouched.

_All twelve gaps are `[RESOLVED] 31/10/2026`; none gates sign-off, which is <%DEVELOPER_NAME%>'s.
SPRINT-08 is already planned and is not at its fill trigger, so no `16-sprint-plans` pass waits
on this plan._

---

## 2. Test scenarios

Derived from the story's Gherkin and its QA criteria. **Every row runs against a file, a gate, a
render or the running dev stack; none against a rendered page.** Each is executed at
implementation; nothing below is measured on an edited tree, because no edit exists yet.

### Happy path (HP-nn)

| ID    | Given                                                               | When                                                                        | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ----- | ------------------------------------------------------------------- | --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | The six files as the story leaves them                              | Their fenced blocks are searched for a runnable `docker` command            | None found; the prose naming what a script wraps and the two never-invoke-`docker` rules remain                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| HP-02 | A running dev stack on this host                                    | Step 1 is typed as written                                                  | `server.sh up` brings the stack up and `logs.sh --service django --follow` follows it; output recorded (Q5)                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| HP-03 | The same stack                                                      | Step 2 is typed as written — one `shell.sh` session, every read inside it   | Each read returns from `/workspace/code/src/logs/django.log`; output recorded                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| HP-04 | The same session                                                    | The truncate in `code/src/logs/CONTEXT.md` Log rotation is typed            | `django.log` is emptied in-container; Step 2 points to that one copy (Q5 — posture `development`, the dev log disposable)                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| HP-05 | CI `[3/4] Template Generation` on the pushed `us013/` branch        | It renders `INCLUDE_MOBILE` false and true with default answers             | Zero unrendered tokens on both paths; run IDs recorded (Q1, Q2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| HP-06 | A `/tmp` scratch copy of the six files, tokens substituted by `sed` | Rendered with `ERROR_TRACKING=Bugsink`, `LOG_AGGREGATOR=Fluent Bit`         | `Bugsink` appears at each of the 18 listed error-tracker sites and `Fluent Bit` at each of the 12 listed log-aggregator sites, asserted **site by site per file**, by position over the 30 listed pre-edit sites — each located in the render by the anchor phrase the inventory task records, never by its pre-edit line number (re-check 5, 31/10/2026) — and never as a raw file-wide total (Section 6; AC-GAP-5, 11-qa round 2; `qa-tester` item 9; 11-qa round 3, Q12). The markers name the reference stack literally and add no token; indicative, US012's fixture method (Q1, Q3) |
| HP-07 | 09 `STEPS.md` and `CHECKLIST.md` as left                            | A reader reaches the end of the investigation                               | No step writes a test or a fix; the six fix boxes and their two headings are gone; the preamble's stop instruction (`:10-11`) hands the fix and its regression test to `10-debug`, and Step 5 ends with the `21-BUGS/` filing line for staging/prod (11-qa round 3, Q14); Steps 7-8 read 6-7; `CHECKLIST.md`:43 no longer cites **External — Testing** (`qa-tester` item 11)                                                                                                                                                                                                              |
| HP-08 | The verification step (was 7)                                       | An undeployed fix                                                           | The deploy is a precondition owned by `<%DEPLOY_REPO%>`, citing `how-to/docs/FEATURE-DEPLOY.md`; no command runs; only the error tracker and dashboards are read; the "error rate" read (`STEPS.md`:203) names no vendor; the step and the `CHECKLIST.md` box (`:34`) give one window, **30 minutes** (`qa-tester` items 7, 11)                                                                                                                                                                                                                                                           |
| HP-09 | `copier.yml` and `how-to/src/TEMPLATE-TOKENS.md` as left            | A reader looks for which tokens reach `code/docs/`                          | No list and no reach claim in either; `copier.yml` cites `TEMPLATE-TOKENS.md`; the shape rule stays; `LOG_AGGREGATOR`'s help carries the bare-name sentence (AC-GAP-4). `copier.yml` `:470-483` matches the post-edit text in the story's task: the guard "Do not put a parenthetical back into a prose-safe default." and the `PLATFORM-PROVIDERS.md` pointer survive, no token is named, and no sentence refers to removed text (`qa-tester` item 3)                                                                                                                                    |
| HP-10 | The four doc gates                                                  | Run at the end of the build                                                 | `docs-length.sh`, `docs-pairing.sh`, `doctrine-drift.sh` exit 0; `doc-references.sh` reads no new finding against the captured baseline (Section 6)                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| HP-11 | 09 `CHECKLIST.md` as left                                           | Its staging / prod box "Bug report filed in `21-BUGS/`" is traced to a step | It resolves to the `21-BUGS/` filing line at the end of Step 5; `:38` is reworded and claims no change made inside 09; every other box has a step behind it, **`:39` and `:56` excluded explicitly** — `S-04`'s, named in the story's Out of Scope (`qa-tester` item 5; 11-qa round 3, Q15)                                                                                                                                                                                                                                                                                               |
| HP-12 | 09 `CONTEXT.md` Outputs and `CLAUDE.md` Definition of done as left  | Each is read for where the regression test is written                       | Both hand it to `code/workflows/10-debug/`; searched across the six files, no sentence still says the regression test is added or written in 09                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| HP-13 | The S-07 record of the LogQL mismatch                               | Looked for where the story's task names it                                  | A dated note on the `S-07` row of `MAP-RULE-OWNERSHIP.md` names the four `Loki` sites held literal — `STEPS.md` :94, :98, `CONTEXT.md`:37, `CLAUDE.md`:28 — and why; `DEFERRED.md` is not edited (Q8; 11-qa round 2)                                                                                                                                                                                                                                                                                                                                                                      |
| HP-14 | A fault on the dev stack whose root cause is found at Step 2        | The reader stops there, as the 09 `STEPS.md` preamble instructs             | Observed in the live walk (HP-02/03), not as a text check — HP-07 owns that: the handoff to `code/workflows/10-debug/` sits above Step 1, and nothing from the preamble to the end of Step 2 sends a dev reader on to Steps 3 to 5; the reader need not reach Step 5, whose `21-BUGS/` line is staging/prod only (11-qa round 3, Q14; re-check 4, 31/10/2026). No 09 `CHECKLIST.md` box records the dev-path handoff; that box is `S-04`'s, named in the story's Out of Scope                                                                                                             |

### Error states (ES-nn)

| ID    | Given                                                                  | When                                                                                        | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ----- | ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | The non-default render                                                 | Searched **case-insensitively** for `glitchtip`                                             | Zero hits. A case-sensitive search is not evidence: it misses 15 of 16 sites today (AC-GAP-1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ES-02 | The non-default render                                                 | Searched case-insensitively for `loki`                                                      | A hit at each of the **4** held sites, asserted by position against the inventory's anchor phrases (re-check 5) — 09 `STEPS.md` :94 and :98 below the Steps 4-5 marker, 09 `CONTEXT.md`:37 and `CLAUDE.md`:28 below their markers (AC-GAP-5); plus **exactly one** in each reference-stack marker that names it — all six, under ES-08's minimum content, so 10 in all; `:176` reads "the log lines from Step 4"; any other hit fails (`qa-tester` items 1, 9; 11-qa round 3, Q12)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ES-03 | The non-default render — not the CI default paths (11-qa round 3, Q13) | Searched case-insensitively for `grafana`, `alloy`, `prometheus`                            | Every hit sits in a file carrying the one reference-stack marker, **in the marker, or below it and within that file's marker scope**: 09 `STEPS.md` Steps 4 to 5 (the marker to the `---` closing Step 5); 09 `CHECKLIST.md` its staging / prod section; 09 `CONTEXT.md`, 09 `CLAUDE.md` and both `code/src/logs/` files the whole file below the marker. No hit above the marker, and none outside its scope — line order alone is not a pass (`qa-tester` item 7; re-check 1, 31/10/2026: Q12's minimum content names no section, so the scope is fixed here, not by the marker)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ES-04 | Any of the three renders                                               | Searched for a surviving token delimiter                                                    | None; on the CI paths this is `[3/4]`'s own unrendered-token step                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ES-05 | A rendered count that differs from the expected count                  | Compared                                                                                    | The check fails and records both numbers; it is never rounded to a pass                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ES-06 | The dev stack not running when the walk starts                         | The walk is attempted                                                                       | Recorded as unmeasured with the reason (`code/docs/GATE-REPORTING.md`), never as passed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ES-07 | `logs.sh` or a `docker compose` argument in scope naming `backend`     | Searched                                                                                    | Fails the story; the service is `django`. The LogQL `<%PROJECT_SLUG%>-backend` selectors are `S-07`'s and are not counted                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ES-08 | The six files as left                                                  | Each is searched for the reference-stack marker                                             | Exactly **1** per file, at the scenario's anchor (`qa-tester` item 7): 09 `STEPS.md` between the `---` closing Step 3 and the Step 4 heading; 09 `CONTEXT.md` intro; 09 `CLAUDE.md` under the Purpose heading, above the purpose sentence; 09 `CHECKLIST.md` under the staging / prod heading; `code/src/logs/CONTEXT.md` intro, above the staging/production blockquote; `code/src/logs/CLAUDE.md` above the dev/test-only rule. Each opens as `code/docs/logging/OBSERVABILITY.md`:109 does ("The reference deployment runs …") and cites `how-to/src/PLATFORM-PROVIDERS.md`. **Minimum content (11-qa round 3, Q12):** it names the reference stack literally, with no token — Grafana Alloy shipping to Loki, LogQL in Grafana, Prometheus — naming Loki exactly once, and in 09 `STEPS.md`, `CONTEXT.md` and `CLAUDE.md` says the held `Loki` sites describe the reference deployment — **referring to them without naming the product** (for example "the query steps below describe that deployment"), since a second `Loki` in the marker breaks this row and ES-02's 10 (re-check 6, 31/10/2026). **Fails** on a file with a Grafana, Alloy or Prometheus hit and no marker, a file with two, a marker elsewhere in its file, a marker without the citation, or a marker short of that content |
| ES-09 | The six files as left, **in source**, before any render                | Every copier token in them is listed and checked against `copier.yml`'s top-level questions | Every name is defined. A misspelt token (`LOG_AGGREGATER` between the token delimiters) fails here: `_envops` (`copier.yml`:26-33) sets no `undefined`, so Copier renders it as an empty string, CI `[3/4]` reports 0 unrendered tokens, and the `sed` render keeps the typo (`qa-tester` item 9)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |

### Edge cases (EC-nn)

| ID    | Given                                                                       | When                                             | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ----- | --------------------------------------------------------------------------- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | `ERROR_TRACKING` answered `Sentry`                                          | The render is read for the browser SDK           | `:146-148` reads "… are captured by the browser SDK, which forwards them to Sentry (Step 3), never to Loki."; no "Sentry's Sentry SDK" (AC-GAP-2, restated after `qa-tester` item 6)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| EC-02 | A two-word answer, `Fluent Bit`                                             | Every substituted sentence is read aloud         | No sentence breaks around it, including possessives and table cells (the read-across criterion)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| EC-03 | The `Prometheus + Grafana dashboards` cell in 09 CONTEXT                    | Rendered under any answer set                    | Literal, below the CONTEXT marker; not tokenised to `<%OBSERVABILITY_STACK%>` (Out of Scope)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| EC-04 | `INCLUDE_RUST`, `INCLUDE_DESKTOP`, `INCLUDE_CLICKUP`, `INCLUDE_WAGTAIL` set | Generated                                        | The six files render identically: no `_exclude` entry names either directory, and none carries a Jinja block (the block-delimiter form) (measured 31/10/2026) (Q2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| EC-05 | The six files after the edit                                                | The read-across counts the `django.log` truncate | **Passes** when it appears once, in `code/src/logs/CONTEXT.md` Log rotation, with Step 2 pointing to it. **Fails** when it appears twice, or not at all                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| EC-06 | The tree after Step 6 is deleted                                            | Every "Step N" citation of workflow 09 is read   | Every reference in 09 `STEPS.md` resolves to the renumbered step; the Key references table carries no pytest row; re-grep the tree for an outside citation of a 09 step number — none on 31/10/2026 (only `STEPS.md` cites them), and any found at build resolves                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| EC-07 | `LOG_AGGREGATOR`'s help in `copier.yml` (`:508-513`) as left                | Its list of answers is read                      | It reads "Loki, Vector, Fluent Bit, CloudWatch" — `copier.yml`'s help no longer offers `Alloy`, so it no longer invites the logs pair's "Grafana Alloy … ships to Alloy" reading (`CONTEXT.md`:6, `CLAUDE.md`:29-30) (11-qa round 3, Q16; reason as restated in 11-qa round 4, Q18). `how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md`:124, its `LOG_AGGREGATOR` row, names the same four with no `Alloy` (11-qa round 4, Q17). It claims nothing about `OBSERVABILITY.md`:100 or `PLATFORM-PROVIDERS.md`:38, which keep `Alloy` as a proven alternate and are Out of Scope (AC-GAP-11); 09 `CLAUDE.md`:12 reads "`<%ERROR_TRACKING%>`, `<%LOG_AGGREGATOR%>`, and Grafana" with no "/Alloy" (`qa-tester` item 8) |

### Permission and access (PA-nn)

**N/A.** No endpoint, view, protected action or role boundary. The routed commands run with the
developer's own rights against a local stack. Recorded rather than omitted, per
`code/docs/GATE-REPORTING.md`.

---

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The output is Markdown read in an editor or
on a code host. The ✅/❌ tool matrix in 09 `CONTEXT.md` is unchanged by this story.

## 4. Responsive behaviour

**N/A — no layout, no breakpoint, no rendered page.**

## 5. GDPR & security constraints

**None — no PII, no new protected action.** The GDPR flag's reason stands: the personal-data path
left this slice for `S-07` and `S-08` (Q14, 27/08/2026). The one constraint with a data shape is
existing doctrine kept, not added: 09 `CLAUDE.md` forbids pasting secrets, tokens or PII from logs
into commits, bug reports or the workflow files, and the live walk's recorded output (HP-02 to
HP-04) is a dev log of a disposable stack, trimmed to what proves the command ran.

---

## 6. Developer notes — testability

- **Precondition — recapture the `doc-references.sh` baseline before the first edit, finding by
  finding.** Per
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  the whole-tree count and every finding by identity go into
  `project-management/src/18-TESTS/MANUAL/US013-MANUAL-TESTING.md` before any file is touched. The
  gate-triage whole-tree run did not finish in 16 minutes, so no baseline exists yet; give it the
  time it needs, and if the capture is missed record it as missed — never reconstruct it. The
  criterion is then no **new** finding from any file the story edits, never "the gate passes".
- **Capture the other three gates the same way, before the first edit**, so each end-of-build
  reading is a diff and not a claim: `docs-length.sh`, `docs-pairing.sh`, `doctrine-drift.sh`
  (Section 7 has today's readings, which are indicative only).
- **Generated-project check (Q1, Q2).** The two default render paths are CI's: push the `us013/`
  branch and record the `[3/4] Template Generation` run IDs for `INCLUDE_MOBILE` false and true.
  Never make a tree with a raw `uvx copier copy` (`.claude/CLAUDE.md` Section 6). **On those two
  paths the check is only that every token renders** — no unresolved token (ES-04, HP-05) —
  plus ES-09's defined-question check at source (11-qa round 3, Q13). The non-default set,
  `ERROR_TRACKING=Bugsink` and `LOG_AGGREGATOR=Fluent Bit`, runs on a `/tmp` scratch copy of the
  six files with the tokens substituted by `sed`; nothing is written into the repository. **The
  case-insensitive unmarked-literal grep (ES-01 to ES-03) runs on that render only**: on a default
  path every token renders back to `GlitchTip` or `Loki`, byte-identical to a missed literal
  (`qa-tester` item 2). The `sed` render is lawful and equal to real output **for these six files
  only**, because they carry no Jinja block and no `_exclude` entry — the reason other flag
  combinations render them identically (EC-04). Recorded as indicative.
- **Expected counts (Q3), measured 31/10/2026 against the story's planned edit set.**
  `<%ERROR_TRACKING%>`: **18** — 16 in the 09 folder (`STEPS.md` 9, `CHECKLIST.md` 2, `CONTEXT.md`
  2, `CLAUDE.md` 3) and 2 in the `code/src/logs/` pair; `:147`'s rewording keeps it one site.
  `<%LOG_AGGREGATOR%>`: **12**, settled in 11-qa round 2 and re-measured at the working tree — 17
  `Loki` sites (13 in the folder, 4 in the pair) less `:94` and `:98` held under the Steps 4-5
  marker, `:176` reworded vendor-free, and 09 `CONTEXT.md`:37 and `CLAUDE.md`:28 held under their
  markers (AC-GAP-5). A rendered count is compared with 12, and a mismatch is a failure, not a
  re-count (ES-05).
- **Counting method — occurrences, per file** (`qa-tester` item 10). Count with
  `grep -oi <name> <file> | wc -l` against each file's expected figure, never `grep -c`, which
  counts lines and diverges from occurrences once a hand edit puts two sites on one line. The 18
  and 17 above were measured as lines and re-measured as occurrences on 31/10/2026; the two agree
  in every file. **Expected per file after the edit** — `<%ERROR_TRACKING%>`: 09 `STEPS.md` 9,
  `CHECKLIST.md` 2, `CONTEXT.md` 2, `CLAUDE.md` 3; logs `CONTEXT.md` 1, `CLAUDE.md` 1.
  `<%LOG_AGGREGATOR%>`: 09 `STEPS.md` 5, `CHECKLIST.md` 0, `CONTEXT.md` 1, `CLAUDE.md` 2; logs
  `CONTEXT.md` 2, `CLAUDE.md` 2. HP-06 and ES-02 then assert **by position** within each file, over
  the 30 listed pre-edit sites — never as a raw file-wide total (11-qa round 3, Q12). The edit
  moves every line, so each site is found in the render by the anchor phrase (heading or sentence
  fragment) the story's inventory task records beside its line number (re-check 5, 31/10/2026);
  for HP-06 the per-file totals above already prove exactness, since the markers add no token, but
  for ES-02's `loki` hits the position is the whole check. The markers
  add no token, so the token figures stand; each names `Loki` once, so a non-default render reads
  `loki` at the 4 held sites plus one per marker, 10 in all (ES-02).
- **Source-side token check (ES-09).** Before any render, list every copier token in the six files
  and check each against `copier.yml`'s top-level questions. Neither CI nor the `sed` render
  catches a misspelt token on its own (`qa-tester` item 9). The story's inventory task, which read "29 + 6" until round 1, reads 35 sites
  (18 + 17), 30 of them tokenised.
- **Live walk (Q5)** on this host's running dev stack, the in-container `django.log` truncate
  included — posture `development`, the dev log disposable. Every command typed as the story
  leaves it, output recorded in the manual testing guide.
- **Second tester (Q4).** <%DEVELOPER_NAME%> walks Claude's edits. A fresh `general-purpose`
  subagent may walk the mechanical rows — the gate runs and the grep counts — and
  <%DEVELOPER_NAME%> reviews its record. The author never signs its own walk.
- **No pytest, no coverage, no migration check.** The story marks those rows `N/A` with reasons;
  the test-status record carries the same.

## 7. Gate readings, measured 31/10/2026 — indicative, not baselines

Taken on `pm/story-creation` at `9ee3ea7`, clean tree, before this plan was written.

| Reading                                    | Value                                                                                                                       |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| `docs-length.sh`, whole tree               | **Exit 0** — 788 files, none over 300, 5 at warn; none of the six in-scope files among them                                 |
| In-scope counted lines (`cloc` code lines) | 09 `STEPS.md` 151 · `CHECKLIST.md` 37 · `CONTEXT.md` 48 · `CLAUDE.md` 42; `code/src/logs/` `CONTEXT.md` 46 · `CLAUDE.md` 30 |
| `docs-pairing.sh`, whole tree              | **Exit 0** — 226 `CONTEXT.md`, 216 `CLAUDE.md`, split intact                                                                |
| `doctrine-drift.sh`, whole tree            | **Exit 0** — 3 claims, each with one home                                                                                   |
| `doc-references.sh`, whole tree            | **Not captured** — recapture at start (Section 6); the triage run did not finish in 16 minutes                              |
| `doc-references.sh --path`, edit set       | 09 folder, `code/src/logs/`, `how-to/src/TEMPLATE-TOKENS.md`: **clean**; `copier.yml`: nothing eligible to read             |
| Vendor literals, case-insensitive          | GlitchTip 18 (16 + 2) · Loki 17 (13 + 4) · Sentry 0 · Grafana 16 · Alloy 4 · Prometheus 4                                   |
| Tokens already in scope                    | `<%PROJECT_SLUG%>` 5 · `<%PROJECT_NAME%>` 1; no Jinja block in any of the six; no `_exclude` entry for either tree          |
| Dev stack                                  | **Not measured** at writing — the walk is the build's (Q5)                                                                  |

---

## 8. Candidates re-opened and refuted

- **"Brand runs, because the story writes tokens."** Refuted: copier answer tokens are Copier
  substitutions, not design tokens; `06-brand-guides` owns the latter (gate triage).
- **"Logging runs, because the story is about logs."** Refuted: it adds or changes no logger, event,
  field, level or retention; `14-logging-checks` gates a log surface, and none moves (gate triage).
- **"Every render path means every flag combination, so the check needs more CI paths."** Refuted
  for these six files: they are unconditional and block-free (EC-04); two CI paths plus that
  recorded reason satisfy the criterion (Q2).
- **"A `sed` render is not a render."** Refuted for these files only: with no conditional block and
  no `_exclude` entry, Copier's output is the substitution; recorded as indicative (Q1).
  **Qualified 31/10/2026 by the `qa-tester` run (item 9):** true only while every token is spelt
  right. `_envops` sets no `undefined`, so Copier renders a misspelt token as an empty string where
  the `sed` render keeps it; ES-09 closes that difference at source.
- **"Tokenising `Loki` in the `code/src/logs/` intro breaks the sentence ('Alloy … ships to Fluent
  Bit')."** Refuted: grammatical, and true of a shipper-to-shipper or shipper-to-store pipeline — Fluent
  Bit is itself a shipper (corrected 31/10/2026, re-check 3); the Alloy half sits
  under the pair's marker. **Holds for Fluent Bit only:** the `qa-tester` run (item 8) showed that
  `Alloy`, then a listed answer, rendered "Grafana Alloy … ships to Alloy". **Closed 31/10/2026**
  by dropping `Alloy` from `LOG_AGGREGATOR`'s help list and its `05-ANSWERS.md`:124 copy
  (AC-GAP-10, -11; 11-qa round 3, Q16; round 4, Q17; EC-07). The reason recorded is that
  self-reference — `Alloy` is the reference deployment's own shipper — not that it is "a
  collector, not a store", which Vector and Fluent Bit share (11-qa round 4, Q18).

---

## Cross-references

- `project-management/src/02-STORIES/US013.md` — the story this plan tests; AC-GAP-1 to -5 resolved in it 31/10/2026, the `qa-tester` fold applied 31/10/2026, AC-GAP-6 to -10 resolved in it 31/10/2026 (11-qa round 3), AC-GAP-11 and -12 resolved in it 31/10/2026 (11-qa round 4)
- `project-management/src/03-SPRINTS/SPRINT-08.md` — the record US013 opens as its `Must`
- `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` — slice `S-01`, nodes N-001, N-012, N-013; `S-07` owns the LogQL blocks
- `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` — the baseline-and-diff regime
- `project-management/src/11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md` — the CI-render and fixture precedent
- `project-management/src/11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the docs-only precedent
- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan
- `code/docs/GATE-REPORTING.md` — the rule behind every `N/A` and unmeasured row
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
