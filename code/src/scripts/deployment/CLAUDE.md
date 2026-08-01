@./CONTEXT.md

# CLAUDE.md — scripts/deployment/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(planned-script table, imported above) → this file → `reports/`.

## Purpose (one line)

Scaffold placeholder for deployment automation — **no scripts exist yet**; planned
`deploy.sh`, `rollback.sh`, and `health-check.sh` arrive as the CI/CD pipeline
matures.

## How to work here

- **Routing:** deployment automation → `cicd` agent (Opus); the live
  pipeline lives in `.github/workflows/`, environment images in `code/src/docker/`.
- **Model:** Opus to author the first deployment scripts (release orchestration and
  rollback are load-bearing); Opus once one exists and is merely run.
- **Concrete steps:** design against the CI workflows and Docker environments → add a
  `kebab-case.sh` script here matching the sibling conventions (flags, exit codes,
  `reports/` output) → update this folder's `CONTEXT.md` as scripts land.
- **Definition of done:** a new deployment script is idempotent where sensible, never
  bypasses the Docker/compose environment config, and is documented in `CONTEXT.md`.

## Guardrails

- **Do not invent deployment behaviour** the CONTEXT.md does not promise — the three
  named scripts are planned, not present; confirm scope before authoring.
- All deployment secrets and target credentials via environment only.
- `DEBUG=False` and an explicit `CORS_ALLOWED_ORIGINS` allowlist in every non-local
  target — never `CORS *` in production.

## Output & naming

- **Hand-written (future):** `deploy.sh`, `rollback.sh`, `health-check.sh`.
- **Generated / gitignored:** anything under `reports/`.
- Scripts `kebab-case.sh`.
