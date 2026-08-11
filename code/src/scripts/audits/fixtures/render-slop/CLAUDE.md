@./CONTEXT.md

# CLAUDE.md — audits/fixtures/render-slop/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what the pair is, why two files, where the numbers come from — imported above) → this file →
`../../CLAUDE.md` for the audit rules these serve.

## Purpose (one line)

The known-positive / known-negative screen pair `render-slop.sh --self-test` asserts against.

## How to work here

- **Routing:** these are test data for `../../render-slop.sh`, not wireframes. Design work goes to
  `project-management/src/08-WIREFRAMES/`; nothing here is ever a design artefact.
- **Model:** Opus — changing a fixture is changing what the gate means, so it is audit logic.
- **Concrete steps:** run `bash code/src/scripts/audits/render-slop.sh --self-test` → it must
  report `positive=1, negative=0` → if it does not, fix the detector and run again.
- **Definition of done:** the self-test exits 0 with the browser present, and the pair still
  differs in the grid and nothing else.

## Guardrails

- **Fix the detector, never the fixtures.** These are the ground truth; editing one to make a
  failing self-test pass destroys the only evidence the gate works and leaves the run green.
- **Keep the pair minimal and self-contained.** No link to `SHARED/wireframe.css` and no shared
  partial: a legitimate change to the wireframe system must not silently move the ground truth
  the gate is proved against.
- **Change one thing at a time.** The two screens differ in the grid alone. Adding a second
  difference makes a passing self-test unattributable.
- **Never add this directory to a scan scope**, here or in `css-slop.sh` / `template-slop.sh`.
  The positive is slop on purpose, so any audit that reads it reports a finding nobody will fix.
- **The positive must stay wrong at 1280 px specifically.** It reads clean at 375 px and 768 px
  by construction, which is the point — do not "improve" it into something that fires everywhere.

## Output & naming

- **Hand-written:** both `.html` fixtures.
- **Generated:** none. The self-test writes its report to `../../reports/`, like every audit.
- Files `<verdict>-<shape>.html` in lower kebab-case — the leading `positive` / `negative` is
  **read by the self-test** to decide which assertion applies, so it is a contract, not a label.
