# Interpretable Context Methodology (ICM)

## Question

Does ICM — folder structure as agent orchestration, as published by Van Clief and McDermott and
shipped as two repositories — hold up as a primary source this template can derive doctrine from,
and what specifically is worth taking?

## Verdict

**A well-argued design pattern with honest sourcing, not an empirical result.** The paper states
outright that no controlled comparison against monolithic prompting has been run; every quantitative
figure in it is self-reported or illustrative. The doctrine is nonetheless the same doctrine
syntek-base already runs, stated independently, and **three ideas are worth taking**: the walk test,
docs-over-outputs, and selective section routing. Nothing here should be adopted wholesale — both
repositories demonstrate the method's own failure mode, and the enforcement layer syntek-base has is
exactly what they lack. Licences are permissive throughout (paper CC BY 4.0, both repos MIT), with
one carve-out noted below.

---

## Claims — the paper

**arXiv:2603.16021v2, 18 Mar 2026, cs.AI / cs.HC, CC BY 4.0.** 21 pages, 5 figures, 2 tables,
54 references. Authors Jake Van Clief and David McDermott, Eduba / University of Edinburgh.
— `https://arxiv.org/abs/2603.16021` (abstract page: title, subjects, licence, submission history);
local copy `research/jve-interpretable-context-methodology-paper-2603.16021v2.pdf`, PDF `/Count 21`.

- **The thesis.** For sequential workflows where a human reviews output between steps, filesystem
  structure replaces framework-level orchestration: numbered folders carry sequencing, markdown
  carries prompts and state. — Abstract; Section 1.
- **Local scripts are part of the design, not an afterthought.** "Local Python scripts handle the
  mechanical work that does not need AI." — Abstract, repeated in Section 7 (Conclusion).
- **Five design principles**, each credited to prior engineering practice: one stage one job
  (McIlroy, Parnas); plain text as the interface (Kernighan & Pike); layered context loading;
  every output is an edit surface (Horvitz, Shneiderman); configure the factory, not the product
  (continuous delivery). — Section 3.1.
- **Five-layer context hierarchy.** L0 `CLAUDE.md` ~800 tok "Where am I"; L1 root `CONTEXT.md`
  ~300 tok "Where do I go"; L2 stage `CONTEXT.md` 200–500 tok "What do I do"; L3 reference material
  (factory, stable); L4 working artifacts (product, per-run). **L2 is named the control point of the
  entire system** — its Inputs table is what makes context selection explicit, editable and
  auditable. — Section 3.2, Figure 1, Table 2.
- **Layers 0 to 2 together are 1,300–1,600 tokens; a full stage load is 2,000–8,000.** — Section 3.2.
- **Not one agent — one orchestrator.** All workspaces ran Claude Opus 4.6 as primary agent
  delegating sub-tasks to Sonnet 4.6 via Agent Teams, and the folder hierarchy doubles as the
  delegation specification: "The folder hierarchy is both the human's control surface and the model's
  orchestration logic." — Section 4.1.
- **Three deployments described**: script-to-animation (3 stages), course-deck production (5 stages),
  workspace-builder (5 stages, output is a new workspace). — Sections 4.2 to 4.4.

### Evidence — read before citing any number

- **No controlled experiments, no benchmarks.** Verbatim: "no controlled comparison has been
  conducted between ICM's staged context loading and a monolithic prompting approach on the same
  tasks", and the quality claim "rests on the theoretical support from the 'lost in the middle'
  literature and practitioner judgment rather than measured effect sizes." — Section 4.6.
- **The token chart is illustrative.** Figure 3 gives ~4.9k / 5.5k / 5.6k per stage against ~42k
  monolithic, captioned "representative token counts" from one workspace. Its largest monolithic
  segment is labelled "unused/irrelevant context" — the comparator is an everything-prompt nobody
  would hand-write. — Figure 3, Section 3.2.
- **The U-curve is conversational self-report.** 33 community members; 30 report heavy editing at
  stage 1, light in the middle, heavy at the final stage; 3 report even editing. Approximate rates
  92% / 30% / 78%, caption stating "practitioner self-report through conversation, not instrumented
  measurement." — Figure 5, Section 4.5.
- **The community is invite-only and self-selected**, 52 members. — Section 4.5.
- **Three members with no coding experience** produced ten-minute animated videos by editing
  markdown. — Section 4.5.
- **Named external adopters are unverifiable by design**: University of Edinburgh Neuropolitics Lab,
  ICR Research, Academy of International Affairs Bonn — "details of these implementations are limited
  by nondisclosure agreements." — Section 4.4.
- **Single model family throughout** (Opus 4.6 / Sonnet 4.6); cross-model evaluation named as future
  work. — Sections 4.1, 4.6.

### Where the authors say it loses

- **Real-time multi-agent collaboration** (file handoffs too slow), **high concurrency** (needs
  queueing and state isolation; ICM is local-first), **automated mid-pipeline branching** (pushes ICM
  toward becoming the framework it replaced). — Section 5.2.
- **Two further gaps live only in Table 1**, not in Section 5.2: **error recovery mid-pipeline** —
  framework gives retry, fallback and exception handling, ICM gives _manual re-run of the failed
  stage_ — and **external service integration** (local scripts or MCP). The error-recovery row is the
  most operationally significant limitation for repository work and is absent from both repos'
  write-ups. — Table 1.

### Future work worth carrying

- **ICM as multi-pass incremental compilation** (Section 6.1). Re-run only the stages whose declared
  inputs changed; a stage's Inputs table _is_ the dependency graph, and a change to any listed file
  signals its output is stale. The most actionable idea in the paper; absent from both repos.
- **Semantic debugging** (Section 6.2), three proposals, **none implemented**: output provenance
  identifiers, cross-stage trace verification, breakpoints in markdown.
- **The edit-source principle** (Section 6.3). Editing stage output is patching the binary; a
  recurring edit is diagnostic and belongs in the contract or reference file. Proposed heuristic:
  the same edit in the same stage three runs in a row should trigger a source-level suggestion.

### Defect in the paper itself

- **The paper's only link to its own artefact is dead.** Footnotes 1 and 5 both cite
  `https://github.com/RinDig/Interpretable-Context-Methodology-ICM-`, which returns **404**. The live
  repository drops the `-ICM-` suffix. — PDF p.1 fn.1, p.10 fn.5; verified by HTTP request 16/08/2026.
- **Title and protocol name differ between the arXiv record and the PDF.** The abstract page reads
  "…as Agentic Architecture" and its abstract calls the method "Model Workspace Protocol (MWP)"; the
  PDF reads "…as Agent Architecture" and uses ICM throughout, never MWP. Cite it as ICM. — compare
  `https://arxiv.org/abs/2603.16021` against the PDF title block.

---

## Claims — `RinDig/Interpretable-Context-Methodology` (the protocol repo)

**1,029 stars, 180 forks, 21 commits, 208 files, MIT.** Created 22/02/2026 — three weeks before the
paper — last push 25/07/2026. Contains `_core/CONVENTIONS.md` (15 named patterns) and four runnable
workspaces. — `https://github.com/RinDig/Interpretable-Context-Methodology`.

**It complies with its own quality bar wherever that bar is measurable:** longest stage `CONTEXT.md`
is 60 lines against an 80-line guardrail, longest reference file 164 against 200, and all 18
`output/` folders contain only `.gitkeep`. — measured across `workspaces/**`.

**Every drift is in a hand-maintained catalog file; not one is in a stage contract.**

| Defect                                                                                                                                                    | Citation                                              |
| --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| Canonical spec breaks its own length rule — 307 lines against its "under 200 lines (if longer, split)"                                                    | `_core/CONVENTIONS.md:303`, file length 307           |
| Spec still carries the abandoned name                                                                                                                     | `_core/CONVENTIONS.md:1` — `# MWP Conventions`        |
| Root entry file misspelt twice — "Interpreted", "Methdology" — after the README was fixed                                                                 | `CLAUDE.md:1`                                         |
| Root folder map names a directory that does not exist                                                                                                     | `CLAUDE.md:8` — `model-workspace-protocol/`           |
| Routing table still sends readers to "the full MWP specification"                                                                                         | `CLAUDE.md:29`                                        |
| Catalog stale: four workspaces exist, three are listed — `voice-driven-animation` (merged) appears in neither the README table nor the root routing table | `README.md`, `CLAUDE.md`; `workspaces/`               |
| Unresolved placeholder shipped                                                                                                                            | `README.md:254` — `](link-to-paper)`                  |
| Licence holder is the abandoned name                                                                                                                      | `LICENSE:3` — "Model Workspace Protocol Contributors" |

- **Naming convention contradicts both the paper and the skill.** The spec mandates `01-`, `02-`,
  `03-` and all 18 stage folders use hyphens (zero underscores), while the paper's Figure 2 and the
  skill's reference both mandate `01_research`. — `_core/CONVENTIONS.md:169`; paper Figure 2;
  `icm-architect/references/core.md:64`.
- **Not uniformly MIT.** Two bundled Anthropic skills carry "© 2025 Anthropic, PBC. All rights
  reserved" inside the MIT tree, governed by the reader's Anthropic terms rather than MIT. They must
  not be vendored onward. — `workspaces/course-deck-production/skills/pptx/LICENSE.txt`,
  `workspaces/*/skills/frontend-design/LICENSE.txt`.

### Patterns the skill repo dropped

- **Pattern 14, docs over outputs** — the sharpest rule in either repo. Agents never read prior
  outputs to learn patterns: "Early outputs are the worst outputs. If future agents learn from them,
  quality never improves." — `_core/CONVENTIONS.md:286`.
- **Pattern 4, selective section routing** — an Inputs table names the _section_ to load, not the
  file: "read the Voice Rules section of voice-rules.md." — `_core/CONVENTIONS.md:92`.
- Also absent from the skill: one-way cross-references (3), checkpoints (11), stage audits with
  unambiguous pass conditions (12), value validation (13), shared constants (15), and a defined
  `status` trigger with a specified render. — `_core/CONVENTIONS.md`.

---

## Claims — `RinDig/icm-architect` (the skill repo)

**947 stars, 129 forks, 7 commits, 14 files, 753 lines of markdown, MIT (© 2026 Jake Van Clief).**
Created 18/07/2026, last push 14/08/2026. — `https://github.com/RinDig/icm-architect`.

- **Well-formed as a Claude Code skill.** Frontmatter carries `name` and `description` only;
  description is 907 characters, under the 1,024 limit; every relative link resolves; progressive
  disclosure is correct (110-line `SKILL.md` routing to three references and eight templates).
- **The walk test is the most valuable thing in either repo** and appears in neither the paper nor the
  protocol repo. It is a falsifier for a documentation structure: a cold agent must orient, act and
  report status from files alone, within the entry file plus at most two reads, at 2k–8k tokens.
  — `SKILL.md` "The walk test".
- **Ten invariants** extend the paper's five principles with numbering-encodes-order, explicit
  folder contracts, instantiate-by-copying, filesystem-as-state-machine, and
  plain-text-linkable-queryable. — `SKILL.md` "The invariants".
- **Hits / Does not hit** is a genuinely novel documentation move: a change-impact card must name the
  obvious next noun that is _the wrong one_. `verified` requires a date, a commit and citations.
  — `references/system-map.md` slices 2 and 4.
- **Ships zero enforcement** while mandating it: "If an index matters, script it and schedule the
  rebuild." No scripts, no validator, no CI in the repository. — `references/core.md:75`.
- **The walk test is self-graded.** Nothing requires an independent reader, though the whole premise
  is a cold agent with no memory. — `SKILL.md` "The walk test".
- **Six forms is taxonomy inflation.** Umbrella is Pipeline recursed one level, which the text
  concedes; Context map and System map are one shape over two subjects, with near-identical card
  templates. — `references/forms.md` sections 2, 5, 6.
- **Maintenance risk.** Four pull requests and one issue open, oldest 19/07/2026, none merged; the
  only merged outside contribution was a README link fix. The unmerged work is stronger than parts of
  `main`: a reference-integrity gate before moves (PR #2, field-tested — the most superseded-looking
  file had 15 inbound references), a reverse walk test for external consumers (PR #4), and a fan/join
  notation fixing numbering's false-dependency problem (PR #5). Issue #6 reports the
  `CLAUDE.md`/`CONTEXT.md` boundary going undetected at 58-against-38 in a live workspace.
  — `https://github.com/RinDig/icm-architect/pulls`, `/issues`.

---

## Cross-cutting finding

**The method predicts its own decay, and both repositories demonstrate it.** The skill names
"duplicated entry files that drift" and "schema mandating names the actual files stopped using" as
anti-patterns; the protocol repo has both, and the skill repo's own naming rule contradicts the
implementation it documents. In the protocol repo the stage contracts are clean while every catalog
file has rotted — which is evidence _for_ the claim that contracts stay honest because they are
loaded every run, and _against_ the method's weakest point: nothing regenerates or checks a catalog,
so catalogs rot. That gap is precisely the enforcement layer syntek-base already has.

---

## What to take

| Take                                            | Why it is not already here                                                                                                         | Source                     |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| **The walk test**, run by an independent reader | `audits/docs-pairing.sh` and `docs-length.sh` check structure mechanically; nothing tests navigability end to end                  | `icm-architect/SKILL.md`   |
| **Docs over outputs**                           | Applies directly to generated `reports/` and PM artefacts: reference docs are the only pattern source, prior outputs are artefacts | `_core/CONVENTIONS.md:286` |
| **Selective section routing**                   | The `@` imports and read-order chains load whole files; a Section/Scope column is the cheaper form                                 | `_core/CONVENTIONS.md:92`  |

**Already covered, do not import:** incremental recompilation (Section 6.1) is `code-review-graph`'s
`detect_changes_tool`; change-impact is `get_impact_radius_tool`; the `CONTEXT.md`/`CLAUDE.md` split
is stricter and gated in `code/docs/DOCUMENTATION-PAIRING.md`.

## Licence position

Paper **CC BY 4.0** — attribution required, **not** share-alike, so nothing propagates into generated
projects. Both repositories **MIT**, except the bundled Anthropic skills in the protocol repo, which
are not MIT and must not be vendored onward. All derivable under `.claude/CLAUDE.md` Section 6,
with the attribution row landing in the same change as any rule taken.

## Sources

- `https://arxiv.org/abs/2603.16021` — arXiv record: title, subjects, CC BY 4.0, submission history.
- `research/jve-interpretable-context-methodology-paper-2603.16021v2.pdf` — the paper, 21 pages.
- `https://github.com/RinDig/Interpretable-Context-Methodology` — protocol repo, MIT.
- `https://github.com/RinDig/icm-architect` — skill repo, MIT; plus its open issue and pull requests.

## Feeds

**No ADR — this repository does not write them.** The attribution is the decision, and it landed in
the same change as this note, per `.claude/CLAUDE.md` Section 6:

- **`README.md` Section _Influences and attribution_** — the Jake Van Clief row now cites the paper
  (CC BY 4.0) and both repositories (MIT) instead of only Clief Notes and LinkedIn, names what the
  layering owes the five-layer hierarchy, and carries the evidence caveat. Per this folder's
  `.gitignore` the evidence sits in the row itself, because nothing under `research/` ships.
- **`.copier/README.md` Section _Influences and Attribution_** — the same row in the seed README a
  generated project starts from.
- **`THIRD-PARTY-NOTICES.md` → _Not listed here, and why_** — records that all three were read and
  none adapted, so no notice obligation attaches, and states the carve-out on the protocol repo's
  bundled Anthropic files.

**Left open, deliberately.** The three takes named above — the walk test, docs-over-outputs,
selective section routing — are **not adopted**. Each would need its own change, with its rule text,
its gate, and its attribution row written together. Until then this note is the record that they were
assessed, not that they were taken.

Recorded 16/08/2026.
