# how-to/workflows — Step-by-Step Operational Guides

**Last Updated**: <%DATE%>

Nine workflows in four families — set up, run, diagnose, author. Like `code/workflows/`,
these are a **catalogue entered by task type**, not a sequence: the number is a stable
identifier and a shelf position, nothing more.

## Directory Tree

```text
how-to/workflows/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
│
│   ── Set up (01–02) ──
├── 01-first-time-setup/     ← clone, configure, and start the project for the first time
├── 02-worktree-setup/       ← create and start a git worktree for parallel development
│
│   ── Run (03–07) ──
├── 03-daily-development/    ← start a session and work on a user story
├── 04-database-operations/  ← backup, restore, reset, seed, users (NOT migrations)
├── 05-testing-and-coverage/ ← run the suites and read the coverage honestly
├── 06-quality-gates/        ← the eight pre-PR gates and the standalone audits
├── 07-dependency-updates/   ← add, upgrade, or remove a dependency; clear advisories
│
│   ── Diagnose (08) ──
├── 08-debugging/            ← a failing test, broken build, or runtime error
│
│   ── Author (09) ──
└── 09-write-operator-guide/ ← write the guides in how-to/docs/ and how-to/src/
```

Every folder carries `CONTEXT.md` (when to use), `CLAUDE.md` (operating rules),
`STEPS.md` (ordered execution) and `CHECKLIST.md` (verification).

## The four families

### Set up (01–02) — getting an environment

| Workflow               | Purpose                                                        |
| ---------------------- | -------------------------------------------------------------- |
| `01-first-time-setup/` | Clone, configure, and start the project for the first time     |
| `02-worktree-setup/`   | Create and start a git worktree for parallel story development |

### Run (03–07) — day-to-day operation

| Workflow                   | Purpose                                                                |
| -------------------------- | ---------------------------------------------------------------------- |
| `03-daily-development/`    | Start a development session and work on a user story                   |
| `04-database-operations/`  | Backup, restore, reset, seed, users — **state, never schema**          |
| `05-testing-and-coverage/` | Run the suites, read coverage against the floors, route failures       |
| `06-quality-gates/`        | The eight pre-PR gates plus the audits — a clean run predicts clean CI |
| `07-dependency-updates/`   | Add, upgrade, or remove a dependency; resolve published advisories     |

### Diagnose (08) — when something is broken

| Workflow        | Purpose                                                                |
| --------------- | ---------------------------------------------------------------------- |
| `08-debugging/` | A failing test, broken build, or runtime error — the environment first |

### Author (09) — documenting the above

| Workflow                   | Purpose                                                         |
| -------------------------- | --------------------------------------------------------------- |
| `09-write-operator-guide/` | Write or restructure a guide in `how-to/docs/` or `how-to/src/` |

## Boundaries worth knowing

- **`04` is not migrations.** Schema changes are `code/workflows/03-database-migration/`;
  `04` only ever changes what state the database holds.
- **`05` is not test authoring.** Writing tests is `code/workflows/02-tdd-cycle/`.
- **`06` checks form, not judgement.** Content review is `code/workflows/07-review/`, and
  it comes first.
- **`09` does not cover server provisioning.** That lives in `<%DEPLOY_REPO%>`; this repo
  specifies the contract in `how-to/src/SERVER-ARCHITECTURE/`.

Read the workflow's `CONTEXT.md` first. Only enter `STEPS.md` when explicitly triggered.

## Numbers are identifiers, not a sequence

Append a new workflow and group it by editing the family tables above; do not renumber an
existing one. A stale number in a skill is a silent routing failure.
