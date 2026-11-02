# Fixture — a plan filename with no exec-order prefix

Fixture for `doc-references.sh --self-test`. Never read as documentation. Nothing below is a
claim about a file: every plan named here is invented, and that is the point — Check 4 reads the
NAME, so no path on either side of generation has to exist for a finding to be true.

The bare form, which Check 2 would otherwise report as an ordinary instance citation:
`STORY-PLAN-US042-FIXTURE-ONLY.md`.

The path form, which nothing tested at all before 08/09/2026 — Check 2 is anchored and never
sees it, and Check 1 drops the whole artefact tree to its catch-all on purpose:
`project-management/src/17-STORY-PLANS/STORY-PLAN-US042-FIXTURE-ONLY.md`.

The relative form a sibling plan writes, which resolves through the same basename:
`../17-STORY-PLANS/STORY-PLAN-US042-FIXTURE-ONLY.md`.

Anchored, because the anchor names a line inside the file and the filename it names is what the
convention governs: `STORY-PLAN-US042-FIXTURE-ONLY.md:88`.

The sprint family takes the identical rule, and only the presence of the prefix is checked —
never the VALUE of either number, because a sprint plan's two numbers are allowed to disagree:
`project-management/src/16-SPRINT-PLANS/SPRINT-PLAN-09.md`.
