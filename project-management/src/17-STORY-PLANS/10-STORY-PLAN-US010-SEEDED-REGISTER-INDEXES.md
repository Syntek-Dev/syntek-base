# STORY-PLAN-US010 — The seven register indexes are born seeded, and the map index leaves the file that ships

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 03/10/2026                         |
| Branch | `us010/seeded-register-indexes`    |
| Sprint | SPRINT-06 · Wave 1 · build order 1 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

<!-- BORN WITH ITS PREFIX, 03/10/2026. The number "10-" was reserved for this story on 20/09/2026,
     at 03-sprint-planning, in ../03-SPRINTS/SPRINT-06.md -> Dependencies ("The next free prefix is
     10-, and that number is reserved, not a plan"), and carried as a no-file row in
     ../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md -> Story Plans — the code master from 03/10/2026. The
     owning story did not record it until this plan's own commit (settled 03/10/2026,
     16-sprint-plans grilling round 9 Q20), which records it in ../02-STORIES/US010.md beside the
     reference to this plan. The prefix is the story's position in the settled build order across
     the WHOLE backlog — US007, US001, US002, US003, US004, US005, US006, US008, US009, US010 — not
     its sprint and not a per-sprint counter, so US010 is tenth, the sole member of SPRINT-06
     behind SPRINT-05's last member. It is RENUMBERED whenever build order changes, which is the
     OPPOSITE of the sibling rule for the sprint plans: a sprint plan carries two numbers and a
     mismatch between them is information, while a story plan carries one, so its prefix must
     track build order or it says nothing. ./CLAUDE.md owns the rule. Re-derived 03/10/2026 at
     HEAD 282ec0b against the run on disk, contiguous 00- to 09-, and against the sprint plans
     01- to 07- in their own exec-order sequence, and confirmed still current at save. US009's
     reserved carry has NOT landed, so the carry case ../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md ->
     Build order describes — US010 at "09-", US009 renumbered to "10-" — does not apply; if that
     carry ever lands, this file is renamed in the change that admits it. The descriptor
     SEEDED-REGISTER-INDEXES matches the story's QA plan, threat model and assessment, as every
     existing pair does. Wave 1 is the story's place in its map's cutting order: slices S-01 and
     the narrowed S-02 ship together as US010, first in
     ../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md's order sentence (:417-418). Build order 1 is
     first of one: the sprint has no other member. -->

Implements `../15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md` (a map's
`**Status**` header is one of five plain values — `Charting`, `Resolving`,
`Blockers clear — stories may start`, `Complete`, `Not started` — with any prose after the first
middle dot, each value derived from the map's own counts, `Blockers clear` winning the one overlap)
and `../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` (an index reads every
register's Status by one rule: the carrier value with the trailing HTML comment, bold markers,
backticks and everything from the first space-middle-dot-space removed, then trimmed, applied to
the value after the key), under
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (while
`doc-references.sh` is red, this story's citation criterion is a baseline captured before the first
edit and read as a diff, the baseline recorded in the manual testing guide). All three read
`Accepted`, measured 03/10/2026. Nothing else binds:
`../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` reads `Proposed`, its
sign-off is the read-rule record's Follow-on, and this story does not edit it.

> **`Open` is literal, and it asserts something.** `./CLAUDE.md` makes any value other than
> `Blocked` an assertion that the blockers are cleared, and this story has **none**: its map's
> frontier is empty (`Frontier open: 0 · Blocking open: 0`), every node it carries is settled, and
> no unshipped story creates a file it needs (`../02-STORIES/US010.md` -> Dependencies, re-measured
> there 27/09/2026). What stands between this plan and the first edit is the process gate every
> story here shares — the `us010/` branch is cut from `main` once `pm/story-creation` lands
> (`../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` -> Branch Naming Reference).

> **Source authority.** Where this plan and `../02-STORIES/US010.md` differ on **what must be
> true**, the story wins. Where the story and the assessment or the QA plan differ on a
> **mechanism**, the story's settled wording and the two US010 records are the corrected record —
> every gap the QA plan raised is `[RESOLVED]` into the story. Where this plan and the sprint plan
> differ on sprint facts, `../03-SPRINTS/SPRINT-06.md` wins over both. On how any gate's result is
> reported, `code/docs/GATE-REPORTING.md` wins over everything here. All three gate artefacts read
> `Signed off`: the threat model and the assessment from 28/09/2026, the QA plan from 30/09/2026,
> corrected in place 03/10/2026 on this workflow's grilling round 2 (Q4 and Q5; Key Decisions 13
> and 14).

**No Table of Contents, and the omission is house practice.** None of the nine sibling plans in
this folder, `01-` to `09-`, carries one (re-measured 03/10/2026, all nine at zero).

---

## Problem Statement

**Why this story exists.** `../02-STORIES/US010.md` is SPRINT-06's sole `Must`, cut from
`../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slices `S-01` and the narrowed `S-02`. The shipped
feature-map index at `../01-FEATURE-MAPS/CONTEXT.md:43-51` reads "None charted yet" beside fifteen
tracked maps, and the instruction that produced it — add a row to `CONTEXT.md` — is repeated at
twenty-four live sites in thirteen shipped files (`../11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
AC-GAP-1). Six of the seven registers that accumulate instances have no index at all, and
`./CONTEXT.md:86-96` records that absence as a decision deferred to exactly this work. Six maps
carried an unticked index-row box when the QA plan measured on 21/09/2026, five of them parked on
this slice shipping — the deadlock the map's own gate names.

**Current state, measured 03/10/2026 at HEAD `282ec0b`.**

- **No index file exists in any of the seven registers.** The only index in
  `project-management/src/` is `../23-INCIDENTS/INCIDENT-INDEX.md`, which ships by a `_exclude`
  negation (`copier.yml:188`) — the shape precedent and never the mechanism precedent.
- **The seed-once chain is one task**: nine `mv .copier/...` lines and `rmdir .copier` (`:1004`),
  joined by `&&` at `copier.yml:994-1005`, gated on the copy operation by its `when:` key (`:1005`).
- **`.github/scripts/shipped-artefacts.sh:105`'s `SEEDED` holds one entry**, read once — by check
  3 as a leak allowlist (`:197`). Check 4 (`:215-224`) never loops it; that loop is US012's.
- **`.github/scripts/shipped-registers.sh` (330 lines) carries nine checks over two registers**,
  `GAPS.md` and `DEFERRED.md`; its `_tasks` clause greps the whole block (`:150-154`) and cannot
  tell a gated task from an ungated one.
- **`.github/scripts/shipped-ai.py` (345 lines) builds its fixture with one destination folder**,
  `01-FEATURE-MAPS/` (`:103-104`), so the first `mv` into `02-STORIES/` would fail the chain and
  turn `[3/4]` red.
- **Map `**Status**` headers**: 3 of 15 parse, all three `Charting`; 12 fail the format.
- **Tracked population**, under each register's positive pattern: maps 15 · stories 12 · sprints 7
  · ADRs 25 · plans 9 · findings 0 · bugs 0. Every one of these is re-counted at implementation;
  none is a target.

**What this story delivers.**

1. Seven in-tree index files, one per register, named for the folder's own noun singularised,
   each carrying the spine `Status · Instance · Summary · Updated`, its own tail, its ordering rule
   and a `## How to read a row` section.
2. Seven `.copier/` seeds, moved by seven one-line `mv` lines inside the one existing copy-gated
   task ahead of `rmdir .copier`; `SEEDED` grown from one entry to eight; the seven landed paths in
   the `[3/4]` completeness step.
3. A third check family in `.github/scripts/shipped-registers.sh`, numbered from 10, proving the
   seeds blank, wired inside the copy gate, never re-included, and agreeing with the seeded map;
   and an update probe in `.github/scripts/shipped-ai.py` that changes every index seed between its
   two tags and asserts byte-identity, proved red with the gate removed.
4. One generated-tree literal grep over all seven index files, a link check over the in-tree and
   generated indexes, and the joined-line instruction search over the generated tree's Markdown,
   all three in the `[3/4]` job.
5. The map index backfilled with one row per map; every map's `**Status**` header re-derived to the
   enum; every Gate-to-stories index-row box and every `Umbrella ADRs` row disposed of.
6. Every shipped site that instructs the old index row, or says a register has no index, repaired;
   the programme-plan permission removed from the three shipped `17-STORY-PLANS` files; the seven
   seed-count sites corrected; the updating guide stating what an existing project and a recopy
   receive; wayfinder's chart step moving a map out of `Not started`.

**Explicitly out of scope**, each owned elsewhere and mirrored into _Deferred Items_:

- **Backfilling the four registers US011 owns** — stories, sprints, decisions and story plans. They
  ship declaring their debt (slice `S-05`, US011, SPRINT-07).
- **The index gate** — `S-03`, `N-003` and `N-004` — unscheduled, and never between US010 and US011
  (settled 21/09/2026, grilling round 1 Q1; CUT-PLAN.md P8).
  `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:420-421`'s "may run once `S-02` has landed"
  contradicts `N-003`'s presence clause and is left for `S-03`'s own cutting gate.
- **US012's check-4 `SEEDED` loop and its deletion probe** — this story grows the array and nothing
  else in check 4.
- **TM-14's seed-if-absent migration, TM-18's guard, and the memory-survival probe's blind case** —
  documented or routed to `GAPS.md` through gate `22`, never built (settled 27/09/2026, grilling
  round 3 Q15 and Q16).
- **Repairing the sprint-plan prerequisites** — only the one `GAPS.md` entry naming them is this
  story's, at its gate-`22` pass (settled 28/09/2026, 16-sprint-plans grilling round 1 Q2;
  settled 30/09/2026, 16-sprint-plans grilling round 3 Q9 and round 5 Q16).
- **The TM-10 window's `GAPS.md` entry** — US011's gate-`22` pass writes it (call recorded
  27/09/2026 with round 6).
- **Slice `S-04`** — artefact frontmatter, uncut and in no record.

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                                                                                                                                            |
| ----------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Database / models / migration | —         | `DB: N/A`. No model, field, index or RLS policy. "Seed" here means a `.copier/` file, never a database seed                                                                      |
| Service layer                 | —         | No service, no transaction, no error type                                                                                                                                        |
| Django Ninja API              | —         | `API: N/A`. No router, endpoint, `Schema` or MCP tool                                                                                                                            |
| Frontend (templates)          | —         | `Frontend: N/A`. No template, component, partial or CSS                                                                                                                          |
| Infrastructure / DevOps       | ✓         | `copier.yml`'s seed task, seven `.copier/` seeds, two CI scripts and the `[3/4]` job of `.github/workflows/audit-template.yml`, plus one Python CI probe outside the Django tree |
| GDPR / PII                    | —         | `GDPR: N/A`. The indexes name artefacts, never people                                                                                                                            |

**`Backend: N/A` and a Python edit are not in tension.** The one Python file this story edits,
`.github/scripts/shipped-ai.py`, is a template-only CI probe outside `code/src/django/`; `Backend`
governs application code (`../03-SPRINTS/SPRINT-06.md` FLAGS comment).

---

## Reference Documents (code/docs gate map)

Every row of the template's table was checked; the rows below are the ones that gate this story.

| Guide                                       | Why it binds this story                                                                                                                                                                                                                                                  |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `code/docs/GATE-REPORTING.md`               | **The most load-bearing guide here.** ShellCheck has no project script, no lint leg reads `.github/scripts/shipped-ai.py`, `shipped-artefacts.sh` runs only in CI, and the citation gate is read as a diff. Each is a reading, never a pass                              |
| `code/docs/FORWARD-VOICE.md`                | Why every path this story creates is written in double quotes below — the citation gate reads a backticked token as a path that must resolve — and why the shipped `CONTEXT.md` files may cite the landed index paths: they are seeded targets                           |
| `code/docs/DOCUMENTATION-PAIRING.md`        | Seven register folders gain a third Markdown file, and an index file must never be read as either half of a `CONTEXT.md` + `CLAUDE.md` pair                                                                                                                              |
| `code/docs/DOCUMENTATION-LENGTH.md`         | Seven `CONTEXT.md` files, six `project-management/workflows/` files, three register `CLAUDE.md` files and `.claude/skills/wayfinder/SKILL.md` are edited, every one bound (Section 2); the 300-line limit and the 270 ratchet are read at P0 and at close, never assumed |
| `code/docs/CODING-PRINCIPLES.md`            | The bash family and the Python probe — function length, the guard-clause form, one finding per mutation                                                                                                                                                                  |
| `code/docs/TESTING.md`                      | Read for what this story does **not** add: no application Python, so no coverage figure to regress                                                                                                                                                                       |
| `how-to/docs/GIT-WORKTREES.md`              | The loopback rule (`:63-65`): the final octet is the story number                                                                                                                                                                                                        |
| `project-management/docs/SECURITY-GUIDE.md` | STRIDE / OWASP 2025 / NIST CSF 2.0, and the rule that only CRITICAL and HIGH gate planning. The threat model produced neither                                                                                                                                            |
| `project-management/docs/QA-GUIDE.md`       | The walk-through shape the manual criteria take                                                                                                                                                                                                                          |

**Database, API design, RLS, encryption, rendering, responsive, accessibility, design tokens,
performance, logging, SEO and Cloudinary bind nothing**: their flags read `N/A` and this story has
no subject for any of them. `code/src/scripts/audits/doc-references.sh:371-377` is named rather
than listed: it parses the `mv .copier/...` lines out of the whole of `copier.yml` and treats a
seeded target as existing, which is why the one-line form (ST08) needs no parser change and why
the landed index paths need no `how-to/src/PROJECT-PATHS.md` row.

Cross-layer compliance guides that also gate this plan: `project-management/docs/SECURITY-GUIDE.md`
(STRIDE), `project-management/docs/QA-GUIDE.md`, `project-management/docs/VERSIONING-GUIDE.md` and
`project-management/docs/GIT-GUIDE.md` (the branch above).

---

## Architecture Decision

**The register-index design is not decided here and is not re-opened.** It was argued on
`../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` (nodes `N-001`, `N-002`, `N-005`, `N-006`, frontier
empty since 31/08/2026), sharpened by gates `10`, `11` and `15`, and settled in seven grilling
rounds between 21/09/2026 and 27/09/2026. What is fixed before this plan:

| Decided                                                                                                            | By                                                                                    | What it fixes                                                                          |
| ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| A map's Status is `<enum> · <prose>`, five plain values, each derived from the map's own counts                    | `../15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`                | The one register value nothing could read as a value                                   |
| One read rule for all seven carriers                                                                               | `../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`                      | Three different answers to "what is a row's Status", and two carriers nobody had asked |
| Seven lines inside the one copy-gated chain, ahead of `rmdir`, in the one-line form; no second task, no `mkdir -p` | ST01, ST02, ST08 (settled 21/09/2026, grilling round 1 Q3)                            | Seed-once, and the three parsers that read the line                                    |
| A third `shipped-registers.sh` family holding its own constant list of seven, plus one seed-row clause             | ST03, ST06 (settled 21/09/2026, grilling round 1 Q2; settled 27/09/2026, round 7 Q34) | Emptiness proved, never trusted; the negation leak the generated-tree check cannot see |
| An update probe that changes every seed, asserts byte-identity, and goes red with the gate removed                 | ST07 (settled 27/09/2026, grilling round 3 Q16)                                       | A probe that could otherwise pass whether or not the gate exists                       |
| Four indexes ship declaring their debt, with no ADR                                                                | settled 21/09/2026, grilling round 2 Q10                                              | The four-register backfill is US011's                                                  |
| Ordering, `Updated`, the Instance label and the positive instance test                                             | settled 21/09/2026, round 1 Q6 and Q7; settled 27/09/2026, round 3 Q17 and Q22        | Every sentence a seed ships, which no update can take back                             |

**This story is free to choose its order, and the developer chose it** (settled 03/10/2026,
17-story-plans grilling round 1 Q1): the mechanism first, each new probe committed red before its
check; then the content repairs; then every map edit and the backfilled map index last, in **one**
commit, so that every map's `Updated` — its last commit date — is read once. The phase plan below
follows that order and derives the rest from it. Round 2 Q4 adds one commit after the map commit,
the joined-line search step, which touches no map (Key Decision 13).

---

## Approach

### Not applicable — Database, Service Layer, API, Frontend

The template's four layer sections are dropped. This story adds no model, migration, service,
endpoint, `Schema`, template or component, and its `DB`, `API`, `Backend` and `Frontend` flags read
`N/A`. `../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` -> _Phase Breakdown_ records phases 1 to 3 as `N/A`
with their reasons. The work is planned per phase below.

**Pre-existing bug fixes — dropped too:** the pre-existing defects this story repairs, the stale
instruction sites and seed counts among them, are its scope (P2 and P3), not fixes made on the way.

### Phase plan — five phases, in the order the developer settled

| Phase | Deliverable                                                                                                                                                                                                                                                                                                                                         | Blocked by          |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| P0    | The baselines, captured **before any edit** — the whole-tree citation set by identity with its detector hash, HEAD and index state; the existing self-test probe counts and labels; the length readings; ShellCheck probed; US012 and US009 landing state                                                                                           | The branch existing |
| P1    | **The mechanism.** The completeness step's seven paths, red; then the fixture's six folders and the presence assertion, red; the seven seeds, the seven `mv` lines, `SEEDED` and the generated-tree grep, green; the update probe's mutation red then its byte-identity check green; the third family, each clause's probe red then its check green | P0                  |
| P2    | **The content repairs** that do not route into `01-FEATURE-MAPS` — six in-tree index files, six `## The index` sections, thirteen of the twenty-four register-index sites, the seven programme-plan sites, the seven seed-count sites and the updating guide                                                                                        | P1                  |
| P3    | **The map commit — one commit.** The map template's definition site, every map's header, box and `Umbrella ADRs` row, the backfilled in-tree map index, its `CONTEXT.md` and `CLAUDE.md`, wayfinder's three edits, the two `01-feature-map` sites, and the link check's in-tree half                                                                | P2                  |
| P4    | **Close.** First one commit adding the joined-line instruction search to `[3/4]` — it reads the sites P2 and P3 repair, and touches no map (Key Decision 13); then the citation diff against P0, every gate reading, ShellCheck recorded, the landing `[3/4]` run recorded — then `22-implementation-documentation`                                 | P3                  |
| —     | The automated test record, the implementation records and the register writes — **`22-implementation-documentation`'s**; the manual guide, authored at `17` before code, is `22`'s to walk                                                                                                                                                          | P0 to P4            |

**P1 precedes P2 because the mechanism fixes every name the repairs route to**, and because it
builds the controls behind the three threats whose design state is `HIGH` (TM-01, TM-03, TM-04;
threat model Section 3a, where each promotes on a later event, never on P1): the red-before-green
evidence is cleanest on a branch that holds nothing else yet. **P3 is the last content phase
because `Updated` is a last-commit date** (`../02-STORIES/US010.md:587`, the spine scenario's "And Updated is the instance
file's last commit date"): every map this story edits takes the map commit's date,
so the map edits and the rows that mirror them land in one commit, and no later commit on the branch
touches a map — P4's one commit, the joined-line search step, included.

**One rule decides what rides P2 and what waits for P3: a route lands in the same commit as the
file it routes to, or after it.** Every instruction that will name "MAP-INDEX.md" — the map
template's `:8` and `:159`, the folder's `CLAUDE.md` and `CONTEXT.md`, wayfinder's `:97-98` and
`:256`, the two `01-feature-map` sites — lands in P3 with that file. Every other site lands in P2
with the in-tree index it names. No commit on the branch points a reader at an index that does not
exist yet.

**Every phase is testable on its own:** P0 by the recorded figures; P1 by the three self-tests and
the `[3/4]` run on each commit; P2 by the scoped citation runs, `docs-length.sh` and
`docs-pairing.sh` over the files it touched; P3 by the manual walk's row-by-row and derivation
reads; P4 by the search step's first `[3/4]` run and the diff against P0.

### P0 — The baselines

Captured on the story branch before its first edit, and pasted into the manual guide's _Recorded
during the build_ at capture — never reconstructed afterwards
(`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`).

| Baseline                               | How it is taken                                                                                                                                                                                                                                                                                                                                                                |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Pre-edit tree                          | `git rev-parse HEAD` and the `git status --porcelain` count                                                                                                                                                                                                                                                                                                                    |
| Citation gate, whole tree, by identity | `bash code/src/scripts/audits/doc-references.sh`, normalised to `(file, kind, token)`, line number dropped, multiplicity kept; `git hash-object code/src/scripts/audits/doc-references.sh` and the index state beside it                                                                                                                                                       |
| Existing self-test probes              | Count and labels: `shipped-registers.sh --self-test` and `shipped-ai.sh --self-test` run; `shipped-artefacts.sh`'s probes counted in the file, its run being CI-only. ST05 gives nine in `shipped-registers.sh`, five in `shipped-artefacts.sh` and two in `shipped-ai.py`, as measured 21/09/2026, and the files hold the same on 03/10/2026; recounted here, never inherited |
| Length                                 | `docs-length.sh --path` over every bound instructional file the change edits: the seven register `CONTEXT.md` files, the six `project-management/workflows/` files, the three register `CLAUDE.md` files P2 and P3 edit (`15-DECISIONS`, `17-STORY-PLANS`, `01-FEATURE-MAPS`) and `.claude/skills/wayfinder/SKILL.md` (`code/docs/DOCUMENTATION-LENGTH.md` Section 2)          |
| ShellCheck                             | Probed with `command -v shellcheck`. **Not installed on 21/09/2026** (QA plan Section 7); the result is recorded either way                                                                                                                                                                                                                                                    |
| US012 and US009                        | Whether either has landed on `main`, because each meets this story in a shared file — `SEEDED`'s comment, and the `[3/4]` job. Read again at the rebase before the landing commit, because either may land mid-build                                                                                                                                                           |

### P1 — The mechanism

**The order inside P1 is forced by one obligation: each new probe is committed red, in a commit of
its own, before the check it proves** (settled 03/10/2026, 17-story-plans grilling round 1 Q1;
ST05; threat model TM-15). A probe edited in the same commit as the check it proves is exactly the
event that promotes TM-15 to `MEDIUM` (threat model Section 3a), and one committed alongside its
check has never been seen to fail. Each red is recorded — the commit SHA and the probe's own failing
line, or the `[3/4]` run ID — under the guide's _Recorded during the build_.

| Step | Commit                                                                                                                                                                                                                                                                                                                                                                                                 | Expected                                                                                                                                                                                                                                                                                                           |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| P1.1 | **The presence probes, in two commits and in this order.** First, the `[3/4]` completeness step (`.github/workflows/audit-template.yml:230-248`) gains the seven landed paths, and nothing else changes. Second, `fixture()` in `.github/scripts/shipped-ai.py` creates the six register folders through their `CONTEXT.md` markers, beside `:103-104`, and the copy asserts all seven indexes present | **Red, twice** — the seeds do not exist yet. The first commit's `[3/4]` run is red on the completeness step's own messages, every step before it green. The second is red on the presence assertion's own message, locally and in `[3/4]`, where the completeness step is skipped behind it — masked, never passed |
| P1.2 | **The seeds and the chain.** Seven seeds under `.copier/`; seven `mv` lines in the one task at `copier.yml:994-1005`, ahead of `rmdir .copier`; `SEEDED` grown to eight and its comment rewritten; the generated-tree grep and the link check's generated half added to `[3/4]`                                                                                                                        | **Green**: presence, completeness, `shipped-artefacts.sh` and its self-test, the grep and the link check                                                                                                                                                                                                           |
| P1.3 | **The update probe's mutation.** A `--self-test` mutation in `shipped-ai.py` that removes the seed task's `when:` key and runs the update path                                                                                                                                                                                                                                                         | **Red**: the detector accepts the ungated fixture, because nothing yet asserts byte-identity                                                                                                                                                                                                                       |
| P1.4 | **The byte-identity check.** Each project edits and commits every index; the template's second tag changes every index seed; every index is compared byte for byte after `run_update`                                                                                                                                                                                                                  | **Green**, the mutation now rejected on the byte-identity assertion's own message                                                                                                                                                                                                                                  |
| P1.5 | **The third family, one clause at a time.** For each clause in turn: its `--self-test` probe in one commit, then the clause in `run_checks` in the next                                                                                                                                                                                                                                                | **Red, then green**, per clause — the probe's line reading "produced 0 finding(s)", then passing with exactly one                                                                                                                                                                                                  |
| P1.6 | **The family's header, usage and closing text** name the index seeds; "Nine checks" counts what the script now holds                                                                                                                                                                                                                                                                                   | Green; the nine existing probes' labels and expected substrings byte-identical                                                                                                                                                                                                                                     |

**Why P1.1 is two commits, completeness first.** A job stops at its first failing step, no step in
`.github/workflows/audit-template.yml` carries `continue-on-error` or `if: always()`, and the
`shipped-ai.sh --self-test` step (`:165-166`) runs before the completeness step (`:230-231`). One
commit holding both would show the presence red alone, the completeness step never reached — so
the completeness paths land first, while every step before them is still green, and their red is
seen on its own.

**Why P1.1's reds are reds for the right reason.** The fixture's six folders land with the presence
assertion, so the first `mv` into `02-STORIES/` can never fail the chain with a `TaskError` — the
wrong-reason red QA plan ES-09 and ES-20 describe. What fails is the assertion that the seven
landed. Folders without seeds change no existing result: `exercise()`, `exercise_legacy()` and
`self_test()` all build through `fixture()` (confirmed by the code-review-graph, `callers_of`
`fixture`, 03/10/2026), so all three callers get the folders and none gets a seed it did not have.

**The seeds — what each holds.** Each seed takes the `../23-INCIDENTS/INCIDENT-INDEX.md` shape —
title, metadata line, reading rule, `## The register` table, `## How to read a row` — with its
register's spine, tail and ordering sentence, and the read rule in the same words every time.

- **The six non-map seeds** carry the italic empty-register placeholder row and nothing else in the
  table: no instance row and no `Backfill owed` line (ST03, ST04).
- **The map-index seed** carries exactly one row for the seeded scale-planning map: `Status`
  `Not started`, string-equal under the read rule to `.copier/MAP-SCALE-PLANNING.md:4`; `Instance` a
  Markdown link to the map, resolving from the landed folder; `Summary` a generic line naming
  nothing syntek-base-specific, or `TBD`; `Updated` `TBD` (settled 21/09/2026, grilling round 1 Q4).
- **No seed names a syntek-base map, story, sprint, decision, plan, finding or bug**, in a row or in
  prose — a worked example in a reading rule is the likeliest leak (TM-08).
- **Seeds render, in-tree files do not** (`copier.yml:16`, `:157`). A seed may carry a registered
  header token the way the incident index does; an in-tree index never copies one, because it would
  display raw (TM-16).

**The chain — what each line is.** `mv .copier/<NOUN>-INDEX.md project-management/src/<REGISTER>/<NOUN>-INDEX.md &&`,
one per register, inside the existing task, ahead of the `rmdir .copier` line, which stays `rmdir`.
No flag, no quoting, no `|| true`, no split across the folded scalar (ST08). The nested target has
its precedent in the task already — the scale-planning line. Nothing enters `_exclude`:
`/project-management/src/**` at `copier.yml:157` already covers every landed path, and no negation
may name one (ST06).

**`SEEDED`'s comment, and the story it shares.** The comment above `:105` names `01-FEATURE-MAPS`
alone and is false for seven of eight entries. It is rewritten to describe the allowlist check 3
reads — paths a `_task` seeds, admitted as not leaked — and **never** as proof that they landed,
which is US012's check-4 loop (assessment 7.12). Build order expects this story first, so the
wording is left for US012 to extend to both reads; **if US012 lands first** — read at P0, and again
at the rebase before the landing commit — this story extends US012's comment to cover the seven
index seeds and never replaces its account of check 4's presence read (`../02-STORIES/US010.md` ->
Dependencies; CUT-PLAN.md P9).

**The third family — six clauses, numbered from 10, append-never-renumber.** The order inside the
family is the build's; each clause's probe precedes it (P1.5).

| Clause                                | What it asserts                                                                                                                                                                                               | Its probe                                                                              |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| Seed exists                           | Each of the seven, from the family's **own constant list** of seed and landed paths — never derived from `copier.yml`, or a seed dropped with its line vanishes from both sides (QA plan ES-08)               | A seed removed: one finding                                                            |
| Wired inside the copy gate            | Each line sits in the command of the task whose `when:` tests the copy operation and which carries the README `mv` — read from that task alone, never the whole `_tasks` block (`:150-154` today cannot tell) | A line moved to an ungated task, or dropped: one finding either way, one check not two |
| Canvas marker                         | Each seed carries `## The register`                                                                                                                                                                           | The marker removed: one finding                                                        |
| No instance row                       | Judged by shape inside `## The register`: a body row that is neither the italic placeholder nor, in the map-index seed, the one row linking the scale-planning map                                            | A seed gains a row linking a real artefact: one finding                                |
| Seed-row agreement                    | The map-index seed's row, read under the read rule, string-equals `.copier/MAP-SCALE-PLANNING.md:4` read the same way (settled 27/09/2026, grilling round 7 Q34)                                              | A mutated seed pair whose two values disagree: one finding                             |
| No negation re-includes an index path | Each `_exclude` line, with either quote style, a trailing comment and a block-tag conditional stripped, matched against the seven landed paths with `_exclude`'s own glob semantics; one finding per line     | A literal negation, and a glob-form one ending in the index suffix: one finding each   |

`path_matches` at `code/src/scripts/audits/doc-references.sh:406-418` is the in-repository
precedent for the glob matching, and the baseline run must stay clean against today's 24 negations
(`copier.yml:147-188`, none matching an index path). **The family is one family.** If it needs a
second family to hold, the story goes to 13 SP and back to `01-feature-map` (settled 21/09/2026,
grilling round 2 Q12); the seed-row clause is a clause, not a family.

**ES-08 is two findings, and ES-02's red is `rmdir`'s** (settled 03/10/2026, 17-story-plans
grilling round 2 Q5; Key Decision 14). QA plan ES-08 removes a seed **and** its `mv` line together:
the seed-exists clause reports the seed and the wired clause the line — two findings, never silent —
while each clause's own probe still yields exactly one. ES-02's `shipped-ai.py` half reads the
threat model's TM-06 way: the fixture keeps only the task holding the memory line, so a line moved
into an ungated task leaves its seed in `.copier/`, and `rmdir .copier` fails with a `TaskError`
before the presence assertion is reached. QA plan ES-02 and ES-08 were corrected in place in this
change, in that file's corrected-in-place shape, on the developer's answer rather than by a re-run
of `11-qa-checks`; the guide's FAMILY-09 and FAMILY-11 assert them.

### The generated-tree grep — one step, all seven indexes, for good

**US010 builds the only generated-tree literal grep over the index files, and US011 adds none**
(settled 03/10/2026, 17-story-plans grilling round 1 Q2). The step runs in the `[3/4]` job on every
render path the template offers (today: `INCLUDE_MOBILE` true and false) over all seven landed
index files, and prints nothing when clean: no `US###`, `SPRINT-##` or `MAP-<FEATURE>` literal, the
ADR, plan, finding and bug identifiers each being caught through the story identifier they carry —
bar each file's own name, the scale-planning map in the map index's one row, and the `000` template
identifiers (QA plan Section 6, EC-14).

**What Q2 changes is the step's lifetime, not its scope.** The scope was already all seven files.
The step is now the one guard on every seed for as long as the template ships, including after
US011 fills four in-tree indexes beside their seeds — which is when TM-03's promotion trigger can
fire. So it is written unconditionally: no reference to this story, no allowance that expires, no
pattern narrower than the four registers US011 fills. US011's own grep task is recorded
`N/A — superseded` in US011's commit, not here.

**It has no self-test, and none is invented here.** ST05's red-before-green binds the self-test
probes, and this plan reads the threat model's TM-15 control, "every new check ships a probe seen
red before it is seen green (ST05)", as ST05 and assessment 7.5 read it (the joined-line search,
below); no planted red is specified for this step. It is proven by its landing run on every
render path, and the same leak has a control that is seen red: the third family's no-instance-row
clause and its probe (TM-03, TM-08).

### The link check — two halves, landing with the files they read

Every Markdown link target in the seven in-tree indexes and the seven generated ones resolves from
the file's own folder (`../02-STORIES/US010.md` -> QA Acceptance Criteria — Automated) — the check
`doc-references.sh` cannot make, because it reads backticked tokens only. The **generated half**
lands in P1.2 with the seeds it reads; the **in-tree half** lands in P3's commit, where the last
in-tree index arrives. A check never lands before the file it reads.

### The joined-line instruction search — a `[3/4]` step, landing after P3

The story requires a search, run over joined lines, of "the files a generated project receives"
for an instruction naming `CONTEXT.md` as a register's index or a statement that a register has no
index or that its index is deferred, its pattern and output recorded
(`../02-STORIES/US010.md` -> the site scenario and the third manual criterion). **US010 adds it to
the `[3/4]` job as a step of its own** (settled 03/10/2026, 17-story-plans grilling round 2 Q4;
Key Decision 13):

- **Where, and over what.** On every render path the template offers, over the generated tree's
  Markdown, reading paragraphs rather than lines; it matches both halves — the instruction, and
  the statement of absence or deferral, the phrases QA plan Section 6 names among them — and skips
  dated historical comments and nothing else (QA plan HP-18 and Section 6).
- **What it prints, and when it fails.** It prints its pattern and its output, and **fails the job
  on any hit**. The walk reads both from the landing run by its ID (the guide's SITES-05), and the
  implementation record copies them, as the story's third manual criterion asks.
- **When it lands.** In P4's first commit, after P3's, because it reads the sites P2 and P3
  repair: landed earlier, it would be red on every commit until P3's, and P1's green readings would
  be taken off a red job. That commit edits `.github/workflows/audit-template.yml` alone — inside
  ST05's eleven paths — and no map, so no map's `Updated` moves.

**Its proof is its landing run, as the generated-tree grep's is.** TM-15's discipline, which P1
is built on — each probe committed red, in a commit of its own, before the check it proves (ST05:
"each new probe is seen red before it is seen green") — binds probes, and this step has none. The
threat model's TM-15 control reads "every new check ships a probe seen red before it is seen green
(ST05)", but ST05, which the story owns, and assessment 7.5 ("new probes seen red first") bind
probes, and this plan reads TM-15 as they do; the step's one natural red — landing before P2, red
on every unrepaired site — is ruled out by Q4's placement after P3, so none is planted. TM-15's
trigger, a probe edited in the same commit as its check, has nothing here to fire on. What the
change could bend is the step's pattern, written by the change it judges, so the walk reads that
pattern against QA plan Section 6 (SITES-05) and _Risks_ names it. Q4 settled the step's home and
its failure, not a lifetime: nothing in it names this story, and removing it later is a change of
its own.

### P2 — The content repairs

**The six in-tree indexes that are not the map index.**

- STORY-INDEX, SPRINT-INDEX, DECISION-INDEX and STORY-PLAN-INDEX carry their spine, tail,
  ordering sentence and `## How to read a row`, **no row and no placeholder row**, and a visible
  `> Backfill owed — US011` line, so none reads as an empty register (ES-17).
- FINDING-INDEX and BUG-INDEX carry the placeholder row and name no debt. **Both registers are
  re-counted at P2's commit**: an instance found then gets its row here, the register being this
  story's (EC-16).

**Tails and ordering, per register.** The tail columns are designed at build
(`../02-STORIES/US010.md` -> Index Tasks), with two fixed obligations: the decision register's
`Supersedes` / `Superseded by` pair, read by the same strips as Status (EC-10), and each event
register's creation date, which its ordering reads.

| Register          | Carrier, read by the one rule                                    | Order the file states                                                                                                                     | Instance label |
| ----------------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `01-FEATURE-MAPS` | First line beginning `**Status**:`                               | Descending by `**Charted**`, ties by identifier ascending                                                                                 | Descriptor     |
| `02-STORIES`      | First line beginning `**Status:**`                               | Ascending by identifier                                                                                                                   | Identifier     |
| `03-SPRINTS`      | First line beginning `**Status:**`                               | Ascending by identifier                                                                                                                   | Identifier     |
| `15-DECISIONS`    | First line beginning `**Status:**`                               | By `US###` then Date ascending; a supersession predecessor before its successor within a group sharing both; otherwise filename ascending | Descriptor     |
| `17-STORY-PLANS`  | First table row keyed `Status`, value backticked                 | Ascending by the build-order prefix; a row renamed when its plan is renumbered (EC-12)                                                    | Descriptor     |
| `20-FINDINGS`     | The metadata line; the value after `**Status**:`, before the cut | Descending by filename date, ties by identifier ascending                                                                                 | Descriptor     |
| `21-BUGS`         | First table row keyed `**Status**`                               | Descending by `Date found`, ties by identifier ascending                                                                                  | Descriptor     |

The orders are settled 21/09/2026, grilling round 1 Q7, and 27/09/2026, round 3 Q17; the
ascending identifier tie-break is the call recorded 27/09/2026 with round 6. **The decision
register's tie-break is real today**: nine groups of ADRs share both `US###` and Date, two of them
holding a same-date supersession chain (counted 03/10/2026; the QA plan's EC-11 counted seven on
21/09/2026). Count again at implementation; the sentence states the rule whatever the count.

**The register `CONTEXT.md` files.** `02-STORIES`, `03-SPRINTS`, `15-DECISIONS`, `20-FINDINGS` and
`21-BUGS` gain a `## The index` H2 on the `../23-INCIDENTS/CONTEXT.md:58-63` shape, linking the
index and stating how to read a row; `21-BUGS` cites its index by full path, never the bare
filename in backticks (ES-15). `./CONTEXT.md:86-96` — this folder's _The plans index_ — is
**rewritten** to describe the index's presence. `23-INCIDENTS/CONTEXT.md` is not touched. Each
touched directory tree gains its index file. **The `**Last Updated**` field keeps the copier date
token in every shipped `CONTEXT.md`, and the date goes in a dated comment** (settled 03/10/2026,
17-story-plans grilling round 2 Q7; Key Decision 9), on the precedent of `./CONTEXT.md`'s comment of
08/09/2026: a hard-coded date would ship into every project generated afterwards. Each touched
file gains one comment dating its edit, which, like that precedent's, names no story, map or plan of
this repository, because the file ships. The story's Documentation Task carries the same answer.

**The thirteen register-index sites outside the map folder** (QA plan AC-GAP-1, re-measured
03/10/2026, every one's text unchanged since 30/09/2026):

- `../15-DECISIONS/CLAUDE.md:47` — the retired `ADR-###` counter has no index, and the decision
  index is the register's index.
- `./CLAUDE.md:64-68` and `:74`; `./00-STORY-PLAN-US000-TEMPLATE.md:16` and `:626` — name the
  story-plan index rather than saying the folder holds none.
- `project-management/workflows/17-story-plans/CLAUDE.md:97-101`;
  `project-management/workflows/17-story-plans/STEPS.md:43`, `:106-107` and `:240-243`;
  `project-management/workflows/17-story-plans/CHECKLIST.md:132-133`;
  `project-management/workflows/17-story-plans/CONTEXT.md:63-64`, `:95-96` and `:104-106` — name the
  story-plan index rather than deferring to work that has landed.

**The seven programme-plan sites** — `./CLAUDE.md:11`, `:72` and `:81-82`; `./CONTEXT.md:18` and
`:25`; `./00-STORY-PLAN-US000-TEMPLATE.md:254` and `:714-715` — lose their permission for a
cross-cutting programme plan. One instance pattern remains, `[0-9]{2}-STORY-PLAN-US[0-9]{3}-*.md`
(settled 27/09/2026, grilling round 6 Q32 and Q33).

**The template is edited in place, one line for one line.** Its line numbers are cited elsewhere —
**nineteen live citations in seven files, measured 03/10/2026**, `:254` five times and `:626`
twice — and its own closing note records the practice that keeps them true. Where a removal
cannot keep the line count (the `:254-256` and `:713-715` blockquotes are three lines each), the
replacement text holds the same number of lines; failing that, every live citation of a later
template line is re-pointed in the same change.

**The seed-count sites and the updating guide.**

- The seven sites that count the seed task's files as nine —
  `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:22`, the `--trust` disclosure;
  `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md:146`, `:162` and `:167-179`;
  `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md:29-45`; `how-to/src/TEMPLATE-GUIDE/15-TROUBLESHOOTING.md:87`;
  and `how-to/src/TEMPLATE-TOKENS.md:528` — count the files as the chain leaves them, measured from
  `copier.yml` at implementation, and where they list the files they list the seven index seeds
  (TM-13; settled 27/09/2026, grilling round 3 Q14).
- `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` gains two statements: a project generated before this
  story receives the routes to the seven indexes on update but never the files (TM-14); and
  `copier recopy`, or `copier copy` into an existing project, runs as copy and moves every blank
  seed over the project's own file, an uncommitted register edit being lost outright (TM-18). The
  wording is the build's; it promises no fix the template does not ship (settled 27/09/2026,
  grilling round 3 Q15). US015 rebases on these files after this story merges.

### P3 — The map commit

**One commit, holding every map edit and the map index that mirrors them** (settled 03/10/2026,
17-story-plans grilling round 1 Q1). In it:

1. **`../01-FEATURE-MAPS/MAP-000-TEMPLATE.md:4`** gains the fifth value, a one-line statement of
   the `<enum> · <prose>` format with the value plain, and each value's test from the map's own
   counts, `Blockers clear` winning the one overlap (settled 27/09/2026, grilling round 3 Q18 and
   round 6 Q31). `:8` and its checklist line `:159` name the map index.
2. **Every map's `**Status**` header** is re-derived by measurement against those tests and written
   `<enum>` or `<enum> · <prose>` on the key's own line — the first line beginning with the key,
   never a fixed number, never a table row. All fifteen are re-derived, the three that parse among
   them: the progressive-enhancement map reads `Charting` over a frontier closed 31/08/2026 (EC-04).
   Two headers wrap onto a second line (EC-06) and three carry middle dots in their prose (EC-05).
3. **Every map's Gate-to-stories index-row box** is ticked where the row now exists, its text naming
   the map index, or left unticked with a reason still true after this story; none still cites
   `N-001`. **All three decline rationales** recorded in `GAPS.md`'s entry of 01/09/2026
   (re-measured 17/09/2026) are disposed of, not only the one with an owner.
4. **Every map's `Umbrella ADRs` header row**, re-measured now, stops asserting the retired no-ADR
   rule and routes to `../15-DECISIONS/CLAUDE.md`.
5. **The in-tree map index**, one row per map, **re-counted at this commit** under the positive
   test: tracked `MAP-*.md`, the template and the index excluded by exact filename (QA plan Section
   6). Each row's Status is the read rule applied to the header this same commit writes; its
   `Updated` is the map's last commit date — this commit's author date for every map it edits,
   written with the intended date and **re-checked once the commit exists** (EC-03); each tail count
   equals its source; each Summary is one line of plain English for someone who has not read the
   map. Rows descend by `**Charted**`.
6. **`../01-FEATURE-MAPS/CONTEXT.md`** — `## Map index` (`:43-51`) becomes `## The index`, linking
   the map index; the `:53-56` prose about the scale-planning map's missing row is retired; the
   `:11` tree annotation names the index file. **`../01-FEATURE-MAPS/CLAUDE.md:6`, `:21-22`, `:25`
   and `:51`** name it too.
7. **`.claude/skills/wayfinder/SKILL.md`** — `:97-98` and `:256` name the map index, and the chart
   step gains one line: writing a map's first node fills its `**Charted**` date and moves its
   `**Status**` out of `Not started` to the value its counts give — `Charting` while
   `Blocking open` is above 0, otherwise `Blockers clear — stories may start` — never asserting
   `Charting`. Its placement among the CHART steps is the build's;
   `.claude/skills/scale-planning/SKILL.md` gains no line (settled 27/09/2026, grilling round 3 Q24;
   round 6 Q31; the reconciliation recorded 27/09/2026).
8. **`project-management/workflows/01-feature-map/STEPS.md:144` and
   `project-management/workflows/01-feature-map/CHECKLIST.md:98`** name the map index; the same
   checklist's `:64` is re-read and left alone where it already reads true.
9. **The link check's in-tree half**, over the seven in-tree indexes.

**Verify, do not re-cut.** `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`'s `S-01`, `S-02` and
`S-05` rows (`:349-353`) are read against the wording of that map's RESOLVE sitting of 27/09/2026
(settled 27/09/2026, grilling round 5 Q30) — `Story` cells filled, `S-01`'s seed row reading
`Not started`, `S-02`'s enum at five values. `S-05`'s "42 at cutting" stays known-stale, routed to
`01-feature-map`, and is recorded as such rather than corrected or read as a failed verification.

**Concurrent charting is expected.** `01-FEATURE-MAPS/` is shared with other sessions
(`.ai/INSTRUCTIONS.md` -> _Keep project execution consistent_), and the folder moved from 14 to 15
on the day this story was cut. Rebase onto `main` immediately before this commit, and re-count
then; a map that lands after the commit is the next session's row to add, under the instruction
this commit repoints (EC-22).

### P4 — Close

**P4 opens with one commit, the joined-line instruction search added to `[3/4]`**, as described
above, and its first run is read before anything else closes (Key Decision 13). Then the whole-tree
citation run is normalised the P0 way and diffed against the baseline by identity:
a new line in a file this story edits is this story's, one outside it is a concurrent change's,
named with its file. If `git hash-object` of the detector has moved since P0, the diff is reported
**detector-confounded**. If US004 has landed and the gate is green, the plain-pass reading applies.
ShellCheck over `.github/scripts/shipped-artefacts.sh` and `.github/scripts/shipped-registers.sh`,
and any Python lint over `.github/scripts/shipped-ai.py`, are recorded in the manual guide as run
or not run with the reason — never as a `lint.sh` pass (`code/src/scripts/syntax/lint.sh:262-265`).
The landing commit's `[3/4]` run ID is recorded. Then `22-implementation-documentation` walks the
guide and writes the records.

---

## Key Decisions

| #   | Decision                                                                                                                                 | Why, and what was rejected                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | **Mechanism first, then content repairs, then every map edit and the map index last in one commit**                                      | Keeps TM-15 `LOW` with each red visible in its own commit, and reads every map's `Updated` once. Rejected: one landing commit with the reds taken locally (no red is visible in history, and TM-15 promotes), and maps first (every later commit would move the dates the index just mirrored). Settled 03/10/2026, 17-story-plans grilling round 1 Q1. Round 2 Q4 adds one commit after the map commit, touching no map (Decision 13)                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 2   | **One generated-tree grep over all seven index files, built here; US011 adds none**                                                      | One check, one owner; US010's pattern already covers the four registers US011 fills. Rejected: US011 extending the pattern in place, and two separate steps. Settled 03/10/2026, 17-story-plans grilling round 1 Q2. US011's task is recorded `N/A — superseded` in US011's commit                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| 3   | **"A reader who has not read this story" is a fresh Claude session given only the index file, its walk reviewed by <%DEVELOPER_NAME%>**  | The only reader guaranteed not to have opened the artefacts in a one-developer repository; the guide template's sign-off already admits Claude with a human reviewer. Rejected: a person other than the developer (none is guaranteed), and the developer reading each line before opening its file. Settled 03/10/2026, 17-story-plans grilling round 1 Q3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 4   | **A route lands in the same commit as the file it routes to, or after it**                                                               | Follows from Decision 1: the map index lands in P3, so every instruction naming it lands there too, and no commit points a reader at a missing file. Rejected: all repoints in P2, which would leave the branch pointing at nothing between P2 and P3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| 5   | **Each probe in a commit of its own, before its check**                                                                                  | ST05 asks every new probe "seen red before it is seen green"; the threat model promotes TM-15 if a probe and its check share a commit. Rejected: a probe and its check together, proved red by a local revert — the red would exist nowhere in the record                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| 6   | **The completeness step's seven paths land first, alone; the fixture's six folders land next with the presence probe, before the seeds** | The red is then the presence assertion's own, never a `TaskError` from a missing folder (ES-09, ES-20), and the completeness red is seen before the shipped-ai step, which runs ahead of it, can mask it (`.github/workflows/audit-template.yml:165-166`, `:230-231`). The repair is in `fixture()`, which all three callers share, never a `mkdir -p` in `copier.yml` (settled 21/09/2026, grilling round 1 Q3). Rejected: both reds in one commit, where the completeness red is never reached                                                                                                                                                                                                                                                                                                                                                                |
| 7   | **The family's list of seven is a constant in the script**                                                                               | Derived from `copier.yml`, a seed removed with its `mv` line vanishes from both sides and the family is silent (QA plan ES-08, Section 6)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| 8   | **The story-plan template is edited one line for one line**                                                                              | Nineteen live citations of its line numbers (03/10/2026); its own closing note records the practice. Rejected: deleting the two programme-plan blockquotes outright, which shifts every later citation silently                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 9   | **The shipped `CONTEXT.md` files keep the copier date token in `**Last Updated**`; the date goes in a dated comment**                    | The story's Documentation Task asked each touched `CONTEXT.md`'s `**Last Updated**` date updated; every shipped one holds the token, `how-to/src/TEMPLATE-TOKENS.md:373` defines it as the doc's Last Updated date set per project, and `./CONTEXT.md`'s comment of 08/09/2026 records why a literal date is not written there and dates the update in the comment instead. Settled 03/10/2026, 17-story-plans grilling round 2 Q7, on that precedent; the story's Documentation Task is amended with a dated note citing Q7. Rejected: a literal date, which would ship into every project generated afterwards. The tree half of the task stands as written                                                                                                                                                                                                   |
| 10  | **The estimate stays 8 SP**                                                                                                              | Neither re-cut trigger has fired: no second `copier.yml` decision, and the third family is one family with one added clause (settled 27/09/2026, grilling round 4 Q26 and round 7 Q34). This plan adds no file the story's tasks do not already name                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| 11  | **The same reader reads the map index's Summaries**                                                                                      | Q3 names US011's Summary bar — someone who has not opened the artefact — as the same bar as the legibility one; this story's own Summary bar (its first manual criterion, "intelligible without opening the map"; QA plan HP-13, "a second reader") is that bar for the map index, and a fresh session given only the map index has opened no map. Settled 03/10/2026, 17-story-plans grilling round 2 Q6: the same fresh Claude session as Decision 3's, given only the map index, its walk reviewed by the developer (the guide's MAPINDEX-09). Rejected: a reader chosen separately for the Summaries, none other being guaranteed not to have opened the map — Decision 3's reason                                                                                                                                                                          |
| 12  | **The plan's Status is `Open`, blocked by nothing**                                                                                      | `../02-STORIES/US010.md` -> Dependencies, "None blocking", re-measured there 27/09/2026 against the widened write set                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| 13  | **The joined-line instruction search is a `[3/4]` step US010 adds, failing on any hit, in P4's first commit**                            | The search reads a generated tree, which exists only in `[3/4]`, and the sites P2 and P3 repair, so it lands after P3's commit. It prints its pattern and its output, fails on any hit, and is read at the walk by run ID (SITES-05). Proved by its landing run, as the generated-tree grep is: it has no probe, and TM-15's control ("every new check ships a probe seen red before it is seen green (ST05)") is read as ST05 and assessment 7.5 read it, binding probes; its one natural red, landing before P2, is ruled out by its placement after P3, so none is planted. Settled 03/10/2026, 17-story-plans grilling round 2 Q4. Rejected: the walker running it locally over the template's own shipped files, which departs from QA plan HP-18 and Section 6, and a step that only prints. QA plan HP-18 and Section 6 record the host since 03/10/2026 |
| 14  | **ES-08 is two findings; ES-02's `shipped-ai.py` red is `rmdir .copier`'s `TaskError`; the QA plan corrected in place**                  | The family's table fires the seed-exists and the wired clause on a seed and its line removed together, and the threat model's TM-06 has a seed left in `.copier/` fail `rmdir .copier` before any later assertion. Settled 03/10/2026, 17-story-plans grilling round 2 Q5, which had QA plan ES-02 and ES-08, and the TM-04 and TM-06 rows of its Section 5, corrected in place in this change. Rejected: asserting the QA plan as it read, one finding and the presence assertion, neither of which the built family and fixture would produce                                                                                                                                                                                                                                                                                                                 |

---

## Dependencies

| Story / Artefact                | Model / Feature                                                                                   | Required for                                                                               | Current state                                                                                  |
| ------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| **Nothing blocking**            | —                                                                                                 | —                                                                                          | Every node settled; no unshipped story creates a file this story needs (story -> Dependencies) |
| US011                           | Backfills four indexes this story ships                                                           | **Blocked by this story** — it has nothing to edit until the files exist                   | `Open`                                                                                         |
| US012                           | The check-4 `SEEDED` loop and its deletion probe                                                  | Neither blocks the other; whichever lands second extends the other's `SEEDED` comment      | `Open`, SPRINT-07                                                                              |
| US009                           | A grep inside the same `[3/4]` job                                                                | A rebase, never a wait (EC-19)                                                             | `Open`, SPRINT-05; its carry into SPRINT-06 has not landed                                     |
| US008                           | Rows in `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`'s register and a `24-release` checklist line | A rebase — neither is a line this story repairs                                            | `Open`, SPRINT-05                                                                              |
| US015 (provisional)             | Other lines of three guide files this story corrects                                              | This story merges first; US015 rebases (settled 27/09/2026, grilling round 3 Q14)          | Unplaced                                                                                       |
| The register-index map's `S-03` | The gate that reads these files                                                                   | Ships after US011, never between the two stories (settled 21/09/2026, grilling round 1 Q1) | Unscheduled (CUT-PLAN.md P8)                                                                   |

**Blocked by:** none. **Blocks:** US011, hard — SPRINT-07's Definition of Done holds it to US010
having landed. **Can be done now:** all of it, once the branch exists; P0 and P1 in particular need
nothing outside this story's write set.

---

## GDPR

**`N/A`, and the flag reads `N/A` in the story.** The indexes list planning artefacts; no field, no
store, no personal-data path, no data subject. `09-gdpr-compliance` did not run, and is recorded as
not run because its entry condition is absent — a different thing from a gate nobody thought about
(`code/docs/GATE-REPORTING.md`).

---

## Security

**Live, and the subject is the generation seam, not an endpoint.** No state-changing endpoint is
introduced, so no permission or ownership check is owed (OWASP A01 has no subject here); the
access-control content is the seed boundary and the write boundary.

### The findings, and the zero that is a reading

`../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` raised
**eighteen threats across all six STRIDE categories: 0 CRITICAL, 0 HIGH, 4 MEDIUM, 12 LOW,
2 INFO**, signed off 28/09/2026. That zero is a present-state reading of a template repository with
one developer, no index seed and no generated project holding an index — never "the security gate
passed". **Three promote to `HIGH`** on named events (Section 3a): TM-01 when the chain is next
split, reordered or given a second task in a release a filled project updates across; TM-03 when a
seed is refreshed from its in-tree sibling after US011 has written rows there; TM-04 when the
first generated project fills an index. **Four more promote to `MEDIUM`**: TM-14 and TM-18 on
their triggers, and TM-06 and TM-15 if an `mv` line gains a flag or **a probe is edited in the same
commit as the check it proves** — the event this plan's P1 order exists to prevent.

### The fifteen constraints, mapped to phases

`../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md` Section 7.
7.1 to 7.8 are the story's ST01 to ST08; the implementation assessment closes each with evidence.

| Section | Constraint                                                                      | Built in         | Proved by                                                                                      |
| ------- | ------------------------------------------------------------------------------- | ---------------- | ---------------------------------------------------------------------------------------------- |
| 7.1     | Seven lines inside the one copy-gated task, no second task                      | P1.2             | The family's wired clause, statically; the update probe and its mutation, behaviourally — ST01 |
| 7.2     | Every line ahead of `rmdir .copier`, which stays `rmdir`                        | P1.2             | Read in the diff — ST02                                                                        |
| 7.3     | Seeds blank, and the blankness proved by the third family                       | P1.2, P1.5       | The family and its probes — ST03                                                               |
| 7.4     | No seed names a syntek-base instance; the one permitted row; the row agreeing   | P1.2, P1.5       | The seed-row clause, the generated-tree grep, and review — ST04                                |
| 7.5     | No write outside the eleven named paths; existing probes unchanged; red first   | P0 to P3         | `git diff --name-only` against the P0 SHA; the probe diff; the recorded reds — ST05            |
| 7.6     | No negation re-includes an index path, by glob semantics                        | P1.5             | The negation clause's literal and glob-form probes — ST06                                      |
| 7.7     | The fixture's folders; byte-identity over changed seeds; red with the gate gone | P1.1, P1.3, P1.4 | `shipped-ai.sh --self-test` — ST07                                                             |
| 7.8     | The one-line form                                                               | P1.2             | Read in the diff; the family's wired clause — ST08                                             |
| 7.9     | One read rule for all seven carriers                                            | P2, P3           | Each index's `## How to read a row`; the row-by-row walk                                       |
| 7.10    | The map Status format and its count-derived values                              | P3               | The derivation walk, recorded per map                                                          |
| 7.11    | The TM-10 window tracked in `GAPS.md`                                           | —                | US011's gate-`22` pass, not this story's                                                       |
| 7.12    | `SEEDED` described as an allowlist wherever cited                               | P1.2             | Read in the diff                                                                               |
| 7.13    | The seven seed-count sites counted truly                                        | P2               | Re-read against `copier.yml`                                                                   |
| 7.14    | What a project generated before this story receives, documented                 | P2               | Re-read of the updating guide; its fix routed to `GAPS.md` at gate `22`                        |
| 7.15    | What a recopy does, documented                                                  | P2               | Re-read of the updating guide; its fix routed to `GAPS.md` at gate `22`                        |

**7.6 and 7.7 are the two to read first**: 7.6 closes the only leak the existing gates cannot
report, and 7.7 is the only constraint whose naive implementation would pass while proving nothing.

---

## Logging & Observability

**`N/A`, and the flag reads `N/A`.** This story emits no log line. The CI scripts print findings
to a terminal, and a terminal report is not a log. TM-17 — nothing records who changed an index
row — is an accepted residual: `code/docs/security/AUDIT-TRAIL.md` covers the application, not a
register file.

---

## Performance, Rendering, Responsive & Accessibility

**All four are `N/A`, each for its own reason.** Performance: the grep, the link check and the
joined-line search added to a job that already generates two projects; no request path. Rendering
and responsive: no rendered surface — Markdown read in an editor or a repository browser. Accessibility: no interactive component, but
one property is worth holding — each Instance link is labelled with a descriptor or an identifier
rather than a filename, the index's version of link purpose being clear from the link text (WCAG
2.2 success criterion 2.4.4; QA plan Section 3, EC-13).

---

## Implementation Workflows & Standards

### PM workflow chain (in order)

`02-story-creation` ✅ → `03-sprint-planning` ✅ → `10-security-checks` ✅ (`Signed off`
28/09/2026) → `11-qa-checks` ✅ (`Signed off` 30/09/2026, corrected in place 03/10/2026) → `15-decisions` ✅ (both records
`Accepted`) → `16-sprint-plans` ✅ (`../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md`, 03/10/2026) →
`17-story-plans` **(this plan)** → `19-backend-code` → `22-implementation-documentation` →
`23-pr-and-review` → `24-release`.

**`20-api-code` and `21-frontend-code` are skipped, and the skip is the reading**: no Ninja surface,
no MCP tool, no rendered page. `04` to `09`, `12`, `13` and `14` did not run, each because its
entry-condition flag reads `N/A`. **`19-backend-code` is entered even though `Backend` reads
`N/A`**, because it is the phase `01-implement-story` is entered at and this story has a build lane
— bash, YAML and one Python CI probe (`../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` -> _The lane this
story actually runs in_).

### Code workflows invoked

`01-implement-story` wraps the build, with `02-tdd-cycle` in its probe-first form: every new probe
is written, committed and seen red before the check it proves. **No stack skill applies** — the
diff is Markdown, YAML, bash and a CI probe outside the Django tree. `07-review` gates the PR.

### Standards gates

| Gate                          | Applies                                                                                                                                                                                           |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/doc-references.sh`    | **Yes** — baseline by identity at P0, scoped runs per edited file, the whole-tree diff at close                                                                                                   |
| `audits/docs-length.sh`       | **Yes** — every bound file the change edits: the seven register `CONTEXT.md` files, the six workflow files, three register `CLAUDE.md` files and the wayfinder skill; and `--path .claude/skills` |
| `audits/skill-conformance.sh` | **Yes** — P3 edits `.claude/skills/wayfinder/SKILL.md`, and `.claude/skills/CLAUDE.md`'s definition of done requires it to exit 0                                                                 |
| `audits/docs-pairing.sh`      | **Yes, and more than regression** — an index file must not be mistaken for either half of a pair                                                                                                  |
| `audits/doctrine-drift.sh`    | Regression only — a green run says the registered claims are undisturbed, and **nothing** about the indexes agreeing with their registers                                                         |
| `syntax/lint.sh`              | **Yes, for Markdown.** Its legs are ruff, markdownlint-cli2, ESLint and clippy; none reads bash, and ruff reads `code/src/django/` only (`:262-265`)                                              |
| `syntax/format.sh`            | **Yes** — Prettier over every changed Markdown file                                                                                                                                               |
| `syntax/check.sh`             | **Regression only** — basedpyright reads `code/src/django/` (`pyproject.toml:184`), and this story's Python sits outside it                                                                       |
| **ShellCheck**                | **Yes, and by hand.** No project script, CI workflow or lefthook entry runs it. Recorded as run or not run                                                                                        |
| `tests/all.sh --coverage`     | Regression only — no application Python, so the floor has nothing to bind                                                                                                                         |
| `audits/routing-skills.sh`    | `N/A` — no routing frontmatter is added                                                                                                                                                           |
| `audits/dict-discipline.sh`   | `N/A` — no application Python                                                                                                                                                                     |
| `audits/css-tokens.sh`        | `N/A` — no CSS                                                                                                                                                                                    |

---

## Execution & Verification via Claude Dynamic Workflows

### Stage 0 — Plan verification (before any code)

This plan is read against the story, both ADRs, the threat model, the assessment and the QA plan,
and every line number in it is re-resolved by quoted text before it is believed. Every number here
was measured on 03/10/2026 at `282ec0b`; a later commit moving one before the branch is cut is the
expected case, not the surprising one — the 18-TESTS split moved eight of the story's sites on
30/09/2026.

### Stage 1 — Build (the probe-first inner loop)

Per check: write the probe → commit it → see it fail **for the stated reason** → write the check →
see it pass → scoped citation gate. A probe that fails because its own path is wrong proves
nothing, and looks identical in a CI log.

### Stage 2 — Continuous verification gates

After every meaningful change: `bash code/src/scripts/syntax/format.sh --fix --file-type markdown --path <file>`,
`bash code/src/scripts/syntax/lint.sh --file-type markdown --path <file>`,
`bash code/src/scripts/audits/doc-references.sh --path <file>`, and the self-test of whichever
script changed. **Every gate is scoped to this story's paths**: concurrent sessions share
`01-FEATURE-MAPS/` and SPRINT-07's members may be in flight in a sibling worktree.

### Stage 3 — Review (before raising the PR)

`code-reviewer` for standards and spec, `qa-tester` for the hostile pass, and `security` — not
optional here, because the story's subject is a one-way door. **No skill reviews its own work**:
each is dispatched independently, naming the skill in the prompt.

### Stage 4 — Behavioural verification

The manual guide, walked: the CI runs read by their recorded IDs, the scratch-copy rows in a
separate checkout, never this working tree.

### Stage 5 — PR and release

`23-pr-and-review` → `24-release`. No release-time obligation: no version key, no migration entry.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**This story runs no container.** Every gate it needs runs on the host; the generated trees are
CI's.

### Canonical commands

| Purpose                   | Command                                                                           |
| ------------------------- | --------------------------------------------------------------------------------- |
| Markdown lint             | `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <file>`         |
| Format                    | `bash code/src/scripts/syntax/format.sh --fix --file-type markdown --path <file>` |
| Citation gate, scoped     | `bash code/src/scripts/audits/doc-references.sh --path <file>`                    |
| Length gate               | `bash code/src/scripts/audits/docs-length.sh --path <file>`                       |
| Pairing gate              | `bash code/src/scripts/audits/docs-pairing.sh --path <dir>`                       |
| The seed family           | `bash .github/scripts/shipped-registers.sh` and `--self-test`                     |
| The update probe          | `bash .github/scripts/shipped-ai.sh --self-test`                                  |
| The generated-tree checks | CI's `[3/4] Template Generation` job only — read by run ID                        |

### The two exceptions, and why each is allowed

1. **`.github/scripts/*.sh` run directly.** They are the project's own wrappers for the template
   seam, and `shipped-registers.sh` and `shipped-ai.sh` run locally as well as in CI (QA plan
   Section 6). `shipped-artefacts.sh` reads a generated tree, which no project script makes
   locally, so it is read in CI and never run here — and **no raw `copier` invocation is improvised
   to make one** (`.claude/CLAUDE.md` Section 6).
2. **ShellCheck, run by hand.** No project script wraps it. Running it directly is the only way to
   run it at all; not running it leaves two widened scripts unlinted.

---

## Testing

**No pytest, no coverage figure, no migration check** — each recorded `N/A` with its reason. There
is no application Python in this diff.

### Automated

| Criterion                                                                                                                                     | Where it runs                            |
| --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `shipped-artefacts.sh --self-test` with eight `SEEDED` entries — not leaks, never "landed"                                                    | `[3/4]` only — it needs a generated tree |
| `shipped-registers.sh --self-test` — nine existing probes unchanged; at least one per new clause, two for the negation clause, each red first | Locally and `[2/4]`                      |
| The `[3/4]` job on every render path; the completeness step naming all seven                                                                  | `[3/4]`                                  |
| `shipped-ai.sh --self-test` — all seven land; byte-identity over changed seeds; red with the gate gone                                        | Locally and `[3/4]`                      |
| The generated-tree literal grep — one step, all seven files (Q2)                                                                              | `[3/4]`                                  |
| The joined-line instruction search — pattern and output printed, red on any hit, landing after P3 (Q4)                                        | `[3/4]`                                  |
| The link check, in-tree and generated                                                                                                         | `[3/4]`                                  |
| `docs-pairing.sh`, `docs-length.sh`, `doc-references.sh` as a baseline diff                                                                   | Locally                                  |

**The `shipped-artefacts.sh --self-test` criterion is labelled "Unit" in the story and is still
CI-only**: its baseline run is the generated tree passed as its argument. It is read from the
`[3/4]` run, never made a local step.

### Manual testing

- `../18-TESTS/MANUAL/US010-MANUAL-TESTING.md` — authored from the specs beside this plan at
  `17-story-plans` Step 7.2, on 03/10/2026. A pointer, never a list of its own. Its rows meet the
  story's eight _QA Acceptance Criteria — Manual_ and exercise or name every QA-plan scenario; the
  reader of the legibility rows is a fresh Claude session given only the index file, its walk
  reviewed by <%DEVELOPER_NAME%> (Decision 3), and the same reader takes the map index's Summaries
  (Decision 11). The four rows that awaited the developer after Step 9 — SITES-05, FAMILY-09,
  FAMILY-11 and MAPINDEX-09 — are written from the answers to round 2 (Q4 to Q6, 03/10/2026), so
  the guide holds no open question and every row is an oracle.

---

## Documentation Write-Ups (Implementation Records)

Owned by `../../workflows/22-implementation-documentation/`, **not by this story**. Named so the
implementer knows what that workflow will ask for.

| Record                                      | Destination                                                                                 | This story                                                                                   |
| ------------------------------------------- | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| This plan                                   | `./`                                                                                        | Always — this file                                                                           |
| Manual testing guide                        | `../18-TESTS/MANUAL/US010-MANUAL-TESTING.md`                                                | Always — authored at Step 7.2, walked at `22`, verified at `23`                              |
| Automated test record                       | "project-management/src/18-TESTS/AUTOMATED/US010-TEST-STATUS.md"                            | Always — written at `22`; the no-test block's reason is that no application code path exists |
| QA implementation review                    | `../11-QA/IMPLEMENTATION/`                                                                  | Always — every scenario closed with evidence                                                 |
| Security assessment and threat model (impl) | `../10-SECURITY/ASSESSMENTS/IMPLEMENTATION/`, `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` | Always — 7.1 to 7.8 and 7.13 to 7.15 closed; any fired trigger re-assessed                   |
| Code review record                          | `../19-REVIEWS/`                                                                            | Always                                                                                       |
| Findings                                    | `../20-FINDINGS/`                                                                           | Conditional — one per guide row amended at the walk                                          |
| ADR, schema, GDPR, SEO, API, logging        | —                                                                                           | Not required — no decision is raised here, and each flag reads `N/A`                         |
| Release                                     | repo root                                                                                   | Conditional — at `24-release`                                                                |

**And the register writes, all gate `22`'s, each dated the day it is written**: `GAPS.md`'s entry of
01/09/2026 closed against the shipped change; four entries opened — TM-14's seed-if-absent update
migration, TM-18's guard refusing an existing target, the memory-survival probe's blind case, and
the one entry naming the three sprint-plan prerequisite defects. The TM-10 window's entry is
US011's.

---

## CONTEXT.md & Index Updates

| File                                      | Change                                                                                                                                                                                                                                                                              |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` | The US010 row in _Story Plans — the code master_ names this file, its Status cell filled as that plan's section defines the column; the Must table's two cells and the Branch row — **Step 10 of `17-story-plans`, not the build**                                                  |
| `../02-STORIES/US010.md`                  | References this plan and its guide on its _Dependencies_ sprint-membership line, the `10-` reservation recorded in an inline comment beside them — not under _Decisions_, so that no line of the story moves under fifty-nine explicit citations in six other records — **Step 10** |
| `./CONTEXT.md`                            | **Nothing at this gate** (Step 10 item 2). **The build rewrites its `:86-96` in P2** to describe the story-plan index it creates; this plan's row in that index is US011's backfill (`S-05`), the file shipping with its `Backfill owed` line until then                            |
| The seven register `CONTEXT.md` files     | P2 and P3, as above — trees gain the index file; `**Last Updated**` keeps the copier date token and the edit is dated in a comment (Decision 9)                                                                                                                                     |
| `GAPS.md` / `DEFERRED.md`                 | Gate `22` only; `DEFERRED.md` gains nothing — every row under _Deferred Items_ was already someone else's                                                                                                                                                                           |

---

## Status Propagation & ClickUp Sync

`../02-STORIES/US010.md`'s `**Status:**` moves `Open` → `In Progress` at the first commit on
`us010/seeded-register-indexes`, and → `Completed` only at `completion`, after review and QA.
This plan's `| Status |` row moves with it. **The sprint plan's Story Plans cell does not mirror
it**: it reads `Not started`, the value that column's own comment defines, knowingly false and
counted in `../02-STORIES/US007.md` Scenario 8's population, whose correction is US007's own
criterion. The ClickUp export is opt-in and not wired in this repository; nothing is pushed.

---

## Deferred Items

| Deferred                                                                  | To                                        | Why                                                                                                 |
| ------------------------------------------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Backfilling `STORY`, `SPRINT`, `DECISION` and `STORY-PLAN` indexes        | US011 (`S-05`), SPRINT-07                 | The split made at `02-story-creation` on 20/09/2026; each file names US011 until then               |
| The index gate, `N-003` and `N-004`                                       | `S-03`, unscheduled                       | Red on the four debt-carrying indexes if run before US011 (settled 21/09/2026, grilling round 1 Q1) |
| TM-14's seed-if-absent update migration                                   | `GAPS.md`, through gate `22`              | A second `copier.yml` decision, the 13 SP trigger (settled 27/09/2026, grilling round 3 Q15)        |
| TM-18's guard refusing an existing target                                 | `GAPS.md`, through gate `22`              | The same, and at odds with ST08's one-line form                                                     |
| The memory-survival probe's blind case                                    | `GAPS.md`, through gate `22`              | Its second tag never changes the memory seed (settled 27/09/2026, grilling round 3 Q16)             |
| The flag-blind sprint-plan prerequisites and the unwritten gate-`11` rule | `GAPS.md`, through this story's gate `22` | Routed here by `16-sprint-plans`; repairing them is outside this story                              |
| The TM-10 window                                                          | US011's gate `22`                         | It opens when US011 ships                                                                           |
| `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:420-421`'s ordering sentence  | `S-03`'s cutting gate                     | Contradicts `N-003`'s presence clause; left as found                                                |
| `S-05`'s "42 at cutting" (`:353`)                                         | `01-feature-map`                          | Outside the RESOLVE sitting of 27/09/2026; known-stale, not this story's to correct                 |
| Who changed an index row (TM-17)                                          | **Nothing — accepted residual**           | `INFO`; a register file is not the audit trail                                                      |

**Nothing here is deferred _by_ this story in the `DEFERRED.md` sense** — each row was already
someone else's, named so it is not absorbed.

---

## Risks

| Risk                                                                                                                                          | Likelihood                    | Impact   | Mitigation                                                                                                                                                                                                                               |
| --------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A probe lands in the same commit as its check**, so it has never been seen to fail and TM-15 promotes                                       | Medium                        | **High** | P1's commit table; every red recorded by SHA and run ID in the guide before the check lands                                                                                                                                              |
| **A seed is refreshed from its populated in-tree sibling** (TM-03's trigger)                                                                  | Low today, rising after US011 | **High** | The family's no-instance-row clause and the generated-tree grep, both permanent (Decision 2)                                                                                                                                             |
| **A squash at promotion rewrites every map's last commit date**, and every map-index `Updated` with it                                        | Medium                        | Medium   | No merge-strategy rule exists in `project-management/docs/git/`. `Updated` is re-checked after the landing commit exists, and again at `23-pr-and-review` against the merged commit; a mismatch is a row edit, never a map edit          |
| **The map folder moves under a concurrent session** before or during P3                                                                       | High                          | Low      | Rebase and re-count immediately before P3's commit (EC-02); nothing in any criterion holds a count                                                                                                                                       |
| **A template line edit shifts nineteen citations**                                                                                            | Medium                        | Low      | Decision 8 — one line for one line, or re-point every later citation in the same change                                                                                                                                                  |
| **US012 lands first** and its last-entry probe moves onto an index seed                                                                       | Medium                        | Low      | Either order goes green (EC-18); the `SEEDED` comment is extended, never replaced; P0 and the landing commit each record which story had landed                                                                                          |
| **A `CONTEXT.md`, `CLAUDE.md`, workflow file or the wayfinder skill crosses the 270 ratchet**                                                 | Medium                        | Low      | Read at P0, after each P2 commit and in P3's commit; a dated allowance or a trim, never an unexplained growth                                                                                                                            |
| **FAMILY-11's red is a `TaskError`, the same shape as the wrong-reason red ES-09 describes** — a walker could read one for the other          | Low                           | Low      | The row names the failing command, `rmdir .copier` on a seed left behind, never an `mv` into a missing folder; UPDATE-05's six folders rule out ES-09's cause, and the run's last lines are recorded beside the result (Key Decision 14) |
| **The joined-line search's pattern is written by the change it judges**, so a pattern too narrow for a site P2 or P3 missed passes in silence | Medium                        | Medium   | The step prints its pattern; SITES-05 reads it against QA plan Section 6's two halves and named phrases, because the step has no probe (Key Decision 13). A hit fails the job, so a pattern too wide is loud, never silent               |
| **A whole-tree gate run damages a sibling worktree's uncommitted work**                                                                       | Medium                        | Medium   | Every `--fix` scoped with `--path`                                                                                                                                                                                                       |

---

## Docker & Nginx Infrastructure

**N = 10.** `how-to/docs/GIT-WORKTREES.md:63-65` fixes the loopback rule — the final octet equals
the story number — so the IP is `127.0.0.10`. **Verified free 03/10/2026**:
`git grep -E '127\.0\.0\.10([^0-9]|$)'` returns no tracked hit at `282ec0b`, nor over the tracked
files this change edits, re-run after its last edit; once it is committed, this plan's own lines are
the only hits, and no sibling plan names it.
Subnets follow `code/src/docker/CONTEXT.md` -> _Network subnet scheme_: second octet the story
number, third octet 1 for dev and 0 for test — `10.10.1.0/24` and `10.10.0.0/24`, also unused.

| File                                            | Purpose                                                                                                                                                                      |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us010.dev.yml"  | Dev stack override — from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us010`; nginx on `127.0.0.10:3080:80`; subnet `10.10.1.0/24` |
| "code/src/docker/docker-compose.us010.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us010`; `127.0.0.10:3081:80`; subnet `10.10.0.0/24`       |
| "code/src/docker/nginx/dev-us010.conf"          | Named per `./CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                  |
| "code/src/docker/nginx/test-us010.conf"         | Same                                                                                                                                                                         |

**The two Nginx files are named because this folder's rule names them, and the docker layer says
they do not exist**: `code/src/docker/nginx/CONTEXT.md:28-29` states `dev.conf` and `test.conf` are
`server_name _` catch-alls a worktree stack reuses unchanged. **And the stack is very likely never
started** — this story runs no container. The overrides are specified because `./CLAUDE.md`
requires them of every plan and the worktree is still where the branch is developed.

`/etc/hosts`, if the stack is ever started:
`bash code/src/scripts/development/hosts-story-add.sh us010`.

---

## Sprint Verification Checklist

- [ ] `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <each changed .md>` — clean
- [ ] `bash code/src/scripts/syntax/format.sh --fix` scoped to the changed paths — clean
- [ ] `bash code/src/scripts/audits/doc-references.sh --path <each changed file>` — no new finding
- [ ] `bash code/src/scripts/audits/doc-references.sh` whole tree — diffed against P0 **by
      identity**, never by count, and never reported as a pass while the baseline stands
- [ ] `bash code/src/scripts/audits/docs-length.sh` and `docs-pairing.sh` over the changed tree
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` and
      `bash code/src/scripts/audits/docs-length.sh --path .claude/skills` — both exit 0, because P3
      edits `.claude/skills/wayfinder/SKILL.md` (`.claude/skills/CLAUDE.md` → definition of done)
- [ ] `bash .github/scripts/shipped-registers.sh` and `--self-test` — exit 0, the nine existing
      probes unchanged; at least one new probe per clause — two for the negation clause, a literal
      and a glob-form negation — each red first and its red recorded
- [ ] `bash .github/scripts/shipped-ai.sh --self-test` — exit 0, the ungated-seed-task mutation
      rejected on the byte-identity message
- [ ] The `[3/4] Template Generation` job green on every render path on the landing commit, its run
      ID recorded: completeness, `shipped-artefacts.sh` and its self-test, the grep, the link check
      and the joined-line instruction search
- [ ] The joined-line instruction search added in a commit after P3's, printing its pattern and an
      empty output on every render path, and failing on any hit (Key Decision 13)
- [ ] **ShellCheck by hand** over `.github/scripts/shipped-artefacts.sh` and
      `.github/scripts/shipped-registers.sh`, and the Python probe's lint, recorded as run or not
      run — **never as a `lint.sh` pass**
- [ ] `bash code/src/scripts/syntax/check.sh` and `bash code/src/scripts/tests/all.sh` — regression
      only, recorded as such
- [ ] The manual guide walked and signed off by a tester other than the author
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] The code-review-graph refreshed **after staging** (`code/docs/CODE-REVIEW-GRAPH.md`)

---

## Definition of Done

- [ ] Seven in-tree indexes exist with the spine, their tails, their ordering sentences and
      `## How to read a row`; the four debt-carrying ones name US011 and carry no placeholder row
- [ ] Seven seeds under `.copier/`, blank bar the map-index seed's one `Not started` row, moved by
      seven one-line lines inside the one copy-gated task ahead of `rmdir .copier`; no second task,
      no `mkdir`, no negation
- [ ] `SEEDED` holds eight entries and its comment calls it the allowlist check 3 reads
- [ ] The third family exists from check 10, six clauses, each with a probe whose red is recorded in
      a commit before its check; the nine existing probes byte-identical
- [ ] `shipped-ai.py` creates the six folders in `fixture()`, asserts all seven land, changes every
      seed between its tags, asserts byte-identity, and its ungated mutation is rejected for that
      reason — its red recorded
- [ ] One generated-tree grep over all seven index files, the link check and the joined-line
      instruction search, all three in `[3/4]`, the search landing after P3
- [ ] The map index carries one row per map counted at the map commit (P3); every row's Status,
      `Updated`, tail counts and Summary verified by the walk
- [ ] Every map header re-derived, every box disposed of across all three rationales, every
      `Umbrella ADRs` row swept — in one commit with the map index
- [ ] Every repaired site re-read; the programme-plan permission gone; the seed counts true; the
      updating guide's two statements present and promising no fix
- [ ] Assessment Sections 7.1 to 7.8 and 7.13 to 7.15 closed with evidence, 7.9, 7.10 and 7.12
      shown carried, 7.11 left to US011; any promotion trigger that fired re-assessed in
      `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/`
- [ ] `S-01`, `S-02` and `S-05` verified, not re-cut
- [ ] The `GAPS.md` closure and four openings written by gate `22`, never from here
- [ ] Every gate above run and recorded per `code/docs/GATE-REPORTING.md`; nothing skipped silently
