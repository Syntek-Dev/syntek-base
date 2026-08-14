# Third-party notices

Files in this project that contain **substantial portions of someone else's licensed work** are
listed here with the notice that licence requires. This is distinct from the influences credited in
`README.md` — those are _derived_, re-authored from scratch, and carry no notice obligation. These
are _adapted_, and the obligation travels with the copy.

**This file ships into every generated project**, because the adapted files do. `LICENSE` is
copier-excluded and cannot carry the obligation on their behalf.

> **Standing rule.** Adapting an outside file adds its row here **in the same change** — the same
> discipline `.claude/CLAUDE.md` Section 6 applies to attribution. A notice added retrospectively has
> already shipped non-compliant at least once.

---

## `mattpocock/skills` — Matt Pocock

**Licence:** MIT · **Source:** <https://github.com/mattpocock/skills>

**Files adapted from it:**

| File                                                          | Relationship                                                         |
| ------------------------------------------------------------- | -------------------------------------------------------------------- |
| `.claude/skills/improve-codebase-architecture/SKILL.md`       | Adapted — structure and much of the prose, re-pathed to this project |
| `.claude/skills/improve-codebase-architecture/HTML-REPORT.md` | Adapted — the report format, scaffold and tone rules, near-verbatim  |

Every other skill under `.claude/skills/` that shares a name with one of his — `grilling`,
`grill-me`, `grill-with-docs`, `wayfinder`, `codebase-design`, `domain-modelling`, `prototype`,
`research`, `teach`, `handoff` — is **independently authored** against the same idea and carries no
notice obligation. The concept is not the expression, and only the expression is licensed.

**`grilling` is the one to watch.** Its **frontier-round method** — work the design as a tree, ask
every question whose prerequisites are settled in one round, let the answers redraw the frontier —
is **derived from his `grilling` skill** (adopted 09/08/2026, replacing an earlier
one-question-per-message rule that was our own). The method is derived; **every word of
`.claude/skills/grilling/SKILL.md` is ours**, and the question format, the recommendation rule and
the `AskUserQuestion` ban have no counterpart upstream. Measured at **2.6% five-gram overlap** with
his text, and what remains is the method's own vocabulary ("recompute the frontier", "ask the whole
frontier in one round") rather than borrowed expression. Credited under `.claude/CLAUDE.md` Section 6
(attribution at the point the rule is written), listed here for traceability rather than because
MIT demands a notice for it.

**Four further skills were derived the same way (09/08/2026)** — his skill list read as a checklist
of concerns, each then authored here against this project's own stack, conventions and file
classes:

| Skill                       | What was taken                                               | Overlap |
| --------------------------- | ------------------------------------------------------------ | ------- |
| `resolving-merge-conflicts` | The never-abort rule and intent-before-text ordering         | 1.8%    |
| `wizard`                    | The staged-wizard idea and its scope→trace→author sequence   | 1.0%    |
| `to-questionnaire`          | "Grill the send, not the subject" — the load-bearing idea    | 4.5%    |
| `wait-what`                 | The premise: a reply that missed is re-pitched, not repeated | 0.0%    |

`tdd`, `to-spec`, `code-review`, `implement`, `triage` and the rest of his set were **assessed and
declined** — each already covered by a workflow, an agent, or a gate here. No text was copied in
any case, so none of these carry a notice obligation; they are recorded because Section 6 requires the
credit to be written in the same change as the rule, not retrospectively.

```text
MIT License

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## `cloudinary-devs/skills` — Cloudinary

**Licence:** MIT · **Source:** <https://github.com/cloudinary-devs/skills>

**Vendored verbatim — 15 files, unmodified**, installed via `skills-lock.json` (which records the
source and a content hash for each) and symlinked into `.claude/skills/` as `cloudinary-docs`,
`cloudinary-react` and `cloudinary-transformations`:

```text
.agents/skills/cloudinary-docs/SKILL.md
.agents/skills/cloudinary-react/            SKILL.md + 4 references/*.md
.agents/skills/cloudinary-transformations/  SKILL.md + 8 references/*.md
```

This is the most clear-cut obligation in this file: not adapted, not derived — **copied**, tracked,
and rendered into every generated project (`copier.yml` excludes neither `.agents/` nor
`skills-lock.json`).

**Two facts about the grant, stated because they are unusual.** The upstream repository has **no
`LICENSE` file** — its only root file is `README.md`, and the GitHub licence API returns null. The
grant is per-file YAML frontmatter instead: each `SKILL.md` declares `license: MIT` with
`metadata.author: cloudinary`. The twelve `references/*.md` files carry **no frontmatter and no
explicit grant of their own**, and are treated here as covered by their skill directory. Both
points are worth confirming with Cloudinary before relying on them commercially; the MIT terms are
reproduced below against the declared author.

```text
MIT License

Copyright (c) Cloudinary — declared in each SKILL.md as `license: MIT`,
`metadata.author: cloudinary`. No upstream LICENSE file exists to quote verbatim.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## `tirth8205/code-review-graph` — Tirth Patel

**Licence:** MIT · **Source:** <https://github.com/tirth8205/code-review-graph>

The **MCP server is run as-is** and needs no notice — running a tool is not redistributing it.
The **four generated playbook cards do**:

```text
.claude/skills/debug-issue.md · explore-codebase.md · refactor-safely.md · review-changes.md
```

`code-review-graph install` writes them, and this repository **commits them**. Their prose is
authored upstream in `code_review_graph/skills.py` (the card bodies are string literals from
around line 700) — spot-checked at **6 of 12 sampled lines verbatim**. Generated output whose text
was written by the tool's author is still that author's text, and it ships into every generated
project.

They remain **auto-generated and never hand-edited** — the notice does not change that; it only
records who wrote what `install` emits.

```text
MIT License

Copyright (c) Tirth Patel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Not listed here, and why

Each row below was **measured**, not assumed — five-gram overlap between the upstream text and the
guide said to derive from it, on 09/08/2026, the two TigerStyle rows on 11/08/2026, and the two
skill-authoring rows on 11/08/2026:

| Source                                      | Derived into                                       | Overlap  |
| ------------------------------------------- | -------------------------------------------------- | -------- |
| `emilkowalski/skills` (motion standard)     | `code/docs/VISUAL-DESIGN.md` Section 5             | **0.0%** |
| `pbakaus/impeccable` (native audit)         | `code/docs/visual-design/MOBILE.md`                | **0.0%** |
| `pbakaus/impeccable` (craft floor)          | `code/docs/visual-design/WEB.md`                   | **0.0%** |
| `hardikpandya/stop-slop` (prose taxonomy)   | `how-to/src/BRAND-VOICE.md` Section 4              | **0.0%** |
| `wshobson/agents` (background jobs)         | `code/docs/TASK-AUTHORING.md` · `PROCESS-MODEL.md` | **0.0%** |
| `tigerbeetle` TigerStyle (negative space)   | `code/docs/NEGATIVE-SPACE.md`                      | **0.0%** |
| `tigerbeetle` TigerStyle (negative space)   | `how-to/src/INVARIANTS.md`                         | **0.0%** |
| Agent Skills specification (the six fields) | `how-to/docs/skill-authoring/` (all six files)     | **0.0%** |
| Claude Code Agent Skills docs (runtime)     | `how-to/docs/skill-authoring/` (all six files)     | **0.0%** |

The last two rows were re-measured after an earlier draft failed them: the fork guide carried six
shared five-grams with the unlicensed runtime docs, and the frontmatter and craft guides eight with
the specification. **Both are why the measurement is a step and not a claim** — every one of those
sentences read as re-authored until it was counted.

Numeric values (durations, easing curves, contrast ratios, character limits) are facts and carry no
obligation regardless — but the wording around them would have, and none was taken.

| Source                                | Why no notice                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The remaining design/platform sources | Read as a checklist of concerns and re-authored (`README.md` → Influences). Facts and method are not copyrightable                                                                                                                                                                                                                                                                                                                                              |
| `trailofbits/skills`                  | CC-BY-SA-4.0 — **read only, never derived into shipped text**. A notice would not cure share-alike (`.claude/CLAUDE.md` Section 6)                                                                                                                                                                                                                                                                                                                              |
| `audits/rules/*.yml`                  | Authored in-house; each file carries an explicit "no upstream rule text consulted" header. Semgrep's rules are not redistributable                                                                                                                                                                                                                                                                                                                              |
| `anthropics/skills` · `vercel-labs`   | No LICENCE upstream — read for ideas, never quoted, so nothing of theirs is redistributed                                                                                                                                                                                                                                                                                                                                                                       |
| `agentskills/agentskills`             | Apache-2.0 covers the **specification text**, and Section 4(d) binds only a derivative of a work that ships a `NOTICE` file. The repository ships none — checked 11/08/2026, root holds `LICENSE` and no `NOTICE` — so the obligation never attaches. Separately, what is taken is the field set, their limits and each field's job, measured at 0.0% overlap above                                                                                             |
| Claude Code's own Agent Skills docs   | **No LICENCE upstream**, so no grant exists to redistribute under — which is why only facts are taken and every derived rule is re-authored, at 0.0% overlap above. **Nothing this template ships quotes them at all:** the working notes that carried marked quotations are syntek-base's own and are not tracked (`research/.gitignore`), and nothing in `how-to/docs/skill-authoring/` quotes. With no quotation redistributed, the absent grant never bites |
| `mattpocock/dictionary-of-ai-coding`  | **Open question — see below.** Not a notice problem, a permission problem                                                                                                                                                                                                                                                                                                                                                                                       |

### Open: `dictionary-of-ai-coding` has no licence

`how-to/docs/AI-DICTIONARY.md` is described in `README.md` as adapted from
<https://github.com/mattpocock/dictionary-of-ai-coding> — which ships **no `LICENSE` file**,
verified 09/08/2026. No licence means no reuse rights granted, so there is no notice that makes an
adaptation compliant. Resolve by one of: obtaining permission, confirming the terms published at
<https://www.aicodingdictionary.com/>, or re-authoring the entries independently. Until then this is
a known gap, recorded rather than papered over.
