@./CONTEXT.md

# CLAUDE.md — scripts/audits/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script inventory, the slop-family split, flags, exit codes — imported above) → this file →
`rules/CLAUDE.md` when touching a static-analysis rule → `reports/`.

## Purpose (one line)

Host-run codebase-health audits — line-count enforcement, stub detection, the token-first
guards for both surfaces (`css-tokens.sh`, `mobile-tokens.sh`), the AI-slop family, static
analysis, the seam and orphan guards, and the dependency CVE audit. Full inventory:
`CONTEXT.md`.

## How to work here

- **Routing:** run these before raising a PR; they back the `07-review` workflow and
  the pre-PR quality gates. Everything here runs on the host with no Docker; `security.sh`
  is the exception that _can_ containerise, defaulting to the host with `--docker` to audit
  inside the running dev stack. Rule changes for `static-analysis.sh` go to `rules/CLAUDE.md`,
  never into the script.
- **Model:** Opus to change audit logic (thresholds, patterns, exit codes)
  and to run an audit.
- **Concrete steps:** invoke the audit → fix real findings in source, **never** by
  loosening a threshold to pass → re-run until clean → keep `security.sh` at
  `pip-audit` for CI parity (`uv audit` is a different, experimental tool).
- **Adding an audit:** derive it from a stated rule in a `docs/` guide, never from taste →
  decide its **input language** first, because that decides which script it joins and which CI
  path filter fires → give every clause a tier the guide also carries → add the row to
  `CONTEXT.md`'s inventory and requirements tables **in the same change**. A script with no row
  is invisible: the inventory is the count, so a register that omits it reads as complete.
- **Definition of done:** exit `0`; the 750-warn/800-fail source line limit and the
  300-line instructional cap both respected; every
  `var(--x)` resolves to a defined token; no hard stubs outside a declared TDD red
  phase; `CONTEXT.md` lists every script actually present in the folder.

## Guardrails

- **`css-tokens.sh` enforces token-first CSS** — a `var(--x)` that resolves to no
  defined token fails the run; add the token in the token layer, never silence the
  audit. **`mobile-tokens.sh` is its mobile counterpart** and enforces the same law with
  a different clause (no raw literals in `StyleSheet`); its `token-allow` annotation is
  for genuinely structural values only, never to defer real design debt.
- **A self-guarding audit must exit 0, not fail, when its surface is absent.**
  `mobile-tokens.sh` returns success with a note on a web-only project — that is what
  lets it run unconditionally in CI without a step-level guard. The same holds for
  `seam-contract.sh`, the slop family and `static-analysis.sh`.
- **Never point a copy audit at instructional Markdown.** `copy-emdash.sh` and `copy-slop.sh`
  enforce `how-to/src/BRAND-VOICE.md` § 4, which governs copy a **user reads** — never `docs/`,
  `CONTEXT.md`/`CLAUDE.md`, code comments, commit messages or ADRs. Widening their scope to
  `**/*.md` would fail this repository on the guides that define the rule. Add a scope only when
  a new **user-facing** surface gets a home in the tree.
- **`docs-pairing.sh` checks shape, never quality — and a finding is moved, not deleted.**
  It can prove a `CONTEXT.md` has an opening paragraph; it cannot tell whether that paragraph
  explains why the directory exists, which is why the _why_ is its one warn-tier row and a
  reviewer's judgement (`code/docs/DOCUMENTATION-PAIRING.md` §8). The tempting way to clear a
  banned-heading finding is to delete the section — a `## Rules` block in a `CONTEXT.md` moves
  to the paired `CLAUDE.md`'s **Guardrails**, or to the `docs/` guide that owns the rule. It
  does not evaporate.
- **A `[gate: warn]` is a question, not noise — and exit 0 is not the same as clean.** The slop
  family reports two tiers in one run and only a fail changes the exit code, because a threshold
  on composition or vocabulary fails correct work (`code/docs/VISUAL-DESIGN.md` § 6). Answer each
  warning; never promote one to a fail to force the issue, and never raise a threshold to silence
  one.
- **Answer a warning with an annotation, and name the clause.**
  `slop-allow: superlative — the client's registered product name` records the judgement where the
  next reader will see it. A bare `slop-allow` silences everything on the line including a tell
  nobody examined, so reserve it for the rare case where that is genuinely what you mean. Never
  strip a clause from a script to stop it reporting — that removes the question for everyone.
- **An annotation carries a reason or it is not an annotation.** The mechanism exists so a
  deliberate choice survives review; a bare marker with no words after it is indistinguishable
  from someone silencing an audit they did not read.
- **Do not merge the slop family into one script.** The split is by **input language** because a
  CI path filter is a file glob — one script over CSS, markup and prose fires on every change to
  any of them. A new clause joins the script matching its input, or gets a new sibling; the
  desktop leg stays at `../desktop/style-check.sh`. **`render-slop.sh` is the one member that
  input language does not place** — it reads the same HTML as the markup leg — and the second axis
  is stated in `CONTEXT.md` rather than left as a silent exception: its clause does not exist until
  the input is **rendered**. Keep the browser dependency in that script alone; folding it into
  `template-slop.sh` would put a Chromium download on every template change.
- **A gate you have never watched fail is not a gate.** `render-slop.sh --self-test` renders a
  known-positive and a known-negative screen and asserts it separates them, because this template
  ships no consolidated wireframes and its ordinary run would otherwise be green for the whole
  life of the rule, having measured nothing — the exact defect `docs-length.sh` was written to
  close. **Fix the detector, never the fixtures**, and note that the self-test deliberately exits
  **2** without a browser where the ordinary scan exits 0: a proof that cannot fail is worse than
  no proof, because its green result is believed.
- **Narrow what an audit looks at; never soften what it concludes.** `seam-contract.sh` flagged
  34 issues on its first draft, 33 of them false, and the fix was scope, not severity.
- **Line limit is a hard gate:** ≥ 800 lines fails — split the file, do not raise the
  ceiling.
- TDD/BDD red phase is the _only_ sanctioned stub bypass, via `STUBS_TDD_RED=1`;
  never disable `stubs.sh` any other way. **It does not reach `cargo clippy`**, and no
  environment variable does — a red-phase Rust stub carries `#[allow(clippy::todo)]` on
  the item instead, which is scoped, visible in the diff, and has to be deleted to go
  green (`code/docs/rust/PYO3-BOUNDARY.md`).
- **Where a compiler can enforce a rule, it beats a grep.** The Rust panicking macros are
  denied in each crate's `[lints.clippy]` rather than pattern-matched here, because clippy
  parses the language and offers a per-site `#[allow]` carrying a reason. Reach for
  `stubs.sh` for what no compiler sees — a `// STUB` comment — and add the rest as a lint.
- **Never make a second script enforce a rule that already has one.** `skill-conformance.sh`
  checks a skill's frontmatter and its routing section and deliberately says nothing about its
  length, because `docs-length.sh` already owns the 300-line cap across all of `.claude/**`. Two
  enforcers of one rule drift the moment the number changes, and the one that is wrong is
  believed exactly as much as the one that is right. Route a skill finding by what it is about:
  **shape → `skill-conformance.sh`, size → `docs-length.sh`, does the named skill exist →
  `routing-skills.sh`.** That third one is a genuinely different surface, not a fourth opinion on
  the same file: `skill-conformance.sh` reads `metadata.skills` **inside** a `SKILL.md`, while
  `routing-skills.sh` reads the `skills:` key in the routing frontmatter of a `docs/` guide or a
  workflow `STEPS.md`. Different key, different file, and neither can see the other's.
- **A vendored skill is exempt from the house rules and bound by the spec.** The `cloudinary-*`
  folders are symlinks refreshed from upstream through `skills-lock.json`, so an edit made to
  satisfy a house clause is reverted by the next refresh — which is why `skill-conformance.sh`
  detects them by **symlink**, never by name. A vendored set that arrives as a _copy_ is
  authored content living here and is held to every clause; do not widen the exemption to
  cover it.
- **Markdown is exempt from the _source_ limits, not from every limit.** Do not extend
  `stubs.sh` or `cloc.sh` to `*.md` — but instructional Markdown has its own cap, **300 cloc
  code lines** (`.claude/CLAUDE.md` § 8), and `docs-length.sh` owns it. Two limits, two
  metrics, two scripts: `cloc.sh` counts total `wc -l` against 750/800 on source,
  `docs-length.sh` counts cloc code lines against 300 on instruction. Route a length question
  by which of those it is, and never answer it with the wrong script — that is the exact defect
  `docs-length.sh` was written to close (`CONTEXT.md` → _Markdown: two limits, two scripts_).

## Output & naming

- **Hand-written:** every `*.sh` audit script in this folder, and the `*.yml` rule set in
  `rules/` (its own `CLAUDE.md` governs those). `CONTEXT.md`'s script inventory is the count —
  no number is repeated here, because it goes stale on every audit added.
- **Generated / gitignored:** report files under `reports/`, named `<script>-report.<FORMAT>`
  via `--output <FORMAT>`.
- **A report is written on every path, including the no-op one.** An absent surface writes a
  clean, zero-finding report naming the reason rather than leaving nothing on disk — a CI job
  told to collect the artefact must always find it, and under `--quiet --output json` a missing
  file is no signal at all.
- Scripts `kebab-case.sh`; report formats `md` / `txt` / `json` / `html`.
