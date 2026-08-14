# code/src/scripts/audits/rules

The static-analysis rule set `../static-analysis.sh` runs. Every rule here is **written
in-house** against this repository's own guides; no upstream rule text is vendored.

## Directory Tree

```text
code/src/scripts/audits/rules/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules
├── django-autoescape-off.yml   ← the {% autoescape off %} block
├── django-safe-filter.yml      ← the |safe filter and mark_safe()
├── django-template-xss.yml     ← a template variable reaching a JS/Alpine expression
├── request-to-sink-taint.yml   ← request data reaching a dangerous sink, across files
└── secrets-in-source.yml       ← a credential written into source rather than the env
```

One file per concern; a file carries however many rule `id`s that concern needs.

## Why these rules exist and not others

`pyproject.toml` already enables ruff's `S` (flake8-bandit) ruleset, so per-file Python
security linting runs on every change. That leaves two gaps ruff cannot close, and they are
what this directory covers:

- **Django-template XSS** — ruff does not read `*.html`, so the stack's own traps (a template
  variable interpolated into an Alpine expression or an inline `<script>` body, where Django's
  auto-escaping no longer protects) are invisible to it.
- **Cross-file taint** — ruff is per-file, so request data flowing through a service module
  into a sink is invisible to it.

Anything ruff already catches is deliberately **not** duplicated here. Two tools reporting the
same finding is two places to keep in step.

## Why written in-house — the licence, not the effort

Neither published rule set may be redistributed by this template:

| Source           | Licence                                                      | Verdict                                      |
| ---------------- | ------------------------------------------------------------ | -------------------------------------------- |
| `semgrep-rules`  | Semgrep Rules License v1.0 — non-sublicensable, internal use | Cannot ship in a template that redistributes |
| `opengrep-rules` | LGPL-2.1 **plus a Commons Clause**, inherited pre-fork       | Same                                         |
| Opengrep engine  | LGPL-2.1, plain                                              | Fine — the engine is invoked, never shipped  |

So the **engine** is used and the **rules** are ours. That is `.claude/CLAUDE.md` Section 6 applied:
use, adapt and redistribute are three different permissions, and the licence column is checked
before deriving, not after.

## How they are run

`../static-analysis.sh` points `--config` at this directory, never at a registry ruleset
(`p/…`) — fetching one would pull in exactly the licences rejected above. The script exits 0
with a note when the `opengrep` engine is not installed, so it is safe to run unconditionally.

## Cross-references

- `../CONTEXT.md` — the audit register, including `static-analysis.sh`'s row
- `code/docs/security/OWASP-AND-CHECKLIST.md` — the guide most rules are derived from
- `code/REFERENCES.md` → External — Code Quality — the Opengrep entry and both rejected lineages
