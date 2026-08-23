# Repository Tour

**Last Updated**: 23/08/2026

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
| `.claude/`            | Skills, routing, hooks, global rules               | `.claude/CLAUDE.md`             |

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

`.claude/` is the exception — it is configuration rather than a layer of work, so it carries
`skills/`, `hooks/` and `plugins/` instead.

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
├── docs/            ← 37 guides plus 20 sub-directories: architecture, security,
│                      testing, rendering, RLS, tokens, discoverability, visual design
├── src/
│   ├── django/      ← the application
│   ├── docker/      ← Dockerfiles and Compose files per environment
│   ├── scripts/     ← every dev operation — you run these, not raw commands
│   └── tests/       ← Bruno API collections
└── workflows/       ← coding workflows, in four families:
                     build (01–06) · verify (07–08) · diagnose & improve (09–11)
                     · build, opt-in (12 rust-only · 13 desktop-only)
```

An oversized guide splits into a sub-directory beside it and the entry point becomes a thin index
— that is what the twenty sub-directories are, not a second category of document.

**`code/src/scripts/` is the interface to everything** — around eighty shell scripts, grouped by
what they do:

| Group                            | Examples                                                                                                                                               |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `development/`                   | `server.sh`, `logs.sh`, `shell.sh`, `new-django-app.sh`, `new-django-view.sh`, `template-update.sh`                                                    |
| `database/`                      | `migrate.sh`, `reset.sh`, `backup.sh`, `restore.sh`, `manageusers.sh`, `verify-db-security.sh`                                                         |
| `tests/`                         | `all.sh`, `backend.sh`, `api.sh`, `e2e-py.sh`, `backend-coverage.sh`, `mutmut.sh`                                                                      |
| `syntax/`                        | `lint.sh`, `check.sh`, `format.sh`                                                                                                                     |
| `audits/`                        | 24 of them — `cloc.sh`, `docs-length.sh`, `docs-pairing.sh`, `stubs.sh`, `css-tokens.sh`, `security.sh`, `template-orphans.sh`, `skill-conformance.sh` |
| `dependencies/`                  | `update.sh` — add, upgrade or remove a dependency and re-resolve                                                                                       |
| `deployment/`                    | a scaffold — the sanctioned deploy entry point is not written yet                                                                                      |
| `mobile/` · `rust/` · `desktop/` | present only where the project opted into that surface                                                                                                 |
| `_lib/`                          | shared helpers the other groups source, never run directly                                                                                             |
| `reports/`                       | generated output, gitignored — the one place a `CONTEXT.md` pair is not required                                                                       |

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
├── 00-ASSETS/                    ← logos, export scripts — reference, not a stage
│   ── discover, once per feature (01) ──
├── 01-FEATURE-MAPS/              ← the wayfinder decision maps
│   ── specify (02–14) ──
├── 02-STORIES/ 03-SPRINTS/ 04-DATABASE/ 05-USER-FLOW/ 06-BRAND-GUIDE/
├── 07-COMPONENTS/ 08-WIREFRAMES/ 09-GDPR/ 10-SECURITY/ 11-QA/ 12-SEO/ 13-API-DESIGN/
├── 14-LOGGING/
│   ── decide & plan (15–17) ──
├── 15-DECISIONS/ 16-SPRINT-PLANS/ 17-STORY-PLANS/
│   ── record, per story (18–22) ──
├── 18-TESTS/ 19-REVIEWS/ 20-FINDINGS/ 21-BUGS/ 22-REFACTORING/
│   ── record, not per story (23) ──
└── 23-INCIDENTS/
```

The numbered `src/` folders mirror the numbered `workflows/` up to `17`. **`17-STORY-PLANS/` is
what a developer actually codes from** — it references the sprint plan, the decisions, and every
02–14 specification.

**These numbers are frozen — append only, never renumber.** They hold artefacts you wrote, and
Copier tracks only what it generated, so renumbering one strands your work silently on the next
update (`14-UPDATING.md`).

**`23-INCIDENTS/` is the exception to both patterns**, and knowing why saves you looking for
things that do not exist: it has no matching workflow, because an incident is unplanned and
cannot be gated, and it is not anchored to a `US###`, because an incident is not caused by or
owned by a story. It is a **PII-free** register — the substance of an incident lives in your
incident tracker, never in git. The practice is `how-to/docs/INCIDENT-PRACTICE.md`.

## `.claude/`

```text
.claude/
├── CLAUDE.md      ← the authoritative operating manual — read first, always
├── MEMORY.md      ← project memory: feedback, patterns, project state (starts empty)
├── settings.json  ← permissions, model, effort level, hooks, disabled plugins
├── skills/        ← skills, loaded on demand (skills/CONTEXT.md)
├── hooks/         ← the pre-PR quality gates and the two session-continuity hooks
└── plugins/       ← 6 read-only inspection helpers a skill calls for context
```

Covered properly in `08-CLAUDE-CODE.md`.

## The four scratch directories

Not a layer — four working areas at the root, each written by one skill and read by nobody else:

| Directory         | Written by          | Holds                                                 |
| ----------------- | ------------------- | ----------------------------------------------------- |
| `handoffs/`       | `handoff`           | Session handoff documents, the compaction replacement |
| `research/`       | `/research`         | Primary-source-cited notes that feed a decision       |
| `questionnaires/` | `/to-questionnaire` | Outbound discovery questionnaires                     |
| `learning/`       | `/teach`            | A throwaway sandbox — the one place `/teach` writes   |

In a **generated project** all four are tracked, because there they are the work — and they arrive
empty, holding nothing but their `CONTEXT.md` and `CLAUDE.md`. `syntek-base` tracks its own too,
so they sync across devices; `copier.yml` `_exclude` is what empties them at generation, since a <!-- doc-references: template-only -->
note answering a question about the template means nothing in a project built from it.

## Root files

| File                                                  | What                                                                |
| ----------------------------------------------------- | ------------------------------------------------------------------- |
| `CONTEXT.md`                                          | Project overview, full directory tree, layer map                    |
| `REFERENCES.md`                                       | Curated index of every internal guide and external resource         |
| `DESIGN.md`                                           | Design entry point — standards, constraints, design workflows       |
| `GAPS.md`                                             | Active gaps, blockers, sprint dependencies                          |
| `DEFERRED.md`                                         | Work explicitly deferred to a named future story                    |
| `VERSION`                                             | The single source of truth — a new project starts at `0.1.0`        |
| `CHANGELOG.md` · `RELEASES.md` · `VERSION-HISTORY.md` | The three version logs, all seeded empty                            |
| `install.sh`                                          | Toolchain bootstrap                                                 |
| `.mcp.json`                                           | The three repo-scoped MCP servers                                   |
| `.copier-answers.yml`                                 | Your generation answers — **commit this**, `copier update` needs it |

---

## Finding things

| You want                            | Go to                                        |
| ----------------------------------- | -------------------------------------------- |
| A command                           | `how-to/docs/CLI-TOOLING.md`                 |
| The rule about X                    | `REFERENCES.md`, then the guide it points to |
| How to do a task properly           | The matching `workflows/NN-…/STEPS.md`       |
| What a directory is for             | Its `CONTEXT.md`                             |
| What I am allowed to do here        | Its `CLAUDE.md`                              |
| Why a decision was made             | `project-management/src/15-DECISIONS/`       |
| What is currently broken or blocked | `GAPS.md`                                    |

Or ask Claude — the structure exists so it can answer accurately.

---

## Next

- The skill setup → `08-CLAUDE-CODE.md`
- Build something → `10-FIRST-FEATURE.md`
