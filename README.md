# syntek-base

**A Django-monolith project template that ships with its own documentation system and a Claude
Code skill suite.**

[![Version](https://img.shields.io/badge/version-3.2.2-blue.svg)](CHANGELOG.md)
[![Licence: MIT](https://img.shields.io/badge/licence-MIT-green.svg)](LICENSE)
[![Template: Copier](https://img.shields.io/badge/template-copier-blue.svg)](https://copier.readthedocs.io/)
[![Status: active](https://img.shields.io/badge/status-active-brightgreen.svg)](https://github.com/Syntek-Dev/syntek-base)

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
```

That is the whole install. Copier asks its questions, renders the tree, generates `uv.lock`, and
runs `git init`. How many it asks depends on your answers — the mobile ones only appear if you
opt in. The full list is [`TEMPLATE-TOKENS.md`](how-to/src/TEMPLATE-TOKENS.md).

---

## What this is

Most project templates give you a directory layout and leave you to invent everything else — how
work is specified, where decisions are recorded, what an AI coding agent is allowed to do.
`syntek-base` is the opposite bet: the structure, the process, and the skill configuration are
the product, and the application skeleton is almost incidental.

Generate a project from it and you get, on day one:

| You get                      | What it means                                                                                                                                                       |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A Django 6 monolith**      | Django Ninja JSON API + server-rendered templates, HTMX, Alpine, token CSS. One deployable, no bundler, no build step.                                              |
| **A three-layer doc system** | `code/`, `how-to/`, `project-management/` — each with reference guides and numbered step-by-step workflows, grouped into families by what they do.                  |
| **Skills, loaded on demand** | Stack idioms (Django, HTMX, FastMCP), design grilling, architecture vocabulary, operator-doc craft, session handoff, scale planning, legal and compliance drafting. |
| **A working dev stack**      | Docker Compose for dev/test/staging/prod, Postgres 18, Valkey, Nginx — plus scripts to drive them. Celery and S3 storage are declared, not wired (see below).       |
| **CI that already bites**    | GitHub Actions covering lint, format, type-check, tests, secrets, dependency advisories, line-count, stub and CSS-token audits.                                     |
| **Compliance scaffolding**   | UK GDPR registers, STRIDE threat models, QA plans, SEO checklists, ADRs, and the workflows that produce them.                                                       |

It is opinionated on purpose. The stack is fixed, the coverage floors are fixed, the file-length
limits are fixed. What varies between projects is captured in the template tokens and nothing else.

## The stack

Django 6 · Django Ninja · PostgreSQL 18 · Valkey · Celery · Django templates · django-components ·
HTMX · Alpine · vanilla token CSS · Gunicorn/Uvicorn · Nginx · Docker Compose · Cloudinary ·
SeaweedFS · pytest · Playwright · Bruno · uv · pnpm

One app process family. No React, no Next.js, no GraphQL, no client bundle. The JSON API serves
machine clients; pages are rendered by Django and made interactive with HTMX and Alpine. A third
surface is designed but deliberately unwired: a FastMCP tool server at `/mcp/` for LLM agent
clients, specified in `code/docs/MCP-SERVER.md` and built only when a project needs it.

Full rationale: [`how-to/src/TEMPLATE-GUIDE/02-STACK.md`](how-to/src/TEMPLATE-GUIDE/02-STACK.md).

## Requirements

Docker Engine 27+ with Compose v2, Node 24, pnpm 11+, Python 3.14, uv 0.12+, and git. Copier
itself needs no install — `uvx` fetches it.

Details and per-platform notes:
[`PREREQUISITES.md`](how-to/src/TEMPLATE-GUIDE/03-PREREQUISITES.md).

### Claude Code plan

The skill suite routes across **two model tiers** — `fable` for planning, specification and design
work, `opus` for everything else. That is a deliberate split: the reasoning tier sets the
foundation, the implementation tier builds on it.

Because of the Fable usage, this template is designed for **Claude Max 20× or above, or the
Anthropic API**. On a smaller plan the Fable-tier skills (`story`, `sprint`, `planner`,
`scale-planning`, and the design/compliance workflows) will not run as configured — you can
retarget them to `opus` by editing the `model:` frontmatter, but you lose the tier separation the
process is built around.

**Using a different LLM provider?** Everything except the model routing is provider-agnostic — the
documentation system, workflows, gates and directory conventions work with any coding agent. Expect
to make one pass over `.claude/` to swap the model names and aliases for your provider's
equivalents: `.claude/CLAUDE.md` Section 4, every skill's `model:` frontmatter in `.claude/skills/`, and
the `model:` lines in `**/docs/*.md` and `**/workflows/**/*.md` routing frontmatter.

---

## Read next

The full guide set lives in **[`how-to/src/TEMPLATE-GUIDE/`](how-to/src/TEMPLATE-GUIDE/)**:

| Guide                                                                       | Read it when                                                         |
| --------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| [OVERVIEW.md](how-to/src/TEMPLATE-GUIDE/01-OVERVIEW.md)                     | You want the design philosophy before committing to it               |
| [PREREQUISITES.md](how-to/src/TEMPLATE-GUIDE/03-PREREQUISITES.md)           | Setting up the host tooling                                          |
| [QUICKSTART.md](how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md)                 | Generating your first project and getting it running                 |
| [GENERATION.md](how-to/src/TEMPLATE-GUIDE/06-GENERATION.md)                 | You want to know exactly what Copier does to the tree                |
| [ANSWERS.md](how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md)                       | Deciding how to answer the Copier questions                          |
| [UPDATING.md](how-to/src/TEMPLATE-GUIDE/14-UPDATING.md)                     | Pulling later template improvements into a live project              |
| [REPO-TOUR.md](how-to/src/TEMPLATE-GUIDE/07-REPO-TOUR.md)                   | Finding your way around the three layers                             |
| [STACK.md](how-to/src/TEMPLATE-GUIDE/02-STACK.md)                           | You want to know why each piece was chosen                           |
| [CUSTOMISING.md](how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md)               | Working out what is yours to change and what is load-bearing         |
| [CLAUDE-CODE.md](how-to/src/TEMPLATE-GUIDE/08-CLAUDE-CODE.md)               | Understanding the skill and hook configuration                       |
| [EXTENDING.md](how-to/src/TEMPLATE-GUIDE/12-EXTENDING.md)                   | Adding your own skill, workflow or guide                             |
| [PROJECT-MANAGEMENT.md](how-to/src/TEMPLATE-GUIDE/09-PROJECT-MANAGEMENT.md) | Using `project-management/src/` — tiers, patterns, which folder when |
| [FIRST-FEATURE.md](how-to/src/TEMPLATE-GUIDE/10-FIRST-FEATURE.md)           | Walking a feature from idea to merged PR                             |
| [DEPLOYMENT.md](how-to/src/TEMPLATE-GUIDE/13-DEPLOYMENT.md)                 | Taking it to a server                                                |
| [TROUBLESHOOTING.md](how-to/src/TEMPLATE-GUIDE/15-TROUBLESHOOTING.md)       | Something went wrong                                                 |

Reference material behind the guides:
[`TEMPLATE-TOKENS.md`](how-to/src/TEMPLATE-TOKENS.md) (the token contract) and
[`copier.yml`](copier.yml) (its executable form).

## Updating a generated project

Because generation is done with Copier, a project stays connected to the template. When
`syntek-base` gains a fix, pull it in:

```bash
cd my-project
copier update
```

Copier three-way-merges the change against your edits, using the answers recorded in
`.copier-answers.yml`. This is the main reason the template is Copier-based rather than a
`git clone` you then sever. See [UPDATING.md](how-to/src/TEMPLATE-GUIDE/14-UPDATING.md).

---

## Influences and attribution

syntek-base is assembled from ideas other people worked out first. They are named here so you can
go and check the primary sources yourself rather than taking this template's word for anything —
and because these influences carry into **every project generated from it**, not just this repo.

**These tables are kept current by a standing rule, not by periodic tidying.** `.claude/CLAUDE.md`
Section 6 binds every skill: doctrine derived from an outside source is credited in the same change as
the rule it credits, and the **licence column below is consulted before deriving, not after** —
because use, adapt and redistribute are three different permissions, and a share-alike source
would propagate its obligation into every generated project.

### Practitioners

| Who                                                                                                                                                                                                                                                                                                                                                                                                                     | What it shaped here                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Matt Pocock** — [AI Hero](https://www.aihero.dev/) · [mattpocock.com](https://www.mattpocock.com/) · [skills](https://github.com/mattpocock/skills) · [dictionary-of-ai-coding](https://github.com/mattpocock/dictionary-of-ai-coding)                                                                                                                                                                                | The engineering process for working _with_ coding agents rather than around them: context gathering, planning before code, steering, feedback loops, spec-driven workflows, and human-in-the-loop review. Two of his repositories are adapted directly — see below                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| **Jake Van Clief** — [_Interpretable Context Methodology_](https://arxiv.org/abs/2603.16021) with David McDermott (arXiv:2603.16021v2, CC BY 4.0) · [ICM protocol](https://github.com/RinDig/Interpretable-Context-Methodology) · [icm-architect](https://github.com/RinDig/icm-architect) (both MIT) · [Clief Notes](https://www.skool.com/cliefnotes/about) · [LinkedIn](https://www.linkedin.com/in/jake-van-clief/) | File organisation and folder architecture as the substrate for AI work, reusable prompt frameworks, and building durable structure underneath rather than chasing tool releases. The layered `CONTEXT.md` / `CLAUDE.md` system owes this its shape — the paper states it as a five-layer hierarchy in which the stage contract, not the root file, is the control point. **Read as primary sources, never derived into shipped text**; the carve-out on the protocol repo's bundled files is in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md). Check the evidence before borrowing the claims: the paper is candid that its figures are practitioner self-report and that **no controlled comparison against monolithic prompting has been run** (Section 4.6) |
| **Martin Fowler** — [_Refactoring_](https://martinfowler.com/books/refactoring.html), ch. 3                                                                                                                                                                                                                                                                                                                             | The twelve code smells named as the Standards-axis baseline in `code/workflows/07-review/`. The taxonomy is referenced, not reproduced, and the repo's own documented standards override it — a smell is a prompt to look closer, never a violation on its own                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| **Gamma, Helm, Johnson, Vlissides** — [_Design Patterns_](https://en.wikipedia.org/wiki/Design_Patterns)                                                                                                                                                                                                                                                                                                                | The pattern catalogue behind the smell-to-pattern map in `code/docs/coding-principles/PRACTICAL-RULES.md`. **The names and their intents are used as vocabulary; no text is reproduced** — every row is re-authored against this stack, and three are disambiguated for Django because the catalogue's framing does not transfer to an ORM                                                                                                                                                                                                                                                                                                                                                                                                                          |
| **Sandi Metz** — [_The Wrong Abstraction_](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction)                                                                                                                                                                                                                                                                                                                  | Why duplication is cheaper than a bad abstraction — visible and local, against a cost hidden behind an interface every caller already depends on. Behind _When not to abstract_ in the same guide                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |

### Design and anti-slop craft

The cross-surface visual-design doctrine, the copy rules, and the audit scripts derive from the
open skill ecosystem below. **Rule text is derived and re-authored, never copied** — sources are
cited so the reasoning stays checkable, and so no upstream licence obligation propagates into a
project generated from this template. **Every row is self-citing:** it links the source and names
what that source contributed, so the primary source _is_ the citation and no survey note sits
between it and the reader.

| Source                                                                                                               | Contributed                                                                            | Licence    |
| -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------- |
| [Impeccable](https://github.com/pbakaus/impeccable) — Paul Bakaus                                                    | The craft floor, the deterministic-detector idea, and the native/mobile audit taxonomy | Apache-2.0 |
| [Taste Skill](https://github.com/Leonxlnx/taste-skill) — Leon                                                        | Named visual directions as a commitment device instead of a default                    | MIT        |
| [`skills/frontend-design`](https://github.com/anthropics/skills) — Anthropic                                         | The original banned-defaults framing for machine-authored UI                           | —          |
| [emilkowalski/skills](https://github.com/emilkowalski/skills) — Emil Kowalski                                        | The numeric motion standard: frequency-first, duration ceilings, easing hierarchy      | MIT        |
| [stop-slop](https://github.com/hardikpandya/stop-slop) — Hardik Pandya                                               | The structural taxonomy of AI prose tells behind the copy rules                        | MIT        |
| [hallmark](https://github.com/nutlope/hallmark) — Hassan El Mghari                                                   | Macrostructure-first generation and slop-test gating                                   | MIT        |
| [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)                                             | Treating design knowledge as a searchable reference, not a prescription                | MIT        |
| [Web Interface Guidelines](https://github.com/vercel-labs/agent-skills) — Vercel Labs                                | Auditing interface rules with `file:line` output a reviewer can act on                 | —          |
| [awesome-claude-design](https://github.com/VoltAgent/awesome-claude-design) — VoltAgent                              | The nine-section `DESIGN.md` brief format                                              | MIT        |
| [claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) — OneRedOak                              | The design-review subagent pattern over a driven browser                               | MIT        |
| [Playwright](https://playwright.dev/) · [chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) | Verifying the rendered result rather than trusting the source                          | Apache-2.0 |

### Adapted directly, and tooling

Where the design sources above are _derived from_, these are **adapted or run as-is** — the
dependency is direct and the credit is owed accordingly.

| Source                                                                                      | How it is used here                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Licence |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- |
| [mattpocock/skills](https://github.com/mattpocock/skills) — Matt Pocock                     | Skill authoring patterns behind `.claude/skills/` and the standard in `how-to/docs/SKILL-AUTHORING.md`. **Two files are adapted text, not derived** — both of `.claude/skills/improve-codebase-architecture/`; MIT notice in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md). Four skills (`resolving-merge-conflicts`, `wizard`, `to-questionnaire`, `wait-what`) and grilling's frontier-round method are **derived** from his set and re-authored. The same-named skills (`grilling`, `wayfinder`, `codebase-design`, `prototype`, `research`, `teach`, `handoff`, …) are independently authored | MIT     |
| [mattpocock/dictionary-of-ai-coding](https://github.com/mattpocock/dictionary-of-ai-coding) | [`how-to/docs/AI-DICTIONARY.md`](how-to/docs/AI-DICTIONARY.md) is adapted from it — sixty-nine terms re-authored in British English, credited in the file itself                                                                                                                                                                                                                                                                                                                                                                                                                                       | none    |
| [tirth8205/code-review-graph](https://github.com/tirth8205/code-review-graph) — Tirth Patel | The MCP server in `.mcp.json` is **run as-is**; the four generated playbook cards under `.claude/skills/` are **committed upstream-authored text** — MIT notice in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md). Graph-refresh gate: `code/docs/CODE-REVIEW-GRAPH.md`                                                                                                                                                                                                                                                                                                                            | MIT     |
| [cloudinary-devs/skills](https://github.com/cloudinary-devs/skills) — Cloudinary            | **Vendored verbatim** — 15 files under `.agents/skills/`, installed via `skills-lock.json` and symlinked into `.claude/skills/`. Not derived, not adapted: copied. MIT notice in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md)                                                                                                                                                                                                                                                                                                                                                                    | MIT     |

### Platform and engineering craft

The backend, background-job, observability and security doctrine draws on these. As above, **rules
are derived and re-authored, never copied**, and **every row is self-citing** — it links the
source and names what that source contributed, so the primary source _is_ the citation. The two
**specification** rows go further and link the numbered clause they derive. Two rows carry
evidence a link alone cannot settle, and it lives in
[`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md): **TigerStyle**, whose derivation is measured
at 0.0% five-gram overlap, and the **Claude Code docs**, which carry no upstream licence — the
notice records that nothing this template ships quotes them, so no grant is needed.

| Source                                                                                               | Contributed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Licence      |
| ---------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| [wshobson/agents](https://github.com/wshobson/agents) — Seth Hobson                                  | Background-job discipline (idempotency under at-least-once delivery, retry policy, DLQ), async/sync patterns, and the incident-practice agenda — postmortem structure, the on-call handover, and runbook templates                                                                                                                                                                                                                                                                                                                                                                                         | MIT          |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — Addy Osmani                  | Spec-driven and doubt-driven development, context engineering                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | MIT          |
| [trailofbits/skills](https://github.com/trailofbits/skills) — Trail of Bits                          | The security-review agenda: Rust review, constant-time analysis, insecure defaults, Semgrep rule authoring. **Read as a checklist of concerns only** — its share-alike licence is incompatible with redistribution into client projects                                                                                                                                                                                                                                                                                                                                                                    | CC-BY-SA-4.0 |
| [agentskills/agentskills](https://github.com/agentskills/agentskills)                                | The published [Agent Skills specification](https://agentskills.io/specification) — the six `SKILL.md` frontmatter fields and their constraints. `how-to/docs/skill-authoring/FRONTMATTER.md` states the format, then records which fields this project authors and which it declines; `audits/skill-conformance.sh` checks both halves. What is taken is the field set, their limits, and a one-line statement of each field's job — facts, not prose — measured at zero shared five-grams with the specification text                                                                                     | Apache-2.0   |
| [Claude Code — Agent Skills docs](https://code.claude.com/docs/en/skills) — Anthropic                | The runtime behaviour the fork rubric rests on, and the reference-versus-task framing it starts from: which keys Claude Code reads beyond the specification's six, that a forked skill begins without the conversation, that `Explore` and `Plan` skip CLAUDE.md where other targets keep it, and what a backgrounded fork gives up. Behind `how-to/docs/skill-authoring/FORK-DECISION.md` and `FRONTMATTER.md`. **No LICENCE upstream** — the facts are used and every rule re-authored, measured at zero shared five-grams; the research note quotes it, marked and cited, and the shipped guides do not | none         |
| [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) — Tom Preston-Werner                | The versioning doctrine in `project-management/docs/VERSIONING-GUIDE.md`: rule 1's **declare a public API** obligation — which is what makes MAJOR decidable and had never been met here — plus `0.y.z` and `1.0.0` (rules 4–5), the pre-release and build-metadata grammar (rules 9–10), precedence (rule 11), and the FAQ's deprecation and wrong-release recovery policies. Rules are re-authored and each is applied to this repository's own surfaces; the spec's numbered clauses are the citation                                                                                                   | CC BY 3.0    |
| [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)                         | Breaking-change signalling in `project-management/docs/GIT-GUIDE.md` — the `!` shorthand, the `BREAKING CHANGE:` footer, and the `fix`→PATCH / `feat`→MINOR / any-breaking-change→MAJOR mapping. The commit format itself was already in use here; what is derived is how a commit **declares** that it breaks something                                                                                                                                                                                                                                                                                   | CC BY 3.0    |
| [alibaba/open-code-review](https://github.com/alibaba/open-code-review)                              | Code-review architecture at scale, alongside the code-review-graph                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Apache-2.0   |
| [TigerStyle](https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/TIGER_STYLE.md) — TigerBeetle | Negative-space programming: state what must **never** be true, enforce each invariant at one named point, and fail loudly rather than degrade. Behind `code/docs/NEGATIVE-SPACE.md` and `how-to/src/INVARIANTS.md`. **Its assertion mechanism is deliberately not adopted** — Python's `assert` is stripped by `-O` and cannot carry the register key, so guards `raise` instead. The name is ThePrimeagen's coinage for the idea Hoare simply called logic                                                                                                                                                | Apache-2.0   |

Everything above is free to read. **Reuse is narrower than that**, in two directions: an
unlicensed row grants nothing at all, and a share-alike row cannot travel into a template this
project redistributes — which is why both are taken as facts and never as wording. If a rule in
this template looks wrong to you, the original is one click away — read it and form your own view.

---

## Licence

MIT — see [LICENSE](LICENSE).

Use it, fork it, rebrand it, build commercial products with it. You owe nothing back. Projects
you generate carry **their own** licence, which is one of the Copier questions and defaults to
proprietary; MIT places no obligation on your output.

## Contributing

Bug reports and improvements are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for what the
template accepts and how to test a change (short version: generate a project from your branch
and prove no token survives).

Security problems go through private disclosure, never a public issue —
see [SECURITY.md](SECURITY.md).

---

_Maintained by Syntek Studio · v3.2.2 · British English (en_GB) throughout_
