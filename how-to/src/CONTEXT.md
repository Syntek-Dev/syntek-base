# how-to/src — Operator Guides

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

The human-facing operator guides: contributing standards, the template contract and its guide set,
and the two architecture snapshots that feed the deploy repository.

These are `**/src/*.md` documents — written for people, in full, and exempt from the 300-line
instructional limit that applies to `docs/` and `workflows/`.

## Directory Tree

```text
how-to/src/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── CONTRIBUTING.md          ← contributing, testing, and code-quality standards for this project
├── TEMPLATE-TOKENS.md       ← the token contract copier.yml implements (template-only)
├── TEMPLATE-GUIDE/          ← full guides for using syntek-base as a template (template-only)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── 01-OVERVIEW.md · 02-STACK.md · 03-PREREQUISITES.md
│   ├── 04-QUICKSTART.md · 05-ANSWERS.md · 06-GENERATION.md
│   ├── 07-REPO-TOUR.md · 08-CLAUDE-CODE.md · 09-FIRST-STORY.md
│   ├── 10-CUSTOMISING.md · 11-EXTENDING.md
│   └── 12-DEPLOYMENT.md · 13-UPDATING.md · 14-TROUBLESHOOTING.md
├── NIXOS-SETUP.md           ← pointer stub → deploy repo runbooks + SERVER-ARCHITECTURE/
├── SCALE-ARCHITECTURE/      ← how the app scales: load profiles, readiness audit, sizing envelope
└── SERVER-ARCHITECTURE/     ← what the server/edge must provide; feeds the NixOS deploy repo
```

> `TEMPLATE-TOKENS.md` and `TEMPLATE-GUIDE/` are **template-only** — `copier.yml` excludes them,
> so they do not appear in a generated project. If you are reading this inside a generated
> project, that is why they are absent.

## What is here

| Document / folder      | Read it when                                                                     |
| ---------------------- | -------------------------------------------------------------------------------- |
| `CONTRIBUTING.md`      | Contributing to this codebase — branching, commits, testing, code quality, gates |
| `TEMPLATE-GUIDE/`      | Generating a project from syntek-base, or maintaining the template               |
| `TEMPLATE-TOKENS.md`   | You need the token vocabulary and what each one reaches                          |
| `NIXOS-SETUP.md`       | Looking for host provisioning — it points at the deploy repository               |
| `SCALE-ARCHITECTURE/`  | Sizing the deployment, or checking scaling readiness                             |
| `SERVER-ARCHITECTURE/` | Specifying what the server and edge must provide                                 |

## The two snapshots

`SCALE-ARCHITECTURE/` and `SERVER-ARCHITECTURE/` are maintained by the `scale-planner` agent via
`/scale-planning`. They ship as **skeletons**: the methodology is real, but every project-specific
figure carries a `TBD — regenerate via /scale-planning` marker until the agent regenerates them
against live code.

`SCALE-ARCHITECTURE/` decides how the application scales; `SERVER-ARCHITECTURE/` turns that into
the contract the NixOS deploy repository (`<%DEPLOY_REPO%>`) consumes. This repository
**specifies**; the deploy repository **implements**.

## Do not use for

- Day-to-day commands → `how-to/docs/CLI-TOOLING.md`
- Environment setup and troubleshooting → `how-to/docs/DEVELOPMENT.md`
- Writing code → `code/CONTEXT.md`
- Stories, sprints, releases → `project-management/CONTEXT.md`
