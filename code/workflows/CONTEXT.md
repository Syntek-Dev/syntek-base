# code/workflows — Step-by-Step Coding Guides

Each workflow is a numbered folder with three files:

## Directory Tree

The numbers run in four families — build, verify, diagnose & improve, then the opt-in
build family (one per optional surface). Within the
build family the layers read bottom-up (data → `/api/` → `/mcp/`); within diagnose they
read in handoff order (find → fix → improve).

```text
code/workflows/
├── CONTEXT.md               ← this file
│
│   ── Build (01–06) ──
├── 01-new-feature/          ← add a new full-stack feature (backend + frontend)
├── 02-tdd-cycle/            ← TDD: Red → Green → Refactor (the method the others use)
├── 03-database-migration/   ← create and run a new Django database migration
├── 04-api-design/           ← design and implement a new Django Ninja API surface
├── 05-mcp-server/           ← add a FastMCP tool to the /mcp/ agent surface
├── 06-gdpr-enforcement/     ← implement GDPR requirements in code (encryption, consent, deletion)
│
│   ── Verify (07–08) ──
├── 07-review/               ← code quality review (OWASP, principles, coverage)
├── 08-security-hardening/   ← security review and hardening of existing code
│
│   ── Diagnose & improve (09–11) ──
├── 09-debugging-with-logs/  ← FIND the cause: local logs, Glitchtip, Loki, Grafana
├── 10-debug/                ← FIX it: isolate in code, regression test, minimal fix
├── 11-refactor/             ← IMPROVE it: restructure without changing behaviour
│
│   ── Build, opt-in (12–13) ──
├── 12-rust-extension/       ← RUST-ONLY — PyO3 extensions in the Cargo workspace
└── 13-desktop-app/          ← DESKTOP-ONLY — the native Slint application
```

Every folder carries the same four files: `CONTEXT.md` (when to use this workflow and
its prerequisites), `STEPS.md` (ordered steps to execute), `CHECKLIST.md` (verification
before marking complete), and `CLAUDE.md` (operating rules).

## The four families

### Build (01–06) — making something new

| Workflow                 | Purpose                                                              |
| ------------------------ | -------------------------------------------------------------------- |
| `01-new-feature/`        | Add a new full-stack feature (backend + frontend)                    |
| `02-tdd-cycle/`          | Test-driven development cycle — the method `01`/`03`–`06` build by   |
| `03-database-migration/` | The data layer — new models, altered fields, any schema change       |
| `04-api-design/`         | The JSON layer at `/api/` — Django Ninja routers, Schemas, endpoints |
| `05-mcp-server/`         | The agent layer at `/mcp/` — FastMCP tools over the service layer    |
| `06-gdpr-enforcement/`   | Cross-cutting — encryption, consent, deletion in code                |

### Verify (07–08) — checking what already exists

| Workflow                 | Purpose                                                               |
| ------------------------ | --------------------------------------------------------------------- |
| `07-review/`             | Code **content** review — patterns, coverage, principles, before a PR |
| `08-security-hardening/` | OWASP A01–A10 audit and hardening of built code                       |

### Diagnose & improve (09–11) — in handoff order

| Workflow                  | Purpose                                                                       |
| ------------------------- | ----------------------------------------------------------------------------- |
| `09-debugging-with-logs/` | **Find** the cause — local logs, Glitchtip, Loki, Grafana. Observational only |
| `10-debug/`               | **Fix** it — isolate the fault in code, write the regression test, patch      |
| `11-refactor/`            | **Improve** it — restructure with behaviour held identical                    |

### Build, opt-in (12–13) — present only on the matching surface

| Workflow             | Purpose                                                          |
| -------------------- | ---------------------------------------------------------------- |
| `12-rust-extension/` | The native tier — PyO3 extensions, crates, the supply-chain gate |
| `13-desktop-app/`    | The desktop tier — the Slint application and its licence gate    |

Listed unconditionally and flagged, like every other optional-surface row. They sit apart from the
build family because they are the only workflows that may be absent: a project generated without
`INCLUDE_RUST` has no `code/src/rust/` for `12` to govern, and `13` additionally needs
`INCLUDE_DESKTOP`.

`09` and `10` are two halves of one activity and are read together: `09` locates a fault
and hands over, `10` fixes it and proves the fix with a test. If you have a log line or a
Glitchtip exception, start at `09`. If you already know which code is wrong, start at `10`.

## Numbers are identifiers, not a sequence

Unlike `project-management/workflows/`, which runs 01 → 21 through a story's life, these
are a **catalogue entered by task type** — you never "run 01 through 13". The number is a
stable identifier and a shelf position, nothing more, and roughly 110 files across the
repository cite these paths.

So: **append a new workflow, never renumber an existing one.** Group it by editing the
family tables above, which cost nothing to reorder. A stale number in an agent definition
is a silent routing failure, which is far worse than an untidy shelf.

Read the workflow's `CONTEXT.md` first. Only enter `STEPS.md` when explicitly triggered.

## Pairing with the PM layer

These workflows are the **build and verify** half of a two-layer chain; `project-management/workflows/`
is the **specify and gate** half. The canonical pairing map — which code workflow pairs with which
PM workflow, which PM phase enters it, and who owns each fact — is in
[`REFERENCES.md` → Cross-layer workflow pairing](../../REFERENCES.md). Do not restate it here.

Two rules follow from it:

- **A code workflow is never entered directly from a PM design gate.** A story reaches here only
  through the PM build phases (`18-backend-code`, `19-api-code`, `20-frontend-code`), which are
  themselves gated on PM `01`–`15` being complete.
- **Records, findings, docs, and the graph refresh belong to PM `21-implementation-documentation`.**
  Code workflows hand off to it; they never restate its formats or destinations.
