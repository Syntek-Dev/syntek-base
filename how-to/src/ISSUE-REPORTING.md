# Issue Reporting — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Before opening an issue

1. Search existing issues to avoid duplicates.
2. Check `GAPS.md` at the project root — known missing workflow files are tracked there.
3. For template usage questions, read the relevant guide in `how-to/src/` first.

---

## Bug reports

Use this structure when reporting a bug:

```text
**Describe the bug**
A clear description of what went wrong.

**Steps to reproduce**
1. Go to '...'
2. Click on '...'
3. See error

**Expected behaviour**
What you expected to happen.

**Actual behaviour**
What actually happened.

**Environment**
- OS: [e.g. macOS 15, Ubuntu 24.04]
- Docker version: [e.g. 27.1.0]
- Branch: [e.g. main, us042/feature]
- Relevant env vars (redacted): [e.g. DJANGO_DEBUG=True]

**Logs / screenshots**
Paste relevant log output here. Redact any secrets.

**Possible fix**
Optional — if you have a hypothesis about the cause.
```

For bugs within a sprint, create a bug report file following the naming convention:

```text
project-management/src/BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md
```

Example: `BUG-AUTH-LOGIN-19-04-2026.md`

---

## Feature requests

Use this structure for feature requests:

```text
**Summary**
A one-sentence description of the feature.

**Problem it solves**
What is the current pain point or gap?

**Proposed solution**
How you imagine the feature working.

**Alternatives considered**
Other approaches you have thought of and why you ruled them out.

**Affected layers**
- [ ] Backend
- [ ] Frontend
- [ ] Mobile
- [ ] Infrastructure / Docker
- [ ] Documentation

**Acceptance criteria**
- List of conditions that must be true for this feature to be considered done.
```

Feature requests that are accepted become user stories. Use
`project-management/workflows/01-story-creation/` to formalise them.

---

## Template improvement requests

If you are using syntek-base as a template for your own project and find something missing,
unclear, or wrong in the scaffold itself, open an issue on the template repository at
[github.com/Syntek-Dev/syntek-base](https://github.com/Syntek-Dev/syntek-base).

Include:

- Which file or guide the issue is in
- What is incorrect or missing
- A suggested improvement if you have one

---

## Security vulnerabilities

Do **not** open a public issue for a security vulnerability. Email
[sam.bailey@syntekstudio.com](mailto:sam.bailey@syntekstudio.com) with the details. Responsible
disclosure is appreciated — allow reasonable time for a fix before public disclosure.
