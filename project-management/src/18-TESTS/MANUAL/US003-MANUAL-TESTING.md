# US003 — Manual Testing Guide

_The manual testing guide for US003 — the journey a tester follows step by step, and — once walked — whether each step passed. Authored on 30/09/2026 at `17-story-plans` Step 7.2, as a backfill for a story planned before authorship moved to that step: written from the specs below, before any of the story's work exists._

**Last Updated**: 09/10/2026 · **Story**: US003 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US003.md` — Absence gets an owning guide, born under 270 with every clause's tier stated
- **Story plan:** `../../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the code master this guide was authored beside
- **Branch:** `us003/absence-guide`
- **Surface:** Gate — every row runs a `code/src/scripts/audits/*.sh` gate or reads a file in the repository
- **Authored from:** the story; `../../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md`; the story plan; `../../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`; `../../15-DECISIONS/ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH-02-09-2026.md`, `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` and `../../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`. No stage-1 design (`04`–`08`) and no `09`, `10`, `12`, `13` or `14` planning artefact exists for this story — every one of those flags reads N/A. Never code.

> **Authored before code, walked after it.** Which workflow writes which part of this file, and
> when, is `../CLAUDE.md` → _The record lifecycle_. Every rule for filling it — authoring, open
> questions, row IDs, the two citation columns, the build captures, marking, amendments and the
> browser contract — is this folder's `CLAUDE.md`. Neither is restated here.
>
> **What this file is, and is not.** This records **executing** the manual tests and their outcome.
> Whether the story met its specified scenarios is `../../11-QA/IMPLEMENTATION/`; whether the flow
> exists as designed is `../../05-USER-FLOW/IMPLEMENTATION/`. Three records, three questions.

---

## Preconditions and environment

- **Stack:** not needed — no row opens a page, and no row touches a database. Every command is a
  `code/src/scripts/audits/*.sh` gate run from the repository root.
- **Base URL:** N/A — the story renders nothing.
- **Working tree:** the story branch checked out at the commit under review, with no other change
  in the tree — the gates read the whole tree, so a stray edit reaches their output.
- **Build order:** US003 is worked in SPRINT-02, **ahead of** US004, so the `doc-references.sh`
  baseline applies and DOCREF-01 is walked as written. Only in the carry case — the story slips to
  SPRINT-03 and is worked there after US004 has landed, with the whole-tree gate proven green
  and the accepted retirement recorded before editing — does the story plan's _The citation gate,
  corrected_ replace the baseline with a plain pass.
- **Seed data:** none. No fixture, no seeded user, no credential, no personal data.
- **Accounts / roles:** none — the story introduces no permission boundary. The tester is someone
  other than the story's author (the story's _QA Acceptance Criteria — Manual_).
- **Out of scope:**
  - **Permission and access** — the QA plan's `PA` table reads _None_: no runtime surface, endpoint
    or protected action, so there is no role boundary to cross and no ID to own.
  - **Accessibility** — the QA plan's Section 3 is N/A, and the story's _Verification Checks_ agree:
    no rendered screen or interactive component; the guide is Markdown read in an editor.
  - **Responsive behaviour** — the QA plan's Section 4 is N/A, for the same reason.
  - **User flow** — the story's `User Flow` flag reads N/A, so no consolidated flow covers it: every
    `Flow` cell is `—`, and `18-consolidate-design-work` has none to set.
  - **`docs-pairing.sh`** — regression only in the story's _Verification Checks_; the story creates
    no directory and owes no new pair.
  - **Markdown lint and format** (`code/src/scripts/syntax/lint.sh`) — a line in the story's
    _Verification Checks_, run before the PR, not a manual acceptance criterion.
  - **The test suites and `migrate.sh check`** — N/A in the story: no code path, no model.
- **Open questions:** None. Resolved 09/10/2026 against the existing verification
  boundaries. BITE-04 exercises the human prose oracle; DRIFT-02 remains the fenced-code regression check.

---

## Recorded during the build

The story requires the `doc-references.sh` baseline in this file (Scenario _The citation gate is
read against a recorded baseline_), captured before any file is edited, as
`ADR-US003-CITATION-GATE-BASELINE-DIFF` also requires; its QA tasks add the after-run. Two more are
kept beside it without a home named for them: the four skills' figures, which the story plan's
_Risks_ re-measures before committing, and the Codd primary-source check, which Scenario 9 requires
before either the row or the fallback sentence is written. The implementer fills these during the
build, the baseline half before the first edit — never reconstructed afterwards. The journeys below
check them at the walk. Not a journey: nothing here carries a `Result`.

| Measurement                                                                                                                                                                                                                                              | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Baseline — date, commit and git-index state of the capture; a baseline is comparable only against a run in the same index state                                                                                                                          | 04/11/2026 at `5baaac2` on `us003/absence-guide`, working tree clean (porcelain count 0), index unstaged — before the first edit                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| The four named skills' counted lines before and after the edit — 169, 155, 220 and 148 in the story (figures as written; re-measured 04/11/2026 below, plan Key Decisions Q1)                                                                            | **Before** (04/11/2026 at `5baaac2`, `docs-length.sh --path .claude/skills/<name> --limit 1`, exit 1 being the probe): `backend` **137** · `frontend` **130** · `code-reviewer` **169** · `refactor` **118** — all clear of 270. **After** (04/11/2026 at `99187e7`, same probe): `backend` **139** · `frontend` **132** · `code-reviewer` **171** · `refactor` **120** — each +2 (the `code/docs/ABSENCE.md` cross-reference), none sat at or above 270 before, so the ratchet binds none                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `code/docs/ABSENCE.md`, counted lines at birth                                                                                                                                                                                                           | **144** counted lines (04/11/2026 at `99187e7`, `docs-length.sh --path code/docs/ABSENCE.md --limit 1`, exit 1 being the probe) — 126 clear of 270. Measured with it: the crib is **30 cells** (six kinds × five surfaces: Python, Rust, Alpine, HTMX, mobile TypeScript), none blank, a bare dash or "varies"; Alpine's expected-miss and empty cells state why the kind cannot arise. **14 inline tier markers** — 12 `[judgement]`, 1 `[gate: fail]` (`doctrine-drift.sh`, claim `absence-enum`, its path filter stated), 1 `[gate: prose]`, **0** `[gate: warn]`; no document-level marker, none in a crib cell **Corrected at the review fix 04/11/2026** (committed as `8a9e245`, parent `e1afd7b`): **148** counted lines, 122 clear of 270; still 30 cells, none blank, a bare dash or "varies", but **no cell now states that a kind cannot arise** — Alpine's expected-miss and empty cells name expressions; **15 inline tier markers** — 14 `[judgement]`, 1 `[gate: fail]`, **0** `[gate: prose]`, **0** `[gate: warn]`. See _The review fix_ below. **Corrected at the second review fix 05/11/2026** (staged on `8a9e245`, not committed): **192** counted lines, 78 clear of 270; still 30 cells, none blank, a bare dash or "varies"; **19 inline tier markers** — 18 `[judgement]`, 1 `[gate: fail]`, **0** `[gate: prose]`, **0** `[gate: warn]`. See _The second review fix_ below |
| The Codd primary-source check — the source read, the date, and whether it found derivation or convergence                                                                                                                                                | Read 04/11/2026, openly hosted primary text: Codd, "Missing Information (Applicable and Inapplicable) in Relational Databases", SIGMOD Record 15(4), 1986, pp. 53-78 — p. 57 defines the "missing-but-applicable-value mark" (A-mark) and the "inapplicable-value mark" (I-mark); and Codd, "Extending the Database Relational Model to Capture More Meaning", ACM TODS 4(4), 1979, p. 408 — "value at present unknown" against "property inapplicable". The 1990 RM/V2 book was not read (no open copy). **Convergence, not derivation:** the absence map charted the six kinds (N-008, N-009, 31/08/2026) without Codd; his A-mark spans this guide's not-yet and not-supplied, and only not-applicable aligns with the I-mark. So **no README row**; the guide states that the split parallels Codd's marks, claiming no derivation (plan Key Decisions Q3)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `.claude/skills/codebase-design/SKILL.md` before and after the edit — counted lines, and every line using "boundary" (slot added 04/11/2026 by the build: plan Key Decisions Q2 requires it)                                                             | **96** counted lines before (`5baaac2`), **102** after (`99187e7`; +6, the scope paragraph). **Five** lines by `grep -n -i boundar` before the edit; the final review, against the scope paragraph as landed at `:50-55`, is _The codebase-design per-line review_ below. The provisional marks recorded here before the edit were superseded at the edit — see there                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| The "boundary" heading inventory — every match of `grep -rn -i -E '^#+ .*boundar' --include='*.md' code .claude how-to project-management/docs project-management/workflows` before the edit (slot added 04/11/2026 by the build: plan Key Decisions Q2) | 33 lines before the edit, 33 at `99187e7`, same file:line set, none edited. See _The boundary-heading inventory_ below — final: **none architectural**, none reworded                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

**The `doc-references.sh` baseline.** Captured 04/11/2026 at `5baaac2`, working tree clean, index
unstaged. Detector `code/src/scripts/audits/doc-references.sh` sha256
`2a0f2442532eecd762a83df4a3d37a4d2163f042f2e485982d77194364801897`. Exit 1: **564 findings, 269
distinct `(file, kind, token)` identities** — 461 instance citations, 94 dangling paths, 9
template-only citations. The raw output and the identity multiset are kept outside the tree, in
/tmp/us003-baseline/ (doc-references.before.txt, doc-references.before.ids) — 564 rows are not
reproduced here; the close diffs against that file.

**This story's own — expected to change:** 18 identities, 65 findings, every one `dangling path`
on `code/docs/ABSENCE.md`, clearing when P1 creates the guide. The citing files, with
multiplicity:

- **Stories:** US003 (3), US004 (3), US006 (1)
- **Sprints:** SPRINT-02 (8), SPRINT-03 (2), SPRINT-04 (2)
- **QA plans:** US003 (3), US004 (1), US005 (2), US006 (2)
- **Decisions:** the US003 citation-gate baseline-diff ADR of 02/09/2026 (1), the US003
  crib-self-contained ADR (2)
- **Sprint plans:** 02-SPRINT-PLAN-02 (6), 03-SPRINT-PLAN-03 (5)
- **Story plans:** this story's (5), US004's (1), US005's (3)
- **Manual testing guides:** this file (15)

The build's own edits to this story's PM artefacts may add occurrences of these same identities
before P1 lands; every one clears with them, so the comparison at the close is by identity.

**Not expected to change:** 1 identity, 1 finding — `dangling path` on
"code/docs/rendering/PITFALLS-AND-EXAMPLES.md#absence" in the US003 crib-self-contained ADR. The
ADR quotes it as the naive forward citation it rejects; the anchor is slice S-03's to write, not
this story's, and the detector tests the token as a literal path, so no heading would clear it.
Every other identity is pre-existing and owned outside this story.

**The codebase-design per-line review — final.** Read 04/11/2026 at `99187e7` against the scope
paragraph as landed (`.claude/skills/codebase-design/SKILL.md:50-55`): the ban binds "boundary"
only where it would name the place a module hides behaviour behind, while reasoning about depth;
it does not bind a trust or parse edge, a runtime or language edge, a transaction or delivery
edge, a DDD consistency boundary, a framework's own name, or the limit of a scope.

| Line (before → after) | Text before                                    | Architectural? | Action                                                 | Reason                                                                                                     |
| --------------------- | ---------------------------------------------- | -------------- | ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| `:36` → `:36`         | "the boundary a module hides behaviour behind" | Yes            | Reworded — "the place a module hides behaviour behind" | The seam's own definition used the banned synonym; the scope paragraph now reuses that wording as its test |
| `:47` → `:47`         | "boundary (for seam)"                          | No — a mention | Kept                                                   | The ban itself names the word; scoped by the new paragraph at `:50-55` directly below it                   |
| — → `:50-55`          | (new) the scope paragraph                      | No — mentions  | Added                                                  | Lists the non-seam edges that keep "boundary"; every use there is a mention                                |
| `:56` → `:63`         | "telling you the boundary is wrong"            | Yes            | Reworded — "the seam is in the wrong place"            | Names where a module hides behaviour, in the test-surface principle                                        |
| `:70` → `:77`         | "the single decrypt boundary"                  | Yes            | Reworded — "the single decrypt seam"                   | An anchor seam in the depth vocabulary's own examples                                                      |
| `:107` → `:114`       | "the review lens on seams and boundaries"      | Yes            | Reworded — "seams and module depth"                    | Architectural review lens; "boundaries" stood as a synonym for seams                                       |

**Superseded at the edit:** the provisional reading recorded before the first edit marked `:36`
compliant ("defines rather than substitutes"). Against the landed wording it is the seam's own
definition written with the banned synonym, and the scope paragraph needed a seam-only phrase to
reuse, so it was reworded too. `:47`, `:56`, `:70` and `:107` stand as provisionally read.

**The boundary-heading inventory — final.** Captured 04/11/2026 at `5baaac2`, before the first
edit, and re-run at `99187e7`: **33 matching lines across 27 files**, the same file:line set both
times — 31 Markdown headings, and 2 `#` comment lines inside fenced code
(`TYPES-OVER-DICTIONARIES.md:78`, `TYPES-EXCEPTIONS.md:98`) that the grep also matches. Read against
the scope as landed at `codebase-design/SKILL.md:50-55`: **none is architectural, and none was
reworded.**

**Superseded at the edit:** the provisional pass marked `NOTIFICATIONS.md:24` and
`mcp-server/TOOL-DESIGN.md:106` "reword" and five lines "borderline". Both "reword" marks read the
guide's subject (where a send or a classification happens) as the seam; the scope settled that the
word is judged by the edge it names. `:24`'s section is the delivery edge — an endpoint enqueues,
a task sends — and the scope keeps "a transaction or delivery one"; `:106`'s section is the single
place that decides what crosses from the tool surface to the client, a trust edge. Neither names
where a module hides behaviour while reasoning about depth. The borderlines resolved the same way.

| Line                                                                                                                                                                                                                             | Heading                                                                                                                                         | Architectural?                     | Action | Reason                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/NOTIFICATIONS.md:24`                                                                                                                                                                                                  | The send boundary                                                                                                                               | No — borderline (provisional: yes) | Left   | The delivery edge (enqueue, then a task sends); the scope keeps a delivery boundary. Borderline only because it sits at the service layer |
| `code/docs/mcp-server/TOOL-DESIGN.md:106`                                                                                                                                                                                        | One boundary, not one per tool                                                                                                                  | No (provisional: yes)              | Left   | The trust edge — what crosses from the tool surface to the client, decided once in middleware                                             |
| `code/docs/TASK-AUTHORING.md:45`                                                                                                                                                                                                 | The enqueue boundary                                                                                                                            | No (provisional: borderline)       | Left   | Named in the scope paragraph itself as a transaction or delivery edge                                                                     |
| `code/docs/rust/PYO3-BOUNDARY.md:73` · `code/workflows/12-rust-extension/STEPS.md:78` · `code/workflows/12-rust-extension/CHECKLIST.md:24`                                                                                       | Keep the boundary thin · Add the thin boundary · Boundary                                                                                       | No (provisional: borderline)       | Left   | The FFI edge; the scope names "the PyO3 boundary" as a runtime or language one                                                            |
| `how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md:166`                                                                                                                                                                            | The boundary, stated once                                                                                                                       | No (provisional: borderline)       | Left   | An ownership split between repositories — the limit of a scope, not a module's seam                                                       |
| `code/docs/rust/PYO3-BOUNDARY.md:7`, `:17` · `.claude/skills/stack-rust/SKILL.md:113`                                                                                                                                            | PyO3 Boundary · Never panic across the boundary · The boundary: never panic into Python                                                         | No                                 | Left   | The Rust/Python language edge                                                                                                             |
| `code/docs/DESKTOP.md:51` · `code/workflows/13-desktop-app/CHECKLIST.md:43`                                                                                                                                                      | The surface boundary · Boundary and security                                                                                                    | No                                 | Left   | The edge between deployables                                                                                                              |
| `code/docs/DESKTOP.md:95` · `code/docs/desktop/UI-AND-STATE.md:47` · `.claude/skills/stack-slint/SKILL.md:108`                                                                                                                   | The generated-code lint boundary                                                                                                                | No                                 | Left   | A lint scope                                                                                                                              |
| `code/docs/PROCESS-MODEL.md:98`                                                                                                                                                                                                  | The ORM's sync boundary                                                                                                                         | No                                 | Left   | The sync/async runtime edge, named in the scope paragraph                                                                                 |
| `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md:57`, `:78` · `code/docs/data-structures/TYPES-EXCEPTIONS.md:79`, `:98` · `code/docs/data-structures/TYPES-TYPESCRIPT.md:210` · `code/docs/MOBILE-CODING-PRINCIPLES.md:114` | Parse at the boundary · the two fenced comments · The serialisation boundary · Parsing at the fetch boundary · a boundary that proves otherwise | No                                 | Left   | The input/trust edge where a payload is parsed; "parse at the boundary" is the scope's own example                                        |
| `code/docs/MOBILE-CODING-PRINCIPLES.md:165`                                                                                                                                                                                      | One error boundary, at the root                                                                                                                 | No                                 | Left   | The framework's own term (`ErrorBoundary`)                                                                                                |
| `code/docs/data-structures/DOMAIN-MODELLING.md:107`                                                                                                                                                                              | Aggregates and Boundaries                                                                                                                       | No                                 | Left   | The DDD consistency boundary                                                                                                              |
| `code/docs/security/AUDIT-TRAIL.md:122` · `code/docs/GATE-REPORTING.md:98` · `code/src/scripts/dependencies/CONTEXT.md:79`                                                                                                       | its boundary · The boundary with a zero population · the template boundary                                                                      | No                                 | Left   | The limit of a rule, a population or a repository                                                                                         |
| `.claude/skills/prototype/SKILL.md:115` · `.claude/skills/to-questionnaire/SKILL.md:105` · `how-to/docs/OPERATOR-DOC-CRAFT.md:91` · `how-to/workflows/CONTEXT.md:68`                                                             | its boundary · Boundaries · Scope boundaries · Boundaries worth knowing                                                                         | No                                 | Left   | Scope of a document or skill                                                                                                              |
| `project-management/workflows/14-logging-checks/CHECKLIST.md:43` · `project-management/workflows/22-implementation-documentation/STEPS.md:57`                                                                                    | Audit trail boundary · Confirm the Absorption Boundary                                                                                          | No                                 | Left   | Scope of a workflow's duty                                                                                                                |

**The gates at the close.** Run 04/11/2026 at `99187e7`, working tree clean, before this file's
own close edits: `routing-skills.sh` exit **0** (612 names across 264 files resolve);
`skill-conformance.sh` exit **0** (65 skills conform); `doctrine-drift.sh` exit **0** (4 claims,
each with exactly one home); `doctrine-drift.sh --self-test` exit **0** (broken/ trips 2 clauses,
clean/ none); `docs-pairing.sh` exit **0** (233 `CONTEXT.md`, 223 `CLAUDE.md`, split intact);
`docs-length.sh --since testing` exit **0** (`testing` is the branch point, `b7c7c2c`; 807 files
within 300, 3 approaching — `FIELD-ENCRYPTION.md` 291, `SEO-CHECKLIST.md` 289, `VISUAL-DESIGN.md`
287, none touched by this story) and plain `docs-length.sh` exit **0**, the same figures.

**The review fix — corrected 04/11/2026.** Applied after the independent review and QA pass and
committed as `8a9e245` (parent `e1afd7b`). Every figure above that it moves is marked _Corrected at the review
fix_; the birth figures stand as measured.

- **Crib cells changed:** Expected miss × Python (`ServiceNotFoundError` named a miss on the error
  channel, not a failure), × Alpine (a frozen `"not-found"` state set by the component's `fetch`),
  × HTMX (200 with the not-found partial, never a 4xx — the shipped `observability.js` handler acts
  on 5xx alone); Not-yet × Python (`TextChoices` on the model, `StrEnum` where serialised off it);
  Empty × Alpine (`results: []` through an `x-if` empty state); Failure × Python (bar
  `ServiceNotFoundError`), × HTMX (swapped into the error region); Not-supplied × Python
  (`model_fields_set` where omitted and `null` differ); Not-applicable × Alpine (`x-if`, never
  `x-show`) and × HTMX (a server `{% if %}`).
- **Prose changed:** the marker vocabulary now routes to `code/docs/VISUAL-DESIGN.md` Section 6
  and the guide uses `[gate: fail]` and `[judgement]` only — the 204 clause re-tiered from
  `[gate: prose]` to `[judgement]`; the `[gate: fail]` clause narrowed to what the `absence-enum`
  regex matches, with a new `[judgement]` clause for every other spelling; not-supplied's question
  reads "a person's"; the Harper sentence reworded; a sentence under the crib cites
  `rendering/PITFALLS-AND-EXAMPLES.md` for the HTMX column; both `TYPES-RUST.md` citations flagged
  **Rust-only**.
- **Other files:** `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` 240 → **241** counted lines
  ("the seam is in the wrong place", in step with `codebase-design`);
  `.claude/skills/improve-codebase-architecture/HTML-REPORT.md` **97** → **97** (its unscoped
  ban now routes to `codebase-design`); `.copier/README.md` gains the Harper _Influences_ row and
  the `ABSENCE.md` Project Tree entry (`.github/scripts/shipped-readme.sh` was red at `e1afd7b` on
  the missing entry, green after). The four reciprocity skills are untouched.
- **Gates after the fix:** `docs-length.sh` plain and `--since testing` exit **0** (807 files, 3
  approaching, none touched); `docs-pairing.sh`, `routing-skills.sh`, `skill-conformance.sh`,
  `doctrine-drift.sh` and its `--self-test` exit **0**; `doc-references.sh --path` on each of the
  four edited files exits **0** with no finding, so no identity is new against the baseline.
- **The baseline multisets, for a walker after `/tmp` is gone:** sha256
  `9103457bfff1a0df920f39d8b196da01c0a42641e8c96332586b79cde5ff5778` (before) and
  `1c3f4e5eb5ca9c69aaf5d3decb3865f0c9395c7e9203f2e5086d5374be63392b` (after), each the
  `(file, kind, token)` triples parsed from `doc-references.sh`'s finding lines, sorted, counted
  with `uniq -c`.

**The second review fix — corrected 05/11/2026.** Applied on `8a9e245` after the targeted
re-review of the first fix round, staged, not committed. Decisions D1 and D2 are the story plan's
_Key Decisions_ → _Settled at the review-fix grilling, 05/11/2026_.

- **Crib cells changed:** Expected miss × Python (404 on the JSON API, caught by an HTMX-facing
  view), × Alpine (the server's partial carries it; Alpine does not fetch — D2), × HTMX (200 while
  the global handler retargets 5xx only — conditional, D1), × mobile (array index, `Map.get` or
  `Array.find`); Not-yet × Alpine (`STATUS.LOADING`), × mobile (`{ kind: "loading" }`); Empty ×
  Alpine (a live filter, keyed on `STATUS.DONE` as well as the array, its count in the persistent
  `role="status"` region); Failure × Python (`DependencyUnavailable`, 503), × Alpine (the server's
  error partial), × HTMX (a non-form 4xx shows nothing until `S-03`), × mobile (a throw routed
  through `classify()`, or a `{ kind: "failed"; reason }` member); Not-supplied × Python
  (`apps.core.schemas.Schema` or `QuerySchema`; a form key cleans to its empty value, never its
  `initial`), × Rust (`#[serde(default)]`; `Option<Option<T>>` behind a deserialiser that maps a
  present `null` to `Some(None)`), × mobile (the parse function maps `null` to an absent key);
  Not-applicable × Python (the domain type against the model's nullable column under a
  `CheckConstraint`), × Alpine (client-side applicability only: `x-if` or `:disabled`, and out of
  any payload the component builds).
- **Prose changed:** the not-supplied question reads "the caller's … rather than a process's to
  produce", and its tie-break "waiting on the caller"; the notes under the crib state the HTMX
  column's scope and its `S-03` dependency, the JSON API's 404 and envelope, the anti-enumeration
  clause, why Alpine does not fetch, the `SCHEMA-DESIGN.md` route, and a **Mobile-only.** note on
  `classify()`; the absence-enum example's base is `(Enum)` with `auto()` values and a `match`
  closing on `case _: raise InvariantViolation(...)`; the `[gate: fail]` clause says "whatever the
  fence's language" and "outside this guide"; the marker legend says no audit lists the
  `[judgement]` clauses. Four `[judgement]` clauses are new: the HTMX-facing catch, the
  anti-enumeration clause, Alpine does not fetch, and the mandatory `case _:` arm.
- **Other files:** `.claude/skills/frontend/SKILL.md` **132** → **132** ("a not-found partial" for
  "a 404"; the backend, code-reviewer and refactor pointers checked, no HTMX status claim, left);
  `.claude/skills/improve-codebase-architecture/SKILL.md` **109** → **109** (its unscoped
  ban now routes to `codebase-design`'s _Vocabulary — use exactly_).
- **Gates after the fix:** `docs-length.sh` plain and `--since testing` exit **0** (807 files, 3
  approaching, none touched); `docs-pairing.sh`, `routing-skills.sh`, `skill-conformance.sh`,
  `doctrine-drift.sh` and its `--self-test`, and `.github/scripts/shipped-readme.sh` exit **0**;
  the `absence-enum` regex still matches `class VatNumberAbsence(Enum):`. `doc-references.sh
--path` exits **0** on `ABSENCE.md`, both skills and this file; on the story plan it exits 1 with
  six findings, every identity already in the baseline, so none is new.

**The `doc-references.sh` run after the build.** Captured 04/11/2026 at `99187e7`, the close edits to this file, the story and the plan staged (index staged, porcelain 3 staged, 0 unstaged), nothing else edited during the run. Detector sha256 `2a0f2442532eecd762a83df4a3d37a4d2163f042f2e485982d77194364801897`, unchanged from the baseline. Exit 1: **499 findings, 251 identities**. Multiset diff against /tmp/us003-baseline/doc-references.before.ids (after-run kept at /tmp/us003-close/): **NEW — 0 identities, 0 increased counts. GONE — 18 identities, 65 findings**, every one `dangling path` on `code/docs/ABSENCE.md`, exactly the set expected above; no other identity decreased. The index state differs from the baseline's (staged against unstaged) only by this story's own PM edits, which add no identity.

Keep the raw gate output, including line numbers, beside each capture for diagnosis. Compare
the stable identities as a multiset: a repeated identity retains its occurrence count; moving
an unchanged citation to another line creates no new finding. Detector and git-index state
must match across the comparison.

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The guide and its frontmatter

| ID       | Action                                               | Expected outcome                                                                                                                                                                         | Flow | QA           | Result | Notes |
| -------- | ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| GUIDE-01 | Open `code/docs/ABSENCE.md`                          | It exists, and opens with the standard header block, its Claude Model line included                                                                                                      | —    | HP-01        |        |       |
| GUIDE-02 | Read its frontmatter                                 | Routing frontmatter — `type: guide`, `skills:` and `model:` — whose `skills:` names `backend`, `frontend`, `code-reviewer` and `refactor` and no other; `stack-django` is not among them | —    | HP-01, EC-04 |        |       |
| GUIDE-03 | Run `bash code/src/scripts/audits/routing-skills.sh` | Exits 0, with every frontmatter name resolved — including through the wrapped-array form Prettier forces at `printWidth: 100`                                                            | —    | HP-01        |        |       |

### Registration

| ID          | Action                                                                                                        | Expected outcome                                                                           | Flow | QA    | Result | Notes |
| ----------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| REGISTER-01 | Open the root `REFERENCES.md`, `code/REFERENCES.md` and `code/docs/CONTEXT.md`, and re-read each row in place | Each carries an index row for `code/docs/ABSENCE.md`, and each row reads true of the guide | —    | HP-01 |        |       |
| REGISTER-02 | Read `code/docs/CONTEXT.md`'s directory tree                                                                  | It carries an entry for `ABSENCE.md`                                                       | —    | —     |        |       |
| REGISTER-03 | Open `code/CONTEXT.md`                                                                                        | No row for `ABSENCE.md` — it carries none for either guide born since charting             | —    | —     |        |       |

### Length and the ratchet

| ID        | Action                                                                                                           | Expected outcome                                                                                     | Flow | QA    | Result | Notes |
| --------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| LENGTH-01 | Run `bash code/src/scripts/audits/docs-length.sh --path code/docs --limit 1`                                     | `code/docs/ABSENCE.md` is listed at under 270 counted lines, matching the figure recorded above      | —    | HP-02 |        |       |
| LENGTH-02 | Run `bash code/src/scripts/audits/docs-length.sh` with `--since` set to the commit the story branch was cut from | The ratchet fails nothing: no file the story edited that sat at or above 270 counted lines has grown | —    | HP-02 |        |       |
| LENGTH-03 | Run `bash code/src/scripts/audits/docs-length.sh`                                                                | No new file is reported at or above the warn tier                                                    | —    | HP-02 |        |       |
| LENGTH-04 | Compare the four named skills' before and after figures recorded above                                           | No skill that sat at or above 270 counted lines before its reciprocity edit has grown                | —    | —     |        |       |

### The six kinds and the crib

| ID       | Action                                                                                             | Expected outcome                                                                                                                                        | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| KINDS-01 | Read the guide's six kinds                                                                         | Expected miss, not-yet, empty, failure, not-supplied and not-applicable are each named and distinguished from the other five                            | —    | HP-03 |        |       |
| KINDS-02 | Look for the guide's claim of exhaustiveness and mutual exclusion, and for its tie-breaks          | Stated: the six cover the absences this stack produces and any absence maps to exactly one; wherever two could plausibly apply, the tie-break is stated | —    | HP-03 |        |       |
| KINDS-03 | Using only the guide, classify an absence that could read as either not-supplied or not-applicable | The stated tie-break resolves it to exactly one kind                                                                                                    | —    | EC-01 |        |       |
| KINDS-04 | Read the crib's surfaces                                                                           | Python, Rust, Alpine, HTMX and mobile TypeScript, mapped against all six kinds — those five surfaces and no others                                      | —    | HP-03 |        |       |
| KINDS-05 | Read every cell of the crib                                                                        | Each names a concrete expression, or states why that kind cannot arise on that surface; no cell is blank, a bare dash, or the word "varies"             | —    | HP-03 |        |       |
| KINDS-06 | Find a cell for a kind that cannot arise on its surface                                            | The cell says so, and gives the reason                                                                                                                  | —    | EC-02 |        |       |
| KINDS-07 | Check every crib cell for a citation                                                               | No cell cites anything that does not yet exist — each is self-contained at birth                                                                        | —    | —     |        |       |

### The boundary with the `TYPES-*` family

| ID          | Action                                                                                             | Expected outcome                                                                                                                                                                            | Flow | QA    | Result | Notes |
| ----------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| BOUNDARY-01 | Read the crib's Rust entry                                                                         | It cites `code/docs/data-structures/TYPES-RUST.md` → _Option and Result, never sentinels_ rather than restating it                                                                          | —    | HP-04 |        |       |
| BOUNDARY-02 | Find the absence-enum rule                                                                         | Stated in this guide: an absence with more than one meaning is modelled as an enum rather than a null                                                                                       | —    | HP-04 |        |       |
| BOUNDARY-03 | Find the never-overload rule                                                                       | Stated in this guide, citing `code/docs/rls/MIDDLEWARE-AND-NINJA.md` → _Row locking_ — the guard paragraph, where "No row" has two causes that look identical — as its one shipped instance | —    | —     |        |       |
| BOUNDARY-04 | Read the guide's _What this is not_                                                                | `GATE-REPORTING.md`, `FORWARD-VOICE.md` and `NEGATIVE-SPACE.md` are named there as siblings, and none of them appears as a crib row                                                         | —    | —     |        |       |
| BOUNDARY-05 | Compare the guide's headings with the H2s of the six `code/docs/data-structures/TYPES-*.md` guides | No `TYPES-*` H2 is restated                                                                                                                                                                 | —    | —     |        |       |
| BOUNDARY-06 | Read the guide against the six `TYPES-*` guides, rule by rule                                      | No rule is stated in two homes, and every shape rule is left where it already lived                                                                                                         | —    | —     |        |       |

### Enforcement tiers

| ID      | Action                                                                                                                                                      | Expected outcome                                                                              | Flow | QA    | Result | Notes |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| TIER-01 | Read the guide clause by clause — every sentence or bullet stating a rule a reader is expected to obey, and not the headings, worked examples or crib cells | Each clause carries an inline marker — `[gate: fail]`, `[judgement]` or `[gate: prose]`       | —    | HP-05 |        |       |
| TIER-02 | Read each `[gate: fail]` marker                                                                                                                             | Each names the gate that enforces it, and says so where that gate's workflow is path-filtered | —    | HP-05 |        |       |
| TIER-03 | Search the guide for `[gate: warn]`                                                                                                                         | No clause carries it                                                                          | —    | HP-05 |        |       |
| TIER-04 | Look for a single document-level marker, then read the crib's cells for markers                                                                             | No document-level marker stands in for the per-clause ones, and no crib cell carries a marker | —    | HP-05 |        |       |

### Reciprocity

| ID       | Action                                                                                                                                                     | Expected outcome                                   | Flow | QA    | Result | Notes |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- | ---- | ----- | ------ | ----- |
| RECIP-01 | Open `.claude/skills/backend/SKILL.md`, `.claude/skills/frontend/SKILL.md`, `.claude/skills/code-reviewer/SKILL.md` and `.claude/skills/refactor/SKILL.md` | Each cites `code/docs/ABSENCE.md`                  | —    | HP-06 |        |       |
| RECIP-02 | Run `bash code/src/scripts/audits/skill-conformance.sh`                                                                                                    | Exits 0 — clause 14 discharged for all four skills | —    | HP-06 |        |       |

### The drift row

| ID       | Action                                                              | Expected outcome                                                                                                                            | Flow | QA           | Result | Notes |
| -------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| DRIFT-01 | Open the drift table in `code/src/scripts/audits/doctrine-drift.sh` | It carries one new `owned` row pinning the absence-enum rule to `code/docs/ABSENCE.md`                                                      | —    | HP-07        |        |       |
| DRIFT-02 | Run `bash code/src/scripts/audits/doctrine-drift.sh`                | Exits 0: the new row is green and no existing claim forks. A regression guard only — it reads fenced code, and BOUNDARY-06 checks the prose | —    | HP-04, HP-07 |        |       |

### The boundary-vocabulary ban

| ID     | Action                                                                                          | Expected outcome                                                      | Flow | QA           | Result | Notes |
| ------ | ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| BAN-01 | Open `.claude/skills/codebase-design/SKILL.md` at its ban on substituting "boundary" for "seam" | The ban is scoped to architectural contexts, not the whole repository | —    | HP-08        |        |       |
| BAN-02 | Check each of that file's four uses of "boundary" against the new scope                         | Each is compliant — any that still violated has been reworded         | —    | HP-08, EC-06 |        |       |
| BAN-03 | Find the commit that scoped the ban                                                             | It is the commit that adds `code/docs/ABSENCE.md`, not a follow-up    | —    | —            |        |       |

### Attribution

| ID        | Action                                                                                                                      | Expected outcome                                                                                                                                                                                                                                                                               | Flow | QA           | Result | Notes |
| --------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| CREDIT-01 | Open `README.md` → _Influences_                                                                                             | A row for Robert Harper's Boolean Blindness, credited for the absence-enum rule, stating its licence — not share-alike                                                                                                                                                                         | —    | HP-09        |        |       |
| CREDIT-02 | Look for E. F. Codd's applicable/inapplicable null marks — a row in the same table, or a sentence in `code/docs/ABSENCE.md` | Exactly one of the two. A row crediting them for the not-supplied and not-applicable kinds, its licence stated and not share-alike; or — where the primary-source check found convergence — no row, and a guide sentence stating that the split parallels Codd's marks, claiming no derivation | —    | HP-09, EC-05 |        |       |
| CREDIT-03 | Compare the outcome of CREDIT-02 with the primary-source check recorded above                                               | The check is recorded, and done before the row or sentence was written; derivation produced the row, convergence the sentence                                                                                                                                                                  | —    | —            |        |       |
| CREDIT-04 | Find the commits that added each _Influences_ row and the rule it credits                                                   | Each row landed in the same commit as its rule                                                                                                                                                                                                                                                 | —    | —            |        |       |

### The citation gate, as a diff

| ID        | Action                                                                                                                                                            | Expected outcome                                                                                                                                                                                                                                                               | Flow | QA    | Result | Notes |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| DOCREF-01 | Run `bash code/src/scripts/audits/doc-references.sh` in the git-index state the baseline recorded, and compare its findings with the baseline, finding by finding | No finding is absent from the baseline: no shipped file the story wrote or edited — the guide, the four skills, `README.md` and the drift table among them — adds an unresolved citation of any class. Recorded as a diff, never as the gate passing while the baseline stands | —    | EC-07 |        |       |
| DOCREF-02 | In the same output, look for the forward references to `code/docs/ABSENCE.md` the baseline recorded                                                               | All have cleared — the guide they name now exists                                                                                                                                                                                                                              | —    | EC-07 |        |       |

### The cold read

| ID      | Action                                                                                                           | Expected outcome                                                                                                                   | Flow | QA  | Result | Notes |
| ------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| COLD-01 | Open `code/docs/ABSENCE.md` cold, as a developer who has not seen the change, with a given `return None` in mind | You can name which of the six kinds it means, and read its expression for your surface off the crib, without opening a second file | —    | —   |        |       |

### The gates still bite

Each row sets up its failure on the finished change, runs the gate, then undoes the set-up; a
clean re-run of the same gate confirms the undo before the next row.

| ID      | Action                                                                                                                                                                       | Expected outcome                                                                                                                                                     | Flow | QA    | Result | Notes                                                                                                                  |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ---------------------------------------------------------------------------------------------------------------------- |
| BITE-01 | Pad `code/docs/ABSENCE.md` to 270 counted lines or more, run `bash code/src/scripts/audits/docs-length.sh`, then undo                                                        | The guide is reported in the warn tier, with no allowance                                                                                                            | —    | ES-01 |        |                                                                                                                        |
| BITE-02 | Remove the `code/docs/ABSENCE.md` citation from one of the four named skills, run `bash code/src/scripts/audits/skill-conformance.sh`, then restore it                       | Exits non-zero, naming the undischarged clause 14                                                                                                                    | —    | ES-02 |        |                                                                                                                        |
| BITE-03 | Misspell one skill name in the guide's routing frontmatter, run `bash code/src/scripts/audits/routing-skills.sh`, then restore it                                            | Exits non-zero, naming the unresolved skill                                                                                                                          | —    | ES-03 |        |                                                                                                                        |
| BITE-04 | In a disposable checkout, restate one TYPES rule in the prose of `code/docs/ABSENCE.md`; perform the BOUNDARY-06 rule-by-rule human read-across, then undo and repeat it     | The read-across identifies the duplicated rule and its two locations; after undo the duplication is absent. No prose-detection claim is made for `doctrine-drift.sh` | —    | ES-04 |        | Corrected 09/10/2026 — was a gate assertion for prose; evidence: QA ES-04 and the accepted prose-verification boundary |
| BITE-05 | In one crib cell, cite a per-surface clause no slice has written yet, run `bash code/src/scripts/audits/doc-references.sh`, then undo                                        | Exits non-zero, with a dangling-path finding for that citation beyond the baseline                                                                                   | —    | ES-05 |        |                                                                                                                        |
| BITE-06 | With the story committed, pad `code/docs/ABSENCE.md` until it measures at least 270 counted lines, run `bash code/src/scripts/audits/docs-length.sh --since HEAD`, then undo | The ratchet fires on the uncommitted growth — the change that grew the file — and not on the story's committed guide                                                 | —    | EC-03 |        |                                                                                                                        |

---

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID  | What happened | Blocks the story? | Routed to |
| --- | ------------- | ----------------- | --------- |

---

## Tester sign-off

Filled at the walk.

| Field        | Value                                         |
| ------------ | --------------------------------------------- |
| **Tester**   |                                               |
| **Date**     |                                               |
| **Browsers** | N/A — Gate surface; no browser is opened      |
| **Outcome**  | Passed / Passed with notes / Failed / Blocked |
| **Blockers** |                                               |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against `../AUTOMATED/US003-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test
- [ ] The tester is not the story's author — the story's _QA Acceptance Criteria — Manual_

---

## Cross-references

- `../../02-STORIES/US003.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US003-TEST-STATUS.md` — the paired automated-test record; written at `22-implementation-documentation` Step 4, so absent until then
- `../../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — the QA implementation record, written at `22`: whether the specified scenarios were met
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `../../15-DECISIONS/ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH-02-09-2026.md` — why no crib cell cites forward
- `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` — why the read-across, not `doctrine-drift.sh`, checks the prose
- `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — why `doc-references.sh` is read as a diff against the baseline; superseded 30/09/2026 by `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`, which restates it unchanged and names this file as where the baseline is recorded
- No `05-USER-FLOW` citation: the story's `User Flow` flag is N/A, so no consolidated flow or flow implementation record exists for it

<!-- CORRECTED 09/10/2026 after adversarial review: citation baseline identities now omit
     line numbers and preserve multiplicity, following the US007 QA-plan comparison rule.
     Raw diagnostics remain recorded; no build capture or manual Result has been filled. -->

<!-- CORRECTED 09/10/2026 after adversarial review: Open question 1 resolved against the accepted prose-verification decision. -->
