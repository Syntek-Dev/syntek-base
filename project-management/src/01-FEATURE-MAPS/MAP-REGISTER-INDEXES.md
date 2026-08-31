# MAP-REGISTER-INDEXES — an index per register, and a gate that keeps it true

**Charted**: 28/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `7a82095` — **graduated out of `MAP-RULE-OWNERSHIP.md` N-010, which settled the
map-folder case and claimed the rest (Q38, 28/08/2026)**
**Status**: Blockers clear — stories may start
**Frontier open**: 0 · **Blocking open**: 0

> **Written from `MAP-000-TEMPLATE.md`.** Its instruction _"add a row to `CONTEXT.md` → Map index"_
> was **declined here on the record**, and this map was the tenth to decline it. **N-001 settled
> the work that makes the row addable, 31/08/2026**: the table leaves the shipped `CONTEXT.md` for
> a seeded `MAP-INDEX.md`. **The decline stands until `S-01` builds it** — and the reason recorded
> for it was measured and found wrong, which is the first correction in Batch A below.

---

## Destination

Every register folder that accumulates instances carries an **index file** listing them, the index
is **written from the same change as the instance**, and a **gate** fails when it is not — so an
index cannot silently drift the way `01-FEATURE-MAPS/CONTEXT.md`'s has for ten maps.

---

## Notes

| Field                    | Value                                                                                                                                                                                        |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | PM artefact structure · the copier shipping seam · audit gates                                                                                                                               |
| Skills to load           | `wayfinder` → `grill-with-docs`; `scaffold` and `doc-writer` for the writes; `cicd` for the gate's CI registration                                                                           |
| Standing preferences     | **Q35–Q38, answered by Sam 28/08/2026** — see the table below. Plus: _no story is cut until the frontier is empty_                                                                           |
| Umbrella ADRs            | **None — declined 31/08/2026**, the fifteenth consecutive decline on the house rule. Whether that rule survives is `MAP-PROGRESSIVE-ENHANCEMENT.md` N-026, and this map does not pre-empt it |
| Register entries triaged | 0 closes · 0 blocks · 0 unrelated — **over zero triable entries** (see Register claimed)                                                                                                     |

**The four answers this map is chartered on.** They are **inputs**, not resolved nodes: they were
settled on `MAP-RULE-OWNERSHIP.md` before this map existed, and no node below may reopen them.

| Q   | Question                         | Answer                                                                                                                                                                                              |
| --- | -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q35 | What is a register index called? | **`<THING>-INDEX.md`**, for indexes of **files**. The six GDPR registers at `copier.yml:170-176` stay bare nouns — they register **facts**, not instances. **N-001 sharpened `<THING>`** (below)    |
| Q36 | Which registers get one?         | **The strong seven** — `01-FEATURE-MAPS`, `02-STORIES`, `03-SPRINTS`, `15-DECISIONS`, `17-STORY-PLANS`, `20-FINDINGS`, `21-BUGS`                                                                    |
| Q37 | What keeps them honest?          | **Both** a skill duty and a gate, on `incident/SKILL.md:132`'s precedent — **the gate is the load-bearing half**                                                                                    |
| Q38 | Does this belong on that map?    | **No — its own chart.** Seven shipped files each needing a copier negation, a `shipped-artefacts.sh` registration and a new gate is a different cause from _a rule with two homes_                  |
| Q45 | Where is the index gate tested?  | **Fixtures plus `.github/scripts/shipped-artefacts.sh`**, never the real tree alone — answered on `MAP-RULE-OWNERSHIP.md` Batch H, 28/08/2026, because the same question governs its template guard |

**Q38's premise is superseded by N-001, and the chart still stands.** There is **no copier
negation** — the seven ride the seed-once `_tasks` mechanism instead. The chart is justified by
scope, not by that mechanism.

**The 24-register survey behind Q36**, recorded here because it existed only in a session that has
ended: **strong (7)** as above · **moderate (6)** `04-DATABASE`, `05-USER-FLOW`, `09-GDPR`,
`10-SECURITY`, `18-TESTS`, `22-REFACTORING` · **weak (5)** `08-WIREFRAMES`, `12-SEO`,
`13-API-DESIGN`, `14-LOGGING`, `19-REVIEWS` · **no (5)** `00-ASSETS`, `06-BRAND-GUIDE`,
`07-COMPONENTS`, `11-QA`, `16-SPRINT-PLANS`. `23-INCIDENTS` already has one.

---

## Register claimed

**Nothing to claim, and the count is provable rather than assumed.** `GAPS.md:28` records that
_"the active items were charted off this file"_; what remains is the three **standing
limitations** `SL-1` to `SL-3`, none of which this feature touches. `DEFERRED.md` holds **no
rows**. So the triage is **0 closes · 0 blocks · 0 unrelated over zero triable entries** — an
empty triage that is exhaustive, not a triage that was skipped.

**Two entries were created after charting, and exactly one is claimed.** Both were surfaced by
resolve sittings rather than inherited, so neither was in the triage above.

| `GAPS.md` entry (31/08/2026)                        | Verdict     | Why                                                                                                                      |
| --------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------ |
| `shipped-artefacts.sh`'s unchecked `SEEDED` array   | **created** | True with or without these seven files; no slice here fixes it. N-003 cites it as an input                               |
| The Plans Index, gated in eight places, never built | **claimed** | `S-01` creates `17-STORY-PLANS/STORY-PLAN-INDEX.md` — the file all eight citations should have named — and repoints them |

**Creating an entry is not claiming one.** A claim promises retirement; only the second earns one,
and it is retired when `S-01` ships, never by this map.

**This is a claim surface, not a close surface.** Nothing here edits either register to mark
anything done; closing belongs to `workflows/22-implementation-documentation/`, against shipped
code.

---

## Resolved decisions

| Node  | Decision                                                                                                                                                                       | Type     | Settled    | Became                                                                                                       |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------- | ------------------------------------------------------------------------------------------------------------ |
| N-001 | An index lives **inside its register folder**, **excluded and seeded** from `.copier/<NOUN>-INDEX.md`; `<THING>` is the folder's own noun, singularised                        | grilling | 31/08/2026 | Slice **S-01** · the naming rule below                                                                       |
| N-005 | They ship **present and blank**, uniformly across all seven — by seed, not by copier negation                                                                                  | grilling | 31/08/2026 | Slice **S-01** · one new `GAPS.md` entry (created, not claimed)                                              |
| N-002 | **A shared spine, a per-register tail.** Spine: `Status · Instance · Summary · Updated`. Status mirrors the artefact verbatim; ordering is per register and stated in the file | grilling | 31/08/2026 | Slice **S-01** · the spine below                                                                             |
| N-006 | **Backfill**, and the ten maps become the red-able population N-003 keys its gate against                                                                                      | grilling | 31/08/2026 | Slice **S-02**, no longer provisional · an input to N-003                                                    |
| N-003 | The gate asserts **presence · symmetry · status**, in its own `audits/register-indexes.sh`, pre-commit **and** in CI                                                           | grilling | 31/08/2026 | Slice **S-03**                                                                                               |
| N-004 | **The duty attaches to the artefact template, not to a skill** — and ships in the same change as its gate                                                                      | grilling | 31/08/2026 | Slice **S-03** · schema graduates to `project-management/docs/ARTEFACT-FRONTMATTER.md` (written by **S-04**) |

### Batch A — N-001 and N-005 settled 31/08/2026

**One answer, asked from two sides, exactly as the batch predicted.** A non-shipping location is
what lets a per-project instance row exist; excluded-and-seeded is the only shape that is true in
**both** trees at once — real rows here, blank downstream, and seed-once so `copier update` can
never hand a project its stub back over a filled-in index. It is the mechanism
`.claude/CLAUDE.md` Section 9 already names for accumulators, and an index of instances **is** an
accumulator.

**The seven names, and the rule that produces them.** `<THING>` is the register folder's own noun,
**singularised** — not the artefact's filename prefix. The rule is exceptionless and it _explains_
the sole precedent rather than special-casing it: `23-INCIDENTS` → `INCIDENT-INDEX.md` falls out
of it unchanged.

| Register          | File                  |
| ----------------- | --------------------- |
| `01-FEATURE-MAPS` | `MAP-INDEX.md`        |
| `02-STORIES`      | `STORY-INDEX.md`      |
| `03-SPRINTS`      | `SPRINT-INDEX.md`     |
| `15-DECISIONS`    | `DECISION-INDEX.md`   |
| `17-STORY-PLANS`  | `STORY-PLAN-INDEX.md` |
| `20-FINDINGS`     | `FINDING-INDEX.md`    |
| `21-BUGS`         | `BUG-INDEX.md`        |

`US-INDEX.md` was rejected because `US` names a numbering scheme, not a thing. `DECISION-INDEX.md`
was taken over `ADR-INDEX.md` deliberately: `15-DECISIONS/CONTEXT.md:20` reads _"There is no
`ADR-###` index; it was retired 31/08/2026"_ — that is the **numeric** index, retired by the
`ADR-US###-<DECISION>-DD-MM-YYYY.md` rename, but an `ADR-INDEX.md` beside that sentence gives one
folder two senses of the word.

**Registration is three surfaces, and they are not the three that were charted.** A
`.copier/<NOUN>-INDEX.md` file · an `mv` line in the `copy`-gated `_tasks` entry
(`copier.yml:908-919`) · a `SEEDED` registration in `.github/scripts/shipped-artefacts.sh:105`.
**No `_exclude` negation is needed** — `/project-management/src/**` already covers the path — and
`doc-references.sh:322` parses `SEEDED` out of `_tasks`, so the citation audit needs no edit at
all.

**`MAP-INDEX.md` is the one seed that does not arrive blank.** A generated project's
`01-FEATURE-MAPS` is not empty on day one: `project-management/src/01-FEATURE-MAPS/MAP-SCALE-PLANNING.md`
is seeded beside it. The seed therefore carries that one row with every column `TBD`, matching how
that map is itself seeded stub-first. A blank index in a folder holding one file would repeat, one
level up, the dangling-route defect the seeded map exists to cure. The
`CONTEXT.md:53-56` prose explaining why that map has no row retires with the table.

**Four literals corrected — measured at `b03b6ab`, not reasoned.**

| Claim                                                                                           | Measured                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| This map's header: the index row is _"the defect `audits/doc-references.sh` exists to prevent"_ | **Not today.** `doc-references.sh:306` exempts `project-management/src/01-FEATURE-MAPS/*` from all three checks, including the shipped `CONTEXT.md`, so the row raises **zero findings**. That arm's own comment (_"none of these ship"_) is falsified by `copier.yml:152-156` — it **is** N-009's defect, and `MAP-RULE-OWNERSHIP.md` **S-06** is the unbuilt fix. Post-S-06 the row trips **Check 3**, not Check 2: Check 2 has an arm at `:610` resolving `MAP-*` against the real folder. **The conclusion survives its reason** — the row would ship ten false statements about syntek-base, and `shipped-artefacts.sh:45-46` says outright it cannot check content |
| N-003: _"the strong seven hold zero instances"_                                                 | **False for one.** `01-FEATURE-MAPS` held **8** at `7a82095` and holds **10** now. The six reading `templates=1, other=0` are `02`, `03`, `15`, `17`, `20`, `21`; the count substituted `23-INCIDENTS`, which is the **precedent** and not one of the seven. True of a generated tree, false of this repository                                                                                                                                                                                                                                                                                                                                                          |
| N-005: _"three registration surfaces"_                                                          | **Right number, wrong three.** The charter named a copier negation, `NAMED_SHIPPED` and the `doc-references.sh` arms, and missed **excluded-and-seeded** entirely — the mechanism `GAPS.md`, `DEFERRED.md`, `MEMORY.md` and `MAP-SCALE-PLANNING.md` already use                                                                                                                                                                                                                                                                                                                                                                                                          |
| `copier.yml` line references throughout this map                                                | Drifted. The `!**/CONTEXT.md` negation is **152-156**; the `INCIDENT-INDEX.md` negation **180-181**; `NAMED_SHIPPED` **90-101**; `SEEDED` **105**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |

**Amended by Batch B, 31/08/2026.** Batch A settled the retired `## Map index` section on a
**Cross-references line**. That is overturned: `23-INCIDENTS/CONTEXT.md:57-62` — the only working
index in the repository — keeps a **`## The index` H2** carrying the link _and_ the reading rule,
which a line in a list cannot. All seven `CONTEXT.md` files take the H2, and `23-INCIDENTS` is
already correct.

**Deliberately not done in this sitting.** The ten maps' `Gate to stories` checklist wording is
**one later sweep**, excluded from the parallel resolve window by the 31/08 handoff because
`MAP-PROGRESSIVE-ENHANCEMENT.md` was held by a concurrent session. `MAP-000-TEMPLATE.md` is **not**
one of the ten — it is shipped template content, and repointing its `:8` instruction and `:146`
checklist line belongs to `S-01`, because a shipped file instructing a rule we have just replaced
is the same _prose duty contradicted by another rule_ that N-010 diagnosed.

### Batch B — N-002 and N-006 settled 31/08/2026

**Shared subject, and the shared evidence was the templates.** Reading all seven artefact
templates settled both nodes and turned up two defects neither node had predicted.

**N-002 — a shared spine, a per-register tail.** A single column set is not merely undesirable, it
is unrepresentable: the seven registers run seven status vocabularies, and one column cannot hold
`17-STORY-PLANS`'s **eleven** states and `15-DECISIONS`'s supersession chain at once.

| Spine column | Holds                                                              |
| ------------ | ------------------------------------------------------------------ |
| `Status`     | The artefact's **own** value, mirrored verbatim — never translated |
| `Instance`   | A Markdown link to the file, labelled with its descriptor          |
| `Summary`    | One line, plain English, for someone who has not read the file     |
| `Updated`    | `DD/MM/YYYY` — the only date every register can produce            |

`Instance` and `Summary` stay separate on the `INCIDENT-INDEX.md` precedent, where the link is
labelled `SEARCH-OUTAGE` and the summary is _"written for someone who was not there"_. A
filename-derived label alone is the _cache of the filesystem_ this map's own fog of war warns is
worse than no cache. Each register's own dates — `Charted`, `Raised`, `Date found` — are **tail**.

**Status mirrors verbatim, and that is a gate decision, not a style one.** N-003 can assert _index
status equals file status_ only where they are the same string; a coarse shared lifecycle would
make the gate assert a mapping table instead, which is the gate-designed-against-a-guess failure
Batch C's ordering exists to avoid.

**Ordering is tail, and must be stated in each file.** Descending by date where the register is
event-like (`MAP`, `FINDING`, `BUG`); ascending by identifier where it is a sequence (`STORY`,
`SPRINT`, `STORY-PLAN`, `DECISION`). `US001 … US043` reads backwards descending and an incident
register reads backwards ascending — but a gate can only assert an order the file declares.

**N-006 — backfill, and the ten maps stop being a backlog and become the fixture.** Starting clean
would make the gate pass on a file complete only going forward, which is the drift this map exists
to stop, arriving on day one by design. Backfill costs a measured read of ten headers, all of
which this sitting already held. **Q45 routed the gate to fixtures because it believed the
population was zero, and that premise was already false** — these ten are the only real instances
in the repository, so they are what proves a clause can go red without a synthetic fixture.
Q45 still holds as written: _never the real tree alone_.

**Two defects found in passing, both class E, declared not built.**

| Defect                                                                                                                                                                                              | Disposition                                                            |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **The Plans Index is gated in eight places and has never existed** — `17-STORY-PLANS/CONTEXT.md` has no such H2, while a `CHECKLIST.md` box and four sites in the **shipped** plan template name it | `GAPS.md` 31/08/2026, **claimed** — `S-01` creates the file they meant |
| **`SPRINT-00-TEMPLATE.md` has no `**Status:**` field**, though `completion/SKILL.md:42` edits one _"in the `SPRINT-##.md` header"_ and defines its vocabulary                                       | Rides `S-01` — a one-line repair `SPRINT-INDEX.md` depends on          |

**One Round 1 finding corrected before it was acted on.** The story and sprint status vocabularies
are **not** undocumented — `completion/SKILL.md:37-42` owns both (`Pending · Open · Blocked · In
Review · Completed`; `Planned · In progress · Done`). They are absent from the _templates_, not
from the repository, so the sprint repair adds a field to an existing vocabulary and invents
nothing.

**Left open, deliberately.** `17-STORY-PLANS`'s eleven states include `Accepted Customer` and
`Rejected Customer`, which no `US###.md` can hold — yet the plan template requires the status to
agree _"across story + plan + Plans Index + sprint"_. Two vocabularies that must agree and cannot
is a real defect, and it is **not this map's**: it belongs to whoever owns the story lifecycle.
Recorded in Fog of war rather than charted here.

### Batch C — N-003 and N-004 settled 31/08/2026

**N-003 — the gate asserts three things, and instance recognition turned out to be mechanical.**
A file in one of the seven is an instance **iff** it is a tracked `.md` that is not `CONTEXT.md`,
not `CLAUDE.md`, not `*TEMPLATE*`, and not the index itself. Exceptionless: `18-TESTS` was the
known counter-example and is not one of the seven, and the seeded
`project-management/src/01-FEATURE-MAPS/MAP-SCALE-PLANNING.md` is a genuine instance that Batch A
already gave a row.

| Clause   | Asserts                                                 |
| -------- | ------------------------------------------------------- |
| Presence | The index file exists, and **every instance has a row** |
| Symmetry | **No orphan rows** — every row's file is present        |
| Status   | The row's `Status` **string-equals** the file's         |

**Ordering is deliberately not asserted.** It fails on a legitimate same-day tie, and a gate people
learn to ignore is worse than none — so it stays a stated rule under reviewer judgement, on
`docs-pairing.sh`'s own precedent that the mechanical half is scripted and the readable half is not.

**Its own script, not a clause elsewhere.** `code/src/scripts/audits/register-indexes.sh`, with a
`broken/`+`clean/` fixture pair, a `--self-test`, one `audit-register-indexes.yml` emitting
`--output md`, **and** a `lefthook.yml` entry beside `docs-pairing.sh` — the failure it catches is
_"wrote the instance, forgot the row"_, which is free to fix in the same commit and tedious three
days later. Folding it into `docs-pairing.sh` would make that script's denominator lie: it asserts
something true of **every** directory, this of seven named ones. Folding it into
`shipped-artefacts.sh` cannot work at all — that asserts what a **generated** project receives,
which is the blank seed, and can say nothing about ten rows in this repository. **Q45 stands as
written**: it names where the gate is _tested_, not where it lives.

**N-004 — the duty attaches to the artefact template, and that is a correction to the node as
charted.** _"Which skill gains the duty"_ is unanswerable for two of the seven: `15-DECISIONS` has
no owning skill at all (`CLAUDE.md:16` — _"an ADR is authored, not scaffolded"_) and `20-FINDINGS`
has three (`database`, `code-reviewer`, `qa-tester`). `21-BUGS` **does** have one, `bugfix`, but
files from three entry points. The template is the only surface that exists **exactly once per
register** and is guaranteed to be in the author's hands whichever door they came through.

**And repetition was never the missing ingredient.** `17-STORY-PLANS` has a single owning skill
and wrote the duty in **eight** places, including a `CHECKLIST.md` tick-box — and its destination
has never existed. The template says it **once**; the gate does the rest. That is Q37 as designed.

**The duty ships with its gate, in `S-03`, never with the index in `S-01`.** Both orderings leave
a one-release window in which the index can drift, so that is not the discriminator. The
discriminator is what a **shipped template** claims: a duty landing a release before its gate
recreates the exact `17-STORY-PLANS` state this map was chartered on.

### The artefact frontmatter schema — settled 31/08/2026, graduates to a guide

Scope was widened by Sam mid-sitting from the seven index files to **every artefact under
`project-management/src/`**. Measured population: **62** — 43 templates and 19 live instances. The
other 138 `.md` files there are the `CONTEXT.md`/`CLAUDE.md` pair, which take **no** artefact
frontmatter; they are orientation and rules, policed by `audits/docs-pairing.sh`.

**This completes a partial rollout rather than starting one.** Three templates already carry
frontmatter — one under `13-API-DESIGN`, two under `14-LOGGING` — on a five-key shape, and they
already disagree with each other about whether a body status line survives beside it.

**Universal, all 62:** `Title` · `Owner` · `Author` · `Date Created` · `Date Updated` · `Version` ·
`Status` · `Summary` · `Sources` · `Workflows` · `Linked Files`.

- **`Owner` decides; `Author` writes and maintains.** Two different people, deliberately.
- **`Version` is a revision counter, not semver** — so `project-management/docs/VERSIONING-GUIDE.md`
  needs no amendment. Its line 175 forbids _"a versioning document anywhere else in the tree"_, and
  a semver key on 62 artefacts would be exactly that. The three existing `0.1.0` values normalise.
- **`Status` mirrors the body, which stays canonical**, because the body is what reaches a client
  PDF and frontmatter does not render there. Everything else is frontmatter-native, so the mirror
  owns `Status` alone (plus `Title` / `Date Updated` where a body header carries them).
- **`Sources` / `Workflows` / `Linked Files`** are three path registers per artefact. They would be
  **entirely unpoliced** as specified — `audits/doc-references.sh` reads **backticked tokens only**
  — so that script gains frontmatter path values as a fourth token source. Building 186 unguarded
  pointer lists would be this map creating its own defect class while curing it.

**Conditional keys, and the one rule that places them:** _a key appears only where its value is not
already the file's own identity._

| Key                         | Applies to                                                                                                     |
| --------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `Story: US###`              | Everything story-anchored — `04`–`14`, `15-DECISIONS`, `17`–`22`. **Not** `02-STORIES`, `01`, `03`, `16`, `23` |
| `Sprint: ##`                | `02-STORIES`, `16-SPRINT-PLANS`, `17-STORY-PLANS`. **Not** `03-SPRINTS`                                        |
| `Flags:`                    | `02-STORIES`, `03-SPRINTS` (the union)                                                                         |
| `MoSCoW:`                   | `02-STORIES`                                                                                                   |
| `Story Points: ##/CAPACITY` | `02-STORIES`, `03-SPRINTS`, `16-SPRINT-PLANS`                                                                  |
| `PK Type:` · `Tenancy:`     | `04-DATABASE`                                                                                                  |

**Two placements derived rather than asked, and named as the contestable ones:**
`01-FEATURE-MAPS` takes no `Flags:` (they live per-slice in the body table, and a file-level union
is a fourth place they must agree); `23-INCIDENTS` takes no `Story:` (its `CONTEXT.md` states an
incident is not owned by a story).

**The incident register takes `Owner` and `Author` — a decision, and it obliges an edit.**
`23-INCIDENTS/CLAUDE.md:40-42` reads _"never an individual, by name or by implication… not
negotiable in a register that ships"_. **Sam, 31/08/2026: the people who decide and who
investigate are not the people to blame.** The narrative stays blameless; the **custodianship** is
attributed. That carve-out is written into that file in the **same change** as the frontmatter, or
the rule and the practice disagree permanently.

**A third defect found on the way there, class D, split doctrine.** The blameless rule has a
**circular attribution**: `23-INCIDENTS/CLAUDE.md:41` says it mirrors
`code/docs/security/MONITORING-AND-INCIDENT.md`, and `how-to/docs/INCIDENT-PRACTICE.md:146` says
that file _"already states the rule"_ — **it does not**. It states the register is PII-free and
routes the blameless postmortem back to `INCIDENT-PRACTICE.md`. Two files defer to a third that
never carried it. `S-04` repairs it while it is there.

---

## Slices

Cut 31/08/2026, at Step 8a, on N-001 — the only blocking node — being settled. **Rows, not
stories:** per Sam's standing preference `02-story-creation` does not run until the frontier is
empty, so the `Story` column stays `—`.

**The 13-flag roster is application-shaped and this work is template plumbing**, so most flags are
`N/A` and omitted. That is the honest manifest, not a thin one.

| Slice | Story | Title                                                    | Nodes | Acceptance | Flags                                                                                                                                                                       |
| ----- | ----- | -------------------------------------------------------- | ----- | ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| S-01  | —     | Wire seven seeded register indexes                       | TBD   | TBD        | QA: unit (`shipped-artefacts.sh --self-test`), integration (generation smoke, `audit-template.yml`) — seed-lands, seed-blank                                                |
| S-02  | —     | Backfill `MAP-INDEX.md`, and correct the rows it indexes | TBD   | TBD        | QA: manual — row-per-map, counts match each header, and no `Umbrella ADRs` row still asserts the reversed no-ADR rule                                                       |
| S-03  | —     | The index gate, and the duty it enforces                 | TBD   | TBD        | QA: unit (`register-indexes.sh --self-test`, `broken/`+`clean/` fixtures), integration (lefthook + `audit-register-indexes.yml`) — missing-row, orphan-row, status-mismatch |
| S-04  | —     | Artefact frontmatter across `project-management/src/`    | TBD   | TBD        | QA: unit (mirror `--check`, `doc-references.sh --self-test`), manual — 62 artefacts, PDF export unaffected                                                                  |

**The `Nodes` and `Acceptance` columns were added 31/08/2026** with the `task` -> `build`
type change. Cells reading `TBD` are **not empty, they are unbackfilled** — this map's next
RESOLVE sitting fills them, and until it does the checklist item _every open node belongs to a
slice_ is unverified here.

**S-02 absorbed the superseded-ADR-wording sweep, 31/08/2026.** Each live map's `Umbrella ADRs`
row still asserts the house rule that `MAP-PROGRESSIVE-ENHANCEMENT` N-026 reversed the same day.
It is the same population, the same measured read and the same pass as the index backfill, so it
**widens this slice rather than earning one of its own**. It was carried here out of
`.claude/MEMORY.md`, where a pending sweep does not belong — that file holds patterns and project
state, and `.claude/CLAUDE.md` Section 9 routes unfinished work to `GAPS.md` or a map.

Measured 31/08/2026, and **the count is eight, not the ten the memory entry claimed** — itself an
instance of the re-measure rule now in `STEPS.md` Step 8.1:

| Row                               | State                                                                                                                                                                                                                                                     |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MAP-CLAUDE-DESIGN-HANDOFF.md:35` | **Flatly wrong** — "none is possible; this template authors no ADRs"                                                                                                                                                                                      |
| `MAP-NAVIGATION.md:48`            | **Flatly wrong** — "this repository does not write ADRs"                                                                                                                                                                                                  |
| `MAP-SUBDOMAIN-ROUTING.md:48`     | Superseded — cites the 16/08 house rule as live                                                                                                                                                                                                           |
| `MAP-UPSTREAM-TRACKING.md:44`     | Superseded — same wording                                                                                                                                                                                                                                 |
| `MAP-RETRY-AND-IDEMPOTENCY.md:36` | Superseded twice — and "ADRs are workflow `15`" is now wrong too, `15` being the coherence gate, not the author                                                                                                                                           |
| `MAP-GATE-PARITY.md:50`           | Superseded — same wording                                                                                                                                                                                                                                 |
| `MAP-REGISTER-INDEXES.md:32`      | This map's own row — "whether that rule survives is N-026" is now answered                                                                                                                                                                                |
| `MAP-ABSENCE.md:84`               | **Borderline, re-measure at the sweep** — its stated reason survives N-026, only its "settled precedent" framing does not; it also had uncommitted concurrent-session edits when this was written, so trust neither the line number nor the wording above |

Already consistent, **not to be touched**: `MAP-PROGRESSIVE-ENHANCEMENT.md:75`,
`MAP-SCRIPT-GUARDS.md:30`, `MAP-RULE-OWNERSHIP.md:84`. `MAP-000-TEMPLATE.md:25` is a placeholder.
The replacement wording is `../15-DECISIONS/CLAUDE.md` — an ADR needs a driving `US###`, and a map
reaches one only through the slice that becomes a story.

**Why two and not one.** The wiring is provable by `shipped-artefacts.sh` alone; the backfill needs
a measured read of ten maps and is the only half carrying a content-correctness risk. **Why not
seven** — one `_tasks` `mv` chain and one `SEEDED` array cannot be delivered once per register, so
the cut is by **mechanism**, exactly as N-005 anticipated.

**S-01's scope grew in Batch B and the additions are prerequisites, not extras.** Beyond the seven
`.copier/` files, the seed `mv` chain and the `SEEDED` registration: the spine and per-register tail
in each seeded file, a `## The index` H2 in all seven `CONTEXT.md` files, the
`SPRINT-00-TEMPLATE.md` `**Status:**` repair that `SPRINT-INDEX.md`'s Status column depends on, and
the **eight Plans Index citations repointed** at `STORY-PLAN-INDEX.md`. `MAP-000-TEMPLATE.md:8` and
`:146` ride it too, per Batch A.

**S-02 is no longer provisional** — N-006 answered _backfill_ on 31/08/2026. It also gained a second
purpose: the ten backfilled rows are the population N-003 keys its gate against, so S-02 lands
**before** the gate rather than beside it.

**S-03 carries the duty as well as the gate**, per N-004 — the template line and the script that
enforces it ship in one change, so a naked duty never exists for even one release.

**S-04 is the widest and the least entangled.** 62 artefacts gain frontmatter, `doc-references.sh`
gains the fourth token source, the mirror script and its `--check` arm land, the
`23-INCIDENTS/CLAUDE.md:40-42` carve-out is written, the circular blameless attribution is
repaired, and `project-management/docs/ARTEFACT-FRONTMATTER.md` is authored as the schema's home.
It also corrects **every affected folder `CLAUDE.md`**, each of which declares _"Generated: none"_
under **Output & naming** — false the moment frontmatter is machine-mirrored.

**Order: `S-01` → `S-02` → `S-03`; `S-04` is independent** and may run at any point, because
frontmatter and the index rows are separate surfaces. Only `S-03` requires `S-02`, and only
because a gate wants a population it can go red against.

---

## Frontier

| Node | Decision | Type | Blocked by | Blocking a story? |
| ---- | -------- | ---- | ---------- | ----------------- |
| —    | —        | —    | —          | —                 |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

**The frontier is empty — all six nodes resolved across three sittings, 31/08/2026.** The evidence
behind each sits in its Batch section above rather than being repeated here; the per-node detail
retired with the nodes, which is what _index, not vault_ requires.

**The map is not `Complete`, and the distinction is the template's own.** Its four statuses are
`Charting / Resolving / Blockers clear — stories may start / Complete`, and wayfinder's criterion
is _"done when Frontier **and** Fog of war are both empty"_. **Five fog items remain** — four
inherited, one opened by Batch C — so this map sits at **Blockers clear**. Stories may be cut; the
map stays open.

### Batches — why each set belongs in one sitting

| Batch | Nodes                     | Why they group                                                                                                                                                                                                                                                                               | Takeable |
| ----- | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| ~~A~~ | ~~N-001 · N-005~~ (31/08) | **Mutual dependence. It held.** One mechanism answered both, and the sole precedent turned out to answer neither: `INCIDENT-INDEX.md` is negated back in and **ships**, which it can only do while permanently empty                                                                         | done     |
| ~~B~~ | ~~N-002 · N-006~~ (31/08) | **Shared subject. It held, and the shared evidence was the seven templates** — one read settled the column shape and the backfill question, and turned up two declared-not-built defects neither node had predicted                                                                          | done     |
| ~~C~~ | ~~N-003 · N-004~~ (31/08) | **Mutual dependence, and Q37 fused them correctly.** The gate's assertable surface is what told N-004 the duty attaches to the **template** rather than a skill — and the duty's failure history is what told N-003 the gate is the load-bearing half. Neither could have been settled alone | done     |

**Order:** all three sat, **A** → **B** → **C**. Enforcement last, deliberately — `MAP-RULE-OWNERSHIP.md`'s Batch
C settled a guard only to find one of its three claims had **never fired**, and the lesson it drew
is that a gate designed before the rule it asserts is a gate designed against a guess.

---

## Fog of war

- **Two status vocabularies that must agree and cannot.** `STORY-PLAN-US000-TEMPLATE.md` runs
  **eleven** states including `Accepted Customer` and `Rejected Customer`, and requires the status
  to agree _"across story + plan + Plans Index + sprint"_ — but `completion/SKILL.md:37` gives a
  `US###.md` only five, none of them those. Found in Batch B and deliberately **not charted here**:
  it belongs to whoever owns the story lifecycle, and this map would be settling another register's
  semantics to make its own index fillable. It bites `STORY-INDEX.md` and `STORY-PLAN-INDEX.md`
  only if the two indexes are ever asserted against each other, which no node proposes.
- **Whether `01-FEATURE-MAPS` should carry `Flags:` and `23-INCIDENTS` a `Story:`.** Both were
  **derived, not asked**, when the frontmatter schema was settled — the first because slice flags
  live in a body table and a file-level union would be a fourth place they must agree, the second
  because that folder's `CONTEXT.md` states an incident is not owned by a story. Neither reasoning
  was put to Sam, so neither is a settled decision. `S-04` must not treat them as one.
- **Whether the moderate six earn an index later, and what evidence would say so.** Q36 settled
  _the strong seven_ **now**; it did not settle that the answer is permanent. A revisit trigger is
  the honest shape — `MAP-RULE-OWNERSHIP.md` N-008 built exactly one for the coverage floors — but
  what the trigger measures is not yet sharp enough to state.
- **Whether an index is the right artefact at all for a register a script can list.** `ls` answers
  _what instances exist_; an index answers _what they are and what state they are in_. Where a
  register's rows would carry nothing but filenames, the index is a cache of the filesystem, and a
  cache with a gate is worse than no cache. Which of the seven those are is not yet measured.
- **Whether seed-once is the right trade for an index, and what the escape hatch is.** N-001 chose
  it knowingly: an index format that gains a column upstream **never reaches** a project generated
  before the change, because `_tasks` seeding is gated to `copy`. `GAPS.md` and `MEMORY.md` accept
  the identical property. What is not yet sharp is whether an index — which a gate asserts against,
  unlike those two — can tolerate a format that drifts per generation, or needs a migration path
  the other accumulators never needed.

---

## Out of scope

| Ruled out                                                | Why                                                                                                                                                                                 |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Deleting any file under `project-management/src/NN-*/`   | **Sam, 27/08/2026** — those files carry the perspective behind design decisions, features, mappings, database shape and branding. A drifted index is repaired, never deleted        |
| Renaming the six GDPR registers to `-INDEX.md`           | Q35 — they register **facts**, not instances; `copier.yml:170-176` ships them as bare nouns deliberately                                                                            |
| Giving the weak five or the no five an index             | Q36 settled the scope at the strong seven; reopening it is a fog-of-war revisit, not a node                                                                                         |
| Changing how `23-INCIDENTS` works                        | It already has an index and a skill duty; it is the **precedent**, not the subject                                                                                                  |
| The template rule those instances are written from       | That is `MAP-RULE-OWNERSHIP.md` **N-024** — adjacent, and deliberately not duplicated here                                                                                          |
| The ten maps' `Gate to stories` checklist wording        | **One later sweep, deliberately deferred** — the 31/08 handoff excluded it from the parallel resolve window. `MAP-000-TEMPLATE.md` is not one of the ten and rides `S-01`           |
| Fixing `shipped-artefacts.sh`'s unchecked `SEEDED`       | Surfaced here, owned by its own `GAPS.md` entry (31/08/2026). True with or without this feature; N-003 cites it as an input                                                         |
| Reconciling the story and story-plan status vocabularies | Found in Batch B; another register's semantics. **Fog of war**, not a node — settling it here would make this map the owner of the story lifecycle                                  |
| Asserting index **ordering** in the gate                 | N-003 — it fails on a legitimate same-day tie, and a gate people learn to ignore is worse than none. Stated rule, reviewer judgement, on `docs-pairing.sh`'s precedent              |
| Frontmatter on the 138 `CONTEXT.md` / `CLAUDE.md` files  | They are orientation and rules, not artefacts, and `audits/docs-pairing.sh` already polices them. The `S-04` population is **62**, not 198                                          |
| Reconciling `Version:` with `VERSIONING-GUIDE.md`        | Avoided rather than reconciled — a revision **counter** is not semver, so line 175's ban on _"a versioning document anywhere else in the tree"_ is never engaged                    |
| Writing an ADR for any of this                           | The fifteenth consecutive decline on the house rule. Whether that rule survives is `MAP-PROGRESSIVE-ENHANCEMENT.md` **N-026**, live in a concurrent session and not pre-empted here |

---

## Session log

| Date       | Node settled                                    | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Frontier redrawn                                                           |
| ---------- | ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| 28/08/2026 | _(none — charting)_                             | **Charted from `MAP-RULE-OWNERSHIP.md` N-010, Q38.** Six nodes in three batches; Q35–Q38 recorded as inputs no node may reopen; the 24-register survey preserved from a conversation that had ended                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | [x] initial                                                                |
| 28/08/2026 | _(none — inputs added)_                         | **Two facts folded into N-003 from `MAP-RULE-OWNERSHIP.md` Batch H**, settled the same day: **Q45** sends the gate to fixtures plus `shipped-artefacts.sh`, because the strong seven hold **zero instances** here; and **N-024's rename of the `18-TESTS` pair** makes the `*TEMPLATE*` filename key reliable. N-003 shrinks to _what does the gate assert_                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [ ] no node settled                                                        |
| 31/08/2026 | **N-001 · N-005** (Batch A)                     | **The blocking node fell, and the sole precedent turned out to answer neither half.** `INCIDENT-INDEX.md` is not excluded — it is **negated back in and ships**, which it can only do while permanently empty; an index of `01-FEATURE-MAPS` copying it would ship ten false rows, and `shipped-artefacts.sh` states it **cannot** check content. Settled instead on **excluded-and-seeded** — the mechanism the charter never named — which is true in both trees at once and needs **no copier negation** and **no `doc-references.sh` edit**. `<THING>` sharpened to _the folder's noun, singularised_: an exceptionless rule that explains the precedent instead of special-casing it. **Four of this map's own literals corrected**, including the reason recorded for its own ten declines: `doc-references.sh:306` exempts that whole folder today, so the row raises no finding at all — **the conclusion survived its reason**, on content-correctness. **Slices cut at Step 8a** (`S-01` mechanism, `S-02` backfill and provisional on N-006), and **one `GAPS.md` entry created, not claimed**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | **Yes — B is takeable.** N-002 is the new root; 0 blocking remain          |
| 31/08/2026 | **N-002 · N-006** (Batch B)                     | **One read of seven templates settled both nodes and found two defects neither predicted.** A single shared column set is **unrepresentable**, not merely undesirable — seven status vocabularies, and one column cannot hold `17-STORY-PLANS`'s eleven states beside `15-DECISIONS`'s supersession chain. Settled on a **spine** (`Status · Instance · Summary · Updated`) with a per-register tail, `Status` mirrored **verbatim** because N-003 can assert string equality but not a mapping table, and ordering declared per file. **N-006 answered _backfill_**, which retires `S-02`'s provisional flag and repurposes the ten maps: **Q45 sent the gate to fixtures believing the population was zero, and that premise was already false** — these ten are the only real instances in the repository and are what proves a clause can go red. **Two class-E defects found**: the **Plans Index**, gated in eight places including a shipped tick-box and never once built (`GAPS.md`, **claimed**, retired by `S-01`), and `SPRINT-00-TEMPLATE.md`'s missing `**Status:**` field, which `completion/SKILL.md:42` already edits (rides `S-01`). Together with `01-FEATURE-MAPS` that is **two written duties, zero gates, zero working indexes** — the measured case for Q37. **Batch A's pointer decision amended**: `## The index` H2, not a Cross-references line, on the `23-INCIDENTS` precedent                                                                                                                                                                                                                                                                                                                                  | **No new nodes.** N-003 and N-004 both unblock; **Batch C closes the map** |
| 31/08/2026 | **N-003 · N-004** (Batch C) · **scope widened** | **The frontier emptied, and the node as charted was wrong.** N-004 asked _which skill gains the duty_ — unanswerable for two of the seven (`15-DECISIONS` has no owning skill; `20-FINDINGS` has three), and the one register with a single owner wrote the duty **eight** times against a destination that never existed. Settled on **the artefact template**: the only surface existing exactly once per register and guaranteed in the author's hands. **N-003** asserts presence · symmetry · status in its own `audits/register-indexes.sh`, pre-commit and in CI; **ordering is deliberately unasserted**; instance recognition proved mechanical and exceptionless. Duty and gate ship together in `S-03`, because a duty landing a release ahead of its gate recreates the very state this map was chartered on. **Sam then widened scope mid-sitting** from seven index files to **all 62 artefacts**, settling the frontmatter schema — 11 universal keys, six conditional ones placed by _not already the file's identity_, `Version` as a revision counter rather than semver, and `Status` mirrored from a body that stays canonical because it is what reaches a client PDF. **Three collisions were measured before writing any of it**: the three path registers would have been **entirely unpoliced** (`doc-references.sh` reads backticked tokens only) — 186 pointer lists creating this map's own defect class while curing it; `Owner`/`Author` collide with `23-INCIDENTS`'s non-negotiable blameless rule, resolved by Sam as _custodianship is not blame_ and obliging a carve-out in the same change; and that blameless rule has a **circular attribution**, two files deferring to a third that never carried it | **Empty.** 6 resolved, 0 open, 0 blocking. Fog gained one item             |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — **zero triable entries; the count is provable**
- [x] Every claimed entry names what will retire it; **neither register file edited to close anything**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — **N-001 settled 31/08/2026; none remain**
- [x] Every resolved node links to the artefact it became — N-001, N-002, N-005 to `S-01`; N-006 to `S-02`; N-003, N-004 to `S-03`
- [x] **Every slice has a flag manifest** — all four do, and **`S-02` is no longer provisional** (N-006, 31/08/2026)
- [ ] Index row in `CONTEXT.md` current — **superseded by N-001, and this box is a deadlock.** The row moves to `MAP-INDEX.md`; `MAP-INDEX.md` is built by `S-01`; `S-01` needs a story; a story needs this box. **The gate binds the work that repairs the gate** — the same unenforceable-duty shape `MAP-RULE-OWNERSHIP.md` N-010 diagnosed, met from the other side. Resolved by ruling that a **recorded refusal is not drift**: `CONTEXT.md:50` calls a missing row _"an index that has drifted"_, and this one is neither missing by accident nor unexplained. **`S-01` may be cut on that basis; the box closes when `S-01` ships**

**Node-count invariant: 0 open + 6 resolved = 6 = N-006.**

**Status is `Blockers clear`, not `Complete`, and the gap is deliberate.** Wayfinder closes a map
only when **Frontier and Fog of war are both empty**; five fog items remain, one of them opened by
this sitting. A map stamped `Complete` over live fog is the same defect as an index stamped current
over a missing row — which is the thing this map exists to stop, and it would be a poor place to
make an exception.

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked** — and per
Sam's standing preference, **not until the frontier is empty**.
