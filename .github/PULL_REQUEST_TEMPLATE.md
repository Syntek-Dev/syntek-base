# Pull Request

## What this changes

<!-- One or two sentences. What is different after this merges? -->

## Why

<!-- The problem being solved. Link the issue if there is one: Closes #123 -->

## Type

- [ ] Bug fix
- [ ] Documentation
- [ ] New guide / workflow
- [ ] Template mechanics (`copier.yml`, tokens, generation tasks)
- [ ] Stack or structural change (raised as an issue first — link it)

---

## Template checks

- [ ] I generated a project from this branch and it rendered with **zero** surviving tokens

  ```bash
  uvx copier copy --trust --defaults \
    --data PROJECT_NAME="Test Project" --data ORG_NAME="Test Org" \
    --data PROJECT_DESCRIPTION="A test project for checking that the template renders end to end." \
    --data DEVELOPER_NAME="You" --data DEVELOPER_EMAIL="you@example.com" \
    --data DATE="01/01/2027" . /tmp/syntek-check
  grep -rIo '<%[A-Z_]*%>' /tmp/syntek-check --exclude-dir=.git | wc -l   # 0
  ```

- [ ] Token integrity passes — no mangled, unregistered or unclosed tokens

  ```bash
  bash .github/scripts/check-template-tokens.sh
  ```

- [ ] Any new token is registered in **both** `copier.yml` and `how-to/src/TEMPLATE-TOKENS.md`
- [ ] No `{{ }}` used for tokens; any literal `<% %> <: :> <~ ~>` is wrapped in `<: raw :>`
- [ ] This does not break `copier update` for projects already generated from the template

## Documentation gate

- [ ] Directory trees in every affected `CONTEXT.md` are updated
- [ ] Any new directory has both a `CONTEXT.md` and a `CLAUDE.md`
- [ ] Instructional `.md` files are still under 300 lines (`**/src/*.md` exempt)
- [ ] Cross-references and `REFERENCES.md` entries resolve
- [ ] Prose is British English

## Quality

- [ ] `pnpm lint:md` passes
- [ ] `bash code/src/scripts/syntax/lint.sh` passes
- [ ] `bash code/src/scripts/syntax/format.sh` reports no changes needed
- [ ] No version bump included (handled on merge)
- [ ] No secrets, `.env` contents, or real credentials

---

## Anything reviewers should know

<!-- Trade-offs you weighed, things you were unsure about, what you deliberately left out. -->
