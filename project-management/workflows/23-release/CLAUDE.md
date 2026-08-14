@./CONTEXT.md

# CLAUDE.md — workflows/23-release/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, cross-references — imported above) → this file.

## Purpose (one line)

The release procedure — the final workflow: version bump, changelog update, and
deployment, run only once staging is green and every story in the release is complete.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`; do **not** freehand a release.
  The version bump goes through `version` per
  `project-management/docs/VERSIONING-GUIDE.md`; branch promotion and staging
  verification follow `project-management/docs/GIT-GUIDE.md` (use
  `git` for the branch/PR mechanics). Deploy via the release
  agent / deployment scripts — **never** invoke `docker`, `pnpm`, or `python` directly.
- **Model:** Opus to drive the release (changelog authoring, gate verification,
  deploy decisions); Opus for the mechanical version-string bump or a
  `Last Updated` date.
- **Concrete steps:** confirm the three prerequisites (staging green and accepted,
  all stories complete, changelog current) → bump the version across every file the
  VERSIONING-GUIDE lists → finalise the changelog → promote through the branch chain →
  deploy → tick every `CHECKLIST.md` item.
- **Definition of done:** version bumped consistently everywhere, changelog complete,
  the branch promotion chain and staging gates satisfied, release deployed, checklist
  fully ticked.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Hard gates before Step 1:** `VERSIONING-GUIDE.md` (bump rules and file checklist —
  followed exactly) and `GIT-GUIDE.md` (promotion chain and staging verification).
  Both are read-before-executing, not optional.
- **Pre-release security checklist** — consult `code/docs/security/OWASP-AND-CHECKLIST.md`
  (DB13, DB16 gates) during execution.
- **Single-track semver:** never hand-edit a version string outside
  `version`; the bump must land in every listed file or the release
  is inconsistent.
- **This is instructional documentation** — `CONTEXT.md`, `STEPS.md`, and
  `CHECKLIST.md` each stay **≤ 300 code lines**. British English throughout; dates
  DD/MM/YYYY.

## Output & naming

- **Hand-written:** `STEPS.md` and `CHECKLIST.md`; `CONTEXT.md` is the orientation
  file (holds the tree).
- **Nothing here is generated** — the release touches `VERSION`, `CHANGELOG.md`, and
  the other version-tracked files in the repo root, not this folder.
- The folder keeps its three-file shape; documentation files `SCREAMING-SNAKE-CASE.md`.
