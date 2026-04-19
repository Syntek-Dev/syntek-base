#!/usr/bin/env bash
# Scaffold a new Next.js App Router route with a typed page stub.
# Usage: bash code/src/scripts/development/new-next-route.sh <route_path>
# Examples:
#   bash code/src/scripts/development/new-next-route.sh about
#   bash code/src/scripts/development/new-next-route.sh services/web-design
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

cd "$PROJECT_ROOT"

ROUTE_PATH="${1:-}"

if [[ -z "${ROUTE_PATH}" ]]; then
  echo "Usage: bash code/src/scripts/development/new-next-route.sh <route_path>" >&2
  exit 1
fi

if [[ ! "${ROUTE_PATH}" =~ ^[a-z0-9][a-z0-9/-]*$ ]]; then
  echo "Error: route_path must be lowercase letters, digits, hyphens, and slashes only." >&2
  exit 1
fi

ROUTE_DIR="code/src/frontend/src/app/${ROUTE_PATH}"

if [[ -d "${ROUTE_DIR}" ]]; then
  echo "Error: ${ROUTE_DIR} already exists." >&2
  exit 1
fi

# Derive a PascalCase component name from the last path segment
SEGMENT="${ROUTE_PATH##*/}"
COMPONENT_NAME=$(echo "${SEGMENT}" | sed -E 's/(^|-)([a-z])/\U\2/g')Page

mkdir -p "${ROUTE_DIR}"

cat > "${ROUTE_DIR}/page.tsx" <<EOF
export default function ${COMPONENT_NAME}() {
  return (
    <main>
      <h1>${COMPONENT_NAME}</h1>
    </main>
  );
}
EOF

cat > "${ROUTE_DIR}/CONTEXT.md" <<CTXEOF
# code/src/frontend/src/app/${ROUTE_PATH}

TODO: Describe the purpose and content of the \`/${ROUTE_PATH}\` route.

## Files

| File       | Purpose              |
| ---------- | -------------------- |
| \`page.tsx\` | Route page component |

## Cross-references

- \`code/src/frontend/src/app/CONTEXT.md\` — App Router conventions
- \`project-management/docs/SEO-CHECKLIST.md\` — SEO requirements per page
CTXEOF

echo "Created ${ROUTE_DIR}/page.tsx"
echo "Created ${ROUTE_DIR}/CONTEXT.md"
echo "Route is now live at: http://dev.projectname.com/${ROUTE_PATH}"
