# Fixture — the template-only marker outside its window

Fixture for `doc-references.sh --self-test`. Never read as documentation. Every path below
is absent from this repository on purpose; what is under test is the marker, not the path.

Two lines above is not the documented window, so the citation below still fires:

<!-- doc-references: template-only -->

The seed staging holds `code/docs/FIXTURE-ONLY-TWO-LINES-ABOVE.md`.

The marker is per line and never per file. This one is accepted:
`code/docs/FIXTURE-ONLY-ACCEPTED.md` <!-- doc-references: template-only -->

This one, further down the same file, is not: `code/docs/FIXTURE-ONLY-UNMARKED.md`.
