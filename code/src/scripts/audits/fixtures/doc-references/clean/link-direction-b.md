# Fixture — Markdown links into an excluded tree, declared (US004 REV-01 / H-01, GUARD)

Fixture for the doc-references self-test. Never read as documentation.

[the contract](../../../../../../../copier.yml) <!-- doc-references: template-only -->

CHANGED 12/11/2026: a declared link into research/ is now a template artefact
(`broken/template-artefact.md`); a declared link to template mechanics still passes.

[a gate](../../../../../../../.github/scripts/shipped-readme.sh) <!-- doc-references: template-only -->

[a note](../../../../../../../research/NO-SUCH-FIXTURE-ONLY-LINKED-NOTE.md) <!-- doc-references: ignore -->

The shipped pair of an excluded tree is lifted back out, so it is no finding: [pair](../../../../../../../research/CONTEXT.md)

The regenerated lock is no finding either: [lock](../../../../../../../uv.lock)
