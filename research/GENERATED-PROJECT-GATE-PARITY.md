# Generated-project gate parity

## Question

How can a project generated from syntek-base — which receives no `copier.yml` and no `.copier/` —
pass the CI workflows the template ships, and what rule keeps a template-authored gate honest in a
tree it was not written in?

## Verdict

**Every failure is one mechanism: a gate authored here measures the template, and the template is
not what ships.** Three shapes of it — a gate reading a file copier excludes, a gate keying off a
symlink copier flattens, and a formatter reading an artefact that still carries delimiter tokens —
and the third is the dangerous one, because **the token makes the artefact unparseable, the tool
skips what it cannot parse, and the gate reports clean**. That is a `code/docs/GATE-REPORTING.md`
Section 5 scoping fault, and it is silent by construction: no amount of CI **here** can detect it.
The fixes are cheap and each was measured end to end against a probe generated from `HEAD` —
`_preserve_symlinks: true` closes 33 findings, an ungated post-render format task closes 257, and
`_external_data` hands the copier-reading scripts a real input. What none of them closes is the
blindness itself: only a job that **generates a project and runs the gates in it** can see this
class at all.

**Read the Addendum before acting on this section.** The three research nodes it records revise
two claims above: the copier-reading population is **three** scripts and eight sites, not two and
four — and one of them, `sync-trees.sh`, blocks a **pre-commit** rather than reddening a badge; and
`_external_data` over `_exclude` alone closes only half of it, because three sites read `_tasks`
and one reads a question-level `when:`. `ruff format` is also one of **three** structurally blind
tools rather than the only one.

---

## The measured baseline

A probe was generated from `HEAD` (`v7.4.1-2-gcee3bbc`) with all four surfaces on, then every
affected gate was run in both trees with the same pinned binaries. The template is green
throughout; the generated project is not.

| Gate                    | Template | Generated | Cause                                                 |
| ----------------------- | -------- | --------- | ----------------------------------------------------- |
| `skill-conformance.sh`  | 0        | **12**    | symlink flattened, `is_vendored` goes false           |
| `docs-length.sh`        | 0        | **6**     | same — vendored copies land under `.claude/skills/`   |
| `prettier --check .`    | 0        | **51**    | 35 substitution + 15 vendored + `.copier-answers.yml` |
| `markdownlint-cli2`     | 0        | **204**   | 180 MD060 (26 files) + 24 MD012 (5 files)             |
| `ruff format --check .` | 0        | **2**     | token made the fence unparseable **here**             |
| `routing-skills.sh`     | 0        | **22**    | `copier.yml` absent, no flag ever found               |
| `doc-references.sh`     | —        | **3**     | Check 3 derives an empty set; README instance cites   |

Three of these the handoff did not record: **MD012** in five `TEMPLATE-GUIDE` files, the 15
vendored files entering Prettier's scope, and `.copier-answers.yml` itself failing Prettier.

---

## Claims — what Copier actually does

- **Symlinks are flattened unless the template asks otherwise.** The setting is
  `preserve_symlinks`, `bool`, **default `False`**, read only from template config —
  `copier/_template.py:568-573`; https://copier.readthedocs.io/en/stable/configuring/#preserve_symlinks
- **In `copier.yml` the key carries the settings underscore: `_preserve_symlinks`.** Written
  without it the line is inert and generation is unchanged — measured: the same clone generated
  real directories with `preserve_symlinks:` and symlinks with `_preserve_symlinks:`.
- **It was added in v7.1.0**, so the `_min_copier_version: "9.6.0"` floor at `copier.yml:13`
  already clears it — https://copier.readthedocs.io/en/stable/changelog/;
  https://github.com/copier-org/copier/pull/938
- **The raw target string is written verbatim**, and is Jinja-rendered only when the link's own
  filename ends with `templates_suffix` — `copier/_main.py:1029-1048`. With
  `_templates_suffix: ""` (`copier.yml:16`) that test is `endswith("")`, so **every** symlink
  target is rendered. The three current targets carry no delimiters, so this is inert today and
  becomes load-bearing the moment a link target is templated.
- **Excluding a symlink's target yields a dangling link, silently** — `_exclude` is matched
  against the link's own destination path only, never its target — `copier/_main.py:829,1025`.
  `.agents/` is not excluded (`copier.yml:35`), so the targets ship.
- **A real directory becoming a preserved symlink crashes `copier update` with a bare
  `AssertionError`** — `copier/_main.py:578` (`assert is_dir`). **Reproduced**: a project
  generated without the flag, committed, then updated against a template carrying it, aborts with
  a traceback and applies nothing. This is exactly what all four live projects would hit.
- **The workaround is reliable and was measured**: `rm -rf` the three materialised directories,
  commit, then `copier update` — exit 0, symlinks created, tasks ran.
- **`_copier_conf.exclude` is not the template's `_exclude`.** It is the CLI `--exclude` extras
  (`copier/_main.py:255,456`), empty in a normal run; the template's list lives on
  `Template.exclude` and is combined only inside `Worker.all_exclusions`
  (`copier/_main.py:700-704`), which is not in the render context.
- **`_external_data` does expose it.** Measured against the real `copier.yml`: with
  `_external_data: {tplconf: "<% _copier_conf.src_path %>/copier.yml"}`, a rendered file iterating
  `_external_data.tplconf._exclude` produced **all 89 entries** in the generated project —
  https://copier.readthedocs.io/en/stable/configuring/#external_data
- **What comes back is raw**: un-rendered, so the surface-gated entries arrive as the literal
  `<: if not INCLUDE_MOBILE :>…` string, and Copier's own defaults are absent because `_exclude`
  replaces them (`copier/_template.py:47-57`).
- **It needs `--trust`** for a path outside the subproject root, enforced since v9.14.1 — which
  costs nothing, since a template with `_tasks` is already unsafe (`copier/_main.py:307-325`).
- **`.copier-answers.yml` carries only `_commit` and `_src_path` plus non-secret, non-hidden,
  JSON-serialisable declared answers** — `copier/_main.py:375-397`.
- **A `when:`-gated flag is written as absent, not `false`.** `INCLUDE_DESKTOP` carries
  `when: "<% INCLUDE_RUST %>"` (`copier.yml:683`). **Measured**: a probe generated with
  `INCLUDE_RUST: false` has no `INCLUDE_DESKTOP` line at all. Any script reading the flags must
  treat missing as false, never as "cannot determine".
- **`_tasks` run on copy and on update**, top to bottom, in the destination root, with `$STAGE`
  and `$COPIER_OPERATION` set; the first non-zero exit aborts and, on a fresh copy, deletes the
  destination — `copier/_main.py:398-443,1291-1292`;
  https://copier.readthedocs.io/en/stable/configuring/#tasks
- **On update they run three times** — once per worker (old copy, real destination, new copy) —
  `copier/_main.py:1405,1454,1478`. A format task must therefore be idempotent, which
  `prettier --write` and `ruff format` both are.
- **Copier offers no first-party "am I generated?" flag.** Its own test is `_src_path` present in
  the answers file — `copier/_subproject.py:74-82`, the same branch `copier update` takes.
  `template-update.sh:100` already uses that idiom.

## Claims — what the formatters require

- **Prettier's markdown table output is a pure function of rendered cell width**: each column is
  padded to `max(getStringWidth(cell))` — `prettier@3.9.6:src/language-markdown/print/table.js:20-23`.
  A table aligned for `<%PROJECT_NAME%>` is by definition misaligned for a real value of a
  different length.
- **There is no option to disable table alignment.** Markdown exposes only `proseWrap` and
  `singleQuote` — `prettier@3.9.6:src/language-markdown/options.js:5-6`. Aligned output is
  returned unconditionally unless `proseWrap: "never"` **and** the table exceeds the print width —
  `table.js:30-37`.
- **MD060 is `table-column-style`**, default `style: "any"`, introduced in markdownlint 0.39.0;
  a table that is neither cleanly aligned, compact nor tight fails even on defaults, and `aligned`
  violations are **not auto-fixable** —
  https://github.com/DavidAnson/markdownlint/blob/main/doc/md060.md
- **The other table rules are structural, not cosmetic.** MD055, MD056 and MD058 inspect pipe
  style, cell counts and surrounding blanks — none inspects padding. Alignment is a Prettier
  requirement that markdownlint then agrees with, because both measure visual width.
- **Prettier's aligned output is always MD060-clean**, so one tool fixes both gates.
- **Ruff formats Python inside Markdown fences by default from 0.16.0**, where `"*.md"` joined the
  default `include` — `ruff@0.16.0:crates/ruff_workspace/src/options.rs:269`;
  https://docs.astral.sh/ruff/formatter/#markdown-code-formatting. Below that it is not "off" but
  differently-on: unlabelled fences went from formatted to skipped in 0.15.1.
- **Ruff silently skips a fence it cannot parse and reports the file clean** — "the formatter
  will automatically skip a code block if the code does not parse as valid Python"
  (https://docs.astral.sh/ruff/formatter/). **Reproduced in isolation**: two Markdown files with
  the identical formatting defect, one containing a delimiter token in an import line — the tokened file
  is reported "already formatted", the other "would be reformatted".
- **That is the whole of item 5.** `code/docs/rls/MIDDLEWARE-AND-NINJA.md:189` reads
  `from apps.<%AUDIT_APP%>.middleware import …`, which is not valid Python, so ruff never sees the
  `list(...)` call three lines down. It is not a host-version scope gap — the template is green at
  the pinned version and the generated project is not.
- **`ruff>=0.16.3` is not a pin.** Ruff's policy assigns "the stable style changed" to a
  **minor** bump — https://docs.astral.sh/ruff/versioning/. `required-version = "==0.16.x"` under
  `[tool.ruff]` makes a mismatched binary exit 2 instead of silently answering differently.

## Claims — what the template's own gates can see

- **`GATE-REPORTING.md` Section 2 does not cover this class.** Its second row — absent surface,
  clean is correct — assumes the population is legitimately empty. Here the population is
  non-empty and unreadable, which is Section 5: "it looked in a place that could not contain the
  thing, and reported success."
- **`FORWARD-VOICE.md` has the doctrine for documents and none for gates.** Direction B gives a
  shipped document the `doc-references: template-only` marker for a path it holds and copier
  excludes. **No equivalent exists for an executable gate** that reads such a path — which is why
  `doc-references.sh:375` and `routing-skills.sh:294` each degrade silently rather than declaring.
- **Both scripts already say so in prose and neither branches on it** —
  `doc-references.sh` prints `matched against 0 path(s) copier excludes unconditionally`
  (measured: it prints exactly that downstream), and `routing-skills.sh:359` records that its
  co-variance verdict reads the real `copier.yml`.
- **`doc-references.sh` reads `copier.yml` in four places, not one** — `:322` (seeded paths),
  `:375` (`_exclude`), `:404` (`uv lock`), plus the derived-set logic from `:31`. The handoff
  named only `:375`.
- **The template-integrity checks already have a home that does not ship**: `.github/scripts/`
  (six scripts) and `audit-template.yml`, both in `_exclude` (`copier.yml:41-42`).
- **A freshly generated README is correct.** The probe's `README.md` produced no `.claude/agents/`
  or stale-workflow findings — only `US001.md`/`US042.md` instance citations, which are a genuine
  defect in `.copier/README.md` **here**. Item 3 is therefore not a generation defect at all: it is
  three majors of drift in a file `14-UPDATING.md:43` states an update can never reach.

## Claims — the fixes, each measured

| Fix                                                        | Closes                                                    | Measured                                            |
| ---------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------- |
| `_preserve_symlinks: true`                                 | `skill-conformance` 12→0, `docs-length` 6→0, Prettier −15 | probe regenerated; audits report "3 vendored"       |
| Ungated `_task`: `prettier --write .` then `ruff format .` | Prettier 51→0, markdownlint 204→0, ruff 2→0               | run on a probe copy; all three re-checked clean     |
| `_external_data` → `_exclude` rendered into the project    | `doc-references` Check 3, `routing-skills` co-variance    | 89 entries rendered from the real `copier.yml`      |
| `.copier-answers.yml` as the flag source                   | the `INCLUDE_*` lookups                                   | present in every probe; absent-means-false verified |

**The format task must be ungated** (no `when: _copier_operation == 'copy'`), because every
`copier update` re-renders the same tables against the same values and breaks them again. It should
follow the guarded, non-fatal idiom of the existing `uv lock` task at `copier.yml:910-913`, since
`node_modules` may not exist at generation time.

---

## What this does not settle

The four open questions in the handoff are decisions, not facts, and this note only removes the
guesswork from three of them:

1. **Where the vendored set lives** — `_preserve_symlinks` keeps the current shape, so the
   exemption stays a symlink test on both sides. The cost is the update crash above, paid once per
   existing project.
2. **Fail, skip or self-declare** — Section 5 says the search is wrong, so **fix the search first**
   (`_external_data`), and only then is there anything left to declare.
3. **A README refresh path** — the seeded README is correct at generation; only accumulated drift
   is at issue, so this is a one-off chore per project, not a template mechanism.
4. **Whether the four projects re-update** — not addressed here; it turns on the crash workaround
   being run by hand in each.

**The gap none of the four names**: `audit-template.yml` [3/4] **does** generate a project, both
ways, and asserts its structure — tokens, leaks, completeness, branding, version freshness, the
opt-in, byte-identity. What nothing does is **run the project's own gates in that tree**, so this
whole class is invisible to CI here. That is the finding worth acting on.

---

## Sources

**Copier** — docs at https://copier.readthedocs.io/en/stable/ (`configuring/#preserve_symlinks`,
`#exclude`, `#external_data`, `#tasks`, `#migrations`, `creating/#_copier_conf`, `changelog/`);
source at https://github.com/copier-org/copier v9.17.2 — `copier/_main.py`, `copier/_template.py`,
`copier/_subproject.py`, `copier/_types.py`; PRs 938, 1409, 2427.

**Prettier** — https://prettier.io/docs/options, `/docs/ignore`, `/docs/cli`; source at tag 3.9.6,
`src/language-markdown/print/table.js`, `src/language-markdown/options.js`.

**markdownlint** — https://github.com/DavidAnson/markdownlint `doc/md060.md`, `doc/md055.md`,
`doc/md056.md`, `doc/md058.md`, `CHANGELOG.md`; markdownlint-cli2 `README.md`, `CHANGELOG.md`
(0.23.0 `overrides`).

**Ruff** — https://docs.astral.sh/ruff/formatter/, `/settings/`, `/versioning/`,
`/configuration/`; https://github.com/astral-sh/ruff `CHANGELOG.md`, `changelogs/0.15.x.md`,
`crates/ruff_markdown/src/lib.rs` @ 0.16.3, `crates/ruff_workspace/src/options.rs`.

**Git** — `Documentation/config/core.adoc` (`core.symlinks`), for the Windows caveat.

**Internal** — `copier.yml`, `code/docs/GATE-REPORTING.md`, `code/docs/FORWARD-VOICE.md`,
`code/src/scripts/audits/skill-conformance.sh`, `docs-length.sh`, `doc-references.sh`,
`routing-skills.sh`, `code/src/scripts/syntax/format.sh`, `.prettierignore`,
`.markdownlint-cli2.jsonc`, `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`.

**Measurement** — a probe generated from `HEAD` with `copier 9.17.2` and the repo's own pinned
binaries (Prettier 3.9.6, markdownlint-cli2 0.23.2, `ruff>=0.16.3`), plus four variant
generations: `_preserve_symlinks` on, `_external_data` on, `INCLUDE_RUST: false`, and an update
onto a materialised-directory project. No live project was touched.

---

## Addendum — the three research nodes, settled 24/08/2026

Charted as `N-001`, `N-002` and `N-003` on
`project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` and dispatched from that session.
Each was measured against a probe generated from `cee3bbc`; the load-bearing claim of each was
then re-run independently before being recorded here.

### N-001 — the population reading a copier-excluded path is eight sites across three scripts

- **`sync-trees.sh` is the third script, and it blocks a commit.** `lefthook.yml:76` runs
  `sync-trees.sh --write --staged` as a blocking pre-commit job. **Reproduced**: in a generated
  project, staging one root-level file gives 5 findings and exit 1. A generated project cannot
  commit a root-level change without `--no-verify`. Neither the handoff nor this note's first
  draft named it.
- The eight broken sites: `doc-references.sh:322`, `:375`, `:404`, `:789`+`:821` (self-test
  probes), `routing-skills.sh:275`, `:294`, `sync-trees.sh:191`, `:295`.
- **`_external_data` over `_exclude` alone does not close the population.** Three sites read
  `_tasks` — `:322` parses the `mv .copier/X Y` commands, `:404` greps for the literal `uv lock`,
  and `sync-trees.sh`'s `.copier/` gap exists _because_ `_tasks` runs `rmdir .copier`, a path that
  is not in `_exclude` at all. A fourth, `routing-skills.sh:275`, reads a question-level `when:`
  (`copier.yml:683`). The rendered input must carry `_exclude`, `_tasks` **and** each
  `INCLUDE_*` question's `when:`.
- **Three independent parsers of the same list already exist** — bash/awk
  (`doc-references.sh:375`), grep (`routing-skills.sh:294`) and Python with its own `<:`-block
  handling (`sync-trees.sh:186-211`). Whatever is handed downstream must satisfy all three, or one
  keeps its private copy and drifts.
- **Eleven further sites read an excluded path and are correctly guarded**, nine of them through
  one idiom: `[ -f copier.yml ]` as a template/project discriminator. The three broken scripts read
  `copier.yml` for **data** and never test for it — which is the gate-side rule, already de facto.
- **`doc-references.sh --self-test` fails downstream and misdiagnoses itself**, reporting "the
  detector no longer separates the fixtures — fix the detector, never the fixtures" when the cause
  is an absent input. Not in CI today.
- **`pre-pr-check.sh:80` silently reduces the local gate from nine checks to eight downstream**, so
  the whole 24-audit surface is unreachable from the shipped pre-PR hook in every generated
  project, with no line printed saying so. The comment at `:369` argues it is intended.

### N-002 — three tools are structurally blind, and the shape is precise

- **The membership test.** A tool is blind only if it parses a sub-language nested inside a
  permissive host format **and** treats a nested parse failure as "nothing to do". A standalone
  parse failure has nowhere to hide.
- **Live:** `ruff format` on Markdown fences — 2 fences, `MIDDLEWARE-AND-NINJA.md:186` and
  `FIELD-ENCRYPTION.md:253`.
- **Latent, and a new finding:** `prettier` passes through embedded code in a `.md` fence it
  cannot parse and reports the file clean. Zero token-caused instances today, but only by luck —
  all 8 tokened fences in prettier languages happen to sit inside strings. The mechanism is live:
  `code/docs/security/AUTH-AND-AUTHZ.md` is reported clean while its `yaml` fence does not parse.
- **Live, known:** `docker compose config` on a shell word — prior art in
  `.github/scripts/check-template-parsers.sh`, re-verified.
- **Everything else is safe, and for a stated reason.** `eslint`, `cargo fmt`, `cargo check` and
  `prettier` on `.json`/`.mjs` **error loudly**; `basedpyright` and `opengrep` have real error
  recovery and report the defect anyway; `markdownlint` and every grep/awk audit never parse.
  `ruff check` has no Markdown scope at all.
- **Only three commands are render-sensitive** — `ruff format --check`, `prettier --check`,
  `markdownlint-cli2`. Everything else fails **here**, so a parity job running the audit family
  would buy a second copy of a green check.
- **The remedy already exists in this tree.** `dependency-drift.sh` records what it successfully
  read **at the point of reading** and treats "exists but does not parse" as unread, exiting 2:
  _"An empty result is not agreement here — nothing was read to agree with."_ Its one gap, a
  partial read proceeding, is shared by `static-analysis.sh`, whose verdict keys on `len(results)`
  while parse errors go to the body.

### N-003 — no assertion breaks; one new blind spot appears

- **Every step of all four `audit-template.yml` jobs exits identically** with
  `_preserve_symlinks: true`, measured over four fresh generations.
- **`grep -r` does not descend into symlinked directories**, so vendored coverage narrows from 2x
  to 1x and never to 0x — `.agents/` is a real directory and is walked directly. A planted token
  was still caught.
- **`diff -r` dereferences by default**, so byte-identity still compares every vendored file. It
  also cannot distinguish a symlink-to-directory from a real directory of identical content.
- **The cost: a dangling vendored link is invisible to everything.** **Reproduced**: delete
  `.agents/` and `skill-conformance.sh` exits 0, green, with its population dropping from 64 skills
  to 61 — three skills vanished and the gate called it clean. Every step of `audit-template.yml`
  stays green; the byte-identity step discards `diff`'s stderr and its exit 2.
- Today this cannot happen: a materialised copy is self-sufficient. Preserving the links makes
  `.agents/` load-bearing for a surface nothing asserts on — and **no workflow watches
  `.agents/**`**, a pre-existing gap the flag would make live.
- **Corrections to this note's first draft:** `skill-conformance.sh` has **no `--self-test`**; and
  the Windows / symlink-hostile destination case is **unmeasured** — `Path.symlink_to()`
  (`copier/_main.py:1041`) raises rather than degrading, and a failed render on a fresh
  `copier copy` deletes the destination, but nobody has run it.
- **Direct evidence for `N-011`:** the host `ruff` is 0.14.11, below the `ruff>=0.16.3` constraint
  and below the 0.16.0 release where `*.md` joined the default include. Every ruff measurement had
  to go through the CI invocation. The constraint is a floor, not a pin, and the gate's behaviour
  changes across it.

---

## Addendum II — the rendered poles, measured 27/08/2026

**The methodological correction first.** Everything above, and the four resolve batches that
read it, reasoned from _reconstructed_ trees, because copier was recorded as unavailable. It was
not: it is absent from `PATH` but reachable through `uvx`, which is how CI has always run it. On
27/08/2026 both answer-set poles were rendered for real with
`uvx copier copy --trust --defaults --vcs-ref=HEAD`, the same invocation as
`.github/workflows/audit-template.yml:154`, widened to all four surface flags.

Two conclusions above were wrong in ways only a render could show, and both are corrected below.
**Render before reconstructing.**

### What was rendered

| Pole  | Answers                                         | Files | Symlinks |
| ----- | ----------------------------------------------- | ----- | -------- |
| `off` | `INCLUDE_CLICKUP/MOBILE/RUST/DESKTOP` all false | 1165  | 0        |
| `on`  | all four true                                   | 1270  | 0        |

The all-on pole is the template's **first ever** rust + desktop render — 59 tracked files that
had never been through generation. `copier` refuses to render at all without `--trust`, because
`copier.yml:841` declares `_tasks`: without it the run exits **4** and writes nothing, so there
is no such thing as a partial, task-free generation of this template.

Standing caveat on every figure here: the render used `--vcs-ref=HEAD` against a **dirty**
working tree, so it inherited three uncommitted `CONTEXT.md` fixes and dropped seven force-added
files under `code/src/scripts/tests/reports/`. Three of the on-pole `doc-references` findings are
that probe artefact rather than a template defect. **A parity gate must render from one clean
committed ref.**

### The gate table

Findings as counts; seconds as off/on. Failure kind distinguishes a real defect in the rendered
project from a gate that cannot read a rendered tree — that distinction is the whole epic.

| Gate                           | off             | on                | secs         | Failure kind                                                           |
| ------------------------------ | --------------- | ----------------- | ------------ | ---------------------------------------------------------------------- |
| `doc-references.sh`            | **70**          | **6**             | 109-134      | mixed — mostly real shipped-doc defects, plus Check 3 inert downstream |
| `skill-conformance.sh`         | **12**          | **12**            | 1.2-1.4      | **blind** — `is_vendored()` is a `-L` test; false after dereference    |
| `docs-length.sh`               | **6**           | **6**             | 0.6          | **blind** — the exemption is an `.agents/*` path prefix                |
| `routing-skills.sh`            | 0 (vacuous)     | **22, all false** | 6.6-7.6      | **blind** — absent `copier.yml` swallowed                              |
| `sync-trees.sh --check`        | **9**           | **6**             | 1.2-1.5      | **real** — would block the first commit                                |
| the other 20 audits            | pass            | pass              | ~33-40 total | n/a — 5 are structurally null on a fresh project                       |
| 9 self-tests                   | **2 fail**      | **1 fail**        | 9.0-9.6      | blind — `doc-references` fails **both** poles                          |
| `prettier --check`             | **52**          | **53**            | 13-15        | mixed — ~37 render-created, 15 vendored, 1 is `N-012`                  |
| `markdownlint-cli2`            | **222** in 32   | **223** in 33     | 4.3-5.5      | real, render-created — token width breaks table alignment              |
| `ruff format --check` @0.14.11 | pass "69 files" | pass              | 0.02         | **false green** — the host sees 69 of 837                              |
| `ruff format --check` @0.16.4  | **2** of 837    | **2** of 888      | 0.04         | real, render-created                                                   |

**Audit family totals: 4 gates non-zero and 88 findings off-pole, 5 and 46 on-pole.**

Not measured at all, and therefore **unknown rather than clean**: `eslint`, `ruff check` (lint),
`basedpyright`, `tsc`, `cargo`, the whole `tests/` family, and every Docker-dependent leg.

### The runtime budget

| Body of work                        | Per pole                    | Both poles |
| ----------------------------------- | --------------------------- | ---------- |
| Full 24-audit family                | 151-166s                    | ~5.5 min   |
| — of which `doc-references.sh`      | 109-134s (74-78%)           | ~4 min     |
| 9 self-tests                        | 9.0-9.6s                    | ~19s       |
| The three render-sensitive commands | 18-21s (prettier is 70-78%) | ~40s       |
| Generation itself                   | ~24s incl. `uv lock`        | ~48s       |

A render-sensitive-only job is ~2 minutes; the full family on both poles is a **6-8 minute job**,
against the 41 seconds `audit-template.yml` costs today. Hard constraint: the sweep **mutates the
tree** — `security.sh` writes a 540 MB `.venv` into whatever it audits — so the job must run in a
throwaway copy per invocation and must never assert on file counts afterwards.

### N-005 — the format pass converges

The map recorded "51 Prettier failures, 204 markdownlint errors and 2 ruff failures to zero",
measured on a `cee3bbc` reconstruction. The real numbers are **52/222/2 off-pole** and
**53/223/2 on-pole** — and the pass does take them to **0/0/0**, in one round, on both poles,
with `prettier --check` then exiting 0.

Three things this settles:

- **`prettier --write` alone clears every markdownlint finding** (222 → 0: 198 MD060 plus 24
  MD012). markdownlint needs no fix pass of its own.
- **It is idempotent.** A second pass rewrites nothing.
- **A reconstruction said otherwise and was wrong.** Measured on the template's _dirty working
  tree_, the same pass appears to leave markdownlint red and to create MD004 findings. The
  counter-example is `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`, which
  `copier.yml` excludes and which therefore never ships. On a clean template archive the pass is a
  no-op (0 findings before and after); on a rendered pole it converges. **`N-005` is a siting
  question, not a feasibility question.**

Four teeth on the convergence, all measured: `.copier-answers.yml` re-reddens on every
`copier update` unless `N-012` resolves (it now does, to ignore); the pass forks the 15 vendored
`cloudinary-*` files from their `.agents/` twins without a `.prettierignore` entry; a naked
`_task` running `pnpm exec prettier` silently installs 565 packages and rewrites the committed
`pnpm-lock.yaml`; and the pass **must invoke a ≥0.16 ruff**, or it silently skips every `.md` and
appears to succeed while CI stays red.

### N-012 — "format it" is impossible, not merely awkward

The rendered `.copier-answers.yml` fails `prettier --check` because
`jinja2_ansible_filters.to_nice_yaml` defaults `indent=4` for folded-scalar continuation lines
where Prettier wants 2. A hand fix can never survive: copier overwrites the answers file
unconditionally (`_main.py:512`) and excludes it from the update patch (`:1548-1553`), with no
`_skip_if_exists` to pre-empt it. Reproduced end to end — render at v7.4.0, format, update to
v7.4.1, and the four-space indent is back.

### The widened matrix is assertion-safe

All 12 of `audit-template.yml`'s generated-tree assertion steps pass on the all-off/all-on pair.
The cross-pole diff is **one** differing file (`.copier-answers.yml`), **zero** off-only files and
105 on-only (mobile 41, rust 35, desktop 24, clickup 5) — so the single-mechanism rule holds at
the widest pair the template can produce. Two leaks it does not cover are charted as map nodes
`N-021` (the ClickUp opt-in leaves an empty directory) and `N-022` (`pnpm-lock.yaml` names the
mobile importer on a web-only project).

---

## Addendum III — the citation cluster, measured 28/08/2026

Grounds map nodes `N-014`, `N-023`, `N-008` and `N-031`, and the four corrections applied to
`MAP-GATE-PARITY.md` in place. Every claim below was re-verified against `7a82095` on 28/08/2026,
independently of the session that first measured them.

### `doc-references.sh` has no fence handling at all

The map inferred that the script "structurally cannot see a fenced tree block". The stronger and
correct statement: the file contains **zero** fence constructs of any kind, so fencing is not what
hides a token from it. It tests **backticked tokens only**, and is therefore blind to an
unbackticked token anywhere in a document — in a fence, in a table cell, or in running prose.

That is why `N-014` settles to **backtick and annotate** rather than to a marker: backticking is
what makes the five root `CONTEXT.md` rows visible to the gate at all, and the annotation is what
makes the verdict correct once they are.

### The third citation class does have a verdict — it misses by one character

`doc-references.sh:704` carries the generated-output arm:

```sh
*/reports/*|*/coverage/*|*/staticfiles/*|.claude/worktrees/*|.claude/worktrees) continue ;;
```

It covers 12 of 162 sites. It does not cover the shipped `code/src/scripts/tests/reports/`
citations, because `:637` normalises the token first:

```sh
stripped="${stripped%/}"
```

`…/tests/reports/` becomes `…/tests/reports`, which `*/reports/*` cannot match — the glob needs a
component after `reports/`. `.claude/worktrees` is listed twice for exactly this reason, once
globbed and once bare; `reports` has no bare alternative. That asymmetry is the whole defect, and
it is `N-023`'s residue once `N-031` dissolves the `tests/reports` instance.

### The nine `[ -f copier.yml ]` sites are two idioms with opposite control flow

The map cited nine guarded sites as one precedent for the discriminator idiom `N-008` writes. They
divide cleanly, and the division matters:

| Group                   | Sites                                                                                                                                                                                    | Shape                                                                                                                                                                   |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Ships** (4)           | `.claude/hooks/pre-pr-check.sh:80` · `.claude/hooks/template-docs-readonly.sh:35` · `lefthook.yml:137` · `lefthook.yml:218`                                                              | **Stand down** — `exit 0`, or set `TEMPLATE_MODE` and carry on. The file is absent downstream by design, and absence is a legitimate state                              |
| **Copier-excluded** (5) | `.github/scripts/shipped-artefacts.sh:142` · `shipped-memory.sh:102` · `shipped-readme.sh:115` · `shipped-registers.sh:118` · `.copier/migrations/v6.0.0-rename-feature-surfaces.sh:451` | **Assert input** — `[[ -f "$COPIER" ]] \|\| die "missing $COPIER"`. The script never runs downstream at all (`copier.yml:41`, `:97`), so absence is a broken invocation |

A rule quoting all nine as one precedent would teach a shipping script to `die` where it should
stand down, or an excluded script to pass silently where it should fail loudly — misapplied on
first use, in either direction.

### `N-031` — the parent-directory trap, and why four files sit inert

Root `.gitignore:50` excludes `code/src/scripts/tests/reports/` in **directory form**. Git does not
descend into an excluded directory, so the nested `.gitignore` inside it is never read, and no
root-level `!` negation can re-include anything beneath it. The observable consequence:
`git status --short code/src/scripts/tests/reports/` prints **nothing** — not "untracked", nothing —
while the directory holds an untracked `.gitignore` and `.gitkeep` on disk.

Seven files are force-added past that rule. **Four of them already are the proposed pattern**
(`backend/.gitignore` + `.gitkeep`, `backend-coverage/.gitignore` + `.gitkeep`), sitting inert
because the parent is excluded in directory form.

The untracked `tests/reports/.gitignore` on disk is **not** the fix and must not be adopted: it is
a list of directory names (`backend/`, `api/`, …) that admits nothing back, repeating the
directory-form error one level down.

The working shape is the one five siblings already ship, plus two lines they do not need:

```gitignore
*
!*/
!.gitignore
!.gitkeep
!CONTEXT.md
!CLAUDE.md
```

- **`!*/` is load-bearing here and absent from the five flat siblings.** `tests/reports/` is the
  only `reports/` directory with children; without `!*/` git never descends into `backend/` or
  `backend-coverage/`, and 4 of the 7 files stay untracked.
- **`!CLAUDE.md` is Sam's call (28/08/2026)**, and it is what opens `N-032` — see below.
- Precedent for the whole shape, `!*/` and `!CLAUDE.md` included: `questionnaires/.gitignore:13-20`.
  The five `reports/` siblings carry the narrower `*` / `!.gitignore` / `!.gitkeep` / `!CONTEXT.md`.
- **`.gitkeep` is strictly redundant** — `code/src/scripts/reports/` holds its folder on a tracked
  `.gitignore` alone — and is kept deliberately, for symmetry with the six siblings.

The root rule moves to the **glob** form (`code/src/scripts/tests/reports/*`) rather than being
deleted, so the directory's generated contents stay ignored if the nested file is ever lost.

### One handoff figure corrected: the `api/` row is an off-pole finding

The batch reported `sync-trees --check` moving 9 → 10 because `tests/reports/CONTEXT.md:16` lists
`api/`, "which is not on disk". **In this repository `api/` is on disk**, so the finding is a
property of a **generated** tree, where nothing has yet run `api.sh`. The annotation is still
required — and `--write` cannot supply it — but it is downstream parity work, not a defect here.
The word must be `gitignored`: the `GATED` regex at `sync-trees.sh:183-185` accepts it, and the
row's current wording, "created on demand", matches nothing in that alternation.

### What this addendum does not settle

The on-pole re-baseline was **not** re-run at this commit. `/tmp/gate-parity-renders/{off,on}` were
polluted by a `security.sh` `.venv` (~540 MB), so the "leaves one red on-pole, and it is
`coverage/`" figure is carried from the batch's own render rather than re-measured. Any number
entering a story's acceptance criteria wants a fresh render from one clean committed ref — which
also resets `S-08`'s baseline.

---

## Feeds

`project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` — nodes `N-001`, `N-002` and `N-003`
are resolved by the first addendum; `N-005`, `N-007`, `N-011` and `N-012` by **Addendum II**,
which also grounds the eleven nodes `N-020` to `N-030` charted from the poles; and `N-014`,
`N-023`, `N-008` and `N-031` by **Addendum III**, which also grounds `N-032` and the four
corrections applied to the map in place.

The ADR is still pending: the decision this note grounds is the scope question the handoff opens
with — what a gate authored in the template may assume about the tree it runs in. That is map node
`N-008`; wire this note to its `ADR-###` when `/grill-with-docs` settles it.

**Written:** 24/08/2026 · **Addendum:** 24/08/2026 · **Addendum II:** 27/08/2026 · **Addendum III:** 28/08/2026
