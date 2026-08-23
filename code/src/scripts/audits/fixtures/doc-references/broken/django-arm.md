# Fixture — a project-built path with no row in the register

Fixture for `doc-references.sh --self-test`. Never read as documentation.

`code/src/django/` is checked rather than skipped, so a path under it that neither exists here
nor holds a row in `how-to/src/PROJECT-PATHS.md` is a dangling path like any other. Two below,
and the tense is the whole point: the second is written in forward voice and must fail anyway,
because the check reads the path and not the sentence around it.

The present-tense form is `code/src/django/apps/no_such_app/views.py`.

The forward form: the first story to need one will write
`code/src/django/apps/no_such_app/urls.py`, and that promise is still unbacked.
