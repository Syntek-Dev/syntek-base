# Fixture — anchors that resolve, and near-misses that are not anchors

Fixture for `doc-references.sh --self-test`. Never read as documentation.

Each anchor below names a location inside a file this repository holds, so neither is a
finding: `code/src/scripts/audits/doc-references.sh:47` in the plain form and
`code/src/scripts/audits/doc-references.sh:12:34` in the column form. The second is the one
a single greedy regex gets wrong — it leaves a path ending `:12` and reports that.

Two near-misses carry no slash, so the path guard drops them before the peel is reached and
neither can ever become a finding: the container port `django:8000` and the OWASP category
`A05:2025`.
