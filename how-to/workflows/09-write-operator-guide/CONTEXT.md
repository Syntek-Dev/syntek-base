# Workflow: Write an Operator Guide

## Directory Tree

```text
how-to/workflows/09-write-operator-guide/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow to author or restructure **developer-guided documentation** — anything
in `how-to/docs/` or `how-to/src/` that tells a human how to operate this system: setting
up an environment, running Docker, using the scripts, standing up a server, recovering
from an incident.

This is the meta-workflow: the procedure for writing the procedures. A generated project
uses it to document its own operations, which the template cannot do on its behalf.

| Documentation kind                                     | Owner                                            |
| ------------------------------------------------------ | ------------------------------------------------ |
| Operating the system (setup, Docker, scripts, servers) | **here** — `operator-docs` agent                 |
| Standards for writing code                             | `doc-writer` → `code/docs/`                      |
| `CONTEXT.md` / `CLAUDE.md` pairs                       | `doc-writer`                                     |
| End-user help for the product                          | `support-articles`                               |
| Sizing and the server contract                         | `scale-planner` → the two architecture snapshots |
| A skill under `.claude/skills/`                        | `how-to/docs/SKILL-AUTHORING.md`                 |

## Prerequisites

- [ ] You can actually perform the procedure being documented — a runbook you have not run
      is a guess
- [ ] The scripts the guide will cite exist (or you know they do not; see the guardrails)
- [ ] You know which of the two homes it belongs in (see below)

## Key concepts

- **Two homes, two standards.** `how-to/docs/*.md` is instructional and capped at **300
  code lines** — split it and leave a thin index. `how-to/src/*.md` is a human-facing
  operator guide and is the sanctioned **exemption** from that cap: write it in full.
  Choosing the wrong home means writing to the wrong standard.
- **Execute to verify.** An operator guide is proven by running it start to finish on a
  clean environment. Prose review cannot find a missing prerequisite or a step that only
  works because your shell already had a variable set.
- **Script-first is absolute.** Every command resolves to `code/src/scripts/**/*.sh`. If
  there is no script, that is the finding — write the script, or record the gap. Do not
  document a raw `docker`/`pnpm`/`uv`/`manage.py` invocation as the sanctioned route.
- **A runbook has a fixed spine:** purpose → prerequisites → the steps with expected output
  → failure modes → rollback → verification. The `runbook` skill carries the full shape.
- **Say what fails, not only what works.** The happy path is the easy half; the value is in
  what to do when step 4 errors.

## Cross-references

### Hard gates — read before executing Step 1

- `.claude/skills/runbook/SKILL.md` — the operator-doc craft and the runbook spine
- `how-to/src/CONTEXT.md` and `how-to/docs/CONTEXT.md` — the two homes and their standards

### Soft references — consult during execution

- `how-to/docs/SKILL-AUTHORING.md` — the sibling standard, for skills rather than guides
- `.claude/skills/global-workflow/` — British English, Markdown style, commit conventions
- `code/src/scripts/CONTEXT.md` — the scripts a guide is allowed to cite
- `project-management/workflows/21-implementation-documentation/` — owns implementation
  records; this workflow does not
