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

**Generation and token integrity are machine-checked on every push, to every branch** —
`.github/workflows/audit-template.yml` generates a project both ways and runs the four
`.github/scripts/` checks; lefthook's `template-integrity` leg runs the cheap half before the
commit exists. Do not tick these by hand; read the run. To reproduce a failure locally:

```bash
bash .github/scripts/check-template-tokens.sh    # token shape — the pre-commit gate
bash .github/scripts/check-template-parsers.sh   # token position — every manifest parses
```

What is left is what no script can decide:

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
