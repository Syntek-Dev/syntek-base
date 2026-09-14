#!/usr/bin/env bash
# Exercise the shared AI Copier contract without downloading dependencies.
# CI reuses the Copier environment already populated by the generation step.
# A local --python path can select an existing environment containing Copier.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat <<'EOF'
Usage: bash .github/scripts/shipped-ai.sh [--python PATH] [--self-test]

Prove shared instruction and skill aliases survive Copier copy/update, optional
skills stay excluded, and project memory is seeded empty and preserved on update.

  --python PATH  Use an existing Python environment containing Copier (no uv needed).
  --self-test    Also prove the detector rejects broken alias configurations.

By default, uvx reuses a cached Copier environment with network access disabled.
EOF
  exit 0
fi

if [[ "${1:-}" == "--python" ]]; then
  [[ $# -ge 2 ]] || { echo "shipped-ai.sh: --python needs an executable path" >&2; exit 2; }
  copier_python="$2"
  shift 2
  exec "$copier_python" "$SCRIPT_DIR/shipped-ai.py" "$@"
fi

exec uvx --offline --from copier python "$SCRIPT_DIR/shipped-ai.py" "$@"
