# Fixture — real `NN` placeholders stay patterns, and a live `PLANNING/` path resolves (US004 F-021)

Fixture for the doc-references self-test. Never read as documentation.

A numbered folder written by its convention names no one folder:
`project-management/src/NN-FOO/CONTEXT.md` and `code/workflows/NN-name/STEPS.md`.

A story number left generic is a pattern, bare or in a path: `US0NN`, `F-0NN`,
`project-management/src/17-STORY-PLANS/NN-STORY-PLAN-US0NN-FOO.md`,
`project-management/src/16-SPRINT-PLANS/NN-SPRINT-PLAN-NN.md`.

A run of `N` written against lower case is a placeholder too: `dev-usNNN.localhost/`.

A live `PLANNING/` path resolves, and so does the seeded map:
`project-management/src/11-QA/PLANNING/CONTEXT.md` and `.copier/MAP-SCALE-PLANNING.md:4`.

Named bare, the seeded map is one every generated project receives, so it is no per-project
instance: `MAP-SCALE-PLANNING.md`.

A placeholder at the very start of a citation, and one at its very end, are runs all the same.
A link target is tested wherever its first folder is, so the leading run is written as one:
[a numbered folder's context](NN-name/CONTEXT.md), and the trailing run as a path:
`project-management/src/16-SPRINT-PLANS/SPRINT-NN`.

A capital means an ASCII capital, in every locale. A run against a non-ASCII letter is still a
run, so this stays a pattern whether the gate runs under `C` or a UTF-8 locale:
`code/docs/ÉNNÉ-NO-SUCH-FIXTURE-ONLY.md`.
