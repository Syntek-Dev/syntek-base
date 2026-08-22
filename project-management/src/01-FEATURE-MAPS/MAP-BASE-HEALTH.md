# MAP-BASE-HEALTH — syntek-base's own open items

**Charted**: 13/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Last verified**: 16/08/2026 — **A verification pass, not a resolve session; nothing below was
settled today.** All ten open nodes were re-checked against the tree and **every one still holds** —
N-030 was reproduced by injecting a fictional skill name into the multi-line array and watching
`routing-skills.sh` report _"✓ Every routing skill resolves"_ across 563 names. Every resolved
node's artefact exists and twelve `audits/*.sh` are green. **The map was accurate about itself and
blind to everything around it.** Three things arrived from outside: a **generation-breaking
regression** shipped by this map's own last-settled node (**N-032**, blocking, proven with a real
`copier copy`), **eight findings `MAP-ABSENCE` routed here on 15/08 and nobody adopted**, and
**commits since the version bump** that no log described — measured at seventeen, re-measured at 41,
and **settled the same evening by eight bumps to 5.3.0** (N-040). Nine new nodes, N-032 to N-040.
**`Blocking open` returns to 1** the day after it first reached 0. **Two of the eight routed
findings did not survive re-verification** and were refused rather than charted — the standing
lesson _re-verify before grilling_ now has a second half: **re-verify what another map hands you,
because inherited evidence is evidence about a tree that has moved.**
**Previously verified**: 15/08/2026 — **Batches A, C and D are closed.** N-006 and N-012 verified
resolved against work in flight; then N-001, N-013 and N-024 grilled and shipped as one batch at
`7cd385d`, taking N-002, N-003 and N-004 with them. **`Blocking open` reaches 0 for the first
time**. In parallel sessions **Batch B lost its first pair** — N-007 and N-011 settled as one
grilling, adding N-028 and N-029 — and **Batch D's original three, N-014, N-016 and N-017, were
settled as one pass**, leaving N-028 alone in the class. **N-025 settled alone**, being the
precedent the rest lean on: the reciprocal duty moved off the frontmatter field and onto the
skill body, `skill-conformance.sh` gained clause 14, and 41 citations across 13 skills took it
from 24 findings to 0 — **and made N-027 measurably worse**, six files now inside the warn tier
where it was charted at five. It also **charted two nodes out of its own evidence**: **N-030**
(`routing-skills.sh` is blind to a multi-line `skills:` array — 8 names never validated, proven
with an injected fake) and **N-031** (shipped guides citing copier-**excluded** paths, which
resolve here and dangle in every generated project). **The Notes block now carries the standing
-limits correction**: the register holds **two**, not the one the triage counted, and both SL-1's
and SL-2's premises died at `7cd385d` — charted together once the nodes are clear. **N-027 then
settled in exactly that worsened state, and the worsening is what settled it**: the warn tier
gained a **ratchet**, so a file at or above 270 may not grow without a dated reason. Its first
finding was against the rule text that created it
**Earlier**: 14/08/2026 — coverage audit against the original register; N-014 unblocked, N-015, N-018 and N-019 resolved; **N-026 and N-027 inherited from `MAP-NEGATIVE-SPACE`'s fog-of-war discharge**
**Register re-reconciled**: 22/08/2026 — the register is now the root `GAPS.md` (excluded and
seeded since sitting 5) and it carries **one** uncharted entry, the `main` item, which is a dated
task with a named owner rather than a node. Previously 16/08/2026 — `TEMPLATE-GAPS.md` carried **no uncharted entries** and root `GAPS.md`/`DEFERRED.md` are still empty. **None of N-032 to N-040 came from a register**: five were routed here by `MAP-ABSENCE`, four were measured on 16/08. The _Register claimed_ table does not account for them, as it does not for N-026 and N-027
**Status**: Charting
**N-032 settled 16/08/2026**, the same day it was charted, because a broken generation is not a
thing to leave charted overnight. `Blocking open` is back to 0.
**Batch B's first sitting settled 16/08/2026** — N-033, N-029 and N-038 together, the last of them
pulled out of Batch E because the gate N-033 builds runs `shipped-readme.sh` and could not ship
green while that was red. **The class that had never paid out has now paid out four times in two
days**, and settling it produced two more members of itself.
**N-028 settled 16/08/2026**, in parallel with Batch B's second sitting and in a shared working
tree — taken because it was the only unblocked node outside the batch another session held, and
because it had to land **before** N-035: that node flips four never-executed suites from skip to
run, and the number they would enforce should be settled before it first bites.
**N-030 settled 16/08/2026 at `0c22b79`** by the Batch B session, and **written up here by the
N-028 one** — every claim in its verdict re-measured rather than read off the commit message.
**Challenge pass 16/08/2026 — N-040 settled and N-044's premise killed, by fourteen agents in four
steps (read, challenge, verify, review), no step reviewing its own work.** Neither node survived
contact with the tree. **N-040 was discharged outside this map**, 69 minutes after its last write:
eight `chore(version)` commits took 4.0.0 → 5.3.0 and four-way parity now holds across the three
logs and the tag namespace. **N-044 was charted against a window that had already closed** — both
names were tracked at `ec8e807`, 31 minutes after this file's previous save — and its `grilling`
type revived a seam argument **this map had already refuted for N-020 the same day**. The reopening
claim is withdrawn as to N-044 and **reasserted on three members nobody had charted**. **Six nodes
charted out of the pass, N-047 to N-052** — the frontier grew from 12 to 18 on an evening that
settled one node and killed another's premise. **Sam's own framing was tested rather than believed
and was wrong on a detail**: eight version commits, not five, which every agent in both chains
caught independently.

**Frontier open**: 7 · **Blocking open**: 0 · **Resolved**: 53 — recounted from the tables
22/08/2026 after **sitting 5** settled **N-056** and **N-058**:
**7 + 53 = 60 = N-060**. Per batch: A 0 · B **1** · D 1 · E 4 · unbatched 1.
**Sitting 5's thesis is that the maintainer's challenge sharpened a node rather than dissolving
it.** Asked whether `sync-trees.sh` is not supposed to update the trees, the answer was yes — and
that reframing found the real defect: a write-mode filter keyed on a message **substring** rather
than on whether a finding was left unresolved, silently dropping the one class the script can
never fix. The sitting also **inverted N-058's remedy** on a definition, not a measurement:
CHECKLIST is read after the work, so its box takes the bare name and the runnable form stays in
STEPS. **Five of N-056's charted members had already died**, three to the N-046/N-055 settlement
and two that were never true. It closes Batch B to one node and carries a register restructure
that was not on the map at all.

**Previously 9 · 0 · 51**, recounted 22/08/2026 after **sitting 4** settled **N-047** and
**N-059**: **9 + 51 = 60 = N-060**. Per batch: A 0 · B 3 · D **1** · E **4** · unbatched **1**.
**Sitting 4 settled one doctrine across two sites, and the batch named itself** — N-059's own
charted text said the open half was _"the same question N-047 is typed `grilling` for, one
decision in two sites; settle them together"_. Both nodes' premises were re-measured before a
question was asked, and **N-047's central objection did not survive it**: re-keying a migration
does not rewrite what a published tag meant, because `copier update` checks out the target tag
and reads `_migrations` from **HEAD**. That inverted the remedy — the node's first option was the
one choice that breaks a population currently served.
**Sitting 3 is the first to close a node as _accepted_ rather than _fixed_** — N-020 became
**SL-2** in `TEMPLATE-GAPS.md`, taking the second of the three outcomes the Destination has always
offered and none of the previous 48 resolutions had used. Its thesis is one sentence: **the file
that calls itself the single source of truth was the only one missing the qualifier every sibling
carried.** Neither half of N-054 was a drift between equals; both were omissions on one side, with
the reason already written in `checks.py` and in three shipped documents.

**Previously 14 · 0 · 46**, recounted from the tables
21/08/2026 after **sitting 2** settled **N-057**, **N-050** and **N-051**:
**14 + 46 = 60 = N-060**. Per batch: A 0 · B **3** · D **2** · E 6 · unbatched **3**.
**Sitting 2 is the first on this map whose remedy needs a live repository setting changed** — the
required-check set moves 20 → 22, applied in branch protection once this merges — and the first
whose remedy was, three times over, to **delete a second copy of a fact rather than correct it**:
the required-set table, a stale version assertion, and four restatements of the version file
list. It also found that **sitting 1 closed N-031 with one of its own charted rows
half-repaired**, which is why the residue paragraph below exists.

**Sitting 2 charted no node.** An 82-agent adversarial review of its own diff raised 76 findings,
**38 surviving refutation**; every one was fixed in place rather than charted, including the ten
shipped files citing a bare `N-0NN` node id — a namespace that **exists and means something
else** in a generated project's `MAP-SCALE-PLANNING.md`. Two of the ten lost their citation
entirely when the `N-029` deferrals were deleted; of the eight left, three already named the map
and **five were qualified here**, so the sweep
`git grep -nE '(^|[^-A-Za-z])N-0[0-9]{2}\b' -- '*.md' '*.sh' '*.yml'` (excluding this folder,
`handoffs/`, the three version logs, `research/`, `learning/`, `.copier/`, `.github/scripts/`,
`audit-template.yml`, `copier.yml` and `TEMPLATE-GAPS.md`) returns nothing unqualified.

**Previously 17 · 0 · 43**, recounted from the tables 21/08/2026 after sitting 1 settled
**N-044**, **N-052** and **N-031** and charted **N-060**:
**17 + 43 = 60 = N-060**. Per batch: A 0 · B 4 · D **3** · E **6** · unbatched 4. **Three
settled and one charted, so the frontier fell by two** — and for the first time on this map a
sitting was planned by **shared file** rather than by batch, which is why it crossed three
batches at once. The batching argument the map made for itself on 18/08 — _"settle the exemption
policy once and three nodes shrink together"_ — held, with the correction that the third node
was **N-052**, refused rather than shrunk.

**Sitting 1's headline is that two of its three nodes cost no code at all.** N-044 was already
satisfied at every site; N-052 was measured and refused. Only N-031 wrote anything, and its
gate half became N-060 rather than shipping unproven. **A resolve session whose main output is
two measurements and one narrowed `case` arm is the map working**, not a thin sitting: both
refusals are now written down with the command that regenerates them, so neither node can be
re-opened on the reasoning that charted it.

Previously 19 · 0 · 40, recounted from the tables
20/08/2026 after **N-037** settled and **N-042** was moved: **19 + 40 = 59 = N-059**. Per batch:
A 0 · B **4** · D 4 · E **7** · unbatched 4. **N-042 was fixed on 18/08 by `5e2b61d` and left sitting
in the open Batch B table for two days** — the standing rule says recount from the tables, and the
tables were wrong because a settled node was never moved. That is the drift this map exists to
catch, occurring on this map. **N-031 loses its last blocker with it**: its own pull request is no
longer blocked at a required check, because `Citations resolve` is green at `692ad63`. It is
**unblocked, not settled** — Direction B was explicitly out of scope for the N-037 sitting.
Previously 21 · 0 · 38 after N-043 settled, when N-031 lost its first blocker — the rule it
classifies against became true — leaving `N-042` as its only remaining one and turning the
three-node batch the map argued for into the **pair** N-037 × N-031. That pair is now half
settled. Previously 22 · 0 · 37 after N-046 and N-055 settled
as one sitting. Previously
18/08/2026 after N-053 settled and **re-counted unchanged the same day** after `b4ed0b9`, which
fixed a finding Sam declined to chart. Nothing was charted and nothing resolved as a node, so the
arithmetic was untouched at that point: **24 + 35 = 59 = N-059**, per batch A 0 · B 7 · D 4 ·
E 9 · unbatched 4. **Batch A's frontier is empty for the third time and the
class is still not called closed** — see the verdict in _Batch A_.

**A release session 18/08/2026 settled nothing and corrected three things, and the sharpest of
them is that this map's one _measured_ claim about the version state had a hole in it.** **5.5.0**
was cut for the seven commits since the 5.4.0 bump — MINOR, and the handoff's open question 1 dies
with it: `lint.sh` rejecting `--file-type css` is **not** a MAJOR, because `CONTRIBUTING.md:185-205`
puts a script flag outside the template contract, so the question was decidable by reading rather
than by judgement. **`v5.4.0` had never been tagged** — 57 log entries against 56 tags — and
N-040's verdict records four-way parity as _measured_, which it was at 5.3.0 and stopped being one
commit later with nothing watching. Restored and re-measured at **58/58/58/58**. Corrections:
**`how-to/src/TEMPLATE-GUIDE/` ships** (`f5fef31`, 14/08, **v3.2.0**) and this map asserted
otherwise in its own voice at **exactly one site** — N-012's rejected option (c) — the node blocks
having already carried it, so the sweep found one live falsehood rather than the several expected;
and **N-037 grew by a third in two days with nobody working on it**, 87 → **117** sites across
62 files, though its **50 unique paths** make the repair a third of what the site count implies.
**Counts unchanged and recounted from the tables anyway**: 22 + 37 = 59 = N-059.

**A commit landed 18/08/2026 that was not a node, and it moved two open nodes' evidence — so the
map records it in both directions.** `b4ed0b9` fixed the `COMMITS.md` Step 2 finding rather than
charting it as N-060, at Sam's call. The re-measurement pass that followed re-resolved **fifteen
stale anchors** across N-046 and N-055, **refuted ten** of its own 59 findings through an
adversarial leg, and established that the commit **removed one N-055 member and added three**. The
lesson this map has now measured at a new boundary: **a session that touches a charted node's
files owes that node a re-measurement**, and the leg that found the three new members was neither
the finders nor their adversaries but the completeness critic — because a finder is scoped to a
bullet, and a bullet cannot ask about a member created after it was written. Details in _Batch B_
and the _Session log_.

**N-053 settled 18/08/2026, and it is the first node on this map taken after a two-day gap —
so every premise was re-measured before any of it was believed.** All of them held. **Three of
the node's own facts did not.** Its stated remedy would have failed open, it walked past a
member sitting inside the block it held up as the correct form, and the "four commits" its
residue bullet corrected `lefthook.yml` to is **five**. The reshaped scope was Sam's call.
**The standing lesson gained nothing new and was vindicated twice more**: a node's own remedy
is a claim like any other, and so is a node's own correction of somebody else's number.

**N-010 settled 16/08/2026, and it closed Batch B's original pair.** All five how-to workflows
were executed rather than reviewed, and **its charted premise was dead before it opened**:
`04`/`05` "need generation" rested entirely on the absent `uv.lock` that N-035 had committed
hours earlier. **Nine defects, seven of them commands that do not exist or cannot work** —
including `reset.sh`, which had **never once run** in the template or in any generated project,
and a documented pre-PR gate invocation that **exits 0 having checked nothing**. Three sittings
of review had passed all nine. The node also produced four artefacts rather than only
corrections, and **charted two nodes out of its own evidence** — N-045 and N-046.
16/08/2026 after the Batch E verification pass charted N-042, N-043 and N-044. Arithmetic check,
re-run after the challenge pass charted N-047 to N-052: **18 + 34 = 52 = N-052**.

**N-036 and N-035 both settled 16/08/2026**, recounted from the tables rather than decremented.
**N-035's row was written by the N-036 session, not the one that did the work** — the Batch B
session landed seven commits and moved to its PR without moving the row, so the map showed a
settled node as open. Every claim in its verdict was re-measured here rather than read off a
handoff; that is the standing lesson applied for the third time, and the first time it returned
nothing to refute.

**Corrections pass 16/08/2026 — nothing settled, and four of the eight findings a handoff carried
here did not survive re-measurement.** N-020's blocker is **live**, not false, and its `task` type
is **correct**; N-021's blocker is real and was **misnamed**; the "N-022 × N-031 share 10 files"
collision the handoff carried **does not exist** and was never on this map. Written instead: N-021's real absence, N-023's second trigger
arm, N-031's one-way coupling and eight-file floor, N-037's twice-wrong row, and the three real
Batch E collisions. **The three printed counts above were all stale** — 14/0/27 against tables
holding 12/0/29, the fourth such drift and the first since the standing rule was written. See
_Batch E_ and the standing lesson at the end of _Frontier_.

**N-022 settled 16/08/2026**, the same afternoon, taking the counts to **11 · 0 · 30** — the first
node on this map settled by a grilling that **shrank** on measurement rather than growing. Its
general case was **refused a node here** on Sam's call and seeded as its own map,
`MAP-UPSTREAM-TRACKING.md`.

**Batch E verification pass 16/08/2026 — nothing settled, three nodes charted, and the batch had
moved underneath its own prose.** Read, challenge, verify and review were carried by fifteen
separate agents, one step never reviewing its own work. Every Batch E premise had been measured at
or before `840acb3` (13:22); **N-035's seven commits then landed from 15:14**, and two premises
died in that window. **N-023's whole subject is gone** — `b805774` deleted the two `quick-xml`
suppressions, so `deny.toml:26` reads `ignore = []` and the `02/11/2026` date-gate has nothing
behind it; the node survives only as a residue sweep. **N-020's obstacle (b) is half-refuted** —
`config/urls.py:21` mounts `apps.health`, so the route exists and only the caller is missing.
**N-037's blocker is false at its three charted claims.** Charted out of the pass: **N-042**
(`doc-references.sh` green on a developer's disk and red on a fresh checkout), **N-043** (the
shipped exclusion register is false on four counts, and N-031 cannot classify against it), and
**N-044** (the health caller has two names, one of them in uncommitted work). **The standing
lesson gained a fourth half: re-verify what a _sibling node_ hands you** — N-035 retired a node in
another batch and moved no row, exactly as its own row had been left unmoved that morning.

> **This map is committed here and never ships.** It is tracked, so it syncs across devices;
> `copier.yml` `_exclude` empties the artefact trees at generation — deliberately, because these
> are the **template's** open items and a generated project has none of them. The name matters:
> a map called `MAP-TEMPLATE-*.md` would match the `!*TEMPLATE*` negation and ship.
>
> **Consequence, accepted 13/08/2026:** the entries this map replaces were removed from
> `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`, which was tracked. This file is therefore the
> only working copy. The full original prose for every node below is recoverable with
> `git show e16b499:how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` — **still the right command, and
> now the only one**: that file was folded into the root `GAPS.md` and deleted on 22/08/2026, so
> it exists in history alone.

---

## Destination

Every open item syntek-base holds against **itself** is either settled, promoted to a standing
limitation that is read rather than fixed, or scheduled as a dated task — so that "what is wrong
with the template" is answerable from one place rather than from a 850-line register nobody
finishes reading.

Done when Frontier and Fog of war are both empty and the root `GAPS.md` carries standing
limitations only.

> **The third condition changed its subject on 22/08/2026, not its meaning.** It named
> `TEMPLATE-GAPS.md` until sitting 5 folded that register into the root `GAPS.md` and deleted it —
> `copier.yml` now excludes `GAPS.md` and seeds a blank one, so the file can hold syntek-base's
> own state without shipping it. The condition is unchanged in substance: the register holds
> accepted properties and nothing else. It is **currently unmet**, and by one entry — the `main`
> item, which is a dated task with a named owner and retires when this branch's PR merges.

> **"One place" stopped being true on 15/08/2026 — see the sibling-map table in _Notes_.** Four
> other maps now share this folder and one of them routes findings here. The destination is
> unchanged; what changed is that reaching it requires reading what the others send.

---

## Notes

| Field                    | Value                                                                                                                                 |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | The template repository itself — not any project generated from it                                                                    |
| Skills to load           | `grill-with-docs` · `cicd` · `scaffold` · `doc-writer` · `runbook` · `code-reviewer`                                                  |
| Standing preferences     | Script-first; a gate that cannot run must say so loudly; template state never ships                                                   |
| Umbrella ADRs            | None — syntek-base's own ADRs are gitignored by design (`project-management/src/.gitignore`)                                          |
| Register entries triaged | 24 entries · 21 closes · 1 standing limit (SL-1) · 0 blocks · 2 removed as already-resolved · root `GAPS.md`/`DEFERRED.md` both empty |

> **The triage counted one standing limitation and the register carries two — corrected
> 15/08/2026.** `git log -S` puts **SL-1 and SL-2 in the same commit, `ce8202e`**, the 13/08
> charting commit itself; at `e16b499` there was no standing-limitations section at all. SL-2 was
> therefore never one of the 24 triaged entries — it was **distilled from entries triaged as
> closes** (the ruff/uv findings retired by N-001/N-002/N-005), so the same facts produced both a
> node and a standing limit and only the node was tracked. The count above is left as the triage
> made it, because it is a record of that triage; this note is the correction.
>
> **Both standing limits are now factually false**, and neither is a frontier node:
>
> - **SL-1** says `uv.lock` is absent because the manifest name is a token. It is a house
>   constant since `7cd385d`. Its text still asserts _"nothing on `MAP-BASE-HEALTH.md` touches
>   it — `N-001` is about the manifest's package name, which is a different root cause"_ — the
>   exact sentence the Out-of-scope row below corrected on 15/08. **The map corrected its own
>   copy and left the tracked register saying the false thing**, which is Batch D with the
>   untracked side right and the tracked side wrong.
> - **SL-2** says any tool needing `uv` to open the manifest cannot run here. Measured
>   15/08/2026: `uv lock --dry-run` resolves 119 packages, `uv run` and `uv export` both work, so
>   its whole _"what still does not run here"_ table — `basedpyright`, `pip-audit`, anything
>   calling `uv run` — is wrong on all three rows. It also closes by routing its open question to
>   `N-001`, which is resolved.
>
> **Sequenced deliberately:** every node is settled first, then SL-1 and SL-2 are charted
> together. Charting SL-1 alone would leave a false, tracked, uncharted standing limitation
> behind it.

**Node numbers are scoped to this map**, and a cross-map reference must therefore name its map.
The one this map used to carry — to the agents→skills chart's own `N-014`, a different node that
shared a number — is gone with the chart: **it was completed and its map deleted on completion,
which is what a finished chart gets.** Nothing here depends on that file any more; where its
outcome is load-bearing, the outcome is stated in full rather than cited.

**This map is no longer the only live one, and its Destination assumed it was — corrected
16/08/2026.** Four sibling maps now sit in this folder, three of them charted on 15/08 while this
one was being resolved:

| Map                           | Status                             | Bears on this map                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ----------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `MAP-NEGATIVE-SPACE`          | Shipped, frontier 0                | Already accounted for — it graduated `N-026` and `N-027` here on 14/08                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `MAP-DOMAIN-OBJECTS`          | Resolving, frontier 0              | Shipped `TYPES-*` and `audits/dict-discipline.sh` at `b404307` — a standard and a new gate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `MAP-ABSENCE`                 | Charting, 11 open, **1 blocking**  | **Routed eight live defects here on 15/08 and marked them unactioned.** They still were                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `MAP-PROGRESSIVE-ENHANCEMENT` | Charting, 16 open, **3 blocking**  | A separate epic; no overlap found, but it is spending the same repository                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `MAP-NAVIGATION`              | Resolving, 10 open, **3 blocking** | **Routes nothing here and _claims a file_ here — corrected 21/08/2026.** Its **N-004** proposes `doc-references.sh` gain an output mode keeping the edge set it currently computes and discards: the same script N-052 and N-031 edit                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `MAP-SUBDOMAIN-ROUTING`       | Seeded, frontier 0                 | **Missing from this table until 18/08/2026**, found by the sibling read N-053 owed. Routes nothing here                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `MAP-UPSTREAM-TRACKING`       | Seeded, frontier 0                 | Seeded by this map's own N-022 and named only in that node's prose — **never added to this table until 18/08/2026**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `MAP-RULE-OWNERSHIP`          | Charting, 10 open, 0 blocking      | **Charted 21/08/2026 by a parallel session and added here the same evening — the eighth map, and it did not exist when sitting 2's sibling read ran.** Routes nothing here and **declines to be folded in** (its Q2: one cause, one remedy, its own frontier). **It claims `doc-references.sh`**: N-009 and N-011 work `is_exempt()` at `:158-170` (**corrected 21/08/2026 from `:158-168`, which cut off two of the four arms — `code/docs/cloudinary/*` and `.agents/*`**; re-locate by string, not by line), four exemption arms over nine shipped files, on the same reasoning sitting 1 used to narrow the arm three lines above them. **Three maps now claim that one script** — this map's N-060, `MAP-NAVIGATION`'s N-004, and these two |

> **The duty found a missing row on both of its first two executions — 16/08 and 18/08.** That is
> now twice out of two, on a table this map maintains about itself, and it is the argument for
> leaving the gate item unticked rather than a reason to distrust any one session. **Seven live
> sibling maps, not five.** Nothing new was routed here on 18/08: `MAP-ABSENCE`'s eight remain
> the only inbound set and all eight are still accounted for.

**The Destination says "answerable from one place". It is not, and pretending otherwise is how the
eight sat unread for a day.** A routed finding is **inbound work with no owner until this map
adopts it** — the sending map recorded it and moved on, exactly as its own rules told it to. Whether
that hand-off needs a mechanism, or whether reading the sibling maps at the start of a resolve
session is enough, is in fog of war rather than asserted here.

Named as reusable **defect classes**, so later maps can inherit the taxonomy rather than
re-inventing a grouping.

| Batch | Class                   | The shape of the defect                                                 |
| ----- | ----------------------- | ----------------------------------------------------------------------- |
| **A** | **Token blast radius**  | An unrendered `<%TOKEN%>` sits where a real parser validates the result |
| **B** | **False green**         | A gate reports success without having looked                            |
| **C** | **Inheritance leak**    | The template's own state ships into every generated project             |
| **D** | **Split doctrine**      | One rule has two or more homes, and they have drifted                   |
| **E** | **Declared, not built** | A shipped document routes to something that does not exist              |

---

## Register claimed

**The register here is the root `GAPS.md`, as of 22/08/2026.** It was `TEMPLATE-GAPS.md` under
the template guide until sitting 5 folded that file in and deleted it: `copier.yml` now excludes
`GAPS.md` and `DEFERRED.md` and seeds blank ones, so the root register holds syntek-base's own
items without shipping them. **The table below keeps its original column heading and its entries
verbatim** — they were entries in `TEMPLATE-GAPS.md` when they were triaged on 13/08/2026, and
restating them under the new filename would misdate the triage. Root `GAPS.md` and `DEFERRED.md`
were both read on 13/08/2026 and held **no open entries**, which is why the unrelated count is
zero.

> **Every other mention of `TEMPLATE-GAPS.md` below this line is a record of a past sitting and
> stands as written.** Rewriting them would falsify what was measured on the day. `01-FEATURE-MAPS/`
> is exempt from `doc-references.sh`, so none of them dangles against a gate.

**This is a claim, not a close.** `workflows/22-implementation-documentation/` closes against
shipped code.

| Entry (TEMPLATE-GAPS.md)                                        | Verdict            | Retired by    |
| --------------------------------------------------------------- | ------------------ | ------------- |
| 12/08 — N-014's two drafting-guide folders may already exist    | closes             | N-014         |
| 11/08 — The agent tier is retired, N-015's routing deferred     | closes             | N-019         |
| 11/08 — Committed merge-conflict markers passed every gate      | closes             | N-008         |
| 11/08 — The `/mcp/` surface has no error-taxonomy clause        | closes             | N-018         |
| 11/08 — The ruff CI jobs do not run either                      | closes             | N-001 → N-002 |
| 11/08 — Two of four `research/` notes cannot be deleted         | closes             | N-012         |
| 11/08 — The mobile tree's sub-directories carry no pair         | closes             | N-017         |
| 11/08 — `apps/core/schemas.py` breaches the comment standard    | closes             | N-016         |
| 11/08 — code-review-graph update is blind to untracked files    | closes             | N-009         |
| 09/08 — `<%CORE_APP%>` is a token the template cannot use       | closes             | N-013         |
| 09/08 — `ruff check .` is red on `main`                         | closes             | N-005         |
| 09/08 — Two guides mandate different JSON error envelopes       | closes             | N-015         |
| 09/08 — `scripts/deployment/` ships empty                       | closes             | N-020         |
| 09/08 — Four security-specific incident runbooks unwritten      | closes             | N-021         |
| 09/08 — `static-analysis.sh` has never executed                 | closes             | N-007         |
| 04/08 — `BRAND-VOICE.md` routed to but did not exist            | **already closed** | — (see below) |
| 03/08 — The Python pre-commit hooks cannot run                  | closes             | N-001 → N-003 |
| 02/08 — Two accepted Rust advisories have no re-check mechanism | closes             | N-023         |
| 02/08 — The five new how-to workflows have never been executed  | closes             | N-010         |
| 02/08 — The backend test suites never execute                   | **standing limit** | SL-1          |
| 02/08 — `pytest + coverage` is not a required status check      | closes             | N-011         |
| 02/08 — Expo SDK tracking has no owner and no trigger           | closes             | N-022         |
| 02/08 — Delimiter-safety guard is one-sixth implemented         | **already closed** | — (see below) |
| 02/08 — `pnpm audit` is red for pre-existing reasons            | closes             | N-006, N-001  |

**The two removed as already-resolved, 13/08/2026:**

- **`BRAND-VOICE.md`** — the artefact exists at `how-to/src/BRAND-VOICE.md` and **48** inbound
  references resolve against it. The entry recorded ten. Its only open thread was the prose-tell
  detector, which belongs to another map.
- **Delimiter-safety guard** — superseded by the 13/08 fix, which corrected the character class
  to `[:~]`, added the bare-opener check, and added `--self-test`. The entry asked for all six
  delimiter sequences; the residue is bare **closers**, and Jinja does not fail on a closer.

---

## Resolved decisions

| Node  | Decision                                                                                                         | Type            | Settled    | Became                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ----- | ---------------------------------------------------------------------------------------------------------------- | --------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| N-001 | Give `pyproject.toml` a name uv accepts                                                                          | grilling        | 15/08/2026 | `7cd385d` — house constant `syntek-base` + a `copier.yml` `_task` branding it ahead of `uv lock`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| N-002 | Make `basedpyright` run in `syntax-python.yml`                                                                   | task            | 15/08/2026 | `7cd385d` — lockfile guard replaced by a sync-**mode** chooser; verified 0 errors before unguarding                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| N-003 | Un-guard the `basedpyright` lefthook leg                                                                         | task            | 15/08/2026 | `7cd385d` — guard deleted outright; the leg is now a real gate on both sides                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| N-004 | `security.sh`'s Python leg needs the manifest                                                                    | task            | 15/08/2026 | `7cd385d` — **the script needed no change**; N-001 was its only blocker. CI's two guarded twins unguarded                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| N-005 | Clear the four live `ruff check .` errors                                                                        | task            | 14/08/2026 | commit `24a5fb7` (reformat + ruff ≥ 0.16.3)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| N-013 | `<%CORE_APP%>` — retire it, or mark prose-only                                                                   | grilling        | 15/08/2026 | `7cd385d` — **retired**; question deleted, 3 sites literalised, house-constant rule written in `TEMPLATE-TOKENS.md`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| N-024 | Teach the token gate about validated positions                                                                   | grilling        | 15/08/2026 | `7cd385d` — `.github/scripts/check-template-parsers.sh` + `--self-test` + `[4/4] Parser Probes`; a **probe**, not a position register                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| N-006 | Clear the `pnpm audit` residue                                                                                   | grilling → task | 15/08/2026 | `4419218` (`audit.ignore` + rationale) · `pnpm update @grpc/grpc-js` → 1.14.4 · two ignores **deleted**, not documented                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| N-012 | Lifecycle for the surviving `research/` notes                                                                    | grilling        | 15/08/2026 | `research/.gitignore` + `copier.yml` `_exclude` + `THIRD-PARTY-NOTICES.md` lines 216/218 + self-citing `README.md` _Influences_ rows                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| N-015 | Pick one JSON error envelope                                                                                     | grilling        | 14/08/2026 | `api-design/AUTH-AND-ERRORS.md` Section _The error envelope_ + `audits/doctrine-drift.sh` + four guides demoted to one-liners                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| N-018 | Does the JSON API row cover `/mcp/`?                                                                             | grilling        | 14/08/2026 | A sixth per-surface row → `mcp-server/TOOL-DESIGN.md` Section _The error taxonomy on this surface_ + 3 clauses on `negative-space.sh`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| N-019 | Route the **verifier** remit to its skills                                                                       | research + task | 14/08/2026 | Clauses in 5 of 6 verifier skills + the `NEGATIVE-SPACE.md` / `MANAGEMENT-COMMANDS.md` frontmatter · new node **N-025**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| N-007 | How Opengrep is obtained, pinned and gated                                                                       | grilling        | 15/08/2026 | `.opengrep-version` + `audit-static-analysis.yml` (cosign) + `static-analysis.sh --self-test` + a 4-file fixture pair                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| N-011 | Does `pytest + coverage` join the required set                                                                   | grilling        | 15/08/2026 | `git/PR-AND-REQUIRED-CHECKS.md` Section _What earns a place in the required set_ + _Toolchain pins_ (moved there by N-029) · **N-028**, **N-029**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| N-014 | Is the two skills' asymmetry correct?                                                                            | grilling        | 15/08/2026 | Asymmetry accepted on measurement · both `## Clarifying questions` sections compressed to `## Before drafting`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| N-009 | Graph refresh — `full_rebuild`, or stage first                                                                   | grilling        | 15/08/2026 | `.claude/CLAUDE.md` Section 6 ordering clause + `hooks/graph-update.sh` + 2 `CODE-REVIEW-GRAPH.md` caveats + 4 hook-timeout unit fixes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| N-016 | Docstring length, and the outside-reference ban                                                                  | grilling        | 15/08/2026 | `STYLE-AND-PROCESS.md` Section _Comments and Documentation_ owns it · 4 homes demoted to routing · 10 source files made self-contained                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| N-017 | What binds a directory to the pair                                                                               | grilling        | 15/08/2026 | `DOCUMENTATION-PAIRING.md` Section 7 rewritten to the worked-in test · `docs-pairing.sh` Check 10 · 5 pairs created                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| N-025 | What does a guide's `skills:` field claim?                                                                       | grilling        | 15/08/2026 | `skill-authoring/FRONTMATTER.md` _The other `skills:` key_ · `skill-conformance.sh` clause 14 · 41 citations repaired across 13 skills                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| N-027 | What is the warn tier for, and whose is it?                                                                      | grilling        | 15/08/2026 | `.claude/CLAUDE.md` Section 8 _the ratchet_ · `docs-length.sh --since` + `--self-test` (7 cases) · lefthook `HEAD`, CI merge-base                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| N-008 | Which audit owns the conflict-marker check?                                                                      | grilling        | 15/08/2026 | New `audits/conflict-markers.sh` (+`--self-test`, 6 cases) · `_lib/conflict-markers.sh` shared with `template-update.sh` · unfiltered CI                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| N-032 | Generation is broken — the marker builder opens a `<%`                                                           | task            | 16/08/2026 | `conflict-markers.sh:104–106` — the conversion spec moved to the front of the format string, plus a comment naming the constraint                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| N-038 | The shipped README omits six things the repo has                                                                 | task            | 16/08/2026 | `.copier/README.md` — six rows written from each script's own header; `shipped-readme.sh` 1 → 0 with its 26 probes still firing                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| N-033 | Where do the template-integrity gates live?                                                                      | grilling        | 16/08/2026 | `lefthook.yml` `template-integrity` leg + `audit-template.yml` push de-branched + `check-audits.sh` glob widened + PR template rewritten                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| N-029 | De-filter and flip the eligible checks to required                                                               | task            | 16/08/2026 | `syntax-python.yml` `paths:` deleted · the eleven-job target set in `git/PR-AND-REQUIRED-CHECKS.md` · `GIT-GUIDE.md` split 292 → 39                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| N-028 | Which number is the coverage floor?                                                                              | grilling        | 16/08/2026 | `eb58a20` — `COVERAGE.md` _The promotion tier_ (75 always, 80 from `testing` up, 90 auth flat) · 4 how-to homes demoted · 3 gates un-holed · `12973ef` — `DOCUMENTATION-PAIRING.md` Sections 5 and 6 reconciled                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| N-030 | Teach the routing audit the wrapped `skills:` array                                                              | task            | 16/08/2026 | `0c22b79` — `_lib/frontmatter-skills.sh` shared with `skill-conformance.sh` · `--self-test` 7 probes over both forms · CI self-test step · 571 → 579 names                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| N-034 | Teach the Alpine XSS rule the attributes nobody listed                                                           | task            | 16/08/2026 | `8cc4c08` — `django-template-var-in-alpine-expression` inverted to a deny-list of the five non-JS directives · 6 positives, 0 false positives · a pre-existing `x-transition:enter` false positive closed with it                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| N-022 | Expo SDK tracking — cadence, owner, trigger condition                                                            | grilling        | 16/08/2026 | Ownership **split by act** in `code/src/mobile/CLAUDE.md` (adopt on first store build) + root `CONTRIBUTING.md` _Standing upstream obligations_ (produce on every SDK release) · 2 restatements demoted · `template-update.sh` suites line · **`MAP-UPSTREAM-TRACKING.md` seeded** for the general case                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| N-041 | Make the register checks require a row, not a mention                                                            | task            | 16/08/2026 | `in_row()` beside `in_tree()` in `shipped-readme.sh`; checks 4 and 5 repointed; `--self-test` 26 → 28 probes. **Landed `840acb3`**, 16/08 — the hold behind the script-comment sweep (`6cb733b`) released when that sweep committed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| N-036 | Sweep the dead `uv` premise out of the live files                                                                | task            | 16/08/2026 | 16 files. **The charted table was wrong in both directions** — 8 of its ~15 rows had already been swept by N-035, and 6 sites it never listed were live. Guards untouched throughout, per N-035's doctrine; prose only                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| N-035 | Chart SL-1 and SL-2: both premises are dead                                                                      | grilling        | 16/08/2026 | 7 commits `b805774`…`bde5cc6` — **`uv.lock` committed** + `copier.yml` `_exclude` · **`apps.health`** built for the probe every container already ran · `apps.core` 68% → **100%** · SL-2 deleted, SL-1 rewritten to the limitation that survives. Row written by the N-036 session; **every claim re-measured, none refuted**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| N-010 | Execute how-to workflows `04`, `05`, `06`, `07`, `09`                                                            | task            | 16/08/2026 | All five executed here — the "needs generation" premise died with N-035's `uv.lock`. **9 defects, 7 of them commands that do not exist or cannot work**, all fixed: `pre-pr-check.sh` documented so it ran nothing (`06`, `07`), `server.sh rebuild` and `shell.sh --command` do not exist, `reset.sh` **had never once worked**. Produced `how-to/docs/HEALTH-PROBES.md`, `development/health.sh`, `server.sh stop`, and the collection's first Bruno tests (11/11)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| N-040 | ~~seventeen~~ ~~41 commits~~ **`VERSION` and the three logs were behind the tree**                               | task            | 16/08/2026 | **Settled outside this map, 69 minutes after its last write** — map mtime 17:11, the bumps 18:16–18:20. Eight `chore(version)` commits `a0b48f7`…`a9c56a1` back-filled **4.0.0 → 5.3.0 across 45 commits**. **Four-way parity measured, not read**: `CHANGELOG.md`, `RELEASES.md`, `VERSION-HISTORY.md` and the tag namespace each hold 56 versions, every `comm -3` empty; `VERSION` = 5.3.0 = the newest of all three = `git tag --points-at HEAD`; `git rev-list --count a9c56a1..HEAD` = **0**. All ten items the node listed as unlogged are described at `CHANGELOG.md:13-240`. **The increment was a judgement and was exercised** — `7cd385d` and `8b66790` earned the two MAJORs, each shipping its `copier.yml` `_migrations:` entry. **The sequencing behind N-032 was moot, not honoured**: `git log --oneline v4.0.0..v5.3.0 \| grep -vc 'chore(version)'` = 0, so every tag was cut from one frozen tree and no ordering could have tagged a broken template — **and that same frozen tree is why `N-047`'s migration is mis-keyed**. Residue charted as **N-047**, **N-050** and **N-051**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| N-053 | A token in a live shell word makes a CI step pass having verified nothing                                        | task            | 18/08/2026 | Both `test-api.yml` wait loops rewritten — `exec -T`, container-side expansion via `sh -c`, and a trailing `exit 1`; `:100` and `test-e2e.yml:89` repointed `/control/` → `/health/`; the `--health-cmd` overclaim deleted from `check-template-parsers.sh` and its compose row re-labelled **NOT the shell-word case**; `lefthook.yml` and `audit-template.yml` taught that seventeen and five are different quantities. **Populations re-swept and both closed**: 74 → **73** files carry `<%` and none occupies an executable shell word; all **three** CI wait loops now end `exit 1`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| N-046 | Three scripts report an action they did not take, or a scope they did not honour                                 | task            | 18/08/2026 | `3c0da01` — **four** subshell scripts fixed (not one), `lint.sh --path` scopes markdownlint via `--no-globs` + `:` literals at no cost to the 16 exclusions, `review/SKILL.md`'s false "format.sh rewrites source" corrected, `update.sh` names the files that moved                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| N-056 | Six gates report a clean verdict over a population they never had                                                | grilling        | 22/08/2026 | **Sitting 5 — five of the node's own members died before a question was asked.** `copy-emdash`'s subshell guard was repaired at `3c0da01` and its silent output at `d9fcca8`; `css-gradients` and `css-tokens` were rewritten onto the `copy-slop` shape at `a6e90d3`; the `--since ""` "live CI producer" was **never true** (`fetch-depth: 0` landed `40bf310`, 15/08, before charting); and `docs-length.sh:405` guards a **ref**, not a scope, so that script was itself an unguarded member. **The owed measurement is discharged**: all 24 audits executed, not grepped — the charted fifteen guards hold exactly, zero defeated, and **six exited 0 unguarded**, four of them uncharted (`cloc`, `stubs`, `docs-length`, plus `doc-references` charted for a different defect). Remedy: `--path` guards on all six; **`docs-pairing`'s false denominator killed** (it printed `216/207` for `--path learning`, `--path code/docs` and a nonexistent path alike); `doc-references` given a denominator; and the four accept-then-ignore-the-scope defects fixed. **`sync-trees.sh` was re-framed by <%DEVELOPER_NAME%>'s challenge and got sharper**: it is a writer by design (ADDED/REPORTED/PRESERVED, `:14-21`), so suppressing what it just fixed is correct — the defect is that `:343` filtered on the substring `"not on disk"` when it meant _was this left unresolved_, silently dropping the third class (`:282`, nested tree, unwritable by `:286`). Proven in a clone: `--write --path apps/core` printed the green line at exit 0 over a live finding. Now keyed on a `by_hand` list built at classification                                                 |
| N-058 | Bare `pre-pr-check.sh` invocations survive N-010's fix, in documents that gate on them                           | task            | 22/08/2026 | **Sitting 5 — two edits, not a class fix, and the population was measured rather than inherited.** 45 workflow folders all carry STEPS+CHECKLIST, 42 runnable CHECKLIST spans, and the silent-false-green subclass has **size exactly one**; 109 fenced-bash lines across the skills, **one** member. **The remedy shape was decided by <%DEVELOPER_NAME%>'s definition of the two artefacts** — STEPS is the procedure, CHECKLIST is read _after_ the work to confirm it was done — which inverted the fix: `06-quality-gates/CHECKLIST.md:49` normalises to the **bare name**, matching `07-dependency-updates/CHECKLIST.md:34`, which stops being "the benign precedent" and becomes the model. The rule lands in `how-to/docs/OPERATOR-DOC-CRAFT.md`: a box carries the bare name **or** its STEPS twin verbatim, never a third variant. `.claude/skills/git/SKILL.md:73-77` takes the piped form, because a skill is executed by an **agent**, and `pr/SKILL.md:46` is reconciled in the same change. **A new fact came out of it**: the matcher at `pre-pr-check.sh:35` is `gh pr (create\|new)\b` and does **not** fire on `gh pr ready` — the exact moment `git/SKILL.md` gated on. Both skills now say so                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| N-055 | Four gates skip a leg they cannot run and still print success                                                    | grilling        | 18/08/2026 | `3c0da01` — `code/docs/GATE-REPORTING.md` states the rule once; exit `3` for the syntax scripts, an `unmeasured` state for the hook libraries, `audits/` unchanged. One member refuted, two new ones found                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| N-043 | The shipped exclusion register is false, and it is the rule N-031 classifies against                             | task            | 18/08/2026 | **Verified by generating, not by reading** — `06-GENERATION.md`'s six rows re-stated and asserted against a real `copier copy`, 27/27. The guide **contradicted itself**: `:103` called the guide tree excluded while `:217` excluded it from a token sweep that only runs in a generated project — 0 surviving tokens with that exclusion, **95 without**. Two uncharted falsehoods swept up (`.git` in no row; the artefact allowlist spares **fifteen** further named paths, not just the pairs and templates), the node's own `_exclude` anchors corrected `:29-197`/58 entries → **`:29-250`/82**, and `doc-references.sh:26`'s justification fixed **without touching its code** — narrowing `is_exempt()` is N-031's                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| N-042 | `doc-references.sh` is green on a developer's disk and red on a fresh checkout                                   | task            | 18/08/2026 | `5e2b61d` — **reproduced in a throwaway clone before anything was written**: exit 0 on the developer's disk, exit 1 at the same SHA in a fresh clone, on `.github/scripts/shipped-readme.sh:141`. `install.sh` writes `code/docs/MACHINE-SPEC.md` and `.gitignore:43` ignores it, so the verdict was a property of **who had run `install.sh`**, not of the repository. Fixed with a generated-output arm beside the `*/reports/*` one. Blast radius re-measured rather than inherited: the map's "exactly one site" holds, the second citer is already exempt. **Row moved here 20/08/2026 — the fix landed 18/08 and the map was never updated, which is the same class of drift the node is about**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| N-044 | Naming hygiene on three unwritten deployment scripts                                                             | task            | 21/08/2026 | **Nothing was corrected, and that is the verdict.** All five other sites already qualify ("planned, not present" / "(future)"); the sixth reads as a plan under its own `## Planned Scripts` heading. Registered **nothing** in `PROJECT-PATHS.md` on `FORWARD-VOICE.md` Section 3 — no workflow or script in this repository creates them, and an entry that cannot name its creator is a wish. `deployment/CONTEXT.md` now records that the omission is deliberate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| N-052 | `doc-references.sh` cannot see a bare script name, so those citations are ungoverned                             | grilling        | 21/08/2026 | **Measured and refused — no code change.** Widening Check 1 puts **505 tokens / 4,529 sites** in scope, of which **91 / 351** go red: 54% could never be a citation (`SCREAMING-SNAKE-CASE.md`, `kebab-case.sh`, `robots.txt`), and only **12% (43 sites)** is the target class — which Q1's answer moved out of the citation class entirely. The register-outward alternative died on its own subject: bare `api.py` is ambiguous **3-to-3** between the registered `config/api.py` and N-026's per-app convention. Second node refused on the `code/src/django/` precedent                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| N-031 | Shipped guides cite copier-**excluded** paths — resolves here, dangles downstream                                | grilling        | 21/08/2026 | `is_exempt()` narrowed to `TEMPLATE-GAPS.md` alone (the tree has shipped since `f5fef31` and the arm hid **7 citers**) · the four findings that exposed **all repaired, none suppressed** · **12 sites / 8 files** marked `doc-references: template-only`, taking the marker from **zero** adoption · three false pointers at a register holding **no dated entries** re-pointed at `GAPS.md` · gate graduates to **N-060**. **Residue discharged by sitting 2, 21/08/2026** — the node's own evidence row 1 named **two** excluded paths in `git/PR-AND-REQUIRED-CHECKS.md` and sitting 1 marked one line of it; see _Sitting 1 closed this node half-repaired_ below                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| N-057 | The required set holds the half of a stated pair that cannot report                                              | grilling        | 21/08/2026 | **Sitting 2. Settled by de-requiring, and by deleting the list that went stale.** `Audit JS + Python dependencies` (`audit-deps.yml`) is removed from the set: it runs only on `schedule` + `workflow_dispatch`, so no `pull_request` event can produce it and it had no path filter to delete — the **trigger**, not the filter, was the defect, and the guide's rule never asked that question. Its reporting twin **`[8/8] Security` is required instead**, and **`Routing skills resolve`** joins on N-030's now-met exit condition (`routing-skills.sh --self-test`, 7 probes, both array forms) alongside **`Unresolved conflict-marker audit`**. Set **20 → 22**, applied in branch protection after this merges. The **eleven-row table is deleted outright** — the guide keeps the criteria and the `gh api` invocation that reads the live set, on its own stated principle that _"a membership list written twice drifts once"_. Two collateral falsehoods corrected (`:57-58`, `:60-61`); the guarded-job rule **narrowed** rather than enforced (see the `[n/8]` finding below). **The remedy is a rule, not just an edit**: `git/CLAUDE.md` now carries a standing prohibition — _never write the required-set membership into these four guides_ — and `git/CONTEXT.md` names `Changing the set` as where the reading command lives. **A workflow file may claim only eligibility, never membership**, because membership is a repository setting and these files ship: `audit-conflict-markers.yml`, `audit-deps.yml` and `test.yml` were rewritten to that standard, and `CONTRIBUTING.md`'s eleven-row second copy — stale three ways — was deleted and routed |
| N-050 | A shipped guide asserts a version three days and eight releases dead                                             | task            | 21/08/2026 | **Sitting 2. One string deleted, not updated** — `git/PR-AND-REQUIRED-CHECKS.md`'s `as of 3.2.2` is gone rather than re-dated, because nothing gates a version number in prose and re-dating re-arms the trap. **The node's own headline was stale and is corrected below.** Its asymmetry — one stale site excluded, one shipped — **died before the node was opened**: `README.md`'s badge and footer were bumped off `3.2.2`, and were bumped **by `866d59d`, the very commit that wrote this node's block**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| N-051 | The version rule has three homes naming three file sets                                                          | grilling        | 21/08/2026 | **Sitting 2. Rescoped on measurement, then settled.** "Three homes" is **nine or ten**, and the canonicity claim is **refuted 3–0** — `version/SKILL.md:23-25`, `CONTRIBUTING.md:86-88` and `release/SKILL.md` all name `VERSIONING-GUIDE.md` canonical, and the executed set had **already conformed** at `b4f00db` (5.5.0 touched exactly the guide's six). What survived is sharper and is what was fixed: the executing skill **forbade itself from restating the list and then restated it short by two**, and `24-release` instructed the `pyproject.toml` bump `VERSIONING-GUIDE.md:173` **forbids**. Four sites: `version/SKILL.md` completed to six and its self-prohibition rewritten as _executes_; `git/SKILL.md`, `global-workflow/VERSIONING-AND-DOCS.md` and the `24-release` pair **delete and route**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| N-037 | A skill is a shipped document too, and nothing checks what one claims about the tree                             | task            | 20/08/2026 | `6c920b1`..`692ad63`, seven commits — **the class was re-typed from "two skills, three claims" to "shipped instructional documents assert things about a tree nobody checks", and answered with a mechanism rather than a sweep.** `code/docs/FORWARD-VOICE.md` (the rule) + `how-to/src/PROJECT-PATHS.md` (the register, **three rows**) + a `code/src/django/*` arm in `doc-references.sh` reading it, so the tree that was skipped in silence by the catch-all `*) continue` is now checked. Register entry = path **and** what creates it, and the creator column polices itself for free because a creator is a backticked path the ordinary dangling check already reads. **The repair surface was a third of what the site count implied** — 120 sites / 63 files, but only ~15 of 43 unique paths were real citations; the rest were naming patterns `is_pattern()` already discards                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| N-054 | The health contract publishes a dependency set it cannot probe and an endpoint nothing serves                    | task            | 21/08/2026 | **Both halves were one-sided omissions, not drifts.** `checks.py:70-80`'s `Component` docstring already held the reason — `API` and `PAGES` _"named in the contract but deliberately absent… each arrives with its surface"_ — and `OBSERVABILITY.md:14`, `.claude/skills/logging/SKILL.md:23` and `RELEASES.md:2488` already carried the `django_prometheus`-not-in-`INSTALLED_APPS` qualifier. **The contract was the only document missing what every sibling stated**, which is the sharper finding: the file calling itself the single source of truth was alone in not saying it. `:34` now names two probed (PostgreSQL, Valkey) and two reserved; `:32` **keeps its row** and states the trigger at `OBSERVABILITY.md` → _Deferred, with a trigger_. Row 2 rode with it — Celery floor `>=5.3` → **`>=5.6`** at `PROCESS-MODEL.md:19`, `TASK-AUTHORING.md:13`, `CELERY-FIRST-RUN.md:21`, against `pyproject.toml:60`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| N-048 | The Prometheus scrape job has four homes and two spellings, and the file disclaiming ownership states one anyway | task            | 21/08/2026 | **`-backend` wins on the ownership rule** — `HEALTH-CONTRACT.md:134` assigns _what the server must expose and scrape_ to SERVER-ARCHITECTURE, and that owner says `-backend`. Two sites changed (`HEALTH-CONTRACT.md:95`, `OBSERVABILITY.md:229`); three already conformed. **Every charted anchor had drifted**: `EDGE-REQUIREMENTS.md:171,185,340` measured at **`:174,188,343`**, `TEMPLATE-TOKENS.md:321` at **`:341`**, the drift record `:174-176` at **`:178-179`**. **A fifth site the node never charted** — `OBSERVABILITY.md:236-239` asserted the two were _"spelled the same way"_, false, and **made true rather than deleted**, being the only sentence that keeps them in step. The drift record was **deleted, not corrected**, taking its own _"two places"_ undercount with it (sitting 2's doctrine). **The node's remedy claim is withdrawn** — see the correction below                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| N-020 | Write `deploy.sh`, `rollback.sh`, `health-check.sh`                                                              | task            | 21/08/2026 | **`TEMPLATE-GAPS.md` → SL-2** — closed as _accepted_, not _fixed_: the second of the Destination's three outcomes, and the first node on this map to take it. **The three-way split proposed 16/08 is refused.** It rested on `health-check.sh` _"now needs only an owner (N-044)"_, and **N-044 settled by finding that nothing in this repository creates these three scripts** — the blocker was confirmed, not cleared, so the split's premise was spent before it was proposed. Residue swept at `config/CONTEXT.md`: the routes table gained the two health paths, the _"no health… route at baseline"_ claim corrected, and **a third falsehood nobody charted** — that dev Compose _"probes `/`"_, when `docker-compose.dev.yml:64`, the test file and both deployed Dockerfiles all probe `/health/`. SL-2's trigger is worded **publishes**, not builds: `test-api.yml:75` already builds an image and no workflow pushes one                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| N-047 | The `v5.0.0` migration key fires four tags after the break it warns about                                        | grilling        | 22/08/2026 | **Sitting 4. `copier.yml` gains a compensating `v4.0.0` key** running the same advisory beside the existing `v5.0.0` one. **The node's central objection died on measurement**: re-keying does _not_ rewrite what a published tag meant, because `copier update` checks out the target tag and reads `_migrations` from **HEAD** — it is a forward-looking predicate, not a historical record. The real trade-off is population coverage under copier's documented rule `old_version < key <= new_version`. Re-keying `v5.0.0` → `v4.0.0` would have closed the `v4.0.0..v4.1.1` window **and simultaneously broken the project already sitting inside it**, whose next update to `>= v5.0.0` is the only thing that reaches it today (`4.1.1 < 4.0.0` is false). **Two keys cover all three populations; one cannot, whichever version it names.** The duplicate report on the one path crossing both keys is accepted rather than guarded — the script only reads and always exits `0`. The script header moved in the same change, and the `v6.0.0` entry already cited this node, so the doctrine now has both halves in `copier.yml`. Anchor re-measured: `:641` → `:694`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| N-059 | A shipped comment bans a glob dialect four live legs rely on                                                     | grilling        | 22/08/2026 | **Sitting 4. The measured rule replaces the false one at `lefthook.yml:116-118`; the two local logs are corrected in place.** **Braces do expand** — the 2×2 was re-driven on pinned lefthook **2.1.10** and reproduced exactly: a multi-alternative group whose wildcard-bearing alternative is **not last** silently drops it (`{TEMPLATE-GUIDE/**,TEMPLATE-TOKENS.md}` matches only the second; the identical pair swapped matches both), and a `/` inside a group works. **No gate** — the measured rule condemns none of the four live globs (`:5`, `:14`, `:18`, `:84`), so a check would guard a population of zero, which is **Batch B's own defect**. `CHANGELOG.md:357` and `VERSION-HISTORY.md:24` corrected in place, not annotated: all three versioning logs are template-local and a generated project is seeded clean from `.copier/`, so no downstream inherits either the error or the correction. The comment **names `a05b1c7`**, routing the `git log -S` reader out of the one immutable surface. Three of four anchors had drifted                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |

**Sitting 1 closed N-031 with one of its own charted rows half-repaired — found 21/08/2026 by
sitting 2's completeness pass, not by any node.** N-031's evidence table names three shipped
citers of copier-excluded paths, and row 1 is `git/PR-AND-REQUIRED-CHECKS.md` citing **two**:
`TEMPLATE-GAPS.md` and `audit-template.yml`. Sitting 1 marked **one line** of that file.

- **Why it was missed, mechanically, and it is not carelessness.** Sitting 1 swept the **full
  path** form — `git grep -l -F 'how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md'` returns **13 files
  at `5d7d264^` and 10 at HEAD**; the three it re-pointed are the difference between those two
  runs, not the sweep's own output. The site here writes the **bare filename**, so it was invisible
  to that sweep and is invisible to the gate as well: Check 1 discards slashless tokens.
- **The map had both halves written down and never joined them.** It recorded the bare-token
  blindness in N-052's evidence, then **refused N-052** on the measurement — which was right,
  and left this class permanently un-gated as the accepted cost. Nobody asked what was already
  sitting inside it.
- **Proof the gate cannot see it, at HEAD.** `bash code/src/scripts/audits/doc-references.sh
--path project-management/docs/git/PR-AND-REQUIRED-CHECKS.md` → **exit 0, "Clean"**, with the
  citation unmarked. A green gate on a file with a known live breach.
- **Discharged 21/08/2026, and four of the five sites went a different way**: the `:92` citation
  is marked `template-only`, and the four `audit-template.yml` table rows **ceased to exist**
  when N-057 deleted the table. Two answers to one question, arrived at independently in the
  same sitting — worth recording, because a residue count is only true against a fixed file.

**A shipped rule was condemning its own gate suite, and narrowing it was the answer — 21/08/2026,
out of N-057.** `PR-AND-REQUIRED-CHECKS.md` stated that a guarded job is required at **step**
level, never job level, or it skips rather than reports. Measured: **all eight `[n/8]` jobs in
`claude.yml` carry a job-level `if:`** (`grep -cE '^    if: github.event_name'
.github/workflows/claude.yml` → 8), and two of them — `[1/8] Line Count` and `[5/8] Stub Audit` —
are live required contexts that report on every pull request. `[8/8] Security` is the third, and
joins the set with this change.

- **The rule had merged two different guards.** A **surface-presence** guard ("is there a mobile
  app here?") really does have to sit at step level. An **event-type** guard cannot suppress a
  job on a pull request, because a pull request is one of the events it admits.
- **Three violators would have been three bugs; eight is a rule that overreached.** The remedy is
  the narrowing, not eight CI edits — and the discriminator was reached by counting the
  population rather than the exceptions, which is this map's standing rule pointed at a rule.

**N-050's own headline was wrong in both directions, and is corrected rather than rewritten.**
"Three days and eight releases dead" — **eight releases** was exact at charting (`v4.0.0`…
`v5.3.0`, all dated 16/08); **three days** holds only from `97ded88` (14/08) to the node's write
on 17/08, not from the file's birth. At HEAD both are stale: **eleven** releases
(`awk '/^\| [0-9]/{n++} /3\.2\.2/{print n-1; exit}' VERSION-HISTORY.md`) and **six** days.
The sharper fact is underneath: the node's census claimed exactly three `3.2.2` sites, and
**`866d59d` — the single commit that wrote this node — is the `chore(version): 5.4.0` bump that
took two of them off `3.2.2`.** The census was false in its own commit, before anyone read it.
**Fifth instance on this map of a node producing a member of the defect it charts.**

**N-019 verdict — the routing was the easy half, and the node's real find is that the routing
declaration itself is a one-way claim nobody checks.** The premise re-verified exactly as charted:
**none of the six cited any artefact of `MAP-NEGATIVE-SPACE`** — not the guide, the register, the
commands guide, the audit script, or either new exception class. All six had ample headroom
(63–143 code lines against 300), so nothing had to be split.

- **Five skills, not six. `review` was declined**, on N-015's own "three skills, not four"
  precedent: it is a 63-line sequencer that dispatches `code-reviewer`, `qa-tester` and `security`
  and checks nothing itself, so a pointer there is the no-op `SKILL-AUTHORING.md` Section 4 says to
  cut. The three it dispatches now carry the doctrine, which is the same coverage by a shorter path.
- **The node shipped more than pointers, and that is what earns it.** N-012 assigned two clauses to
  `[judgement]` — whether an enforcement point guards the **right** thing, and whether an invariant
  is **missing altogether** — precisely because no gate can decide either. They have been homeless
  since 11/08. They are now a named dimension in `code-reviewer`, which is the only tier that was
  ever going to hold them.
- **Each skill took the half its own work reaches**, rather than one uniform paragraph. `qa-tester`
  reads `INVARIANTS.md` as an **attack list** and checks both inversions (a programmer error as a
  friendly 4xx is the silence; a user error as a 500 is the noise that gets the rule muted).
  `security` took the disclosure half — a programmer error's body is generic, the detail string is
  the tracker's — plus `MANAGEMENT-COMMANDS.md`, whose "argparse parses, parsing is not validation"
  is an access-control rule wearing a CLI hat. `refactor` gained a **third** thing a move must never
  drop, beside the permission check and the ownership verification. `bugfix` gained the fact that
  reframes a diagnosis: an `InvariantViolation` in a trace is the **guard working**, and the cause
  is always upstream of the raise.
- **A distinction the writing forced, and CI cannot make.** Deleting a guard fails
  `negative-space.sh` (`key-unraised`); extracting one and leaving the original raises a key at two
  sites (`key-duplicated`). **Moving a guard and leaving its register row behind keeps the gate
  green** — the key is still raised somewhere. That is the `[judgement]` half, and `refactor` now
  says so rather than assuming CI will catch it.
- **The deletion class is unchanged from N-015: doctrine only, and still the weakest.** The obvious
  upgrade was measured and rejected on the evidence — see N-025. Nothing re-derives a citation, and
  the survey remains the only thing that would find the hole again.
- **Frontmatter routing is now bidirectional for this guide.** `NEGATIVE-SPACE.md` gained the five
  verifiers and `MANAGEMENT-COMMANDS.md` gained `security`; every name added is cited back in the
  same change. `planner` was **left** on `NEGATIVE-SPACE.md` uncited — it is a pre-existing breach
  and removing it would have "fixed" it in the wrong direction. Side effect worth knowing: eight
  names exceed Prettier's 100-character width, so this is the **only** guide in the tree whose
  `skills:` is a multi-line array — a parser reading that field must handle both forms.
- **Gates green:** `skill-conformance.sh` (64 skills), `docs-length.sh --path .claude/skills` (76
  files, none over; `stack-django` 281 is the pre-existing warn), `negative-space.sh` and its
  `--self-test`, Prettier, and zero section signs.

**N-005 was settled by work already in flight, not by a resolve session.** Verified 14/08/2026
with CI's own invocation — `uvx --from 'ruff>=0.16.3' ruff check .` → _All checks passed_, and
`ruff format --check .` → _796 files already formatted_.

**N-006 took both of its charted options, one per advisory, and the verification is what found the
half that was missing.** The node offered (a) bump/replace `@usebruno/cli` **or** (b) ignore with a
written rationale. Checked on 15/08/2026, the answer was neither-and-both: the mechanism half was
already done and done well, and two live suppressions had no justification at all.

- **What `4419218` had already earned.** The key moved to `audit.ignore` — correct for the 11.21.0
  pin — with no leftover `auditConfig:` block, the four downstream sites renamed in the same change,
  and the `--ignore` false green closed in `check-security.sh` (pnpm has no such flag; given one it
  printed _"No new vulnerabilities were ignored"_ and **exited 0 without auditing**). Proven the way
  this repository requires, by taking the key away and watching the gate go red.
- **What it had not.** `GHSA-5375-pq7m-f5r2` and `GHSA-99f4-grh7-6pcq` — both `@grpc/grpc-js`,
  reached through `. > @usebruno/cli > @usebruno/requests > @grpc/grpc-js` — sat in the list
  **unannotated since `fc905eb`**, carried for two weeks by nobody's decision. `git log -S` confirms
  a rationale never existed. Closing the node on that state would have manufactured a **Batch B**
  defect inside a **Batch A** node: `security.sh` green on a suppression nobody had justified.
- **The remedy was smaller than either charted option.** A patch existed the whole time —
  vulnerable `>=1.14.0 <1.14.4`, fixed in 1.14.4 — and `@usebruno/requests` declares `^1.14.3`, so
  the fix **already satisfied the range**. The lockfile was merely stale. `pnpm update
@grpc/grpc-js` cleared both with **no override and no forced resolution**, a 7-line lockfile diff.
  Option (a) without touching `@usebruno/cli` at all.
- **So the two entries were deleted rather than documented, and that is the rule the node leaves
  behind:** an ignore whose advisory **has** a published fix is a suppression, not a decision.
  Ignore on availability, never on inertia. Written beside the key in `pnpm-workspace.yaml`, which
  is where the next reader meets it.
- **The image-size pair stays, and is the contrast that makes the rule legible.** No patched release
  exists — both advisories name `>=2.0.3`, the newest published is 2.0.2, and an override floor
  fails the install outright. Dev-time bundler, reached only through the mobile surface. Ignored on
  availability, with its re-check trigger already written.
- **Re-proven at the new count, same method:** `audit.ignore` → _2 high (2 ignored)_ **clean**;
  key removed → _2 high_ **VULNERABLE**. Prettier clean, zero section signs. The `(N ignored)` line
  is the assertion, never the exit code.

**N-012 was settled by a fourth option nobody charted, and the fourth option dissolves the question
rather than answering it.** The node offered three paths for the three notes `README.md` and
`THIRD-PARTY-NOTICES.md` made undeletable — (a) narrow the never-quoted precedent to redistributed
rule text, (b) paraphrase the quotations, (c) move the evidence into the ~~excluded~~ `TEMPLATE-GUIDE/`
and repoint `README.md`, which was rejected because it dangles the citation for a generated project.
**Corrected 18/08/2026 — that tree is not excluded and has not been since `f5fef31` (14/08, v3.2.0);
see N-043.** The description was true when the option was framed and is the only place this map
still asserted the falsehood in its own voice. It changes nothing about the outcome — `5a00dde`
took a fourth path — but (c)'s stated **reason for rejection** is void twice over: a citation into
a shipping tree does not dangle downstream at all.
`5a00dde` instead **deleted all four notes and made the folder self-ignoring**, then removed the
reason anything pointed at them: every `README.md` _Influences_ row is now **self-citing** — it links
the primary source and names what that source contributed — and the two rows a link cannot settle
(TigerStyle's 0.0% five-gram overlap, the unlicensed Claude Code docs) cite `THIRD-PARTY-NOTICES.md`,
a **shipped** file. So (c)'s failure mode cannot occur: nothing in a generated project's README points
anywhere that does not ship.

- **The quotation question is not answered, it is voided.** With `research/*` untracked, no verbatim
  quotation of an unlicensed source is redistributed by this template at all, so the missing grant
  never bites — stated at `THIRD-PARTY-NOTICES.md` line 218, which is the same line that used to name
  `SKILLS-VS-SUBAGENTS.md` as the one place that _did_ quote one. Option (a)'s wording change became
  unnecessary rather than being declined.
- **Verified 15/08/2026, and the original entry's own deletability table is the checklist.** Zero
  inbound references survive from `README.md` or `THIRD-PARTY-NOTICES.md` to any of the four notes.
  The five that remain are all in `CHANGELOG.md` and `RELEASES.md`, which the entry itself ruled
  correct and permanent: a historical record naming a file later deleted is accurate, not dangling.
  `audits/doc-references.sh` agrees — _Clean — every citation resolves_.
- **The answer generalised past the node.** `research/` is one of **five** folders on the same
  override (`handoffs/`, `project-management/src/`, `research/`, `questionnaires/`, `learning/`),
  each with its `.gitignore` in `copier.yml` `_exclude`. The apparent contradiction — `research/CONTEXT.md`
  still says "**Committed**, synced home" — is deliberate and documented in `copier.yml`: a shipped
  `CONTEXT.md` describes the **generated project's** behaviour, and the ignore rule is the
  syntek-base-only override that must not travel. Read that line in this repo knowing it is not
  about this repo.

**N-001 / N-013 / N-024 verdict — the batching was right and its stated reason was wrong, and the
node that looked smallest was the one carrying everything.** The map batched these three on
`TEMPLATE-TOKENS.md` Section _Position matters as much as shape_. N-013 does not belong to that
section at all: its three sites are Markdown code blocks, which nothing parses. The batch held for
a better reason, now written as the section's own framing — all three answer **when may a name be a
token at all?** N-001 on position, N-024 on detection, N-013 on honourability.

- **N-001 was undercosted by the map, and the Out-of-scope table said so explicitly.** It was
  charted as buying `basedpyright` and `pip-audit`. Measured on 15/08/2026 with `uv lock --dry-run`,
  the token was the **sole cause** of every Python gate being off: no manifest parse means no
  lockfile, and no lockfile is what every guard tested for. The row reading _"N-001 does not touch
  this"_ about SL-1 was false — see the correction in Out of scope below. **The lesson is the
  measurement, not the answer:** the node had been costed from the guards' stated reasons rather
  than by running the tool once.
- **The re-ask was answered against a premise that had also moved.** The map asked "is a placeholder
  name worth it for those two, or is per-tool routing the better standing answer?" Per-tool routing
  is what saved ruff at `24a5fb7`, but it **cannot** reach this: a lockfile is a project artefact,
  not a launcher, so no amount of `uvx` fixes it. The question only looked open because the prize
  was undercounted.
- **Six gates were unguarded, not three.** N-002, N-003 and N-004 were charted. `claude.yml`'s
  `[3/8] Format`, `[4/8] Lint` and `[8/8] Security` were not, and had been announcing themselves —
  _"Running Prettier only"_, _"Running ESLint only"_, _"Auditing the JS dependency tree only"_ — on
  every template run since they were written. **Every one was verified green before being
  unguarded**, which is the opposite order from the one that makes a gate a liability.
- **N-004 needed no code at all.** `audits/security.sh` was never guarded; it simply could not work.
  The whole node was N-001 wearing a second hat — worth recording, because a task node that
  dissolves is indistinguishable on a map from one that was done.
- **N-024's charted plan does not survive its own evidence.** "Teach the script the positions that
  qualify" assumes positions are decidable. `pnpm` parses `<%PROJECT_SLUG%>` in `package.json`'s
  `name` — root **and** mobile — while `uv` rejects the identical token in the identical position.
  A hand-maintained register would have been the rule again one level up, still carried by whoever
  remembers to read it. **Asking each parser is the only formulation that stays true**, and it
  catches `70fc963`'s shell case, which no identifier list ever could.
- **A row the rule was missing.** The shell-word case is a _different_ failure: everywhere else the
  delimiters are illegal and a parser refuses; in a shell word they are **legal and active**, so the
  command parses fine and silently does something else. It is now its own row.
- **A gate that pays a second dividend.** The compose probe needs each `.env.<env>.example` to
  interpolate, so it now also proves every example env file is complete enough to render its own
  compose file — a property nothing checked before.
- **The one cost, written where it bites.** Branding by `_task` means `copier update` never re-runs
  it, so changing the literal would reach an existing project and rename its package. Recorded in
  `pyproject.toml` beside the constant, and asserted in `[3/4]`: a generated project's manifest must
  carry its own name **and** its `uv.lock` must not pin the template's, which is what proves the
  task ran before the lock.
- **Proven end to end, not argued.** `copier copy` run locally against `7cd385d`: tasks 3 and 4 in
  the right order, `name = "ci-probe"`, a 298 KB `uv.lock` naming `ci-probe` and never
  `syntek-base`, zero unrendered tokens, zero `CORE_APP` references outside the retirement note,
  and no template-only file leaked.

**Batch D's three shared a class, not a subject — and each turned out to be an instance of a
general defect rather than the local one charted.** That is the batch's finding, and it repeats
N-019 → N-025 three times over. None of the three fixes is a file change; all three are rule
changes, which is what "split doctrine" was always going to mean once looked at properly.

- **N-014 — the asymmetry is correct, and it was never the defect.** Measured rather than argued:
  `msp-scp-documents` covers **12** document types and would be ~644 raw lines unsplit, well past
  the 300 gate; `legal-documents` covers **6** at 226 and fits with headroom. So one skill had to
  disclose into sub-documents and the other did not. The counter-measurement settles the
  temptation to "fix" it: per single-document task the split form loads **more** — `SKILL.md` 101
  - the always-needed `STANDARDS.md` 137 + one thematic doc 57–135 — against a flat 226. What the
    measuring **did** find is that both files carried a `## Clarifying questions` section, the only
    two left repo-wide, against `.claude/CLAUDE.md` Section 10's project-wide supersession. They were
    **compressed, not deleted**: the section held a decision grilling does not own — use the
    stateless `/grill-me`, never `/grill-with-docs`, because the output goes to professional review
    rather than into the repo — and deleting it outright would have lost that.
- **N-016 — the rule lost to the practice, 13 to 9, and the rule was wrong.** `schemas.py`'s
  24-line module docstring was charted as the defect; it is the worst case of a near-universal
  pattern — **13 of 22** module docstrings in the template's own Python are multi-line. Sam's cut
  is by **kind, not scope level**: a docstring says why the **unit** exists and runs as long as
  that needs; a **comment** is one line about why _that line_ is there. A second, separate breach
  surfaced in the same measurement — **6 files** cited a `code/docs/*` path against the
  outside-reference ban — and it was settled the other way: **self-contained, no exceptions**,
  because a pointer is not a reason and it rots at a different rate from the code around it. The
  sweep then found three more the node never mentioned, in `mobile/lib/*.ts` and
  `crates/desktop/build.rs`, since the rule's scope covers `.ts` and `.rs` too.
- **The rule had two homes each claiming to be canonical**, which is the class in its purest form:
  `CHANGELOG.md` called `VERSIONING-AND-DOCS.md` "the canonical standard … **mirrored in**"
  `STYLE-AND-PROCESS.md`. **A mirror is a second home.** Ownership settled on the code guide — a
  code rule belongs in `code/docs/`, and skills route to it — and the four other statements were
  demoted, `stack-django`'s "every module opens with a one-line docstring" among them.
- **`doctrine-drift.sh` cannot hold this rule, and saying so was better than shipping a dead row.**
  Its claims table matches **fenced-code lines only**, and its own instructions require a regex
  anchored to "something a STATEMENT has and a mention does not — never a bare word". This rule is
  prose with no such anchor. N-015 built that table as the thing future split-doctrine rules join;
  this is the first one that cannot, and the boundary is now known rather than assumed.
- **N-017 — not a mobile problem, and the gate was blind by construction.** The node asked for
  three mobile pairs; enumeration found **17** tracked source directories carrying neither file,
  of which **5** are the Rust and desktop crates — the same class, never mentioned. Worse,
  `docs-pairing.sh` iterated over the `CONTEXT.md`/`CLAUDE.md` files that **exist**, so a
  directory holding neither was unreachable rather than overlooked. The rule now turns on **who
  works there** rather than who made it, with five exempt classes: generated output, synthetic
  fixtures, the root, a skill folder (oriented by its own `SKILL.md`), and a single-purpose leaf.
- **N-025's warning was heeded, and it changed the scope.** A repo-wide enumeration would have
  shipped **red on 95 directories** — 62 of them skill folders. Scoped to `code/src/**`, with the
  leaf exemption expressed as arithmetic rather than a path list (one tracked file, no tracked
  sub-directory), it is green on 9 real cases once 5 are paired. **Proved in both directions**:
  removing `mobile/app`'s pair fails the gate with the new message, restoring it passes.

**N-027 verdict — the warn tier was not a category to file, it was an instrument that had never
been built, and the node proved itself three times over while being answered.** Charted at five
files in the band; six by the time it was taken; and the three movements that got it there —
`stack-django` 281 → 290 on N-025, `audits/CONTEXT.md` 270 → 279 on N-007, `.claude/CLAUDE.md`
entering outright on N-009 — were **three different nodes, none of them this one**, each
spending someone else's headroom with no obligation to notice. Sam's cut: **warn carries an
obligation, and it is the crosser's**, expressed as a ratchet rather than an owner.

- **Below 270 nothing changes; at or above it a file may not get LONGER without a dated reason.**
  That is what the tier's own comment always claimed it was for — "far enough from the wall to
  split deliberately rather than under duress" — and nothing had ever made the deliberate split
  happen. A file **born** in the band is held to the same bar, or any file could enter at 299 and
  the ratchet would never see it.
- **One flag, two baselines, and the second is what makes it real.** `--since <ref>`: lefthook
  passes `HEAD` for immediate local feedback, CI the merge-base. A HEAD baseline **alone** would
  have reproduced the very creep the node describes, one commit at a time — the failure mode was
  spotted in the option list rather than after shipping.
- **A dated allowance, and the date is mandatory by format.** `<!-- docs-length-allow: <reason>
(expires DD/MM/YYYY) -->`. This is the **third** register with an expiry trigger, and it answers
  the counter N-006 raised against the whole idea: the entries that rotted there were the
  **undated** ones, which cannot happen where the parser refuses an undated marker.
- **Two silent-failure traps found by building it, either of which would have shipped a green
  gate that measured nothing.** `cloc` infers language from the **file extension** and emits
  nothing at all for an extensionless path — a baseline extracted to a bare `mktemp` compares
  clean forever. And the rule's own documentation tripped its own gate, because
  `.claude/CLAUDE.md` Section 8 quotes the annotation syntax; fixed by **shape** (an annotation is
  a whole line) rather than by narrowing scope, since unlike the copy audits this one cannot stop
  reading instructional Markdown.
- **`--self-test` proves seven cases in both directions**, and it cannot use a fixture directory
  like its siblings because what it reads is git **history** — so it builds a throwaway repository
  and drives a copy of the script through it. The three negatives carry as much weight as the
  positives: a ratchet that fired on a file that had shrunk would be reverted within a day.
- **No exemption for a register that grows by design** (`audits/CONTEXT.md` gains a row per
  script by its own `CLAUDE.md` rule). A register nobody finishes reading is precisely what the
  cap exists to prevent, so it becomes an index like anything else — which lands as real work on
  a file already at 279.
- **The gate's first bite was on its own author**: the Section 8 rule text took `.claude/CLAUDE.md`
  from 269 to 277, crossing the tier. Deferred to **01/11/2026** with the reason written in — the
  split is a genuine question about the auto-loaded root config and not a side-effect of this node.
  **Discharged the same day, and the deferral never reached its date — corrected 16/08/2026.**
  `0e62bdc` took `.claude/CLAUDE.md` from **326 to 208** code lines and **deleted the allowance
  rather than renewing it**, moving the length rule out to a new `code/docs/DOCUMENTATION-LENGTH.md`.
  So the node's own worked example is gone from the band, and the ratchet is doing the other half of
  its job unremarked: `audits/CONTEXT.md` grew **270 → 285** at `b404307` and is correctly held by a
  dated allowance at its line 8, expiring 01/12/2026. **The warn band is five files again, not six**
  — `code/docs/encryption/FIELD-ENCRYPTION.md` 291, `stack-django` 290, `SEO-CHECKLIST.md` 289,
  `VISUAL-DESIGN.md` 287, `audits/CONTEXT.md` 285. Only `stack-django` carries an allowance
  (01/11/2026); the other four sit in the band unannotated, which the ratchet permits until one grows.

**N-032 verdict — the fix is one character moved, and the interesting part is that the defect was
created by a correct instinct.** `conflict-markers.sh` builds its markers rather than writing them,
because a file that greps for conflict markers must not contain any or it flags itself. That
instinct is right and stays. The expression it reached for was `printf '<%.0s'`, which puts
Copier's `variable_start_string` in the file: Jinja opened an expression, never found the closer,
and `copier copy` died with `TemplateSyntaxError: unexpected '.'` before writing a single file.

- **`%.0s` consumes its argument and prints nothing, so the literal can sit on either side.**
  `printf '%.0s<'` produces the identical seven characters and contains no delimiter. Proven
  byte-for-byte on all three builders before the edit — open, close and the space-mangled close —
  rather than assumed from the format-string rules.
- **All three were reordered, not just the broken one.** `CLOSE` and `MANGLED_CLOSE` use `>` and
  were never at risk, but leaving them bracket-first leaves the next person a template to copy, and
  the copy is what reintroduces the class. Symmetry is the cheap half of the fix.
- **The comment is the durable half.** Six lines above the builders now name the constraint, why it
  exists, that this script shipped the defect on 15/08/2026, and which gate catches it — so the
  reason survives in the place someone would otherwise reintroduce it. The escape spelling the map
  proposed (`printf '\x3c%.0s'`) was **declined**: it works, but it hides the character behind a hex
  code for a reader who then cannot see what the script builds.
- **Proven four ways, and the generation is the one that counts.** `check-template-tokens.sh` → 1986
  well-formed tokens, exit 0; its `--self-test` → 8 probes, the unclosed-variable check still fires;
  `conflict-markers.sh --self-test` → all 6 cases, **including "fires on all 4 known-bad forms"**,
  which is what proves the reordered builders still produce real markers; and a full
  `copier copy` → **exit 0, all five tasks, `name = "gen-probe"`, a `uv.lock` naming the generated
  project with zero `syntek-base` occurrences**. The generated copy's own `conflict-markers.sh`
  self-test was run inside the probe and passes, so the fix survives rendering.
- **Thirteen audits re-run green afterwards**, and no `CONTEXT.md` changed: the script's behaviour,
  flags and output are identical, so the inventory row still describes it. Not touching
  `audits/CONTEXT.md` also keeps a file at 285 out of the ratchet's way for nothing.
- **What it does not settle: N-033.** The one-line fix does not explain how a red gate stayed red
  and unread for seventeen commits. That is the node, and it is untouched by this.

**N-033 / N-029 / N-038 verdict — the charted question was wrong about its own facts, and the
correction is what made the remedy cheap.** The node read _"the template-integrity gates never run
on a feature branch"_. Measured against GitHub's own documentation and this repository's history,
that is too strong: `pull_request.branches` filters the **base** branch, so a PR from any feature
branch to the chain already fired `audit-template.yml` — and `45e2be6`'s own message
(_"the two gate faults this branch's own PR check found"_) is the evidence. **The real defect is
narrower and worse: there is no signal before PR-open**, and the window that hid N-032 was
seventeen commits with no PR in it, during which `check-template-tokens.sh` was exiting 1 and
naming the line the whole time. Nothing local ran it.

- **The remedy split by cost, which the wrong framing would have hidden.** The gate has a
  sub-second half and a full-`copier copy` half. `[1/4]` and `[2/4]` moved to a `lefthook.yml`
  pre-commit leg; `[3/4]` and `[4/4]` stayed at PR time, being far too slow and needing the whole
  toolchain. A branch-list widening — the map's first charted option — would have paid CI minutes
  on every commit to close the gap _later_ than lefthook does.
- **The leg's own `set -e` is the node in miniature, and it was proven rather than asserted.**
  lefthook reports the status of the **last** command in a `run` block, so without `set -e` five
  failures followed by one pass report a pass. Driven through lefthook 2.1.10 itself: without it,
  exit 0 on a failing `shipped-readme.sh`; with it, exit 1. **A Batch B fix that shipped a Batch B
  defect inside itself would have been the whole class in one file.**
- **The self-tests are conditional, and the reasoning generalises.** A self-test proves a detector
  still discriminates, and a detector stops discriminating only when somebody edits it. Charging
  6.75s on every commit to re-prove an untouched script is the cost without the reason, so the
  three `--self-test` runs fire only when a `.github/scripts/*.sh` file is staged: ~4s ordinary,
  ~11s when a detector moves.
- **N-038 was pulled out of Batch E because the leg could not ship green without it**, which is the
  N-008 precedent applied one gate later. All six of its findings came from work this map settled —
  `conflict-markers.sh` is N-008, `audit-static-analysis.yml` is N-007, `DOCUMENTATION-LENGTH.md` is
  N-027's discharge, `dict-discipline.sh` is `MAP-DOMAIN-OBJECTS`. **Four nodes each shipped a gate
  and none registered it.**
- **A third member of the class fell out of building the second.** `.claude/hooks/lib/check-audits.sh`
  looped over `shipped-*.sh` — a drifting list wearing a wildcard so it looked like a scope. It
  covered two of the four scripts in `.github/scripts/` and silently excluded
  `check-template-tokens.sh` and `check-template-parsers.sh`, the two that answer _can this template
  generate at all_. That is what N-032 cost, one layer further in.
- **N-029's write-up forced a split nobody planned.** Recording the eleven-job target set took
  `GIT-GUIDE.md` from 269 to 292 code lines, tripping N-027's ratchet — the instrument biting a
  successor rather than its author. Sam took the split over a dated allowance, on the same
  precedent that took `.claude/CLAUDE.md` from 326 to 208. The guide is now a 39-line index over
  four sub-documents, and **31 section-level citations were repointed**, 16 of them CI workflow
  headers.
- **The split is provably a move, not a rewrite.** Of 258 non-blank lines at `HEAD`, exactly 7
  differ, and all 7 are the one paragraph deliberately replaced by the required-set table. Every
  H2 and H3 kept its wording character for character, because those headings are what the 31
  citations name.
- **`Routing skills resolve` is on the target set and deliberately held back.** It is N-030 — a gate
  reporting every name resolving while never opening `NEGATIVE-SPACE.md`. Requiring a green that
  means nothing is the instrument outrunning the rule, so the row carried `Hold` until N-030 landed.
  **N-030 landed at `0c22b79` on 16/08/2026 and the row was not flipped for five days.**
  **Discharged 21/08/2026 by sitting 2**, which settled N-057 by deleting the table the row sat in
  outright; `Routing skills resolve` joins the required set in the same change. Both paragraphs
  above are history, not live state — nothing in the guide reads `Hold` any more.

**N-028 verdict — the node was charted as a contradiction and measurement made it an omission,
which is what decided it.** The map read _"`COVERAGE.md` says 75 no-exceptions, CI enforces 80"_,
implying one of the two numbers was wrong. Neither was. The 80 is a **deliberate promotion
ratchet with its reason written out** — `how-to/workflows/06-quality-gates/CONTEXT.md` says _"a
change that passes locally can still fail the promotion"_ — documented across four files in that
folder and implemented in four gates. The defect was that the file whose own `CLAUDE.md` calls it
_"a single source of truth"_ was the only home that had never heard of it. So the sentence that
was false was **"Hard floor — no exceptions"**, and the remedy was to teach the owner rather than
delete the instrument.

- **Two files charted, seven found.** Beyond `COVERAGE.md` and `test.yml`: `claude.yml` (twice in
  comments, once in a command), `check-tests.sh`, `pre-pr-check.sh`, `backend-coverage.sh` and
  `scripts/tests/CLAUDE.md`. **This is the standing lesson about denominators again** — N-025's
  "a node carrying a ratio names the population it counted", one map-node later.
- **Ownership on N-016's precedent, and it applied cleanly for once.** _A mirror is a second
  home_: the four `06-quality-gates` files drop the number and route. `code/docs/testing/CLAUDE.md`
  was itself breaching the rule it stated — it forbade restating a number and then restated two,
  and routed a floor change to `code/CONTEXT.md`, **which carries no floor at all**. A routing
  instruction naming a home that does not hold the fact is Batch E wearing Batch D's clothes.
- **Three gates disagreed with the rule they claimed to enforce, and none of them was charted.**
  `pre-pr-check.sh` ran `all.sh` **without** `--coverage` below staging/main and set the floor to
  `0`, so a feature branch reported a green `[7/8]` having measured nothing; `claude.yml` ran bare
  `pytest` on every non-promotion branch, the same hole; and the **90% auth floor ran in two of
  four Python paths**. All three closed, because Sam's scope was "no gate disagrees with the
  settled rule" — leaving one is precisely N-036, the fact corrected in one place and the reason
  left standing in fifteen.
- **The two halves key off different things, and that is now proven rather than assumed.** The
  hook keys on the branch you are **on**; CI keys on the branch you **target**. Sam extended the
  hook's tier down to `testing`, which put the two out of step at exactly one hop
  (`testing` → `dev`), so `test.yml` and `claude.yml` gained `dev`. Verified by extracting the
  **shipped** `case` statements and driving all five hops: 75/75, 80/80, 80/80, 80/80, 80/80.
- **The auth floor is measured separately from the aggregate, which it never was.** A project can
  clear the total while `apps/users` sits under 90. The extractor mirrors `backend-coverage.sh`
  rather than inventing a second method, and **fails closed** on an unparseable report or on zero
  matched lines — proven at 40%, 90%, no-lines and not-XML, then driven through the sourced
  function in four states.
- **What is not proven, stated rather than implied.** All four Python suites are guarded on a
  `uv.lock` that does not exist here, so **none has ever executed** and no threshold has been
  watched firing against a real coverage run. That is **N-035**, and it is the node that will
  first exercise every line of this one. Read this node's evidence as "the logic is right and the
  gates parse", never as "the floors have bitten".
- **Gates green:** 19 `audits/*.sh`, the three `.github/scripts/` template-integrity checks,
  `docs-length --since HEAD` (`COVERAGE.md` 143 lines, nowhere near the band), `docs-pairing`,
  Prettier and markdownlint — all through lefthook on the commit itself.

**N-030 verdict — written up by a different session from the one that settled it, so every claim
below was re-measured rather than read off the commit message.** That is the standing lesson —
_a finding handed to you is a claim, not a conclusion_ — applied at the **session** boundary
instead of the map or agent one. All of it held; the residue at the end is what re-measuring found
that the commit did not mention.

- **The premise and the arithmetic both check out.** `code/docs/NEGATIVE-SPACE.md` writes its
  `skills:` array across **eleven** lines, and the old `/^skills:[[:space:]]*\[/` selector matches
  it **zero** times — the file was skipped whole. 571 names across 246 files became **579 across
  247**: exactly the eight names, exactly the one file, nothing else moved.
- **The map charted one selector and there were two.** `check_gated`'s file list ran
  `head -20 | grep -E "^skills:.*<name>"`, blind the same way **and** blind to any frontmatter
  longer than twenty lines, so a copier-gated skill named inside a wrapped array was exempt from
  the co-variance clause by accident. The 16/08 re-verification had already found the second one;
  the node's own charting had not.
- **The two parsers disagreed about which files even have a `skills:` list**, which is the finding
  worth keeping. `skill-conformance.sh` clause 14 reads the same key to ask the opposite question
  and already handled the wrapped form. Both now source `_lib/frontmatter-skills.sh` on the
  `_lib/conflict-markers.sh` precedent — **the copy that is wrong is believed exactly as much as
  the one that is right**, and here the weaker copy was the one guarding the gate. Clause 14's
  verdict is unchanged at 119 names, which is what proves the share was a move and not a rewrite.
- **Re-proven here, not accepted.** The original reproduction — `this-skill-does-not-exist`
  injected into the real wrapped array — now **exits 1 and names the skill** where it previously
  reported _"✓ Every routing skill resolves"_. `--self-test` passes **7 probes over both array
  forms**, and its clean half asserts a **name count** as well as a finding count, because a
  skipped file and a correct file both report zero findings and that indistinguishability is the
  entire defect class. It also states what it does **not** cover — the co-variance verdict's
  `copier.yml` `_exclude`/`when:` chain, only its file selector — rather than leaving a reader to
  find the gap.
- **The fixtures assert they are still wrapped**, so a future Prettier reformat fails the proof
  instead of quietly halving it. That is the defect's own cause turned into a guard.
- **Residue — an open loop for five days, DISCHARGED 21/08/2026 by N-057.** The guide's
  required-set table carried `Routing skills resolve` → **`Hold — see below`** with the parser
  defect described in the present tense as the reason, and the node's own exit condition — _"the
  row carries `Hold` until N-030 lands"_ — had been met at `0c22b79` on 16/08/2026. It was not
  flipped at the time because the other half of promoting a check is a GitHub branch-protection
  setting no file in this repository can make, and flipping the row alone would put a written
  claim ahead of the enforcement, which is the class this batch is named for. **N-057 discharged
  it by deleting the table**: the row, the `Hold` and the reasoning are all gone, and the guide
  now holds criteria plus the `gh api` command that reads the live set. Re-locate by string, not
  line — `git grep -n 'Hold — see below' project-management/docs/git/` returns nothing.

### Closed before the register ever saw them

Three defects were found and fixed between charting and this audit, by trying to open a PR and
by reading a red `main`. None reached `TEMPLATE-GAPS.md`, so none is on the Register-claimed
table — recorded here so the map is not read as the complete history of the period.

| Commit    | Defect                                                                           | Class |
| --------- | -------------------------------------------------------------------------------- | ----- |
| `c79dfe7` | `pre-pr-check.sh` could not run in the template at all; its security leg nowhere | B     |
| `0a652ed` | `setup-uv`'s post step failed on an empty cache — 4 months of red, every run     | B     |
| `70fc963` | `--health-cmd` runs through `/bin/sh`, where the token's `<`/`>` are redirects   | A     |

`70fc963` is a **second confirmed instance of the class `N-024` covers**, and the sharpest one
yet: the position that broke was a shell word, not a manifest field.

---

## Frontier

**9 open at 22/08/2026, after sitting 4 — the current reading is the header block above, and
the trail below is kept as written.** This opener read **19** from 20/08 through sittings 1, 2
and 3 while the header block was recounted three times beneath it, which is the **fifth** drift of
this map's prose count from its own tables and the first to survive three consecutive sittings.
The standing rule caught the header every time and never reached this line, because the rule says
_recount from the tables_ and nobody asked **which** sentence they were about to make stale. It is
corrected here rather than deleted, being its own best evidence.

~~19 open~~ — **recounted from the tables 20/08/2026, after N-037 settled and N-042's row was
moved two days late.** Per batch: A **0** · B **4** · D 4 · E **7** · unbatched 4, and
**19 + 40 = 59 = N-059**. **This opener carried 24 for two days after the header above had been
corrected to 19** — the same drift as N-042's row, one heading apart, found by recounting the
tables rather than by reading either sentence. The reading before it was 24 on 18/08/2026 after
N-053 settled (A 0 · B 7 · D 4 · E 9 · unbatched 4, **24 + 35 = 59**); before that
25 on 16/08 after the Batch B challenge pass added N-055 to N-059; the pass before that left 20
(N-053, N-054). 23 at charting, 21 by the end of 14/08, 23 again on intake that
evening, 15 after the
first 15/08 sittings **which closed two whole classes**, then 10 as Batch D and N-009 and N-025
fell, 12 because settling N-025 charted two new nodes out of its own evidence (N-030, N-031) —
**19 on 16/08 when a verification pass added nine without settling one, then 18 the same afternoon
as N-032 was fixed**, **16 that evening: Batch B's first sitting settled three (N-033, N-029
and N-038, the last inherited from Batch E) and charted N-041 out of its own adversarial pass, so
the net is minus two** — **15 when N-028 fell, the first node settled beside a sitting rather than
as one** — and **14 when Batch B's sitting 2 opened and took N-030, and 12 as that sitting closed on N-034 and N-041.** Two sessions settling one
map on one branch in one afternoon, which is a first for this map and is why the counts below are
recounted from the tables at every write rather than carried forward.

**Then 11 as N-022 settled, 10 as N-036 did, 9 once N-035's row was moved — and 12 again on
16/08/2026, when the Batch E verification pass charted N-042, N-043 and N-044 without settling
anything.** The number is the same as two paragraphs of trail ago and means something different:
**this reading is 9 surviving nodes plus 3 new ones, not the 12 that sitting 2 left behind.** A
count that returns to a previous value is the one case where checking the number against the last
sentence carrying it succeeds by accident, which is exactly the failure the standing rule below
exists to prevent. Recounted from the tables **at that pass**: Batch A 0, Batch B 2, Batch D 1,
Batch E 7, unbatched 2.

**Superseded the same evening, twice.** N-010 settled and charted N-045 and N-046; N-040 settled
outside the map; then the challenge pass charted **six** — N-047 to N-052. Recounted from the
tables **16/08/2026 after charting**: Batch A 0, Batch B **3**, Batch D **4**, Batch E 8,
unbatched **3** = **18 open**, **34 resolved**, highest node **N-052**. 18 + 34 = 52 ✓.

**The frontier grew by half in one evening, and that is the pass working rather than failing.**
Two nodes were challenged; both died on their premises; and the six that replaced them were found
in the ground the two had been standing on. **A frontier is a list of what someone has looked at**
— the map already knew that (see the 16/08 verification bullet below) and has now measured it a
second time at a different scale. **Batch D is the largest open class for the first time**, having
been declared closed twice in two days.

**This paragraph read "18 open" against tables holding 16 until 16/08/2026, and two more counts
were stale with it** — the _Gate to stories_ item said "the remaining 18 nodes" and the resolved
tally said 22 against a table of 25. All three are corrected here. That is the **third** time this
map's prose count has drifted from its own tables (the 15/08 pass said 12 against 10), which is
long past coincidence: the tables are edited node by node and the prose is edited from memory.
**The standing rule, now stated rather than re-learned: recount from the tables before writing a
count, never from the last sentence that carried one.**

**And it drifted a fourth time, in the first pass after the rule was written.** On 16/08 the header
read 14 · 0 · 27 against tables holding **12 · 0 · 29** — off by exactly the two nodes Batch B's
sitting 2 closed (N-034, N-041), with the same error mirrored at _Gate to stories_' last two items.
The Frontier paragraph above already said "12 open" and was right, which is the tell: **the tables
and the prose nearest them are edited together; the header and the gate are edited from memory.**
The arithmetic check that settles it in one line: **open + resolved must equal the highest node
number**, 12 + 29 = 41 = N-041.

**The standing lesson gained a third half on 16/08/2026: re-verify what a _handoff_ hands you.**
The map already says re-verify before grilling, then re-verify what another **map** hands you.
Today eight findings crossed a **session** boundary inside a handoff document and were re-measured
before being written here: **four refuted, two partial, two confirmed.** Two of the refuted ones
(N-020's "false" blocker, N-021's "false" blocker) would have sent the next session to write
scripts and runbooks against obstacles that are still standing — the precise harm the corrections
were meant to prevent. That is the same four-of-eight ratio as the `MAP-ABSENCE` intake earlier the
same day, from a different source in a different format. **A finding survives the session that
measured it only as a claim**, and the shorter and more confident its wording, the more of the
measurement has been left behind.

**The standing lesson turned out to have a shape the four halves were all instances of, found
16/08/2026 by a sixteen-agent challenge pass that failed twice in the same way and caught itself
both times.** The four halves name **boundaries** — map, handoff, session, sibling node, agent. The
shape underneath them is not a boundary at all:

> **A frontier is only empty when a search that _could_ have found a member came back empty. Name
> the search, its population and its exclusions — or write `unverified` instead of `none`.**

- **Three instances in one pass, all of them claims of absence from a search that could not have
  found the thing.** The Batch A closure declared the frontier empty by **reading the node table**
  and never sweeping — a member was sitting in `test-api.yml:86` (N-053). N-031's challenge
  declared N-042 dead from a `git grep` carrying an **inherited pathspec** that hid the only
  surviving citer. N-020's charted obstacle claimed no workflow builds an image, from a
  `grep 'docker build'` that **cannot match `docker compose … build`**.
- **The process caught all three, but only because every leg was doubled.** The verifier caught
  one, the adversary caught the second, a reviewer caught the third. **A pass with any single leg
  missing would have written a false verdict into this map** — which is the argument for the
  challenge → verify → review shape, stated as a measured result rather than a preference.
- **Nine of 70 verification checks refuted and eight partial**, against 53 confirmed. The failures
  clustered entirely in the two **bounded** legs — the ones given an effort cap — and both
  self-certified their own inference. **An effort cap buys speed by spending exactly the margin
  that would have caught this**, so a capped leg's absence claims need a second pair of eyes even
  when its positive claims do not.
- **Stop charting counts; chart the command that produces them.** Three independent nodes have now
  under-counted their own class by 3x to 8x — N-031's citer set 3 → 25 → 33, N-036's table _"wrong
  in both directions"_, N-037's floor ~10 → 87. That is **one habit, not three mistakes**, and the
  remedy is that a node carrying a number carries the invocation that regenerates it.

- **The map was right about its own nodes and wrong about its own completeness, and only one of
  those is visible from inside it.** Ten nodes re-verified, ten still true, twelve audits green —
  and in the same tree, generation was broken, eight routed findings sat unadopted, and seventeen
  commits had gone unlogged. **A frontier is a list of what you decided to look at.** Re-verifying
  it proves the list is honest; it cannot prove the list is complete, and this map has now measured
  the difference at nine nodes in one pass.
- **Batch A reopened on its own closing commit, and closed again the same day.** N-032 was shipped
  by `8050ac7`, the commit that settled N-008 — the last node the 15/08 session recorded — and was
  fixed on 16/08. A class is not closed when its last node is settled; it is closed when nothing is
  producing new members, and this one produced a member the same day it was declared shut. **The
  count is 18 with the batch empty again**, which is the state the map was in yesterday and should
  not be read as the same thing.

- **A stated measurement can hide an unstated scope, and this map shipped one.** N-025 was
  charted as "26 of 77 pairs breach". Both numbers were reproducible and both were `code/docs/*.md`
  **alone** — a scope the node never wrote down. The same rule across all three top-level guide
  trees is **52 of 116**, and across every guide including sub-documents **232 of 330**: a 9x
  spread between readings of one sentence. Nothing was wrong with the measurement; what was
  missing was the denominator's definition. **The standing lesson: a node carrying a ratio names
  the population it counted**, or the session that resolves it silently picks one — and the pick
  changes the remedy, not just the number.

- ~~**Batch A is closed, and it was the expensive one.**~~ **Reopened 16/08/2026 by N-032.** The
  rest of this bullet stands and is left as written; only the claim of closure is withdrawn.
  N-006 fell to work already in flight; then
  N-001 was grilled and took N-002, N-003 and N-004 with it, plus three `claude.yml` gates nobody
  had charted, plus N-024's detector. **Three of its six nodes were overtaken by work in flight
  rather than settled by a session** — a fact about the class, since a token blast radius is
  repaired by whoever trips over it. The standing lesson survives the batch: **re-verify before
  grilling**, because N-001's cost and N-024's plan were both wrong on the map and only measurement
  showed it.
- **Batch C is closed.** N-012 to `5a00dde`, N-013 in the N-001 batch — which is where it belonged,
  though not for the reason the map gave.
- **Batch D lost two**, N-015 then N-018, in that order and for that reason: the envelope had to be
  settled before a second surface could be asked what it returns.
- **Batch E lost one and gained one.** N-019 resolved and produced N-025 out of its own findings,
  so the count stood still while the composition changed.
- **Two arrived from outside the register.** `MAP-NEGATIVE-SPACE` discharged its fog of war the
  same evening and **graduated two entries here** rather than parking them on a map that has
  shipped — **N-026** (Batch E) and **N-027** (unbatched). They are the first nodes on this map
  that did not come from `TEMPLATE-GAPS.md`, which is why the _Register claimed_ table does not
  account for them.

### Batch A — Token blast radius

**Frontier empty — N-053 settled 18/08/2026, see _Resolved decisions_.** The class is **not**
called closed, on its own record: it has produced a member on three separate occasions after
being declared shut. What is different this time is that both populations were **re-swept after
the fix** rather than argued from the node table — 73 files carry `<%`, none in an executable
shell word, and all three CI wait loops end `exit 1`.

**N-053 verdict — the node was right about the repository and wrong about its own remedy, and
the remedy was the part nobody would have re-measured.** Every charted premise reproduced at
HEAD two days after it was written, including `LOOP_EXIT=0` by execution. Three of the node's
own claims did not survive.

- **The stated fix would have failed open, which is the class it was convened to close.** The
  node prescribed `pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"`, _"reading the container's
  own environment exactly as `docker-compose.test.yml:28` already does"_. It does not: a
  workflow `run:` block is expanded by the **runner**, and `test-api.yml`'s `env:` at `:35-43`
  sets five variables, none of them `POSTGRES_*`. Proven with an argv stub — the probe receives
  `[-U] [] [-d] []`. Compose's `$$` and a `run:` block are two escaping regimes and the node
  collapsed them into one. The working form is `exec -T db sh -c '…'` with single quotes.
  **A remedy written into a node is a claim, not a conclusion** — the standing lesson had never
  been pointed at a node's own _Became_ half before.
- **It walked past a member inside the block it cited as the correct form.**
  `test-e2e.yml:88-96` was held up for ending `exit 1`; its probe at `:89` was the same
  uncorrected `/control/` residue the node charts at `test-api.yml:100`.
  `docker-compose.dev.yml:58-62` documents the move to `/health/` in terms. **The node read the
  sibling for the half it wanted and not for the half it was charting** — N-054's shape exactly,
  one file further out.
- **Both `test-api.yml` loops were unfailable, not one.** `:84-89` has no failure path either,
  so the charted token fix alone would have converted a Batch A defect into a bare Batch B one
  and closed the node on it.
- **`exec -T` was missing from both and this was conformance, not a decision.** Every
  `docker compose exec` in the repository carries it — 18 sites across `.claude/hooks/lib/`,
  `code/src/scripts/tests/`, `audits/security.sh` and `syntax/` — and these two were the only
  ones without.
- **The residue's own correction was off by one.** The node taught `lefthook.yml:142` and
  `audit-template.yml:13` that seventeen and four are different quantities. Seventeen is right
  (`git rev-list --count main..c6cea78`); **four is not**. `8050ac7` introduced the break and
  `21d77d7` fixed it, so the commits that carried it are `8050ac7`, `a358791`, `b404307`,
  `0e62bdc`, `47bafb1` — **five**, and `21d77d7` is the fix rather than a carrier. Both files
  now name both quantities and say what each measures. **Third instance of the habit this map
  named as _carry the command, not the number_, and the first inside a correction of somebody
  else's number.**
- **The `--health-cmd` overclaim was refuted by measurement, and it was stated twice.**
  `check-template-parsers.sh` claimed the probe catches the class _"by definition, including
  `--health-cmd`"_, and its cost table called the compose probe _"the shell-word case"_. A
  synthetic compose file carrying the token inside a `CMD-SHELL` healthcheck passes
  `docker compose config` at **exit 0**, run here rather than inherited. Both lines now state
  the boundary and route the shell-word row to `TEMPLATE-TOKENS.md`, whose remedy is doctrine
  because no parse-success probe can ever reach it. The node's anchor for the first was `:34-37`;
  it is **`:33-36`**, drifted in under two days.
- **Proven in both directions against a real container, not argued.** The test stack's `db`
  service was brought up under a scratch project name: the new form returns
  `accepting connections` at exit 0 while the old token form returns
  `no such file or directory: %PROJECT_SLUG%`. The new loop shape was then driven twice —
  unreachable service → **exit 1**, healthy service → **exit 0**. Worth keeping: in this tree
  `POSTGRES_USER` is literally `<%PROJECT_SLUG%>` and Postgres created that role happily, which
  is why asking the container what its own user is, is correct in the template **and** downstream.
- **Gates green:** all six lefthook pre-commit legs (prettier, template-integrity with three
  self-tests, sync-trees, code-review-graph), `check-template-tokens.sh` at 2025 tokens,
  `check-template-parsers.sh --self-test`, and `doc-references.sh`, `seam-contract.sh` and
  `conflict-markers.sh` run individually.
- **Honest limit, and one house rule bent to get it.** The behavioural proof used a direct
  `docker compose` invocation rather than a `code/src/scripts/**` wrapper, because no script
  drives a single service for a probe and `tests/api.sh` would have run the whole suite. Named
  here rather than left implicit. The CI steps themselves remain **unexercised** — the last ten
  `test-api` runs all finished in 7-32s with `steps.detect` false, the newest on 15/08, before
  `b20167b` committed the lock. **The first real run of these loops will be their first ever.**

**Closure was proposed on 16/08/2026 and refused — by a member, not by history.** The criterion was
established rather than assumed: **Batch C closed on node settlement**, not on generalisation. Its
closure statement justifies itself purely by node disposition, and the _"one of five folders on the
same override"_ reading appears only in the taxonomy entry under _Fog of war_, written two days
later and hedged (_"generalised too, though less sharply"_). That is a low bar, and it is the bar
Sam asked for — **and Batch A fails it, because its frontier is not empty.**

**N-053 — the class's third confirmed member, and the first that was live while the batch was being
declared empty.** `.github/workflows/test-api.yml:86` reads
`pg_isready -U <%PROJECT_SLUG%> -d <%PROJECT_SLUG%>_test && break`, inside a `run: |` block.

- **The shell semantics were measured, not argued.** Driving the real loop returns three
  `%PROJECT_SLUG%: No such file or directory` and `LOOP_EXIT=0` — `<` and `>` are redirects, the
  `&& break` never fires, and the step **passes having verified nothing** — but the job does not
  stay green, and naming that precisely is the point. Nothing between `:103` and `:109` can fail,
  so the first step that can go red is **`Run Bruno API tests` (`:109-128`)**. A database that
  never came up is therefore reported **120 seconds later as a Bruno suite failure**: what the two
  loops buy is wasted time and **a misattributed failure**, which is worse than a red step because
  it sends the reader to the wrong file. It is a Batch A token defect and a Batch B false green in
  the same line.
- **The class has a second, token-free member in the same file, and fixing `:86` leaves it
  standing — added 16/08/2026.** `test-api.yml:98-103` is the identical unfailable
  `for … && break … done` with no trailing `exit 1` and **no `<%` in it** — so it is a Batch B
  false green with no Batch A defect underneath, which makes this node's own title narrower than
  what it holds. Its probe is `curl -sf http://localhost:8000/control/`, **uncorrected N-035
  residue in CI**: `docker-compose.test.yml:57` was moved to `/health/` and the workflows were
  never swept. The correct form is one file away — `test-e2e.yml:88-96` runs the same shape and
  ends `exit 1`.
- **It went live at `b20167b` (16/08/2026, 15:14)**, seven hours after N-032's fix. The step is
  gated `if: steps.detect.outputs.present == 'true'` on `[ -f uv.lock ]`, so committing the lock
  flipped it from skip to run. **This map predicted the activation** — _"committing a `uv.lock`
  flips `test.yml`, `test-api.yml` and `test-e2e.yml` from skip to run automatically"_ — and nobody
  swept for it.
- **The repository had already written the diagnosis next door.**
  `code/src/docker/docker-compose.test.yml:22-26` says in terms that a token interpolated there is
  _"a shell redirection, not a name"_, while the identical construct ran in CI two directories away.
  **A comment is not a gate.**
- **The population is closed, which is what the closure actually needed.** Swept 16/08/2026: **74
  tracked non-markdown files carry `<%`, and exactly one occupies an executable shell word. There is
  no third member.** Reached independently by two agents over two different populations. The fix is
  `pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"`, reading the container's own environment
  exactly as `docker-compose.test.yml:28` already does. **Named honestly, 16/08/2026: that sweep
  enumerated _token_ sites, not _unfailable loop_ sites.** The second population has now been
  enumerated too and is also closed — three CI wait loops (`test-api.yml:84-89`, `:98-103`,
  `test-e2e.yml:88-96`), of which two cannot fail and both are in this one file. **A frontier is
  only empty when a search that could have found a member came back empty**, and the first search
  could not have found `:98-103`.

**Three of the day's repair commits walked past it.** `33926e9` edited `test-api.yml` at `:46-64`
and reported 1,996 well-formed tokens — the defect is at `:86` and **is** well-formed, so a shape
check cannot see it. `47e84cf` wrote the diagnosis into the compose file two hours earlier. And the
gate named for this class never reads `.github/workflows/` at all.

**Residue — two shipped gate headers overclaim, and both corrections are cheap.**

- `.github/scripts/check-template-parsers.sh:34-37` claims it catches the class _"by definition,
  including … `--health-cmd`"_. **False by measurement** — a synthetic compose file carrying the
  token inside a `CMD-SHELL` healthcheck passes `docker compose config` with exit 0 — and false **in
  principle**, because `how-to/src/TEMPLATE-TOKENS.md:349-352` states that a shell word's delimiters
  are legal and active, so a probe whose test is parse-success can never fire there.
- `lefthook.yml:142` and `.github/workflows/audit-template.yml:13` say N-032 _"rode seventeen
  commits undetected"_. **Both numbers are real and they are different quantities**: the branch
  carried seventeen commits with no PR (`git rev-list --count main..c6cea78` = 17), while the defect
  rode **four** (`8050ac7..21d77d7`). The headers name the ride and print the branch.

**What did improve, and it is why this is a new member rather than a repeat.** N-033's pre-commit
leg closed the window N-032 escaped through: `check-template-tokens.sh` scans `git ls-files` **plus**
`--others --exclude-standard` on every commit in 2.38s, so an N-032-shaped member is now caught at
the commit that introduces it — earlier than any gate Batch C ever had. **The class stays open**: it
has produced a member on three separate occasions after being declared closed, so treat "Batch A is
closed" as a statement about the frontier and never about the repository.

### Batch B — False green

| Node  | Decision                                                                                                                      | Type | Blocked by | Blocking a story? |
| ----- | ----------------------------------------------------------------------------------------------------------------------------- | ---- | ---------- | ----------------- |
| N-060 | **New.** Nothing reads `copier.yml`'s `_exclude` and compares it against citations, so Direction B is declared and unenforced | task | none       | no                |

**N-056 and N-058 settled 22/08/2026, sitting 5 — see _Resolved decisions_.** Both were re-measured
before a question was asked and **both lost claims to it**: five of N-056's charted members had
been repaired by the N-046/N-055 settlement or were never true, and N-058's central defect turned
out to be narrower and sharper than charted. The batch leaves **N-060 alone in Batch B**.

**N-052 settled 21/08/2026 — see _Resolved decisions_.** It is this map's second
**measured-and-refused** node, and the measurement is the artefact rather than any code change.

**N-060 is charted out of N-031's settlement, and `FORWARD-VOICE.md` Section 5 had already
charted it in prose.** That section states the gap in terms — _"Nothing reads `copier.yml`'s
`_exclude` list and compares it against citations, so an excluded path cited **without** the
token is green today… the automatic half is charted, not built"_ — and no node existed. N-031
carried it implicitly and no longer does.

- **Batch B by its own definition:** a green `doc-references.sh` run means _"no path is missing
  here"_, never _"every citation survives generation"_, and the script's output does not say so.
- **Typed `task`, not `grilling`, and the reason is that N-031 already took the decision.** Which
  citations are the deliberate-dangle class was the undecided half; it is settled, and the 12
  marked sites are the worked answer a gate would assert against.
- **The rule is true before the instrument ships, which is N-025's warning honoured rather than
  re-learnt.** The marker had **zero adoption** on 21/08 — every occurrence was the rule, the
  implementation or an index — so a gate built first would have reddened on 12 correct sites.

**N-010 settled 16/08/2026 — see _Resolved decisions_.** Its charted premise was **dead on
arrival**: `04`/`05` "need generation" rested solely on the absent `uv.lock`, which N-035
committed the same day, and every one of the five workflows ran here. **Nine defects, seven of
them commands that do not exist or cannot work** — found by executing what three sittings of
review had passed. The batch keeps its name: the sharpest of them made the pre-PR gate **exit 0
having run nothing**.

**N-046 came out of N-010's own execution, and it is the batch's thesis at a smaller scale.**
Three scripts each report something other than what happened:

- **`syntax/format.sh` bare is a dry-run** that prints "All files are correctly formatted", which
  workflow `06` read as "the tree was rewritten" for as long as it has existed. The script is
  right and the reader is wrong, which is the definition of a misleading report.
  **Re-measured 18/08/2026: the cited specimen is dead and the mechanism is not — and the
  surviving member is worse than the one that died.** `06-quality-gates/STEPS.md` was corrected at
  `f4a988b` (16/08, 17:46) and reads right at `:39-41`. But `f4a988b` touched five files and
  **`.claude/skills/review/SKILL.md` was not one of them**: `:21` states _"**This skill writes.**
  Its pre-flight runs `format.sh`, which rewrites source."_, its pre-flight at `:28-31` invokes
  `format.sh` **bare**, and its definition of done at `:62` consumes the false inference. That is
  the identical falsehood in a stronger form, **in a skill an agent executes**. The file has one
  commit in its history (`bcb1efb`, 12/08/2026) and has never been edited, so it has been false
  for as long as it has existed — the same phrase this node applies to workflow `06`. The map has
  no hit for it. Secondary: `f4a988b`'s body and `VERSION-HISTORY.md:13` both frame those five
  documents as _"correct when written and falsified by a change elsewhere"_, which is false for
  this member — it was wrong on the day it was authored.
- ~~**`development/sync-trees.sh --path <dir>` reports "Every CONTEXT.md tree matches its
  directory"** for a directory the unscoped run reports as drifted.~~ **Specimen dead — the block
  was repaired at `ec8e807` (16/08, 17:42), four hours before this node was written.** The
  mechanism may well survive; it now **needs a new specimen** before it can be scheduled.
- **`syntax/lint.sh --path <file>` does not scope markdownlint — re-measured and confirmed
  16/08/2026, and the contest was answered by the tool rather than the script.** The contest was
  right about `lint.sh` and wrong about the cause: `:259-266` genuinely scopes `md_pattern` to
  `--path` and has since `ee5c2bb` (01/08/2026), and `:267` passes it as the sole glob.
  **Re-anchored 18/08/2026** — these read `:198-205` and `:206` until `b4ed0b9` rewrote the file;
  the blocks are byte-identical and moved +61.
  **`markdownlint-cli2` then appends the `globs` array from `.markdownlint-cli2.jsonc:2-21` to
  whatever the CLI gave it**, so the path narrows nothing. Observed: a run scoped to
  `how-to/docs/HEALTH-PROBES.md` printed the full glob array after the path and **`Linting: 793
files`**, then reported its only four findings in `MAP-BASE-HEALTH.md` — a file it was not given.
  Unchanged since `13de9b9` (02/08/2026). **The remedy is named by the tool's own `--help`** —
  `--no-globs`, absent from `lint.sh` — **and it is not free**: it discards all 16 negations in
  `globs`, and `ignores` at `:26-31` re-covers only 4, so a directory-scoped run under
  `--no-globs` would start linting `node_modules/`, `.venv/` and `.claude/**`. Preserving the
  exclusion set is a design choice, which is what keeps this bullet honestly `task` only at the
  report layer.
- Lesser, same class: `dependencies/update.sh` prints "package.json and pnpm-lock.yaml updated"
  when only the lockfile moved. **Re-measured untouched at HEAD, as is the `lint.sh` bullet above.**

**The node held its size: three misreporting scripts are two confirmed and one dead specimen —
corrected 16/08/2026.** The one struck bullet died the way the batch is named for: true when
written, repaired **four hours before the node was charted**. The other survived a contest that
was itself under-measured — it challenged the script and never ran the tool, which is this map's
standing lesson landing on a **challenge** rather than on a claim. That is not an argument against
the node; it is the argument for **re-measuring a script's output rather than citing the last
session that ran it**.

**A replacement specimen arrives from N-056, and it belongs here by class and by type.**
`copy-emdash.sh:106`'s `[[ -e "$TARGET_PATH" ]] || die` sits inside `collect_files()`, invoked in
a process substitution at `:128`, so `die`'s `exit 2` kills the **subshell** and the script prints
its error to stderr then `✓ No em dashes in marketing copy.` at **exit 0**. ~~Three siblings carry
the identical guard outside a subshell and exit `2` (`css-gradients.sh:101`, `css-tokens.sh:107`,
`copy-slop.sh:233`).~~ That is _a scope it did not honour_ — the live specimen the struck
`sync-trees.sh` bullet asked for. **But the count was wrong in both directions, corrected
18/08/2026 by running every script in `audits/` rather than grepping the guard string.**

- **Eight** siblings carry the correct form, not three — add `negative-space.sh:521`,
  `render-slop.sh:189`, `template-slop.sh:206`, `css-slop.sh:200`, `static-analysis.sh:306`.
- **And it is not a one-script defect. Four** scripts put the guard inside a function invoked from
  `done < <(func)`, so `die`'s `exit 2` kills only the subshell and each prints a success line at
  exit 0 over a `--path` it never honoured: `copy-emdash.sh:106`/`:128`;
  `seam-contract.sh:115`/`:178`; `conflict-markers.sh:201`/`:215`, which prints
  `scanned 0 text file(s)` and then `✓ No unresolved conflict markers in 0 text file(s)`; and
  `skill-conformance.sh:237`/`:510`, whose success line **names the default scope while the
  operator asked for another path**.
- **Why a grep could not have closed this, which is the standing lesson landing again.**
  `skill-conformance.sh`'s guard reads `$t`, not `$TARGET_PATH`, so a search on the guard string
  misses it; only executing each script closes the population. A fix scoped to `copy-emdash.sh`
  alone leaves **three identical live defects**, and none of the three is charted for this defect
  anywhere on this map.

**Typed `task`: nothing is undecided** — each is a report that should describe the action taken.
**But see N-055 and the collision table**: N-055 works the same two files, and the `lint.sh` line
ranges nest, so neither node's fix may edit the shared success string without the other's evidence
in view.

**N-042 — the gate's verdict is a property of the developer's disk, and the line it trips over
says so about a different script.** Measured 16/08/2026 in a `git archive HEAD` scratch clone with
`git init`, which is what a CI checkout looks like:

- **Exit 1 on a fresh checkout, exit 0 once the file exists.** `.github/scripts/shipped-readme.sh:141`
  cites `code/docs/MACHINE-SPEC.md` in a comment. `install.sh` writes that file (`install.sh:25`,
  `:518`) and `.gitignore:43` ignores it, so it is present on any machine that has run the
  installer and absent from every clone. Creating it in the scratch clone flips the same run to
  exit 0 — proven in both directions, one variable.
- **The local gate and CI disagree, and the local one is the reassuring half.**
  `.claude/hooks/lib/check-audits.sh:43` globs `"$audit_dir"/*.sh`, so the pre-PR gate runs this
  audit and passes here; `.github/workflows/audit-doc-references.yml:34-37` runs it after a bare
  `actions/checkout@v7` and would fail on any PR to `[main, staging, dev, testing]`.
- **The cited comment is the joke at the gate's expense.** `shipped-readme.sh:135-144` exists to
  explain this exact hazard — _"a machine that had run install.sh failed an audit a fresh clone
  passed. Whether the audit is red became a property of the developer's disk rather than of the
  repository"_ — and closes it for itself with `is_generated`. `doc-references.sh` has no such
  exemption: `grep -n 'is_generated|generated|gitignor' code/src/scripts/audits/doc-references.sh`
  returns only prose about copier-seeded paths.
- **The direction is the inverse of the comment's, which is why nobody caught it.** The comment
  warns that a developer's disk makes an audit **red**; here it makes it **green**, and the failure
  is deferred to whoever opens the PR.
- **It blocks N-031 in practice, and "in practice" was an understatement — measured 16/08/2026.**
  `Citations resolve` (`audit-doc-references.yml:31`) is one of the **20 required contexts on
  ruleset `20221742`** (`main — protected`, `enforcement: active`, target `~DEFAULT_BRANCH` =
  `main`), so an N-031 pull request into `main` is not merely red, it is **unmergeable**. Two
  honest bounds: the ruleset targets the default branch only, so a PR into `staging`, `dev` or
  `testing` runs the job (`:26`) without a gate; and `bypass_actors` grants `RepositoryRole`
  actor_id 5 `bypass_mode: always`, so an admin merge never waits. **The shipped file says the
  opposite** — `audit-doc-references.yml:19` reads _"and it is not a required status check"_, which
  is false at HEAD and rides with this node's own fix. Typed `task`: nothing is undecided —
  `is_generated` already implements the rule, one directory away.
- **Blast radius measured 16/08/2026: exactly one site.** `.github/scripts/shipped-readme.sh:141`
  is the sole survivor over the gate's **full 1,007-file candidate set**. Traced end to end: it is
  backticked (the only form `doc-references.sh:256` can see), tracked, matched by `candidates()` at
  `:80-82`, absent from `is_exempt` at `:85-94`, carries no `doc-references: ignore`, survives
  `is_pattern`, is slash-bearing, and is in scope at `code/docs/*` — **only `[ -e "$resolved" ]` at
  `:252` keeps it green on this disk.** `git check-ignore -v` puts the file at `.gitignore:43`;
  `install.sh:518` writes it. Nothing else in the repository cites a present-but-untracked path.
- **A kill attempt was made on this node during the 16/08 challenge pass and it failed.** N-031's
  challenge declared the practical half _"dead at HEAD"_ from a `git grep` carrying an inherited
  `.github/scripts/` pathspec exclusion; unrestricted, the same search returns **12 hits across 6
  files**. Recorded because the instruction is reusable and the fact is not: **a `git grep`
  inherited from another measurement carries that measurement's pathspec, and an absence produced
  by a filter is not an absence.**
- **One honest limit, stated rather than implied.** The redness on a fresh checkout was derived
  line-by-line from the script's control flow this time, **not observed** — the pass was read-only
  and the audits write report files. The scratch-clone reproduction above remains the observed one.

**Sitting 1 closed 16/08/2026 — N-033, N-029 and N-038 (the last inherited from Batch E).** See
_Resolved decisions_. **N-010 is unblocked**: N-032 was its only blocker and it fell the same day.
The remaining four were re-verified against the tree before the sitting opened and all four still
hold — N-030 gained a second blind selector (`routing-skills.sh:216` as well as `:128`), and
`x-for` is absent from **every** rule in `audits/rules/`, not only line 22.

**Sitting 2 closed 16/08/2026 — N-030, N-034 and N-041**, the last folded in from no sitting at all because it is the same shape as the other two: the rule already settled, the pattern not implementing it. **Sitting 3 closed 16/08/2026 on N-035, leaving N-010 as Batch B's last node.** N-041's work is proven and its commit is held behind a repository-wide sweep that owns the same file. **Sitting 2 opened and N-030 fell at `0c22b79`** — see _Resolved decisions_. **The row above was
written up by the N-028 session, not the one that did the work**, so every claim in the verdict
was re-measured here rather than taken from the commit message; that is the standing lesson
applied to a sibling session instead of a sibling map. **N-034 and N-041 are still open** and were
sitting 2's other charted members.

**N-041 came out of the adversarial pass on N-038's own gate, which is the class reproducing under
its own repair.** `shipped-readme.sh` checks 4 and 5 use a bare `grep -qF` scoped to a section,
while checks 1/2/3/10/11/12 use `in_tree`'s row-boundary rule. Proven: delete the
`` `conflict-markers.sh` `` **table row** and replace it with the sentence _"The
`conflict-markers.sh` script is mentioned here in prose only"_ → **exit 0**. The register is gone
and the gate is green. The script's own header reasons about this hazard for check 5 and solves
half of it: backticks distinguish a name from prose, but nothing distinguishes a row from a
sentence. **Typed `task` — nothing is undecided, `in_tree` already implements the rule the other
two checks need.**

**N-034 was routed here by `MAP-ABSENCE` and re-verified on 16/08/2026.**
`code/src/scripts/audits/rules/django-template-xss.yml:22` matches a Django variable interpolated
into an Alpine expression. Its alternation lists `x-data`, `x-init`, `x-html`, `x-model`,
`x-effect`, `x-text`, `x-show`, `x-if`, `x-on:`, `x-bind:`, `@…` and `:…` — **and not `x-for`**.
`x-for` takes a JavaScript expression exactly as the others do, so `x-for="item in {{ items }}"`
is the identical injection and the rule reports clean. **Typed `task`: nothing is undecided, the
rule already means to cover the attribute and the regex does not implement it** — the same shape as
N-030, one directory away. Worth checking the sibling rules for the same omission while it is open;
a hand-written alternation of a framework's attribute surface is a list that goes stale by design.

**N-035 is the node the 15/08 session's Out-of-scope section prescribed, and it is charted here as
that section asked.** Both standing limitations in `TEMPLATE-GAPS.md` are **factually false**, and
`TEMPLATE-GAPS.md` **ships** — so the false text is the tracked, inherited half of a correction this
untracked map has already made to itself.

- **Measured 16/08/2026, and the numbers are the argument.** `uv lock --dry-run` → _Resolved 119
  packages in 8ms_, exit 0. `uv export` succeeds and prints `# via syntek-base`, which is the house
  constant doing its job. SL-2's whole _"what still does not run here"_ table — `basedpyright`,
  `pip-audit`, anything calling `uv run` — is wrong on all three rows, and it still cites line 2 of
  `pyproject.toml` as `name = "<%PROJECT_SLUG%>"` when line 18 reads `name = "syntek-base"`.
- **SL-1 still contains the exact sentence the map corrected on 15/08** — _"nothing on
  `MAP-BASE-HEALTH.md` touches it — `N-001` is about the manifest's package name, which is a
  different root cause"_. N-001 was its sole cause. The untracked side is right and the tracked side
  is wrong, which is Batch D wearing a standing limit's clothes.
- **The real question is not the text, and that is why this is `grilling`.** A `uv.lock` exists
  locally (299 KB, untracked) and committing it flips `test.yml`, `test-api.yml`, `test-e2e.yml` and
  `claude.yml`'s `[7/8] Tests` from skip to run **automatically**, because they test for the lock's
  presence. Those suites have never executed. Whether they pass is unknown, and finding out by
  merging is the wrong order. The Django image also builds `COPY pyproject.toml uv.lock ./` with
  `uv sync --frozen`, so a committed lock changes what Docker does here too.
- **Sequencing, unchanged from 15/08:** SL-1 and SL-2 are charted and settled **together**. Fixing
  one alone leaves a false, tracked, uncharted standing limitation behind it.
- **Blocked in practice by N-032, not on paper.** The verification route SL-1 itself names is
  "generate a project and run the suites there", which is unavailable while generation is broken.

**N-035 verdict — settled 16/08/2026 in seven commits, and the first inherited claim set on this
map that survived re-measurement whole.** The row was written by the **N-036 session, not the one
that did the work**: the Batch B session landed the commits, pushed, wrote a handoff and moved to
its PR without moving the row, so the map showed a settled node as open while anyone reading the
frontier would have taken it as available work. Re-measured at `bde5cc6` rather than transcribed —
**nothing was refuted**, against a standing lesson that had found four of eight wrong twice running.

- **The charted question was answered in the order the node insisted on.** N-035's whole reason for
  being `grilling` was that committing the lock flips four suites from skip to run **automatically**,
  and _"whether they pass is unknown, and finding out by merging is the wrong order"_. They were run
  first. Reproduced here independently: `backend-coverage.sh` → **100% over 162 statements, 22
  passed**, the 75% floor reached; `basedpyright` → **0 errors, 0 warnings, 0 notes**; `pip-audit` →
  **no known vulnerabilities**; the dev stack up with all four containers healthy and `/health/` →
  `200 ok`, `/health/ready/` → `{"status": "operational"}`.
- **SL-1 and SL-2 were settled together, as the sequencing demanded.** SL-2 is **deleted outright**
  — zero occurrences remain — and SL-1 is **rewritten rather than corrected**, replacing two false
  limitations with the one that is true and permanent: a green suite here exercises the harness and
  the two shipped apps, and says nothing about a generated project's features. Fixing one alone
  would have left a false, tracked, uncharted limitation behind it, which is exactly what the
  charting warned of.
- **The node grew a build and an app it was not charted for, and both were right.** `apps.health`
  did not exist, yet **every production container had always probed `/health/`** — the compose
  healthchecks were pointed at `/control/`, Django's admin, to paper over it. A node convened about
  a lockfile found a probe with no subject, which is the same defect class as N-036's: the
  configuration was corrected once and the thing it depended on was never built.
- **The residue is honest and worth keeping.** The 75% floor has now been **watched firing**; the
  **90% auth floor still has not**, and cannot until `apps/users/` exists — `backend-coverage.sh`
  reports it skipped and states the floor applies from the moment that app is created. N-028's
  concern was that _"no threshold has been watched firing"_; half of that is now discharged and the
  half that is not says so out loud rather than reporting a green.
- **It also created one instance of the class N-036 was clearing** — `syntax-python.yml`'s body
  called `--frozen` _"an impossible [assertion] in the template, which commits no lock"_, written by
  the commit that committed the lock. Cleared in `33926e9`. A node that changes a fact corrects most
  of the prose it passes and occasionally writes a new false one; that is an argument for the sweep
  following the change rather than preceding it, which is how these two were sequenced.

**N-030 settled 16/08/2026** — see _Resolved decisions_.

**N-052 — the gate that polices citations cannot see the kind of citation N-044 leaves behind.**
Charted 16/08/2026 out of the challenge pass, and it is the reason N-044's residue has no
enforcement. `code/src/scripts/audits/doc-references.sh:183-186` — Check 1 reads
`case "$token" in */*) ;; *) continue ;;` with the comment _"only tokens that look like a path"_.
**A token with no slash is skipped.**

- **The blast radius is measured, not estimated.** All five `health-check.sh` sites and **15 of 16**
  `health.sh` references are invisible to the only gate that would police them. Proven by mutation
  in a throwaway `git archive HEAD` clone in both directions: a bare `zzz-nonexistent.sh` added to
  `deployment/CONTEXT.md` is **not** flagged, while the path form on the very next line is; a
  `git mv` of `health.sh` produces exactly **one** violation out of 17 tracked references.
- **This is Batch B in its charted sense** — the gate reports _"Clean — every citation resolves"_
  having declined to look at a whole citation shape. It is a sibling of the same script's other
  blind spot already charted as **N-042**, and of the finding the map **refused** on 16/08 (the
  `code/src/django/` skip, which is a rationale written into the script). **The three must be told
  apart when this is taken**: `:238-241` is a documented boundary, `:183-186` is an undocumented
  side-effect of a heuristic, and N-042 is a generated-file exemption that was never written.
- **Typed `grilling`, not `task`, and the reason is N-025's standing warning.** The fix looks like
  one line, but widening the token filter makes every prose mention of a script name a citation —
  and this repository has never measured how many of those exist or how many would resolve. **The
  rule has to be true before the instrument ships**, which is the lesson `docs-pairing.sh` learnt
  at 95 red directories and `skill-conformance.sh` clause 14 learnt at 24 findings. Measure the
  population first; the node is the decision about what counts as a citable name, not the regex.
- **Do not settle it before N-044.** N-044's remedy is that whoever writes
  `deployment/health-check.sh` writes it under that name; this node decides whether anything ever
  checks that they did.

**N-055 — the class N-046 keeps gesturing at and never names.** Not a script that mis-describes
what it did: a gate that did **nothing** and files a clean report. Re-measured at `a9c56a1` on
16/08/2026; all four members reproduce, and the two the challenge pass rated highest are the two
weakest.

- **The syntax pair is the purest instance, and the persisted artefact is worse than the
  terminal.** With `pnpm` off `PATH`, `format.sh --file-type markdown` prints
  `⚠ pnpm not found on host — skipping Prettier`, then `✓ All files are correctly formatted.`, and
  exits **0**; `lint.sh` is the same shape (`format.sh:284-299`, `:412-413`, `:422` ·
  `lint.sh:256-276`, `:417-418`, `:425`). `OVERALL_EXIT` is only ever touched **inside** the branch
  that ran (`:293` / `:270`). **New, and found by neither leg of the pass:** `log()` at
  `format.sh:46` writes to stdout and never to `$TMPFILE`, which `:321` reads to build every report
  — so `--output json --quiet` yields `{"exit_code": 0, "output": ""}` over zero files examined,
  with **no notice in either channel**.
  **Every anchor in this bullet was re-resolved 18/08/2026** — they read `format.sh:232-247`,
  `:348-349`, `:358`, `:241`, `:35`, `:257` and `lint.sh:195-215`, `:312-313`, `:320`, `:209` until
  `b4ed0b9` rewrote all three scripts. Each was exact at `a9c56a1`, verified in both directions
  against `git show c006ff5:<path>`; **the offset is not uniform** (the Prettier leg moved +52, the
  tail +64), so no anchor here may be recovered by adding a constant.
  **And the bullet under-counts `lint.sh` now: there are TWO skip sites, not one.** `b4ed0b9`
  added a `javascript` leg with the identical shape — `:289` `if host_has_pnpm; then` / `:297`
  `⚠ … skipping JavaScript lint`, with its `OVERALL_EXIT=1` at `:294` inside the ran-branch.
  **This map's own remedy produced a new member of the node it was measured beside.**
  Two directions confirmed by an A/B control on a deliberately mis-formatted file outside the
  repo: **pnpm present → exit 1 `✗ Formatting issues found.`; pnpm absent → exit 0 with the
  success line.** The green is false, not coincidentally true. A further shape nobody had named:
  **`--fix` prints the same success string when nothing ran**, because the `⚡ Formatting applied.`
  branch at `format.sh:414-415` is an `elif` under `OVERALL_EXIT -eq 0` and is unreachable
  whenever the only lane was skipped. And the reach is wider than "a host without Node":
  `package.json:5` pins `"packageManager": "pnpm@11.22.0"`, so a **corepack-only** host hits the
  skip branch even though `corepack pnpm` works.
- **The member live on this machine is `check-typecheck.sh`, and ~~it is the only guard of its
  kind in the directory~~ it is the only one of the directory's three skip sites that fires
  here.** `basedpyright` is not on this host's `PATH`; `:14-19`'s `else` leaves
  `local_exit` at its `:10` initialiser, `:27` hands that `0` to `_dual_result`,
  `pre-pr-check.sh:297-298` reads `0 && 0` as a pass, and `:29-30` writes
  **`No type errors (Python local ✓ Docker ✓)`**.
  **Corrected 18/08/2026 — "only guard of its kind" confused a search with a population.**
  `check-typecheck.sh:14`'s `command -v basedpyright` is the directory's only **PATH-lookup**
  guard (`grep -rn "command -v" .claude/hooks/lib/` — one hit across nine files, both numbers
  re-confirmed), but not its only skip-and-pass guard: `check-lockfiles.sh:78`
  (`if [[ -n "$venv_dir" ]]`) and `:139` (`if [[ -d "$PROJECT_ROOT/node_modules" ]]`) are the
  same mechanism in **file-test** form. `:134` and `:149` print `skipping`, neither `else` touches
  `exit_code`, and `:153-155` then prints `Python + JS packages match lockfiles (local ✓
container ✓)`. The three skips are live in **different conditions, not different kinds** — here
  the root `.venv` and `node_modules` both exist and `basedpyright` does not.
  `check-format.sh:14-15` and `check-lint.sh:16-17` run the raw tool unguarded and fail closed;
  **`check-tests.sh:108-109` already carries the tri-state** (`auth unmeasurable` → red), so the
  honest form is **one** file away, not two.
- **A fifth member, outside `hooks/lib/` and outside every census this node has run.**
  `.claude/hooks/context-threshold-handoff.sh:25` — `command -v jq >/dev/null 2>&1 || exit 0`, the
  only other `command -v` in the hooks tree. With `jq` absent the hook exits 0 having measured
  nothing, and the 50%/75% thresholds `.claude/CLAUDE.md` Section 2.6 calls **"measured not
  guessed"** go unmeasured, with no notice in either channel. **The class is five gates, not
  four**, and the header count above is stale by one.
- **A sixth, and it is the one that needs no absent prerequisite at all.** `lint.sh:278-282`'s
  `if wants css` prints `ℹ CSS linting is not configured.`, never touches `OVERALL_EXIT`, and
  falls through to `✓ No lint issues found.` at exit 0. It predates `b4ed0b9` (`c006ff5:217-219`,
  so live at the charting commit `a9c56a1`) and appears in **neither** this node nor N-046 —
  found 18/08/2026 by the completeness critic, not by any finder.
- **It breaks a rule written one directory up, about the tool that rule names.**
  `.claude/hooks/CLAUDE.md:23-27` calls the dual-check design deliberate, lists **`basedpyright`**
  among the host-side raw tools, and states its purpose as catching host/container drift. A guard
  that skips the host leg disables the comparison the file exists to make.
- **The silent failure has a loud sibling nobody named.** Host leg skipped, Docker genuinely red:
  `pre-pr-check.sh:299-301` prints **`MISMATCH: passed locally, failed in Docker`**, and
  `check-typecheck.sh:31`'s `elif [[ -z … ]]` cannot overwrite it. The gate asserts a host result
  that was never produced and sends diagnosis after drift that does not exist. That is the false
  green inverted, and it is worse than the green.
- **The verifier's correction on `check-lockfiles` is upheld, and its scenario is the finding
  text.** The fresh-clone framing is **refuted**: `:13-24` sets `exit_code=1` on each of three
  failed `_dc exec` calls, so no container means a red check. The residue is real — `:133-135` and
  `:148-150` skip without touching `exit_code`, under `:153-155`'s `local ✓ container ✓`.
  **Reachability measured rather than asserted**: `command -v ruff` resolves outside the repo
  `.venv`, so container-up with no `.venv` leaves the format check green while the lockfiles
  summary claims a host check that never ran.
- **The blast-radius dispute resolves both ways, and the half that refutes the challenger convicts
  a doctrine line.** Nothing automated invokes `syntax/format.sh` or `syntax/lint.sh` — seven hits
  across `.github/`, `.claude/hooks/` and `lefthook.yml`, every one an advice string or the human
  checkbox at `PULL_REQUEST_TEMPLATE.md:50-51`. So `medium` is right **there**. But
  `syntax/CLAUDE.md:56` justifies the exit-code contract with **"CI depends on it"**, and that is
  false at HEAD by the same grep (`:41` until `b4ed0b9`): the rule survives on its merits and loses its stated reason,
  which is the N-036 shape exactly. **The downgrade must not generalise** —
  `.claude/settings.json:132-141` registers `pre-pr-check.sh` as a `PreToolUse` hook whose matcher
  at `:134` is `"Bash"`, so it fires on **every** Bash call; the `gh pr create|new` filter is
  `pre-pr-check.sh:35`, and exit `2` blocks. The two hook-lib members sit inside a live blocking
  gate. **The two files were cross-wired at the same line number in this node's own draft**, which
  is the citation-drift class it sits beside.
- **Typed `grilling`, against the candidate's `task`, for the reason that shrank N-046.**
  `syntax/CLAUDE.md:55` publishes three codes — `0` clean, `1` issues, `2` script error — and
  **has no case for "could not look"** (`:40` until `b4ed0b9` moved it +15; the text is
  byte-identical, and the claim survives the rewrite in substance); `_dual_result` takes two integers and has no representation
  for "not run" across the five checks that call it. Both forks cost: failing closed blocks a PR
  from any host without `basedpyright`, **including this one**, and a per-leg tri-state changes
  shared code under five callers. That is a contract decision, not a message edit.
- **Not blocking, on the N-053 and N-042 precedent**: it gates neither a merge nor a story; it
  fails to gate anything, which is the defect. **Not already charted** — N-046's bullets are all
  scripts that _ran_ and mis-described the run, and N-053 is this effect from a token cause.
- **It collides with N-046 on ~~two~~ THREE files, and the ranges nest.** N-046's `lint.sh`
  bullet works `:259-266`; this node cites `lint.sh:256-276` for the skip, and both point at the
  same success string in `format.sh`. **Settle N-046's bullet first or together** — a fix to
  either that edits the success line without the other's evidence in view will look complete and
  close half the class.
  **Widened 18/08/2026 by `b4ed0b9`, which every agent measured and none connected.** `check.sh`
  now shares `log()` at `:46`, `TMPFILE` at `:207`, `RAW=$(<"$TMPFILE")` at `:290`, the `--path`
  drop block at `:180-191`, the `DROPPED_NOTE` print at `:216` and the default narrowing at
  `:171-174` with both collision files. Every finder asked whether `check.sh` is an N-055
  **member**; none asked whether it joins the **collision**. A fix to the shared success string,
  to `log()`, or to the `$TMPFILE` path now moves in three files.
  **And the two nodes' remedies sit in the same `if/else`.** `--no-globs` — N-046's remedy —
  would be added at `lint.sh:267`, inside the `if host_has_pnpm` limb at `:257` whose `else` at
  `:272-275` **is** N-055's member. Nobody has measured what a `--no-globs` edit does to N-055's
  evidence, or the reverse.
  **The control that proves N-046's cause was never run, and it lives in the other collision
  file.** `lint.sh --file-type markdown --path <file>` reports `Linting: 794 files`;
  `format.sh --file-type markdown --path <file>` scopes **correctly**, because
  `prettier_pattern()` (`format.sh:231-260`) hands Prettier the pattern as its sole glob and
  Prettier has no config-side append. That contrast is what shows the fault is
  `markdownlint-cli2`'s appended `globs` rather than the `--path` contract the two scripts share.
- **No self-test would have caught any of it**: `grep -c "self-test"` returns `0` for all four
  files, against the `audits/*.sh` convention that carries one. Population stated rather than
  implied — **three skip sites, two files, nine hook libs**. **That sentence counts the hook libs
  (`check-typecheck.sh:18`, `check-lockfiles.sh:134`, `:149` — three sites in two of nine files),
  not the syntax pair, and it is arithmetically exact at HEAD.** Two agents returned opposite
  verdicts on it on 18/08/2026 for want of a named referent; the referent is written down here so
  the next reader does not have to guess it.

**`b4ed0b9` removed one member of N-055 and added three, and a map that recorded only the
removal would be a map you could not trust.** The commit is the `--file-type` work of 18/08/2026
(see _Session log_); it was not taken against either node, and every item below was found by the
re-measurement pass that followed it rather than by the session that wrote it.

- **Removed, and it is the only subtraction.** `check.sh`'s absent-mobile-surface branch used to
  print `⚠ no code/src/mobile/ — this project has no mobile surface; skipping` and exit `0`. It
  is gone: the type is either auto-added because the directory exists, or explicitly named and
  validated against that directory, so an absent surface now exits `2`.
- **Added (1) — `rust/lint.sh:42-55`, an N-046 member in a file the commit touched.** The
  `--fmt-only` block runs `cargo fmt --all` (`:47`, which **rewrites source**) or
  `cargo fmt --all --check` (`:49`), then **unconditionally** prints `✓ Rust formatting clean.`
  (`:53`) and exits `0` (`:54`). A `--fix` run that rewrites the workspace reports a **state**,
  never the action — N-046's definition. Reached from `format.sh:306-307`. Its pre-existing
  sibling at `:60-69` is the same shape, so the commit **copied an existing defect** rather than
  inventing one, which is the more useful fact about it.
- **Added (2) — a silent surface drop in all three syntax scripts.** `lint.sh:187-192`,
  `format.sh:175-180`, `check.sh:171-174`: a bare run appends `typescript`/`rust` **only if the
  directory exists**, with no `⚠`, no `ℹ` and no report field. On a project generated without
  either surface — the template's normal case — the legs vanish and the script prints `✓`.
  Invisible to every census this node has run, because they all grep `skipping` or `⚠`.
- **Added (3) — the persisted artefact misstates the scope requested, which is worse than
  omitting it.** The `--path` drop at `lint.sh:197-209` sets `DROPPED_NOTE`, printed at `:231`
  through `log()` (`:46`) — stdout only, never `$TMPFILE`, which `:330` reads. So
  `lint.sh --path how-to/docs --output json --quiet` yields
  `"file_types": ["python","markdown","javascript"]` with **no trace of the two dropped types**:
  the report states the post-drop set as though it were the set asked for. Same shape at
  `format.sh:184-196`/`:218`/`:321` and `check.sh:180-191`/`:216`/`:290`. **The notice was written
  specifically so the drop would not be silent, and it is silent in the only channel that
  persists** — which is N-055's own `log()`-versus-`$TMPFILE` bullet reproduced on a feature added
  beside it.

**The standing lesson takes the obvious form and one less obvious one.** A session that touches a
charted node's files owes that node a re-measurement — that is the obvious half, and it is why
these four items exist. The less obvious half: **three of them were found by the completeness
critic, not by any of the five finders or their adversaries.** The finders were each scoped to a
node's existing bullets, and a bullet cannot ask about a member created after it was written. The
critic's question — _what did this pass fail to look at?_ — is the only leg that could have found
them, and it found the CSS lane member above by the same route.

**N-056 — six gates report a clean verdict over a population they never had, and one of them is
the pre-commit hook.** Charted 16/08/2026. Every figure below was executed at HEAD `a9c56a1`, not
read off the pass that proposed it; three of the pass's own supporting claims were wrong and are
corrected here.

- **The sharpest member is the one with no third exit case.** `sync-trees.sh:49-50` documents
  `0 = trees match · 1 = drift · 2 = script error` and nothing else. `:99-101` collects,
  `:103-105` narrows on `--path`, `:106-108` narrows on `--staged`, `:205` loops, `:357-358`
  prints `✓ Every CONTEXT.md tree matches its directory.` and exits 0 — and
  `grep -n "contexts" sync-trees.sh` returns only those six lines, so **there is no emptiness test
  to add a case to**. Measured: `--check --path .github/workflows` (35 tracked files, no
  `CONTEXT.md` among them) is green at exit 0, while the unscoped `--check` exits **1** with three
  real drift findings.
- **Typed `grilling`, and the reason is one line in `lefthook.yml`.** `:75-76` runs
  `sync-trees.sh --write --staged` with `stage_fixed: true`, and the file carries a single hook
  block — `pre-commit:` at `:1`. A commit staging only files in directories that own no
  `CONTEXT.md` narrows the set to zero, and **an empty staged scope is arguably a legitimate
  no-op**. Choosing the third exit code changes whether that commit passes; it is not a message
  edit.
- **The class has three sub-cases and they do not share an answer**, which is the whole of the
  decision: a scope that is _legitimately_ empty (`copy-emdash.sh:31-34` points at
  `apps/marketing`, which this template does not ship — `ls code/src/django/apps/` returns
  `core health` and nothing else), a scope the caller _typo'd_, and a run _outside the
  repository_. The honest form for the first already exists one directory away at
  `copy-slop.sh:315-319`, and `docs-length.sh:405` already dies loudly on the second. Neither is
  wired to the third.
- **Correction to the pass's evidence: `docs-pairing.sh` does not close this class, it is the
  worst member of it.** Its guard at `:166` sits on the _unscoped_ collection at `:161-164`, so it
  closes only the out-of-repo case; `--path` is applied later by `in_scope` at `:153-156`, and the
  counter at `:280` reports the **pre-filter** size. `docs-pairing.sh --path does/not/exist` prints
  `checked 216 CONTEXT.md and 207 CLAUDE.md files` and `✓ CONTEXT.md / CLAUDE.md split intact.` at
  exit 0. **A false denominator is worse than a missing one**, because the count is exactly the
  mitigation the rest of the class is being asked to adopt.
- **The member with a live CI consequence is the ratchet, not the cosmetics.**
  `docs-length.sh:162`'s `require_arg` counts arguments only, so `--since ""` passes; `:404`'s
  `if [[ -n "$SINCE_REF" ]]` then skips the ratchet in silence. `--since ""` exits **0**;
  `--since deadbeef` exits **2**. The asymmetry is backwards — **the empty ref is the one CI can
  actually produce**: `audit-docs-length.yml:67` feeds `--since "$(git merge-base HEAD "$BASE_SHA")"`,
  and `:47` already documents that a shallow clone cannot compute it.
- **Rank the members by what they print, because the fix differs.** `sync-trees.sh` and
  `copy-emdash.sh` print **neither count nor path**; `css-gradients.sh:114` prints its scopes;
  `css-tokens.sh` prints `defined: 0 / referenced: 0`; `routing-skills.sh:370` prints
  `checked 0 skill name(s) across 0 file(s)`. The last two are **headline-only overclaims** — the
  denominator is already there, which is precisely the mitigation N-030's settlement adopted when
  it made `--self-test` assert on the **name count** as well as the finding count. That sentence
  was written about a skipped file; it is true of a skipped population too.
- **One member is not a decision at all, and it should leave this node.** `copy-emdash.sh:106`'s
  `[[ -e "$TARGET_PATH" ]] || die` sits inside `collect_files()`, invoked in a process
  substitution at `:128` — so `die`'s `exit 2` kills the **subshell**, and the script prints its
  error to stderr and `✓ No em dashes in marketing copy.` at **exit 0**. Proven against three
  siblings carrying the identical guard: `css-gradients.sh:101`, `css-tokens.sh:107` and
  `copy-slop.sh:233` all exit **2**. That is a one-script defect with the correct form three times
  over in the same directory — **route it to N-046 as the live specimen its struck `sync-trees`
  bullet asks for**, where it belongs by class (_a scope it did not honour_) and by type (`task`).
- **Say plainly what this is not, or the next reader will fold it into something older.** It is
  **not** N-046's struck bullet revived: that specimen missed a real member _inside_ its scope and
  was repaired at `ec8e807`; this one has no member to miss, and calling it the same mechanism
  repeats the error the map recorded when it charted a node against a window already closed. It is
  **not** N-052: `doc-references.sh:185`'s `*/*) ;;` skips a token **shape** out of a non-empty
  population, while this reports on **no population**. It is **not** N-042: that verdict turns on
  a file present on a developer's disk and absent from a clone. And it is **not N-055**, charted
  beside it — there a gate skipped a leg it could not run; here every gate ran its code correctly
  over nothing.
- **Blast radius is the whole audit directory, twice over.** `.claude/hooks/lib/check-audits.sh:41-43`
  globs `"$audit_dir"/*.sh`, so the pre-PR gate runs all six, and each also owns a CI job. Fifteen
  audits carry the `--path` existence guard; **four were measured here and one is defeated** — the
  remaining eleven are unmeasured, and the settling session should run them rather than inherit
  that ratio.

**N-057 — SETTLED 21/08/2026, sitting 2** (see _Resolved decisions_). The charted block is left
as written, with one claim withdrawn and one correction, both measured at HEAD `5d3c22f`:

- **The cost that made it a decision has largely evaporated, and it decided the call.** _"8 of
  its last 10 scheduled runs concluded `failure`"_ was true on 16/08 (runs #6–#15). At the
  sitting it was **3 of 10, with the last seven consecutive runs green** (15/08–21/08) —
  `gh api 'repos/{owner}/{repo}/actions/workflows/audit-deps.yml/runs?per_page=10'`. That
  weakens the case **against** requiring it and the case **for** it about equally, which is why
  the sitting settled on the trigger argument rather than the failure-rate one.
- **The scope was one bullet wider than the node knew.** `:98-99` deferred the conflict-marker
  audit's promotion to **N-029, a node that settled without taking it**, and its target
  `audit-conflict-markers.yml:10` claimed to be _"the only audit here"_ without a path filter —
  **six of the 26 are unfiltered**
  (`for f in .github/workflows/audit-*.yml; do grep -qE '^\s+paths:' "$f" || echo "$f"; done`).
  That is this node's charter verbatim, five lines from its own table, and no pass had read it.
- **Direction (c) — the ten unnamed contexts — is no longer refused; it is dissolved.** The
  refusal held while the table disclaimed being a census. Deleting the table removes the claim
  that could be wrong, which is a better answer than either adopting or re-refusing the finding.

Charted below. Measured at HEAD `a9c56a1`, 16/08/2026,
against live ruleset `20221742` — `main — protected`, `enforcement: active`, `strict: false`,
**20** required contexts.

- **The check that cannot arrive.** `audit-deps.yml:18-21` is `schedule` + `workflow_dispatch: {}`
  and nothing else, and `:33` names the job `Audit JS + Python dependencies`, which is required.
  It is the **only one of 35** workflows with neither trigger —
  `grep -LE '^\s*(push|pull_request):' .github/workflows/*.yml` returns that one file. So a PR to
  `main` never produces the context and it sits _Expected — waiting for status_, which is the
  failure `PR-AND-REQUIRED-CHECKS.md:44-48` opens by describing.
- **This is not the path-filter case the doc guards, and the doc's rule passes it.** `:42` states
  the binary — path-filtered **or** required, never both — and `:64` makes promotion mean
  _"deleting its path filter in the same change"_. `audit-deps.yml` has no filter to delete and
  still cannot report. The real predicate is whether a `pull_request` event starts it, and no
  sentence in the guide asks that; the qualifying criteria at `:74-78` do not reach it either,
  criterion 1 being _"it executes here and can fail here."_
- **The set holds the wrong half of a pair the file itself names.** `audit-deps.yml:82` — _"Both
  audits mirror `[8/8] Security` in claude.yml exactly"_ — and `:5` says the sweep exists
  **because** that gate _"only runs when a PR happens"_. `[8/8] Security` (`claude.yml:517`)
  reports on every PR and is **not** required. Its scheduled twin, which cannot, is.
- **Ten of the eleven rows are past, not future.** `comm -3` between the table's rows (`:103-113`)
  and the live contexts returns exactly one on the left — `Routing skills resolve` — and ten on
  the right. So `:94-96`'s _"promotion target … each row is a deliberate switch to flip"_, and the
  `Eligible since 16/08/2026` notes at `:107-109`, describe a world that ended at 12:32.
- **Timed to the minute, and it was true when written.** `8b66790` wrote the guide at
  **16/08/2026 10:15:25 +0100**; ruleset version `46675245` flipped seven contexts in at
  **12:32:15 +0100**; `33926e9` edited the file again at **15:57:28** without correcting it. Not
  decay, and not born stale like N-050 — **stale by 2h17m, then read past once.**
- **The one row honestly held is held for a reason that no longer exists.** `:106` marks
  `Routing skills resolve` **Hold** and `:118-122` gives the reason in the present tense, then
  sets the exit: _"Flip it once the parser reads both forms."_ N-030 met it —
  `routing-skills.sh:62-63` sources `_lib/frontmatter-skills.sh` and `--self-test` passes
  **7 probes over both array forms**.
- **Two collateral falsehoods in the same doctrine.** `:57-58` — _"the audits under
  `code/src/scripts/audits/` … none of them a required check"_ — is falsified by
  `Citations resolve` (`audit-doc-references.yml:31`, unfiltered, required). `:60-61` — _"`syntax-python.yml`
  unfiltered since 16/08/2026 and **not yet required**"_ — is falsified by all three of its jobs
  sitting in the set.
- **What is blocked, for whom, and the caveat — stated precisely, because the stronger framing
  does not survive.** **Blocked:** the merge of any pull request based on `main`, on automatic
  check results alone. **For whom:** anyone who is not the ruleset's single bypass actor —
  `RepositoryRole` id 5 at `bypass_mode: always` — and this repository's operating account carries
  `admin: true`, so today it merges regardless; it bites the first non-admin contributor or
  non-admin token. **Caveats, all three measured:** `workflow_dispatch` makes the context
  satisfiable by hand (**zero dispatch runs exist**); admin bypass; and **no pull request has ever
  met this ruleset**, the contexts having landed 16/08 at 12:32 and PR #11 having merged on 15/08.
  _Permanently unmergeable_ is wrong. **_Cannot be satisfied by any automatic event; needs a manual
  dispatch per PR or an admin bypass_ is right** — structurally certain, empirically unexercised.
- **The obvious fix carries a cost, which is what makes this a decision.** Adding `pull_request:`
  contradicts `:5`'s stated reason for the file existing and imports a gate **designed to fail**
  on advisory publication (`:8-10`) — **8 of its last 10 scheduled runs concluded `failure`**. So
  the open question is real: de-require it and decide whether `[8/8] Security` takes the place
  instead, or require the sweep and accept that the CVE feed gates merges. **Typed `grilling`,
  not `task`** — one `/grill-with-docs` surface. The three documentation corrections are its
  residue and cannot be written first, because row `:104` is either deleted or re-noted by
  whichever way the call goes.
- **Not blocking, on this map's own precedent — and the precedent was miscounted in this node's
  own draft.** _Gate to stories_ carries the claim **once**, about N-042 (_"still the closest to
  blocking and still does not"_); the neighbouring sentence is about **N-053** citing that
  precedent, not a second statement of it. The precedent survives the correction: it gates a
  merge, not a story, and a reviewer's proposal to mark N-053 blocking was refused on that basis.
  This is the same class one turn harder — a check that never arrives rather than one that arrives
  red — and it still gates a merge. **`Blocking open` stays 0.** Overturning that on a node whose
  block has never once been exercised, and which the repository's own admin bypasses by default,
  would be this batch's class pointed at the counters.
- **Direction (c) is refused, and the refusal is the finding.** The live set holds ten contexts
  the table never names — but `:94` disclaims being a census in terms, and **this map already
  refused a two-context version of exactly this claim** in _Fog of war_, as one of the three
  exhibits behind _a dispatched finding is evidence about where to look, never about what is
  there_. Re-adopting it at ten without engaging that refusal re-charts a phantom. What survives
  is a **question for the grilling**: `:61-62` says _"which jobs are in the set is the next
  section's table"_ while `:94` says the table is only a target — both cannot be true.
- **Third node on one file, second on one sentence, and it ships.** `:94` is already **N-050**'s
  site (the dead `3.2.2`); `:92`'s excluded-path citation is **N-031**'s. N-050 owns the version
  number in that sentence, this node owns _"promotion target"_ in the same one — recorded on the
  collision table and on N-050's row, or one fix half-writes another's. Both `audit-deps.yml` and
  the guide are absent from `copier.yml` `_exclude`, so a generated project inherits row `:104`
  and can wire itself the same unproducible required check.

**N-058 is charted as N-010 residue, and the _Resolved decisions_ row for N-010 is not
reopened.** N-010's claim was that `06` and `07` documented the gate in a form that runs nothing,
and that it fixed them; both halves are true at HEAD — `f4a988b` put the JSON pipe into
`06-quality-gates/STEPS.md:122` and `07-dependency-updates/STEPS.md:117`, each with the mechanism
written out beneath it. What survives is **outside the two files the node named**, so this is a
scope finding about N-010's blast radius, not a defect in its verdict. The `[x]` stands.

- **Two bare invocations, and the census is exhaustive rather than indicative.** A sweep for every
  executable form of the command returns exactly five hits repository-wide. Two are N-010's own
  fixes. One is `.claude/settings.json:138`, where bare is **correct** — that is the `PreToolUse`
  registration and Claude Code writes the payload to stdin. The remaining two are the defect:
  `how-to/workflows/06-quality-gates/CHECKLIST.md:49` and `.claude/skills/git/SKILL.md:76`
  (charted `:75`; moved +1 at `e3407cf`, N-051's own remedy).
- **Both were observed exiting 0, not reasoned about.** `bash .claude/hooks/pre-pr-check.sh < /dev/null`
  prints nothing and returns **EXIT=0** having run none of the gates — **nine here, eight in a
  generated project**, `TEMPLATE_MODE` adding the `audits` leg; the node said "eight" of this
  tree and undercounted by one — because `:30` reads
  stdin, `:31-33` parse `tool_input.command` out of it and `:35` exits 0 the moment the payload
  does not name the PR command. The correct mechanism lines are `:30`, `:31-33` and `:35`; **the
  challenge pass cited `:27`, `:28-31` and `:33`, all three wrong**, where the repository's own
  `STEPS.md:124-130` has them right. **That over-claims by one third**: the STEPS block cites
  `:30` and `:35` and never `:31-33`. A report auditing citation drift carried it.
- **The checklist site is one file from its own fix, and it is the gating artefact.**
  `06-quality-gates/CHECKLIST.md:49` is a box an operator ticks — "run end to end and green" —
  while `STEPS.md:122` four screens away carries the pipe and says in terms that the script is
  **unusable without it**. The workflow therefore instructs correctly and gates falsely, which is
  the batch's thesis inside the batch's own closing node.
- **The skill site is worse, and it was not in N-010's field of view.** `.claude/skills/git/SKILL.md:76`
  carries the bare command in a fenced `bash` block under "Run the pre-PR gate first and only mark
  a PR ready once every gate is green" (`:72`). A skill is what an **agent executes**, so its blast
  radius exceeds a checklist's, and nothing in that file corrects it. The keeper: `f4a988b`
  **edited two other skills in the same commit** (`stack-django`, `stack-htmx-templates`) and still
  missed this one, because the session was sweeping the N-037 class rather than its own.
- **It also contradicts the skill that owns the PR.** `.claude/skills/pr/SKILL.md:46` states "Two
  hooks fire on their own and **must not be duplicated by hand**". So `git` tells an agent to run
  it manually in a form that does nothing, and `pr` tells it not to run it manually at all. Two
  skills, one hook, opposite instructions — and the wrong one is the one that is silent when
  followed.
- **Typed `task` because the reconciliation already exists in the tree**, not because the sites
  are identical: a **human** running workflow `06` before pushing needs the piped form, while an
  **agent** in the `git` skill is about to trigger the hook itself, so its manual block is both
  redundant and false. Which of those two shapes the skill takes is left to the executing session
  rather than settled here — CHART draws, RESOLVE settles.
- **A third, weaker site, recorded rather than counted.** `07-dependency-updates/CHECKLIST.md:34`
  reads "`pre-pr-check.sh` green end to end" — a bare **name**, not a runnable command, so it
  cannot itself produce a false green. It is the same asymmetry as the `06` checklist: N-010 fixed
  both STEPS and neither CHECKLIST. Whoever takes this node should sweep the checklist twin of
  every command it corrected, not just this one.
- **Incidental, and it proves the gate itself is healthy.** A `git log -S` issued during this
  measurement quoted the hook's trigger string in its pathspec; the live `PreToolUse` hook matched
  it and **blocked the Bash call**. The matcher works, the registration works, the eight gates
  work. **Only the three documents telling a human how to invoke it do not** — which is precisely
  why this belongs to Batch B and not to a scripts node.

### Batch D — Split doctrine

| Node  | Decision                                                                                                | Type | Blocked by | Blocking a story? |
| ----- | ------------------------------------------------------------------------------------------------------- | ---- | ---------- | ----------------- |
| N-049 | **New.** N-016's comment rule contradicts itself across its two homes — a **resolved** node, live again | task | none       | no                |

~~**N-044 — the class reopened, and it is cheapest to settle before the second name commits.**~~
**Rewritten 16/08/2026 by the challenge pass. The node was wrong about its premise, its subject
and its type, and each was measured at HEAD rather than argued.**

- **The window it was racing had already closed when it was written.** `git ls-files
--error-unmatch how-to/docs/HEALTH-PROBES.md code/src/scripts/development/health.sh` → exit 0,
  both tracked at **`ec8e807`, 16/08/2026 17:42**; `git status --porcelain -uall` is empty
  repo-wide. This file's own mtime was **17:11**. The bullet reading _"the second name is free
  today and is Batch D proper tomorrow"_ was **31 minutes** from being false as it was typed.
- **They are two artefacts, not two names for one — which dissolves the subject.**
  `deployment/health-check.sh` is planned, post-deploy and CI-triggered;
  `development/health.sh` ships, is diagnostic and human-triggered, and its own
  `development/CONTEXT.md:43` says _"Diagnosis only; it restarts nothing"_. Different directory
  family, trigger, lifecycle stage and contract. Nothing is misnamed.
- **The `grilling` type revived an argument this map had already refuted, the same day.** The
  claimed _"three candidate answers"_ seam question is the one MAP:1339-1344 measured and refused
  for N-020 — _"they carve the seam at different levels rather than contradicting… an unwritten
  artefact with a named owner is a `task`, not an ownership question"_. `config/urls.py:8-11` lists
  two **consumers of the endpoint** and routes to `HEALTH-CONTRACT.md`; it makes no claim to own a
  caller script. **Re-typed to `task`.** Failing to cite the refusal is how this node was born.
- **It fails the Batch D class test outright.** No rule is stated twice and drifted: all five
  `health-check.sh` sites agree, every one names `code/src/scripts/deployment/` as the script's
  home, and `HEALTH-PROBES.md:18-19` **explicitly declines to own the rule** — _"This is the
  operator's half. What the endpoints publish and what the deploy repository must provision are
  decided in `code/docs/logging/HEALTH-CONTRACT.md`, not here"_.
- **Two claims survived re-measurement exactly.** `git grep -l -- 'health-check\.sh'` → **five
  files, six references** (`deployment/CLAUDE.md` cited twice — both figures were always right),
  and all six file:line citations reproduce at HEAD with **zero line drift**. None of the five is
  copier-excluded; all 58 `_exclude` entries were read. And `git ls-files
code/src/scripts/deployment/` still returns `CLAUDE.md`, `CONTEXT.md` and `reports/` only, so
  the script genuinely does not exist.
- **What is left is naming hygiene on an unwritten script**: whoever writes
  `deployment/health-check.sh` writes it under that name, because five shipped sites already say
  so. That is a `task` with a named owner (the `cicd` skill), not a decision.
- **The row is rescoped in place, not deleted.** This map has no precedent for a struck node —
  N-023 and N-037 both sit in the open Batch E table in exactly this state — and deleting it
  breaks the arithmetic invariant.

**The batch's original three closed together on 15/08/2026, N-028 on 16/08, and N-036 on 16/08**
— see _Resolved decisions_. ~~**Batch D is closed.**~~ ~~**Reopened 16/08/2026 by N-044**~~ — the
rest of this paragraph stands and is left as written. N-036 was the class's largest instance by
file count; its verdict is below, because the batch it came from is where the working belongs.

**The reopening claim is withdrawn as to N-044 and reasserted on different members — 16/08/2026.**
N-044 fails the class test (above). But the challenge pass found the class **live at HEAD in three
places nobody had charted**, one of them inside N-044's own subject area, and the chain's own
verdict on itself is the useful part: _every step accepted "Batch D is empty because the five sites
agree" and stopped at the filename_ — the first of these sat one `grep` away from fourteen agents
and was found only at the verify step. **Charted 16/08/2026 as N-048, N-049 and N-051.**

**N-048 — the file that disclaims ownership of the fact states it anyway, and the file that logged
the drift undercounted it.** `code/docs/logging/HEALTH-CONTRACT.md:134` reads _"This doc owns the
endpoint shapes and what each status means; SERVER-ARCHITECTURE owns what the server must expose
and scrape"_ — and then `:95`, inside a `nix` fence, writes `job_name = "<%ORG_SLUG%>-web"`.

- **Four homes, two spellings**, measured with
  `git grep -n 'ORG_SLUG%>-web\|ORG_SLUG%>-backend' -- $(git ls-files)`:
  `HEALTH-CONTRACT.md:95` and `logging/OBSERVABILITY.md:229` say **`-web`**;
  `SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md:171,185,340` and `how-to/src/TEMPLATE-TOKENS.md:321`
  say **`-backend`**.
- **The drift is already written down in a shipped file and still undercounted.**
  `EDGE-REQUIREMENTS.md:174-176` says _"Both spell the job `<%ORG_SLUG%>-web` where this contract
  says `<%ORG_SLUG%>-backend`; the spellings are unreconciled"_ — but calls the build side "two
  places" when `TEMPLATE-TOKENS.md:321` makes three. **A file can record a drift and still be an
  instance of it.** No `GAPS.md` entry, no node until now.
- **Typed `task` because the ownership question is already answered**, not because the sweep is
  small: `:134` names SERVER-ARCHITECTURE as owner and that owner says `-backend`, so three sites
  conform and `:95` loses its assertion. **The one thing that would re-type it to `grilling`** is
  if `-web` is the better name on its merits — in which case the owner changes its own contract and
  the other three follow. Settle that in the first five minutes of the sitting.
- ~~**It carries its own remedy, and the remedy corrects the map.**~~ **Withdrawn 21/08/2026 by
  sitting 3, measured rather than argued. The claim was derived from `SCAN_DIRS` alone and three
  things block it, not none:**
  - **The owner cannot be named.** `doctrine-drift.sh:207` tests `-f "$DOCS_DIR/$owner"` and `:212`
    matches `grep -F "$DOCS_DIR/$owner:"`, both rooted at `DOCS_DIR="code/docs"`. The owner this
    node settles on is `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`, outside that root, so
    an `owned` row would fire `doctrine-unowned` against a correct tree.
  - **The owner is never scanned.** `SCAN_DIRS` holds `code/docs`, `.claude/skills` and the three
    `workflows/` trees — **not `how-to/src`** — so all three `-backend` sites are invisible to it.
  - **Only fenced code is read**, and every `-backend` site is prose or a table. SERVER-ARCHITECTURE
    states its rules in prose **on purpose** (`SERVER-ARCHITECTURE/CLAUDE.md` → _Specify, never
    implement_), so satisfying the audit would mean breaking that doctrine to please a linter.
  - **So the map's twice-stated verdict (MAP:474-478, MAP:1096-1105) stands** — the audit named for
    Batch D genuinely cannot reach this Batch D rule, and the counter-example was the error. **The
    node corrected the map's pessimism into an equal and opposite optimism, from the same single
    source.** The scope is now written into `doctrine-drift.sh` beside `DOCS_DIR`, where the next
    person will be standing; it has been mis-derived from `SCAN_DIRS` twice.
- **Not Batch A.** The tokens are incidental: nothing here is an unrendered `<%TOKEN%>` reaching a
  parser, only one name spelt two ways. Filed under the class it actually belongs to.

**N-049 — a resolved node decayed, and the sweep that killed the exemption missed one of its two
homes.** N-016 closed 15/08 on the finding that _"a mirror is a second home"_, with ownership
settled on `code/docs/coding-principles/STYLE-AND-PROCESS.md`. At HEAD the two homes give
**contradicting scope**:

- `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md:124-129` — _"Scope: application source
  that ships in a deployable… **Two exemptions**… and the dev scripts under
  `code/src/scripts/`"_ — then routes to its owner **nine lines later** at `:133-136`.
- `STYLE-AND-PROCESS.md:41-48`, the named owner — _"every file this repository executes… and every
  script file (`*.sh`), wherever in the repository it sits… **One exemption**"_.
- **Typed `task` because the decision was already taken and one home missed it.** The
  N-030/N-034 sitting log on this page records the shell-script exemption **deleted at `1775d6d`**,
  _"after which every script in the repository needs auditing against it"_. So `:124-129` is not a
  rival view, it is an unswept site. **The node is the sweep plus the audit it implies** — the
  sitting that deleted the exemption named the consequence and nobody has run it.
- **Why it is worth a node rather than a one-line fix:** this is the first demonstration on this
  map that **a resolved node can decay**, and its Resolved row (MAP _Resolved decisions_, N-016)
  claims _"the rule now has one home"_. That row is now false and should be annotated when this
  settles, not silently left.

**N-051 — SETTLED 21/08/2026, sitting 2** (see _Resolved decisions_). **Both halves of the
headline are refuted; the node survived on what was underneath them.** Measured at `5d3c22f`:

- **"Three homes" is nine or ten.** The node named two and implied a third it never found. A
  sweep of every file stating a bump file set — not merely mentioning a log — returns nine, read
  by hand at `5d3c22f` from the candidates `git grep -l -F 'VERSION-HISTORY.md' -- '*.md'` gives,
  because "states a file set" is a judgement no grep expresses; and
  a paraphrase sweep adds `.claude/skills/git/SKILL.md:61-62`, which the literal search could
  not have seen. **A node carrying a number carries the invocation**, and this one did not.
- **"The one that runs is not the one claiming to be canonical" is refuted 3–0.** Nothing
  disputes canonicity: `version/SKILL.md:23-25`, `CONTRIBUTING.md:86-88` and
  `release/SKILL.md:40` all name the guide. The sitting was told not to spend itself on a
  contest that does not exist.
- **The evidence was stale in the strongest possible way: the practice had already conformed.**
  `b4f00db` (5.5.0, 18/08) touched exactly `CHANGELOG.md CONTEXT.md README.md RELEASES.md
VERSION VERSION-HISTORY.md` — the guide's six — and all three bumps after the original eight
  touched `README.md`. The node's "`README.md` was not touched" is a true claim about **eight
  past commits** and was never a claim about HEAD.
- **What survived is sharper than what was charted**, and is what shipped: the executing skill
  **forbade itself from restating the list, then restated it short by two**; and
  `24-release/STEPS.md` + `CHECKLIST.md` instructed the `pyproject.toml` bump the guide
  **forbids** at `:175` (`Only the root files above move on a root bump.`, the categorical line;
  `:173` is the weaker of the two) — which `git log -G'^version = ' -- pyproject.toml` shows has
  been executed **eleven** times, one of which created the file.
- **The grilling premise died too.** "A shipped guide binding a downstream reader to the
  template's housekeeping" assumed a generated project has no README to bump. It has one:
  `copier.yml:757` moves `.copier/README.md` into place, badge at `version-0.1.0`. Only the
  **footer version** half fails downstream — the shipped footer carries no version at all.

Charted below. Paired with **N-050** (_Unbatched_) and settled with it: N-051 is the cause, N-050 is
the site that shipped because of it.

- `project-management/docs/VERSIONING-GUIDE.md:160-171` — six files, prefaced _"All of the
  following must be updated. Missing any one leaves the project inconsistent"_, including
  `README.md` and `CONTEXT.md`.
- `.claude/skills/version/SKILL.md:78-86` — a six-step ordered procedure naming `VERSION`,
  `VERSION-HISTORY.md`, `CHANGELOG.md`, `RELEASES.md`, the headers and the stage. **It names
  neither `README.md` nor `CONTEXT.md`.**
- **The executed set matches the skill.** All eight bumps touched exactly `CHANGELOG.md`
  `CONTEXT.md` `RELEASES.md` `VERSION` `VERSION-HISTORY.md` (plus `copier.yml` and a migration on
  the two MAJORs). `CONTEXT.md` was done anyway; **`README.md` was not, which is why its badge sat
  eight releases behind.** A procedure gap that showed once and hid once.
- **Typed `grilling` because the answer is not simply "conform the skill to the guide".**
  `README.md` is copier-**excluded** (`copier.yml:37`) and a generated project ships
  `.copier/README.md` at `version-0.1.0`, so a shipped guide instructing a downstream reader to
  bump their README is arguably binding them to the template's own housekeeping. **Which file set
  is canonical, and whether a shipped guide may name a template-only file, is the decision.**

**N-028's tail was fixed rather than charted, on Sam's call — no node.** Two things came out of it
and only one of them was ever a node's worth of work.

- **The eleven downstream restatements stay.** `COVERAGE.md`'s numbers are repeated in
  `FRONTEND-TESTING.md`, `rls/TESTING-AND-AUDIT.md`, `mcp-server/TESTING-AND-OPS.md`, `RUST.md`,
  `OBJECT-STORAGE.md`, the `test-writer`, `stack-rust`, `stack-react-native`, `authentication` and
  `stack-fastmcp` skills, and `how-to/workflows/05-testing-and-coverage/CHECKLIST.md`. **None of
  them became false** — 75 really is the always-floor — so they are incomplete rather than wrong,
  and were left as scoped.
- **`DOCUMENTATION-PAIRING.md` was fixed in place**, because it was not a restatement problem at
  all but a **self-contradiction**: Section 5 offered _"the coverage floor is 75% line and branch,
  90% auth"_ as a domain fact that **belongs** in `## Key concepts`, while Section 6 showed the
  same sentence as its **Bad** example. One guide, one example, both sides of its own rule. Section
  5 now states the reconciliation the guide always implied — **a fact that already has an owner is
  a restatement whatever its grammar**, so the test is Section 6's — and uses the coverage floor as
  the counter-example rather than the permitted one.
- **The dating is the part worth keeping.** Section 6's Bad example **decayed inside the guide
  while nobody touched it**: N-028 gave the floor a promotion tier, so the bad half is now
  incomplete as well as duplicated, and reads no differently for it. The Good half needed no edit.
  A guide that documents route-don't-restate now carries a dated instance of the rule proving
  itself on its own page, which is worth more than the node would have been.

**N-036 — the fact was corrected in one place and the reason was left standing in fifteen.** N-001
made the manifest name a house constant at `7cd385d`. The map recorded the consequence for
`.gitignore` (_"carries a rationale that is no longer true"_) and stopped there. A sweep on
16/08/2026 found the same dead premise — _uv rejects the tokenised name / the manifest cannot be
parsed / `uv.lock` is absent by design because it would pin `<%PROJECT_SLUG%>`_ — alive in:

| Where                                                                                                | Reads                                                             |
| ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| root `CONTEXT.md:125`                                                                                | **auto-loaded every session by `.claude/CLAUDE.md`'s `@` import** |
| `.gitignore:11`                                                                                      | the rule's own rationale                                          |
| `.github/workflows/syntax-python.yml:5–9`                                                            | _"THE BLOCKER"_ — and contradicted by its own line 153            |
| `claude.yml:12` · `test.yml:42` · `test-api.yml:49` · `test-e2e.yml:37`                              | the four lockfile guards' stated reason                           |
| `lefthook.yml:25` · `.claude/hooks/CONTEXT.md:124` · `check-security.sh` · `pre-pr-check.sh`         | the local gate half                                               |
| `dependencies/CONTEXT.md:65` · `dependencies/update.sh` · `code/src/mobile/CONTEXT.md`               | the tooling half                                                  |
| `how-to/workflows/06-quality-gates/STEPS.md:125` · `07-dependency-updates/{CLAUDE,CONTEXT,STEPS}.md` | what an operator is told                                          |
| `how-to/src/TEMPLATE-TOKENS.md`                                                                      | the token contract itself                                         |

- **Most are half-true, which is what makes it Batch D rather than a simple error.** The charting
  above was written while `uv.lock` was still absent, so it read _the fact holds, the reason is
  dead_. **N-035 then committed the lock, and the fact died too** — by the time the node was taken,
  both halves of the premise were false and every site was wrong rather than half-wrong.
- **`CHANGELOG.md` and `RELEASES.md` keep their text and are not in scope** — a historical record
  describing the state at the time is accurate, which is the same rule N-012 applied to the deleted
  `research/` notes. Held to on execution; `VERSION-HISTORY.md` added to the same exemption.
- **Blocked by N-035, deliberately** — and the sequencing was right for a reason better than the
  one given. The stated case was avoiding writing the new wording fifteen times; what actually
  happened is that **N-035 swept eight of the fifteen itself**, because a node that changes a fact
  corrects the prose it touches on the way past.

**N-036 verdict — settled 16/08/2026, and the charted table was wrong in both directions.** Not a
transcription: of the ~15 rows charted, **8 had already been swept by N-035** (root `CONTEXT.md`
— the row called highest-leverage — plus `.gitignore`, `claude.yml`, `test.yml`, `audit-deps.yml:55`,
`syntax-python.yml`'s body, and both `dependencies/` files), while **6 live sites the table never
listed** were found by sweeping for the premise rather than reading the row list. Sixteen files
changed.

- **The table's two charted errors both confirmed.** `code/src/mobile/CONTEXT.md` carries no `uv`
  premise at all — its `:39` "absent by design" is about `ios/` and `android/` under Expo CNG —
  **row struck**. And `06-quality-gates` was **under-counted by two**: `CONTEXT.md:56` and
  `CLAUDE.md:36` carry it beside the charted `STEPS.md:125`.
- **The six unlisted sites**, four of which no reading of the table would have reached:
  `.claude/hooks/lib/check-security.sh`, `code/src/scripts/audits/render-slop.sh` (which by the end
  **contradicted its own `CONTEXT.md`**, the node's defect reproducing inside the node),
  `audit-template.yml:102`, `audit-deps.yml:41` and `:69`, and
  `git/PR-AND-REQUIRED-CHECKS.md:76,86`.
- **`syntax-python.yml` was worse than charted — three defects, not one.** Its header was flatly
  false (`name` "is **still** the unrendered token") **and** contradicted its own body on whether
  basedpyright is guarded. The third was **introduced by N-035 itself, hours earlier**: the body
  called `--frozen` "an impossible [assertion] in the template, which commits no lock", written by
  the commit that committed the lock. **A node can create an instance of the class it is clearing.**
- **The cross-reference defect is the one worth keeping.** `git/PR-AND-REQUIRED-CHECKS.md:86` cited
  `TEMPLATE-GAPS.md` SL-1 as authority for "the backend suites guard to success here". N-035
  **rewrote SL-1 to say the opposite** — the suites now run, verified at 100% over 162 statements.
  The citation did not rot, it **inverted**: still resolving, still authoritative-looking, now
  claiming the reverse of its source. Nothing lints that.
- **Guards untouched, prose only**, on N-035's own doctrine — _"every `[ -f uv.lock ]` runtime guard
  stays; what changes is the prose around them"_. Every guard self-adjusts to `--frozen` now that
  the lock exists, so behaviour was already correct everywhere; **not one line of logic changed in
  sixteen files.** Where a dead reason justified a live choice — `uvx --from` in `lefthook.yml`,
  `--no-project --with` in `render-slop.sh` — the choice was **re-justified on its surviving merits
  rather than reverted**.
- **`doctrine-drift.sh` cannot hold this class as written — measured, not assumed.** **0 of 7 homes
  are reachable**, on two independent axes: `collect_fenced()` is `*.md`-only and neither `.github/`
  nor `code/src/scripts/` is in `SCAN_DIRS`, and `fenced_lines()` emits only fenced lines while both
  homes in a scanned tree are prose. The deeper objection is that the gate would have to separate
  _"uv.lock is absent by design"_ from _"uv.lock **used to be** absent by design"_ — narration this
  repository requires, and which the corrections above now contain. **Tense is meaning**, and the
  script's stated invariant is that it matches shapes, never meaning. A defect-scoped sibling audit
  is the shape that could work (`conflict-markers.sh` is the precedent), but a standing gate for one
  now-dead fact is thin; the generalisable version is "a dated claim about repository state", which
  is a larger design than this sweep.
- **Deliberately not taken:** `syntax-python.yml:47,97,137,172` carry four copies of "the template
  installs nothing to cache". Downstream of the same dead premise and now doubtful, but correcting
  them means measuring CI cache behaviour rather than reading a file, and `ignore-nothing-to-cache`
  is a harmless no-op when there **is** something to cache. Left as a measured, named residue.

**N-028 settled 16/08/2026** — see _Resolved decisions_.

### Batch E — Declared, not built

| Node  | Decision                                                                                                                                             | Type     | Blocked by                                                                                  | Blocking a story? |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------- | ----------------- |
| N-021 | Write the four security incident runbooks — each performed once against non-production first                                                         | task     | **three of the four have no subject and may never have one here** — blocker re-worded 16/08 | no                |
| N-023 | ~~Dated 02/11/2026~~ **Premise dead — `b805774` deleted both ignores.** What remains is the residue sweep                                            | task     | none                                                                                        | no                |
| N-026 | **Inherited.** `NINJA-CONVENTIONS.md` requires a per-app `api.py` and a mounted `config/api.py`; neither ships and `new-django-app.sh` emits neither | grilling | none — **but it splits; see the verdict below**                                             | no                |
| N-045 | **New.** The Bruno request template a developer copies documents a **GraphQL** API this project does not have                                        | task     | none                                                                                        | no                |

**Verification pass 16/08/2026 — the corrections below were measured after N-035 landed, and the
window is the whole story.** Every Batch E premise in the prose beneath this block was measured at
or before `840acb3` (16/08, 13:22). N-035's seven commits ran from `b805774` (15:14) to `bde5cc6`
(15:40). **Two premises died inside those two hours and one node died outright.** Read anything
below dated 15/08 or "corrected 16/08" as measured before that window unless it says otherwise.

**Challenge pass 16/08/2026 evening — nine subjects challenged, verified and reviewed by sixteen
agents, no step reviewing its own work.** Every node below was attacked rather than confirmed. The
outcome per node is recorded in its own paragraph; what the pass produced as a whole is **two new
nodes** (N-053 in Batch A, N-054 here), **one node shrunk** (N-046), **two grown sharply** (N-031,
N-037), and **nothing settled**. The pass also found **two of its own legs wrong in the same way** —
see the standing lesson at the end of _Frontier_.

**N-054 — the owning contract publishes what it cannot probe, and the node that halved it did not
re-read it.** `code/docs/logging/HEALTH-CONTRACT.md` is the single source of truth for what the app
exposes, and two of its claims are false at HEAD:

- **`:34` names four readiness dependencies** against `apps/health/checks.py:136-138`, which probes
  **two**. An operator reading the contract expects a verdict covering four subsystems.
- **`:32` publishes `GET /metrics/`**, which `config/urls.py:20-22` does not serve — it mounts the
  health app and the admin alone. A `health-check.sh` written to that table would probe a 404, which
  is the same trap N-020 already carries.
- **`ec8e807` (16/08, 17:42) touched this exact file** and left both standing, editing one
  cross-reference line. **The node that built the operator's half did not re-read the contract it
  was halving** — the same shape as N-036's defect, one guide further out.
- **A second row, folded in rather than charted separately.** Three maintained shipped documents
  state the Celery floor as `celery[redis]>=5.3` — `PROCESS-MODEL.md:19`, `TASK-AUTHORING.md:13`,
  `CELERY-FIRST-RUN.md:21` — against `pyproject.toml:60`, which has read `>=5.6` since `fd9bdde`
  (14/08/2026). Their "declared, not wired" framing is correct; only the number is dead. Three
  sites, one edit each.

**N-023 — the node is dead as charted, and it was killed by a node in another batch that moved no
row.** `code/src/rust/deny.toml:26` reads `ignore = []`, under a comment headed _"EMPTY BY
MEASUREMENT, 16/08/2026"_. `git log -S 'RUSTSEC-2026-0194' -- code/src/rust/deny.toml` and
`git show b805774` put the deletion in **`b805774`, the first of N-035's seven commits**.

- **The cause was not a re-check.** The MSRV floor moved — `Cargo.toml:26` is now
  `rust-version = "1.92"` — which let the resolver take `zbus` 5.19, which no longer pulls
  `quick-xml` at all. The whole chain left the graph and cargo-deny began warning
  `advisory-not-detected` on both entries, so they were deleted rather than re-justified.
- **Both charted arms are void, not answered.** The `02/11/2026` date has no subject; the second
  arm — _"or sooner if Slint bumps accesskit"_ — has no subject either. The 16/08 corrections pass
  wrote a careful analysis of `deny.toml:31` at 13:22 and the line ceased to exist at 15:14. **It
  was right when written.**
- **The uncharted finding recorded beside it has also self-cleared.** `SUPPLY-CHAIN.md:42`
  described the policy as _"empty `ignore` … An empty ignore list is the default state"_ and was
  flagged false at HEAD; it is **true again**, by the same commit.
- **What survives is a residue sweep, and it is larger than the node.** Seven shipped sites still
  assert that `deny.toml` carries two accepted advisories — including `code/src/rust/CONTEXT.md:70-73`
  and `copier.yml:173-176`, the latter in the template contract rather than a guide. `RELEASES.md:2244`
  points at content that no longer exists and is **append-only, so not a line to edit**, on the
  N-012 precedent. Re-scope the node to that sweep, or close it and chart the sweep; do not leave
  it reading as a date-gate.
- **Re-measured 16/08/2026, and the sweep is 9 sites across 7 files, not seven sites — with the
  denominator stated, because neither of the two agents who counted it had one.** Population:
  `git grep -niE 'accesskit|quick-xml|RUSTSEC-2026-019'` over tracked files returns 57 lines in 22
  files; exclude `Cargo.lock` (generated), `deny.toml` (the corrected source), the append-only
  `CHANGELOG.md`/`RELEASES.md`/`VERSION-HISTORY.md`, and the lines asserting only _"keep AccessKit
  enabled"_, which are still true. What remains — present-tense assertions that the two advisories
  are accepted — is **9 sites in 7 files**: `.claude/skills/stack-slint/SKILL.md:191,258` ·
  `code/docs/DESKTOP.md:128,135` · `code/docs/desktop/CLAUDE.md:34` · `code/docs/desktop/CONTEXT.md:34`
  · `code/docs/desktop/UI-AND-STATE.md:172` · `code/src/rust/CONTEXT.md:71` (not `:70`) ·
  `code/workflows/13-desktop-app/CONTEXT.md:57`. A tenth, `.claude/skills/stack-rust/SKILL.md:197-198`,
  is real but is **a different class** — stale MSRV doctrine citing a guide that now contradicts it —
  and is named separately rather than merged into the count.
- **The causal story charted here is wrong, and the correction is a method note.** This node reads
  as though `b805774` rewrote `SUPPLY-CHAIN.md` and removed the section the cross-references point
  at. It did not: `git log -G accesskit`, `-G AccessKit`, `-G quick-xml` and `-G RUSTSEC-2026-0194`
  over that file are **all empty across its entire seven-commit history**, and
  `git show b805774^:code/docs/rust/SUPPLY-CHAIN.md` contains neither term. **The cross-references
  dangled from birth.** `## Suppressing an advisory` is alive at `:125`, so _"the guide no longer
  contains what they cite"_ also overstates. Use `git log -G` here, never `-S`: `-S` counts
  occurrences and cannot find a commit that never held the string. Re-anchor `RELEASES.md:2244` to
  `:3028-3036` and `CHANGELOG.md:684` to `:912`.
- **A fog-of-war entry loses its quorum with it.** The expiry-gate question below counted three
  registers carrying a re-check date. `deny.toml`'s instance is gone, leaving two — one of which
  (`docs-length-allow`) is immune by format. **One vulnerable register is not a pattern**, and the
  entry now says so.

**N-043 settled 18/08/2026 — the register is now true about a tree `copier copy` actually
produced, and the guide had been contradicting itself for four days in one file.** All six charted
claims re-measured before anything was written; **one was already dead, four held verbatim, and
the node's own anchors were wrong.**

- **The sharpest finding is one the node never charted: `06-GENERATION.md` disagreed with itself,
  and the half nobody doubted was the wrong half.** The register at `:103` said the guide tree is
  excluded. The verification command at `:217` — 114 lines below it, in the same document — passes
  `--exclude-dir=TEMPLATE-GUIDE --exclude=TEMPLATE-TOKENS.md` to a token sweep **a reader runs
  inside their generated project**, which is only meaningful if those files are there. **Proven by
  execution against a real generation: 0 surviving tokens with the exclusions, 95 without**, all of
  them in `06-GENERATION.md`, `15-TROUBLESHOOTING.md` and `TEMPLATE-TOKENS.md` — the three shipped
  files that quote token syntax on purpose. The command was right, the table was wrong, and no
  reader could have reconciled them.
- **Verified by generating, not by reading.** `uvx copier copy --trust --defaults --vcs-ref=HEAD`
  into a scratch tree, then **27 assertions across all six rows**, every one passing:
  `TEMPLATE-GUIDE/` and `TEMPLATE-TOKENS.md` **present**, `TEMPLATE-GAPS.md` **absent**,
  `copier.yml`/`LICENSE`/`SECURITY.md`/`CONTRIBUTING.md` absent, the five template-only CI paths
  absent, the six seeded files and `uv.lock` present, `.copier/` cleared, the artefact trees
  holding their pair and nothing else. The guide's own four remaining checks pass too — `ok`,
  `0`, `staging cleared`, `0.1.0`.
- **Two uncharted falsehoods found by sweeping the whole register rather than the four bullets** —
  the completeness critic's catch, exactly as the 18/08 lesson predicts, because a finder scoped
  to a charted bullet cannot ask about a row nobody wrote one for. **`.git` is excluded
  (`copier.yml:31`) and appeared in no row.** And the artefact-trees row said the exclusion spares
  _"the `CONTEXT.md`/`CLAUDE.md` pairs and the templates"_ when the allowlist re-includes
  **fifteen further named paths** — the six GDPR documents, the brand-guide and component build
  scripts, the shared wireframe stylesheet, the two `US000` test sheets and the incident index. A
  reader would have concluded their `09-GDPR/` folder arrives holding a documentation pair; it
  arrives holding six working documents. **That is this batch's own defect shape, in the register
  that exists to describe it.**
- **The node's anchors were wrong and nobody would have re-measured them.** It recorded
  `_exclude` as spanning **`:29-197`**, last entry `.DS_Store` at `:197`, next top-level key at
  `:201`, and a sibling bullet at N-050 records _"all 58 `_exclude` entries were read"_. Measured
  at HEAD: the span is **`:29-250`**, `.DS_Store` sits at **`:250`**, the next key `PROJECT_NAME:`
  at **`:254`**, and there are **82** entries. `866d59d` grew the file by 81 lines on 17/08 — the
  artefact-tree allowlist — and every anchor written before it drifted by ~53. `:30`
  (`/copier.yml`) and `:44` (`/uv.lock`) both hold, being above the insertion.
- **`/uv.lock` was placed by mechanism rather than by row.** It is excluded and **regenerated by
  the `uv lock` task**, not re-supplied from `.copier/` like the six beside it, so filing it under
  _Seeded state_ unqualified would have traded one falsehood for a smaller one. The row now names
  both mechanisms.
- **The fifth site is corrected and its code deliberately is not.**
  `code/src/scripts/audits/doc-references.sh:26` justified exempting the tree as _"copier-excluded
  AND must be able to name a broken citation"_. The first half is false; the second survives and
  covers `TEMPLATE-GAPS.md`. The comment now says so and states plainly that the **rest** of the
  tree is exempted as a citing file on a premise that no longer applies to it — **and routes the
  decision to N-031**, which is where narrowing `is_exempt()` belongs. Fixing it here would have
  answered a grilling question with a script edit.
- **What this node did not do, on its own boundary.** `copier.yml` excludes itself, so a shipped
  sentence citing it dangles downstream. The register now **states** that consequence, because it
  is a fact. **Which of the 32 shipped files citing it should change is N-031's**, unchanged.

**N-020 — obstacle (b) is half-refuted by N-035, and the node's type does not survive it.** The
charted text reads _"No health route — `code/src/django/config/urls.py:16-18` registers the admin
alone, and `health-check.sh` is equally absent, so there is neither an endpoint nor a caller."_
Measured at HEAD: `config/urls.py:21` reads `path("", include("apps.health.urls"))`, and
`apps/health/` ships `urls.py`, `views.py`, `checks.py` and two test packages. **The endpoint
exists; only the caller is missing.**

- **Obstacles (a) and (c) still hold.** No workflow in `.github/workflows/` builds or pushes an
  image — 35 files, none matching — while `docker-compose.prod.yml:17` pulls from GHCR with no
  `build:` fallback; and `code/src/scripts/deployment/` still holds `CONTEXT.md`, `CLAUDE.md` and
  `reports/` alone.
- **Proposed re-type, not applied — Sam's call.** The node is three scripts with three different
  blockers: `health-check.sh` now needs only an owner (**N-044**), `deploy.sh` needs the absent
  image-publish workflow first, and `rollback.sh` has no contract row anywhere in
  `SERVER-ARCHITECTURE/` and waits on `/scale-planning`. **A `task` is an unwritten artefact with a
  named owner**; two of the three fail that test, which is the map's own mis-typing rule.
- **N-035 also left closeout residue on this node's surface.** `code/src/django/config/CONTEXT.md:28-30`
  still lists `/control/` as the only route and `:39-41` still asserts _"There is no health,
  metrics, API, or SEO route at baseline"_ — false in both halves since `47e84cf`. Beside it,
  `code/docs/logging/HEALTH-CONTRACT.md:32` lists a `GET /metrics/` row that `config/urls.py`
  serves with nothing, so a `health-check.sh` written to that table would probe a 404.

**N-037's blocker is false at its three charted claims — corrected 16/08/2026, again.** The row was
corrected once already (from `Blocked by: none` to `N-026`). Measured: the claims table has exactly
three rows — `stack-htmx-templates/SKILL.md:33` and `:169`, `stack-django/SKILL.md:259` — and
**none touches `api.py`, `services/` or `policies.py`**. The N-026 dependency lives at `:168` and
`:302-308`, which appear only in the blocker rationale and are not charted claims. **The map
contradicts itself here in two places written the same day**: the collision table scopes the
coupling to specific lines, the node row scopes it to a whole file. So the node is takeable today
at its charted scope, and blocked only if a session widens it to the whole false-assertion class in
both files. Both skill files are unchanged since 15/08, so all three claims survive N-035 and N-036
intact — `:33` and `:259` hold as written, `:169`'s repair is the **number**, not the line.

**N-031's reproduction was re-run and the numbers are different — and the difference is N-042.**
The 16/08 correction records _"exit 0 → exit 1, with exactly three `dangling path` violations"_.
Re-run in a `git archive HEAD` scratch clone with `git init`, the deletion of `TEMPLATE-GAPS.md`
gives **exit 1 → exit 1 and four violations**. The three charted `TEMPLATE-GAPS.md` sites reproduce
exactly as recorded — `MONITORING-AND-INCIDENT.md:73`, `apps/core/CONTEXT.md:61`,
`INCIDENT-PRACTICE.md:203`, of which **only the first is charted here**. The fourth is the
pre-existing `MACHINE-SPEC.md` violation that is now **N-042**: the baseline was never clean on a
fresh checkout, so the "exit 0" half of the original claim was an artefact of measuring on a disk
that had run `install.sh`. **A reproduction is only as good as its baseline**, and this one had
been run without a git repository, where `doc-references.sh:81`'s `git ls-files` returns nothing
and the script reports _"Clean — every citation resolves"_ **having examined no files at all** —
it prints no file count, unlike every sibling audit.

**The three-way collision N-020 × N-021 × N-031 does not survive measurement.** The map charts
`how-to/docs/INCIDENT-PRACTICE.md:199-206` as one passage naming the three absent deploy scripts,
routing the four security runbooks, and carrying the dangling citation. Measured: the passage is
headed `## Rollback` and **names none of the four security recoveries** — `grep -inE 'account
compromise|cache compromise|key rotation|log tampering|admin_db'` over that file returns nothing.
The real collision is **N-020 × N-031** on that passage, and **N-021 × N-031** separately on
`MONITORING-AND-INCIDENT.md:69-73`. Two agents found this independently. **N-021 is not coupled to
N-020 at all**, which frees the two to be scheduled apart.

**N-026 splits, and only one half is takeable — recorded, not settled.** The documentation arm is
mechanical: `NINJA-CONVENTIONS.md` asserts a universal per-app `api.py` in prose the guide still
carries, and `find code/src/django -name api.py` is empty. The scaffold arm — does
`new-django-app.sh` start emitting an `api.py` and a `services/` package — is **genuinely
undecided and is Sam's call**, which is why the node stays `grilling`. Two facts found while
measuring and worth carrying into that grilling: `new-django-app.sh:149-150` emits an app
`CLAUDE.md` telling the developer to put _"business logic in `services`"_ while the script creates
no `services/` package; and **`apps/health` — the newest app in the tree, built by N-035 after the
convention was written — has no `api.py` either**, so the convention has now been declined once in
practice.

**A third fact for that grilling, measured 16/08/2026: the convention has also been _adopted_ once,
by hand.** `code/src/django/apps/core/services/errors.py` exists — added at **`ce259df`, 11/08/2026
08:36**, which is the directory's oldest commit. So the scaffold arm is not choosing between a
convention nobody follows and a blank sheet; it is choosing between **one hand-built adoption and one
deliberate refusal**, five days apart. The provenance matters and was got wrong once on this pass:
a challenge dated the adoption to `93037ba` (14/08), which `git show --stat` shows touching that file
for **four lines**. **Measuring a file's birthday and inferring its contents** is the failure this
map has already named — recorded here because it recurred inside the audit of it.

**Everything else in this node re-measures true.** `NINJA-CONVENTIONS.md:73-75` still demands a
per-app `api.py` in unqualified present tense; `find code/src/django -name api.py` is empty;
`git grep -n NinjaAPI -- 'code/src/django/*'` returns nothing; and only
`api-design/AUTH-AND-ERRORS.md:148-151` states the absence, under `### Not yet built` — **the owning
guide still does not**.

**N-022 verdict — settled 16/08/2026 in four grilling rounds; the row has moved to _Resolved
decisions_ and the working is kept here, where the batch it came from is.** Opened after
measurement showed the node **a third smaller than charted**: the
cadence and the owner's producing half are already written at `02-STACK.md:136-137`, and only the
trigger was ever missing. Round 1, settled by Sam:

| #   | Question                                             | Settled                                                                                       |
| --- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| 1   | Whose obligation is tracking Expo's SDK cadence?     | **Split by act** — the template owns **producing** the bump, the project owns **adopting** it |
| 2   | Single home for the rule binding a generated project | **`code/src/mobile/CLAUDE.md`**; the other three sites demote to citations                    |
| 3   | `02-STACK.md`'s ungated Expo passage                 | **Folded into this node**, not charted separately                                             |
| 4   | The pin's accidental protection from the sweep       | **Write the constraint down**; `update.sh` is not edited                                      |

- **The split in Q1 is the load-bearing answer.** The template cannot know a downstream project's
  store-release schedule, so a single owner was never coherent — `02-STACK.md:136` had promised
  only the producing half and the adopting half had no owner at all.
- **Q4's finding, measured not assumed:** `code/src/scripts/dependencies/update.sh:213,216` run
  `pnpm update --latest` with **no `-r`**, and pnpm's own documentation confirms `update` does not
  cross workspace packages without it (`recursiveInstall` governs `install`, not `update`). But
  `code/src/mobile/` **is** a workspace member through `pnpm-workspace.yaml`'s `code/src/*` glob —
  whose own comment already warns that "any future directory under `code/src/` that carries a
  `package.json` joins this workspace without anyone declaring it". **So the Expo pin survives the
  routine dependency sweep by one absent flag, and nothing says so.** The script is not touched
  here: it is claimed by both N-036 and N-010.

Rounds 2 and 3, settled by Sam:

| #   | Question                                    | Settled                                                                                         |
| --- | ------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| 5   | What makes the template **produce** a bump? | **Every SDK release, immediately** — no wait for the ecosystem to land                          |
| 6   | What makes a project **adopt** one?         | **On store release**, plus an explicit pre-apply breakage warning                               |
| 7   | Where the producing obligation lives        | Root **`/CONTRIBUTING.md`** — copier-excluded (`copier.yml` `_exclude`), so it never ships      |
| 8   | `02-STACK.md:129-139`                       | **Keep the choice framing, demote the cadence claim to a citation** — not gated, not left as-is |
| 9   | The general upstream-tracking ask           | **Its own map**, not a node here — see below                                                    |
| 10  | The update pre-flight                       | Suites line added **and** a pre-apply warning, **conditional** on dependencies having changed   |

- **Q5 went against the recommendation, and the reason is the general case.** _Wait for the
  ecosystem_ was recommended on `02-STACK.md:137`'s own evidence that SDK majors break projects.
  Sam took _immediately_ instead, on the ground that Expo is **one of about twenty** upstream
  technologies this template pins and the answer has to generalise — a per-technology judgement
  about ecosystem readiness does not.
- **Q10 was measured down to almost nothing, and the first framing of it was wrong.** The ask read
  as "build a dry-run"; `template-update.sh` **already has one and it is better than copier's
  `--pretend`** — it clones the project to a scratch directory, runs the update against the copy
  (`:125`, `:134`) and reports modified/deleted/added/conflicts, _"Would anything be orphaned?"_
  (`:196`) and _"Would your dependencies change?"_ (`:221`), with **preview as the default and
  `--apply` the only writing path** (`:19-20`). The real gap is one line: `dependencies/update.sh:85`
  tells the operator to run the suites after `--apply` and **`template-update.sh:287-290` does
  not** — it says `git diff`, `template-orphans.sh`, commit. Two sibling scripts, one habit,
  present in the one whose blast radius is smaller.
- **The general case is a separate map, on Sam's call, not a node here.** Nothing in this
  repository watches upstream **releases** for **any** technology: `audit-deps.yml` is a daily
  **CVE** sweep (`pnpm audit` + `pip-audit`) that opens an issue for advisories, and
  `audits/dependency-drift.sh` compares an incoming template against this project — neither looks
  upstream. `REFERENCES.md`'s stack table is **17 rows of which 9 read `latest`**, so over half are
  not pins at all. Expo, and N-023's unwatched _"or sooner if Slint bumps accesskit"_ arm, are two
  members of one class that has no mechanism. **Keeping it off this map is deliberate**: this map
  is syntek-base's own open items, and a twenty-technology tracking design is an epic with its own
  frontier, not a row on someone else's.

**Round 4, and what the node finally cost.** Sam took the seeded-map option (`MAP-UPSTREAM-TRACKING.md`,
`Status: Seeded`, frontier deliberately empty) and **declined an ADR outright** — _"no ADR in this
project template"_. That refusal is now doctrine at `../15-DECISIONS/CLAUDE.md`, because the offer
had just been made in good faith and would be made again: this repository authors **no** ADRs of
its own, only the `ADR-000-TEMPLATE.md` scaffold a generated project uses. Final write set: eight
files, none of them on the queued sessions' surfaces.

- **The node shrank twice under measurement and both shrinkages were the useful part.** Charted as
  three missing things, it had one; the `copier update` safeguard Sam asked for turned out to be
  **already built and better than proposed** — `template-update.sh` previews by default, clones to
  a scratch directory, refuses `--apply` on predicted drift without `--force-deps`, and already
  carries a conditional pre-apply warning. **One line was genuinely missing**, the post-apply
  instruction to run the suites, which its sibling `dependencies/update.sh:85` has and it did not.
  Two sibling scripts, one habit, absent from the one with the larger blast radius.
- **The general case was refused a node here, and that is the reusable part.** _Fold it in_ was
  available and would have produced a twenty-technology design inside a sitting convened for one
  of them. **A map is the right size for that; a node is not** — and this map's job is
  syntek-base's open items, not every epic they imply.

**N-020 — the blocker is live, the type is right, and the map was one edit away from recording
both backwards.** A handoff carried three claims here on 16/08; two are refuted and the third is
half true. Re-measured at `840acb3`:

- **"The blocker is false" — refuted, and the dates that argued it are exact.**
  `how-to/src/SERVER-ARCHITECTURE/` was added whole at `7cb6040`, 01/08/2026 22:47, and the gap
  naming it is dated 09/08 — eight days by its own heading, **ten by commit** (`ce259df`, 11/08).
  But `NIXOS-HANDOFF.md` does not **state** the contract, it **disclaims** it: `:131-136` consign
  _"the deploy script + CI deploy key"_ and _"post-deploy service checks"_ to the deploy repo and
  say provisioning mechanics are _"deliberately **not** specified anywhere in this repo"_; the
  artefact-to-module map at `:48-52` is an explicit **TBD** awaiting `/scale-planning`; and the
  whole file carries a _"Template skeleton … do not treat the placeholder values as real"_ banner
  at `:5-8`. `rollback.sh` and `health-check.sh` are named **nowhere** in the directory. All four
  were already present at `13de9b9`, the revision in force on 09/08 — **the gap's author had this
  text in front of them.** A file existing is not a contract existing, and that is the whole error:
  the finding measured the **birthday** and inferred the **contents**.
- **"Typed wrong" — refuted; `task` stays.** Charted as `BUILD-OPERATE-SEAM.md:25` contradicting
  `.claude/skills/cicd/SKILL.md:4-5`. Measured, they carve the seam at different levels — the
  deploy repo implements the server/edge contract (Nix modules, vhosts, units), the `cicd` skill
  owns the three scripts **in this repo** — which `how-to/src/TEMPLATE-GUIDE/13-DEPLOYMENT.md:20-28`
  states outright: _"This repository specifies. The deploy repository implements."_ An unwritten
  artefact with a named owner is a `task`, not an ownership question.
- **The real obstacles, two of three charted.** **(a) No image-publish workflow** — 35 files in
  `.github/workflows/` and not one **publishes** an image. **Corrected 16/08/2026: this once read
  "builds or pushes", and the build half is false** — `claude.yml:411` and `test-api.yml:75` both run
  `docker compose -f $COMPOSE_FILE build django-test`, under steps named _Build django-test image_
  and _Build images_. The charted claim rested on a `grep 'docker build'`, which cannot match
  `docker compose … build`: **an absence produced by the wrong pattern**. The push half holds
  (`grep -rn 'ghcr\|docker/build-push' .github/workflows/` returns nothing), so the consequence for
  `deploy.sh` is unchanged and the blocker stands. While
  `code/src/docker/docker-compose.prod.yml:17` pulls `ghcr.io/…/django:${IMAGE_TAG:?…}` with **no
  `build:` fallback** and `13-DEPLOYMENT.md:85` asserts a publish that does not exist.
  **(b) No health route** — `code/src/django/config/urls.py:16-18` registers the admin alone, and
  `health-check.sh` is equally absent, so there is neither an endpoint nor a caller.
  **(c) "No non-prod target" is false** — `docker-compose.staging.yml:16-19` is a complete
  buildable environment with its own `Dockerfile.staging`, `entrypoint.staging.sh`,
  `.env.staging.example` and `config/settings/staging.py`. The real third is **no deploy automation
  at all**: `code/src/scripts/deployment/` holds `CONTEXT.md`, `CLAUDE.md` and `reports/`.

**N-021 — the blocker is real and was misnamed, which is a different repair from deleting it.**
`code/src/docker/docker-compose.test.yml` **is** self-contained — Postgres, Valkey, Django and
nginx from public images, every variable defaulted inline, `entrypoint.test.sh` holding Gunicorn up
behind nginx — so it is more than a run-and-exit harness. It still cannot host a rehearsal: its
Postgres is `tmpfs`-only, `config/settings/test.py` swaps Valkey for `LocMemCache` so the cache
container is never touched, passwords are MD5, and there is no seeded superuser.

**What actually blocks it is the subject system.** `code/docs/security/MONITORING-AND-INCIDENT.md:69-71`
names four recoveries and **three have nothing to be performed against**:

| Runbook                           | Subject in this tree                                                                                                   |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Account compromise via `admin_db` | **Absent** — `DATABASES` declares a single `default` alias (`config/settings/base.py:78-84`), no token model           |
| Audit-log tampering               | **Absent** — no models, no migrations, the string `audit` in no `.py` in the tree                                      |
| Emergency key rotation            | **Absent** — `apps.core.encryption` does not exist; `cryptography` is declared (`pyproject.toml:51`), imported nowhere |
| Valkey cache compromise           | **Present** — `CACHES` wired at `base.py:91-101`, a `cache` service in the dev and test stacks                         |

- **Precision matters on the third row.** "Not wired" is right; "not declared" would be wrong.
  Likewise two of the three have a generic substrate — `django.contrib.auth` and `sessions` are
  installed (`base.py:29,31`), `SECRET_KEY` exists (`base.py:23`) — but the **named mechanisms**,
  admin-token revocation via `admin_db` and versioned field-encryption keys, are the absent part.
- **So the blocker column changes rather than clears.** A session reading "a non-prod environment"
  goes looking for infrastructure; the thing to wait for is an application layer.
- **The sentence above was challenged on 16/08/2026 and the challenge was refuted — no edit.** A
  challenger reported _"passwords are MD5 was false when written; it is `scram-sha-256`"_. It had
  changed the subject: this passage's running subject is `config/settings/test.py`, and `:15` reads
  `PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]`. The `scram-sha-256` is
  `docker-compose.test.yml:17`'s **Postgres host auth**, a different mechanism —
  `git log -p --all -- code/src/docker/docker-compose.test.yml | grep -ci 'md5'` returns **0** across
  that file's entire history, so it was never the subject. Recorded rather than dropped, because a
  **confident one-clause refutation that quietly changes the subject** is a failure shape this map
  has not previously named.

**N-023 — the trigger has two arms, and the second is not merely unwatched but unrecognised.**
`code/src/rust/deny.toml:31` gates the two `quick-xml` DoS suppressions (`RUSTSEC-2026-0194` and
`-0195`, reached only through Slint's AccessKit stack) on a date **and** an event: _"Re-check
02/11/2026, **or sooner if Slint bumps accesskit**"_. The event arm exists in that one comment and
nowhere else — `CHANGELOG.md:684` and `RELEASES.md:2244` record only the date, and the owning
doctrine `code/docs/rust/SUPPLY-CHAIN.md:129` asks only for _"a re-check date"_.

- **Nothing watches either arm.** No Dependabot or Renovate config in the tree; the sole scheduled
  workflow, `.github/workflows/audit-deps.yml` (`cron: "0 6 * * *"`), sweeps JS and Python only;
  and `audits/dependency-drift.sh` compares an **incoming template** against this project, never
  upstream crates.io.
- **The gate itself is live and clean** — `syntax-rust.yml:94` runs `rust/audit.sh` on any
  rust-path change, reproduced at HEAD (`advisories ok`, both ignores still matching). But
  cargo-deny's only passive signal for a stale ignore is a non-blocking
  `warning[advisory-not-detected]`, which can appear **only after somebody has already regenerated
  `Cargo.lock`** — the very act the second arm asks a human to notice. The instrument fires after
  the moment it is meant to catch.
- **Found alongside, uncharted:** `code/docs/rust/SUPPLY-CHAIN.md:42` still describes the policy as
  _"empty `ignore` … An empty ignore list is the default state"_. False at HEAD, and it is the
  guide that owns the rule.

**Batch E's collisions — the charted pair does not exist and three real ones do.** The handoff
carried "N-022 × N-031 share 10 files", anchored at `lefthook.yml` and
`how-to/workflows/06-quality-gates/*`. Neither anchor is Batch E: both sit in **N-036's** own file
table (`lefthook.yml:25` and `how-to/workflows/06-quality-gates/STEPS.md:125`), a **Batch D** node
blocked on N-035. The string "10 files" appears nowhere in `01-FEATURE-MAPS/`, so the count's origin is
unrecoverable — most likely that table, read as if it belonged to the node beside it. Measured, the real overlaps are:

| Collision                                               | Shared surface                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **N-020 × N-031 × N-044**                               | `how-to/docs/INCIDENT-PRACTICE.md:199-206` — one passage names the absent deploy scripts (`:200`), cites the excluded register (`:203`), and names `health-check.sh` (`:201`). **Corrected 16/08: N-021 is not on this passage** — the map's own verdict at MAP:1224-1231 says so and this row had not been updated; N-044 was absent and belongs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| **N-021 × N-031**                                       | `code/docs/security/MONITORING-AND-INCIDENT.md:69-73` — the same paragraph announces the four runbooks and carries the dangling citation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **N-026 × N-037**                                       | `.claude/skills/stack-django/SKILL.md:168,302-308` — must be sequenced together                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ~~**N-031 × N-036**~~ _(dropped)_                       | ~~`.claude/hooks/CONTEXT.md` · `how-to/src/TEMPLATE-TOKENS.md`~~ — **N-036 settled 16/08/2026**, so this is no longer a live collision. Row kept struck rather than deleted, because the shared files are still N-031's evidence                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ~~**N-031 × N-050 × N-057**~~ _(discharged 21/08/2026)_ | `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md` — **added 16/08, widened the same day, and closed by sitting 2.** As charted: `:92` cites the excluded `TEMPLATE-GAPS.md` and `:99` cites the per-project node id `N-029`, **both N-031's**; `:94` carries the dead `3.2.2`, **N-050's**, and _"promotion target"_ in the same sentence, **N-057's** — as are the required-set table at `:103-113` and the falsehoods at `:57-61`. `:106`'s `Hold` row inside that table is **N-030's residue**. **The row was right about the file and wrong about the count: it was three nodes and _three_ residues.** N-036 (settled 16/08) had worked the same sentence at old `:86` = today's `:92`, repaired the inverted claim and left the excluded citation it was standing on; and N-031 itself closed with row 1 half-repaired. All discharged together — `:92` marked, `:94` and `:99` rewritten, the table deleted, the `Hold` row flipped into the ruleset. **The lesson the row exists for held and needed one more clause: none may fix another's half in passing, _and a settled node's row is not proof its half was fixed_**            |
| ~~**N-051 remedy × N-058**~~ _(discharged 22/08/2026)_  | `.claude/skills/git/SKILL.md` — **charted 21/08/2026, at the moment sitting 2 edited the file.** N-051's remedy rewrote `:61-62` (a paraphrase of the version file set, short by two); **N-058 owns the bare `pre-pr-check.sh` invocation** in the same file, now at **`:76`** — re-anchor, it moved +1 in this sitting. Fourteen lines apart, and the sitting plan called sittings 2 and 5 disjoint surfaces. They are not **Discharged by sitting 5, and the row earned its keep**: measured at settlement, N-051's remedy occupies `:61-63` — **three lines, not the two the row recorded** — and N-058 owned `:71-77`, a separate H2 section twelve lines below. The two never touched, but the anchor it warned about had already moved once, which is why the sitting re-measured before editing rather than trusting either number                                                                                                                                                                                                                                                                                                           |
| **N-051 remedy × N-049** _(sitting 2 → 6)_              | `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` — **charted 21/08/2026, same cause.** N-051's remedy rewrote `:25-32` (a fourth restatement of the file set, omitting `RELEASES.md`); **N-049 owns the contradicting comment-rule scope**, cited at `:124-129` and `:133-136` and now at **`:126-131`** and **`:135-138`** — every line below `## 4. Code-comment standards` (`:111`) moved **+2** in this sitting. The file is also the sharpest instance of the class N-051 settled: `:19-21` deletes a restated increment table as _"a drift site, not a convenience"_, and eleven lines later restated the file list                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ~~**N-020 × N-048 × N-054**~~ _(discharged 21/08/2026)_ | `code/docs/logging/HEALTH-CONTRACT.md` — **charted 21/08/2026, in triage for sitting 1 rather than by any pass that read these nodes.** N-054 owns `:32` (a `GET /metrics/` row nothing serves) and `:34` (four readiness dependencies against two probed); N-048 owns `:95` (`job_name` spelt `-web` where the owner it names says `-backend`) and `:134` (the sentence disclaiming ownership); **N-020's residue bullet independently names `:32`**, so two open nodes already carry the same line and neither row said so. **Sequence N-054 before anything writes `health-check.sh`** — a caller written to that table probes a 404, which N-020 and the map both state and neither had connected to the file's other open node. **Closed by sitting 3, which took all three in one pass and found the sequencing constraint moot in the outcome rather than in the plan**: N-020 closed as SL-2, so nothing writes `health-check.sh` at all. The row's real value was that it put three nodes on one file before any of them was opened — the first collision on this map to be charted **before** a sitting rather than discovered inside one |
| **N-046 × N-055** _(within Batch B)_                    | `code/src/scripts/syntax/format.sh` · `lint.sh` — **added 16/08; re-anchored and widened to THREE files 18/08.** N-046 works `lint.sh:259-266` for the unscoped-markdownlint bullet; N-055 cites `lint.sh:256-276` for the skipped-leg bullet, and both nodes point at the **same success string** in `format.sh`. The ranges nest. A fix to either that edits the success line without the other's evidence in view will look complete and close half the class. **`b4ed0b9` moved every anchor in this row and added `check.sh` to it** — it now shares `log()`, `$TMPFILE`, the `--path` drop block and the default narrowing with both. N-046's `--no-globs` remedy would land at `lint.sh:267`, inside the `if host_has_pnpm` limb whose `else` **is** N-055's member                                                                                                                                                                                                                                                                                                                                                                          |

- **`INCIDENT-PRACTICE.md:206` re-scopes N-020 outright** — _"rollback during an incident is
  **manual, via the `<%DEPLOY_REPO%>` runbooks**"_ — which is the second document, after
  `NIXOS-HANDOFF.md`, putting the script on the far side of the seam.
- **N-022 is takeable alone, but only mobile-scoped — and the first wording of this bullet was
  wrong.** It read _"its file set … appears in no other node's evidence"_, listing
  `how-to/workflows/07-dependency-updates/` and `code/src/scripts/dependencies/update.sh` among
  five. **Both are claimed by N-036's own table at `:887-888`**, and the dead `uv` premise is live
  in all four of those files (`update.sh:13-14`, `07/CLAUDE.md:33`, `07/CONTEXT.md:31-32`,
  `07/STEPS.md:76`). They are also **N-010's execution target**, queued in the other session. So the
  claim was false in the same pass that corrected four other false claims — **written from a
  synthesis rather than measured**, which is this map's defect class arriving in the paragraph that
  names it. N-023 is genuinely disjoint but date-gated to 02/11. **This still contradicts the 16/08
  handoff, which named N-037 as the one uncoupled node**; it is coupled to N-026.
- **Restricting N-022 to the mobile-gated files is doctrine, not a dodge, and that is measurable.**
  `how-to/workflows/07-dependency-updates/` contains **zero** occurrences of `mobile`, `expo` or
  `react-native` across all four files, and `dependencies/update.sh` handles exactly three
  ecosystems — Python, JS, Rust (`:6`, `:134`, `:206`, `:231`). Both surfaces are **ungated**, while
  `code/src/mobile/` and `.claude/skills/stack-react-native/` are gated on `INCLUDE_MOBILE`
  (`copier.yml:101`, `:142`) — so writing an Expo cadence there would ship a mobile obligation into
  every **web-only** generated project. Two guides already route the rule to its owner:
  `code/docs/MOBILE-CODING-PRINCIPLES.md:178-180` and
  `code/docs/data-structures/TYPES-TYPESCRIPT.md:246-247`, both naming `code/src/mobile/CLAUDE.md`.
- **And the node is a third smaller than charted.** `how-to/src/TEMPLATE-GUIDE/02-STACK.md:136-137`
  already states the **cadence** (_"roughly three releases a year"_) and the **owner** (_"the
  template takes on tracking Expo's SDK cadence"_). Only the **trigger condition** is genuinely
  absent, and the house shape for one exists twice — `MOBILE-CODING-PRINCIPLES.md:186` and
  `TYPES-TYPESCRIPT.md:250`. **Uncharted, and it rides with this node:** `02-STACK.md` ships and is
  **not** gated on `INCLUDE_MOBILE`, so its Expo passage already dangles in a web-only project.
- **N-036's table carries one wrong row, and striking it does _not_ clear the overlaps.**
  `code/src/mobile/CONTEXT.md` is listed there under the dead `uv` premise and carries no `uv`, no
  `uv.lock` and no token rationale — its only "absent by design" is line 39, about `ios/` and
  `android/` under Expo CNG. But the two real overlaps above stand regardless, so this is a table
  correction, not a release. **The same table also under-counts `06-quality-gates` by two** —
  `06/CONTEXT.md:56` and `06/CLAUDE.md:36` carry the premise and are unlisted.
- **Cross-session hazard, charted nowhere and the sharpest thing this pass found.** `uv.lock` is on
  disk untracked (299 KB, `.gitignore:16`), so `update.sh:138`'s `elif [[ -f uv.lock ]]` is **true
  in this working tree** and workflow `07` Step 2 run with `--apply` reaches `:145 uv lock
--upgrade` — **regenerating the exact artefact N-035 is convened to decide about**. N-010 executes
  workflow `07` start to finish. **Whoever takes N-010 must run it in check mode only until N-035
  lands.** Neither node's chart mentions this.

**N-037's three charted claims were fixed 16/08/2026 by N-010, and the node stays open on the
floor beneath them.** All three are corrected: the vendored-Alpine path became "self-hosted under
`static/vendor/` when first used", the invented 51-route axe scan became a pointer to
`test_e2e_a11y.py` with its empty-`PAGES` baseline stated, and the strict-type-hints claim became
the measured `standard`. **What N-010 also proved is that this node's class is wider than
"skills"**: the same false `strict` claim was live in `how-to/workflows/06-quality-gates/STEPS.md:52`
and in `stack-django`'s own frontmatter `description` — a **fourth and fifth** site, in a document
type the node never covered. Both fixed with the rest. The node therefore keeps its remaining
scope — the ~ten unaddressed assertions below, plus the `stack-django:168,302-308` half still
bound to N-026 — and should be re-typed from "two skills, three claims" to "shipped instructional
documents assert things about a tree nobody checks" when it is next taken.

**The remainder was measured 16/08/2026 and it is an order of magnitude above its charted size.**
The floor read _"~ten unaddressed assertions"_ in one skill file. Measured across the whole shipped
instructional corpus: **87 backticked citations into the Django source tree do not resolve, across
42 of 270 shipped instructional documents.**

**Re-measured 18/08/2026 and it has grown by a third in two days — 87 → 117 sites, 42 → 62 files.**
The node is now the largest open item on this map by site count, and it grew while nobody was
working on it, which is the fact worth carrying rather than the number.

| Reading                                    | 16/08 | 18/08   | Notes                                                                                               |
| ------------------------------------------ | ----- | ------- | --------------------------------------------------------------------------------------------------- |
| Unresolved **sites**, shipped population   | 87    | **117** | Backticked `code/src/django/…` citations that do not resolve, with `is_exempt()`'s trees subtracted |
| **Files** carrying at least one            | 42    | **62**  | Denominator is the whole tracked `*.md` corpus, not 270                                             |
| Unresolved **unique paths**                | —     | **50**  | Never measured before; the repair surface is far smaller than the site count suggests               |
| Unfiltered sites (artefact trees included) | —     | 135     | Not the node's population — `is_exempt()` exempts those trees deliberately                          |

- **Carry the command, not the number** — this map's own standing rule, and this node is one of the
  three that earned it. Regenerate with:

  ```bash
  git grep -nE '`code/src/django/[^`]+`' -- '*.md' \
    | grep -vE '^(CHANGELOG|RELEASES|VERSION-HISTORY)\.md:|^how-to/src/TEMPLATE-GUIDE/|^handoffs/|^\.copier/|^research/|^learning/|^project-management/src/01-FEATURE-MAPS/|^code/docs/cloudinary/|^\.agents/'
  ```

  then drop every citation whose path exists. The exclusion list is `doc-references.sh:85-104`'s
  `is_exempt()` transcribed — **if that function changes, this number changes with it**, which is
  the coupling to N-031 restated as an arithmetic fact rather than a scheduling preference.

- **50 unique paths against 117 sites means the repair is roughly 2.3 citations per broken path.**
  Nothing had measured that ratio, and it moves the remedy: this is not 117 individual judgements
  about what a template may forward-voice, it is **50**, most of them repeated. The two heaviest
  files are `project-management/src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` and
  `code/docs/FRONTEND-CODING-PRINCIPLES.md` at **nine sites each**.
- **One missing `case` hides all of them.** `code/src/scripts/audits/doc-references.sh:243-249`
  **— re-anchored 18/08/2026 to `:252-258`, a drift of nine.** It
  carries no `code/src/django/*` arm, so every claim about that tree is skipped. This map already
  adjudicated the skip itself as _"true as a fact, wrong as a defect"_ under _Refused_ — the skip is
  deliberate and carries its rationale. **What is new is the size of what it hides**, which nothing
  had measured. The remedy is one case plus a decision about what a template may legitimately
  forward-voice, and that decision is why the node is not merely mechanical.
- **The class spans five skill files, not the charted two.** `git grep -nE
'apps\.marketing|apps/marketing|django/components' -- '.claude/skills/*'` returns **17 lines across
  five files** — `stack-htmx-templates` 11, `frontend` 2, `seo` 2, `notifications` 1, `stack-rust` 1
  — against `code/src/django/components/`, which does not exist.
- **One `strict` claim is still live and the map records it as fixed.** `git grep -n 'strict type
hint'` returns exactly one hit, `.claude/skills/stack-django/SKILL.md:6`, the frontmatter
  `description`. The paragraph above says _"Both fixed with the rest"_ — **that is wrong for the
  frontmatter**, and this is the correction. `stack-django/SKILL.md:31` was proposed as a second
  live site and **refused**: it is a table-of-contents row whose target section states the truth at
  `:260-262`. A nav label pointing at a correct section is not a false assertion about the tree.
- **Sequenced with N-031 and ~~N-043~~, not after them — and N-043 settled 18/08/2026, so the
  batch is now two.** `doc-references.sh`'s exemption policy is the
  single common cause behind the remaining pair — `:88` hides eight of N-031's citers, the missing
  `code/src/django/*` arm hides all ~~87~~ **117** here, and the script's own header at `:26` repeats
  the falsehood N-043 charts. **Settle the exemption policy once and three nodes shrink together**,
  which is a batching argument this map did not previously make.
- **All three anchors re-verified at HEAD 18/08/2026, and only one had moved.** `:26` (the header
  falsehood) and `:88` (`is_exempt()`'s `how-to/src/TEMPLATE-GUIDE/*` arm) both hold **exactly**;
  the allowlist `case` moved `:243-249` → **`:252-258`**. **One file, three edits, two adjacent
  `case` blocks** — which is why these three cannot be worked concurrently even though the map
  batches them: each edit invalidates the others' line numbers, exactly as `84067c9` had to
  re-resolve fifteen anchors at non-uniform offsets of +52 and +64.

**N-045 — the request template a developer copies describes the wrong stack entirely.**
`code/src/tests/template-test.bru` is annotated end to end for **GraphQL**: it POSTs to
`/graphql/`, carries `body:graphql` and `body:graphql:vars` blocks, and its assertions advise
that "GraphQL always returns 200 even on errors" and to check `res.body` for an `errors`
property. This project serves **Django Ninja REST at `/api/`** and has no GraphQL surface, no
`/graphql/` route, and no GraphQL dependency. The file sits outside `api/` so the CLI never runs
it — which is precisely why it went unnoticed: nothing executes it and no audit reads it. It also
names four folders as the collection's structure (`api/auth/`, `api/users/`, `api/content/`,
`api/performance/`), none of which exists. **Typed `task`** — the stack is not in question, only
the document. Found while adding the collection's first real requests under N-010, which had to
ignore the template rather than copy it.

**A second failure mode, measured 16/08/2026 — a copied file breaks before it ever reaches the 404.** `template-test.bru` uses four variables and **`{{some_variable}}` (`:60`) is defined
nowhere**, so a copy fails at variable resolution, not at request time. Three counts in the
surrounding prose also overstate: the file is **96** lines, `code/src/scripts/tests/` holds **8**
scripts (11 counts `CLAUDE.md`, `CONTEXT.md` and `reports/`), and `api/environments/` holds **5**
environments. And the node's own framing needs softening: this project does not yet serve Django
Ninja REST at `/api/` either — `config/urls.py:20-23` mounts `apps.health.urls` and the admin
alone, and `git grep -n NinjaAPI -- 'code/src/django/*'` returns nothing, so **the corrected
template's only live verification target today is the `/health/` contract**. One twin fossil rides
with it: `code/src/scripts/tests/api.sh:155-157` carries the same "not-yet-implemented `user(id)`
endpoint" text as `test-api.yml:115-121`, and both still pass `--exclude-tags manual,wip` against a
collection that carries no tags.

**N-037 SETTLED 20/08/2026 — see _Resolved decisions_. What it left behind is below, and none of
it is a node.** Sam's call on the day was to resolve rather than chart, so the residue is recorded
here as fact and carried nowhere else:

- **Direction B is declared, not built.** Nothing reads `copier.yml`'s `_exclude` list and compares
  it against citations, so a copier-excluded path cited **without** `doc-references: template-only`
  is green today. `FORWARD-VOICE.md` Section 5 says so in terms, and `--self-test` prints it on
  every run rather than leaving a reader to infer it. **That half is N-031's**, still open.
- **Dotted module paths have no gate at all.** `doc-references.sh` resolves backticked _slash_
  paths only, so `apps.core.crypto.make_email_token` and its kind passed every run ever made while
  being false. The false claims were fixed by reading; a checker would need the import graph, not a
  filesystem test, and was deliberately not smuggled into the same change.
- **A resolving parent hides every false child.** `apps/core/` ships, which is exactly why its
  invented children survived. No gate on this map addresses that shape.
- **On a host lacking Slint's system libraries the Rust type gate reports `could not run`, not
  clean** — correct under `GATE-REPORTING.md`, but nobody should read that `3` as close enough to
  green. CI installs `libfontconfig-dev`, so it is a local blindness only.
- **The N-026 half was left untouched on purpose.** `stack-django:168` and its file tree stay bound
  to that node; `NINJA-CONVENTIONS.md` was not opened.

**N-037 — a skill is a shipped document too, and nothing checks what one claims about the tree.**
Routed here by `MAP-ABSENCE` and each claim re-measured on 16/08/2026:

| Claim                                                                                          | Measured                                                                                                                                                                           |
| ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `stack-htmx-templates/SKILL.md:33` — Alpine "vendored at `static/vendor/alpine/alpine.min.js`" | `code/src/django/static/` holds `CONTEXT.md`, `CLAUDE.md` and `js/observability.js`. **No `vendor/` at any depth**, and no htmx or Alpine file anywhere under `code/src/django`    |
| `stack-htmx-templates/SKILL.md:169` — "keep the 51-route axe scan"                             | ~~`config/urls.py` is the **only** `urls.py` in the tree; there are no app route modules~~ **Evidence dead 18/08/2026** — `apps/health/urls.py` ships, so there are two. See below |
| `stack-django/SKILL.md:259` — "all Python code uses strict type hints"                         | `code/src/django/pyrightconfig.json` and `pyproject.toml:166` **both** say `typeCheckingMode = "standard"`                                                                         |

- **Row 2's evidence died and its finding did not, and the map already held the refutation.**
  Re-measured 18/08/2026: `find code/src/django -name 'urls.py'` returns **two** —
  `config/urls.py` and `apps/health/urls.py`. The stated evidence _"the only `urls.py` in the
  tree"_ is therefore false. **This map knew:** N-020's own entry records `config/urls.py:21`
  reading `path("", include("apps.health.urls"))` and `apps/health/` shipping four modules, and
  nobody propagated it across the two nodes. The **finding** stands — two route modules is not
  fifty-one — but a session opening this node on the written evidence would have been refuted at
  its first command. Rows 1 and 3 hold exactly: no `vendor/` at any depth under
  `code/src/django/static/` (which holds `CONTEXT.md`, `CLAUDE.md` and `js/observability.js`), and
  both `pyrightconfig.json:7` and `pyproject.toml:166` still say `"standard"`.
- **The `pyrightconfig.json` half of the routed claim was wrong and is refused.** `MAP-ABSENCE`
  implied the citation dangles; the file exists at `code/src/django/pyrightconfig.json`. Only the
  **mode** is false. Charting the overstatement would have sent a session looking for a missing file.
- **These are Batch E from the reader's side.** The document does not route to something that does
  not exist — it _describes_ something that does not exist, which fails the same way and later: the
  reader believes the tree has a vendored Alpine and 51 routes, and only finds out by looking.
- **Typed `task`, and the general question is deliberately left out of it.** Whether anything could
  check a skill's claims about the tree is real, unsettled, and much larger than three lines; it is
  in fog of war, not smuggled into a task node.

**Corrected 16/08/2026 — the row was wrong twice, and its own evidence table said so.**

- **"Three shipped skills" against an evidence table naming two.** `stack-htmx-templates/SKILL.md`
  twice (`:33`, `:169`) and `stack-django/SKILL.md` once (`:259`) — **three claims, two skills**,
  and `MAP-ABSENCE.md:500-501` agrees at two rows. A session reading the row goes hunting for a
  third skill that does not exist, which is **the exact fault this node congratulates itself for
  avoiding four lines above** when it refused to chart the `pyrightconfig.json` overstatement.
- **`Blocked by: none` was false.** `stack-django/SKILL.md:168` and its file tree at `:302-308`
  assert `apps/<app>/api.py`, `services/` and `policies.py`; `code/src/django/apps/` holds `core/`
  alone and neither file exists at any depth. **Those lines are N-026's subject verbatim** —
  whether they are false claims to delete or correct conventions awaiting a scaffold is not
  answerable until N-026 lands. The `stack-htmx-templates` half is unblocked and could go alone.
- **The claims table is a floor, not a total.** The same two files carry roughly ten more
  present-tense assertions of absent things, none charted: `apps.marketing` at
  `stack-htmx-templates/SKILL.md:30,36,37,97,108,111,158,160`; `code/src/django/components/` at
  `:31,:63`; `static/css/marketing.css` at `:88`. Measured — no `components/` directory,
  `marketing` absent from `config/settings/base.py`, and `static/` holds `CLAUDE.md`, `CONTEXT.md`
  and `js/observability.js`.
- **One charted claim needs a different remedy than the node implies.** The 51-route axe scan
  **exists** and is deliberately empty: `code/src/django/tests/e2e/test_e2e_a11y.py:108`
  parametrises over `PAGES`, and its docstring at `:8-10` reads _"At baseline `PAGES` is empty and
  every scan skips. That is the correct behaviour for a template with no public routes."_ The line
  is a correct instruction carrying a false **number**, not a line to delete — so the _Measured_
  cell above ("no app route modules") is true but points at the wrong repair.
- **Proposed `task` → `grilling`, not applied — Sam's call, put to him 16/08.** The node excludes
  the _general_ question and misses the **local** one it cannot dodge: which sentences in a
  stack-reference skill **describe this tree** and which **prescribe the project built from it**.
  The three charted lines have three different remedies (delete · fix the number · choose between
  editing the skill and setting `typeCheckingMode = "strict"` at `pyrightconfig.json:7` and
  `pyproject.toml:166`), and each depends on that answer; the surrounding `apps.marketing`
  sentences cannot be triaged at all without it. **It is the same discrimination problem that types
  N-031 `grilling`** — _"the class is not 'any citation of an excluded path', and telling the two
  apart is the node"_. Two nodes, one problem, two types.

**N-031 is Batch E seen from the far side of generation — the citation resolves here and dangles
there.** `copier.yml` excludes `TEMPLATE-GAPS.md` by name (line 79) along with `LICENSE`,
`SECURITY.md`, `CONTRIBUTING.md`, `.github/scripts/` and `audit-template.yml`; `CHANGELOG.md`,
`RELEASES.md` and `.claude/MEMORY.md` are excluded but **seeded from `.copier/`**, so they exist
downstream and are not at issue. Three shipped files cite something in the first group:

| Citing file (ships)                                     | Cited (excluded)                                               |
| ------------------------------------------------------- | -------------------------------------------------------------- |
| `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md` | `TEMPLATE-GAPS.md` (SL-1), and separately `audit-template.yml` |
| `how-to/docs/skill-authoring/SHIPPING.md`               | `.github/scripts/`                                             |
| `code/docs/security/MONITORING-AND-INCIDENT.md`         | `TEMPLATE-GAPS.md` — **and wrong here too**                    |

**The third row carries both faults at once and is the sharpest specimen.** It tells the reader
_"The gap is recorded in `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`"_ about the four unwritten
security runbooks — but that entry **moved onto this map as `N-021` on 13/08** and
`TEMPLATE-GAPS.md` now holds no dated entries at all. So it is stale **here**, where the file at
least exists, and dangling **there**, where it does not. A citation of a register is a pointer to
a location, and a register that gets consolidated leaves every such pointer behind it.

**`doc-references.sh` is clean and structurally cannot see any of them** — it asks whether a
citation resolves **here**, and every one of these does. The check that would catch it is
"resolves in a generated project", which is a different question against a different tree.

**Two things keep this from being a sweep.** First, `code/docs/discoverability/CONTEXT.md` records
a **deliberate** repo-wide dangle — a copier-gated surface file legitimately absent on a project
that did not opt in — so the class is not "any citation of an excluded path", and telling the two
apart is the node. Second, the `git/PR-AND-REQUIRED-CHECKS.md` line is **new, added 15/08 by
N-011's session and moved there by N-029's split on 16/08**,
which means the class is still being produced rather than merely inherited.

**Corrected 16/08/2026 — the coupling to N-035 is one-way and conditional, and this table is a
floor.** A handoff carried "N-031 ↔ N-035 coupling, proven two-way". Re-measured by deleting
`TEMPLATE-GAPS.md` in a throwaway `git archive HEAD` clone and running the gate:

- **`doc-references.sh` does go red — exit 0 → exit 1, with exactly three `dangling path`
  violations**: `code/docs/security/MONITORING-AND-INCIDENT.md:73`,
  `code/src/django/apps/core/CONTEXT.md:61`, `how-to/docs/INCIDENT-PRACTICE.md:203`. **Only the
  first is charted here.** The other two are uncharted.
- **Two of the three sites this node names would not redden at all.**
  `git/PR-AND-REQUIRED-CHECKS.md:87` cites the **bare slashless token**, which Check 1 discards at
  `doc-references.sh:186-189` (`*/*) ;; *) continue ;;`), and `skill-authoring/SHIPPING.md` never
  cites `TEMPLATE-GAPS.md` at all — it cites `.github/scripts/`, as the table above says.
- **N-035 nowhere proposes deleting the file.** Its remedy is to settle SL-1 and SL-2 together, and
  `TEMPLATE-GAPS.md` remains the standing intake register per its own `## Adding a new gap`
  section. Both node rows read `Blocked by: none`. **So there is no two-way coupling**: direction A
  holds conditionally on a deletion nobody has proposed, and direction B fails outright — settling
  this node at its charted scope leaves the gate red on two sites it never listed.
- **The measured citer set is at least eight shipped files against this table's three.** Add
  `how-to/src/CONTEXT.md:31` and `how-to/src/TEMPLATE-GUIDE/{CLAUDE.md:25,39,52 · CONTEXT.md:11,54,59 · 15-TROUBLESHOOTING.md:332}`.
  That directory **left `_exclude` at 3.2.0** — pinned 18/08/2026 to **`f5fef31`**, 14/08,
  _"the guide ships with the project, and turns read-only when it does"_ — and only
  `TEMPLATE-GAPS.md` itself is named at `copier.yml:86`, so those three files now **ship**, while
  `doc-references.sh`'s `is_exempt` still exempts `how-to/src/TEMPLATE-GUIDE/*` as a **citing**
  file, an exemption written when that tree was template-only. **Three shipped citers invisible to
  the gate by a stale exemption.** Re-verified at HEAD 18/08/2026: the exemption arm is still there
  and the `:88` anchor **holds exactly**. Full statement of the shipping fact, and the `raw`-block
  consequence that makes it more than untidy, is in **N-043**; this node does not restate it.
- **"At least eight" was a floor and the floor was low — measured 16/08/2026 at 33 files / 77
  sites**, reproduced independently by two agents over the same pathspec, and roughly **25 files**
  after hand-discriminating the `how-to/src/CONTRIBUTING.md` false positives. **Stop carrying the
  number and carry the command**, because this node has now under-counted itself twice:
  `git grep -cE 'TEMPLATE-GAPS|audit-template\.yml|\.github/scripts|CONTRIBUTING\.md|CODEOWNERS'`
  over tracked files, with the excluded and non-shipping paths pathspec-excluded.
- **A whole class the table never named: `copier.yml` excludes itself**, and **41 shipped files
  cite it**. Every one of those sentences dangles downstream. That is larger than the charted set
  and belongs in the same grilling.
- **Anchors corrected 16/08/2026.** `copier.yml`'s `_exclude` spans **`:29-197`** and
  `TEMPLATE-GAPS.md` sits at **`:86`**, not `:79` — the map holds citations from both sides of
  `b20167b`, which added seven lines for the `/uv.lock` exclusion. The separate `:75-81` citation is
  **correct and was mis-flagged** during this pass: it points at the comment reading
  _"how-to/src/TEMPLATE-GUIDE/ SHIPS, deliberately"_. Also re-anchor `doc-references.sh:186-189` to
  **`:184-187`**.
- **The kill attempt on N-042 failed, and how it failed is the reusable part.** This node's own
  challenge declared N-042 _"dead at HEAD — no tracked `MACHINE-SPEC.md` citer remains"_. An
  unrestricted `git grep -n 'MACHINE-SPEC'` returns **12 hits across 6 files**; the challenger's
  carried an inherited `.github/scripts/` pathspec exclusion and returned two. **An absence produced
  by a filter is not an absence.** Both blockers stand.
- **This is why the node cannot be scheduled from its own table.** Which of those citations are the
  _deliberate dangle_ class carved out at `code/docs/discoverability/CONTEXT.md` is precisely the
  grilling question — so the file set has to be **measured at resolve time**, not read off a row
  written on 15/08.

**N-026 is textbook Batch E, and half of it closed itself while nobody was looking.** The facts,
stated in full rather than cited, because the map they came from is untracked and may not exist
in a future working tree: `code/docs/api-design/NINJA-CONVENTIONS.md` documents a mounted
`config/api.py` as the single `NinjaAPI` and a per-app `api.py` beside it. **Neither exists.**
`code/src/django/config/` holds `asgi.py`, `urls.py`, `wsgi.py` and `settings/` and nothing else;
`apps/core/` has no `api.py`; and `code/src/scripts/development/new-django-app.sh` emits
`models/`, `migrations/`, `CONTEXT.md` and `CLAUDE.md` — **no `api.py`, no `services/`**. Verified
14/08/2026.

What changed underneath the entry is that the **documentation half closed itself at `93037ba`**,
outside any node: `api-design/AUTH-AND-ERRORS.md` now states the absence in the guide —
_"`config/api.py` does not exist in the base template, so no handler ships"_ — which is also
where `N-015` deferred the six exception handlers to. So the guide no longer lies, and what
remains is a **scaffold** question with no owner and no trigger date: does `new-django-app.sh`
start emitting an `api.py` and a `services/` package, or is per-app API wiring something the
first endpoint story writes by hand? Both `N-015` and `MAP-NEGATIVE-SPACE`'s N-014 deferred it
to "the first story that needs an endpoint" — **which is a trigger nobody owns**, and is the
reason it is a node here rather than a note there.

### Unbatched

**N-027 settled 15/08/2026** — see _Resolved decisions_. It never earned a sixth class. Two nodes
arrived on 16/08 that fit none of the five either, and neither is promoted to one. **Two more
arrived the same evening from the challenge pass, and the count is now the argument**: four
unbatched nodes against five classes is no longer a residue, and the taxonomy question in fog of
war should be settled before a fifth joins them.

**Sitting 4 took the unbatched count from three to one, 22/08/2026** — N-047 and N-059 both
settled, leaving only N-039. The sentence above argued the taxonomy question should be settled
_"before a fifth joins them"_; the pressure it named has receded rather than been answered, and
the question is still open in _Fog of war_ with nobody scheduled against it. Recorded so the next
reader does not mistake a smaller residue for a decided one.

**Both counts in that sentence were wrong when written, and N-059 is the fourth — corrected
16/08/2026 by recounting the table.** The table held **three** rows (N-039, N-047, N-050) at the
moment the sentence claimed four: the fourth it counted was **N-040, settled the same evening**
and sitting in _Resolved decisions_. N-059 therefore takes the count to four, not five, and the
taxonomy question is reached one node later than the sentence expected rather than one earlier.
Recorded rather than rewritten, because the sentence is the evidence for the standing rule it
broke: **recount from the tables before writing a count, never from the last sentence that
carried one.**

| Node  | Decision                                                                                  | Type | Blocked by | Blocking a story? |
| ----- | ----------------------------------------------------------------------------------------- | ---- | ---------- | ----------------- |
| N-039 | **New.** Eight shipped guides carry leaked tool-call artefacts, and have since 01/08/2026 | task | none       | no                |

**N-040 settled 16/08/2026** — see _Resolved decisions_. It was discharged outside this map, by
eight version commits that landed 69 minutes after the map's last write. **N-047 and N-050 were
charted out of the same evidence**: settling the version state proved the number right and left the
method unexamined.

**N-047 — SETTLED 22/08/2026, sitting 4** (see _Resolved decisions_). The charted block is left
as written; its measurable premises all held at HEAD `2ff476e` — six split files in the `v4.0.0`
tree, `GIT-GUIDE.md` at 52 lines there, 0 content commits in `v4.0.0..v5.3.0`, and a window
exactly three tags wide. **The anchor had drifted** (`copier.yml:641` → `:694`) and **the
undecidable half was not undecidable** — see the row.

**N-047 — the migration advisory fires four tags after the break it warns about, and the
retroactive tagging method is why.** Charted 16/08/2026. This is **the only open node on this map
whose cost lands in someone else's repository.**

- **The break is already in the tree at `v4.0.0`.** `git ls-tree -r --name-only v4.0.0 | grep
'project-management/docs/git'` returns all six split files, and
  `git show v4.0.0:project-management/docs/GIT-GUIDE.md | wc -l` → **52**, the post-split index.
  The advisory warning about that split is keyed at `copier.yml:641`, `version: v5.0.0`.
- **So the window is real and it is three tags wide.** A downstream project running
  `copier update` to `v4.0.0`, `v4.1.0` or `v4.1.1` **receives the split content and the migration
  never runs**. Only a project crossing v5.0.0 sees the warning it no longer needs.
- **The cause is the method, not a typo.** `git log --oneline v4.0.0..v5.3.0 | grep -vc
'chore(version)'` → **0**: all 45 content commits sit inside the `v4.0.0` tree, because the eight
  bumps back-filled versions onto one frozen state. **Retroactive batch tagging cannot key a
  migration correctly by construction** — every migration written that way is keyed to when
  somebody noticed, not to when the break landed.
- **The migration script states its own stakes.** It records that `doc-references.sh` checks a
  cited path resolves and **has no opinion on whether the section inside it still exists** — the
  fog-of-war entry N-029 raised. So nothing downstream reports the break either.
- **Typed `grilling`, and the undecidable half is the published tags.** The facts are all
  measurable; the remedy is not. Re-keying the entry rewrites what a published tag meant; adding a
  compensating entry at `v4.0.0` keys a migration to a version already in the past; accepting and
  documenting leaves three tags carrying a silent break. **Which of those three, and whether the
  tagging method changes, is the node.** Unbatched deliberately — it is neither a false green nor
  split doctrine, and asserting a sixth class here would pre-empt the taxonomy question exactly as
  N-027 and N-039 declined to.

**N-050 — SETTLED 21/08/2026, sitting 2** (see _Resolved decisions_, and the headline correction
after that table). **The node's own asymmetry — the part it said it would die without — was
already dead when the sitting opened**, and had been killed by the commit that wrote the node.
`README.md:6` and `:248` read `6.0.0`; the census the node ran returned eleven lines at
`5d3c22f` and **only one of them was a stale assertion**, the site itself — the other two
non-map lines are `GAPS.md:35` and `:38`, which ship but are not claims about the current
version. `git grep -n -F '3.2.2' -- '*.md' ':!CHANGELOG.md' ':!RELEASES.md'
':!VERSION-HISTORY.md'` — and note it **measures its own map**, eight of the eleven being this
file's text, rising to all of them once the shipped site is deleted.

Charted below. Paired with **N-051** (_Batch D_) and settled with it — N-051 is the
cause, this is the site.

- `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md:94` — _"**The table below is the promotion
  target as of 3.2.2, not a census of everything unfiltered.**"_ Tracked, and **not** in
  `copier.yml` `_exclude` (all 58 entries read), so it reaches every generated project.
- **It was born stale, which is the part worth keeping.** The file was created by `8b66790` on
  16/08, when `3.2.2` was already ~40 commits behind. This is not decay; **a version assertion was
  written into a shipped guide about a repository that had already moved.**
- **The two `README.md` hits are not the same finding and must not be written as one.**
  `git grep -n -F '3.2.2' -- '*.md' ':!CHANGELOG.md' ':!RELEASES.md' ':!VERSION-HISTORY.md'`
  returns exactly three lines: `README.md:6` (badge), `README.md:248` (footer), and the line above.
  `copier.yml:37` excludes `/README.md`, so those two are **template-local**. **The asymmetry is
  the node** — it dies if written as "a couple of stale badges".
- **N-039's class, not N-040's.** Stale content in shipped prose with no gate detecting it, exactly
  as the tool-call residue is. `doc-references.sh` cannot see it: a version number is not a
  citation.
- **It collides with N-031 and N-057 on the same file — and with N-057 on the same sentence.**
  `PR-AND-REQUIRED-CHECKS.md` is already N-031's
  evidence (it cites the excluded `TEMPLATE-GAPS.md` at `:92`), and `:99` cites **`N-029` — a
  per-project map node id in a shipped guide**, which breaches this map's own closing rule that a
  shipped file may cite layering-system artefacts only. **That half belongs to N-031, not here**;
  say so on both rows so one file is not fixed twice or, worse, half-fixed by each.
  **N-057 (16/08) owns _"promotion target"_ in the very sentence whose `3.2.2` is this node's** —
  whoever fixes `:94` fixes it once, under both rows.

**N-039 — machine-authored residue in shipped prose, two weeks old and past ~~thirteen~~ 49
releases.**
Ten occurrences of `</content>` and `</invoke>` across **eight** files, all of which **ship**
(nothing under `code/docs/` is copier-excluded except the mobile-gated set):

`RENDERING.md` (2) · `api-design/NINJA-CONVENTIONS.md` (2) · `api-design/AUTH-AND-ERRORS.md` ·
`api-design/API-DOCS.md` · `rendering/PITFALLS-AND-EXAMPLES.md` · `rendering/CONTEXT.md` ·
`rendering/CLAUDE.md` · `rendering/TEMPLATES-AND-INTERACTIVITY.md`

- **`MAP-ABSENCE` dated it to `35eeb12` (13/08). That is wrong and the correction matters.**
  `git log -S` puts it at **`6dbec52`, 01/08/2026** — the 0.6.0 → 0.7.0 code-guide rewrite. It is a
  fortnight old, not three days, and it has survived every release since. The inherited date would
  have framed it as fresh breakage from a known session; it is neither.
- **Its own headline number was wrong too, and unlike N-040's it was never right — corrected
  16/08/2026 by the challenge pass.** The row read _"past thirteen releases"_. Measured:
  `git tag --contains 6dbec52 | wc -l` → 50 of 56 tags, `v0.7.0` the earliest, so **49 releases
  have followed** the residue commit and roughly 41 had at charting. A challenger reported the 50
  and still marked the claim _holds_ — a verdict contradicted by the reporter's own output, and the
  sharpest instance of the standing lesson found in that pass.
- **Nothing looks for it.** Neither `template-slop.sh` nor `copy-slop.sh` mentions `invoke`,
  `content>` or any tool-call token. `doc-references.sh` cannot see it — it is not a citation.
  The class is _transcript residue_, and this repository has no gate for it despite two audits whose
  names suggest they would.
- **Unbatched on purpose.** It resembles Batch B — a tree full of green audits, none of which was
  ever going to look — but the defect is not a gate reporting falsely about its own subject. Naming
  a sixth class here would pre-empt the fog-of-war question, which is exactly what N-027 declined to
  do. It is written down as evidence for that question instead.
- **The fix is trivial and the node is not the fix**: delete ten lines. What is worth a decision is
  whether a one-line grep joins the audit set, and that rides with the taxonomy question.

**N-059 — SETTLED 22/08/2026, sitting 4** (see _Resolved decisions_). The charted block is left
as written and **every mechanism claim in it was re-driven rather than inherited** — the 2×2 on
pinned lefthook **2.1.10** reproduced exactly. **Three of its four anchors had drifted**:
`CHANGELOG.md:263` → `:357` and `VERSION-HISTORY.md:21` → `:24`; only `lefthook.yml:116-118`
held.

**N-059 — a shipped comment bans the glob dialect four live legs in the same file rely on, and
the real fault is order-sensitivity nobody has named.** Charted 16/08/2026. The remedy it
justifies is right; **every reason given for it is false**, and the true one is a sharper hazard
than the invented one.

- **"lefthook does not expand braces" is false, and the file disproves itself a hundred lines
  above.** `lefthook.yml:118` states it flatly; `:5` (`*.{js,mjs,cjs}`), `:18` (prettier), `:84`
  (`*{CONTEXT,CLAUDE}.md`) and `:14` (the mobile leg) are live gates that cannot fire without it.
  Driven through the pinned binary — `node_modules/.bin/lefthook version` → **2.1.10**, and
  `git show a05b1c7:pnpm-lock.yaml` resolves the same **2.1.10**, so this is the engine the claim
  was written against, not a later one — **all four fire**.
- **"Silently matched nothing here" is false by half, and the half that matched was the guard
  doing its job.** The exact quoted pattern `how-to/src/{TEMPLATE-GUIDE/**,TEMPLATE-TOKENS.md}`
  **fires on `how-to/src/TEMPLATE-TOKENS.md`**. `git show a05b1c7 -- lefthook.yml` shows the
  pre-fix job printed `{staged_files}` and exited 1, so staging that file **was** blocked.
  Decorative for the `TEMPLATE-GUIDE/` half only — and "the job never ran" is simply wrong.
- **The actual defect is position-dependent, which is worse than a missing dialect.** A 2×2 on the
  same binary: the wildcard-bearing alternative **first** → matches only `TEMPLATE-TOKENS.md`;
  the identical pair **swapped** → matches both. A literal alternative carrying a `/`
  (`{TEMPLATE-GUIDE/01.md,TEMPLATE-TOKENS.md}`) matches both either way, and a single-alternative
  group `{TEMPLATE-GUIDE/**}` matches too. So braces work, `/` inside a group works, and what
  silently mis-compiles is a **multi-alternative group whose wildcard-bearing alternative is not
  last**. A glob that changes meaning when you reorder its alternatives is the exact fail-open
  shape the comment claims to be defending against — and it is recorded nowhere.
- **The correction changes what the rule says, not merely the comment.** "Braces don't work"
  argues for banning them and quietly condemns four shipped legs; the measured rule condemns
  **none** of them — no live `glob:` puts a wildcard and a `/` in the same brace group, `:14`'s
  `**/` sitting outside. The unglobbed self-gating design stays right, for a reason no reader can
  reach from what is written.
- **Four surfaces carry the false mechanism and they are not equally mutable — that split is the
  node, not the typo.** Shipped: `lefthook.yml:116-118`, absent from `copier.yml`'s `_exclude`
  (every entry there is a literal path; none can catch it), so **every generated project inherits
  it**, positioned where an author meets it before writing a `glob:`. Local only:
  `CHANGELOG.md:263` and `VERSION-HISTORY.md:21`, both `_exclude`d at `copier.yml:53-56`.
  Immutable: `a05b1c7`'s message.
- **Typed `grilling`, against the draft's `task`, because the fourth surface is undecided.** The
  shipped comment and the two local logs are mechanical once the measured rule is written. What is
  not is the immutable one: this repo already holds that a published record is recovered forward —
  _"a broken build under a correct number is recovered by releasing the patch, never by moving a
  published tag"_ — and **whether that doctrine reaches from a tag to a changelog line is the open
  half**. That is the same question **N-047** is typed `grilling` for, one decision in two sites;
  settle them together or route this half there. **Unbatched deliberately:** it is not a false
  green, since nothing fails open at HEAD and the guard works, and it is not split doctrine, since
  the rule has one home. It is the class this map has already named once — **a dead reason
  justifying a live choice**, as with `uvx --from` in the N-036 settlement — and asserting a sixth
  class here would pre-empt the taxonomy question N-027, N-039 and N-047 all declined to.

**N-040's verdict — the one instruction it wrote is the one thing that outlives it.** The node's
own _"a node counting commits goes stale by the hour, so the number should be re-run, never read"_
was vindicated by its own headline going seventeen → 41 → **0** in 48 hours. Keep the instruction;
the node is closed. Three of its subsidiary claims died with it and are recorded because each was
load-bearing for something else:

- **It did not compound N-038 or N-039.** The premise — _"a release is where `shipped-readme.sh`
  and the audit set are run against the whole tree"_ — is false: those gates live on the
  `template-integrity` **pre-commit** leg and in `audit-template.yml`, and
  `project-management/workflows/24-release/STEPS.md` contains **no audit step at all**. The
  compounding was asserted, never checked.
- **The sequencing behind N-032 was moot, not honoured**, and the map must not credit a discipline
  nobody exercised — `git log --oneline v4.0.0..v5.3.0 \| grep -vc 'chore(version)'` → **0**.
- **The bump reached the files the `version` skill names, not the files `VERSIONING-GUIDE.md`
  names.** That gap is **N-051** (_Batch D_), paired with **N-050** for the site it shipped.
  Settling the version state proved the number right and left the method unexamined; **N-047**
  is the other half of that, and the more expensive one.

### Refused — routed here and not adopted

`MAP-ABSENCE` routed **eight** findings to this map on 15/08/2026 and marked them unactioned. Six
became N-034, N-037 (three of them), N-038 and N-039. **Two did not survive re-verification on
16/08/2026 and are recorded here rather than charted**, so they are not inherited a second time:

| Routed claim                                                                                       | Measured 16/08/2026                                                                                                                                                                                                                                                                             |
| -------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `07-review/STEPS.md` Step 1 names `code-reviewer` in its heading and `review` in its dispatch line | **Not reproduced.** Line 36 reads `### Step 1 — Code Review`, line 38 reads ``Dispatch `code-reviewer` across the scope being reviewed``. Consistent. Either already repaired or misread                                                                                                        |
| `doc-references.sh` structurally cannot resolve any path under `code/src/django/`                  | **True as a fact, wrong as a defect.** The skip is deliberate and carries its rationale in the script at lines 238–241: those paths are where a project's own work lands, absent here by design, and flagging them _"would make the gate permanently red, which is the same as having no gate"_ |

**The second is the more useful refusal.** A stated scope boundary and a blind spot are
indistinguishable from the outside — both produce a green gate over unexamined ground — and only
reading the script tells them apart. The residue is real and small: a citation of `code/src/django/`
that is simply **wrong** is never caught. That is a fog-of-war line, not a node, and it is recorded
as one below.

**Types:** `research` (looked up, no human) · `tracer` (spike) · `grilling` (one
`/grill-with-docs` surface) · `task` (manual unblocking work)

---

## Fog of war

- Whether the five defect classes above should become a **shipped taxonomy** that audits are
  written against, or stay a map-local grouping. **Half-answered on 14/08/2026, in the direction
  of shipping:** `audits/doctrine-drift.sh` was written against **Batch D** rather than against
  the envelope instance that motivated it — a claims table any future split-doctrine rule joins
  by adding one row. That is the first audit in this repository named for a defect class instead
  of a defect.

  **Two classes have now paid out, in different currencies, and the difference is the interesting
  part.** Batch D produced an **audit** named for the class. Batch E produced a **node** — N-019's
  finding that a `skills:` declaration is a one-way claim nobody checks is Batch E's own shape,
  "declared, not built", turned on the routing system itself. So the taxonomy is not merely a
  filing convention: naming the class predicted the shape of what each would yield.

  **Four of five have now paid out, and A paid in the same currency as D.** Batch A produced
  `check-template-parsers.sh` — an audit written against the **class** rather than the defect,
  exactly as `doctrine-drift.sh` was for D. It does not check the token that motivated it; it asks
  every parser in the repository whether its own manifest still loads, so a future member of the
  class is caught without the script changing. Batch C generalised too, though less sharply:
  `5a00dde`'s self-ignoring folder turned out to be one of **five** folders on the same override.

  So the count is now A · C · D · E, with only **B** untested — and B is the class whose members
  are hardest to name in advance, since a false green announces nothing. **The prediction held
  twice more:** naming the class told you the shape of what it would yield, before the work
  started. That is now the strongest argument for shipping the taxonomy, and the argument against
  is unchanged: N-025 was the standing warning against building the instrument before the rule it
  enforces is true. Settle it once B closes, not before — one untested class is exactly the gap a
  shipped guide would paper over.

  **N-025 has now closed, and it turned the argument against itself in a way worth recording.**
  Settling it produced `skill-conformance.sh` clause 14 — an audit written against a **class**,
  the third after `doctrine-drift.sh` (D) and `check-template-parsers.sh` (A) — so **Batch E has
  now paid out twice, in both currencies**: a node first, then a gate. The warning was not
  refuted, it was **honoured and then discharged**: the clause shipped only once the 41 repairs
  made it green, and it was watched failing at 24 first. What that adds to the taxonomy question
  is that "declared, not built" predicted the shape of its own remedy — the routing system's
  unchecked declaration was itself a Batch E instance. **B is still the only untested class**, so
  the settle-once-B-closes rule stands.

  **16/08/2026 — B paid out, and it paid in the currency the taxonomy predicted for it.** The class
  is "a gate reports success without having looked", and the day's largest finding is a gate that
  **was never asked to look at all**: `audit-template.yml` does not run on a feature branch, so
  `check-template-tokens.sh` sat red and silent while generation broke (N-032, N-033). `shipped-readme.sh`
  was red the same way (N-038). **All five classes have now yielded**, and B yielded the one that
  cost the most — which is consistent with its own charted description, that a false green announces
  nothing and its members are the hardest to name in advance. The settle-once-B-closes rule was
  written when B looked untested; it now has the opposite problem, four new members in one day. **The
  taxonomy question is riper, not settled**, and two new candidate classes arrived with the same pass:
  **built, not declared** (N-038, E read backwards) and **transcript residue in shipped prose**
  (N-039). Neither is asserted as a sixth or seventh class here. Settle the whole question once, with
  all of this on the table.

  **16/08/2026, second instalment — B paid out four more times in a single verification pass, and
  the class split in the hand.** N-055 to N-058 are all Batch B, and two of them name sub-cases no
  existing contract can express: a gate that **could not look** (a skipped leg filed as clean) and
  a gate that **looked at nothing** (a population of zero under the normal green verdict). Both are
  typed `grilling` precisely because the three-value exit contract at `syntax/CLAUDE.md:40` and
  `_dual_result`'s two-integer signature have no case for either — so the taxonomy question now
  carries a concrete cost: whether "could not look" and "looked at nothing" are members of B or
  classes beside it decides how many exit contracts change and under how many callers. The
  Unbatched table also gained the fifth node its own intro asked to prevent (N-059). Riper still;
  still not settled here.

- **Whether anything can check what a skill claims about the tree.** Surfaced by N-037, and larger
  than it. `skill-conformance.sh` checks a skill's **shape** — spec fields, the field set, fork
  targets — and clause 14 checks its **citations** resolve. Nothing checks its **assertions**: that
  Alpine is vendored at a path, that there are 51 routes, that type checking is `strict`. All three
  were false and all three are the kind of sentence a reader acts on. The hard part is that most such
  claims are prose about the world, not references — the same anchorlessness that N-016 found
  `doctrine-drift.sh` could not hold. Some are mechanisable (a claimed **path** either exists or does
  not, which is doc-references' question pointed at skills), and starting there would have caught one
  of the three. Worth measuring how many of the class are path claims before designing anything.

- **`doc-references.sh` asks whether a cited PATH resolves, and has no opinion on whether the cited
  SECTION still exists in it.** Surfaced 16/08/2026 by N-029, which split `GIT-GUIDE.md` into four
  sub-documents and moved every heading **31 citations name by string**. The index still exists, so
  every one of those citations would have stayed **green while pointing at a file that no longer
  held the section**. Nothing in the repository would have said so; the split was caught only
  because the session went looking.

  **The obvious remedy was built and measured, and it is why this is fog rather than a node.** A
  first pass over the tracked tree examined 12 section-citations and reported 3 resolving and **9
  broken — all nine false positives**. Every one was a routing table _describing_ the guide's scope
  (`| GIT-GUIDE.md | Branch strategy, commit format, PR flow |`) rather than citing a heading. The
  hard part is that a citation of a section and a description of one are the same words, which is
  precisely the anchorlessness N-016 found `doctrine-drift.sh` could not hold.

  **What might be tractable is the arrow form.** The 16 CI-workflow headers all write
  `path/to/GUIDE.md → Exact Heading Text`, and that is mechanically checkable: split on the arrow,
  grep the target for a heading matching the right-hand side. It is a **convention rather than a
  rule**, so a gate built on it enforces the convention first — which this repository has done
  before and would have to decide deliberately. **Measure how much of the class uses the arrow
  before designing anything**, exactly as N-037's sibling question asks for path claims. Related:
  N-025's standing warning against shipping the instrument before the rule it enforces is true.

- **A finding handed to you is a claim, not a conclusion — and it now has a measured cost.** The
  15/08 lesson was _re-verify what another map hands you_. On 16/08 it repeated one level down, at
  the **agent** boundary, three times in one sitting: a reviewer reported the required-set table
  omitting two live required checks (the prose above it says in terms that it is _"the promotion
  target … not a census of everything unfiltered"_); an adversarial pass reported the shipped
  README's `git/` block describing its directory inaccurately (it omits the `CONTEXT.md`/`CLAUDE.md`
  pair exactly as the neighbouring `gdpr/` block does, so it follows the convention rather than
  breaking it); and this session's own citation checker produced nine false positives. **All three
  were confidently stated and specific.** The two that survived checking were real and worth having.
  The rule that leaves: **a dispatched finding is evidence about where to look, never about what is
  there** — and the cheap discriminator is that a claim naming a file and a line can be re-run,
  while a claim about what a document _means_ cannot.

- **`47bafb1`'s port sweep missed two files, and both ship.** That commit moved the dev-stack URL to
  `:81` on the grounds that _"every doc that said 8000 was quoting a port nobody publishes"_.
  `project-management/docs/git/BRANCHES-AND-WORKTREES.md` and `.copier/README.md` both still give a
  worktree URL ending `:3080`, against `.claude/CLAUDE.md` Section 7's host port and against
  `how-to/docs/GIT-WORKTREES.md`, which gives no port at all and which the first of those two says
  it is summarising. Found 16/08/2026 during N-029's review; **not fixed there, deliberately**, the
  split being a move and an edit inside it breaking that guarantee. Small and certain, so it is a
  node the moment anyone wants it — recorded as fog only because the right number is a question for
  whoever owns the worktree URL scheme, not a lookup.

- **A citation of `code/src/django/` that is wrong is never caught.** The residue of the refused
  `doc-references.sh` finding above. The skip is correct — flagging a project's own future work would
  make the gate permanently red — but it is a blanket `continue`, so a genuinely misspelled path
  under that tree passes exactly as a legitimately-absent one does. Whether the two are separable at
  all is the question; a directory that exists here (`config/`, `apps/core/`) might be checkable while
  its unbuilt siblings are not. Small, and it only matters once a project has code, which is why it is
  fog rather than a node.

- **Whether a finding routed between maps needs a mechanism.** Eight findings sat in
  `MAP-ABSENCE`'s _Graduated outside this map_ table for a day, correctly recorded, explicitly marked
  unactioned, and read by nobody — including the two that were already red gates. The sending map did
  everything its rules require. **A routed finding has no owner until the receiving map adopts it**,
  and nothing makes that happen. The cheap answer is a rule that a resolve session opens by reading
  the sibling maps' outbound tables; the expensive one is a shared inbox. **What is not yet clear is
  whether this is a wayfinder-level gap or a symptom of three maps being charted in parallel by
  sessions that could not see each other** — the same shape as N-027's finding about three nodes
  spending one budget, one level up. Note the second half: two of the eight did not survive
  re-verification, so an automatic adopt would have charted two phantoms.

- ~~Whether `docs-pairing.sh` can flag a source directory carrying **neither** file without firing
  on every ordinary Python package. Surfaced by N-017; larger than that node.~~ **Discharged
  15/08/2026 by N-017 itself**, which turned out to be able to hold it: `docs-pairing.sh` Check 10
  enumerates **directories** rather than the files that exist — the two loops above it are driven
  by the `CONTEXT.md`/`CLAUDE.md` that are present, so a directory holding neither was not
  overlooked but unreachable. It fires without noise because it is scoped to `code/src`, where
  "a directory someone works in" is decidable, and exempts two named classes: synthetic audit
  fixtures, and a single-purpose leaf (exactly one tracked file at any depth, so the parent's
  pair already annotates it — the exemption lapses at two files, when there is a relationship
  between them to describe).
- Whether a CI step that fails on an **expired ignore date** generalises beyond `deny.toml` to
  every register carrying a re-check date. Surfaced by N-023, and **N-006 supplied the second
  register on 15/08/2026**: `pnpm-workspace.yaml`'s surviving image-size pair carries the trigger
  _"re-check when 2.0.3 ships and delete both lines"_ in prose, owned by nobody and checked by
  nothing. Two registers with the same shape is the threshold at which this stops being N-023's
  private problem — but note what N-006 also proved, which cuts the other way: the entries that
  actually rotted there were **undated**, and no expiry check would have caught them. A trigger
  gate finds the ignore that outlived its date; it does not find the ignore that never had one.

  **N-027 supplied the third register on 15/08/2026, and it answers that objection rather than
  repeating it.** `docs-length-allow` carries its expiry **by format** — the parser refuses a
  marker without one, and refuses one without a reason — so the undated entry N-006 warned about
  cannot be created here at all. That is the shape the other two registers would have to adopt
  for a shared expiry gate to be worth building: **make the date mandatory at the point of
  writing, not checkable afterwards.** Three registers now, one of them already immune.

  **The quorum was lost on 16/08/2026, and the entry stays open on a weaker footing.** `b805774`
  deleted `deny.toml`'s `ignore` list outright, so **the register that raised this question no
  longer exists**. Two remain — `pnpm-workspace.yaml`'s image-size pair, which carries an undated
  prose trigger, and `docs-length-allow`, which is immune by format. That leaves **exactly one
  vulnerable register**, which is below the "two with the same shape" threshold this entry set for
  itself. Keep it as fog rather than closing it: the shape recurred three times in four days, and
  the argument for the mechanism was never the count so much as the demonstration that an undated
  trigger is unenforceable. But do not cite the threshold as met — it is not.

- **Whether the ratchet generalises beyond line count to every shared budget.** N-027 settled the
  line-count case on 15/08/2026 — the obligation falls on the change that spends the headroom,
  enforced by `docs-length.sh --since` against a baseline rather than by a warning nobody owns.
  What is not yet sharp is whether that **shape** is the general answer. The evidence that it
  might: three nodes spent someone else's share of that budget in a single day without any of
  them being about length — N-007 took 9 lines from `audits/CONTEXT.md`, N-009 pushed
  `.claude/CLAUDE.md` into the warn band outright, and N-025 moved `stack-django` from
  fourth-worst to **second-worst** — and each was correct, small, and reviewed on its own terms.
  Nothing about that story is specific to Markdown. Two other budgets have the same shape and no
  ratchet: the **required-check set** (N-029, where each addition is cheap and the total is what
  costs), and the **standing skill `description` surface** (`.claude/MEMORY.md`, 13/08 — 65
  entries measured costing **more** than the 85 they replaced, because two decisions in different
  sessions moved one quantity and neither re-measured). A budget spent per-change and measured
  per-release is the pattern; whether it earns one mechanism or three is the open question.

- **A line number cited into a file another session is editing is a claim with a shelf life, and
  the Batch B verification pass measured the decay rate.** Three independent drifts in one day:
  the challenge leg cited `pre-pr-check.sh:27`/`:28-31`/`:33` where HEAD has `:30`/`:31-33`/`:35`
  — and the repository's own `06-quality-gates/STEPS.md:124-130` had them right; the same leg
  cited `docs-pairing.sh:148,161-164,272` for a guard at `:166` and a counter at `:280`; and
  N-030's residue bullet aged from `PR-AND-REQUIRED-CHECKS.md:102`/`114-117` to `:106`/`118-122`
  in under a day, corrected this pass. The pass's own evidence reviewer put drift in a third of
  findings. This map already re-locates by string on every reading; what is open is whether its
  **verdict blocks** should stop printing line numbers for volatile files altogether, or keep them
  and accept the maintenance cost as the price of a re-runnable claim. The evidence cuts both
  ways: a file-and-line is the cheap discriminator the standing lesson relies on — and it is also
  the component found wrong most often in the very pass that relied on it. One caveat rides here
  rather than in N-057's block: its satisfiability caveat — that a `workflow_dispatch` run against
  a PR head ref would attach a check run satisfying the required context — is **reasoning about
  GitHub's model, not a measurement**; zero dispatch runs exist, and dispatching one is a write.
  Measure it before any settling session leans on it.

---

## Out of scope

| Ruled out                                                  | Why                                                                                                                                                                                                                                                                                                                                                              |
| ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The ADR machinery retirement                               | Reversed 13/08/2026; the mechanism already worked and no file needed to change                                                                                                                                                                                                                                                                                   |
| Further **delimiter** checks in `check-template-tokens.sh` | The 13/08 fix plus `--self-test` closed that class; a bare closer is inert to Jinja. **Scope corrected 14/08/2026** — this row once read "further work on the script" and would have suppressed `N-024`, which is a _position_ check, not a delimiter one                                                                                                        |
| Making the backend suites run in this repository           | **Row corrected 15/08/2026 — it was wrong, and wrongly reassuring.** It read "`uv.lock` is absent by design — see SL-1; N-001 does not touch this". N-001 was SL-1's **sole cause**: the manifest could not be parsed, so no lock could exist, and every suite guard tested for that lock. Still out of scope, but now for an honest reason — see the note below |
| A generated project's own `GAPS.md`                        | A different register with a different owner; this map is the template's own items only                                                                                                                                                                                                                                                                           |

**SL-1 is now unblocked and was deliberately not taken on 15/08/2026.** With the manifest parseable,
`uv sync` resolves here and `uv lock` succeeds, so the standing limit's stated cause is gone. What
is left is a **different** question with a real blast radius, and answering it inside a token
session would have been the batching mistake this map keeps warning about:

- Committing a `uv.lock` flips the `[7/8] Tests`, `test.yml`, `test-api.yml` and `test-e2e.yml`
  guards from skip to run **automatically**, because they test for the lock's presence. Those
  suites have never executed here. Whether they pass is unknown, and finding out by merging is the
  wrong order.
- The Django image builds with `COPY pyproject.toml uv.lock ./` and `uv sync --frozen`, so a
  committed lock also changes what Docker does in the template.
- A template that commits its own lock has to say how that lock relates to the one Copier writes at
  generation, and `.gitignore` currently carries a rationale that is no longer true.

**It should become a node** — Batch B, since the guards are the false green — rather than be left
as a standing limit whose reason has expired. Charting it is the first act of the next session.

**Done, 16/08/2026: it is `N-035`**, charted in Batch B with the three consequences above carried
into it verbatim and the `uv` measurements re-run. The related sweep — the dead premise still
standing in about fifteen live files, of which `.gitignore` is one — is **`N-036`**, blocked on
N-035 so the replacement wording is decided once and written once.

---

## Session log

| Date       | Node settled          | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Frontier redrawn |
| ---------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 22/08/2026 | N-047 · N-059         | **Sitting 4 — one doctrine, two sites, and the batch named itself.** N-059's charted text already said its open half was the same question N-047 is typed `grilling` for, one decision in two sites, to be settled together — so the grouping was read off the map rather than argued. Five questions over two rounds. **The pre-flight paid for itself twice.** N-047's measurable premises all held: six split files in the `v4.0.0` tree, `GIT-GUIDE.md` at 52 lines there, zero content commits across the `v4.0.0` to `v5.3.0` range, and a window exactly three tags wide. **Its central objection did not.** The node said re-keying rewrites what a published tag meant. It does not: `copier update` checks out the target tag and reads its migration list from HEAD, so re-keying is forward-looking and rewrites nothing. With the documented trigger rule in hand — fire when the old version is below the key and the new version is at or above it — the node's **first option turned out to be the only one that breaks a population currently served**: a project sitting in the `v4.0.0` to `v4.1.1` band is reached today by the `v5.0.0` key and would have been reached by nothing. Two keys, not one. **N-059's mechanism was re-driven, not inherited.** A 2x2 through pinned lefthook 2.1.10 reproduced every claim: braces expand, a slash inside a group works, and what silently mis-compiles is a multi-alternative group whose wildcard-bearing alternative is not last. It condemns none of the four live globs, so the remedy is a comment and **not a gate** — a check over a population of zero is the Batch B defect this map is named for. **Anchor drift on both nodes, the fourth and fifth on this map.** copier.yml 641 to 694; CHANGELOG.md 263 to 357; VERSION-HISTORY.md 21 to 24. Only lefthook.yml 116-118 held. Every charted anchor was re-measured before a question was asked, on sitting 3's precedent. **A finding no node had, refused rather than charted.** `code/src/django/` has taken 20 commits since its 0.1.0 row, including a whole new app, while its three sub-package logs never moved. Sam ruled the sub-package tracks are seeds for a generated project, so only the root track is versioned here. Not a defect; recorded so it is not re-found. **Charted nothing.** Counts recounted from the tables: **9 + 51 = 60 = N-060**, per batch A 0, B 3, D 1, E 4, unbatched 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | [x]              |
| 22/08/2026 | N-056 · N-058         | **Sitting 5 — the maintainer's challenge sharpened a node instead of dissolving it, and a definition inverted a remedy.** Seven questions over one round; **one dissolved on measurement before it was asked** and one more died to the challenge. **N-056: five charted members were already dead** — `copy-emdash`'s subshell guard repaired at `3c0da01` and its silent output at `d9fcca8`, `css-gradients` and `css-tokens` rewritten onto the `copy-slop` shape at `a6e90d3`, the `--since ""` "live CI producer" **never true** (`fetch-depth: 0` landed `40bf310`, 15/08, _before_ charting), and `docs-length.sh:405` guarding a **ref** not a scope, which made that script an unguarded member rather than the model for the fix. **The node's own owed measurement was discharged**: all 24 audits executed rather than grepped — the map's fifteen guards hold **exactly**, zero defeated, and **six exit 0 unguarded**, four of them uncharted. `docs-pairing` stayed the worst member on re-measurement, printing `216/207` for `--path learning`, `--path code/docs` and a nonexistent path **alike** — a denominator that does not move with the scope. **`sync-trees.sh` was re-framed by Sam's question _"isn't it supposed to update the trees?"_, and the answer was yes**: it is a writer by design (`:14-21`, ADDED / REPORTED / PRESERVED), so declining to re-report what it has just fixed is correct. The defect is narrower and worse — `:343` filtered on the substring `"not on disk"` where it meant _was this left unresolved_, so the **nested-tree class** (`:282`, unwritable by `:286`, wording containing no such substring) was computed and silently dropped. Proven in a clone at the hook's own mode: `--write --path apps/core` printed `✓ Every CONTEXT.md tree matches its directory.` at exit 0 over a live finding. **N-058: the population was measured, not inherited** — 45 workflow folders all paired, 42 runnable CHECKLIST spans, silent-false-green subclass of size **exactly one**; 109 fenced-bash lines across the skills, **one** member. **Sam's definition of the two artefacts inverted the fix**: STEPS is the procedure, CHECKLIST is read _after_ the work to confirm it — so the box takes the **bare name**, `07-dependency-updates/CHECKLIST.md:34` stops being "the benign precedent" and becomes the model, and the runnable form stays in STEPS. **A new fact fell out**: `pre-pr-check.sh:35` matches `gh pr (create\|new)\b` and does **not** fire on `gh pr ready` — the exact moment `git/SKILL.md` gated on; the held question was then **priced and refused**, `--draft` having zero occurrences in the tree and zero commits across all refs, ever. **Adversarial review earned its cost twice over**: all six sweep agents returned `defective`, including a **fabricated quotation with a line citation** in `MAP-ABSENCE.md` — a string absent from the file it named — inside a paragraph asserting the close was "measured against HEAD rather than read off the commit message". The corrective round then found the remedy had **reintroduced its own defect class**: guards testing the filesystem while the scope was applied as a repo-relative prefix, so `--path .` and an absolute path printed a confident new "surface absent" note over an unexamined tree. **Carried a register restructure that was not on this map**: `GAPS.md` and `DEFERRED.md` are now copier-**excluded and seeded blank**, `TEMPLATE-GAPS.md` folded in and deleted, gated by a new `shipped-registers.sh` (9 checks, 9/9 probes). The justification was measured, not argued — `git show v6.0.0:GAPS.md` is **47 lines carrying this repository's own `main` entry**, which a real `copier copy` handed to a generated project as its own active gap and a real `copier update` delivered as `UU GAPS.md`. `doc-references.sh`'s exemption arm was **retired, never re-pointed at `GAPS.md`**: exempting it was proven to blind the audit over every downstream register. Verified by generating both `INCLUDE_MOBILE` variants and by a real `copier update` across the transition — project entries intact, zero conflict markers, zero leakage. **Charted nothing.** Counts recounted from the tables: **7 + 53 = 60 = N-060** | [x]              |
| 21/08/2026 | N-054 · N-048 · N-020 | **Sitting 3 — three nodes on one file, and the first node on this map closed as _accepted_ rather than _fixed_.** Nine questions over two rounds; two more dissolved on lookup, which is the grilling rule paying out — `OBSERVABILITY.md:312` already held the `/metrics/` reopening trigger and `TEMPLATE-GAPS.md` already held the standing-limitation format, so neither reached Sam. **The sitting's thesis: neither half of N-054 was a drift between equals — both were omissions on one side.** `checks.py:70-80`'s `Component` docstring already said `API` and `PAGES` are _"named in the contract but deliberately absent… each arrives with its surface"_, and three shipped documents already carried the `django_prometheus`-not-wired qualifier. **The file calling itself the single source of truth was the only one missing what every sibling stated** — a shape no batch on this map is named for, and the reason `:32` kept its row instead of losing it. **N-048 settled on ownership, not merit**: `:134` assigns the scrape contract to SERVER-ARCHITECTURE and that owner says `-backend`, so two sites moved and three already conformed — with the honest note recorded that **both names imply a front/back split this stack does not have**, the contract itself saying _"a single Django ASGI process family… no separate frontend scrape target"_. **Every one of N-048's charted anchors had drifted** (`:171,185,340` → `:174,188,343`; `:321` → `:341`; `:174-176` → `:178-179`) and a **fifth site was found that no node had**: `OBSERVABILITY.md:236-239` asserting the two were _"spelled the same way"_. It was **made true rather than deleted** — the only sentence keeping them in step — while the drift record itself was deleted rather than corrected, on sitting 2's doctrine. **The node's remedy claim was withdrawn, and this is the sitting's sharpest finding.** N-048 said `doctrine-drift.sh` could hold the instance and derived that from `SCAN_DIRS` alone; measured, **three things block it** — the owner path is rooted at `DOCS_DIR="code/docs"` and the owner is not in it, `how-to/src` is not scanned, and only fenced code is read while a specification tree states its rules in prose on purpose. **The map's twice-stated pessimism stands and the counter-example was the error.** A node correcting the map's pessimism into an equal optimism, from the same single source, is a new instance of this map's oldest habit — and the scope now lives in the script, not only here. **N-020 closed as SL-2 and its proposed three-way split refused**: the split rested on `health-check.sh` _"now needing only an owner (N-044)"_, and N-044 had settled by finding that **nothing in this repository creates these three scripts** — the blocker was confirmed, not cleared, so the premise was spent before the split was written. **The trigger nearly shipped wrong**: SL-2 was drafted _"reopens when a workflow builds and pushes an image"_ and re-measured before commit — `test-api.yml:75` **already builds** one (`docker compose … build django-test`), and what no workflow does is **push**. Worded _builds_, the entry would have read as already met on a test image that never leaves the runner. That is the 16/08 `grep 'docker build'` slip in the opposite direction, on the same claim, five days apart. **A third falsehood was swept that no node had charted**: `config/CONTEXT.md` said dev Compose _"probes `/`"_ when the dev and test files and both deployed Dockerfiles all probe `/health/`. **Charted nothing.** Sibling duty paid a fifth time: `MAP-SUBDOMAIN-ROUTING:58` reads the exact section this sitting edited and is _seeded, not charted_ — a downstream reader, no collision; `MAP-NEGATIVE-SPACE` touches `EDGE-REQUIREMENTS.md` 13/14, not 8. `GAPS.md` and `DEFERRED.md` both hold zero entries, so nothing was claimed. Counts recounted from the tables: **11 + 49 = 60 = N-060**                                                                                                                                                                                                                                                                                                 | [x]              |
| 21/08/2026 | N-057 · N-050 · N-051 | **Sitting 2 — three nodes on one file, and the first whose remedy needs a live repository setting changed.** Thirteen grilling questions over four rounds. **One doctrine ran through every answer: stop keeping a second copy of a fact that has an authoritative source** — the required-set table deleted rather than made a census, `as of 3.2.2` deleted rather than re-dated, four restatements of the version file set deleted or routed. **N-057 settled by de-requiring**: `audit-deps.yml` runs only on `schedule` + `workflow_dispatch`, so no `pull_request` event can produce its context and it had **no path filter to delete** — the trigger was the defect and the guide's rule never asked that question. `[8/8] Security` takes its place; `Routing skills resolve` joins on **N-030's exit condition, met since 16/08 and never acted on**; `Unresolved conflict-marker audit` joins because `:98-99` deferred it to **N-029, a node that settled without taking the decision**. Set **20 → 22**, applied in branch protection after this merges — the file half ships first and claims only eligibility, so no artefact here asserts a membership it cannot see. **Two of the three nodes' headlines were refuted before they were settled.** N-050's asymmetry was killed by `866d59d` — **the very commit that wrote the node** — and its "three days / eight releases" is six and eleven at HEAD: the fifth instance of a node producing a member of its own class. N-051's "three homes" is nine or ten, its canonicity contest is **3–0 and uncontested**, and the executed set had **already conformed** at `b4f00db`; what survived was sharper — a skill forbidding itself to restate a list and then restating it short by two, and `24-release` instructing the `pyproject.toml` bump the guide forbids. **A shipped rule was condemning its own gate suite**: `:83-84` bans a job-level guard on a required check, and **all eight `[n/8]` jobs carry one** — narrowed rather than enforced, because eight violators is a rule that overreached. **The pre-flight found what no node had: sitting 1 closed N-031 with its own row 1 half-repaired**, five sites unmarked and the gate blind to every one of them (`doc-references.sh --path` on the file: exit 0, clean). Four of the five were discharged by **deleting the table they sat in**. **Two cross-sitting collisions charted** — sittings 2, 5 and 6 are not the disjoint surfaces the plan claimed — with both later anchors re-measured after this sitting moved them. **Charted nothing.** An 82-agent adversarial review of this diff returned 76 findings, **38 surviving refutation**, and every one was fixed in place rather than charted, on the standing instruction that this map stops growing. The ten shipped files citing a bare `N-0NN` — a namespace that **exists and means something else** in a generated project's `MAP-SCALE-PLANNING.md` — now name their map, closing the class outright instead of opening a node for it. Three membership claims **no workflow file can honestly make**, because membership is a repository setting and the files ship (`audit-conflict-markers.yml`, `audit-deps.yml`, `test.yml`, the last stale in the other direction), became **eligibility** claims derivable from the file itself; `CONTRIBUTING.md`'s eleven-row second copy of the required set, stale three ways, was deleted and routed. **The sitting's most durable output is a rule, recorded here because nothing else would**: `git/CLAUDE.md` now forbids writing the required-set membership into the four git guides at all — the doctrine above turned into a standing prohibition — and `git/CONTEXT.md` was re-pointed to name `Changing the set`, which holds the `gh api` command that reads the live set. **The sibling duty was paid a fourth time and failed a third new way**: `MAP-RULE-OWNERSHIP` was written by a parallel session at 17:44, after the read, and claims `doc-references.sh` — the third map to do so. Counts recounted from the tables: **14 + 46 = 60 = N-060**                                                                                                                                                                                    | [x]              |
| 21/08/2026 | N-044 · N-052 · N-031 | **Sitting 1, and the first on this map planned by shared FILE rather than by batch — three nodes across three batches, settled in the order the couplings demanded.** The sibling-map duty was discharged third time running and paid a third time: `MAP-NAVIGATION` N-004 proposes an output mode on `doc-references.sh`, the very script this sitting edits, and this map's table said that map _routes nothing here_. **Two of the three nodes cost no code.** N-044: all six sites already qualified their unwritten scripts, and **nothing was registered** in `PROJECT-PATHS.md` because no workflow creates them and `FORWARD-VOICE.md` Section 3 calls an entry without a creator a wish. N-052: **measured and refused** — widening Check 1 puts 505 tokens / 4,529 sites in scope, 91 / 351 go red, **54% could never be a citation and only 12% is the target class**, and the register-outward alternative died because bare `api.py` is ambiguous 3-to-3. N-031: `is_exempt()` narrowed to `TEMPLATE-GAPS.md` alone, which exposed **four findings and no broken citation** — all four repaired, not suppressed — plus **12 sites marked `template-only`, from zero prior adoption**, and three pointers at a register holding no dated entries re-pointed at `GAPS.md`. **The narrowing comment created an instance of the defect it documents** (a backticked `.claude/agents/` at `:71`), caught by the gate on the next run: a node creating a member of its own class, for the third time on this map. Charted **N-060** for the unbuilt `_exclude` reader. Gates: `doc-references.sh` exit 0, `--self-test` 7/7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | [x]              |
| 13/08/2026 | —                     | Charted: 23 nodes in 5 batches; 7 closed + 2 resolved swept                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | [x]              |
| 14/08/2026 | N-005                 | **Coverage audit** vs `e16b499`: all 31 original entries accounted for. N-005 resolved by `24a5fb7`; N-002/N-003 narrowed; N-024 recovered as new node                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]              |
| 14/08/2026 | —                     | **N-014 unblocked, not settled.** The agents→skills chart completed and its map was deleted on completion; the tier went at v3.0.0 (56 files), folding the 13 writers into `legal-documents` and `msp-scp-documents`. The node's blocking edge was the conversions, so it dies with them — `Blocking open` 2 → 1. The question re-framed: the two skills are asymmetric (6 sub-documents vs a lone `SKILL.md`), so what is left to ask is whether **that** is correct, not where 13 writers go. Two dangling cross-references to the deleted map removed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [x]              |
| 14/08/2026 | N-015                 | **One envelope, and the count was the wrong argument.** 4 guides said `{"error": {...}}` against 1 saying `{"detail": ...}`, but the deciding fact was coverage: Ninja registers **six** default handlers and every guide overrode two, so the majority spelling was itself incomplete — 401, 403, 404 and every `HttpError` still answered natively. `{"detail"}` turned out to be Ninja's own output rather than an invention. Settled on the declared envelope with all six overridden, and on the principle that makes it coherent with dropping the `{"data"}` success wrap: **diverge where it buys something, stay native where it does not**. Ownership moved to `AUTH-AND-ERRORS.md`, whose name promised errors while saying nothing about them; the taxonomy guide had been routing the JSON API to a **logging** guide, which is why nobody found the fork. A fourth contradiction surfaced mid-grill, in shipped code: `ServiceError.code` ships `SCREAMING_SNAKE` against the guide's mandated `snake_case`, now lowercased to match the invariant register key. `config/api.py` deferred to the first endpoint story — a single config is class 3 on this project's deletion test, so `audits/doctrine-drift.sh` carries the rule instead                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [x]              |
| 14/08/2026 | N-018                 | **The inheritance was never true, and the node's own question is what exposed it.** `stack-fastmcp` claimed `/mcp/` inherits the JSON API's per-surface row; that row's mechanism is Ninja's exception handlers, and a Starlette mount has no `NinjaAPI` and no Django middleware — so the surface had been routed to wiring it cannot have. Sixth row added, expression in `TOOL-DESIGN.md`. Two facts from FastMCP's own source decided the rules: a tool error returns as `CallToolResult(isError=true)`, a JSON-RPC **success** the model reads and reasons over, so there are no status codes here; and `mask_error_details` defaults **off**, which would hand an `InvariantViolation`'s register key and debug detail to the model verbatim. Settled on one `on_call_tool` boundary, masking **on** so the exception **type** decides who speaks, and correlation minted on the router **above both mounts** rather than a second scheme here. Three `[gate: fail]` clauses, gated on a tool module existing, watched failing in both directions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | [x]              |
| 14/08/2026 | N-019                 | **The premise held and the node found a bigger one underneath it.** None of the six verifier skills cited any artefact of `MAP-NEGATIVE-SPACE`; five now do and **`review` was declined**, a 63-line sequencer whose three dispatches carry the doctrine instead — N-015's "three skills, not four" precedent. The node shipped more than pointers: N-012's two `[judgement]` clauses, homeless since 11/08 because no gate can decide them, are now a named `code-reviewer` dimension. Each skill took the half its work reaches — `INVARIANTS.md` as an **attack list** for `qa-tester`, the disclosure rule plus `MANAGEMENT-COMMANDS.md`'s "argparse parses, parsing is not validation" for `security`, a **third** thing a move must never drop for `refactor`, and for `bugfix` the reframe that an `InvariantViolation` is the guard **working** with the cause upstream of it. Writing `refactor` forced a distinction CI cannot make: deleting a guard fails `key-unraised` and extracting one twice fails `key-duplicated`, but **moving a guard and leaving its register row behind stays green**. The deletion class is unchanged — doctrine only — because the obvious upgrade was measured and rejected: a reciprocity clause reading each guide's own `skills:` field would ship **red at 26 of 77 pairs**. That became **N-025**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]              |
| 14/08/2026 | _none — intake_       | **Two nodes inherited from `MAP-NEGATIVE-SPACE`, which closed its fog of war and had nowhere live to put them.** That map is **Shipped** with an empty frontier, so an entry left on it would never be read again — both maps are gitignored alike, so the move buys **liveness, not durability**. **N-026** is textbook Batch E: `NINJA-CONVENTIONS.md` requires a per-app `api.py` and a mounted `config/api.py`, neither ships, and `new-django-app.sh` emits neither — but its documentation half closed itself at `93037ba`, where `AUTH-AND-ERRORS.md` now states the absence outright, so what is left is a scaffold question deferred by two separate nodes to "the first story that needs an endpoint", **a trigger nobody owns**. **N-027 is unbatched on purpose**: the instructional-length warn tier fits none of the five classes, and asserting a sixth in passing would pre-empt the fog-of-war question about whether the taxonomy ships at all. Its own measurement is the argument — 717 files, all under 300, but **five** inside the 270 warn where there were four, `stack-django/SKILL.md` holding fourth place without moving while the set grew around it. First nodes on this map not sourced from `TEMPLATE-GAPS.md`; the _Register claimed_ table is unchanged and does not account for them                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [x]              |
| 15/08/2026 | N-012                 | **Verified resolved by a commit, not a session — the second node on this map settled that way, after N-005.** `5a00dde` took a fourth path none of the charted three described: delete all four `research/` notes, make the folder self-ignoring, and remove the reason anything cited them. The node existed because three notes were **undeletable** — `README.md` at lines 151/183/188 and `THIRD-PARTY-NOTICES.md` at 218 named them as per-claim evidence. Re-run against that same deletability table: **zero inbound references survive from either file**. The five that remain sit in `CHANGELOG.md` and `RELEASES.md`, which the original entry ruled correct and permanent — a historical record naming a deleted file is accurate. `audits/doc-references.sh` clean. The quotation half is **voided rather than answered**: with nothing under `research/` tracked, no unlicensed verbatim quotation is redistributed, so option (a)'s wording change became unnecessary. Option (c)'s rejected failure mode — a citation that dangles for a generated project — is structurally impossible now, because every `README.md` _Influences_ row is self-citing and the two that need more cite the shipped `THIRD-PARTY-NOTICES.md`. **Batch C reduced to N-013, which is grilled in Batch A**, so the class has no session of its own                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | [x]              |
| 15/08/2026 | N-006                 | **The verification is the session — and it found the half nobody had done.** Opened to close N-006 on `4419218`, which had moved the ignores to `audit.ignore`, proven them load-bearing by removing the key, renamed four downstream sites and closed the `--ignore` false green in `check-security.sh` (pnpm has no such flag; given one it printed _"No new vulnerabilities were ignored"_ and **exited 0 without auditing**). All of that held. What did not: `GHSA-5375-pq7m-f5r2` and `GHSA-99f4-grh7-6pcq` — both `@grpc/grpc-js` via `. > @usebruno/cli > @usebruno/requests` — had sat **unannotated since `fc905eb`**, and `git log -S` confirms a rationale never existed. Closing on that would have manufactured a **Batch B** defect inside a Batch A node: the gate green on a suppression nobody justified. The remedy was smaller than either charted option — a patch existed the whole time (`>=1.14.0 <1.14.4`, fixed 1.14.4) and `@usebruno/requests` declares `^1.14.3`, so **the fix already satisfied the range and the lockfile was merely stale**. `pnpm update @grpc/grpc-js` cleared both: 7-line lockfile diff, no override, no forced resolution. Both entries **deleted rather than documented**, leaving the rule beside the key — an ignore whose advisory has a published fix is a suppression, not a decision. Re-proven at the new count: with key _2 high (2 ignored)_ clean, without key _2 high_ VULNERABLE. Second Batch A node overtaken by work in flight rather than settled by a session, after N-005 — **re-verify a Batch A node before grilling it**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | [x]              |
| 15/08/2026 | N-001 · N-013 · N-024 | **Batch A and Batch C closed in one sitting, and the map was wrong about all three in the same direction — it undercosted them.** N-001 was charted as buying `basedpyright` and `pip-audit`; one `uv lock --dry-run` showed the token was the **sole cause** of every Python gate being off, because no manifest parse means no lockfile and no lockfile is what every guard tested for. The Out-of-scope row saying "N-001 does not touch this" about SL-1 was therefore false, and is corrected. Settled on a house constant `syntek-base` branded by a `copier.yml` `_task` ordered **ahead of** `uv lock` — cheap because `[tool.uv] package = false` makes this a virtual project, with the one cost (`copier update` never runs `_tasks`) written beside the constant. **Six gates unguarded, not the three charted**: N-002, N-003, N-004 plus `claude.yml`'s `[3/8]`, `[4/8]` and `[8/8]`, which had been announcing _"Running Prettier only"_ / _"Running ESLint only"_ / _"Auditing the JS dependency tree only"_ since they were written. Every one verified green **before** unguarding. N-004 needed no code: `security.sh` was never guarded, it simply could not work. **N-024's charted plan died on its own evidence** — pnpm parses `<%PROJECT_SLUG%>` in `package.json`'s `name` while uv rejects it in `pyproject.toml`'s, so positions are not statically decidable and a hand-maintained register would be the rule again one level up. `check-template-parsers.sh` asks each parser instead (`uv`, `cargo`, `pnpm`, `docker compose`), ships with `--self-test`, runs as `[4/4]`, and gained the rule a row it lacked: a shell word, where the delimiters are legal and **active** rather than illegal. **N-013 retired** — `apps/core/` already ships literal, so the question could never be honoured; 38 tokens to 37, and the doc's count was stale the moment it went. Proven end to end with a local `copier copy`: tasks in order, `name = "ci-probe"`, a lock naming `ci-probe` and never `syntek-base`, zero unrendered tokens                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | [x]              |
| 15/08/2026 | N-007 · N-011         | **Batch B's first pair, and the batch held because both were one question in two costumes: what does this repo owe a gate that cannot run here?** The answer was already written on both sides and never joined up — `docs-length.sh` dies without `cloc` ("no honest fallback"), `render-slop.sh` installs Chromium in CI and self-tests before scanning, and `static-analysis.sh` did neither, so its rules had never once run. N-007 took the render-slop contract: optional on a laptop, pinned and signature-verified in CI, `--self-test` first. Opengrep forced a **new supply-chain class** — not on PyPI, no official Action, no image, and the npm `opengrep` is an unrelated placeholder stuck at 1.0.0 — so it is the first downloaded binary here, and it arrives cosign-verified against the exact upstream workflow identity, checked locally before shipping. **N-011's charted question was the wrong size.** The required set is not arbitrary: every one of the 13 sits on an **unfiltered** workflow, which `GIT-GUIDE.md` already explained. What was missing was what earns membership once eligible — and the answer was already being practised, unstated, by `jest-expo + coverage`, required on the same step-guard shape that supposedly disqualified `pytest`. Wrote the rule; declined the audit clause on N-025's precedent. Sam overrode the pin location to a root dotfile, which surfaced that **cargo-deny was installed unpinned** — `--locked` pins its dependencies, not it — so the gate was a different tool every run. Two nodes out, **N-028** (coverage floor forked 75/80) and **N-029** (apply the rule) in                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | [x]              |
| 15/08/2026 | N-014 · N-016 · N-017 | **Batch D held as a class but never as a subject, and all three charted framings described symptoms.** N-014: the asymmetry is **correct** — `msp-scp-documents` covers 12 types at ~644 raw lines unsplit and had to disclose; `legal-documents` covers 6 at 226 and did not. Splitting it would _raise_ per-task load (101 + an always-needed 137 + 57–135, against a flat 226). The real find was both files carrying the one heading `.claude/CLAUDE.md` Section 10 supersedes project-wide — compressed rather than deleted, because the section owned a decision grilling does not: stateless `/grill-me`, never `/grill-with-docs`. N-016: `schemas.py` is not an outlier but the worst of **13 of 22** multi-line module docstrings, so the rule lost to the practice and was recut by **kind** — a docstring sizes to the unit's why, a comment is one line about its own line. The separate outside-reference ban went the other way, **absolute**: 10 source files made self-contained, three of them (`mobile/lib/*.ts`, `crates/desktop/build.rs`) outside the node's stated scope. Two documents each claimed to be canonical — a **mirror is a second home** — and ownership settled on the code guide with four homes demoted. `doctrine-drift.sh` **cannot** hold it: fenced-code only, and this is anchorless prose, so the table's boundary is now known. N-017: not mobile but **17** directories, 5 of them Rust/desktop, and the audit was blind by construction because it walked files rather than directories. Rule recut on **who works there**; gate scoped to `code/src/**` after measuring that repo-wide ships **red on 95**, 62 being skill folders. Leaf exemption is arithmetic, not a path list. Fires proven both ways                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | [x]              |
| 15/08/2026 | N-009                 | **The charted question had already lost one of its two options, and the register's own remedy had already shipped.** Measured rather than assumed, on a live probe: an untracked `.py` file was absent from the graph after an incremental pass and present after `git add` plus the same pass — so staging is the fix. `full_rebuild` is **not** the rival it was charted as: it outlived the 120s MCP timeout twice, ran past 11 minutes with nothing else touching the store, and the CLI route dies on `database is locked` because the MCP server holds it. Meanwhile `CODE-REVIEW-GRAPH.md` had carried the staging rule since `68360d6` — landed **13/08, the day this map was charted**, so the node was charted against a register entry already half-answered. What was genuinely missing was the ordering in `.claude/CLAUDE.md` Section 6, where the hard gate lives; a citation does not make an ordering, and a reader who opens the guide to learn the order has already used the wrong one. Two findings arrived uncharted: an **aborted full build does not roll back** (177 files down to 171, `status` still reporting success), and the `PostToolUse` hook was **blind by construction** — incremental on every Edit/Write/Bash, so the graph looked continuously fresh while missing exactly what the session had just written. Fixed by wrapping it in `graph-update.sh`, which reports on change only via JSON `systemMessage` (plain stdout is discarded there) and never stages, because a hook that ran `git add` would commit work nobody chose. A third defect fell out of reading the same block: **four hook timeouts were in milliseconds against a seconds field** — 900000, 5000, 30000, 5000, i.e. 10.4 days, 83 min, 8.3 hours, 83 min. Every `bash -c` hook was wrong and every bare command right                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]              |
| 15/08/2026 | N-025                 | **The node asked what the field claims; the answer was that it points down the minority path.** A guide's `skills:` is read by whoever opens the **guide** — but Section 2.3 has skills fire on description match, so the dominant traffic is agent → skill → guide, and the field cannot prevent the decay N-015 blamed it for. So the obligation was **relocated rather than strengthened**: the field keeps its name and its one-way meaning (`routing-skills.sh` still owns "does the name resolve"), and the reciprocal duty moved to the **skill body**, where the practice already existed unenforced — all six skills carrying the 26 breaches already cited 4–15 guides each. **The map's 26/77 silently assumed a scope it never stated**: that figure is `code/docs/*.md` alone, and the same rule over all three top-level trees is 52. Widening it surfaced the finding that reshaped the clause — **11 of the extra 26 are `global-workflow`**, named as the second entry in nearly every how-to guide's list for its _conventions_, not as that guide's subject, and it already routes to those trees **by glob**. A literal-path check would have **punished the correct route-don't-restate pattern** and forced an enumeration churning on every guide added, so a **directory glob discharges the obligation** — which is what made the wider scope affordable and killed the incoherent "code guides reciprocate, PM guides do not" alternative. Clause 14 was **watched failing at 24 before any repair** (not 26: global-workflow's existing `project-management/docs/*` glob already discharged two, proving the allowance before it was relied on), then 41 citations across 13 skills took it to 0. Gate placement follows the folder's own routing rule — the finding is that a **skill** lacks something, so it is `skill-conformance.sh`, not `routing-skills.sh`; the two now read one key in opposite directions and `audits/CLAUDE.md`'s "neither can see the other's" was corrected in the same change. **N-027 got worse by exactly this work**: `stack-django` went 282 → 290 and moved from fourth-worst to **second-worst** in the warn band, with `.claude/CLAUDE.md` joining it at 279 from N-009 — six files now inside 270, where the node was charted at five                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]              |
| 15/08/2026 | N-027                 | **A node made worse by three other nodes in one day, and the worsening is what settled it.** Charted at five files in the warn band, six by the time it was taken — and the three movements were `stack-django` 281 → 290 on N-025, `audits/CONTEXT.md` 270 → 279 on N-007, `.claude/CLAUDE.md` entering outright on N-009. **Three nodes, none of them this one**, each spending someone else's headroom with nothing obliging them to notice. Sam's cut is that warn carries an obligation and it is the **crosser's**, expressed as a **ratchet** rather than an owner: below 270 nothing changes, at or above it a file may not get LONGER without a dated reason, and a file **born** in the band is held to the same bar or any file could enter at 299 unseen. **One flag, two baselines** — `--since <ref>`, lefthook from `HEAD` and CI from the merge-base — because a HEAD baseline alone reproduces the node's own creep one commit at a time; caught in the option list, not after shipping. The allowance is `docs-length-allow: <reason> (expires DD/MM/YYYY)`, making this the **third** expiry register and the first immune to N-006's objection: the parser refuses an undated marker, so the entry that rotted there cannot be written here. **Two silent-failure traps found by building it** — `cloc` infers language from the **extension** and emits nothing for an extensionless path, so a baseline via bare `mktemp` compares clean forever; and the rule's own Section 8 text tripped its own gate, fixed by **shape** (an annotation is a whole line) rather than by narrowing scope, since unlike the copy audits this one cannot stop reading instructional Markdown. `--self-test` builds a throwaway repository — a fixture directory cannot hold git **history** — and separates **7 cases**, the three negatives mattering as much as the positives. **No exemption for a register that grows by design**, so `audits/CONTEXT.md` becomes an index like anything else. The gate's first finding was against the rule text that created it: `.claude/CLAUDE.md` 269 → 277, deferred to 01/11/2026 with the reason written in                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | [x]              |
| 15/08/2026 | N-008                 | **The charted question named the wrong axis, and the answer was "none of them".** It asked which existing audit owns the conflict-marker check; measurement said no audit is a candidate, because every other one is scoped by **surface** and this defect is scoped by **file**. So it is a new script, and the placement was cheaper than charted — `check-audits.sh` globs the audits directory, so a new script is picked up by the pre-PR gate with no wiring. The three mangled forms were recovered from `3bd49e8` rather than assumed, and one of them changed the design: `=======` does not survive Prettier at all — it is read as a setext H1 underline, the line above is rewritten as `# …`, and the marker is consumed — while the open survives **indented** and the close becomes a nested blockquote. So the detector matches the open and the close only. That is not a compromise: every conflict writes all three, so nothing is lost, and `^={7}` was simultaneously the sole pattern with a measured false positive here (an `====` separator rule in a Django comment). Ships green rather than red, which is the N-025 lesson applied one gate later. Two side-findings: `template-update.sh` **already** grepped for markers with an anchored pattern that would have missed the real defect on both counts, now sharing one `_lib` regex; and the audit caught its own author twice — first the self-test fixtures, then a comment describing the old pattern — so the markers are built from repeated characters rather than written. Exemption is the house `conflict-markers: ignore` directive, accepted on the line, the nearest line with content above, or a code fence's opener, because an HTML comment inside a fence renders to the reader. Unfiltered in CI, deliberately: a path list for this defect is a list of the places it would still be missed — which also makes it eligible for the required set                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | [x]              |

| 16/08/2026 | _none — verification_ | **Nothing was settled, nine nodes were added, and `Blocking open` went back to 1 the day after it first hit 0.** All ten open nodes re-verified and all ten hold — N-030 **reproduced** by injecting `this-skill-does-not-exist` into `NEGATIVE-SPACE.md`'s multi-line array and watching `routing-skills.sh` report _"✓ Every routing skill resolves"_ across 563 names; SL-1/SL-2 re-measured (`uv lock --dry-run` → _Resolved 119 packages in 8ms_); twelve `audits/*.sh` green; every resolved node's artefact present. **Then the outside.** `copier copy` was run for real and **died** — `TemplateSyntaxError` at `audits/conflict-markers.sh:104`, the `<%` in `printf '<%.0s'`, shipped by **`8050ac7`, the commit that settled N-008**. `check-template-tokens.sh` had been exiting 1 and naming the line the whole time; `audit-template.yml` runs only on `[main, staging, dev, testing]`, so on `pm/base-health-map` **it has not run once in seventeen commits** → **N-032** (blocking) and **N-033**. `MAP-ABSENCE` was found holding **eight findings routed here on 15/08 and marked unactioned**; six adopted (**N-034**, **N-037** ×3, **N-038**, **N-039**) and **two refused after re-measurement** — the `07-review` heading/dispatch mismatch does not reproduce, and `doc-references.sh`'s `code/src/django/` skip is a rationale written into the script, not a blind spot. Two of the six were also **understated by their source**: `shipped-readme.sh` is six findings not three, and the tool-call residue dates to **`6dbec52`, 01/08**, not `35eeb12`. Measured here independently: the dead `uv` premise alive in ~15 live files → **N-036**; `VERSION` seventeen commits stale → **N-040**; SL-1/SL-2 charted as prescribed → **N-035**. Also corrected in place: N-027's `.claude/CLAUDE.md` deferral **never reached its 01/11 date** — `0e62bdc` took the file 326 → 208 and deleted the allowance; the warn band is five again, not six. **The standing lesson gained a second half: re-verify what another map hands you.** Four of eight inherited claims were wrong in date, count or kind | [x] |

| 16/08/2026 | N-032 | **Charted and settled in one sitting, because a template that cannot generate is not a thing to leave open overnight.** The fix is one character moved: `%.0s` consumes its `seq` argument and prints nothing, so `printf '%.0s<'` builds the identical seven-character marker as `printf '<%.0s'` while containing no Copier delimiter. **Equivalence proven byte-for-byte on all three builders before the edit**, not argued from the format-string rules. All three were reordered though only the first was at risk — `CLOSE` and `MANGLED_CLOSE` use `>` and were always safe, but leaving them bracket-first leaves a template to copy, and the copy is what reintroduces the class. The map's suggested escape spelling (`printf '\x3c%.0s'`) was **declined**: it works and it hides the character behind a hex code, so the next reader cannot see what the script builds. **The comment is the durable half** — six lines naming the constraint, why it exists, that this script shipped the defect on 15/08, and which gate catches it. **Proven four ways**: `check-template-tokens.sh` 1986 tokens exit 0 · its `--self-test` 8 probes, unclosed-variable check still firing · `conflict-markers.sh --self-test` 6/6 **including "fires on all 4 known-bad forms"**, which is what proves the reordered builders still emit real markers · and a full `copier copy` at **exit 0**, five tasks, `name = "gen-probe"`, a lock naming the project with **zero** `syntek-base` occurrences, the generated copy's own self-test passing inside the probe. Thirteen audits green after; no `CONTEXT.md` touched, since behaviour, flags and output are unchanged. **Batch A empty again — and that is a statement about the frontier, not the repository**, the class having now produced a member twice after being declared closed. **N-033 is untouched**: the fix does not explain how a red gate stayed red and unread for seventeen commits | [x] |

| 16/08/2026 | N-033 · N-029 · N-038 | **Batch B's first sitting, and the charted question was wrong about its own facts in the direction that made the fix cheaper.** N-033 read _"the gates never run on a feature branch"_; `pull_request.branches` filters the **base** branch, so a PR from any feature branch already fired `audit-template.yml` — `45e2be6`'s own message names gate faults _"this branch's own PR check found"_. The real defect is that **nothing fires between commits**, and the window that hid N-032 was seventeen commits with no PR in it while `check-template-tokens.sh` sat exiting 1 and naming the line. So the remedy split **by cost** rather than by branch list: the sub-second half (`[1/4]`, `[2/4]`) became a `lefthook.yml` pre-commit leg, the `copier copy` half (`[3/4]`, `[4/4]`) stayed at PR time, and `audit-template.yml`'s push trigger lost its branch list besides. **The leg's `set -e` is the class in miniature and was driven through lefthook 2.1.10 to prove it** — without it a failing `shipped-readme.sh` followed by a passing `shipped-memory.sh` reports **exit 0**. Self-tests were then made conditional on a `.github/scripts/*.sh` being staged (~4s ordinary, ~11s when a detector moves), on the reasoning that a detector stops discriminating only when somebody edits it. **A third member of the class fell out of building the second**: `check-audits.sh` looped over `shipped-*.sh`, a drifting list wearing a wildcard, covering two of four scripts and excluding the two that answer _can this template generate at all_. **N-038 was pulled out of Batch E** because the leg could not ship green over a red gate — all six of its findings came from nodes this map had already settled, four gates shipped and none registered. **N-029's write-up then forced a split nobody planned**: recording the eleven-job target set took `GIT-GUIDE.md` 269 → 292 and tripped N-027's ratchet, so the guide became a 39-line index over four sub-documents and **31 section citations were repointed**, 16 of them CI headers. The split is **provably a move** — 7 of 258 lines differ, all one deliberately-replaced paragraph. Two independent passes found one hard blocker (Prettier red on two repointed tables) and **three confident findings that did not survive checking**, which is the standing lesson repeating at the agent boundary. Out: **N-041**, `shipped-readme.sh` accepting a prose mention where a table row is required — proven by replacing a row with a sentence and watching it exit 0 | [x] |

| 16/08/2026 | N-028 | **Charted as a contradiction, measured as an omission — and that reframing is what settled it.** The map read _"`COVERAGE.md` says 75 no-exceptions, CI enforces 80"_, implying one number was wrong. Neither was: the 80 is a **deliberate promotion ratchet with its reason written out** in `how-to/workflows/06-quality-gates/CONTEXT.md` (_"a change that passes locally can still fail the promotion"_), documented across four files there and implemented in four gates. The only home that had never heard of it was the file whose own `CLAUDE.md` calls it _"a single source of truth"_ — so the false sentence was **"Hard floor — no exceptions"**, and the remedy was to teach the owner rather than delete the instrument. Settled: 75 always, **80 from `testing` upward**, 90 auth flat and untiered. **Two files charted, seven found** — `claude.yml` twice in comments and once in a command, plus `check-tests.sh`, `pre-pr-check.sh`, `backend-coverage.sh`, `scripts/tests/CLAUDE.md` — which is N-025's denominator lesson repeating one node later. Ownership on N-016's precedent, _a mirror is a second home_: four how-to files drop the number and route, and `code/docs/testing/CLAUDE.md` turned out to be **breaching the rule it stated**, forbidding restatement while restating two numbers and routing a floor change to `code/CONTEXT.md`, **which carries no floor at all**. **Three gates disagreed with the rule they claimed to enforce and none was charted**: `pre-pr-check.sh` ran `all.sh` without `--coverage` below staging/main with the floor at `0`, so a feature branch reported a green `[7/8]` having measured nothing; `claude.yml` ran bare `pytest` on every non-promotion branch; and the 90% auth floor ran in **two of four** Python paths. All three closed, on Sam's scope that no gate may disagree with the settled rule — leaving one is N-036 in miniature. Sam extended the hook's tier down to `testing`, which put hook and CI out of step at exactly one hop (`testing` → `dev`), so `test.yml` and `claude.yml` gained `dev`; **agreement proven at all five hops by extracting and driving the shipped `case` statements**, not by reading them. The auth floor is now measured separately from the aggregate and **fails closed** — proven at 40%, 90%, no-lines and not-XML, then driven through the sourced function in four states. **What is not proven, and is stated rather than implied: all four Python suites are guarded on a `uv.lock` that does not exist, so none has ever executed and no threshold has been watched firing.** That is N-035, which will be the first thing to exercise this node. Green: 19 audits, 3 template-integrity checks, docs-length, docs-pairing, Prettier, markdownlint. Also corrected in passing — **three stale prose counts** (18 open against 16, "remaining 18", 22 resolved against 25), the third such drift on this map, now carrying a standing rule to recount from the tables. **Tail fixed rather than charted at Sam's call** (`12973ef`): the eleven downstream restatements stay, being incomplete rather than false, but `DOCUMENTATION-PAIRING.md` turned out not to be a restatement problem at all — **Section 5 offered the coverage floor as a domain fact that _belongs_ in `## Key concepts` while Section 6 showed the same sentence as its _Bad_ example**, so the guide sat on both sides of its own rule. Section 5 now carries the reconciliation it always implied (a fact with an owner is a restatement whatever its grammar) and the floor becomes the counter-example there. The keeper is the dating: **Section 6's Bad half decayed inside the guide while nobody touched it** — this node gave the floor a tier, so it is now incomplete as well as duplicated and reads no differently for it, while the Good half needed no edit. A route-don't-restate guide now proves its own rule on its own page | [x] |

| 16/08/2026 | N-030 | **Settled by the Batch B session at `0c22b79`, written up by the N-028 one — so every claim here was re-measured rather than read off the commit message.** That is _a finding handed to you is a claim, not a conclusion_ applied at the **session** boundary, after the map and the agent ones. It all held. The premise: `NEGATIVE-SPACE.md` wraps its `skills:` array across **eleven** lines, the old `/^skills:[[:space:]]*\[/` selector matches it **zero** times, and the file was skipped whole — 571 names over 246 files became **579 over 247**, exactly the eight names and the one file with nothing else moving. **The map charted one selector and there were two**: `check_gated`'s list ran `head -20 \| grep -E "^skills:.*<name>"`, blind the same way and blind again past twenty lines of frontmatter, so a copier-gated skill inside a wrapped array was exempt from the co-variance clause **by accident** — the clause that is the reason this audit needs no allowlist. The keeper is that **two parsers disagreed about which files even have a `skills:` list**: clause 14 of `skill-conformance.sh` reads the same key to ask the opposite question and already handled the wrapped form, so both now source `_lib/frontmatter-skills.sh` on the `_lib/conflict-markers.sh` precedent — the copy that is wrong is believed exactly as much as the one that is right, and here **the weaker copy was the one guarding the gate**. Clause 14's verdict is unchanged at 119 names, which is what proves the share was a move. **Re-proven here, not accepted**: the original injection into the real wrapped array now exits 1 and names the skill where it once reported _"✓ Every routing skill resolves"_; `--self-test` passes **7 probes over both array forms**, asserts the clean half on its **name count** as well as its finding count (a skipped file and a correct file both report zero findings, which is the entire class), states what it does **not** cover, and the fixtures **assert they are still wrapped** so a future Prettier reformat fails the proof instead of halving it. **Residue, and a real open loop:** `git/PR-AND-REQUIRED-CHECKS.md:102` still reads `Hold` for `Routing skills resolve` with lines 114–117 still describing the defect in the present tense, though the node's stated exit condition is met. Not flipped here on purpose — the other half of promoting a check is a GitHub branch-protection setting no file can make, and a written claim ahead of its enforcement is this batch's own class | [x] |
| 16/08/2026 | N-030 · N-034 · N-041 | **Batch B's second sitting, and every one of the three was bigger than the map had written it down.** N-030 was charted as one blind selector and had two: `check_gated`'s file list ran `head -20 \| grep "^skills:.*<name>"`, blind to a wrapped array exactly as `:128` was and blind again past twenty lines, so a copier-gated skill named inside one was exempt from the co-variance clause by accident — the clause that exists so this audit needs no allowlist. Both now read `_lib/frontmatter-skills.sh`, shared with `skill-conformance.sh` clause 14, which had handled the wrapped form all along: **two parsers of one key, and the weaker was the one guarding the gate.** Measured across the tree, 571 → 579 names and 246 → 247 files, the difference being exactly the eight of `NEGATIVE-SPACE.md` and nothing else; clause 14's own verdict unchanged at 119. **N-034's list was the wrong shape, not merely short** — `x-for` was the charted miss and `x-modelable`, `x-id` and a colon-less `x-bind` were three more, so the rule now names the five directives that take no expression and matches everything else, including whatever Alpine adds next. Inverting it **also closed a false positive nobody had charted**: the unanchored `:` shorthand was swallowing the `:enter` of `x-transition:enter="{{ classes }}"`, correct escaped markup, and that is what makes the self-test go red on a revert rather than merely lose a hit. **The engine ran locally for the first time in this repository's life** — there was no local install route at all, and the instruction standing in for one told a developer to chmod an unverified download, against the CI job's own stated policy; `install-opengrep.sh` closes that, cosign required with no degraded path, and its four refusal paths were each watched failing. **N-041 was folded in from no sitting** and needed one helper: a register row is a table cell, not a tree row, so `in_row()` sits beside `in_tree()` and the self-test gained the sharper mutation — replacing a row with prose about itself, which a containment test passes and a row-aware test does not. Out of the sitting, unplanned: the comment rule's shell-script exemption **deleted** (`1775d6d`), after which every script in the repository needs auditing against it; and the `/handoff` document blocks every commit through markdownlint, which bites on every sitting that resumes from one | [x] |
| 16/08/2026 | N-022 | **The first node on this map that got smaller every time it was measured, and the only one so far settled by a grilling in the same session that corrected the map it sits on.** Charted as "cadence, owner, trigger condition" — measurement found the **cadence and the owner's producing half already written** at `how-to/src/TEMPLATE-GUIDE/02-STACK.md:136-137`, leaving only the trigger genuinely absent. Four rounds. **Ownership split by act**, because a single owner was never coherent: the template cannot know a downstream project's store-release schedule, so the **template produces** (follow every Expo SDK release, immediately) and the **project adopts** (on the first build that ships to a store — the trigger shape `MOBILE-CODING-PRINCIPLES.md:186` already uses for the error tracker). Sam took _immediately_ **against the recommendation** of waiting for the ecosystem, on the ground that Expo is one of ~20 pinned upstreams and a rule needing a per-release readiness judgement is a rule nobody applies. Homes settled by measurement rather than preference — `code/src/mobile/CLAUDE.md` **owns** the downstream half (two `code/docs` guides already cite it as owner, so naming a guide instead would have inverted two live citations), and root `CONTRIBUTING.md` takes the template's own obligation **because it is copier-excluded and never ships**: an obligation that reached a generated project would describe work its reader does not own, which is **N-037's defect class**. Two restatements demoted to citations. **Q4's finding, measured not assumed:** `dependencies/update.sh:213,216` run `pnpm update --latest` with **no `-r`**, and pnpm does not cross workspace packages without it — but `code/src/mobile/` **is** a member through `pnpm-workspace.yaml`'s glob, so **the Expo pin survives the routine sweep by one absent flag** and nothing said so; written down rather than fixed, the script being claimed by N-036 and N-010. **The `copier update` safeguard Sam asked for was already built and better than proposed** — `template-update.sh` previews by default, clones to a scratch dir, refuses `--apply` on predicted drift without `--force-deps`, and already warns conditionally; **one line was missing**, the post-apply "run the suites" its sibling `dependencies/update.sh:85` carries. **The general case was refused a node and seeded as its own map** (`MAP-UPSTREAM-TRACKING.md`) on Sam's call: nothing here watches upstream **releases** for anything — `audit-deps.yml` is a CVE sweep, `dependency-drift.sh` compares an incoming template, and `REFERENCES.md`'s stack table is 17 rows of which **9 read `latest`**. **An ADR was offered and declined** — this template authors none — and that refusal became doctrine at `../15-DECISIONS/CLAUDE.md` so the next session does not re-offer it | [x] |
| 16/08/2026 | _none — corrections_ | **A corrections pass that mostly refused to write what it was sent to write, and that is the finding.** Sam approved transcribing eight measured findings from `HANDOFF-BASE-HEALTH-N028-AND-BATCH-E`; re-measured first at `840acb3`, **four were refuted, two partial, two confirmed**, so half the approved edit was never made. **N-020's blocker is live**: the dates behind "it is false" are exact — `SERVER-ARCHITECTURE/` at `7cb6040`, 01/08, against a gap dated 09/08 (ten days by commit, `ce259df`) — but `NIXOS-HANDOFF.md` **disclaims** the contract rather than stating it, consigning the deploy script to the deploy repo at `:131-136`, marking its artefact map TBD at `:48-52`, and carrying a "do not treat the placeholder values as real" banner at `:5-8`, all present at `13de9b9` when the gap was written. **The finding had measured the file's birthday and inferred its contents.** **N-020's re-type was refused too** — `BUILD-OPERATE-SEAM.md:25` and `cicd/SKILL.md:4-5` carve the seam at different levels rather than contradicting, as `13-DEPLOYMENT.md:20-28` says outright. **N-021's blocker was misnamed, not false**: `docker-compose.test.yml` is genuinely self-contained but cannot host a rehearsal (tmpfs Postgres, `LocMemCache`, MD5, no superuser), and what actually blocks it is that **three of the four runbooks have no subject** — no `admin_db` alias, no audit model, no wired Fernet — while the fourth, Valkey cache compromise, does. **The charted "N-022 × N-031 share 10 files" does not exist**: both anchors are rows in **N-036's** table, a Batch D node. Written in their place: N-023's **second trigger arm** (`deny.toml:31` "or sooner if Slint bumps accesskit" — recorded nowhere else, watched by nothing, and cargo-deny's only passive signal fires _after_ the `Cargo.lock` regeneration it asks a human to notice); N-031's coupling as **one-way and conditional**, reproduced by deleting `TEMPLATE-GAPS.md` in a throwaway clone — three violations, only one charted, and two of the node's own three sites would not redden at all — with its citer set measured at **eight shipped files against a table of three**, three of them invisible to the gate through a `TEMPLATE-GUIDE/*` exemption written when that tree was still excluded; the **three real Batch E collisions** (N-020×N-021×N-031 on `INCIDENT-PRACTICE.md:199-206`, N-021×N-031 on `MONITORING-AND-INCIDENT.md:69-73`, N-026×N-037 on `stack-django/SKILL.md`), which leave **N-022 as the only node takeable alone — not N-037, as the handoff directed**. **N-037's row was wrong twice and nobody had been sent to check it**: "three shipped skills" over an evidence table naming two, and `Blocked by: none` when its `stack-django` half is N-026's subject verbatim; its claims table is a floor (~10 more uncharted assertions), and one of its three charted lines needs the **number** fixed rather than the line deleted, the axe scan being real and deliberately empty (`test_e2e_a11y.py:8-10`). A `task` → `grilling` re-type is **proposed and not applied**. **All three printed counts were stale** — 14/0/27 against 12/0/29 — the fourth drift and the first since the rule against it was written on this page, with the same error mirrored in two _Gate to stories_ items, one of which is a checkbox recording a previous recount. N-041's row updated to name `840acb3`. **The standing lesson gained a third half: re-verify what a handoff hands you** — four of eight, the same ratio as the `MAP-ABSENCE` intake that morning, from a different source in a different format | [x] |
| 16/08/2026 | N-036 | **The sweep found the map's own table wrong in both directions, and caught the class reproducing inside the node that was clearing it.** Charted as ~15 files carrying the dead `uv` premise; **8 had already been swept by N-035**, including root `CONTEXT.md`, the row a handoff had called highest-leverage — a node that changes a fact corrects the prose it passes. **6 live sites the table never listed** were found by sweeping for the premise instead of reading the row list, four of them unreachable from it: `check-security.sh`, `render-slop.sh`, `audit-template.yml:102`, `audit-deps.yml:41,69`, `PR-AND-REQUIRED-CHECKS.md:76,86`. Both charted errors confirmed — `code/src/mobile/CONTEXT.md` carries no `uv` premise (its `absent by design` is Expo CNG's `ios/`/`android/`), **row struck**; `06-quality-gates` **under-counted by two**. **By execution the premise was doubly dead**: charting said _the fact holds, the reason is dead_, but N-035 committed the lock, so `uv.lock is absent` was false too and every site was wrong rather than half-wrong. **`syntax-python.yml` carried three defects, not one** — a header claiming the name is _still_ a token, a header contradicting its own body on whether basedpyright is guarded, and a third **written by N-035 hours earlier**: the body called `--frozen` _"an impossible [assertion] in the template, which commits no lock"_, in the commit that committed the lock. A node can create an instance of the class it is clearing. **The keeper is `PR-AND-REQUIRED-CHECKS.md:86`**, which cited `TEMPLATE-GAPS.md` SL-1 for _the backend suites guard to success here_ — N-035 **rewrote SL-1 to say the opposite**, so the citation did not rot but **inverted**: still resolving, still authoritative-looking, now claiming the reverse of its source, and nothing lints that. **Guards untouched throughout** on N-035's doctrine — not one line of logic changed across 16 files; where a dead reason justified a live choice (`uvx --from`, `--no-project --with`) the choice was re-justified on its surviving merits rather than reverted. **`doctrine-drift.sh` measured and refused: 0 of 7 homes reachable** on two axes (md-only `SCAN_DIRS`, fenced-only matching), and the deeper objection is that it would have to separate _"is absent by design"_ from _"used to be absent by design"_ — narration this repo requires and these very corrections contain. **Tense is meaning**, against a script whose invariant is shapes-never-meaning. Residue named rather than silently dropped: four `installs nothing to cache` claims in `syntax-python.yml` need CI cache measurement, not a read. Green: 6 audits, prettier, markdownlint, template-tokens, `bash -n` ×3, YAML parse ×6, parser `--self-test` | [x] |
| 16/08/2026 | N-035 | **Written by the session that took N-036, not the one that did the work — and the first inherited claim set on this map to survive re-measurement whole.** The Batch B session landed seven commits (`b805774`…`bde5cc6`), pushed, wrote a handoff and moved to its PR **without moving the row**, so the map showed a settled node as open and anyone reading the frontier would have taken it as available work. Re-measured at `bde5cc6` rather than transcribed: **nothing refuted**, against a standing lesson that had found four of eight claims wrong twice running. **The charted question was answered in the order the node insisted on** — the whole reason N-035 was `grilling` is that committing `uv.lock` flips four suites from skip to run automatically, and _"whether they pass is unknown, and finding out by merging is the wrong order"_. Reproduced independently here: `backend-coverage.sh` → **100% over 162 statements, 22 passed**, 75% floor reached; `basedpyright` → **0 errors**; `pip-audit` → **no known vulnerabilities**; four containers healthy; `/health/` → `200 ok` and `/health/ready/` → `{"status": "operational"}`. **SL-1 and SL-2 settled together as the sequencing demanded** — SL-2 **deleted outright** (zero occurrences), SL-1 **rewritten rather than corrected**, two false limitations replaced by the one that is true and permanent. **The node grew an app it was not charted for, and it was right**: `apps.health` did not exist while **every production container had always probed `/health/`**, the compose healthchecks pointed at `/control/` to paper over it — a lockfile node finding a probe with no subject, which is N-036's defect class wearing different clothes. **Residue kept honest**: the 75% floor has now been watched firing, the **90% auth floor has not** and cannot until `apps/users/` exists, and the script says so rather than reporting a green. It also **wrote one instance of the class N-036 was clearing** — `syntax-python.yml` called `--frozen` _"impossible in the template, which commits no lock"_, in the commit that committed the lock; cleared at `33926e9`. That is the argument for the sweep following the change rather than preceding it | [x] |
| 16/08/2026 | _none — Batch E verification_ | **A four-step pass over Batch E — read, challenge, verify, review — carried by fifteen separate agents, no step reviewing its own work. Nothing settled; three nodes charted; two premises found dead and one node killed outright by a sibling node that moved no row.** **N-023 is dead as charted**: `b805774`, the first of N-035's seven commits, deleted both `quick-xml` ignores because the MSRV floor moved 1.85 → 1.92 and `zbus` 5.19 dropped `quick-xml` from the graph entirely. `deny.toml:26` is `ignore = []`. The corrections pass had written a careful second-trigger-arm analysis of `deny.toml:31` at **13:22**; the line ceased to exist at **15:14**. It was right when written, and the residue is seven shipped sites still asserting the ignores exist — plus `SUPPLY-CHAIN.md:42`, flagged false on 16/08 and now **true again by the same commit**. **N-020's obstacle (b) is half-refuted**: `config/urls.py:21` mounts `apps.health`, so the endpoint exists and only the caller is missing; a re-type to a three-way split is **proposed and not applied**, because two of its three scripts fail the map's own "unwritten artefact with a named owner" test. **N-037's blocker is false at its three charted claims** — none of `:33`, `:169`, `:259` touches `api.py`, and the map contradicts itself on the coupling's scope in two places written the same day. **N-031's reproduction was re-run and the baseline was never clean**: exit 1 → exit 1 with four violations, not exit 0 → exit 1 with three; the three charted `TEMPLATE-GAPS.md` sites reproduce exactly, the fourth is the new **N-042**. The original run had been made **without a git repository**, where `doc-references.sh:81`'s `git ls-files` returns nothing and the script reports _"Clean — every citation resolves"_ having examined **no files at all**, printing no file count unlike every sibling audit. **The three-way collision N-020 × N-021 × N-031 does not survive measurement** — `INCIDENT-PRACTICE.md:198-206` is headed `## Rollback` and names none of the four security recoveries, so N-021 is not coupled to N-020 and the two can be scheduled apart. Charted out of the pass: **N-042** (Batch B — `doc-references.sh` green on a developer's disk, red on a fresh checkout, because `shipped-readme.sh:141` cites the generated, gitignored `MACHINE-SPEC.md`; the local gate globs it and passes, CI checks out clean and fails, and the comment on the very line it trips over is the one explaining this hazard for a different script), **N-043** (Batch E — the shipped exclusion register at `06-GENERATION.md:96-105` says "five groups" over six rows, lists `TEMPLATE-GUIDE/` and `TEMPLATE-TOKENS.md` as excluded when both ship, and omits `/uv.lock`; it is the rule N-031 would classify against), and **N-044** (Batch D, **reopening a class closed the same day** — the health caller is `health-check.sh` in five shipped sites and `health.sh` in the uncommitted `HEALTH-PROBES.md`, with `config/urls.py:8-11` supplying a third answer by consigning it to the deploy repo). Gates run for the pass: **24 audits, 4 template-integrity checks, all green locally** — which is precisely N-042's point. **The standing lesson gained a fourth half: re-verify what a _sibling node_ hands you.** It already covers a map, a handoff, a session and an agent; N-035 retired a node in another batch and moved no row, on the same morning its own row was left unmoved by the session that settled it | [x] |
| 16/08/2026 | N-010 | **Batch B closed. The node was executed rather than reviewed, and that is the whole finding.** All five how-to workflows ran here — its "`04`/`05` need generation" premise had died hours earlier with N-035's `uv.lock`, so the node was smaller than charted in scope and far larger in yield. **Nine defects, seven of them commands that do not exist or cannot work**, every one passed by three prior sittings of review: `shell.sh --command` and `server.sh rebuild` are not commands; `06`/`07` both documented `pre-pr-check.sh` in a form that **exits 0 having run nothing**, because it is a `PreToolUse` hook reading JSON from stdin; `06` claimed bare `format.sh` rewrites when it is a dry-run, and claimed `strict` type-checking against two configs reading `standard`. **The sharpest was `reset.sh`, which had never once worked** — unquoted `$DB_NAME` in four DDL sites (fatal for the hyphenated slug `copier.yml` _mandates_) over an empty `DB_NAME`, because its fallback sat in an `else` while `.env.dev` deliberately carries no `POSTGRES_DB`. Both destructive scripts proven working afterwards, against a real drop and restore. **Four artefacts, not just corrections**: `how-to/docs/HEALTH-PROBES.md` (whose failure modes are observed, not imagined — readiness reported `operational` for the first **16 seconds** of a real database outage), `development/health.sh`, `server.sh stop`, and the Bruno collection's first ever requests (11/11). `MAILERS` replaced the deprecated `EMAIL_BACKEND` ahead of Django 7. **N-037's three charted claims fixed in passing, and its class widened** by two further sites in a document type it never covered. **Two nodes charted out of its own evidence** — N-045 and N-046 | [x] |
| 16/08/2026 | N-040 · N-044 _(rescoped)_ | **A challenge pass over Batch D and N-040 — fourteen agents in four steps (read, challenge, verify, review), no step reviewing its own work, read-only throughout. Both nodes died on their premises, and neither died the way it was expected to.** **N-040 was already settled and nobody had moved the row**: eight `chore(version)` commits took 4.0.0 → 5.3.0 between 18:16 and 18:20, **69 minutes after this map's last write**. Four-way parity measured rather than read — `CHANGELOG.md`, `RELEASES.md`, `VERSION-HISTORY.md` and the tag namespace each hold 56 versions with every `comm -3` empty, `VERSION` = the newest of all three = `git tag --points-at HEAD`, and `git rev-list --count a9c56a1..HEAD` = 0. All ten items the node called unlogged are described at `CHANGELOG.md:13-240`, checked one by one rather than in aggregate. **Three of its subsidiary claims died with it**: it does not compound N-038/N-039 (those gates are pre-commit, and `24-release/STEPS.md` has no audit step), and the N-032 sequencing was **moot rather than honoured** — every tag from v4.0.0 was cut from one frozen tree, so no ordering could have tagged a broken template. Crediting a discipline nobody exercised was the first challenger's overreach and is refused here. **N-044 was charted against a window that had closed 31 minutes after this file's previous save** — `ec8e807`, 17:42, against an mtime of 17:11 — and its subject dissolved on measurement: `deployment/health-check.sh` (planned, CI-triggered) and `development/health.sh` (shipped, diagnostic, _"restarts nothing"_) are **two artefacts, not two names**. Its `grilling` type revived the seam argument **MAP:1339-1344 had already refuted for N-020 that same day**, without citing the refusal; re-typed `task`. It fails the Batch D class test outright — all five sites agree and `HEALTH-PROBES.md:18-19` declines to own the rule — so **the reopening claim is withdrawn as to N-044 and reasserted on three uncharted members**, one of them (the Prometheus job name, four homes, two spellings, drift recorded in a shipped file) **one `grep` from every agent in the chain and found only at the verify step**. Also corrected: N-039's _"thirteen releases"_ is **49** and was never right; the N-020×N-021×N-031 collision row, which the map's own verdict had contradicted 180 lines earlier; and **the seventh count drift**, this time two settlements deep. **Eleven overreach items were named and discarded**, the sharpest being a challenger marking a claim _holds_ against its own contradicting output. **Residue held back one turn, then charted on Sam's call as N-047 to N-052** — six of ten candidates taken, the four held being the ones that argue _about_ the classes rather than instancing them (two ungated version surfaces, the unattributed `deploy.sh`, the map's own two-home typing rule), plus three items the reviewer had explicitly not re-measured. **Nothing was charted into Batch A**, which another session holds | [x] |
| 16/08/2026 | _none — charting_ | **Six nodes charted from the challenge pass's own evidence: N-047 to N-052, and the frontier grew from 12 to 18 on an evening that settled a node and killed another's premise.** Charted in the order the evidence ranked them, not by batch. **N-047 is the only node on this map whose cost lands in someone else's repository** — the `v5.0.0` migration advisory fires four tags after the break it warns about, because retroactive batch tagging put all 45 content commits inside the `v4.0.0` tree; a project updating to v4.0.0/v4.1.0/v4.1.1 takes the break and never sees the warning. Typed `grilling` because the facts are measurable and the remedy is not: re-keying rewrites what a published tag meant. **N-048 and N-049 are the members Batch D's reopening claim was moved onto** after N-044 failed the class test — the Prometheus job name (four homes, two spellings, and `HEALTH-CONTRACT.md:134` disclaiming ownership then asserting at `:95`), and **N-016 decaying**, the first demonstration on this map that a _resolved_ node can come back. N-048 carries a correction to the map with it: `doctrine-drift.sh` **can** reach that instance, so the twice-stated "the Batch D audit cannot hold a Batch D rule" is too pessimistic by one counter-example. **N-050 and N-051 are charted as a pair across two batches** — the shipped `3.2.2` assertion and the three-homed version rule that produced it — on the N-035/N-036 precedent that a cause and its sweep are decided once and written once. **N-052 closes the loop on N-044**: the naming hygiene that node now carries has no enforcement, because `doc-references.sh:183-186` skips any token without a slash, leaving all five `health-check.sh` sites and 15 of 16 `health.sh` references ungoverned. Typed `grilling` on N-025's standing warning — the population has never been measured and the rule must be true before the instrument ships. **Four candidates were deliberately not charted**, and the reason is uniform: each argues about the taxonomy rather than instancing it, and the fog-of-war question owns that. **Three more were refused pending re-measurement** — the "Supported platforms" triple-home whose drift half no agent verified, and the N-028 and N-036 residues that reached the reviewer unmeasured. **The standing lesson applied to the pass's own output**: a finding good enough to report is not automatically good enough to chart | [x] |
| 16/08/2026 | _none — Batch E and N-039 challenge; Batch A closure refused_ | **Sixteen agents over two legs — challenge, verify, review, no step reviewing its own work — across all eight Batch E nodes plus N-039, and a measure-then-refute pair on the Batch A closure Sam asked for. Nothing settled; two nodes charted; the closure refused by a member rather than by history.** **Batch A does not close.** The criterion was established rather than assumed: **Batch C closed on node settlement**, its generalisation reading being a later, hedged rationalisation — a low bar, and the bar Sam asked for. Batch A fails it anyway, because **`.github/workflows/test-api.yml:86` is a live member**: a token in a shell word, measured not argued (`LOOP_EXIT=0`, three `No such file or directory`, the `&& break` never firing), which went live at `b20167b` when `uv.lock` flipped the step's `[ -f uv.lock ]` guard from skip to run — **an activation this map predicted and nobody swept for**. The population is now closed at **74 tracked non-markdown files carrying `<%`, exactly one in an executable shell word, no third member** → **N-053**. Two shipped gate headers overclaim and ride with it: `check-template-parsers.sh:34-37` claims the class _"by definition, including `--health-cmd`"_, false by measurement and in principle, and `lefthook.yml:142`/`audit-template.yml:13` print the branch length (seventeen) while naming the ride (four). **N-054** charted from the reviewers' own sweep: `HEALTH-CONTRACT.md:34` names four readiness dependencies against `checks.py`'s two and `:32` publishes a `/metrics/` nothing serves, both left standing by `ec8e807`, which edited that very file. **Two nodes grew sharply and both had under-counted themselves** — N-031's citer set 3 → **33 files / 77 sites** plus an unnamed class of **41 shipped files citing the self-excluding `copier.yml`**, and N-037's floor ~10 → **87 sites across 42 of 270 shipped documents**, every one hidden by a single missing `code/src/django/*` case in `doc-references.sh`. That same missing case couples N-031, N-037 and N-043 to one decision, **a batching argument this map did not previously make**. **N-046 shrank** to one confirmed bullet: one specimen was repaired four hours before the node was charted, the other is contradicted by the script since 01/08. Corrections landed on N-020 (the build half of _"builds or pushes"_ is false — `grep 'docker build'` cannot match `docker compose … build`), N-023 (the cross-references **dangled from birth**; `git log -G` empty across seven commits; residue **9 sites / 7 files** with the denominator finally stated), N-026 (`apps/core/services/` dates to `ce259df` 11/08, not 14/08), N-042 (blast radius **exactly one site** over a 1,007-file candidate set) and N-045 (a copied file breaks at **variable resolution** before it reaches the 404). **N-021 needed no edit at all** — a confident refutation had silently changed the subject from `test.py`'s hashers to Postgres host auth. **The pass failed twice in the same way and caught itself both times**, which is the evening's real finding and is now the standing lesson's general shape: **a frontier is only empty when a search that could have found a member came back empty**. Both failures were claims of absence from a search that could not have found the thing, both came from the two **bounded** legs, and each was caught by a different downstream agent — **a pass with any single leg missing would have written a false verdict here** | [x] |
| 16/08/2026 | _none — Batch B verification_ | **An 11-agent pass over Batch B — challenge, verify, review, no step reviewing its own work, read-only throughout — plus an earlier killed run of the same scopes whose N-046 and settled-node results were preserved as an independent second measurement. Nothing settled; five nodes charted (N-055 to N-058 into Batch B, N-059 unbatched); four amendments; `Blocking open` held at 0 against two proposals to raise it.** The batch's thesis instanced itself four ways. **N-055**: four gates skip a leg they cannot run and print success — with two facts neither leg of the pass produced: `format.sh --output json --quiet` persists `{"exit_code": 0, "output": ""}` over zero files examined, and a skipped host leg makes `pre-pr-check.sh:299-301` fabricate `MISMATCH: passed locally, failed in Docker`. **N-056**: six gates green over a population of zero — where `docs-pairing.sh`, offered as the class's closure, measured as its **worst member**, printing a pre-filter denominator of 216 files against a nonexistent `--path`. **N-057**: a required status check no pull-request event can produce (`audit-deps.yml`, the only one of 35 workflows with neither `push:` nor `pull_request:`), in a guide that went stale **2h17m** after it was written — the ten-unnamed-contexts direction **refused**, engaging this map's own prior refusal of the two-context version. **N-058**: two bare `pre-pr-check.sh` invocations survived N-010's fix, one in a skill an agent executes, both observed at EXIT=0 having run none of the eight gates — N-010's row not reopened, the miss sitting outside its two named files. **N-059**, unbatched: lefthook 2.1.10 **does expand braces** — four live legs in the same file depend on it, the exact glob the shipped comment says _"matched nothing"_ fires on `TEMPLATE-TOKENS.md`, and the real fault is **order-sensitivity** (a multi-alternative brace group whose wildcard-bearing alternative is not last silently mis-compiles), recorded nowhere. Refuted along the way: check-lockfiles' fresh-clone framing (three `_dc exec` failures each set `exit_code=1`, so no container is a red check); the dossier's "790 vs 793" (no count was ever charted); the challenger's claim that N-042 leans on a workflow comment (the map never cites it — the lean was the challenger's own, its evidence field admitting branch protection was never measured); and the same challenger's refutation of the map's four-violation record, which had compared HEAD against the `TEMPLATE-GAPS.md`-deleted reproduction. Amendments: N-046's `lint.sh` bullet **un-contests** with the cause moved from the script to `markdownlint-cli2`'s appended `globs` array (a run scoped to one file linted **793** and reported its only findings in a file it was not given), and it gains `copy-emdash.sh` as the live specimen its struck bullet asked for; N-042 was **understating itself** — `Citations resolve` is one of ruleset `20221742`'s 20 required contexts, so its red is unmergeable into `main`; N-053 gained a token-free second member (`test-api.yml:98-103`, uncorrected N-035 residue probing `/control/`, misattributing a dead database as a Bruno failure 120 seconds later); N-030's residue citations re-anchored after drifting in under a day. **The pass corrected its own instructions twice** — the re-measurement leg re-typed four of five candidates from `task` to `grilling`, each because the remedy carries a cost the `task` framing hid, and the amendments leg refuted two premises in the brief it was given. Cost: eleven agents in three steps, one killed run salvaged as a second measurement, and not one repository file written | [x] |
| 18/08/2026 | N-053 | **Batch A's frontier empties for the third time, and the node's own remedy was the thing that did not survive.** First node opened after a gap — the map was two days stale and the tree had moved by a version bump and two commits — so every premise was re-measured before it was believed. **All of them held**, including `LOOP_EXIT=0` reproduced by execution and both populations re-swept at the map's own figures (74 files carrying `<%`, exactly one in an executable shell word; three CI wait loops, two unfailable). **Three of the node's own facts did not.** Its prescribed fix — `pg_isready -U "$POSTGRES_USER"` — **would have failed open**, because a workflow `run:` block is expanded by the runner and this job's `env:` sets no `POSTGRES_*`; proven with an argv stub receiving `[-U] [] [-d] []`. Compose's `$$` and a `run:` block are two escaping regimes and the node collapsed them; the working form is `exec -T db sh -c '…'`. It **walked past a member inside its own citation** — `test-e2e.yml:89`, in the very block held up as the correct form, carried the same `/control/` residue it charts at `test-api.yml:100`. And **both** `test-api.yml` loops were unfailable, not one, so the charted token fix alone would have left a bare Batch B defect where a Batch A one had been. **The residue's correction was itself off by one**: seventeen is right, four is not — `8050ac7` introduced the break and `21d77d7` fixed it, so five commits carried it; both shipped headers now name both quantities and say what each measures. **The `--health-cmd` overclaim was refuted by measurement and had been stated twice** — a compose file carrying the token in a `CMD-SHELL` healthcheck passes `docker compose config` at exit 0 — so `check-template-parsers.sh` now states its boundary and routes the shell-word row to doctrine, no parse-success probe being able to reach it. **Proven in both directions against a real container**: new form `accepting connections` exit 0, old form `no such file or directory: %PROJECT_SLUG%`; the new loop driven to **exit 1** unreachable and **exit 0** healthy. Keeper — in this tree `POSTGRES_USER` is literally the token and Postgres created that role, which is why asking the container for its own user is right in the template and downstream alike. Five files, all six lefthook legs and three audits green. **`exec -T` was conformance, not a decision**: 18 sites carry it and these two were the only ones without. **The sibling-map duty was paid and found two rows missing from this map's own table** — seven live maps, not five. **Stated rather than implied: these CI steps have still never run.** The last ten `test-api` runs finished in 7-32s with `steps.detect` false, newest 15/08, before `b20167b` committed the lock — so their first real execution will be their first ever | [x] |
| 18/08/2026 | _none — a finding fixed rather than charted, then a re-measurement pass_ | **The `COMMITS.md` Step 2 finding was offered as N-060 and Sam declined the node, so it was fixed instead — and the fix touched two open nodes' evidence, which is the reason this row exists.** The finding: Step 2, mandated _"before every commit, no exceptions"_, documented two commands that **both exit 2** — `lint.sh --file-type typescript` and `check.sh --file-type typescript`, where `lint.sh` accepted `python markdown css` and `check.sh` accepted `python javascript`. **Not a typo of one word**: `lint.sh` had no JS or TS lane at all, and `check.sh`'s `javascript` token gated `tsc`, naming the wrong language for the only leg it controlled. Settled by grilling over eleven questions: one token per **language** — `javascript` the web surface's Alpine and enhancement scripts, `typescript` the mobile surface, `rust` the Cargo workspace — with the aggregates **delegating** to `scripts/mobile/*.sh` and `scripts/rust/*.sh`, which stay canonical for CI and lefthook. `rust/lint.sh` gained `--fmt-only` because its `--fix` also runs `clippy --fix`, and a format command must not rewrite logic. **A bare run now covers exactly the surfaces present**, proven against a tree with neither optional directory; naming an absent surface exits **2**, which deleted an N-055 member. **Two findings arrived on the way.** `format.sh` could not reach the 11 tracked `.ts`/`.tsx` files that root `pnpm format` and lefthook's prettier leg both cover, so `format.sh --fix` could leave a tree the hook then rejected — proven in both directions with a planted breach. And **`--help` was broken on all ten `rust/` and `mobile/` scripts and had been**: `_common.sh` cds into the surface directory before argument parsing, so the relative `BASH_SOURCE[0]` stopped resolving and `bash code/src/scripts/mobile/lint.sh --help` — exactly how every doc invokes it — printed `sed: can't read`. Uncharted, in the blast radius, fixed with an absolute `SCRIPT_SELF`. Shipped as `b4ed0b9`, 29 files, all nine lefthook legs green, 20 audits green, both fixture self-tests still separating, backend 50+22 / mobile 16 / rust green. **Then the pass that this row is really about: 47 agents over N-046 and N-055 — five measurements, one adversary per finding, one completeness critic — because the commit had moved files both nodes cite.** 49 findings survived, **10 were refuted by the adversary**, and the corrections were not cosmetic: N-046's specimen count was wrong **in both directions** (eight correct siblings, not three; and **four** scripts carry the subshell defect, not one), its `format.sh` bullet's specimen is dead while a **stronger** member lives on in `.claude/skills/review/SKILL.md:21` — false since the file was created and never edited since — and N-055's _"only guard of its kind"_ confused a search with a population. **Fifteen stale anchors re-resolved, and the offsets are not uniform**, so none was recoverable by adding a constant. **`b4ed0b9` removed one N-055 member and added three**, all three found by the completeness critic rather than by any finder or adversary — a finder is scoped to a bullet, and a bullet cannot ask about a member created after it was written. **Nothing was charted and nothing was resolved as a node, so the counts do not move**: 24 + 35 = 59 = N-059, recounted from the tables | [x] |
| 18/08/2026 | N-046 · N-055 | **Batch B's third sitting, taken as one because the map's own collision table forbade taking them apart — and the pass that opened it refuted six of the two nodes' own facts before a line was written.** The rule is stated once, in a new `code/docs/GATE-REPORTING.md`: _"could not look" is never reported as "looked, and it was clean"_. It turns on a distinction nothing in this repository had written down — an absent **tool** leaves a full population unexamined and is never clean; an absent **surface** leaves a legitimately empty one and correctly is — which is why `audits/CLAUDE.md`'s self-guarding rule survives as the guide's second row instead of being contradicted by it, and which finally gives the **N-055/N-056 boundary** a line. Three families route to it and none restates it. **Three idioms, one rule**: exit `3` for the syntax scripts (non-zero deliberately, so a caller treating any non-zero as failure fails closed), an `unmeasured` state for the hook check libraries (reported in its own tier, **not blocking** — a missing host tool is ordinary on a developer's machine and a gate that blocks the maintainer gets switched off), and `audits/` unchanged. **The verdict is now decided before the report is written**, so `--output json` carries `exit_code: 3` and an `unrun` array where it used to carry `{"exit_code": 0, "output": ""}` over zero files examined — the half that had no notice in either channel. `_dual_result`'s seven state combinations were unit-tested; host-unrun + Docker-red now names the real failure instead of asserting **`MISMATCH: passed locally, failed in Docker`** over a host result that was never produced. **`lint.sh` lost the `css` token** — a type that could only ever print an informational line and pass is a clean verdict over a population nothing examined; a breaking change to a documented flag, taken deliberately. **Six of the nodes' own facts died.** N-046's specimen count was wrong **in both directions**: eight siblings carry the correct guard, not three, and **four** scripts carry the subshell defect, not one — `copy-emdash`, `seam-contract`, `conflict-markers` and `skill-conformance`, the last printing a success line naming the **default** scope while the operator had asked for another path. `skill-conformance`'s guard reads `$t` and not `$TARGET_PATH`, **so no grep on the guard string could ever have closed that population — only executing every script did.** N-046's `format.sh` specimen was dead and its mechanism was not: `.claude/skills/review/SKILL.md:21` asserts _"This skill writes. Its pre-flight runs `format.sh`, which rewrites source"_ — one commit in its history, never edited, **false on the day it was authored**, in a skill an agent executes whose definition of done consumed the inference. N-055's _"only guard of its kind in the directory"_ confused a search with a population, and `_dual_result` has **four** callers, not the five the node claimed. **And a charted member was refused**: `context-threshold-handoff.sh` is documented in `.claude/hooks/CLAUDE.md` as always exiting 0 by design, because it fires on every prompt submission and must never block typing — it produces no verdict, so it claims nothing and cannot claim something false. The class is five, not six. **The remedy the map called expensive turned out to be free**: `--no-globs` was charted as discarding all 16 `globs` negations with `ignores` re-covering only 4, but `--no-globs` **plus `:`-prefixed literal paths** keeps every one, because `markdownlint-cli2` filters literal files through the config's negated globs regardless — proven both ways, and a one-file request went from **794 files to 1**. **Two new defect shapes were found and both are the inverse of this node's**: ESLint errors when every file under a `--path` is ignored, and ruff answers `No such file or directory` for any `--path` outside the django container's single mount, so both reported **false reds** — a result the run did not produce, in the other direction. Neither was charted; both are fixed and the guide covers both. **`b4ed0b9` removed one N-055 member and added three, and all three were found by the completeness critic rather than by any of the five finders or their ten adversaries** — a finder is scoped to a bullet, and a bullet cannot ask about a member created after it was written. Shipped as **two** commits, deliberately: `3c0da01` closes the class, `be63789` the self-inflicted set, because burying the second inside the first is how it stops being visible. Counts recounted from the tables, not carried forward: **22 + 37 = 59 = N-059** | [x] |
| 18/08/2026 | _none — version + corrections_ | **A release session, and it found a hole in the one thing this map had already declared measured.** Cut **5.5.0** for the seven commits since the 5.4.0 bump — MINOR against `CONTRIBUTING.md:185-205`, syntek-base's public API being the template contract: `copier.yml` untouched across the whole range, no routing contract removed, no inherited directory moved, one file added. **That settles the handoff's open question 1 by reading rather than judgement** — `lint.sh` rejecting `--file-type css` is a script flag, which that declaration puts outside the contract and inside its PATCH row, so a deliberate breaking change to a documented flag does **not** force a MAJOR. **`v5.4.0` had never been tagged.** `VERSION` read 5.4.0 from `866d59d` (17/08) and all three logs carried the entry, but no tag existed locally or on origin and no release was cut: **57 log entries against 56 tags**. N-040's verdict records four-way parity as _measured_ — each of the three logs and the tag namespace holding 56, every `comm -3` empty — and that was true when written at 5.3.0 and **stopped being true one commit later, with nothing watching**. The handoff recorded `VERSION` as five commits back and did not notice the tag was absent at all, which is the same shape as N-040's own defect one turn further out. Tagged at `866d59d`, the commit where the version actually moved — **not N-047's failure mode**, which is eight bumps back-filled onto one frozen tree where no tag could key a migration to its break. Parity restored and re-measured: **58/58/58/58, every `comm -3` empty**. Both releases cut as **pre-release**, matching every v4.x/v5.x before them. **Corrections written, nothing settled.** `TEMPLATE-GUIDE/` **ships** — pinned to `f5fef31`, 14/08, **v3.2.0** — and the map asserted otherwise in its **own voice at exactly one site**, N-012's rejected option (c) in _Resolved decisions_; N-043 and N-031 already carried the correction, so the sweep found one live falsehood rather than the several expected. The fact is now stated once in N-043 with the consequence nobody had written down: those files are **rendered**, so a guide there quoting token syntax needs a `raw` block, which is why the belief is more than untidy. **N-037 has grown by a third in two days with nobody working on it — 87 → 117 sites, 42 → 62 files** — and gained a reading it never had: **50 unique unresolved paths**, so the remedy is 50 judgements repeated 2.3 times each, not 117. Its missing-`case` anchor re-resolved `:243-249` → **`:252-258`**, a drift of nine, while N-043's `:26` and N-031's `:88` both **hold exactly** — one file, three edits, two adjacent `case` blocks, which is the measured argument that these three batch together but cannot run concurrently | [x] |
| 18/08/2026 | N-043 | **The register that describes what a project does not receive was verified by generating one, and the guide had been contradicting itself in the same file for four days.** All six charted claims re-measured first: one already dead (`:98` reads _"six groups"_ since `866d59d`), four holding verbatim, **and the node's own anchors wrong** — `_exclude` spans **`:29-250`** with **82** entries, not `:29-197` with 58, every pre-`866d59d` anchor having drifted ~53 when the artefact allowlist landed. **The finding nobody charted:** `:103` called the guide tree excluded while `:217`, 114 lines below in the same document, passes `--exclude-dir=TEMPLATE-GUIDE` to a token sweep **a reader runs inside their generated project** — meaningful only if it ships. Settled by execution: **0 surviving tokens with the exclusions, 95 without**, all in the three shipped files that quote token syntax on purpose. The command was right and the table was wrong. Fixed against a real `uvx copier copy`, **27 assertions across all six rows, 27 passing**, plus the guide's own four checks. **Two uncharted falsehoods swept up by reading the whole register rather than the four bullets** — the completeness critic's catch again, because a finder scoped to a bullet cannot ask about a row nobody wrote one for: `.git` is excluded (`copier.yml:31`) and sat in no row, and the artefact-trees row spared only _"the pairs and the templates"_ against an allowlist re-including **fifteen further named paths**, so a reader would expect `09-GDPR/` to arrive holding a documentation pair when it arrives holding six working documents — **this batch's own defect shape, in the register that exists to describe it**. `/uv.lock` placed by mechanism rather than by row (regenerated by task, not seeded from `.copier/`). The fifth site, `doc-references.sh:26`, corrected in its **comment only** and its code deliberately left alone, with the narrowing routed to **N-031** — fixing it here would have answered a grilling question with a script edit. Sibling-map read discharged and **found nothing for the first time in three**. Counts recounted from the tables: **21 + 38 = 59 = N-059** | [x] |
| 20/08/2026 | N-037 | **Settled with a mechanism, not a sweep — and the mechanism is smaller than the sweep would have been.** Seven commits `6c920b1`..`692ad63`. The node was re-measured first and the number that mattered was one nobody had taken: 120 sites across 63 files, but only **~15 of 43 unique paths were real citations** — the rest are naming patterns `is_pattern()` already discards. So the repair was never 120 judgements. `FORWARD-VOICE.md` states the rule, `PROJECT-PATHS.md` holds **three** rows, and a `code/src/django/*` arm makes the register load-bearing. **Six register candidates were proposed and four were killed by an adversarial reader** for naming no creator. |
| 20/08/2026 | N-042 | **Moved to _Resolved_, two days after it was fixed.** `5e2b61d` closed it on 18/08 and nobody moved the row, so the open table over-counted for two days while the map's own standing rule says to recount from the tables. **The tables are only as true as the last person to move a row.** Closure re-verified today by a stronger test than its commit: the gate is green on a disk where `code/docs/MACHINE-SPEC.md` is **absent**, which was exactly the red condition. |
| 20/08/2026 | _none — gate repair_ | **Three gates were found reporting a clean run over nothing, and a fourth blaming our code for an absent library.** `css-tokens.sh` and `css-gradients.sh` scoped two directories that do not exist; `copy-emdash.sh` and `copy-slop.sh` scanned `apps/marketing/templates`, a path this project's doctrine never creates and `new-django-view.sh:35` disproves. `syntax/lint.sh` reported an unbuildable Rust workspace as `Lint issues found` — cargo returns **101 for both** a build-script panic and a real clippy finding, so the discriminator is whether any diagnostic carries a span inside this workspace. All four fixed under `GATE-REPORTING.md`; **none is charted here, per the 20/08 decision to resolve rather than chart.** |
| 20/08/2026 | _none — v6.0.0 released_ | **The release this branch had been building toward, and the changelog it shipped was audited by readers who had not written it.** `[Unreleased]` was written for the 16-commit range, then put through 83 agents over eight lenses with every finding handed to an independent refuter told to default to _not a defect_: 75 findings, **18 confirmed** — 14 false claims in the entry just written, 4 more in the `[6.0.0]` entry `c155801` had already committed. The sharpest **inverted** the greedy-regex example, naming the correct peel as the bug; another recorded the `code/src/django/*` arm as _measured on (5)_ when it was **34 across 25 files**. The rebase was clean and the `REFERENCES.md` conflict the handoff predicted **did not exist** — hunks 30+ lines apart, proven with `git merge-tree` before anything was touched — leaving `CHANGELOG.md` the only one. Consolidated by **fast-forward** onto this branch, so no history was rewritten on any remote, and the v6 branch and worktree were deleted. `v6.0.0` tagged and published as a pre-release. The handoff was pruned and its one orphaned item — `main` 80 commits behind at `v3.2.2`, a third MAJOR now stacked on it — went to `GAPS.md`. **The three rows above this one had been prepended above the table header**, where Markdown does not render them and a recount cannot see them: N-042's own drift, in the log that records it. Moved into the table here. |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open register entry triaged — closes / standing limit / already-resolved
- [x] Every claimed entry names what will retire it; **`TEMPLATE-GAPS.md` carries no `✅ CLOSED` edits from here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — **regressed and restored on
      16/08/2026.** Ticked on 15/08 when N-001 settled at `7cd385d`; broken the next morning by
      **N-032**, which gated not story-writing but _producing a project at all_; **re-ticked the
      same day**, once a full `copier copy` returned exit 0. The remaining **11** nodes are
      non-blocking by their own wiring (**recounted an eleventh time 21/08/2026** after sitting 3
      settled N-054, N-048 and N-020 — it read **15** from 18/08 through three consecutive
      sittings, the same three-sitting survival as the Frontier opener, and both were corrected in
      the same pass; **recounted a tenth time on 18/08/2026 when N-053
      settled**, and nine times on 16/08/2026; this line read 14,
      then 12 before N-022 settled, 11 before N-036 did, 10 before N-035's row was moved, 9 before
      the Batch E verification pass charted N-042, N-043 and N-044, **13 after N-010 settled and
      charted N-045 and N-046**, 12 when N-040 closed, **18 once the challenge pass charted N-047 to
      N-052**, **20 once this evening's challenge pass charted N-053 and N-054**, and **25 once the
      Batch B challenge pass charted N-055 to N-059**). **Two of the five new nodes were proposed
      as blocking and both were refused on the same precedent** — N-057, a required check no
      pull-request event can produce, and N-042, now measured as a required context rather than
      merely a red job. Each blocks a **merge**, and one of them has never once been exercised
      because the operating account bypasses it by default. ~~**N-053 is
      the closest of the twenty-five to blocking and still does not**~~ — **settled 18/08/2026**,
      so the claim passes back to N-042. The refusal is kept because the reasoning outlives the
      node: it made a CI step pass having verified nothing, which is a false green on promotion —
      it gated neither a merge nor a story, it failed to gate anything, which was the defect. A
      reviewer proposed marking it blocking; refused on the N-042 precedent, and the disagreement
      is recorded rather than resolved silently. **The sixth recount arrived at 12 again, and that was a coincidence, not a
      carry-forward** — N-040 closing removed one node from a table N-010 had grown by one. A
      figure that is right by accident is what the standing rule forbids relying on, so every
      reading here is taken from the tables. **N-042 is still the closest to blocking and still
      does not**: measured against ruleset `20221742` on 16/08/2026 it does not merely redden a CI
      job — `Citations resolve` is a **required** context, so it **blocks the merge** of any PR
      into `main`. The precedent is unchanged and the verdict survives the correction: it gates a
      merge, not a story, and an admin bypass (`bypass_mode: always`) exists besides. **N-047
      is the first node on this map whose cost lands outside this repository** — it does not block
      a story here, and it does break a `copier update` there.
      **Worth recording for the round trip rather than the
      outcome: the tick was true both times and the repository was broken in between.** This gate
      reads the frontier, and the frontier only knows what someone has looked at
- [x] Every resolved node links to the artefact it became — all **49** carry a commit, a script, a standing limitation, or
      a named guide section in the _Became_ column (**recounted seven times on 16/08/2026**: it read
      20, then 22, while the table held 25; corrected to 27, stale again at 29 as N-034 and N-041
      landed, 30 when N-022 settled that afternoon, 31 when N-036 did, and 32 when N-035's row was
      moved. **A checkbox that records having recounted is not a recount** — see the standing rule
      in _Frontier_. **The fifth drift was caused by the node that cleared the fourth**: settling
      N-036 made both counts on this page stale the moment its row landed, which is the same shape
      as N-036's own defect — a fact corrected in one place and its dependants left standing. The
      sixth was caused by moving N-035's row an hour later, which is the same shape again, and is
      why this line now names the cause rather than only the number. **The Batch E verification
      pass settled nothing, so 32 was correct at that write** — the first write to this page in two
      days that did not move it, and the reason the open count moved instead. **The seventh drift
      is the one this line was carrying when the challenge pass read it**: N-010 settled at some
      point after, taking the table to 33 without touching this checkbox, and N-040 then took it to
      **34**. Two settlements, no recount, exactly the failure the rule names. **Charting N-047 to
      N-052 does not move this number** — six new open nodes change the frontier and leave the
      resolved table alone, which is the one case where carrying a figure forward would have been
      safe. It was recounted anyway. **The evening challenge pass settled nothing either, so 34
      stands** — recounted from the table a ninth time rather than carried, and cross-checked
      against the frontier by the arithmetic the map prescribes. **The Batch B challenge pass
      settled nothing either, so 34 stood a tenth time** — five nodes charted, no `Became` cell
      written, and the arithmetic re-run from the tables: 25 + 34 = 59 = N-059. **N-053 then
      settled on 18/08/2026 and both counts moved together for once**, the row and these two
      lines written in the same pass rather than one of them a day later, which is the fix for
      the fifth and sixth drifts named above: **24 + 35 = 59 = N-059**. **Sitting 1 took it to
      43 and sitting 2 to 46** — three rows written and three counts moved in the same pass,
      twice running, which is now the practice rather than the exception. **Sitting 2's review
      pass then took the frontier down rather than up**, the first time on this map: N-061 was
      charted and closed inside the same uncommitted diff, so it was deleted rather than carried
      as a resolved row: **14 + 46 = 60 = N-060**)
- [x] Index row — **deliberately not added**: `01-FEATURE-MAPS/CONTEXT.md` ships, and a shipped file
      may cite layering-system artefacts only, never a per-project instance
- [ ] **Sibling maps read before the next resolve session** — added 16/08/2026. Four live maps
      share this folder and one of them routes findings here; eight sat unadopted for a day because
      nothing obliged a session to look. Unticked deliberately: it is a standing duty, not a
      one-time act, and it belongs on the gate until the fog-of-war question about routing gives it
      a mechanism. **Discharged for Batch B sitting 1, 16/08/2026** — all five siblings read,
      `MAP-ABSENCE`'s eight routed findings all accounted for, nothing new inbound, and a **fifth**
      map found that this map's own table did not list (`MAP-NAVIGATION`, charted the same day).
      That the duty's first execution immediately found a missing row is the argument for keeping it
      unticked. **Not discharged for the Batch E verification pass, 16/08/2026** — stated rather
      than quietly skipped. The pass measured this map's own nodes against the tree and read no
      sibling map, which is defensible for a verification pass and would not be for a resolve
      session. **Whoever opens N-023, N-037 or N-042 owes the read first.** **Not discharged for
      the 16/08 challenge pass either** — stated rather than quietly skipped, on the same reasoning:
      it measured two of this map's own nodes against the tree and read no sibling map. It did,
      however, settle N-040 and rescope N-044, which makes it the first pass to move rows without
      paying the duty. **Whoever opens the next node owes the read regardless of which node it is.**
      **Discharged for N-053, 18/08/2026** — the duty's second execution, and like its first it
      immediately found rows missing from this map's own sibling table: **seven live maps, not
      five**, `MAP-SUBDOMAIN-ROUTING` never listed and `MAP-UPSTREAM-TRACKING` named only in
      N-022's prose. No sibling claims any file in N-053's set, nothing new was routed here, and
      `MAP-ABSENCE`'s eight remain accounted for. Two of two executions have paid for themselves,
      which is why this stays unticked. **Discharged for sitting 1, 21/08/2026 — three of three.**
      All seven siblings read; `MAP-ABSENCE`'s outbound table still holds exactly eight rows and
      all eight are still accounted for; nothing new inbound. What it found this time is a
      **different failure from the first two**: not a missing row but a **false** one. This map
      recorded `MAP-NAVIGATION` as routing nothing here, which is true — and missed that its
      **N-004 claims a file this sitting was about to edit**, `doc-references.sh`. The duty's
      first two executions caught maps this table had never listed; the third caught a map it had
      listed and described wrongly. **A sibling table needs re-reading, not just re-counting**,
      and the cheap discriminator is that a routed finding is inbound work while a claimed file
      is a collision — the table only had a column for the first.
      **Discharged for sitting 2, 21/08/2026 — four of four, and this one caught a map that did
      not exist when the read ran.** All seven siblings read, nothing new inbound,
      `MAP-ABSENCE`'s eight still accounted for. Then **`MAP-RULE-OWNERSHIP` was written by a
      parallel session at 17:44**, after the read and before the sitting closed, and it **claims
      `doc-references.sh`** — the third map to do so. **The duty's failure mode has now changed
      three times in four executions**: a map never listed, a map listed and described wrongly,
      and now a map that did not exist yet. The first two are fixed by reading more carefully;
      **the third cannot be, and is the argument this item was always making.** A sibling read is
      a measurement with a timestamp, so on a branch other sessions are writing it is **re-run
      before the commit, not only before the first node**. Sitting 2 re-ran it and this row is
      the result
