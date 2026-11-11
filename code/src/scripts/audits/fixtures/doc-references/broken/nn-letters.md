# Fixture — `NN` as letters inside a word is not a placeholder (US004 F-021, RED)

Fixture for the doc-references self-test. Never read as documentation.

A `PLANNING/` folder holds the letters `NN` inside a word, and the path is a citation all the
same. Nothing is at this one: `project-management/src/11-QA/PLANNING/NO-SUCH-FIXTURE-ONLY.md`

The seeded map's name holds them too, and this copy of it is absent:
`code/docs/MAP-SCALE-PLANNING.md`

A bare map name nothing seeds is still an instance citation: `MAP-NO-SUCH-FIXTURE-ONLY.md`

An `N` run touching a capital on one side only is letters in a word, so each of these is tested
and fires. A capital on the left alone: `code/docs/PLANN-NO-SUCH-FIXTURE-ONLY.md`. A capital on
the right alone: `code/docs/no-such-NNA-FIXTURE-ONLY.md`. A single `N` is no run at all:
`code/docs/N-NO-SUCH-FIXTURE-ONLY.md`.

The accepted trade-off: a run written against capitals is letters, so a story number spelt
`USNNN` is a citation, never a pattern. Write it `US0NN`. This one fires:
`code/docs/USNNN-NO-SUCH-FIXTURE-ONLY.md`
