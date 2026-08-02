# TEMPLATE-GUIDE — Using syntek-base as a Template

**Last Updated**: 02/08/2026 | **Maintained By**: Syntek Studio

Everything a developer needs to generate a project from `syntek-base`, understand what they
received, change it safely, and pull later template improvements back in.

> **These files are template-only.** `copier.yml` excludes this directory, so none of it lands
> in a generated project — which is why it is written in literal prose with no `<%TOKEN%>`
> substitution, and can quote token syntax freely.

## Directory Tree

```text
how-to/src/TEMPLATE-GUIDE/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for editing these guides
│
│   ── Before you generate ──
├── 01-OVERVIEW.md           ← what syntek-base is, the bets it makes, who it suits
├── 02-STACK.md              ← every stack component and why it was chosen
├── 03-PREREQUISITES.md      ← host tooling, per-platform notes, verification
│
│   ── Generating ──
├── 04-QUICKSTART.md         ← generate → running stack, the short path
├── 05-ANSWERS.md            ← the twenty-one questions, and how to answer each
├── 06-GENERATION.md         ← what Copier does to the tree, step by step
│
│   ── Living with it ──
├── 07-REPO-TOUR.md          ← the three layers and how to navigate them
├── 08-CLAUDE-CODE.md        ← agents, skills, hooks, MCP servers, settings
├── 09-FIRST-STORY.md        ← a feature from user story to merged PR
├── 10-CUSTOMISING.md        ← what is yours to change, what is load-bearing
├── 11-EXTENDING.md          ← add an agent, skill, workflow, guide or Django app
│
│   ── Beyond the laptop ──
├── 12-DEPLOYMENT.md         ← the path to a server and the NixOS deploy repo
├── 13-UPDATING.md           ← copier update, conflicts, and re-sync policy
└── 14-TROUBLESHOOTING.md    ← what breaks, and what to do about it
```

## Reading order

Nobody should read all fourteen. Pick the entry point that matches where you are:

| You are…                                     | Read                                       |
| -------------------------------------------- | ------------------------------------------ |
| Evaluating whether to use this at all        | `01-OVERVIEW.md` → `02-STACK.md`           |
| Ready to generate your first project         | `03-PREREQUISITES.md` → `04-QUICKSTART.md` |
| Sitting at the prompt, unsure what to answer | `05-ANSWERS.md`                            |
| Staring at a generated project, lost         | `07-REPO-TOUR.md` → `08-CLAUDE-CODE.md`    |
| About to build the first feature             | `09-FIRST-STORY.md`                        |
| Wanting to change what the template gave you | `10-CUSTOMISING.md` → `11-EXTENDING.md`    |
| Taking it to a server                        | `12-DEPLOYMENT.md`                         |
| Months in, wanting upstream fixes            | `13-UPDATING.md`                           |
| Stuck                                        | `14-TROUBLESHOOTING.md`                    |

## Related reference

| Document                            | Purpose                                                    |
| ----------------------------------- | ---------------------------------------------------------- |
| `../TEMPLATE-TOKENS.md`             | The token contract — every token, format, and derived form |
| `../../../copier.yml`               | The executable form of that contract                       |
| `../CONTRIBUTING.md`                | Code-quality standards _inside_ a generated project        |
| `../../../CONTRIBUTING.md`          | How to contribute changes to the template itself           |
| `../SCALE-ARCHITECTURE/CONTEXT.md`  | How the app scales — regenerated per project               |
| `../SERVER-ARCHITECTURE/CONTEXT.md` | What the server must provide — feeds the NixOS deploy repo |

## Do not use for

- Day-to-day development commands → `how-to/docs/CLI-TOOLING.md`
- Writing code → `code/CONTEXT.md`
- Stories, sprints, releases → `project-management/CONTEXT.md`
