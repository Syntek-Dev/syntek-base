@./CONTEXT.md

# CLAUDE.md — workflows/09-write-operator-guide/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, the two homes, key concepts — imported above) → this file.

## Purpose (one line)

The procedure for authoring developer-guided documentation — the guides in `how-to/docs/`
and `how-to/src/` that tell a human how to operate this system.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Authoring
  → the `operator-docs` agent (Opus) loading `.claude/skills/runbook/`. Code standards go
  to `doc-writer`; end-user help to `support-articles`; skills to
  `how-to/docs/SKILL-AUTHORING.md`.
- **Grill first:** Step 1 is a grilling pass — reader, trigger, home, shape, scope — before
  a word is drafted (`.claude/CLAUDE.md` §10).
- **Model:** Opus throughout.
- **Concrete steps:** grill and place → draft against the runbook spine → resolve every
  command to a script → **execute it on a clean environment** → wire it into the indexes.
- **Definition of done:** the guide has been run start to finish and corrected from what
  actually happened; every command cites a script; it is listed in its `CONTEXT.md` tree
  and `how-to/REFERENCES.md`; length and Markdown gates pass.

## Guardrails

- **A guide you have not executed is a guess.** Step 4 is not optional, and prose review
  cannot substitute for it — it is the only thing that finds a missing prerequisite.
- **Two homes, two standards.** `how-to/docs/*` is capped at **300 code lines**;
  `how-to/src/*` is the sanctioned exemption. Write to the standard of the home you chose.
- **Script-first is absolute.** Never present a raw `docker`/`pnpm`/`uv`/`manage.py`
  command as the sanctioned route; a missing script is a finding, not a licence.
- **Server provisioning is out of scope.** It lives in `<%DEPLOY_REPO%>`; this repo
  specifies the contract (`how-to/src/SERVER-ARCHITECTURE/`) and `NIXOS-SETUP.md` is a
  pointer stub by design. Do not duplicate the deploy repo here.
- **Never put secrets, tokens, or real credentials in a guide** — reference
  `.env.*.example` templates only.
- **Failure modes must be real.** Write what went wrong when you ran it, not a plausible list.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Produced by following it:** guides under `how-to/docs/` or `how-to/src/`, plus the
  `CONTEXT.md` and `how-to/REFERENCES.md` entries that index them.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`; sub-folders under
  `how-to/src/` `SCREAMING-SNAKE-CASE/`, under `how-to/docs/` `kebab-case/`.
