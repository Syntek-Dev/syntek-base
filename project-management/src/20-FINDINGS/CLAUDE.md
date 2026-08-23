@./CONTEXT.md

# CLAUDE.md — src/20-FINDINGS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(template-only scaffold, naming, record-tier position, what the record captures —
imported above) → this file.

## Purpose (one line)

The findings store — one `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per story, written at
completion to record where the delivered work diverged from the project's standards, what
the smallest fix is, and which of those findings should shape the next story.

## How to work here

- **Routing:** findings are written during
  `project-management/workflows/22-implementation-documentation/`, after the code and its
  docs land and before the PR is raised. Data-layer findings are assessed against
  `code/docs/DATABASE.md` and its owning guides; the `database` skill produces them for
  schema and query work, the `code-reviewer` / `qa-tester` skills for everything else.
- **Model:** Opus — recording an observed divergence and its smallest fix is an
  implementation-phase touch, not planning. A finding that reopens a hard-to-reverse
  decision escalates to the `planner` skill and graduates to `../15-DECISIONS/`.
- **Concrete steps:** copy `FINDING-US000-TEMPLATE.md` →
  `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → record each finding with a stable `F-0NN` ID,
  where it was found, why it matters, the smallest fix, and a **retrofit cost** (Cheap /
  Expensive) → set a disposition for every row → link the story
  (`../02-STORIES/US###.md`) and its plan (`../17-STORY-PLANS/STORY-PLAN-US###-*.md`) →
  carry the `Next story` rows into the next plan.
- **Definition of done:** file named to convention with a real `DD/MM/YYYY` completion date,
  every finding carrying a retrofit cost and a disposition, expensive-to-retrofit items
  called out separately, and a `Nothing found` record written explicitly if that is the
  outcome; British English throughout.

## Guardrails

- **Record, never fix.** A findings record states the smallest fix; it does not apply it.
  The fix lands in a later story, a `../21-BUGS/` report, or `../22-REFACTORING/`.
- **Never invent a rationale.** Where a migration, index, or model carries no explanation
  for why it is shaped as it is, record the absence and flag it — do not reconstruct intent
  that was never stated. Mark anything inferred rather than found as `TODO(verify)`.
- **Separate cheap from expensive.** Schema shape, a missing scope column, and absent
  database-level constraints are expensive to retrofit and must be surfaced distinctly from
  cosmetic or additive findings — that split is what makes the record actionable.
- **Documentation only — no code, diffs, secrets, `.env` content, or credentials.** Redact
  any PII or token appearing in a quoted snippet.
- **Never rename or back-date a filed record** — the date is the completion date and is
  load-bearing for the audit trail; supersede with a new record if needed.
- Every developer command is a project script under `code/src/scripts/**/*.sh` — never raw
  pytest / pnpm / docker / python.
- One story per file. This is not a memory or gaps store — active blockers go to `GAPS.md`,
  deferrals with a named target story to `DEFERRED.md`, patterns to `.claude/MEMORY.md`.
  Every new directory needs a `CONTEXT.md` + `CLAUDE.md`; instructional files stay ≤ 300
  code lines (the artefacts and template here are exempt).

## Output & naming

- **Hand-written:** every `FINDING-*.md` in this folder, from `FINDING-US000-TEMPLATE.md`.
- **Template:** `FINDING-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none — nothing here is machine-produced.
- Filename `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (story-anchored, primary) or
  `FINDING-<DESCRIPTOR>-DD-MM-YYYY.md` (cross-cutting fallback); descriptor in
  `SCREAMING-KEBAB-CASE`; stories `US###`; dates DD/MM/YYYY.
