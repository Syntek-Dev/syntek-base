# Fixture — a volume spec whose host half exists (US004 phase 9, QA-US004-03, GUARD)

Fixture for the doc-references self-test. Never read as documentation.

The host half exists and the container half is a path on another machine, never tested here:
`./code/docs:/workspace/FIXTURE-ONLY-CONTAINER-SIDE`

The same without the leading dot: `code/src/logs:/workspace/code/src/logs`

A named volume has no host path at all: `pgdata:/var/lib/postgresql/data`
