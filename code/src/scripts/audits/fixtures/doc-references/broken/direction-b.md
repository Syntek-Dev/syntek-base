# Fixture — a citation that does not survive generation

Fixture for `doc-references.sh --self-test`. Never read as documentation. Every path below
**resolves in this repository**, which is the point: Check 1 passes on all of them and only
Check 3 can fire, so a finding here cannot have come from anywhere else.

The template contract is `copier.yml`, and it is excluded — unmarked, so this fires.

The template-integrity gate `.github/scripts/shipped-readme.sh` is excluded too, and this
line does not declare it either.

Neither of these fires, and both would if the set were built from `_exclude` naively:
`code/docs/RUST.md` is absent only where the Rust surface was declined, and `CHANGELOG.md`
is excluded **and** seeded from `.copier/`, so a generated project has one.
