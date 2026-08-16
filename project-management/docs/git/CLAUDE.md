@./CONTEXT.md

# CLAUDE.md — project-management/docs/git/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `project-management/docs/CONTEXT.md` →
this folder's `CONTEXT.md` (which file owns what, imported above) → this file.

## Purpose (one line)

The four git sub-documents — `BRANCHES-AND-WORKTREES.md`, `COMMITS.md`,
`PR-AND-REQUIRED-CHECKS.md`, `MIGRATION-GATES.md` — behind the thin `../GIT-GUIDE.md` index.

## How to work here

- **Routing:** reference guides, not artefacts. Enter via `../GIT-GUIDE.md` and read the one
  matching the operation in hand; edit it when the convention changes. Substantive edits load the
  `git` skill, and a change to the merge gates is checked against
  `project-management/workflows/22-pr-and-review/`.
- **Model:** Opus throughout — these are process conventions, and every touch here (a new scope
  value, a check name, a version-header bump) is mechanical rather than a design decision.
- **Concrete steps:** edit the owning sub-document → check the other three do not now contradict
  it → update `../GIT-GUIDE.md` if the split itself changed → keep each file ≤ 300 code lines.
- **Definition of done:** the convention is stated in exactly one of the four; the tables in
  `CONTEXT.md` and `../GIT-GUIDE.md` both match; British English; `audits/docs-length.sh` and
  `audits/docs-pairing.sh` clean.

## Guardrails

- **Never rename an H2 or H3 here.** These headings are cited by name across the repository
  (`git/PR-AND-REQUIRED-CHECKS.md → Required status checks and path filters` and its siblings) — a reworded
  heading breaks every citation silently, and nothing re-resolves it. Add a heading, or move a
  whole section between these files, but do not rewrite one in place.
- **Copy a CI check name, never retype it.** The required-set table in
  `PR-AND-REQUIRED-CHECKS.md` matches branch protection by exact string, em dashes included.
- **These guides describe the process; the workflows execute it.** Do not restate a workflow's
  `STEPS.md` here — cite it.
- **The increment rules belong to `VERSIONING-GUIDE.md`.** `COMMITS.md` owns only how a commit
  _signals_ a breaking change; what counts as breaking is decided there.
- **≤ 300 code lines** per file — this folder exists to honour that; do not let one grow back.
- No secrets, `.env` content, or source.

## Output & naming

- **Hand-written:** all four sub-documents; nothing generated.
- Files `SCREAMING-SNAKE-CASE.md`; the folder is `kebab-case/`, matching the
  `GDPR-GUIDE.md` → `gdpr/` and `PLANNING-GUIDE.md` → `planning/` precedent; stories cited as
  `US###`, branches as `us###/<short-desc>`; dates DD/MM/YYYY.
