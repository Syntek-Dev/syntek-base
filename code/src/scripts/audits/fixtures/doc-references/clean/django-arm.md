# Fixture — the register, read from the Path column

Fixture for `doc-references.sh --self-test`. Never read as documentation.

Three registered paths, every one of them absent from this repository and green because
`how-to/src/PROJECT-PATHS.md` names what creates each: `code/src/django/apps/marketing/`,
`code/src/django/config/api.py` and `code/src/django/components/`.

This half of the proof is coupled to that file on purpose. Retire a row and this fixture
reddens, which is the only way the coupling is ever noticed.

One path under the same tree that simply exists, checked like any other and passing on that
alone: `code/src/django/config/settings/base.py`.
