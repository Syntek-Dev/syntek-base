# MAP-REGISTER-INDEXES — an index per register, and a gate that keeps it true

**Charted**: 28/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `7a82095` — **graduated out of `MAP-RULE-OWNERSHIP.md` N-010, which settled the
map-folder case and claimed the rest (Q38, 28/08/2026)**
**Status**: Charting
**Frontier open**: 6 · **Blocking open**: 1

> **Written from `MAP-000-TEMPLATE.md`.** Its instruction _"add a row to `CONTEXT.md` → Map index"_
> is **declined here, on the record** — that row is a per-project instance citation in a file that
> ships, which is the defect `audits/doc-references.sh` exists to prevent. **N-001 below is the
> work that makes the row addable**, and this map is the tenth to decline it in the meantime.

---

## Destination

Every register folder that accumulates instances carries an **index file** listing them, the index
is **written from the same change as the instance**, and a **gate** fails when it is not — so an
index cannot silently drift the way `01-FEATURE-MAPS/CONTEXT.md`'s has for nine maps.

---

## Notes

| Field                    | Value                                                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| Domain                   | PM artefact structure · the copier shipping seam · audit gates                                                     |
| Skills to load           | `wayfinder` → `grill-with-docs`; `scaffold` and `doc-writer` for the writes; `cicd` for the gate's CI registration |
| Standing preferences     | **Q35–Q38, answered by Sam 28/08/2026** — see the table below. Plus: _no story is cut until the frontier is empty_ |
| Umbrella ADRs            | None yet — N-003's gate design is the likeliest first                                                              |
| Register entries triaged | 0 closes · 0 blocks · 0 unrelated — **over zero triable entries** (see Register claimed)                           |

**The four answers this map is chartered on.** They are **inputs**, not resolved nodes: they were
settled on `MAP-RULE-OWNERSHIP.md` before this map existed, and no node below may reopen them.

| Q   | Question                         | Answer                                                                                                                                                                                              |
| --- | -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q35 | What is a register index called? | **`<THING>-INDEX.md`**, for indexes of **files**. The six GDPR registers at `copier.yml:170-176` stay bare nouns — they register **facts**, not instances                                           |
| Q36 | Which registers get one?         | **The strong seven** — `01-FEATURE-MAPS`, `02-STORIES`, `03-SPRINTS`, `15-DECISIONS`, `17-STORY-PLANS`, `20-FINDINGS`, `21-BUGS`                                                                    |
| Q37 | What keeps them honest?          | **Both** a skill duty and a gate, on `incident/SKILL.md:132`'s precedent — **the gate is the load-bearing half**                                                                                    |
| Q38 | Does this belong on that map?    | **No — its own chart.** Seven shipped files each needing a copier negation, a `shipped-artefacts.sh` registration and a new gate is a different cause from _a rule with two homes_                  |
| Q45 | Where is the index gate tested?  | **Fixtures plus `.github/scripts/shipped-artefacts.sh`**, never the real tree alone — answered on `MAP-RULE-OWNERSHIP.md` Batch H, 28/08/2026, because the same question governs its template guard |

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

**This is a claim surface, not a close surface.** Nothing here edits either register; closing
belongs to `workflows/22-implementation-documentation/`, against shipped code.

---

## Resolved decisions

Nothing settled yet — this map was charted 28/08/2026 and no RESOLVE sitting has run.

| Node | Decision | Type | Settled | Became |
| ---- | -------- | ---- | ------- | ------ |
| —    | —        | —    | —       | —      |

---

## Slices

Empty by design: `01-feature-map` Step 8a cuts slices **once no blocking node remains**, and
`N-001` is blocking. The seven registers are **not** seven slices on their face — N-005 may prove
the copier and `shipped-artefacts.sh` registrations are one indivisible change across all seven,
which would make the natural cut _mechanism_ rather than _register_.

| Slice | Story | Title | Flags |
| ----- | ----- | ----- | ----- |
| —     | —     | —     | —     |

---

## Frontier

| Node  | Decision                                                                                            | Type     | Blocked by    | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------- | -------- | ------------- | ----------------- |
| N-001 | Where does an index file live, and does relocating `01-FEATURE-MAPS`'s table set the pattern?       | grilling | none          | **yes**           |
| N-002 | What is in a row — one column set for all seven, or one per register?                               | grilling | N-001         | no                |
| N-003 | What does the gate assert, and how does it recognise an instance?                                   | grilling | N-001 · N-002 | no                |
| N-004 | Which skill gains the duty for each of the seven, and what is the wording?                          | grilling | N-002         | no                |
| N-005 | Seven new **shipped** files across three registration surfaces — do they ship empty, or not at all? | grilling | N-001         | no                |
| N-006 | The nine-map backlog — backfill the existing instances, or start the index clean?                   | grilling | N-001 · N-002 | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `task` (manual unblocking work)

**N-001 is marked blocking and the others are not**, because every remaining node takes the index
file's **location** as an input: a row's columns, a gate's assertion, a skill's wording and a
copier negation all read differently for a file inside the register folder than for one outside it.

### Batches — why each set belongs in one sitting

| Batch | Nodes         | Why they group                                                                                                                                                                                                                                     | Takeable |
| ----- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| **A** | N-001 · N-005 | **Mutual dependence.** Where the file lives and whether it ships are the same question asked from two sides — a non-shipping location is what lets a per-project instance row exist at all, which is the whole reason N-010 resolved by relocation | **now**  |
| B     | N-002 · N-006 | **Shared subject** — what a row says, and whether nine existing maps get one retrospectively                                                                                                                                                       | after A  |
| C     | N-003 · N-004 | **Mutual dependence, and Q37 already fused them.** The gate and the duty are one enforcement design; deciding the duty's wording without knowing what the gate can key on writes a rule no script can assert                                       | after B  |

**Order:** **A** → **B** → **C**. Enforcement last, deliberately — `MAP-RULE-OWNERSHIP.md`'s Batch
C settled a guard only to find one of its three claims had **never fired**, and the lesson it drew
is that a gate designed before the rule it asserts is a gate designed against a guess.

### Node detail — one line of evidence each

- **N-001** · The instruction and the citation rule collide **only inside a shipped file**.
  `01-FEATURE-MAPS/CONTEXT.md:43-51` holds a `## Map index` table reading `_None charted yet_`
  while **nine `MAP-*.md` files** sit beside it — and that refusal is **recorded, not accidental**,
  in `MAP-RULE-OWNERSHIP.md`'s header and its `Gate to stories`. `copier.yml:116-133` re-includes
  `!**/CONTEXT.md`, so the file ships and the row cannot. The decision is the **location**: a
  sibling `<THING>-INDEX.md` inside the register folder, excluded by copier the way `MAP-*.md`
  already is — or somewhere else entirely.
- **N-002** · `23-INCIDENTS/INCIDENT-INDEX.md` is the **only `-INDEX.md` in the repository**, so
  there is **one precedent and no convention**. `incident/SKILL.md:132` specifies its row as _"most
  recent first, status matching the file"_. Whether seven registers share that shape or each takes
  its own is undecided, and the answer sets what N-003 can assert.
- **N-003** · **Two facts are already settled into this node from `MAP-RULE-OWNERSHIP.md` Batch H,
  28/08/2026 — neither is reopened here.** First, **Q45: the gate is tested against fixtures and
  against `shipped-artefacts.sh`, not the real tree alone.** Measured at `7a82095`, the strong seven
  hold **zero instances** — six read `templates=1, other=0`, and `23-INCIDENTS` holds only its own
  index — so a gate asserting anything about index rows **passes vacuously in this repository** and
  bites only downstream. `code/src/scripts/audits/fixtures/` is the `doc-references.sh` precedent
  for proving a clause can go red; `shipped-artefacts.sh` already builds a generated project, which
  is where the population is real. Second, **N-024 renames the `18-TESTS` pair to carry `*TEMPLATE*`**,
  which removes the reason the filename key was unreliable. **What remains open is what the gate
  asserts**, not where it runs or what it keys on.
- **N-003, as originally charted** · **The obvious key was unreliable, and that was measured.** A gate keyed on `*TEMPLATE*`
  to tell instances from scaffolding fails on `18-TESTS`, which ships `US000-MANUAL-TESTING.md` and
  `US000-TEST-STATUS.md` — templates that `copier.yml:178-179` documents as _"named for the story
  they are copied to, not for their role"_. `00-ASSETS` has no instances at all. Neither is in the
  strong seven, so the gate may scope around them; whether it **should** is the decision.
- **N-004** · The precedent exists and is narrow: `incident/SKILL.md:132` makes the row a numbered
  step with the index named. Seven registers implicate at least `story`, `sprint`, `planner`,
  `wayfinder` and `bugfix`. **Q37 settled that the duty is not sufficient alone** — the map index
  carries a written same-change duty at `01-FEATURE-MAPS/CONTEXT.md` and nine maps still declined
  it, because a **second rule contradicted it**. A duty survives forgetfulness; it does not survive
  a conflict.
- **N-005** · **Three registration surfaces, not one**, and the third was missed by the survey that
  produced Q36 and caught by its verifier: a copier `_exclude` negation (the pattern is
  `copier.yml:180-181`, which negates `INCIDENT-INDEX.md` back in with the comment _"the one file in
  `23-INCIDENTS` that is not an incident"_), a `NAMED_SHIPPED` registration in
  `.github/scripts/shipped-artefacts.sh:185-205`, and the `doc-references.sh` exemption arms that
  **`MAP-RULE-OWNERSHIP.md` N-009 has just narrowed**. An index that ships **empty** is a register
  skeleton on the GDPR pattern; one that does not ship is a file a generated project must create
  before its first instance, which is a gate that fails on day one.
- **N-006** · Nine maps, and `20-FINDINGS`, `21-BUGS` and the rest hold their own instances today.
  Backfilling makes the index true immediately and costs a measured read of every instance;
  starting clean makes the gate pass on a file that is **complete only going forward**, which is
  the drift this map exists to stop, arriving on day one by design.

---

## Fog of war

- **Whether the moderate six earn an index later, and what evidence would say so.** Q36 settled
  _the strong seven_ **now**; it did not settle that the answer is permanent. A revisit trigger is
  the honest shape — `MAP-RULE-OWNERSHIP.md` N-008 built exactly one for the coverage floors — but
  what the trigger measures is not yet sharp enough to state.
- **Whether an index is the right artefact at all for a register a script can list.** `ls` answers
  _what instances exist_; an index answers _what they are and what state they are in_. Where a
  register's rows would carry nothing but filenames, the index is a cache of the filesystem, and a
  cache with a gate is worse than no cache. Which of the seven those are is not yet measured.

---

## Out of scope

| Ruled out                                              | Why                                                                                                                                                                          |
| ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Deleting any file under `project-management/src/NN-*/` | **Sam, 27/08/2026** — those files carry the perspective behind design decisions, features, mappings, database shape and branding. A drifted index is repaired, never deleted |
| Renaming the six GDPR registers to `-INDEX.md`         | Q35 — they register **facts**, not instances; `copier.yml:170-176` ships them as bare nouns deliberately                                                                     |
| Giving the weak five or the no five an index           | Q36 settled the scope at the strong seven; reopening it is a fog-of-war revisit, not a node                                                                                  |
| Changing how `23-INCIDENTS` works                      | It already has an index and a skill duty; it is the **precedent**, not the subject                                                                                           |
| The template rule those instances are written from     | That is `MAP-RULE-OWNERSHIP.md` **N-024** — adjacent, and deliberately not duplicated here                                                                                   |

---

## Session log

| Date       | Node settled            | Outcome                                                                                                                                                                                                                                                                                                                                                     | Frontier redrawn    |
| ---------- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| 28/08/2026 | _(none — charting)_     | **Charted from `MAP-RULE-OWNERSHIP.md` N-010, Q38.** Six nodes in three batches; Q35–Q38 recorded as inputs no node may reopen; the 24-register survey preserved from a conversation that had ended                                                                                                                                                         | [x] initial         |
| 28/08/2026 | _(none — inputs added)_ | **Two facts folded into N-003 from `MAP-RULE-OWNERSHIP.md` Batch H**, settled the same day: **Q45** sends the gate to fixtures plus `shipped-artefacts.sh`, because the strong seven hold **zero instances** here; and **N-024's rename of the `18-TESTS` pair** makes the `*TEMPLATE*` filename key reliable. N-003 shrinks to _what does the gate assert_ | [ ] no node settled |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — **zero triable entries; the count is provable**
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — **N-001 is open**
- [ ] Every resolved node links to the artefact it became — none resolved yet
- [ ] **Every slice has a flag manifest** — slices are cut at Step 8a, after N-001
- [ ] Index row in `CONTEXT.md` current — **declined on the record; N-001 is the work that makes it addable**

**Node-count invariant: 6 open + 0 resolved = 6 = N-006.**

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked** — and per
Sam's standing preference, **not until the frontier is empty**.
