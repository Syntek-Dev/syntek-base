---
name: runbook
description: >-
  The operator-documentation craft for <%PROJECT_NAME%> — how to write a guide or runbook a
  human can execute under pressure: the fixed spine (purpose, prerequisites, steps with
  expected output, failure modes, rollback, verification), the two homes and their two length
  standards, script-first command discipline, and the execute-to-verify rule. Load when
  authoring or restructuring anything in `how-to/docs/` or `how-to/src/`, when the
  `operator-docs` agent runs, or when any agent must write a procedure a person will follow.
---

# Runbook & Operator-Doc Craft (<%PROJECT_NAME%>)

Reference material for **documentation a human executes** — as distinct from documentation
Claude reads (`CONTEXT.md`/`CLAUDE.md`, `code/docs/*`) or a customer reads (support
articles). The `operator-docs` agent loads this; `how-to/workflows/09-write-operator-guide/`
is the procedure of record.

**Locale:** British English (en_GB) · <%TIMEZONE%> · <%CURRENCY%>.

---

## The reader

Someone with a problem, under time pressure, who did not choose to be reading. They are
scanning for their step. Everything below follows from that:

- **Headings are navigation**, not decoration — they must be skimmable.
- **No preamble.** Nobody recovering an outage reads an introduction.
- **Second person, imperative.** "Run X", not "one may wish to run X".
- **The happy path is the easy half.** The value is in what to do when step 4 errors.

## Two homes, two standards

Choosing the wrong home means writing to the wrong standard, so choose deliberately:

| Home           | Kind                        | Length                                       |
| -------------- | --------------------------- | -------------------------------------------- |
| `how-to/docs/` | Instructional reference     | **≤ 300 code lines** — split, leave an index |
| `how-to/src/`  | Human-facing operator guide | **Exempt** — write it in full                |

A reference is read in fragments (`CLI-TOOLING.md`); a runbook is executed top to bottom.
If it will be followed start to finish, it is a runbook — give it the spine below.

## The spine

Every runbook has these sections, in this order. Omit one only when you can say why.

1. **Purpose** — one line: what this achieves, and when to reach for it.
2. **Prerequisites** — state, access, and tools required _before_ step 1. This is the
   section execute-to-verify most often corrects.
3. **Steps** — numbered, each with the command, **what success looks like**, and a pointer
   to Failure modes when it does not.
4. **Failure modes** — what actually went wrong when you ran it, with the recovery.
5. **Rollback** — how to undo it. Mandatory for anything destructive.
6. **Verification** — how to prove it worked, independently of the steps' own output.

## Command discipline

- **Script-first, absolutely.** Every command resolves to `code/src/scripts/**/*.sh`. A
  raw `docker`, `pnpm`, `npm`, `npx`, `pip`, `uv`, or `python manage.py` invocation must
  never be presented as the sanctioned route — the audits flag it, and it rots.
- **No script? That is the finding.** Write the script and document it, record the gap in
  `GAPS.md`, or state plainly that the step is manual and why. Never document around it.
- **Copy-pasteable, always.** No placeholder the reader has to guess. Where a value
  genuinely varies, say where to find it.
- **Quote real output.** Paste what the command actually printed, not what you expect it to.
- **Flag destructive commands in the line above them**, and say what is lost.
- **Never include a secret, token, or real credential** — reference `.env.*.example` only.

## Execute to verify

**A guide you have not run is a guess.** Run it start to finish from a state matching your
stated prerequisites, then correct it from what happened:

| What you observe                                       | What it means                      |
| ------------------------------------------------------ | ---------------------------------- |
| A step worked only because your environment was primed | A prerequisite is missing          |
| Output differs from what you wrote                     | Correct the guide, not your memory |
| You had to stop and think                              | The step is under-specified        |
| You recovered by instinct                              | That belongs in Failure modes      |

Prose review cannot find any of these. This is the single highest-value step, and the one
most often skipped.

## Scope boundaries — do not cross these

- **Server provisioning lives in `<%DEPLOY_REPO%>`**, not here. This repo _specifies_ the
  app→server contract (`how-to/src/SERVER-ARCHITECTURE/`); the deploy repo _implements_ it.
  `how-to/src/NIXOS-SETUP.md` is a pointer stub on purpose — never grow it into a runbook.
- **The two architecture snapshots belong to `scale-planner`** via `/scale-planning`, not
  to hand-editing.
- **Implementation records belong to PM `19-implementation-documentation`.**
- **Skills are a different standard** — `how-to/docs/SKILL-AUTHORING.md`.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `how-to/workflows/09-write-operator-guide/` — authoring or restructuring a guide
- `how-to/workflows/06-quality-gates/` — the Markdown, length and format gates a guide must pass
- `code/workflows/07-review/` — when the guide documents code-level standards as well
- `project-management/workflows/19-implementation-documentation/` — owns implementation
  records; a guide is not one

## Cross-references

- `how-to/docs/SKILL-AUTHORING.md` — the sibling standard, for skills rather than guides
- `.claude/skills/global-workflow/` — British English, Markdown style, commit conventions
- `code/src/scripts/CONTEXT.md` — the scripts a guide is allowed to cite
