@./CONTEXT.md

# CLAUDE.md — src/00-ASSETS/WALK-TESTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `project-management/src/00-ASSETS/CONTEXT.md`
→ this folder's `CONTEXT.md` (what a walk is, and what each artefact holds, imported above) →
this file.

## Purpose (one line)

Raw evidence from cold walk tests — the prompt, the walker's verbatim answer, the ground-truth
transcript, and the verified result — kept so a navigability claim can be re-checked rather than
believed.

## How to work here

- **Routing:** evidence store, not doctrine. The decision a walk feeds is recorded on the owning
  feature map; the outcome is never argued from a summary in this folder alone.
- **Model:** Opus to file a completed walk and to verify its claims. The walk itself is run by a
  separate isolated session, never by the session that will record the outcome.
- **Concrete steps:** run the walk with the context chain suppressed; capture the transcript;
  check every load-bearing claim the walker makes against the tree; write the result file naming
  which question broke and at which read; then open the map and record the outcome.
- **Definition of done:** all four artefacts present for the run, the isolation controls stated as
  recorded fact, every walker claim marked verified or corrected, and the token and read spend
  given as measured figures.

## Guardrails

- **A walk is only as good as its transcript.** Never file a result without the captured tool log —
  a self-reported walk is the self-grading defect this evidence exists to close.
- **Verify before recording.** The first walk produced a confident, false finding inside its
  budget. Treat every walker claim as a candidate until checked against the tree.
- **Never edit a walker's report or transcript.** They are the record. Corrections belong in the
  result file, attributed, with the tree evidence that overturned the claim. The captured files
  are held out of Prettier, `markdownlint-cli2` and `audits/doc-references.sh` for that reason —
  a formatter counts as an edit. The authored result file is not held out of any of them.
- **"Could not look" is a fail, never a clean pass** — `code/docs/GATE-REPORTING.md`.
- **Do not let a run's artefacts ship.** A new run is excluded in `copier.yml` <!-- doc-references: template-only -->
  in the same change that adds it — a generated project inherits the practice, never this
  repository's results.

## Output & naming

- **Hand-written:** the result file, and this pair.
- **Captured, never hand-edited:** the prompt, the walker's report, and the transcript.
- One run is four sibling files sharing a stem, flat in this folder — no per-run sub-directory, so
  no per-run documentation pair.
- Stem: `WALK-<NODE>-<KIND>-DD-MM-YYYY`, then the bare stem for the result and the suffixes
  `-PROMPT.md`, `-REPORT.md`, `-TRANSCRIPT.jsonl`.
