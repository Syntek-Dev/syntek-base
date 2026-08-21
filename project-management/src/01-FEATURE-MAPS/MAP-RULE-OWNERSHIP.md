# MAP-RULE-OWNERSHIP — one rule, one home, and a guard that keeps it there

**Charted**: 21/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `9a69a9b` · **Re-verified at**: `5d3c22f` — **all ten nodes still hold**
**Status**: Charting
**Frontier open**: 10 · **Blocking open**: 0 · **Resolved**: 1

> Charted from two `/improve-codebase-architecture` passes on 21/08/2026 — the first over
> `**/CLAUDE.md`, `**/CONTEXT.md` and `**/docs/**`, the second extended to `**/workflows/**`.
> Reports are local-only under `code/src/improvement-architecture/` (gitignored); every claim
> below was re-derived from the tree, not from the report.
>
> **No index row in `CONTEXT.md`** — see N-010. A `MAP-<FEATURE>` row is a per-project instance
> citation in a file that ships, which is the defect `audits/doc-references.sh` exists to prevent.
> Nine existing maps have declined it for the same reason. The instruction is charted, not obeyed.

---

## Destination

Every rule in this repository is **stated once, in a named owner, and cited everywhere else** —
and a guard makes a second home fail rather than rely on a reader noticing. Reached in that
order: the instances that break at runtime first, then the guard, then the remainder as the guard
catches them.

---

## Notes

| Field                      | Value                                                                                                                                                                                                                                                                         |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                     | Repository documentation governance — the three-role split (`.claude/CLAUDE.md` global rules · per-folder `CLAUDE.md` local rules · `CONTEXT.md` orientation) and the audits that hold it up                                                                                  |
| Skills to load             | `doc-writer` · `scaffold` · `domain-modelling` · `codebase-design` · `grill-with-docs`                                                                                                                                                                                        |
| Standing preferences       | **Route, don't restate** (`code/docs/DOCUMENTATION-PAIRING.md` §6) · a gate is **derived from a stated rule, never from taste** (`code/src/scripts/audits/CLAUDE.md`) · **no gate may disagree with the settled rule** (Sam, MAP-BASE-HEALTH N-028)                           |
| Umbrella ADRs              | None — `14-DECISIONS/` holds only `ADR-000-TEMPLATE.md`. N-003 and N-004 are the two likeliest to earn the first                                                                                                                                                              |
| Relationship to other maps | Deliberately **not** folded into `MAP-BASE-HEALTH` (N-059, Frontier 17), which is a catch-all for syntek-base's open items. These nine share one cause and one remedy. The split has a measured cost here — `MAP-ABSENCE` routed eight findings there and nobody adopted them |
| Register entries triaged   | **0 closes · 0 blocks · 1 unrelated**                                                                                                                                                                                                                                         |

**What the reviews did _not_ find, recorded so it is not re-measured.** The three-role split
holds: no `CLAUDE.md` contradicts `.claude/CLAUDE.md` on scope or authority; no `CONTEXT.md`
claims to be operating rules; the `Read order:` chain is byte-identical in **206 of 206** files.
All **45** workflows carry the four-file shape, all **90** routing files one frontmatter schema,
every `workflow:` matches its folder, only `fable`/`opus` appear, and **no workflow is an orphan**.
`docs-pairing.sh`, `routing-skills.sh`, `docs-length.sh` and `doctrine-drift.sh` are green.
**The structure is sound; what leaks is ownership of individual rules.**

---

## Register claimed

| Register    | Entry                                                                       | Verdict   | Retired by |
| ----------- | --------------------------------------------------------------------------- | --------- | ---------- |
| GAPS.md     | 20/08/2026 — `main` unreconciled since v3.2.2, v6.0.0 stacks a second MAJOR | unrelated | —          |
| DEFERRED.md | _(file holds no rows)_                                                      | —         | —          |

`GAPS.md` held exactly one open entry at charting and it is a branch/release decision the entry
itself routes to `22-pr-and-review`. **This feature closes nothing and is blocked by nothing** —
the triage is exhaustive at one entry, which is what makes the count provable rather than
reassuring.

> **The entry was deleted from `GAPS.md` mid-session by a parallel session**, staged but not
> committed, alongside `5d7d264`'s finding that _"that register holds no dated entries"_. Recorded
> rather than absorbed: the verdict is **unchanged either way** — unrelated is unrelated whether
> the row is present or gone — but a triage that silently re-counts itself against a moving
> register is not a triage. If the row returns, this table is still correct.

---

## Resolved decisions

| Node  | Decision                                                                               | Type     | Settled    | Became                                                                             |
| ----- | -------------------------------------------------------------------------------------- | -------- | ---------- | ---------------------------------------------------------------------------------- |
| N-011 | Does the false _"does not ship"_ premise repeat across `doc-references.sh` exemptions? | research | 21/08/2026 | The evidence under **N-009** — a measurement, not a decision; no external artefact |

**N-011, in full, because it widened a node during charting.** `doc-references.sh:158-168`
exempts four folder globs on the stated ground that _"none of these ship — copier.yml `_exclude`
empties every one of them at generation"_. `copier.yml:116-133` re-includes
`!**/CONTEXT.md`, `!**/CLAUDE.md` and `!**/*TEMPLATE*`, so **nine files inside those exemptions do
ship**: the `CONTEXT.md`/`CLAUDE.md` pairs under `research/`, `learning/` and `handoffs/`, plus
`01-FEATURE-MAPS/`'s pair and `MAP-000-TEMPLATE.md`. Charted as one file; measured as four arms.

**Current exposure is one citation and it is legitimate** — `01-FEATURE-MAPS/CONTEXT.md:51` cites
`MAP-SCALE-PLANNING.md`, which `is_seeded()` would pass on its own merits because `copier.yml`
`_tasks` moves it into place. So the exemption is **latently** wrong, not live: nothing abuses it
today, and the first thing that would is the index row `CLAUDE.md` tells every charting session to
add. That is why Q4 was answered _don't add it_ and why N-009 and N-010 are one batch.

---

## Frontier

| Node  | Decision                                                                                  | Type     | Blocked by                                    | Batch | Blocking a story? |
| ----- | ----------------------------------------------------------------------------------------- | -------- | --------------------------------------------- | ----- | ----------------- |
| N-001 | Workflow `09-debugging-with-logs` bypasses the script seam — 9 raw `docker compose` calls | task     | none                                          | A     | no                |
| N-002 | The implementation entry gate is stated three times and the code layer's copy is wrong    | task     | none                                          | A     | no                |
| N-007 | The doc-length exemption is documented one level deep and implemented all the way down    | task     | none                                          | A     | no                |
| N-003 | The source-file length rule has no owner — where does 750/800 actually live?              | grilling | none                                          | B     | no                |
| N-005 | `phase:` — define the vocabulary, or delete the key from 90 files                         | grilling | none                                          | B     | no                |
| N-006 | Model tier is answered three ways with no precedence rule — which is canonical?           | grilling | none                                          | B     | no                |
| N-004 | Widen `doctrine-drift.sh` — prose matching, an owner column, a wider scan scope           | grilling | none _(its source-length row waits on N-003)_ | C     | no                |
| N-008 | The coverage-floor restatements have no revisit trigger                                   | grilling | **N-004**                                     | C     | no                |
| N-009 | `doc-references.sh` exempts nine **shipped** files on a premise `copier.yml` falsifies    | grilling | none                                          | D     | no                |
| N-010 | The index-row instruction cannot be safely followed as written                            | grilling | **N-009**                                     | D     | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike) · `grilling` (one `/grill-with-docs`
surface) · `task` (manual unblocking work)

**Nothing is marked blocking-a-story, and that is deliberate.** Q1 settled the order as _runtime
first, then the guard_. Marking N-004 blocking would gate the Batch A fixes behind a gate-design
decision, which is the opposite of what was decided. The ordering lives in the batches below, not
in the story gate.

### Batches — why each set belongs in one sitting

| Batch | Nodes                 | Why they group                                                                                                                                   | Takeable |
| ----- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| **A** | N-001 · N-002 · N-007 | **Shared evidence** — all three are read off the workflow and audit trees, and none carries a trade-off: a replacement, a deletion, a re-wording | **now**  |
| **B** | N-003 · N-005 · N-006 | **Shared subject** — one question asked in three places: _where does a rule live, and what is canonical when three sources disagree?_            | now      |
| **C** | N-004 · N-008         | **Mutual dependence** — the guard's design decides whether N-008 needs a trigger of its own or gets one for free                                 | after B  |
| **D** | N-009 · N-010         | **Shared subject** — the same folder, the same two shipped files, the same question about what may cite what                                     | now      |

**Order by what unblocks the most:** A (runtime defect, no dependants) → B (feeds C's claims
table) → C (supplies N-008's trigger) → D (independent; takeable any time).

### Node detail — one line of evidence each

- **N-001** · `code/workflows/09-debugging-with-logs/STEPS.md:35,39,52,56,60,64,71,199,200`. Against
  `.claude/CLAUDE.md` §6, which names _"writing it into a doc"_ explicitly. `logs.sh`, `server.sh`
  and `shell.sh` already exist; the raw form skips `worktree-detect.sh` and `--env-file`, so it
  attaches to the **wrong stack in a worktree**. The sibling `how-to/workflows/08-debugging/STEPS.md:33-39`
  supplies the correct idiom verbatim. 44 of 45 workflows comply.
- **N-002** · `REFERENCES.md:200` and `project-management/workflows/CONTEXT.md:172` say implementation is
  gated on PM `02`–`17`; `code/workflows/CONTEXT.md:111` says `01`–`15`. Both restating files carry
  _"Do not restate it here"_ two lines above. The dropped `17-consolidate-design-work` is the gate the
  PM layer's next bullet calls **hard**.
- **N-007** · `code/docs/DOCUMENTATION-LENGTH.md:35`, `docs-length.sh:28,114` and
  `audits/CONTEXT.md:165` all write `**/src/*.md` (one level); `is_instructional()` at
  `docs-length.sh:301-322` exempts the whole tree at any depth. The spec is **stricter than the
  gate**, in the direction that costs work.
- **N-003** · `.claude/CLAUDE.md:231` says _"Defined in `code/CONTEXT.md`"_; that file never states
  750 or 800 and routes to `code/docs/CODING-PRINCIPLES.md`, a 30-line index that also never states
  it, whose `coding-principles/CLAUDE.md:29` routes **back**. The pointer is a **cycle**. The only
  in-`docs/` statement, `STYLE-AND-PROCESS.md:164`, omits the 800 grace and so disagrees with
  `cloc.sh:25-26`. 22 `CLAUDE.md` files under `code/src/` restate the number.
- **N-005** · 90 files carry `phase:`; it takes 10 values; **nothing reads it** — no script, hook or
  CI job — and nothing defines it. Six values fight the documented families (three debug workflows
  labelled `verify`; `11-refactor` labelled `build`; `how-to/03-daily-development` labelled `setup`).
  Its three sibling keys each have a definition, a gate, or both. **Deletion is a live option** —
  removing it moves no complexity anywhere.
- **N-006** · Frontmatter says `fable 01–17 / opus 18–23`. `project-management/workflows/CLAUDE.md:30`
  says _"Fable (01–10, 12–16); Opus for SEO (11)…"_ — wrong three ways: **11 is qa-checks not SEO**,
  **11 is fable not opus**, and **17 is named by neither range**. Inline annotations then invert two
  design workflows to `opus` (`13-api-design`, `07-component-designs`), which `.claude/CLAUDE.md` §4
  puts squarely on `fable`. **No precedence rule exists.**
- **N-004** · `doctrine-drift.sh` holds **3 claims**, all JSON envelope keys, matched against **fenced
  code only**, over 5 trees. Its design note at `:27-31` defends fenced-only — _"examples are the
  contract"_ — and MAP-BASE-HEALTH N-036 records it **refusing a job** on exactly that ground
  (_"0 of 7 homes reachable on two axes"_). N-002's two restatements sit **inside** its scan dirs and
  it still cannot see them, because they are prose. Reopening the invariant is the decision.
- **N-008** · Narrowed per Q3. `code/docs/testing/COVERAGE.md` gained an **80% promotion tier** on
  16/08/2026; twelve files still say only _75 / 90_. **Whether they stay is settled** — Sam, `12973ef`,
  MAP-BASE-HEALTH N-028: _"incomplete rather than false"_. What is open is only **what would ever
  raise them again**, and N-004 is the candidate answer.
- **N-009** · See N-011 above. Four exemption arms, nine shipped files, one legitimate citation
  today. **Precedented, not speculative:** commit `5d7d264` (21/08/2026, **N-031 on
  MAP-BASE-HEALTH**) narrowed the arm three lines above these — `how-to/src/TEMPLATE-GUIDE/*` down
  to `TEMPLATE-GAPS.md` alone — on the identical reasoning, _"that tree ships as of `f5fef31`; only
  this one file is copier-excluded"_. The principle is accepted and was applied to one arm the same
  day; the four arms below it still carry _"none of these ship"_ unamended. Narrowing there exposed
  four findings and **not one was a broken citation**, which is what made it safe — the same
  measurement is what N-009 needs before it moves.
- **N-010** · `01-FEATURE-MAPS/CLAUDE.md` makes the index row **definition-of-done**; `CONTEXT.md`
  ships and `MAP-*.md` does not, so the row is a per-project instance citation in a shipped file.
  Nine maps have declined it and the index still reads _"None charted yet"_. The instruction and the
  citation rule cannot both be obeyed.

---

## Fog of war

- **Orientation carrying operating rules in prose, under legal headings.** `docs-pairing.sh` §5 bans
  _headings_, not sentences; the decision test is per-sentence and nothing measures it.
  `audits/CONTEXT.md` is a 4× outlier on rule-verb density (43 lines against a median of ~2) and is
  still defensible. **Not sharp enough to be a node** — there is no measurement of how widespread the
  class is, and its one visible instance is the one case where the prose is probably right.
- **Whether N-005's three-taxonomy problem is one decision or two.** `phase:` fights the code
  families and the how-to families, which are themselves two different four-family schemes. Whether
  reconciling them is part of defining `phase:` or a separate question depends on N-005's outcome.
- **Whether the guard from N-004 should also cover `**/CLAUDE.md` under `code/src/`.** 22 of them
  restate the source-length limit and none is in any current scan scope. Depends on N-003 and N-004.

---

## Out of scope

| Ruled out                                                  | Why                                                                                                                                                                                                                    |
| ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Restructuring `code/src/scripts/audits/CONTEXT.md`         | **Fails the deletion test** — splitting moves complexity into a third file rather than concentrating it; the inventory is genuinely one table, and its dated allowance (expires 01/12/2026) already supplies a trigger |
| Reopening **whether** the coverage-floor restatements stay | Settled at `12973ef` (MAP-BASE-HEALTH N-028). N-008 charts only the missing revisit trigger, not the decision                                                                                                          |
| Changing the 750/800 or 300/270 thresholds themselves      | The numbers are not in question anywhere in this map — only **where they are written** and **whether anything guards them**                                                                                            |
| `main` reconciliation (`GAPS.md` 20/08/2026)               | Unrelated to rule ownership; the entry routes itself to `22-pr-and-review`                                                                                                                                             |
| Folding these nodes into `MAP-BASE-HEALTH`                 | Q2. One cause, one remedy, its own frontier — kept out of a 446KB catch-all at N-059                                                                                                                                   |
| Adding the `CONTEXT.md` index row for this map             | Q4. It would ship a citation to a map no generated project holds. Charted as N-010 instead of obeyed                                                                                                                   |

---

## Session log

| Date       | Node settled                       | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Frontier redrawn |
| ---------- | ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 21/08/2026 | N-011 (research) · re-verification | **Charted: 10 open nodes in 4 batches, 1 research node fired and settled same-day.** Two architecture reviews produced nine findings; charting produced a tenth. N-011 widened N-009 from one file to **four exemption arms / nine shipped files**, and bounded it honestly — exposure is **one citation and it is legitimate**, so the defect is latent, not live. Register triaged exhaustively at one entry: **0 closes, 0 blocks, 1 unrelated**. Q4 answered _don't add the index row_, which made the instruction itself node **N-010**. Nothing else settled — CHART draws the frontier. **Then the base moved under the session and every node was re-measured.** Two commits landed from parallel sessions between the first measurement and the write (`5d7d264`, `5d3c22f`); **all ten nodes still hold at `5d3c22f`**. Two premises did move: the single `GAPS.md` entry was deleted (staged, verdict unchanged), and `5d3c22f` repaired the one dangling citation the reviews had reported, so `doc-references.sh` is now **clean**. **N-009 came out stronger** — `5d7d264` narrowed a sibling arm of the very function it names, on the very same reasoning, leaving the four arms below it unamended. The standing lesson applied to itself: _re-verify what a parallel session hands you_ | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — none is so marked (see Frontier)
- [x] Every resolved node links to the artefact it became
- [ ] Index row in `CONTEXT.md` current — **deliberately not added; charted as N-010**

**Stories may be cut in `workflows/02-story-creation/` now** — no node gates them. Batch A is the
intended first slice.
