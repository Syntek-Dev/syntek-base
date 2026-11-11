# Fixture — the host half of a Compose volume spec is a path (US004 phase 9, QA-US004-03)

Fixture for the doc-references self-test. Never read as documentation.

A bind mount whose host half is spelt from the repository root names a directory here, and this
one is gone: `./code/docs/NO-SUCH-FIXTURE-ONLY-DIR:/workspace/logs`

The same without the leading dot: `code/docs/NO-SUCH-FIXTURE-ONLY-DIR-TWO:/workspace/docs`
