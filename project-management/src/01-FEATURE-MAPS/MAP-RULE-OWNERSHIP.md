# MAP-RULE-OWNERSHIP — one rule, one home, and a guard that keeps it there

**Charted**: 21/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `9a69a9b` · **Re-verified at**: `a4d3ca9` (23/08/2026) · **Extended at**: `111637a`
(23/08/2026) — **a sixth review, over the copier seam, refuted four of its five candidate findings
and charted one: N-019. The seventeen existing nodes were not re-measured by it**
**Resolved at**: `7a82095` (27–28/08/2026) — **ten sittings. E settled N-001, N-012, N-013 and
opened N-020 and N-021; A settled N-002, N-007, N-016, N-017, N-019 and its rider; B settled
N-003, N-005, N-006, N-018; F settled N-014 and N-015, answered the four-spellings fog entry from
evidence, and discharged one of N-004's five conditional rows; G1 settled N-020 after **Batch G
split in two**, its charted _"settled shape"_ having failed on contact with the tree; **G2
settled N-022 after measurement falsified all three of its charted premises, then N-021; **C
settled N-004 and N-008 after finding the guard it was sent to widen was itself false green**;
**D settled N-009 and N-010 on 28/08/2026 after executing its own proposed glob and rejecting it**;
**H settled N-023 and N-024, charted the same day, after proving one guard impossible in the
obvious form and the other untestable in this repository**. Between them they corrected
**thirty-one** of this map's own literals and found three populations larger than charted, all
recorded below**
**Status**: **Blockers clear — stories may start**
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 24 — **every node on this map is
settled. N-023 and N-024 were charted and settled on 28/08/2026, in the sitting that closed D**

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
> **A sixth pass, 23/08/2026, over the copier seam — five candidate findings, four refuted, one
> node.** `architecture-review-20260823-164041.html` asked a single question: does a generated
> project keep its edited documentation across `copier update`? The answer is **yes, and it always
> did** — the three-way merge preserves an untouched file silently and an edited one unless the
> lines overlap. Four of the five findings that followed died on that fact or on a mechanism the
> review had not looked for, and **the fifth is N-019**. Two of the four were killed by execution
> rather than argument: a real `copier copy` at v7.0.0 → fill in four answer sheets → `copier
update` to HEAD produced **zero** conflicts, and `copier update` was measured carrying `-s/--skip`
> and `-x/--exclude` at 9.17.2, which the guides say requires a fork. **The pass is recorded for
> what it refuted**; its one node came from the wreckage of a taxonomy, not from its own thesis.
>
> **It also ran against a moving tree, and that is the fourth sitting running.** Two commits landed
> mid-pass from a parallel session — `9122ca5` (v7.4.0) and `111637a` (v7.4.1) — the second of them
> **fixing the very fact N-019 charts**. Every number below is measured at `111637a` with a clean
> tree, not at the `fff9955` the pass opened on.

> **No index row in `CONTEXT.md` — and N-010 settled why, 28/08/2026.** A `MAP-<FEATURE>` row is a
> per-project instance citation in a file that **ships**, which is the defect
> `audits/doc-references.sh` exists to prevent, so nine maps have declined it. The resolution is
> **relocation, not exception**: the `## Map index` table moves out of the shipped `CONTEXT.md`
> into its own non-shipping file, after which both rules are obeyed and the row is added. Until
> that lands, this map still declines it — deliberately, and on the record.

---

## Destination

Every rule in this repository is **stated once, in a named owner, and cited everywhere else** —
and a guard makes a second home fail rather than rely on a reader noticing. Reached in that
order: the instances that break at runtime first, then the guard, then the remainder as the guard
catches them.

---

## Notes

| Field                      | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                     | Repository documentation governance — the three-role split (`.claude/CLAUDE.md` global rules · per-folder `CLAUDE.md` local rules · `CONTEXT.md` orientation) and the audits that hold it up                                                                                                                                                                                                                                                                                                                                 |
| Skills to load             | `doc-writer` · `scaffold` · `domain-modelling` · `codebase-design` · `grill-with-docs`                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Standing preferences       | **Route, don't restate** (`code/docs/DOCUMENTATION-PAIRING.md` Section 6) · a gate is **derived from a stated rule, never from taste** (`code/src/scripts/audits/CLAUDE.md`) · **no gate may disagree with the settled rule** (Sam, 23/08/2026) · **every node resolved before any story is cut** (Sam, 27/08/2026) · **an enforcement rule that composition walks around is false green, not a gate** (Sam, 27/08/2026)                                                                                                     |
| Umbrella ADRs              | None — `15-DECISIONS/` holds only `ADR-000-TEMPLATE.md`. N-003 and N-004 are the two likeliest to earn the first                                                                                                                                                                                                                                                                                                                                                                                                             |
| Relationship to other maps | Deliberately **not** folded into the template-health map that has since been deleted, which held **no** node touching workflow shape, the observability tokens, or `09-debugging-with-logs`. These seventeen share one cause and one remedy. The split had a measured cost — `MAP-ABSENCE` routed eight findings there and nobody adopted them                                                                                                                                                                               |
| Defect classes             | Reuses `GAPS.md`'s five: **A** token blast radius · **B** false green · **C** inheritance leak · **D** split doctrine · **E** declared, not built. Five of six open nodes are class **D** — that is the map's whole thesis. **N-020** and **N-021**, opened 27/08/2026, were the first class **E**; **N-020 is settled and N-022 arrived class D**, so the thesis reasserted itself even in the batch that looked least like it. The one class **A** and the map's one class **B** — the corruption rider — are both settled |
| Register entries triaged   | **0 closes · 0 blocks · 0 unrelated** — re-triaged 23/08/2026 against a restructured `GAPS.md` (see below)                                                                                                                                                                                                                                                                                                                                                                                                                   |

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
| GAPS.md     | **Re-triaged 01/09/2026** — 6 dated entries + 3 loose items                  | **unrelated**   | —          |
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

| Node  | Decision                                                                                     | Type     | Settled    | Became                                                                                                                                                                                                                       |
| ----- | -------------------------------------------------------------------------------------------- | -------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| N-011 | Does the false _"does not ship"_ premise repeat across `doc-references.sh` exemptions?       | research | 21/08/2026 | The evidence under **N-009** — a measurement, not a decision; no external artefact                                                                                                                                           |
| N-001 | Where does `09` reach the dev and staging stacks, now the raw form cannot work at all?       | build    | 27/08/2026 | Slice **S-01** — the script seam, the service name, the log path, and Step 7 cut to verification                                                                                                                             |
| N-012 | Which of the three vendor names is a token, and what does the one that cannot be do?         | build    | 27/08/2026 | Slice **S-01** — 29 of 43 tokenised, 14 `Grafana` kept literal under a reference-stack marker                                                                                                                                |
| N-013 | Where is `09` cut, given Step 7's tools are its own?                                         | build    | 27/08/2026 | Slice **S-01** — cut at the fix, not at the root cause; Step 7 survives                                                                                                                                                      |
| N-002 | Which build-phase range is canonical, and do the two restatements survive?                   | build    | 27/08/2026 | Slice **S-02** — `19`–`21` gated on `02`–`18`; six numbers fixed, both restatements **deleted**                                                                                                                              |
| N-007 | The exemption cannot be written as the glob all four sites write                             | build    | 27/08/2026 | Slice **S-02** — a two-part glob replaces `**/src/*.md` in all four                                                                                                                                                          |
| N-016 | Fix the omissions, and does a decaying rule earn a gate?                                     | build    | 27/08/2026 | Slice **S-02** — eight fixed; the gate question routed to **N-004** as its fourth conditional row                                                                                                                            |
| N-017 | Four stale literals — replace them, or remove what goes stale?                               | build    | 27/08/2026 | Slice **S-02** — three replaced; the file count becomes a **command**, not a figure                                                                                                                                          |
| N-019 | Six shipped homes, and the only full account sits in a file that does not ship               | build    | 27/08/2026 | Slice **S-02** — owner `06-GENERATION.md:140-141`; `copier.yml:842-845` keeps a guard comment                                                                                                                                |
| N-003 | Where does the 750/800 source limit live, when four claimants name a silent file?            | grilling | 27/08/2026 | Slice **S-03** — home is `coding-principles/PRACTICAL-RULES.md`; four claimants repoint                                                                                                                                      |
| N-005 | `phase:` — define the vocabulary, or delete the key?                                         | grilling | 27/08/2026 | Slice **S-03** — **deleted** from 93 files and from the `.claude/CLAUDE.md:85` schema                                                                                                                                        |
| N-006 | Which of the four model-tier answers is canonical, and what governs a step?                  | grilling | 27/08/2026 | Slice **S-03** — frontmatter canonical; range list deleted; 17 of 40 step markers removed                                                                                                                                    |
| N-018 | `CLI-TOOLING.md` promises three scopes and satisfies none                                    | grilling | 27/08/2026 | Slice **S-03** — becomes an **index** over ten families plus a derived eight-command set                                                                                                                                     |
| N-015 | The `STEPS`/`CHECKLIST` contract has an owner, but its named reference does not satisfy it   | grilling | 27/08/2026 | Slice **S-04** — owner becomes `how-to/docs/WORKFLOW-SHAPE.md`, cited by seven; guard is a new `audits/workflow-shape.sh`                                                                                                    |
| N-014 | The `## Context` closing block is a second copy of PM `22`, and 30 of 34 understate the rule | grilling | 27/08/2026 | Slice **S-04** — deleted in `code/` (9 files); 29 survivors + 22 `STEPS.md` blocks take one canonical line                                                                                                                   |
| N-020 | The staging/prod logging pipeline is promised by two shipped docs and built by neither       | build    | 27/08/2026 | Slice **S-07** — a hand-written formatter + `request_id` filter in `apps/core/observability.py`; no dependency                                                                                                               |
| N-022 | The retrieval procedure has no owner, and the doctrine it rests on is stated in no file      | grilling | 27/08/2026 | Slice **S-08** — line at the **connection**; rule owned by `.claude/CLAUDE.md` Section 6; access owned by the `<%DEPLOY_REPO%>` runbooks                                                                                     |
| N-021 | _"Humans collect the logs"_ is stated nowhere and enforced by nothing                        | build    | 27/08/2026 | Slice **S-08** — `deny` for the bare verbs + a `PreToolUse` hook for the wrapped forms; ships verbatim; **no log excerpt enters the repo**                                                                                   |
| N-004 | Widen `doctrine-drift.sh` — prose matching, an owner column, a wider scan scope              | grilling | 27/08/2026 | Slice **S-05** — a dead claim fixed first, then a per-claim `scope` field, a citation exemption and per-claim scan roots; four rows land                                                                                     |
| N-008 | The coverage-floor restatements have no revisit trigger                                      | grilling | 27/08/2026 | Slice **S-05** — a dated allowance in `COVERAGE.md`, read by `docs-length.sh`; the guard cannot supply a trigger and does not                                                                                                |
| N-009 | `doc-references.sh` exempts nine **shipped** files on a premise `copier.yml` falsifies       | grilling | 28/08/2026 | Slice **S-06** — one fall-through arm for `*/CONTEXT.md`, `*/CLAUDE.md`, `*TEMPLATE*` mirroring `copier.yml:116-133`; 982 files read, 1 genuine finding (`research/CLAUDE.md:26` → `LICENSE`)                                |
| N-010 | The index-row instruction cannot be safely followed as written                               | grilling | 28/08/2026 | Slice **S-06** — resolved by **relocation**: the `## Map index` table leaves shipped `CONTEXT.md` for its own file. The register-wide case is **claimed by `MAP-REGISTER-INDEXES.md`**                                       |
| N-023 | `/wayfinder resolve` writes to five artefacts and is forbidden from none                     | grilling | 28/08/2026 | Slice **S-09** — RESOLVE writes **the map only**; the graduation table becomes a pointer to `15-DECISIONS`, `02-story-creation` and `22-implementation-documentation`, which already own each destination                    |
| N-024 | The template rule has an owner whose statement covers `04`–`13` only                         | grilling | 28/08/2026 | Slice **S-09** — `project-management/src/CLAUDE.md:26-29` widens to every `NN-*`; folder files keep the template's **name** and drop the **rule**; the `18-TESTS` pair is renamed and `00-ASSETS` named as the one exception |

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

**Batch E in full, because settling it corrected four of this map's own literals and opened two
nodes.** Re-measured at `7a82095`, all three nodes held and every one was **larger than charted**.

- **N-001 · settled: route to the scripts, and cut Step 7's deploy.** The 9 raw calls sit at the
  cited lines, but the map never recorded that **all six dev commands name service `backend`,
  which does not exist** — `docker-compose.dev.yml` defines `db`, `cache`, `django`, `nginx`, so
  they cannot run at all. Nor that the in-container log path is wrong five times: `STEPS.md:53,57,
61,65,72` write `/workspace/src/logs/django.log` against the real `/workspace/code/src/logs/
django.log` (`dev.py:40` `parents[4]`, WORKDIR `/workspace`, mount `../django:/workspace/code/src/
django`). **Step 7 had nothing to route to** — `code/src/scripts/deployment/` holds no script and
  its `CONTEXT.md` deliberately keeps `deploy.sh` out of `how-to/src/PROJECT-PATHS.md`, because
  _"an entry that cannot name its creator is a wish"_. So Step 7 loses its shell block and becomes
  **verification only**, the deploy a stated precondition owned by `<%DEPLOY_REPO%>` per
  `how-to/docs/FEATURE-DEPLOY.md`, which says _"not this repo"_ at `:37`, `:77` and `:113`.
  `code/src/logs/CONTEXT.md` and `CLAUDE.md` fold into the same sitting — same dead service name,
  one more raw call, four host-side paths.
- **N-012 · settled: tokenise 29, mark 14, and delete the second copy of the classification.**
  `<%ERROR_TRACKING%>` (16) and `<%LOG_AGGREGATOR%>` (13) are both **`bare name · prose`** at
  `how-to/src/TEMPLATE-TOKENS.md:107-108`, so they substitute directly. The **14 `Grafana`**
  literals stay, under a **reference-stack marker** in the `OBSERVABILITY.md:14` idiom, because
  `<%OBSERVABILITY_STACK%>` is phrase-shaped and Steps 4-5 are a Grafana **UI procedure** — a
  project answering differently needs to know what it is reading, not a token that breaks
  mid-sentence. **No wiring-status marker is added:** _declared, not wired_ has an owner one
  directory away and is cited, never copied. Rider: `copier.yml:358-363` **loses its enumeration
  entirely** and cites the register instead of restating a list it gets wrong.
- **N-013 · settled: cut at the fix, not at the root cause.** `STEPS.md:180`'s heading claims the
  regression test but its **body already delegates** to `10-debug/STEPS.md`; the real breach is
  `CHECKLIST.md:17-21` and `:23-27` — **six tickable boxes** claiming `10`'s gates. Those go, with
  Step 6. **Step 7 survives**: reading Glitchtip and Grafana after a deploy is `09`'s own toolset,
  and `CONTEXT.md:28` already promises _"confirm that a fix actually resolved an issue in
  production"_. `CLAUDE.md:31-33,38-39` and both index files were already right.

**Four literals of this map's own were wrong, and are corrected here rather than silently.**

| Written                                              | Measured at `7a82095`                                                                                                            |
| ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| N-001: _"44 of 45 workflows comply"_                 | **45 of 46** — 13 code + 9 how-to + 24 PM. An N-017-class stale literal inside another node's evidence line                      |
| N-012: `copier.yml` _"the other two as cell-only"_   | `LOG_AGGREGATOR` is **prose**, not cell (`TEMPLATE-TOKENS.md:108`). The misreading would have blocked 13 of the 43 substitutions |
| N-012: `copier.yml` omits one token from its lists   | It omits **two** — `LOG_AGGREGATOR` and `ANALYTICS_PROVIDER`, both prose-shaped. Four prose · three cell is the register's count |
| `09/CONTEXT.md:34` marks local log files ✅ for test | `test.py` declares **no file handler at all**; only `dev.py:56-57` writes one. The row was never true for that column            |

**Batch A in full, settled the same day, and it corrected six more of this map's literals.**
Re-measured at `7a82095`: **all five held, two were bigger, one had shrunk under a parallel
session, and the rider's harshest claim was confirmed.**

- **N-002 · settled: `19`–`21`, gated on `02`–`18`, and both restatements deleted.** Charted as
  three files disagreeing; it is **four**, because `REFERENCES.md` — the file that calls itself
  _"the single source of truth"_ for this — **contradicts itself**. Its prose at `:201` and
  `:218-220` says the build phases are `18`–`20`; its own pairing rows at `:210-212` are
  `19-backend-code`, `20-api-code`, `21-frontend-code`, and it **already writes `19` correctly at
  `:208` and `:209`**. Six numbers in that one file are wrong — `:201` ×2, `:206`, `:218`, `:220`
  ×2 — against two already right, which is the file's own hand settling the question. `18` is a
  **gate**, not a build phase (PM `workflows/CONTEXT.md:175`). **Both restatements are deleted
  rather than corrected (Q1):** each carries _"Do not restate it here"_ two lines above, so
  `REFERENCES.md` is cited and not summarised. Consequential: _"Three rules follow"_ → **Two**,
  _"Two rules follow"_ → **One**.
- **N-007 · settled: a two-part glob, in four sites.** A fourth site joins the three charted —
  `docs-length.sh:382`. **The exemption cannot be written as `**/src/*.md` at any depth:**
  `is_instructional()` exempts a `src/` tree **unless** the path carries a `docs/` or `workflows/`
  segment or starts `.claude/`, which its own comment defends deliberately — a guide at
  `code/src/django/apps/billing/docs/GUIDE.md` must stay rule-bound. So (Q2) `**/src/**/*.md`
  exempt, `**/src/**/docs/**` and `**/src/**/workflows/**` bound, written the same way four times.
- **N-016 · settled: fix the eight, route the gate to N-004.** **The node shrank under a parallel
  session and grew back by one.** Four of the eleven charted omissions are now present —
  `DOCUMENTATION-PAIRING`, `OBJECT-STORAGE`, `PROCESS-MODEL`, `TASK-AUTHORING` — and
  **`MACHINE-SPEC` has appeared since charting**. Eight remain, with `docs/discoverability/`,
  `scripts/dependencies/` and **`apps/health`**, whose only trace in the file is the unrelated
  phrase _"codebase health audits"_ at `:63`. `code/src/CONTEXT.md:17` still says _"`core` ships"_
  against its own child's _"Neither shipped app"_. **That four were fixed and a fifth appeared is
  the evidence the node lacked** — this rule decays continuously rather than failing twice, which
  is why the gate question goes to **N-004** (Q3) rather than being designed in the wrong batch.
- **N-017 · settled: three replaced, one turned into a command.** Three literals become **four**.
  `code/workflows/CONTEXT.md:89` says PM _"runs 01 → 21"_ against **24** folders; `mypy` is
  required by `19-backend-code/CHECKLIST.md:35` and `20-api-code/CHECKLIST.md:38` while
  `syntax/check.sh` runs **basedpyright** and mypy appears in **no manifest**. **The fourth is new
  and sits in the sentence that names the owner:** PM `workflows/CONTEXT.md:179` says the code
  workflows _"hand off to `21`"_ and `:181` that the registers are _"written at `21`"_ — inside the
  bullet whose own first line assigns closeout to **`22`**. **The file count becomes a `git grep`,
  not a figure (Q4):** charted as 156, measured here as **142** on a narrower predicate, written as
  _"roughly 110"_. Three numbers for one claim is the defect; a stored figure schedules the next
  N-017.
- **N-019 · settled: one shipped owner, five citations, one guard comment kept on purpose.** All
  six homes intact at HEAD. `06-GENERATION.md:188` is now measured rather than argued: `_tasks`
  gates **1 and 4** on `_copier_operation == 'copy'`, while task 2 (manifest branding) and task 3
  (`uv lock`) are **ungated** — so _"Tasks 1, 2 and 4 are guarded"_ is false on task 2.
  **`/copier.yml` is the first line of `_exclude` and does not ship**, while all six homes do
  (`how-to/src/TEMPLATE-GUIDE/` ships deliberately, per `_exclude`'s own comment), so the owner is
  forced to **`06-GENERATION.md:140-141`** — the corrected account that ships. **One deliberate
  second home (Q7):** `copier.yml:842-845` keeps its full guard comment on the `_tasks:` header,
  because distance from the hazard is exactly what failed — `111637a` corrected `:140` and
  reintroduced the error at `:188`, **48 lines below its own fix**. `copier.yml:56-59` becomes a
  pointer. **Recorded as an exemption, not an oversight: a guard comment adjacent to its hazard is
  a second home by design**, and a later pass must not chart it as a violation of this map.
- **Rider · settled: fragment two is re-authored, naming no script.** The corruption at
  `02-story-creation/CHECKLIST.md:49` is confirmed, and the map's harshest claim about it is
  **right**: `git log --all -S` places the string in **`c2886e8` alone**, so the line was **born
  corrupt** and has no clean ancestor in 294 commits. Fragment one restores verbatim from
  `01-implement-story/CHECKLIST.md:37`. Fragment two ends ``…sh` before raising PR (requires dev
server running)``, and **the repository has no a11y, axe or pa11y script at all** — four scripts
  need a live server and none checks accessibility. So (Q6) it is re-authored as _"the rest walked
  manually against a running dev server before raising PR"_: true today, and registering no path
  that nothing creates. **This was the map's only class B evidence, and it is settled.**

**Batch B in full — four grilling nodes, one question, and the sitting that found this map's
largest single population.** Re-measured at `7a82095`: **all four held, one was partly repaired
under a parallel session, and two were substantially larger.**

- **N-003 · settled: the home is `code/docs/coding-principles/PRACTICAL-RULES.md`.** **56 files
  state the number and four name a home; the named home is silent.** `.claude/CLAUDE.md:231`
  states both numbers and then disclaims ownership, pointing at `code/CONTEXT.md`;
  `coding-principles/CLAUDE.md:30` names **two** homes in one sentence — _"this folder"_ **and**
  `code/CONTEXT.md`; `how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md:155` **ships**, telling a
  generated project to change the rule in `code/CONTEXT.md`; and `cloc.sh:70` points back at
  `CLAUDE.md`. **`code/CONTEXT.md` states neither number**, and `CODING-PRINCIPLES.md` is a
  30-line index that states neither. `STYLE-AND-PROCESS.md:183` says _"within the 750-line
  limit"_, **omitting the grace**, against `cloc.sh:25-26`. **23** `CLAUDE.md` files under
  `code/src/` restate it, not 22. **Settled (Q1, Q5):** the numbers are written once into
  `PRACTICAL-RULES.md`, which the folder's own `CONTEXT.md:12` scopes to _"concrete
  implementation rules and patterns"_ — the only non-arbitrary tiebreak available. `.claude/
CLAUDE.md` Section 8 cites it, exactly as it already cites `DOCUMENTATION-LENGTH.md` for the other
  length rule; the other four claimants repoint; `:183` becomes a citation. **`code/CONTEXT.md`
  was never the answer** — `DOCUMENTATION-PAIRING.md`'s decision test puts a threshold in
  operating rules, never in orientation, so three claimants had made one category error together.
- **N-005 · settled: `phase:` is deleted.** Grown to **93** files and **11** values — `design` 30,
  `build` 22, `verify` 14, `setup` 6, `ship` 4, `operate` 4, `harden` 4, `compliance` 4,
  `document` 2, `discovery` 2, **`implementation` 1**. The singleton is the vocabulary drifting in
  real time. **Nothing reads it** — every `phase` hit in `code/src/scripts`, `.claude/hooks`,
  `.github` and `lefthook.yml` is pytest's unrelated two-phase run — and **nothing defines it**:
  `.claude/CLAUDE.md:85` lists the key and no vocabulary. **Settled (Q2): delete it**, because
  defining it would force a **third** family taxonomy alongside the `code/` and `how-to/` schemes
  (the standing fog entry) to justify a field nothing consumes. **The deletion is clean**: both
  `phase:` matches in `.claude/skills/` are prose (_"the TDD Red phase:"_, _"Output of this
  phase:"_) and `scaffold` templates no frontmatter, so the change is 93 workflow files plus
  `.claude/CLAUDE.md:85` and **no emitter**.
- **N-006 · settled: frontmatter is canonical, the range list goes, and 17 of 40 step markers go
  with it.** **One of the map's three charted errors is repaired and two new ones are present.**
  Frontmatter is clean — **01–18 `fable`, 19–24 `opus`**. `project-management/workflows/CLAUDE.md:
30-32` now reads _"Fable (01–10, 13–17); Opus for SEO (12)…"_, so _"11 is qa-checks not SEO"_ is
  **fixed** — `12` **is** `12-seo-checks`. What is wrong now: **`11-qa-checks` and
  `18-consolidate-design-work` are named by neither range**, and **`12` is assigned `opus` where
  its own frontmatter and `.claude/CLAUDE.md` Section 4 both say `fable`**. **The fourth answer is an
  order of magnitude larger than charted.** The map recorded _"inline annotations invert two design
  workflows"_; there are **40 step-level `> **Model:** opus` markers across all 18 fable
  workflows**, and **17 of them put a design act on the implementation tier** — including **six
  `Step 1 — Grill, then …` steps**, the opening move of design work. The other 23 are legitimate:
  Commit ×11, Close out ×4, four review steps, and mechanical ones like _"Copy the template"_.
  **Settled (Q3, Q6, Q8):** frontmatter is canonical; the range list is **deleted**, having been
  wrong at every measurement ever taken of it; Section 2.5 gains one sentence — _a step-level `Model:`
  overrides the file-level `model:`, and the grilling step always inherits the file-level tier_;
  the 17 wrong markers are **deleted rather than corrected to `fable`**, since a marker restating
  the file level is noise. **The grilling clause is not derivable and that was measured, not
  assumed:** Section 10 makes grilling open _"design, code, tests, QA, refactor, review, debug, migration,
  docs"_, so grilling is **not intrinsically fable** and Section 4 implies nothing about its tier.
- **N-018 · settled: it becomes an index, plus a set derived from two workflows.** **25 of 80
  confirmed to the digit** — `syntax` 3/3 · `tests` 6/8 · `database` 4/8 · `development` 5/15 ·
  `mobile` 3/7 · `rust` 1/5 · **`audits` 2/24** · **`desktop` 0/4** · **`dependencies` 0/1** ·
  `_lib` 1/5, where `_lib` is five internal libraries and the honest user-facing denominator is
  **75**. **There are three framings, not two, and two of them are in the same file**:
  `how-to/CONTEXT.md:22` _"every dev command"_, `:92` _"the command that does a thing"_, and
  `how-to/REFERENCES.md:56` _"all Docker Compose development commands"_. **Settled (Q4, Q7, Q9):**
  one row per script family routing to that family's `CONTEXT.md` — which this map already
  measured as listing **all 80** — plus a short everyday section holding exactly the **8** scripts
  `03-daily-development` and `08-debugging` invoke: `server.sh`, `logs.sh`, `shell.sh`,
  `migrate.sh`, `check.sh`, `lint.sh`, `all.sh`, `backend.sh`. **The set is derived from named
  workflows rather than chosen**, which is what stops it drifting back into _"every dev command"_
  one entry at a time — the mechanism that produced the arbitrary 25. All three framings then say
  the same narrower thing.

> **A fifth defect surfaced that no node had charted, and it is why N-020 exists.** `STEPS.md:104,
117,126,141` pipe LogQL `| json` and `:106` filters `| __error__=""`, while `staging.py:43-46`
> and `production.py:49-52` declare a **`StreamHandler` with a plain-text `verbose` formatter** and
> inherit no other. Every query in Step 4 therefore returns **nothing**, and two shipped documents
> — `how-to/src/PLATFORM-PROVIDERS.md:38` and `copier.yml:433` — promise **structured JSON on
> stdout**. Found by settling N-001, owned by neither it nor N-012.

**Batch F in full, because the re-measurement roughly doubled one node and answered a fog entry
from evidence.** Re-measured at `7a82095` across all 46 workflow folders (13 `code/` + 9 `how-to/`

- 24 `project-management/`), each axis measured once and then re-derived by an independent
  verifier using different commands. **The verifiers overturned findings from their own measurers**,
  so every number below is twice-derived.

- **N-015 · settled: the contract moves to an owner of its own, and the terminal section becomes
  two named sections.** Owner is a new **`how-to/docs/WORKFLOW-SHAPE.md`** — workflows are a
  how-to subject, so the rule sits in the layer whose readers execute it, not in `code/docs/`.
  It carries the **four-file shape and the terminal contract, nothing else**: every rule a wider
  scope would absorb (the routing frontmatter at `.claude/CLAUDE.md` Section 2.5, the 300-line
  limit at `code/docs/DOCUMENTATION-LENGTH.md`) already has a named owner **and** a working gate,
  and moving one would create the second home this map exists to close. Cited by **seven**: the
  three layer `workflows/CLAUDE.md`, `.claude/skills/scaffold/SKILL.md`,
  `how-to/src/TEMPLATE-GUIDE/12-EXTENDING.md`, `.copier/README.md` and
  `project-management/workflows/24-release/CLAUDE.md` — chosen because those four are existing
  **homes** of the fact rather than readers of it, and leaving them stating it independently
  reproduces the fork below. **`CHECKLIST.md` closes with an optional `## Close-out` (docs
  hygiene) then a required `## Definition of Done` (the assertion). `STEPS.md` closes with a last
  step that routes to `` `CHECKLIST.md` ``; `## Completion` is no longer required**, because all
  **39 of 39** that carry it are byte-identical boilerplate — one sentence, _"Run through
  `CHECKLIST.md` before marking this workflow complete."_ — so the heading carries no information
  a reader could get wrong. Realisation is **layer-local**: the contract asserts the obligation and
  each layer names its own form, which is what keeps `code/`'s numbered step conformant as written.
- **The map's own figures for N-015 were wrong in four places, and the rule is failed far more
  widely than charted.** _Three_ checklists lacking `## Definition of Done` is **eight** —
  the three preamble carriers plus `code/05`, `code/12`, `code/13`, `PM/13`, `PM/17`. _Four_
  spellings is **five** — `Close-out` ×4, `Closeout` ×3, `Close out` ×3, `Close Out` ×2,
  `Sign-off` ×3, plus `Verify and hand off` ×2 doing the same job. And _9 of 46 fail_ counts four
  headings independently; read as the **ordered tail the contract is actually written as**, only
  **22 of 46 folders** conform — `code/` **0 of 13**, `PM` 15 of 24, `how-to` **9 of 9**. The
  layer that wrote the rule is the only one that keeps it; the layer it names as _the reference
  shape_ does not.
- **The four-spellings fog entry is settled from evidence, and its own premise was false.** It
  supposed `Sign-off` and `Close-out` might mean _a person approves this_ rather than _the work is
  done_. They do not: all six `Close-out`/`Closeout` sections hold **zero** approval items across
  21 checklist items, `PM/17`'s `Sign-off` holds **0 of 4**, and `PM/13`'s holds **1 of 4** —
  against **8 `Definition of Done` sections that do carry approval items**, four of them using the
  literal words _"signed off"_. The distinction is not carried by the spelling anywhere. The entry
  also claimed `Close-out` sits on _"three discovery ones"_; **exactly one** of the 46 workflows is
  `phase: discovery`, and the other two are `phase: design` — the same phase as both `Sign-off`
  files. **One real distinction survived and is what Q2 canonised**:
  `PM/12-seo-checks/CHECKLIST.md` carries **both** sections — a `## Close-out` with 0 assertion
  items and a `## Definition of Done` with 2 — and the docs-hygiene pair sits under `Close-out`
  **4 of 4**. They are two sections, not two names, and that file is now the shape's exemplar.
- **N-014 · settled: the block is deleted in `code/` and corrected everywhere else.** The
  restate/route partition is **perfectly clean**: all **9** `code/` checklists carrying a
  `## Context` block mention PM `22-implementation-documentation` **zero** times, and all **4**
  without it (`01`, `02`, `12`, `13`) route to it — so the block **is** the restatement,
  one-for-one, in breach of `code/workflows/CONTEXT.md:112` (_"they never restate its formats or
  destinations"_). All 13 now route. The **29 surviving blocks** (`how-to` 9, `PM` 20) take one
  canonical pairing line naming **both** files and **citing `audits/docs-pairing.sh`**, because the
  block's whole failure mode is that it is advisory prose with no mechanical link to the gate it
  contradicts. **The graph half rejoins in the survivors only** — no graph line is written into a
  block being deleted.
- **N-014 was scoped to the wrong file set, and to the wrong shape.** _"37 files carry the same
  four-line block"_ is wrong twice: it is **38** at HEAD, and hashing the bodies yields **seven
  distinct variants** — the 4-line canonical covers only **29 of 38**, so nine files need
  individual judgement and not a `sed`. Four `how-to` checklists (`04`, `05`, `06`, `07`) carry a
  **3-line block with no pairing line at all**, weaker than the weak wording and a distinct defect
  the _34 / 30 / 4_ framing hid; they gain the canonical line, because the variant is a truncation
  rather than a considered exception. The four _"correct copies already in the tree"_ use **two
  rival wordings**, so there was no canonical line to copy from. **And the defect was never
  confined to `CHECKLIST.md`: 22 of the 24 `## Update context files` blocks in `STEPS.md` also
  say item 4 = create _a `CONTEXT.md`_** — 30 + 22 = **52** instances of one understatement, of
  which 51 survive `code/`'s deletion and take the canonical line.
- **The gate the checklists understate was executed, not assumed.** A directory holding only a
  `CONTEXT.md` fails `docs-pairing.sh` with exit `1` and the message _"no CLAUDE.md beside it —
  every orientation file is paired"_. **`docs-pairing.sh` never opens a `CHECKLIST.md`** — so
  correcting the wording changes no gate outcome, only what a reader is told to expect. That is
  the standing preference _no gate may disagree with the settled rule_ in its purest form: here
  the **checklist** is the weaker of the two and the gate is right.
- **N-015 · the guard: a new `audits/workflow-shape.sh`, fail tier, self-guarding.** It asserts
  the four files exist per `NN-…/`, that every `STEPS.md` cites `` `CHECKLIST.md` ``, and that
  every `CHECKLIST.md`'s last H2 is `## Definition of Done`. It is **not** an extension of
  `docs-pairing.sh`, whose stated rule is the pair — bolting a second rule into it would make one
  script answer to two owners, which is this map's own defect class. Tier and absence behaviour
  are **derived, not chosen**: `audits/CLAUDE.md:90-93` reserves the warn tier for _"a threshold
  on composition or vocabulary"_ that would fail correct work, and a structural presence assertion
  is deterministic; `:59` requires a self-guarding audit to **exit 0, not fail, when its surface is
  absent**, which the opt-in `code/12` and `code/13` folders need. **The wiring cost is stated
  rather than discovered:** a 25th script needs CI, `lefthook.yml`, the operator gate list and
  `audits/CONTEXT.md` — the `c024338` pass found six audits missing from that list, and
  `dependency-drift.sh` is wired to neither today.
- **The counter-argument to guarding at all is recorded, because it nearly won.** The routing
  frontmatter keys are equally ungated and have drifted **nowhere** — all **92** `STEPS.md`/
  `CHECKLIST.md` carry `workflow:`, `phase:` and `skills:`, 0 missing in any layer. Absence of a
  gate did not produce drift there; it did in 24 of 46 folders for the headings. **And the claim
  that nothing gates workflow headings is false**: `docs-pairing.sh:310-312` already asserts an
  exact H2 sequence over all **49** workflow-tree `CLAUDE.md`, and `:321` bans `Definition of done`
  as a `CONTEXT.md` heading. The precise statement is that **the two workflow files whose shape is
  gated are the two that do not carry the terminal contract**, and the two that carry it are opened
  by nothing but a line count.
- **Rider — the four-file shape has seven homes and three of them are wrong.** All 46 folders carry
  four files. Correct: `code/workflows/CONTEXT.md:3,39`, `how-to/workflows/CLAUDE.md:13,36`,
  `project-management/workflows/CLAUDE.md:55`, `how-to/src/TEMPLATE-GUIDE/12-EXTENDING.md:35`,
  `.copier/README.md:809`. **Wrong: `code/workflows/CLAUDE.md:13-14,31,55` says _three-file_ in
  three separate statements and contradicts its own paired `CONTEXT.md` inside the same
  directory** — the orientation file is right where the operating-rules file is wrong, which
  inverts the usual assumption. Also wrong: `project-management/workflows/24-release/CLAUDE.md:53`.
  **And the worst of the three is `.claude/skills/scaffold/SKILL.md:65-68` — the skill that
  creates workflow folders** — which states a three-file shape, omits `CLAUDE.md` entirely, makes
  `CHECKLIST.md` conditional (_"where the sibling workflows carry one"_), and never mentions the
  terminal sections. All four become citations of the new owner; **the authoring path is not
  allowed to restate the contract**, because a restatement in the file that generates the
  population is how this defect class propagates.
- **Rider — `code/05-mcp-server` is the one place the function is genuinely missing, on both
  halves, and repairing it costs the tree its best copy.** Its `CHECKLIST.md` ends at `## Context`
  with no terminal section — the only one of 46 — and its `STEPS.md` is the only one of 46 that
  never cites its own `` `CHECKLIST.md` ``, because `:134` names a **different** document's
  checklist and `grep -i checklist` therefore matches all 46. Its `## Context` block is the **most
  complete in the tree** (names both files _and_ the graph refresh) and N-014 deletes it; the same
  wording survives at `how-to/09-write-operator-guide`.
- **Rider — `code/12-rust-extension` and `code/13-desktop-app`.** `## Closeout` → `## Close-out`,
  and both gain a `## Definition of Done`. Their existing content — build artefacts excluded from
  the commit, `code/src/rust/CONTEXT.md` updated, handed to PM `22` — is hygiene, so it stays under
  the Close-out rather than being promoted into the assertion.
- **A note settled by lookup rather than decision.** `12-seo-checks` was queried as possibly
  instructing SEO **code**; it does not, and needs no change. `STEPS.md:13` states _"This workflow
  plans; it does not verify"_, `:47` stops the workflow with `SEO: N/A` where a story ships no
  public URL, `CONTEXT.md` carries a whole _"This workflow plans — it does not verify"_ section
  recording that it _"used to be wrong here"_, and verification is routed to PM `22` three times.

> **Four findings surfaced that no node charts, recorded so a later pass does not re-chart them
> and so this map does not silently absorb them.** `dependency-drift.sh` is invoked by **no** CI
> workflow and **no** commit hook (`grep -rn 'dependency-drift' .github lefthook.yml` exits `1`) —
> that is gate wiring, so it routes to `MAP-GATE-PARITY.md`, not here.
> `project-management/workflows/17-story-plans/CONTEXT.md` opens `# Workflow 16` and
> `18-consolidate-design-work/CONTEXT.md` opens `# Workflow 17` — both H1 titles off by one from
> their folder numbers. `project-management/workflows/14-logging-checks/STEPS.md` has **no
> `## Steps` H2 at all**, leaving seven `### Step N` headings with no parent — the only file in
> the population shaped that way, and the reason its last H2 reads `## Prerequisites`. And the
> `02-story-creation/CHECKLIST.md:49` corruption **is still live in the tree**: Batch A settled
> what it should say, and settling is not building.

**Batch G1 in full, because Batch G's charted _"settled shape"_ did not survive measurement and
the batch had to split.** Ten agents re-measured the logging surface at `7a82095`, each axis
re-derived by an independent verifier. They returned **27 open questions, and the verifiers raised
30 more** — against a node the map described as having a settled shape. **G split into G1 (the
pipeline, settled below) and G2 (N-021, the retrieval procedure, and the doctrine's home).**

- **Three of the node's charted premises were false.** _"Five Compose files"_ is **four** — the
  fifth was the phantom `docker-compose.override.yml` that `c024338` had already deleted, so
  N-020 was charted against a count its own map records as fixed. _"Promised by two shipped
  docs"_ is **twelve**, and one of them **already decides the shape**:
  `code/docs/logging/DJANGO-LOGGING.md:133`, _"Structured JSON to stdout only"_ — a file the
  node's detail never mentioned. And the mount claim is **stronger** than charted: the string
  `logs` appears in **no Compose file at all**, not as a mount, a driver, or a comment.
- **N-020 · settled: write the formatter, do not depend on one.** A ~30-line
  `logging.Formatter` subclass doing `json.dumps(payload, default=str)` over `record.__dict__`
  minus `RESERVED_ATTRS`, in **`apps/core/observability.py`** — the path
  `DJANGO-LOGGING.md:34` already cites, so the module lands where the guide already points.
  **`apps/core/CONTEXT.md:56-62` licensed this directly**: the dozen documented-but-absent
  `apps.core` modules are missing deliberately, because _"a module lands here when the decision
  that governs it lands, not in anticipation"_ — and this decision has now landed.
- **The library question was asked, researched, and answered against the recommendation.**
  **structlog is the better tool and it is not close** — 4,930 stars against 267, ~115M
  downloads a month, `contextvars` binding, `dict_tracebacks`, `capture_logs`. It still lost, and
  so did `python-json-logger`, on `code/docs/coding-principles/STYLE-AND-PROCESS.md:121`:
  _"Don't add a dependency for something you can write correctly in under 50 lines … 1. Can this
  be implemented simply without it? If yes, write it."_ **The first recommendation this sitting
  made was for `python-json-logger` and it was wrong** — made without reading that gate, and
  overturned by the adversarial pass that read it. `python-json-logger`'s claimed decisive
  advantage was also **false on measurement**: `rename_fields` does not satisfy the LogQL
  contract _"by construction"_, because `RESERVED_ATTRS` excludes `levelname` and `name` from the
  automatic merge, so `level` needs **both** a `fmt` naming it **and** `rename_fields` — and
  `rename_fields` is **silently ignored** when the formatter is declared with `"class"` instead
  of `"()"`.
- **A mandatory shipmate the node never charted: the `request_id` filter.**
  `code/docs/security/MONITORING-AND-INCIDENT.md:41-42` requires a correlation ID in **every log
  entry**; `apps/core/middleware.py` ships `RequestIDMiddleware` and `current_request_id()` over a
  `ContextVar` whose own comment at `:19` names the consumer — _"a **logging filter**, a template
  context processor, the error tracker"_; `audits/negative-space.sh:149,407-414` enforces the
  middleware. **No `logging.Filter` exists anywhere in `code/src/django/`.** The middleware was
  built expecting a filter nobody wrote, so the repository fails its own security guide today.
  The filter ships with N-020, and it is the reason writing the formatter beats importing one:
  the whole answer lands in one module instead of a dependency with a hand-written filter beside it.
- **Five further findings the map did not have.** There is **no `import logging` or `getLogger`
  anywhere** in `code/src/django/`, so the pipeline currently carries Django's own framework
  records and nothing else. The `base.py`, `staging.py` and `production.py` `LOGGING` dicts are
  **byte-identical** — `diff` empty on all three pairs — which `settings/CLAUDE.md:39-41` forbids
  outright: _"An override that happens to match the base value is a future divergence nobody will
  notice."_ **No JSON logging dependency is installed** in `pyproject.toml` or across the 119
  packages in `uv.lock`. The guide's own hand-rolled template at `DJANGO-LOGGING.md:141-147`
  **emits invalid JSON** on any message containing a quote, backslash or newline, which a
  `| __error__=""` filter then silently drops. And **three container labels exist of which none
  is what Compose produces** — `STEPS.md` queries `-backend`, `OBSERVABILITY.md` queries `-web`,
  and `container_name:` is set in **no** Compose file, so the real container is
  `<%PROJECT_SLUG%>-prod-django-1`. **A correct JSON stream under the wrong label still returns
  nothing**, so the formatter alone was never sufficient.
- **The rest of the settled shape.** Query by the Compose **service** label, written into
  `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` as what the collector must relabel —
  the only option that survives more than one replica, at the cost of making that file
  load-bearing where it has no log row today. Bind-mount `../logs:/workspace/code/src/logs` on the
  dev `django` service, which makes five documented host-path commands true and preserves
  `dev.py:68`'s deliberate file-only routing of `django.db.backends` to keep SQL parameters off
  the console. `test.py` stays console-only and **two documents lose their test `✅`**
  (`LOGGING.md:38`, `code/src/logs/CONTEXT.md:3`) — the settings are the decision, the docs were
  wrong. **Each environment module carries its own complete config and `base.py` carries none**;
  the loss of a shared floor is an **accepted property** (Sam, 27/08/2026) because dev, test,
  staging and production is a closed set. Scope stops at settings, Compose and the one module:
  the named `django.request` and `api` loggers are **not** declared, because nothing writes to
  them, and a generated project adds its own instrumentation once it has features to log.
- **Two field contracts exist, and they are two streams rather than one drifted rule.**
  `MONITORING-AND-INCIDENT.md:41` specifies `timestamp`, `event_type`, `actor`, `resource`,
  `action`, `outcome`, `ip_address`, `request_id`; `OBSERVABILITY.md:137-152` keys its LogQL on
  `level`, `logger`, `duration_ms`. `MONITORING-AND-INCIDENT.md:44` — _"Store security logs
  separately from application logs where possible"_ — is what settles it: the first governs
  security and audit events, the second application logs, and **`request_id` is the one field
  that crosses both**. N-020 implements the **application** stream only and states the split, so
  the relationship is written down rather than left as two lists in two homes.
- **Redaction is deferred with a destination, not a shrug.** `DJANGO-LOGGING.md:34-35` credits
  `apps.core.observability` with scrub hooks that _"redact secret-bearing fields"_, and **no
  document anywhere lists the keys or patterns** — only the class. Shipping a thin scrub would be
  a redaction guarantee that is not one, which is this map's class **B**. So `observability.py`
  ships the formatter and the filter only, N-020 **claims no redaction anywhere**, and
  `DJANGO-LOGGING.md:34-35`'s existing claim is marked a forward reference in the same change.

> **`syntek-modules` was considered as the home for this and declined, with evidence.** The
> proposal was to hold the logging setup there and let a project choose its own on copy.
> **It cannot work for N-020, and the tree shows why**: `syntek-modules` is itself **generated
> from** `syntek-base` (`.copier-answers.yml` → `_src_path: gh:Syntek-Dev/syntek-base`,
> `_commit: v7.4.1`) and has **already inherited this exact defect** — its own `staging.py:33`
> and `production.py:39` carry the same byte-identical plain-text block. A fix living only there
> cannot fix that. Three further reasons: `syntek-base`'s own skeleton must pass its own gates,
> so a template that emits plain text and points at a package still emits plain text; a package
> is a dependency, and `STYLE-AND-PROCESS.md:121` does not stop applying because the dependency is
> first-party; and `syntek-modules` has **no packages yet** — `DESIGN-NOTES.md` still reads
> _"Status: placeholder. No code yet"_ — so N-020 would block on standing up publishing, versioning
> and licence tiers for 45 lines. **The choice the proposal wanted already has a seam**:
> `copier.yml:431` `LOG_AGGREGATOR` and `:438` `OBSERVABILITY_STACK` are generation-time questions
> already, answered `Loki` and `Prometheus + Grafana` in `syntek-modules` itself. **What does
> belong there is the half N-020 defers** — a `syntek-observability` package holding the curated
> scrub key list, OTLP tracing wiring and metrics. **Trigger:** a second Syntek product needing the
> same scrub list, or tracing being un-deferred, whichever comes first. Nothing was written to
> `syntek-modules`; this is a record of a decision, not a change to that repository.

### Batch G2, first sitting — N-022 settled 27/08/2026

**Charted on three premises, and measurement at HEAD falsified all three.** Ten agents re-read the
surface; five adversarial verifiers returned **41 refutations** of their own legs, and the node it
left is not the node that was charted.

- **_"The doctrine is stated in no file"_ — false for half of it.**
  `.claude/skills/incident/SKILL.md:35-37` states the **mutation** half verbatim: _"Never change a
  live environment ... Propose it, name the command, and wait. `<%DEVELOPER_NAME%>` executes"_,
  restated at `:148` as a table row. `how-to/docs/FEATURE-DEPLOY.md:15` states it again for
  rollout and carries an `## Ownership summary` at `:219`. The map read `09/CLAUDE.md` and
  `08-debugging/CLAUDE.md` and correctly found nothing in either; it never read `.claude/skills/`.
- **_"Nearest statement is `HEALTH-PROBES.md:23`"_ — false.** That line is a prerequisite bullet
  with no actor and no procedure. It ranks roughly fifth.
- **_"The retrieval procedure has no owner"_ — false as stated, and the correction moves the
  node.** The **querying** procedure exists and is owned: `09/STEPS.md:77`, `:94` and `:157` are
  three staging/prod-only steps carrying the Glitchtip triage, four LogQL queries and the Grafana
  panel order. **Server access already has a named owner in three files** — the
  `<%DEPLOY_REPO%>` runbooks, at `incident/SKILL.md:55`, `INCIDENT-PRACTICE.md:37` and
  `CELERY-FIRST-RUN.md:177`. What has no owner is only the **reaching step**, and the defect is
  that the two workflows needing it never cite the owner that exists.

> **The finding that inverts the node.** `09/STEPS.md:96` carries
> `> **↳ New dispatch:** general-purpose · **Skill:** bugfix · **Model:** opus` on **Step 4 —
> Query Loki in Grafana (staging / prod only)**. The repository does not merely fail to state
> _the human opens the connection_ — it **explicitly dispatches a Claude subagent to query
> production observability**. The converse doctrine is written down; the doctrine N-021 would
> enforce is not. A guard shipped against `09` as it stands would refuse an instruction the same
> repository gives.

**Settled, in four answers (Q15–Q18, 27/08/2026).**

| #   | Decision                       | Answer                                                                                                                                                                                       |
| --- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q15 | Connection, or mutation?       | **The connection.** Claude never opens one to an environment running this application. Claude **writes the command**; `<%DEVELOPER_NAME%>` executes it and pastes the output back            |
| Q16 | What does the rule bind?       | **Environments running this application that we operate** — staging and production. GitHub, and Forgejo once it exists, stay allowed for **safe information only**: never secrets, never PII |
| Q17 | Where does the rule live?      | **`.claude/CLAUDE.md` Section 6**, one non-negotiable bullet beside its sibling `:201` _"no manual DDL against a deployed database"_. Every other site **cites** it                          |
| Q18 | Who owns the access procedure? | **The `<%DEPLOY_REPO%>` runbooks — the owner that already exists.** `09` and `08-debugging/` each gain a routing line to it; no new file, no second home                                     |

**Q15 chose enforceability over a stated capability, and the cost is recorded.**
`incident/SKILL.md:86` currently **grants** Claude _"read-only inspection of anything live"_, and
the answer revokes it; `:86` and `09/STEPS.md:96` are rewritten in the same change. The ground is
this map's own standing preference — _an enforcement rule that composition walks around is false
green, not a gate_ — and only a line at the connection survives `bash -c` and `docker exec`. The
capability revoked is one the repository **cannot exercise today anyway**: no procedure for
reaching Grafana exists, and `code/src/scripts/deployment/` holds no script.

**Q16 was forced by a measurement, not chosen freely.** _"Claude does not connect to servers"_ is
**already false** at HEAD: **16 of the 84 `allow` entries open outbound connections**, and one of
them — `Bash(gh run view:*)` at `settings.json:80` — **is remote log retrieval, pre-approved**.
The wording therefore has to distinguish **CI logs from someone else's infrastructure** from
**application logs from ours**, which is the line Q16 draws.

**Two riders carried by `<%DEVELOPER_NAME%>`, and they widen the remedy beyond a citation.**
`incident/SKILL.md` and `09/STEPS.md` do not merely lose their dispatch markers — they must
**supply the commands** the human runs to obtain the logs, and what comes back must be
**redacted of secrets and PII**. This makes the redaction question live in **S-08**, where S-07
had explicitly deferred it; the two slices now both carry a personal-data path and for different
reasons.

**Measured, so the next sitting does not re-measure it.** No candidate home needs a dated
docs-length allowance: cloc **212** `.claude/CLAUDE.md`, **173** `INCIDENT-PRACTICE.md`, **170**
`HEALTH-PROBES.md`, **151** `09/STEPS.md`, against a 300 limit warning at 270. A leg reported
`.claude/CLAUDE.md` at 286 against the ratchet and made the invented cost load-bearing; the gate
counts **cloc code lines**, not `wc -l`, and its own adversarial pass overturned it.

**One correction the map owes itself.** Batch F's precedent was cited here as a shipped artefact.
It is not: `how-to/docs/WORKFLOW-SHAPE.md` and `audits/workflow-shape.sh` **do not exist on
disk** — F is a settled decision, not built work, exactly as this map records of every node it has
closed. The precedent is reasoning that can be read, not an implementation that can be inspected.

### Batch G2, second sitting — N-021 settled 27/08/2026

**N-022's answers made this node askable, and the measurement behind it caught its own legs
re-opening four settled nodes.** Ten agents measured the guard surface; the five adversarial
verifiers returned **67 refutations**, of which the sharpest were procedural: legs re-derived
**N-001, N-012, N-013 and N-020** as open questions and recommended answers **contradicting the
settled ones**. All four were discarded. **The lesson generalises and is new to this map: a
measurement agent given a settled map will re-open it unless told which rows are closed.**

**Settled, in five answers (Q19–Q23, 27/08/2026).**

| #   | Decision                          | Answer                                                                                                                                                                                                                                                                                                            |
| --- | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q19 | The split between the two layers  | **`deny` carries the bare verbs** — `ssh`, `scp`, `rsync`, `kubectl`, `aws`, `wg`. **The hook carries what `deny` cannot see**: the wrapped forms (`bash -c`, `docker exec`, `npx`, `devbox run`, `direnv exec`, `mise exec`) and the argument-shaped cases `docker -H`, `psql -h`, `docker compose -f *staging*` |
| Q20 | `ssh` against the forge           | **Denied bare.** `.claude/skills/global-workflow/GIT-AND-PR.md:29-31` — the one-time GitHub key setup ending `ssh -T git@github.com` — is **marked explicitly human-only** in the same change                                                                                                                     |
| Q21 | Does the guard ship?              | **Yes, verbatim, into every generated project**, and the Section 6 bullet says it binds both repositories. Rider: `.claude/settings.local.json` gains a `.gitignore` line in the same change                                                                                                                      |
| Q22 | May a log excerpt enter the repo? | **No — strict everywhere.** The human pastes into the **conversation**; Claude reads it and writes **findings**, never the log. `23-INCIDENTS`'s rule is generalised rather than relaxed                                                                                                                          |
| Q23 | Naming Forgejo                    | **The bullet names the interface** — _the project's own git forge_. The products go in a `how-to/src/PLATFORM-PROVIDERS.md` row                                                                                                                                                                                   |

**Q19's split is the settled Q13 shape given its boundary.** Q13 chose _both layers_; what was
never decided is which layer carries what. The division follows the mechanics G1 corrected against
the official documentation: `deny` is **absolute across all scopes**, survives a pipe and survives a
leading variable assignment — so the bare verbs belong there, where nothing can re-approve them —
while `bash -c` and the **unsupported wrappers** are invisible to a prefix rule and belong to the
hook, which receives the full command string at `tool_input.command`. **Deny-only was rejected as
false green** under this map's standing preference; hook-only was rejected for surrendering the
absolute floor on the one verb that matters most.

**Q21 turned on a precedent that does not transfer, and the difference is on record.**
`.claude/hooks/template-docs-readonly.sh:16-18` records that _"a `permissions.deny` entry in the
project settings would apply in syntek-base too"_ — which was **why that guard is a hook**. It
does not transfer: that guard had to **stand down inside `syntek-base`**, because the template must
retain the write it denies a project. This guard has no such asymmetry — `syntek-base` needs the
block exactly as much as a generated project does — so the property that forced a hook there
argues _for_ a deny here. **Measured, not assumed:** `.claude/settings.json` is **absent from
`copier.yml`'s `_exclude`** across its whole span `:35-298`, whose only `.claude` entries are
`/.claude/MEMORY.md` at `:75` and three conditional skill folders.

> **A shipped claim is false today, and Q21's rider is what makes it true.**
> `.claude/CONTEXT.md:13` describes `settings.local.json` as _"local permission overrides
> (gitignored)"_. It is ignored **only** by this machine's global git config —
> `git check-ignore -v` names `/home/sam-dev/.config/git/ignore:1`, and the repository's own
> `.gitignore` carries **no rule for it at all**. Every generated project on another machine
> would track it. One line fixes it, and Q21's override story depends on it existing.

**Q22 resolved a contradiction the rider landed on top of, rather than adding to it.** Three
shipped rules disagreed: `23-INCIDENTS/CLAUDE.md:33-37` bans excerpts outright — _"No log
excerpts. No stack traces … Never relax this"_ — `21-BUGS/` states **no policy at all**, and
`09/CLAUDE.md:42-43` bans secrets and PII in commits and bug reports with **nothing enforcing it**.
Strict-everywhere is the only answer needing **no pattern list, no detector and no new gate**: a
regex PII scanner over prose bug records is the class **B** shape this map has already rejected
twice, and N-020 deliberately shipped **no scrub**, so any other answer would depend on a
mechanism that does not exist. **The conversation is not the repository** — that distinction is
what lets the rider be satisfied without a redaction engine.

**What this batch did not settle, and why.** Two defects surfaced that share neither this map's
cause nor its remedy, and both are routed out rather than charted: the actor-ambiguity in
`project-management/docs/git/MIGRATION-GATES.md:75-111`, which takes a **citation** to the new
Section 6 bullet inside S-08 rather than a rewrite; and a reported contradiction between
`code/docs/architecture/PROVIDER-NEUTRALITY.md` and `how-to/src/PLATFORM-PROVIDERS.md` over
`git_writeback.py`'s seam. **The second was measured by an agent and not re-verified here**, and
is recorded in _Out of scope_ as a candidate for its own chart on that basis — a finding this
map declines to launder into a node it has not checked.

### Batch C — N-004 and N-008 settled 27/08/2026

**The batch opened to widen a guard and found the guard was false green.** Ten agents measured the
script, its four conditional rows and the coverage population; five verifiers returned **57
refutations**, including one leg refuting another's central conclusion. **Three findings changed
the batch, and all three were re-derived by hand before being relied on.**

- **One of `doctrine-drift.sh`'s three claims can never fire.** `api-success-data-wrap` is anchored
  `^[[:space:]]*"data"`, but `:203` greps a corpus whose every line is `path:line:text` (built at
  `:179`), so the `^` always meets a file path. **Proven by positive control, not inferred**: the
  corpus form returns **0**, the bare line returns **1**. The script nonetheless prints
  `✓ All 3 claim(s) have exactly one home.` at `:340`. **A third of the table has guarded nothing
  since it was written**, and `--help:128` promises _"Run every clause over fixtures"_ while
  `EXPECTED` at `:244` names **two of three** — which is exactly how it survived.
- **Batch F's carve-out rests on a misreading of the script, and this map should not inherit it.**
  F sent workflow shape to a script of its own on the ground that _"`doctrine-drift.sh`'s stated
  rule is the JSON envelope"_. **It is not.** `doctrine-drift.sh:131` states its rule as
  `code/docs/DOCUMENTATION-PAIRING.md — route, don't restate`. **All four of N-004's conditional
  rows sit inside the stated rule**, so `audits/CLAUDE.md`'s derived-from-a-stated-rule test is
  satisfied by widening rather than by splitting. **F's outcome is not reopened** — a separate
  script is still a defensible home — but its stated reason was wrong, and the reason is what a
  later node would have cited.
- **Row C's gate exists, already decided the question the fog entry called undecidable, and is
  structurally blind to the live drift.** `code/src/scripts/development/sync-trees.sh` reconciles
  every `CONTEXT.md` tree against disk, is wired pre-commit at `lefthook.yml:75-77`, and decides
  the elision question **explicitly** at `:29-31` — _"ONLY THE TOP LEVEL of each block is
  reconciled"_ — with `ROW` at `:145` anchored on `^[├└]──` and the space after it. **N-016's population is depth 2 to 4.**
  `code/docs/discoverability/` and `code/src/scripts/dependencies/` are on disk and appear
  **nowhere** in `code/CONTEXT.md`, and `sync-trees.sh --check` prints
  `✓ Every CONTEXT.md tree matches its directory`. One leg reported the row discharged on this
  evidence; **another leg's verifier caught it**, and the hand check confirmed the verifier.

**Settled, in seven answers (Q24–Q30, 27/08/2026).**

| #   | Decision                        | Answer                                                                                                                                                                                         |
| --- | ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q24 | Fixing the gate before widening | **Fix the anchor, extend the fixture to prove all three clauses, and state the rule** in `audits/CLAUDE.md`: **every claim must be proven to fire by the self-test**. Lands first              |
| Q25 | Widen, or one script per row    | **Widen `doctrine-drift.sh`** — a per-claim `scope: fenced\|prose` field, a citation exemption, and a per-claim scan root. One table, four new rows                                            |
| Q26 | Row A — the 750/800 limit       | **The `## Guardrails` bullet is a sanctioned second home, and the gate asserts agreement** — it may carry the number; it fails only where the number **disagrees** with the owner              |
| Q27 | Row C — the `CONTEXT.md` tree   | **Keep top-level-only and add a declared-elision marker** a file carries to opt into full-depth reconciliation                                                                                 |
| Q28 | N-008 — the revisit trigger     | **A dated allowance in `code/docs/testing/COVERAGE.md`** on `DOCUMENTATION-LENGTH.md`'s 270-ratchet pattern, read by extending `docs-length.sh`'s expiry check to any file carrying the marker |
| Q29 | Row B — the `_tasks` doctrine   | **A `banned`-spelling claim** on the false phrasings, scoped to `how-to/src/**` — **the guard that keeps `MAP-GATE-PARITY`'s `N-026` fix fixed**, landing only after it                        |
| Q30 | Row D — the step-level marker   | **A schema in `.claude/CLAUDE.md` Section 2.5 plus a gate over both shapes**, asserting the value is `fable` or `opus`                                                                         |

**Q25's answer was forced by the measurement, against this sitting's own first instinct.** Turning
prose on today produces **3 findings and all 3 are false** — two are the retirement narration the
fenced-only design note exists to protect, and the third is **the owner file's own denial of the
banned shape** (`code/docs/api-design/AUTH-AND-ERRORS.md:83`, _"There is no `{"data": ...}`
envelope."_). Prose matching is therefore unusable **without** the citation exemption, and usable
with it — which is why the two ship as one change rather than as two decisions. The capability is
not new: **five audits already match prose in Markdown**, so widening buys discrimination, not a
new mechanism.

**Q26 turned on what a layer's operating rules are for.** **57** prose restatements of the
750/800 limit across **44** files; **16** are one-line `## Guardrails` bullets in
`code/src/**/CLAUDE.md`, **none drifted**. A `CLAUDE.md` is read _instead of_ the owner, not
alongside it, so a bare citation there costs the reader the number. **Asserting agreement keeps
the value single-sourced where it matters** — the day `PRACTICAL-RULES.md` moves, every bullet
that disagrees fails — which is the property N-008 lacks and Q28 supplies by another route.

**Q28 was forced by a correction to this batch's own grouping.** C was grouped on _"the guard's
design decides whether N-008 needs a trigger of its own or gets one for free"_. **It cannot get
one for free**: all three of the script's clauses are presence/absence tests over a text corpus,
with **no time dimension**, so no claim row can express a revisit condition. The batch still holds
on **shared evidence** — one measurement settled both — but the stated dependence was wrong.

**Q29 stopped this map re-charting another map's node.** The `_tasks` contradiction is **already
charted as `N-026` on `MAP-GATE-PARITY.md:267`**, naming the same five sites and recording that
`06-GENERATION.md:140` contradicts them correctly **in the same file**. N-026 is the **fix**; this
row is the **guard**, and the two are complementary — but the guard **ships red until the fix
lands**, which is a sequencing constraint the slice carries. Nothing was written to
`MAP-GATE-PARITY.md`.

**Four of this map's own literals corrected.**

| Map claim                                                                                        | Measured at HEAD                                                                                                                                                                                                                              |
| ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| N-008: _"twelve files still say only 75 / 90"_                                                   | **36** files carry 75 and 90 with no 80 tier, of 45 stating both. At least two are correct as written — the mobile surface holds a flat 75 by decision (`COVERAGE.md:64`), and `DOCUMENTATION-PAIRING.md:135` is a deliberate counter-example |
| N-004: `SCAN_DIRS` _"is the three whole workflows trees"_                                        | **Five** entries, of which three are workflow trees — and the same node says _"over 5 trees"_ nineteen lines earlier, so it contradicts itself                                                                                                |
| N-004: the script _"was recorded refusing a job"_, quoted _"0 of 7 homes reachable on two axes"_ | **That string exists nowhere in the repository** but on the map line quoting it. The script's actual recorded refusal is `doctrine-drift.sh:52-59`, dated 21/08/2026                                                                          |
| N-004: _"no existing gate can take"_ Row C                                                       | **`sync-trees.sh` takes it** and has since 11/08/2026 — but only at depth 1, which is why the row survives in the sharper form Q27 answers rather than being discharged                                                                       |

---

### Batch D — N-009 and N-010 settled 28/08/2026

**The last charted batch, and the one whose own recommendation it had to refute.** Both nodes were
carried into this sitting as _settled in conversation, written nowhere_. Re-measuring them at
`7a82095` confirmed every figure N-009 rested on and **falsified the glob it had chosen**, so the
node is settled on the measurement rather than on the inheritance.

**N-009 — `is_exempt()` narrows by hand, and not to the glob the node proposed.**

- **Q31 = hand-narrow the arms; do not delegate to `is_template_only()`.** The decisive fact is
  structural, not stylistic: `copier.yml:36` is `- /copier.yml`, so **`copier.yml` does not ship**,
  and `build_template_only()` fails soft on its absence — `raw="$(awk … 2>/dev/null || true)"`
  followed by `[ -n "$raw" ] || return 0`. In a generated project the derived set is therefore
  **empty**, and any exemption delegated to it **evaporates silently rather than failing**. A
  predicate that is correct-by-construction here and vacuous downstream is worse than a hand-written
  glob, because nothing reports its absence.
- **Q32 = narrow every arm by the three negations `copier.yml` already states, not the folder globs
  one at a time.** `copier.yml:116-133` re-includes `!**/CONTEXT.md`, `!**/CLAUDE.md` and
  `!**/*TEMPLATE*` out of the very trees these arms exempt, which is why **nine files inside the
  exemptions ship** — the pairs under `research/`, `learning/` and `handoffs/`, plus
  `01-FEATURE-MAPS/`'s pair and `MAP-000-TEMPLATE.md`. One fall-through arm ahead of the others
  restores all nine at once and **mirrors the copier contract rather than paraphrasing it**, so the
  two cannot drift apart the way a hand-written folder list would.
- **The node's own proposed glob was measured and rejected.** It read _narrow `.copier/*` to
  `.copier/migrations/*`_. `.copier/` is `rm -rf`'d wholesale by `copier.yml:836` after `:865-874`
  moves its seeds into place, and `handoffs/**` is excluded at `:144` with only its pair negated
  back at `:145-146`. The arm's standing comment — _"none of these ship"_ — is therefore **true**;
  the arm was never wrong about the folders, only about the nine files copier lifts back out of
  them.
- **All three candidate narrowings were executed rather than argued. The measurement is the
  settlement.**

| Narrowing                                                            | Files read | Exempt | Findings | Verdict                                                                |
| -------------------------------------------------------------------- | ---------- | ------ | -------- | ---------------------------------------------------------------------- |
| Baseline at `7a82095`                                                | 968        | 80     | 0        | the state being changed                                                |
| **Chosen** — one arm for `*/CONTEXT.md`, `*/CLAUDE.md`, `*TEMPLATE*` | **982**    | **67** | **1**    | all nine shipped files enter; the one finding is **genuine**           |
| Rejected — narrow `.copier/*` to `.copier/migrations/*`              | 981        | 68     | 37       | 30+ are handoffs correctly citing maps they are entitled to cite       |
| Rejected — negate the `handoffs/` pair alone                         | 971        | 78     | 0        | clean, and **incomplete**: seven of the nine shipped files stay exempt |

**The one finding is the node's whole justification, and it is real.** `research/CLAUDE.md:26`
cites `LICENSE` — syntek-base's **own** licence, which the root `CONTEXT.md` records as _"not
rendered into a project"_. A shipped file pointing a generated project at a file it will never
have is exactly the defect this gate exists to catch, and it has been invisible because the arm
above it exempted the file wholesale.

**Why the rejected glob fails is the instructive half.** A handoff's job is to cite `MAP-*.md`,
`US###` and a sibling handoff by path — the artefact working as designed. Admitting the whole
`handoffs/` tree to a gate that forbids per-project instance citations yields 37 findings of which
**not one is a defect**: the false-positive mirror of the false-green defect Batch C found in
`doctrine-drift.sh`. **The same sitting that widened a guard correctly also proves a guard can be
widened wrongly, and the difference is measured, not reasoned.**

**N-010 — the instruction is obeyed by moving it, and the rest is claimed by a new map.**

- **Q33 was redirected, not answered from its options — Sam, 27/08/2026.** **Nothing under
  `project-management/src/NN-*/` is deleted.** Those files carry the perspective behind design
  decisions, features, mappings, database shape and branding, and deleting a drifted index destroys
  the record rather than repairing it. Instead **an index file is added to each register where one
  is warranted — explicitly not to all of them.** The `## Map index` table at
  `01-FEATURE-MAPS/CONTEXT.md:43-51` therefore **becomes its own file** rather than being removed.
- **Q34 is superseded and must not be carried forward.** It asked how wide the deletion goes; there
  is no deletion.
- **The conflict N-010 charts is real and is resolved by the move, not by an exception.** A
  `MAP-<FEATURE>` row in `CONTEXT.md` is a per-project instance citation in a **shipped** file,
  which is precisely what `doc-references.sh` exists to stop. Moving the table into a file that does
  **not** ship lets the instruction and the citation rule both be obeyed.
- **A correction this sitting makes about the map's own header.** The header records nine maps
  having _"declined"_ the row and the index reading `_None charted yet_`. Re-measured: **nine
  `MAP-*.md` files** are present beside `MAP-000-TEMPLATE.md` and the index does read
  `_None charted yet_` — but this is a **recorded, reasoned refusal**, not drift, and the map says
  so in its own header and at `Gate to stories`. It is evidence that **a prose duty contradicted by
  another rule is unenforceable**, which is a different and stronger finding than neglect.

**Q35 to Q38 — answered by Sam 28/08/2026, and they graduate to their own chart.**

| Q   | Question                         | Answer                                                                                                                                                          |
| --- | -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q35 | What is a register index called? | **`<THING>-INDEX.md`** for indexes of **files**; the six GDPR registers at `copier.yml:170-176` stay bare nouns, because they register **facts**, not instances |
| Q36 | Which registers get one?         | **The strong seven** — `01-FEATURE-MAPS`, `02-STORIES`, `03-SPRINTS`, `15-DECISIONS`, `17-STORY-PLANS`, `20-FINDINGS`, `21-BUGS`                                |
| Q37 | What keeps them honest?          | **Both** — a skill duty on `incident/SKILL.md:132`'s precedent **and** a gate; the gate is the load-bearing half                                                |
| Q38 | Does this belong on this map?    | **Its own chart.** N-010 settles the map-folder case and **claims** the remainder                                                                               |

**The 24-register survey that produced the strong seven, recorded here because it existed only in a
conversation that has ended.** Verdicts on whether a register warrants an index file:

- **Strong (7)** — `01-FEATURE-MAPS`, `02-STORIES`, `03-SPRINTS`, `15-DECISIONS`, `17-STORY-PLANS`,
  `20-FINDINGS`, `21-BUGS`
- **Moderate (6)** — `04-DATABASE`, `05-USER-FLOW`, `09-GDPR`, `10-SECURITY`, `18-TESTS`,
  `22-REFACTORING`
- **Weak (5)** — `08-WIREFRAMES`, `12-SEO`, `13-API-DESIGN`, `14-LOGGING`, `19-REVIEWS`
- **No (5)** — `00-ASSETS`, `06-BRAND-GUIDE`, `07-COMPONENTS`, `11-QA`, `16-SPRINT-PLANS`
- `23-INCIDENTS` already has one, and it is the **only `-INDEX.md` in the repository** — one
  precedent, not a convention, which is why Q35 had to be asked rather than assumed.

**Three of this map's own literals corrected.**

| Map claim                                                | Measured at `7a82095`                                                                                                                       |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| N-009: `is_exempt()` has _"four exemption arms"_         | **Seven.** The _"none of these ship"_ comment grounds three of them; the count has been stale since the arm above was narrowed at `5d7d264` |
| N-009: `is_template_only()` _"answers 40 paths"_         | **36.** It was 40 at `c024338`; four paths have since left copier's unconditional excludes                                                  |
| N-010: the index-row conflict is unresolvable as written | **Resolvable by relocation** — moving the table out of a shipped file satisfies both rules                                                  |

**Baseline re-measured at HEAD and quoted rather than inherited:** 968 files read, 80 exempt by
rule, 28,997 backticked tokens of which 5,519 tested as repo paths, 36 paths matched against
copier's unconditional excludes, exit `0`.

**Two nodes opened as this batch closed — N-023 and N-024.** Both arrived from Sam in the same
sitting, both are class **D**, and both are this map's thesis in a tree it had not yet reached:
`project-management/src/`. They are **charted, not settled** — Batch H.

---

### Batch H — N-023 and N-024 settled 28/08/2026

**The batch that was not charted at charting.** Both nodes arrived from Sam mid-sitting as Batch D
was being written, and both turned out to be this map's thesis in `project-management/src/` — the
one tree eight sittings had never entered. Neither is a homeless rule. **N-023's is stated in the
wrong file; N-024's is stated in the right file at the wrong scope**, which is the more dangerous
shape, because an owner that looks discharged stops anyone looking.

**N-023 — RESOLVE writes to the map and nothing else.**

- **Q39 = map only, and the reason is that the other steps already exist.** Sam's ruling:
  the graduation destinations are owned by later workflows, so RESOLVE writing them is a second,
  earlier copy of a step that already has an owner. **Verified rather than accepted**:
  `22-implementation-documentation/STEPS.md:126-131` owns the `DEFERRED.md` row, the map's
  Resolved-decisions link-back and the `GAPS.md` close; `15-decisions/` owns the ADR;
  `02-story-creation/` cuts the story from a Slices row. **Four of the graduation table's five
  destinations therefore have a downstream owner, and the fifth — a Slices row — is on the map
  already.**
- **This reverses a shipped rule, and the reversal is recorded rather than quietly applied.**
  `.claude/skills/wayfinder/SKILL.md:135` and `project-management/workflows/01-feature-map/STEPS.md:172-174`
  both read _"never leaving an answer only on the map"_. That sentence is **deleted**, and the
  graduation table at `SKILL.md:178-189` becomes a **pointer to who graduates each destination
  later**, not an instruction to do it here.
- **Q40 = the home stays where it is, and the skill cites it.** _"Documentation workflow — no
  code."_ is `01-feature-map/CLAUDE.md:63` and stays there; `SKILL.md` gains a citation, not a
  copy. Route-don't-restate — the shape this map has now settled five times (N-002, N-003, N-006,
  N-018, and here).
- **Q41 = a prose duty, a `CHECKLIST.md` line, and a conformance clause — because the obvious
  guard is impossible, and that was measured.** A `PreToolUse` hook on `Edit|Write` **cannot tell
  which skill is running**: the payload carries `session_id`
  (`.claude/hooks/context-threshold-handoff.sh:29`) and no active-skill field.
  `template-docs-readonly.sh` works because it keys on **path** — _nobody writes these, ever_ —
  whereas N-023's constraint is _this procedure may not write these_, which is a property of the
  session, not of the write. **The precedent does not transfer, and saying so is the finding.**
- **Q46 = the conformance clause lands in `doctrine-drift.sh` — and it is blocked on N-004's
  widening.** The claim being asserted is _one rule, one home_, which is that script's whole
  purpose. But **as built it is fenced-code-only** — measured at HEAD:
  `scope: 5 tree(s), fenced code only · 3 claim(s) · 3 fail clauses` — and the rule here is prose.
  Batch C settled the widening (a per-claim `scope: fenced|prose` field plus a citation exemption)
  and recorded that **prose matching is unusable without the exemption**. So this clause **cannot
  be written until N-004's widening ships**: a hard sequencing constraint the slice carries, not a
  preference. `audits/wayfinder-scope.sh` on the N-015 precedent remains the fallback if the
  widened script still cannot express it.

**N-024 — the owner widens, the folders keep only what is local to them.**

- **Q42 = widen `project-management/src/CLAUDE.md:26-29` in place.** Its statement — _"copy the
  target folder's per-story template — the stage folder for `04`–`08`, `PLANNING/` vs
  `IMPLEMENTATION/` for `09`–`13`"_ — enumerates ten registers and stops, leaving **eleven**
  (`01`, `02`, `03`, `15`, `16`, `17`, `19`–`23`) governed only by their own folder files. The rule
  is about `src/` and the owner is `src/`'s own file; moving it up to
  `project-management/CLAUDE.md` (which mentions templates **zero** times) would put it a layer
  away from everything it governs.
- **Q43 = the folder keeps its template's name; it stops restating the rule.** **48** `CLAUDE.md`
  files under `project-management/src/**` mention a template, with _"the copy source; do not delete
  or repurpose"_ recurring near-verbatim. The **filename** is local fact and nothing else carries
  it; the **rule** is not. Only the rule collapses to a citation — a narrower cut than Batch A's,
  and deliberately so, because collapsing both would delete information that has no other home.
- **Q44 = rename the `18-TESTS` pair; `00-ASSETS` is a named exception.**
  `US000-MANUAL-TESTING.md` and `US000-TEST-STATUS.md` are templates that decline the `*TEMPLATE*`
  marker, which `copier.yml:177` documents as deliberate — _"named for the story they are copied
  to, not for their role"_. **That naming is the single reason a guard cannot key on `*TEMPLATE*`**,
  so it is the thing to change. `00-ASSETS` holds logos and scripts, has no instances to template,
  and is a genuine exception the widened statement must name.
- **The rename is bounded, and it removes a registration surface rather than moving a name.** Six
  sites: `copier.yml:178-179` with its comment at `:177`, `18-TESTS/CLAUDE.md:25-26`,
  `18-TESTS/CONTEXT.md:14-15` and `:19`, and `.github/scripts/shipped-artefacts.sh:98-99`. **Those
  last two `NAMED_SHIPPED` entries exist only because the files do not match `*TEMPLATE*`** — after
  the rename the `case "$base" in *TEMPLATE*) continue` arm at `shipped-artefacts.sh:195` catches
  them and **both entries become deletable**.

**Q45 — where a guard over per-story artefacts is tested, and it answers a question on another
map too.**

- **Settled: fixtures plus `shipped-artefacts.sh`, not the real tree alone.** Measured at HEAD, the
  strong seven registers hold **zero instances** — six read `templates=1, other=0` and
  `23-INCIDENTS` holds only its own index. **A guard asserting anything about instances passes
  vacuously in this repository** and bites only downstream. A fixture proves it can go red
  (`code/src/scripts/audits/fixtures/` is the `doc-references.sh` precedent), and
  `.github/scripts/shipped-artefacts.sh` already builds a generated project, which is where the
  population is real.
- **This was asked inside Batch H and half of it belongs to `MAP-REGISTER-INDEXES.md`.** The
  question covers the **index** gate as much as the template guard, and the index gate is that
  map's **N-003**. The answer is recorded there as an input rather than re-decided — **one
  decision, cited twice, which is the discipline this map exists to enforce.**

**Why Batch C's lesson fired again here.** C was sent to widen a guard and found a third of it had
never guarded anything. H was sent to install two guards and found that **one of them cannot exist
in the obvious form** (no skill context in a hook payload) and **the other cannot be tested here at
all** (no instances). Both were established by execution — a payload field grepped for and absent,
a population counted and empty — not by argument.

---

## Slices

The buildable slices this feature cuts into. **This map's six batches are its slices** — the gate
below already names Batch E _"the intended first slice"_, so the identification is the map's own
and is recorded here rather than imposed. The `Story` column reads `—` until `02-story-creation`
allocates a number; wayfinder never reserves one, because a slice later merged or dropped would
burn it and `US###` gaps are permanent.

| Slice | Story | Title                                                                                                 | Nodes               | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Flags                        |
| ----- | ----- | ----------------------------------------------------------------------------------------------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| S-01  | —     | Batch E — the `09` script seam, its vendor names, the fix cut                                         | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | none                         |
| S-02  | —     | Batch A — five restatements that drifted from their owner                                             | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | none                         |
| S-03  | —     | Batch B — where a rule lives, and what is canonical                                                   | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | none                         |
| S-04  | —     | Batch F — the workflow shape, its terminal contract, and the `## Context` block                       | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | none                         |
| S-05  | —     | Batch C — the guard's dead claim, its widening, and the coverage-floor revisit trigger                | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | none                         |
| S-06  | US004 | Batch D — what a shipped file may cite                                                                | N-009 ✅ · N-010 ✅ | `is_exempt()` gains one fall-through arm for `*/CONTEXT.md`, `*/CLAUDE.md` and `*TEMPLATE*` mirroring `copier.yml:116-133`, so the nine shipped files copier lifts back out of the exempt trees are policed; `build_template_only()` reads the population `candidates()` reads, so a verdict stops being a property of the git index; Check 2 exempts copier-excluded citers and names the live `ADR-US###` and `QA-PLAN-US###` spellings; Check 1 gains a `project-management/src/*` arm plus a token-level naming guard; `how-to/src/PROJECT-PATHS.md` gains the two per-story artefact rows and `code/docs/FORWARD-VOICE.md` the duty behind them; every genuine finding repaired and every generic-noun false positive marked; both self-test modes used; the gate exits 0 and the baseline-diff regime retires. **N-010's relocation half is `MAP-REGISTER-INDEXES.md` S-01/S-02's, never this slice's.** | none                         |
| S-07  | —     | Batch G1 — the structured-logging pipeline and the `request_id` filter                                | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | **GDPR · Backend · Logging** |
| S-08  | —     | Batch G2 — the retrieval procedure, its doctrine, and the two-layer block on Claude reaching a server | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | **GDPR**                     |
| S-09  | —     | Batch H — what a wayfinder session may write, and the template every PM artefact is written from      | TBD                 | TBD                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | none                         |

**The `Nodes` and `Acceptance` columns were added 31/08/2026** with the `task` -> `build`
type change. Cells reading `TBD` are **not empty, they are unbackfilled** — this map's next
RESOLVE sitting fills them, and until it does the checklist item _every open node belongs to a
slice_ is unverified here.

**Seven slices read `N/A` and two do not, which is the whole reason S-07 and S-08 are separate slices.**
All thirteen gates in `../02-STORIES/US000-TEMPLATE.md` are code-shaped — `DB`, `User Flow`,
`Brand`, `Components`, `Wireframes`, `GDPR`, `Security`, `QA`, `SEO`, `API`, `Logging`, `Backend`,
`Frontend` — and S-01 to S-06 plus S-09 edit documentation, workflow prose and audit scope. **S-07 and S-08
do not, and they are flagged for different reasons.** S-07 changes Django settings, a Compose file
and ships a new Python module: `Backend` and `Logging` are live on their face, and **`GDPR` is
live because redaction is deliberately deferred** — the pipeline ships with no scrub, which is a
GDPR-relevant decision taken knowingly rather than an omission. S-08 writes no application code at
all, but it opens the path down which a **production log reaches a developer's machine**, so
`GDPR` alone is live. Stated explicitly because an empty `Flags` cell is otherwise
indistinguishable from a manifest nobody wrote, which is this map's own thesis applied to itself.

> **This is why Batch E split rather than grew (Q14, 27/08/2026).** Settling three nodes carried
> the work from four files to twelve across four layers, and would have converted a
> documentation slice into a GDPR-flagged one **without the manifest moving**. Three remedies,
> three review surfaces: a doc gate, a code change carrying a deploy-repo contract and a
> personal-data path, and a permission policy touching nothing but `.claude/`.

**A batch is a sitting; a slice is what a story is cut from.** They coincide here because each
batch's justification is _shared evidence, one reading_ — the same property that makes it one
story. That is a property of this map, not a general rule.

---

## Frontier

| Node | Decision                                       | Type | Class | Blocked by | Batch | Blocking a story? |
| ---- | ---------------------------------------------- | ---- | ----- | ---------- | ----- | ----------------- |
| —    | **Empty — every node on this map is settled.** | —    | —     | —          | —     | —                 |

**Types:** `research` (looked up, no human) · `tracer` (spike) · `grilling` (one `/grill-with-docs`
surface) · `build` (the work a slice's story carries — named here, never done here). **Manual
unblocking work is not a node** — it is a `GAPS.md` blocker. Renamed from `task` on 31/08/2026.

**Nothing is marked blocking-a-story, and that is deliberate.** Q1 settled the order as _runtime
first, then the guard_. Marking N-004 blocking would gate the Batch A fixes behind a gate-design
decision, which is the opposite of what was decided. The ordering lives in the batches below, not
in the story gate.

### Batches — why each set belongs in one sitting

| Batch  | Nodes                             | Why they group                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Takeable |
| ------ | --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| ~~A~~  | ~~N-002 … N-019~~ (settled 27/08) | **Shared shape** — a restatement that drifted from its owner, each with the correct copy already in the tree to copy from. No trade-off: a replacement, a deletion, a re-wording. **N-019 joins it 23/08/2026** and is the purest case: `111637a` wrote the canonical form three times in the same commit that left six copies wrong                                                                                                                                                                                                                                                                                             | done     |
| ~~B~~  | ~~N-003 … N-018~~ (settled 27/08) | **Shared subject** — one question asked in four places: _where does a rule live, and what is canonical when the sources disagree?_ N-018 is the same question about a document's **scope** rather than its content                                                                                                                                                                                                                                                                                                                                                                                                               | done     |
| ~~F~~  | ~~N-014 · N-015~~ (settled 27/08) | **Mutual dependence** — N-015 decided what a `CHECKLIST.md` closes with; N-014 decided whether one of those closing sections may exist at all in `code/`. The pairing paid: N-015's answer (two named sections) is what made N-014's deletion safe, and N-014's clean 9/4 restate-route partition is what proved the block was the restatement                                                                                                                                                                                                                                                                                   | done     |
| ~~C~~  | ~~N-004 · N-008~~ (settled 27/08) | **Grouped on mutual dependence — and the dependence proved false.** _"The guard's design decides whether N-008 gets a trigger for free"_: it cannot, the script's three clauses being presence/absence tests with **no time dimension**. The batch held on **shared evidence** instead — one measurement settled both                                                                                                                                                                                                                                                                                                            | **now**  |
| ~~D~~  | ~~N-009 · N-010~~ (settled 28/08) | **Shared subject** — the same folder, the same two shipped files, the same question about what may cite what. **It held, and it paid**: N-009's measurement of which files copier lifts back out of an exempt tree is the same fact that told N-010 its conflict was resolvable by relocation                                                                                                                                                                                                                                                                                                                                    | done     |
| ~~H~~  | ~~N-023 · N-024~~ (settled 28/08) | **Shared subject, and it was this map's thesis in the one tree it had not reached** — both asked _what may a session write into `project-management/src/`, and which file says so_. **The pairing paid**: N-023's finding that a hook cannot see the running skill is what sent N-024's enforcement to a filename key instead, and N-024's rename is what makes that key reliable                                                                                                                                                                                                                                                | done     |
| ~~G1~~ | ~~N-020~~ (settled 27/08)         | **Split out of Batch G, 27/08/2026.** G was charted as one sitting on the strength of a _"settled shape"_ that measurement destroyed — 27 open questions from the measurers and 30 more from the verifiers. G1 is the part whose shape a shipped guide had genuinely already decided: the pipeline itself                                                                                                                                                                                                                                                                                                                        | done     |
| ~~G2~~ | ~~N-022 · N-021~~ (settled 27/08) | **Mutual dependence, and the reason G split.** N-021's refusal message names a retrieval procedure that **does not exist and has no owner** — `08-debugging/` is entirely local-dev and `09/STEPS.md:98` opens at _"Open Grafana → Explore"_ with no step for reaching it. Worse, **the doctrine N-021 enforces is stated nowhere**, so the guard would be a gate with no stated rule. Writing the rule is N-022. **The pairing paid twice**: N-022's answer to _where the line falls_ is what made N-021's `deny` list expressible at all, and N-021's measurement is what proved the home N-022 chose ships into every project | done     |

> **Batch A's rider, 23/08/2026 — a defect fixed in the sitting, not a node. Settled 27/08/2026.**
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

**Order by what unblocks the most:** ~~E~~ → ~~A~~ → ~~B~~ → ~~F~~ → ~~G1~~ → ~~G2~~ → ~~C~~ → ~~D~~ → ~~H~~
**— all nine settled 27–28/08/2026. The frontier is empty.**

> **The frontier emptied, refilled and emptied again in one sitting, and none of that is a failure
> of the chart.** D was the last _charted_ batch; H is two nodes Sam raised while D was being
> written, both squarely inside this map's destination — a rule stated in more than one place with
> no guard over it. Charting them here rather than opening a second map was the cheaper answer
> precisely because the destination already covered them, and settling them the same day cost one
> extra round of grilling. **The standing preference is now satisfied**: the frontier is empty, so
> `02-story-creation` is unblocked for the first time since 21/08/2026.

> **F discharged one of N-004's five conditional rows rather than feeding it, so C is smaller than
> charted and no longer waits on anything.** The row _workflow terminal-section shape_ was written
> _"waits on N-015, which must first pick a canonical spelling for a guard to have anything to
> assert"_. N-015 picked one — and then put the guard in a script of its own,
> `audits/workflow-shape.sh`, on the ground that `doctrine-drift.sh`'s stated rule is not workflow
> shape. The row is
> therefore **answered and closed, not inherited**: C reopens neither the spelling nor the guard
> that asserts it. **Four of the five rows remain** — source-file length (supplied by N-003), the
> `_tasks` doctrine (from N-019), the `CONTEXT.md` tree gate (from N-016), and the step-level
> `Model:` marker (from N-006).

> **N-001 moved from Batch A to Batch E on 23/08/2026** — a frontier redraw, not a re-typing. It
> is unchanged and still a build node (`task` at the time); the `code/` pass simply found two more defects in the same
> four-file folder, and a batch whose whole justification is _shared evidence_ should follow the
> evidence. Batch A keeps its rationale and gains two nodes that fit it better.

### Node detail — one line of evidence each

- **N-004** · `doctrine-drift.sh` holds **3 claims**, all JSON envelope keys, matched against **fenced
  code only**, over 5 trees. Its design note at `:27-31` defends fenced-only — _"examples are the
  contract"_ — and it was recorded **refusing a job** on exactly that ground
  (_"0 of 7 homes reachable on two axes"_). N-002's two restatements sit **inside** its scan dirs and
  it still cannot see them, because they are prose. Reopening the invariant is the decision.
  ~~**A second conditional row, added 23/08/2026:** _workflow terminal-section shape_ — waits on
  N-015.~~ **Discharged 27/08/2026 by Batch F, not inherited.** N-015 picked the canonical
  spelling this row waited on, and then put the guard in a script of its own —
  `audits/workflow-shape.sh` — on the ground that `doctrine-drift.sh`'s **stated rule** is the
  JSON envelope, not workflow shape, and `audits/CLAUDE.md` requires a gate derived from a stated
  rule. **N-004 no longer carries this row, and C no longer follows F.** Batch F's own measurement
  corrected two of the facts recorded here: `git grep -E 'Definition of Done|Update context
files|## Completion' -- code/src/scripts .claude/hooks .github lefthook.yml` does return **zero
  hits**, but _"nothing asserts workflow file shape"_ was **false** — `docs-pairing.sh:310-312`
  asserts an exact H2 sequence over all **49** workflow-tree `CLAUDE.md` and `:321` bans
  `Definition of done` as a `CONTEXT.md` heading. The precise statement is that **the two workflow
  files whose shape is gated are the two that do not carry the terminal contract.** The four audits
  naming `STEPS.md` (`copy-emdash.sh:22`, `copy-slop.sh:81`, `docs-length.sh:109`,
  `doctrine-drift.sh:49`) do all use it as scope or commentary, and `doctrine-drift.sh` reaches
  **further than its own comment says and guards less** — `SCAN_DIRS` at `:61-67` is the three whole
  workflows trees and `:190` walks every `*.md`, so all 190 files are **visited**, every
  `CHECKLIST.md` among them, while the 3 fenced-code claims make no heading in any of them
  **visible**. **This node also carried the map's only class B evidence** — the corruption
  rider, one unreadable checklist line that passed every gate for 22 days; **settled 27/08/2026**
  with Batch A, and **still live in the tree**.
  **A fourth conditional row, added 27/08/2026 out of N-016 (Q3): `CONTEXT.md` tree completeness.**
  It waits on no prior decision but carries an open design question of its own — **what a tree may
  legitimately elide**, since `code/docs/CONTEXT.md` lists every file where `code/CONTEXT.md`
  summarises by design (the standing fog entry). What N-016 supplied is the **evidence the row
  lacked**: four omissions were repaired and a fifth appeared between charting and settlement, so
  this is a rule that **decays continuously**, not one that failed twice. `doc-references.sh`
  structurally cannot see an omission — only a bad citation — so no existing gate can take it.
  **A fifth conditional row, added 27/08/2026 out of N-006 (Q3, Q6, Q8): the step-level `Model:`
  marker.** Batch B settled its **meaning** — it overrides the file-level `model:`, and the
  grilling step always inherits — and deleted the **17 of 40** markers that contradicted
  `.claude/CLAUDE.md` Section 4. It settled **no enforcement**: the marker has no schema, no reader and
  no gate, `routing-skills.sh` validates `skills:` names alone, and the 40 that exist were written
  by hand. A rule now exists to assert, which is the precondition this row waited on.
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
- **N-022** · **Charted 27/08/2026, out of G1's measurement, and it is why Batch G split.** The
  doctrine N-021 exists to enforce — _the human opens the connection, Claude writes the command_ —
  **is stated in no file.** The map attributed it to `09/CLAUDE.md` and `08-debugging/CLAUDE.md`;
  both were read in full and grepped repo-wide, and it is in **neither**. The nearest statement
  anywhere is `how-to/docs/HEALTH-PROBES.md:23`, _"shell access to the environment that is red"_,
  listed as a prerequisite with no procedure attached. **The procedure has no owner either**:
  `how-to/workflows/08-debugging/` is entirely local-dev and its `CONTEXT.md:45-46` hands
  staging and production to `code/workflows/09`, whose `STEPS.md:98` then opens at _"Open Grafana
  → Explore"_ with **no step for reaching Grafana at all**. Neither file claims the gap, and
  `code/src/scripts/deployment/` holds no script — its `CONTEXT.md:22-25` refusing on record to
  register one that does not exist. So the decision is **where the rule lives and who owns the
  procedure**, and it is class **D**, not **E**: this is a rule with no home rather than a
  capability that was promised and not built. **N-021 is blocked on it**, because a guard whose
  refusal message cites a procedure nobody owns is a gate with no stated rule —
  `code/src/scripts/audits/CLAUDE.md`'s own prohibition, and the defect N-004 exists to catch.
- **N-021** · **Charted 27/08/2026; re-measured at `7a82095` by G1, which corrected its mechanics
  in three places and refuted one of its premises outright.**
  `09/CLAUDE.md:42-43` bans pasting secrets or PII from logs into commits and bug reports, and
  **nothing enforces it**. `.claude/settings.json` sets no `defaultMode` and its 84-entry `allow`
  list is read-only commands, so `ssh`, `scp`, `aws` and `wg` prompt today rather than refuse.
  **Settled shape (Q13): both layers** — `deny` entries for the connection verbs **and** a
  `PreToolUse` Bash hook matching the **full command string**. The conclusion stands; **the
  reasoning behind it was wrong in three places**, corrected 27/08/2026 against the official
  documentation.
  1. **_"A prompt can be approved, including from a `settings.local.json` a project writes for
     itself"_ — refuted for a denied command.** _"Deny is absolute across all scopes. If a tool is
     denied at any level, no other level can allow it."_ Rules evaluate **deny → ask → allow**,
     first match wins, and specificity does not reorder them. A local file cannot re-approve what
     a project deny refuses.
  2. **Two of the three composition escapes do not exist.** A prefix rule **does** survive a
     **pipe** — `&&`, `||`, `;`, `|`, `|&`, `&` and newlines are parsed and each subcommand
     matched independently — and it **does** survive a **variable**, because _"a deny or ask rule
     matches past any leading assignment"_ (the assignment bypass applies to **allow** rules only).
     Only **`bash -c`** holds, the subcommand there being `bash`. **A fourth escape the node never
     found is the strongest**: unsupported wrappers. `docker exec`, `npx`, `devbox run`,
     `direnv exec` and `mise exec` are explicitly **not** in the strip list, so
     `docker exec … ssh` walks around any `Bash(ssh:*)` rule. The hook survives on one charted leg
     of three plus one uncharted.
  3. **The mechanism is confirmed and a third lever was found.** Exit `2` **is** a hard block — the
     only exit code that blocks on its own — and there is also a structured form,
     `hookSpecificOutput.permissionDecision: "deny"` with a reason; a `PreToolUse` hook receives
     the **full command string** at `tool_input.command`, as the settled shape assumed. Neither
     form appears anywhere in this repository — **zero** occurrences of `permissionDecision` or
     `hookSpecificOutput` — so the only internal statement of hook semantics is a **comment** at
     `.claude/hooks/template-docs-readonly.sh:27`, now known to be accurate. The third lever is
     `permissions.defaultMode: "dontAsk"`, which auto-denies everything not pre-approved **and
     still honours a PreToolUse allow**, so it composes with the hook rather than competing.
     **Two costs the node had not weighed.** `.claude/settings.json` is **not** in `copier.yml`'s
     `_exclude`, so a deny entry here **ships verbatim into every generated project** — and since
     deny is absolute, with no local escape;
     `.claude/hooks/template-docs-readonly.sh:15-21` records that this exact property is why the
     previous guard was written as a hook rather than a deny rule, and that reasoning has never been
     applied here. And **`Bash(find:*)` is pre-approved** at `settings.json:10` while
     `find … -delete` and `find … -exec` both begin with the token `find` and a space, so N-021 may have to audit the
     84-entry allow list rather than only add denials. **The doctrine it enforces is N-022**, and
     N-021 is blocked on it.

- **N-023** · **Charted 28/08/2026, from Sam, as Batch D was being written.** The boundary he
  states is _chart states the nodes and the potential slices; **resolve finalises the design plan
  on the map** and writes nothing else; stories and sprints come after._ Measured against the tree,
  **half of it is stated in the wrong file and the other half is contradicted by the skill.**
  1. **The no-code half has exactly one home, and the skill cannot reach it.**
     `project-management/workflows/01-feature-map/CLAUDE.md:63` reads _"Documentation workflow — no
     code."_ `.claude/skills/wayfinder/SKILL.md` is **247 lines and never says it**; its one
     adjacent sentence, `:31`, is _"wayfinder writes markdown only, never to ClickUp directly"_ —
     a statement about **ClickUp**, not about source. Since a skill fires on description match and
     is read **before** the workflow it routes to, the rule sits behind the surface that needs it.
     This is the map's thesis inverted: **one home, unreachable from the entry point.**
  2. **The map-only half is not under-stated but _contradicted_.** `SKILL.md:135` mandates
     _"never leaving an answer only on the map"_, and `STEPS.md:172-174` repeats it verbatim as
     Step 8.4. The graduation table at `SKILL.md:178-189` names **five** destinations outside the
     map — an `ADR-###` in `15-DECISIONS/`, a **Slices** row, a `GAPS.md` entry, a `DEFERRED.md`
     row, and a glossary term in the nearest `CONTEXT.md`. Only two of the five are already fenced:
     the table forbids writing a story (_"never a written story"_) and `SKILL.md:163-168` forbids
     **closing** a register entry. **The requested boundary therefore reverses a shipped rule
     rather than filling a silence**, which is why it is a decision and not a correction.
  3. **What the decision has to settle**, in the order the answers depend on each other: does
     RESOLVE write to the map **only**, or to the map plus the two artefacts that cannot wait
     (an ADR is a decision record, and a `GAPS.md` blocker discovered mid-resolve has nowhere else
     to live)? If map-only, **when** does graduation happen — a new terminal step, or at
     `02-story-creation`? Where does the no-code rule live so the skill carries it? And **what
     guards it**, given `.claude/hooks/` already holds a file-scope hook precedent in
     `template-docs-readonly.sh`.
  4. **This sitting is itself the evidence.** Batch D settled two nodes, wrote **only** the map,
     and graduated nothing — the shape Sam is asking for, executed before it was written down.
- **N-024** · **Charted 28/08/2026, from Sam.** The rule: _anything writing into
  `project-management/src/NN-*/` writes from the template in the folder **at the level it is
  writing**._ **The rule already has an owner, and the owner's statement is narrower than the
  rule** — which is a different defect from the homeless ones this map opened on, and arguably a
  worse one, because the owner looks discharged.
  - **Owner:** `project-management/src/CLAUDE.md:26-29` — _"copy the target folder's per-story
    template — the stage folder for `04`–`08`, `PLANNING/` vs `IMPLEMENTATION/` for `09`–`13` — using
    its fixed naming pattern"_. It enumerates `04`–`13` and stops. **`01`, `02`, `03`, `15`, `16`,
    `17`, and `19`–`23` are outside its scope**, so eleven registers are governed only by their own
    folder `CLAUDE.md`.
  - **Population, measured at `7a82095`:** **48** `CLAUDE.md` files under
    `project-management/src/**` mention a template; **44** `*TEMPLATE*` files exist across the
    registers; `project-management/CLAUDE.md` one level up mentions templates **zero** times. The
    per-folder restatements are near-identical — _"the copy source; do not delete or repurpose"_
    recurs verbatim — which is the drift signature Batch A settled four times over.
  - **Two registers have no template at all, and both look deliberate.** `18-TESTS` ships
    `US000-MANUAL-TESTING.md` and `US000-TEST-STATUS.md`, which `copier.yml:178-179` documents as
    _"named for the story they are copied to, not for their role"_ — a template that declines the
    `*TEMPLATE*` marker, and therefore invisible to any guard keyed on the name. `00-ASSETS` holds
    logos and scripts and has no instances to template. **A rule stated as _all_ has two exceptions
    and names neither.**
  - **What the decision has to settle:** does the owner's statement widen to every `NN-*` register,
    or does the rule move up to `project-management/CLAUDE.md`? Do the 48 restatements collapse to
    citations, on the Batch A pattern? Are `18-TESTS` and `00-ASSETS` named exceptions or defects
    to fix? And can a guard assert it at all, given the `18-TESTS` pair proves the `*TEMPLATE*`
    filename is not a reliable key.

---

## Fog of war

- **Orientation carrying operating rules in prose, under legal headings.** `docs-pairing.sh` Section 5 bans
  _headings_, not sentences; the decision test is per-sentence and nothing measures it.
  **The class extent was measured 01/09/2026 and the item stays fog — the measurement did not
  discharge it, and the first attempt to strike it was refuted twice.** Over all **221** tracked
  `CONTEXT.md` files: median **1** rule-verb line, mean 2.0, **81 files at zero**, p90 5. So the base
  rate is far too low for a per-sentence gate — that would be a taste threshold failing correct work,
  which `audits/CLAUDE.md` reserves against. **But the strike was attempted on three false claims and
  is withdrawn:** (1) _"only three files at ≥ 9"_ is **four** — `audits/CONTEXT.md` 45,
  `project-management/workflows/CONTEXT.md` 11, `.claude/skills/CONTEXT.md` 11, and
  **`how-to/src/SERVER-ARCHITECTURE/CONTEXT.md` at exactly 9, never inspected**, whose `:68-69`
  (_"always the envelope plus the headroom buffer, never the bare measurement"_) and `:89` are
  operating-rule prose in an orientation file — the class this item names; (2) it is an **idiom, not a
  one-off** — `_Avoid:_` prohibitions appear **5 times across 2** orientation files, and
  `project-management/workflows/CONTEXT.md:48-49` reads _"Do not batch: do not write every story, then
  every schema, then every flow"_, a direct imperative on conduct, which
  `DOCUMENTATION-PAIRING.md:114-115`'s own test distinguishes from orientation; (3) the claim that the
  owning guide _"already states both halves"_ misreads Section 8 — its _deliberately not mechanical_
  row (`:203`, `:206-208`) covers the opening **why** paragraph only, and **no enforcement row
  addresses the per-sentence test at all**. **What would discharge it:** disposition the fourth file
  explicitly (move its rules to a paired operating-rules home, or record them defensible), and add the
  one line to `DOCUMENTATION-PAIRING.md` Section 8 stating that the per-sentence half is reviewer
  judgement — which is a rule with no stated owner today, and therefore the real defect this item has
  been circling.
- ~~**Whether N-005's three-taxonomy problem is one decision or two.**~~ **Moot for `phase:` since
  27/08/2026** — Batch B settled N-005 by **deleting** the key from 93 files and from the
  `.claude/CLAUDE.md` schema, so there is no third taxonomy left to reconcile and the entry's
  stated dependency is discharged. ~~**A narrower residue survives and is deliberately not promoted**:
  whether the code and how-to workflow trees' two four-family groupings should agree with each
  other.~~ **Residue cleared 01/09/2026 by measurement — there is no axis on which the two could
  conflict, so the question stops existing.** The taxonomies partition **disjoint populations**:
  code's _build (01–06) / verify (07–08) / diagnose & improve (09–11) / build opt-in (12–13)_
  classifies only `code/workflows`, how-to's _set up (01–02) / run (03–07) / diagnose (08) /
  author (09)_ only `how-to/workflows` — **no workflow is classed twice.** On their only two points
  of contact they already agree: the shared meta-rule (a catalogue entered by task type,
  append-never-renumber) is stated compatibly in both, with how-to explicitly citing code's as its
  model (_"Like `code/workflows/`"_); and the one shared family word, **diagnose**, carries the same
  sense in both, with the seam owned and routed in both directions — `how-to/08` is environment-first
  and states _"Code-logic faults belong in `code/workflows/10-debug/`"_. **They merely differ, and
  layer-local vocabulary over disjoint sets is not drift.** N-005's deletion verdict is confirmed
  rather than reopened. **Do not re-chart this.**
- ~~**Whether the guard from N-004 should also cover `**/CLAUDE.md` under `code/src/`.**~~
  **Answered 27/08/2026 by Batch C (Q26), and the population was larger than the entry recorded**
  — **57** prose restatements across **44** files, of which **16** are `code/src/**/CLAUDE.md`
  guardrail bullets. The answer is neither _cover_ nor _exempt_: the guardrail bullet is a
  **sanctioned second home that must agree**, because a `CLAUDE.md` is read _instead of_ the owner
  rather than alongside it. **Do not re-chart this.**
- ~~**Whether a `CONTEXT.md` tree is checkable at all.**~~ **Answered 27/08/2026 by Batch C (Q27),
  and the entry's premise was false in the most useful way.** It said _"nothing here says which
  wins"_ between completeness and orientation. **Something does, and has since 11/08/2026**:
  `code/src/scripts/development/sync-trees.sh:29-31` decides it explicitly — _"ONLY THE TOP LEVEL
  of each block is reconciled. Deeper levels are curated summaries"_ — and is wired pre-commit at
  `lefthook.yml:75-77`. The entry was written against a gate that already existed. **What it got
  right is that the answer is incomplete**: `ROW` at `:145` anchors on `^[├└]──` and the space after it, so N-016's depth-2
  population is invisible, and `code/docs/discoverability/` and `code/src/scripts/dependencies/`
  are absent from `code/CONTEXT.md` while `--check` reports clean. Q27 keeps top-level-only and
  adds a declared-elision marker. **Do not re-chart this.**
- **Which sections of a shipped guide a project may edit, where the guide answers in prose.**
  `how-to/src/BRAND-VOICE.md:13` puts its portable core at _"Sections 1, 2 and 4 to 7"_ and `:237`
  at _"Section 1 … and Section 4"_, echoed both ways at `01-first-time-setup/STEPS.md:149` and
  `:158`. **Neither is false and both yield the same action** — all 7 `_TBD` markers sit in Section 3 — so
  there is no drift to fix, and nothing anywhere measures which sections a project owns.
  `code/docs/VISUAL-DESIGN.md`'s two statements are byte-consistent, so the population is **one
  file**. Sharpens into a node only if a third guide states its own split a third way.
  **Re-measured 01/09/2026: the sharpening condition is still not met** — a repo-wide sweep of
  `code/docs`, `how-to`, `project-management/docs` and `.claude` for section-split phrasing finds
  **exactly two** guides carrying one, both still self-consistent; a fifth restatement site
  (`04-QUICKSTART.md:193-194`) agrees with `BRAND-VOICE.md:13`'s framing rather than adding a third
  way. **The trigger is made checkable rather than left passive**, because a condition depending on a
  future author volunteering the observation is one that never fires: the two existing instances were
  found only because a resolve sitting went looking. **Attach it to the birth path** — one line in
  `how-to/workflows/09-write-operator-guide/CHECKLIST.md` asking whether a guide shipping as a
  template with fillable sections states which sections a project owns, and if so, that it is the
  third such guide and this item reopens. That is the revisit-trigger shape this repository already
  uses, at negligible cost.
- ~~**Whether the four terminal spellings in N-015 are drift or vocabulary.**~~ **Cleared
  27/08/2026 by Batch F, from evidence rather than by decision — and the entry's own premise was
  false.** It said `Close-out` sits on _"three discovery ones"_; exactly **one** of the 46
  workflows is `phase: discovery`. The verdict is **drift**: zero approval items across all six
  `Close-out`/`Closeout` sections, against 8 `Definition of Done` sections that carry them. **One
  real distinction survived and was canonised** — `Close-out` is a docs-hygiene tail and
  `Definition of Done` the assertion, two sections rather than two names. Full account in the
  Batch F settlement above; **do not re-chart this**.

---

## Out of scope

| Ruled out                                                                                                  | Why                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Restructuring `code/src/scripts/audits/CONTEXT.md`                                                         | **Fails the deletion test** — splitting moves complexity into a third file rather than concentrating it; the inventory is genuinely one table, and its dated allowance (expires 01/12/2026) already supplies a trigger                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Reopening **whether** the coverage-floor restatements stay                                                 | Settled at `12973ef`. N-008 charts only the missing revisit trigger, not the decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Changing the 750/800 or 300/270 thresholds themselves                                                      | The numbers are not in question anywhere in this map — only **where they are written** and **whether anything guards them**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `main` reconciliation (`GAPS.md` 20/08/2026)                                                               | Unrelated to rule ownership; the entry routes itself to `23-pr-and-review`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| Folding these nodes into the template-health map                                                           | Q2. One cause, one remedy, its own frontier — kept out of a 446KB catch-all                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Adding the `CONTEXT.md` index row for this map                                                             | Q4. It would ship a citation to a map no generated project holds. Charted as N-010 instead of obeyed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| The 14 defects the `how-to/` pass **fixed** on 23/08/2026                                                  | Shipped in `c024338` and re-verified live at `c09a189`: the dead `--service backend` / `--service frontend` flags, `lsof -i :8000`, the phantom `docker-compose.override.yml`, six audits absent from the operator's gate list, four files absent from `how-to/CONTEXT.md`, the `24-` numbering collision, the drifted skill count. **Done, not deferred** — listed so a later pass does not re-chart them                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| The 41 broken relative links in `code/docs/cloudinary/`                                                    | Vendored third-party reference docs whose links target Cloudinary's own site. Not this repository's rules, and `doc-references.sh` already exempts the tree                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| The five audits that exit `1` on `--path project-management`                                               | **Routed away, not charted here.** `copy-emdash.sh`, `css-gradients.sh`, `css-tokens.sh`, `seam-contract.sh`, `template-orphans.sh` — **all five verified false positives** (see _Notes_). The cause is **gate scoping**, not a rule with two homes, so it shares neither this map's cause nor its remedy. Recorded only because it narrows this map's own repeated claim that _"the gates are green"_                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| The four findings the sixth pass refuted (23/08/2026)                                                      | **Refuted, not deferred**, each on its own ground, and recorded so a seventh pass does not re-chart them. **Answer-sheet protection** — the stated harm does not occur: a real `copier copy` at v7.0.0, four answer sheets filled in, then `copier update` to HEAD produced **zero** conflicts, because the cells a project owns are copier tokens re-rendered from unchanged answers — `PLATFORM-PROVIDERS.md:19` defines that column as _"the answer given at generation time, **or the shipped default**"_. Its survivor is _guard coverage is 2 of 4_, which is gate coverage and routes to **N-004**. **"Nothing reads the ownership taxonomy"** — false: `doc-references.sh` **Check 3** parses `copier.yml` `_exclude` into a ships / does-not-ship set, applies it to `11-CUSTOMISING.md`, carries **no path filter by decision** (`audit-doc-references.yml:18-19`) and is a **required status check**. **The rule/answer split in `BRAND-VOICE.md` and `VISUAL-DESIGN.md`** — the collision mechanism does not exist: **0 of 45** post-birth hunks reached a fill-in cell in either file; moved to _Fog of war_. **"No per-file keep-mine short of a fork"** — false: `copier update` carries `-s/--skip` and `-x/--exclude` (measured at 9.17.2) and `template-update.sh:90` already forwards them; its survivor — _"deleted files come back"_ is false for a **tracked** deletion — is a `how-to/` accuracy fix in the `c024338` class, not a node |
| A reported `PROVIDER-NEUTRALITY.md` / `PLATFORM-PROVIDERS.md` contradiction over `git_writeback.py`'s seam | **Surfaced by G2's measurement, not re-verified in this sitting, and routed out on both grounds.** It is a claim about **built state** — whether a seam is real or specified — which is forward-voice territory (`code/docs/FORWARD-VOICE.md`), not a rule with two homes. Recorded so a later pass can chart it **after checking it**, rather than inheriting an agent's finding as a node this map never opened                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| Ownership across the copier seam, as its own subject                                                       | **Recommended as a separate chart, not folded here.** Who may write to a file _after_ generation is a **lifecycle boundary**, not a rule with two homes: the file has one home, and the dispute is who writes it next. The remedy is a copier mechanism — `_skip_if_exists`, `_exclude`, `_migrations`, a merge driver — never _name an owner and add a guard_. Q2's discipline cuts both ways: it kept these nodes out of a catch-all because they share one cause and one remedy, and it keeps a different cause out of them. **`MAP-UPSTREAM-TRACKING.md:33` is not its home either**, scoping itself to _"syntek-base's own upstream surface, **not a generated project's**"_. **N-019 is not that subject** — its fact is stated by this repository, about this repository, in files this repository owns                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| The domain-grouped checklist headings                                                                      | `Before` / `During` / `After`, `Justification` / `Change` / `Verification` / `Record` and the rest are deliberate and repository-wide — PM `01`, `12`, `14`, `18` and code `05`, `12`, `13` all do it, and the groupings carry real information. **N-015 is the terminal section only**, never the groupings above it. **Qualified 23/08/2026:** the seven files with no `## Completion` are **exactly** these seven, so the groupings and the missing terminal are one population, not two — the ruling holds as a statement of intent but cannot be applied as a clean separation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |

---

## Session log

| Date       | Node settled                                            | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Frontier redrawn                                                              |
| ---------- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| 21/08/2026 | N-011 (research) · re-verification                      | **Charted: 10 open nodes in 4 batches, 1 research node fired and settled same-day.** Two architecture reviews produced nine findings; charting produced a tenth. N-011 widened N-009 from one file to **four exemption arms / nine shipped files**, and bounded it honestly — exposure is **one citation and it is legitimate**, so the defect is latent, not live. Register triaged exhaustively at one entry: **0 closes, 0 blocks, 1 unrelated**. Q4 answered _don't add the index row_, which made the instruction itself node **N-010**. Nothing else settled — CHART draws the frontier. **Then the base moved under the session and every node was re-measured.** Two commits landed from parallel sessions between the first measurement and the write (`5d7d264`, `5d3c22f`); **all ten nodes still hold at `5d3c22f`**. Two premises did move: the single `GAPS.md` entry was deleted (staged, verdict unchanged), and `5d3c22f` repaired the one dangling citation the reviews had reported, so `doc-references.sh` is now **clean**. **N-009 came out stronger** — `5d7d264` narrowed a sibling arm of the very function it names, on the very same reasoning, leaving the four arms below it unamended. The standing lesson applied to itself: _re-verify what a parallel session hands you_                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]                                                                           |
| 23/08/2026 | _(none — a charting pass)_                              | **Two further reviews; seven nodes added, nothing settled.** The `how-to/` pass (`…091427Z.html`) **fixed 14 defects** rather than charting them and left one decision, now **N-018**; the rule it installed at `how-to/workflows/CLAUDE.md:38-44` became **N-015**. The `code/` pass (`…135337Z.html`) charted **N-012**–**N-017**. Sixteen of seventeen open nodes are class **D** split doctrine; **N-012** is this map's first class **A**. **N-001 moved A → E** — a frontier redraw, not a re-typing: the `code/` pass found two more defects in the same four-file folder, and a batch justified by _shared evidence_ should follow the evidence. **The blocked item from the `how-to/` report is unblocked** — see below, including the recommendation that was not taken. Registers re-triaged against a `GAPS.md` restructured underneath the map: **0 · 0 · 0 over zero triable entries**, verdict unmoved. Every claim re-derived at `c09a189`; **all ten original nodes still hold**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [x]                                                                           |
| 23/08/2026 | _(none — a verification pass)_                          | **A fifth review, over `project-management/`; no node added, three corrected.** `architecture-review-20260823-142445.html` re-measured the layer the other four had only passed through. **The pass's value was the refutation, not the discovery.** Its seven claims went to seven independent hostile verifiers and **six came back refuted or materially corrected** — including two the report had rated `Strong`. Killed: _"`18` is named nowhere in `REFERENCES.md`'s canonical map"_ (it appears four times, once **inside** the pairing table at `:206`) and _"three CHECKLISTs never declare the work finished"_ (the terminal assertion is **relocated to a line-13 preamble** in exactly those three). Corrected: N-015's `0 of 13` premise — true of the heading, false of the clause, **8 of 13** carrying items 1-4 **byte-identical** to the contract's own list; N-002's own citation, **stale at `:200`/`:172`** and understating a three-way disagreement as a two-way one; and the map's standing _"the gates are green"_, which meant **four** of the **twenty** audits that take `--path` — five others exit `1` on this tree, **all five false positives**. One defect found and **not charted**: the `02-story-creation` corruption, a Batch A rider and this map's first class **B** evidence. **Node-count invariant unmoved: 17 open + 1 resolved = 18.** The standing lesson applied to itself for the third sitting running — _re-verify what a parallel session hands you_, where this time the parallel sessions were the map's own verifiers, and the first draft of these numbers was wrong in six places                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]                                                                           |
| 23/08/2026 | _(none — a charting pass)_                              | **A sixth review, over the copier seam; five candidate findings, four refuted, one node.** `architecture-review-20260823-164041.html` asked whether a generated project keeps its edited documentation across `copier update`. **It does, and always did** — the three-way merge preserves an untouched file silently and an edited one unless the lines overlap. Four of the five findings built on that premise died with it, **two by execution rather than argument**: a real `copier copy` → fill in → `copier update` produced **zero** conflicts in any answer sheet, and `copier update` was measured carrying `-s/--skip` and `-x/--exclude` at 9.17.2 — the capability two shipped guides say requires a fork. A third died on a mechanism the review had not looked for: `doc-references.sh` **Check 3** already parses `copier.yml` `_exclude` for ownership and is a **required status check**. **What survived is N-019**, and it came from the wreckage of a refuted taxonomy rather than from any of the five theses. **The parallel-session lesson fired for the fourth sitting running, and this time it was the finding**: two commits landed mid-pass — `9122ca5` (v7.4.0) and `111637a` (v7.4.1) — and the second **fixed the very fact N-019 charts**, in seven places by its own count. Six shipped homes still contradict it, three of them in the one file that commit edited, and one of those three is a line **that commit rewrote**. Every number re-derived at `111637a` against a clean tree, never at the `fff9955` the pass opened on                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | [x]                                                                           |
| 27/08/2026 | **N-001 · N-012 · N-013** (Batch E)                     | **The map's first resolve session. Three nodes settled, four of the map's own literals corrected, two nodes opened, and the batch split rather than grown.** All three held at `7a82095` and **all three were larger than charted**: N-001's six dev commands name a service `docker-compose.dev.yml` does not define, so they could never have run; its in-container log path is wrong five times; and Step 7 had **no script to route to**, `deployment/` holding none and its `CONTEXT.md` refusing on record to register one. N-012's premise was wrong — `LOG_AGGREGATOR` is **prose-shaped**, not cell — which freed 13 of the 43 literals, and `copier.yml` omits **two** prose tokens from a list `TEMPLATE-TOKENS.md` owns, so the rider **deletes the enumeration** rather than completing it. N-013 cut **at the fix, not the root cause**: Step 7's tools are `09`'s own and `CONTEXT.md:28` already promised the function. **Settling them found a fifth defect no node had charted** — Step 4's LogQL returns nothing, because staging and production emit plain text where two shipped documents promise JSON — which with an unmounted `code/src/logs/` became **N-020**; the block on Claude opening a connection to a server became **N-021**, waiting on it. **The batch stopped being one sitting**: three nodes carried the work from four files to twelve across four layers, and folding that into S-01 would have turned an all-`N/A` manifest into a GDPR-flagged one without the manifest moving. Split three ways instead. **Invariant: 17 open + 4 resolved = 21 = N-021**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | [x]                                                                           |
| 27/08/2026 | **N-002 · N-007 · N-016 · N-017 · N-019** + rider       | **Batch A, the same day. Five nodes and the rider settled; six more of the map's literals corrected; nothing new opened.** **N-002 was charted as three files disagreeing and is four** — `REFERENCES.md`, which calls itself _"the single source of truth"_ for the pairing, **contradicts itself**: prose at `:201` and `:218-220` says `18`–`20`, its own rows at `:210-212` say `19`/`20`/`21`, and it already writes `19` correctly at `:208`/`:209`. Six numbers wrong in one file against two right — the file's own hand settled it. Both restatements were **deleted, not corrected**, each carrying _"Do not restate it here"_ two lines above. **N-016 shrank under a parallel session and grew back**: four of its eleven omissions are now present and `MACHINE-SPEC` has appeared, which is the evidence it lacked — the rule **decays continuously**, so the gate question routed to **N-004** as a fourth conditional row rather than being designed in the wrong batch. **N-017's fourth literal sits in the sentence that names the owner** (`21` for `22`, twice, in the bullet assigning closeout to `22`), and its file count became a **`git grep`** — three numbers had been written for one claim. **N-019's owner was forced by a lookup**: `/copier.yml` is the first line of `_exclude` and does not ship, while all six homes do, so `06-GENERATION.md:140-141` owns it — with **one deliberate second home**, the `_tasks:` guard comment, because `111637a` reintroduced this very error **48 lines below its own fix**. **The rider's harshest claim held**: `git log --all -S` puts the string in `c2886e8` alone, so the line was **born corrupt**, and fragment two is re-authored naming no script because the repository has **no a11y script at all**. **Invariant: 12 open + 9 resolved = 21 = N-021**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | [x]                                                                           |
| 27/08/2026 | **N-003 · N-005 · N-006 · N-018** (Batch B)             | **Four grilling nodes, one question, and the sitting that found this map's largest single population.** **N-003: 56 files state the 750/800 limit and four name a home — and the named home is silent.** `.claude/CLAUDE.md:231` states both numbers then disclaims ownership; `coding-principles/CLAUDE.md:30` names **two** homes in one sentence; `11-CUSTOMISING.md:155` **ships**, telling a project to change the rule in a file that does not contain it; `cloc.sh:70` points back at claimant one. Settled onto `PRACTICAL-RULES.md` — `code/CONTEXT.md` was **never** the answer, orientation being the wrong home for a threshold, so three claimants had made one category error together. **N-005: deleted.** 93 files, **11** values, a singleton `implementation` against `build` ×22 — and **no reader and no definition**; the deletion is clean because nothing emits it. **N-006 was charted as _"two design workflows inverted"_ and is 40 markers across all 18**, **17** of them putting a design act on the implementation tier, **six** of those on the `Step 1 — Grill, then …` step itself. Frontmatter is canonical, the range list is deleted, and Section 2.5 gains the precedence sentence — **the grilling clause was measured, not assumed**: Section 10 makes grilling open code, tests, QA and review too, so grilling is **not intrinsically fable** and Section 4 implies nothing about its tier. **N-018: three framings, two of them in one file**; it becomes an index over ten families plus **8** commands derived from `03-daily-development` ∪ `08-debugging` — derived, so it cannot drift back into _"every dev command"_ one entry at a time, which is how the arbitrary 25 happened. **Two nodes opened nothing; N-004 gained a fifth conditional row.** **Invariant: 8 open + 13 resolved = 21 = N-021**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | [x]                                                                           |
| 27/08/2026 | **N-014 · N-015** (Batch F)                             | **Two nodes, seven more of the map's literals corrected, a fog entry cleared from evidence, and one of N-004's conditional rows discharged rather than fed.** Ten agents re-measured all 46 workflow folders at `7a82095`, each axis derived once and re-derived by an independent verifier on different commands — **the verifiers overturned findings from their own measurers**, so every number is twice-derived. **N-015 was charted as _9 of 46 fail_ and read as the ordered tail it is actually written as, only 22 of 46 conform** — `code/` **0 of 13**, `PM` 15 of 24, `how-to` **9 of 9**: the layer that wrote the rule is the only one that keeps it, and the layer it names as _the reference shape_ is not. _Three_ checklists lacking a `Definition of Done` is **eight**; _four_ spellings is **five**. Settled by moving the contract to an owner of its own — **`how-to/docs/WORKFLOW-SHAPE.md`**, because workflows are a how-to subject — carrying **the four-file shape and the terminal contract and nothing else**, since every rule a wider scope would absorb already has an owner **and** a gate. `## Completion` was dropped as a required heading on measurement: **39 of 39** are byte-identical boilerplate. **The four-spellings fog entry was cleared from evidence and its own premise was false** — it claimed `Close-out` sits on _"three discovery ones"_ when **exactly one** of 46 workflows is `phase: discovery`, and zero of the six `Close-out` sections carry an approval item against **8 `Definition of Done` sections that do**. One real distinction survived and was canonised, from the single file carrying both. **N-014 was scoped to the wrong file set and the wrong shape**: 37 is **38**, _"the same four-line block"_ is **seven variants** covering only 29 of 38, and the defect was never confined to `CHECKLIST.md` — **22 of the 24 `## Update context files` blocks in `STEPS.md` understate it too**, so 30 instances is **52**. Its restate/route partition proved **perfectly clean 9/4**: the block **is** the restatement, one-for-one, so it is deleted in `code/`. **The gate was executed, not assumed** — a `CONTEXT.md`-only directory fails `docs-pairing.sh` with exit `1`, and **that script never opens a `CHECKLIST.md`**, so the wording change alters no gate outcome. **The claim that nothing gates workflow headings was refuted**: `docs-pairing.sh:310-312` already asserts an exact H2 sequence over 49 workflow `CLAUDE.md`. **The counter-argument to guarding at all is on record** — the equally ungated routing frontmatter is **92 of 92** with zero drift. **Both nodes opened nothing; the guard went to its own script and N-004 lost a row.** **Invariant: 6 open + 15 resolved = 21 = N-021**                                                                                                                                                                                                  | [x]                                                                           |
| 27/08/2026 | **N-020** (Batch G1) · **N-022 charted**                | **The batch whose shape was already 'settled' and was not — G split in two, and the first recommendation of the sitting was overturned by its own adversarial pass.** Ten agents re-measured the logging surface; they returned **27 open questions and the verifiers raised 30 more**, against a node the map described as settled. **Three charted premises were false**: _five_ Compose files is **four** (the fifth was the phantom `docker-compose.override.yml` this map's own out-of-scope table records `c024338` deleting); _two_ shipped docs promising JSON is **twelve**, one of which — `DJANGO-LOGGING.md:133` — **already decides the shape** and was never cited by the node; and the mount claim is stronger than charted, the string `logs` appearing in **no Compose file at all**. **Five findings the map did not have**: no `import logging` **anywhere** in the Django tree, so the pipeline carries framework records only; the base/staging/production `LOGGING` dicts **byte-identical**, which `settings/CLAUDE.md:39-41` forbids; **no JSON dependency installed**; the guide's own hand-rolled formatter **emitting invalid JSON** on any quote or newline; and **three container labels of which none is what Compose produces**, so a correct stream under the wrong label still returns nothing. **Settled: write the formatter, do not depend on one** — and that reversed this sitting's own first recommendation. `python-json-logger` was recommended, then **refuted by the adversarial pass on `STYLE-AND-PROCESS.md:121`** — _"don't add a dependency for something you can write correctly in under 50 lines"_ — a gate the recommendation had never read; its claimed decisive advantage also proved **false**, `rename_fields` needing a companion `fmt` entry and being **silently ignored** under `"class"`. **structlog is the better tool and lost anyway**, which is the whole point of the gate. **A mandatory shipmate emerged that no node had charted**: `MONITORING-AND-INCIDENT.md:42` requires `request_id` in **every** log entry, `RequestIDMiddleware` ships with a comment naming a logging filter as its consumer, `negative-space.sh` enforces the middleware — and **no `logging.Filter` exists**, so the repository fails its own security guide today. **`syntek-modules` was proposed as the home and declined on evidence**: it is generated **from** `syntek-base` and has **already inherited this exact defect** at v7.4.1, so a fix living only there cannot fix it; the user-choice seam it wanted already exists as `copier.yml`'s `LOG_AGGREGATOR` and `OBSERVABILITY_STACK`; and it is named instead as the home for the **deferred** half, with a trigger. **G1 opened N-022** — the doctrine N-021 enforces is **stated in no file**, the map having attributed it to two `CLAUDE.md` files that do not contain it, so the guard would be a gate with no stated rule. **Invariant: 6 open + 16 resolved = 22 = N-022** | [x]                                                                           |
| 27/08/2026 | **N-022 · N-021** (Batch G2)                            | **The batch that closed the map's only class E node, and found its own premises false in both sittings.** **N-022 was charted on three premises and measurement falsified all three.** The doctrine is **not** stated in no file — `.claude/skills/incident/SKILL.md:35-37` states the **mutation** half verbatim and `:148` restates it, a tree the charting sweep never read; `HEALTH-PROBES.md:23` is **not** the nearest statement but roughly fifth; and the retrieval procedure is **not** unowned — `09/STEPS.md:77`, `:94` and `:157` are the staging/prod steps, and **server access has a named owner in three files**, the `<%DEPLOY_REPO%>` runbooks. **The finding that inverted the node**: `09/STEPS.md:96` carries a `general-purpose` **dispatch marker** on _Step 4 — Query Loki in Grafana (staging / prod only)_, so the repository does not merely fail to state the doctrine — **it explicitly dispatches Claude to query production observability**. The converse is written down; the rule is not. **Settled: the line falls at the connection, not the mutation**, on this map's own standing preference that a rule composition walks around is false green — and the capability it revokes (`incident/SKILL.md:86`'s read-only grant) is one the repository **cannot exercise today anyway**, no procedure for reaching Grafana existing. **Q16 was forced by measurement, not chosen**: _"Claude does not connect to servers"_ is **already false**, 16 of the 84 `allow` entries opening outbound connections and `Bash(gh run view:*)` at `:80` being **pre-approved remote log retrieval**. **N-021 then split the two layers** — `deny` for the bare verbs, where absoluteness is the point; the hook for `bash -c` and the unsupported wrappers, which no prefix rule can see — **and rejected the one precedent that looked decisive**: `template-docs-readonly.sh:16-18` chose a hook _because_ a deny would bind `syntek-base` too, and that asymmetry **does not exist here**, so the same property argues the other way. **Q22 resolved a live three-way contradiction rather than adding to it**: `23-INCIDENTS/CLAUDE.md:33-37` bans log excerpts outright, `21-BUGS/` states **no policy at all**, `09/CLAUDE.md:42-43` bans secrets and PII with **nothing enforcing it** — settled **strict everywhere**, the only answer needing no pattern list, no detector and no gate. **A shipped claim was found false and fixed in scope**: `.claude/CONTEXT.md:13` calls `settings.local.json` gitignored; the repo's `.gitignore` **has no rule for it**. **The measurement's own failure mode is the new lesson**: five verifiers returned **67 refutations**, the sharpest being that legs **re-opened N-001, N-012, N-013 and N-020** and recommended answers contradicting the settled ones — a measurement agent handed a settled map will re-open it unless told which rows are closed. **Invariant: 4 open + 18 resolved = 22 = N-022**               | [x]                                                                           |
| 27/08/2026 | **N-004 · N-008** (Batch C)                             | **Sent to widen a guard, and found the guard was false green.** **One of `doctrine-drift.sh`'s three claims can never fire**: `api-success-data-wrap` is anchored `^[[:space:]]*"data"` against a corpus whose every line is `path:line:text`, so the `^` always meets a file path — **proven by positive control**, the corpus form returning 0 and the bare line 1, while `:340` prints `✓ All 3 claim(s) have exactly one home.` **A third of the table has guarded nothing since it was written**, and `--help:128` promises _"Run every clause over fixtures"_ where `EXPECTED` at `:244` names **two of three**, which is how it survived. **Batch F's carve-out was found to rest on a misreading and is not inherited**: F split workflow shape out because _"doctrine-drift.sh's stated rule is the JSON envelope"_, and `:131` states it as `DOCUMENTATION-PAIRING.md — route, don't restate`, so **all four conditional rows sit inside the stated rule**. F's outcome stands; its reason does not. **Row C's gate exists and is blind where it matters**: `sync-trees.sh` decides the elision question explicitly at `:29-31` and is wired pre-commit, but `ROW` at `:145` anchors depth 1, so `code/docs/discoverability/` and `code/src/scripts/dependencies/` sit on disk, absent from `code/CONTEXT.md`, while `--check` reports clean — **one leg called the row discharged on this evidence and another leg's verifier caught it**, the hand check confirming the verifier. **The batch's own grouping premise was false**: N-008 could not get a trigger _"for free"_ from the guard, because all three clauses are presence/absence tests with **no time dimension**; the batch held on shared evidence instead. **Q25 was forced against this sitting's first instinct** — prose-on today yields **3 findings, all false**, the third being the owner file's own denial of the banned shape — so the citation exemption ships in the same change or prose does not ship at all. **Q29 stopped this map re-charting another map's node**: the `_tasks` contradiction is already `N-026` on `MAP-GATE-PARITY.md:267`, so this row is the **guard** that keeps that **fix** fixed, and ships red until it lands. **Four map literals corrected**, including N-008's _"twelve files"_ → **36**. **Three fog entries cleared**, two answered outright and one narrowed rather than deleted. **Invariant: 2 open + 20 resolved = 22 = N-022**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | [x]                                                                           |
| 28/08/2026 | **N-009 · N-010** (Batch D) · **N-023 · N-024 charted** | **The last charted batch closed, and the frontier refilled in the same sitting.** **N-009's own proposed glob was executed and rejected**: narrowing `.copier/*` to `.copier/migrations/*` admits the `handoffs/` tree and yields **37 findings, not one of them a defect**, because a handoff is entitled to cite the maps and stories it hands over. The settled shape instead mirrors `copier.yml:116-133` in a single fall-through arm for `*/CONTEXT.md`, `*/CLAUDE.md` and `*TEMPLATE*` — **982 files read, 67 exempt, exactly 1 finding**, and that finding (`research/CLAUDE.md:26` citing the non-shipping `LICENSE`) is genuine. **N-010 resolved by relocation rather than exception** — the `## Map index` table leaves a shipped file, so the instruction and the citation rule can both be obeyed — and Sam's Q33 redirect fixed the wider policy: **nothing under `project-management/src/NN-*/` is deleted**, indexes are added where warranted. Q35–Q38 answered and **graduated to `MAP-REGISTER-INDEXES.md`**. **Three more of this map's literals corrected** (seven exemption arms not four; 36 derived paths not 40; the index conflict resolvable, not unresolvable).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | **Yes — 2 opened.** N-023 and N-024 arrived from Sam mid-sitting; **Batch H** |
| 28/08/2026 | **N-023 · N-024** (Batch H)                             | **The batch that was charted and settled the same day, and proved both its guards wrong before building either.** **N-023: a `PreToolUse` hook cannot see which skill is running** — the payload carries `session_id` and no active-skill field — so `template-docs-readonly.sh`'s path-keyed pattern does not transfer, and enforcement falls to a prose duty, a `CHECKLIST.md` line and a `doctrine-drift.sh` clause **blocked on N-004's unbuilt widening**. RESOLVE writes **the map only**; `SKILL.md:135` and `STEPS.md:172-174` are reversed, and the graduation table becomes a pointer to the four downstream workflows that already own each destination. **N-024: the rule was never homeless** — `project-management/src/CLAUDE.md:26-29` owns it and enumerates `04`–`13`, leaving eleven registers to 48 folder restatements. The owner widens; folders keep the template's **name** and drop the **rule**; the `18-TESTS` pair is renamed, which **deletes two `NAMED_SHIPPED` entries** rather than moving them. **Q45 settled where such a guard is tested** — fixtures plus `shipped-artefacts.sh`, because the strong seven hold **zero instances here** and a real-tree gate would pass vacuously.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | **Yes — to empty.** 0 open · 24 resolved                                      |

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
- [x] **Every slice has a flag manifest** — nine slices; **seven** read `N/A`, S-07 carries `GDPR · Backend · Logging` and S-08 carries `GDPR`, each stated as such
- [ ] Index row in `CONTEXT.md` current — **deliberately not added; N-010 settled 28/08/2026 that the table relocates out of the shipped file first, and `MAP-REGISTER-INDEXES.md` carries that work**

**No story is cut until the frontier is empty** — Sam, 27/08/2026, displacing the line this
paragraph used to carry. Nothing gates a story technically; the decision is that a map resolved in
full cuts better slices than one cut batch by batch, because a later node can still redraw an
earlier one's boundary. **All nine settled batches are the evidence, and the last two are the
strongest** — E moved work out of S-01 into two new slices; A found N-016 had **shrunk under a
parallel session and grown back by one** between charting and settlement; F found N-014's
population was **52 instances across two file types, not 30 across one**, and discharged a row from
N-004 in another batch entirely; **D executed its own charted glob and rejected it**; and **H
arrived after every other batch had closed**, which a story cut at the end of D would not have
carried. Any of them would have forced a rewrite of a story already written.
**Every batch is closed and the frontier is empty.** G2 settled the doctrine's home, the retrieval
procedure's owner and the two-layer block on Claude reaching a server; C settled the guard's
widening, its four conditional rows and the coverage-floor trigger; **D settled what a shipped file
may cite and how the index-row conflict resolves** — and its own recommendation was the thing it
refuted; **H settled what a wayfinder session may write and which file owns the template rule**,
charted and closed the same day. **`02-story-creation` is unblocked**, for the first time since the
map was charted on 21/08/2026.

> **One box stays unticked, and it does not gate.** The index row waits on the `## Map index`
> table leaving a shipped file — N-010's settled resolution, and the work is
> `MAP-REGISTER-INDEXES.md` **N-001**. Ticking it here would require writing the very citation
> `audits/doc-references.sh` forbids, so it stays open **on the record** rather than being
> satisfied wrongly. Nothing on this map's own frontier waits on it.

**Node-count invariant: 0 open + 24 resolved = 24 = N-024** — **resolved at `7a82095`** across
ten sittings. E settled N-001, N-012 and N-013 and opened N-020 and N-021; A settled N-002,
N-007, N-016, N-017, N-019 and its rider; B settled N-003, N-005, N-006 and N-018; F settled
N-014 and N-015; G1 settled N-020 and opened N-022; G2 settled N-022 then N-021; **C settled
N-004 and N-008; D settled N-009 and N-010 and opened N-023 and N-024; H settled both**. A, B, F,
G2, C and H opened nothing; **E, G1 and D each opened as they settled** — E and G1 because their
charted size proved wrong, **D because Sam raised two new rules mid-sitting, which is a different
cause and worth distinguishing**. Per class: the two
remaining are **class D**, which is the thesis this map was charted on. **Every defect class this map
charted is closed** — the one class **A** (N-012), the one class **B** (the rider), the one class
**E** (N-021, settled by G2), and no class **C** was ever charted. **N-004's closure retires the
map's own guard question**, which every other class **D** node had been routing its enforcement
to. What remains is the map's own thesis and nothing else: **N-023 and N-024 are both class D**,
and each is a rule whose statement exists but sits in the wrong file or at the wrong scope — the
same defect the map opened on, found one tree further in.

> **N-004 carried four conditional rows into Batch C, which settled it on 27/08/2026.** Source-file length
> (waits on N-003 — **supplied**), `_tasks` doctrine (from N-019, needing no prior spelling), the
> `CONTEXT.md` tree gate (from N-016), and the step-level `Model:` marker (from N-006). **A fifth
> — the workflow terminal-section shape — was discharged by Batch F rather than inherited**, which
> is the one outcome the ordering did not anticipate: F was sequenced before C precisely because
> that row waited on N-015, and settling N-015 removed the row instead of filling it. All four
> remaining rows are unblocked, which is why C is takeable now and why settling it late was still
> right: the guard's scope was growing while the rules it must assert were being written.
