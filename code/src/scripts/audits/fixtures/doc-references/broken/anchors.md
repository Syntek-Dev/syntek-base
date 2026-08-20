# Fixture — a line anchor over a path that is not there

Fixture for `doc-references.sh --self-test`. Never read as documentation.

Both paths below are absent from this repository on purpose, and the anchors on them are
the point: peeling an anchor must not make a dangling path resolve.

The plain form is `code/docs/NO-SUCH-GUIDE.md:7` and the column form is
`code/docs/NO-SUCH-GUIDE.md:12:34`. Each is one finding, and each finding must quote the
citation as it was written, anchor and all, or the author is shown a path they never typed.
