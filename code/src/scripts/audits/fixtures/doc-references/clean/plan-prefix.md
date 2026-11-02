# Fixture — the prefix present, and every way of writing the pattern instead

Fixture for `doc-references.sh --self-test`. Never read as documentation.

Two plan filenames carrying the two-digit exec-order prefix. Both are path-form and neither
exists, which is deliberate: Check 4 is a naming rule, so the prefix alone is what makes it
silent, and a path under the artefact tree proves that without any file being involved —
`project-management/src/17-STORY-PLANS/07-STORY-PLAN-US042-FIXTURE-ONLY.md` and
`project-management/src/16-SPRINT-PLANS/09-SPRINT-PLAN-09.md`.

A correctly prefixed BARE basename cannot appear here, and the reason is a different rule
rather than an oversight: bare or not, it names a per-project instance, so Check 2 reports it
whatever its prefix. This half of the pair proves Check 4's silence; Check 2's population is
its own.

Now every spelling of the pattern itself, none of which is a citation. The angle-bracket house
form is `<exec-order>-STORY-PLAN-US###-<DESC>.md` and its sprint sibling
`<exec-order>-SPRINT-PLAN-##.md`. A file using brace placeholders writes the same thing as
`{XX}-STORY-PLAN-US{###}-{DESC}.md`. The older shorthand for a numbered prefix is
`NN-SPRINT-PLAN-NN.md`. A bare `STORY-PLAN-US###` is the artefact class used as a noun, with no
extension and no path, and stays as it is.

The zero-index artefacts are the convention rather than an instance of it, so
`00-STORY-PLAN-US000-TEMPLATE.md` and `00-SPRINT-PLAN-00-TEMPLATE.md` are silent on that
account and not on the prefix — both carry one anyway.
