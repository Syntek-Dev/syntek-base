# SPRINT-08

**Last Updated**: 01/11/2026 **Version**: 0.2.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Debugging an incident runs through the scripts against structured logs: the 09 workflow
is honest and every log line carries a request_id.

<!-- Settled 31/10/2026, 03-sprint-planning grilling round 1 Q1 (<%DEVELOPER_NAME%>). Derived from
     the title and Client Summary of US013, the sole member, and from the slice CUT-PLAN.md P8
     reserves as this record's second member — RULE-OWNERSHIP `S-07`, US014 (provisional), the
     structured-logging slice. The first clause is US013's; "every log line carries a request_id"
     is US014's working title, and it is in the goal BY CALL, not by drift.
     project-management/src/03-SPRINTS/SPRINT-02.md recorded on 05/09/2026 that a goal naming a
     deliverable no member carries is a defect; this goal names one member's deliverable and one
     reservation's, and the reservation is stated in the Notes below. If US014 is cut and admitted,
     the goal already reads true of both members. If US014 is not admitted here, the goal is
     rewritten in that change from the members it then has — SPRINT-07's rewrite of 21/09/2026
     is the precedent. Worded so that a re-pricing of US014 at its own cut does not reach it: no
     figure, no estimate and no file count appears in the sentence.

     CONFIRMED 01/11/2026 on US014's admission: the goal reads true of both members as written
     and is not rewritten (03-sprint-planning grilling round 1, Settled — Goal). -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **11 SP Must = 11 / 11 SP** — at capacity, the fill trigger,
two members, all-`Must`. US014 took the 8 SP `project-management/src/02-STORIES/CUT-PLAN.md` P8
reserved, admitted 01/11/2026. The record is **full**, and its sprint plan and both story plans
are **owed** once every member has cleared the specify tier. See Notes.

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story admitted,
     never edit it directly.
     Computed 31/10/2026 on US013's admission at opening — the union over one member is that
     member's table, copied verbatim from project-management/src/02-STORIES/US013.md, including the
     reasoning its GDPR row carries in place of a bare N/A. One row carries a value: QA names the
     manual type, the four doc gates and the generated-project check. Twelve rows read N/A. Nothing
     in either row is substituted or reworded.

     THESE ARE FIRST-PASS VALUES. On 31/10/2026 no artefact under
     project-management/src/11-QA/ names US013, it has no manual testing guide in
     project-management/src/18-TESTS/MANUAL/, and it has no story plan. Its one gate that runs,
     11-qa-checks, runs before US014 is cut (CUT-PLAN.md P1: one story at a time). Per
     code/docs/GATE-REPORTING.md this is a gate not yet entered, reported as such — not a gate
     that found nothing. When gate 11 closes, the union is recomputed here from the member's table
     as that gate leaves it.

     RECOMPUTED 31/10/2026 AT 11-qa-checks, from US013's table as that gate left it, copied
     verbatim: the QA row now searches case-insensitively (11-qa-checks grilling round 1, Q6), and
     the Security, SEO and Logging rows carry a one-line inline reason as the GDPR row does (Claude's
     call, accepted in the same round). No row changed between N/A and a value. The "first-pass"
     paragraph above is the record of the opening and is kept as written: gate 11 has run
     (project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md) but is not
     closed, because the plan is not signed off and AC-GAP-5 is OPEN.

     AMENDED 31/10/2026 after 11-qa-checks grilling round 2 (Q10, Q11): AC-GAP-5 is RESOLVED into
     US013 — four LogQL-bound Loki sites held literal, STEPS.md:176 reworded vendor-free, the
     LOG_AGGREGATOR count 12. US013's flag table did not change, so the union above stands. Gate 11
     is still not closed: the plan is not signed off, and its qa-tester dispatch is owed.

     AMENDED 31/10/2026 after the 11-qa-checks qa-tester run: eleven findings, seven folded into
     the plan and US013 (wording and task repairs, no flag moved), and five gaps opened with
     <%DEVELOPER_NAME%> as AC-GAP-6 to -10 (one finding split between the two). US013's flag table
     did not change, so the union above stands. Gate 11 is still not closed: five [OPEN] gaps and
     no sign-off.

     RECOMPUTED 31/10/2026 after 11-qa-checks grilling round 3 (Q12 to Q16): AC-GAP-6 to -10
     RESOLVED into US013. Its QA row changed in wording, not between N/A and a value — the
     unmarked-literal grep now runs on the non-default Bugsink / Fluent Bit render only, and the CI
     default paths check only that every token renders (Q13) — and is copied here verbatim. Gate 11
     has no [OPEN] gap and its qa-tester run is done; it closes on <%DEVELOPER_NAME%>'s sign-off.

     AMENDED 31/10/2026 after the scoped qa-tester re-check of round 3: AC-GAP-11 and -12 are
     [OPEN] in the QA plan, waiting on <%DEVELOPER_NAME%>. US013's QA row is unchanged, so nothing
     is recopied; the previous paragraph is kept as the record of round 3, and Gate 11 is not
     closed until both are ruled.

     AMENDED 31/10/2026 after 11-qa-checks grilling round 4 (Q17, Q18): AC-GAP-11 and -12
     RESOLVED into US013 — Alloy also leaves the TEMPLATE-GUIDE/05-ANSWERS.md:124 copy of the help
     list, the two "proven alternates" lists go to Out of Scope and the DEFERRED.md entry, and the
     recorded reason is that Alloy is the reference deployment's own shipper. US013's flag table
     did not change, so nothing is recopied. Gate 11 has no [OPEN] gap, its qa-tester run and
     scoped re-check are done; it closes on <%DEVELOPER_NAME%>'s sign-off.

     RECOMPUTED 01/11/2026 ON US014'S ADMISSION — the union over two members, each value copied
     verbatim from its story's table and prefixed with the member it comes from, SPRINT-05's
     convention. US014 brings five live rows — GDPR, Security, QA, Logging, Backend — and US013
     contributes only to QA, so four rows that read N/A with US013's reason now read US014's value:
     a union is never narrower than a member, and an N/A cannot narrow a value. SEO and API carry each
     member's reason, prefixed; both members are N/A there. US014's values are FIRST-PASS: it has entered none of its
     gates (09, 10, 11, 14), so each row is recomputed when that gate closes. Customer review is
     not a sprint row — the template's 13 gates are.

     RECOMPUTED 01/11/2026 AFTER US014'S GATES 09, 10, 11 AND 14 RAN (three grilling rounds with
     <%DEVELOPER_NAME%>, an independent review per gate, the qa-tester run and its scoped re-check).
     US014's GDPR, Security, QA and Logging rows are copied verbatim from its table as the gates left
     it, each prefixed "US014:"; US013's QA half is unchanged. No row moved between N/A and a value.
     The gate plans are written and await <%DEVELOPER_NAME%>'s sign-off; the values are no longer
     first-pass. All five were signed off the same day; gates 09, 10, 11 and 14 are closed. -->

| Flag       | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| User Flow  | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Brand      | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Components | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Wireframes | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| GDPR       | US014: Yes — PII incidental, no new field; planned 01/11/2026 in `09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` (signed off 01/11/2026 by <%DEVELOPER_NAME%>); no redaction ships — the minimisation is the staging/prod extras allowlist and the dropped `exc_info` message, while `message` (not scrubbed) still carries `str(exc)` for `BadRequest`/`SuspiciousOperation` (Q9, Q11; gates Q6); the claim covers Django's `LOGGING` lines, the process-server stderr stream documented outside it (gates R2-Q1); app-server access log dropped outside dev (gates Q1), dev keeps uvicorn's (gates R2-Q8); Art. 6(1)(f) with the LIA, 14/90-day reference retention and the Art. 11 position (a supplied `request_id` may have to be served) surfaced to the controller for legal sign-off (gates Q2-Q4, R2-Q7); edge access log retention is the controller's                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Security   | US014: A09:2025 — `request_id` on every record Django's `LOGGING` emits, null for a record outside the middleware's dynamic extent (gates round 3, R3-Q3), the process-server stderr stream documented with a selector that keeps it (gates round 2, R2-Q1); the edge sets `X-Request-ID` unconditionally (gates Q7); the staging/prod field allowlist; no exception message in `exc_info` off dev, Django's `str(exc)` messages named (gates Q6); request paths logged, so none carries a secret or PII (gates Q5) — threat model and assessment planned 01/11/2026, 0 CRITICAL / 0 HIGH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| QA         | unit, manual — US013: manual — `docs-length.sh`, `docs-pairing.sh`, `doc-references.sh`, `doctrine-drift.sh`; generated-project check — on every render path the template offers, every token in scope renders; on the non-default Bugsink / Fluent Bit render only, no unmarked vendor literal survives, searched case-insensitively, in `code/workflows/09-debugging-with-logs/` or `code/src/logs/` · US014: unit — formatter (valid JSON on quote, backslash, newline; field set and pinned UTC timestamp, `TZ`-independent; ensure_ascii and the escaped `/caf\xe9/` path; allowlist; exception shape: type and {filename, lineno, function} frames, type-only cause/context chain, group member types, notes dropped; never raises — bad %-args, a raising `__str__`, `logger.exception()` outside `except` — its fallback one JSON object keeping the extras `str()`-coerced in place through a guarded repr, `message` falling back to `str(record.msg)` (gates round 3, R3-Q2); context cycle, 2000-link chain and `(None, None, None)` give one line; the minimal line capped at 16 KiB with `"truncated": true` (R3-Q1); `BadRequest`'s `str(exc)` in `message`, none in `exc_info`), filter (`request_id` in and out of a request; overwrite; reset after a request; returned 4xx and 5xx under `Client` and `AsyncClient` from the id `RequestIDMiddleware` stores on the request; a raised `PermissionDenied` through the ContextVar; a rejected inbound id never in the line; a `request` extra with no stored id gives null; a streaming body's line null, pinned (R3-Q3); isolation on two barrier threads), the middleware's stored id under a function-level marker, the filter on every handler of every environment's `LOGGING` (importlib, no dictConfig; every entry built through `DictConfigurator`; negative fixtures proving the check can fail), staging == production `LOGGING`, staging/production/test's `django` logger at WARNING with no handlers, staging's console handler writing one JSON line to stdout (`capsys`); static — no `--access-logfile` in the three entrypoints and `--log-level warning` in staging's (R3-Q4), entry 13's `$request_id` access-log requirement, the JSON claim bounded to Django's `LOGGING` and the process-server stream named with a selector that keeps it, the documentation content criteria; manual — the dev mount and a parsed host `django.log` line after a request to an unmatched path, the doc gates |
| SEO        | N/A — US013: no public page; every file edited is developer documentation · US014: no public page                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| API        | N/A — US014: no endpoint                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Logging    | US014: the pipeline itself — JSON formatter and `request_id` filter on every handler Django's `LOGGING` declares; per-environment levels and field sets, the `django` logger at `WARNING` with no handlers in staging, production and test (gates grilling 01/11/2026, Q8; round 2, R2-Q2); the process-server stderr stream documented outside it with a query that keeps it (R2-Q1), staging's process-server at `--log-level warning` as production's (gates round 3, R3-Q4); the minimal line capped at 16 KiB with a `"truncated": true` marker, the over-4 KiB interleave an accepted residual (R3-Q1); records outside the middleware's dynamic extent documented as uncorrelated (R3-Q3); the collector relabels `com.docker.compose.service` to `service_name` and `com.docker.compose.project` to an environment label (Q10, Q11) — confirmed 01/11/2026 against Grafana Alloy v1.21 (`14-LOGGING/PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Backend    | US014: Yes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Frontend   | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |

---

## Story Summary

| ID    | Title                                                                                                                      | MoSCoW    | SP  |
| ----- | -------------------------------------------------------------------------------------------------------------------------- | --------- | --- |
| US013 | The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause | Must Have | 3   |
| US014 | Structured JSON logging with a `request_id` on every entry, queried by Compose service label                               | Must Have | 8   |

**Total:** 11 SP — all committed, no stretch tier. Two members, in build order US013 then US014.

<!-- US013 admitted 31/10/2026 at 03-sprint-planning, cut the same day from
     project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md slice `S-01` (nodes N-001, N-012
     and N-013). The row reads Must Have at 3 SP, matching
     project-management/src/02-STORIES/US013.md: the `Must` was settled 21/09/2026 (CUT-PLAN.md,
     MAP-RULE-OWNERSHIP round, Q6) and the 3 SP the same day, confirmed at cut. This record derives
     its tiers FROM its stories and edits neither figure. Its `**Status:**` reads `Open` and this
     record moves it nowhere. US013 sits in no other record's table.

     US014 admitted 01/11/2026 at 03-sprint-planning (grilling round 1 Q1), cut 31/10/2026 from
     MAP-RULE-OWNERSHIP.md slice `S-07` (node N-020). Must Have at 8 SP, matching
     project-management/src/02-STORIES/US014.md: the `Must` settled 21/09/2026 (CUT-PLAN.md Q6 = 2)
     and the 8 SP the same day, confirmed at cut. Its `**Status:**` reads `Open`; this record moves
     it nowhere. US014 sits in no other record's table. -->

## Dependencies

- **US013 has no upstream dependency.** `MAP-RULE-OWNERSHIP.md` has an empty frontier and an
  unblocked gate to stories; N-001, N-012 and N-013 are settled, and no open story edits the 09
  folder or the `code/src/logs/` pair (`project-management/src/02-STORIES/US013.md` ->
  Dependencies). `SPRINT-01` to `SPRINT-07` are all closed, so this record is the only one that
  could receive it.
- **US013 unblocks four slices by merge order, not by a blocking edge.** `S-07` (US014,
  provisional), `S-03` (US017, provisional), `S-04` (US020, provisional) and `S-08` (`Held` on
  MAP-BUN-TOPOLOGY) all edit the 09 folder and merge **after** US013, rebasing onto it. `S-07` is
  the one P8 places in this record; the build order inside the record is therefore US013 then
  US014, which is also P8's order.
- **Neither US013 nor US014 blocks on US004**, for the reason SPRINT-04 to SPRINT-07 each record for their
  own members: the citation gate's baseline-diff regime
  (`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`)
  is a reporting regime and sequences nothing. US013's own QA criterion reads `doc-references.sh`
  under it unless US004 has landed and the gate is green, and US014's doc-gate row does the same
  (added 01/11/2026 on its admission).
- **US014 merges after US013 inside this record**, rebasing onto its edits to 09 Step 4, 09
  `CONTEXT.md` and the `code/src/logs/` pair (`project-management/src/02-STORIES/US014.md` ->
  Dependencies).
- **US014 merges after US008, which sits in the closed `SPRINT-05` and still reads `Open`** — a
  merge-order dependency, not a block on admission (settled 01/11/2026, 03-sprint-planning grilling
  round 1 Q2). US008 edits `base.py`, `staging.py`, `production.py` and `EDGE-REQUIREMENTS.md` and
  pins `dev.py` and `test.py` unchanged; US014 rewrites all five, so it lands second. Sprint
  numbering is not execution order, and setting US014 `Blocked` is `completion`'s call when work
  starts, not this record's.
- **Sprint numbering and build order agree.** The settled build order is the prefix on each plan in
  `project-management/src/17-STORY-PLANS/` — twelve plans on disk on 31/10/2026, `01-` to `12-` —
  and US013 builds thirteenth, at a **reserved `13-`**. It is a **reserved number, not a plan**,
  until `17-story-plans` writes it, and nothing here may cite it as a plan before then (SPRINT-04's
  rule for US006's `07-`). This is this gate's reading on SPRINT-07's precedent of 21/09/2026, not
  a call made on the day; it moves if build order does. **US014 builds fourteenth, at a reserved
  `14-`** (settled 01/11/2026, 03-sprint-planning grilling round 1 Q3) — likewise a number, not a
  plan, until `17-story-plans` writes it.
- **Nothing carries into this record, and nothing is reserved out of it.** US003's carry is
  reserved into SPRINT-03 and US009's into SPRINT-06. SPRINT-07's US011 has a drop branch with no
  receiving record, and this record does not become one: see Notes.
- **`Blocked` is a story status, not a sprint one.** US013's and US014's own `**Status:**` lines read `Open`, and a
  status flip is `.claude/skills/completion/SKILL.md`'s to make when the work starts.

## Notes

**This record opens with its first admitted story, as SPRINT-05, SPRINT-06 and SPRINT-07 each
did.** `project-management/src/03-SPRINTS/SPRINT-07.md` -> Notes recorded on 21/09/2026 that "A
new admission opens SPRINT-08" and that it "is opened by the first story admitted to it, at
`03-sprint-planning` … and not in advance". US013 is that story, cut and admitted on 31/10/2026.
It is the first story cut since SPRINT-07 closed by call, and the first cut under CUT-PLAN.md's
one-story-at-a-time rule (P1).

**At opening (31/10/2026) the rest of this record was reserved, and the reservation is stated here rather than in the
register.** The paragraph is kept in its opening tense. `project-management/src/02-STORIES/CUT-PLAN.md` P8 (27/09/2026) gives SPRINT-08 to
RULE-OWNERSHIP: US013 then US014, at 11 / 11. US014 is **provisional** — slice `S-07` on
`MAP-RULE-OWNERSHIP.md`, priced at 8 SP in CUT-PLAN.md's cut order and not yet cut — so it is a
reservation, not a member. It is not in the Story Summary, it is not counted in the capacity
figure, and the backlog register's row names US013 alone (settled 31/10/2026, 03-sprint-planning
grilling round 1 Q2). Under P1, US013's own QA gate, `11-qa-checks`, runs before US014 is cut.
US014's admission is `03-sprint-planning`'s at that time, on the figure its own cut gives it.
**Discharged 01/11/2026:** US014 was cut on 31/10/2026 at the priced 8 SP and admitted the next
day (03-sprint-planning grilling round 1 Q1); the reservation is now a member, and this paragraph is
kept as the record of the opening.

**The backlog register.** Every live record carries this table and the copies are identical; **this
record is `SPRINT-08`**. It became a live register on 17/09/2026, when US009 was placed into
SPRINT-05 — until that day it stood in three records only, four rows long, and was scoped to the
07/09/2026 cascade alone.

| Sprint      | Members, in build order                                         | SP                                                          |
| ----------- | --------------------------------------------------------------- | ----------------------------------------------------------- |
| `SPRINT-01` | US007 (`Must`, 5) then US001 (`Must`, 5)                        | 10 / 11 — closed                                            |
| `SPRINT-02` | US002 (`Must`, 3) then US003 (`Should`, 5, stretch)             | 8 / 11 — closed                                             |
| `SPRINT-03` | US004 (`Must`, 8), plus US003's reserved 5 SP carry if it slips | 8 / 11 — closed, holding a reservation; 13 / 11 if it lands |
| `SPRINT-04` | US005 (`Must`, 5) then US006 (`Must`, 8)                        | 13 / 11 — at grace, closed                                  |
| `SPRINT-05` | US008 (`Must`, 8) then US009 (`Should`, 5, stretch)             | 13 / 11 — at grace, closed                                  |
| `SPRINT-06` | US010 (`Must`, 8), plus US009's reserved 5 SP carry if it slips | 8 / 11 — closed, holding a reservation; 13 / 11 if it lands |
| `SPRINT-07` | US012 (`Must`, 2) then US011 (`Should`, 8, stretch)             | 10 / 11 — closed                                            |
| `SPRINT-08` | US013 (`Must`, 3) then US014 (`Must`, 8)                        | 11 / 11 — at capacity, open                                 |

Each record owns its own row, and **every record carries the whole table**: a membership or a
capacity change is written into every copy in the same change. It is maintained by hand — no gate
reads it, and that cost is filed in `GAPS.md` (17/09/2026). Rule:
`project-management/docs/planning/SPRINTS.md`. Obligation:
`project-management/src/03-SPRINTS/CLAUDE.md`.

<!-- ONE ROW ADDED, 31/10/2026 at 03-sprint-planning: this record's own, on its opening with
     US013 (settled 31/10/2026, 03-sprint-planning grilling round 1 Q2). The other seven rows are
     copied from SPRINT-07.md's register as it stood at 39b9fcf and did not move; checked against
     each record's own capacity line as well as against the other copies, per
     project-management/src/03-SPRINTS/CLAUDE.md, and every row agrees with its source. The
     history of those rows is in the dated comments under the register in SPRINT-01 to SPRINT-07,
     and is not restated here. -->

<!-- ROW AMENDED, 01/11/2026 at 03-sprint-planning: US014 (`Must`, 8) admitted to `SPRINT-08`,
     cut 31/10/2026 from MAP-RULE-OWNERSHIP slice `S-07` — the admission CUT-PLAN.md P8 reserved.
     It stands the record at 11 / 11, the fill trigger (settled 01/11/2026, 03-sprint-planning
     grilling round 1 Q1). No other row moved; checked against each record's own capacity line as
     well as against the other copies, per project-management/src/03-SPRINTS/CLAUDE.md. -->

**Capacity: 11 / 11 — at capacity, the fill trigger, all committed (01/11/2026).** The record is
full: no further story is admitted, and grace is not taken. The `16-sprint-plans` pass and the
`17-story-plans` passes for US013 and US014 are **owed**, written once every member has cleared the
specify tier (`project-management/docs/planning/SPRINTS.md` -> _Capacity_): US013's one gate, 11,
is closed — its QA plan signed off 31/10/2026 (`c4a5245`), re-confirmed by <%DEVELOPER_NAME%> 01/11/2026; US014's gates 09, 10, 11 and 14 closed 01/11/2026, every plan signed off. The paragraph below is
the record of the opening position, kept as written.

**Opening position (31/10/2026). Capacity: 3 / 11 — inside capacity, all committed, and under capacity by 8 SP, called out rather
than padded.** The 8 SP is **spoken for** by P8's reservation above, as SPRINT-06's 3 SP was by
US009's reserved carry, and it is not padded with a story cut to fill it.
`project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_ owns both figures
as generation-time answers, `SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`; in this template repository
the table is unrendered and the 11 and 13 every record uses are the `copier.yml` defaults. <!-- doc-references: template-only -->
3 / 11 is not the fill trigger, so this admission owes no `16-sprint-plans` or `17-story-plans`
pass. If US014 is admitted at its priced 8 SP, the record lands on **11 / 11 — at capacity, the fill
trigger** — and owes its plan then, written once every member has cleared the specify tier
(`project-management/docs/planning/SPRINTS.md` -> _Capacity_).

**`Timeline: TBD`, so scope-against-duration is unmeasurable and is recorded as such.**
`project-management/workflows/03-sprint-planning/CHECKLIST.md` asks that "Scope is realistic for
the sprint duration"; with no dates that box has nothing to divide the points by, and **it is
marked unmeasurable rather than ticked**. No record in `project-management/src/03-SPRINTS/` has
ever carried a date, and this one follows SPRINT-07's reading of the same box. Per
`code/docs/GATE-REPORTING.md` a check that could not run is reported, never passed. It becomes
answerable the moment a timeline is set.

**CLOSED to admission from 01/11/2026** — the record is at 11 / 11 and P8's reservation is
discharged. The list below is the opening position's, kept as the record; its first branch is the
one taken.

**OPEN to admission, and what would change the position** (31/10/2026) — each <%DEVELOPER_NAME%>'s call at the
time, and not this record's to pre-empt:

- **US014 at its priced 8 SP** lands the record on 11 / 11, the fill trigger, which closes it on
  arithmetic and owes the plan. That is the admission P8 anticipates.
- **US014 re-priced at its own cut.** At 9 or 10 SP it stands the record at 12 or 13 / 11, in grace;
  SPRINT-04 and SPRINT-05 have taken grace, and `CADENCE.md` reads "a sprint that habitually runs to
  it means the capacity figure is wrong", so a third is the signal SPRINT-05's and SPRINT-07's Notes
  both name. Past 10 SP it is over the 13 SP ceiling and is refused on arithmetic before it is
  argued. The goal is worded to survive either reading (Q1).
- **Any other story** would spend the reservation P8 holds, and is refused for that reason unless P8
  is amended first, in `project-management/src/02-STORIES/CUT-PLAN.md`.

**SPRINT-07's US011 still has no receiving record, and nothing moves.** SPRINT-07's Definition of
Done carries a drop branch for its `Should` stretch and binds the reservation to be named "the
moment a receiving record is opened". This record is opened, and it is **not** that record: under
P8 it is full at 11 / 11 with US013 and US014, and US011's 8 SP on top is 19 / 11, past the 13 SP
grace ceiling. Placing a dropped US011 therefore stays owed to `03-sprint-planning`, as SPRINT-07
records, and this record names nothing for it. SPRINT-07 is annotated in this change to say this
record now exists.

---

## Acceptance Criteria

Two outcomes, one per member. US013's outcome: workflow 09 and the `code/src/logs/` pair carry no raw `docker`
call and no unmarked vendor literal; their vendor names render from the project's own answers; and
09 ends at the root cause, with a verification step that runs nothing it does not own. The four
documentation gates and the generated-project check in the QA flag run against it, each under the
regime the Verification Checks give it. The seven Gherkin scenarios are US013's own and are not
restated here (`project-management/src/02-STORIES/US013.md` -> Acceptance Criteria).

<!-- AMENDED 31/10/2026 after 11-qa-checks grilling round 3: "six" until then. Q14 added a seventh
     scenario to US013 — a dev fault rooted at Step 2 is routed to 10-debug. -->

<!-- AMENDED 01/11/2026 on US014's admission: the paragraph above opened "One outcome, the sole
     member's:" until then. -->

US014's outcome: in staging and production every log line is one valid JSON object with a fixed
field set and a `request_id`; dev logs wide and to a mounted host path; test stays console-only;
every handler in every environment carries the filter; and the documents describing the pipeline
describe this one. Its scenarios and per-discipline criteria — Backend, GDPR, Security, Logging and
QA — are its own and are not restated here (`project-management/src/02-STORIES/US014.md` ->
Acceptance Criteria).

### Backend Acceptance Criteria

<!-- Restored 01/11/2026 with the Backend flag going live on US014's admission, as rollups: the
     template's generic criteria name surfaces (transactions, IDOR, signals, Celery, audit writes)
     that neither member introduces, so each is stated against what this sprint does ship. -->

- [ ] US014's `apps/core/observability.py` is standard library only, typed throughout, and no
      source file exceeds 750 lines
- [ ] No service method, endpoint, signal, Celery task or audit write is introduced this sprint —
      the template's transaction, IDOR, idempotence and audit criteria have nothing to bind
- [ ] Every Backend criterion in `project-management/src/02-STORIES/US014.md` is met

### GDPR Acceptance Criteria

- [ ] No redaction is claimed anywhere; the minimisation claim — the staging/prod extras allowlist
      and the dropped exception message, `message` not scrubbed — is the only one written
- [ ] No PII field is introduced, so the template's encryption, HMAC, erasure and consent criteria
      have nothing to bind
- [ ] `09-GDPR/DATA-INVENTORY.md`:199 and :201 reconciled; every GDPR criterion in US014 met

### Security Acceptance Criteria

- [ ] [A09:2025] Every log entry in every environment carries `request_id`, including a
      `django.request` line for a returned error response
- [ ] No exception message and no non-allowlisted extra reaches staging or production stdout
- [ ] No endpoint, rate limit or rendered input is introduced; no secrets, debug flags or
      hardcoded credentials; every Security criterion in US014 met

### Logging Acceptance Criteria

<!-- US014's own Logging flag is the only one that is not N/A; US013's reads N/A with its reason. -->

- [ ] Every handler in every environment's `LOGGING` carries the `request_id` filter, and staging
      and production write one JSON object per line to stdout
- [ ] Every LogQL selector in the 09 workflow and `OBSERVABILITY.md` selects
      `{service_name="django"}`, and `EDGE-REQUIREMENTS.md` states the relabel
- [ ] No raw PII appears in `code/src/logs/django.log` after exercising the dev stack; every
      Logging criterion in US014 met

### QA Acceptance Criteria — Automated

- [ ] US014's unit suite, `apps/core/tests/unit/test_observability.py`, passes under
      `tests/all.sh --coverage`, with `apps/core` at or above the 75 % line and branch floor

### QA Acceptance Criteria — Manual

<!-- The automated QA sections were removed at opening, when the sole member shipped
     documentation and no code path; US014's admission (01/11/2026) brings a unit type, so the
     automated criterion above is restored, as are the Backend, GDPR, Security and Logging
     sections. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/MANUAL/US013-MANUAL-TESTING.md` carries a tester sign-off
      block — a path that does not exist on 31/10/2026; `17-story-plans` writes it
- [ ] `project-management/src/18-TESTS/MANUAL/US014-MANUAL-TESTING.md` carries a tester sign-off
      block — likewise absent on 01/11/2026; `17-story-plans` writes it
- [x] **No `[OPEN]` acceptance-criteria gap remains** in US014's QA plan,
      `project-management/src/11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — eighteen
      gaps, all resolved; signed off 01/11/2026 by <%DEVELOPER_NAME%>, gate 11 closed
- [x] **No `[OPEN]` acceptance-criteria gap remains** in US013's QA plan,
      `project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`, written at
      `11-qa-checks` on 31/10/2026 — AC-GAP-1 to -5 resolved into the story the same day (AC-GAP-5
      in 11-qa-checks grilling round 2), and AC-GAP-6 to -10, raised by the `qa-tester` run of
      31/10/2026, resolved into it in 11-qa-checks grilling round 3 the same day; and AC-GAP-11 and
      -12, raised by the scoped `qa-tester` re-check of 31/10/2026, resolved into it in
      11-qa-checks grilling round 4 the same day. **No gap is `[OPEN]`**; the plan's sign-off is
      <%DEVELOPER_NAME%>'s

<!-- AMENDED 31/10/2026 at 11-qa-checks: the criterion above read "in US013's QA plan, which
     `11-qa-checks` writes under `project-management/src/11-QA/PLANNING/` and which does not exist
     on 31/10/2026" until the plan was written the same day. -->

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file —
`project-management/src/02-STORIES/US013.md` -> Tasks carries seventeen documentation tasks and
`project-management/src/02-STORIES/US014.md` -> Tasks its Backend, GDPR, Security, Logging,
Documentation and QA tasks; neither is restated here.

<!-- AMENDED 31/10/2026 at 11-qa-checks: "twelve" until then. The gate added two tasks to the story
     — the browser-SDK rewording (11-qa-checks grilling round 1, Q7) and LOG_AGGREGATOR's help text
     (Q9) — and amended the tokenisation task's counts and exemptions (Q7, Q8). "Fourteen" became
     "fifteen" the same day, when an independent review of the 11-qa pass gave the Q8 S-07 record its
     own task (a dated note on the S-07 row of MAP-RULE-OWNERSHIP.md). Still fifteen after
     11-qa-checks grilling round 2 (31/10/2026, Q10, Q11): the STEPS.md:176 rewording was folded into
     the tokenise task, whose LOG_AGGREGATOR count moved from 11 to 12, and the S-07 note task now
     names its four literal sites. "Fifteen" became "sixteen" after the 11-qa-checks qa-tester run
     (31/10/2026), which added the CHECKLIST.md:43 references task (item 11); its other folded
     findings amended existing tasks. "Sixteen" became "seventeen" after 11-qa-checks grilling
     round 3 (31/10/2026), which added the CHECKLIST.md:38 rewording task (Q15) and amended the
     marker (Q12), 10-debug re-home (Q14) and LOG_AGGREGATOR help-text (Q16) tasks. Still
     seventeen after 11-qa-checks grilling round 4 (31/10/2026, Q17, Q18): the 05-ANSWERS.md:124
     mirror and the restated reason amended the LOG_AGGREGATOR help-text task; none was added. -->

<!-- AMENDED 31/10/2026 after 11-qa-checks grilling round 3 (Q13): the generated-project QA task
     below read "run on every render path the template offers and on one extra answer set …, the
     vendor-literal search case-insensitive" until then. -->

### Backend Tasks

- [ ] US014 — `apps/core/observability.py`, the four environment `LOGGING` dicts with the filter on
      every handler, `base.py`'s block deleted, the dated exception in `config/settings/CLAUDE.md`,
      and the dev logs mount

### GDPR Tasks

- [ ] US014 — `09-gdpr-compliance` run and closed; the redaction forward reference, the
      `DJANGO-LOGGING.md`:47 identifier and the `DATA-INVENTORY.md` reconciliation

### Security Tasks

- [ ] US014 — `10-security-checks` run and closed, ruling on request paths in `django.request`
      messages; the two-stream split written into `MONITORING-AND-INCIDENT.md`

### Logging Tasks

- [ ] US014 — `14-logging-checks` run and closed, confirming the collector relabel; the selector
      rewrites and the `EDGE-REQUIREMENTS.md` section

<!-- Each gate above, and 11-qa-checks, recomputes the FLAGS union when it closes, as US013's gate
     11 did. -->

### QA Tasks — Automated

- [ ] US014 — `apps/core/tests/unit/test_observability.py`, marked `story("US014")`

### QA Tasks — Manual

- [ ] US013 — the four documentation gates run, and their output recorded in its manual testing
      guide, `doc-references.sh` read as a diff against the baseline captured before the first edit
- [ ] US013 — the generated-project check: on the two CI default render paths, only that every
      token renders and every token name is a defined question; on one extra `sed` render with
      `ERROR_TRACKING=Bugsink` and `LOG_AGGREGATOR=Fluent Bit`, and there only, the case-insensitive
      unmarked-vendor-literal search; the paths it ran and their run IDs recorded
- [ ] US013 — each routed command typed as written against a running dev stack, its output recorded
- [ ] US013 — the human read-across: the truncate stated once between 09 Step 2 and
      `code/src/logs/CONTEXT.md`, and no sentence in scope reading wrongly with a substituted name
- [ ] US013 — a tester other than the author has signed the walk-through off
- [ ] US014 — every row of its manual testing guide walked and marked: the host-mounted log file,
      the documented host-path commands, a staging-settings line through a JSON parser, the doc gates
- [ ] US014 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- At opening the code-path checks were marked N/A because the sole member shipped
     documentation only. US014's admission (01/11/2026) makes the ones it touches live; the rest
     keep N/A with a reason restated against both members, because per code/docs/GATE-REPORTING.md
     a skip is never reported as a pass (03-sprint-planning grilling round 1 Q4). -->

- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file US013 or US014 edits crosses 270
      counted lines without a dated allowance
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — every pair US013 or US014 edits keeps its
      four H2s
- [ ] `bash code/src/scripts/audits/doc-references.sh` — **read as a diff against the baseline
      captured before the first edit**, per
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
      unless US004 has landed and the gate is green; never reported as a bare pass while the
      baseline stands
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **regression guard only**: it reads fenced
      code, so the prose half of US013 is the read-across, never this gate
- [ ] The generated-project check, with the render paths it ran recorded
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — the Markdown leg for both members and the ruff leg
      for US014's Python
- [ ] `bash code/src/scripts/syntax/check.sh` passes — US014's Python (`observability.py`, the
      settings modules, the test)
- [ ] `bash code/src/scripts/audits/negative-space.sh` passes — `RequestIDMiddleware` stays listed
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, neither member touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` passes — US014's unit suite, `apps/core` at
      or above the floor
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, neither member adds a template
      or component
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — US014's
- [ ] Every story's logging plan satisfied and the exclusion check run — US014's
- [ ] All security acceptance criteria signed off — US014's
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, neither member renders an interactive surface

---

## Definition of Done

- [ ] All stories in the Story Summary are individually marked **Completed** (their own DoD
      complete) — US013 and US014, both `Must`
- [ ] **Admitting a story recomputes this record in the same change** — the FLAGS union, the Story
      Summary, the capacity line, the Notes' admission position, the goal if its members no longer
      carry it, and the backlog register in every copy
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in any member's QA plan
- [ ] The sprint plan (`16-sprint-plans`) and both story plans (`17-story-plans`) written — owed
      from 01/11/2026, when this record reached the fill trigger
- [ ] The `DEFERRED.md` entry for the out-of-scope vendor literals written, and items 1-2 of
      `GAPS.md`'s 17/09/2026 entry closed, both by `22-implementation-documentation`, as US013's own
      Definition of Done provides
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — US014's GDPR flag is live
- [ ] Retrospective notes captured (optional — link or inline)
