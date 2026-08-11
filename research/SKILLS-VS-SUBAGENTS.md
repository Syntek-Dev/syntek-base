# SKILLS-VS-SUBAGENTS

**Written**: 09/08/2026 · **Updated**: 11/08/2026 (Round 3) · **Skill**: `research`
**Feeds**: the agents-to-skills epic — nodes N-001, N-016, N-019
(and, downstream, N-003, N-004, N-008, N-010, N-011)

---

## Question

In Claude Code 2.1.226, what is the actual capability surface of **skills** versus **subagents**?
Four sub-claims, each asserted by the web summary that prompted the agents-to-skills epic, none
previously verified against a primary source:

1. Does a `context: fork` frontmatter field exist, and is it specification or product extension?
2. What are the real skill loading mechanics, and what is the standing context cost?
3. How does Claude Code select between custom subagents, and does selection degrade with roster size?
4. Do personal and project-level skills/agents differ in cloud sessions?

---

## Verdict

**`context: fork` is real, documented, and stable in this version** — a Claude Code product
extension, deliberately outside the six-field Agent Skills specification. The "auto-triggering
plus context isolation" middle ground the web summary described therefore **exists**. What blocks
it here is this project's own narrowing, enforced by `audits/skill-conformance.sh`, whose
`SPEC_KEYS` allowlist would reject the key — a project choice, not a platform limit, and one this
epic may now revisit on the merits rather than dismiss as unavailable.

**The roster-size argument is unsupported.** No primary source documents subagent selection
quality degrading as the roster grows. The only documented constraint is a hard limit of **20
concurrent executions**, which is an execution ceiling, not a roster ceiling — it says nothing
about 56 agent definitions coexisting. The web summary's "keep to 3–5 job classes" is a
practitioner heuristic with no primary grounding found.

---

## Claims

Each claim ends in the primary source that owns it.

### 1 — `context: fork`

- A `context: fork` skill frontmatter field **exists** in Claude Code and runs the skill's body
  inside an isolated subagent context, with auto-background execution from v2.1.218 onward —
  https://code.claude.com/docs/en/skills.md § _Run skills in a subagent_
- It is **not** part of the published Agent Skills specification, which defines exactly six
  fields: `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools` —
  https://agentskills.io/specification
- A `context: fork` skill using `agent: Explore` or `agent: Plan` **skips CLAUDE.md** to preserve
  context isolation — https://code.claude.com/docs/en/skills.md § _Run skills in a subagent_

### 2 — Skill loading and standing cost

- Only the skill **description** loads at startup, in every request; the full `SKILL.md` body
  loads on invocation — https://code.claude.com/docs/en/skills.md § _Where skills live_
- The specification's progressive-disclosure guidance puts metadata at **~100 tokens** and
  recommends instruction bodies under 5,000 tokens — https://agentskills.io/specification
  § _Progressive disclosure_
- Skills are **model-invocable by default**, unless `disable-model-invocation: true` is set —
  https://code.claude.com/docs/en/skills.md § _Frontmatter reference_
- Every skill is also reachable as a slash command — https://code.claude.com/docs/en/skills.md
- Skills inherit CLAUDE.md when invoked, with the `context: fork` exception above —
  https://code.claude.com/docs/en/skills.md

### 3 — Subagent selection and frontmatter

- Subagents start with a **fresh, isolated context** — no inheritance of the parent conversation,
  skills, or file history — https://code.claude.com/docs/en/sub-agents.md § _What loads at startup_
- Documented subagent frontmatter is far wider than `name`/`description`/`model`/`tools`: it also
  includes `disallowedTools`, `permissionMode`, `mcpServers`, `hooks`, `maxTurns`, **`skills`**,
  `initialPrompt`, `memory`, `effort`, `background`, `isolation`, `color`, and `agent` —
  https://code.claude.com/docs/en/sub-agents.md § _Supported frontmatter fields_
- The documented limit is **20 concurrent subagents per session**, enforced at spawn time —
  https://code.claude.com/docs/en/sub-agents.md

### 4 — Cloud sessions

- Repo-level `.claude/skills/`, `.claude/agents/` and `.claude/commands/` **carry over** to cloud <!-- doc-references: ignore — Claude Code's own directory names, not this repository's -->
  environments; the user-level `~/.claude/` equivalents **do not** —
  https://code.claude.com/docs/en/cloud-environments.md § _What carries over_

---

## What this contradicts in our own docs

One correction lands directly on an existing project document.

`how-to/docs/SKILL-AUTHORING.md` states: _"Keys outside the six fail validation."_ That is
**false for Claude Code**, which accepts its own documented extensions (`context`,
`disable-model-invocation`). The sentence's other half is accurate — those keys genuinely are not
specification fields. The fix is to separate the two ideas: the spec defines six; Claude Code
accepts more; this project declines the extras **by choice**, and should say so as a choice.
The stated structural reason for declining `allowed-tools` — that a skill carries no capability
of its own — is untouched by this and still stands on its own merits.

---

---

## Round 2 — can the project go skills-only?

Fired 09/08/2026 after the destination sharpened to _skills only, agents justify survival_.
Three capabilities decide the reach.

- **Skills DO accept `model:`, but the override is turn-scoped** — "applies for the rest of the
  current turn and is not saved to settings; the session model resumes on your next prompt".
  Subagent `model:` persists across turns; a skill's does not —
  https://code.claude.com/docs/en/skills.md § _Frontmatter reference_
- **`agent:` on a forked skill is optional and CAN name a custom subagent** — the documented
  options are the built-ins (`Explore`, `Plan`, `general-purpose`) **or any custom subagent from
  `.claude/agents/`** — https://code.claude.com/docs/en/skills.md § _Run skills in a subagent_
- **CLAUDE.md loads by default in a forked skill** — it is skipped **only** when the agent is
  `Explore` or `Plan`, so the non-negotiables survive any other fork —
  https://code.claude.com/docs/en/skills.md § _Run skills in a subagent_
- **A forked skill starts fresh** — no access to the parent conversation history —
  https://code.claude.com/docs/en/skills.md § _Run skills in a subagent_
- **`allowed-tools` does NOT restrict tools** — "It does not restrict which tools are available:
  every tool remains callable." It grants per-turn pre-approval only. `disallowedTools` does
  restrict, but is also per-turn: "The restriction clears when you send your next message" —
  https://code.claude.com/docs/en/skills.md § _Frontmatter reference_

### What this costs _this_ repository — measured, not assumed

The abstract reading is "skills-only is impossible". Against the actual roster it is close to
free. Measured 09/08/2026:

| Capability lost       | Abstract cost                          | Actual cost here                                                                                                                                                                                                                                                        |
| --------------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Durable tool scoping  | No enforced read-only or hostile agent | **≈ nil.** Only two declared tool sets exist — 32 full, 16 lacking only `Bash`; the orchestrators declare none and carry everything. `code-reviewer` is described as "Read-only" and carries `Write, Edit, Bash`. The guarantee is already instruction, not enforcement |
| Persistent model tier | No sustained Fable planning tier       | **5 agents.** All but five are `opus` — the session default. Only those five carry `model: fable`, and §2.5 routing frontmatter already carries `model:` on the governing docs/workflow file                                                                            |
| Custom fork targets   | Forked skills lose specialised targets | **Real, and the strongest survivor.** Needed only if a forked skill must run as a _custom_ agent; the built-ins remain available                                                                                                                                        |

**Revised verdict.** Skills-only is achievable for roughly **51 of 56** definitions at no
capability cost, because the two capabilities that block it in theory are ones this repository
does not actually use. The residue is the Fable planning tier and any deliberate custom fork
target — a handful of definitions, to be argued individually rather than inherited wholesale.

---

## Round 3 — is inline the default, and what does forking actually cost?

Fired 11/08/2026 as `N-016`'s opening step: 56 files were about to be authored on an **inference**
that a skill runs inline unless it declares `context: fork`. The inference was correct. Four
further facts came back that no earlier round had recorded, and one of them **corrects Round 2**.

### The confirmation

- **Inline is the default, stated directly.** Reference content — "conventions, patterns, style
  guides, domain knowledge" — "**runs inline so Claude can use it alongside your conversation
  context**" — https://code.claude.com/docs/en/skills.md § _Types of skill content_

### What was not previously recorded

- **An invoked skill's body persists for the whole session, not the turn.** "the rendered
  `SKILL.md` content enters the conversation as a single message and **stays there for the rest of
  the session**… Claude Code does not re-read the skill file on later turns" —
  https://code.claude.com/docs/en/skills.md § _Skill content lifecycle_
- **Re-invocation is cheap, compaction is the relief valve, and neither helps here.** Identical
  re-invocation "adds a short note that the skill is already loaded rather than a second copy"
  (v2.1.202+); auto-compaction "re-attaches the most recent invocation of each skill after the
  summary, keeping the first 5,000 tokens of each", within "a combined budget of 25,000 tokens" —
  same section. **This project disables auto-compaction** (`.claude/CLAUDE.md` §2.6), so the
  re-attach budget never fires and invoked bodies accumulate until `/handoff` + `/clear`.
- **Anthropic publishes the fork rubric.** "`context: fork` **only makes sense for skills with
  explicit instructions**. If your skill contains guidelines like 'use these API conventions'
  without a task, the subagent receives the guidelines but no actionable prompt, and **returns
  without meaningful output**" — https://code.claude.com/docs/en/skills.md § _Run skills in a
  subagent_. It aligns with the docs' own **reference content vs task content** split.
- **`agent:` defaults to `general-purpose`.** "Options include built-in agents (`Explore`, `Plan`,
  `general-purpose`) or any custom subagent from `.claude/agents/`. **If omitted, uses
  `general-purpose`**" — same section.
- **A backgrounded fork is doubly degraded.** It "runs with the **narrower tool set** that applies
  to background subagents", and "applies its edits **outside your session's checkpoints**, so
  `/rewind` doesn't undo them; use git to revert them" — same section.
- **A forked skill ends slash-command stacking.** "Expansion stops at the first token that isn't an
  inline user-invocable skill, so a skill that runs as a forked subagent… also ends the run there"
  — https://code.claude.com/docs/en/skills.md § _Stack skills_

### Correction to Round 2

Round 2 recorded `model:` as **turn-scoped**, full stop. The sentence continues, and the
continuation reverses the conclusion for forked skills:

> "The override applies for the rest of the current turn and is not saved to settings; the session
> model resumes on your next prompt… **With `context: fork`, the value sets the forked subagent's
> model instead**" — https://code.claude.com/docs/en/skills.md § _Frontmatter reference_

So a **forked** skill carries its model tier durably for that run. Round 2's "persistent model
tier costs 5 agents" holds only for **non-forked** skills; the epic's routing node `N-010` is
corrected accordingly, and must decide the five Fable planning definitions **per skill**, against
`N-016`'s fork call, rather than assuming §2.5 frontmatter is the sole carrier for all five.

---

## Licences, verified against the GitHub API on 11/08/2026

The licence-gate node of the epic this note serves. `.claude/CLAUDE.md` § 6 requires the licence
checked **before** deriving, because a share-alike obligation would propagate into every generated
project.

**First, what this epic actually derived from.** The map named four sources ("Steering Claude
Code", "Skills explained", "Subagents in Claude Code", the Skills docs), but the first two were the
**web summary that prompted the epic** and their URLs were never recorded. Nothing derives from
them: Round 1 **refuted** the summary's load-bearing claim (roster-size degradation) and confirmed
the rest only against primary sources. Per `.claude/MEMORY.md` → _A third-party source's claim is a
lead, not a finding_ — where the primary source confirms it, the substance is the primary source's
and **no attribution is owed to the lead**. So the check reduces to what is genuinely cited here.

| Source                                  | Stars  | Licence             | Obligation if text is carried                   |
| --------------------------------------- | ------ | ------------------- | ----------------------------------------------- |
| `agentskills/agentskills` (the spec)    | 24.1k  | **Apache-2.0**      | Attribution + NOTICE retained on redistribution |
| `anthropics/claude-code` (the CLI docs) | 141.0k | **no LICENSE file** | Unlicensed — read for facts, do not copy text   |
| `anthropics/skills`                     | 167.9k | **no LICENSE file** | Unlicensed — do not copy text (already on file) |

**Verdict: nothing here is share-alike, so the epic is clear to proceed.** No CC-BY-SA source is
involved and no obligation propagates into a generated project. Two operative constraints:

1. **The Agent Skills specification is Apache-2.0** — derivable, and it earns a `README.md`
   § _Influences_ row with a NOTICE obligation, written in the **same change** as the rule it
   credits (`N-014`), not retrospectively.
2. **Claude Code's documentation is unlicensed.** Its **facts** — field names, defaults, documented
   behaviour — are not copyrightable and are freely usable. Its **wording** is not. Every rule
   `N-007` and `N-014` write must be **re-authored**, matching the standing README rule: _"Rule text
   is derived and re-authored, never copied."_ This binds the fork rubric especially, since the
   reference-vs-task distinction came from that page.

---

## Sources

- https://code.claude.com/docs/en/skills.md
- https://code.claude.com/docs/en/sub-agents.md
- https://code.claude.com/docs/en/features-overview.md
- https://code.claude.com/docs/en/cloud-environments.md
- https://agentskills.io/specification
- Installed CLI: `claude --version` → 2.1.226 (verified 09/08/2026)

---

## Unverified

Recorded so no downstream decision treats these as settled.

- **Selection quality vs roster size.** No primary source found. The 20-subagent cap is a
  concurrency limit, not evidence about roster size. Any decision resting on "too many agents
  degrades selection" is resting on a practitioner claim, not documentation.
- **Per-skill standing cost in tokens.** The ~100-token figure is specification _guidance_, not a
  measured or enforced value; Claude Code publishes no formula for N skills. Our own measurement
  (this epic's own _Measured baseline_) is the better local number.
- **Auto-delegation to project agents in cloud sessions.** Documented to carry over; not
  explicitly documented as available for auto-delegation there.
- **Whether `/fork` and `context: fork` share a mechanism.** Documented separately, no stated
  relationship.

Version-dependent: every claim here is against **2.1.226**. `context: fork` behaviour changed at
2.1.218 (auto-background), so it is young enough to re-verify before relying on it long-term.
