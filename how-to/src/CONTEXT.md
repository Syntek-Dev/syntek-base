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
├── BRAND-VOICE.md           ← how the project writes: tone, four registers, banned machine tells
├── CONTRIBUTING.md          ← contributing, testing, and code-quality standards for this project
├── INVARIANTS.md            ← the register: every invariant, its one enforcement point, its breach
├── PLATFORM-PROVIDERS.md    ← the register: every infra dependency, its seam kind, its alternates
├── PROJECT-PATHS.md         ← the register: every path a shipped doc promises, and what creates it
├── STORE-LISTING.md         ← MOBILE-ONLY — the register: this project's App Store / Play listing values
├── TEMPLATE-TOKENS.md       ← the token contract copier.yml implements (ships, and is rendered)
├── TEMPLATE-GUIDE/          ← full guides for using syntek-base as a template (all of which ship)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── 01-OVERVIEW.md · 02-STACK.md · 03-PREREQUISITES.md
│   ├── 04-QUICKSTART.md · 05-ANSWERS.md · 06-GENERATION.md
│   ├── 07-REPO-TOUR.md · 08-CLAUDE-CODE.md
│   ├── 09-PROJECT-MANAGEMENT.md · 10-FIRST-FEATURE.md
│   ├── 11-CUSTOMISING.md · 12-EXTENDING.md
│   └── 13-DEPLOYMENT.md · 14-UPDATING.md · 15-TROUBLESHOOTING.md
├── NIXOS-SETUP.md           ← pointer stub → deploy repo runbooks + SERVER-ARCHITECTURE/
├── SCALE-ARCHITECTURE/      ← how the app scales: load profiles, readiness audit, sizing envelope
└── SERVER-ARCHITECTURE/     ← what the server/edge must provide; feeds the NixOS deploy repo
```

> **Every file in this tree ships.** `copier.yml` excludes nothing here — it did exclude one,
> `TEMPLATE-GUIDE/TEMPLATE-GAPS.md`, until that register was folded into the root `GAPS.md` on
> 22/08/2026. `TEMPLATE-TOKENS.md` and all of `TEMPLATE-GUIDE/` land in a generated project,
> because most of what those guides answer is asked long after generation: what am I looking at,
> which skill does this job, how do I pull upstream fixes.
>
> The consequence for anyone editing them — they are rendered by Copier, so a literal token in
> the prose is live template code — is `CLAUDE.md` → _Guardrails_.

## What is here

| Document / folder       | Read it when                                                                      |
| ----------------------- | --------------------------------------------------------------------------------- |
| `BRAND-VOICE.md`        | Writing any user-facing copy — and settling the voice at first-time setup         |
| `CONTRIBUTING.md`       | Contributing to this codebase — branching, commits, testing, code quality, gates  |
| `INVARIANTS.md`         | Adding a constraint or a guard — recording the one place an invariant is enforced |
| `PLATFORM-PROVIDERS.md` | Choosing or swapping an infrastructure provider, or classifying a new dependency  |
| `PROJECT-PATHS.md`      | Citing a path this repository does not hold — recording what creates it, and when |
| `TEMPLATE-GUIDE/`       | Generating a project from syntek-base, or maintaining the template                |
| `TEMPLATE-TOKENS.md`    | You need the token vocabulary and what each one reaches                           |
| `NIXOS-SETUP.md`        | Looking for host provisioning — it points at the deploy repository                |
| `SCALE-ARCHITECTURE/`   | Sizing the deployment, or checking scaling readiness                              |
| `SERVER-ARCHITECTURE/`  | Specifying what the server and edge must provide                                  |

## The two snapshots

`SCALE-ARCHITECTURE/` and `SERVER-ARCHITECTURE/` are maintained by the `scale-planning` skill via
`/scale-planning`. They ship as **skeletons**: the methodology is real, but every project-specific
figure carries a `TBD — regenerate via /scale-planning` marker until a run regenerates them
against live code.

`SCALE-ARCHITECTURE/` decides how the application scales; `SERVER-ARCHITECTURE/` turns that into
the contract the NixOS deploy repository (`<%DEPLOY_REPO%>`) consumes. This repository
**specifies**; the deploy repository **implements**.

## Do not use for

- Day-to-day commands → `how-to/docs/CLI-TOOLING.md`
- Environment setup and troubleshooting → `how-to/docs/DEVELOPMENT.md`
- Writing code → `code/CONTEXT.md`
- Stories, sprints, releases → `project-management/CONTEXT.md`
