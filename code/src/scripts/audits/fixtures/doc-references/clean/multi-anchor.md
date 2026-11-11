# Fixture — one file cited at two lines (US004 R2, PM-arm false-positive class)

Fixture for the doc-references self-test. Never read as documentation.

A record citing two locations in one file writes the anchors comma-joined, and the file it names
exists, so neither is a finding: `code/src/scripts/audits/doc-references.sh:345,:351` for a
script, and `project-management/src/02-STORIES/US000-TEMPLATE.md:94,:288` for a shipped template.
