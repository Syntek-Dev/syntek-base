# Fixture — a Compose volume spec is not a path (US004 R2, PM-arm false-positive class)

Fixture for the doc-references self-test. Never read as documentation.

A Compose volume entry maps a host path to a container path with a colon, so the token names two
locations on two machines and neither is a citation of a file in this repository. Relative here
exactly as a QA record under the artefact tree writes it, so Check 1 resolves it against this
file's directory into a checkable tree: `../logs:/workspace/code/src/logs`
