# Repository Tour

**Last Updated**: 02/08/2026

You have generated a project and it has a lot of directories. This is what they are and how to
find your way.

---

## The organising idea

Four layers, each self-describing:

| Layer                 | Holds                                              | Entry point                     |
| --------------------- | -------------------------------------------------- | ------------------------------- |
| `code/`               | Source, coding standards, coding workflows         | `code/CONTEXT.md`               |
| `how-to/`             | Setup, daily development, debugging, scaling       | `how-to/CONTEXT.md`             |
| `project-management/` | Stories, sprints, design, GDPR, security, releases | `project-management/CONTEXT.md` |
| `.claude/`            | Agent routing, skills, hooks, global rules         | `.claude/CLAUDE.md`             |

Each layer has the same internal shape:

```text
<layer>/
├── CONTEXT.md      ← orientation: the tree, what is here, what not to use it for
├── CLAUDE.md       ← operating rules: how to work here, guardrails, naming
├── REFERENCES.md   ← index of internal and external references
├── docs/           ← reference guides — the "why" and the standard
├── src/            ← the actual artefacts (code, or PM documents)
└── workflows/      ← numbered step-by-step procedures — the "how"
```

**`docs/` tells you the rule. `workflows/` walks you through applying it. `src/` is where the
output lands.**

## The two-file convention

Every directory that carries a `CONTEXT.md` also carries a `CLAUDE.md`.

- **`CONTEXT.md`** — orientation. Directory tree, what lives here, when to read it.
- **`CLAUDE.md`** — operating rules. Purpose, how to work here, guardrails, output and naming.

They are separate because they answer different questions and are read at different moments. When
you add a directory, you add both — CI and the documentation gate both check.

---

## `code/`

```text
code/
├── docs/            ← 20+ guides: architecture, security, testing, rendering, RLS, tokens
├── src/
│   ├── django/      ← the application
│   ├── docker/      ← Dockerfiles and Compose files per environment
│   ├── scripts/     ← every dev operation — you run these, not raw commands
│   └── tests/       ← Bruno API collections
└── workflows/       ← coding workflows, in four families:
                     build (01–06) · verify (07–08) · diagnose & improve (09–11)
                     · build, opt-in (12 rust-only · 13 desktop-only)
```

**`code/src/scripts/` is the interface to everything.** Grouped by what the scripts do:

| Group                            | Examples                                                                                       |
| -------------------------------- | ---------------------------------------------------------------------------------------------- |
| `development/`                   | `server.sh`, `logs.sh`, `shell.sh`, `new-django-app.sh`, `template-update.sh`                  |
| `database/`                      | `migrate.sh`, `reset.sh`, `backup.sh`, `manageusers.sh`                                        |
| `tests/`                         | `all.sh`, `backend.sh`, `api.sh`, `backend-coverage.sh`                                        |
| `syntax/`                        | `lint.sh`, `check.sh`, `format.sh`                                                             |
| `audits/`                        | `cloc.sh`, `docs-length.sh`, `stubs.sh`, `css-tokens.sh`, `security.sh`, `template-orphans.sh` |
| `deployment/`                    | a scaffold — the sanctioned deploy entry point is not written yet                              |
| `mobile/` · `rust/` · `desktop/` | present only where the project opted into that surface                                         |
| `_lib/`                          | shared helpers the other groups source, never run directly                                     |

Every script takes `--help`. Never run `python`, `pytest`, `pnpm` or `docker` directly — the
scripts handle the container, the environment and the compose overrides for your branch.

## `how-to/`

Operational guides and nine workflows in four families — set up (`01`–`02`), run (`03`–`07`,
covering daily development, database operations, testing, quality gates and dependency updates),
diagnose (`08`), and author (`09`, for writing operator guides of your own).
`how-to/docs/CLI-TOOLING.md` is the command reference you will use most.

`how-to/src/` holds the human-facing operator guides, exempt from the 300-line limit:
the contributing standard, this template guide, and the two architecture snapshots.

## `project-management/`

The heaviest layer, and the one that makes the process real.

```text
project-management/src/
├── 00-ASSETS/                    ← logos, export scripts
│   ── specify (02–13) ──
├── 02-STORIES/ 03-SPRINTS/ 04-DATABASE/ 05-USER-FLOW/ 06-BRAND-GUIDE/
├── 07-COMPONENTS/ 08-WIREFRAMES/ 09-GDPR/ 10-SECURITY/ 11-QA/ 12-SEO/ 13-API-DESIGN/
│   ── decide & plan (14–16) ──
├── 14-DECISIONS/ 15-SPRINT-PLANS/ 16-STORY-PLANS/
│   ── record, per story (17–21) ──
├── 17-TESTS/ 18-REVIEWS/ 19-FINDINGS/ 20-BUGS/ 21-REFACTORING/
│   ── record, not per story (22) ──
└── 22-INCIDENTS/
```

The numbered `src/` folders mirror the numbered `workflows/`. **`16-STORY-PLANS/` is what a
developer actually codes from** — it references the sprint plan, the decisions, and every 02–13
specification.

**`22-INCIDENTS/` is the exception to both patterns**, and knowing why saves you looking for
things that do not exist: it has no matching workflow, because an incident is unplanned and
cannot be gated, and it is not anchored to a `US###`, because an incident is not caused by or
owned by a story. It is a **PII-free** register — the substance of an incident lives in your
incident tracker, never in git. The practice is `how-to/docs/INCIDENT-PRACTICE.md`.

## `.claude/`

```text
.claude/
├── CLAUDE.md    ← the authoritative operating manual — read first, always
├── MEMORY.md    ← project memory: feedback, patterns, project state
├── skills/      ← skills, loaded on demand (skills/CONTEXT.md)
├── hooks/       ← pre-PR quality gates and the pre-compact handoff interceptor
└── plugins/     ← 6 read-only inspection helpers a skill calls for context
```

Covered properly in `08-CLAUDE-CODE.md`.

## Root files

| File                  | What                                                                |
| --------------------- | ------------------------------------------------------------------- |
| `CONTEXT.md`          | Project overview, full directory tree, layer map                    |
| `REFERENCES.md`       | Curated index of every internal guide and external resource         |
| `DESIGN.md`           | Design entry point — standards, constraints, Figma                  |
| `GAPS.md`             | Active gaps, blockers, sprint dependencies                          |
| `DEFERRED.md`         | Work explicitly deferred to a named future story                    |
| `install.sh`          | Toolchain bootstrap                                                 |
| `.copier-answers.yml` | Your generation answers — **commit this**, `copier update` needs it |

---

## Finding things

| You want                            | Go to                                        |
| ----------------------------------- | -------------------------------------------- |
| A command                           | `how-to/docs/CLI-TOOLING.md`                 |
| The rule about X                    | `REFERENCES.md`, then the guide it points to |
| How to do a task properly           | The matching `workflows/NN-…/STEPS.md`       |
| What a directory is for             | Its `CONTEXT.md`                             |
| What I am allowed to do here        | Its `CLAUDE.md`                              |
| Why a decision was made             | `project-management/src/14-DECISIONS/`       |
| What is currently broken or blocked | `GAPS.md`                                    |

Or ask Claude — the structure exists so it can answer accurately.

---

## Next

- The skill setup → `08-CLAUDE-CODE.md`
- Build something → `10-FIRST-FEATURE.md`
