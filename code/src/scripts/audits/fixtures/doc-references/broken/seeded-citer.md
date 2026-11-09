# Fixture — a citer copier seeds from .copier/ (US004 R4, seeded citers, 05/11/2026)

Fixture for the doc-references self-test. Never read as documentation.

The self-test runs this file twice: once with its own path added to the seeded set, and once
without. Seeded, its content never reaches a generated project, because the seed replaces it,
so neither of the next two citations is a finding. Not seeded, both are.

A per-project instance, which Check 2 reports in a shipped file:
`US042.md`

A copier-excluded path, which Check 3 reports in a shipped file:
`copier.yml`

The exemption is Checks 2 and 3 alone. A dead repo path is a defect wherever it is written, so
Check 1 reports this one either way:
`project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-SEEDED-DECISION.md`
