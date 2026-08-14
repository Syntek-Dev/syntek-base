# TEMPLATE-GUIDE — Using syntek-base as a Template

**Last Updated**: 14/08/2026 | **Maintained By**: Syntek Studio

Everything a developer needs to generate a project from `syntek-base`, understand what they
received, change it safely, and pull later template improvements back in.

> **These files ship.** Your generated project receives this whole directory, because the
> questions it answers — what am I looking at, which folder do I write in, how do I pull
> upstream fixes — are asked long after generation, not before it. The one exception is
> `TEMPLATE-GAPS.md`, which `copier.yml` excludes: it is syntek-base's own open-items
> register, and means nothing in your project.
>
> **Consequence for anyone editing here.** These files are rendered by Copier like every
> other file in the tree, so a literal token or block delimiter in the prose is **live
> template code**. Where a guide quotes the syntax — `04-QUICKSTART`, `06-GENERATION`,
> `11-CUSTOMISING`, `15-TROUBLESHOOTING` — the region is wrapped in a Jinja `raw` block.
> Add an unwrapped one and generation blanks it or dies.

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
├── 05-ANSWERS.md            ← the Copier questions, and how to answer each
├── 06-GENERATION.md         ← what Copier does to the tree, step by step
│
│   ── Living with it ──
├── 07-REPO-TOUR.md          ← the three layers and how to navigate them
├── 08-CLAUDE-CODE.md        ← skills, hooks, MCP servers, settings
├── 09-PROJECT-MANAGEMENT.md ← how to use project-management/src/ — tiers, patterns, which folder when
├── 10-FIRST-FEATURE.md      ← one feature end to end: chart → specify → build → ship
├── 11-CUSTOMISING.md        ← what is yours to change, what is load-bearing
├── 12-EXTENDING.md          ← add a skill, workflow, guide or Django app
│
│   ── Beyond the laptop ──
├── 13-DEPLOYMENT.md         ← the path to a server and the NixOS deploy repo
├── 14-UPDATING.md           ← copier update, conflicts, and re-sync policy
├── 15-TROUBLESHOOTING.md    ← what breaks, and what to do about it
│
│   ── Reference, no reading order ──
├── GUIDE-TO-SKILLS.md       ← every skill, what it is for, and how to reach it
│
│   ── Maintaining the template itself (NOT shipped) ──
└── TEMPLATE-GAPS.md         ← syntek-base's OWN open items (the root GAPS.md ships, so it stays empty)
```

**Two files are unnumbered, for opposite reasons.** `GUIDE-TO-SKILLS.md` is a lookup table you
dip into at any point, so it sits outside a reading order rather than at a position in one.
`TEMPLATE-GAPS.md` is a working register for someone **maintaining** the template, not using it —
and it is the one file here that does not ship.

## Reading order

Nobody should read all sixteen. Pick the entry point that matches where you are:

| You are…                                     | Read                                       |
| -------------------------------------------- | ------------------------------------------ |
| Evaluating whether to use this at all        | `01-OVERVIEW.md` → `02-STACK.md`           |
| Ready to generate your first project         | `03-PREREQUISITES.md` → `04-QUICKSTART.md` |
| Sitting at the prompt, unsure what to answer | `05-ANSWERS.md`                            |
| Staring at a generated project, lost         | `07-REPO-TOUR.md` → `08-CLAUDE-CODE.md`    |
| Facing 23 numbered PM folders                | `09-PROJECT-MANAGEMENT.md`                 |
| About to build the first feature             | `10-FIRST-FEATURE.md`                      |
| Wondering which skill does a job             | `GUIDE-TO-SKILLS.md`                       |
| Wanting to change what the template gave you | `11-CUSTOMISING.md` → `12-EXTENDING.md`    |
| Taking it to a server                        | `13-DEPLOYMENT.md`                         |
| Months in, wanting upstream fixes            | `14-UPDATING.md`                           |
| Stuck                                        | `15-TROUBLESHOOTING.md`                    |

## Related reference

| Document                            | Purpose                                                           |
| ----------------------------------- | ----------------------------------------------------------------- |
| `../TEMPLATE-TOKENS.md`             | The token contract — every token, format, and derived form        |
| `../../../copier.yml`               | The executable form of that contract                              |
| `../CONTRIBUTING.md`                | Code-quality standards _inside_ a generated project               |
| `../../../CONTRIBUTING.md`          | How to contribute changes to the template itself                  |
| `../BRAND-VOICE.md`                 | The voice a generated project settles at first-time setup, Step 8 |
| `../PLATFORM-PROVIDERS.md`          | The infra register the platform-provider answers render into      |
| `../SCALE-ARCHITECTURE/CONTEXT.md`  | How the app scales — regenerated per project                      |
| `../SERVER-ARCHITECTURE/CONTEXT.md` | What the server must provide — feeds the NixOS deploy repo        |

## Do not use for

- Day-to-day development commands → `how-to/docs/CLI-TOOLING.md`
- Writing code → `code/CONTEXT.md`
- Stories, sprints, releases → `project-management/CONTEXT.md`
