---
type: guide
skills: [runbook]
model: opus
---

# Operator-Doc Craft

**Version:** 0.1.0 **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the standing conventions behind every guide a human executes

The conventions for **documentation a human executes**, as distinct from documentation Claude
reads (`CONTEXT.md`/`CLAUDE.md`, `code/docs/*`) or a customer reads (help articles). They are
standing rules rather than a procedure: the procedure is
`how-to/workflows/09-write-operator-guide/`, and the skill that runs it is
`.claude/skills/runbook/`.

## The reader

Someone with a problem, under time pressure, who did not choose to be reading. They are scanning
for their step. Everything below follows from that:

- **Headings are navigation**, not decoration — they must survive a skim.
- **No preamble.** Nobody recovering an outage reads an introduction.
- **Second person, imperative.** "Run X", not "one may wish to run X".
- **The happy path is the easy half.** The value is in what to do when step 4 errors.

## Two homes, two standards

Choosing the wrong home means writing to the wrong standard, so choose deliberately:

| Home           | Kind                        | Length                                       |
| -------------- | --------------------------- | -------------------------------------------- |
| `how-to/docs/` | Instructional reference     | **≤ 300 code lines** — split, leave an index |
| `how-to/src/`  | Human-facing operator guide | **Exempt** — write it in full                |

A reference is read in fragments (`how-to/docs/CLI-TOOLING.md`); a runbook is executed top to
bottom. If it will be followed start to finish, it is a runbook — give it the spine below.

The exemption is narrower than it looks: a `CONTEXT.md` or `CLAUDE.md` **inside** `how-to/src/`
is still bound by the 300-line cap, and `code/src/scripts/audits/docs-length.sh` checks it.

## The spine

Every runbook has these sections, in this order. Omit one only when you can say why.

1. **Purpose** — one line: what this achieves, and when to reach for it.
2. **Prerequisites** — state, access, and tools required _before_ step 1. This is the section
   execute-to-verify most often corrects.
3. **Steps** — numbered, each with the command, **what success looks like**, and a pointer to
   Failure modes when it does not.
4. **Failure modes** — what actually went wrong when you ran it, with the recovery.
5. **Rollback** — how to undo it. Mandatory for anything destructive.
6. **Verification** — how to prove it worked, independently of the steps' own output.

## Command discipline

- **Script-first, absolutely.** Every command resolves to `code/src/scripts/**/*.sh`. A raw
  `docker`, `pnpm`, `npm`, `npx`, `pip`, `uv`, or `python manage.py` invocation must never be
  presented as the sanctioned route — the audits flag it, and it rots.
- **No script? That is the finding.** Write the script and document it, record the gap in
  `GAPS.md`, or state plainly that the step is manual and why. Never document around it.
- **Copy-pasteable, always.** No placeholder the reader has to guess. Where a value genuinely
  varies, say where to find it.
- **Quote real output.** Paste what the command actually printed, not what you expect it to.
- **Flag destructive commands in the line above them**, and say what is lost.
- **Never include a secret, token, or real credential** — reference `.env.*.example` only.

## Execute to verify

**A guide you have not run is a guess.** Run it start to finish from a state matching your stated
prerequisites, then correct it from what happened:

| What you observe                                       | What it means                      |
| ------------------------------------------------------ | ---------------------------------- |
| A step worked only because your environment was primed | A prerequisite is missing          |
| Output differs from what you wrote                     | Correct the guide, not your memory |
| You had to stop and think                              | The step is under-specified        |
| You recovered by instinct                              | That belongs in Failure modes      |

Prose review cannot find any of these. This is the single highest-value step, and the one most
often skipped.

## Scope boundaries — do not cross these

- **The two operator homes, and only those**, plus the `how-to/workflows/` procedures themselves
  and the `CONTEXT.md`/`CLAUDE.md` pairs inside `how-to/`.
- **Server provisioning lives in `<%DEPLOY_REPO%>`**, not here. This repo _specifies_ the
  app→server contract (`how-to/src/SERVER-ARCHITECTURE/`); the deploy repo _implements_ it.
  `how-to/src/NIXOS-SETUP.md` is a pointer stub on purpose — never grow it into a runbook.
- **The two architecture snapshots** (`how-to/src/SCALE-ARCHITECTURE/` and
  `how-to/src/SERVER-ARCHITECTURE/`) are regenerated through `/scale-planning`, never hand-edited.
- **Code standards, docstrings, and every `CONTEXT.md`/`CLAUDE.md` outside `how-to/`** belong to
  the developer-docs remit, not this one.
- **End-user help for the product** is a different audience and a different register.
- **Implementation records** belong to `project-management/workflows/21-implementation-documentation/`.
- **Skills are a different standard** — `how-to/docs/SKILL-AUTHORING.md`.

## Indexing is part of writing

A guide nothing links to will not be found. Every new file lands in its folder's `CONTEXT.md`
tree and in `how-to/REFERENCES.md` in the same change, and `**Last Updated**` is refreshed on
every `CONTEXT.md` touched.

_Part of the `how-to/docs/` documentation family._
