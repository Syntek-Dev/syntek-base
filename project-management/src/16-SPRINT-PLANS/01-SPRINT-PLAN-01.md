# SPRINT-PLAN-01 — Two rules get one owner each before anything writes against them

<!-- Titled "The homes and the headroom wave 1 writes into" from 02/09/2026 until 07/09/2026, when
     US002 — the headroom — moved to SPRINT-02 and US007 was admitted here. Retitled to follow the
     goal, for the reason the goal comment below gives. -->

**Last Updated**: 07/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> · **Capacity:** 5 SP Must + 5 SP Must = 10 / 11 · **Stories:** 2

<!-- Read "Capacity: 8 SP · Stories: 2" from 02/09/2026 until 07/09/2026, when US002 (Must, 3)
     moved to SPRINT-02 and US007 (Must, 5) was admitted, before either sprint was worked. The
     member count is unchanged and the members are not. ../03-SPRINTS/SPRINT-01.md was re-planned
     the same day, and this plan mirrors it.

     WHAT THIS EDIT IS, AND IS NOT. It is the sprint-plan half of the six-artefact discipline the
     US003 move of 05/09/2026 set — membership, capacity, goal, build order, the flag union and the
     index brought into line with the record, so the two do not disagree. It is NOT a full
     16-sprint-plans run: CADENCE.md's prerequisite for that pass — every member cleared
     15-decisions — is not met by US007, which on 07/09/2026 has cleared 02-story-creation only.
     Every cell below that a 16 run fills from US007's 09–15 artefacts (its QA plan, its story plan,
     its branch) says so rather than inventing a value, and is filled when that loop completes. -->

---

## Sprint Goal

> Two rules get exactly one owner each before anything downstream writes against them — the story
> status vocabulary is defined in one document that every skill, workflow and template writing the
> field routes to, and cross-surface retry and idempotency doctrine lives in one owning guide that
> every pointer reaches.

<!-- The goal read "Cross-surface retry and idempotency doctrine gains one owning guide, and the
     audit register regains the room the next nine gates need to register themselves in." until
     07/09/2026. The audit-register headroom is now SPRINT-02's deliverable, and a goal naming a
     deliverable no member carries is the drift ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md's own goal
     comment names. Rewritten rather than trimmed, mirroring ../03-SPRINTS/SPRINT-01.md: the
     sprint's subject changed with its membership — both members now give a rule one owner. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`, so there is no schema to
> defer to and no flow to follow. The authorities this sprint actually defers to are
> `code/docs/DOCUMENTATION-LENGTH.md` and `code/docs/DOCUMENTATION-PAIRING.md` for what a
> documentation file may weigh and which half of a pair a line belongs in,
> `code/docs/GATE-REPORTING.md` for how a gate's result is reported, and — for US007's edit to
> `.claude/skills/completion/SKILL.md` — `how-to/docs/SKILL-AUTHORING.md`, the one home of the
> skill-authoring standard that `.claude/skills/CLAUDE.md` routes to and `skill-conformance.sh`
> enforces. Where a story's wording and those guides differ, the guides win.

## Sprint Reference Documents

| Area               | Source                                                                                                                                                                                                                                                                               |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Sprint definition  | `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only -->                                                                                                                                                                                                                  |
| User stories       | `../02-STORIES/US007.md` <!-- doc-references: template-only --> · `../02-STORIES/US001.md`                                                                                                                                                                                           |
| Database           | **N/A** — both stories read `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                                                                                                    |
| User flows         | **N/A** — both stories read `User Flow: N/A`; no user journey in scope                                                                                                                                                                                                               |
| Brand & components | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                                                                                          |
| Wireframes         | **N/A** — both read `Wireframes: N/A`; no screen                                                                                                                                                                                                                                     |
| GDPR               | **N/A** — both read `GDPR: N/A`; no personal-data path                                                                                                                                                                                                                               |
| Security           | **N/A** — both read `Security: N/A`; no protected action and no new endpoint                                                                                                                                                                                                         |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — **Signed off** · US007's — **not yet written**: it is authored when US007's `11-qa-checks` gate runs, and this row is filled then                                                                                   |
| SEO                | **N/A** — both read `SEO: N/A`; no public page                                                                                                                                                                                                                                       |
| API design         | **N/A** — both read `API: N/A`; no Django Ninja surface                                                                                                                                                                                                                              |
| Logging            | **N/A** — both read `Logging: N/A`; no log line                                                                                                                                                                                                                                      |
| Decisions          | `../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` <!-- doc-references: template-only --> · `ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` · `ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` · `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` |
| **Story plans**    | `../17-STORY-PLANS/STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — written 02/09/2026 · US007's — **does not exist**: `17-story-plans` has not run for it, and no path is invented here                                                                                             |

<!-- 07/09/2026: the User stories, QA and Story plans rows named US002, its QA plan
     (../11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md, signed off) and its story plan
     (../17-STORY-PLANS/STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md, written 02/09/2026) until the
     story moved to SPRINT-02. All three are indexed from ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md
     from this re-plan on. The Decisions row is unchanged in its list: US007's own Decisions
     section rests on exactly these four records. -->

**Every `N/A` above is a flag reading `N/A` in both stories, not a gate anyone forgot** — the
distinction `code/docs/GATE-REPORTING.md` requires. Twelve of the thirteen flags are `N/A` in both
stories; only `QA` is live, and `Backend` and `Frontend` are among the twelve, which is why the
phase breakdown below is mostly empty.

<!-- Read "Eleven of the thirteen flags are N/A in both stories; only QA is live, and
     Backend/Frontend are N/A too" until 07/09/2026 — a miscount that summed to fourteen. The
     population is unchanged by the move; the sentence is corrected in passing. -->

**Two ADRs in the set were authored by stories that are not members of this sprint, and both bind
US007.** `../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` was written for
US002, now in SPRINT-02, and US007 applies its rule to `doctrine-drift.sh` — a gate that can read
the files under test but decides none of the question stays in the manifest, narrowed.
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` was written for US003, now
SPRINT-02's stretch, and its Decision states it binds **every story in this backlog until the gate
is green**; US007's own Decisions section says it binds US007 "not only US003", and extends the
same treatment to `skill-conformance.sh`. US001 predates both and is deliberately left as it
stands, per the citation record's own Consequences.

<!-- Read, until 07/09/2026: "**One ADR in the set is not this sprint's.**
     ../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md was written for US003 in
     SPRINT-02, and its Decision states it binds every story in this backlog until the gate is
     green. US002 honours it; US001 predates it and is deliberately left as it stands, per that
     record's own Consequences." US002 has left, US007 honours the record in its place, and
     ADR-US002's record is now an inherited one too. -->

---

## Stories

### Must

| ID    | Title                                                                                                          | Phases touched           | SP  | Story plan                                                        | Git branch                                             |
| ----- | -------------------------------------------------------------------------------------------------------------- | ------------------------ | --- | ----------------------------------------------------------------- | ------------------------------------------------------ |
| US007 | The story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits | Docs only — no code lane | 5   | _none yet — `17-story-plans` has not run for US007_               | _not yet set — fixed by its story plan's `Branch` row_ |
| US001 | Reliability doctrine gets an owning guide, and every pointer reaches it                                        | Docs only — no code lane | 5   | `../17-STORY-PLANS/STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` | `us001/reliability-doctrine-home`                      |

**Total: 10 SP against a capacity of 11.** The sprint is closed at two members by decision rather
than by fill (07/09/2026) — `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> → _Notes_ carries the reasoning, and
the reading it rests on: `project-management/docs/planning/CADENCE.md` → _Sprint capacity_ says
capacity is a trigger and not a target, and "a sprint that lands on 10 SP because the next story is
a 5 is a correct sprint, not an under-filled one" — ten is now that case to the letter.

<!-- US002's row — "The audits register regains the headroom nine new gates need · Docs only —
     no code lane · 3 · ../17-STORY-PLANS/STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md ·
     us002/audits-register-headroom" — sat first in this table from 02/09/2026 until 07/09/2026,
     when the story moved to SPRINT-02 before either sprint was worked. Removed rather than struck
     through, on ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md's precedent for US003: the total below
     the table is computed from it. That total read "**Total: 8 SP against a capacity of 11.**
     The sprint is closed at two members by decision rather than by fill" — closed at eight on
     02/09/2026, reopened and closed again at ten on 07/09/2026. -->

### Should

_None. The sprint is closed._

### Could

_None._

### Won't (this sprint)

- **US002** — the audits register regains the headroom nine new gates need. This plan's first
  member from 02/09/2026 until 07/09/2026, when it moved to `../03-SPRINTS/SPRINT-02.md` <!-- doc-references: template-only -->,
  where it opens that sprint at `Must`, 3 SP, ahead of US003. It left because US007 has to ship
  before it — the constraint under _Build order_ below — and <%DEVELOPER_NAME%> chose a cascade over
  a reorder. Recorded here as a `Won't` rather than left absent, because a story this plan carried
  must stay findable from it — the precedent `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` set for
  US003 on 05/09/2026. Its story plan, QA plan and branch are indexed from that plan from this
  re-plan on; its nine-registration unblocking table is in `../02-STORIES/US002.md`.
- **US003** — the absence guide, `../01-FEATURE-MAPS/MAP-ABSENCE.md` <!-- doc-references: template-only --> slice `S-01`. Deferred from
  here to SPRINT-02 on 02/09/2026 rather than admitted: at 5 SP it would have taken this sprint to
  the grace ceiling rather than its capacity, and grace exists for a story that would split badly,
  not as a routine allowance. **That refusal stands after the re-plan** — this sprint is at ten with
  two `Must` members, and US003 sits in SPRINT-02 as its `Should` stretch, having gone SPRINT-02 →
  SPRINT-03 on 05/09/2026 and back on 07/09/2026, with its 5 SP carry reserved into SPRINT-03. Not
  a `DEFERRED.md` row — it is scheduled, not deferred.

<!-- The US003 bullet read, until 07/09/2026: "The third wave-0 Must, deferred to **SPRINT-02** on
     02/09/2026 rather than admitted here: at roughly 5 SP it would have taken this sprint to the
     grace ceiling rather than its capacity, and grace exists for a story that would split badly,
     not as a routine allowance." US003 has been a Should Have since 02/09/2026 and has moved
     twice since; the refusal's reasoning is the part that still stands. -->

---

## Build order — US007 before US001

**The two stories are independent.** They share no file: US007 writes into the planning guides,
the `completion` skill, three workflows, the PM templates, the live sprint records and plans, the
README seed and one map; US001 creates a new reliability family under `code/docs/` and repoints
three citations into it. Neither depends on the other, and neither waits on anything upstream —
both are wave 0 of their cutting orders.

**The order is nevertheless fixed — US007 first — settled 07/09/2026 and not re-derived here.** It
is a sequencing call, not a dependency inside this sprint: US007 must ship before US002, which now
opens SPRINT-02, because US002 unblocks `MAP-REGISTER-INDEXES.md` slice `S-03` — <!-- doc-references: template-only -->
`register-indexes.sh`, whose `broken/` + `clean/` status fixtures are built against whichever
vocabulary is canonical on the day they are written (`../02-STORIES/US007.md` → _Dependencies_).
Putting US007 first in this sprint means the vocabulary is settled before anything in this sprint
or the next writes a `**Status:**` value against it. That constraint is why US007 came here rather
than to SPRINT-04, and it makes SPRINT-01 → SPRINT-02 an execution order and not only a numbering
— the first pair in this backlog where the two agree.

**Within the sprint nothing fails if the order is reversed; across the boundary it is not
optional.** US001 carries no cross-sprint constraint of its own: what it unblocks — slices `S-02`
and `S-03` on the retry-and-idempotency map, the reliability half of `S-01` on the CAP-posture map,
and US005, now in SPRINT-04 — sits further out than SPRINT-02 either way.

**This plan keeps execution order `01`.** The blast-radius tiebreak that put US002 first no longer
has anything to decide between: both members are 5 SP, and the member whose position mattered for
blast radius has left the sprint.

<!-- The section read, from 02/09/2026 until 07/09/2026, under the heading "Build order — US002
     before US001":

     "**The two stories are independent.** US001 creates a new reliability family under code/docs/
     and repoints three citations into it; US002 shrinks code/src/scripts/audits/CONTEXT.md and its
     sibling. They share no file, so either order is correct and they may run in parallel.

     **US002 goes first on blast radius**, the same tiebreak the cutting order uses. It unblocks
     nine audit registrations across eight slices and seven maps; US001 unblocks three slices.
     Taking the smaller story first also surfaces any friction in the implement tier at 3 SP rather
     than 5.

     This is a recommendation with a stated reason, not a dependency. Nothing fails if the order is
     reversed."

     Superseded because US002 is no longer a member and the argument compared it with US001. The
     order it argued for now holds ACROSS sprints — US002 opens SPRINT-02, after this sprint — which
     is a stronger constraint than the tiebreak, not a reversal of it. -->

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. US001's plan exists;
US007's does not — `17-story-plans` has not run for it, and it is a prerequisite of implementation
this plan cannot supply. The Status column mirrors the story plan's own `Status` field, so a story
with no plan has no value to mirror.

| Story | Story plan (`../17-STORY-PLANS/`)                                                                                           | Status              |
| ----- | --------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| US007 | _none — US007's story plan does not exist on 07/09/2026; written by `17-story-plans` once US007 has cleared `15-decisions`_ | _no plan to mirror_ |
| US001 | `../17-STORY-PLANS/STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`                                                           | Not started         |

<!-- US002's row — ../17-STORY-PLANS/STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md, Not started —
     sat first in this table until 07/09/2026, when the story moved to SPRINT-02; its plan is
     indexed by ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md instead, and that plan's own | Sprint | row
     is owed a repoint from SPRINT-01 to SPRINT-02 by 17-story-plans.

     US001's cell still reads "Not started" — a value in no status set, and false against the
     plan's own line 9, which holds `Open`. It is left as this re-plan found it BY DESIGN:
     correcting it is US007's Scenario 8, which names this plan's "Not started" cells as the live
     mirror cells it changes, and a re-plan that moves membership does not pre-empt a scheduled
     story's own edit. US007 cites two such cells here at :109-110; after this edit there is one,
     US002's having left, and the story re-resolves its line numbers at implementation. -->

---

## Phase Breakdown

The four-phase sequence is kept whole, with the three empty phases marked `N/A` and their reason
given rather than deleted. **The emptiness is the information**: this sprint touches no runtime
surface at all, and a reader comparing it with a later code sprint should see that at a glance.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**Stories:** none — **N/A**, both stories read `Backend: N/A`
**Key deliverables:** none. No model, service, migration or management command is in scope.

### Phase 2 — API (`../../workflows/20-api-code`)

**Stories:** none — **N/A**, both stories read `API: N/A`
**Key deliverables:** none. No Django Ninja router, endpoint or Schema, and no MCP tool.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**Stories:** none — **N/A**, both stories read `Frontend: N/A`
**Key deliverables:** none. No template, component, HTMX partial or Alpine behaviour.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

**Stories:** US007, US001.
The only phase with content. Both stories are documentation changes verified by the audit suite
and by a recorded human read-across; there is no test suite to go green and no coverage figure to
report. **Five gates are in this sprint's QA union, and none of them reports a plain pass for both
members** — see _Sprint-wide Constraints_ below. `22-implementation-documentation` runs before this
phase and is a merge gate: it writes each story's `../18-TESTS/US###-MANUAL-TESTING.md`, closes
`GAPS.md`'s entry of 01/09/2026 and writes `DEFERRED.md`'s two US007 rows, as US007's own
Definition of Done provides.

<!-- Read "Stories: US002, US001" and "Two of the four gates a story of this shape would normally
     name cannot see this work" until 07/09/2026. The union had four gates; US007 brought the
     fifth, and the gate that was blind — doctrine-drift.sh over US002's files — left with US002. -->

---

## Sprint-wide Constraints

### GDPR (`../09-GDPR/`)

- **None this sprint.** Both stories read `GDPR: N/A`; neither introduces a field, a store or a
  code path that could carry personal data.

### Security (`../10-SECURITY/`)

- **None this sprint.** Both read `Security: N/A`. No state-changing endpoint, no permission
  check, no user-supplied ID, so neither the OWASP A01 nor the IDOR rule has a surface to bind.

### QA & SEO

- **QA:** US001 has a signed-off plan in `../11-QA/PLANNING/` with **no unresolved `AC-GAP`** —
  six found and six resolved. **US007 has no QA plan yet**: its `11-qa-checks` gate has not run,
  and this plan records that rather than ticking a box for it. The sprint's QA union **widened by
  one gate on 07/09/2026** — `skill-conformance.sh`, which enters with US007 alone — and narrowed
  by nothing: US002 was the sole carrier of no value, so its departure left the union where it
  stood. `../03-SPRINTS/SPRINT-01.md` → FLAGS comment carries the recomputation.
- **SEO:** **N/A** — no public page in either story.

<!-- The QA bullet read "both stories have a signed-off plan in ../11-QA/PLANNING/ and no
     unresolved AC-GAP — US001 found six and resolved all six; US002 found eleven from 24
     adversarially tested candidates and resolved all eleven" until 07/09/2026. -->

### Gate honesty — the constraint that is specific to this sprint

Five gates run, and **neither story may report a plain pass where the gate cannot decide the
question** — the rule `code/docs/GATE-REPORTING.md` states. Per gate:

- **`doc-references.sh` is red before either story starts.** It is read as an **identity diff**
  against a baseline captured before the first edit, never as exit 0 —
  `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, which binds every story
  in this backlog until US004, now in SPRINT-03, retires it. US007's Scenario 13 states the regime
  and captures the set by identity, an empty set recorded as empty. **US001's flat must-pass is
  inconsistent with this and is left standing deliberately**, per that record.
- **`skill-conformance.sh` is US007's alone.** `.claude/skills/CLAUDE.md` makes it the definition
  of done for any skill edit, and US007 edits `.claude/skills/completion/SKILL.md`. Read as an
  **attributed** identity diff against a baseline captured immediately before the first edit: a
  finding on any other skill is a concurrent change's, neither cleared nor inherited nor reported
  as US007's; an empty baseline with exit 0 at close is the pass, and is reported as one. US001
  edits no skill.
- **`doctrine-drift.sh` is a regression guard for both members, never a duplicate detector.** It
  reads fenced code only. US001's doctrine is prose
  (`../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`); US007's claims are prose
  and tables, and the gate can open the skill and workflow files it edits — so it stays in the
  manifest, narrowed, on `../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`'s
  rule. A green run says the registered claims are undisturbed and nothing about a rule stated in
  two homes.
- **`docs-pairing.sh` decides only for US001**, which creates the reliability family under
  `code/docs/` and its pair. US007 creates, splits and moves no pair, and reads the gate as an
  identity diff because another story landing can move it.
- **`docs-length.sh` binds both, and US007 measures with the gate, never `wc -l`** —
  `STORIES.md`, `SPRINTS.md` and `completion/SKILL.md` are re-measured with `--path … --limit 1`
  before and after the edit, because `wc -l` reports different figures for all three.

<!-- The first bullet read, until 07/09/2026: "**doctrine-drift.sh is blind to US002's files.**
     Its scan roots exclude code/src/scripts/**, so it cannot open either file US002 edits.
     Removed from that story's QA manifest and recorded N/A with its cause —
     ../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md. US001 keeps it,
     correctly: it reads US001's tree and was only ever blind to prose." The blind case left with
     US002; the ADR stays, because US007 applies its rule to the same gate in its other case —
     readable but undecidable — above. -->

---

## Sprint Verification Checklist

Run before closing the sprint. Every command is a project script under
`code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`, `pytest` or `docker` call.

```bash
bash code/src/scripts/audits/docs-length.sh
bash code/src/scripts/audits/docs-pairing.sh
bash code/src/scripts/audits/doc-references.sh
bash code/src/scripts/audits/doctrine-drift.sh
bash code/src/scripts/audits/skill-conformance.sh
bash code/src/scripts/syntax/lint.sh --file-type markdown
bash code/src/scripts/syntax/format.sh --file-type markdown
```

<!-- The template's default block runs migrate.sh, tests/backend.sh and syntax/check.sh. They are
     replaced rather than kept-and-ticked: this sprint ships no Python, so running them would
     report a pass over an empty population. Marked N/A below with the reason, per
     code/docs/GATE-REPORTING.md. skill-conformance.sh joined the block on 07/09/2026 with US007. -->

- [ ] `docs-length.sh` — no file created or edited this sprint enters the warn tier without a
      dated allowance. For US007, `STORIES.md`, `SPRINTS.md` and `completion/SKILL.md` are
      re-measured with `--path … --limit 1` before and after the edit, never with `wc -l`
- [ ] `docs-pairing.sh` — every new directory carries both halves, and neither half carries the
      other's headings. Only US001 gives it anything to decide; US007 reads it as an identity diff
- [ ] `doc-references.sh` — **read as a diff**, not as exit 0; no new finding against each story's
      recorded baseline, by identity rather than count
- [ ] `doctrine-drift.sh` — regression guard only, for both members; a green run is never reported
      as having checked prose
- [ ] `skill-conformance.sh` — no **new** violation attributable to
      `.claude/skills/completion/SKILL.md`, by identity against US007's captured baseline;
      US007's alone
- [ ] Markdown lint and format pass
- [ ] `migrate.sh check` — **N/A**, no story here touches a model
- [ ] `tests/backend.sh` and `tests/all.sh --coverage` — **N/A**, no story here ships a code path
- [ ] `syntax/check.sh` — **N/A**, no Python or type-checked source is added or edited
- [ ] OpenAPI schema at `/api/docs` — **N/A**, no endpoint changed
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] Every story's GDPR, security and SEO criteria signed off — **N/A**, each flag reads `N/A`

<!-- Until 07/09/2026 the docs-length box ended "and code/src/scripts/audits/CONTEXT.md has reached
     its target", and the doctrine-drift box read "run for US001; recorded N/A with its cause for
     US002". Both halves were US002's and moved with it to SPRINT-02. -->

---

## Sprint Definition of Done

- [ ] Both Must stories — US007 and US001 — implemented, tested and reviewed; each story plan's own
      DoD complete, US007's once `17-story-plans` has written it
- [ ] US007's own `**Status:**` header is the one field of its measured population that moves, to
      **Completed**; every other live source field holds the value it held before its first edit
- [ ] No open Critical or High security findings
- [ ] GDPR constraints implemented and verified — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] All QA scenarios passing per `../11-QA/`, including the human read-acrosses that no gate
      can perform for either story — US001's plan is signed off; US007's is written when its gate
      runs
- [ ] `GAPS.md`'s entry of 01/09/2026 closed and `DEFERRED.md`'s two US007 rows written, both by
      `22-implementation-documentation`, as US007's own Definition of Done provides
- [ ] All code merged to the integration branch; CI passing
- [ ] Sprint closed on the board; version bumped if this sprint produces a release
- [ ] Gaps found during the sprint recorded per `../09-GDPR/` / `../10-SECURITY/` where applicable
- [ ] `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> `**Status:**` moved to `Done` via the `completion` skill
- [ ] Retrospective notes captured in `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> (optional)

<!-- "Sprint closed on the board" is the template's clause, surviving here beside the Status row
     two lines below it. It is LEFT STANDING BY DESIGN: ../02-STORIES/US007.md -> Dependencies
     names this plan's board clause as left alone, owned by the sprint's own close under
     24-release, because the Status row already carries the repository-side condition and US007's
     board-neutrality work is scoped to what travels. It is not this re-plan's to fix either — a
     membership move edits the rows that name members. The first box read "Both Must stories
     implemented, tested and reviewed — each story plan's own DoD complete" until 07/09/2026; the
     US007-specific boxes mirror ../03-SPRINTS/SPRINT-01.md -> Definition of Done. -->

---

## Branch Naming Reference

| Story ID | Branch name                       | Pattern                                                                                                  |
| -------- | --------------------------------- | -------------------------------------------------------------------------------------------------------- |
| US007    | _not yet set_                     | as below — fixed by the `Branch` row of US007's story plan when `17-story-plans` runs; not invented here |
| US001    | `us001/reliability-doctrine-home` | `us` + 3-digit ID + `/` + title lowercased, kebab-cased, ≤ 5 words                                       |

<!-- US002's row — us002/audits-register-headroom — moved with the story to
     ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md on 07/09/2026. -->

**Both branches are cut from `main`, and not yet** (decided 02/09/2026, and doubly true on
07/09/2026). Every planning artefact these stories depend on — the stories, this plan, the QA
plans, the ADRs and the sprint record — is uncommitted on `pm/story-creation`, and US007's own
per-story loop has not finished, so a branch cut from `main` today could not see any of it. **The
sequence is: every story completes its planning workflows → `pm/story-creation` is raised as a PR
to `main` → the `us###/` branches are cut from `main` and the stories implemented.** A branch cut
earlier inherits a tree in which its own plan does not exist.

Full rules: `../../docs/GIT-GUIDE.md`.
