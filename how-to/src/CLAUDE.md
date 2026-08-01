@./CONTEXT.md

# CLAUDE.md — how-to/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(contributing + code-quality guide, imported above) → this file.

## Purpose (one line)

The human-facing operational guides that don't fit the instructional-doc limits — the
full contributing and code-quality guide (`CONTEXT.md`), the base-template token
manifest (`TEMPLATE-TOKENS.md`), the two scale-planner snapshots
(`SCALE-ARCHITECTURE/`, `SERVER-ARCHITECTURE/`), and the `NIXOS-SETUP.md` pointer stub
(server provisioning lives in the deploy repo; the app→server contract sits in
`SERVER-ARCHITECTURE/`).

## How to work here

- **Routing:** contributing-standard edits → `global-workflow` skill. The two
  architecture snapshots → the `scale-planner` agent via `/scale-planning` (see
  their own `CLAUDE.md` files). Server provisioning → the `{{DEPLOY_REPO}}` repo.
  These are `**/src/*.md` operator guides, **exempt** from the 300-line instructional
  limit — write them for humans in full.
- **Model:** Opus for substantive guide edits and renames and command/link fixes;
  Fable where the snapshot dirs say so.
- **Concrete steps:** edit `CONTEXT.md` (contributing) → keep dev
  commands aligned with `code/src/scripts/**/*.sh` and the coverage floors (backend
  75% / auth 90% / frontend 70%) → keep branch/commit rules in step with
  `project-management/docs/GIT-GUIDE.md`.
- **Definition of done:** commands verified against the scripts and Compose files;
  British English; docs hard-gate satisfied.

## Guardrails

- **Never commit secrets or real credentials** — dev accounts live in the gitignored
  `code/src/docker/.env.dev`; reference `.env.*.example` templates only.
- **Proprietary licence:** do not introduce GPL/AGPL-incompatible dependencies into
  guidance without prior written approval (per the Licensing section).
- Contributing guidance must stay script-first; the illustrative raw `uv`/`pnpm`
  examples here are documenting the tools behind the scripts, not endorsing bypassing
  them for routine operations.
- The `**/src/*.md` operator guides here are the sanctioned exception to the
  300-line limit — do not treat them as instructional `.md` for splitting (each
  snapshot dir's `CONTEXT.md`/`CLAUDE.md` pair still keeps within it).

## Output & naming

- **Hand-written:** `CONTEXT.md` (contributing guide), `TEMPLATE-TOKENS.md` (the
  base-template manifest), the `NIXOS-SETUP.md` pointer stub, and the snapshot
  directories; nothing generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`.
- **Template discipline:** project-specific values are `{{…}}` from
  `TEMPLATE-TOKENS.md`; org identity (`{{ORG_NAME}}`/`{{ORG_SLUG}}`) and the standard stack stay
  literal. Verify no stray tokens leak: `grep -rn '{{' how-to/src`.
