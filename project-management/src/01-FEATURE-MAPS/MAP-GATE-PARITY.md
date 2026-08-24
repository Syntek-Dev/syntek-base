# MAP-GATE-PARITY — a gate authored here must mean the same thing downstream

**Charted**: 24/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `cee3bbc` (`v7.4.1-2`) · **Research resolved at**: `b82bed7` (24/08/2026)
**Status**: Resolving
**Frontier open**: 14 · **Blocking open**: 5 · **Resolved**: 3

> Charted from `handoffs/HANDOFF-GENERATED-PROJECT-CI-FAILURES-24-08-2026.md` and the
> measurements in `research/GENERATED-PROJECT-GATE-PARITY.md`, whose **Addendum** carries the
> three resolved research nodes. Every count below was taken from a probe generated from
> `cee3bbc` — never from the handoff's own figures, three of which were incomplete.

---

## Destination

**Every gate syntek-base ships passes in a project generated from it**, proven by CI running
those gates inside a generated tree, with the rule that keeps it true written where gates are
authored.

Four live projects came back from the `v2.3.1 → v7.4.1` update with eight identical CI failures
each. The measured cause is single: **a gate authored here measures the template, and the
template is not what ships.**

---

## Notes

| Field                    | Value                                                                                     |
| ------------------------ | ----------------------------------------------------------------------------------------- |
| Domain                   | Template integrity — the copier seam, the shipped audits, and the CI over both            |
| Skills to load           | `cicd` · `runbook` · `doc-writer` · `grill-with-docs` · `version` then `git`              |
| Standing preferences     | See below — four already-settled constraints bound this work                              |
| Umbrella ADRs            | None yet; `N-008` is the candidate                                                        |
| Register entries triaged | 0 closes · 0 blocks · 1 unrelated (3 standing limitations exempt)                         |
| Cross-map                | `N-019 on MAP-RULE-OWNERSHIP` — charted over the same copier seam; referenced, not merged |

**Standing preferences — settled before this map and not reopened by it:**

- **`GATE-REPORTING.md` Section 1** — "could not look" is never reported as "looked, and it was
  clean". Every node here answers to it.
- **`FORWARD-VOICE.md` Section 1** — a dangling citation's default disposition is deletion or
  correction, never a marker. The gate-side counterpart (`N-008`) inherits that default.
- **The single-mechanism rule** — a surface is gated by a templated `_exclude` entry and nothing
  else. **Measured 24/08/2026: no shipped file carries an `INCLUDE_` conditional**, so the
  byte-identity assertion in `audit-template.yml` survives any widening of the matrix.
- **Seed-once** — `README.md`, the four version files, `.claude/MEMORY.md`, the two registers and
  the scale map are excluded and re-seeded, gated `when: _copier_operation == 'copy'`.
  `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` states the corollary; this map does not reopen it.

**No index row in `CONTEXT.md`, deliberately.** `copier.yml` excludes
`/project-management/src/**` and negates `**/CONTEXT.md`, so the map index **ships**. A row here
naming a syntek-base map would arrive in every generated project pointing at a file that is not
there — the Batch C inheritance leak this map exists to close. All eight other maps here are
unindexed for the same reason. The conflict with the wayfinder gate checklist is in fog of war.

---

## Register claimed

Every open entry triaged. **Nothing here edits `GAPS.md` or `DEFERRED.md`.**

| Register      | Entry                                              | Verdict   | Retired by |
| ------------- | -------------------------------------------------- | --------- | ---------- |
| `GAPS.md`     | 22/08/2026 — `main` has never received this branch | unrelated | its own PR |
| `GAPS.md`     | SL-1, SL-2, SL-3                                   | exempt    | —          |
| `DEFERRED.md` | _(no rows)_                                        | —         | —          |

**This feature closes nothing, and that is itself a finding.** All five defects were carried by
four consecutive handoffs and never written to `GAPS.md`, whose own Format section says new items
are recorded there **first** and charted afterwards. The map is being cut from a handoff rather
than from the register — the failure mode `GAPS.md` warns about, one level up.

**SL-1 is the closest thing to a prior claim** and is not one: it already states that
`audit-template.yml` is "the only thing here that exercises a project rather than a template".
That sentence is true and insufficient — the job exercises a project's **structure** and never
runs its gates, which is the whole of `N-007`.

---

## Resolved decisions

Detail lives in the research note's **Addendum**, not here.

| Node    | Decision                                                     | Type     | Settled    | Became                                              |
| ------- | ------------------------------------------------------------ | -------- | ---------- | --------------------------------------------------- |
| `N-001` | The excluded-path population: 8 broken sites, 3 scripts      | research | 24/08/2026 | `research/GENERATED-PROJECT-GATE-PARITY.md` → N-001 |
| `N-002` | The token-blind population: 3 tools, 1 live, 1 latent        | research | 24/08/2026 | `research/GENERATED-PROJECT-GATE-PARITY.md` → N-002 |
| `N-003` | Preserving symlinks breaks no assertion, buys one blind spot | research | 24/08/2026 | `research/GENERATED-PROJECT-GATE-PARITY.md` → N-003 |

**What the three changed, in one line each:**

- **`N-001`** — `sync-trees.sh` is a third broken script and it **blocks a pre-commit** in every
  generated project, which reorders priority away from the two red badges. `N-006` widens
  accordingly, and `N-014`, `N-016` and `N-017` are new nodes it surfaced.
- **`N-002`** — only three commands are render-sensitive, so `N-007` is far cheaper than charted;
  `prettier` joins the blind population latently, which is what `N-008` must write the rule for.
- **`N-003`** — `N-004` is not blocked by assertion damage (there is none) but must price a
  dangling link that no gate can see; `N-015` is the new node for it.

---

## Slices

The buildable slices. **Flags are a manifest, not a design**; this epic touches no product
surface, so DB / API / GDPR / SEO / Brand / Components / Wireframes / User Flow are `N/A`
throughout and omitted.

| Slice  | Story   | Title                                  | Flags                                                                                                      |
| ------ | ------- | -------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `S-01` | `US###` | Vendored-skill parity across the seam  | Backend: no · QA: generation probe, both matrices · Nodes: N-004, N-009, N-010, N-015                      |
| `S-02` | `US###` | Render-time formatting                 | Backend: no · QA: generation probe, `prettier --check`, `ruff format --check` · Nodes: N-005, N-011, N-012 |
| `S-03` | `US###` | The copier-config-reading scripts      | Backend: no · QA: audit self-tests, pre-commit probe, generation probe · Nodes: N-006, N-017               |
| `S-04` | `US###` | The generated-tree parity gate         | Backend: no · QA: CI job, both matrices · Logging: CI annotations · Nodes: N-007                           |
| `S-05` | `US###` | The gate-side rule                     | Backend: no · QA: review-enforced, no script · Nodes: N-008, N-016                                         |
| `S-06` | `US###` | `.copier/README.md` instance citations | Backend: no · QA: `doc-references.sh`, `shipped-readme.sh` · Nodes: N-013                                  |
| `S-07` | `US###` | Fenced trees that promise absent paths | Backend: no · QA: `doc-references.sh`, `sync-trees.sh` pre-commit probe · Nodes: N-014                     |

`S-03` is now the **highest-priority slice**, not `S-04`: it is the only one whose defect stops
work rather than reddening a badge.

**`S-02` and `S-04` may want to be one slice.** `N-002` found that if the format pass lands, the
parity gate must run **after** it, at which point its three commands stop being a discovery
mechanism and become the regression test that the pass stayed ungated and idempotent. Recorded as
a question for `N-007`, not merged here — merging slices is a decision, not a finding.

---

## Frontier

Open decisions in dependency order. **Nine are unblocked** — the whole blocking set is takeable.

| Node    | Decision                                                                           | Type     | Blocked by | Blocking a story? |
| ------- | ---------------------------------------------------------------------------------- | -------- | ---------- | ----------------- |
| `N-004` | Vendored set: preserved symlink, or relocated so no `-L` test is needed            | grilling | none       | yes               |
| `N-005` | Where the render-time format pass runs, and whether it is ungated                  | grilling | none       | yes               |
| `N-006` | How the three copier-reading scripts get a real input downstream                   | grilling | none       | yes               |
| `N-007` | What the parity gate runs in the generated tree, and its runtime budget            | grilling | none       | yes               |
| `N-014` | The shipped root `CONTEXT.md` tree promises five paths its reader does not have    | grilling | none       | yes               |
| `N-008` | Where the gate-side rule lives, and what it says                                   | grilling | none       | no                |
| `N-016` | `pre-pr-check.sh` drops the local gate from nine checks to eight downstream        | grilling | none       | no                |
| `N-011` | `required-version` for ruff against the `uvx --from` CI invocations                | tracer   | none       | no                |
| `N-013` | The `US001.md` / `US042.md` instance citations in `.copier/README.md`              | task     | none       | no                |
| `N-009` | Can a `before`-stage migration clear the materialised directories                  | tracer   | `N-004`    | no                |
| `N-010` | The copier version floor, given preserved symlinks are unupdatable in 9.9.1–9.11.1 | task     | `N-004`    | no                |
| `N-015` | A dangling vendored link is invisible, and no workflow watches `.agents/**`        | grilling | `N-004`    | no                |
| `N-012` | `.copier-answers.yml` and Prettier — format it, ignore it, or reshape the seed     | grilling | `N-005`    | no                |
| `N-017` | `doc-references.sh --self-test` fails downstream and misdiagnoses itself           | task     | `N-006`    | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `task` (manual unblocking work)

### What each node already has behind it

- **`N-004`** — `_preserve_symlinks: true` was measured to work and to take `skill-conformance`
  12 → 0, `docs-length` 6 → 0 and Prettier −15, **breaking no existing assertion** (`N-003`). Two
  costs to price: it **crashes `copier update`** on a project holding real directories
  (`AssertionError`, `copier/_main.py:578`, reproduced), and it makes a dangling link invisible
  (`N-015`).
- **`N-005`** — a single post-render `prettier --write .` then `ruff format .` was measured to
  take 51 Prettier failures, 204 markdownlint errors and 2 ruff failures to zero. The decision is
  the **site** (a `_task`, `install.sh`, or lefthook) and the **gating** — it must be ungated, or
  every update re-breaks the same tables.
- **`N-006`** — now **three** scripts, not two, and the third stops work: `sync-trees.sh` runs in
  `lefthook.yml:76` as a blocking pre-commit and a generated project cannot commit a root-level
  change without `--no-verify`. The rendered input must carry `_exclude`, `_tasks` **and** each
  `INCLUDE_*` question's `when:` — `_exclude` alone closes only half the population. Three
  independent parsers of that list already exist and all three must be satisfied.
- **`N-007`** — the matrix is settled as **all-surfaces-off against all-surfaces-on**, replacing
  today's `INCLUDE_MOBILE` false/true. `N-002` narrows the job to **three render-sensitive
  commands** — `ruff format --check`, `prettier --check`, `markdownlint-cli2` — because everything
  else already fails here. Open: whether self-tests are in scope, and the ordering against
  `N-005`.
- **`N-008`** — the rule is already de facto: nine guarded sites use `[ -f copier.yml ]` as a
  template/project discriminator and the three broken scripts read it for **data** without testing
  for it. `dependency-drift.sh` carries the case-(c) antidote in this repository's own voice.
- **`N-014`** — the five paths `sync-trees.sh` complains about are listed in the shipped root
  `CONTEXT.md` **directory tree**, inside a fence. `doc-references.sh` tests backticked tokens
  only, so it **structurally cannot see a fenced tree block**; line 129 of the same file carries a
  correct `template-only` marker in prose while lines 83, 96, 97, 98 and 103 carry nothing and
  cannot. The template ships an orientation file promising five files its reader does not have.
- **`N-011`** — `N-002` supplies the evidence: the host `ruff` is 0.14.11, below both the
  `ruff>=0.16.3` constraint and the 0.16.0 release where `*.md` joined the default include. The
  constraint is a floor, not a pin, and the gate's behaviour changes across it.

---

## Fog of war

In scope, not yet sharp enough to state as a decision.

- **The 24 MD012 errors across five `TEMPLATE-GUIDE` files.** `prettier --write` fixes them, so
  `N-005` covers the symptom. Whether rendering leaves blank-line residue that will recur in new
  files is unmeasured.
- **Whether the widened matrix should assert per-surface file sets**, not only shared-file byte
  identity. `N-003` sharpened this: `diff -r` dereferences, so it cannot tell a
  symlink-to-directory from a real directory of identical content, and the byte-identity step
  discards `diff`'s stderr and its exit 2.
- **`static-analysis.sh`'s verdict keys on `len(results)`** while parse errors go to the body — the
  one place in the audit family missing the remedy `dependency-drift.sh` already implements. Same
  Section 5 shape, not token-triggered today.
- **A catch-up path for projects generated before the format task exists** — `install.sh` is the
  obvious host, and whether it should is not yet a decision.
- **The wayfinder index-row rule against the shipping negation.** Eight maps sit unindexed by
  necessity; the skill's gate checklist requires a row. One of the two needs an exception written,
  and it is not this map's to write.
- **Windows and symlink-hostile destinations are unmeasured.** `Path.symlink_to()` raises rather
  than degrading, and a failed render on a fresh `copier copy` deletes the destination. Nobody has
  run it. Folds into `N-004` if the answer is to preserve.

---

## Out of scope

| Ruled out                                                        | Why                                                                                                                   |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Running the update on the four live projects                     | The map owns the migration path and its ordering (`N-009`); executing it is separate work, on Sam's timing            |
| Refreshing the four projects' accumulated `README.md` drift      | A freshly generated README is correct — measured. This is three majors of per-project drift, fixed by hand once       |
| Absorbing `N-019 on MAP-RULE-OWNERSHIP`                          | Same seam, different question. Folding maps together is how a frontier stops being takeable; cross-referenced instead |
| `syntek-accountability`'s `DESIGN-NOTES.md` `</content>` residue | Not a template defect — transcript residue in Sam's own file, absent from the other three                             |
| Giving seed-once an escape hatch                                 | The mechanism is sound; only accumulated drift is at issue, and that is not a mechanism problem                       |

---

## Session log

| Date       | Node settled            | Outcome                                                                                   | Frontier redrawn |
| ---------- | ----------------------- | ----------------------------------------------------------------------------------------- | ---------------- |
| 24/08/2026 | —                       | Charted: destination pinned, 13 nodes, 6 unblocked, register triaged                      | [x]              |
| 24/08/2026 | `N-001` `N-002` `N-003` | All three research nodes settled; 4 new nodes added; every blocking node is now unblocked | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — 5 open, all unblocked
- [x] Every resolved node links to the artefact it became
- [x] **Every slice has a flag manifest**
- [ ] Index row in `CONTEXT.md` current — **deliberately absent**; see Notes

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
