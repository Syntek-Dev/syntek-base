# syntek-base

**A Django-monolith project template that ships with its own documentation system and a Claude
Code agent suite.**

[![Version](https://img.shields.io/badge/version-2.10.0-blue.svg)](CHANGELOG.md)
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
`syntek-base` is the opposite bet: the structure, the process, and the agent configuration are
the product, and the application skeleton is almost incidental.

Generate a project from it and you get, on day one:

| You get                       | What it means                                                                                                                                                       |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A Django 6 monolith**       | Django Ninja JSON API + server-rendered templates, HTMX, Alpine, token CSS. One deployable, no bundler, no build step.                                              |
| **A three-layer doc system**  | `code/`, `how-to/`, `project-management/` — each with reference guides and numbered step-by-step workflows, grouped into families by what they do.                  |
| **A Claude Code agent suite** | 8 orchestrators that delegate to specialists and document writers, each tool-scoped, each with a defined remit. Roster: `.claude/agents/CONTEXT.md`.                |
| **Skills, loaded on demand**  | Stack idioms (Django, HTMX, FastMCP), design grilling, architecture vocabulary, operator-doc craft, session handoff, scale planning, legal and compliance drafting. |
| **A working dev stack**       | Docker Compose for dev/test/staging/prod, Postgres 18, Valkey, Celery, Nginx, Mailpit — plus scripts to drive them.                                                 |
| **CI that already bites**     | GitHub Actions covering lint, format, type-check, tests, secrets, dependency advisories, line-count, stub and CSS-token audits.                                     |
| **Compliance scaffolding**    | UK GDPR registers, STRIDE threat models, QA plans, SEO checklists, ADRs, and the workflows that produce them.                                                       |

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

Docker Engine 27+ with Compose v2, Node 24, pnpm 11+, Python 3.14, uv 0.11+, and git. Copier
itself needs no install — `uvx` fetches it.

Details and per-platform notes:
[`PREREQUISITES.md`](how-to/src/TEMPLATE-GUIDE/03-PREREQUISITES.md).

### Claude Code plan

The agent suite routes across **two model tiers** — `fable` for planning, specification and design
work, `opus` for everything else. That is a deliberate split: the reasoning tier sets the
foundation, the implementation tier builds on it.

Because of the Fable usage, this template is designed for **Claude Max 20× or above, or the
Anthropic API**. On a smaller plan the Fable-tier agents (`story`, `sprint`, `planner`,
`user-story`, and the design/compliance workflows) will not run as configured — you can retarget
them to `opus` by editing the `model:` frontmatter, but you lose the tier separation the process
is built around.

**Using a different LLM provider?** Everything except the model routing is provider-agnostic — the
documentation system, workflows, gates and directory conventions work with any coding agent. Expect
to make one pass over `.claude/` to swap the model names and aliases for your provider's
equivalents: `.claude/CLAUDE.md` §4, every agent's `model:` frontmatter in `.claude/agents/`, and
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
| [CLAUDE-CODE.md](how-to/src/TEMPLATE-GUIDE/08-CLAUDE-CODE.md)               | Understanding the agent, skill and hook configuration                |
| [EXTENDING.md](how-to/src/TEMPLATE-GUIDE/12-EXTENDING.md)                   | Adding your own agent, skill, workflow or guide                      |
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

_Maintained by Syntek Studio · v1.0.0 · British English (en_GB) throughout_
