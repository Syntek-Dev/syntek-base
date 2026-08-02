#!/usr/bin/env bash
# Scaffold a new Django app in apps/ using this project's per-model-file structure.
# Usage: bash code/src/scripts/development/new-django-app.sh <app_name>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"
DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

cd "$PROJECT_ROOT"

APP_NAME="${1:-}"

if [[ -z "${APP_NAME}" ]]; then
  echo "Usage: bash code/src/scripts/development/new-django-app.sh <app_name>" >&2
  exit 1
fi

if [[ ! "${APP_NAME}" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Error: app_name must be lowercase letters, digits, and underscores only." >&2
  exit 1
fi

APP_DIR="code/src/django/apps/${APP_NAME}"

if [[ -d "${APP_DIR}" ]]; then
  echo "Error: ${APP_DIR} already exists." >&2
  exit 1
fi

echo "Scaffolding apps/${APP_NAME}..."

# Create the app structure using Django's startapp inside the container
"${DC[@]}" exec -w /workspace/code/src/django django python manage.py startapp "${APP_NAME}" "apps/${APP_NAME}"

# startapp runs as the container user — root on the per-story worktree stacks (the
# main dev stack maps the host UID, so its scaffolds are already host-owned). Root-owned
# files block the host-side rm/sed/cat below and later host edits / git, so chown the new
# app (inside the container, as root) to match apps/'s host owner. Idempotent and correct
# regardless of which stack scaffolded it.
"${DC[@]}" exec -w /workspace/code/src/django django chown -R --reference=apps "apps/${APP_NAME}"

# Remove files not used in this project (Django Ninja + pytest replaces them)
rm -f "${APP_DIR}/views.py" "${APP_DIR}/tests.py" "${APP_DIR}/admin.py"

# Replace models.py with per-model-file structure
rm -f "${APP_DIR}/models.py"
mkdir -p "${APP_DIR}/models"
touch "${APP_DIR}/models/__init__.py"

# Fix apps.py: startapp writes just "<app_name>"; we need "apps.<app_name>"
sed -i "s/name = '${APP_NAME}'/name = 'apps.${APP_NAME}'/" "${APP_DIR}/apps.py"

# Create blank CONTEXT.md stubs for all new directories
cat > "${APP_DIR}/CONTEXT.md" <<CTXEOF
# code/src/django/apps/${APP_NAME}

TODO: Describe the purpose and responsibilities of the \`${APP_NAME}\` app.

## Directory Tree

\`\`\`text
apps/${APP_NAME}/
├── __init__.py
├── apps.py
├── migrations/
│   └── __init__.py
└── models/
    └── __init__.py
\`\`\`

## Cross-references

- \`code/src/django/apps/CONTEXT.md\` — app registry and conventions
- \`code/docs/ARCHITECTURE-PATTERNS.md\` — Django app and service layer patterns
CTXEOF

cat > "${APP_DIR}/migrations/CONTEXT.md" <<CTXEOF
# code/src/django/apps/${APP_NAME} — migrations

Auto-generated Django migration files for the \`${APP_NAME}\` app.

## Rules

- Never edit migration files by hand — use \`code/src/scripts/database/migrate.sh make\`.
- Never delete or modify applied migrations — squash if needed, never rewrite history.
- Always run \`code/src/scripts/database/migrate.sh check\` in CI.

## Cross-references

- \`code/src/scripts/database/CONTEXT.md\` — migration runner scripts
- \`code/src/django/apps/${APP_NAME}/CONTEXT.md\` — app overview
CTXEOF

cat > "${APP_DIR}/models/CONTEXT.md" <<CTXEOF
# code/src/django/apps/${APP_NAME} — models

Model definitions for the \`${APP_NAME}\` app.

## Directory Tree

\`\`\`text
apps/${APP_NAME}/models/
└── __init__.py
\`\`\`

## Rules

- Export all models from \`__init__.py\` — one model per file.
- Invariants belong in the database: FKs with explicit delete behaviour, \`NOT NULL\`,
  \`UNIQUE\`, and \`CHECK\` on every bounded column (\`code/docs/DATABASE.md\`).
- Encrypt PII at the field level before storing it (\`code/docs/ENCRYPTION-GUIDE.md\`).

## Cross-references

- \`code/src/django/apps/${APP_NAME}/CONTEXT.md\` — app overview
- \`code/docs/DATABASE.md\` — pre-flight data-layer rules
- \`code/docs/DATA-STRUCTURES.md\` — model design conventions
- \`code/docs/SECURITY.md\` — PII handling requirements
CTXEOF

# Every directory with a CONTEXT.md must also have a CLAUDE.md: `@./CONTEXT.md` to
# auto-load the tree, a Read order line, then the four H2 sections. A bare
# `@./CONTEXT.md` stub is the pre-03/07/2026 convention and is not acceptable
# (.claude/CLAUDE.md § 8) — fill the TODOs as the app takes shape.
cat > "${APP_DIR}/CLAUDE.md" <<CLAUDEEOF
@./CONTEXT.md

# CLAUDE.md — apps/${APP_NAME}/

Read order: \`.claude/CLAUDE.md\` → \`.claude/MEMORY.md\` → this folder's \`CONTEXT.md\`
(imported above) → this file → the target sub-package's \`CONTEXT.md\`/\`CLAUDE.md\`.

## Purpose (one line)

TODO: what this app owns, in one line — the domain boundary, not the file list.

## How to work here

- **Routing:** \`backend\` agent (Opus) with the \`stack-django\` skill. Start substantive
  changes from the matching \`code/workflows/NN-…/\` procedure.
- **Model:** Opus for services, endpoints, and tests.
- **Concrete steps:** model in \`models/\` → business logic in \`services\` (views and
  endpoints stay thin) → migrations via \`code/src/scripts/database/migrate.sh make\`
  → tests in \`tests/\` via \`code/src/scripts/tests/*.sh\`.
- **Definition of done:** coverage floor met; every state-changing endpoint carries an
  explicit permission check; \`migrate.sh check\` clean; \`CONTEXT.md\` updated.

## Guardrails

- **Every state-changing endpoint carries an explicit permission check** (OWASP A01);
  user-supplied IDs verified against caller ownership — no IDOR.
- **Every service method doing ≥ 2 writes uses \`transaction.atomic()\`.**
- Data invariants live in the database, not only in application validation.
- Files **≤ 750 lines (800 grace)**; every new package gets a \`CONTEXT.md\` + \`CLAUDE.md\`.

## Output & naming

- **Hand-written:** everything here except \`migrations/\`.
- **Generated (never hand-edit):** migration files under \`migrations/\`.
- Modules \`snake_case.py\`; documentation \`SCREAMING-SNAKE-CASE.md\`.
CLAUDEEOF

cat > "${APP_DIR}/migrations/CLAUDE.md" <<CLAUDEEOF
@./CONTEXT.md

# CLAUDE.md — apps/${APP_NAME}/migrations/

Read order: \`.claude/CLAUDE.md\` → \`.claude/MEMORY.md\` → this folder's \`CONTEXT.md\`
(imported above) → this file.

## Purpose (one line)

The generated migration history for \`${APP_NAME}\` — the schema's audit trail.

## How to work here

- **Routing:** \`database\` agent (Opus); the \`03-database-migration\` workflow.
- **Model:** Opus.
- **Concrete steps:** change the model → \`code/src/scripts/database/migrate.sh make --app
  ${APP_NAME} --name <desc>\` → review the generated file → \`migrate.sh run\` →
  \`migrate.sh check\`.
- **Definition of done:** \`migrate.sh check\` is clean and the migration is lock-safe.

## Guardrails

- **Never hand-write or hand-edit a migration** — generate it, then read it.
- **Never rewrite applied history** — squash forward, never edit in place.
- **No long \`ACCESS EXCLUSIVE\` lock on a populated table** — add-nullable → backfill →
  constrain; build indexes concurrently (\`code/docs/DATABASE.md\`).

## Output & naming

- **Generated (never hand-edit):** every \`NNNN_*.py\` here.
- Django's own numbering; give each a descriptive \`--name\`.
CLAUDEEOF

cat > "${APP_DIR}/models/CLAUDE.md" <<CLAUDEEOF
@./CONTEXT.md

# CLAUDE.md — apps/${APP_NAME}/models/

Read order: \`.claude/CLAUDE.md\` → \`.claude/MEMORY.md\` → this folder's \`CONTEXT.md\`
(imported above) → this file.

## Purpose (one line)

The persistent domain model for \`${APP_NAME}\` — one model per module, re-exported from
\`__init__.py\`.

## How to work here

- **Routing:** \`database\` agent (Opus) for schema shape, \`backend\` for the Python.
  **Read \`code/docs/DATABASE.md\` before the first field.**
- **Model:** Opus.
- **Concrete steps:** add \`<model>.py\` → export it from \`__init__.py\` → generate the
  migration via \`migrate.sh make --app ${APP_NAME}\` → never query from a view directly;
  go through the service layer.
- **Definition of done:** every bounded column carries its database constraint; the
  migration is generated, reviewed, and applied.

## Guardrails

- **Invariants are enforced in the database** — FKs with explicit delete behaviour,
  \`NOT NULL\`, \`UNIQUE\`, \`CHECK\`. Application validation is not a substitute.
- **PII is encrypted at the field level** (\`code/docs/ENCRYPTION-GUIDE.md\`).
- A scope column, its row-security policy, its index, and the middleware that sets the
  session variable ship **together** (\`code/docs/RLS-GUIDE.md\`).
- Files **≤ 750 lines (800 grace)**.

## Output & naming

- **Hand-written:** every \`.py\` here.
- Modules \`snake_case.py\` named for the model they define; models \`PascalCase\`.
CLAUDEEOF

echo ""
echo "Done. apps/${APP_NAME}/ scaffolded."
echo "Next: add \"apps.${APP_NAME}\" to INSTALLED_APPS in code/src/django/config/settings/base.py"
