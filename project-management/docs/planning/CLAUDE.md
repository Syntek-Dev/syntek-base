@./CONTEXT.md

# CLAUDE.md — project-management/docs/planning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `project-management/docs/CONTEXT.md` →
this folder's `CONTEXT.md` (which file owns what, imported above) → this file.

## Purpose (one line)

The three planning sub-documents — `CADENCE.md` (the loop and the point ceiling), `STORIES.md`
(stories and story plans), `SPRINTS.md` (sprints and sprint plans) — behind the thin
`../PLANNING-GUIDE.md` index.

## How to work here

- **Routing:** reference guides, not artefacts. Read the one matching the artefact being written;
  edit it when the convention changes. Enter via `../PLANNING-GUIDE.md`. Substantive edits use
  the `sprint` or `user-story` agent.
- **Model:** Fable — planning conventions are design decisions about how work is shaped; Opus for
  mechanical touches (a link fix, a version-header bump, a renamed path).
- **Concrete steps:** edit the owning sub-document → check the other two do not now contradict it
  → update `../PLANNING-GUIDE.md` if the split itself changed → keep each file ≤ 300 code lines.
- **Definition of done:** the convention is stated in exactly one of the three; the index table in
  `CONTEXT.md` and `../PLANNING-GUIDE.md` both match; cited workflow numbers resolve; British
  English.

## Guardrails

- **State the capacity figure once.** `<%SPRINT_CAPACITY_SP%>` and `<%SPRINT_GRACE_SP%>` live in
  `CADENCE.md` only. `SPRINTS.md` points at it. Two copies of a tunable number drift the moment
  one project tunes it.
- **Respect the ownership split.** A story convention added to `SPRINTS.md` is a convention nobody
  writing a story will find. If a fact genuinely serves both, it belongs in `CADENCE.md` and the
  other two link to it.
- **These guides describe the process; the workflows execute it.** Do not restate a workflow's
  `STEPS.md` here — cite it. The workflow is the source of truth for its own procedure.
- **Workflow numbers are load-bearing.** PM workflow numbers are a running order, and these guides
  cite them heavily; a stale number here misroutes a planning session silently.
- **≤ 300 code lines** per file — this folder exists to honour that; do not let one grow back.
- No secrets, `.env` content, or source.

## Output & naming

- **Hand-written:** `CADENCE.md`, `STORIES.md`, `SPRINTS.md`; nothing generated.
- Files `SCREAMING-SNAKE-CASE.md`; the folder is `kebab-case/`, matching the
  `GDPR-GUIDE.md` → `gdpr/` precedent; stories cited as `US###`, sprints as `SPRINT-##`;
  dates DD/MM/YYYY.
