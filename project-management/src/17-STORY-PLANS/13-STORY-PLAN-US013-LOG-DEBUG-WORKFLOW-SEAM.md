# STORY-PLAN-US013 — The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause

| Field  | Value                                                                                                                                  |
| ------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| Date   | 01/11/2026                                                                                                                             |
| Branch | `us013/log-debug-workflow-seam`                                                                                                        |
| Sprint | SPRINT-08 · Wave 1 · build order 1                                                                                                     |
| Author | <%ORG_NAME%>                                                                                                                           |
| Board  | No status of its own — `STORY-PLANS-BOARD.md` shows this plan under its `US###`'s `**Status:**`; it moves to `archive/` with the story |

<!-- BORN WITH ITS PREFIX, 01/11/2026. The number "13-" was reserved for this story on 31/10/2026
     and is recorded in ../02-STORIES/US013.md -> Dependencies (the sprint-membership bullet, "a
     reserved `13-`, a number and not a plan until `17-story-plans` writes it"), in
     ../03-SPRINTS/SPRINT-08.md -> Dependencies, and, until 17-story-plans Step 10 repoints it, as a
     no-file row in ../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md -> Story Plans — the code master. The
     prefix is the story's position in the settled build order across the WHOLE backlog — US007,
     US001, US002, US003, US004, US005, US006, US008, US009, US010, US012, US011, US013, US014 — not
     its sprint and not a per-sprint counter. It is RENUMBERED whenever build order changes, the
     OPPOSITE of the sibling rule for sprint plans; ./CLAUDE.md owns the rule.

     Derived 01/11/2026 at HEAD 5234a27. The sprint plans in their own exec-order sequence are 01- to
     08-, each name agreeing with its sprint number, and neither archive/ holds a plan. Plan 08 builds
     US013 then US014 (../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md -> Build order). The tracked run is
     contiguous 00- to 12-, so this plan is the thirteenth file; US014 holds 14-, which this plan
     leaves alone. The descriptor LOG-DEBUG-WORKFLOW-SEAM matches the story's QA plan, as every
     existing pair does. Wave 1 is the story's place in its map's cutting order — slice S-01 of
     ../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md, order 1 of the RULE-OWNERSHIP section of
     ../02-STORIES/CUT-PLAN.md — and does not move with the sprint; build order 1 is first of {US013,
     US014}. -->

<!-- STEP 1 DREW ITS ROUND FROM THE RECORDED ANSWERS (.claude/skills/grilling/SKILL.md -> A decision
     already recorded is a fact). The story's cutting interview (grilling round 1, 31/10/2026, Q1 to
     Q10), the four 11-qa-checks rounds of 31/10/2026 (Q1 to Q18, all twelve AC-GAPs resolved and the
     QA plan Signed off), the 15-decisions outcome (no ADR, 31/10/2026) and 16-sprint-plans (plan 08,
     01/11/2026) settled the scope, the lane, the method and the order; this plan carries them in and
     re-derives none.

     ONE QUESTION WAS LEFT, and it went to <%DEVELOPER_NAME%> rather than being guessed:
     17-story-plans grilling round 1, 01/11/2026, Q1 — how EC-01's Sentry reading is produced, since
     the records name only one non-default answer set (Bugsink / Fluent Bit) and ES-04 speaks of
     "the three renders". Answered option 1: a second /tmp sed render, scoped to that one guide row,
     of 09 STEPS.md only, with ERROR_TRACKING=Sentry and every other answer at its default, recorded
     as a row check and NOT as part of the generated-project check — so 11-qa round 1 Q3 ("one extra
     answer set") and round 3 Q13 ("the grep runs on the sed render only") are untouched. Key
     Decision 9 and the guide's READ-03 carry it.

     ROUND 2 (17-story-plans grilling round 2, answered by <%DEVELOPER_NAME%> 01/11/2026) settled
     three more, from the Step 9 review:
       - Q1 = 1: 09 STEPS.md:42 "If the issue only occurs in staging/prod, skip to Step 3" does NOT
         breach the AC at ../02-STORIES/US013.md:293 — its Given is a dev-stack fault, and the skip
         fires only for a staging/prod-only fault. STEPS.md:42 is not edited; the guide's WALK-06
         records the reading as decided. Key Decision 12.
       - Q2 = 1: a manual row that cannot be run is Result Fail, Notes "Unmeasured — <reason>", a
         Failures row routed per code/docs/GATE-REPORTING.md, and the sign-off Outcome Blocked —
         never Pass, never blank. Key Decision 13; the guide's Unmeasured rows bullet.
       - Q3 = 2: US013 and US008 are HARD START GATES for US014 — none of US014's work starts until
         both have merged, and its branch is cut from main after both land. That supersedes, for
         US014's start, the merge-order-only reading in ../03-SPRINTS/SPRINT-08.md -> Dependencies
         and ../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md -> Build order. Key Decision 14; Dependencies.
       Q4 (slot E / P5R) and Q5 (hosts-story-add.sh) concern US014's and US008's plans only.

     FOUR FACTS ARE RECORDED, NOT ASKED (each one line under Measured divergences below):
       - how-to/src/TEMPLATE-TOKENS.md moved 4 lines in facc337 (31/10/2026, after the QA sign-off):
         the reach paragraph the story cites at :134-137 is now :138-141 and the LOG_AGGREGATOR row
         the QA plan cites at :121 is now :125, text unchanged. The inventory task re-measures it.
       - The S-01 Acceptance cell at ../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md:1080 predates the
         11-qa rounds and is stale; it is routed to 01-feature-map, not edited here.
       - ../02-STORIES/US013.md:260 and :374 (also the FLAGS comment at :80) say a marker already
         exists ("existing reference-stack marker", "their file's existing marker"); no marker exists
         at HEAD. It is the marker this story writes — a wording slip only. (The settled line cited
         :272, which says "a reference-stack marker introduces"; the cite is corrected here.)
       - "Every render path" here means US013's own definition (QA plan Q2, Q13, EC-04: the two CI
         default paths plus EC-04's recorded reason), not US010's 72-case matrix. -->

**Implements no ADR, and the absence is the story's own reading.** `../02-STORIES/US013.md` →
_Decisions_ records none, confirmed at `15-decisions` on 31/10/2026: every decision is a settled map
node or reversible documentation. Its citation criterion is read under
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (`Accepted`,
measured 01/11/2026): while `doc-references.sh` is red, the criterion is a baseline captured before
the first edit and read as a diff, the baseline kept in the manual testing guide. `US004` reads
`Open`, so the regime applies.

> **Source authority.** Where this plan and `../02-STORIES/US013.md` differ on **what must be true**,
> the story wins. Where they differ on **how a scenario is tested** — counts, method, render paths —
> `../11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` wins. Sprint facts are
> `../03-SPRINTS/SPRINT-08.md`'s. How any gate's result is reported is `code/docs/GATE-REPORTING.md`'s.
> This plan records the engineering route, not the requirement.

Three template sections are dropped: the **Table of Contents** (no sibling plan carries one, and this
is a single-lane documentation plan), the **As-Built Summary** (this plan is forward-looking) and
**Pre-existing bug fixes** (every defect fixed — the `backend` service name, the
`/workspace/src/logs` path, the bare `up` — is itself an acceptance criterion, not an en-route fix).
The four per-layer sections are dropped under _Approach_, each with its reason.

---

## Problem Statement

**Why this story exists.** `../02-STORIES/US013.md` — a developer in a generated project debugging
an incident follows `code/workflows/09-debugging-with-logs/`, and the procedure fails them in three
ways: six of its seven dev commands name a Compose service, `backend`, that does not exist (the
service is `django`) and the seventh is a bare `up`; it names GlitchTip and Loki whatever the
project answered for `ERROR_TRACKING` and `LOG_AGGREGATOR`; and it goes on to write a regression
test and a fix that `code/workflows/10-debug/` owns. It is slice `S-01` of
`../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` (nodes N-001, N-012, N-013, settled 27/08/2026), and the
head of five slices that edit the 09 folder.

**Current state / gap** (measured at cutting, 31/10/2026, re-checked 01/11/2026). Ten raw `docker`
calls — seven in 09 `STEPS.md` Steps 1-2, two staging calls in Step 7, and the truncate in
`code/src/logs/CONTEXT.md`. Thirty-five GlitchTip / Loki sites across the 09 folder and the
`code/src/logs/` pair, spelt `Glitchtip` at 15 of 16 sites in the folder. Step 2 reads
`/workspace/src/logs/django.log`, which is not the in-container path
(`/workspace/code/src/logs/django.log`). Step 6 writes a regression test; six `CHECKLIST.md` boxes
claim a fix. `copier.yml`:470-483 and `how-to/src/TEMPLATE-TOKENS.md` claim two provider tokens
reach `code/docs/`, where five do — so the enumeration is deleted rather than corrected (cutting
round, Q3, Q6).

**What this story delivers.**

- Every command in scope runs through `code/src/scripts/development/{server,logs,shell}.sh`; the
  `django.log` truncate lives once, in `code/src/logs/CONTEXT.md` → _Log rotation_.
- 18 error-tracker sites render from `<%ERROR_TRACKING%>` and 12 log-aggregator sites from
  `<%LOG_AGGREGATOR%>`; four LogQL-bound `Loki` sites stay literal and six reference-stack markers
  introduce every Grafana, Alloy and Prometheus site.
- 09 stops at the root cause: the `10-debug` handoff rides the preamble, Step 6 and six fix boxes go,
  the verification step runs nothing it does not own.
- `copier.yml`'s comment and `TEMPLATE-TOKENS.md` state no reach; `LOG_AGGREGATOR`'s help gains the
  bare-name sentence and loses `Alloy`, mirrored in `how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md`.

**Out of scope** — the story's own list, mirrored under _Deferred Items_: ~58 vendor literals in 21
other files; `code/workflows/CONTEXT.md` (`S-02`); the host-path reads, the 09 `CONTEXT.md`:34 tick
and the LogQL selectors (`S-07`, US014); `CHECKLIST.md`:39, :56 and any dev-path handoff box
(`S-04`); the dashboards cell; the two "proven alternates" lists; `GAPS.md` and `DEFERRED.md`
themselves.

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                                                                                 |
| ----------------------------- | --------- | --------------------------------------------------------------------------------------------------------------------- |
| Database / models / migration | —         | `DB: N/A`                                                                                                             |
| Service layer                 | —         | `Backend: N/A` — no Python                                                                                            |
| Django Ninja API              | —         | `API: N/A`                                                                                                            |
| Frontend (templates)          | —         | `Frontend: N/A`                                                                                                       |
| Infrastructure / DevOps       | ✓ (text)  | `copier.yml` comment and one help text only — no question, default, task or `_exclude` entry changes                  |
| Documentation                 | ✓         | Six Markdown files (the 09 four, the `code/src/logs/` pair), `TEMPLATE-TOKENS.md`, `05-ANSWERS.md`, one map S-07 note |
| GDPR / PII                    | —         | `GDPR: N/A` — the personal-data path left this slice for `S-07` and `S-08` (Q14, 27/08/2026)                          |

---

## Reference Documents (code/docs gate map)

| Concern (when it gates)                         | Authoritative doc(s)                                                                                                                                          | Applies? |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| URL / route / admin path                        | `code/docs/URL-STRATEGY.md`                                                                                                                                   | —        |
| Coding principles                               | `code/docs/CODING-PRINCIPLES.md`                                                                                                                              | —        |
| Architecture — provider neutrality              | `code/docs/architecture/PROVIDER-NEUTRALITY.md` exception 2 (bare name vs phrase); `how-to/src/PLATFORM-PROVIDERS.md` (the register every marker cites)       | ✓        |
| Copier tokens                                   | `how-to/src/TEMPLATE-TOKENS.md` (shape column, the one classification `copier.yml` cites); `how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md`                          | ✓        |
| Data structures / API / Encryption / RLS        | `DATA-STRUCTURES.md` · `API-DESIGN.md` · `ENCRYPTION-GUIDE.md` · `RLS-GUIDE.md`                                                                               | —        |
| Security                                        | `code/docs/SECURITY.md` — no surface; the walk follows `.claude/CLAUDE.md` Sections 0 and 6                                                                   | — (walk) |
| Rendering / Responsive / Accessibility / Tokens | `RENDERING.md` · `RESPONSIVE-DESIGN.md` · `ACCESSIBILITY.md` · `DESIGN-TOKENS.md`                                                                             | —        |
| Performance / Scale                             | `PERFORMANCE.md` · `architecture/CORE-AND-SCALING.md`                                                                                                         | —        |
| Logging / observability                         | `code/docs/logging/OBSERVABILITY.md`:109 — the sentence each marker opens as ("The reference deployment runs …"); the story documents logs and adds no logger | ✓ (doc)  |
| Deploy precondition                             | `how-to/docs/FEATURE-DEPLOY.md` — cited by the verification step                                                                                              | ✓        |
| Instructional length and pairing                | `code/docs/DOCUMENTATION-LENGTH.md` (270 ratchet) · `code/docs/DOCUMENTATION-PAIRING.md` (four H2s per pair)                                                  | ✓        |
| Shipped-file claims                             | `code/docs/FORWARD-VOICE.md` — the six files and `copier.yml` ship                                                                                            | ✓        |
| Gate reporting                                  | `code/docs/GATE-REPORTING.md` — every `N/A`, every unmeasured row (`Fail`, `Unmeasured — <reason>`; Key Decision 13), the baseline regime                     | ✓        |
| Graph refresh                                   | `code/docs/CODE-REVIEW-GRAPH.md` — staged first, then refreshed                                                                                               | ✓        |
| Testing                                         | `code/docs/TESTING.md` — no code path, so no floor binds                                                                                                      | —        |
| Cloudinary                                      | `code/docs/cloudinary/CONTEXT.md`                                                                                                                             | —        |

> Cross-layer compliance guides: `project-management/docs/QA-GUIDE.md` and
> `project-management/docs/GIT-GUIDE.md` apply; the security, GDPR and SEO guides do not, each flag
> reading `N/A`.

---

## Architecture Decision

None of its own. The seam this story applies is fixed by prior decisions: `ERROR_TRACKING` is wired
through the Sentry SDK wire protocol (`copier.yml` `ERROR_TRACKING` help), so the protocol name stays
literal and only the backend name is tokenised (11-qa round 1, Q7); `LOG_AGGREGATOR` and
`ERROR_TRACKING` are bare-name, prose-shaped tokens (`TEMPLATE-TOKENS.md`, PROVIDER-NEUTRALITY
exception 2). What this story is free to choose — and chose in the 31/10/2026 rounds — is where each
site is tokenised, held or reworded, and where the markers sit. No choice passes the ADR bar.

---

## Approach

### Not applicable — Database, Service Layer, Django Ninja API, Frontend

- **Database** — no model, field or migration (`DB: N/A`).
- **Service layer** — no Python (`Backend: N/A`).
- **Django Ninja API** — no router, endpoint or Schema (`API: N/A`).
- **Frontend** — no template, component or CSS (`Frontend: N/A`).

### Phase plan

Two orderings are forced by the tasks: the inventory and baselines come before any edit
(`US013.md` task 1; QA plan Section 6), and the handoff is re-homed before Step 6 is deleted
(task 9). Everything else follows the story's task order. Track every site by its anchor phrase,
never by an inherited line number — every edit moves the lines below it.

- **P0 — Start state, baselines, inventory (before the first edit).** First the build-start
  transition (_Status Propagation_ below), then the captures. Record in the guide's
  _Recorded during the build_: the `doc-references.sh` whole-tree baseline finding by finding, with
  `HEAD` and the git-index state (ADR-US003 — give it the time it needs; a missed capture is recorded
  as missed, never reconstructed); the `docs-length.sh`, `docs-pairing.sh` and `doctrine-drift.sh`
  readings; and the inventory — the ten raw calls, the 35 GlitchTip / Loki sites each with anchor
  phrase, line and disposition (18 + 12 tokenised, 4 held, 1 reworded), every Grafana / Alloy /
  Prometheus site, and the `TEMPLATE-TOKENS.md` reach paragraph's and `LOG_AGGREGATOR` row's current
  lines. Exit: every slot filled or recorded as missed — each guide row reading a missed capture is
  then `Fail`, `Unmeasured — <capture> missed`, and the sign-off `Blocked` (Key Decision 13).
- **P1 — The script seam.** 09 Step 1 to `server.sh up` and `logs.sh --service django --follow`;
  Step 2 to one `shell.sh` session with every read typed inside it at
  `/workspace/code/src/logs/django.log`, and the truncate replaced by a pointer; in the logs pair the
  truncate becomes the one copy, a step typed inside a `shell.sh` session, and `logs.sh --service
backend` names `django`. Exit: no `docker` call left in 09 Steps 1-2 or the `code/src/logs/` pair,
  and no `backend` service argument (the two Step 7 staging calls go at P4).
- **P2 — Tokens, the browser-SDK sentence, markers, the S-07 note.** Tokenise the 30 sites; reword
  `STEPS.md` Step 4's browser-errors sentence whole and `:176` vendor-free; drop 09 `CLAUDE.md`:12's
  "/Alloy"; write the six markers at their anchors (each naming `Loki` exactly once — re-check 6);
  add the dated note on the `S-07` row of `MAP-RULE-OWNERSHIP.md`. Exit: the source token list is
  clean against `copier.yml`'s questions (ES-09).
- **P3 — The fix cut.** Re-home the `10-debug` handoff into the preamble's stop instruction and the
  `21-BUGS/` line to the end of Step 5; reword 09 `CONTEXT.md` Outputs and `CLAUDE.md` Definition of
  done; then delete Step 6 and its Key references row, renumber 7 and 8 to 6 and 7, delete the six
  fix boxes and their headings, reword `CHECKLIST.md`:38 and drop `:43`'s "External — Testing".
- **P4 — The verification step (was 7).** Delete the staging pull and up; state the deploy as a
  precondition owned by `<%DEPLOY_REPO%>`, citing `how-to/docs/FEATURE-DEPLOY.md`; reword the error-
  rate read vendor-free; one window, 30 minutes, in the step and its box. Exit: no fenced `docker`
  call in the six files (SEAM-01, HP-01).
- **P5 — `copier.yml` and the registers.** Replace the two comment paragraphs at `:470-483` with
  the story's post-edit text (`:483`, the PostgreSQL line, stays); add the bare-name sentence to `LOG_AGGREGATOR`'s help and
  drop `Alloy` from its list and from `05-ANSWERS.md`'s copy; delete the `TEMPLATE-TOKENS.md` reach
  paragraph, keeping the shape rule. The template-docs guard stands down in syntek-base
  (`.claude/hooks/CONTEXT.md`:91-93).
- **P6 — Close.** Lint, the four gates against P0, push and record the one CI `[3/4]` run (its ID, job URL, commit, and the two `INCLUDE_MOBILE`
  log lines), the
  `sed` renders, the live walk on this host's dev stack, the read-across — all walked from the guide
  at `22` by a tester other than the author.

---

## Key Decisions

| #   | Decision                                   | Chosen                                                                                                                                                           | Rejected / Alternative                                                                  | Reason                                                                                                                                                                  |
| --- | ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Lane                                       | Documentation and `copier.yml` comment/help text only; no code lane; Backend, API, Frontend `N/A`                                                                | Entering `19-backend-code` as the US009 / US012 bash lanes did                          | No executable surface (`US013.md` Story Points comment); the shape of `./02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`; sprint plan 08 leaves the lane to this plan |
| 2   | ADR                                        | None; ADR-US003's baseline-diff regime applied to `doc-references.sh`                                                                                            | Raising an ADR; reading the gate as a bare pass                                         | `15-decisions`, 31/10/2026 (`US013.md` → Decisions); `US004` still `Open`                                                                                               |
| 3   | The enumeration of token reach             | Deleted from `copier.yml` and `TEMPLATE-TOKENS.md`; `copier.yml` cites the register                                                                              | Correcting it to five tokens                                                            | A list of reach drifts the day a guide gains a token (cutting round, Q3, Q6)                                                                                            |
| 4   | Which sites are tokenised                  | 18 `<%ERROR_TRACKING%>`, 12 `<%LOG_AGGREGATOR%>`; Sentry SDK protocol name literal; `:94`, `:98`, 09 `CONTEXT.md`:37, `CLAUDE.md`:28 held; `:176` reworded       | Tokenising every `Loki` (a substituted name above a LogQL query it cannot run)          | 11-qa round 1, Q7, Q8; round 2, Q10, Q11                                                                                                                                |
| 5   | What a reference-stack marker names        | The reference stack literally — Grafana Alloy shipping to Loki, LogQL in Grafana, Prometheus — `Loki` once, citing `PLATFORM-PROVIDERS.md`; counts by position   | No aggregator; the `OBSERVABILITY.md`:109 token form                                    | Only a marker naming Loki explains the held sites; positional counts keep 12 exact (11-qa round 3, Q12)                                                                 |
| 6   | What each render path checks               | CI's two default paths: tokens render; the case-insensitive literal grep on the Bugsink / Fluent Bit `sed` render only                                           | The grep on every path; a source grep as well                                           | On a default path a token renders byte-identical to a literal (11-qa round 1, Q1-Q3, Q6; round 3, Q13)                                                                  |
| 7   | Where the `10-debug` handoff lives         | The 09 `STEPS.md` preamble's stop instruction; the `21-BUGS/` line at the end of Step 5                                                                          | End of Step 5; a closing paragraph                                                      | The stop instruction is the one line every path obeys (11-qa round 3, Q14)                                                                                              |
| 8   | `CHECKLIST.md` boxes; `Alloy` as an answer | Reword `:38` only (`:39`, `:56` to `S-04`); drop `Alloy` from the help list and its `05-ANSWERS.md` copy                                                         | Repairing all three boxes; dropping `Alloy` from every alternates list                  | `:38` breaks this story's own Then (round 3, Q15); `Alloy` is the reference shipper, so it renders "ships to Alloy" (round 3, Q16; round 4, Q17, Q18)                   |
| 9   | How EC-01's Sentry reading is produced     | A second `/tmp` `sed` render of 09 `STEPS.md` only, `ERROR_TRACKING=Sentry`, other answers at default, recorded as that guide row's check                        | Reading the source sentence and substituting by eye; folding it into the Bugsink render | Only option that exercises the Sentry case; scoped to one row so Q3 and Q13 stand (17-story-plans grilling round 1, 01/11/2026, Q1, option 1)                           |
| 10  | Walk and sign-off                          | A live walk on this host's dev stack, the in-container truncate included; signed by <%DEVELOPER_NAME%>; a fresh `general-purpose` agent may walk mechanical rows | A text-only check of the commands; the author signing                                   | Posture `development`, the dev log disposable (11-qa round 1, Q4, Q5)                                                                                                   |
| 11  | "Every render path"                        | US013's own definition — the two CI default paths plus EC-04's recorded reason                                                                                   | US010's 72-case matrix                                                                  | The six files carry no Jinja block and no `_exclude` entry, so every flag combination renders them alike (QA plan Q2, Q13, EC-04, Section 8)                            |
| 12  | 09 `STEPS.md`:42's staging/prod skip       | Not a breach of the dev-fault AC (`US013.md`:293); `STEPS.md`:42 unedited; WALK-06 records the reading as decided                                                | Editing `:42`; leaving the reading to the walker                                        | The AC's Given is a dev-stack fault; the skip fires only for a staging/prod-only fault (17-story-plans grilling round 2, 01/11/2026, Q1)                                |
| 13  | A manual row that cannot be run            | `Result` `Fail`, `Notes` `Unmeasured — <reason>`, a _Failures_ row per `code/docs/GATE-REPORTING.md`; sign-off _Outcome_ `Blocked`                               | `Pass`; a blank `Result`                                                                | "Could not look" is never "looked, and it was clean" (17-story-plans grilling round 2, 01/11/2026, Q2)                                                                  |
| 14  | US013's hold on US014                      | A **hard start gate**: US014 starts only once US013 and US008 have merged, its branch cut from `main` after both                                                 | Merge order only, US014's P0-P4 startable once its branch exists (the draft's option a) | Supersedes, for US014's start, `SPRINT-08.md` → Dependencies and plan 08 → _Build order_ (17-story-plans grilling round 2, 01/11/2026, Q3)                              |

---

## Dependencies

| Story / Artefact                       | Model / Feature                                   | Required for                                           | Current state      |
| -------------------------------------- | ------------------------------------------------- | ------------------------------------------------------ | ------------------ |
| `MAP-RULE-OWNERSHIP.md` S-01           | Settled nodes N-001, N-012, N-013; empty frontier | The story's scope                                      | Settled 27/08/2026 |
| US004                                  | `doc-references.sh` git-index read                | Nothing — the baseline regime applies while it is open | `Open`             |
| US014 (`S-07`)                         | Edits 09 Step 4, 09 `CONTEXT.md`, the logs pair   | Nothing here — US013 is US014's **hard start gate**    | `Open`             |
| US017 (`S-03`), US020 (`S-04`), `S-08` | Edit the 09 folder                                | Merge after US013 (provisional numbers)                | Not cut / `Held`   |
| `pm/story-creation` → `main`           | Every planning artefact this story rests on       | Cutting `us013/` from `main`                           | Unmerged           |

**Blocked by:** none. The map frontier is empty, no open story edits the 09 folder or the
`code/src/logs/` pair (`US013.md` → Dependencies), and the citation regime sequences nothing.
**Blocks:** `S-07` (US014) by a **hard start gate** — US014's work, P0 and its before-first-edit
baselines included, does not start until US013 **and** US008 have merged, and its branch is cut
from `main` after both land; at `17-story-plans` Step 10 US014 moves `Open` → `Blocked`
(`completion`'s call) and to `Pending` once both have merged (17-story-plans grilling round 2,
01/11/2026, Q3). **This supersedes, for US014's start, the merge-order-only reading** in
`../03-SPRINTS/SPRINT-08.md` → Dependencies (`:154`) and `../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md`
→ _Build order_. `S-03`, `S-04`, `S-08` stay merge order only, never an edge. After US013 merges,
the Row D marker counts in `CUT-PLAN.md` move; `S-03` and `S-05` re-measure.
**Can be done now:** nothing in a worktree until `pm/story-creation` merges to `main`; then
`us013/log-debug-workflow-seam` is cut from `main` and the whole story is startable at P0, ahead of
US014. At `17-story-plans` Step 10 `completion` moves the story `Open` → `Pending` — not `Blocked`,
because no blocking dependency is open.

> No cross-cutting `PLAN-<DESCRIPTOR>.md` exists for this sprint; the serialisation is plan 08's
> _Build order_.

---

## GDPR

**N/A** — no personal data is touched (`GDPR: N/A`). The one carried constraint is existing doctrine:
09 `CLAUDE.md` forbids pasting secrets, tokens or PII from logs into commits, bug reports or the
workflow files, and the live walk's recorded output is trimmed to what proves the command ran (QA
plan Section 5).

## Security

**N/A** — no authentication, permission, endpoint or personal-data path; no state-changing endpoint,
so no A01 or IDOR row (`Security: N/A`). Carried walk constraints: posture `development` (`.claude/CLAUDE.md`
Section 0), so the in-container truncate of a disposable dev log is lawful; every command a project
script (Section 6) — the only raw tools are the read-only ones under _Quality Gates_.

## Logging & Observability

**N/A** — a document about logs: no logger, event, field, level or retention is added or changed
(`Logging: N/A`; QA plan Section 8).

## Performance, Rendering, Responsive & Accessibility

**N/A** — no query, page, layout or interactive component; the output is Markdown read in an editor
(QA plan Sections 3-4; `US013.md` Definition of Done, WCAG row).

---

## Implementation Workflows & Standards

### PM workflow chain (in order)

`02-story-creation` ✅ → `03-sprint-planning` ✅ → `11-qa-checks` ✅ (`Signed off` 31/10/2026) →
`15-decisions` ✅ (no ADR) → `16-sprint-plans` ✅ (`../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md`,
01/11/2026) → `17-story-plans` **(this plan and its guide)** → the Markdown build lane (P0-P6) →
`22-implementation-documentation` → `23-pr-and-review` → `24-release` when a version is cut.

**No code lane.** `19-backend-code`, `20-api-code` and `21-frontend-code` read `N/A`; `04` to `10`,
`12`, `13` and `14` did not run, each flag reading `N/A`.

### Code workflows invoked

`code/workflows/01-implement-story/` for its build-start prerequisite alone (`Pending` →
`In Progress`, `STEPS.md`:31), code phases `N/A`. `07-review` gates the PR content. No stack skill
applies — the diff is Markdown and YAML comments.

### Standards gates

| Gate                                         | Applies                                                                                                     |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `audits/doc-references.sh`                   | **Yes** — baseline by identity at P0, whole-tree diff at close; never a bare pass while the baseline stands |
| `audits/docs-length.sh`                      | **Yes** — no edited file crosses 270 counted lines without a dated allowance                                |
| `audits/docs-pairing.sh`                     | **Yes** — both pairs keep their four H2s                                                                    |
| `audits/doctrine-drift.sh`                   | **Yes, regression only** — it reads fenced code; the prose half is the read-across                          |
| `syntax/lint.sh`                             | **Yes** — Markdown lint and formatting                                                                      |
| `syntax/check.sh`, `tests/all.sh --coverage` | `N/A` — no code path (`US013.md` → Verification Checks)                                                     |
| `database/migrate.sh check`                  | `N/A` — no model                                                                                            |

---

## Execution & Verification via Claude Dynamic Workflows

**The internal procedure comes first** (`.claude/CLAUDE.md` Section 2.7): each stage names the
workflow it executes.

### Stage 0 — Plan verification (before any code)

`17-story-plans` Step 9: 2-3 independent reviewers critique this plan and its guide — a row no spec
supports, a QA scenario no row exercises, a guessed outcome, a wrong cite — and every finding is
resolved before Step 10.

### Stage 1 — Build (one phase at a time)

P0 to P5 in order, inside the worktree. No TDD loop applies — there is no unit of behaviour; each
phase's exit is the check named against it. A subagent may draft P2's token pass, but P0's captures
and P3's ordering are serial.

### Stage 2 — Continuous verification gates

After each phase: `bash code/src/scripts/syntax/lint.sh` over the changed Markdown and
`bash code/src/scripts/audits/doc-references.sh --path <changed file>`. The whole-tree gates run at
P6 against P0.

### Stage 3 — Review (before raising the PR)

`code/workflows/07-review/` through the `review` skill; each finding adversarially verified before
acting. The guide is walked by a tester other than the author (Key Decision 10).

### Stage 4 — Behavioural verification

The live walk: `server.sh up`, the `logs.sh` follow, and every read and the truncate inside one
`shell.sh` session, typed as the story leaves them (guide _WALK_).

### Stage 5 — PR & release

`22-implementation-documentation` (the records, the `DEFERRED.md` entry and the `GAPS.md` close) →
`23-pr-and-review` → `24-release` if a version is cut.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**Governing rule.** Every developer operation runs through `code/src/scripts/**/*.sh`; no raw
`python`, `pytest`, `pnpm`, `uv`, `pip`, `npx` or `docker`. **Never make a generated tree with a raw
Copier call** — CI's `[3/4] Template Generation` makes it (QA plan Section 6).

### Canonical commands

| Need                      | Command                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------ |
| Dev stack up              | `bash code/src/scripts/development/server.sh up`                                           |
| Follow the django service | `bash code/src/scripts/development/logs.sh --service django --follow`                      |
| One shell in django       | `bash code/src/scripts/development/shell.sh` (default service `django`)                    |
| Doc gates                 | `bash code/src/scripts/audits/{docs-length,docs-pairing,doc-references,doctrine-drift}.sh` |
| Lint                      | `bash code/src/scripts/syntax/lint.sh`                                                     |
| Worktree hosts            | `bash code/src/scripts/development/hosts-story-add.sh 013`                                 |

### The exceptions, and why each is allowed

Read-only text tools, none on the banned list and none touching the repository: the `/tmp` `sed`
renders (a scratch copy of the six files, tokens substituted — lawful for these files only, because
they carry no Jinja block and no `_exclude` entry; QA plan Section 6, EC-04); `grep -oi <name> <file>
| wc -l` for counts (occurrences, never `grep -c`; `qa-tester` item 10); and `git grep` for the EC-06
outside-citation search; `mktemp -d` and `cp` of the six files into `/tmp` for those renders, and
`git status` to show the render left the repository unchanged (TOKENS-02); and
`git diff --name-only main...<last build commit>` for the build's changed-file list (MARKERS-04). Commands typed **inside** the `shell.sh` session (the reads and the
truncate) run in the container the script opened.

---

## Testing

**Automated: N/A**, each with its reason — no pytest (no code path), no coverage floor (nothing
instruments), no `migrate.sh check` (no model), no Bruno, no e2e (no page). Recorded, never omitted
(`code/docs/GATE-REPORTING.md`).

### Where each criterion is read

| Criterion                            | Read by                                                                                                                           |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| Every token renders                  | The one CI `[3/4]` run, both `INCLUDE_MOBILE` iterations in its log; run ID recorded (HP-05, ES-04)                               |
| Every token is a defined question    | Source-side list against `copier.yml`'s top-level questions (ES-09)                                                               |
| Per-site counts, no unmarked literal | The Bugsink / Fluent Bit `sed` render: 18 / 12 by position, `glitchtip` 0, `loki` 10, marker scope (HP-06, ES-01 to ES-03, ES-05) |
| The Sentry sentence                  | Its own `/tmp` render of 09 `STEPS.md` (EC-01; Key Decision 9) — not part of the generated-project check                          |
| The doc gates                        | Four gates diffed against P0 (HP-10)                                                                                              |
| Commands run as written              | The live walk (HP-02 to HP-04, HP-14)                                                                                             |
| Sentences read correctly             | The human read-across (EC-02, EC-05)                                                                                              |

### Manual testing

- `project-management/src/18-TESTS/MANUAL/US013-MANUAL-TESTING.md` — authored from the specs beside
  this plan at `17-story-plans` Step 7.2. A pointer, never a list of its own.

---

## Documentation Write-Ups (Implementation Records)

| Record                                        | Destination                                                                   | Produced by                     | This story                                                               |
| --------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------- | ------------------------------------------------------------------------ |
| This plan                                     | `../17-STORY-PLANS/`                                                          | `17-story-plans`                | Always                                                                   |
| Manual testing guide                          | `../18-TESTS/MANUAL/US013-MANUAL-TESTING.md`                                  | `17` (authored), walked at `22` | Always                                                                   |
| Automated test record                         | "../18-TESTS/AUTOMATED/US013-TEST-STATUS.md"                                  | `22`                            | Always — every suite `N/A` with its reason; the CI run IDs               |
| QA implementation review                      | "../11-QA/IMPLEMENTATION/QA-IMPL-US013-LOG-DEBUG-WORKFLOW-SEAM-DD-MM-YYYY.md" | `22`, verified at `23`          | Always                                                                   |
| Code review record                            | `../19-REVIEWS/`                                                              | `23` / code `07-review`         | Always                                                                   |
| `DEFERRED.md` entry                           | repo root                                                                     | `22`                            | Always — the out-of-scope literals and the two "proven alternates" lists |
| `GAPS.md` 17/09/2026 items 1-2                | repo root                                                                     | `22`                            | Always — closed                                                          |
| GDPR / Security / SEO / API / Logging records | `09`-`14`                                                                     | —                               | Not required — every flag `N/A`                                          |
| ADR                                           | `../15-DECISIONS/`                                                            | —                               | Not required (Key Decision 2)                                            |
| Bug report                                    | `../21-BUGS/`                                                                 | code `10-debug`                 | Conditional — only if the walk finds a defect beyond the story           |

---

## CONTEXT.md & Index Updates

| File                                        | Change required                                                                                                                                                                             |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md`   | At Step 10: the US013 _Story plan_ and _Git branch_ cells in _Stories → Must_, the _Story Plans — the code master_ row, and the _Branch Naming Reference_ row point at this file and branch |
| `../02-STORIES/US013.md`                    | At Step 10: reference this plan                                                                                                                                                             |
| `STORY-PLANS-BOARD.md` and the other boards | `bash project-management/src/00-ASSETS/scripts/pm-board.sh --write` — never hand-edited                                                                                                     |
| 09 and `code/src/logs/` pairs               | Content edited by the story; their directory trees do not change (no file added or removed)                                                                                                 |
| `how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md`   | Bump **Last Updated** with the P5 edit; the 09 and logs-pair `CONTEXT.md` files carry no date line                                                                                          |
| `MAP-RULE-OWNERSHIP.md` S-07 row            | The dated LogQL-mismatch note (P2)                                                                                                                                                          |
| code-review-graph                           | Refreshed **after staging**, at the close (`code/docs/CODE-REVIEW-GRAPH.md`)                                                                                                                |

---

## Status Propagation & ClickUp Sync

The story's `**Status:**` is the only status; `completion` edits it, appends the `## Status history`
row, ticks the sprint's Story Summary where due and regenerates the boards. This plan and the sprint
plan carry none.

| Transition                | When                                                                                |
| ------------------------- | ----------------------------------------------------------------------------------- |
| `Open` → `Pending`        | `17-story-plans` Step 10 — no blocking dependency is open                           |
| `Pending` → `In Progress` | `code/workflows/01-implement-story/` build-start prerequisite, before P0's captures |
| Later transitions         | `22`, `23` — `completion`'s vocabulary                                              |

The ClickUp export is regenerated by the `precommit-clickup.sh` lefthook whenever the story is staged
(`bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US013` to preview).

---

## Deferred Items

- **~58 vendor-literal lines in 21 files outside scope** — `22` writes the `DEFERRED.md` entry at
  close, re-measuring then (cutting round, Q9).
- **The two "proven alternates" lists naming `Alloy`** — `code/docs/logging/OBSERVABILITY.md`:100,
  `how-to/src/PLATFORM-PROVIDERS.md`:38 — the same `DEFERRED.md` entry (11-qa round 4, Q17).
- **The LogQL container selectors and the four held `Loki` sites' mismatch** — `S-07` (US014), via
  the map note.
- **Host-path reads and the 09 `CONTEXT.md`:34 tick** — `S-07` (US014).
- **`CHECKLIST.md`:39, :56 and any dev-path handoff box** — `S-04` (US020, provisional).
- **The 7 literals in `code/workflows/CONTEXT.md`** — `S-02`.
- **The "Prometheus + Grafana dashboards" cell** — scheduled nowhere; a candidate for
  `<%OBSERVABILITY_STACK%>` (`US013.md` → Out of Scope; N-012, Q11). `22` names it in the same
  `DEFERRED.md` entry, as "scheduled nowhere", so it is recorded after close.
- **Row D marker counts** — re-measured by `S-03` and `S-05` after merge.
- **The stale S-01 Acceptance cell** (`MAP-RULE-OWNERSHIP.md`:1080) — routed to `01-feature-map`.

---

## Risks

| Risk                                                                                 | Likelihood | Impact | Mitigation                                                                                                                                                     |
| ------------------------------------------------------------------------------------ | ---------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A case-sensitive grep reports the folder clean (misses 15 of 16 `Glitchtip`)         | High       | High   | Every vendor search `-i` (ES-01; 11-qa round 1, Q6)                                                                                                            |
| On a default render a token is byte-identical to a missed literal                    | Certain    | High   | The literal grep runs on the `sed` render only (Q13)                                                                                                           |
| A misspelt token renders empty under Copier but survives `sed`                       | Med        | High   | Source-side defined-question check before any render (ES-09)                                                                                                   |
| Edits move every line, so a site is mis-located                                      | High       | Med    | Inventory by anchor phrase (re-check 5)                                                                                                                        |
| A second `Loki` in a marker breaks the count of 10                                   | Med        | Med    | Markers refer to the held sites without naming the product (re-check 6)                                                                                        |
| The whole-tree `doc-references.sh` run exceeds 16 minutes and the baseline is missed | Med        | Med    | Start it first and give it the time; a miss is recorded as missed, GATES-03 is `Fail` `Unmeasured — baseline missed`, the sign-off `Blocked` (Key Decision 13) |
| Counting lines rather than occurrences                                               | Low        | Med    | `grep -oi … \| wc -l`, never `grep -c` (`qa-tester` item 10)                                                                                                   |
| Renumbering Steps 7-8 breaks an outside citation                                     | Low        | Med    | EC-06 re-grep at build (none on 31/10/2026, re-checked 01/11/2026)                                                                                             |
| Line drift since sign-off misdirects an edit                                         | Certain    | Low    | Inventory re-measures; see _Measured divergences_                                                                                                              |

---

## Measured divergences

Recorded 01/11/2026 at `5234a27`, one line each; none reopens a settled answer.

- **`TEMPLATE-TOKENS.md` drift.** `facc337` added four lines: the reach paragraph is `:138-141` (story
  cites `:134-137`) and the `LOG_AGGREGATOR` row `:125` (QA plan cites `:121`); text unchanged — the
  inventory task re-measures. `copier.yml`:470-483 and :508-513, `05-ANSWERS.md`:124 and every 09 /
  logs-pair cite still hold.
- **Stale map cell.** The S-01 Acceptance cell at `MAP-RULE-OWNERSHIP.md`:1080 predates the 11-qa rounds
  (29 + 6 literals, one check on every path); routed to `01-feature-map`, not edited here.
- **Wording slip.** `US013.md`:260 and :374 (also the FLAGS comment at :80) say the marker already
  exists; none exists at HEAD — it is the marker this story writes (task :414).
- **"Every render path".** US013's own definition (QA plan Q2, Q13, EC-04), not US010's 72-case
  matrix in `./10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md`; CI still renders `INCLUDE_MOBILE`
  false and true only.

---

## Docker & Nginx Infrastructure

**N = 13**, so the IP is `127.0.0.13` (`how-to/docs/GIT-WORKTREES.md`:63-65). Subnets per
`code/src/docker/CONTEXT.md`: `10.13.1.0/24` dev and `10.13.0.0/24` test. None of the three appears
in the tracked tree (`git grep`, 01/11/2026).

| File                                            | Purpose                                                                                                                                      |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us013.dev.yml"  | Dev override — from `code/src/docker/docker-compose.usXXX.dev.yml.example`; nginx on `127.0.0.13:3080:80`; subnet `10.13.1.0/24`             |
| "code/src/docker/docker-compose.us013.test.yml" | Test override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `127.0.0.13:3081:80`; subnet `10.13.0.0/24`                    |
| "code/src/docker/nginx/dev-us013.conf"          | Named per `./CLAUDE.md`'s four-file rule — **not generated**: `dev.conf` is a `server_name _` catch-all (`code/src/docker/nginx/CONTEXT.md`) |
| "code/src/docker/nginx/test-us013.conf"         | Same                                                                                                                                         |

**Unlike the precedent documentation plans, this story does start the stack** — the live walk (Key
Decision 10). Hosts entry: `bash code/src/scripts/development/hosts-story-add.sh 013` — the story
number, never `us013`.

```text
127.0.0.13 dev-us013.<%PROJECT_SLUG%>.localhost test-us013.<%PROJECT_SLUG%>.localhost
```

---

## Sprint Verification Checklist

- [ ] P0 captured before the first edit — the four gate readings and the inventory — or recorded as missed
      (a miss makes every dependent guide row `Fail` `Unmeasured` and the sign-off `Blocked` — Key
      Decision 13)
- [ ] `bash code/src/scripts/syntax/lint.sh` — clean over every changed file
- [ ] `docs-length.sh`, `docs-pairing.sh`, `doctrine-drift.sh` — exit 0, read against P0
- [ ] `doc-references.sh` whole tree — diffed against P0 by identity; no new finding in the edit set
- [ ] CI `[3/4]` run green, both `INCLUDE_MOBILE` iterations reading 0 unrendered tokens, run ID recorded; the source token check clean
- [ ] The Bugsink / Fluent Bit `sed` render: 18 / 12 by position, `glitchtip` 0, `loki` 10, marker scope
- [ ] The live walk typed and recorded; the read-across done
- [ ] `check.sh`, `tests/all.sh --coverage`, `migrate.sh check` — `N/A`, recorded as such
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] The guide walked and signed off by a tester other than the author
- [ ] code-review-graph refreshed after staging

---

## Definition of Done

- [ ] Every acceptance criterion in `../02-STORIES/US013.md` met and demonstrated by its guide row
- [ ] All eighteen tasks checked off — the seventeen documentation tasks and the manual QA walk; nothing outside the edit set and the map's S-07 note changed
- [ ] `07-review` complete; every gate recorded per `code/docs/GATE-REPORTING.md`, nothing skipped silently
- [ ] Documentation hard gate satisfied before commit; the graph refreshed after staging
- [ ] `22` has written the test-status record, the QA review, the `DEFERRED.md` entry and closed
      items 1-2 of `GAPS.md`'s 17/09/2026 entry
- [ ] PR raised and promoted via `23-pr-and-review/`; merged before US014 starts — its hard start gate (Key Decision 14)
- [ ] Story status advanced by `completion`, history row appended, boards regenerated
- [ ] (If releasing) version bumped per `24-release/`
