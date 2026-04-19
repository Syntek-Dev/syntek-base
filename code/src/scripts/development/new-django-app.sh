#!/usr/bin/env bash
# Scaffold a new Django app in apps/ using this project's per-model-file structure.
# Usage: bash code/src/scripts/development/new-django-app.sh <app_name>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"

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

APP_DIR="code/src/backend/apps/${APP_NAME}"

if [[ -d "${APP_DIR}" ]]; then
  echo "Error: ${APP_DIR} already exists." >&2
  exit 1
fi

echo "Scaffolding apps/${APP_NAME}..."

# Create the app structure using Django's startapp inside the container
docker compose -f "$COMPOSE_FILE" \
  exec backend python manage.py startapp "${APP_NAME}" "apps/${APP_NAME}"

# Remove files not used in this project (GraphQL + pytest replaces them)
rm -f "${APP_DIR}/views.py" "${APP_DIR}/tests.py" "${APP_DIR}/admin.py"

# Replace models.py with per-model-file structure
rm -f "${APP_DIR}/models.py"
mkdir -p "${APP_DIR}/models"
touch "${APP_DIR}/models/__init__.py"

# Fix apps.py: startapp writes just "<app_name>"; we need "apps.<app_name>"
sed -i "s/name = '${APP_NAME}'/name = 'apps.${APP_NAME}'/" "${APP_DIR}/apps.py"

# Create blank CONTEXT.md stubs for all new directories
cat > "${APP_DIR}/CONTEXT.md" <<CTXEOF
# code/src/backend/apps/${APP_NAME}

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

- \`code/src/backend/apps/CONTEXT.md\` — app registry and conventions
- \`code/docs/ARCHITECTURE-PATTERNS.md\` — Django app and service layer patterns
CTXEOF

cat > "${APP_DIR}/migrations/CONTEXT.md" <<CTXEOF
# code/src/backend/apps/${APP_NAME} — migrations

Auto-generated Django migration files for the \`${APP_NAME}\` app.

## Rules

- Never edit migration files by hand — use \`code/src/scripts/database/migrate.sh make\`.
- Never delete or modify applied migrations — squash if needed, never rewrite history.
- Always run \`code/src/scripts/database/migrate.sh check\` in CI.

## Cross-references

- \`code/src/scripts/database/CONTEXT.md\` — migration runner scripts
- \`code/src/backend/apps/${APP_NAME}/CONTEXT.md\` — app overview
CTXEOF

cat > "${APP_DIR}/models/CONTEXT.md" <<CTXEOF
# code/src/backend/apps/${APP_NAME} — models

Model definitions for the \`${APP_NAME}\` app.

## Directory Tree

\`\`\`text
apps/${APP_NAME}/models/
└── __init__.py
\`\`\`

## Rules

- Export all models from \`__init__.py\`.
- PII fields must use \`EncryptedCharField\` or \`EncryptedEmailField\` from \`apps.core.encryption\`.
- Each model must have \`db_table_comment\` on its \`Meta\` class.

## Cross-references

- \`code/src/backend/apps/${APP_NAME}/CONTEXT.md\` — app overview
- \`code/docs/DATA-STRUCTURES.md\` — model design conventions
- \`code/docs/SECURITY.md\` — PII handling requirements
CTXEOF

echo ""
echo "Done. apps/${APP_NAME}/ scaffolded."
echo "Next: add \"apps.${APP_NAME}\" to INSTALLED_APPS in code/src/backend/config/settings/base.py"
