# MAP-GATE-PARITY — a gate authored here must mean the same thing downstream

**Charted**: 24/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `cee3bbc` (`v7.4.1-2`) · **Research resolved at**: `b82bed7` (24/08/2026)
**Vendored-seam batch resolved at**: `7a82095` (27/08/2026)
**Copier-reader batch resolved at**: `7a82095` (27/08/2026)
**Render/format/parity batch resolved at**: `7a82095` (27/08/2026)
**Citation-cluster batch resolved at**: `7a82095` (28/08/2026)
**Reports-pair batch resolved at**: `7a82095` (28/08/2026)
**False-claims batch resolved at**: `7a82095` (28/08/2026)
**Gate-honesty batch resolved at**: `7a82095` (28/08/2026)
**Manifest-integrity batch resolved at**: `7a82095` (28/08/2026)
**Gate-visibility batch resolved at**: `7a82095` (28/08/2026)
**Final batch resolved at**: `7a82095` (28/08/2026)
**Status**: **Frontier and fog both closed** — fog dispositioned 01/09/2026 (1 answered, 2 cleared)
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 31 · **Moot**: 2

> Charted from `handoffs/HANDOFF-GENERATED-PROJECT-CI-FAILURES-24-08-2026.md` and the
> measurements in `research/GENERATED-PROJECT-GATE-PARITY.md`, whose **Addendum** carries the
> three resolved research nodes and **Addendum II** the rendered-pole gate table.
>
> **Every figure on this map is now a measurement, not a floor (27/08/2026).** The first four
> batches reasoned from reconstructed trees because copier was believed unavailable; it is
> reachable through `uvx`, and both answer-set poles have since been rendered with
> `copier copy --trust --vcs-ref=HEAD`, exactly as `audit-template.yml:154` does it. Twelve
> figures changed and are corrected in place below. Where a number here disagrees with a
> handoff, the render wins.

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
| Umbrella ADRs            | None yet, and none authored here — ADRs are workflow `15`, after stories (`02`)           |
| Register entries triaged | 0 closes · 0 blocks · 1 unrelated (3 standing limitations exempt)                         |
| Cross-map                | `N-019 on MAP-RULE-OWNERSHIP` — charted over the same copier seam; referenced, not merged |

**Standing preferences — settled before this map and not reopened by it:**

- **`GATE-REPORTING.md` Section 1** — "could not look" is never reported as "looked, and it was
  clean". Every node here answers to it.
- **`FORWARD-VOICE.md` Section 1** — a dangling citation's default disposition is deletion or
  correction, never a marker. The gate-side counterpart (`N-008`) inherits that default.
- **The single-mechanism rule** — a surface is gated by a templated `_exclude` entry and nothing
  else. **Confirmed at the widest pair 27/08/2026**: an all-off against an all-on render differs
  in exactly **one** file (`.copier-answers.yml`), with 105 on-only files and **zero** off-only.
  **But the corollary drawn from it was false.** The rule holds; the byte-identity assertion in
  `audit-template.yml` does **not** survive widening, because its implementation compares two
  hard-coded trees outside the loop and swallows `diff`'s stderr (`:364-374`). Two leaks the rule
  does not cover are now charted as `N-021` and `N-022`.
- **Seed-once** — `README.md`, the four version files, `.claude/MEMORY.md`, the two registers and
  the scale map are excluded and re-seeded, gated `when: _copier_operation == 'copy'`.
  `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` states the corollary; this map does not reopen it.

**Accepted property (27/08/2026, `N-004`).** A generated project carries the vendored bytes
**twice** — at `.agents/skills/` and as the dereferenced real directories at
`.claude/skills/cloudinary-*`. Confirmed by render: **zero symlinks survive in either pole**
against three in the template. Consciously accepted, because the only alternative that removes it
makes the template and generated topologies deliberately different, which is the defect class this
map exists to close.

**The acceptance is conditional on `S-05`, which the charting understated.** "Both copies are
gate-exempt" is **not true today** — the dereferenced set draws **33 findings across three gates**
in each pole (`skill-conformance` 12, `docs-length` 6, `prettier` 15) until `S-05`'s three edits
land. And "neither is edited" only holds once the format pass carries its `.prettierignore` entry:
without it the pass rewrites the 15 `.claude/skills/cloudinary-*` files and forks them from their
`.agents/` twins, breaking the very bijection `N-015` asserts.

**No index row in `CONTEXT.md`, deliberately.** `copier.yml` excludes
`/project-management/src/**` and negates `**/CONTEXT.md`, so the map index **ships**. A row here
naming a syntek-base map would arrive in every generated project pointing at a file that is not
there — the Batch C inheritance leak this map exists to close. **All twelve other maps here are
unindexed for the same reason** (re-measured 01/09/2026; "eight" was correct when written and two
more maps have since been charted). The conflict with the wayfinder gate checklist was fog and is
**cleared** — `MAP-RULE-OWNERSHIP` N-010 resolved it by relocation, and the three shipped files
still carrying the old instruction are a `GAPS.md` entry of 01/09/2026, not this map's residue.

---

## Register claimed

Every open entry triaged. **Nothing here edits `GAPS.md` or `DEFERRED.md`.**

**Re-triaged 01/09/2026** during the fog pass, because the 24/08 triage had expired: the
`22/08/2026 — main has never received this branch` entry it verdicted is **gone from the register**,
and six entries have arrived since. **Nothing is claimed and nothing blocks.**

| Register      | Entry                                                             | Verdict       | Retired by                                                                     |
| ------------- | ----------------------------------------------------------------- | ------------- | ------------------------------------------------------------------------------ |
| `GAPS.md`     | 31/08/2026 — the PE gate's markup half / the prefix set           | **unrelated** | `MAP-PROGRESSIVE-ENHANCEMENT`                                                  |
| `GAPS.md`     | 31/08/2026 — htmx pinned at major 2                               | **unrelated** | `MAP-ABSENCE` `S-03`                                                           |
| `GAPS.md`     | 01/09/2026 — a RUSTSEC advisory against an unchanged `Cargo.lock` | **unrelated** | Its own fix; a gate-coverage gap                                               |
| `GAPS.md`     | 01/09/2026 — staging and production have no mail backend          | **unrelated** | A settings decision, not a gate                                                |
| `GAPS.md`     | 01/09/2026 — the story `**Status:**` header's two vocabularies    | **unrelated** | Story lifecycle, not the seam                                                  |
| `GAPS.md`     | 01/09/2026 — the index-row instruction in three shipped files     | **unrelated** | **Written by this map's own fog pass**; owned by `MAP-REGISTER-INDEXES` `S-01` |
| `GAPS.md`     | _Still open, found on the way_ — 3 loose items                    | **unrelated** | None touches the copier seam                                                   |
| `GAPS.md`     | SL-1, SL-2, SL-3                                                  | **exempt**    | Standing limitations take no verdict                                           |
| `DEFERRED.md` | _(no rows)_                                                       | —             | —                                                                              |

**The last row is a creation, not a claim.** This map's fog pass surfaced it and wrote it to
`GAPS.md`; the work that retires it sits on another map's slice. Creating an entry is not claiming
one, and this map promises nothing about it.

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

| Node    | Decision                                                                                                             | Type     | Settled    | Became                                                          |
| ------- | -------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | --------------------------------------------------------------- |
| `N-001` | The excluded-path population: 8 broken sites, 3 scripts                                                              | research | 24/08/2026 | `research/GENERATED-PROJECT-GATE-PARITY.md` → N-001             |
| `N-002` | The token-blind population: 3 tools, 1 live, 1 latent                                                                | research | 24/08/2026 | `research/GENERATED-PROJECT-GATE-PARITY.md` → N-002             |
| `N-003` | Preserving symlinks breaks no assertion, buys one blind spot                                                         | research | 24/08/2026 | `research/GENERATED-PROJECT-GATE-PARITY.md` → N-003             |
| `N-004` | Neither horn: the gate changes shape, the tree does not                                                              | grilling | 27/08/2026 | `S-05` slice row; ADR at workflow `15`                          |
| `N-015` | `skill-conformance` asserts an `.agents/` ↔ `.claude/skills/` bijection                                              | grilling | 27/08/2026 | `S-05` acceptance criterion                                     |
| `N-010` | Pin copier exactly at both live sites; raise the declared floor                                                      | build    | 27/08/2026 | `S-05` — two edit sites named below                             |
| `N-006` | Per-script guard, three different behaviours — not one manifest                                                      | grilling | 27/08/2026 | `S-03` slice row; idiom half to `N-008`                         |
| `N-017` | **Widened** to "self-tests that fail downstream" — two scripts, not one                                              | build    | 27/08/2026 | `S-03` acceptance criteria                                      |
| `N-009` | **Moot** — no topology change, so no migration to design                                                             | tracer   | 27/08/2026 | Retired unbuilt; reason recorded below                          |
| `N-005` | Copy-gated `_task` + an unversioned `after` migration; pass converges                                                | grilling | 27/08/2026 | `S-08` slice row; ADR at workflow `15`                          |
| `N-007` | A separate workflow, full audit family + self-tests, both poles                                                      | grilling | 27/08/2026 | `S-08` slice row; ADR at workflow `15`                          |
| `N-011` | Convert the two bare host sites to the `uvx --from` idiom                                                            | tracer   | 27/08/2026 | `S-08` acceptance criterion                                     |
| `N-012` | Ignore the answers file — "format it" is impossible, not merely awkward                                              | grilling | 27/08/2026 | `S-08` acceptance criterion; blocker edge struck                |
| `N-019` | An explicit `lefthook install` in `install.sh`, keeping the guard                                                    | build    | 27/08/2026 | `S-03` acceptance criterion                                     |
| `N-014` | Backtick **and** annotate the five root rows — both gates then see them                                              | grilling | 28/08/2026 | `S-07` slice row; acceptance criteria                           |
| `N-023` | A third `FORWARD-VOICE.md` direction — absent in both trees until a named command runs                               | grilling | 28/08/2026 | `S-07` slice row; the `:637` fix rides with it                  |
| `N-008` | **Splits into two rules** — tree-assumption, and `GATE-REPORTING` completeness                                       | grilling | 28/08/2026 | `S-05` slice row; ADR at workflow `15`                          |
| `N-031` | Make the path exist — glob the root rule, track a nested `.gitignore` admitting the pair                             | build    | 28/08/2026 | `S-07` acceptance criterion; edit sites below                   |
| `N-032` | **Must** carry a `CLAUDE.md`; the exemption goes and the class splits                                                | grilling | 28/08/2026 | `S-09` slice row; `S-07` gains eight further `.gitignore` edits |
| `N-013` | Reword `:559` so the examples read as examples — the existing naming-row guard then covers them                      | build    | 28/08/2026 | `S-07` acceptance criterion (from retired `S-06`)               |
| `N-026` | Correct all four toward `06-GENERATION.md:140`'s own wording                                                         | build    | 28/08/2026 | `S-08` acceptance criterion — forced by `N-005`                 |
| `N-027` | **Moot** — `N-019` makes the claim true rather than needing correction                                               | build    | 28/08/2026 | Retired unbuilt; `S-03` acceptance criterion                    |
| `N-024` | Read the report line, state the ignore count, fail closed when it hits zero                                          | build    | 28/08/2026 | `S-10` slice row; acceptance criteria                           |
| `N-029` | A `--self-test` step in each gate's existing workflow, matching `audit-conflict-markers.yml:43`                      | build    | 28/08/2026 | `S-10` acceptance criterion                                     |
| `N-033` | `static-analysis.sh:398` counts `len(results)` while `:395` sends errors to the body — same principle, own mechanics | build    | 28/08/2026 | `S-10` acceptance criterion; graduated from fog of war          |
| `N-018` | Recompute as **our** digest over all 15 files, stated basis, asserted in `skill-conformance.sh`                      | build    | 28/08/2026 | `S-05` acceptance criterion                                     |
| `N-022` | **Defect** — exclude `pnpm-lock.yaml` and regenerate at generation, as `uv.lock` already is                          | grilling | 28/08/2026 | `S-08` acceptance criterion; rule to `S-05`                     |
| `N-016` | The downstream gate **runs `audits`** — Scope 1's 21, via a declared template-mode branch                            | grilling | 28/08/2026 | `S-05` acceptance criterion                                     |
| `N-020` | Fix both sites; add a fenced-block clause to `check-template-tokens.sh`'s existing scan                              | grilling | 28/08/2026 | `S-10` acceptance criterion                                     |
| `N-025` | Widen `format.sh` to prettier's full set — json, jsonc, yaml, yml, html                                              | grilling | 28/08/2026 | `S-08` acceptance criterion                                     |
| `N-028` | Widen the residue discriminator — backticked content is a quotation, not a leak                                      | grilling | 28/08/2026 | `S-10` acceptance criterion                                     |
| `N-021` | The **bare** directory form, matching the three surface flags — `/**` prunes, bare removes                           | build    | 28/08/2026 | `S-08` acceptance criterion                                     |
| `N-030` | Tiered `timeout-minutes` from measured CI p95s, swept now at an interim 30; enforced by a shipping `run:` step       | build    | 28/08/2026 | `S-08` acceptance criterion                                     |

**What the three changed, in one line each:**

- **`N-001`** — `sync-trees.sh` is a third broken script and it **blocks a pre-commit** in every
  generated project, which reorders priority away from the two red badges. `N-006` widens
  accordingly, and `N-014`, `N-016` and `N-017` are new nodes it surfaced.
- **`N-002`** — only three commands are render-sensitive, so `N-007` is far cheaper than charted;
  `prettier` joins the blind population latently, which is what `N-008` must write the rule for.
- **`N-003`** — `N-004` is not blocked by assertion damage (there is none) but must price a
  dangling link that no gate can see; `N-015` is the new node for it.

**What the vendored-seam batch changed (27/08/2026), in one line each:**

- **`N-004`** — the charted horns were a false pair. `is_vendored()` at
  `skill-conformance.sh:363` is the **only `-L` test in the repository** (119 tracked `.sh`,
  all `.py`, all `.yml`); the other three gate families already exempt the vendored set by
  **path prefix**. The gate changes shape, the tree does not: `.agents/` stays, the three
  symlinks stay, copier keeps dereferencing, and `_preserve_symlinks` is never set. Three edit
  sites — `skill-conformance.sh`, `docs-length.sh:368`, `.prettierignore`; markdownlint is
  already covered by `!.claude/**`.
- **`N-015`** — as charted it was **counterfactual**: with `_preserve_symlinks` off no link
  exists downstream to dangle, and with it on `.agents/` still ships so both ends travel. The
  real defect is that the invisibility is **pre-existing and total in syntek-base itself** —
  `VENDORED_COUNT` is printed, never asserted, and a wholly absent vendored set reports
  "✓ Every skill conforms" at exit 0. Closed by asserting the bijection, not by moving files.
- **`N-010`** — no copier pin exists anywhere; both live invocations are bare `uvx copier`
  resolving to whatever PyPI serves. The reproduced `AssertionError` is specific to **9.17.2**
  (9.17.0 and 9.17.1 carry unrelated code at that line), and never fires once symlinks are not
  preserved. Pin exactly; the `9.6.0` floor is a minimum, not a pin.
- **`N-009`** — retired unbuilt. It asked whether a `before`-stage migration could clear the
  materialised directories; with no topology change there is nothing to clear.

**What the render/format/parity batch changed (27/08/2026), in one line each:**

- **`N-005`** — **feasibility settled, siting decided.** The pass converges: `prettier --write .`
  then `ruff format .` takes markdownlint from **222 findings in 32 files to 0** on a rendered
  pole, and `prettier --check` then exits 0, so it is idempotent and markdownlint needs no fix
  pass of its own. The charted "51/204/2" was a `cee3bbc` reconstruction; the real numbers are
  **52/222/2 off-pole, 53/223/2 on-pole**. Site: a **copy-gated `_task` plus an unversioned
  `after`-stage migration** for update — the only shape where each operation formats the tree the
  developer actually keeps, exactly once. Ruled out by measurement: `install.sh` (never runs on
  update), a naked `_task` (silently installs 565 packages and rewrites the committed
  `pnpm-lock.yaml` before the initial commit), and `syntax/format.sh` (needs the django container,
  and its Prettier glob carries no yml). The pass must invoke a **≥0.16 ruff** or it silently
  skips every `.md` and appears to succeed while CI stays red.
- **`N-007`** — **a separate workflow**, not a widening of `audit-template.yml`, because that
  file's own `${{` ban forbids `strategy.matrix` and forces seven duplicated shell loop bodies.
  It runs the **full 24-audit family and all 9 self-tests** on both poles — ~175s per pole, a
  6–8 minute job — in a **throwaway copy per invocation**, because `security.sh` writes a 540 MB
  `.venv` into the tree it audits. `timeout-minutes` is declared, the repository's first.
  Byte-identity moves to **one designated reference pole**, and the stderr swallow is fixed
  regardless. **Phased in**: the format legs land green with `S-08`; the audit legs join as `S-03`
  and `S-05` land, because the family opens at 88 findings off-pole and 46 on. The five
  structurally-null audits on a fresh project are **accepted** and declared, not papered over
  with a seeded app.
- **`N-011`** — the seam is three mechanisms reaching three live versions at once. Settled the
  narrow way: convert the **two bare host sites** (`check-format.sh:14`, `check-lint.sh:16`) to
  the `uvx --from` idiom every other site already uses. `required-version` is **not** adopted now
  — it is a hard exit-2 stop that would crash the drift checks one-sidedly until the host is
  upgraded. The measured stake: `ruff format --check` at the host's 0.14.11 reports "69 files" and
  **passes**; at the CI-constrained 0.16.4 it sees 837 and **fails 2**.
- **`N-012`** — **"format it" is impossible, not merely awkward** — proven end to end: copier
  rewrites the answers file unconditionally (`_main.py:512`) and excludes it from the update
  patch, so a formatted file re-reddens on the next update. Settled to **ignore it** — one
  `.prettierignore` line — over reshaping the seed, because `to_nice_yaml(indent=2)` only holds
  while no answer wraps at PyYAML's 80 columns and nothing enforces that. **Its `N-005` blocker
  edge was measurably false and is struck**; the node was takeable all along.
- **`N-019`** — **confirmed for generation, refuted for the lifecycle.** The hooks are absent at
  generation, then armed by pnpm's `prepare` on the first non-suppressed install — so the hazard
  is _timing_, not impossibility, and an armed hook plus `sync-trees` blocks the first commit at
  an unpredictable moment. Settled: an **explicit `lefthook install` step in `install.sh`**,
  keeping `--ignore-scripts` on all three `install-frontend.sh` branches, because that flag is a
  deliberate supply-chain control and a `_task` would arm the hook before the toolchain that
  satisfies it exists.

**What the citation-cluster batch changed (28/08/2026), in one line each:**

- **`N-014`** — settled **backtick _and_ annotate** the five root `CONTEXT.md` tree rows: both
  gates then see them and no new mechanism is introduced. It must be argued as the tree idiom's
  **correction**, not as a marker, or the map's standing `FORWARD-VOICE.md` preference reopens —
  and that argument belongs in the story, not here.
- **`N-023`** — settled as a **third direction in `FORWARD-VOICE.md`**: "absent in both trees until
  a named command runs", distinct from both the instance-citation class (`N-013`) and the
  fenced-tree class (`N-014`). Its `tests/reports` half is dissolved by `N-031`; the class residue
  is the `doc-references.sh:637` trailing-slash strip, which rides with `S-07`.
- **`N-008`** — **splits into two rules**: a tree-assumption rule (the discriminator idiom, the
  unguarded copier reads, the premise clause) and a `GATE-REPORTING.md` completeness half (the
  homeless families, the Section 1 widening). Rule 1 names rule 2 for expression. The idiom is
  **one family-agnostic declaration plus a shared `_lib/template-tree.sh`** — roughly 24 source
  lines across 28 core scripts, generalising `dependency-drift.sh`'s record-at-read / denominator /
  refusal shape. Whether the split earns a second node ID is deliberately left unsplit: node IDs
  are stable identifiers here.
- **`N-031`** — **make the path exist rather than suppress the question.** Root `.gitignore:50`
  excludes `code/src/scripts/tests/reports/` in _directory form_, so the nested `.gitignore` is
  never read, `git add -A` stages nothing, and no root-level `!` negation can re-include it. Four
  of the seven force-added files already **are** the proposed pattern, sitting inert. Settled to
  the glob form (`…/reports/*`, not deletion, so contents stay ignored if the nested file is lost)
  plus a tracked nested `.gitignore`. **`!*/` is load-bearing** — without it git never descends
  into `backend/` and `backend-coverage/`. `.gitkeep` is **kept** for symmetry with the six
  siblings though strictly redundant, and the file admits **`CLAUDE.md` as well as `CONTEXT.md`**
  on Sam's call, which is what opens `N-032`. Precedent for the whole shape, `!*/` and
  `!CLAUDE.md` included: `questionnaires/.gitignore:13-20`.

**Four corrections owed to this map, measured and now applied in place:**

- **`doc-references.sh` and fenced blocks.** The map read "structurally cannot see a fenced tree
  block". Wrong inference: the script has **no fence handling at all** — zero matches for any fence
  construct — so it is blind to **unbackticked tokens anywhere**, fenced or not. Backticking makes
  them gate-visible, which is why `N-014` settles the way it does.
- **The third citation class has a verdict.** "A class `doc-references.sh` has no verdict for" was
  false. The verdict is at `doc-references.sh:704` (`*/reports/*|*/coverage/*|…`) and covers 12 of
  162 sites. It misses the shipped citations **by one character**: `:637` strips the trailing slash,
  turning `…/tests/reports/` into `…/tests/reports`, which `*/reports/*` cannot match.
  `.claude/worktrees` carries a bare-directory alternative; `reports` does not.
- **"Leaves four red" is off-pole only.** On-pole it leaves **one**, and that one is `coverage/` —
  an `N-023` instance the map nowhere recorded. Carried from the batch's own render; **not
  re-measured at this commit**, because the rendered poles were polluted by a `security.sh` `.venv`.
- **The nine `[ -f copier.yml ]` sites are two idioms, not one.** Four **ship** and stand down
  (`.claude/hooks/pre-pr-check.sh:80`, `.claude/hooks/template-docs-readonly.sh:35`,
  `lefthook.yml:137`, `:218` — `exit 0` or set a mode); five sit in **copier-excluded** trees and
  assert their input (`.github/scripts/shipped-{artefacts,memory,readme,registers}.sh` and
  `.copier/migrations/v6.0.0-rename-feature-surfaces.sh:451` — `|| die "missing $COPIER"`). The
  control flow is opposite, not merely the intent. A rule citing all nine as one precedent is
  misapplied on first use.

**What the reports-pair batch changed (28/08/2026):**

- **`N-032`** — settled in three rounds. A `code/src/scripts/**/reports/` directory **must** carry
  a `CLAUDE.md`; `docs-pairing.sh`'s blanket `is_exempt_dir()` arm is **removed** rather than
  narrowed; and `DOCUMENTATION-PAIRING.md`'s generated-output class **splits**, tracked output
  (`reports/`) taking its own rule while the untracked three — coverage output, `.expo/`,
  `node_modules/` — stay exempt as written. The nine `CLAUDE.md` files are **routing stubs over one
  shared rule** in `code/src/scripts/CLAUDE.md`, and the operating rules currently sitting in the
  eight `CONTEXT.md` files **move into them**.
- **Two facts found in the grilling that the charting had not.** The population is **nine**
  directories, not six: `code/src/scripts/reports/` is the shared output directory for four scripts
  (`syntax/check.sh:36`, `syntax/lint.sh:35`, `syntax/format.sh:34`,
  `dependencies/update.sh:42`) and is the only one of the nine with **no `CONTEXT.md` at all**. And
  **none** of the nine `reports/.gitignore` files admits a `CLAUDE.md` — every one is
  `*` / `!.gitignore` / `!.gitkeep` / `!CONTEXT.md`, so "must" costs eight `.gitignore` edits
  beyond `N-031`'s one.
- **Removing the exemption does not, by itself, surface the undocumented directory.**
  `is_exempt_from_enumeration()` at `docs-pairing.sh:235` exempts a **single-purpose leaf** — one
  tracked file at any depth — and `code/src/scripts/reports/` holds exactly one, its `.gitignore`.
  Settled to carve `reports/` out of that rule **as well as** documenting this instance, because
  fixing only the instance leaves the identical hole for the next bare `reports/` directory.
- **`S-09` is cut, and split from `S-07` by gate.** `S-07` answers to `doc-references.sh` and
  `sync-trees.sh` and takes all nine `.gitignore` edits with the root rule; `S-09` answers to
  `docs-pairing.sh` and is purely additive. **`S-07` must land first** — until the `!CLAUDE.md`
  negations exist, git cannot track the nine files — and within `S-09` the two gate edits must land
  **with** the files, never before, or `docs-pairing.sh` goes red against nine directories at once.

**What the false-claims batch changed (28/08/2026), in one line each:**

- **`N-027`** — **moot, and retired unbuilt.** The claim at `.copier/README.md:436` is that
  `install.sh` "runs `lefthook install`". `N-019` is already settled to add exactly that step, and
  `install.sh` is **not** seed-once, so the four live projects receive it by `copier update`: the
  sentence becomes true rather than needing correction. The map's reason for keeping the two apart
  — "one of them is unreachable downstream" — was about the **README**, but what the README
  describes is the **behaviour**, and that is reachable. `S-03` carries the verification.
- **`N-026`** — **four sites, not five**, and corrected toward `06-GENERATION.md:140`'s own wording
  rather than deleted, because each site carries real local information and only its blanket clause
  is wrong. It graduates to **`S-08`**, which `N-005` forces: that slice cannot cite
  `06-GENERATION.md` for its `_task` while the same file says `_tasks` never run on update. The
  sites **ship** — `copier.yml:101` says so in as many words.
- **`N-013`** — **the guard already exists and the sentence wraps out of it.**
  `doc-references.sh:558-566` sets `is_naming_row` from six patterns, two of which already carry
  from the previous line (`:550-553`); `.copier/README.md:558` holds the `###` that trips it and
  `:559` holds the examples, one line below. Adding _"e.g."_ to `:559` tells the reader they are
  examples and trips the existing guard — the same edit serves both. `US###.md` was never at risk:
  `US[0-9]{3}` does not match `###`, and Check 1 needs a slash.
- **The class fix, narrowed deliberately.** The four heuristic patterns gain the `prev` carry the
  two explicit markers already have, **for Check 2 only**. Check 1's dangling-path rule stays
  strictly per-line: a missed instance citation is a story ID that does not resolve, a missed
  dangling path is a broken repo reference, and Check 1 is the gate this map exists to protect.
  Ships with `S-07`, with a self-test probe.

**What the gate-honesty batch changed (28/08/2026):**

- **`N-024`** — **the remedy already existed in a sibling.** `.claude/hooks/lib/check-security.sh:46-48`
  pipes `pnpm audit` through a `grep -qE '[0-9]+ (low|moderate|high|critical) severity'` and sets its
  exit from the **report line**; `security.sh:165-166` sets status from the **exit code alone**. Two
  scripts, one tool, one honest. `pnpm-workspace.yaml:41-42` already demands the report-line method
  in as many words, and `GATE-REPORTING.md` §4 already bans the defect — _"a skip reaching the same
  verdict as a pass"_. This node is enforcement, not new doctrine.
- **The drift guard tolerates `reported ≤ declared`.** Strict equality was chosen, then reversed on
  evidence: **three** ignores are declared (`pnpm-workspace.yaml:69-71`) while every recorded control
  run reports `2 high (2 ignored)`, because `image-size` is reachable only through the mobile
  bundler and is **inert on a web-only render**. The file is not copier-excluded, so all three ship
  to every project regardless of surface — equality would false-red every web-only one, which is
  this map's own defect class. The guard fires only when the reported count hits **zero** against a
  non-empty list, which is the 13/08/2026 incident. Accepted cost: a partial apply passes.
- **`N-029` is smaller than charted** — both gates already run in CI
  (`audit-doc-references.yml:43`, `audit-docs-length.yml:66`). What is missing is the `--self-test`
  step the other seven carry immediately before their gate step
  (`audit-conflict-markers.yml:43`). Two lines, two existing workflows, no new job.
- **`N-033` graduated from fog of war.** The fog asked whether `security.sh` and
  `static-analysis.sh` wanted one fix or two; settled as **two fixes, one principle** — one greps a
  tool's stdout, the other counts a Python list, and a shared helper spanning both is the false
  abstraction `N-008` exists to warn against. The principle is stated once, in
  `GATE-REPORTING.md` §3's audits family row; §1 stays `N-008`'s to widen.
- **`S-10` is cut and stands alone.** It neither blocks nor is blocked. `S-08` benefits — its parity
  job reads exit codes, which is precisely what `N-024` makes trustworthy — but does not depend on it.

**What the manifest-integrity batch changed (28/08/2026):**

- **One rule covers both** — _a committed manifest must describe the tree it ships into, or be
  regenerated at generation_. It is the manifest counterpart to the single-mechanism rule in
  **Notes**, and it is written **with `N-008`'s tree-assumption rule** rather than beside it: one
  question (_what may a shipped artefact assume about its tree?_), two artefact kinds.
- **`N-022`** — **a defect, and the asymmetry is the defect.** `uv.lock` is copier-excluded and
  rewritten by a `uv lock` post-task precisely because a lock pinning the template must not travel;
  `pnpm-lock.yaml` is **not excluded** and ships as committed, naming the `code/src/mobile` importer
  (`:60`) on a web-only project. One pattern, applied to Python and not to JavaScript. The fix
  applies it, and **fixes both `|| echo` swallows in the same change** — no `_task` uses pnpm today,
  so this would be the first, and writing it in the shape of the defect `S-08` is already removing
  would create its second instance.
- **`N-018`** — the hash **becomes ours**, with a stated basis, and is asserted for the first time.
  The recorded values reproduce under none of seven bases and nothing reads them, so the choice was
  between deleting a dead field and making it the control `THIRD-PARTY-NOTICES.md:88-98` already
  implies. It covers **all 15 vendored files** as a per-skill directory digest, not the three
  `SKILL.md`s the `skillPath` field names — 12 of the 15 are `references/*.md`, which is exactly
  where an edit would otherwise go unseen. Asserted in `skill-conformance.sh`, beside `N-015`.
- **The two land in different slices, and the rule in a third place.** `N-022` → `S-08` (the
  `copier.yml` surface it edits), `N-018` → `S-05` (which already edits `skill-conformance.sh`), the
  rule → `S-05` with `N-008`. **`S-08` therefore ships the lockfile fix before the paragraph that
  generalises it exists.** Recorded here because it is chosen, not overlooked: it is the one place
  this batch accepts instance-before-class.
- **Two consequences, neither a decision.** Excluding `pnpm-lock.yaml` means `copier update` stops
  managing it, so the four live projects keep their own untouched; and a generation whose guard
  finds no pnpm leaves the project without a lockfile until the printed instruction is followed —
  the identical trade-off `uv lock` already accepts. `skills-lock.json` needs no exclusion: it
  describes `.agents/skills/**`, which ships whole, so `N-018`'s fix is what makes it satisfy the rule.

**What the gate-visibility batch changed (28/08/2026):**

- **`N-016` — the asymmetry disappears rather than narrowing.** The charting read the 9-versus-8
  split as the defect; `pre-pr-check.sh:358-369` had already restructured it into an **addition**,
  leaving `audits` as the one template-only check. Settled to run it downstream too, so **both trees
  run nine** and `audits` differs in _scope_ instead of presence. The scope is Scope 1's **21**
  audits (24 less `cloc.sh`, `security.sh` and `dependency-drift.sh`, `check-audits.sh:116`);
  Scope 2 is the `shipped-*` and `check-template-*` scripts in `.github/scripts/`, which
  `copier.yml:41` excludes, so it is structurally absent downstream. **That branch is `N-008`'s
  tree-assumption rule in first use** — a script reading which tree it is in and declaring what it
  therefore did not check — which is why both live in `S-05`.
- **`N-020` — latent, and its detection is correctly template-only.** Both sites confirmed
  (`code/docs/encryption/FIELD-ENCRYPTION.md:254`, `code/docs/rls/MIDDLEWARE-AND-NINJA.md:189`), each
  a fenced `python` block whose first identifier is a copier token. Nothing lints fenced Python
  anywhere today, so the token hides nothing yet — the trap fires the first time anyone adds such a
  linter. Both sites are fixed and the class is caught by one clause on
  `check-template-tokens.sh:135-148`, which already scans the tree for every `<%…%>`. **Its being
  copier-excluded is correct, not a parity gap**: a copier token exists only in the template, so the
  check has no downstream subject. Written down because it will otherwise be "fixed" later.
- **`N-025` — a pure coverage fix, measured at zero cost.** `format.sh:192` defaults to
  `(python javascript typescript css markdown)` and `prettier_pattern()` emits only
  `js mjs cjs ts tsx css md`. The **80** tracked json / jsonc / yaml / yml / html files all
  **already pass** `prettier --check` — CI has been covering them the whole time and only the local
  wrapper was blind, so widening it surfaces no backlog. `copier.yml` passes today, its Jinja
  delimiters sitting inside YAML strings, so the widening carries no hazard.
- **`N-028` — a discriminator, not a marker.** An ignore marker already exists and is self-tested
  (`conflict-markers.sh:192-193`), and a discriminator already exists — _"ordinary markup is not
  residue"_ (`:183-188`). The backticked case slipped past it. Widening that discriminator so
  inline code reads as a quotation honours the standing preference for correction over a marker,
  and is the same shape as the `is_naming_row` carry settled for `N-013` in this session.

**What the final batch changed (28/08/2026):**

- **`N-021` — two exclusion forms, two jobs, and the charting conflated them.** A **bare** directory
  entry removes the directory outright; `/dir/**` prunes the contents and leaves the directory
  standing so `!` negations can re-include a pair. `copier.yml:285` used the pruning form where the
  intent was removal, which is why an `INCLUDE_CLICKUP=false` render keeps an empty directory. The
  three surface flags already use bare (`:187`, `:234`, `:257`). Safe here because
  `shipped-artefacts.sh:167-168` demands `/**` only for `PAIR_ONLY_TREES` and `SRC_TREE`, and
  `project-management/export/` is neither; the tree holds one tracked file, its `README.md`.
- **`N-030` — swept now, tiered after measurement.** All 35 workflow files carry **zero**
  `timeout-minutes` and inherit the 360-minute default. The bands are tiered — light for the ~26
  single-script audits, heavy for the container and suite jobs (`claude.yml`, `test-api.yml`,
  `test-e2e.yml`, `test.yml`, `syntax-python.yml`, `audit-deps.yml`, `audit-template.yml`) and
  `S-08`'s parity job — but the **values come from measured CI p95s, not from a guess**, because a
  timeout that fires spuriously is worse than the default it replaces. An interim **30** lands with
  the sweep so nothing waits on the measurement. `claude.yml` is flagged for that pass: an agentic
  workflow has no naturally bounded runtime.
- **The enforcement ships, and that is the deliberate contrast with `N-020`.** The policy step
  goes in a **shipping** hygiene workflow (`audit-conflict-markers.yml`), not in the
  copier-excluded `audit-template.yml`, because a generated project writes its own workflows and so
  has a real downstream subject. `N-020`'s detection stays template-only for the mirror-image
  reason — a copier token exists only here. Same question, opposite answers; both written down so
  neither is "corrected" later.

---

## Slices

The buildable slices. **Flags are a manifest, not a design**; this epic touches no product
surface, so DB / API / GDPR / SEO / Brand / Components / Wireframes / User Flow are `N/A`
throughout and omitted.

| Slice  | Story   | Title                                         | Nodes                                                                                    | Acceptance                                                                                                                                                                                                                                                                                                                                                             | Flags                                                                                                                                                               |
| ------ | ------- | --------------------------------------------- | ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `S-03` | `US###` | The copier-config-reading scripts             | N-006 ✅, N-017 ✅, N-019 ✅, N-027 (moot)                                               | TBD                                                                                                                                                                                                                                                                                                                                                                    | Backend: no · QA: audit self-tests (x2), pre-commit probe, generation probe on **both** answer sets, **the `.copier/README.md` lefthook claim re-read as true**     |
| `S-05` | `US###` | The gate-side rule, and its first use         | N-008 ✅, N-018 ✅, N-016 ✅, N-004 ✅, N-015 ✅, N-010 ✅ (N-009 moot)                  | TBD                                                                                                                                                                                                                                                                                                                                                                    | Backend: no · QA: `skill-conformance` self-test, generation probe, `prettier --check`                                                                               |
| `S-07` | `US###` | Shipped documents that promise absent paths   | N-014 ✅, N-023 ✅, N-031 ✅, N-013 ✅                                                   | TBD                                                                                                                                                                                                                                                                                                                                                                    | Backend: no · QA: `doc-references.sh` + a new naming-row self-test probe, `sync-trees.sh` pre-commit probe, `shipped-readme.sh`, a nine-`.gitignore` tracking probe |
| `S-08` | `US###` | The format pass, and the gate that watches it | N-005 ✅, N-007 ✅, N-011 ✅, N-012 ✅, N-026 ✅, N-022 ✅, N-025 ✅, N-021 ✅, N-030 ✅ | **The catch-up leg is the `after` migration, not a second mechanism** (fog, 01/09/2026): a tree generated at a pre-`S-08` ref and then `copier update`d to the `S-08` release comes out formatted with **no manual step and no `install.sh` edit anywhere**, proved by an update-leg probe alongside the both-pole generation probe. Remaining acceptance unbackfilled | Backend: no · QA: both-pole generation probe, the three commands, `timeout-minutes`, byte-identity vs the reference pole · Logging: CI annotations                  |
| `S-09` | `US###` | The reports tree's documentation pair         | N-032 ✅                                                                                 | TBD                                                                                                                                                                                                                                                                                                                                                                    | Backend: no · QA: `docs-pairing.sh` (both gate edits), `sync-trees.sh --check`, generation probe                                                                    |
| `S-10` | `US###` | Every audit's verdict is legible              | N-024 ✅, N-029 ✅, N-033 ✅, N-020 ✅, N-028 ✅                                         | TBD                                                                                                                                                                                                                                                                                                                                                                    | Backend: no · QA: `security.sh` on both poles, the two new `--self-test` steps, `static-analysis.sh --self-test`, a declared-ignore drift probe                     |

**The `Nodes` and `Acceptance` columns were added 31/08/2026** with the `task` -> `build`
type change. Cells reading `TBD` are **not empty, they are unbackfilled** — this map's next
RESOLVE sitting fills them, and until it does the checklist item _every open node belongs to a
slice_ is unverified here.

`S-03` is the **highest-priority slice** — but its reason changed twice and its answer did not.
The hooks are not installed at generation (`N-019`), so nothing is blocked at commit time on a
fresh project; but they arm on the first non-suppressed `pnpm` invocation, which makes the
landmine live at an unpredictable moment rather than never. It stays first because it is still
the only defect that _stops work_ once that happens, and because `N-019`'s own fix — making the
install deliberate — arms it on purpose. **`S-03` is fully resolved and ready to cut.**

**`S-02` and `S-04` are merged into `S-08` (27/08/2026).** The map recorded the merge as an open
question for `N-007`; the render answered it. ~277 findings separate the two, so `S-04` alone is
red on every run, while `S-02` alone is **unverifiable** — nothing downstream ever runs the checks
it fixes. The conditional the map parked is now measured fact: the pass converges, is idempotent,
and preserves shared-file byte identity, so gate-after-pass is safe by construction. And `S-04`
must exist even with the pass landed, because the parse-gating class (`N-020`) is structurally
invisible to the template's own gates. Slice IDs are stable, so `S-02` and `S-04` are retired,
never reused.

**The merged slice is phased, not monolithic.** Its format legs land green; its audit legs join
the job as `S-03` and `S-05` merge, because the full family opens at 88 findings off-pole and 46
on until those two land. `S-08` also carries the `uv lock` swallow fix (`copier.yml:912-914`),
because its all-on leg is the template's **first-ever** rust + desktop render and a silently
failed lock would surface as a misleading "uv.lock missing".

**`S-01` is retired into `S-05` (27/08/2026).** All four of its nodes resolved or went moot, and
what remained — three gate edits plus a version pin — is the enforcement half of the very rule
`N-008` writes. Splitting them would have cut two stories that must restate one another. `S-05`
now carries both: the gate-side rule and the vendored-seam change that is its first application.
Slice IDs are stable identifiers, so `S-01` is retired, never reused.

**`S-06` is retired into `S-07` (28/08/2026).** Its only node resolved to a one-word edit, and a
slice holding one word is a story that restates `S-07` — which already owns the shipped-promise
class and runs the same `doc-references.sh` gate. `S-07` picks up `shipped-readme.sh` with it.
Slice IDs are stable identifiers, so `S-06` is retired, never reused.

---

## Frontier

**The frontier is closed (28/08/2026).** Every charted decision is resolved or moot, and each is
listed in **Resolved decisions** above with the slice it became. What remains is **fog of war**,
which is not a frontier: none of the three is this epic's alone to settle.

**`N-020` to `N-030` were charted on 27/08/2026 from the rendered poles** — eleven defects that
only a real generation could show, or that the reconstructions had shown and nobody had written
down. None blocks a story; several must **ship with** a slice rather than wait for their own, and
those say so in their entry below.

### What each node already has behind it

---

## Fog of war

**Empty — all three items dispositioned 01/09/2026.** One was answered, two were cleared, and
neither clearance is an answer. Struck rather than deleted, so a later reader sees what was decided
and on what.

- ~~**A catch-up path for the four projects generated before the format task exists.**~~
  **Answered 01/09/2026: no — `install.sh` gains no catch-up leg, because the path already exists
  inside `N-005`'s settled shape.** The unversioned `after` migration runs on **every**
  `copier update`, so the same update that delivers the format task formats the four live trees,
  whose toolchains are present at update time; executing that update is already this map's _Out of
  scope_, on Sam's timing. An `install.sh` leg would be a **second copy of the pass** — the
  duplicated-mechanism class the single-mechanism preference in **Notes** exists to forbid — and it
  would fire on every fresh developer setup of an already-formatted project, rewriting a committed
  tree outside any story. **Graduated to `S-08`'s acceptance as a probe**, because the claim is
  falsifiable and should be proved rather than asserted.
- ~~**The wayfinder index-row rule against the shipping negation.**~~ **Cleared 01/09/2026 — the
  conflict is dead, resolved by relocation, and neither map wrote an exception.**
  `MAP-RULE-OWNERSHIP` N-010 (28/08/2026) moved the `## Map index` table out of the shipped
  `CONTEXT.md`, so the index-row instruction and the shipping-citation rule are both obeyed;
  `MAP-REGISTER-INDEXES` N-001 (31/08/2026) settled the mechanism as an excluded-and-seeded
  `MAP-INDEX.md`. This map's own sentence — _"it is not this map's to write"_ — was correct and is
  now discharged. **The residue is named rather than assumed**, because clearing an item on work
  another map carries is only honest if that work exists: the shipped instruction survives in
  **three files no slice repairs** — `.claude/skills/wayfinder/SKILL.md:97-98` and `:256`, and
  `01-FEATURE-MAPS/CLAUDE.md:22-23` and `:26` — and `MAP-REGISTER-INDEXES.md:157` scopes S-01 to
  `MAP-000-TEMPLATE.md` and the seven `CONTEXT.md` H2s, which does not include them. Recorded as a
  `GAPS.md` entry (01/09/2026) rather than left inside a struck fog bullet.
- ~~**Windows and symlink-hostile destinations.**~~ **Cleared 01/09/2026 — the premise is false
  without needing a run.** Both cited copier behaviours are real, but `_render_symlink` is
  **reachable only when `preserve_symlinks` is true**, a setting absent from `copier.yml` and
  settled by `N-004` as never to be set. For this template the unguarded call is **dead code on
  every platform**, and both rendered poles already carry zero symlinks — this map's own accepted
  property — so a symlink-hostile destination receives nothing that can fail. What remains is not a
  destination question at all but git checking out the template's own three `120000` entries on a
  symlink-incapable host: a **host-support property of syntek-base's own working copy**, which gate
  parity does not own and which the repo's stated POSIX/LF posture already excludes. It revives only
  if `_preserve_symlinks` is ever set — the exact thing `N-004` settled against.

---

## Out of scope

| Ruled out                                                     | Why                                                                                                                                                                                                                                                                                                            |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Running the update on the four live projects                  | The map owns the migration path and its ordering (`N-009`); executing it is separate work, on Sam's timing                                                                                                                                                                                                     |
| Refreshing the four projects' accumulated `README.md` drift   | A freshly generated README is correct — measured. This is three majors of per-project drift, fixed by hand once                                                                                                                                                                                                |
| Absorbing `N-019 on MAP-RULE-OWNERSHIP`                       | Same seam, different question. Folding maps together is how a frontier stops being takeable; cross-referenced instead                                                                                                                                                                                          |
| `syntek-accountability`'s `DESIGN-NOTES.md` tool-call residue | Not a template defect — a leaked closing tool-call tag in Sam's own file, absent from the other three. The tag itself is not quoted here: `conflict-markers.sh` reads a backticked one in a table cell as residue, which is `N-028`                                                                            |
| The template's own `sync-trees.sh` findings                   | **Stale as written.** Green on the working tree (exit 0) via three uncommitted `CONTEXT.md` fixes, red only at committed `HEAD`. Still out of scope as a parity defect — but committing those three fixes moves the downstream count from 12 to 9, so `S-07` is sized against the wrong number until they land |
| Giving seed-once an escape hatch                              | The mechanism is sound; only accumulated drift is at issue, and that is not a mechanism problem                                                                                                                                                                                                                |

---

## Session log

| Date       | Node settled                            | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Frontier redrawn |
| ---------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 24/08/2026 | —                                       | Charted: destination pinned, 13 nodes, 6 unblocked, register triaged                                                                                                                                                                                                                                                                                                                                                                                                              | [x]              |
| 24/08/2026 | `N-001` `N-002` `N-003`                 | All three research nodes settled; 4 new nodes added; every blocking node is now unblocked                                                                                                                                                                                                                                                                                                                                                                                         | [x]              |
| 27/08/2026 | `N-006` `N-017`                         | One manifest proved impossible; per-script guards by `GATE-REPORTING.md` Section 2 row. `N-017` widened to two scripts. `N-019` added, `N-008` widened again. `S-03` resolved                                                                                                                                                                                                                                                                                                     | [x]              |
| 27/08/2026 | `N-004` `N-015`                         | Neither charted horn taken — the gate changes shape, the tree does not. `N-010` settled alongside, `N-009` moot, `N-018` added, `N-008` widened. `S-01` fully resolved                                                                                                                                                                                                                                                                                                            | [x]              |
| 27/08/2026 | `N-005` `N-007` `N-011` `N-012` `N-019` | **Both poles rendered for the first time.** Five nodes settled, 12 map figures corrected, 11 nodes added (`N-020`–`N-030`), `N-008` widened a third time, `S-02`+`S-04` merged into `S-08`. The last blocking node is `N-014`                                                                                                                                                                                                                                                     | [x]              |
| 28/08/2026 | `N-014` `N-023` `N-008`                 | **The citation cluster.** Three nodes settled and four map corrections applied in place — `doc-references.sh` has no fence handling at all, and its third-class verdict exists at `:704`, missed by the `:637` slash strip. `N-031` added and settled (make the path exist); `N-032` added and open; `S-07` widened and renamed                                                                                                                                                   | [x]              |
| 28/08/2026 | `N-032`                                 | **The reports pair.** Settled in three rounds: a `reports/` directory **must** carry a `CLAUDE.md`, `docs-pairing.sh`'s blanket exemption is removed and the single-purpose-leaf escape carved out, and tracked generated output splits from the untracked class. `S-09` cut; `S-07` widened to nine `.gitignore` files. **The last blocking node is closed**                                                                                                                     | [x]              |
| 28/08/2026 | `N-013` `N-026` `N-027`                 | **The false-claims cluster.** `N-027` retired **moot** — `N-019` makes its claim true rather than needing it corrected. `N-026` corrected from five sites to **four** (`06-GENERATION.md:188` was miscounted and is right) and sent to `S-08`, which `N-005` forces. `N-013` is a one-word fix: the naming-row guard already exists and the sentence merely wraps out of it. `S-06` retired into `S-07`                                                                           | [x]              |
| 28/08/2026 | `N-024` `N-029`                         | **Gate honesty.** `security.sh` reads the report line rather than the exit code — the remedy its sibling `.claude/hooks/lib/check-security.sh:46-48` already implements — states the ignore count, and fails closed only when that count hits zero against a non-empty list, because `image-size` is inert on a web-only render and strict equality would false-red it. `N-029` is two lines in two existing workflows. `N-033` graduated from fog of war; `S-10` cut             | [x]              |
| 28/08/2026 | `N-018` `N-022`                         | **Manifest integrity.** One rule for both: _a committed manifest must describe the tree it ships into, or be regenerated at generation_. `N-022` applies the `uv.lock` pattern to `pnpm-lock.yaml` and fixes **both** `\|\| echo` swallows rather than writing a second one. `N-018`'s hash becomes ours — a directory digest over all 15 vendored files, not the 3 `SKILL.md`s — and is asserted for the first time                                                              | [x]              |
| 28/08/2026 | `N-016` `N-020` `N-025` `N-028`         | **What a gate can see.** The 9/8 split **disappears** rather than narrowing: both trees run nine checks, `audits` differing in scope not presence — Scope 1's 21, since Scope 2 lives in the copier-excluded `.github/scripts/`. That branch is `N-008`'s rule in first use. `format.sh` widens to prettier's full set at **zero** cleanup cost — all 80 files already pass. `N-020`'s detection joins an existing token scan; `N-028` gains a discriminator rather than a marker | [x]              |
| 28/08/2026 | `N-021` `N-030`                         | **The frontier closes.** `N-021` was a form confusion — bare removes a directory, `/**` prunes its contents, and `copier.yml:285` used the pruning form for a removal. `N-030` sweeps all 35 workflows off the 360-minute default at an interim 30, tiering from measured CI p95s rather than a guess, with the policy step in a **shipping** workflow so a generated project's own workflows are covered                                                                         | [x]              |

**What the copier-reader batch changed (27/08/2026), in one line each:**

- **`N-006`** — a single rendered manifest is **impossible**, measured: `routing-skills.sh`
  reports **22 findings against a rendered `copier.yml`** and `✓ All 591 … resolve` against the
  **raw** one, so the three parsers do not want the same input. Each script instead guards on
  `copier.yml`'s absence and reports per its `GATE-REPORTING.md` Section 2 row — and the three rows
  differ: `sync-trees.sh` is a **false red** (an empty `EXCLUDED` only ever _adds_ findings, so it
  can never print a false green), `doc-references.sh`'s Check 3 is a **Section 5 scoping fault** (it can
  never find a member), and `routing-skills.sh`'s co-variance clause is the **Section 1 case** — skipped
  and reported clean.
- **`N-006`, second half** — two defects **no input can fix**, both now in `S-03`: `.copier/`
  survives any `copier.yml` because `TEMPLATE_ONLY` is applied in one direction only
  (`sync-trees.sh:151` vs `:288-297`), and an `lstrip("./")` character-set bug means no rendered
  input can ever satisfy the parser for a dot-directory path.
- **`N-017`** — widened. `routing-skills.sh --self-test` also fails downstream, on the **default**
  surfaces-off answer set, because fixture `clean/wrapped.md:3` deliberately names the excluded
  `stack-rust` — and CI runs that self-test as its first step. The failure set **inverts with the
  answers**: `routing-skills`' ordinary gate is 22 false findings surfaces-ON and 0 OFF;
  `doc-references` is 2 ON and 66 OFF. That bears directly on `N-007`'s matrix.
- **Corrected arithmetic.** The map's "5 findings → 1" was measured on a stub tree holding one
  `CONTEXT.md`. On a faithful ~135-file reconstruction: **13 downstream → 4 with a rendered
  `copier.yml` → 7 with `N-014` alone.** `N-006` and `N-014` are **complements, neither
  sufficient** — the charted ordering was right.

**What the render/format/parity batch changed (27/08/2026):** recorded above under **Resolved
decisions**, per node, and in the corrected figures throughout. The measured detail — the
per-gate table for both poles, the runtime budget, and the before/after of the format pass —
lives in `research/GENERATED-PROJECT-GATE-PARITY.md` **Addendum II**, not here.

**One methodological correction worth keeping.** Four batches recorded their counts as floors
because copier was believed unavailable. It was reachable through `uvx` the whole time. The
reconstructions were not wrong so much as unnecessary, and two of their conclusions were wrong in
ways only a render could show — the format pass was thought non-convergent (it converges; the
counter-example was in a file `copier.yml` excludes), and `N-012` was thought to depend on
`N-005` (it never did). **Render before reconstructing.**

**Settled 27/08/2026, after the batch:** `S-01` folds into `S-05` — the gate change is the first
application of the rule `N-008` writes, and two slices would have restated one another. **No ADR
is authored from this map**: `workflows/15-decisions/` runs after `02-story-creation` and takes
the driving `US###` as an input, so the vendored-seam decision is recorded as an ADR at that gate,
not here. The map records the decision; the ADR is written when the story reaches `15`.

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — **0 open**; `N-014` and `N-032` both closed 28/08/2026
- [x] Every resolved node links to the artefact it became
- [x] **Every slice has a flag manifest**
- [ ] Index row in `CONTEXT.md` current — **deliberately absent**; see Notes

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
