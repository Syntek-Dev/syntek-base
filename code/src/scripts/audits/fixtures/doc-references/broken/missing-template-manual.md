# Fixture — a missing shipped manual template under a class row (US004 P4, EC-01b, TARGET-01)

Fixture for the doc-references self-test. Never read as documentation.

The self-test registers a class row over this fixture-local directory, standing in for the real
row: the real template cannot be removed from a working tree to prove this. A zero-index
template is a literal presence obligation, never a member of the class, so its absence is a
dangling path even with the class row present:
`code/src/scripts/audits/fixtures/doc-references/missing/MANUAL/US000-MANUAL-TESTING.md`
