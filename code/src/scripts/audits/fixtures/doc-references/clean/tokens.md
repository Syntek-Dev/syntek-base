# Fixture — the template-only marker inside its window

Fixture for `doc-references.sh --self-test`. Never read as documentation. Every path below
is absent from this repository on purpose; what is under test is the marker, not the path.

On the line itself: `code/docs/FIXTURE-ONLY-ON-LINE.md` <!-- doc-references: template-only -->

The line-above form keeps the marker at the END of the preceding prose line, never on a line
of its own: Prettier reads a leading HTML comment as its own block and inserts a blank line
under it, which would push the marker two lines up and outside its window. <!-- doc-references: template-only -->
`code/docs/FIXTURE-ONLY-LINE-ABOVE.md` is the citation it covers.

The sibling marker records the other judgement and has to keep working:
`code/docs/FIXTURE-ONLY-IGNORED.md` <!-- doc-references: ignore — quoted, not cited -->
