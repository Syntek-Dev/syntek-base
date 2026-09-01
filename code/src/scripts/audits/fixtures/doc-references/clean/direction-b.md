# Fixture — Direction B declared, and the three classes that need no declaration

Fixture for `doc-references.sh --self-test`. Never read as documentation.

Declared on the line, which is the whole mechanism: `copier.yml` <!-- doc-references: template-only -->

The same path under an anchor, declared the same way — the marker is per line, not per form:
`copier.yml:41-42` <!-- doc-references: template-only -->

The `ignore` marker records the other judgement and must suppress this check too:
`.github/scripts/shipped-readme.sh` <!-- doc-references: ignore — quoted, not cited -->

Undeclared and correctly silent, one per class. Surface-gated: `code/docs/RUST.md` ships
wherever the surface was taken. Seeded: `CHANGELOG.md` is re-supplied from `.copier/`.
Regenerated: `uv.lock` is written by the `uv lock` task. Re-included inside an excluded
tree: `handoffs/CONTEXT.md` and `project-management/src/CONTEXT.md` both ship.
