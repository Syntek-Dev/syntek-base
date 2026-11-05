# Fixture — one target, two spellings, one verdict (US004 phase 9, F1)

Fixture for the doc-references self-test. Never read as documentation.

A relative citation is normalised before Check 1 decides whether its target sits in a checkable
tree, so the relative and the repo-relative spelling of one target get the same verdict.

A target in a tree Check 1 does not check, spelt relative: `../../../../../../../research/NO-SUCH-FIXTURE-ONLY-NOTE.md`

The same target, spelt repo-relative: `research/NO-SUCH-FIXTURE-ONLY-NOTE.md`

A dead target in a checked tree, spelt relative: `../../../../../../../project-management/src/02-STORIES/NO-SUCH-FIXTURE-ONLY-STORY.md`

The same dead target, spelt repo-relative: `project-management/src/02-STORIES/NO-SUCH-FIXTURE-ONLY-STORY.md`
