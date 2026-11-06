# Fixture — every anchor form on a file that exists (US004 QA-F03)

Fixture for the doc-references self-test. Never read as documentation.

Comma-joined without the second colon: `code/src/scripts/audits/doc-references.sh:12,40`

A trailing range after the comma: `code/src/scripts/audits/doc-references.sh:12,40-45`

The same with the colon kept: `code/src/scripts/audits/doc-references.sh:12,:40-45`

A heading fragment on a guide: `code/docs/FORWARD-VOICE.md#1-the-rule`

A line fragment on a script: `code/src/scripts/audits/doc-references.sh#L12`

A heading fragment on a shipped template: `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md#how-to-use`

The marker still silences an anchored dead path that is no template:

`code/docs/NO-SUCH-FIXTURE-ONLY-ANCHORED.md#section` <!-- doc-references: ignore -->

A GitHub line anchor: `code/src/scripts/audits/doc-references.sh:L12`

A trailing comma left by prose: `code/src/scripts/audits/doc-references.sh:12,`

A query string, with and without a fragment: `code/docs/FORWARD-VOICE.md?plain=1#L5` and `code/docs/FORWARD-VOICE.md?plain=1`
