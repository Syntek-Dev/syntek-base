# SPRINT-PLAN-05 — The cookie doctrine lands with its advisory reaching a real operator, and the git hooks arm on purpose

**Last Updated**: 17/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-05.md` · **Capacity:** 8 SP Must + 5 SP Should = 13 / 11 — at the grace ceiling, the full 2 SP taken on 17/09/2026, **CLOSED** · **Stories:** 2

<!-- Written 17/09/2026 by a `16-sprint-plans` run, immediately after `15-decisions` closed for
     both members. The record said on 09/09/2026 that this plan stayed absent deliberately because
     the sprint had not filled at 8 of 11 SP; it filled the same day US009 was admitted and
     re-estimated, and US008's own Dependencies bullet was corrected in that change rather than
     deleted.

     Both segments of this file's name read `05`, and that is an AGREEMENT rather than a
     coincidence: ./CLAUDE.md rules that a mismatch between `<exec-order>` and `<sprint-number>` is
     deliberate information and must NOT be "corrected", so a reader who knows that guardrail
     should also know this pair was derived and found to agree. _Build order_ below shows the
     derivation. The plan MIRRORS the record; where the two would disagree the record wins, and the
     disagreement is named here rather than resolved by paraphrase. -->

---

## Sprint Goal

> The cookie doctrine lands and the git hooks arm on purpose — every cookie this deployable sets
> is host-only under a `__Host-` name with the CSRF cookie httpOnly, one guide owns that rule
> while the four that stated their own defer to it, and `install.sh` installs the pre-commit
> hooks as an explicit, reported step instead of leaving them to arm themselves at a moment
> nobody chose.

<!-- The record's `**Goal:**` line, verbatim, on ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md's
     convention that a plan carries the record's goal rather than a paraphrase so the two cannot
     drift. It is written in build order — US008 then US009 — for a sprint with two subjects. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`.
>
> The authorities this sprint defers to are `code/docs/GATE-REPORTING.md` for how a gate's result
> is reported, `code/docs/NEGATIVE-SPACE.md` for the one-named-enforcement-point rule the new gate
> clauses join, `.claude/CLAUDE.md` Section 6 for the `CORS_ALLOWED_ORIGINS` sentence that must
> survive US008's rewrite verbatim, and — new to this sprint —
> `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` as the contract the deploy repository
> consumes. `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` _The cookie spine_ (`:206-241`) is the
> argued record of the doctrine itself and is not re-opened here. Where a story's wording and
> those guides differ, the guides win.
>
> **This sprint has a prerequisite no story owns, and it is stated here because nothing else would
> carry it.** See _The tag this sprint waits on_ below.

## Sprint Reference Documents

| Area               | Source                                                                                                                                                                                                                                                                                                                                                          |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-05.md`                                                                                                                                                                                                                                                                                                                                    |
| User stories       | `../02-STORIES/US008.md` · `../02-STORIES/US009.md`                                                                                                                                                                                                                                                                                                             |
| Feature maps       | `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` slice `S-02` (US008) · `../01-FEATURE-MAPS/MAP-GATE-PARITY.md` slice `S-11` (US009)                                                                                                                                                                                                                               |
| Database           | **N/A** — both stories read `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                                                                                                                                                                               |
| User flows         | **N/A** — both read `User Flow: N/A`; no user journey in scope                                                                                                                                                                                                                                                                                                  |
| Brand & components | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                                                                                                                                                                     |
| Wireframes         | **N/A** — both read `Wireframes: N/A`; no screen                                                                                                                                                                                                                                                                                                                |
| GDPR               | **N/A** — both read `GDPR: N/A`; no personal-data path. A session cookie is an identifier, and the doctrine narrows who can read it rather than widening what is collected                                                                                                                                                                                      |
| Security           | **Live, both members, two artefacts each.** US008: `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` and `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md`. US009: the matching `THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` and `ASSESSMENT-PLAN-US009-HOOK-ARMING.md` under the same two folders |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` — **Reviewed**, ten gaps found, ten resolved · `../11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md` — **Reviewed**, nine found, nine resolved                                                                                                                                                                |
| SEO                | **N/A** — both read `SEO: N/A`; no public page                                                                                                                                                                                                                                                                                                                  |
| API design         | **N/A** — both read `API: N/A`; no Django Ninja surface and no MCP tool                                                                                                                                                                                                                                                                                         |
| Logging            | **N/A** — both read `Logging: N/A`; no log line. The advisory prints to a terminal, which is a report and not a log                                                                                                                                                                                                                                             |
| Decisions          | **Six ADRs bind this sprint** — three authored by US008 at `15-decisions` on 17/09/2026, one by US009 the same day, one by US008 on 09/09/2026, one inherited. A seventh is superseded. Listed under _Sprint-wide Constraints_                                                                                                                                  |
| **Story plans**    | **Both exist.** `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` — written 18/09/2026 under the reserved `08-` · `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — written the same day under the reserved `09-`, after a three-reviewer adversarial pass at Step 9. Both indexed here by that workflow's Step 10                            |

**Every `N/A` above is a flag reading `N/A` in both stories, not a gate anyone forgot** — the
distinction `code/docs/GATE-REPORTING.md` requires. Each skipped gate is recorded with its reason
rather than omitted.

**Eleven of the thirteen flags are `N/A` in both members, and `Backend` is the exception that makes
this sprint unlike the last one.** US008 reads `Backend: Yes` because it ships assignments in
`code/src/django/config/settings/` — **the first Python this backlog has touched**, and with it the
first sprint for which `code/src/scripts/syntax/check.sh` is not `N/A`. US009 reads `Backend: N/A`
and ships bash and one manifest edit. `Frontend` is `N/A` in both.

**Both QA plans read `Reviewed` rather than `Signed off`, and that word is reported as found.**
Their Step 1 grilling passes did not run when they were written on 17/09/2026, at
<%DEVELOPER_NAME%>'s direction; the interview ran later the same day at `15-decisions`, which is
where all nineteen gaps were settled and fed back. Each plan records the deviation in its own
header. The record treats both gates as closed; this plan mirrors the record and does not upgrade
the word.

---

## Stories

### Must

| ID    | Title                                                                                                  | Phases touched                          | SP  | Story plan                                                   | Git branch                |
| ----- | ------------------------------------------------------------------------------------------------------ | --------------------------------------- | --- | ------------------------------------------------------------ | ------------------------- |
| US008 | Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule | **Backend** + scripts, docs, migrations | 8   | `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` | `us008/host-only-cookies` |

### Should

| ID    | Title                                                                                           | Phases touched                   | SP  | Story plan                                             | Git branch          |
| ----- | ----------------------------------------------------------------------------------------------- | -------------------------------- | --- | ------------------------------------------------------ | ------------------- |
| US009 | The git hooks arm on purpose at install, and the README claim that they already do becomes true | Script + manifest — no code lane | 5   | `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` | `us009/hook-arming` |

<!-- 18/09/2026, `17-story-plans` Step 10 for US009: BOTH ROWS ARE NOW FILLED and this comment is
     fully discharged. US009's plan was written later the same day, and its `Branch` row fixes
     `us009/hook-arming` exactly as US008's fixed its own. Nothing here was invented.

     18/09/2026, Step 10 for US008, earlier the same day: US009's two cells were still deliberately
     unfilled — `17-story-plans` had not run for it. US008's were filled, which is this
     comment's own precedent applied rather than departed from:
     ../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md set it on 08/09/2026 — leave the cells as a stated
     absence, then fill them from the plan's own `Branch` row once that plan exists, taken from
     the plan and never invented here. US008's plan fixes `us008/host-only-cookies` in its
     `Branch` row and that is where this row's value comes from. US009's stayed unset until its
     plan did the same, which it now has.

     Superseded text, preserved rather than deleted — this comment read: "Both Story plan and Git
     branch cells are deliberately unfilled. `17-story-plans` has not run for either member, and
     ../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md set the precedent on 08/09/2026 for leaving them as a
     stated absence and filling them from the plan's own `Branch` row when it exists — taken from
     the plan, never invented here." -->

### Could

_None._

### Won't (this sprint)

- **`../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` slices `S-01`, `S-03` and `S-04`.** `S-01`'s
  rule section **defers cookie scope to the guide US008 rewrites**, so it is unblocked by this
  sprint rather than competing with it; `S-03` is dev/test host hygiene and `S-04` re-casts the
  Phase 2 table in a file US008 also edits, in a different section. None is cut into a story.
  **This record is closed to all three regardless**, at the grace ceiling.
- **The six-target map re-cut** — `:116`, `:118`, `:119`, `:120`, `:211` and `:447` of the same
  map. A separate `01-feature-map` correction on <%DEVELOPER_NAME%>'s 09/09/2026 ruling, not a
  story, and explicitly out of US008's scope.
- **`../01-FEATURE-MAPS/MAP-GATE-PARITY.md` slice `S-03`** — ships after `S-05`, not after US009.
  Named so the two halves of the split are not re-merged by a later reader.
- **The Bun swap** — `../01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md` puts `install.sh` inside its surface
  and stands at 29 open / 21 blocking, so it cannot produce a story. US009 ships against pnpm as
  the tree stands, and the swap re-reads the step when it earns a story.
- **The eleven unsuppressed `pnpm install` invocations** — one local hook and ten across five
  workflow files, measured 17/09/2026. `ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`
  declines them as its Option D. After US009 they no longer arm anything, because the script they
  ran is gone; the surface stays open for the next lifecycle script anyone adds, and `GAPS.md`
  carries it from 17/09/2026.
- **Repairing `shared-ai-symlinks.sh`'s missing `06-GENERATION.md` register row** — found while
  writing `ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` and filed as a `GAPS.md` row of
  17/09/2026. US008 establishes the **form** a row with no version takes, because its own
  unversioned entry needs one; it does not backfill the earlier entry's row.
- **Admitting a third story.** The record is at 13 / 11, the hard ceiling, and CLOSED. Anything
  arriving is refused on arithmetic before it is argued.

---

## Build order — US008 then US009, and both name segments read `05`

**This plan takes execution order `05`, and the number was derived rather than copied.** Neither
member has a blocking upstream dependency:

| Member | Blocked by                                                                                        | In  | Built at |
| ------ | ------------------------------------------------------------------------------------------------- | --- | -------- |
| US008  | Nothing — `MAP-SUBDOMAIN-ROUTING.md` records `Frontier open: 0 · Blocking open: 0 · Resolved: 26` | —   | —        |
| US009  | Nothing — verified 17/09/2026 across US001 to US008; none writes a file US009 writes              | —   | —        |

Every earlier sprint's members are built at `01` to `04`, so honouring the dependency chain and
honouring the sprint number give the same answer and both segments read `05`. A reader who finds
`05` on both should know it was checked rather than assumed.

**US008 builds first because it is the `Must`**, on `../../docs/planning/CADENCE.md`'s
one-story-at-a-time rule. US009 is the stretch tier and **the first work dropped if US008
overruns**; dropping it does not fail the sprint, which is the give this record has and SPRINT-04
did not.

**One dependency looks blocking and is not.** US008's whole-tree citation criterion would block on
US004 (SPRINT-03, Open), which is why `../15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md`
scopes the criterion to `doc-references.sh --path code/docs`, exit 0, plus one `--path <file>` run
for each shipped, scanned file the story edits outside that scope. The whole-tree figure is
executed and recorded, never claimed. **That record's enumeration of those files has grown**: it
named three on 09/09/2026, and this sprint's decisions add `code/src/scripts/development/template-update.sh`
and `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`, making five. The rule is unchanged and
the record is not superseded — only its list of instances is longer, which is a property of the
story rather than of the decision.

### The tag this sprint waits on

**`v7.6.0` must be tagged at `16aac54` before US008 writes its `copier.yml` entry.** This is a
sprint prerequisite, not a story task and not something any member owns — settled 17/09/2026.

`../15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` rules that a migration key is
**derived at release against `git tag`**, never carried from a design-time record, because that is
exactly how the record it supersedes was falsified eight days after it was written. Measured
17/09/2026: `VERSION` reads `7.6.0` on `pm/story-creation` and `7.5.0` on `main`; there are 77 tags
and the newest is `v7.5.0`; `CHANGELOG.md`'s `## [7.6.0] - 14/09/2026` describes the shared-AI /
Codex release and nothing else. **No generated project has ever resolved to 7.6.0**, so the damage
is prospective — and it becomes real the moment `v7.6.0` is tagged for a release that does not
carry this doctrine, which is precisely what is about to happen and should.

The sequence this plan requires:

1. `pm/story-creation` merges, and **`v7.6.0` is tagged at `16aac54`** — the commit its CHANGELOG
   entry actually describes.
2. **Everything committed above `16aac54`** — scrapling at `fff578f`, the PM work at `1e00a4b`,
   the Playwright pin at `806dc4a`, and whatever lands after them — plus both members of this
   sprint become the **next minor**, which owes a `CHANGELOG.md` entry; `## [Unreleased]` was
   empty on 17/09/2026. Stated as "everything above `16aac54`" rather than as a list of commits,
   because the branch is still moving and a list goes stale the next time it does.
3. US008 derives its key against `git tag` **at that moment**. `v7.7.0` is the expected value as
   the tree stands today; it is a prediction, and writing an untagged number into `copier.yml` is
   the unverified claim the ADR exists to stop.

**If step 1 is skipped the story breaks silently**, which is what makes it a prerequisite rather
than a note. Owned by the `release` and `version` skills, tracked here.

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. **Both plans now
exist.** US008's was written 18/09/2026 by `17-story-plans` under the `08-` reserved for it on
09/09/2026; US009's was written later the same day under the `09-` reserved for it on 17/09/2026,
after a three-reviewer adversarial pass at Step 9 that returned six blocking findings, all
resolved. This table was repointed at each by that workflow's Step 10, in the order they were
written.

| Story | Story plan (`../17-STORY-PLANS/`)                            | Status      |
| ----- | ------------------------------------------------------------ | ----------- |
| US008 | `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` | Not started |
| US009 | `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`       | Not started |

The run on disk is contiguous `00-` to `09-`. **The prefix is the story's position in the settled
build order across the whole backlog, not its sprint and not a per-sprint counter** — US008 eighth,
US009 ninth — and it is renumbered whenever that order changes; `../17-STORY-PLANS/CLAUDE.md` owns
that rule.

<!-- 18/09/2026, `17-story-plans` Step 10 for US008 — THE STATUS COLUMN, AND THE POPULATION IT
     JOINS. This table carried no Status column until today. It was written on 17/09/2026 as
     `Story | Reserved prefix | Position in the settled build order` because neither plan existed
     and there was nothing to index; it now takes the house shape the other four live sprint plans
     use. Superseded text, preserved rather than deleted — the section opened "**Neither member's
     plan exists.** `17-story-plans` runs after this plan, and both prefixes are reserved rather
     than assigned by this file:", the US008 row read "`08-` | Eighth across the whole backlog",
     the US009 row "`09-` | Ninth across the whole backlog", and the closing paragraph opened "The
     run on disk is contiguous `00-` to `07-`."

     THE US008 CELL READS "Not started" BY DESIGN, and the value is KNOWINGLY FALSE: it is a value
     in no status set anywhere in this repository, and the plan it points at carries `Open` in its
     own `| Status |` header row, which is NOT mirrored here. It takes that value on the rule
     ../02-STORIES/US007.md Scenario 8 already states — "re-counted immediately before the edit, a
     plan written between now and then joining the population and taking the same rule" — and on
     the precedent ../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md set for US006 on 08/09/2026. Correcting
     the value is US007 Scenario 8's OWN ACCEPTANCE CRITERION: US007 is scheduled in SPRINT-01 and
     still reads `Open`, and a new plan does not pre-empt a scheduled story's acceptance criterion
     any more than a re-plan does. ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md's verbatim-mirror
     `Open`/`Open` is the second live convention and is deliberately NOT followed here, for the
     same reason; the shipped template's legend {Draft / Ready / In Progress / Done} is a fourth
     vocabulary and is not used either.

     THIS ROW ADDS TO THE POPULATION SCENARIO 8 COUNTS, flagged here so the addition is not
     silent. RE-MEASURED 18/09/2026 across the five live sprint plans, immediately before this
     edit: SIX `Not started` cells — US007 and US001 in ../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md,
     US002 and US003 in ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md, US005 and US006 in
     ../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md — which makes this cell the SEVENTH. Six is exactly
     what ../02-STORIES/US007.md anticipated at its 08/09/2026 re-count ("SIX once the plan's own
     row lands in the first"), and that row has since landed.

     AND THE US009 ROW IS THE EIGHTH, added later the same day at that story's own Step 10. The
     condition this comment named hours earlier — "it joins the population if `17-story-plans`
     writes US009's plan before US007 ships and the row then takes the same value" — HAS BEEN MET.
     Its plan exists, it carries `Open` in its own `| Status |` header row, and that value is NOT
     mirrored here for the same reason US008's is not. RE-COUNTED 18/09/2026 immediately before
     that edit: SEVEN cells stood (the six above plus US008's), so US009's makes EIGHT. Flagged so
     neither addition is silent.

     The story owner re-counts immediately before their own edit rather than inheriting this
     figure — Scenario 8 already says so, and this plan added two cells to it in one day.
     ../02-STORIES/US007.md is NOT edited by this pass. -->

**That is the opposite of the rule governing this file's own name.** `./CLAUDE.md` says a sprint
plan is `<exec-order>-SPRINT-PLAN-<sprint-number>.md`, two numbers, and that a mismatch between
them is deliberate information that must never be "corrected". A story plan carries one, so its
prefix must track build order or it says nothing. Do not read either guardrail across to the other
folder.

---

## Phase Breakdown

**One story enters a code lane and one does not.** The four-phase backend → API → frontend → PR
sequence in `project-management/docs/planning/SPRINTS.md` maps stories by the layers they touch.
The phases neither story touches are recorded as `N/A` with a reason rather than deleted, per
`code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**US008 only.** Five settings assignments across three modules under
`code/src/django/config/settings/` — `CSRF_COOKIE_HTTPONLY = True` in `base.py`, and the two
`__Host-` cookie names in each of `staging.py` and `production.py` beside their `SECURE = True`
lines — plus one widened comment and six rows in that folder's `CONTEXT.md` table.

**No new Python test is written, deliberately.** The gate clause is the invariant's one named
enforcement point (`code/docs/NEGATIVE-SPACE.md`), and a pytest assertion over the same five values
would be a second enforcer of the same rule, which is the shape that guide forbids. `dev.py` and
`test.py` are unchanged by this story, asserted on the diff.

**US009: N/A** — it reads `Backend: N/A` and ships no Python.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema, and no MCP tool. Both read `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. Both read `Frontend: N/A`. The CSRF token still
reaches HTMX through the template, which US008 asserts and does not change.

### The lane these stories actually run in

| Story | Deliverable                                                                                                                                                                                                                                                                                                                              | Proven by                                                                                                                                                                                                                         |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| US008 | Five settings assignments across three modules; three `negative-space.sh` clauses with the real scope and the self-test scope moved together and a fixture pair grown on both sides; **two** `_migrations:` entries and scripts; an additive report block in `template-update.sh`; five guide rewrites; an `EDGE-REQUIREMENTS.md` clause | `negative-space.sh --self-test` over a widened fixture pair, `check.sh` and the Python leg of `lint.sh`, plus four manual walks — the baseline capture, the five-document read-across, the advisory dry run and the preview proof |
| US009 | One step at the end of `install.sh`'s Phase 1, a `usage()` renumber across two phases, the removal of `package.json`'s `prepare` and an announcing `postinstall`                                                                                                                                                                         | A pre-commit probe, a no-`.git` negative case, a worktree probe and a `postinstall` notice probe, plus three manual walks — clean clone, idempotence, and a failure walk                                                          |

**This sprint ships its first Python and its first executable authentication-shaped surface, and
the manual checks are still load-bearing.** Neither member's headline risk is reachable by any
suite this repository runs: US008's is a browser silently discarding a cookie after a clean
three-way merge, and US009's is a hook arming at a moment nobody chose. The walks in
`../03-SPRINTS/SPRINT-05.md` → _Tasks_ are the only place either is observed, and they are not
ceremonial.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

Both stories, US008 then US009, each behind its own gate. `22-implementation-documentation` runs
between the lane above and this phase and is a merge gate: it writes each story's test-status and
manual-testing records under `../18-TESTS/`, and it owns this sprint's register writes — the
`GAPS.md` **closure** of the 09/09/2026 preview-blindness row that US008 now repairs, and the two
`GAPS.md` **openings** of 17/09/2026, for `shared-ai-symlinks.sh`'s missing register row and for
the eleven unsuppressed `pnpm install` invocations.

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in each story's acceptance criteria and the spec it
cites.

### GDPR (`../09-GDPR/`)

**N/A.** Both flags read `GDPR: N/A`. No personal data is collected, stored or exported by either
member. US008 narrows which hosts may read an existing session identifier; it adds no field, no
retention question and no lawful-basis question.

### Security (`../10-SECURITY/`)

**Live for both members, four artefacts, and no `CRITICAL` or `HIGH` in either.** Fifteen threats
across all six STRIDE categories for US008, twelve across five for US009. **That zero is a measured
outcome with its reason, never "the security gate passed"** — every threat resolves to `MEDIUM` or
below _because this repository deploys nothing and no generated project is known to be live_, and
each model names the event that promotes it. **Five promote to `HIGH` in each story.** Nothing was
written to `../10-SECURITY/VULNERABILITIES/PLANNING/`, and neither gate blocks on severity.

Three findings that shape what this sprint builds:

- **TM-03/TM-04 (US008)** — the merge hazard is the sprint's highest-consequence threat, and the
  advisory is its only mitigation. The channel that delivers it is repaired **inside** US008.
- **TM-05 (US008)** — `__Host-` has an edge precondition. Django emits the cookie's `Secure`
  attribute from the setting (`django/contrib/sessions/middleware.py:74`,
  `django/middleware/csrf.py:264`, Django 6.1.0), so that half is gated here; the dependency runs
  through `SECURE_SSL_REDIRECT` and `request.is_secure()`, which trusts a client-suppliable header.
  The requirement lands in the deployment contract because **no gate in this repository can see
  it**.
- **TM-01 (US009)** — the story as originally specified did not deliver its own User Story. Fixed
  by removing `prepare`, which is a scope decision rather than a severity one.

### QA (`../11-QA/`)

**Nineteen acceptance-criteria gaps found across the two members — ten and nine — and all nineteen
are `[RESOLVED] 17/09/2026`**, each fed back into its story as an acceptance criterion or a task.
Five were blocking: three on US008 and two on US009. `../11-QA/PLANNING/CLAUDE.md` gates a sprint
plan on exactly this, and the gate is satisfied rather than waived.

**One gap was corrected rather than carried.** `QA-PLAN-US008` AC-GAP-3 and TM-05 both stated that
Django takes the cookie's `Secure` flag from `request.is_secure()`. It does not. The finding
survives the correction and its severity is unchanged; the mechanism is corrected in both artefacts
because **the mechanism is what the next reader reuses**.

### SEO (`../12-SEO/`)

**N/A.** Both flags read `SEO: N/A`. No public page, route or metadata surface is added or changed.

### Decisions binding this sprint

| ADR                                                                         | Authored at                | What it binds                                                                                |
| --------------------------------------------------------------------------- | -------------------------- | -------------------------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md`          | `15-decisions`, 17/09      | Two `_migrations:` entries, gated on state and on version; the key derived at release        |
| `../15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md`       | `15-decisions`, 17/09      | The `template-update.sh` preview repair, inside US008; and the rule beyond it                |
| `../15-DECISIONS/ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md` | `15-decisions`, 17/09      | The edge precondition, and the `EDGE-REQUIREMENTS.md` clause that carries it                 |
| `../15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`   | `15-decisions`, 17/09      | `prepare` removed, `install.sh` the sole arming path, the announcing `postinstall`           |
| `../15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md`          | `02-story-creation`, 09/09 | US008's citation criterion is the scoped run; the whole-tree figure is recorded, not claimed |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`       | Inherited                  | Binds every story in this backlog until the gate is green; both supersession fields read `—` |

**One record is superseded and is named rather than dropped.**
`../15-DECISIONS/ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026.md` reads `Superseded` since
17/09/2026, cross-linked both ways by full filename. Its body is unchanged — only `Status:` and
`Superseded by:` moved — because its reasoning is not re-derived by its replacement and a reader
who meets the dual-gating decision should be able to read what it replaced. Its key and its
Option E are the two things that moved; the rule that a key names the release the change shipped
in, whatever the tier, survives intact, and so does its `Template.migration_tasks()` proof.

**All six binding records read `Accepted`** as of 17/09/2026. The story's ADR set was checked
pairwise at `15-decisions` and no two clash.

### Gate honesty — the constraint specific to this sprint

`code/docs/GATE-REPORTING.md` applies to every sprint; three readings are specific to this one and
must not be softened in any record it produces.

- **The whole-tree citation gate is inherited red and this sprint does not move it.** US004 has not
  landed. The criterion is the scoped run; the whole-tree figure is captured before the first edit,
  recorded with HEAD and the detector's `git hash-object`, and read as a **per-citer diff** —
  never as a total, and never as the gate passing.
- **US009's story file carries ten pre-existing `[instance citation]` findings** and reads exit 1
  under `--path`. Measured 17/09/2026 as a before/after diff against HEAD: **identical token set,
  zero introduced** by the `15-decisions` edits. Report it that way or not at all.
- **ShellCheck has no project script.** `lint.sh`'s legs are ruff, markdownlint-cli2, ESLint and
  clippy; no script under `code/src/scripts/`, no CI job and no lefthook entry runs ShellCheck as
  of 17/09/2026. Both members ship bash. It is run by hand and recorded in `../18-TESTS/` **as run
  or as not run**, never as a `lint.sh` pass.
- **A green `negative-space.sh` run proves a directory, not a global rule.** Three assignment sites
  sit outside `code/src/django/config/settings/` and are invisible to it. The owner guide says so,
  and no record may read the green run as proof the rule holds everywhere.

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, `pnpm`, `uv` or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-05.md` → _Verification Checks_ and is not restated here.

- [ ] `bash code/src/scripts/audits/negative-space.sh --self-test` exits 0 — US008's; `EXPECTED`
      holds fourteen names, `broken/settings/` trips all three new clauses, `clean/settings/` trips
      none, and the new fixtures are asserted **inert** for the eleven pre-existing clauses
- [ ] `bash code/src/scripts/audits/negative-space.sh` (unscoped — `--path` is refused) exits 0
      after the settings land, with none of the three new clauses in its skip notes
- [ ] `bash code/src/scripts/syntax/check.sh` passes — **the first sprint for which this is not
      `N/A`**; US008 ships Python
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — the Python leg via ruff over three settings
      modules, the Markdown leg over the documents both members edit
- [ ] `bash code/src/scripts/tests/all.sh` is green — the test settings module still imports and
      every existing test passes. No new Python test is added, for the reason under _Phase 1_
- [ ] `doc-references.sh` — read per _Gate honesty_: the scoped `--path code/docs` run exits 0, one
      `--path <file>` run per shipped scanned file edited outside that scope (five, not three), and
      the whole-tree figure recorded as a per-citer diff with its index state beside it
- [ ] `docs-length.sh` — the five guides stay clear of the 270 ratchet;
      `code/src/scripts/audits/CONTEXT.md` is **not grown**, measured at **299 of 300** on
      17/09/2026 and not 298, which nineteen artefacts under `../` still assert
- [ ] `docs-pairing.sh` passes — US008 edits both halves of the settings pair; neither member
      creates a directory, so no new pair is owed
- [ ] ShellCheck over `negative-space.sh`, both migration scripts, `template-update.sh` and
      `install.sh` — **recorded as run or as not run**, never as a `lint.sh` pass
- [ ] The `[3/4] Template Generation` job is green on both answer sets, and the generated
      `install.sh` carries US009's step in each
- [ ] US009's pre-commit, no-`.git`, worktree and `postinstall` probes pass — **not wired into the
      generation job**, which never executes the generated `install.sh`
- [ ] `migrate.sh check` — **N/A**, neither member touches a model
- [ ] `routing-skills.sh` — **N/A**, neither member adds routing frontmatter
- [ ] Cross-browser, responsive and accessibility (WCAG 2.2 AA) walk-throughs — **N/A**, this
      sprint adds no page, component or interactive surface
- [ ] US008's four manual walks: the baseline captured **before** the first edit and balanced at
      close; the five-document read-across with the `CORS_ALLOWED_ORIGINS` sentence confirmed
      verbatim; the advisory dry run against a scratch tree with `SESSION_COOKIE_DOMAIN` planted;
      and **the preview proof** — a successful `template-update.sh` preview showing the migration
      report before its "Preview only" line
- [ ] US009's three manual walks: clean clone then commit with the legs observed; a second
      `install.sh` run proving idempotence; a broken `lefthook install` proving exit 2
- [ ] A tester other than the author has signed each walk-through off
- [ ] No secrets, debug flags or hardcoded IDs introduced — both advisories print file paths, line
      numbers and setting names and **never a value**
- [ ] All security acceptance criteria signed off — **applies to both members**
- [ ] GDPR, Logging and SEO criteria — **N/A**, each flag reads `N/A` in both stories

---

## Sprint Definition of Done

- [ ] **The `Must` story is Completed — US008.** Its plan's own DoD complete and verified by a
      reviewer, once `17-story-plans` has written it
- [ ] **US009 is Completed, or is dropped with its reason recorded in both records.** It is the
      stretch tier and the first work dropped if US008 overruns; dropping it does not fail the
      sprint. This is the give SPRINT-04 did not have
- [ ] **`v7.6.0` is tagged at `16aac54`, and US008's migration key was derived against `git tag`
      at the moment it was written** — not carried from any record, including the one that settled
      the rule. See _The tag this sprint waits on_
- [ ] The next minor's `CHANGELOG.md` entry covers **everything committed above `16aac54`** plus
      both members — `## [Unreleased]` was empty on 17/09/2026, and the branch was still taking
      commits from a second session that day
- [ ] All sprint-level verification checks passed
- [ ] **No open Critical or High security finding.** Zero of each in both members at design state;
      any finding whose promotion trigger fired during the sprint is re-assessed in
      `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at its present-state severity
- [ ] No `[OPEN]` gap remains in either member's QA plan — nineteen resolved on 17/09/2026, and
      none reopened
- [ ] GDPR constraints implemented and verified — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Both stories' implementation records written by `22-implementation-documentation`;
      `GAPS.md`'s 09/09/2026 preview-blindness row **closed**, and its two 17/09/2026 rows open
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-05.md` `**Status:**` set to `Done`
- [ ] Retrospective notes captured in `../03-SPRINTS/SPRINT-05.md` (optional) — **and one subject
      is named in advance**: this is the second sprint of five to run at the grace ceiling.
      `.claude/skills/sprint/SKILL.md` warns that a sprint _habitually_ running to grace means the
      ceiling is wrong, and `../../docs/planning/CADENCE.md` names revisiting both figures against
      measured velocity as the check

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story | Branch                                                                                 |
| ----- | -------------------------------------------------------------------------------------- |
| US008 | `us008/host-only-cookies` — the `Branch` row of US008's story plan, written 18/09/2026 |
| US009 | `us009/hook-arming` — the `Branch` row of US009's story plan, written 18/09/2026       |

Neither is invented here. `17-story-plans` sets each, and this table is filled from the plan when
it exists — the precedent `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` set on 08/09/2026. US008's was
filled that way on 18/09/2026, taken from its plan's `Branch` row, and US009's the same day from
its own. **Neither table cell now carries a placeholder**, and the precedent is discharged.

**Both branches are cut from `main`, and not yet**, on the reasoning
`../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` recorded on 02/09/2026. Every planning artefact these
stories depend on — the stories, this plan, the QA plans, the threat models, the four ADRs of
17/09/2026 and the sprint record — is uncommitted on `pm/story-creation`, so a branch cut from
`main` today could see none of it. The sequence is: every story completes its planning workflows →
`pm/story-creation` is raised as a PR to `main` → **`v7.6.0` is tagged at `16aac54`** → the
`us###/` branches are cut from `main` and the stories implemented.

**That third step is new to this sprint** and is the one a reader is most likely to skip, which is
why it appears in the sequence rather than only in its own section.
