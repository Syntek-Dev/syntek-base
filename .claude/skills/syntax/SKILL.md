---
name: syntax
description: >-
  Make <%PROJECT_NAME%> parse, lint clean, format, and type-check — clear ruff, ESLint,
  Prettier, basedpyright, tsc or markdownlint failures left by an edit, or explain a piece of
  obscure syntax. Load when the tree is mechanically broken or a syntax gate is red. Strictly
  behaviour-preserving: never a logic or structural change (`refactor`), never a runtime fault
  with a behavioural root cause (`bugfix`), and never the CI configuration behind the gates
  (`cicd`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow stack-django stack-htmx-templates
---

# Fix Syntax, Lint, Format and Types (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — a mechanical procedure with a clean toolchain as its output).

> **The golden rule: do not change logic.** Fix only what stops the code parsing, linting,
> formatting or type-checking. **The moment a fix would alter runtime behaviour, stop and return
> it** — a behaviour change smuggled in under a lint fix is invisible to the reviewer, because
> the diff looks mechanical.

- **Do:** `cosnt` → `const`, unclosed brackets, bad imports, missing annotations, formatting
  drift, unused imports, the `# type: ignore` a checker genuinely demands.
- **Do not:** rename for clarity, reorder logic, optimise, restructure, or improve anything the
  linter did not flag.

---

## The brief arrives settled

A fork has no conversation behind it, so two things must already be in the brief: **which gate
is red** (or the command that reproduces it), and **the scope** — the files or file type this
is allowed to touch. Without the second, a whole-tree `--fix` lands changes nobody asked for in
a diff someone else owns.

## Tooling — never a raw linter

Every syntax operation goes through the project scripts. `ruff`, `eslint`, `prettier`,
`basedpyright`, `tsc` and `markdownlint` are never invoked directly.

```bash
bash code/src/scripts/syntax/lint.sh                       # detect lint issues (all types)
bash code/src/scripts/syntax/lint.sh --fix                 # apply safe fixes
bash code/src/scripts/syntax/lint.sh --file-type python    # scope to one file type
bash code/src/scripts/syntax/format.sh --fix               # reformat (ruff format + Prettier)
bash code/src/scripts/syntax/check.sh                      # type-check (basedpyright + tsc)
```

- `lint.sh --unsafe-fix` (ruff only) — only where no safe fix exists **and** the change is
  provably behaviour-preserving. Read the diff before accepting it.
- `check.sh` is dry-run: no type checker auto-fixes, so type errors are resolved by hand.
- CSS has no linter — `format.sh` covers it. Token rules belong to the `frontend` skill.

## Steps

1. **Reproduce** the failure with `lint.sh` or `check.sh`, scoped with `--file-type`.
2. **Apply `--fix`** for the mechanical mass, then hand-fix what is left.
3. **Re-run until clean.** Fix a type error by correcting the annotation or the import —
   **never silence a real mismatch with a blanket ignore.**
4. **Read the surrounding lines** and confirm no fix altered behaviour.
5. **Report** what changed and why, and name anything that needs a real code change.

## Guardrails

- **Never weaken a config to pass** — no disabling a rule, no widening an ignore, unless
  <%DEVELOPER_NAME%> asks for it explicitly. A green gate bought that way is a false one.
- **Preserve the non-negotiables carried in the code you touch.** Do not strip a permission
  check, loosen an ownership guard, or hardcode a secret to satisfy a linter.
- British English in any comment or message edited. Stay in remit: no architecture review, no
  new tests, no documentation.

## Definition of done

`lint.sh`, `format.sh` and `check.sh` all report clean at the agreed scope; no configuration was
weakened; every edit is behaviour-preserving; anything needing a real change is named rather
than attempted.

## Handoff

Report the gates now green, the files touched, and what each fix was. Then name what is out of
scope and who owns it: a logic or structural change (`refactor`), a runtime fault with a
behavioural cause (`bugfix`), new functionality (`backend`, `frontend`), missing or failing
tests (`test-writer`), docstrings and documentation (`doc-writer`), a broader quality or
security concern (`code-reviewer`), and the CI configuration for these gates (`cicd`).

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `how-to/workflows/06-quality-gates/` — the gates this skill turns green, and how they run
- `how-to/workflows/08-debugging/` — when a lint or type failure is really a broken environment
- `code/workflows/07-review/` — clean linters are a precondition of review, not a substitute

## Cross-references

- `code/docs/CODING-PRINCIPLES.md` — the style, naming and error-handling conventions
- `code/docs/BACKEND-CODING-PRINCIPLES.md` · `code/docs/FRONTEND-CODING-PRINCIPLES.md`
- `code/src/scripts/CONTEXT.md` — the scripts this skill is allowed to run
