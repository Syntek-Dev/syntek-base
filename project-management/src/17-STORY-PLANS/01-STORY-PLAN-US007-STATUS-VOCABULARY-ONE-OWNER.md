# STORY-PLAN-US007 — The story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits

| Field  | Value                               |
| ------ | ----------------------------------- |
| Date   | 08/09/2026                          |
| Branch | `us007/status-vocabulary-one-owner` |
| Sprint | SPRINT-01 · Wave 0 · build order 1  |
| Author | <%ORG_NAME%>                        |
| Status | `Open`                              |

<!-- BORN WITH ITS PREFIX, 08/09/2026. The number `01-` was reserved for this story earlier that
     day, when the six plans in this folder were renamed by `git mv` to
     `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`. The reservation is recorded in
     `../02-STORIES/US007.md` (its STORY-PLAN RENAME comment, point 3) and as a no-file row in
     `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` -> _Story Plans — the code master_. The prefix is
     the story's position in the settled build order across the WHOLE backlog — US007, US001,
     US002, US003, US004, US005, US006 — not its sprint and not a per-sprint counter, so US007 is
     FIRST, ahead of US001. Derived rather than inherited: the sprint plans read in their own
     `<exec-order>` sequence give US007, US001 (01-SPRINT-PLAN-01), US002, US003
     (02-SPRINT-PLAN-02), US004 (03-SPRINT-PLAN-03), US005, US006 (04-SPRINT-PLAN-04), and the
     six plans on disk carry `02-` through `07-` against exactly that order, leaving `01-` free.
     It is RENUMBERED whenever build order changes, which is the OPPOSITE of the sibling rule for
     the sprint plans: a sprint plan carries two numbers and a mismatch between them is
     information, while a story plan carries one, so its prefix must track build order or it says
     nothing. `./CLAUDE.md` owns the rule. The descriptor `STATUS-VOCABULARY-ONE-OWNER` matches
     the story's QA plan, as every existing pair does. Wave 0 is the story's position in its
     cutting order — it waits on nothing — and build order 1 is first of {US007, US001}, the order
     `../03-SPRINTS/SPRINT-01.md` settled on 07/09/2026. -->

Rests on `../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` (no gate verifies
a PM `src/` citation in either form, so every citation here is human-checked),
`../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` (prose doctrine is verified
by a human read-across; `doctrine-drift.sh` is a regression guard only),
`../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` (a gate that reads the files
under test but decides none of the question stays in the manifest, narrowed) and
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` (a red `doc-references.sh`
is read as an identity diff against a recorded baseline until US004 retires the regime).

**No new ADR, and that is on the record rather than an omission.**
`../02-STORIES/US007.md` -> _Decisions_ closes with "No record is written at this gate": each of
the twelve decisions the grilling pass settled is an edit to a document that can be edited back,
which is the reversibility test `../15-DECISIONS/`'s own template applies. The `15-decisions` pass
of 08/09/2026 ran as a coherence gate over the four records above, found no clash, and authored
nothing for US007. `../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` was
written the same day and is `Proposed`; it is US004's and binds nothing here.

> **`Open` is literal.** `./CLAUDE.md` makes any value other than `Blocked` an assertion that the
> blockers are cleared, and this story has none: it is wave 0, it waits on nothing, and
> `../03-SPRINTS/SPRINT-01.md` -> _Dependencies_ says so in terms. What stands between this plan
> and the first edit is the process gate every story in this backlog shares — the `us###/` branch
> is cut from `main` once `pm/story-creation` lands
> (`../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` -> _Branch Naming Reference_) — not a story.
> `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` reads `Blocked` because
> its target directory exists in no branch; that is a different fact and the two values are not
> drift from each other.

> **Source authority.** Where this plan and `../02-STORIES/US007.md` differ on **what must be
> true**, the story wins — its thirteen scenarios are the requirement and this plan records the
> engineering route. Where the story and
> `../11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` differ, the QA plan is the
> later measurement and its Section 1 says which of its own readings the story superseded. Where
> either differs from what is **on disk today**, the disk wins and this plan records the
> divergence under _Measured divergences_ rather than propagating it. On sprint facts
> `../03-SPRINTS/SPRINT-01.md` wins over both plans. On how a gate's result is reported,
> `code/docs/GATE-REPORTING.md` wins over everything here.

**No Table of Contents, and no As-Built Summary.** The template marks the first optional — keep
for large multi-phase plans, drop for small single-layer ones — and none of the six sibling plans
in this folder carries one (measured 08/09/2026), so this plan follows the folder rather than
inventing a difference. The second is marked retrospective-only and this plan is forward-looking.
**And one section the template does not carry — _Measured divergences_.** It holds the live claims
in sibling artefacts that the tree does not support, each named with its owner so it is read as
known rather than found; the plan corrects none of them, bar the one sprint-plan cell its own Step
10 already owns. It sits after _Status Propagation & ClickUp Sync_ and before _Deferred Items_, and
no sibling plan in this folder carries one (measured 08/09/2026).

---

## Problem Statement

**Why this story exists.** This repository records where every piece of work stands in a
`**Status:**` field, and its own instructions disagree about which values that field admits.
`project-management/docs/planning/STORIES.md` defines eleven and calls them "the canonical set";
`.claude/skills/completion/SKILL.md` lists five for the same header; and two shipped workflow
steps — `23-pr-and-review` Step 5 and `24-release` Step 5 — order three values between them,
`Accepted`, `Accepted Customer` and `Closed`, that the skill recording the completion transitions
cannot express, while a third, `23-pr-and-review` Step 3, orders `In Review`, which it can. A
fourth vocabulary, `{Draft / Ready / In Progress / Done}`, sits in the sprint-plan template as the
legend of the story-plan `Status` column, and none of its four values appears in any live plan.
The story is `../02-STORIES/US007.md`.

**Current state / gap.** Nothing has broken yet, because no story has reached any of the disputed
states — measured, not assumed: a field-scoped `git log --all -S` over the three registers returns
**0 commits** for each of the six values outside the skill's five (Scenario 12). The exposure is
downstream. US002 unblocks `MAP-REGISTER-INDEXES.md` slice `S-03`, "register-indexes.sh", whose
`broken/` and `clean/` fixtures string-equal a `Status` column against the file it names — so
whichever vocabulary is canonical on the day those fixtures are written is the one a gate enforces
for good. A gate built on a split vocabulary ships the split into every generated project with a
green tick beside it. That is the whole reason US007 was placed ahead of US002 in the cascade
re-plan of 07/09/2026 and opens SPRINT-01 ahead of US001.

**What this story delivers.** One set of eleven story statuses, defined in exactly one document,
with every skill, workflow, template and README seed **that writes or lists a `**Status:**` value
into this repository's own artefacts** routing to that section and using a value it admits. The
sprint set takes the same shape one register over in `SPRINTS.md`. The defining sentence stops
naming a board, so a project generated without ClickUp reads the same eleven values. Nothing is
renamed and no live source value changes.

**Explicitly out of scope, each with its owner:**

| Left alone                                                                         | Owner                                                                                             |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| The folder-level plans index and the sites that once gated on it                   | US002's line of work — `MAP-REGISTER-INDEXES.md` `S-01` creates the file, `S-03` the gate over it |
| `.claude/skills/pm-tool-sync/SKILL.md` `:59-68` and `:98` — the board-side mapping | Whoever configures a board; excluded from this story's population on the record                   |
| `MAP-REGISTER-INDEXES.md` `:213`, `:456-469` and `:556`                            | A `wayfinder` RESOLVE session                                                                     |
| `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md`'s surviving board clause in its own DoD  | The sprint's own close under `24-release`                                                         |
| `doc-references.sh`'s findings, and any edit to that script                        | `MAP-RULE-OWNERSHIP.md` `S-06`, carried by US004                                                  |
| The US005 plan-versus-story status divergence                                      | Whoever owns US005's plan — recorded, not resolved                                                |

Mirrored into _Deferred Items_ below.

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                            |
| ----------------------------- | --------- | ---------------------------------------------------------------- |
| Database / models / migration | —         | `DB: N/A`. No model, no migration, no RLS policy                 |
| Service layer                 | —         | No Python at all                                                 |
| Django Ninja API              | —         | `API: N/A`. No router, endpoint or `Schema`                      |
| Frontend (templates)          | —         | `Frontend: N/A`. No template, component, HTMX partial or Alpine  |
| Infrastructure / DevOps       | —         | No Docker, Nginx, CI or Nix change. The worktree files are setup |
| GDPR / PII                    | —         | `GDPR: N/A`. No field, no store, no personal-data path           |

Twelve of the story's thirteen flags read `N/A`; only `QA` is live. **The emptiness is the
information**, not a set of gates anyone skipped — the distinction `code/docs/GATE-REPORTING.md`
requires.

---

## Reference Documents (code/docs gate map)

| Concern (when it gates)                      | Authoritative doc(s)                                                                                    | Applies |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------- |
| Length limit and the ratchet                 | `code/docs/DOCUMENTATION-LENGTH.md` — the 270 warn tier and its dated allowance                         | ✓       |
| Reporting a gate's result                    | `code/docs/GATE-REPORTING.md` — "could not look" is never "looked, and it was clean"                    | ✓       |
| What a shipped document may claim            | `code/docs/FORWARD-VOICE.md` — the `template-only` marker, and when it is admissible                    | ✓       |
| The pair, and which half owns what           | `code/docs/DOCUMENTATION-PAIRING.md` — nothing here creates, splits or moves a pair                     | ✓       |
| Skill authoring                              | `how-to/docs/SKILL-AUTHORING.md` — the one home of the standard `skill-conformance.sh` enforces         | ✓       |
| The two owning documents                     | `project-management/docs/planning/STORIES.md` · `project-management/docs/planning/SPRINTS.md`           | ✓       |
| The pair that assigns them                   | `project-management/docs/planning/CONTEXT.md` · `project-management/docs/planning/CLAUDE.md`            | ✓       |
| The thin index that must not become an owner | `project-management/docs/PLANNING-GUIDE.md`                                                             | ✓       |
| The skill being rewritten                    | `.claude/skills/completion/SKILL.md`                                                                    | ✓       |
| Story                                        | `../02-STORIES/US007.md` — thirteen scenarios, the QA criteria, the Tasks table                         | ✓       |
| QA                                           | `../11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — seven resolved gaps; **Section 6**   | ✓       |
| Sprint plan                                  | `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` — build order, phase disposition, the gate-honesty constraint | ✓       |
| Sprint record                                | `../03-SPRINTS/SPRINT-01.md` — membership, capacity, the cascade re-plan                                | ✓       |
| Worktree isolation                           | `how-to/docs/GIT-WORKTREES.md` · `code/src/docker/CONTEXT.md` · `code/src/docker/nginx/CONTEXT.md`      | ✓       |

**Not applicable, and why:** `../04-DATABASE/` through `../10-SECURITY/`, `../12-SEO/`,
`../13-API-DESIGN/` and `../14-LOGGING/` — the story's corresponding flags all read `N/A`, and it
ships Markdown only. `code/docs/SECURITY.md`, `TESTING.md`, `API-DESIGN.md`, `URL-STRATEGY.md`,
`ACCESSIBILITY.md`, `DESIGN-TOKENS.md`, `RENDERING.md`, `RESPONSIVE-DESIGN.md`, `RLS-GUIDE.md`,
`ENCRYPTION-GUIDE.md`, `LOGGING.md` and `PERFORMANCE.md` gate code this story does not write.
Listed rather than dropped, because a Reference Documents table that simply omits a row and one
that says the row was checked and does not apply read very differently.

---

## Architecture Decision

**No ADR is raised, and the reason is the reversibility test, not the absence of a choice.**
Twelve decisions were settled at the grilling pass, and every one is an edit to a Markdown
document that can be edited back: which set is canonical, which document owns it, which values the
skill may write, whether the defining sentence names a board. `../15-DECISIONS/`'s own template
applies reversibility as the test for a record, and none of the twelve fails it. The one decision
that was genuinely hard — whether the register-indexes feature map owns the story lifecycle — the
map settled for itself at `:556` under what it will **not** do, and this story leaves that row
standing.

**What is fixed by prior decisions.** Four records above bind the engineering route and are not
re-opened here: a PM `src/` citation is unverified in either form and is human-checked; prose
doctrine is verified by read-across and `doctrine-drift.sh` is a regression guard; a gate that
cannot decide the question stays in the manifest, narrowed, rather than being dropped; and a red
`doc-references.sh` is read as an identity diff against a recorded baseline.

**What this story is free to choose, and has.** The **shape** of the two owning sections — a rule
first, then the values with a meaning against each, then an illustrative and explicitly
non-exhaustive list of sibling registers — and the **shape of the skill's declaration**: two
routes plus a writer table that assigns each of the eleven an owner and says on its face that it
is a declaration of authority, not a second definition. Both are fixed in _Approach_ below.

---

## Approach

### Not applicable — Database, Service Layer, API, Frontend

No Python, no template, no component, no endpoint. The four layer sections are dropped because the
story touches none of them, not to dodge a gate. Its one lane is documentation: twenty-one files
across nine trees, of which two take newly authored sections, one is rewritten, and the rest take
a repointed route, a corrected value or a marker.

### The one lane — documentation, in seven phases

The phases are a **dependency chain, not a preference order**. Phase 0 precedes everything
absolutely. **Phases 1 and 2 are one pass, not two** — `STORIES.md`'s pointer names the skill's
writer declaration and the skill's sprint route names `SPRINTS.md` -> _Sprint statuses_, so each
creates a section the other cites; their joint landing precedes Phase 3, whose three repointed
routes target Phase 1's section, and Phase 4, whose four board-neutral edits route into it too.
Phase 6 is the close.

#### Phase 0 — Capture, before the first keystroke

**This is the highest-risk step in the story and it is unrecoverable once editing starts.** A
baseline measured after an edit cannot separate a pre-existing finding from an introduced one
(QA plan ES-01), and the recovery is to return the tree to its pre-edit state by SHA and capture
there.

1. **Stage the untracked artefacts first.** `doc-references.sh`'s `build_template_only()` builds
   its excluded set from `git ls-files` while its candidate walk reads tracked **plus**
   `--others --exclude-standard`, so an **untracked** file under `project-management/src/` is read
   as shipping and every full-path citation it makes into an excluded artefact fires
   `[template-only citation]`. Measured 08/09/2026: **467** findings tree-wide — 135 instance, 106
   dangling, 226 template-only, 0 plan prefix — of which **214 of the 226 template-only sit in
   untracked citing files**. Restricting the count to tracked citing files gives 209 — 110
   instance, 87 dangling, 12 template-only, 0 plan prefix. Capturing a baseline before staging
   makes every one of those 214 clear as a `<` line at close, which the implementer must then
   explain. Stage them, then capture.

   **Confirmed by measurement the same day, and this is the evidence rather than the argument.**
   With the working tree staged, the tree-wide run returns **253** — 467 less exactly the 214
   untracked-file findings, the residue being the 12 tracked template-only plus the instance and
   dangling classes. The prediction and the reading agree to the finding, so the instruction is
   proven, not asserted. **Both figures are readings of an index state, not baselines**; the
   implementer takes their own at capture and neither inherits nor quotes these.

2. Record the pre-edit tree: `git rev-parse HEAD`, the `git status --porcelain` count, and a
   `git stash create` SHA where the tree is dirty. **The porcelain count is a reading, never a
   fingerprint** — 75, 84 and 85 in
   `../11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` and 87 in this plan's own
   reading (_Measured divergences_): four figures on one unchanged HEAD.
3. Record **every gate by content**: `git hash-object` of all five audit scripts, re-asserted at
   close. A differing hash makes that gate's diff **detector-confounded**, reported as such and
   never as the story's.
4. Capture the finding sets of the **four diff-read gates** by identity — `doc-references.sh`,
   `skill-conformance.sh`, `docs-pairing.sh`, `doctrine-drift.sh` — an empty set recorded as
   empty. `docs-length.sh` is measured, not captured.
5. Re-count the whole source-`**Status:**` population from the tree, never inherited from the
   story or from this plan.

**The capture procedure — the normalising pipes, the `sed` identity rewrite and the `/tmp` set
files — is `../11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` Section 6 and is not
reproduced in this plan.** Two of its steps recur at close by Section 6's own instruction and are
repeated under _Sprint Verification Checklist_ so that block runs as written: the detector-hash
loop and the `docs-length --limit 1` rulers. Nothing else is copied across, and if Section 6
moves, those two blocks move with it.

#### Phase 1 — The two owning documents

**`project-management/docs/planning/STORIES.md`** takes four edits, all under and around
`## Story statuses` (`:73` on 08/09/2026; the eleven values at `:81-91`, the "canonical set"
sentence at `:93`):

- The defining sentence at `:75-77` stops naming a board. The set is this repository's story
  lifecycle and a board is mapped onto it; `:93-94` already says "if a project's board uses
  different words, map them here once", and that becomes true of ClickUp as well.
- A **per-register scoping declaration**, rule first: a `Status` value is scoped to the register
  whose template declares it, and the eleven bind `US###.md` and its story plan and nothing else.
  The sibling registers are given as **illustrative and explicitly non-exhaustive** — "for
  example", with the count omitted — because a closed set of siblings goes stale the day a
  register is added.
- A **one-line pointer** at the skill's writer declaration, so the owner of the set routes to the
  writer of each value without the reader having to know the skill exists.
- The export and push are mentioned only as **consumers**, carrying the bold clickup-only marker
  that `project-management/CONTEXT.md` and `.copier/README.md` already use for the same boundary.

**`project-management/docs/planning/SPRINTS.md`** gains a `Sprint statuses` section holding
`Planned` · `In Progress` · `Done` with a meaning against each — Scenario 2's per-register rule
applied to the sprint register, and Scenario 1's single-owner rule applied to the second set.
`:21` names status as a required sprint-record field today and lists no values.

**Neither may cross 270 counted lines.** Measured by the gate on 08/09/2026: `STORIES.md` **104**
counted (149 raw), `SPRINTS.md` **93** (143 raw) — 166 and 177 lines of headroom. Re-measured
before and after with `docs-length.sh --path project-management/docs/planning --limit 1`, never
with `wc -l`, which reports different figures for both.

**`PLANNING-GUIDE.md` is not made an owner.** No `Story Statuses` section is added to it — that
would make a second definition site of the index. Its H2s are at `:27`, `:39` and `:50` and it has
no such section today.

#### Phase 2 — The skill

`.claude/skills/completion/SKILL.md` — **77 counted lines of 102 raw**, and clean against HEAD as
of 08/09/2026. Its `## The status vocabulary` section is **rewritten, not trimmed**:

- The story enumeration at `:37-38` and the sprint enumeration at `:42` each become a **route** —
  to `STORIES.md` -> _Story statuses_ and `SPRINTS.md` -> _Sprint statuses_ — using the
  "owned by … Not restated here." HTML-comment pattern `SPRINT-00-TEMPLATE.md:12-13` already
  carries.
- The skill **declares the five it may write** — `Pending` · `Open` · `Blocked` · `In Review` ·
  `Completed` — and the one sprint value it may write, `Done`. The "never straight from `Pending`
  or `Open` to `Completed`" rule at `:39-40` stays: that rule is the skill's, not the set's.
- A **writer table** names the writer of each value outside its five: `Accepted` and
  `Accepted Customer` by `23-pr-and-review` Step 5; `Closed` by `24-release` Step 5; `Rejected` by
  the review record's transition surface; `In Progress` as written only by the board-side sync;
  and `Rejected Customer` as having **no writer in this repository today** — declared so, not
  assigned one. On the sprint side, `Planned` by the template copy and `Done` by this skill;
  `In Progress` is declared writer-less and handed to a `DEFERRED.md` row.
- The declaration says **on its face that it is a declaration of authority and not a definition**
  — it enumerates eleven values in order to assign each an owner, and a reader must not mistake
  that for a second canonical list.

**The skill is the one file `skill-conformance.sh` decides for.** `.claude/skills/CLAUDE.md` makes
that gate the definition of done for any skill edit. It is **exit 0 across 65 skills today**, so
the baseline is empty and an exit 0 at close **is** the pass and is reported as one.

#### Phase 3 — The routes and the checklist boxes

- **Three stale routes**, each citing `project-management/docs/PLANNING-GUIDE.md → Story
Statuses`, a section that does not exist:
  `project-management/workflows/02-story-creation/STEPS.md:83`,
  `project-management/workflows/23-pr-and-review/STEPS.md:59` and
  `project-management/workflows/24-release/STEPS.md:92`. Each is repointed to
  `project-management/docs/planning/STORIES.md` -> _Story statuses_. **The casing matters** — the
  heading is `## Story statuses`, lower-case `s` on `statuses`; the three stale routes all
  capitalise it, and the story's own repair row already carries the correct form. All three files
  are working-tree clean, so their line numbers hold at HEAD.
- `../19-REVIEWS/REVIEW-US000-TEMPLATE.md`'s citation of `PLANNING-GUIDE.md` **without** naming a
  section is left alone: it resolves through that guide's own routing line in one hop and is not
  stale.
- **The five ownership comments** — the byte-identical two-line block beneath each
  `**Status:** Planned` line in `SPRINT-00-TEMPLATE.md` and in `../03-SPRINTS/SPRINT-01.md` to
  `../03-SPRINTS/SPRINT-04.md` — route to `SPRINTS.md` -> _Sprint statuses_ instead of to the
  skill, so no comment points at a section that no longer states the set. **This is the only edit
  the four live sprint records take from this story.**
- `23-pr-and-review/CHECKLIST.md` gains a box for the `In Review` write its Step 3 orders and the
  `Completed` / `Accepted` write its Step 5 orders; `24-release/CHECKLIST.md` gains one for the
  `Closed` write. A write a `STEPS.md` orders is a write its `CHECKLIST.md` checks.
- **The three ordering steps are left ordering what they order.** Every value they name is legal
  under the one set — the contradiction was the skill's claim, never the workflows'.

#### Phase 4 — The shipped templates and the README seed

Everything in this phase **travels**. `copier.yml` excludes `/project-management/src/**` and
re-includes only `**/CONTEXT.md`, `**/CLAUDE.md`, `**/*TEMPLATE*` and a short allowlist;
`project-management/docs/**` and `project-management/workflows/**` appear nowhere in `_exclude`;
and `completion` appears nowhere in `copier.yml` at all, so the skill ships unconditionally. **So
the drift that ships is systematically the uncorrected one** — which is why this phase exists as
its own step rather than as a tail on Phase 3.

| File                                                | Edit                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `../03-SPRINTS/SPRINT-00-TEMPLATE.md`               | `:344` "marked **Done**" → `Completed`; its DoD gains "Sprint `**Status:**` set to `Done`" in place of the board clause at `:350`; the ownership comment repointed (Phase 3)                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `../16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`  | The `{Draft / Ready / In Progress / Done}` legend under _Story Plans — the code master_ → a route; the "Sprint closed on the board" clause under _Sprint Definition of Done_ → the sprint-record `Status` wording                                                                                                                                                                                                                                                                                                                                                                                |
| `../17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` | `:24-30` → a route; `:248` → a route, dropping the board attribution; `:633-638` renamed and reworded board-neutrally; the ClickUp export row and the regenerate block marked; `:773` → the final **canonical** value; **`:9`, the header `Status` pick-list, is left standing** — the field's legend, the shape `../15-DECISIONS/ADR-US000-TEMPLATE.md:10` uses, and a pick-list beside a field is not a definition. It is the third of the three sites the story's read-across counts for this file, the other two being `:24-30` and `:248`, and it is confirmed unchanged rather than edited |
| `.copier/README.md`                                 | `:568-570` stop attributing the values to ClickUp and route to `STORIES.md`; the `:566` heading is left as it is                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

**Two citation families take the volatility rule, not the number.** The sprint-plan template is
modified against HEAD (33 insertions, 14 deletions): its legend is `:98` in the working tree and
`:90` at HEAD, and its board clause `:178` against `:170`. Both are **found by quoted text**, and
the number is dated evidence only. The story-plan template's line numbers hold — the rename pass
appended its note below `:773` — but the **content** at `:646` and `:773` moved on 08/09/2026, so
those two are re-read before they are edited.

**`00-STORY-PLAN-US000-TEMPLATE.md` removes and renumbers no row.** A separate pass on 08/09/2026
rewrote all four of its former plans-index sites in place, one line for one line; the story
consumes **zero** of them and the cause of its row-3 hand-off is gone. The `:636` example
transition survives the board-neutral rewording **as an example, not an order** — it names values
the one set admits, and the rewording changes the comment's attribution, not the example's values.

#### Phase 5 — The live mirror cells, the casing, and the one map edit

**The `Not started` cells number SIX once this plan lands, and the story's own count is five.**
Measured on the live _Story Plans — the code master_ tables on 08/09/2026, comments and prose
excluded:

| Cell                           | Plan                                      | Mirrors   |
| ------------------------------ | ----------------------------------------- | --------- |
| US001                          | `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` | `Open`    |
| US002                          | `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` | `Open`    |
| US003                          | `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` | `Open`    |
| US005                          | `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` | `Blocked` |
| US006                          | `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` | `Open`    |
| **US007 — added by this plan** | `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` | `Open`    |

`../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` holds none — its two rows already mirror verbatim, and
they are **backticked** (`` `Open` ``) where all six cells above are bare. The story states no
rule on the backticks; the implementer picks one, applies it to all six, and records the choice.
The recommendation here is to backtick, matching the plans' own `| Status |` header rows and the
already-correct third plan.

**No story plan's own `Status` field is edited** — the column mirrors, it does not lead. The
legend in the sprint-plan template's column header routes to `STORIES.md` -> _Story statuses_,
which ratifies the third plan's position.

**The casing touch.** `../18-TESTS/US000-MANUAL-TESTING.md:5` is normalised `In progress` →
`In Progress` as a casing correction inside that register's own three-value set; no word changes.
The other two lowercase sites — the skill's `:42` and the map's `:217` — clear as consequences of
Phases 2 and 5 rather than as extra edits. Measured 08/09/2026:
`git grep -nw "In progress" -- '*.md' '*.sh' '*.yml'` returns **11 hits**, of which **3 are
outside `../02-STORIES/US007.md`** and are exactly those three sites; the remaining 8 are inside
the story, whose subject is the casing and which is excluded by pathspec. The untracked QA plan
carries a further five and is excluded for the same reason.

**One map edit, as a stated exception.**
`../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:215-219` asserts that the skill "owns both"
vocabularies — the clause this story falsifies. It is corrected to the fact, as an **exception**
to that folder's wayfinder-only routing rule and not under a licence it grants: a false ownership
assertion on a live map row must not survive the change that falsifies it, and the map's own
session log records the batch as closed, so the alternative is a false claim standing until a
session nothing schedules. `:213`, `:456-469` and `:556` take **no** edit.

#### Phase 6 — Close

Re-run the five gates; re-assert every detector hash; diff the four captured sets by identity and
classify every `>` line by the edit set — **a `[plan prefix]` line is the story's against a zero
baseline: repoint it to the on-disk prefixed name, or, where a superseded name is deliberately
being quoted, move it from backticks to "double quotes"** (QA plan ES-11). Then build the Scenario
1 named-site inventory with its role column; run the casing `git grep` with its stated pathspecs;
take the before/after list of the source fields; perform the human read-acrosses; and write all of
it into "project-management/src/18-TESTS/US007-MANUAL-TESTING.md", which does not exist today and
is created at implementation from `../18-TESTS/US000-MANUAL-TESTING.md`.

<!-- That path is in double quotes, not backticks, deliberately: the file does not exist, and
     `doc-references.sh` reads backticked tokens as paths. The same rule governs every
     work-yet-to-create name in this plan. `../02-STORIES/US001.md`'s plan backticks its own
     equivalent and is a live forward reference no gate catches — named in
     ADR-US001-INSTANCE-CITATION-UNVERIFIED and not repeated here. -->

### Phase dependencies

| Phase | Must land before | Why                                                                                                                                                                                              |
| ----- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 0     | everything       | A baseline taken after an edit cannot separate pre-existing from introduced                                                                                                                      |
| 1+2   | 3, 4             | One pass, one writer: each names a section the other creates — `STORIES.md`'s pointer needs the skill's writer declaration, and the skill's sprint route needs `SPRINTS.md` -> _Sprint statuses_ |
| 3     | —                | Waits on 1+2; nothing but the close follows it. Shares `SPRINT-00-TEMPLATE.md` with Phase 4, so the two never run concurrently                                                                   |
| 4     | —                | **Not independent of 1+2.** Its board-neutral routes land on the `STORIES.md` sentence Phase 1 de-attributes, and two of its edits write the sprint value `Done`, whose owner Phase 1 creates    |
| 5     | —                | Shares no file with 1–4, but the map correction asserts what Phases 1 and 2 make true, so it is written after them or its own sentence is premature                                              |
| 6     | after all        | The close                                                                                                                                                                                        |

**Startable immediately inside the worktree:** Phase 0, then Phases 1 and 2 as one pass. Nothing in
this story waits on another story.

---

## Key Decisions

| Decision                                              | Chosen                                                                    | Rejected                                        | Reason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Reference                                                                                |
| ----------------------------------------------------- | ------------------------------------------------------------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Who owns the story set                                | `project-management/docs/planning/STORIES.md`, alone                      | `PLANNING-GUIDE.md`; the `completion` skill     | The planning pair already assigns "statuses" to `STORIES.md`, and the guide self-describes as "A thin index." — making it an owner creates a second definition site                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Story Scenario 1                                                                         |
| Who owns the sprint set                               | `SPRINTS.md`, in a new _Sprint statuses_ section                          | Leaving it in the skill                         | `SPRINTS.md` already names status as a required field and lists no values; the per-register rule applied one register over                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Story Scenario 3                                                                         |
| What the skill states                                 | Two routes plus a writer table, declared as **authority, not definition** | A trimmed enumeration                           | An enumeration of eleven values in a non-owning file is read as a second canonical list however it is captioned                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Story Scenarios 1 and 4                                                                  |
| The sibling-register list                             | Illustrative and explicitly non-exhaustive                                | A closed, counted set                           | A closed set goes stale the day a register is added, and the rule has to hold for the register nobody has written yet                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Story Scenario 2                                                                         |
| Board attribution                                     | Removed from the defining sentence; export and push marked clickup-only   | A Jinja-conditional sentence                    | Ruled out, not merely rejected: no file in this template ever has templated contents, and CI diffs two generations for byte-identity                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Story Scenario 6                                                                         |
| **The `Status` cell this plan's own row takes**       | **`Not started`, matching its sibling**                                   | `Open`, the value this plan carries             | US006's Step 10 pass took exactly this call on 08/09/2026 — fill with the column's current value, because correcting the column is US007's own Scenario 8. `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` -> _Story Plans — the code master_ says so in its own dated comment, "this is the settled reading for every sprint plan", `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` having moved its cells to `Open` on 07/09/2026 and reverted them on 08/09/2026; and Scenario 8 provides for it — "a plan written between now and then joining the population and taking the same rule". **That section's live sentence "The Status column mirrors the story plan's own `Status` field, so a story with no plan has no value to mirror" is rewritten by the same Step 10 change**, not left contradicted — see _CONTEXT.md & Index Updates_ | `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` -> _CONTEXT.md & Index Updates_ |
| How `doc-references.sh` is read                       | Identity diff — `(file, kind, token)`, line dropped, multiplicity kept    | Exit code; a count; a read-by-eye               | The story edits 21 files, several carrying pre-existing findings, so an edit above one shifts its line and a `file:line` diff reports a false pair for each                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `ADR-US003` · QA plan AC-GAP-2                                                           |
| When the baseline is captured                         | **After staging the untracked artefacts**                                 | On the tree as it stands                        | Untracked citing files are read as shipping, inflating template-only from 12 to 226; unstaged, their clearance appears as 214 unexplained `<` lines at close                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | QA plan Section 1, _Correction to Section 7_                                             |
| Whether the story's four-cell count is corrected here | **No — measured, named, and left to the implementer's re-count**          | Editing `../02-STORIES/US007.md` from this plan | A plan does not edit the story it plans; the story already requires the population to be re-counted immediately before the edit, which is the mechanism that catches it                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | _Measured divergences_ below                                                             |

---

## Dependencies

| Story / Artefact | What it gives / needs                                                | Required for                                                 | Current state                                                                         |
| ---------------- | -------------------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| US001            | Nothing to this story; co-member of SPRINT-01, built **second**      | —                                                            | `Open`. Shares no file. A sequencing call, not a dependency                           |
| US002            | Consumes the vocabulary this story makes canonical                   | "register-indexes.sh"'s `broken/` + `clean/` status fixtures | `Open`, opens SPRINT-02 **behind** this story — the constraint the cascade was for    |
| US004            | Owns the `doc-references.sh` repair (`MAP-RULE-OWNERSHIP.md` `S-06`) | Retiring the baseline-diff regime this story runs under      | `Open`, SPRINT-03. Not a blocker — the regime works red                               |
| US005            | Its plan/story `Status` divergence is recorded, not resolved         | Nothing here                                                 | Plan `Blocked`, story `Open` — pre-existing, unexplained, routed to that plan's owner |

**Blocked by:** nothing. Wave 0, first in the backlog's build order. The only gate ahead of the
first edit is the process one every story shares — the `us###/` branch is cut from `main` after
`pm/story-creation` merges.

**Blocks:** US002's line of work, and through it `MAP-REGISTER-INDEXES.md` slice `S-03`. This is
the reason the story sits first: whichever vocabulary is canonical when `S-03`'s fixtures are
written is the one a gate enforces into every generated project.

**Can be done now:** yes, in full, once the branch is cut. Phase 0 and the joint Phase 1+2 pass are
startable immediately and nothing in the story waits on US001, which shares no file with it.

> This project keeps no cross-cutting parallel-worktree programme plan; the DAG is the
> _Dependencies_ sections of the plans in this folder.

---

## GDPR

**Not applicable.** The story's `GDPR` flag reads `N/A`. It edits Markdown: no field, no store, no
code path that could carry personal data, and no `code/` file bar the audit scripts it **runs and
does not edit**. Stated rather than deleted, because a missing GDPR section and one that says
there is no personal data read very differently.

---

## Security

**Not applicable, and the sentence matters more than the absence.** The story's `Security` flag
reads `N/A` and **it introduces no mutation** — no endpoint, no state change, no user-supplied ID,
no role boundary — so the template's rule that every mutation carries an explicit permission check
and ownership verification (OWASP A01, no IDOR) has no subject. A status vocabulary is not a
control.

The one boundary that _behaves_ like access control is the **travel rule** — what ships into a
generated project and what stays behind — and it is a property of `copier.yml`'s exclusion list,
not of a caller. Nothing here can be reached by a caller who should not reach it. The standing
constraint that does apply is carried in the Verification Checks: no secrets, debug flags or
hardcoded IDs introduced.

---

## Logging & Observability

**Not applicable.** The `Logging` flag reads `N/A`. No runtime code, so no log line, no span, no
error payload. The story _documents_ a status lifecycle; it does not instrument one.

---

## Performance, Rendering, Responsive & Accessibility

**Not applicable — no rendered surface.** No page for an axe scan, no focus order, no
announcement, no breakpoint, no query. The story ships Markdown guides, a skill, workflow steps,
templates and record edits, all read in an editor this project neither controls nor ships.

---

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✓ → `03-sprint-planning` ✓ → `11-qa-checks` ✓ (signed off, seven gaps found
and seven resolved) → `15-decisions` ✓ (ran as a coherence gate; authored nothing) →
`16-sprint-plans` ✓ → **`17-story-plans` (this document)** → `22-implementation-documentation` →
`23-pr-and-review`. Gates `04`–`10` and `12`–`14` are skipped on `N/A` flags — skipped, and
recorded as skipped.

**No code lane.** `19-backend-code`, `20-api-code` and `21-frontend-code` all read `N/A` — the
story's `Backend`, `API` and `Frontend` flags say so, and
`../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` -> _Phase Breakdown_ records the matching Phases 1–3 as
`N/A` with their reasons rather than deleting them, because the emptiness is the information, with
Phase 4 (PR & review) the only one carrying content. `18-consolidate-design-work` is `N/A` on the
same ground: gates `04`–`08` never ran, so there is no per-story design artefact to consolidate.
The lane this story runs in is Phases 0–6 above, entered directly from `17-story-plans`.

### Code workflows invoked

**None.** No Python, no endpoint, no template, no migration. `code/workflows/02-tdd-cycle` and
`07-review` have nothing to run against; the review this story gets is the human read-across and
the PM `23-pr-and-review` pass.

### Standards gates

`docs-length.sh` · `docs-pairing.sh` · `doc-references.sh` · `doctrine-drift.sh` ·
`skill-conformance.sh` · `syntax/lint.sh` (the one leg that reads Markdown, via markdownlint-cli2)
· `syntax/format.sh`.

**Each is read under a stated regime, and none may report a plain pass it has not earned** — the
rule `code/docs/GATE-REPORTING.md` states. Per gate:

| Gate                   | Reading, 08/09/2026                                                                                                                                                                                  | Regime at close                                                                         |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `doc-references.sh`    | exit 1 · **467** unresolved unstaged (135 instance · 106 dangling · 226 template-only · 0 plan prefix), **253 staged** — the 214 untracked-file findings clear · blob `b9e4e129…` (HEAD `a3412dcd…`) | Identity diff. **Never a pass while a non-empty baseline stands**                       |
| `skill-conformance.sh` | exit 0 · 65 skills, 62 first-party and 3 vendored, all conform                                                                                                                                       | **Empty baseline.** Exit 0 at close **is** the pass, and is reported as one             |
| `doctrine-drift.sh`    | exit 0 · 5 trees, fenced code only · 3 claims, one home each                                                                                                                                         | Regression guard. It opens **six of the twenty-one files** and neither owning document  |
| `docs-pairing.sh`      | exit 0 · 0 findings across 222 `CONTEXT.md` and 212 `CLAUDE.md`                                                                                                                                      | Identity diff of two empty sets. **It decides nothing here** — no pair created or moved |
| `docs-length.sh`       | exit 0 · 777 files within 300 · 5 in the warn band, none this story edits                                                                                                                            | A **measurement**, not a diff. `--limit 1` exits non-zero by construction               |

**`doctrine-drift.sh`'s population is stated with its result.** Its `SCAN_DIRS` are exactly five
trees — `code/docs`, `.claude/skills`, `code/workflows`, `project-management/workflows`,
`how-to/workflows` — so of the twenty-one files in the story's Tasks table it can open **six**
(the skill, three `STEPS.md`, two `CHECKLIST.md`), fenced code only. `STORIES.md`, `SPRINTS.md`,
everything under `project-management/src/` and `.copier/README.md` are outside them and are never
opened. A green run says three API-envelope claims still have one home in six files; **it has read
neither definition and cannot.** It stays in the manifest, narrowed, on
`ADR-US002-BLIND-GATE-LEAVES-THE-FLAG`'s rule.

**`docs-length.sh --limit 1` is a ruler, not a leg.** It exits non-zero by construction —
everything is over a one-line limit. Read the figure, record it, and let the tree-wide run at 300
be the pass/fail leg. The two uses are labelled apart in the record.

---

## Execution & Verification via Claude Dynamic Workflows

Every Opus session runs with **ultracode** on. Drive this story with dynamic workflows rather than
ad-hoc single passes — and **the internal procedure comes first** (`.claude/CLAUDE.md` Section
2.7): the stages below name the `**/workflows/NN-…/` folder each executes, and the dynamic
workflow supplies the fan-out and the adversarial verification, never a substitute set of steps.

**One rule overrides the default fan-out shape, and it is this story's own hazard.**
`handoffs/HANDOFF-US007-PLANNING-AND-PLAN-PREFIX-08-09-2026.md` records that a passage asserting a
sibling artefact is stale or absent **when it is in fact correct** recurred four times in one day,
on top of nine the day before, and that every instance had the same cause: **two writers on files
that cite each other**. This story edits twenty-one files across nine trees and many of them cite
one another. Therefore:

- **One writer whenever files cross-cite.** Partition by file only where the sets are genuinely
  disjoint and neither side describes the other's state. Phases 1+2, 3, 4 and 5 each touch a
  cross-citing cluster and are **not** run as parallel writers; Phases 3 and 4 share
  `SPRINT-00-TEMPLATE.md` and never run concurrently.
- **Open every artefact before describing it.** Never restate a claim from this plan, the story or
  the QA plan as fact in a file — re-read the passage first.
- **Never backtick a name that work has yet to create.** `doc-references.sh` reads backticked
  tokens including inside HTML comments, so a dead or unwritten name in a history comment becomes
  a finding. Quote it in "double quotes". This binds a name **this repository's own work will
  create** — a script a later slice writes, a record this story writes at close. It does not bind
  a gitignored runtime directory or a path a shipped document legitimately promises downstream,
  which `code/docs/FORWARD-VOICE.md` governs.

### Stage 0 — Plan verification (before any edit)

Two or three independent reviewers adversarially critique **this plan** — missing files, a
falsified citation, a dependency-order error, an unscoped deferral. Findings resolved before
Phase 0 runs. Read-only; they write nothing.

### Stage 1 — Capture (Phase 0)

A single writer, no fan-out. The capture is a sequence whose steps have an order, and parallelism
buys nothing against five short commands.

### Stage 2 — Edit (Phases 1–5)

One writer per phase, phases sequenced per _Phase dependencies_. Fan out **only** for read-only
work: locating a passage by quoted text, re-resolving a line number, counting a population.

### Stage 3 — Verify (Phase 6)

Fan out the read-acrosses — one agent per route family, each reporting what it opened and what it
found — then a single writer folds the results into the manual-testing record. The gate diffs are
mechanical and are run once, by the close pass, never by a reviewer's eye.

### Stage 4 — Review and PR

`23-pr-and-review/`, which raises the PR, writes `In Review` into the story's own header at Step
3, and takes the branch through the chain.

**No stage here is improvised** — every one names an internal workflow or an internal rule.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**Governing rule.** All developer operations use the wrapper scripts in
`code/src/scripts/**/*.sh`. Never a raw `python`, `manage.py`, `pytest`, `pnpm`, `uv` or `docker`
call, whether running it or writing it into a document.

**This story runs the documentation legs only**, and the code legs are marked `N/A` with a reason
rather than deleted:

| Need                     | Command                                                               | This story                                                                      |
| ------------------------ | --------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Citation gate            | `bash code/src/scripts/audits/doc-references.sh`                      | ✓ — identity diff                                                               |
| Skill conformance        | `bash code/src/scripts/audits/skill-conformance.sh`                   | ✓ — attributed identity diff                                                    |
| Doctrine drift           | `bash code/src/scripts/audits/doctrine-drift.sh`                      | ✓ — regression guard                                                            |
| Pair audit               | `bash code/src/scripts/audits/docs-pairing.sh`                        | ✓ — decides nothing; captured so "no new" has a before                          |
| Length audit             | `bash code/src/scripts/audits/docs-length.sh [--path … --limit 1]`    | ✓ — tree-wide is the leg; `--limit 1` is the ruler                              |
| Markdown lint            | `bash code/src/scripts/syntax/lint.sh --file-type markdown [--fix]`   | ✓ — the one syntax leg that reads Markdown                                      |
| Format                   | `bash code/src/scripts/syntax/format.sh --file-type markdown [--fix]` | ✓ — Prettier over Markdown, host-side                                           |
| Typecheck                | `bash code/src/scripts/syntax/check.sh`                               | **N/A** — Python/TS/Rust only; no Markdown leg                                  |
| Migrations               | `bash code/src/scripts/database/migrate.sh check`                     | **N/A** — no model                                                              |
| Tests / coverage         | `bash code/src/scripts/tests/all.sh --coverage`                       | **N/A** — no code path, so no coverage figure                                   |
| Browser e2e              | `bash code/src/scripts/tests/e2e-py.sh`                               | **N/A** — no rendered surface                                                   |
| Stub / cloc / CVE audits | `audits/stubs.sh` · `audits/cloc.sh` · `audits/security.sh`           | **N/A** — no source file added; length is `docs-length.sh`'s, never `cloc.sh`'s |

**Neither raw-command exception is exercised.** No `pnpm exec` and no `uv run` — this story adds
no dependency, no Python and no host-versus-container drift to detect.

**On local↔Docker alignment — and why the two syntax legs are scoped.** The pre-PR hook re-runs
its eight gates both locally and inside Docker and hard-blocks on a mismatch. The five audit
scripts this story runs are host-side shell over Markdown and have no container leg to diverge.
`lint.sh` and `format.sh` do — **unscoped, their default leg set is `python markdown javascript
typescript rust`, and the Python leg executes against the toolchain rather than over Markdown.**
Both are therefore invoked `--file-type markdown`, matching
`../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` -> _Sprint Verification Checklist_ — a scoping so that
the result reads only on what this story ships, **not a workaround for an observed failure**.
Measured 08/09/2026 on this tree: the unscoped `format.sh --fix` and `lint.sh --fix` both exit
**0** with every leg running and no file changed — ruff, markdownlint over 930 files, ESLint on
both surfaces, and rustfmt + clippy. Whether an unscoped run behaves the same in a worktree with
no stack up is **not measured here**, and the scoped form is the one the checklist carries either
way. Recorded so the absence of a mismatch is not read as a mismatch that was checked for in a
container that never ran.

---

## Testing

**No automated test suite, and no coverage figure.** No code path, so no unit, integration, API,
contract or browser test. `code/docs/TESTING.md`'s floors — 75% line and branch, 90% auth — bind
code, and none is added. Recorded rather than left to be inferred as a pass.

**Every criterion closes by a recorded human read-across** in
"project-management/src/18-TESTS/US007-MANUAL-TESTING.md", because **no gate in this repository
reads a status value or a doctrine claim expressed in prose or a table**: `doctrine-drift.sh` logs
its scope as fenced code only, and the only two extraction sites accept any string.

| Check                                               | How it is decided                                                                                                                                                                                                             |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Exactly one definition site per set                 | **The named-site inventory**, with a ROLE beside every site — definition, legend, writer declaration, example, order, mapping, route, excluded. A grep cannot tell a definition from a legend                                 |
| Every route lands on a section that states the set  | Human read-across, route by route. `doc-references.sh` tests the path **before** the arrow and never the section after it                                                                                                     |
| The skill reads as authority, not definition        | A cold reader can name the five it writes, the one sprint value, and who writes the other six, without leaving the file                                                                                                       |
| A project without ClickUp reads the same eleven     | A cold trace of `STORIES.md` and the generated `README.md` against the `INCLUDE_CLICKUP: false` exclusion list, line numbers re-resolved first                                                                                |
| Zero live source values change                      | The before/after list of the whole population, this story's own column read against `Open` → `In Review` → `Completed`                                                                                                        |
| The mirror cells hold their plans' values           | Re-counted immediately before the edit; six cells after this plan lands                                                                                                                                                       |
| No new citation finding                             | Identity diff, every `>` line classified by `git diff --name-only <recorded pre-edit SHA>`                                                                                                                                    |
| A `[plan prefix]` finding in a file the story edits | It is the story's — the baseline is **0 plan prefix** tree-wide. Repoint the citation to the on-disk prefixed name; where a superseded name is deliberately quoted, move it from backticks to "double quotes" (QA plan ES-11) |
| No new skill violation attributable to the skill    | Whole-line identity diff, attribution by **path and cause** — a `[house 14]` line naming a guide outside the edit set is a concurrent change's                                                                                |
| The casing is gone                                  | `git grep -nw "In progress" -- '*.md' '*.sh' '*.yml'` with its stated `:!` pathspecs returns zero                                                                                                                             |
| Neither owning document crosses 270                 | `docs-length.sh --path … --limit 1` before and after — the gate's figure, never `wc -l`                                                                                                                                       |

**The walk-through is signed off by a tester other than the author.**

---

## Documentation Write-Ups (Implementation Records)

Owned by `22-implementation-documentation`. Of the records below, this story authors **one new one
at implementation** — the manual-testing walk-through in `../18-TESTS/`. The QA implementation
review and the code review record follow at `23-pr-and-review`, as they do for every story.

| Record                                                 | Destination                                                      | This story                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------------------------ | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **This plan**                                          | `../17-STORY-PLANS/`                                             | Always — written 08/09/2026                                                                                                                                                                                                                                                                                                            |
| User story                                             | `../02-STORIES/US007.md`                                         | Always — exists, `Open`                                                                                                                                                                                                                                                                                                                |
| QA plan (pre-dev)                                      | `../11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` | Always — exists, `Signed off`                                                                                                                                                                                                                                                                                                          |
| QA implementation review                               | `../11-QA/IMPLEMENTATION/`                                       | Always — written at `23-pr-and-review`                                                                                                                                                                                                                                                                                                 |
| **Manual testing record**                              | `../18-TESTS/`                                                   | Always — "project-management/src/18-TESTS/US007-MANUAL-TESTING.md" does not exist today; **created by this story at Phase 6** from `../18-TESTS/US000-MANUAL-TESTING.md`                                                                                                                                                               |
| **Automated test status**                              | `../18-TESTS/`                                                   | **Not required, and decided rather than omitted** — the folder's pair exists for a story with an automated suite, and this one has none: no code path, so no green/red/partial to record and no coverage figure. `23-pr-and-review/CHECKLIST.md`'s test-status box is ticked `N/A` with this reason, per `code/docs/GATE-REPORTING.md` |
| Code review record                                     | `../19-REVIEWS/`                                                 | Always — written at `23-pr-and-review`                                                                                                                                                                                                                                                                                                 |
| Sprint plan                                            | `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md`                        | Always — exists; takes this plan's path and branch                                                                                                                                                                                                                                                                                     |
| ADR                                                    | `../15-DECISIONS/`                                               | **Not required** — the reversibility test, argued under _Architecture Decision_                                                                                                                                                                                                                                                        |
| Schema · GDPR · security · SEO · API · logging records | `../04-DATABASE/` … `../14-LOGGING/`                             | **Not required** — the matching flags read `N/A`                                                                                                                                                                                                                                                                                       |
| Bug · refactoring · release                            | `../21-BUGS/` · `../22-REFACTORING/` · repo root                 | **Not required** — no bug, no restructure, no version bump                                                                                                                                                                                                                                                                             |

**What is forward-referenced today, measured 08/09/2026.**
"project-management/src/18-TESTS/US007-MANUAL-TESTING.md" is named by `../02-STORIES/US007.md`,
the QA plan and `../03-SPRINTS/SPRINT-01.md`; `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` names the
pattern `../18-TESTS/US###-MANUAL-TESTING.md` only, not the instance.
"project-management/src/18-TESTS/US007-TEST-STATUS.md" is named **nowhere in the tree**. The folder
holds only its pair and the two `US000-` templates.

---

## CONTEXT.md & Index Updates

| File                                          | Change required                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md`     | **Paid by `17-story-plans` Step 10, in the same change as this plan.** Its _Story Plans — the code master_ row for US007 points at this file with its Status cell filled `Not started` (the column's current value — see _Key Decisions_), **and the section's opening paragraph is rewritten to what is then true**: the clauses asserting absence and reservation — "US007's does not", "`17-story-plans` has not run for it, and it is a prerequisite of implementation this plan cannot supply", "What US007 has is a reserved **number**, `01-`", "the row below records the reservation and not a file" and "so a story with no plan has no value to mirror" — go, superseded wording kept in a dated comment after the table as `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` does. Its _Sprint Reference Documents_ **Story plans** and **QA** rows, its _Stories_ table Story-plan and Git-branch cells, and its _Branch Naming Reference_ row take this plan's path and `Branch` value |
| `../02-STORIES/US007.md`                      | **Paid by Step 10.** The STORY-PLAN RENAME comment's point (3) gains a dated note that the reservation was taken up; the story cites this plan in the form `../02-STORIES/US006.md` uses for its own                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `../17-STORY-PLANS/CONTEXT.md`                | **No row.** It ships, and its _The plans index_ section records that it holds no index by decision; the folder-level index is deferred to the register-index work charted in `../01-FEATURE-MAPS/`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `project-management/docs/planning/CONTEXT.md` | Only if `SPRINTS.md`'s new section changes what that pair says the three sub-documents own — checked, not assumed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `.claude/skills/CONTEXT.md`                   | No change — the skill's remit and description do not move; only its vocabulary section is rewritten                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `GAPS.md`                                     | The entry of 01/09/2026 closed by `22-implementation-documentation`, with its `MAP-RULE-OWNERSHIP.md` charting-home suggestion recorded as **untested and not required**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `DEFERRED.md`                                 | **One** row, written by `22`: the sprint value `In Progress`, which `SPRINTS.md` will define and nothing writes, targeted at `03-sprint-planning` and the `sprint` skill. The propagation-table row-3 hand-off is **N/A** with its reason — this story consumes no plans-index site                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |

**No new directory, so no new pair.** `docs-pairing.sh` has nothing to decide for this story; it
is captured anyway so "no new finding" has a before.

---

## Status Propagation & ClickUp Sync

**This section is the story's own subject, and the recursion is deliberate rather than awkward:**
the plan describing the repair follows the rule the repair will ratify.

On every status transition, the same value is set in this order:

| #   | Artefact                         | Where the status lives                                                                                                                                              |
| --- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | **Story — the source of truth**  | `../02-STORIES/US007.md` → `**Status:**` header. Edit here **first**; the only file the export reads                                                                |
| 2   | **This plan**                    | The `Status` cell of the metadata table above                                                                                                                       |
| 3   | **Sprint plan — story-plan row** | `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` → _Story Plans — the code master_ `Status` cell                                                                           |
| 4   | **Sprint record**                | `../03-SPRINTS/SPRINT-01.md` → _Story Summary_ — **which carries no status column today**, four columns only, so there is nothing to set until the record grows one |
| 5   | **ClickUp export (generated)**   | `project-management/export/clickup/` — **clickup-only**; never hand-edited, regenerated                                                                             |

Then, **clickup-only**, regenerate the export from the updated source story with
`bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US007`. A project
generated with `INCLUDE_CLICKUP: false` has neither the script nor the folder and skips the step.

**The vocabulary this plan's own `Status` cell uses is the template's eleven-value legend**, and
`Open` is also a value in the `completion` skill's five. Which set owns the column is precisely
what this story settles; this plan does not pre-empt its own outcome.

**The expected trajectory is `Open` → `In Review` → `Completed`, two writes on one moving field.**
`In Review` is written at `23-pr-and-review` Step 3 when the PR is raised — a legal intermediate
the skill records and the story leaves ordered — and `Completed` at the Definition of Done. A
before/after list taken between PR-raise and merge reads `In Review`, and that is predicted, not a
regression.

---

## Measured divergences

**Measured on disk 08/09/2026 at HEAD `98e3847`, 87 porcelain entries.** Each is a live claim in a
sibling artefact that the tree does not support. **None is edited by this plan** — a plan does not
correct the story it plans, nor a sprint record it is not the writer of — and each is named with
its owner so it is read as known rather than found.

| #   | Divergence                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Owner                                                                                                                    |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| 1   | **The mirror-cell count.** `../02-STORIES/US007.md` Scenario 8 states **five** and its `Then` clause lists values for four, omitting `Open` for US006; the Tasks table row states **four** and omits the US006 cell entirely. Five is correct today, six once this plan lands                                                                                                                                                                                                                                                                                                                                                                                                                         | The story's own re-count immediately before the edit, which the criterion already requires                               |
| 2   | **`../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` says "three live mirror cells" in live prose**, not in a dated comment. Superseded by the cascade and by the fourth plan                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | That plan's next `16-sprint-plans` pass                                                                                  |
| 3   | **`../03-SPRINTS/SPRINT-01.md` says US007's QA plan "does not yet exist"** — it exists, is `Signed off`, and the record contains zero occurrences of its filename. The record also owes "seven found, seven resolved" beside US001's "six found, six resolved"                                                                                                                                                                                                                                                                                                                                                                                                                                        | The sprint record's next pass. `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md`'s matching cell is fixed by this plan's Step 10 |
| 4   | **The branch-name formula's home.** **Three** sprint plans — `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`, `03-SPRINT-PLAN-03.md` and `04-SPRINT-PLAN-04.md` — attribute "`us###/<kebab-descriptor>`, five words or fewer" to `project-management/docs/GIT-GUIDE.md`; that guide and its sub-guides state only the shape `us###/<short-desc>`, with no case, word-count or digit rule. The formula lives in `../16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md` and `01-SPRINT-PLAN-01.md`                                                                                                                                                                                                                | `MAP-RULE-OWNERSHIP.md`'s line of work — a rule with two homes and neither the guide                                     |
| 5   | **`../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:213`** asserts `SPRINT-00-TEMPLATE.md` has no `**Status:**` field; it carries one at `:10`, committed. The story already elects to leave `:213` standing                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | A `wayfinder` RESOLVE session                                                                                            |
| 6   | **The four-file worktree rule versus the docker layer.** `./CLAUDE.md` and `./CONTEXT.md` require two per-story Nginx confs; `code/src/docker/nginx/CONTEXT.md` states there are none to generate. `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` named all four and marked the two confs not-generated rather than re-deciding it — this plan copies that treatment                                                                                                                                                                                                                                                                                                                        | Not this story's; raised, not resolved                                                                                   |
| 7   | **Two `.md` files under `project-management/docs/planning/` moved on 08/09/2026** — `STORIES.md` 97 → 104 counted, `SPRINTS.md` 88 → 93 — against the figures the story quotes from 07/09/2026. The story says "re-measured at implementation", so this is evidence for reading every figure as a method, not a gap                                                                                                                                                                                                                                                                                                                                                                                   | The implementer's re-measurement                                                                                         |
| 8   | **The `DEFERRED.md` row count.** `../03-SPRINTS/SPRINT-01.md` orders **two** US007 `DEFERRED.md` rows "as US007's own Definition of Done provides". That Definition of Done provides **one** — the sprint value `In Progress` — with the propagation-table row-3 hand-off recorded as **N/A**, the 08/09/2026 Plans-Index rewrite having left this story consuming no such site (QA plan R1). `DEFERRED.md` carries no US007 row today, so a second would be authored against the story's own `N/A`. `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` carried the same order at two sites and **was corrected in this plan's own Step 10 pass**, which is the writer of that file; the sprint record was not | The sprint record's next pass                                                                                            |
| 9   | **The source-`**Status:**` field count.** Scenario 12 counts **seventeen** — seven stories, four sprint records, six story plans (`Open` ×5, `Blocked` ×1), re-counted the evening of 08/09/2026 — and this plan's own metadata `Status` cell makes **eighteen**. The same case Scenario 12 already anticipates ("a story, sprint or plan added between now and then joins it") and the same one its evening comment records for US006's plan                                                                                                                                                                                                                                                         | The implementer's re-count at Phase 0, which supersedes both figures                                                     |

---

## Deferred Items

- **The folder-level plans index.** Not this story's — `MAP-REGISTER-INDEXES.md` slice `S-01`
  creates the file and `S-03` the gate over it, and `S-01` re-measures its population from the
  tree as it stands rather than inheriting any earlier count. The index's absence is already a
  recorded decision at `./CONTEXT.md` -> _The plans index_. **No `DEFERRED.md` row** — recorded as
  `N/A` with this reason, because the deferral is already on the record twice over.
- **The sprint value `In Progress`, which nothing writes.** `SPRINTS.md` will define it with a
  meaning and no instruction in this repository writes it into a record. Declared writer-less in
  the same words as `Rejected Customer`, **and handed on**: the one `DEFERRED.md` row this story
  opens, targeted at `03-sprint-planning` and the `sprint` skill. A sprint that can never legally
  enter its own middle state is a gap this story names rather than one it silently authors.
- **`Rejected Customer` has no writer in this repository today.** Declared so rather than assigned
  one — a value with no writer and a value with an unnamed writer read very differently.
- **The board-side mapping** in `.claude/skills/pm-tool-sync/SKILL.md` — seven strings in none of
  the eleven, and a transition driven off branch and PR events. A board-configuration decision,
  excluded from this story's population on the record.
- **The US005 plan-versus-story `Status` divergence** — plan `Blocked`, story `Open`, unexplained
  by any artefact. Recorded as pre-existing and routed to whoever owns US005's plan. Residual, not
  deferred.
- **`doc-references.sh`'s own repair** — `MAP-RULE-OWNERSHIP.md` slice `S-06`, carried by US004.
  **Nothing in that script is edited by this story.**
- **`../03-SPRINTS/SPRINT-01.md`'s two stale QA sentences and its two-row `DEFERRED.md` order**
  (divergences 3 and 8) — the record's own next pass. Named here so the debt is visible from the
  plan. The sprint **plan**'s matching claims were corrected by this plan's Step 10 pass, which
  is that file's writer; the sprint **record** is not this pass's file and is left to its own.

---

## Risks

| Risk                                                                                                                                      | Likelihood | Impact   | Mitigation                                                                                                                                                                                                                             |
| ----------------------------------------------------------------------------------------------------------------------------------------- | ---------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The baseline is captured **before** the untracked artefacts are staged, and 214 template-only findings clear as unexplained `<` lines     | **High**   | Medium   | Phase 0 step 1 stages first and says why; the QA plan's Correction carries the measurement                                                                                                                                             |
| An edit lands before the baseline is captured, so no finding can be attributed                                                            | Medium     | **High** | Phase 0 is first in a stated chain; ES-01 makes the recovery explicit — return to the pre-edit SHA and capture there                                                                                                                   |
| The detector moves between capture and close and the diff is charged to the story                                                         | Medium     | **High** | Five `git hash-object` values recorded at capture and **re-asserted at close**; a differing hash is detector-confounded, never the story's                                                                                             |
| The implementer inherits "four" mirror cells from the Tasks row and leaves US006's — or now US007's — uncorrected                         | **High**   | Medium   | Divergence 1 names it; the criterion already requires a re-count from the live tables; six is the figure after this plan lands                                                                                                         |
| A route is repointed to `Story Statuses` with a capital `S` and the read-across passes it by eye                                          | Medium     | Medium   | The heading is `## Story statuses`; the read-across opens each target in place, and the gate never reads past the arrow                                                                                                                |
| A "one writer" phase is fanned out to parallel writers and a false staleness claim ships                                                  | Medium     | **High** | The named hazard of the session that wrote this plan; Stage 2 forbids it, and the fan-out is restricted to read-only work                                                                                                              |
| An unscoped `lint.sh` / `format.sh` run reports on legs this story does not ship, so a green tick says more than the story earned         | Low        | Low      | Both are invoked `--file-type markdown` in the checklist and the command table, matching the sprint plan. Unscoped, both measured exit 0 on this tree on 08/09/2026 — the scoping narrows what is claimed, it does not avoid a failure |
| `STORIES.md` or `SPRINTS.md` crosses 270 after its gain                                                                                   | Low        | Medium   | 166 and 177 counted lines of headroom; measured by the gate before and after, and a dated allowance taken rather than assumed if crossed                                                                                               |
| A name work has yet to create is backticked and becomes a citation finding                                                                | Medium     | Low      | Every such name in this plan is in "double quotes"; the rule and its boundary are stated in Stage 2                                                                                                                                    |
| `doctrine-drift.sh` green is reported as "the doctrine has one home"                                                                      | Medium     | Medium   | It opens six of twenty-one files, fenced code only, and neither definition; the regime table says so beside the result                                                                                                                 |
| `skill-conformance.sh` fires `[house 14]` on the skill's path for a guide the story did not edit, and the finding is charged to the story | Low        | Medium   | Attribution is **path and cause**; the named guide is checked against the edit set before it is charged                                                                                                                                |
| The map edit is read as a licence to edit maps outside a `wayfinder` session                                                              | Low        | Medium   | It is written as a **stated exception** with its reason, and the three non-edits are recorded beside it                                                                                                                                |
| The `Not started` cells are backticked inconsistently across the six                                                                      | Medium     | Low      | One choice, applied to all six, recorded — the third plan's backticked form is the recommendation                                                                                                                                      |

---

## Docker & Nginx Infrastructure

**N = 7.** `how-to/docs/GIT-WORKTREES.md` fixes the loopback rule — the final octet equals the
story number, `127.0.0.1` being the main stack — so the IP is `127.0.0.7`, and it is **free**:
`127.0.0.7` returns zero hits repo-wide (measured 08/09/2026), and no other story carries the
number 7. The subnets follow `code/src/docker/CONTEXT.md`: second octet the story number, third
octet 1 for dev and 0 for test.

| File                                            | Purpose                                                                                                                                                                                     |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us007.dev.yml"  | Dev stack override — copied from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us007`; nginx published on `127.0.0.7:3080:80`; subnet `10.7.1.0/24` |
| "code/src/docker/docker-compose.us007.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us007`; `127.0.0.7:3081:80`; subnet `10.7.0.0/24`                        |
| "code/src/docker/nginx/dev-us007.conf"          | Named per `./CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                                 |
| "code/src/docker/nginx/test-us007.conf"         | Same                                                                                                                                                                                        |

**The two Nginx files are named because the folder's rule names them, and the docker layer says
they do not exist.** `code/src/docker/nginx/CONTEXT.md` states that `dev.conf` and `test.conf` are
`server_name _` catch-alls a worktree stack reuses unchanged, and that "there are no per-story
Nginx variants to generate"; `code/src/docker/CONTEXT.md` -> _Worktree stacks_ says the same. The
two compose overrides are the files a worktree actually creates; the two Nginx names are recorded
so the four-file convention is satisfied on paper and the reader is told which half is real. That
disagreement between `./CLAUDE.md` and the docker layer's own orientation is **not this story's to
settle** — it is divergence 6 above, and `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` set this treatment
on 08/09/2026.

Every path in the table is in quotes because none exists until the worktree does; the two example
files they are copied from do exist and are backticked. **A second contradiction to know rather
than resolve:** the plan template names three dev ports (`3080`/`3082`/`3180`) where
`docker-compose.usXXX.dev.yml.example` binds only `127.0.0.NNN:3080:80`. The example is the file
that gets copied.

`/etc/hosts` (one-time per story — `bash code/src/scripts/development/hosts-story-add.sh us007`,
reversed by `hosts-story-remove.sh`):

```text
127.0.0.7 dev-us007.<%PROJECT_SLUG%>.localhost test-us007.<%PROJECT_SLUG%>.localhost
```

The worktree-aware scripts auto-detect the `us007/` branch through `_lib/worktree-detect.sh` and
layer the two overrides in.

**A note on what the worktree is for here.** This story ships Markdown and runs no stack — the
five gates are local shell scripts over text. The worktree is for **isolation from the parallel
story**, not for a running application: `.claude/worktrees/` holds a second copy of every file,
which is exactly the population hazard Scenario 9's closing grep is stated against.

---

## Sprint Verification Checklist

Run before declaring done. Every command is a project script under `code/src/scripts/**/*.sh`.

```bash
# The five gates, in the order the QA plan's Section 6 captures them
bash code/src/scripts/audits/doc-references.sh
bash code/src/scripts/audits/skill-conformance.sh
bash code/src/scripts/audits/doctrine-drift.sh
bash code/src/scripts/audits/docs-pairing.sh
bash code/src/scripts/audits/docs-length.sh

# The two rulers — measurements, never legs (QA plan Section 6, step 6)
bash code/src/scripts/audits/docs-length.sh --path project-management/docs/planning --limit 1
bash code/src/scripts/audits/docs-length.sh --path .claude/skills/completion --limit 1

# Markdown syntax — scoped: the unscoped default set includes container-bound Python legs
bash code/src/scripts/syntax/format.sh --file-type markdown --fix
bash code/src/scripts/syntax/lint.sh --file-type markdown --fix

# The detector must be the one that produced the baseline (QA plan Section 6, step 2)
for g in doc-references docs-pairing doctrine-drift skill-conformance docs-length; do
  printf '%s  %s\n' "$g" "$(git hash-object "code/src/scripts/audits/$g.sh")"
done

# The closing casing check, with its stated pathspecs
git grep -nw "In progress" -- '*.md' '*.sh' '*.yml' \
  ':!handoffs/' \
  ':!project-management/src/02-STORIES/US007.md' \
  ':!project-management/src/11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md' \
  ':!project-management/src/18-TESTS/US007-MANUAL-TESTING.md'
```

- [ ] Every detector hash matches the value recorded at capture — otherwise the diff is
      **detector-confounded** and is reported as such, never as this story's
- [ ] `doc-references.sh` — no `>` line whose file is in the edit set, by identity; **never
      reported as passing while a non-empty baseline stands**
- [ ] `skill-conformance.sh` — exit 0 against an empty baseline **is** the pass, and is reported
      as one; no violation attributable to `.claude/skills/completion/SKILL.md` by path **and**
      cause
- [ ] `doctrine-drift.sh` — the same three claims, one home each; reported as a regression guard
      over six of twenty-one files, fenced code only, and never as having read a definition
- [ ] `docs-pairing.sh` — an identity diff of two empty sets, with the record stating that the
      gate decided nothing here
- [ ] `docs-length.sh` tree-wide exits 0; `STORIES.md`, `SPRINTS.md` and `completion/SKILL.md` all
      under 270 by the gate's own figure, before and after
- [ ] Markdown lint and format pass, both scoped `--file-type markdown`
- [ ] The closing casing grep returns zero over its stated population
- [ ] `syntax/check.sh`, `migrate.sh check`, `tests/all.sh --coverage`, the template/component
      tests and the accessibility walk — **N/A**, each with its reason recorded, never ticked
- [ ] No secrets, debug flags or hardcoded IDs introduced

---

## Definition of Done

- [ ] `project-management/docs/planning/STORIES.md` is the **only** document that defines the
      eleven, with a meaning against each, a board-neutral defining sentence, the per-register
      scoping declaration stated rule-first with its registers illustrative and non-exhaustive,
      and the one-line pointer at the writer declaration
- [ ] `project-management/docs/planning/SPRINTS.md` carries a _Sprint statuses_ section holding
      `Planned` · `In Progress` · `Done`, one meaning each
- [ ] `PLANNING-GUIDE.md` gains **no** `Story Statuses` section
- [ ] `.claude/skills/completion/SKILL.md` restates neither set: two routes, the five it may write
      and the sprint `Done`, a writer table naming the owner of each remaining value, and an
      explicit statement that the table is a declaration of authority and not a definition
- [ ] The three stale `PLANNING-GUIDE.md → Story Statuses` routes reach
      `planning/STORIES.md` -> _Story statuses_, with the heading's lower-case `statuses`
- [ ] The five sprint ownership comments route to `SPRINTS.md` -> _Sprint statuses_ — and the four
      live sprint records take **no other edit** from this story
- [ ] `23-pr-and-review/CHECKLIST.md` and `24-release/CHECKLIST.md` each gain a box for the writes
      their `STEPS.md` order
- [ ] The four shipped surfaces are board-neutral and marked: `SPRINT-00-TEMPLATE.md`,
      `00-SPRINT-PLAN-00-TEMPLATE.md`, `00-STORY-PLAN-US000-TEMPLATE.md`, `.copier/README.md` —
      with the story-plan template's rows neither removed nor renumbered, and its `:9` header
      pick-list confirmed **left standing** as the field's legend
- [ ] **Every `Not started` mirror cell** under _Story Plans — the code master_ — **six** once
      this plan lands, re-counted from the live tables immediately before the edit — reads the
      value its named plan carries in its `| Status |` header row, backticked consistently; and
      **no story plan's own `Status` field is edited**
- [ ] `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:215-219` is corrected as a **stated exception**; `:213`,
      `:456-469` and `:556` stand, and the one edit and three non-edits are recorded with reasons
- [ ] `../18-TESTS/US000-MANUAL-TESTING.md` is normalised to `In Progress`, casing only
- [ ] The closing `git grep -nw "In progress"` returns zero over its stated population and
      pathspecs, recorded verbatim
- [ ] Zero live source `**Status:**` values change but this story's own, whose trajectory is
      `Open` → `In Review` → `Completed` — two writes on one moving field
- [ ] The named-site inventory exists with a **role** column, and shows exactly one definition row
      per set
- [ ] "project-management/src/18-TESTS/US007-MANUAL-TESTING.md" exists and carries the baselines,
      the detector hashes, the four identity diffs, the before/after source list, the six mirror
      cells, the read-acrosses and the casing grep — every figure with its date
- [ ] `23-pr-and-review/CHECKLIST.md`'s automated-test-status box is ticked **N/A** with its
      reason — no code path, so no test status and no coverage figure — and no
      "US007-TEST-STATUS.md" is authored
- [ ] A tester other than the author has signed the walk-through off
- [ ] All five gates recorded under their stated regimes, with **no plain pass reported where the
      gate could not decide the question**
- [ ] Story `**Status:**` moved to `Completed`; this plan's `Status` cell and its row in
      `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` -> _Story Plans — the code master_ mirror it
- [ ] `GAPS.md`'s entry of 01/09/2026 closed and `DEFERRED.md`'s **one** row written, both by
      `22-implementation-documentation`
- [ ] PR raised and promoted via `23-pr-and-review/`; review record in `../19-REVIEWS/`
