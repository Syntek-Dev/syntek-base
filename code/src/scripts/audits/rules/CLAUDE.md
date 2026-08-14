@./CONTEXT.md

# CLAUDE.md — scripts/audits/rules/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the rule inventory, the ruff boundary, the licence verdicts — imported above) → this file.

## Purpose (one line)

The in-house Opengrep rule set `../static-analysis.sh` runs — Django-template XSS, cross-file
taint, and hardcoded secrets, covering what ruff's `S` ruleset structurally cannot.

## How to work here

- **Routing:** rule changes come through the `security` skill; the governing guides are
  `code/docs/security/OWASP-AND-CHECKLIST.md` and `code/docs/SECURITY.md`. Model: Opus.
- **Concrete steps:** derive the rule from a statement in this repository's own guides → add it
  to the file for that concern (a new concern earns a new file, not a bucket) → give it a
  `message` naming the fix, not just the fault → verify with
  `bash code/src/scripts/audits/static-analysis.sh` → add the row to `CONTEXT.md` if the file
  is new.
- **Definition of done:** the scan exits 0 on a clean tree; the rule fires on a written
  counter-example and stays silent on the correct form; no upstream rule text was consulted.

## Guardrails

- **Never vendor, copy, adapt or paraphrase an upstream rule.** `semgrep-rules` is
  non-sublicensable and internal-use only; `opengrep-rules` carries a Commons Clause over LGPL.
  Both obligations would propagate into every generated project. Read a published rule as a
  **checklist of concerns** if you must, then author independently from our own guides
  (`.claude/CLAUDE.md` Section 6).
- **Never `--config p/…`.** A registry ruleset fetches exactly the licences above.
- **Do not duplicate ruff.** If ruff's `S` ruleset already catches it per file, it does not
  belong here — two tools reporting one finding is two places to keep in step.
- **A rule that produces false positives is a bug in the rule**, not an argument for lowering
  the gate. Narrow what it looks at; never soften what it concludes
  (`code/docs/VISUAL-DESIGN.md` Section 6, and `seam-contract.sh`'s 33-of-34 first draft).
- Every rule file opens with a comment naming the guide it derives from.

## Output & naming

- **Hand-written:** every `*.yml` in this folder. Nothing here is generated.
- Files `kebab-case.yml`, one per concern; rule `id`s `kebab-case` and unique across the set.
