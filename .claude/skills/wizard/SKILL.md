---
name: wizard
description: >-
  Author a guided bash script for the parts of a procedure a person must do by hand —
  provisioning a third-party service, minting credentials or CI secrets, a one-off migration or
  cutover. Built on `code/src/scripts/_lib/wizard.sh`. Load when a procedure is blocked on a
  dashboard, a console, or a human decision the agent cannot make. Never for work the agent can
  do itself.
---

# Skill: wizard (<%PROJECT_NAME%>)

Some procedures cannot be automated — a human must click through a console, accept terms, mint a
key, or press the button on an irreversible cutover. Those procedures are tedious by hand and
worse to re-explain to an agent every time. A **wizard** removes both costs: a bash script that leads the
person stage by stage, launching each page at the moment it is needed, naming the exact control to
use, collecting whatever it produces, filing it in the right place, and gating on a confirmation
wherever the next action cannot be undone.

**The test for reaching here:** could the agent do this itself? If yes, write a normal script
under `code/src/scripts/` instead. A wizard exists only for the human-in-the-loop remainder.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## The harness is already written

`code/src/scripts/_lib/wizard.sh` provides the whole interaction layer — staged progress with a
cleared screen, hidden secret entry, cross-platform URL opening (Linux, macOS, WSL), idempotent
`.env` upserts at `0600`, confirmation gates, and a closing summary of everything written.

**Bound the procedure and write its stages — that is the whole job. Leave the harness alone.**
Every wizard sourcing it behaves identically, which is the point: a human who has run one has run
them all. Do not fork or hand-edit the library to suit one wizard; if it genuinely lacks a helper,
add it there, for everyone.

Helpers: `stage` · `say` · `step` · `warn` · `open_url` · `ask` · `ask_secret` · `confirm` ·
`pause` · `write_env` · `finish`. Read the header of `_lib/wizard.sh` for the contract.

## Steps

### 1. Scope the procedure

Read the repository before asking anything — the facts-up rule applies. For setup work that means the
`.env.*.example` templates, `code/src/docker/`, `config/settings/`, and the `secrets.*` and
`vars.*` references in `.github/workflows/` — CI naming a secret is proof the wizard has to
produce it. For a migration or cutover, establish where the system is now, where it must end up,
and which actions along the way cannot be undone.

Then put the ordered stage list to <%DEVELOPER_NAME%> — one round, through
`.claude/skills/grilling/SKILL.md`, which owns the shape. He may add, drop, or reorder.

_Done when the stages are ordered and named, and no captured value is missing its origin, its
destination, or a secret/public classification._

### 2. Trace the human's path through each stage

Spell out, per stage, the route someone actually walks: the page to land on, the action taken
there, the place the value surfaces, and the variable waiting for it — "Settings, then Access, then
Create token, then copy it before closing the dialog".

**Where you do not know the current UI, say so.** Check the provider's own documentation via
`context7` or ask. A wizard that confidently names a menu that no longer exists is worse than one
that says "find the API keys section" — the human trusts it and then cannot find the button.

_Done when someone with no prior exposure to the service could follow each stage unaided._

### 3. Author it

Source the library, set `TOTAL_STAGES`, and write one `stage` per step in dependency order:

```bash
#!/usr/bin/env bash
#
# setup-<thing>.sh — Walk a human through <procedure>.
#
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
TOTAL_STAGES=2
source "$PROJECT_ROOT/code/src/scripts/_lib/wizard.sh"

ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

stage "Create the API credentials"
open_url "https://example.com/dashboard/api-keys"
step "Sign in, then choose 'Create key'."
step "Name it '<%PROJECT_SLUG%>-dev' and copy the value shown once."
ask_secret API_KEY "Paste the key"
write_env "$ENV_FILE" EXAMPLE_API_KEY "$API_KEY"

stage "Point the project at your account"
ask ACCOUNT "Account identifier" "<%PROJECT_SLUG%>"
write_env "$ENV_FILE" EXAMPLE_ACCOUNT "$ACCOUNT"

finish "Restart the dev stack to pick up the new values."
```

Hold the bar the harness sets:

- **Open the URL before asking for its value** — never ask for something the human has not been
  sent to find.
- **`ask_secret` for anything secret.** Never `ask`, never echo it, never `say` it back.
- **`confirm` before every irreversible action**, and `warn` what it will do.
- **One focused task per `stage`** — each stage clears the screen, so anything the human still
  needs must not have scrolled away.
- **Secrets go to `.env` files only** (gitignored). `.env.*.example` takes placeholders. Never a
  tracked file, never a log.

### 4. Verify, then hand off

- `bash -n <script>` must pass; run `shellcheck` if it is installed.
- `chmod +x <script>`.
- **Never execute it start to finish yourself** — it launches a browser and then waits on a person
  who is not there. Read it through instead, checking that nothing scoped in step 1 was dropped,
  that each value ends up at the destination step 1 assigned it, and that CI secret names match
  their `secrets.*` references character for character.
- Tell <%DEVELOPER_NAME%> the path and how to run it.

## Where it lives, and whether it is kept

| Kind                                               | Home                                                                     |
| -------------------------------------------------- | ------------------------------------------------------------------------ |
| **Repeatable** — anyone setting up will need it    | `code/src/scripts/development/` — committed, and indexed in `CONTEXT.md` |
| **Deploy or cutover** — run against an environment | `code/src/scripts/deployment/` — committed                               |
| **One-off** — this migration, once                 | A scratch path outside the repo; delete it when done                     |

A committed wizard is a project script like any other: it needs its `CONTEXT.md` row, and the
guide that used to describe the manual procedure should point at it instead
(`how-to/workflows/09-write-operator-guide/`).

## Wizard versus runbook

A **runbook** is prose a human reads and follows (`.claude/skills/runbook/`). A **wizard** is a
script that leads them through it and captures the results. Prefer a runbook when the human needs
to understand and adapt; prefer a wizard when the procedure is fixed, repeated, and produces
values the project must store. They pair: a runbook may open by telling the reader to run the
wizard, and cover only what the wizard cannot.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `how-to/workflows/01-first-time-setup/` — the procedure a setup wizard most often automates
- `how-to/workflows/09-write-operator-guide/` — the runbook a wizard replaces or pairs with
- `how-to/workflows/06-quality-gates/` — the syntax gate a committed wizard must pass

## Cross-references

- `code/src/scripts/_lib/wizard.sh` — the harness; its header is the helper contract.
- `code/src/scripts/CONTEXT.md` — the script registry a committed wizard is indexed in.
- `.claude/skills/runbook/SKILL.md` — the prose counterpart.
- `.claude/skills/grilling/SKILL.md` — owns the interview shape used in step 1.
- `how-to/src/SERVER-ARCHITECTURE/` — the contract behind any provisioning wizard.
