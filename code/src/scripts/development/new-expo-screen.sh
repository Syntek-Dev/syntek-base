#!/usr/bin/env bash
#
# new-expo-screen.sh — Scaffold a new Expo Router screen with a typed component stub.
#
# Usage: bash code/src/scripts/development/new-expo-screen.sh <screen_path>
#
# Examples:
#   bash code/src/scripts/development/new-expo-screen.sh profile
#   bash code/src/scripts/development/new-expo-screen.sh settings/notifications
#   bash code/src/scripts/development/new-expo-screen.sh (tabs)/dashboard
#
# Screen paths support Expo Router conventions:
#   Segments wrapped in () are layout group names — e.g. (tabs)/profile
#   Segments wrapped in [] are dynamic params — e.g. posts/[id]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

cd "$PROJECT_ROOT"

SCREEN_PATH="${1:-}"

if [[ -z "${SCREEN_PATH}" ]]; then
  echo "Usage: bash code/src/scripts/development/new-expo-screen.sh <screen_path>" >&2
  exit 1
fi

if [[ ! "${SCREEN_PATH}" =~ ^[a-zA-Z0-9_()\[\]][a-zA-Z0-9_/()\[\]-]*$ ]]; then
  echo "Error: screen_path must use letters, digits, hyphens, underscores, slashes, () and [] only." >&2
  exit 1
fi

SCREEN_DIR="code/src/mobile/app/${SCREEN_PATH}"

if [[ -f "${SCREEN_DIR}.tsx" ]]; then
  echo "Error: ${SCREEN_DIR}.tsx already exists." >&2
  exit 1
fi

if [[ -d "${SCREEN_DIR}" && -f "${SCREEN_DIR}/index.tsx" ]]; then
  echo "Error: ${SCREEN_DIR}/index.tsx already exists." >&2
  exit 1
fi

# Derive a PascalCase component name from the last path segment
SEGMENT="${SCREEN_PATH##*/}"
# Strip Expo Router special chars: () [] for naming purposes
CLEAN_SEGMENT=$(echo "${SEGMENT}" | sed -E 's/[()[\]]//g')
COMPONENT_NAME=$(echo "${CLEAN_SEGMENT}" | sed -E 's/(^|[-_])([a-zA-Z])/\U\2/g')Screen

# Flat screen file (leaf route) or directory-based screen
mkdir -p "$(dirname "${SCREEN_DIR}")"

cat > "${SCREEN_DIR}.tsx" <<EOF
import { SafeAreaView } from 'react-native-safe-area-context';
import { Text } from 'react-native';

export default function ${COMPONENT_NAME}() {
  return (
    <SafeAreaView className="flex-1 items-center justify-center bg-white">
      <Text className="text-lg font-semibold">${COMPONENT_NAME}</Text>
    </SafeAreaView>
  );
}
EOF

echo "Created ${SCREEN_DIR}.tsx"
echo "Screen is now routable at: /${SCREEN_PATH}"
