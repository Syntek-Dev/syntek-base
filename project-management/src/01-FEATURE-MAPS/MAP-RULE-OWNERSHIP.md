# MAP-RULE-OWNERSHIP — one rule, one home, and a guard that keeps it there

**Charted**: 21/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `9a69a9b` · **Re-verified at**: `a4d3ca9` (23/08/2026) — **all seventeen nodes
still hold; a fifth review corrected the evidence under three of them and added no new node**
**Status**: Charting
**Frontier open**: 17 · **Blocking open**: 0 · **Resolved**: 1

> Charted from **four** `/improve-codebase-architecture` passes. Two on 21/08/2026 — the first
> over `**/CLAUDE.md`, `**/CONTEXT.md` and `**/docs/**`, the second extended to `**/workflows/**`
> — then two on 23/08/2026: `architecture-review-20260823T091427Z.html` over `how-to/`, and
> `architecture-review-20260823T135337Z.html` over `code/`. Reports are local-only under
> `code/src/improvement-architecture/` (gitignored); every claim below was re-derived from the
> tree at `c09a189`, not from the report.
>
> **The `how-to/` pass fixed 14 defects rather than charting them** — commands that could not
> work, six audits CI runs that the operator's gate list omitted, four files missing from the
> layer's own tree. Those are shipped and are **not** nodes. What it left undecided is **N-018**,
> and the shape rule it installed is **N-015**. The `code/` pass charted **N-012**–**N-017**.
>
> **A fifth pass, 23/08/2026, over `project-management/` — it added no node and corrected three.**
> `architecture-review-20260823-142445.html` re-measured the layer the other four had only passed
> through. Its seven candidate claims were then put to **seven independent hostile verifiers**, and
> **six came back refuted or materially corrected** — including two the review had rated `Strong`.
> What survives is folded into **N-002**, **N-004**, **N-015** and the fog entry below; nothing it
> found is new frontier. **The pass is recorded for the correction, not the discovery** — its own
> first draft of these numbers was wrong in six places, and the map would have inherited them.
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

| Field                      | Value                                                                                                                                                                                                                                                                                                                                          |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                     | Repository documentation governance — the three-role split (`.claude/CLAUDE.md` global rules · per-folder `CLAUDE.md` local rules · `CONTEXT.md` orientation) and the audits that hold it up                                                                                                                                                   |
| Skills to load             | `doc-writer` · `scaffold` · `domain-modelling` · `codebase-design` · `grill-with-docs`                                                                                                                                                                                                                                                         |
| Standing preferences       | **Route, don't restate** (`code/docs/DOCUMENTATION-PAIRING.md` §6) · a gate is **derived from a stated rule, never from taste** (`code/src/scripts/audits/CLAUDE.md`) · **no gate may disagree with the settled rule** (Sam, 23/08/2026)                                                                                                       |
| Umbrella ADRs              | None — `15-DECISIONS/` holds only `ADR-000-TEMPLATE.md`. N-003 and N-004 are the two likeliest to earn the first                                                                                                                                                                                                                               |
| Relationship to other maps | Deliberately **not** folded into the template-health map that has since been deleted, which held **no** node touching workflow shape, the observability tokens, or `09-debugging-with-logs`. These seventeen share one cause and one remedy. The split had a measured cost — `MAP-ABSENCE` routed eight findings there and nobody adopted them |
| Defect classes             | Reuses `GAPS.md`'s five: **A** token blast radius · **B** false green · **C** inheritance leak · **D** split doctrine · **E** declared, not built. Sixteen of seventeen nodes are class **D** — that is the map's whole thesis. **N-012** is the one class **A**                                                                               |
| Register entries triaged   | **0 closes · 0 blocks · 0 unrelated** — re-triaged 23/08/2026 against a restructured `GAPS.md` (see below)                                                                                                                                                                                                                                     |

**What the reviews did _not_ find, recorded so it is not re-measured.** The three-role split
holds: no `CLAUDE.md` contradicts `.claude/CLAUDE.md` on scope or authority; no `CONTEXT.md`
claims to be operating rules; the `Read order:` chain is byte-identical in **206 of 206** files.
All **46** workflows carry the four-file shape, all routing files one frontmatter schema,
every `workflow:` matches its folder, only `fable`/`opus` appear, and **no workflow is an orphan**.
`docs-pairing.sh`, `routing-skills.sh`, `docs-length.sh` and `doctrine-drift.sh` are green.
**The structure is sound; what leaks is ownership of individual rules.**

**Added by the two 23/08 passes, in the `GATE-REPORTING.md` idiom — checked, and clean, which is
not the same as unchecked.** `doc-references.sh` exits `0` over **5,490 repo paths in 968 files**.
Every one of the **80** scripts under `code/src/scripts/**` is listed in its family's
`CONTEXT.md`. `code/docs/CONTEXT.md` matches its directory **exactly, in both directions**, and
`code/src/django/CONTEXT.md` is current to `apps/health`, `observability.js` and
`pyrightconfig.json`. Every skill named in `code/workflows/*` frontmatter resolves, and
`STEPS.md`/`CHECKLIST.md` frontmatter agrees in all **13**. The version pins in `REFERENCES.md`
match the manifests — Django 6, Python 3.14, PostgreSQL 18, pnpm 11, Rust 1.92, PyO3 0.29,
Slint 1.17. On the `how-to/` side: every `code/src/scripts/**` citation resolves, the toolchain
pins match `.nvmrc` / `.python-version` / `package.json`, `docs/CONTEXT.md` and `src/CONTEXT.md`
matched their directories, and the three forward-voice deploy scripts are correctly written as
planned. **In both layers only the layer-root `CONTEXT.md` had drifted** — which is N-016.

**Added 23/08/2026, and it narrows a claim this map has twice stated loosely.** "The gates are
green" has meant _the gates this map runs_ — four of them. **Twenty audits accept `--path`**
(twenty-one parse it; `negative-space.sh:182` parses it only to `die`). Pointed at
`project-management`, **fifteen exit 0 and five exit 1** — `copy-emdash.sh` (45 em dashes, chiefly
`src/07-COMPONENTS/component-build/components.py`), `css-gradients.sh` and `css-tokens.sh` (both
`src/08-WIREFRAMES/SHARED/wireframe.css`), `seam-contract.sh` (168 unattributed `## N.` sections
across 128 files) and `template-orphans.sh` (2 files under `export/`). **Every one of the five is a
false positive**, checked individually: `--wf-sp-2` is _defined_ at `wireframe.css:53` and reported
phantom only because `--path` moves the reference scan while the definition lookup stays pinned to
`code/src/django/`; `export/` and both its files are declared at `project-management/CONTEXT.md:28`
and `:88-89`, which `template-orphans.sh` cannot see because it reads `src/CONTEXT.md`'s numbering
alone; `seam-contract.sh` applies the **server contract's** `**Source:**` rule to PM templates.
**No PM defect is behind any of the five.** This is the standing preference inverted — _no gate may
disagree with the settled rule_ — five times, and it is **routed away, not charted here** (see
_Out of scope_): gate scoping is not this map's cause and would not be fixed by this map's
remedy.

**`how-to/workflows/` was never measured until this pass, and it is the uniform one.** All nine
carry `## Update context files` and `## Completion`; the numbered-step variant appears **zero**
times. The layer that _states_ the contract obeys it perfectly; the layer it _names as the
reference_ has four realisations of one clause (N-015).

---

## Register claimed

| Register    | Entry                                                                        | Verdict         | Retired by |
| ----------- | ---------------------------------------------------------------------------- | --------------- | ---------- |
| GAPS.md     | 20/08/2026 — `main` unreconciled since v3.2.2, v6.0.0 stacks a second MAJOR  | unrelated, gone | —          |
| GAPS.md     | SL-1 — a green suite here proves the template's own code, not your project's | **exempt**      | n/a        |
| DEFERRED.md | _(file holds no rows)_                                                       | —               | —          |

**Re-triaged 23/08/2026 at `c09a189`, and the register changed shape underneath it.** At charting
`GAPS.md` held exactly one dated entry, verdict _unrelated_. It is now gone, and `c024338`
restructured the file around a statement that **the active items live on a map, not here** plus a
_Standing limitations_ section. `GAPS.md`'s own preamble makes standing limitations **exempt from
triage** — _"accepted properties, not open entries, and can take none of the three verdicts"_ — so
the honest count is now **0 closes · 0 blocks · 0 unrelated over zero triable entries**, not one
unrelated. `DEFERRED.md` still holds no rows.

> **The verdict never moved; only the arithmetic did.** _Unrelated_ is unrelated whether the row
> is present or gone, and this feature still **closes nothing and is blocked by nothing**. It is
> restated rather than silently re-counted, because a triage that re-counts itself against a
> moving register is not a triage. Both re-measurements were forced by parallel sessions, which
> is now this map's second-most-repeated lesson: **re-verify what a parallel session hands you.**

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

| Node  | Decision                                                                                     | Type     | Class | Blocked by                                    | Batch | Blocking a story? |
| ----- | -------------------------------------------------------------------------------------------- | -------- | ----- | --------------------------------------------- | ----- | ----------------- |
| N-002 | The implementation entry gate is stated three times and the code layer's copy is wrong       | task     | D     | none                                          | A     | no                |
| N-007 | The doc-length exemption is documented one level deep and implemented all the way down       | task     | D     | none                                          | A     | no                |
| N-016 | Both layer-root `CONTEXT.md` files were the stale copy; `how-to/` is fixed, `code/` is not   | task     | D     | none                                          | A     | no                |
| N-017 | Three stale literals nothing can see — a range, a count, and a type-checker we do not run    | task     | D     | none                                          | A     | no                |
| N-003 | The source-file length rule has no owner — where does 750/800 actually live?                 | grilling | D     | none                                          | B     | no                |
| N-005 | `phase:` — define the vocabulary, or delete the key from 90 files                            | grilling | D     | none                                          | B     | no                |
| N-006 | Model tier is answered three ways with no precedence rule — which is canonical?              | grilling | D     | none                                          | B     | no                |
| N-018 | `CLI-TOOLING.md`'s scope is stated twice, differently, and the file satisfies neither        | grilling | D     | none                                          | B     | no                |
| N-004 | Widen `doctrine-drift.sh` — prose matching, an owner column, a wider scan scope              | grilling | D     | none _(its source-length row waits on N-003)_ | C     | no                |
| N-008 | The coverage-floor restatements have no revisit trigger                                      | grilling | D     | **N-004**                                     | C     | no                |
| N-009 | `doc-references.sh` exempts nine **shipped** files on a premise `copier.yml` falsifies       | grilling | D     | none                                          | D     | no                |
| N-010 | The index-row instruction cannot be safely followed as written                               | grilling | D     | **N-009**                                     | D     | no                |
| N-001 | Workflow `09-debugging-with-logs` bypasses the script seam — 9 raw `docker compose` calls    | task     | D     | none                                          | E     | no                |
| N-012 | The same workflow hardcodes three vendor names the token contract already owns               | task     | **A** | none                                          | E     | no                |
| N-013 | `09` declares itself observational, then writes the regression test and applies the fix      | task     | D     | none                                          | E     | no                |
| N-014 | The `## Context` closing block is a second copy of PM `22`, and 30 of 34 understate the rule | grilling | D     | none                                          | F     | no                |
| N-015 | The `STEPS`/`CHECKLIST` contract has an owner, but its named reference does not satisfy it   | grilling | D     | none                                          | F     | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike) · `grilling` (one `/grill-with-docs`
surface) · `task` (manual unblocking work)

**Nothing is marked blocking-a-story, and that is deliberate.** Q1 settled the order as _runtime
first, then the guard_. Marking N-004 blocking would gate the Batch A fixes behind a gate-design
decision, which is the opposite of what was decided. The ordering lives in the batches below, not
in the story gate.

### Batches — why each set belongs in one sitting

| Batch | Nodes                         | Why they group                                                                                                                                                                                                     | Takeable |
| ----- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| **E** | N-001 · N-012 · N-013         | **One folder.** All three are defects in `code/workflows/09-debugging-with-logs/` — four files, three unrelated causes. One sitting, one re-read, one commit; splitting them means reading that folder three times | **now**  |
| **A** | N-002 · N-007 · N-016 · N-017 | **Shared shape** — a restatement that drifted from its owner, each with the correct copy already in the tree to copy from. No trade-off: a replacement, a deletion, a re-wording                                   | **now**  |
| **B** | N-003 · N-005 · N-006 · N-018 | **Shared subject** — one question asked in four places: _where does a rule live, and what is canonical when the sources disagree?_ N-018 is the same question about a document's **scope** rather than its content | now      |
| **F** | N-014 · N-015                 | **Mutual dependence** — N-015 decides what a `CHECKLIST.md` closes with; N-014 decides whether one of those closing sections may exist at all in this layer. Settling either alone risks re-opening it             | after A  |
| **C** | N-004 · N-008                 | **Mutual dependence** — the guard's design decides whether N-008 needs a trigger of its own or gets one for free                                                                                                   | after B  |
| **D** | N-009 · N-010                 | **Shared subject** — the same folder, the same two shipped files, the same question about what may cite what                                                                                                       | now      |

> **Batch A gains a rider, 23/08/2026 — a defect to fix in the sitting, not a node.**
> `project-management/workflows/02-story-creation/CHECKLIST.md:49` is **corrupt**: two checklist
> items fused and both truncated, carrying an unbalanced backtick. It is the **file's last line
> (49 of 49)**, so the `## Definition of Done` section is itself truncated, and it is the only
> unpaired-backtick line among the **326 Markdown files** under `project-management/` (seven more
> sit in `.sh` and `.tex` and are unrelated). **It has shipped since `c2886e8` (01/08/2026)** —
> `git blame` attributes it there, at the pre-rename path `01-story-creation/CHECKLIST.md:41` — and
> has survived **four** later commits that touched the file (`13de9b9`, `3bd49e8`, `35eeb12`,
> `b2a1d21`) and **every gate**. Fragment one restores from
> `code/workflows/01-implement-story/CHECKLIST.md:37` (_"the rest walked manually"_); **fragment two
> exists nowhere in the repository or in any of its 294 commits** and must be **re-authored, not
> restored** — the one decision in the rider. Cited under **N-004** as this map's **first class B
> (false green)** evidence: an unreadable acceptance criterion no gate could see.

**Order by what unblocks the most:** E (one folder, three defects, no dependants) → A (mechanical,
no dependants) → B (feeds C's claims table) → F (needs A's N-016 pattern settled first) →
C (supplies N-008's trigger) → D (independent; takeable any time).

> **N-001 moved from Batch A to Batch E on 23/08/2026** — a frontier redraw, not a re-typing. It
> is unchanged and still `task`; the `code/` pass simply found two more defects in the same
> four-file folder, and a batch whose whole justification is _shared evidence_ should follow the
> evidence. Batch A keeps its rationale and gains two nodes that fit it better.

### Node detail — one line of evidence each

- **N-001** · `code/workflows/09-debugging-with-logs/STEPS.md:35,39,52,56,60,64,71,199,200`. Against
  `.claude/CLAUDE.md` §6, which names _"writing it into a doc"_ explicitly. `logs.sh`, `server.sh`
  and `shell.sh` already exist; the raw form skips `worktree-detect.sh` and `--env-file`, so it
  attaches to the **wrong stack in a worktree**. The sibling `how-to/workflows/08-debugging/STEPS.md:33-39`
  supplies the correct idiom verbatim. 44 of 45 workflows comply.
- **N-002** · **Re-measured at `a4d3ca9`; the node is bigger than it was written, and its own
  citation had drifted.** Three files state the implementation entry gate and **all three differ**:
  `REFERENCES.md:201` says the build phases are `18`–`20` _"gated on `02`–`17`"_;
  `project-management/workflows/CONTEXT.md:174` says _"once `02`–`18` are complete"_;
  `code/workflows/CONTEXT.md:111` says `01`–`15`. The map previously cited `:200` and `:172` and
  recorded the first two as **agreeing** on `02`–`18` — they do not, and the line numbers were off
  by one and two. Both restating files still carry _"Do not restate it here"_ two lines above.
  **And the same file drops the same workflow a second way.** `REFERENCES.md`'s cross-layer section
  (`:195-238`) holds **three** enumerating structures. The pairing table (`:204-216`) names 9 PM
  workflows and the _PM-only_ list (`:222-224`) names 13 — disjoint, covering **22 of 24**.
  **`01-feature-map` and `18-consolidate-design-work` are in neither**; `01` is recovered only by
  the third table at `:232`, and `18` by nothing. `18` is the sole workflow of the 24 **never named
  in full anywhere in the section** — though the section refers to it as `18` four times, once
  _inside_ the pairing table (`:206`, _"entered via `18`"_). **Not an independent second defect:**
  `:201` classifies `18` as an implementation entry point rather than a design gate, which is
  precisely why it has no pairing row. One cause, three surfaces, one edit pass.
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
  contract"_ — and it was recorded **refusing a job** on exactly that ground
  (_"0 of 7 homes reachable on two axes"_). N-002's two restatements sit **inside** its scan dirs and
  it still cannot see them, because they are prose. Reopening the invariant is the decision.
  **A second conditional row, added 23/08/2026, mirroring the source-length row that waits on
  N-003:** _workflow terminal-section shape_ — **waits on N-015**, which must first pick a canonical
  spelling for a guard to have anything to assert. Measured at `a4d3ca9`: nothing anywhere enforces
  workflow file shape. `git grep -E 'Definition of Done|Update context files|## Completion' --
code/src/scripts .claude/hooks .github lefthook.yml` returns **zero hits**, and **nothing asserts
  the two files exist at all** — the _four-file shape_ of `how-to/workflows/CLAUDE.md:36-37` has no
  gate either. Four audits name `STEPS.md` (`copy-emdash.sh:22`, `copy-slop.sh:81`,
  `docs-length.sh:109`, `doctrine-drift.sh:49`) and every one uses it as **scope or commentary**,
  never as a shape assertion; only `docs-length.sh:109` names `CHECKLIST.md`, and only to bind it to
  300 lines. **This node also now carries the map's first class B evidence** — see the corruption
  rider under _Out of scope_, one unreadable checklist line that passed every gate for 22 days.
- **N-008** · Narrowed per Q3. `code/docs/testing/COVERAGE.md` gained an **80% promotion tier** on
  16/08/2026; twelve files still say only _75 / 90_. **Whether they stay is settled** — Sam,
  `12973ef`: _"incomplete rather than false"_. What is open is only **what would ever
  raise them again**, and N-004 is the candidate answer.
- **N-009** · See N-011 above. Four exemption arms, nine shipped files, one legitimate citation
  today. **Precedented, not speculative:** commit `5d7d264` (21/08/2026)
  narrowed the arm three lines above these — `how-to/src/TEMPLATE-GUIDE/*` down
  to `TEMPLATE-GAPS.md` alone — on the identical reasoning, _"that tree ships as of `f5fef31`; only
  this one file is copier-excluded"_. The principle is accepted and was applied to one arm the same
  day; the four arms below it still carry _"none of these ship"_ unamended. Narrowing there exposed
  four findings and **not one was a broken citation**, which is what made it safe — the same
  measurement is what N-009 needs before it moves.
  **The predicate now exists, 23/08/2026 — built by a sitting on another map, which
  deliberately did not settle this node.** That sitting added Check 3 to the same
  script: `is_template_only()` derives ships / does-not-ship from `copier.yml`'s `_exclude` —
  anchored entries in, negations and `_tasks` seeds and the regenerated `uv.lock` out, surface-
  gated entries excluded by decision — and answers **40 paths**. So N-009's four arms now have a
  correct-by-construction predicate sitting three screens below them in the same file, and the
  node shrinks from _design a rule for what ships_ to **decide whether `is_exempt()` should call
  the one that is already there**. The nine shipped files and the single legitimate citation are
  re-confirmed at HEAD by that sitting; nothing else about this node changed, and no arm was
  touched.
- **N-010** · `01-FEATURE-MAPS/CLAUDE.md` makes the index row **definition-of-done**; `CONTEXT.md`
  ships and `MAP-*.md` does not, so the row is a per-project instance citation in a shipped file.
  Nine maps have declined it and the index still reads _"None charted yet"_. The instruction and the
  citation rule cannot both be obeyed.
- **N-012** · `code/workflows/09-debugging-with-logs/` writes three vendor names as literals —
  **31 lines, 43 occurrences** across its four files (`Glitchtip` ×15, `Grafana` ×14, `Loki` ×13,
  `GlitchTip` ×1), plus 7 more in `code/workflows/CONTEXT.md`. `copier.yml:388,396,403` already own
  them as `ERROR_TRACKING` (default `GlitchTip`), `LOG_AGGREGATOR` (`Loki`) and
  `OBSERVABILITY_STACK` (`Prometheus + Grafana`), and `copier.yml:358-363` classifies the first as
  **prose-safe** and the other two as **cell-only**. `code/docs/logging/OBSERVABILITY.md:33` and
  `code/docs/LOGGING.md:39` render the token correctly one directory away. **Both spellings coexist
  inside the one folder**, which is what proves these are hand-typed literals and not a rendered
  token. Two aggravations: `OBSERVABILITY.md` opens **_declared, not wired_** — nothing calls
  `sentry_sdk.init()` and `django_prometheus` is not in `INSTALLED_APPS` — while `09` carries no
  such marker and reads as describing running infrastructure; and **no audit covers vendor
  literals**, because `doctrine-drift.sh` matches rule text, not product names. The only class **A**
  node on this map: a token exists, and prose walked around it.
- **N-013** · `code/workflows/CONTEXT.md:67` says `09` is _"Observational only"_ and that _"09
  locates a fault and hands over, 10 fixes it and proves the fix with a test"_;
  `code/workflows/10-debug/CONTEXT.md` says _"This workflow owns the fix; `09-debugging-with-logs/`
  owns the search."_ Against `09/STEPS.md:180` **`## Step 6 — Write a regression test`** and `:193`
  **`## Step 7 — Verify the fix in the target environment`**, and `09/CHECKLIST.md:17`
  **`## Regression test`** / `:23` **`## Code fix`** (_"Fix addresses the root cause"_). Two
  workflows own one activity; whoever enters at `09` finishes there and `10`'s gates never run.
  Both index files are already right — only `09` needs cutting at the root cause.
- **N-014** · **37** `CHECKLIST.md` files carry the same four-line `## Context` block; **34** carry
  its pairing line and **30 of those name only `CONTEXT.md`**, against 4 that name both. But
  `code/CLAUDE.md` and `code/docs/DOCUMENTATION-PAIRING.md` both require the **pair**, and
  `docs-pairing.sh` enforces the pair — so **the checklist passes where the gate fails**, in 30
  files, and that is the map's standing preference violated exactly: _no gate may disagree with the
  settled rule_ (here, the checklist is the weaker of the two). In `code/` the block is also a
  second copy of a fact `REFERENCES.md` assigns to PM `22-implementation-documentation`, which
  `code/workflows/CONTEXT.md` restates as _"they never restate its formats or destinations"_.
  **9 of 13 restate it anyway**; `01`, `02`, `12` and `13` route to PM `22` instead — two of them
  with the words _"never restate them here"_. **The correct copy is already in the tree, four
  times.** The 28 copies outside `code/` may legitimately stay, since neither layer is gated by
  PM `22`; the understated wording is wrong in all 30 regardless.
- **N-015** · `how-to/workflows/CLAUDE.md:38-44`, added 23/08/2026 in `c024338`, states the
  contract: `STEPS.md` closes with `## Update context files` then `## Completion`; `CHECKLIST.md`
  closes with `## Context` then `## Definition of Done`; _"The reference shape is
  `project-management/workflows/**`."_ **Measured against its own named reference, 6 of 24 PM
  workflows fail it** (`01`, `12`, `13`, `14`, `17`, `18`), plus **3 of 13** in `code/` (`05`, `12`,
  `13`) — 9 of 46. Across all 46 the terminal section takes **four spellings**: `Definition of Done`
  ×38, `Close-out` ×3, `Closeout` ×2, `Sign-off` ×2 — and **`code/05-mcp-server` has none at all**,
  ending at `## Context`, so nothing in it ever declares the work finished. On the other half,
  39 of 46 `STEPS.md` close with `## Completion`.
  **Re-measured at `a4d3ca9` by the fifth pass. One tension survives, one collapses, and one
  premise was wrong.**
  1. **Survives — the rule binds three layers from a layer-local `CLAUDE.md`.** Confirmed and
     sharpened: `git grep 'Definition of Done' -- '*/workflows/CLAUDE.md' '*/workflows/*/CLAUDE.md'
'.claude/CLAUDE.md'` returns **only** `how-to/workflows/CLAUDE.md:42-43`. One home, three
     layers bound, **zero guard** (N-004). And the layer that states it is the only one that obeys
     it — `how-to/` is **9 of 9** on both halves; the layer it names as _the reference shape_ is not.
  2. **Collapses — the `## Update context files` clause was never wrong for `code/`.** The old
     premise, _"`0 of 13` code `STEPS.md` carry it, and per N-014 that absence is correct"_, is true
     of the **heading string** and false of the **clause**. Zero carry the heading in any case; but
     **8 of 13** carry a numbered `Step N — Update Context and Documentation`
     (`03:75`, `04:108`, `06:92`, `07:82`, `08:54`, `09:209`, `10:93`, `11:81`) whose **items 1-4
     are byte-identical** to the contract's own list — `diff` against
     `how-to/workflows/03-daily-development/STEPS.md:105-108` is **empty** — under a _stricter_
     lead-in, _"**Hard gate — complete before committing.**"_ The remaining five are not silent
     either: `01:230,233` and `02:193,196` impose the same hard gate and delegate to PM `22`;
     `05:143` updates `config/CONTEXT.md` directly; `12:143-145` and `13:124-125` hand closeout to
     PM `22` **explicitly**. **13 of 13 carry a closeout obligation.** So the decision is not
     _should `code/` adopt this clause_ but **which of the existing spellings is canonical** — and
     the eight are themselves three bodies, not one (4-item ×4; 5-item ×3, adding the
     code-review-graph refresh at `07:90`, `10:101`, `11:89`; and `09` reading _"before closing this
     workflow"_).
  3. **Wrong premise corrected — PM has four realisations of the clause, and one file has two.**
     `## Update context files` ×15; a numbered step ×5 (`19:124`, `20:119`, `21:245`, `24:96`,
     `22:138`); a differently-titled `Step 7 — Verify Documentation Closeout` ×1 (`23:126`); a bare
     bullet inside a generic close-out step ×1 (`18:153`). Only **3 of 24** carry none —
     `01-feature-map`, `12-seo-checks`, `14-logging-checks`. The buckets are **not a partition**:
     `22-implementation-documentation` carries the clause **twice in one file** (`STEPS.md:138` and
     `:170`, near-identical 4-item bodies) — the workflow `REFERENCES.md` names as closeout's **sole
     owner**, restating it against itself. That is this map's thesis in a single file.
  4. **The three PM checklists without `## Definition of Done` have not lost the function — they
     relocated it.** `01-feature-map`, `14-logging-checks` and `18-consolidate-design-work` each
     carry the terminal assertion as a **line-13 preamble**: _"Every box must be ticked before
     `02-story-creation/` may begin."_ / _"…before `15-decisions/` may close this story's loop."_ /
     _"…before `19-backend-code/` may begin."_ Exactly **3 of 24** PM checklists carry that sentence
     and they are **exactly** the 3 lacking the heading — mutually exclusive, which is a relocation,
     not an omission. A first reading of this pass called the function _absent_; it is not, and the
     node is smaller than that reading made it.
  5. **`code/05-mcp-server` is the one place the function is genuinely missing**, and on both
     halves: its `CHECKLIST.md` ends at `## Context` with no terminal section, and its `STEPS.md` is
     **the only one of all 46** that never cites its own `` `CHECKLIST.md` `` — 45 do, 41 in the
     standard _"Run through `CHECKLIST.md` before marking this workflow complete."_ **The
     case-sensitivity is load-bearing:** `grep -i checklist` matches all 46, because `05:134` says
     _"the checklist in `code/docs/mcp-server/AUTH-AND-THREATS.md`"_ — a different document. Use
     ``grep -L '`CHECKLIST.md`'``. Mitigated but not repaired: all 46 workflow `CLAUDE.md` files
     do cite their checklist, so the read order still reaches it.
- **N-016** · `code/CONTEXT.md`'s tree omits **11** top-level guides — `DISCOVERABILITY`,
  `DOCUMENTATION-LENGTH`, `DOCUMENTATION-PAIRING`, `EXPORTS`, `FORWARD-VOICE`, `GATE-REPORTING`,
  `MOBILE-CODING-PRINCIPLES`, `NOTIFICATIONS`, `OBJECT-STORAGE`, `PROCESS-MODEL`,
  `TASK-AUTHORING` — the whole `docs/discoverability/` subtree, the `src/scripts/dependencies/`
  family, and **`apps/health`**, a shipped Django app it never names anywhere. `code/src/CONTEXT.md:17`
  still reads _"`core` ships"_ where its own child `apps/CONTEXT.md:45` already says _"neither
  shipped app"_. Meanwhile `code/docs/CONTEXT.md` matches disk exactly. **The class is confirmed
  twice, independently:** the `how-to/` pass found the identical shape — `how-to/CONTEXT.md` missing
  four files that its own `REFERENCES.md` already listed — and fixed it in `c024338`. Two layers
  measured, two layer roots stale, every sub-tree `CONTEXT.md` clean. Whether that earns a gate is
  part of the node: the rule **is** stated (the `## Context` block's own first line), so one is
  derivable — but two instances is thin, and `doc-references.sh` structurally cannot see an
  **omission**, only a bad citation.
- **N-017** · Three literals, each true once. `code/workflows/CONTEXT.md:89` says PM
  _"runs 01 → 21 through a story's life"_ — there are **24** folders, and `22`, `23`, `24` are the
  ones it drops. `:91` says _"roughly 110 files across the repository cite these paths"_ — **156**
  do. `project-management/workflows/19-backend-code/CHECKLIST.md:35` and `20-api-code/CHECKLIST.md:38`
  both require _"`mypy` passes — no type errors"_; `syntax/check.sh` runs **basedpyright**, mypy is
  not a declared dependency and never runs, and `19`'s own `STEPS.md` names basedpyright two screens
  above the box. `doc-references.sh` cannot see any of the three — two are bare numbers and the
  third is a real tool name that resolves as a word. **In scope despite two sites being PM files:**
  they gate code work with the name of a tool the code layer does not run.
- **N-018** · `how-to/CONTEXT.md:22` calls `CLI-TOOLING.md` the _"CLI reference for **every dev
  command**"_; `how-to/REFERENCES.md:56` calls it the _"CLI reference for **all Docker Compose
  development commands**"_ — a materially narrower promise, in the layer's other index. The file
  names **25 of 80** scripts: `syntax` 3/3 · `tests` 6/8 · `database` 4/8 · `development` 5/15 ·
  `mobile` 3/7 · `rust` 1/5 · `audits` **2/24** · `desktop` **0/4** · `dependencies` **0/1** ·
  `_lib` 1/5. So **two indexes state one document's scope differently and the document satisfies
  neither**. The fix is a decision, not a sweep — most of the absent families are opt-in-surface, so
  either the promise narrows to what the file is, or the file gains surface-gated sections — which
  is precisely why the `how-to/` pass fixed 14 defects and left this one alone. Both index rows move
  together either way.

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
- **Whether a `CONTEXT.md` tree is checkable at all.** N-016 is two instances of one shape, and the
  rule behind it is stated — _"Directory trees in relevant `CONTEXT.md` files reflect any new files
  or folders created during this workflow"_. But a gate would have to decide what a tree is
  **allowed** to elide: `code/docs/CONTEXT.md` lists every file, where `code/CONTEXT.md` summarises
  by design. **Not a node** — completeness and orientation pull opposite ways and nothing here says
  which wins. It becomes one if a third instance appears.
- **Whether the four terminal spellings in N-015 are drift or vocabulary.** `Sign-off` sits on two
  PM design gates and `Close-out` on three discovery ones; both may be saying _a person approves
  this_ rather than _the work is done_, which is a real distinction one spelling would erase. The
  `how-to/` pass reached the same doubt from the other side and **deliberately left the
  domain-grouped headings alone**, fixing only the missing terminals. Whether that restraint extends
  to the terminal's _name_ is N-015's to settle, not fog — it is recorded here because the answer
  changes N-015's size, not its existence.

---

## Out of scope

| Ruled out                                                    | Why                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Restructuring `code/src/scripts/audits/CONTEXT.md`           | **Fails the deletion test** — splitting moves complexity into a third file rather than concentrating it; the inventory is genuinely one table, and its dated allowance (expires 01/12/2026) already supplies a trigger                                                                                                                                                                                                                                                                                                                                                              |
| Reopening **whether** the coverage-floor restatements stay   | Settled at `12973ef`. N-008 charts only the missing revisit trigger, not the decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Changing the 750/800 or 300/270 thresholds themselves        | The numbers are not in question anywhere in this map — only **where they are written** and **whether anything guards them**                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `main` reconciliation (`GAPS.md` 20/08/2026)                 | Unrelated to rule ownership; the entry routes itself to `23-pr-and-review`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Folding these nodes into the template-health map             | Q2. One cause, one remedy, its own frontier — kept out of a 446KB catch-all                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Adding the `CONTEXT.md` index row for this map               | Q4. It would ship a citation to a map no generated project holds. Charted as N-010 instead of obeyed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| The 14 defects the `how-to/` pass **fixed** on 23/08/2026    | Shipped in `c024338` and re-verified live at `c09a189`: the dead `--service backend` / `--service frontend` flags, `lsof -i :8000`, the phantom `docker-compose.override.yml`, six audits absent from the operator's gate list, four files absent from `how-to/CONTEXT.md`, the `24-` numbering collision, the drifted skill count. **Done, not deferred** — listed so a later pass does not re-chart them                                                                                                                                                                          |
| The 41 broken relative links in `code/docs/cloudinary/`      | Vendored third-party reference docs whose links target Cloudinary's own site. Not this repository's rules, and `doc-references.sh` already exempts the tree                                                                                                                                                                                                                                                                                                                                                                                                                         |
| The five audits that exit `1` on `--path project-management` | **Routed away, not charted here.** `copy-emdash.sh`, `css-gradients.sh`, `css-tokens.sh`, `seam-contract.sh`, `template-orphans.sh` — **all five verified false positives** (see _Notes_). The cause is **gate scoping**, not a rule with two homes, so it shares neither this map's cause nor its remedy. Recorded only because it narrows this map's own repeated claim that _"the gates are green"_                                                                                                                                                                              |
| The domain-grouped checklist headings                        | `Before` / `During` / `After`, `Justification` / `Change` / `Verification` / `Record` and the rest are deliberate and repository-wide — PM `01`, `12`, `14`, `18` and code `05`, `12`, `13` all do it, and the groupings carry real information. **N-015 is the terminal section only**, never the groupings above it. **Qualified 23/08/2026:** the seven files with no `## Completion` are **exactly** these seven, so the groupings and the missing terminal are one population, not two — the ruling holds as a statement of intent but cannot be applied as a clean separation |

---

## Session log

| Date       | Node settled                       | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Frontier redrawn |
| ---------- | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 21/08/2026 | N-011 (research) · re-verification | **Charted: 10 open nodes in 4 batches, 1 research node fired and settled same-day.** Two architecture reviews produced nine findings; charting produced a tenth. N-011 widened N-009 from one file to **four exemption arms / nine shipped files**, and bounded it honestly — exposure is **one citation and it is legitimate**, so the defect is latent, not live. Register triaged exhaustively at one entry: **0 closes, 0 blocks, 1 unrelated**. Q4 answered _don't add the index row_, which made the instruction itself node **N-010**. Nothing else settled — CHART draws the frontier. **Then the base moved under the session and every node was re-measured.** Two commits landed from parallel sessions between the first measurement and the write (`5d7d264`, `5d3c22f`); **all ten nodes still hold at `5d3c22f`**. Two premises did move: the single `GAPS.md` entry was deleted (staged, verdict unchanged), and `5d3c22f` repaired the one dangling citation the reviews had reported, so `doc-references.sh` is now **clean**. **N-009 came out stronger** — `5d7d264` narrowed a sibling arm of the very function it names, on the very same reasoning, leaving the four arms below it unamended. The standing lesson applied to itself: _re-verify what a parallel session hands you_                                                                                                                                                                                                                                                                                                                                 | [x]              |
| 23/08/2026 | _(none — a charting pass)_         | **Two further reviews; seven nodes added, nothing settled.** The `how-to/` pass (`…091427Z.html`) **fixed 14 defects** rather than charting them and left one decision, now **N-018**; the rule it installed at `how-to/workflows/CLAUDE.md:38-44` became **N-015**. The `code/` pass (`…135337Z.html`) charted **N-012**–**N-017**. Sixteen of seventeen open nodes are class **D** split doctrine; **N-012** is this map's first class **A**. **N-001 moved A → E** — a frontier redraw, not a re-typing: the `code/` pass found two more defects in the same four-file folder, and a batch justified by _shared evidence_ should follow the evidence. **The blocked item from the `how-to/` report is unblocked** — see below, including the recommendation that was not taken. Registers re-triaged against a `GAPS.md` restructured underneath the map: **0 · 0 · 0 over zero triable entries**, verdict unmoved. Every claim re-derived at `c09a189`; **all ten original nodes still hold**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]              |
| 23/08/2026 | _(none — a verification pass)_     | **A fifth review, over `project-management/`; no node added, three corrected.** `architecture-review-20260823-142445.html` re-measured the layer the other four had only passed through. **The pass's value was the refutation, not the discovery.** Its seven claims went to seven independent hostile verifiers and **six came back refuted or materially corrected** — including two the report had rated `Strong`. Killed: _"`18` is named nowhere in `REFERENCES.md`'s canonical map"_ (it appears four times, once **inside** the pairing table at `:206`) and _"three CHECKLISTs never declare the work finished"_ (the terminal assertion is **relocated to a line-13 preamble** in exactly those three). Corrected: N-015's `0 of 13` premise — true of the heading, false of the clause, **8 of 13** carrying items 1-4 **byte-identical** to the contract's own list; N-002's own citation, **stale at `:200`/`:172`** and understating a three-way disagreement as a two-way one; and the map's standing _"the gates are green"_, which meant **four** of the **twenty** audits that take `--path` — five others exit `1` on this tree, **all five false positives**. One defect found and **not charted**: the `02-story-creation` corruption, a Batch A rider and this map's first class **B** evidence. **Node-count invariant unmoved: 17 open + 1 resolved = 18.** The standing lesson applied to itself for the third sitting running — _re-verify what a parallel session hands you_, where this time the parallel sessions were the map's own verifiers, and the first draft of these numbers was wrong in six places | [x]              |

### The blocked item, and what it cost to unblock it

**`architecture-review-20260823T091427Z.html` shipped `14 defects fixed · 1 blocked`, and the
blocked one was not a finding — it was the tree moving underneath the review.** Mid-pass a parallel
session rewrote `code/src/scripts/audits/doc-references.sh` to add Check 3 and bulk-wrote
`<!-- doc-references: template-only -->` markers into 27 files outside `how-to/`. The gate **passed
clean at 10:07 and exited `2` at 10:10:41**, so the `how-to/` pass could not prove its own citations
resolved. It recorded the collision, did not touch the other session's file, and made one
recommendation: **separate the two changesets before committing.**

**Unblocked, and verified here rather than taken on trust.** `doc-references.sh` exits **`0`** at
`c09a189` — 968 files, 5,490 repo paths tested, 40 matched against copier's unconditional excludes.
All 14 `how-to/` fixes are live at HEAD, spot-checked independently of the report: zero surviving
`--service backend`, zero `lsof -i :8000`, `HEALTH-PROBES.md` present in `how-to/CONTEXT.md`,
`12-EXTENDING.md` renumbered to `25-`, and **9 of 9** how-to workflows now carrying both terminal
sections.

**The recommendation was not followed, and that is the part worth recording.** `c024338` is a
**70-file** commit holding both changesets — the Check 3 rewrite (+246 lines to
`doc-references.sh`, two new fixtures) _and_ the 24-file `how-to/` accuracy pass — plus edits to
`GAPS.md`, the template-health map and this one. Nothing was lost and the gate is green, so
**there is no node here**: re-splitting a landed commit buys nothing. What it cost is reviewability — a
documentation-accuracy pass now sits inside a gate change, and neither half reverts without the
other. **N-012's evidence survived only because it was re-derived from the tree** rather than read
out of a report. Two sittings, two parallel-session collisions, one lesson: **this map's claims are
measurements taken at a named commit, never quotations from a report.**

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

**Stories may be cut in `workflows/02-story-creation/` now** — no node gates them. **Batch E is the
intended first slice**, displacing Batch A: three defects in one four-file folder is the cheapest
sitting on the board and the only one where re-reading the same files twice is the alternative.
A follows immediately.

**Node-count invariant: 17 open + 1 resolved = 18 = N-018** — **re-confirmed at `a4d3ca9`**; the
fifth pass corrected evidence under N-002, N-004 and N-015, answered the N-015 fog entry, and added
**no** node. Per batch: A 4 · B 4 · C 2 · D 2 ·
E 3 · F 2. Per class: **D** 16 · **A** 1.
