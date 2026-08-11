---
type: guide
agent: doc-writer
skills: [global-workflow, runbook]
model: opus
---

# Authoring Skills

**Version:** 0.1.0 **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — how to write and edit skills under `.claude/skills/` so they stay predictable

A skill exists to wrangle determinism out of a stochastic system. The root virtue is
**predictability** — the agent taking the same _process_ every run, not producing the same
output. A brainstorming skill should predictably diverge; its tokens vary, its behaviour does
not. Cost and maintainability are symptoms of predictability, not rivals to it. Every lever in
this guide serves it.

Two things govern a skill here, and they are different in kind. The **format** is the published
[Agent Skills specification](https://agentskills.io/specification) — an external contract, and
the thing a loader validates. The **craft** is the four axes in §1–§4 below: invocation,
information hierarchy, steering, and pruning. Conforming to the format is necessary and tells you
nothing about whether the skill is any good.

---

## The format, and where this project narrows it

The specification defines six frontmatter fields. This project authors **two** of them and
deliberately declines the rest — a narrowing, not a format limit, and the distinction matters
because a reader who cannot tell them apart will not know which rule they may argue with.

| Field           | Spec     | Constraint                                                      | Here                                          |
| --------------- | -------- | --------------------------------------------------------------- | --------------------------------------------- |
| `name`          | required | 1–64 chars · `a-z0-9-` only · no leading/trailing `-` · no `--` | **Authored.** Matches its folder              |
| `description`   | required | 1–1024 chars · what the skill does **and** when to use it       | **Authored.** The whole invocation lever (§1) |
| `license`       | optional | A licence name, or a bundled licence file                       | Vendored skills only                          |
| `metadata`      | optional | Arbitrary string→string map                                     | Vendored skills only                          |
| `compatibility` | optional | ≤ 500 chars — environment or product requirements               | **Declined**                                  |
| `allowed-tools` | optional | Space-separated pre-approved tools (experimental)               | **Declined**                                  |

**Why the narrowing.** What an agent may _do_ (`allowed-tools`) and which _model_ runs are
properties of the **agent** that loads the skill (`.claude/agents/*.md`) and of the routing
frontmatter on the governing `docs/`/`workflows/` file — never of the skill. A skill is reference
and process; it carries no capability of its own. Put `allowed-tools` on a skill and the same
skill grants different powers depending on who loaded it, which is precisely the unpredictability
this guide exists to remove.

**Why `compatibility` is declined** even though it looks made for the surface-gated skills:
`stack-react-native`, `stack-rust` and `stack-slint` are gated by `copier.yml` `_exclude`, so on a
project without that surface the file is **absent**, not present-and-incompatible. The field would
restate a decision the file's own absence already makes.

**The one exception, stated rather than implied.** The three `cloudinary-*` skills are symlinks
into `.agents/skills/`, refreshed from upstream by the skills tool and never authored here. They
carry `license` and `metadata`, and they carry no `## Governing procedures` section. That is
correct: the two-key rule binds what **this project writes**, and hand-editing a vendored skill
would be undone by the next refresh (`skills-lock.json`).

**Keys outside the six fail validation.** `tools`, `model` and `disable-model-invocation` are not
specification fields at all — they are product extensions of various agent runtimes, and naming
one here would be neither spec-conformant nor project-conformant.

### The gate

`bash code/src/scripts/audits/skill-conformance.sh` enforces **eight** clauses, all `[gate: fail]`
and none advisory: the six the table above states — every constraint in the _Constraint_ column,
plus the rule that no key outside those six may appear — and two more, the `name` + `description`
narrowing and the `## Governing procedures` section of § 5. Where a clause is also stated as prose
further down it carries an inline `[gate: fail]` marker; the table is the register. Findings are
reported as `[spec N]` or `[house N]`, because a format breach and a house breach have different
remedies. Run it on any skill you touch.

It does **not** check length — `docs-length.sh` owns the 300-line cap across all of `.claude/**`,
and a rule with two enforcers drifts the moment the number moves.

### The other hard constraints

- **≤ 300 code lines per file** `[gate: fail — docs-length.sh]` (`cloc --include-lang=Markdown`;
  `.claude/CLAUDE.md` § 8). The spec recommends under 500 raw lines, so this is the **stricter**
  of the two and conformance follows from it. The metrics differ: ours counts code lines, so
  blank lines and prose wrapping are free. When a `SKILL.md` would breach the cap, it becomes a
  thin index and its reference moves into `SCREAMING-SNAKE-CASE.md` sub-documents beside it.
- **Folder discovery.** A skill is a `kebab-case/` folder under `.claude/skills/` whose entry
  file is `SKILL.md`, and the folder name **is** the `name` field `[gate: fail]`. Registration is:
  add the folder, then list it in `.claude/skills/CONTEXT.md` (tree + when-to-load table) and, if
  agents cite it, in `.claude/CLAUDE.md` §2.4 and Skill Targets.
- **British English** (en_GB) throughout, and every developer operation cites a script in
  `code/src/scripts/**/*.sh` — never a raw `pnpm`, `pytest`, `python`, or `docker` command.

Four axes govern the craft: **invocation** (how it is reached), **information hierarchy** (how its
content is arranged), **steering** (how the agent's runtime behaviour is shaped), and **pruning**
(how it is kept lean). `.claude/skills/grilling/` is cited throughout as the worked example.

---

## 1. Invocation — how the skill is reached

Two ways in, trading two different costs. Because this project declines `allowed-tools` and the
spec has no opt-out field, the **description wording is the whole lever**.

- **Model-auto-loaded.** A description opening with a leading word and a rich "**Load when…**"
  trigger list lets the agent fire the skill on its own, and lets other skills reach it. The
  price is **context load**: the description sits in the window every turn, spending tokens and
  attention. Use this when the agent must reach the skill unaided. The stack skills and
  `grilling` are model-auto-loaded — `grilling`'s description names every design surface and the
  `/grill-*` triggers, so it fires reliably.
- **User-typed `/name`.** A description phrased around explicit invocation ("Invoke by typing
  `/grill-me`…") keeps the skill primarily human-reached: the human is the index that must
  remember it exists. That is **cognitive load** — not a cost to minimise but the price of human
  agency; spend it where human judgement should gate the skill. `grill-me` and `grill-with-docs`
  are the worked example: two thin entry points, each typed by hand.

**Context load vs cognitive load** is the trade. Pick model-auto-loading only when the agent (or
another skill) must reach the skill itself; otherwise phrase for `/name` invocation and pay no
standing context cost.

**Writing the description.** It does two jobs — state what the skill is, and list the branches
that trigger it — and every word is standing context load, so it earns harder pruning than the
body. Front-load the skill's leading word; write **one trigger per branch** (synonyms that rename
one branch are duplication — collapse them); cut identity already stated in the body. The spec's
1024-character ceiling is a validation limit, not a target `[gate: fail]`.

**When to add a router.** When user-typed skills multiply past what one person can hold in their
head, add a router: one user-typed skill that names the others and when to reach for each. The
`grilling` trio is the neighbouring pattern — a shared model-loaded **engine** (`grilling`) with
two user-typed entry points (`grill-me`, `grill-with-docs`) that load it. That keeps the process
in one place while giving each entry point its own `/name`.

---

## 2. Information hierarchy — how content is arranged

A skill is built from two content types that mix freely: **steps** (ordered actions the agent
performs, in order) and **reference** (definitions, rules, and facts consulted on demand). A
skill can be all steps, all reference, or both. `grilling` is both: five numbered steps under
"How to grill", then flat reference under "What to grill".

Rank every piece on the ladder by how immediately the agent needs it:

1. **In-skill step** — an ordered action in `SKILL.md`, the primary tier.
2. **In-skill reference** — a rule or fact in `SKILL.md`, consulted on demand. Often a
   legitimately flat peer-set (every rule of a review on one rung) — a fine arrangement, not a
   smell.
3. **Sub-document reference** — reference pushed out of `SKILL.md` into a
   `SCREAMING-SNAKE-CASE.md` file beside it, reached by a **context pointer** and loaded only when
   the pointer fires.

**Progressive disclosure** is the move down that ladder, and here the **300-line cap forces
it**: when a `SKILL.md` would breach 300 code lines, disclose its reference into sub-documents and
leave the `SKILL.md` a thin index that points at them. `global-workflow` (index +
`GIT-AND-PR.md` + `VERSIONING-AND-DOCS.md`) and `msp-scp-documents` (index + six sub-documents)
are the worked examples. `grilling` sits comfortably under the cap, so it discloses nothing — a
single `SKILL.md` is correct when it fits.

**Sub-documents sit flat beside `SKILL.md`, not in `references/`.** The specification suggests
three optional directories — `scripts/`, `references/`, `assets/` — and permits any layout beyond
the required `SKILL.md`; these are recommendations for organising content, not conformance
requirements. Every skill here discloses **prose only**, and a `references/` folder holding one
kind of thing is a directory that earns nothing while lengthening every pointer. **The trigger for
adopting the spec directories is content, not count:** the first skill that ships an executable
puts it in `scripts/`, the first that ships a template or fixture puts it in `assets/`, and at
that point its prose moves to `references/` in the same change, so one skill never mixes both
conventions.

**In-file vs sub-doc** is decided by **branch**: inline what every run needs; push behind a
pointer only what some runs reach. The pointer's _wording_, not its target, decides when and how
reliably the agent follows it — a must-have behind a weak pointer is a variance bug, so sharpen
the wording before you consider pulling material back inline. Keep every reference **one level
deep** from `SKILL.md`; the spec warns against nested reference chains, and an agent that must
follow two pointers to reach a rule usually follows neither.

---

## 3. Steering — shaping runtime behaviour

**Leading words.** A leading word is a compact concept already living in the model's pretraining
(_lesson_, _fog of war_, _tracer bullets_) that the agent thinks with while running the skill.
Repeated as a token — not restated as a sentence — it accumulates a distributed definition and
anchors a whole region of behaviour in the fewest tokens. It serves predictability twice: in the
body it anchors execution (the agent reaches for the same behaviour each time the word appears);
in the description it anchors invocation (when the same word lives in your prompts, docs, and
code, the agent links that shared language to the skill and fires it more reliably). `grilling`
leans on _predictability_ and _frontier round_ as its leading words. Prefer an existing
pretrained word; a coined one recruits no priors and you pay in definition tokens what a
pretrained word gives free.

**Completion criteria.** Every step ends on the condition that tells the agent the work is done.
Make it **checkable** (can the agent tell done from not-done?) and, where it matters,
**exhaustive** ("every modified model accounted for", not "produce a change list") — a vague
criterion invites premature completion and thin legwork. `grilling` ends on a sharp,
non-negotiable bar: the design is summarised and <%DEVELOPER_NAME%> gives an explicit "yes" before any
downstream work begins.

**Look up facts; ask about decisions.** Steer the agent to _discover_ anything derivable from the
codebase or environment rather than offload the question to the human. In <%PROJECT_NAME%> the lookup order
is `code-review-graph` (structural context) → Read/Grep/Glob → `.claude/plugins/*.py`
(`project`/`db`/`env`), and every dev operation runs through `code/src/scripts/**/*.sh`. Reserve
questions for genuine decisions with a real trade-off. `grilling` rule 3 is the canonical
statement: "Do not ask 'does a `Customer` model exist?' — check. Do ask 'should a booking belong
to a `Customer` or a `User`?'".

**Post-completion steps.** The steps visible ahead of the current one pull the agent forward into
**premature completion** — ending a step before it is genuinely done. Defend in order: sharpen the
completion criterion first (cheap and local); only if it is irreducibly fuzzy _and_ you observe
the rush do you hide the later steps by splitting the sequence across a real context boundary (a
user-typed hand-off or a sub-agent dispatch — an inline call leaves the later steps in view and
clears nothing).

**Steer positive, not by prohibition.** Naming the banned behaviour drags it into context and
makes it _more_ available — _don't think of an elephant_. State the target behaviour so the
banned one is never spoken ("write one-line comments", not "never write verbose comments"). Keep
a prohibition only as a hard guardrail you cannot phrase positively, and even then pair it with
the positive target.

---

## 4. Pruning — keeping the skill lean

The 300-line cap is a standing forcing function against every failure below. Run
`bash code/src/scripts/audits/docs-length.sh --path .claude/skills` for the cap and
`bash code/src/scripts/audits/skill-conformance.sh` for the format on any skill you touch.

- **Single source of truth.** Keep each meaning in exactly one authoritative place, so changing
  the behaviour is a one-place edit. The `grilling` engine is the pattern — `grill-me` and
  `grill-with-docs` both load it rather than restate the process.
- **Duplication** — the same meaning in more than one place. It costs maintenance and tokens and
  inflates a meaning's prominence on the ladder past its real rank. Collapse it (and, in a
  description, collapse synonym-triggers to one per branch).
- **Sediment** — stale layers that settle because adding feels safe and removing feels risky. The
  default fate of any skill without a pruning discipline; check every line for **relevance** —
  does it still bear on what the skill does?
- **Sprawl** — a skill simply too long, even when every line is live and unique. The cure is the
  ladder: disclose reference into sub-documents and split by branch or sequence so each path
  carries only what it needs.
- **The no-op test.** Hunt no-ops sentence by sentence: does this line change behaviour versus the
  model's default? A line the agent already obeys pays load to say nothing. A weak leading word
  (_be thorough_ when the agent is already thorough-ish) is a no-op — the fix is a stronger word
  (_relentless_), not a new technique. When a sentence fails, delete the whole sentence rather
  than trim words from it. Be aggressive; most prose that fails should go.

---

## 5. Routing — the `## Governing procedures` section

**Every skill this project authors carries a `## Governing procedures` section, placed
immediately before `## Cross-references`** `[gate: fail]`. It names the procedures across all
three workflow layers — `project-management/workflows/`, `code/workflows/` and
`how-to/workflows/` — that the skill is loaded in service of, each with a one-line "when", and it
routes rather than restating them.

The reason is structural rather than stylistic: because the frontmatter is `name` + `description`
only, **there is nowhere else routing can live**. A skill with `allowed-tools` could imply its
context from its permissions; one without has to say it in the body.

A skill that is a session or sandbox mechanic — `handoff`, `teach`, `msp-scp-documents` — **says
it has none** rather than leaving the absence ambiguous, because a missing section and an empty
one are indistinguishable to the next author. The cross-layer pairing map is
`REFERENCES.md` → _Cross-layer workflow pairing_.

---

## Checklist before shipping a skill

- [ ] Folder is `kebab-case/` under `.claude/skills/`; entry file is `SKILL.md`; sub-documents
      are `SCREAMING-SNAKE-CASE.md` **flat beside it**, one level deep.
- [ ] `name` matches the folder exactly: 1–64 chars, `a-z0-9-`, no leading/trailing or doubled
      hyphen.
- [ ] Frontmatter is **`name` + `description` only** — the other four spec fields are declined,
      and `tools`/`model`/`disable-model-invocation` are not spec fields at all.
- [ ] `description` is non-empty and under 1024 characters, and earns every one of them.
- [ ] Invocation is deliberate: a rich "Load when…" description for model-auto-loading, or an
      "Invoke by typing `/name`" description for user-typed; the trade (context vs cognitive load)
      is the right one.
- [ ] Description front-loads the leading word, carries one trigger per branch, and repeats no
      identity already in the body.
- [ ] Steps sit above reference; every step ends on a checkable (and where it matters, exhaustive)
      completion criterion.
- [ ] Every file is ≤ 300 code lines; anything longer is a thin index plus disclosed
      sub-documents.
- [ ] Reference that only some branches need sits behind a well-worded context pointer; related
      material is co-located under one heading.
- [ ] Facts are looked up, not asked; dev operations cite `code/src/scripts/**/*.sh`.
- [ ] Each meaning has a single source of truth; no duplication, sediment, sprawl, or no-op lines
      survive a pass.
- [ ] Steering is positive, not prohibition; British English throughout.
- [ ] `## Governing procedures` is present immediately before `## Cross-references` — naming the
      procedures, or saying there are none.
- [ ] Registered: `.claude/skills/CONTEXT.md` (tree + when-to-load), and `.claude/CLAUDE.md` §2.4
      and Skill Targets if an agent cites it.
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` and
      `bash code/src/scripts/audits/docs-length.sh --path .claude/skills` both exit 0.

---

_Part of the `how-to/docs/` documentation family._
